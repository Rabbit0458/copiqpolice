// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Widget PointPill                              ║
// ║  Référence : docs/cas_pratique/05_DESIGN_SYSTEM.md (§ 4.7)              ║
// ║  Tâche      : CODE-032                                                  ║
// ║                                                                         ║
// ║  Carte d'un point de rubric dans la page correction :                  ║
// ║   - Icône + label + score (n pt / max)                                  ║
// ║   - Couleur sémantique selon status (covered/partial/missing)           ║
// ║   - Expand on tap → description du point + bouton "Faire appel" si     ║
// ║     missing.                                                             ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';
import 'package:copiqpolice/data/cas_pratique/models/cas_pratique_models.dart' show PointStatus;
/// Carte pour un point de correction.
class PointPill extends StatefulWidget {
  const PointPill({
    super.key,
    required this.label,
    required this.status,
    required this.score,
    required this.weight,
    this.explanationMd,
    this.canAppeal = false,
    this.onAppeal,
    this.matchedKeywords = const [],
    this.initiallyExpanded = false,
  });

  /// Label du point.
  final String label;

  /// Statut.
  final PointStatus status;

  /// Score obtenu (0..weight).
  final double score;

  /// Score max possible (weight).
  final double weight;

  /// Explication pédagogique (optionnelle).
  final String? explanationMd;

  /// Si true, on affiche le bouton "Faire appel" (lorsque status=missing).
  final bool canAppeal;

  /// Callback bouton "Faire appel".
  final VoidCallback? onAppeal;

  /// Mots-clés effectivement matchés (debug / pédagogie).
  final List<String> matchedKeywords;

  /// Ouvert au montage.
  final bool initiallyExpanded;

  @override
  State<PointPill> createState() => _PointPillState();
}

