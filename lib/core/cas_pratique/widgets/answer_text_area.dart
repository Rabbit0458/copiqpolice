// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Widget AnswerTextArea                         ║
// ║  Référence : docs/cas_pratique/05_DESIGN_SYSTEM.md (§ 4.5)              ║
// ║  Tâche      : CODE-030                                                  ║
// ║                                                                         ║
// ║  Textarea premium avec :                                                ║
// ║   - Compteur de caractères en haut, couleur selon palier                ║
// ║   - Auto-save indicator (cloud icon + pulse + "Sauvegarde…")            ║
// ║   - Border focus animé (kBlueLight light / cInfo dark)                  ║
// ║   - Padding 16, font 15, line-height 1.5                                ║
// ║   - Min height 200, max height 400 puis scroll                          ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';

/// État de l'auto-save tel que vu par l'UI.
enum AnswerSaveState {
  idle,        // rien à signaler
  typing,      // l'utilisateur tape (avant déclenchement du save)
  saving,      // sauvegarde en cours
  saved,       // sauvegardé OK ("Sauvegardé il y a Xs")
  error,       // dernier save a échoué
}

/// Textarea premium pour répondre à une question de cas pratique.
///
/// Exemple d'utilisation :
/// ```dart
/// AnswerTextArea(
///   controller: _ctrl,
///   charRecommended: 400,
///   saveState: _state,
///   lastSavedAt: _lastSavedAt,
///   placeholder: 'Tape ta réponse ici…',
///   enabled: !_validated,
/// )
/// ```
class AnswerTextArea extends StatefulWidget {
  const AnswerTextArea({
    super.key,
    required this.controller,
    required this.charRecommended,
    this.charMin = 50,
    this.placeholder = 'Tape ta réponse ici…',
    this.saveState = AnswerSaveState.idle,
    this.lastSavedAt,
    this.enabled = true,
    this.maxHeight = 400.0,
    this.minHeight = 200.0,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final int charRecommended;
  final int charMin;
  final String placeholder;
  final AnswerSaveState saveState;
  final DateTime? lastSavedAt;
  final bool enabled;
  final double maxHeight;
  final double minHeight;
  final bool autofocus;

  @override
  State<AnswerTextArea> createState() => _AnswerTextAreaState();
}

class _AnswerTextAreaState extends State<AnswerTextArea>
    with TickerProviderStateMixin {
  late final FocusNode _focusNode;
  late final AnimationController _focusAnim;
  late final AnimationController _pulseAnim;

  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);

    _focusAnim = AnimationController(
      vsync: this,
      duration: CpTokens.animMedium,
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _pulseAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  void _onFocusChange() {
    final f = _focusNode.hasFocus;
    setState(() => _focused = f);
    if (f) {
      _focusAnim.forward();
    } else {
      _focusAnim.reverse();
    }
  }

  @override
  void dispose() {
    _focusAnim.dispose();
    _pulseAnim.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  bool _reduceMotion(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    final disableByOS = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    return (mq?.disableAnimations ?? false) || disableByOS;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final reduceMotion = _reduceMotion(context);

    final bg = CpTokens.surfaceContainer(isDark);
    final outline = CpTokens.outlineVariant(isDark);
    final focusedOutline = CpTokens.infoFor(isDark);
    final onSurface = CpTokens.onSurface(isDark);
    final onSurfaceFaint = CpTokens.onSurfaceFaint(isDark);

    return AnimatedBuilder(
      animation: _focusAnim,
      builder: (context, _) {
        final lerp = reduceMotion ? (_focused ? 1.0 : 0.0) : _focusAnim.value;
        final borderColor = Color.lerp(outline, focusedOutline, lerp)!;
        final shadowOpacity = isDark ? 0.30 : 0.10;

        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(CpTokens.r3),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: focusedOutline.withValues(alpha: 0.20 * lerp),
                blurRadius: 18 * lerp,
                offset: const Offset(0, 4),
              ),
              if (lerp == 0)
                BoxShadow(
                  color: Colors.black.withValues(alpha: shadowOpacity),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(
            CpTokens.s5, CpTokens.s3, CpTokens.s5, CpTokens.s4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(
                charCount: widget.controller.text.length,
                charRecommended: widget.charRecommended,
                charMin: widget.charMin,
                saveState: widget.saveState,
                lastSavedAt: widget.lastSavedAt,
                onSurfaceFaint: onSurfaceFaint,
                onSurface: onSurface,
                isDark: isDark,
                pulse: _pulseAnim,
                reduceMotion: reduceMotion,
              ),
              const SizedBox(height: CpTokens.s2),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: widget.minHeight,
                  maxHeight: widget.maxHeight,
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  autofocus: widget.autofocus,
                  enabled: widget.enabled,
                  maxLines: null,
                  minLines: 6,
                  expands: false,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: GoogleFonts.montserrat(
                    color: onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: widget.placeholder,
                    hintStyle: GoogleFonts.montserrat(
                      color: onSurfaceFaint,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  onChanged: (_) {
                    // Force redraw du compteur header (caractères)
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Header : compteur + indicator save ─────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.charCount,
    required this.charRecommended,
    required this.charMin,
    required this.saveState,
    required this.lastSavedAt,
    required this.onSurfaceFaint,
    required this.onSurface,
    required this.isDark,
    required this.pulse,
    required this.reduceMotion,
  });

  final int charCount;
  final int charRecommended;
  final int charMin;
  final AnswerSaveState saveState;
  final DateTime? lastSavedAt;
  final Color onSurfaceFaint;
  final Color onSurface;
  final bool isDark;
  final Animation<double> pulse;
  final bool reduceMotion;

  Color _counterColor() {
    if (charCount < charMin) return CpTokens.dangerFor(isDark);
    if (charCount < charRecommended) return onSurface;
    if (charCount < charRecommended * 2) return CpTokens.successFor(isDark);
    return CpTokens.warningFor(isDark);
  }

  @override
  Widget build(BuildContext context) {
    final counterColor = _counterColor();

    return Row(
      children: [
        Text(
          '$charCount / $charRecommended',
          style: GoogleFonts.montserrat(
            color: counterColor,
            fontWeight: FontWeight.w900,
            fontSize: 12.5,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'caractères',
          style: GoogleFonts.montserrat(
            color: onSurfaceFaint,
            fontWeight: FontWeight.w700,
            fontSize: 11.5,
          ),
        ),
        const Spacer(),
        _SaveIndicator(
          state: saveState,
          lastSavedAt: lastSavedAt,
          isDark: isDark,
          pulse: pulse,
          reduceMotion: reduceMotion,
        ),
      ],
    );
  }
}

// ─── SaveIndicator : icône + texte ──────────────────────────────────────────

class _SaveIndicator extends StatelessWidget {
  const _SaveIndicator({
    required this.state,
    required this.lastSavedAt,
    required this.isDark,
    required this.pulse,
    required this.reduceMotion,
  });

  final AnswerSaveState state;
  final DateTime? lastSavedAt;
  final bool isDark;
  final Animation<double> pulse;
  final bool reduceMotion;

  String _ageString(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inSeconds < 5) return 'à l’instant';
    if (diff.inSeconds < 60) return 'il y a ${diff.inSeconds}s';
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    return 'il y a ${diff.inHours} h';
  }

  @override
  Widget build(BuildContext context) {
    final faint = CpTokens.onSurfaceFaint(isDark);

    final ({IconData icon, String label, Color color, bool pulsing}) spec =
        switch (state) {
      AnswerSaveState.idle => (
          icon: Icons.cloud_outlined,
          label: '',
          color: faint,
          pulsing: false,
        ),
      AnswerSaveState.typing => (
          icon: Icons.edit_outlined,
          label: 'Modifié',
          color: faint,
          pulsing: false,
        ),
      AnswerSaveState.saving => (
          icon: Icons.cloud_sync_rounded,
          label: 'Sauvegarde…',
          color: CpTokens.infoFor(isDark),
          pulsing: true,
        ),
      AnswerSaveState.saved => (
          icon: Icons.cloud_done_rounded,
          label: lastSavedAt != null
              ? 'Sauvegardé ${_ageString(lastSavedAt!)}'
              : 'Sauvegardé',
          color: CpTokens.successFor(isDark),
          pulsing: false,
        ),
      AnswerSaveState.error => (
          icon: Icons.cloud_off_rounded,
          label: 'Échec — on réessaie',
          color: CpTokens.dangerFor(isDark),
          pulsing: false,
        ),
    };

    Widget iconWidget = Icon(spec.icon, size: 14, color: spec.color);
    if (spec.pulsing && !reduceMotion) {
      iconWidget = AnimatedBuilder(
        animation: pulse,
        builder: (_, child) => Opacity(
          opacity: 0.45 + 0.55 * pulse.value,
          child: child,
        ),
        child: iconWidget,
      );
    }

    if (spec.label.isEmpty) {
      return iconWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconWidget,
        const SizedBox(width: 5),
        Text(
          spec.label,
          style: GoogleFonts.montserrat(
            color: spec.color,
            fontWeight: FontWeight.w700,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }
}
