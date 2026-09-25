import 'package:flutter/material.dart';

/// Bloc de reprise partagé, indépendant de la source de progression.
///
/// Sa hauteur reste pilotée par son contenu afin de supporter les petits
/// écrans et l'agrandissement du texte sans masquer le bouton principal.
class ContinuePreparationPanel extends StatelessWidget {
  const ContinuePreparationPanel({
    super.key,
    required this.loading,
    required this.hasActivity,
    required this.activityTitle,
    required this.activitySubtitle,
    required this.scorePercent,
    required this.streakDays,
    required this.doneToday,
    required this.dailyGoal,
    required this.onPrimaryTap,
    required this.onSeeAll,
    this.startTitle = 'Commence ta préparation',
    this.startSubtitle =
        'Lance un premier entraînement pour démarrer ton suivi.',
  });

  final bool loading;
  final bool hasActivity;
  final String? activityTitle;
  final String? activitySubtitle;
  final int? scorePercent;
  final int streakDays;
  final int doneToday;
  final int dailyGoal;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSeeAll;
  final String startTitle;
  final String startSubtitle;

  @override
  Widget build(BuildContext context) {
    final palette = _PanelPalette.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final scaledBody = MediaQuery.textScalerOf(context).scale(14);
        final compactHeader = constraints.maxWidth < 340 || scaledBody > 18;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PanelHeader(
              palette: palette,
              compact: compactHeader,
              onSeeAll: onSeeAll,
            ),
            const SizedBox(height: 14),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: loading
                  ? _PanelSkeleton(key: const ValueKey('continue-loading'))
                  : Column(
                      key: const ValueKey('continue-ready'),
                      children: [
                        if (hasActivity)
                          _ResumeActivityCard(
                            title: activityTitle?.trim().isNotEmpty == true
                                ? activityTitle!.trim()
                                : 'Ton dernier entraînement',
                            subtitle:
                                activitySubtitle?.trim().isNotEmpty == true
                                ? activitySubtitle!.trim()
                                : 'Préparation au concours',
                            scorePercent: scorePercent,
                            palette: palette,
                            onTap: onPrimaryTap,
                          )
                        else
                          _StartActivityCard(
                            title: startTitle,
                            subtitle: startSubtitle,
                            palette: palette,
                            onTap: onPrimaryTap,
                          ),
                        const SizedBox(height: 12),
                        _ProgressStats(
                          streakDays: streakDays,
                          doneToday: doneToday,
                          dailyGoal: dailyGoal,
                          palette: palette,
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.palette,
    required this.compact,
    required this.onSeeAll,
  });

  final _PanelPalette palette;
  final bool compact;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Continue ta préparation',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: palette.ink,
                  fontSize: 18,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.25,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Reprends exactement là où tu t’es arrêté.',
                maxLines: compact ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.muted,
                  height: 1.25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Semantics(
          button: true,
          label: 'Voir mon parcours',
          child: Material(
            color: palette.softSurface,
            shape: StadiumBorder(side: BorderSide(color: palette.border)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onSeeAll,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 12 : 14,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!compact) ...[
                        Text(
                          'Mon parcours',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: palette.ink,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 19,
                        color: palette.ink,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResumeActivityCard extends StatelessWidget {
  const _ResumeActivityCard({
    required this.title,
    required this.subtitle,
    required this.scorePercent,
    required this.palette,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final int? scorePercent;
  final _PanelPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final percentage = scorePercent?.clamp(0, 100);

    return Semantics(
      button: true,
      label: 'Continuer $title',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [palette.surface, palette.tintSurface],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: palette.border),
            boxShadow: [palette.shadow],
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LeadingIcon(
                        icon: Icons.menu_book_rounded,
                        palette: palette,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: palette.accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'À REPRENDRE',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: palette.accent,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.05,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: palette.ink,
                                    fontSize: 17,
                                    height: 1.12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -.2,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: palette.muted,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (percentage != null)
                        Expanded(
                          child: _ScoreProgress(
                            percentage: percentage,
                            palette: palette,
                          ),
                        )
                      else
                        Expanded(
                          child: Text(
                            'Ta progression est prête à continuer.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: palette.muted,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      const SizedBox(width: 14),
                      _PrimaryAction(
                        label: 'Continuer',
                        icon: Icons.play_arrow_rounded,
                        palette: palette,
                        onTap: onTap,
                      ),
                    ],
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

class _StartActivityCard extends StatelessWidget {
  const _StartActivityCard({
    required this.title,
    required this.subtitle,
    required this.palette,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final _PanelPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [palette.surface, palette.tintSurface],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: palette.border),
            boxShadow: [palette.shadow],
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _LeadingIcon(
                    icon: Icons.rocket_launch_rounded,
                    palette: palette,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: palette.ink,
                                fontSize: 17,
                                height: 1.15,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: palette.muted,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _ArrowButton(palette: palette, onTap: onTap),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.icon, required this.palette});

  final IconData icon;
  final _PanelPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: palette.accentSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.accentBorder),
      ),
      child: Icon(icon, color: palette.accent, size: 25),
    );
  }
}

class _ScoreProgress extends StatelessWidget {
  const _ScoreProgress({required this.percentage, required this.palette});

  final int percentage;
  final _PanelPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Dernier score',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: palette.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: palette.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 7,
            backgroundColor: palette.progressTrack,
            valueColor: AlwaysStoppedAnimation<Color>(palette.accent),
          ),
        ),
      ],
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({
    required this.label,
    required this.icon,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final _PanelPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.cta,
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 46),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: palette.ctaInk),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: palette.ctaInk,
                    fontWeight: FontWeight.w800,
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

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.palette, required this.onTap});

  final _PanelPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.cta,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            Icons.arrow_forward_rounded,
            color: palette.ctaInk,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _ProgressStats extends StatelessWidget {
  const _ProgressStats({
    required this.streakDays,
    required this.doneToday,
    required this.dailyGoal,
    required this.palette,
  });

  final int streakDays;
  final int doneToday;
  final int dailyGoal;
  final _PanelPalette palette;

  @override
  Widget build(BuildContext context) {
    final goalReached = dailyGoal > 0 && doneToday >= dailyGoal;
    final textIsLarge = MediaQuery.textScalerOf(context).scale(14) > 18;

    final items = [
      _StatCard(
        icon: Icons.local_fire_department_rounded,
        iconColor: const Color(0xFFFFA72C),
        value: '$streakDays',
        label: streakDays <= 1 ? 'jour de suite' : 'jours de suite',
        palette: palette,
      ),
      _StatCard(
        icon: goalReached
            ? Icons.check_circle_rounded
            : Icons.track_changes_rounded,
        iconColor: goalReached ? const Color(0xFF25B978) : palette.accent,
        value: '$doneToday/$dailyGoal',
        label: goalReached ? 'objectif atteint' : 'objectif du jour',
        palette: palette,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 320 || textIsLarge) {
          return Column(
            children: [items.first, const SizedBox(height: 10), items.last],
          );
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: items.first),
              const SizedBox(width: 10),
              Expanded(child: items.last),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.palette,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final _PanelPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: palette.softSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: palette.isDark ? .13 : .09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 21, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: palette.ink,
                    height: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: palette.muted,
                    height: 1.15,
                    fontWeight: FontWeight.w600,
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

class _PanelSkeleton extends StatelessWidget {
  const _PanelSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = _PanelPalette.of(context);

    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 154),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: palette.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _SkeletonBar(width: 50, height: 50, radius: 16),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _SkeletonBar(width: 84, height: 8),
                        SizedBox(height: 9),
                        _SkeletonBar(width: 190, height: 15),
                        SizedBox(height: 7),
                        _SkeletonBar(width: 140, height: 10),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Row(
                children: [
                  Expanded(child: _SkeletonBar(height: 34, radius: 12)),
                  SizedBox(width: 14),
                  _SkeletonBar(width: 104, height: 46, radius: 15),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(child: _SkeletonBar(height: 66, radius: 18)),
            SizedBox(width: 10),
            Expanded(child: _SkeletonBar(height: 66, radius: 18)),
          ],
        ),
      ],
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({
    this.width = double.infinity,
    required this.height,
    this.radius = 8,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final palette = _PanelPalette.of(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: palette.skeleton,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _PanelPalette {
  const _PanelPalette({
    required this.isDark,
    required this.surface,
    required this.softSurface,
    required this.tintSurface,
    required this.ink,
    required this.muted,
    required this.border,
    required this.accent,
    required this.accentSoft,
    required this.accentBorder,
    required this.progressTrack,
    required this.cta,
    required this.ctaInk,
    required this.skeleton,
    required this.shadow,
  });

  final bool isDark;
  final Color surface;
  final Color softSurface;
  final Color tintSurface;
  final Color ink;
  final Color muted;
  final Color border;
  final Color accent;
  final Color accentSoft;
  final Color accentBorder;
  final Color progressTrack;
  final Color cta;
  final Color ctaInk;
  final Color skeleton;
  final BoxShadow shadow;

  factory _PanelPalette.of(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const accent = Color(0xFF3977F6);
    final surface = isDark ? const Color(0xFF171B20) : Colors.white;

    return _PanelPalette(
      isDark: isDark,
      surface: surface,
      softSurface: isDark ? const Color(0xFF15191E) : const Color(0xFFF7F8FA),
      tintSurface: Color.alphaBlend(
        accent.withValues(alpha: isDark ? .055 : .035),
        surface,
      ),
      ink: isDark ? const Color(0xFFF7F8FA) : const Color(0xFF15171B),
      muted: isDark ? const Color(0xFFAEB4BD) : const Color(0xFF5E6671),
      border: isDark ? const Color(0xFF272D35) : const Color(0xFFE5E8ED),
      accent: accent,
      accentSoft: accent.withValues(alpha: isDark ? .14 : .09),
      accentBorder: accent.withValues(alpha: isDark ? .26 : .18),
      progressTrack: isDark ? const Color(0xFF292E35) : const Color(0xFFE9EDF3),
      cta: isDark ? const Color(0xFFF5F7FA) : const Color(0xFF171A1F),
      ctaInk: isDark ? const Color(0xFF14171B) : Colors.white,
      skeleton: isDark ? const Color(0xFF242930) : const Color(0xFFEBEEF2),
      shadow: BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? .22 : .07),
        blurRadius: isDark ? 24 : 22,
        offset: const Offset(0, 12),
      ),
    );
  }
}
