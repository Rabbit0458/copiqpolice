// COP'IQ — Widgets premium réutilisables pendant un exercice psycho :
//   - PsychoTimerHeader (top bar : exit, compteur, timer)
//   - PsychoQuestionCard (carte énoncé)
//   - PsychoAnswerButton (bouton de réponse avec états correct/incorrect)

import 'package:flutter/material.dart';

import '../models/psycho_question.dart';
import 'psycho_brand.dart';
import 'psycho_cube_renderer.dart';

class PsychoTimerHeader extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final double progressTimer; // 0..1 : 1 = full, 0 = expired
  final int remainingSeconds;
  final VoidCallback onExit;
  final VoidCallback onReport;
  final Color color;

  const PsychoTimerHeader({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.progressTimer,
    required this.remainingSeconds,
    required this.onExit,
    required this.onReport,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = remainingSeconds <= 5 ? PsychoBrand.bad : color;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          _IconButton(
            icon: Icons.close_rounded,
            onTap: onExit,
            tooltip: 'Quitter',
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Question $currentIndex / $totalQuestions',
                      style: PsychoBrand.small(context).copyWith(
                        fontWeight: FontWeight.w800,
                        color: PsychoBrand.text(context),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: PsychoBrand.tinted(
                        context,
                        color: c,
                        radius: 999,
                        alpha: .12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer_outlined, size: 14, color: c),
                          const SizedBox(width: 6),
                          Text(
                            '${remainingSeconds}s',
                            style: PsychoBrand.small(
                              context,
                            ).copyWith(color: c, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    value: progressTimer.clamp(0.0, 1.0),
                    backgroundColor: psychoOpa(c, .15),
                    valueColor: AlwaysStoppedAnimation(c),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _IconButton(
            icon: Icons.flag_outlined,
            onTap: onReport,
            tooltip: 'Signaler',
            tint: PsychoBrand.bad,
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color? tint;
  const _IconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final c = tint ?? PsychoBrand.text(context);
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: psychoOpa(c, .08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: psychoOpa(c, .15), width: 1),
            ),
            child: Icon(icon, size: 20, color: c),
          ),
        ),
      ),
    );
  }
}

