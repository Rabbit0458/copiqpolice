// lib/ui/forum/forum_theme.dart
import 'package:flutter/material.dart';

/// ===========================================================================
/// ForumTheme — Thème "design-system" du forum
/// - Light/Dark auto (via Theme.of(context).brightness)
/// - Skins/variants (par grade/mode), sans dupliquer tout le code
/// - Utilisable partout: final t = ForumTheme.of(context);
/// ===========================================================================

enum ForumSkin { examGPX, policeAdjoint, gardienPaix, officier, commissaire }

@immutable
class ForumTheme extends ThemeExtension<ForumTheme> {
  const ForumTheme._({
    required this.skin,
    required this.isDark,

    // Base
    required this.bgTop,
    required this.bgBottom,
    required this.surface,
    required this.surface2,
    required this.surface3,
    required this.stroke,
    required this.strokeStrong,

    // Text
    required this.text,
    required this.textSoft,
    required this.textMuted,
    required this.textOnPrimary,

    // Brand / Accent
    required this.primary,
    required this.primary2,
    required this.primarySoft,
    required this.primaryStroke,

    // Status
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,

    // Components
    required this.cardShadow,
    required this.inputBg,
    required this.inputStroke,
    required this.chipBg,
    required this.chipText,
    required this.divider,
    required this.icon,
    required this.iconSoft,

    // Overlays / Modals
    required this.overlayScrim,
    required this.sheetBg,
    required this.glassBg,
    required this.glassStroke,
  });

  final ForumSkin skin;
  final bool isDark;

  // Base
  final Color bgTop;
  final Color bgBottom;
  final Color surface;
  final Color surface2;
  final Color surface3;
  final Color stroke;
  final Color strokeStrong;

  // Text
  final Color text;
  final Color textSoft;
  final Color textMuted;
  final Color textOnPrimary;

  // Brand
  final Color primary;
  final Color primary2;
  final Color primarySoft;
  final Color primaryStroke;

  // Status
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;

  // Components
  final List<BoxShadow> cardShadow;
  final Color inputBg;
  final Color inputStroke;
  final Color chipBg;
  final Color chipText;
  final Color divider;
  final Color icon;
  final Color iconSoft;

  // Overlays / Modals
  final Color overlayScrim;
  final Color sheetBg;
  final Color glassBg;
  final Color glassStroke;

  // ──────────────────────────────────────────────────────────────────────────
  // Public API
  // ──────────────────────────────────────────────────────────────────────────

