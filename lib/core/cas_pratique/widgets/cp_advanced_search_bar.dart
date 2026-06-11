// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Barre de recherche avancée avec auto-complete ║
// ║  Tâche : CODE-092                                                       ║
// ║                                                                         ║
// ║  Fonctionnalités :                                                      ║
// ║    - Champ de saisie avec debounce 300ms                                ║
// ║    - Dropdown d'auto-complete (suggestions titres via RPC)              ║
// ║    - Chip "Non fait" (filtre notDone)                                   ║
// ║    - Animations slide-down / fade                                       ║
// ║    - Dark/Light mode (CpTokens)                                         ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/cas_pratique/search/cp_search_service.dart';
import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';

// ─── CpAdvancedSearchBar ─────────────────────────────────────────────────────

/// Barre de recherche full-text avec auto-complete pour la liste Cas Pratique.
///
/// Paramètres :
///   [controller]    — TextEditingController fourni par le parent
///   [focusNode]     — FocusNode fourni par le parent
///   [onQueryChanged]— callback appelé avec la requête après debounce 300ms
///   [notDone]       — valeur actuelle du filtre "Non fait"
///   [onNotDoneToggled] — callback quand l'utilisateur bascule "Non fait"
///   [onSuggestionTap]  — callback quand une suggestion est sélectionnée
///                        (reçoit le slug du cas)
///   [isDark]        — thème courant
class CpAdvancedSearchBar extends StatefulWidget {
  const CpAdvancedSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onQueryChanged,
    this.notDone = false,
    this.onNotDoneToggled,
    this.onSuggestionTap,
    this.isDark = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onQueryChanged;
  final bool notDone;
  final VoidCallback? onNotDoneToggled;
  final ValueChanged<String>? onSuggestionTap;
  final bool isDark;

  @override
  State<CpAdvancedSearchBar> createState() => _CpAdvancedSearchBarState();
}

class _CpAdvancedSearchBarState extends State<CpAdvancedSearchBar>
    with SingleTickerProviderStateMixin {
  // ─── Debounce ────────────────────────────────────────────────────────────
  Timer? _debounce;
  static const _kDebounce = Duration(milliseconds: 300);

  // ─── Auto-complete ───────────────────────────────────────────────────────
  Timer? _acDebounce;
  static const _kAcDebounce = Duration(milliseconds: 200);
  List<CpAutocompleteSuggestion> _suggestions = const [];
  bool _showSuggestions = false;
  bool _loadingAc = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  // ─── Animation slide-in suggestions ─────────────────────────────────────
  late final AnimationController _acAnim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  );
  late final Animation<double> _acFade =
      CurvedAnimation(parent: _acAnim, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _acDebounce?.cancel();
    widget.controller.removeListener(_onTextChanged);
    widget.focusNode.removeListener(_onFocusChanged);
    _removeOverlay();
    _acAnim.dispose();
    super.dispose();
  }

  // ─── Listeners ───────────────────────────────────────────────────────────

  void _onTextChanged() {
    final v = widget.controller.text;

    // Debounce pour le callback principal
    _debounce?.cancel();
    _debounce = Timer(_kDebounce, () {
      if (mounted) widget.onQueryChanged(v);
    });

    // Debounce pour l'auto-complete
    _acDebounce?.cancel();
    if (v.trim().length >= 2) {
      _acDebounce = Timer(_kAcDebounce, () => _fetchSuggestions(v.trim()));
    } else {
      _hideSuggestions();
    }
  }

  void _onFocusChanged() {
    if (!widget.focusNode.hasFocus) {
      // Petit délai pour permettre le tap sur une suggestion avant de cacher
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _hideSuggestions();
      });
    }
  }

  // ─── Auto-complete : fetch + overlay ─────────────────────────────────────

  Future<void> _fetchSuggestions(String query) async {
    if (!mounted) return;
    setState(() => _loadingAc = true);
    final results =
        await CpSearchService.instance.autocomplete(query, limit: 6);
    if (!mounted) return;
    setState(() {
      _suggestions = results;
      _loadingAc = false;
    });
    if (results.isNotEmpty && widget.focusNode.hasFocus) {
      _showSuggestionsOverlay();
    } else {
      _hideSuggestions();
    }
  }

  void _showSuggestionsOverlay() {
    _removeOverlay();
    if (!mounted) return;

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (ctx) => _SuggestionsOverlay(
        layerLink: _layerLink,
        suggestions: _suggestions,
        query: widget.controller.text.trim(),
        isDark: widget.isDark,
        fadeAnimation: _acFade,
        onTap: (s) {
          HapticFeedback.selectionClick();
          _hideSuggestions();
          widget.controller.text = s.title;
          widget.controller.selection = TextSelection.fromPosition(
            TextPosition(offset: s.title.length),
          );
          widget.onQueryChanged(s.title);
          widget.onSuggestionTap?.call(s.slug);
        },
      ),
    );
    overlay.insert(_overlayEntry!);
    _showSuggestions = true;
    _acAnim.forward(from: 0);
  }

  void _hideSuggestions() {
    _removeOverlay();
    _showSuggestions = false;
    _suggestions = const [];
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark
        ? CpTokens.surfaceDark.withValues(alpha: 0.9)
        : Colors.white.withValues(alpha: 0.95);
    final borderColor = widget.isDark
        ? Colors.white.withValues(alpha: 0.12)
        : CpTokens.brand.withValues(alpha: 0.25);
    final hintColor = widget.isDark
        ? Colors.white.withValues(alpha: 0.35)
        : Colors.black.withValues(alpha: 0.35);
    final textColor =
        widget.isDark ? Colors.white : Colors.black.withValues(alpha: 0.87);
    final iconColor = widget.isDark
        ? Colors.white.withValues(alpha: 0.5)
        : CpTokens.brand.withValues(alpha: 0.7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Champ de saisie ──────────────────────────────────────────────
        CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: CpTokens.brand.withValues(alpha: 
                      widget.focusNode.hasFocus ? 0.18 : 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(Icons.search_rounded, size: 20, color: iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Titre, situation, question, mot-clé…',
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: hintColor,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (v) {
                      _hideSuggestions();
                      widget.onQueryChanged(v);
                    },
                  ),
                ),
                if (_loadingAc)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: iconColor,
                      ),
                    ),
                  )
                else if (widget.controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      widget.controller.clear();
                      widget.onQueryChanged('');
                      _hideSuggestions();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: iconColor,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 10),
              ],
            ),
          ),
        ),

        // ── Chip "Non fait" ──────────────────────────────────────────────
        const SizedBox(height: 8),
        _NotDoneChip(
          active: widget.notDone,
          isDark: widget.isDark,
          onTap: () {
            HapticFeedback.selectionClick();
            widget.onNotDoneToggled?.call();
          },
        ),
      ],
    );
  }
}

