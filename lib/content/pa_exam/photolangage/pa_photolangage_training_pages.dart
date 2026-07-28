// COP'IQ — Photolangage PA : liste des cas, introduction d'un cas,
// visionneuse d'image (zoom). Les cas viennent de la base de données.

import 'package:flutter/material.dart';

import '../psycotechniques/pa_psycho_brand.dart';
import '../psycotechniques/pa_tests_psy_hub_pages.dart'
    show PaPsyReveal, PaPsyScaffold;
import 'pa_photolangage_core.dart';
import 'pa_photolangage_editor_page.dart';

// ======================================================================
//                      LISTE DES ENTRAÎNEMENTS
// ======================================================================

class PaPhotolangageTrainingListPage extends StatefulWidget {
  static const String routeName = PaPhotolangageRoutes.entrainements;
  const PaPhotolangageTrainingListPage({super.key});

  @override
  State<PaPhotolangageTrainingListPage> createState() =>
      _PaPhotolangageTrainingListPageState();
}

enum _CaseFilter { tous, aCommencer, enCours, termines }

class _CaseStatus {
  final bool hasDraft;
  final int attemptsCount;
  final int? bestScore;
  const _CaseStatus({
    required this.hasDraft,
    required this.attemptsCount,
    required this.bestScore,
  });

  String get label => hasDraft
      ? 'Brouillon en cours'
      : attemptsCount > 0
      ? 'Terminé'
      : 'À commencer';
}

class _PaPhotolangageTrainingListPageState
    extends State<PaPhotolangageTrainingListPage> {
  final _repo = PaPhotolangageRepository.instance;

  bool _loading = true;
  String? _error;
  List<PhotolangageCase> _cases = const [];
  Map<String, _CaseStatus> _status = const {};
  _CaseFilter _filter = _CaseFilter.tous;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final cases = await _repo.fetchCases(force: true);
      final attempts = await _repo.fetchAttempts();
      final drafts = <String, PhotolangageDraft>{};
      for (final c in cases) {
        final d = await _repo.loadDraft(c.id);
        if (d != null && d.text.trim().isNotEmpty) drafts[c.id] = d;
      }
      final status = <String, _CaseStatus>{};
      for (final c in cases) {
        final caseAttempts = attempts.where((a) => a.caseId == c.id).toList();
        final scores = caseAttempts
            .where((a) => a.pedagogicalScore != null)
            .map((a) => a.pedagogicalScore!)
            .toList();
        status[c.id] = _CaseStatus(
          hasDraft: drafts.containsKey(c.id),
          attemptsCount: caseAttempts.length,
          bestScore: scores.isEmpty
              ? null
              : scores.reduce((a, b) => a > b ? a : b),
        );
      }
      if (!mounted) return;
      setState(() {
        _cases = cases;
        _status = status;
        _loading = false;
      });
    } catch (e) {
      debugPrint('photolangage cases load failed: $e');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Impossible de charger les cas. Vérifie ta connexion.';
      });
    }
  }

  List<PhotolangageCase> get _filtered {
    return _cases.where((c) {
      final s = _status[c.id];
      return switch (_filter) {
        _CaseFilter.tous => true,
        _CaseFilter.aCommencer =>
          s == null || (!s.hasDraft && s.attemptsCount == 0),
        _CaseFilter.enCours => s?.hasDraft == true,
        _CaseFilter.termines =>
          (s?.attemptsCount ?? 0) > 0 && s?.hasDraft != true,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return PaPsyScaffold(
      badge: 'Entraînements',
      title: 'Sujets & corrigés',
      subtitle:
          '20 minutes par cas, correction détaillée à la clé. Le score '
          'COP’IQ est un indicateur d’entraînement non officiel.',
      headerIcon: Icons.photo_camera_rounded,
      headerColor: PaPsychoBrand.cCalcul,
      children: [
        PaPsyReveal(
          index: 3,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final f in _CaseFilter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(switch (f) {
                        _CaseFilter.tous => 'Tous',
                        _CaseFilter.aCommencer => 'À commencer',
                        _CaseFilter.enCours => 'En cours',
                        _CaseFilter.termines => 'Terminés',
                      }),
                      selected: _filter == f,
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_error != null)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: PaPsychoBrand.card(context),
            child: Column(
              children: [
                const Icon(
                  Icons.cloud_off_rounded,
                  size: 40,
                  color: PaPsychoBrand.warn,
                ),
                const SizedBox(height: 12),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: PaPsychoBrand.body(context),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _load,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Réessayer'),
                ),
              ],
            ),
          )
        else if (_filtered.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: PaPsychoBrand.card(context),
            child: Text(
              'Aucun cas dans cette catégorie pour le moment.',
              textAlign: TextAlign.center,
              style: PaPsychoBrand.body(context),
            ),
          )
        else
          for (var i = 0; i < _filtered.length; i++)
            PaPsyReveal(
              index: 4 + (i.clamp(0, 8)),
              child: _CaseCard(
                c: _filtered[i],
                status: _status[_filtered[i].id],
                onOpen: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          PaPhotolangageCaseIntroPage(c: _filtered[i]),
                    ),
                  );
                  _load();
                },
              ),
            ),
      ],
    );
  }
}

