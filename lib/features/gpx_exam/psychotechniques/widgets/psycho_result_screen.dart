// COP'IQ — Écran de fin d'exercice psycho.
// Affiche : score, bonnes/mauvaises, total, précision, temps total, temps moyen, niveau.

import 'package:flutter/material.dart';

import 'psycho_brand.dart';

class PsychoResultScreen extends StatelessWidget {
  final String exerciseTitle;
  final String difficulty;
  final IconData icon;
  final Color color;
  final int correct;
  final int wrong;
  final int total;
  final int durationSeconds;
  final double avgResponseTime;
  final VoidCallback onRestart;
  final VoidCallback onChangeLevel;
  final VoidCallback onBack;
  final bool isSaving;

  const PsychoResultScreen({
    super.key,
    required this.exerciseTitle,
    required this.difficulty,
    required this.icon,
    required this.color,
    required this.correct,
    required this.wrong,
    required this.total,
    required this.durationSeconds,
    required this.avgResponseTime,
    required this.onRestart,
    required this.onChangeLevel,
    required this.onBack,
    this.isSaving = false,
  });

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return m == 0
        ? '${s}s'
        : '${m}min ${s.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0 : ((correct / total) * 100).round();
    final accuracy = total == 0 ? 0 : ((correct / total) * 100).round();

    return Scaffold(
      backgroundColor: PsychoBrand.bg(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: PsychoBrand.text(context),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: PsychoBrand.tinted(
                      context,
                      color: color,
                      radius: 999,
                      alpha: .14,
                    ),
                    child: Text(
                      'Bilan • $difficulty',
                      style: PsychoBrand.small(
                        context,
                      ).copyWith(color: color),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: PsychoBrand.card(context, radius: 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 140,
                            height: 140,
                            child: CircularProgressIndicator(
                              value: percent / 100,
                              strokeWidth: 10,
                              backgroundColor:
                                  psychoOpa(color, .15),
                              valueColor:
                                  AlwaysStoppedAnimation(color),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$percent%',
                                style: PsychoBrand.h1(
                                  context,
                                ).copyWith(fontSize: 32),
                              ),
                              Text(
                                'de réussite',
                                style: PsychoBrand.small(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(exerciseTitle, style: PsychoBrand.h2(context)),
                    const SizedBox(height: 4),
                    Text(
                      isSaving
                          ? 'Enregistrement de ta session…'
                          : 'Session enregistrée',
                      style: PsychoBrand.small(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: 'Bonnes',
                      value: '$correct',
                      icon: Icons.check_circle_rounded,
                      color: PsychoBrand.good,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatTile(
                      label: 'Mauvaises',
                      value: '$wrong',
                      icon: Icons.cancel_rounded,
                      color: PsychoBrand.bad,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: 'Total',
                      value: '$total',
                      icon: Icons.list_alt_rounded,
                      color: PsychoBrand.accent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatTile(
                      label: 'Précision',
                      value: '$accuracy%',
                      icon: Icons.bolt_rounded,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: 'Temps total',
                      value: _formatDuration(durationSeconds),
                      icon: Icons.timer_outlined,
                      color: PsychoBrand.warn,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatTile(
                      label: 'Temps moyen',
                      value: '${avgResponseTime.toStringAsFixed(1)}s',
                      icon: Icons.speed_rounded,
                      color: PsychoBrand.cConcentration,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: onRestart,
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Recommencer'),
                  style: FilledButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: onChangeLevel,
                  icon: const Icon(Icons.tune_rounded),
                  label: const Text('Changer de niveau'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: PsychoBrand.borderColor(context),
                      width: 1.4,
                    ),
                    foregroundColor: PsychoBrand.text(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Retour aux exercices'),
                  style: TextButton.styleFrom(
                    foregroundColor: PsychoBrand.textMuted(context),
                    textStyle: const TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
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
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: PsychoBrand.card(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: PsychoBrand.small(
                  context,
                ).copyWith(fontSize: 11.5, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: PsychoBrand.h2(context).copyWith(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
