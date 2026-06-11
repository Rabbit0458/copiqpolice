// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Design Tokens                                 ║
// ║  Référence : docs/cas_pratique/05_DESIGN_SYSTEM.md (section 10)         ║
// ║  Tâche      : CODE-009                                                  ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';

/// Tokens centraux du module Cas Pratique.
///
/// **Règles d'usage** :
/// - Ne JAMAIS hardcoder une couleur ou un spacing dans une page → utiliser ces tokens.
/// - Toute nouvelle couleur passe d'abord par une discussion design (cf. 05_DESIGN_SYSTEM.md).
/// - Light vs Dark : utiliser les variantes suffixées `Light` / `Dark`.
class CpTokens {
  CpTokens._(); // pas d'instanciation

  // ─── Brand (cohérence avec le reste de COP'IQ) ──────────────────────────
  static const Color blueLight     = Color(0xFF1147D9);
  static const Color blueMidLight  = Color(0xFF1A55E6);
  static const Color blueDeepLight = Color(0xFF0E2F9E);

  /// Alias canonical — couleur brand principale (light = blueLight).
  /// CODE-092 : ajouté pour unifier les références sans hardcoder la valeur.
  static const Color brand = blueLight;

  /// Retourne la couleur brand adaptée au thème courant.
  static Color brandFor(bool isDark) => isDark ? blueMidLight : blueLight;

  static const Color darkNavy      = Color(0xFF000B36);
  static const Color darkNavyMid   = Color(0xFF000A33);
  static const Color darkNavyDeep  = Color(0xFF00082D);

  // ─── Surfaces ───────────────────────────────────────────────────────────
  static const Color surfaceLight             = Color(0xFFFFFFFF);
  static const Color surfaceContainerLight    = Color(0xFFF4F6FB);
  static const Color surfaceContainerHiLight  = Color(0xFFEAEEF7);
  static const Color outlineLight             = Color(0xFFD5DBE8);
  static const Color outlineVariantLight      = Color(0xFFE7EBF3);

  static const Color surfaceDark              = Color(0xFF0B102A);
  static const Color surfaceContainerDark     = Color(0xFF0F1438);
  static const Color surfaceContainerHiDark   = Color(0xFF13193F);
  static const Color outlineDark              = Color(0xFF1F2A52);
  static const Color outlineVariantDark       = Color(0xFF1A2050);

  // ─── AMOLED (CODE-068) — pur noir + surfaces très sombres ───────────────
  // Économise la batterie sur écrans OLED (pixels #000 = pixel éteint).
  static const Color surfaceAmoled            = Color(0xFF000000);
  static const Color surfaceContainerAmoled   = Color(0xFF050505);
  static const Color surfaceContainerHiAmoled = Color(0xFF0A0A0A);
  static const Color outlineAmoled            = Color(0xFF1A1A1A);
  static const Color outlineVariantAmoled     = Color(0xFF111111);
  static const Color darkNavyAmoled           = Color(0xFF000000);
  static const Color darkNavyMidAmoled        = Color(0xFF000000);
  static const Color darkNavyDeepAmoled       = Color(0xFF000000);

  // ─── Texte ──────────────────────────────────────────────────────────────
  static const Color onSurfaceLight       = Color(0xFF0F172A);
  static const Color onSurfaceMutedLight  = Color(0xFF475569);
  static const Color onSurfaceFaintLight  = Color(0xFF94A3B8);

  static const Color onSurfaceDark        = Color(0xFFF8FAFC);
  static const Color onSurfaceMutedDark   = Color(0xFF94A3B8);
  static const Color onSurfaceFaintDark   = Color(0xFF64748B);

  // ─── Sémantique correction ──────────────────────────────────────────────
  static const Color success      = Color(0xFF22C55E);
  static const Color successDark  = Color(0xFF34D399);
  static const Color successSoftL = Color(0xFFDCFCE7);
  static const Color successSoftD = Color(0xFF022C22);

  static const Color warning      = Color(0xFFF59E0B);
  static const Color warningDark  = Color(0xFFFBBF24);
  static const Color warningSoftL = Color(0xFFFEF3C7);
  static const Color warningSoftD = Color(0xFF451A03);

  static const Color danger       = Color(0xFFEF4444);
  static const Color dangerDark   = Color(0xFFF87171);
  static const Color dangerSoftL  = Color(0xFFFEE2E2);
  static const Color dangerSoftD  = Color(0xFF450A0A);

  static const Color info         = Color(0xFF0EA5E9);
  static const Color infoDark     = Color(0xFF38BDF8);
  static const Color infoSoftL    = Color(0xFFE0F2FE);
  static const Color infoSoftD    = Color(0xFF082F49);

