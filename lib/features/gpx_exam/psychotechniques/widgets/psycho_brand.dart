// COP'IQ — Tokens de design partagés pour la catégorie Psychotechniques.
// Style premium 2026 : Apple / Linear / Notion. Compatible dark + light.

import 'package:flutter/material.dart';

Color psychoOpa(Color c, double a) => c.withValues(alpha: a);

class PsychoBrand {
  // Palette neutre
  static const textDark = Color(0xFF101114);
  static const textLight = Color(0xFFF8F9FB);
  static const bgLight = Color(0xFFF5F6F7);
  static const bgDark = Color(0xFF0E1014);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF161A20);
  static const border = Color(0xFFE7E9ED);
  static const borderDark = Color(0xFF22262E);

  // Palette accent
  static const accent = Color(0xFF6C63FF);
  static const accentSoft = Color(0xFF8B85FF);
  static const good = Color(0xFF22C55E);
  static const goodSoft = Color(0xFF86EFAC);
  static const bad = Color(0xFFEF4444);
  static const badSoft = Color(0xFFFCA5A5);
  static const warn = Color(0xFFF59E0B);

  // Catégories — tons distincts (utilisés pour cartes & cercles d'icônes)
  static const cAttention = Color(0xFF6C63FF);
  static const cSuiteLogique = Color(0xFF14B8A6);
  static const cCalcul = Color(0xFFF59E0B);
  static const cVerbal = Color(0xFFEC4899);
  static const cRaisonnement = Color(0xFF3B82F6);
  static const cSpatial = Color(0xFF8B5CF6);
  static const cRotation = Color(0xFF06B6D4);
  static const cConcentration = Color(0xFFEA580C);

  static Color text(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? textLight : textDark;

  static Color textMuted(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark
      ? psychoOpa(textLight, .65)
      : psychoOpa(textDark, .60);

  static Color bg(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? bgDark : bgLight;

  static Color surface(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? surfaceDark : surfaceLight;

  static Color borderColor(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? borderDark : border;

  // Typographie
  static TextStyle h1(BuildContext c) => TextStyle(
    fontFamily: 'InstrumentSans',
    fontWeight: FontWeight.w800,
    fontSize: 28,
    height: 1.2,
    letterSpacing: -0.4,
    color: text(c),
    decoration: TextDecoration.none,
  );

  static TextStyle h2(BuildContext c) => TextStyle(
    fontFamily: 'InstrumentSans',
    fontWeight: FontWeight.w800,
    fontSize: 22,
    height: 1.25,
    letterSpacing: -0.2,
    color: text(c),
    decoration: TextDecoration.none,
  );

  static TextStyle h3(BuildContext c) => TextStyle(
    fontFamily: 'InstrumentSans',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.3,
    color: text(c),
    decoration: TextDecoration.none,
  );

  static TextStyle body(BuildContext c) => TextStyle(
    fontFamily: 'InstrumentSans',
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 1.45,
    color: text(c),
    decoration: TextDecoration.none,
  );

  static TextStyle small(BuildContext c) => TextStyle(
    fontFamily: 'InstrumentSans',
    fontWeight: FontWeight.w600,
    fontSize: 12.5,
    letterSpacing: 0.2,
    color: textMuted(c),
    decoration: TextDecoration.none,
  );

  static TextStyle option(BuildContext c) => TextStyle(
    fontFamily: 'InstrumentSans',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.25,
    color: text(c),
    decoration: TextDecoration.none,
  );

  // Decorations utilitaires
  static BoxDecoration card(BuildContext c, {double radius = 18}) =>
      BoxDecoration(
        color: surface(c),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor(c), width: 1),
        boxShadow: [
          BoxShadow(
            color: psychoOpa(Colors.black, .04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration tinted(
    BuildContext c, {
    required Color color,
    double radius = 18,
    double alpha = .12,
  }) => BoxDecoration(
    color: psychoOpa(color, alpha),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: psychoOpa(color, .25), width: 1),
  );
}
