// COP'IQ — Photolangage PA : traitement de la correction + page de résultat.
// Le score COP'IQ est toujours accompagné de la mention « indicateur
// d'entraînement non officiel ». Le texte original n'est jamais modifié :
// la version améliorée est affichée dans un bloc séparé.

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../psycotechniques/pa_psycho_brand.dart';
import 'pa_photolangage_core.dart';

// ======================================================================
//                      ÉCRAN D'ANALYSE (TRAITEMENT)
// ======================================================================

class PaPhotolangageProcessingPage extends StatefulWidget {
  final PhotolangageCase c;
  final String attemptId;
  final String rawText;
  const PaPhotolangageProcessingPage({
    super.key,
    required this.c,
    required this.attemptId,
    required this.rawText,
  });

  @override
  State<PaPhotolangageProcessingPage> createState() =>
      _PaPhotolangageProcessingPageState();
}

class _PaPhotolangageProcessingPageState
    extends State<PaPhotolangageProcessingPage> {
  static const _steps = [
    'Vérification du texte',
    'Analyse du français',
    'Analyse de la structure',
    'Comparaison avec l’image',
    'Préparation des conseils',
  ];

  int _step = 0;
  bool _failed = false;
  Timer? _stepTimer;

  @override
  void initState() {
    super.initState();
    _run();
  }

  void _animateSteps() {
    _stepTimer?.cancel();
    _stepTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted && _step < _steps.length - 1) {
        setState(() => _step++);
      }
    });
  }

  Future<void> _run() async {
    setState(() {
      _failed = false;
      _step = 0;
    });
    _animateSteps();
    try {
      final payload = await PaPhotolangageRepository.instance.correctAttempt(
        widget.attemptId,
      );
      _stepTimer?.cancel();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PaPhotolangageResultPage(
            c: widget.c,
            payload: payload,
            rawText: widget.rawText,
          ),
        ),
      );
    } catch (e) {
      debugPrint('photolangage correction failed: $e');
      _stepTimer?.cancel();
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaPsychoBrand.bg(context),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _failed
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off_rounded,
                          size: 48,
                          color: PaPsychoBrand.warn,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Correction momentanément indisponible',
                          textAlign: TextAlign.center,
                          style: PaPsychoBrand.h2(context),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ta copie est bien enregistrée : rien n’est '
                          'perdu. Tu peux relancer l’analyse maintenant ou '
                          'la retrouver plus tard dans ton historique.',
                          textAlign: TextAlign.center,
                          style: PaPsychoBrand.body(context),
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: _run,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Relancer l’analyse'),
                          style: FilledButton.styleFrom(
                            backgroundColor: PaPsychoBrand.accent,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).popUntil(
                            (r) =>
                                r.isFirst ||
                                r.settings.name ==
                                    PaPhotolangageRoutes.entrainements,
                          ),
                          child: const Text('Revenir plus tard'),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 24),
                        Text(
                          'Analyse de ta copie…',
                          style: PaPsychoBrand.h2(context),
                        ),
                        const SizedBox(height: 20),
                        for (var i = 0; i < _steps.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Icon(
                                  i < _step
                                      ? Icons.check_circle_rounded
                                      : i == _step
                                      ? Icons.radio_button_checked_rounded
                                      : Icons.radio_button_unchecked_rounded,
                                  size: 20,
                                  color: i <= _step
                                      ? PaPsychoBrand.good
                                      : PaPsychoBrand.textMuted(context),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _steps[i],
                                  style: PaPsychoBrand.body(context),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ======================================================================
//                          PAGE DE RÉSULTAT
// ======================================================================

class PaPhotolangageResultPage extends StatefulWidget {
  final PhotolangageCase? c;
  final Map<String, dynamic> payload;
  final String rawText;
  const PaPhotolangageResultPage({
    super.key,
    required this.c,
    required this.payload,
    required this.rawText,
  });

  @override
  State<PaPhotolangageResultPage> createState() =>
      _PaPhotolangageResultPageState();
}

class _PaPhotolangageResultPageState extends State<PaPhotolangageResultPage> {
  final List<TapGestureRecognizer> _recognizers = [];
  String _issueFilter = 'toutes';

  Map<String, dynamic> get p => widget.payload;

  int get score => (p['overallPedagogicalScore'] as num?)?.toInt() ?? 0;
  String get level => (p['pedagogicalLevel'] ?? '').toString();
  double get confidence => (p['confidence'] as num?)?.toDouble() ?? 0;

  List<Map<String, dynamic>> get issues => p['issues'] is List
      ? List<Map<String, dynamic>>.from(
          (p['issues'] as List).whereType<Map>().map(
            (e) => Map<String, dynamic>.from(e),
          ),
        )
      : const [];

  List<Map<String, dynamic>> get aiIssues => p['aiIssues'] is List
      ? List<Map<String, dynamic>>.from(
          (p['aiIssues'] as List).whereType<Map>().map(
            (e) => Map<String, dynamic>.from(e),
          ),
        )
      : const [];

  Map<String, dynamic> get metrics => p['metrics'] is Map
      ? Map<String, dynamic>.from(p['metrics'] as Map)
      : const {};

  Map<String, dynamic>? get semantic => p['semanticAnalysis'] is Map
      ? Map<String, dynamic>.from(p['semanticAnalysis'] as Map)
      : null;

  static const _categoryLabels = <String, String>{
    'spelling': 'Orthographe',
    'grammar': 'Grammaire',
    'conjugation': 'Conjugaison',
    'syntax': 'Syntaxe',
    'punctuation': 'Ponctuation',
    'typography': 'Typographie',
    'capitalization': 'Majuscules',
    'homophone': 'Homophones',
    'repetition': 'Répétitions',
    'style': 'Style',
    'vocabulary': 'Vocabulaire',
    'structure': 'Organisation',
    'incoherence': 'Cohérence',
    'unsupportedInference': 'Interprétation non justifiée',
    'uncertaintyExpression': 'Expressions d’incertitude',
  };

  Color _scoreColor() {
    if (score >= 75) return PaPsychoBrand.good;
    if (score >= 40) return PaPsychoBrand.warn;
    return PaPsychoBrand.bad;
  }

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  void _showIssueDetail(Map<String, dynamic> issue) {
    final suggestions = issue['suggestions'] is List
        ? (issue['suggestions'] as List).map((e) => e.toString()).toList()
        : const <String>[];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: PaPsychoBrand.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _categoryLabels[issue['category']] ??
                  issue['category'].toString(),
              style: PaPsychoBrand.h3(ctx).copyWith(color: PaPsychoBrand.bad),
            ),
            const SizedBox(height: 8),
            if ((issue['original'] ?? '').toString().isNotEmpty)
              Text(
                '« ${issue['original']} »',
                style: PaPsychoBrand.body(
                  ctx,
                ).copyWith(fontWeight: FontWeight.w800),
              ),
            const SizedBox(height: 8),
            Text(
              (issue['explanation'] ?? '').toString(),
              style: PaPsychoBrand.body(ctx),
            ),
            if (suggestions.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in suggestions)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: PaPsychoBrand.tinted(
                        ctx,
                        color: PaPsychoBrand.good,
                        radius: 10,
                        alpha: .12,
                      ),
                      child: Text('→ $s', style: PaPsychoBrand.body(ctx)),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  /// Texte annoté : surlignage des fautes localisées, touchable.
  Widget _annotatedText(BuildContext context) {
    final text = widget.rawText;
    final located =
        issues
            .where(
              (i) =>
                  i['start'] is num &&
                  i['end'] is num &&
                  (i['start'] as num) >= 0 &&
                  (i['end'] as num) <= text.length &&
                  (i['start'] as num) < (i['end'] as num),
            )
            .toList()
          ..sort((a, b) => ((a['start'] as num).compareTo(b['start'] as num)));

    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final issue in located) {
      final start = (issue['start'] as num).toInt();
      final end = (issue['end'] as num).toInt();
      if (start < cursor) continue; // chevauchement : on garde la première
      if (start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, start)));
      }
      final rec = TapGestureRecognizer()..onTap = () => _showIssueDetail(issue);
      _recognizers.add(rec);
      spans.add(
        TextSpan(
          text: text.substring(start, end),
          recognizer: rec,
          style: TextStyle(
            backgroundColor: PaPsychoBrand.bad.withValues(alpha: .18),
            decoration: TextDecoration.underline,
            decorationColor: PaPsychoBrand.bad,
            decorationStyle: TextDecorationStyle.wavy,
          ),
        ),
      );
      cursor = end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return Text.rich(
      TextSpan(
        style: PaPsychoBrand.body(
          context,
        ).copyWith(fontSize: 15.5, height: 1.6),
        children: spans,
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredIssues {
    if (_issueFilter == 'toutes') return issues;
    return issues.where((i) => (i['category'] ?? '') == _issueFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final counts = p['counts'] is Map
        ? Map<String, dynamic>.from(p['counts'] as Map)
        : const <String, dynamic>{};
    final strengths = p['strengths'] is List
        ? (p['strengths'] as List).map((e) => e.toString()).toList()
        : const <String>[];
    final priorities = p['priorities'] is List
        ? (p['priorities'] as List).map((e) => e.toString()).toList()
        : const <String>[];
    final categoriesPresent =
        issues.map((i) => (i['category'] ?? '').toString()).toSet().toList()
          ..sort();

    return Scaffold(
      backgroundColor: PaPsychoBrand.bg(context),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: PaPsychoBrand.text(context),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: PaPsychoBrand.tinted(
                        context,
                        color: PaPsychoBrand.accent,
                        radius: 999,
                        alpha: .14,
                      ),
                      child: Text(
                        widget.c?.title ?? 'Résultat',
                        style: PaPsychoBrand.small(
                          context,
                        ).copyWith(color: PaPsychoBrand.accent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // ── Score ──
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: PaPsychoBrand.card(context),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$score',
                            style: PaPsychoBrand.h1(
                              context,
                            ).copyWith(fontSize: 56, color: _scoreColor()),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              '/100',
                              style: PaPsychoBrand.h3(context),
                            ),
                          ),
                        ],
                      ),
                      Text(level, style: PaPsychoBrand.h3(context)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: PaPsychoBrand.tinted(
                          context,
                          color: PaPsychoBrand.warn,
                          radius: 8,
                          alpha: .12,
                        ),
                        child: Text(
                          'Score pédagogique COP’IQ — indicateur '
                          'd’entraînement non officiel',
                          textAlign: TextAlign.center,
                          style: PaPsychoBrand.small(
                            context,
                          ).copyWith(color: PaPsychoBrand.warn),
                        ),
                      ),
                      if (p['correctionMode'] == 'linguistic_only') ...[
                        const SizedBox(height: 8),
                        Text(
                          'Analyse sémantique indisponible pour cette '
                          'session : résultat partiel centré sur la langue.',
                          textAlign: TextAlign.center,
                          style: PaPsychoBrand.small(context),
                        ),
                      ] else ...[
                        const SizedBox(height: 6),
                        Text(
                          'Confiance de l’analyse : '
                          '${(confidence * 100).round()} %',
                          style: PaPsychoBrand.small(context),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ── Jury ──
                if ((p['juryAppreciation'] ?? '').toString().isNotEmpty)
                  _Section(
                    title: 'Simulation du jury',
                    icon: Icons.record_voice_over_rounded,
                    color: PaPsychoBrand.cPersonnalite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '« ${p['juryAppreciation']} »',
                          style: PaPsychoBrand.body(
                            context,
                          ).copyWith(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Simulation pédagogique — ne préjuge pas de '
                          'l’avis d’un jury réel.',
                          style: PaPsychoBrand.small(context),
                        ),
                      ],
                    ),
                  ),

                if (strengths.isNotEmpty)
                  _Section(
                    title: 'Points forts',
                    icon: Icons.thumb_up_alt_rounded,
                    color: PaPsychoBrand.good,
                    child: _Bullets(items: strengths),
                  ),
                if (priorities.isNotEmpty)
                  _Section(
                    title: 'Priorités de progression',
                    icon: Icons.trending_up_rounded,
                    color: PaPsychoBrand.warn,
                    child: _Bullets(items: priorities.take(3).toList()),
                  ),

                // ── Métriques par compétence ──
                _Section(
                  title: 'Score par compétence',
                  icon: Icons.bar_chart_rounded,
                  color: PaPsychoBrand.cRaisonnement,
                  child: Column(
                    children: [
                      for (final e in const [
                        ('language', 'Maîtrise de la langue'),
                        ('factualAccuracy', 'Fidélité à l’image'),
                        ('structure', 'Organisation'),
                        ('observationCoverage', 'Couverture de l’image'),
                        ('vocabulary', 'Vocabulaire'),
                        ('readability', 'Lisibilité'),
                      ])
                        if (metrics[e.$1] != null)
                          _MetricGauge(
                            label: e.$2,
                            value: (metrics[e.$1] as num).toInt().clamp(0, 100),
                          ),
                    ],
                  ),
                ),

                // ── Texte annoté ──
                _Section(
                  title: 'Ta copie annotée',
                  icon: Icons.edit_note_rounded,
                  color: PaPsychoBrand.bad,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        issues.isEmpty
                            ? 'Aucune faute localisée par le correcteur.'
                            : 'Touche un passage souligné pour voir '
                                  'l’explication et la correction proposée.',
                        style: PaPsychoBrand.small(context),
                      ),
                      const SizedBox(height: 10),
                      _annotatedText(context),
                    ],
                  ),
                ),

                // ── Liste des fautes filtrable ──
                if (issues.isNotEmpty)
                  _Section(
                    title: 'Fautes détectées (${issues.length})',
                    icon: Icons.rule_rounded,
                    color: PaPsychoBrand.cCalcul,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final cat in [
                                'toutes',
                                ...categoriesPresent,
                              ])
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: ChoiceChip(
                                    label: Text(
                                      cat == 'toutes'
                                          ? 'Toutes'
                                          : '${_categoryLabels[cat] ?? cat} '
                                                '(${counts[cat] ?? ''})',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    selected: _issueFilter == cat,
                                    onSelected: (_) =>
                                        setState(() => _issueFilter = cat),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (final i in _filteredIssues.take(40))
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            onTap: () => _showIssueDetail(i),
                            leading: const Icon(
                              Icons.error_outline_rounded,
                              color: PaPsychoBrand.bad,
                              size: 20,
                            ),
                            title: Text(
                              '« ${i['original']} » — '
                              '${_categoryLabels[i['category']] ?? i['category']}',
                              style: PaPsychoBrand.body(context),
                            ),
                            subtitle: Text(
                              (i['explanation'] ?? '').toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: PaPsychoBrand.small(context),
                            ),
                          ),
                      ],
                    ),
                  ),

                // ── Analyse sémantique ──
                if (semantic != null) ...[
                  if ((semantic!['unsupportedClaims'] as List? ?? [])
                      .isNotEmpty)
                    _Section(
                      title: 'Interprétations non justifiées',
                      icon: Icons.report_gmailerrorred_rounded,
                      color: PaPsychoBrand.bad,
                      child: _Bullets(
                        items: (semantic!['unsupportedClaims'] as List)
                            .map((e) => e.toString())
                            .toList(),
                      ),
                    ),
                  if ((semantic!['importantMissingElements'] as List? ?? [])
                      .isNotEmpty)
                    _Section(
                      title: 'Éléments importants non décrits',
                      icon: Icons.visibility_off_rounded,
                      color: PaPsychoBrand.warn,
                      child: _Bullets(
                        items: (semantic!['importantMissingElements'] as List)
                            .map((e) => e.toString())
                            .toList(),
                      ),
                    ),
                  if ((semantic!['organizationFeedback'] ?? '')
                      .toString()
                      .isNotEmpty)
                    _Section(
                      title: 'Organisation de la description',
                      icon: Icons.format_list_numbered_rounded,
                      color: PaPsychoBrand.cRaisonnement,
                      child: Text(
                        semantic!['organizationFeedback'].toString(),
                        style: PaPsychoBrand.body(context),
                      ),
                    ),
                ],

                // ── Version améliorée ──
                if ((p['improvedVersion'] ?? '').toString().isNotEmpty)
                  _Section(
                    title: 'Proposition améliorée',
                    icon: Icons.auto_fix_high_rounded,
                    color: PaPsychoBrand.good,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Une réécriture possible de TA copie — ce n’est '
                          'pas ton texte original.',
                          style: PaPsychoBrand.small(context),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p['improvedVersion'].toString(),
                          style: PaPsychoBrand.body(context),
                        ),
                      ],
                    ),
                  ),

                // ── Corrigé type ──
                if ((p['referenceDescription'] ?? '').toString().isNotEmpty)
                  _Section(
                    title: 'Corrigé type',
                    icon: Icons.menu_book_rounded,
                    color: PaPsychoBrand.accent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Une référence pédagogique parmi d’autres : deux '
                          'textes très différents peuvent être excellents.',
                          style: PaPsychoBrand.small(context),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p['referenceDescription'].toString(),
                          style: PaPsychoBrand.body(context),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).popUntil(
                      (r) =>
                          r.settings.name ==
                              PaPhotolangageRoutes.entrainements ||
                          r.settings.name == PaPhotolangageRoutes.home ||
                          r.isFirst,
                    ),
                    icon: const Icon(Icons.grid_view_rounded),
                    label: const Text('Retour aux entraînements'),
                    style: FilledButton.styleFrom(
                      backgroundColor: PaPsychoBrand.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamed(PaPhotolangageRoutes.etapes),
                    icon: const Icon(Icons.route_rounded),
                    label: const Text('Revoir la méthode'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ======================================================================
//                        WIDGETS DE RÉSULTAT
// ======================================================================

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;
  const _Section({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: PaPsychoBrand.card(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: PaPsychoBrand.tinted(
                    context,
                    color: color,
                    radius: 10,
                    alpha: .15,
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: PaPsychoBrand.h3(context))),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  final List<String> items;
  const _Bullets({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final s in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('• $s', style: PaPsychoBrand.body(context)),
          ),
      ],
    );
  }
}

class _MetricGauge extends StatelessWidget {
  final String label;
  final int value;
  const _MetricGauge({required this.label, required this.value});

  Color get _color => value >= 75
      ? PaPsychoBrand.good
      : value >= 40
      ? PaPsychoBrand.warn
      : PaPsychoBrand.bad;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: PaPsychoBrand.body(context)),
              Text(
                '$value/100',
                style: PaPsychoBrand.small(
                  context,
                ).copyWith(color: _color, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 7,
              backgroundColor: PaPsychoBrand.borderColor(context),
              valueColor: AlwaysStoppedAnimation(_color),
            ),
          ),
        ],
      ),
    );
  }
}
