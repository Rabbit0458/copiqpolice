// COP'IQ — Écran d'introduction COMPACT (sans scroll) pour chaque exercice
// psychotechnique. Tout est condensé sur une seule vue mobile :
// titre / objectif court / mini-règle / chrono / drapeau / "ne plus afficher".

import 'package:flutter/material.dart';

import 'psycho_brand.dart';

class PsychoIntroScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String objective;     // ce que l'utilisateur doit faire (court)
  final String howTo;         // mini-règle / consigne en 1 phrase
  final String? example;      // ignoré dans la version compacte (pour rester sans scroll)
  final String? tip;          // ignoré dans la version compacte
  final String timerText;     // texte court sur le chrono
  final IconData icon;
  final Color color;
  final bool initialHideForever;
  final ValueChanged<bool> onHideForeverChanged;
  final VoidCallback onStart;
  final VoidCallback onBack;

  const PsychoIntroScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.objective,
    required this.howTo,
    required this.timerText,
    required this.icon,
    required this.color,
    required this.initialHideForever,
    required this.onHideForeverChanged,
    required this.onStart,
    required this.onBack,
    this.example,
    this.tip,
  });

  @override
  State<PsychoIntroScreen> createState() => _PsychoIntroScreenState();
}

class _PsychoIntroScreenState extends State<PsychoIntroScreen> {
  late bool _hide;

  @override
  void initState() {
    super.initState();
    _hide = widget.initialHideForever;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PsychoBrand.bg(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ─────────────────────────────────────────────
              Row(
                children: [
                  IconButton(
                    onPressed: widget.onBack,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: PsychoBrand.text(context),
                    ),
                    tooltip: 'Retour',
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: PsychoBrand.tinted(
                      context,
                      color: widget.color,
                      radius: 999,
                      alpha: .14,
                    ),
                    child: Text(
                      'Avant de commencer',
                      style: PsychoBrand.small(
                        context,
                      ).copyWith(color: widget.color),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ─── Icône + titre + sous-titre ─────────────────────────
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: PsychoBrand.tinted(
                      context,
                      color: widget.color,
                      radius: 18,
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: PsychoBrand.h1(
                            context,
                          ).copyWith(fontSize: 24, height: 1.15),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle,
                          style: PsychoBrand.body(context).copyWith(
                            color: PsychoBrand.textMuted(context),
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ─── 3 blocs compacts : Objectif / Comment / Chrono ─────
              _CompactBlock(
                icon: Icons.flag_rounded,
                color: widget.color,
                title: 'Objectif',
                body: widget.objective,
              ),
              const SizedBox(height: 10),
              _CompactBlock(
                icon: Icons.lightbulb_outline_rounded,
                color: widget.color,
                title: 'Consigne',
                body: widget.howTo,
              ),
              const SizedBox(height: 10),
              _CompactBlock(
                icon: Icons.timer_outlined,
                color: PsychoBrand.warn,
                title: 'Chrono',
                body: widget.timerText,
              ),

              const Spacer(),

              // ─── Drapeau de signalement (mini-info) ─────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: PsychoBrand.tinted(
                  context,
                  color: PsychoBrand.bad,
                  alpha: .08,
                  radius: 12,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.flag_outlined,
                      color: PsychoBrand.bad,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Une question fausse ? Tape le drapeau en haut à droite.',
                        style: PsychoBrand.small(context).copyWith(
                          color: PsychoBrand.text(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ─── Toggle "ne plus afficher" ──────────────────────────
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() => _hide = !_hide);
                  widget.onHideForeverChanged(_hide);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _hide
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        size: 22,
                        color: _hide
                            ? widget.color
                            : PsychoBrand.textMuted(context),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Ne plus afficher cette introduction',
                          style: PsychoBrand.body(
                            context,
                          ).copyWith(fontSize: 13.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ─── Bouton commencer ───────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: widget.onStart,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Commencer'),
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      letterSpacing: 0.2,
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

class _CompactBlock extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String body;

  const _CompactBlock({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: PsychoBrand.card(context, radius: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: PsychoBrand.tinted(
              context,
              color: color,
              radius: 9,
              alpha: .15,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: PsychoBrand.h3(
                    context,
                  ).copyWith(fontSize: 14, height: 1.1),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: PsychoBrand.body(context).copyWith(
                    fontSize: 13,
                    height: 1.35,
                    color: PsychoBrand.textMuted(context),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
