part of '../placement_test.dart';

class PlacementAnswerTile extends StatefulWidget {
  const PlacementAnswerTile({
    super.key,
    required this.label,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  State<PlacementAnswerTile> createState() => _PlacementAnswerTileState();
}

class _PlacementAnswerTileState extends State<PlacementAnswerTile> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    final accent = selected ? const Color(0xFF2453E6) : _placementMuted;
    final bg = selected ? const Color(0xFFEFF4FF) : Colors.white;
    final border = selected ? const Color(0xFF2453E6) : _placementLine;
    final elevation = selected ? 18.0 : (_hovered ? 10.0 : 0.0);

    return Semantics(
      button: true,
      selected: selected,
      enabled: !widget.locked || selected,
      label: widget.label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Listener(
          onPointerDown: widget.locked
              ? null
              : (_) => setState(() => _pressed = true),
          onPointerUp: widget.locked
              ? null
              : (_) => setState(() => _pressed = false),
          onPointerCancel: widget.locked
              ? null
              : (_) => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.985 : 1,
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOutCubic,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.locked ? null : widget.onTap,
                borderRadius: BorderRadius.circular(18),
                splashColor: const Color(0xFF2453E6).withValues(alpha: 0.08),
                highlightColor: const Color(0xFF2453E6).withValues(alpha: 0.04),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 190),
                  curve: Curves.easeOutCubic,
                  constraints: const BoxConstraints(minHeight: 58),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: border,
                      width: selected ? 1.4 : 1,
                    ),
                    boxShadow: [
                      if (elevation > 0)
                        BoxShadow(
                          color: const Color(
                            0xFF2453E6,
                          ).withValues(alpha: selected ? 0.16 : 0.08),
                          blurRadius: elevation,
                          offset: Offset(0, selected ? 8 : 5),
                        ),
                    ],
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 190),
                        curve: Curves.easeOutCubic,
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected ? accent : Colors.white,
                          border: Border.all(
                            color: selected ? accent : const Color(0xFFCBD5E1),
                            width: 1.5,
                          ),
                        ),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 160),
                          curve: Curves.easeOutBack,
                          scale: selected ? 1 : 0,
                          child: const Icon(
                            Icons.check_rounded,
                            size: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text(
                          widget.label,
                          style: placementText(
                            size: 14.2,
                            weight: selected
                                ? FontWeight.w900
                                : FontWeight.w700,
                            color: _placementInk,
                            height: 1.28,
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: selected && widget.locked ? 1 : 0,
                        duration: const Duration(milliseconds: 180),
                        child: Icon(
                          Icons.verified_rounded,
                          size: 20,
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