// ─── Chip "Non fait" ─────────────────────────────────────────────────────────

class _NotDoneChip extends StatelessWidget {
  const _NotDoneChip({
    required this.active,
    required this.isDark,
    required this.onTap,
  });

  final bool active;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const activeBg = CpTokens.brand;
    final inactiveBg = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : CpTokens.brand.withValues(alpha: 0.08);
    final labelColor =
        active ? Colors.white : (isDark ? Colors.white70 : CpTokens.brand);
    final borderColor = active
        ? CpTokens.brand
        : (isDark
            ? Colors.white.withValues(alpha: 0.12)
            : CpTokens.brand.withValues(alpha: 0.25));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? activeBg : inactiveBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                active
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                key: ValueKey(active),
                size: 15,
                color: labelColor,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              'Non fait',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Overlay suggestions ──────────────────────────────────────────────────────

class _SuggestionsOverlay extends StatelessWidget {
  const _SuggestionsOverlay({
    required this.layerLink,
    required this.suggestions,
    required this.query,
    required this.isDark,
    required this.fadeAnimation,
    required this.onTap,
  });

  final LayerLink layerLink;
  final List<CpAutocompleteSuggestion> suggestions;
  final String query;
  final bool isDark;
  final Animation<double> fadeAnimation;
  final ValueChanged<CpAutocompleteSuggestion> onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF0D1A3E) : Colors.white;
    final shadow = BoxShadow(
      color: CpTokens.brand.withValues(alpha: 0.18),
      blurRadius: 20,
      spreadRadius: 2,
      offset: const Offset(0, 6),
    );

    return Positioned(
      width: 320,
      child: CompositedTransformFollower(
        link: layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0, 50),
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 280),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: CpTokens.brand.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [shadow],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: suggestions.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
                  itemBuilder: (ctx, i) {
                    final s = suggestions[i];
                    return _SuggestionTile(
                      suggestion: s,
                      query: query,
                      isDark: isDark,
                      onTap: () => onTap(s),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.suggestion,
    required this.query,
    required this.isDark,
    required this.onTap,
  });

  final CpAutocompleteSuggestion suggestion;
  final String query;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? Colors.white : Colors.black.withValues(alpha: 0.85);
    final subColor =
        isDark ? Colors.white38 : Colors.black.withValues(alpha: 0.4);
    final highlightBg = CpTokens.brand.withValues(alpha: 0.18);
    final highlightFg = isDark ? Colors.white : CpTokens.brand;

    // Surligner les mots correspondants dans le titre
    final spans = CpTextHighlighter.highlight(
      text: suggestion.title,
      query: query,
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              size: 16,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.3)
                  : CpTokens.brand.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  children: spans
                      .map(
                        (s) => TextSpan(
                          text: s.text,
                          style: s.isMatch
                              ? GoogleFonts.montserrat(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: highlightFg,
                                  backgroundColor: highlightBg,
                                )
                              : null,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${suggestion.year}',
              style: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: subColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widget de titre surlighé (réutilisable dans les cards) ──────────────────

/// Affiche [text] en surlignant les occurrences de [query].
///
/// Usage dans une CasCard :
/// ```dart
/// CpHighlightedText(
///   text: cas.title,
///   query: currentSearchQuery,
///   style: titleStyle,
///   highlightColor: CpTokens.brand,
/// )
/// ```
class CpHighlightedText extends StatelessWidget {
  const CpHighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.style,
    this.highlightColor,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  final String text;
  final String query;
  final TextStyle? style;
  final Color? highlightColor;
  final int? maxLines;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final spans = CpTextHighlighter.highlight(text: text, query: query);
    final base = style ?? DefaultTextStyle.of(context).style;
    final hlColor = highlightColor ?? CpTokens.brand;

    if (spans.length == 1 && !spans.first.isMatch) {
      // Optimisation : pas de match → Text simple
      return Text(
        text,
        style: base,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(
        style: base,
        children: spans
            .map(
              (s) => TextSpan(
                text: s.text,
                style: s.isMatch
                    ? TextStyle(
                        fontWeight: FontWeight.w700,
                        backgroundColor: hlColor.withValues(alpha: 0.18),
                        color: hlColor,
                      )
                    : null,
              ),
            )
            .toList(),
      ),
    );
  }
}