  /// Le plus simple : ForumTheme.of(context)
  static ForumTheme of(
    BuildContext context, {
    ForumSkin skin = ForumSkin.examGPX,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? dark(skin) : light(skin);
  }

  /// Option plus propre si tu l’injectes dans ThemeData.extensions:
  static ForumTheme fromTheme(BuildContext context) {
    final ext = Theme.of(context).extension<ForumTheme>();
    if (ext != null) return ext;
    // fallback: si jamais pas injecté, on prend examGPX
    return of(context, skin: ForumSkin.examGPX);
  }

  static ForumTheme light(ForumSkin skin) => _build(skin: skin, isDark: false);
  static ForumTheme dark(ForumSkin skin) => _build(skin: skin, isDark: true);

  /// Gradient de fond (si tu veux un background premium)
  LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgTop, bgBottom],
  );

  /// Gradient subtil pour header / topbar
  LinearGradient get headerGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      bgTop.withValues(alpha: isDark ? 0.90 : 0.98),
      bgTop.withValues(alpha: isDark ? 0.55 : 0.75),
      Colors.transparent,
    ],
    stops: const [0.0, 0.55, 1.0],
  );

  /// Style input “pro”
  InputDecoration inputDecoration({
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: textMuted, fontWeight: FontWeight.w600),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: inputBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: inputStroke),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: inputStroke),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryStroke, width: 1.3),
      ),
    );
  }

  /// “Glass” style (AppNotifier / menus / sheet)
  BoxDecoration glassDecoration({double radius = 18}) => BoxDecoration(
    color: glassBg,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: glassStroke),
  );

  // ──────────────────────────────────────────────────────────────────────────
  // ThemeExtension plumbing
  // ──────────────────────────────────────────────────────────────────────────

  @override
  ForumTheme copyWith({
    ForumSkin? skin,
    bool? isDark,

    Color? bgTop,
    Color? bgBottom,
    Color? surface,
    Color? surface2,
    Color? surface3,
    Color? stroke,
    Color? strokeStrong,

    Color? text,
    Color? textSoft,
    Color? textMuted,
    Color? textOnPrimary,

    Color? primary,
    Color? primary2,
    Color? primarySoft,
    Color? primaryStroke,

    Color? success,
    Color? warning,
    Color? danger,
    Color? info,

    List<BoxShadow>? cardShadow,
    Color? inputBg,
    Color? inputStroke,
    Color? chipBg,
    Color? chipText,
    Color? divider,
    Color? icon,
    Color? iconSoft,

    Color? overlayScrim,
    Color? sheetBg,
    Color? glassBg,
    Color? glassStroke,
  }) {
    return ForumTheme._(
      skin: skin ?? this.skin,
      isDark: isDark ?? this.isDark,

      bgTop: bgTop ?? this.bgTop,
      bgBottom: bgBottom ?? this.bgBottom,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      surface3: surface3 ?? this.surface3,
      stroke: stroke ?? this.stroke,
      strokeStrong: strokeStrong ?? this.strokeStrong,

      text: text ?? this.text,
      textSoft: textSoft ?? this.textSoft,
      textMuted: textMuted ?? this.textMuted,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,

      primary: primary ?? this.primary,
      primary2: primary2 ?? this.primary2,
      primarySoft: primarySoft ?? this.primarySoft,
      primaryStroke: primaryStroke ?? this.primaryStroke,

      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,

      cardShadow: cardShadow ?? this.cardShadow,
      inputBg: inputBg ?? this.inputBg,
      inputStroke: inputStroke ?? this.inputStroke,
      chipBg: chipBg ?? this.chipBg,
      chipText: chipText ?? this.chipText,
      divider: divider ?? this.divider,
      icon: icon ?? this.icon,
      iconSoft: iconSoft ?? this.iconSoft,

      overlayScrim: overlayScrim ?? this.overlayScrim,
      sheetBg: sheetBg ?? this.sheetBg,
      glassBg: glassBg ?? this.glassBg,
      glassStroke: glassStroke ?? this.glassStroke,
    );
  }

  @override
  ForumTheme lerp(ThemeExtension<ForumTheme>? other, double t) {
    if (other is! ForumTheme) return this;
    Color lc(Color a, Color b) => Color.lerp(a, b, t)!;

    List<BoxShadow> lerpShadows(List<BoxShadow> a, List<BoxShadow> b) {
      // keep it simple: pick nearest (shadows don't lerp perfectly anyway)
      return t < 0.5 ? a : b;
    }

    return ForumTheme._(
      skin: t < 0.5 ? skin : other.skin,
      isDark: t < 0.5 ? isDark : other.isDark,

      bgTop: lc(bgTop, other.bgTop),
      bgBottom: lc(bgBottom, other.bgBottom),
      surface: lc(surface, other.surface),
      surface2: lc(surface2, other.surface2),
      surface3: lc(surface3, other.surface3),
      stroke: lc(stroke, other.stroke),
      strokeStrong: lc(strokeStrong, other.strokeStrong),

      text: lc(text, other.text),
      textSoft: lc(textSoft, other.textSoft),
      textMuted: lc(textMuted, other.textMuted),
      textOnPrimary: lc(textOnPrimary, other.textOnPrimary),

      primary: lc(primary, other.primary),
      primary2: lc(primary2, other.primary2),
      primarySoft: lc(primarySoft, other.primarySoft),
      primaryStroke: lc(primaryStroke, other.primaryStroke),

      success: lc(success, other.success),
      warning: lc(warning, other.warning),
      danger: lc(danger, other.danger),
      info: lc(info, other.info),

      cardShadow: lerpShadows(cardShadow, other.cardShadow),
      inputBg: lc(inputBg, other.inputBg),
      inputStroke: lc(inputStroke, other.inputStroke),
      chipBg: lc(chipBg, other.chipBg),
      chipText: lc(chipText, other.chipText),
      divider: lc(divider, other.divider),
      icon: lc(icon, other.icon),
      iconSoft: lc(iconSoft, other.iconSoft),

      overlayScrim: lc(overlayScrim, other.overlayScrim),
      sheetBg: lc(sheetBg, other.sheetBg),
      glassBg: lc(glassBg, other.glassBg),
      glassStroke: lc(glassStroke, other.glassStroke),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Builders (Palette pro)
  // ──────────────────────────────────────────────────────────────────────────

  static ForumTheme _build({required ForumSkin skin, required bool isDark}) {
    // Accent per skin: le "grade/mode" change l’identité sans casser la lisibilité
    final accent = _accentFor(skin, isDark: isDark);

    // Base neutrals (très premium)
    final bgTop = isDark ? const Color(0xFF0A0F1A) : const Color(0xFFF6F8FF);
    final bgBottom = isDark ? const Color(0xFF070A12) : const Color(0xFFFFFFFF);

    final surface = isDark ? const Color(0xFF121A2A) : const Color(0xFFFFFFFF);
    final surface2 = isDark ? const Color(0xFF0E1523) : const Color(0xFFF3F6FF);
    final surface3 = isDark ? const Color(0xFF0B1220) : const Color(0xFFEEF3FF);

    final stroke = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.black.withValues(alpha: 0.06);

    final strokeStrong = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.black.withValues(alpha: 0.10);

    final text = isDark ? const Color(0xFFEAF0FF) : const Color(0xFF0D1730);
    final textSoft = isDark ? const Color(0xFFC1CBE8) : const Color(0xFF3E4E79);
    final textMuted = isDark
        ? Colors.white.withValues(alpha: 0.62)
        : Colors.black.withValues(alpha: 0.44);

    final textOnPrimary = isDark ? const Color(0xFF061023) : Colors.white;

    // Primary set
    final primary = accent.primary;
    final primary2 = accent.primary2;

    final primarySoft = isDark
        ? _mix(primary, const Color(0xFF0B1220), 0.20) // “ink”
        : _mix(primary, Colors.white, 0.88);

    final primaryStroke = isDark
        ? _mix(primary, Colors.white, 0.28)
        : _mix(primary, const Color(0xFF0D1730), 0.12);

    // Status
    final success = isDark ? const Color(0xFF3BDB7C) : const Color(0xFF2F9E44);
    final warning = isDark ? const Color(0xFFFFB020) : const Color(0xFFF08C00);
    final danger = isDark ? const Color(0xFFFF5C5C) : const Color(0xFFE03131);
    final info = isDark ? const Color(0xFF62A8FF) : const Color(0xFF228BE6);

    // Shadow (pro: très léger en light, quasi invisible en dark)
    final cardShadow = isDark
        ? <BoxShadow>[
            BoxShadow(
              blurRadius: 22,
              offset: const Offset(0, 10),
              color: Colors.black.withValues(alpha: 0.38),
            ),
          ]
        : <BoxShadow>[
            BoxShadow(
              blurRadius: 22,
              offset: const Offset(0, 10),
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ];

    // Inputs / chips
    final inputBg = isDark ? const Color(0xFF0B1322) : const Color(0xFFF7F9FF);
    final inputStroke = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.10);

    final chipBg = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.05);
    final chipText = isDark ? textSoft : textSoft;

    final divider = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final icon = isDark ? const Color(0xFFDDE6FF) : const Color(0xFF132149);
    final iconSoft = isDark
        ? Colors.white.withValues(alpha: 0.70)
        : Colors.black.withValues(alpha: 0.52);

    // Overlays
    final overlayScrim = isDark
        ? Colors.black.withValues(alpha: 0.62)
        : Colors.black.withValues(alpha: 0.42);

    // Bottom sheets / modals
    final sheetBg = isDark ? const Color(0xFF0B1220) : const Color(0xFFFFFFFF);

    // Glass (Notifiers, menu cards)
    final glassBg = isDark
        ? Colors.black.withValues(alpha: 0.32)
        : Colors.white.withValues(alpha: 0.72);

    final glassStroke = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.black.withValues(alpha: 0.10);

    return ForumTheme._(
      skin: skin,
      isDark: isDark,

      bgTop: bgTop,
      bgBottom: bgBottom,
      surface: surface,
      surface2: surface2,
      surface3: surface3,
      stroke: stroke,
      strokeStrong: strokeStrong,

      text: text,
      textSoft: textSoft,
      textMuted: textMuted,
      textOnPrimary: textOnPrimary,

      primary: primary,
      primary2: primary2,
      primarySoft: primarySoft,
      primaryStroke: primaryStroke,

      success: success,
      warning: warning,
      danger: danger,
      info: info,

      cardShadow: cardShadow,
      inputBg: inputBg,
      inputStroke: inputStroke,
      chipBg: chipBg,
      chipText: chipText,
      divider: divider,
      icon: icon,
      iconSoft: iconSoft,

      overlayScrim: overlayScrim,
      sheetBg: sheetBg,
      glassBg: glassBg,
      glassStroke: glassStroke,
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Accent library (par grade/mode)
  // ──────────────────────────────────────────────────────────────────────────

  static _Accent _accentFor(ForumSkin skin, {required bool isDark}) {
    // Tu peux ajuster selon ton identité visuelle.
    // Très pro: accents pas trop saturés, lisibles en dark.
    switch (skin) {
      case ForumSkin.examGPX:
        return _Accent(
          primary: isDark ? const Color(0xFF7AA2FF) : const Color(0xFF2F6BFF),
          primary2: isDark ? const Color(0xFF9A7BFF) : const Color(0xFF6A4CFF),
        );
      case ForumSkin.policeAdjoint:
        return _Accent(
          primary: isDark ? const Color(0xFF66D9FF) : const Color(0xFF0088CC),
          primary2: isDark ? const Color(0xFF79FFA8) : const Color(0xFF14B86B),
        );
      case ForumSkin.gardienPaix:
        return _Accent(
          primary: isDark ? const Color(0xFFFFC86B) : const Color(0xFFFFA000),
          primary2: isDark ? const Color(0xFFFF7AA8) : const Color(0xFFE91E63),
        );
      case ForumSkin.officier:
        return _Accent(
          primary: isDark ? const Color(0xFF77F0D1) : const Color(0xFF10B981),
          primary2: isDark ? const Color(0xFF79A9FF) : const Color(0xFF2563EB),
        );
      case ForumSkin.commissaire:
        return _Accent(
          primary: isDark ? const Color(0xFFFF8D8D) : const Color(0xFFEF4444),
          primary2: isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
        );
    }
  }
}

/// Petit conteneur accent
@immutable
class _Accent {
  final Color primary;
  final Color primary2;
  const _Accent({required this.primary, required this.primary2});
}

/// Utilitaire: mix de 2 couleurs (ratio = part de "b")
Color _mix(Color a, Color b, double ratio) {
  ratio = ratio.clamp(0.0, 1.0);
  final ar = a.red, ag = a.green, ab = a.blue, aa = a.alpha;
  final br = b.red, bg = b.green, bb = b.blue, ba = b.alpha;

  int lerpInt(int x, int y) => (x + (y - x) * ratio).round();

  return Color.fromARGB(
    lerpInt(aa, ba),
    lerpInt(ar, br),
    lerpInt(ag, bg),
    lerpInt(ab, bb),
  );
}

/// ===========================================================================
/// Helpers pratiques (lisibilité dans le code UI)
/// ===========================================================================

extension ForumThemeX on BuildContext {
  /// Récupère l'extension si injectée, sinon fallback auto
  ForumTheme get forum => ForumTheme.fromTheme(this);
}

/// ===========================================================================
/// Optionnel: injection dans ThemeData (recommandé)
/// - Tu peux mettre ça dans ton MaterialApp theme/darkTheme
/// ===========================================================================

ThemeData buildLightThemeWithForum({ForumSkin skin = ForumSkin.examGPX}) {
  return ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    extensions: <ThemeExtension<dynamic>>[ForumTheme.light(skin)],
  );
}

ThemeData buildDarkThemeWithForum({ForumSkin skin = ForumSkin.examGPX}) {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    extensions: <ThemeExtension<dynamic>>[ForumTheme.dark(skin)],
  );
}