class _CaseCard extends StatelessWidget {
  final PhotolangageCase c;
  final _CaseStatus? status;
  final VoidCallback onOpen;
  const _CaseCard({required this.c, required this.status, this.onOpen = _noop});
  static void _noop() {}

  Color _difficultyColor() => switch (c.difficulty) {
    'avancee' => PaPsychoBrand.bad,
    'intermediaire' => PaPsychoBrand.warn,
    _ => PaPsychoBrand.good,
  };

  @override
  Widget build(BuildContext context) {
    final s = status;
    final buttonLabel = s?.hasDraft == true
        ? 'Reprendre'
        : (s?.attemptsCount ?? 0) > 0
        ? 'Refaire'
        : 'Commencer';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onOpen,
          child: Container(
            decoration: PaPsychoBrand.card(context),
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  height: 108,
                  child: Image.network(
                    c.imageUrl,
                    fit: BoxFit.cover,
                    semanticLabel: c.imageAlt,
                    loadingBuilder: (ctx, child, p) => p == null
                        ? child
                        : Container(
                            color: PaPsychoBrand.borderColor(ctx),
                            child: const Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                    errorBuilder: (ctx, _, __) => Container(
                      color: PaPsychoBrand.borderColor(ctx),
                      child: const Icon(Icons.broken_image_rounded),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                c.title,
                                style: PaPsychoBrand.h3(context),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: PaPsychoBrand.tinted(
                                context,
                                color: _difficultyColor(),
                                radius: 999,
                                alpha: .12,
                              ),
                              child: Text(
                                c.difficultyLabel,
                                style: PaPsychoBrand.small(context).copyWith(
                                  color: _difficultyColor(),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${c.durationSeconds ~/ 60} min — ${s?.label ?? 'À commencer'}'
                          '${s?.bestScore != null ? ' — Meilleur : ${s!.bestScore}/100' : ''}'
                          '${(s?.attemptsCount ?? 0) > 0 ? ' — ${s!.attemptsCount} tentative(s)' : ''}',
                          style: PaPsychoBrand.small(context),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              s?.hasDraft == true
                                  ? Icons.play_arrow_rounded
                                  : Icons.arrow_forward_rounded,
                              size: 16,
                              color: PaPsychoBrand.accent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              buttonLabel,
                              style: PaPsychoBrand.small(context).copyWith(
                                color: PaPsychoBrand.accent,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
//                      INTRODUCTION D'UN CAS
// ======================================================================

class PaPhotolangageCaseIntroPage extends StatelessWidget {
  final PhotolangageCase c;
  const PaPhotolangageCaseIntroPage({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return PaPsyScaffold(
      badge: c.difficultyLabel,
      title: c.title,
      subtitle: c.shortDescription ?? 'Commentaire d’une photographie.',
      headerIcon: Icons.photo_camera_rounded,
      headerColor: PaPsychoBrand.accent,
      children: [
        PaPsyReveal(
          index: 3,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: PaPsychoBrand.card(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  icon: Icons.timer_rounded,
                  text:
                      'Durée : ${c.durationSeconds ~/ 60} minutes. Le '
                      'chronomètre démarre quand tu appuies sur « Commencer '
                      'la rédaction », pas pendant cette introduction.',
                ),
                _InfoRow(
                  icon: Icons.flag_rounded,
                  text:
                      'Objectif : décrire fidèlement et uniquement ce qui '
                      'est visible, en français correct, du général au '
                      'particulier.',
                ),
                _InfoRow(
                  icon: Icons.straighten_rounded,
                  text:
                      'Minimum demandé : ${c.minimumWords} mots et '
                      '${c.minimumCharacters} caractères (repère : environ '
                      '20 lignes manuscrites). Recommandé : '
                      '${c.recommendedCharacters} caractères.',
                ),
                _InfoRow(
                  icon: Icons.loop_rounded,
                  text:
                      'Tu pourras revoir l’image à tout moment pendant la '
                      'rédaction — sans mettre le chronomètre en pause.',
                ),
                _InfoRow(
                  icon: Icons.save_rounded,
                  text:
                      'Ton texte est sauvegardé automatiquement : tu peux '
                      'reprendre après une interruption.',
                ),
              ],
            ),
          ),
        ),
        if (c.pedagogicalTips.isNotEmpty)
          PaPsyReveal(
            index: 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: PaPsychoBrand.tinted(
                  context,
                  color: PaPsychoBrand.cSuiteLogique,
                  radius: 18,
                  alpha: .10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Conseils pour ce cas',
                      style: PaPsychoBrand.h3(context),
                    ),
                    const SizedBox(height: 8),
                    for (final tip in c.pedagogicalTips)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '• $tip',
                          style: PaPsychoBrand.body(context),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),
        PaPsyReveal(
          index: 5,
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => PaPhotolangageImagePage(c: c),
                  ),
                );
              },
              icon: const Icon(Icons.image_rounded),
              label: const Text('Découvrir l’image'),
              style: FilledButton.styleFrom(
                backgroundColor: PaPsychoBrand.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: PaPsychoBrand.accent),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: PaPsychoBrand.body(context))),
        ],
      ),
    );
  }
}

// ======================================================================
//                    OBSERVATION DE L'IMAGE (ZOOM)
// ======================================================================

class PaPhotolangageImagePage extends StatefulWidget {
  final PhotolangageCase c;

  /// En mode relecture (depuis l'éditeur), pas de bouton de démarrage :
  /// le chronomètre continue de tourner.
  final bool reviewMode;

  const PaPhotolangageImagePage({
    super.key,
    required this.c,
    this.reviewMode = false,
  });

  @override
  State<PaPhotolangageImagePage> createState() =>
      _PaPhotolangageImagePageState();
}

class _PaPhotolangageImagePageState extends State<PaPhotolangageImagePage> {
  final TransformationController _transform = TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (_transform.value != Matrix4.identity()) {
      _transform.value = Matrix4.identity();
    } else if (_doubleTapDetails != null) {
      final p = _doubleTapDetails!.localPosition;
      _transform.value = Matrix4.identity()
        ..translate(-p.dx * 1.5, -p.dy * 1.5)
        ..scale(2.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    widget.c.title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontFamily: 'InstrumentSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GestureDetector(
                onDoubleTapDown: (d) => _doubleTapDetails = d,
                onDoubleTap: _handleDoubleTap,
                child: InteractiveViewer(
                  transformationController: _transform,
                  minScale: 1,
                  maxScale: 5,
                  child: Center(
                    child: Image.network(
                      widget.c.imageUrl,
                      fit: BoxFit.contain,
                      semanticLabel: widget.c.imageAlt,
                      loadingBuilder: (ctx, child, p) => p == null
                          ? child
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                      errorBuilder: (ctx, _, __) => const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.broken_image_rounded,
                              color: Colors.white54,
                              size: 48,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Image indisponible.\nVérifie ta connexion.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: widget.reviewMode
                  ? Text(
                      'Le chronomètre continue pendant la relecture de '
                      'l’image. Pince pour zoomer, double-touche pour '
                      'agrandir.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .7),
                        fontFamily: 'InstrumentSans',
                        fontSize: 12.5,
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Observe librement : le chronomètre de '
                          '${widget.c.durationSeconds ~/ 60} minutes ne '
                          'démarrera qu’au moment où tu appuieras sur le '
                          'bouton ci-dessous.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .8),
                            fontFamily: 'InstrumentSans',
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PaPhotolangageEditorPage(c: widget.c),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_rounded),
                            label: const Text('Commencer la rédaction'),
                            style: FilledButton.styleFrom(
                              backgroundColor: PaPsychoBrand.accent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
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
