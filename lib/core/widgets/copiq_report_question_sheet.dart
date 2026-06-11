// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CopiqReportQuestionSheet
// Bottom sheet for reporting a quiz question.
// Design only — insertion logic is handled by the caller via [onSend].
// ─────────────────────────────────────────────────────────────────────────────
class CopiqReportQuestionSheet extends StatefulWidget {
  final Future<void> Function({
    required String reportType,
    required String message,
  }) onSend;

  const CopiqReportQuestionSheet({super.key, required this.onSend});

  /// Show the bottom sheet and await its result.
  static Future<void> show(
    BuildContext context, {
    required Future<void> Function({
      required String reportType,
      required String message,
    })
    onSend,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CopiqReportQuestionSheet(onSend: onSend),
    );
  }

  @override
  State<CopiqReportQuestionSheet> createState() =>
      _CopiqReportQuestionSheetState();
}

class _CopiqReportQuestionSheetState extends State<CopiqReportQuestionSheet> {
  static const _types = [
    ('reponse_incorrecte',   'Réponse incorrecte'),
    ('question_mal_formulee','Question mal formulée'),
    ('probleme_affichage',   'Problème d\'affichage'),
    ('doublon',              'Doublon'),
    ('autre',                'Autre'),
  ];

  String? _selectedType;
  final _msgCtrl  = TextEditingController();
  int    _charCount = 0;
  bool   _sending = false;
  bool   _sent    = false;

  @override
  void initState() {
    super.initState();
    _msgCtrl.addListener(() {
      setState(() => _charCount = _msgCtrl.text.length);
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    if (_selectedType == null || _sending) return;
    setState(() => _sending = true);
    try {
      await widget.onSend(
        reportType: _selectedType!,
        message: _msgCtrl.text.trim(),
      );
      if (!mounted) return;
      setState(() { _sending = false; _sent = true; });
      HapticFeedback.lightImpact();
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sysDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final sheetBg   = sysDark ? const Color(0xFF111827) : Colors.white;
    final surfaceBg = sysDark ? const Color(0xFF1F2937) : const Color(0xFFF6F6F7);
    final textMain  = sysDark ? const Color(0xFFF9FAFB) : const Color(0xFF111827);
    final textSub   = sysDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final divider   = sysDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6);
    const bad       = Color(0xFFFF3B30);
    const badBg     = Color(0xFFFFF1F1);
    const badBorder = Color(0xFFFF3B30);

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ───────────────────────────────────────────────────────
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── Header ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: sysDark
                          ? bad.withValues(alpha: .15)
                          : const Color(0xFFFFF1F1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.flag_rounded,
                      color: bad,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Signaler la question',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: textMain,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          'Ton signalement aide à améliorer le contenu.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textSub,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Type de problème ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Type de problème',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textSub,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Type rows
            for (final type in _types) ...[
              _TypeRow(
                label: type.$2,
                selected: _selectedType == type.$1,
                sysDark: sysDark,
                badBg: badBg,
                textMain: textMain,
                textSub: textSub,
                divider: divider,
                onTap: () => setState(() => _selectedType = type.$1),
              ),
            ],
            const SizedBox(height: 16),

            // ── Message field ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Message (optionnel)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textSub,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        '$_charCount/250',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: textSub,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _msgCtrl,
                    maxLines: 4,
                    maxLength: 250,
                    buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                        const SizedBox.shrink(),
                    style: TextStyle(
                      fontSize: 14,
                      color: textMain,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Décris le problème rencontré…',
                      hintStyle: TextStyle(
                        color: textSub.withValues(alpha: .7),
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: surfaceBg,
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF6C63FF),
                          width: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Send button ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: FilledButton(
                  onPressed: (_sending || _sent || _selectedType == null)
                      ? null
                      : _onSend,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF83F42),
                    disabledBackgroundColor: sysDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                    disabledForegroundColor: textSub,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _sent
                        ? const Icon(Icons.check_rounded, key: ValueKey('ok'))
                        : _sending
                        ? const SizedBox(
                            key: ValueKey('spin'),
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Envoyer le signalement',
                            key: ValueKey('label'),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Type row
// ─────────────────────────────────────────────────────────────────────────────
class _TypeRow extends StatelessWidget {
  final String label;
  final bool selected;
  final bool sysDark;
  final Color badBg;
  final Color textMain;
  final Color textSub;
  final Color divider;
  final VoidCallback onTap;

  const _TypeRow({
    required this.label,
    required this.selected,
    required this.sysDark,
    required this.badBg,
    required this.textMain,
    required this.textSub,
    required this.divider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const bad = Color(0xFFFF3B30);
    final rowBg = selected
        ? (sysDark ? bad.withValues(alpha: .10) : badBg)
        : Colors.transparent;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: rowBg,
          borderRadius: BorderRadius.circular(10),
          border: selected
              ? Border.all(color: bad.withValues(alpha: .4))
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? bad : textMain,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            if (selected)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: bad,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 13,
                ),
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: textSub.withValues(alpha: .4),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

  }
}
