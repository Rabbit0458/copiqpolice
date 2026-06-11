// COP'IQ — Écran de choix du niveau de difficulté.
// Premium, animé, responsive, dark/light.

import 'package:flutter/material.dart';

import 'psycho_brand.dart';

class PsychoDifficultyOption {
  final String label; // 'Facile', 'Moyenne', 'Difficile'
  final String description;
  final IconData icon;
  final Color color;
  final int? availableQuestions;

  const PsychoDifficultyOption({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    this.availableQuestions,
  });
}

class PsychoDifficultyScreen extends StatelessWidget {
  final String exerciseTitle;
  final String exerciseSubtitle;
  final IconData exerciseIcon;
  final Color exerciseColor;
  final List<PsychoDifficultyOption> options;
  final ValueChanged<String> onChoose;
  final VoidCallback? onBack;

  const PsychoDifficultyScreen({
    super.key,
    required this.exerciseTitle,
    required this.exerciseSubtitle,
    required this.exerciseIcon,
    required this.exerciseColor,
    required this.options,
    required this.onChoose,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PsychoBrand.bg(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (onBack != null)
                    IconButton(
                      onPressed: onBack,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: PsychoBrand.text(context),
                      ),
                      tooltip: 'Retour',
                    )
                  else
                    const SizedBox(width: 8),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: PsychoBrand.tinted(
                      context,
                      color: exerciseColor,
                      radius: 999,
                      alpha: .14,
                    ),
                    child: Text(
                      'Choix du niveau',
                      style: PsychoBrand.small(
                        context,
                      ).copyWith(color: exerciseColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: 64,
                height: 64,
                decoration: PsychoBrand.tinted(
                  context,
                  color: exerciseColor,
                  radius: 22,
                ),
                child: Icon(exerciseIcon, color: exerciseColor, size: 30),
              ),
              const SizedBox(height: 18),
              Text(exerciseTitle, style: PsychoBrand.h1(context)),
              const SizedBox(height: 8),
              Text(
                exerciseSubtitle,
                style: PsychoBrand.body(
                  context,
                ).copyWith(color: PsychoBrand.textMuted(context)),
              ),
              const SizedBox(height: 28),
              ...options.map(
                (o) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _DifficultyCard(option: o, onTap: () => onChoose(o.label)),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: PsychoBrand.tinted(
                  context,
                  color: PsychoBrand.accent,
                  alpha: .07,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: PsychoBrand.accent,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Les questions sont mélangées à chaque session. '
                        'Tu peux signaler n’importe quelle question via le drapeau.',
                        style: PsychoBrand.small(
                          context,
                        ).copyWith(color: PsychoBrand.text(context)),
                      ),
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

class _DifficultyCard extends StatefulWidget {
  final PsychoDifficultyOption option;
  final VoidCallback onTap;
  const _DifficultyCard({required this.option, required this.onTap});

  @override
  State<_DifficultyCard> createState() => _DifficultyCardState();
}

class _DifficultyCardState extends State<_DifficultyCard> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.option;
    final available = o.availableQuestions;
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? .98 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: PsychoBrand.card(context).copyWith(
            border: Border.all(color: psychoOpa(o.color, .25), width: 1.4),
            boxShadow: [
              BoxShadow(
                color: psychoOpa(o.color, _down ? .12 : .08),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: PsychoBrand.tinted(
                  context,
                  color: o.color,
                  radius: 16,
                ),
                child: Icon(o.icon, color: o.color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o.label, style: PsychoBrand.h3(context)),
                    const SizedBox(height: 2),
                    Text(
                      o.description,
                      style: PsychoBrand.small(
                        context,
                      ).copyWith(fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (available != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: PsychoBrand.tinted(
                          context,
                          color: o.color,
                          radius: 999,
                          alpha: .12,
                        ),
                        child: Text(
                          '$available question${available > 1 ? 's' : ''} disponibles',
                          style: PsychoBrand.small(
                            context,
                          ).copyWith(color: o.color),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: PsychoBrand.textMuted(context),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );

  }
}
