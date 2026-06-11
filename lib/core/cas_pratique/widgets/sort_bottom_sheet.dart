// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Sort bottom sheet (single-select)             ║
// ║  Référence : docs/cas_pratique/05_DESIGN_SYSTEM.md (§ 3.3 tri)          ║
// ║  Tâche      : CODE-039                                                  ║
// ║                                                                         ║
// ║  Bottom sheet "Trier par…" avec liste de radios premium. Tap →         ║
// ║  ferme la sheet en renvoyant la valeur sélectionnée (CaseSortBy).      ║
// ║  Tap en dehors / drag down → renvoie null (annulation).                 ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_repository.dart'
    show CaseSortBy;

/// Spec d'une option de tri.
class SortOptionSpec {
  final CaseSortBy value;
  final String label;
  final IconData icon;
  final String? subtitle;

  const SortOptionSpec({
    required this.value,
    required this.label,
    required this.icon,
    this.subtitle,
  });
}

/// Liste par défaut des options de tri exposées à l'utilisateur.
/// L'ordre ici = ordre d'affichage dans la sheet.
const List<SortOptionSpec> kSortOptions = [
  SortOptionSpec(
    value: CaseSortBy.recent,
    label: 'Plus récent',
    icon: Icons.new_releases_rounded,
    subtitle: 'Les cas publiés en premier',
  ),
  SortOptionSpec(
    value: CaseSortBy.alphabetical,
    label: 'Alphabétique (A → Z)',
    icon: Icons.sort_by_alpha_rounded,
    subtitle: 'Ordre du titre du cas',
  ),
  SortOptionSpec(
    value: CaseSortBy.durationAsc,
    label: 'Durée croissante',
    icon: Icons.timer_outlined,
    subtitle: 'Les plus courts d\'abord',
  ),
  SortOptionSpec(
    value: CaseSortBy.durationDesc,
    label: 'Durée décroissante',
    icon: Icons.timer_rounded,
    subtitle: 'Les plus longs d\'abord',
  ),
];

/// Ouvre la sheet et retourne le tri choisi (ou null si annulé).
Future<CaseSortBy?> showSortBottomSheet({
  required BuildContext context,
  required CaseSortBy current,
  List<SortOptionSpec> options = kSortOptions,
}) {
  return showModalBottomSheet<CaseSortBy>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _SortSheet(current: current, options: options),
  );
}

class _SortSheet extends StatelessWidget {
  const _SortSheet({required this.current, required this.options});

  final CaseSortBy current;
  final List<SortOptionSpec> options;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surface = CpTokens.surface(isDark);
    final onSurface = CpTokens.onSurface(isDark);
    final onSurfaceMuted = CpTokens.onSurfaceMuted(isDark);
    final outlineVariant = CpTokens.outlineVariant(isDark);

    return SafeArea(
      top: false,
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
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 44, height: 4,
              decoration: BoxDecoration(
                color: onSurfaceMuted.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                CpTokens.s6, CpTokens.s3, CpTokens.s6, CpTokens.s3,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.swap_vert_rounded,
                    color: onSurface,
                    size: 20,
                  ),
                  const SizedBox(width: CpTokens.s2),
                  Text(
                    'Trier par',
                    style: GoogleFonts.montserrat(
                      color: onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: outlineVariant),
            ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: CpTokens.s2),
              itemCount: options.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                thickness: 0.5,
                indent: CpTokens.s6,
                endIndent: CpTokens.s6,
                color: outlineVariant.withValues(alpha: 0.55),
              ),
              itemBuilder: (_, i) {
                final opt = options[i];
                final selected = opt.value == current;
                return _SortTile(
                  option: opt,
                  selected: selected,
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  accent: CpTokens.blueLight,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.of(context).pop(opt.value);
                  },
                );
              },
            ),
            const SizedBox(height: CpTokens.s2),
          ],
        ),
      ),
    );
  }
}

class _SortTile extends StatelessWidget {
  const _SortTile({
    required this.option,
    required this.selected,
    required this.accent,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.onTap,
  });

  final SortOptionSpec option;
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
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: selected ? 0.18 : 0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: Icon(option.icon, color: accent, size: 18),
              ),
              const SizedBox(width: CpTokens.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      style: GoogleFonts.montserrat(
                        color: onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (option.subtitle != null) ...[
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
              _RadioDot(selected: selected, accent: accent),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected, required this.accent});
  final bool selected;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: 22, height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? accent : Colors.transparent,
        border: Border.all(
          color: selected
              ? accent
              : Theme.of(context).colorScheme.outlineVariant,
          width: 1.6,
        ),
      ),
      child: selected
          ? Container(
              margin: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}
