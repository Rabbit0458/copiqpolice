// COP'IQ — Photolangage PA : historique des copies corrigées.
// Toucher une tentative rouvre sa page de résultat depuis le payload
// enregistré en base (aucune nouvelle correction n'est facturée).

import 'package:flutter/material.dart';

import '../psycotechniques/pa_psycho_brand.dart';
import '../psycotechniques/pa_tests_psy_hub_pages.dart'
    show PaPsyReveal, PaPsyScaffold;
import 'pa_photolangage_core.dart';
import 'pa_photolangage_result_page.dart';

class PaPhotolangageHistoryPage extends StatefulWidget {
  static const String routeName = PaPhotolangageRoutes.historique;
  const PaPhotolangageHistoryPage({super.key});

  @override
  State<PaPhotolangageHistoryPage> createState() =>
      _PaPhotolangageHistoryPageState();
}

class _PaPhotolangageHistoryPageState extends State<PaPhotolangageHistoryPage> {
  final _repo = PaPhotolangageRepository.instance;

  bool _loading = true;
  String? _error;
  List<PhotolangageAttempt> _attempts = const [];
  Map<String, PhotolangageCase> _casesById = const {};

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
      final results = await Future.wait([
        _repo.fetchAttempts(),
        _repo.fetchCases(),
      ]);
      final attempts = results[0] as List<PhotolangageAttempt>;
      final cases = results[1] as List<PhotolangageCase>;
      if (!mounted) return;
      setState(() {
        _attempts = attempts;
        _casesById = {for (final c in cases) c.id: c};
        _loading = false;
      });
    } catch (e) {
      debugPrint('photolangage history load failed: $e');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Impossible de charger l’historique.';
      });
    }
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} à '
        '${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return PaPsyScaffold(
      badge: 'Historique',
      title: 'Mes copies corrigées',
      subtitle:
          'Toutes tes tentatives, avec leur score pédagogique COP’IQ '
          '(indicateur d’entraînement non officiel).',
      headerIcon: Icons.history_rounded,
      headerColor: PaPsychoBrand.cHistorique,
      children: [
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
                Text(_error!, style: PaPsychoBrand.body(context)),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _load,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Réessayer'),
                ),
              ],
            ),
          )
        else if (_attempts.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: PaPsychoBrand.card(context),
            child: Text(
              'Aucune copie pour le moment. Lance ton premier '
              'entraînement !',
              textAlign: TextAlign.center,
              style: PaPsychoBrand.body(context),
            ),
          )
        else
          for (var i = 0; i < _attempts.length; i++)
            PaPsyReveal(
              index: 3 + (i.clamp(0, 8)),
              child: _AttemptTile(
                attempt: _attempts[i],
                caseData: _casesById[_attempts[i].caseId],
                dateLabel: _fmtDate(_attempts[i].submittedAt),
              ),
            ),
      ],
    );
  }
}

class _AttemptTile extends StatelessWidget {
  final PhotolangageAttempt attempt;
  final PhotolangageCase? caseData;
  final String dateLabel;
  const _AttemptTile({
    required this.attempt,
    required this.caseData,
    required this.dateLabel,
  });

  Color _scoreColor(int? s) {
    if (s == null) return PaPsychoBrand.warn;
    if (s >= 75) return PaPsychoBrand.good;
    if (s >= 40) return PaPsychoBrand.warn;
    return PaPsychoBrand.bad;
  }

  @override
  Widget build(BuildContext context) {
    final score = attempt.pedagogicalScore;
    final hasPayload = attempt.correctionPayload != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: hasPayload
              ? () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PaPhotolangageResultPage(
                      c: caseData,
                      payload: attempt.correctionPayload!,
                      rawText: attempt.rawText,
                    ),
                  ),
                )
              : null,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: PaPsychoBrand.card(context),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: PaPsychoBrand.tinted(
                    context,
                    color: _scoreColor(score),
                    radius: 16,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    score == null ? '…' : '$score',
                    style: PaPsychoBrand.h3(
                      context,
                    ).copyWith(color: _scoreColor(score)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        caseData?.title ?? attempt.caseId,
                        style: PaPsychoBrand.h3(context),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${attempt.wordCount} mots'
                        '${attempt.status == 'expired_incomplete' ? ' — temps écoulé, réponse incomplète' : ''}'
                        '${attempt.correctionStatus == 'partial' ? ' — analyse partielle' : ''}',
                        style: PaPsychoBrand.small(context),
                      ),
                      if (dateLabel.isNotEmpty)
                        Text(dateLabel, style: PaPsychoBrand.small(context)),
                    ],
                  ),
                ),
                if (hasPayload)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: PaPsychoBrand.textMuted(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
