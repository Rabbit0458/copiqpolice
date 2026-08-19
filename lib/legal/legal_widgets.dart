// lib/legal/legal_widgets.dart
//
// Tuile + section réutilisables pour le Centre juridique. Design "carte
// moderne" : icônes en dégradé, ripple correctement clippé, ombre douce,
// cohérent clair/sombre via les couleurs du thème (pas de valeur en dur).

import 'package:flutter/material.dart';

class LegalSection extends StatelessWidget {
  final String title;
  final IconData? icon;
  final List<Widget> children;

  const LegalSection({
    super.key,
    required this.title,
    this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14, color: t.colorScheme.primary),
                  const SizedBox(width: 6),
                ],
                Text(
                  title.toUpperCase(),
                  style: t.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    color: t.hintColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: t.cardColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: .06)
                    : Colors.black.withValues(alpha: .05),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? .18 : .04),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class LegalSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool showDivider;

  const LegalSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDestructive = false,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;
    final destructiveColor = t.colorScheme.error;
    final accent = isDestructive ? destructiveColor : t.colorScheme.primary;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          accent.withValues(alpha: isDark ? .22 : .14),
                          accent.withValues(alpha: isDark ? .10 : .06),
                        ],
                      ),
                    ),
                    child: Icon(icon, color: accent, size: 21),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                            color: isDestructive ? destructiveColor : null,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: t.textTheme.bodySmall?.copyWith(
                              color: t.hintColor,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? Colors.white.withValues(alpha: .06)
                          : Colors.black.withValues(alpha: .04),
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 17,
                      color: t.hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Divider(
              height: 1,
              color: t.dividerColor.withValues(alpha: .25),
            ),
          ),
      ],
    );
  }
}
