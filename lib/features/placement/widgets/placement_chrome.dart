part of '../placement_test.dart';

const Color _placementInk = Color(0xFF0B1020);
const Color _placementMuted = Color(0xFF637083);
const Color _placementLine = Color(0xFFE7ECF4);
const Color _placementGold = Color(0xFFD4AF37);
const Color _placementSoft = Color(0xFFF7F9FC);

TextStyle placementText({
  required double size,
  FontWeight weight = FontWeight.w700,
  Color color = _placementInk,
  double height = 1.2,
}) {
  return GoogleFonts.montserrat(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: 0,
  );
}

class PlacementBackdrop extends StatefulWidget {
  const PlacementBackdrop({
    super.key,
    required this.isDark,
    required this.animate,
  });

  final bool isDark;
  final bool animate;

  @override
  State<PlacementBackdrop> createState() => _PlacementBackdropState();
}

class _PlacementBackdropState extends State<PlacementBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant PlacementBackdrop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate == oldWidget.animate) return;
    widget.animate ? _controller.repeat(reverse: true) : _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = widget.isDark
        ? const Color(0xFF03081D)
        : const Color(0xFF0C3CC4);
    final mid = widget.isDark
        ? const Color(0xFF061649)
        : const Color(0xFF0E44D6);
    final bottom = widget.isDark
        ? const Color(0xFF020512)
        : const Color(0xFF081D5F);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = widget.animate ? _controller.value : 0.35;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.8 + (t * 0.22), -1),
              end: Alignment(0.85 - (t * 0.18), 1),
              colors: [top, mid, bottom],
              stops: const [0, 0.48, 1],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(
                          alpha: widget.isDark ? 0.03 : 0.08,
                        ),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.25),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: _PlacementGridPainter(
                    color: Colors.white.withValues(
                      alpha: widget.isDark ? 0.035 : 0.055,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlacementGridPainter extends CustomPainter {
  const _PlacementGridPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const gap = 42.0;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PlacementGridPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class PlacementSurface extends StatelessWidget {
  const PlacementSurface({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.82)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(18),
            child: child,
          ),
        ),
      ),
    );
  }
}

class PlacementPill extends StatelessWidget {
  const PlacementPill({super.key, required this.label, this.icon, this.accent});

  final String label;
  final IconData? icon;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? const Color(0xFF2453E6);
    return Container(
      constraints: const BoxConstraints(minHeight: 34),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: placementText(
              size: 11.5,
              weight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class PlacementPrimaryButton extends StatefulWidget {
  const PlacementPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.icon = Icons.arrow_forward_rounded,
    this.foreground = const Color(0xFF0E44D6),
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final IconData icon;
  final Color foreground;

  @override
  State<PlacementPrimaryButton> createState() => _PlacementPrimaryButtonState();
}

class _PlacementPrimaryButtonState extends State<PlacementPrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled && widget.onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      child: Listener(
        onPointerDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onPointerUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onPointerCancel: enabled
            ? (_) => setState(() => _pressed = false)
            : null,
        child: AnimatedScale(
          scale: _pressed ? 0.985 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              onPressed: enabled ? widget.onPressed : null,
              icon: Icon(widget.icon, size: 20),
              label: Text(widget.label),
              style:
                  ElevatedButton.styleFrom(
                    elevation: 0,
                    disabledBackgroundColor: const Color(0xFFD8DFEA),
                    disabledForegroundColor: const Color(0xFF7D8797),
                    backgroundColor: Colors.white,
                    foregroundColor: widget.foreground,
                    textStyle: placementText(
                      size: 15.5,
                      weight: FontWeight.w900,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ).copyWith(
                    overlayColor: WidgetStatePropertyAll(
                      widget.foreground.withValues(alpha: 0.08),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlacementSectionTitle extends StatelessWidget {
  const PlacementSectionTitle({
    super.key,
    required this.title,
    required this.icon,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 19, color: const Color(0xFF2453E6)),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            title,
            style: placementText(size: 15, weight: FontWeight.w900),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class PlacementReveal extends StatelessWidget {
  const PlacementReveal({
    super.key,
    required this.child,
    required this.delay,
    required this.reduceMotion,
  });

  final Widget child;
  final Duration delay;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    if (reduceMotion) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 360 + delay.inMilliseconds),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final delayed =
            ((value * (360 + delay.inMilliseconds)) - delay.inMilliseconds) /
            360;
        final t = delayed.clamp(0.0, 1.0);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 14),
            child: Transform.scale(scale: 0.985 + (t * 0.015), child: child),
          ),
        );
      },
      child: child,
    );
  }
}