class PsychoQuestionCard extends StatelessWidget {
  final PsychoQuestion question;
  final Color color;
  final IconData icon;
  const PsychoQuestionCard({
    super.key,
    required this.question,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: PsychoBrand.card(context, radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: PsychoBrand.tinted(
                  context,
                  color: color,
                  radius: 12,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: PsychoBrand.tinted(
                  context,
                  color: PsychoBrand.accent,
                  radius: 999,
                  alpha: .1,
                ),
                child: Text(
                  question.difficulty,
                  style: PsychoBrand.small(context).copyWith(
                    color: PsychoBrand.accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // ─── Renderer visuel cube net (spatial / rotations) ─────────
          if (_hasCubeNetFigure(question)) ...[
            Center(
              child: PsychoCubeNet(
                figureData: (question.figureData as Map)
                    .cast<String, dynamic>(),
                tint: color,
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (question.prompt != null && question.prompt!.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: PsychoBrand.tinted(
                context,
                color: color,
                radius: 14,
                alpha: .08,
              ),
              child: Text(
                question.prompt!,
                style: PsychoBrand.body(context).copyWith(
                  fontFamily: 'InstrumentSans',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          Text(
            question.question,
            style: PsychoBrand.h3(context).copyWith(fontSize: 19, height: 1.35),
          ),
        ],
      ),
    );
  }
}

/// Détecte si la question contient un patron de cube à dessiner.
bool _hasCubeNetFigure(PsychoQuestion q) {
  final f = q.figureData;
  if (f == null) return false;
  return (f['type']?.toString() ?? '') == 'cube_net' && f['faces'] is Map;
}

/// Détecte si une option correspond à un cube plié (3 faces visibles).
Map<String, dynamic>? _foldedFromOption(PsychoQuestion q, PsychoOption opt) {
  final raw = q.rawData['options'];
  if (raw is List) {
    for (final entry in raw) {
      if (entry is Map &&
          (entry['key']?.toString() == opt.key ||
              entry['label']?.toString() == opt.label)) {
        final folded = entry['folded'];
        if (folded is Map) return folded.cast<String, dynamic>();
      }
    }
  }
  return null;
}

class PsychoAnswerButton extends StatelessWidget {
  final PsychoOption option;
  final int index; // pour afficher A/B/C/D
  final bool isSelected;
  final bool isLocked; // true = answer revealed
  final bool isCorrect;
  final bool isWrongPicked;
  final VoidCallback? onTap;
  final Color color;
  // Si la question est de type cube net, on dessine le cube plié dans le bouton.
  final PsychoQuestion? cubeNetContext;

  const PsychoAnswerButton({
    super.key,
    required this.option,
    required this.index,
    required this.isSelected,
    required this.isLocked,
    required this.isCorrect,
    required this.isWrongPicked,
    required this.onTap,
    required this.color,
    this.cubeNetContext,
  });

  String get _badgeLetter {
    // Si la clé est déjà une lettre simple A/B/C/D, on l'utilise.
    if (option.key.length == 1) {
      final upper = option.key.toUpperCase();
      if (RegExp(r'^[A-Z]$').hasMatch(upper)) return upper;
    }
    // Sinon on dérive A/B/C… depuis l'index.
    return String.fromCharCode(0x41 + (index % 26));
  }

  @override
  Widget build(BuildContext context) {
    Color borderC = PsychoBrand.borderColor(context);
    Color bgC = PsychoBrand.surface(context);
    Color labelC = PsychoBrand.text(context);
    IconData? trailingIcon;
    Color trailingC = PsychoBrand.textMuted(context);

    if (isLocked) {
      if (isCorrect) {
        borderC = PsychoBrand.good;
        bgC = psychoOpa(PsychoBrand.good, .12);
        labelC = PsychoBrand.text(context);
        trailingIcon = Icons.check_circle_rounded;
        trailingC = PsychoBrand.good;
      } else if (isWrongPicked) {
        borderC = PsychoBrand.bad;
        bgC = psychoOpa(PsychoBrand.bad, .12);
        trailingIcon = Icons.cancel_rounded;
        trailingC = PsychoBrand.bad;
      } else {
        bgC = psychoOpa(PsychoBrand.text(context), .03);
      }
    } else if (isSelected) {
      borderC = color;
      bgC = psychoOpa(color, .10);
    }

    final foldedMap = (cubeNetContext != null)
        ? _foldedFromOption(cubeNetContext!, option)
        : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bgC,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderC, width: 1.4),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: psychoOpa(color, .15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _badgeLetter,
                  style: PsychoBrand.small(context).copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (foldedMap != null) ...[
                PsychoFoldedCube(foldedData: foldedMap, tint: color, size: 72),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  option.label,
                  style: PsychoBrand.option(context).copyWith(color: labelC),
                ),
              ),
              if (trailingIcon != null)
                Icon(trailingIcon, color: trailingC, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class PsychoExplanationCard extends StatelessWidget {
  final bool isCorrect;
  final String? explanation;
  final String correctAnswerLabel;
  const PsychoExplanationCard({
    super.key,
    required this.isCorrect,
    required this.correctAnswerLabel,
    this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? PsychoBrand.good : PsychoBrand.bad;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: PsychoBrand.tinted(
        context,
        color: color,
        radius: 18,
        alpha: .10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Bonne réponse' : 'Mauvaise réponse',
                style: PsychoBrand.h3(context).copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isCorrect
                ? 'Bravo ! Tu as bien identifié la solution.'
                : 'La bonne réponse était : $correctAnswerLabel',
            style: PsychoBrand.body(context),
          ),
          if (explanation != null && explanation!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              explanation!,
              style: PsychoBrand.body(
                context,
              ).copyWith(color: PsychoBrand.textMuted(context), fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}
