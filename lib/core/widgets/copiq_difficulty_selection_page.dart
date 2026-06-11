// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CopiqDifficultySelectionPage
// Shared difficulty-selection overlay for every quiz.
// Drop-in replacement for each file's private _DifficultySplash.
// ─────────────────────────────────────────────────────────────────────────────
class CopiqDifficultySelectionPage extends StatelessWidget {
  final Animation<double> fade;
  final bool isDark;
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onStart;
  final VoidCallback onStartRandom;
  final String title;
  final String subtitle;
  final IconData icon;

  const CopiqDifficultySelectionPage({
    super.key,
    required this.fade,
    required this.isDark,
    required this.selected,
    required this.onSelect,
    required this.onStart,
    required this.onStartRandom,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  // ── Level definitions ──────────────────────────────────────────────────────
  static const _levels = [
    _LevelDef(
      label: 'Facile',
      emoji: '🌱',
      desc: 'Questions accessibles pour débuter',
      color: Color(0xFF22C55E),
      bg: Color(0xFFECFDF3),
      border: Color(0xFFB8F5CA),
      darkBg: Color(0xFF072A13),
      darkBorder: Color(0xFF145228),
    ),
    _LevelDef(
      label: 'Moyenne',
      emoji: '🏅',
      desc: 'Niveau intermédiaire recommandé',
      color: Color(0xFFF59E0B),
      bg: Color(0xFFFFF7E8),
      border: Color(0xFFFFDCA8),
      darkBg: Color(0xFF2A1A02),
      darkBorder: Color(0xFF5C3A06),
    ),
    _LevelDef(
      label: 'Difficile',
      emoji: '🏆',
      desc: 'Pour les candidats confirmés',
      color: Color(0xFFFF3B30),
      bg: Color(0xFFFFF1F1),
      border: Color(0xFFFFBDBD),
      darkBg: Color(0xFF2A0808),
      darkBorder: Color(0xFF5C1616),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF6C63FF);
    final bg       = isDark ? const Color(0xFF08111D) : const Color(0xFFF4F7FB);
    final cardBg   = isDark ? const Color(0xFF101826) : Colors.white;
    final textMain = isDark ? const Color(0xFFF5F7FA) : const Color(0xFF18202F);
    final textSub  = isDark ? const Color(0xFFA9B5C7) : const Color(0xFF667085);
    final borderC  = isDark ? const Color(0xFF253247) : const Color(0xFFE3EAF5);

    return Positioned.fill(
      child: FadeTransition(
        opacity: fade,
        child: Container(
          color: bg,
          child: SafeArea(
            child: Column(
              children: [
                // ── Top bar ─────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderC),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: textMain,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Badge "Choix du niveau"
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? accent.withValues(alpha: .15)
                              : const Color(0xFFEEEDFF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? accent.withValues(alpha: .30)
                                : const Color(0xFFC9C6FF),
                          ),
                        ),
                        child: Text(
                          'Choix du niveau',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFF8C93FF) : accent,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Module icon + Title + Subtitle ───────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isDark
                              ? accent.withValues(alpha: .15)
                              : const Color(0xFFEEEDFF),
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(
                            color: isDark
                                ? accent.withValues(alpha: .25)
                                : const Color(0xFFD4D2FF),
                          ),
                        ),
                        child: Icon(icon, color: accent, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: textMain,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: textSub,
                                decoration: TextDecoration.none,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Cards + info + random ────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        // Level cards
                        for (final level in _levels) ...[
                          _CopiqLevelCard(
                            level: level,
                            isDark: isDark,
                            cardBg: cardBg,
                            onTap: () {
                              onSelect(level.label);
                              onStart();
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                        const SizedBox(height: 4),

                        // Info block
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? accent.withValues(alpha: .10)
                                : const Color(0xFFF0F0FF),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark
                                  ? accent.withValues(alpha: .20)
                                  : const Color(0xFFC9C6FF),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                size: 16,
                                color: accent,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Les questions sont mélangées à chaque session. '
                                  'Tu peux signaler n\'importe quelle question via le drapeau.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? const Color(0xFF8C93FF)
                                        : accent,
                                    decoration: TextDecoration.none,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Random button
                        TextButton.icon(
                          onPressed: onStartRandom,
                          icon: Icon(
                            Icons.shuffle_rounded,
                            size: 16,
                            color: textSub,
                          ),
                          label: Text(
                            'Mode aléatoire',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textSub,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
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

// ─────────────────────────────────────────────────────────────────────────────
// Internal data + card widget
// ─────────────────────────────────────────────────────────────────────────────
class _LevelDef {
  final String label;
  final String emoji;
  final String desc;
  final Color color;
  final Color bg;
  final Color border;
  final Color darkBg;
  final Color darkBorder;

  const _LevelDef({
    required this.label,
    required this.emoji,
    required this.desc,
    required this.color,
    required this.bg,
    required this.border,
    required this.darkBg,
    required this.darkBorder,
  });
}

class _CopiqLevelCard extends StatelessWidget {
  final _LevelDef level;
  final bool isDark;
  final Color cardBg;
  final VoidCallback onTap;

  const _CopiqLevelCard({
    required this.level,
    required this.isDark,
    required this.cardBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final levelBg     = isDark ? level.darkBg     : level.bg;
    final levelBorder = isDark ? level.darkBorder  : level.border;
    final textMain    = isDark ? const Color(0xFFF5F7FA) : const Color(0xFF18202F);
    final textSub     = isDark ? const Color(0xFFA9B5C7) : const Color(0xFF667085);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 102,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: levelBorder.withValues(alpha: isDark ? .6 : .8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .15 : .05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Emoji icon in colored rounded square
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: levelBg,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: levelBorder),
              ),
              child: Center(
                child: Text(
                  level.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Label + desc + badge
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textMain,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    level.desc,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textSub,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: levelBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: levelBorder),
                    ),
                    child: Text(
                      '1000 questions disponibles',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: level.color,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right_rounded,
              color: textSub.withValues(alpha: .5),
              size: 22,
            ),
          ],
        ),
      ),
    );

  }
}
