// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — FilterChipsRow                                ║
// ║  Référence : docs/cas_pratique/05_DESIGN_SYSTEM.md (§ 3.1)              ║
// ║  Tâche      : CODE-038                                                  ║
// ║                                                                         ║
// ║  Rangée horizontale de chips de filtre (Année / Thème / Difficulté).   ║
// ║  Chaque chip est cliquable et affiche un compteur si actif.            ║
// ║  Un bouton "Effacer" apparaît à droite si au moins un filtre est actif.║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_filters.dart';

/// Configuration d'un chip de filtre.
class FilterChipSpec {
  /// Label affiché ("Année", "Thème", "Difficulté").
  final String label;

  /// Icône à gauche du label.
  final IconData icon;

  /// Nombre de valeurs sélectionnées dans cette catégorie (0 = inactif).
  final int activeCount;

  /// Callback au tap.
  final VoidCallback onTap;

  const FilterChipSpec({
    required this.label,
    required this.icon,
    required this.activeCount,
    required this.onTap,
  });
}

/// Rangée scrollable horizontalement avec les chips de filtre.
class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({
    super.key,
    required this.filters,
    required this.onTapYear,
    required this.onTapTheme,
    required this.onTapDifficulty,
    required this.onClearAll,
  });

  final CasPratiqueFilters filters;
  final VoidCallback onTapYear;
  final VoidCallback onTapTheme;
  final VoidCallback onTapDifficulty;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final chips = <FilterChipSpec>[
      FilterChipSpec(
        label: 'Année',
        icon: Icons.calendar_today_rounded,
        activeCount: filters.years.length,
        onTap: onTapYear,
      ),
      FilterChipSpec(
        label: 'Thème',
        icon: Icons.local_offer_rounded,
        activeCount: filters.themeSlugs.length,
        onTap: onTapTheme,
      ),
      FilterChipSpec(
        label: 'Difficulté',
        icon: Icons.bolt_rounded,
        activeCount: filters.difficulties.length,
        onTap: onTapDifficulty,
      ),
    ];

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        physics: const BouncingScrollPhysics(),
        children: [
          for (final c in chips) ...[
            _FilterChip(spec: c),
            const SizedBox(width: 8),
          ],
          if (filters.isNotEmpty)
            _ClearAllChip(onTap: onClearAll),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.spec});
  final FilterChipSpec spec;

  @override
  Widget build(BuildContext context) {
    final active = spec.activeCount > 0;

    final bg = active
        ? Colors.white
        : Colors.white.withValues(alpha: 0.12);
    final stroke = active
        ? Colors.white
        : Colors.white.withValues(alpha: 0.18);
    final fg = active ? CpTokens.darkNavy : Colors.white.withValues(alpha: 0.92);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        spec.onTap();
      },
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: stroke, width: 1.2),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.20),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(spec.icon, size: 15, color: fg),
            const SizedBox(width: 6),
            Text(
              spec.label,
              style: GoogleFonts.montserrat(
                color: fg,
                fontWeight: FontWeight.w900,
                fontSize: 12.5,
                letterSpacing: -0.2,
              ),
            ),
            if (active) ...[
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: CpTokens.darkNavy,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${spec.activeCount}',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    height: 1.0,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 2),
            Icon(
              Icons.expand_more_rounded,
              size: 16,
              color: fg,
            ),
          ],
        ),
      ),
    );
  }
}

class _ClearAllChip extends StatelessWidget {
  const _ClearAllChip({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.30),
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.close_rounded,
              size: 14,
              color: Colors.white.withValues(alpha: 0.92),
            ),
            const SizedBox(width: 4),
            Text(
              'Effacer',
              style: GoogleFonts.montserrat(
                color: Colors.white.withValues(alpha: 0.92),
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
