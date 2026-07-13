part of '../placement_test.dart';

class PlacementProgressHeader extends StatelessWidget {
  const PlacementProgressHeader({
    super.key,
    required this.index,
    required this.total,
    required this.remaining,
    required this.currentWeight,
    required this.formatTime,
    required this.reduceMotion,
  });

  final int index;
  final int total;
  final Duration remaining;
  final int currentWeight;
  final String Function(Duration) formatTime;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final progress = ((index + 1) / total).clamp(0.0, 1.0);
    final pct = (progress * 100).round();

    return PlacementSurface(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${index + 1}',
                      style: placementText(size: 18, weight: FontWeight.w900),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$pct % complété',
                      style: placementText(
                        size: 12.2,
                        weight: FontWeight.w700,
                        color: _placementMuted,
                      ),
                    ),
                  ],
                ),
              ),
              _HeaderMetric(
                icon: Icons.timer_rounded,
                label: 'Temps',
                value: formatTime(remaining),
                pulse: remaining.inMinutes < 2,
              ),
              const SizedBox(width: 8),
              _HeaderMetric(
                icon: Icons.bolt_rounded,
                label: 'Points',
                value: '+$currentWeight',
                pulse: false,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: Duration(milliseconds: reduceMotion ? 0 : 420),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  minHeight: 8,
                  value: value,
                  backgroundColor: const Color(0xFFE7ECF4),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF2453E6),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.pulse,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool pulse;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      constraints: const BoxConstraints(minWidth: 82, minHeight: 50),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _placementLine),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2453E6)),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: placementText(
                  size: 10.5,
                  weight: FontWeight.w700,
                  color: _placementMuted,
                ),
              ),
              Text(
                value,
                style: placementText(size: 13.2, weight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );

    if (!pulse) return content;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: content,
    );
  }
}
