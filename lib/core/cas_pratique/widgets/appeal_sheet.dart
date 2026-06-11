// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — AppealSheet                                   ║
// ║  Référence : docs/cas_pratique/05_DESIGN_SYSTEM.md (§ 4.8 appel)        ║
// ║  Tâche      : CODE-041                                                  ║
// ║                                                                         ║
// ║  Bottom sheet "Faire appel" pour un point manqué :                     ║
// ║   - Header : icône + titre + bouton fermer                              ║
// ║   - Rappel point attendu (label + explanation)                          ║
// ║   - Aperçu de la réponse utilisateur (extrait, max 4 lignes)            ║
// ║   - Textarea "Pourquoi penses-tu que ta réponse est correcte ?"        ║
// ║   - Bouton "Envoyer mon appel" (CTA primary bleu)                       ║
// ║   - Bouton "Annuler" (ghost)                                            ║
// ║                                                                         ║
// ║  Le helper `showAppealSheet(...)` retourne le message saisi (String)   ║
// ║  ou null si l'utilisateur annule.                                       ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';

/// Ouvre la sheet d'appel. Retourne le message saisi (non vide) ou null.
Future<String?> showAppealSheet({
  required BuildContext context,
  required String pointLabel,
  String? pointExplanation,
  String? userAnswerPreview,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: true,
    builder: (ctx) {
      return _AppealSheet(
        pointLabel: pointLabel,
        pointExplanation: pointExplanation,
        userAnswerPreview: userAnswerPreview,
      );
    },
  );
}

class _AppealSheet extends StatefulWidget {
  const _AppealSheet({
    required this.pointLabel,
    required this.pointExplanation,
    required this.userAnswerPreview,
  });

  final String pointLabel;
  final String? pointExplanation;
  final String? userAnswerPreview;

  @override
  State<_AppealSheet> createState() => _AppealSheetState();
}

class _AppealSheetState extends State<_AppealSheet> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();
  bool _sending = false;

  static const int _kCharMin = 20;
  static const int _kCharRecommended = 200;
  static const int _kCharMax = 1000;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_rebuild);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_rebuild);
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  bool get _canSend =>
      !_sending && _ctrl.text.trim().length >= _kCharMin;

  void _cancel() {
    HapticFeedback.selectionClick();
    Navigator.of(context).pop();
  }

  void _send() {
    final msg = _ctrl.text.trim();
    if (msg.length < _kCharMin) {
      HapticFeedback.lightImpact();
      return;
    }
    HapticFeedback.lightImpact();
    setState(() => _sending = true);
    Navigator.of(context).pop(msg);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surface = CpTokens.surface(isDark);
    final onSurface = CpTokens.onSurface(isDark);
    final onSurfaceMuted = CpTokens.onSurfaceMuted(isDark);
    final onSurfaceFaint = CpTokens.onSurfaceFaint(isDark);
    final outlineVariant = CpTokens.outlineVariant(isDark);
    const primary = CpTokens.blueLight;

    final mq = MediaQuery.of(context);
    final keyboard = mq.viewInsets.bottom;
    final maxHeight = mq.size.height * 0.88;

    final charCount = _ctrl.text.length;

    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(bottom: keyboard),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(CpTokens.r6),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Drag handle
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 6),
                  width: 44, height: 4,
                  decoration: BoxDecoration(
                    color: onSurfaceMuted.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                _Header(
                  title: 'Faire appel',
                  subtitle:
                      'Si tu penses que ta réponse couvrait ce point, explique nous pourquoi. Un correcteur vérifiera.',
                  onClose: _cancel,
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  primary: primary,
                ),
                Divider(height: 1, thickness: 1, color: outlineVariant),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      CpTokens.s6, CpTokens.s4, CpTokens.s6, CpTokens.s4,
                    ),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _PointReminder(
                          label: widget.pointLabel,
                          explanation: widget.pointExplanation,
                          onSurface: onSurface,
                          onSurfaceMuted: onSurfaceMuted,
                          accent: primary,
                          isDark: isDark,
                        ),
                        if (widget.userAnswerPreview != null &&
                            widget.userAnswerPreview!.trim().isNotEmpty) ...[
                          const SizedBox(height: CpTokens.s3),
                          _UserAnswerBlock(
                            text: widget.userAnswerPreview!.trim(),
                            onSurface: onSurface,
                            onSurfaceMuted: onSurfaceMuted,
                            onSurfaceFaint: onSurfaceFaint,
                            isDark: isDark,
                          ),
                        ],
                        const SizedBox(height: CpTokens.s5),
                        Text(
                          'Ton argumentaire',
                          style: GoogleFonts.montserrat(
                            color: onSurface,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: CpTokens.s2),
                        _AppealTextarea(
                          controller: _ctrl,
                          focusNode: _focus,
                          enabled: !_sending,
                          charCount: charCount,
                          charMin: _kCharMin,
                          charRecommended: _kCharRecommended,
                          charMax: _kCharMax,
                          onSurface: onSurface,
                          onSurfaceMuted: onSurfaceMuted,
                          onSurfaceFaint: onSurfaceFaint,
                          outlineVariant: outlineVariant,
                          accent: primary,
                          isDark: isDark,
                        ),
                        const SizedBox(height: CpTokens.s3),
                        Text(
                          'Ton message sera transmis à l\'équipe pédagogique. '
                          'En cas de validation, ta correction sera ajustée et le '
                          'mot-clé manquant sera ajouté au moteur.',
                          style: GoogleFonts.montserrat(
                            color: onSurfaceFaint,
                            fontWeight: FontWeight.w600,
                            fontSize: 11.5,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    CpTokens.s6, CpTokens.s4, CpTokens.s6, CpTokens.s5,
                  ),
                  decoration: BoxDecoration(
                    color: surface,
                    border: Border(top: BorderSide(color: outlineVariant)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: _sending ? null : _cancel,
                          style: TextButton.styleFrom(
                            foregroundColor: onSurfaceMuted,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(CpTokens.r3),
                              side: BorderSide(color: outlineVariant),
                            ),
                          ),
                          child: Text(
                            'Annuler',
                            style: GoogleFonts.montserrat(
                              color: onSurface,
                              fontWeight: FontWeight.w900,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: CpTokens.s3),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _canSend ? _send : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                primary.withValues(alpha: 0.40),
                            disabledForegroundColor:
                                Colors.white.withValues(alpha: 0.70),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(CpTokens.r3),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          child: _sending
                              ? const SizedBox(
                                  width: 20, height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.send_rounded,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Envoyer mon appel',
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
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

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.onClose,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final String title;
  final String subtitle;
  final VoidCallback onClose;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CpTokens.s6, CpTokens.s3, CpTokens.s3, CpTokens.s4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.report_problem_rounded,
              color: primary,
              size: 19,
            ),
          ),
          const SizedBox(width: CpTokens.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    color: onSurfaceMuted,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.2,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Fermer',
            onPressed: onClose,
            icon: Icon(
              Icons.close_rounded,
              color: onSurfaceMuted,
              size: 22,
            ),
            splashRadius: 22,
          ),
        ],
      ),
    );
  }
}

