// lib/ui/app_notifier.dart
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ===========================================================================
/// AppSettingsController — Source UNIQUE des préférences UI globales
/// - Thème (ThemeMode) — défaut: light
/// - Hauteur de la bottom bar (persistée)
/// ===========================================================================
class AppSettingsController {
  AppSettingsController._();
  static final AppSettingsController I = AppSettingsController._();

  // ---- Thème
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(
    ThemeMode.light, // ✅ défaut clair
  );
  static const _kThemeKey = 'app_theme_mode'; // 'light' | 'dark' | 'system'

  // ---- Bottom bar height
  final ValueNotifier<double> bottomBarHeight = ValueNotifier<double>(56);
  static const _kBottomBarKey = 'ui_bottom_bar_height';

  bool _loaded = false;

  /// Charge toutes les préférences persistées (idempotent).
  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;

    final prefs = await SharedPreferences.getInstance();

    // Thème
    switch (prefs.getString(_kThemeKey)) {
      case 'dark':
        themeMode.value = ThemeMode.dark;
        break;
      case 'system':
        themeMode.value = ThemeMode.system;
        break;
      case 'light':
      default:
        themeMode.value = ThemeMode.light;
    }

    // Bottom bar
    final h = prefs.getDouble(_kBottomBarKey);
    if (h != null) {
      bottomBarHeight.value = h.clamp(44, 68).toDouble();
    }
  }

  /// Applique un thème (et persiste) — notifie immédiatement.
  Future<void> setTheme(ThemeMode mode) async {
    themeMode.value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeKey, switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
      _ => 'light',
    });
  }

  /// Compat: alias pour les anciens écrans
  Future<void> setThemeMode(ThemeMode mode) => setTheme(mode);

  /// Applique une hauteur de bottom bar (et persiste).
  Future<void> setBottomBarHeight(double h) async {
    final clamped = h.clamp(44, 68).toDouble();
    bottomBarHeight.value = clamped;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kBottomBarKey, clamped);
  }
}

/// Extension compat : si certains écrans appellent `init()` au lieu de `load()`
extension AppSettingsInitCompat on AppSettingsController {
  Future<void> init() => load();
}

/// ===========================================================================
/// AppNotifier — Bannière iOS-like (toasts superposés via Overlay)
/// ===========================================================================
class AppNotifier {
  AppNotifier._();

  static OverlayEntry? _entry;
  static Timer? _timer;

  static const Duration _kDefaultDuration = Duration(seconds: 3);

  static const _success = _NotifStyle(
    circleColor: Color(0xFF2F9E44),
    icon: Icons.check_rounded,
  );
  static const _error = _NotifStyle(
    circleColor: Color(0xFFE03131),
    icon: Icons.close_rounded,
  );
  static const _info = _NotifStyle(
    circleColor: Color(0xFF228BE6),
    icon: Icons.info_rounded,
  );
  static const _warning = _NotifStyle(
    circleColor: Color(0xFFF08C00),
    icon: Icons.priority_high_rounded,
  );

  static void success(
    BuildContext context, {
    required String title,
    String message = '',
    Duration? duration = _kDefaultDuration,
  }) {
    _showInternal(
      context,
      title: title,
      message: message,
      style: _success,
      duration: duration,
    );
  }

  static void error(
    BuildContext context, {
    required String title,
    String message = '',
    Duration? duration = _kDefaultDuration,
  }) {
    _showInternal(
      context,
      title: title,
      message: message,
      style: _error,
      duration: duration,
    );
  }

  static void info(
    BuildContext context, {
    required String title,
    String message = '',
    Duration? duration = _kDefaultDuration,
  }) {
    _showInternal(
      context,
      title: title,
      message: message,
      style: _info,
      duration: duration,
    );
  }

  static void warning(
    BuildContext context, {
    required String title,
    String message = '',
    Duration? duration = _kDefaultDuration,
  }) {
    _showInternal(
      context,
      title: title,
      message: message,
      style: _warning,
      duration: duration,
    );
  }

  /// Version générique (avec leading custom optionnel)
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    Widget? leading,
    Duration? duration = _kDefaultDuration,
  }) {
    _showInternal(
      context,
      title: title,
      message: message,
      style: _info,
      duration: duration,
      customLeading: leading,
    );
  }

  static void subscriptionRequired(BuildContext context) {
    error(
      context,
      title: 'Abonnement requis',
      message: 'Vous devez être abonné pour accéder à ce module.',
    );
  }

  static void _showInternal(
    BuildContext context, {
    required String title,
    required String message,
    required _NotifStyle style,
    Duration? duration,
    Widget? customLeading,
  }) {
    _dismiss();

    final overlay = Overlay.of(context, rootOverlay: true);
    if (overlay == null) return;

    _entry = OverlayEntry(
      builder: (_) => _NotifierBanner(
        title: title,
        message: message,
        leading:
            customLeading ??
            _CircleIcon(color: style.circleColor, icon: style.icon),
        onClose: _dismiss,
      ),
    );

    overlay.insert(_entry!);
    if (duration != null) {
      _timer = Timer(duration, _dismiss);
    }
  }

  static void _dismiss() {
    _timer?.cancel();
    _timer = null;
    try {
      _entry?.remove();
    } catch (_) {}
    _entry = null;
  }
}

class _NotifStyle {
  final Color circleColor;
  final IconData icon;
  const _NotifStyle({required this.circleColor, required this.icon});
}

class _CircleIcon extends StatelessWidget {
  final Color color;
  final IconData icon;
  const _CircleIcon({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: SizedBox(
        width: 26,
        height: 26,
        child: Center(child: Icon(icon, size: 18, color: Colors.white)),
      ),
    );
  }
}

class _NotifierBanner extends StatefulWidget {
  final String title;
  final String message;
  final Widget leading;
  final VoidCallback onClose;

  const _NotifierBanner({
    required this.title,
    required this.message,
    required this.leading,
    required this.onClose,
  });

  @override
  State<_NotifierBanner> createState() => _NotifierBannerState();
}

class _NotifierBannerState extends State<_NotifierBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 220),
    )..forward();

    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    await _ctrl.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    final safeTop = paddingTop == 0 ? 12.0 : paddingTop + 8.0;

    final bg = Colors.black.withValues(alpha: 0.38);
    final stroke = Colors.white.withValues(alpha: 0.08);

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: Stack(
          children: [
            Positioned(
              top: safeTop,
              left: 12,
              right: 12,
              child: SlideTransition(
                position: _slide,
                child: FadeTransition(
                  opacity: _fade,
                  child: Material(
                    type: MaterialType.transparency,
                    child: GestureDetector(
                      onVerticalDragUpdate: (d) {
                        if (d.primaryDelta != null && d.primaryDelta! < -6) {
                          _close();
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: stroke),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 14,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 3.0,
                                    right: 10,
                                  ),
                                  child: widget.leading,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                        ),
                                      ),
                                      if (widget.message.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          widget.message,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 
                                              0.92,
                                            ),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            height: 1.25,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: _close,
                                  child: const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
