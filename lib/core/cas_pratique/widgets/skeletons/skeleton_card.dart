// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — SkeletonCard + SkeletonListTile                ║
// ║  Tâche      : CODE-067                                                  ║
// ║                                                                         ║
// ║  Patterns de skeleton premium prêts à l'emploi pour les écrans         ║
// ║  liste/details du module cas pratique.                                  ║
// ║                                                                         ║
// ║  - `SkeletonCard` : avatar/numéro + titre + sous-titre + pills          ║
// ║  - `SkeletonListTile` : avatar + 2 lignes (style ListTile classique)    ║
// ║  - `SkeletonHero` : skeleton plein écran avec halo (page de détail)     ║
// ║                                                                         ║
// ║  Tous wrapped dans un `SkeletonShimmer` au call-site, ou peuvent       ║
// ║  être utilisés en standalone (l'absence du shimmer parent affichera   ║
// ║  un rectangle statique — gracieux).                                    ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';

import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';
import 'package:copiqpolice/core/cas_pratique/widgets/skeletons/skeleton_box.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key, this.height = 132});
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: CpTokens.surface(isDark),
        borderRadius: BorderRadius.circular(CpTokens.r3),
        border: Border.all(color: CpTokens.outlineVariant(isDark)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 44, height: 44, radius: 12),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: double.infinity, height: 14),
                    SizedBox(height: 8),
                    SkeletonBox(width: 90, height: 10),
                  ],
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              SkeletonBox(width: 70, height: 22, radius: 999),
              SizedBox(width: 8),
              SkeletonBox(width: 62, height: 22, radius: 999),
              SizedBox(width: 8),
              SkeletonBox(width: 78, height: 22, radius: 999),
            ],
          ),
        ],
      ),
    );
  }
}

class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({
    super.key,
    this.avatarSize = 40,
    this.height = 64,
  });
  final double avatarSize;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: CpTokens.surface(isDark),
        borderRadius: BorderRadius.circular(CpTokens.r3),
        border: Border.all(color: CpTokens.outlineVariant(isDark)),
      ),
      child: Row(
        children: [
          SkeletonCircle(size: avatarSize),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 180, height: 12),
                SizedBox(height: 8),
                SkeletonBox(width: 110, height: 10),
              ],
            ),
          ),
          const SkeletonBox(width: 32, height: 18, radius: 6),
        ],
      ),
    );
  }
}

class SkeletonHero extends StatelessWidget {
  const SkeletonHero({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 28, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SkeletonBox(width: 200, height: 26, radius: 10),
          SizedBox(height: 12),
          SkeletonBox(width: 140, height: 14),
          SizedBox(height: 30),
          SkeletonBox(height: 18),
          SizedBox(height: 8),
          SkeletonBox(height: 18),
          SizedBox(height: 8),
          SkeletonBox(width: 240, height: 18),
          SizedBox(height: 28),
          SkeletonBox(height: 56, radius: 16),
        ],
      ),
    );
  }
}