class _PointReminder extends StatelessWidget {
  const _PointReminder({
    required this.label,
    required this.explanation,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.accent,
    required this.isDark,
  });

  final String label;
  final String? explanation;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        CpTokens.s4, CpTokens.s3, CpTokens.s4, CpTokens.s3,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.10 : 0.07),
        borderRadius: BorderRadius.circular(CpTokens.r3),
        border: Border.all(color: accent.withValues(alpha: 0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag_rounded, color: accent, size: 16),
              const SizedBox(width: 6),
              Text(
                'POINT ATTENDU',
                style: GoogleFonts.montserrat(
                  color: accent,
                  fontWeight: FontWeight.w900,
                  fontSize: 10.5,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              height: 1.3,
              letterSpacing: -0.2,
            ),
          ),
          if (explanation != null && explanation!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              explanation!.trim(),
              style: GoogleFonts.montserrat(
                color: onSurfaceMuted,
                fontWeight: FontWeight.w600,
                fontSize: 12.2,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _UserAnswerBlock extends StatelessWidget {
  const _UserAnswerBlock({
    required this.text,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.onSurfaceFaint,
    required this.isDark,
  });

  final String text;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color onSurfaceFaint;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        CpTokens.s4, CpTokens.s3, CpTokens.s4, CpTokens.s3,
      ),
      decoration: BoxDecoration(
        color: CpTokens.surfaceContainer(isDark),
        borderRadius: BorderRadius.circular(CpTokens.r3),
        border: Border.all(color: CpTokens.outlineVariant(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote_rounded,
                color: onSurfaceFaint,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'TA RÉPONSE',
                style: GoogleFonts.montserrat(
                  color: onSurfaceMuted,
                  fontWeight: FontWeight.w900,
                  fontSize: 10.5,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            text,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              color: onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
              height: 1.45,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppealTextarea extends StatelessWidget {
  const _AppealTextarea({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.charCount,
    required this.charMin,
    required this.charRecommended,
    required this.charMax,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.onSurfaceFaint,
    required this.outlineVariant,
    required this.accent,
    required this.isDark,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final int charCount;
  final int charMin;
  final int charRecommended;
  final int charMax;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color onSurfaceFaint;
  final Color outlineVariant;
  final Color accent;
  final bool isDark;

  Color _counterColor() {
    if (charCount == 0) return onSurfaceFaint;
    if (charCount < charMin) return CpTokens.dangerFor(isDark);
    if (charCount < charRecommended) return onSurface;
    if (charCount < charMax) return CpTokens.successFor(isDark);
    return CpTokens.warningFor(isDark);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CpTokens.surfaceContainer(isDark),
        borderRadius: BorderRadius.circular(CpTokens.r3),
        border: Border.all(color: outlineVariant, width: 1.2),
      ),
      padding: const EdgeInsets.fromLTRB(
        CpTokens.s4, CpTokens.s3, CpTokens.s4, CpTokens.s3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            maxLines: 6,
            minLines: 4,
            maxLength: charMax,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            cursorColor: accent,
            style: GoogleFonts.montserrat(
              color: onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.45,
            ),
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              counterText: '',
              hintText:
                  'Décris en quelques phrases pourquoi tu penses que ce point '
                  'est couvert par ta réponse…',
              hintStyle: GoogleFonts.montserrat(
                color: onSurfaceFaint,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '$charCount / $charRecommended',
                style: GoogleFonts.montserrat(
                  color: _counterColor(),
                  fontWeight: FontWeight.w900,
                  fontSize: 11.5,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                charCount < charMin
                    ? 'minimum $charMin caractères'
                    : 'caractères',
                style: GoogleFonts.montserrat(
                  color: onSurfaceFaint,
                  fontWeight: FontWeight.w700,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
