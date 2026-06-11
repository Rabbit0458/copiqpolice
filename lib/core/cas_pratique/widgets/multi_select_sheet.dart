// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — MultiSelectSheet (bottom sheet checkboxes)    ║
// ║  Référence : docs/cas_pratique/05_DESIGN_SYSTEM.md (§ 3.2 filtres)      ║
// ║  Tâche      : CODE-038                                                  ║
// ║                                                                         ║
// ║  Bottom sheet générique pour sélectionner plusieurs valeurs parmi      ║
// ║  une liste d'options. Animation d'arrivée, header titre + reset,       ║
// ║  liste scrollable de checkboxes, CTA "Appliquer" sticky en bas.       ║
// ║                                                                         ║
// ║  Helper `showMultiSelectSheet<T>(...)` qui résout en Set<T> (ou null   ║
// ║  si fermé sans appliquer).                                              ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';

/// Une option présentée dans le bottom sheet.
class MultiSelectOption<T> {
  /// Valeur retournée si l'option est cochée.
  final T value;

  /// Label visible à l'utilisateur.
  final String label;

  /// Description optionnelle (petite ligne grise sous le label).
  final String? subtitle;

  /// Couleur d'accent (pour la pastille). Null = couleur primaire du theme.
  final Color? accent;

  /// Icône optionnelle à gauche.
  final IconData? icon;

  const MultiSelectOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.accent,
    this.icon,
  });
}

/// Ouvre un bottom sheet multi-sélection. Retourne le Set choisi si
/// "Appliquer" tapé, sinon null (fermé sans appliquer).
Future<Set<T>?> showMultiSelectSheet<T>({
  required BuildContext context,
  required String title,
  required List<MultiSelectOption<T>> options,
  required Set<T> initial,
  String emptyLabel = 'Aucune option disponible.',
  String resetLabel = 'Réinitialiser',
  String applyLabel = 'Appliquer',
}) {
  return showModalBottomSheet<Set<T>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return _MultiSelectSheet<T>(
        title: title,
        options: options,
        initial: initial,
        emptyLabel: emptyLabel,
        resetLabel: resetLabel,
        applyLabel: applyLabel,
      );
    },
  );
}

class _MultiSelectSheet<T> extends StatefulWidget {
  const _MultiSelectSheet({
    required this.title,
    required this.options,
    required this.initial,
    required this.emptyLabel,
    required this.resetLabel,
    required this.applyLabel,
  });

  final String title;
  final List<MultiSelectOption<T>> options;
  final Set<T> initial;
  final String emptyLabel;
  final String resetLabel;
  final String applyLabel;

  @override
  State<_MultiSelectSheet<T>> createState() => _MultiSelectSheetState<T>();
}

class _MultiSelectSheetState<T> extends State<_MultiSelectSheet<T>> {
  late Set<T> _selected = {...widget.initial};

  bool get _hasChanges => !_setEq(_selected, widget.initial);

  static bool _setEq<T>(Set<T> a, Set<T> b) {
    if (a.length != b.length) return false;
    for (final v in a) {
      if (!b.contains(v)) return false;
    }
    return true;
  }

  void _toggle(T v) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_selected.contains(v)) {
        _selected.remove(v);
      } else {
        _selected.add(v);
      }
    });
  }

  void _resetAll() {
    HapticFeedback.lightImpact();
    setState(() => _selected = <T>{});
  }

  void _apply() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop(_selected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surface = CpTokens.surface(isDark);
    final onSurface = CpTokens.onSurface(isDark);
    final onSurfaceMuted = CpTokens.onSurfaceMuted(isDark);
    final outlineVariant = CpTokens.outlineVariant(isDark);
    const primary = CpTokens.blueLight;

    final mq = MediaQuery.of(context);
    final maxHeight = mq.size.height * 0.78;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
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
            // ── Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                CpTokens.s6, CpTokens.s3, CpTokens.s6, CpTokens.s3,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.montserrat(
                        color: onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _selected.isEmpty ? null : _resetAll,
                    style: TextButton.styleFrom(
                      foregroundColor: primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8,
                      ),
                    ),
                    child: Text(
                      widget.resetLabel,
                      style: GoogleFonts.montserrat(
                        color: _selected.isEmpty
                            ? onSurfaceMuted.withValues(alpha: 0.55)
                            : primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: outlineVariant,
            ),
            // ── Liste des options
            Flexible(
              child: widget.options.isEmpty
                  ? _EmptyOptions(
                      message: widget.emptyLabel,
                      onSurfaceMuted: onSurfaceMuted,
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: CpTokens.s2,
                      ),
                      itemCount: widget.options.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        thickness: 0.5,
                        indent: CpTokens.s6,
                        endIndent: CpTokens.s6,
                        color: outlineVariant.withValues(alpha: 0.55),
                      ),
                      itemBuilder: (_, i) {
                        final opt = widget.options[i];
                        final selected = _selected.contains(opt.value);
                        return _OptionTile<T>(
                          option: opt,
                          selected: selected,
                          accent: opt.accent ?? primary,
                          onSurface: onSurface,
                          onSurfaceMuted: onSurfaceMuted,
                          onTap: () => _toggle(opt.value),
                        );
                      },
                    ),
            ),
            // ── Footer : nb sélectionnés + bouton Appliquer
            Container(
              padding: EdgeInsets.fromLTRB(
                CpTokens.s6, CpTokens.s4, CpTokens.s6,
                CpTokens.s4 + mq.viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: surface,
                border: Border(
                  top: BorderSide(color: outlineVariant),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selected.isEmpty
                          ? 'Aucune sélection'
                          : '${_selected.length} sélection'
                              '${_selected.length > 1 ? 's' : ''}',
                      style: GoogleFonts.montserrat(
                        color: onSurfaceMuted,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _hasChanges ? _apply : _apply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(CpTokens.r3),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        elevation: 0,
                      ),
                      child: Text(
                        widget.applyLabel,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w900,
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile<T> extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.selected,
    required this.accent,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.onTap,
  });

  final MultiSelectOption<T> option;
  final bool selected;
  final Color accent;
  final Color onSurface;
  final Color onSurfaceMuted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            CpTokens.s6, CpTokens.s3, CpTokens.s6, CpTokens.s3,
          ),
          child: Row(
            children: [
              if (option.icon != null) ...[
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(option.icon, color: accent, size: 18),
                ),
                const SizedBox(width: CpTokens.s3),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      style: GoogleFonts.montserrat(
                        color: onSurface,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (option.subtitle != null &&
                        option.subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        option.subtitle!,
                        style: GoogleFonts.montserrat(
                          color: onSurfaceMuted,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: CpTokens.s3),
              _CheckBox(checked: selected, accent: accent),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.checked, required this.accent});
  final bool checked;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      width: 24, height: 24,
      decoration: BoxDecoration(
        color: checked ? accent : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: checked
              ? accent
              : Theme.of(context).colorScheme.outlineVariant,
          width: 1.6,
        ),
      ),
      child: checked
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
          : null,
    );
  }
}

class _EmptyOptions extends StatelessWidget {
  const _EmptyOptions({
    required this.message,
    required this.onSurfaceMuted,
  });
  final String message;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(CpTokens.s6),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
          color: onSurfaceMuted,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