  // ─── Couleurs par thème (mapping slug → couleur) ────────────────────────
  static const Map<String, Color> themeColors = {
    'accueil':           Color(0xFF1147D9),
    'deontologie':       Color(0xFF0EA5E9),
    'cadre_legal':       Color(0xFF22C55E),
    'securite_publique': Color(0xFFF59E0B),
    'intervention':      Color(0xFFEF4444),
    'famille_mineur':    Color(0xFFA855F7),
    'routier':           Color(0xFF06B6D4),
  };

  // ─── Spacings ───────────────────────────────────────────────────────────
  static const double s1 = 4.0;
  static const double s2 = 8.0;
  static const double s3 = 12.0;
  static const double s4 = 14.0;
  static const double s5 = 16.0;
  static const double s6 = 20.0;
  static const double s7 = 24.0;
  static const double s8 = 32.0;

  // ─── Radii ──────────────────────────────────────────────────────────────
  static const double r1 = 8.0;
  static const double r2 = 12.0;
  static const double r3 = 16.0;
  static const double r4 = 18.0;
  static const double r5 = 20.0;
  static const double r6 = 24.0;
  static const double rPill = 999.0;

  // ─── Durées d'animation ─────────────────────────────────────────────────
  static const Duration animFast       = Duration(milliseconds: 120);
  static const Duration animMedium     = Duration(milliseconds: 280);
  static const Duration animPage       = Duration(milliseconds: 320);
  static const Duration animScore      = Duration(milliseconds: 1200);
  static const Duration animConfetti   = Duration(milliseconds: 3000);

  // ─── Helpers contextuels ────────────────────────────────────────────────
  static Color surface(bool isDark)         => isDark ? surfaceDark              : surfaceLight;
  static Color surfaceContainer(bool isDark)=> isDark ? surfaceContainerDark     : surfaceContainerLight;
  static Color outline(bool isDark)         => isDark ? outlineDark              : outlineLight;
  static Color outlineVariant(bool isDark)  => isDark ? outlineVariantDark       : outlineVariantLight;
  static Color onSurface(bool isDark)       => isDark ? onSurfaceDark            : onSurfaceLight;
  static Color onSurfaceMuted(bool isDark)  => isDark ? onSurfaceMutedDark       : onSurfaceMutedLight;
  static Color onSurfaceFaint(bool isDark)  => isDark ? onSurfaceFaintDark       : onSurfaceFaintLight;

  // ─── AMOLED-aware helpers (CODE-068) ─────────────────────────────────────
  // Quand `isAmoled=true` ET `isDark=true`, on retourne les surfaces noir
  // pur. Sinon : fallback sur les helpers light/dark standards.
  static Color surfaceFor(bool isDark, bool isAmoled) =>
      (isDark && isAmoled) ? surfaceAmoled : surface(isDark);
  static Color surfaceContainerFor(bool isDark, bool isAmoled) =>
      (isDark && isAmoled) ? surfaceContainerAmoled : surfaceContainer(isDark);
  static Color outlineFor(bool isDark, bool isAmoled) =>
      (isDark && isAmoled) ? outlineAmoled : outline(isDark);
  static Color outlineVariantFor(bool isDark, bool isAmoled) =>
      (isDark && isAmoled) ? outlineVariantAmoled : outlineVariant(isDark);
  /// Top/Mid/Bot du gradient brand. En AMOLED dark : tous noirs.
  static Color brandTopFor(bool isDark, bool isAmoled) =>
      (isDark && isAmoled) ? darkNavyAmoled : (isDark ? darkNavy : blueLight);
  static Color brandMidFor(bool isDark, bool isAmoled) =>
      (isDark && isAmoled) ? darkNavyMidAmoled : (isDark ? darkNavyMid : blueMidLight);
  static Color brandBotFor(bool isDark, bool isAmoled) =>
      (isDark && isAmoled) ? darkNavyDeepAmoled : (isDark ? darkNavyDeep : blueDeepLight);

  static Color successFor(bool isDark)      => isDark ? successDark : success;
  static Color warningFor(bool isDark)      => isDark ? warningDark : warning;
  static Color dangerFor(bool isDark)       => isDark ? dangerDark  : danger;
  static Color infoFor(bool isDark)         => isDark ? infoDark    : info;

  /// Couleur d'un thème par slug. Fallback `blueLight` si inconnu.
  static Color themeColorFor(String? slug) =>
      (slug != null && themeColors.containsKey(slug))
          ? themeColors[slug]!
          : blueLight;

  /// Couleur sémantique selon le pourcentage de score (0..100).
  /// < 30 → danger ; < 70 → warning ; sinon → success.
  static Color scoreColor(double percent, bool isDark) {
    if (percent < 30) return dangerFor(isDark);
    if (percent < 70) return warningFor(isDark);
    return successFor(isDark);
  }
}
