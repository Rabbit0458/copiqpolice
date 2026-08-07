// lib/home/parametre_home.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart'; // AppNotifier + AppSettingsController
import 'package:copiqpolice/features/forum/community_models.dart';
import 'package:copiqpolice/features/forum/community_repository.dart';
import 'package:copiqpolice/features/forum/community_notification_service.dart';

// ---- Style helpers
const double _r16 = 16;
BoxShadow get _cardShadow => BoxShadow(
  color: const Color(0xFF000000).withValues(alpha: 0.10),
  blurRadius: 16,
  offset: const Offset(0, 8),
);

class ParametreHomePage extends StatefulWidget {
  static const routeName = '/parametre_home';
  const ParametreHomePage({super.key});

  @override
  State<ParametreHomePage> createState() => _ParametreHomePageState();
}

class _ParametreHomePageState extends State<ParametreHomePage> {
  final ctrl = AppSettingsController.I;
  final _communityRepository = CommunityRepository();
  late Future<CommunityNotificationPreferences> _communityPreferences =
      _communityRepository.notificationPreferences();
  bool _savingCommunityPreferences = false;

  Future<void> _saveCommunityPreferences(
    CommunityNotificationPreferences value,
  ) async {
    if (_savingCommunityPreferences) return;
    setState(() {
      _savingCommunityPreferences = true;
      _communityPreferences = Future.value(value);
    });
    try {
      if (value.enabled) {
        final allowed = await CommunityNotificationService.I
            .requestPermission();
        if (!allowed && mounted) {
          AppNotifier.info(
            context,
            title: 'Autorisation nécessaire',
            message:
                'Active les notifications dans les réglages du téléphone pour recevoir les alertes.',
          );
        }
      }
      await _communityRepository.updateNotificationPreferences(value);
    } catch (_) {
      if (mounted) {
        setState(
          () => _communityPreferences = _communityRepository
              .notificationPreferences(),
        );
        AppNotifier.error(
          context,
          title: 'Préférences non enregistrées',
          message: 'Réessaie dans quelques instants.',
        );
      }
    } finally {
      if (mounted) setState(() => _savingCommunityPreferences = false);
    }
  }