class _PointPillState extends State<PointPill>
    with SingleTickerProviderStateMixin {
  late bool _expanded = widget.initiallyExpanded;
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
      value: widget.initiallyExpanded ? 1.0 : 0.0,
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
    HapticFeedback.selectionClick();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ─── Mapping status → couleurs / icône / label court ────────────────────

  ({Color main, Color soft, Color border, IconData icon, String shortLabel})
      _styleFor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (widget.status) {
      case PointStatus.covered:
        return (
          main: CpTokens.successFor(isDark),
          soft: isDark ? CpTokens.successSoftD : CpTokens.successSoftL,
          border: CpTokens.successFor(isDark).withValues(alpha: 0.50),
          icon: Icons.check_circle_rounded,
          shortLabel: 'Couvert',
        );
      case PointStatus.partial:
        return (
          main: CpTokens.warningFor(isDark),
          soft: isDark ? CpTokens.warningSoftD : CpTokens.warningSoftL,
          border: CpTokens.warningFor(isDark).withValues(alpha: 0.50),
          icon: Icons.error_outline_rounded,
          shortLabel: 'Partiel',
        );
      case PointStatus.missing:
        return (
          main: CpTokens.dangerFor(isDark),
          soft: isDark ? CpTokens.dangerSoftD : CpTokens.dangerSoftL,
          border: CpTokens.dangerFor(isDark).withValues(alpha: 0.50),
          icon: Icons.cancel_rounded,
          shortLabel: 'Manqué',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = _styleFor(context);
    final surface = CpTokens.surface(isDark);
    final onSurface = CpTokens.onSurface(isDark);
    final onSurfaceMuted = CpTokens.onSurfaceMuted(isDark);

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(CpTokens.r3),
        border: Border.all(color: style.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(CpTokens.r3),
        child: InkWell(
          borderRadius: BorderRadius.circular(CpTokens.r3),
          onTap: _toggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              CpTokens.s4, CpTokens.s3, CpTokens.s4, CpTokens.s3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(
                  icon: style.icon,
                  iconColor: style.main,
                  iconBg: style.soft,
                  shortLabel: style.shortLabel,
                  label: widget.label,
                  score: widget.score,
                  weight: widget.weight,
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  statusMainColor: style.main,
                  expanded: _expanded,
                ),
                SizeTransition(
                  sizeFactor: _anim,
                  axisAlignment: -1.0,
                  child: _ExpandedBody(
                    explanationMd: widget.explanationMd,
                    matchedKeywords: widget.matchedKeywords,
                    canAppeal:
                        widget.canAppeal && widget.status == PointStatus.missing,
                    onAppeal: widget.onAppeal,
                    onSurfaceMuted: onSurfaceMuted,
                    onSurface: onSurface,
                    accent: style.main,
                    isDark: isDark,
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

// ─── Header (toujours visible) ──────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.shortLabel,
    required this.label,
    required this.score,
    required this.weight,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.statusMainColor,
    required this.expanded,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String shortLabel;
  final String label;
  final double score;
  final double weight;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color statusMainColor;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: CpTokens.s3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.montserrat(
                  color: onSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                shortLabel,
                style: GoogleFonts.montserrat(
                  color: statusMainColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: CpTokens.s3),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _fmt(score),
              style: GoogleFonts.montserrat(
                color: onSurface,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                height: 1.0,
                letterSpacing: -0.4,
              ),
            ),
            Text(
              '/ ${_fmt(weight)} pt',
              style: GoogleFonts.montserrat(
                color: onSurfaceMuted,
                fontWeight: FontWeight.w700,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
        const SizedBox(width: 6),
        AnimatedRotation(
          duration: const Duration(milliseconds: 200),
          turns: expanded ? 0.5 : 0.0,
          child: Icon(
            Icons.expand_more_rounded,
            color: onSurfaceMuted,
            size: 20,
          ),
        ),
      ],
    );
  }

  String _fmt(double v) {
    if (v == v.toInt()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(1);
  }
}

// ─── Body (visible quand expanded) ──────────────────────────────────────────

class _ExpandedBody extends StatelessWidget {
  const _ExpandedBody({
    required this.explanationMd,
    required this.matchedKeywords,
    required this.canAppeal,
    required this.onAppeal,
    required this.onSurfaceMuted,
    required this.onSurface,
    required this.accent,
    required this.isDark,
  });

  final String? explanationMd;
  final List<String> matchedKeywords;
  final bool canAppeal;
  final VoidCallback? onAppeal;
  final Color onSurfaceMuted;
  final Color onSurface;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: CpTokens.s3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (explanationMd != null && explanationMd!.trim().isNotEmpty) ...[
            Text(
              explanationMd!,
              style: GoogleFonts.montserrat(
                color: onSurfaceMuted,
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
                height: 1.45,
              ),
            ),
            const SizedBox(height: CpTokens.s3),
          ],
          if (matchedKeywords.isNotEmpty) ...[
            Text(
              'Trouvé dans ta réponse :',
              style: GoogleFonts.montserrat(
                color: onSurfaceMuted,
                fontWeight: FontWeight.w800,
                fontSize: 11.5,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: matchedKeywords
                  .take(12)
                  .map((k) => _Chip(text: k, color: accent, isDark: isDark))
                  .toList(),
            ),
            const SizedBox(height: CpTokens.s3),
          ],
          if (canAppeal) _AppealButton(onTap: onAppeal),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, required this.color, required this.isDark});

  final String text;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(CpTokens.rPill),
        border: Border.all(color: color.withValues(alpha: 0.40)),
      ),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 10.5,
        ),
      ),
    );
  }
}

class _AppealButton extends StatelessWidget {
  const _AppealButton({required this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = CpTokens.infoFor(isDark);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CpTokens.rPill),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.18 : 0.10),
          borderRadius: BorderRadius.circular(CpTokens.rPill),
          border: Border.all(color: color.withValues(alpha: 0.50)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.report_problem_rounded, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              'Je pense que ma réponse est correcte',
              style: GoogleFonts.montserrat(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
