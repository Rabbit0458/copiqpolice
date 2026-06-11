/// COP'IQ — Language switcher widget (settings page)
///
/// Usage:
///   // In your settings page:
///   const CpLanguageSwitcher()
///
/// Or inline:
///   CpLanguageSwitcherTile()   ← ListTile variant (settings list)
///   CpLanguageSwitcherChips()  ← Compact chips variant (bottom of a sheet)

library cp_language_switcher;


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:copiqpolice/core/cas_pratique/i18n/cp_l10n.dart';
import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';

// ─── Standalone dialog ────────────────────────────────────────────────────

/// Shows a bottom sheet to pick a language.
Future<void> showLanguageSwitcherSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _LanguageSwitcherSheet(),
  );
}

// ─── ListTile variant (drop into a SettingsPage ListView) ─────────────────

class CpLanguageSwitcherTile extends StatelessWidget {
  const CpLanguageSwitcherTile({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListenableBuilder(
      listenable: CpLocaleService.instance,
      builder: (context, _) {
        final l = CpL10n.of(context);
        final langCode = CpLocaleService.instance.locale.languageCode;
        final langLabel = langCode == 'en' ? l.langSwitcherEn : l.langSwitcherFr;
        return ListTile(
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: CpTokens.brandFor(isDark).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.language_rounded,
              color: CpTokens.brandFor(isDark),
              size: 20,
            ),
          ),
          title: Text(
            l.langSwitcherTitle,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: CpTokens.onSurface(isDark),
            ),
          ),
          subtitle: Text(
            l.langSwitcherSubtitle(langLabel),
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              color: CpTokens.onSurface(isDark).withValues(alpha: 0.60),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: CpTokens.onSurface(isDark).withValues(alpha: 0.40),
          ),
          onTap: () => showLanguageSwitcherSheet(context),
        );
      },
    );
  }
}

// ─── Chip row (compact — inline in a screen) ──────────────────────────────

class CpLanguageSwitcherChips extends StatelessWidget {
  const CpLanguageSwitcherChips({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListenableBuilder(
      listenable: CpLocaleService.instance,
      builder: (context, _) {
        final current = CpLocaleService.instance.locale;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: kCpSupportedLocales.map((locale) {
            final isActive = locale == current;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () async {
                  HapticFeedback.selectionClick();
                  await CpLocaleService.instance.setLocale(locale);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? CpTokens.brandFor(isDark)
                        : CpTokens.surface(isDark),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive
                          ? CpTokens.brandFor(isDark)
                          : CpTokens.outline(isDark),
                      width: 1.5,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: CpTokens.brandFor(isDark).withValues(alpha: 0.30),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Text(
                    locale.languageCode == 'fr' ? '🇫🇷 FR' : '🇬🇧 EN',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? Colors.white
                          : CpTokens.onSurface(isDark),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// ─── Full bottom sheet ────────────────────────────────────────────────────

class _LanguageSwitcherSheet extends StatelessWidget {
  const _LanguageSwitcherSheet();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = CpL10n.of(context);
    return Container(
      decoration: BoxDecoration(
        color: CpTokens.surface(isDark),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: CpTokens.outline(isDark),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                Icon(Icons.language_rounded, color: CpTokens.brandFor(isDark), size: 22),
                const SizedBox(width: 10),
                Text(
                  l.langSwitcherTitle,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: CpTokens.onSurface(isDark),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close_rounded,
                      color: CpTokens.onSurface(isDark).withValues(alpha: 0.50)),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: l.close,
                ),
              ],
            ),
          ),
          // Language options
          ListenableBuilder(
            listenable: CpLocaleService.instance,
            builder: (context, _) {
              final current = CpLocaleService.instance.locale;
              return Column(
                children: kCpSupportedLocales.map((locale) {
                  final isActive = locale == current;
                  final label = locale.languageCode == 'fr'
                      ? l.langSwitcherFr
                      : l.langSwitcherEn;
                  final flag = locale.languageCode == 'fr' ? '🇫🇷' : '🇬🇧';
                  return _LangTile(
                    flag: flag,
                    label: label,
                    isActive: isActive,
                    isDark: isDark,
                    onTap: () async {
                      HapticFeedback.selectionClick();
                      await CpLocaleService.instance.setLocale(locale);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _LangTile extends StatelessWidget {
  final String flag;
  final String label;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _LangTile({
    required this.flag,
    required this.label,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isActive
                ? CpTokens.brandFor(isDark).withValues(alpha: 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isActive
                ? Border.all(color: CpTokens.brandFor(isDark), width: 1.5)
                : Border.all(color: CpTokens.outline(isDark), width: 1),
          ),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? CpTokens.brandFor(isDark)
                        : CpTokens.onSurface(isDark),
                  ),
                ),
              ),
              if (isActive)
                Icon(Icons.check_circle_rounded,
                    color: CpTokens.brandFor(isDark), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