  /// Applique immédiatement (UI instantanée via ValueNotifier) + persiste.
  Future<void> _applyAndToast(ThemeMode mode) async {
    // Haptique puis mise à jour/persistance via TON contrôleur (qui notifie tout de suite).
    HapticFeedback.lightImpact();
    await ctrl.setTheme(mode);

    if (!mounted) return;
    AppNotifier.success(
      context,
      title: 'Thème appliqué',
      message: switch (mode) {
        ThemeMode.dark => 'Mode sombre activé',
        ThemeMode.light => 'Mode clair activé',
        _ => 'Thème système activé',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          children: [
            // ============ Header ============
            Row(
              children: [
                _BackButtonMinimal(
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Paramètres',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
            const SizedBox(height: 22),

            // ============ Apparence ============
            Text(
              'Apparence',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),

            // 👉 On écoute le notifier pour afficher l’état "Actif" en live.
            ValueListenableBuilder<ThemeMode>(
              valueListenable: ctrl.themeMode,
              builder: (context, current, _) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(_r16),
                    boxShadow: [_cardShadow],
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: .10),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ThemePreviewCard(
                          label: 'Clair',
                          icon: Icons.wb_sunny_rounded,
                          dark: false,
                          selected: current == ThemeMode.light,
                          onTap: () => _applyAndToast(ThemeMode.light),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ThemePreviewCard(
                          label: 'Sombre',
                          icon: Icons.nightlight_round_rounded,
                          dark: true,
                          selected: current == ThemeMode.dark,
                          onTap: () => _applyAndToast(ThemeMode.dark),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            // ============ Notifications communautaires ============
            Text(
              'Notifications',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder<CommunityNotificationPreferences>(
              future: _communityPreferences,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    height: 112,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(_r16),
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: .10),
                      ),
                    ),
                    child: const CircularProgressIndicator(),
                  );
                }
                final preferences = snapshot.data!;
                return Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(_r16),
                    boxShadow: [_cardShadow],
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: .10),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Semantics(
                        label: 'Mettre toutes les notifications en sourdine',
                        child: SwitchListTile.adaptive(
                          secondary: Icon(
                            preferences.enabled
                                ? Icons.notifications_active_outlined
                                : Icons.notifications_off_outlined,
                          ),
                          title: const Text('Alertes communautaires'),
                          subtitle: Text(
                            preferences.enabled
                                ? 'Bannières et sons activés'
                                : 'Sourdine activée',
                          ),
                          value: preferences.enabled,
                          onChanged: _savingCommunityPreferences
                              ? null
                              : (enabled) => _saveCommunityPreferences(
                                  CommunityNotificationPreferences(
                                    enabled: enabled,
                                    messagesEnabled:
                                        preferences.messagesEnabled,
                                    forumEnabled: preferences.forumEnabled,
                                  ),
                                ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        indent: 58,
                        color: theme.dividerColor.withValues(alpha: .12),
                      ),
                      SwitchListTile.adaptive(
                        secondary: const Icon(
                          Icons.chat_bubble_outline_rounded,
                        ),
                        title: const Text('Messages privés'),
                        subtitle: const Text('Alerte quand un membre t’écrit'),
                        value: preferences.messagesEnabled,
                        onChanged:
                            !preferences.enabled || _savingCommunityPreferences
                            ? null
                            : (enabled) => _saveCommunityPreferences(
                                CommunityNotificationPreferences(
                                  enabled: preferences.enabled,
                                  messagesEnabled: enabled,
                                  forumEnabled: preferences.forumEnabled,
                                ),
                              ),
                      ),
                      SwitchListTile.adaptive(
                        secondary: const Icon(Icons.forum_outlined),
                        title: const Text('Activité du forum'),
                        subtitle: const Text('Réponses et réactions'),
                        value: preferences.forumEnabled,
                        onChanged:
                            !preferences.enabled || _savingCommunityPreferences
                            ? null
                            : (enabled) => _saveCommunityPreferences(
                                CommunityNotificationPreferences(
                                  enabled: preferences.enabled,
                                  messagesEnabled: preferences.messagesEnabled,
                                  forumEnabled: enabled,
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 2, 16, 14),
                        child: Text(
                          'La sourdine coupe les alertes, mais conserve les activités dans le centre de notifications.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            // ============ Barre de navigation ============
            Text(
              'Barre de navigation',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(_r16),
                boxShadow: [_cardShadow],
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: .10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Taille de la barre'),
                    subtitle: Text('Ajustez la compacité de la bottom bar'),
                  ),
                  ValueListenableBuilder<double>(
                    valueListenable: ctrl.bottomBarHeight,
                    builder: (context, value, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Slider(
                          min: 44,
                          max: 68,
                          divisions: 12,
                          value: value.clamp(44, 68),
                          label: '${value.toStringAsFixed(0)} px',
                          onChanged: (v) => ctrl.setBottomBarHeight(v),
                          onChangeEnd: (_) {
                            HapticFeedback.selectionClick();
                            AppNotifier.info(
                              context,
                              title: 'Barre mise à jour',
                              message:
                                  'Hauteur : ${value.toStringAsFixed(0)} px',
                            );
                          },
                        ),
                        Text(
                          'Hauteur : ${value.toStringAsFixed(0)} px',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Container(
                            height: value,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: .08)
                                  : theme.colorScheme.onSurface.withValues(
                                      alpha: .90,
                                    ),
                              borderRadius: BorderRadius.circular(value / 2),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: .10)
                                    : Colors.black.withValues(alpha: .06),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _PreviewDot(selected: true),
                                SizedBox(width: 12),
                                _PreviewDot(),
                                SizedBox(width: 12),
                                _PreviewDot(),
                                SizedBox(width: 12),
                                _PreviewDot(),
                                SizedBox(width: 12),
                                _PreviewDot(),
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
          ],
        ),
      ),
    );
  }
}

// =============== Bouton retour minimaliste ===============
class _BackButtonMinimal extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButtonMinimal({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [_cardShadow],
          border: Border.all(color: theme.dividerColor.withValues(alpha: .10)),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          color: isDark ? Colors.white : const Color(0xFF212529),
        ),
      ),
    );
  }
}

// =============== Carte d’aperçu de thème ===============
class _ThemePreviewCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool dark;
  final bool selected;
  final VoidCallback onTap;

  const _ThemePreviewCard({
    required this.label,
    required this.icon,
    required this.dark,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    // Couleurs de preview (maquette)
    final Color phoneBg = dark
        ? const Color(0xFF111316)
        : const Color(0xFFF7F7F9);
    final Color bar = dark ? const Color(0xFF1C1F23) : Colors.white;
    final Color block = dark
        ? const Color(0xFF22262B)
        : const Color(0xFFF0F1F3);
    final Color text = dark ? Colors.white : const Color(0xFF212529);

    final Color borderC = selected
        ? t.colorScheme.primary
        : t.dividerColor.withValues(alpha: .25);

    final BoxShadow glow = BoxShadow(
      color: selected
          ? t.colorScheme.primary.withValues(alpha: .35)
          : Colors.transparent,
      blurRadius: selected ? 18 : 0,
      spreadRadius: selected ? 1 : 0,
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderC, width: selected ? 2 : 1),
          boxShadow: [_cardShadow, glow],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 9 / 16,
              child: Container(
                decoration: BoxDecoration(
                  color: phoneBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Container(
                      height: 18,
                      decoration: BoxDecoration(
                        color: bar,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Column(
                        children: [
                          _blockRow(block),
                          const SizedBox(height: 6),
                          _blockRow(block, short: true),
                          const Spacer(),
                          Container(
                            height: 22,
                            decoration: BoxDecoration(
                              color: bar,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _dot(text, selected: true),
                                _dot(text),
                                _dot(text),
                                _dot(text),
                                _dot(text),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: text),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: t.textTheme.bodyMedium?.color,
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: t.colorScheme.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Actif',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _blockRow(Color block, {bool short = false}) {
    return Row(
      children: [
        Expanded(
          flex: short ? 2 : 3,
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              color: block,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          flex: short ? 3 : 2,
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              color: block,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _dot(Color c, {bool selected = false}) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: selected ? c : c.withValues(alpha: .35),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _PreviewDot extends StatelessWidget {
  final bool selected;
  const _PreviewDot({this.selected = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      alignment: Alignment.center,
      children: [
        if (selected)
          const CircleAvatar(radius: 18, backgroundColor: Colors.white),
        Icon(
          Icons.circle,
          size: 18,
          color: selected
              ? (isDark ? Colors.black : const Color(0xFF212529))
              : (isDark ? Colors.white : Colors.white),
        ),
      ],
    );
  }
}
