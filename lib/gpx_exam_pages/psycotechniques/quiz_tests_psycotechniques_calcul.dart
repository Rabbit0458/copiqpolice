// ignore_for_file: use_build_context_synchronously

// ============================================================================
//  Quiz Hiérarchie – version refondue
//  - Splash full-screen (FR), sans blur, fond animé, cartes fluides
//  - Bouton "Aléatoire" (mix des 3 niveaux) sous "Commencer"
//  - Création immédiate d'une ligne dans quiz_history à Start + update à la fin
//  - Animation de feedback (✓ / ✕) minimaliste et fluide
//  - Résultat : anneau animé infini, typographies unifiées, aucun soulignement
// ============================================================================

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:copiqpolice/ui/app_notifier.dart'
    show AppNotifier, AppSettingsController;

// Utilitaire alpha (évite withOpacity déprécié)
Color _opa(Color c, double a) => c.withValues(alpha: a);

// ============================================================================
// THEME
// ============================================================================
class _Brand {
  static const textDark = Color(0xFF212529);
  static const bgLight = Color(0xFFF5F6F7);
  static const white = Color(0xFFFFFFFF);

  static const accent = Color(0xFF6C63FF);
  static const good = Color(0xFF27C93F);
  static const bad = Color(0xFFFF3B30);

  static TextStyle h1(BuildContext c) => const TextStyle(
    fontFamily: 'InstrumentSans',
    fontWeight: FontWeight.w800,
    fontSize: 28,
    height: 1.25,
    letterSpacing: .2,
    decoration: TextDecoration.none,
  );

  static TextStyle option(BuildContext c) => const TextStyle(
    fontFamily: 'InstrumentSans',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.2,
    decoration: TextDecoration.none,
  );

  static TextStyle small(BuildContext c) => const TextStyle(
    fontFamily: 'InstrumentSans',
    fontWeight: FontWeight.w700,
    fontSize: 12,
    letterSpacing: .2,
    decoration: TextDecoration.none,
  );

  static Color radioTrack(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark
      ? _opa(Colors.white, .18)
      : const Color(0xFFE7E9ED);
}

// ============================================================================
// DATA
// ============================================================================
class QuizQuestion {
  final String category;
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;
  final String difficulty; // "Facile" | "Moyenne" | "Difficile"
  final String? sub;

  const QuizQuestion({
    required this.category,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.difficulty,
    this.sub,
  });
}

final List<QuizQuestion> questionPsycotechniquesCalcul = [
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + 3 ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "La somme de 5 et 3 est 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - 4 ?",
    options: ["8", "9", "10"],
    answer: "8",
    explanation: "La soustraction de 4 à 12 donne 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 2 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "La multiplication de 6 par 2 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ 4 ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "La division de 20 par 4 donne 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 9 - 4 ?",
    options: ["18", "20", "22"],
    answer: "20",
    explanation: "15 plus 9 moins 4 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (4 + 2) ?",
    options: ["16", "18", "20"],
    answer: "18",
    explanation: "3 multiplié par la somme de 4 et 2 donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 3 ?",
    options: ["18", "20", "24"],
    answer: "24",
    explanation: "La différence de 10 et 2 multipliée par 3 donne 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 3 ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "La division de 25 par 5 plus 3 donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 3 + 10 - 5 ?",
    options: ["15", "16", "17"],
    answer: "17",
    explanation: "4 multiplié par 3 plus 10 moins 5 donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 2 × 3 ?",
    options: ["18", "12", "15"],
    answer: "18",
    explanation:
        "La somme de 8 et 4 divisée par 2, puis multipliée par 3 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (3 + 1) - 10 ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "7 multiplié par la somme de 3 et 1, moins 10 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (3 × 2) + 5 ?",
    options: ["8", "9", "10"],
    answer: "10",
    explanation: "9 moins 3 multiplié par 2 plus 5 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 ÷ 2 + 6 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "La division de 14 par 2 plus 6 donne 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - 10 ÷ 2 ?",
    options: ["20", "25", "15"],
    answer: "25",
    explanation: "30 moins 10 divisé par 2 donne 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) × 2 - 4 ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation: "La somme de 5 et 3 multipliée par 2, moins 4 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 - 3 + 2 ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation: "8 moins 3 plus 2 donne 7.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 4 ?",
    options: ["6", "8", "10"],
    answer: "10",
    explanation: "La division de 18 par 3 plus 4 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + 2 × 3 ?",
    options: ["12", "16", "18"],
    answer: "12",
    explanation: "6 plus 2 multiplié par 3 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 6) × 2 - 8 ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation: "La somme de 4 et 6 multipliée par 2, moins 8 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - 2 + 5 ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "10 moins 2 plus 5 donne 13.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 3 ?",
    options: ["6", "7", "9"],
    answer: "9",
    explanation: "La multiplication de 3 par 3 est 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 ÷ 3 ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "15 divisé par 3 donne 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 5 - 3 ?",
    options: ["9", "10", "11"],
    answer: "9",
    explanation: "7 plus 5 moins 3 est égal à 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - 2 × 3 ?",
    options: ["4", "6", "8"],
    answer: "4",
    explanation: "10 moins 6 (2 × 3) donne 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 4 ?",
    options: ["2", "3", "4"],
    answer: "3",
    explanation: "La somme de 8 et 4 est 12, et 12 divisé par 4 est 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (2 + 3) ?",
    options: ["20", "25", "30"],
    answer: "25",
    explanation: "5 fois 5 (2 + 3) est 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 - 4) ÷ 4 + 2 ?",
    options: ["3", "4", "5"],
    answer: "4",
    explanation: "16 divisé par 4 donne 4, et 4 plus 2 est 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + (6 - 2) × 3 ?",
    options: ["15", "21", "27"],
    answer: "21",
    explanation: "6 moins 2 est 4, et 4 fois 3 plus 9 est 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 5) × (2 - 1) ?",
    options: ["8", "10", "16"],
    answer: "8",
    explanation: "8 fois 1 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 7 ?",
    options: ["10", "11", "12"],
    answer: "12",
    explanation: "18 divisé par 2 est 9, et 9 plus 3 est 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 3 × 2 ?",
    options: ["8", "9", "10"],
    answer: "8",
    explanation: "3 fois 2 est 6, et 14 moins 6 est 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 3 - 5 ?",
    options: ["13", "15", "18"],
    answer: "13",
    explanation: "18 moins 5 est 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 5) ÷ 2 + 1 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation: "10 divisé par 2 donne 5, et 5 plus 1 est 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ (2 + 2) ?",
    options: ["2", "3", "4"],
    answer: "3",
    explanation: "12 divisé par 4 est 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 5 - 6 ?",
    options: ["14", "18", "20"],
    answer: "14",
    explanation: "20 moins 6 est 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 + 3) × 2 - 5 ?",
    options: ["15", "20", "25"],
    answer: "15",
    explanation: "10 fois 2 est 20, et 20 moins 5 est 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 ÷ 2 + 3 ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "5 plus 3 est 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + 4 - 5 ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "6 plus 4 moins 5 est 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "5 + 3 - 2 = ?",
    options: ["6", "7", "8"],
    answer: "6",
    explanation: "La somme de 5 et 3 est 8, moins 2 donne 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "12 ÷ 4 + 1 = ?",
    options: ["3", "4", "5"],
    answer: "4",
    explanation: "12 divisé par 4 donne 3, plus 1 est égal à 4.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "3 × 4 - 2 = ?",
    options: ["10", "11", "12"],
    answer: "10",
    explanation: "3 multiplié par 4 donne 12, moins 2 est égal à 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 ÷ 2 + 3 = ?",
    options: ["5", "6", "7"],
    answer: "7",
    explanation: "8 divisé par 2 donne 4, plus 3 est égal à 7.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) × 2 = ?",
    options: ["16", "14", "18"],
    answer: "16",
    explanation: "D'abord 10 moins 2 donne 8, multiplié par 2 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 + 4) ÷ 2 = ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "La somme de 6 et 4 est 10, divisé par 2 donne 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 × 3 - 5 = ?",
    options: ["22", "24", "26"],
    answer: "22",
    explanation: "9 multiplié par 3 donne 27, moins 5 donne 22.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 ÷ 3) + (5 × 2) = ?",
    options: ["11", "12", "13"],
    answer: "12",
    explanation: "18 divisé par 3 donne 6, plus 10 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - 4) ÷ 4 + 3 = ?",
    options: ["4", "5", "6"],
    answer: "6",
    explanation: "20 moins 4 est 16, divisé par 4 donne 4, plus 3 donne 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 + 15) ÷ 4 = ?",
    options: ["5", "6", "7"],
    answer: "5",
    explanation: "La somme de 5 et 15 est 20, divisé par 4 donne 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(30 - 10) ÷ 4 + 2 = ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "30 moins 10 est 20, divisé par 4 donne 5, plus 2 donne 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(50 ÷ 5) + (10 × 2) = ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation: "50 divisé par 5 donne 10, plus 20 donne 30.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 5 ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "La somme de 8 et 5 est 13.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 7 ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "La différence entre 15 et 7 est 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 3 ?",
    options: ["27", "28", "26"],
    answer: "27",
    explanation: "9 multiplié par 3 donne 27.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 15 - 5 ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation: "10 plus 15 moins 5 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 5 + 2 ?",
    options: ["11", "10", "9"],
    answer: "11",
    explanation: "14 moins 5 plus 2 est égal à 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 2 + 4 ?",
    options: ["16", "14", "12"],
    answer: "16",
    explanation: "6 multiplié par 2 plus 4 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) × 2 ?",
    options: ["16", "14", "12"],
    answer: "16",
    explanation: "La somme de 5 et 3 multipliée par 2 est 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 7 ?",
    options: ["14", "13", "15"],
    answer: "13",
    explanation: "18 divisé par 2 plus 7 donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 9 ?",
    options: ["16", "15", "14"],
    answer: "16",
    explanation: "25 moins 9 est égal à 16.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - 5 ?",
    options: ["16", "21", "18"],
    answer: "16",
    explanation: "7 multiplié par 3 moins 5 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 10 ?",
    options: ["20", "15", "25"],
    answer: "15",
    explanation: "50 divisé par 5 plus 10 est égal à 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) ÷ 2 ?",
    options: ["5", "6", "4"],
    answer: "5",
    explanation: "La somme de 6 et 4 divisée par 2 est 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 + 4 ?",
    options: ["15", "14", "16"],
    answer: "15",
    explanation: "11 plus 4 donne 15.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - 4 + 6 ?",
    options: ["14", "12", "10"],
    answer: "14",
    explanation: "12 moins 4 plus 6 est égal à 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (3 + 1) ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation: "5 multiplié par la somme de 3 et 1 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 ÷ 2 + 6 ?",
    options: ["7", "8", "10"],
    answer: "7",
    explanation: "8 divisé par 2 plus 6 donne 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 + 4 + 4 ?",
    options: ["10", "11", "12"],
    answer: "12",
    explanation: "La somme de 4, 4 et 4 est 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 2 ?",
    options: ["16", "17", "18"],
    answer: "18",
    explanation: "La multiplication de 9 par 2 donne 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 ?",
    options: ["7", "8", "9"],
    answer: "9",
    explanation: "La division de 18 par 2 est 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 5 - 3 ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "15 plus 5 moins 3 donne 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 ÷ 5 + 3 ?",
    options: ["8", "9", "10"],
    answer: "10",
    explanation:
        "La division de 45 par 5 est 9, puis on ajoute 1 pour obtenir 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 6) × 2 ?",
    options: ["18", "20", "22"],
    answer: "20",
    explanation: "La somme de 4 et 6 est 10, multipliée par 2 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (3 + 4) ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation: "La somme de 3 et 4 est 7, multipliée par 2 donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (8 ÷ 2) ?",
    options: ["21", "22", "23"],
    answer: "21",
    explanation: "La division de 8 par 2 est 4, 25 moins 4 donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × (5 + 1) ?",
    options: ["48", "50", "54"],
    answer: "48",
    explanation:
        "La soustraction de 2 à 10 est 8, la somme de 5 et 1 est 6, 8 multiplié par 6 donne 48.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (4 + 5) - 2 ?",
    options: ["25", "26", "27"],
    answer: "25",
    explanation:
        "La somme de 4 et 5 est 9, multipliée par 3 donne 27, moins 2 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (16 ÷ 4) + (5 × 3) ?",
    options: ["18", "19", "20"],
    answer: "19",
    explanation:
        "La division de 16 par 4 est 4, et 5 multiplié par 3 est 15, donc 4 plus 15 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (3 × 2) + 5 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation:
        "La multiplication de 3 par 2 est 6, 14 moins 6 plus 5 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (3 + 1) - 2 ?",
    options: ["22", "23", "24"],
    answer: "22",
    explanation:
        "La somme de 3 et 1 est 4, multipliée par 6 donne 24, moins 2 donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (4 + 2) × 2 ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation:
        "La somme de 4 et 2 est 6, multipliée par 2 donne 12, donc 20 moins 12 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (5 + 5) ?",
    options: ["2", "3", "5"],
    answer: "5",
    explanation: "La somme de 5 et 5 est 10, donc 50 divisé par 10 donne 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 3 - 1 ?",
    options: ["23", "24", "25"],
    answer: "23",
    explanation: "La multiplication de 8 par 3 est 24, moins 1 donne 23.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 + 2 × 3 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation:
        "La multiplication est effectuée en premier, donc 2 fois 3 est 6, puis 4 plus 6 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - 25 ÷ 5 ?",
    options: ["95", "96", "97"],
    answer: "96",
    explanation: "La division de 25 par 5 est 5, donc 100 moins 5 donne 95.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "12 - 4 + 5 = ?",
    options: ["11", "12", "13"],
    answer: "13",
    explanation:
        "En soustrayant 4 de 12, on obtient 8, puis en ajoutant 5, cela donne 13.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 × 2 ÷ 3 = ?",
    options: ["6", "5", "8"],
    answer: "6",
    explanation: "9 multiplié par 2 est 18, puis divisé par 3 donne 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - 5 + 10 = ?",
    options: ["20", "25", "15"],
    answer: "20",
    explanation: "15 moins 5 est 10, plus 10 donne 20.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 ÷ 4 + 6 = ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "8 divisé par 4 est 2, ajouté à 6 donne 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(3 + 2) × 4 = ?",
    options: ["20", "15", "25"],
    answer: "20",
    explanation: "La somme de 3 et 2 est 5, multipliée par 4 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) × 3 = ?",
    options: ["24", "30", "20"],
    answer: "24",
    explanation: "10 moins 2 est 8, multiplié par 3 donne 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 + 4) ÷ 2 × 5 = ?",
    options: ["25", "20", "30"],
    answer: "25",
    explanation:
        "La somme de 6 et 4 est 10, divisé par 2 donne 5, multiplié par 5 donne 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 ÷ 2) + (6 × 3) = ?",
    options: ["20", "22", "18"],
    answer: "20",
    explanation:
        "8 divisé par 2 est 4, et 6 multiplié par 3 est 18, donc 4 + 18 donne 22.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 2) + (3 × 4) = ?",
    options: ["26", "22", "20"],
    answer: "26",
    explanation:
        "5 multiplié par 2 est 10, et 3 multiplié par 4 est 12, donc 10 + 12 donne 22.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(12 - 4) × (3 + 1) = ?",
    options: ["32", "28", "36"],
    answer: "32",
    explanation:
        "12 moins 4 est 8, et 3 plus 1 est 4, donc 8 multiplié par 4 donne 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(7 + 5) × (2 - 1) = ?",
    options: ["12", "14", "24"],
    answer: "12",
    explanation:
        "La somme de 7 et 5 est 12, et 2 moins 1 est 1, donc 12 multiplié par 1 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 × 5) - (6 ÷ 2) = ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation:
        "4 multiplié par 5 est 20, et 6 divisé par 2 est 3, donc 20 moins 3 donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) ÷ 2 + 3 = ?",
    options: ["7", "8", "6"],
    answer: "7",
    explanation: "10 moins 2 est 8, divisé par 2 donne 4, ajouté à 3 donne 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 − 3) × (2 + 1) = ?",
    options: ["18", "21", "20"],
    answer: "18",
    explanation:
        "9 moins 3 est 6, et 2 plus 1 est 3, donc 6 multiplié par 3 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(15 ÷ 3) + (5 × 2) = ?",
    options: ["20", "15", "10"],
    answer: "15",
    explanation:
        "15 divisé par 3 est 5, et 5 multiplié par 2 est 10, donc 5 + 10 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 × 3) ÷ 4 + 6 = ?",
    options: ["12", "18", "14"],
    answer: "12",
    explanation:
        "8 multiplié par 3 est 24, divisé par 4 donne 6, ajouté à 6 donne 12.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 4 ?",
    options: ["11", "12", "13"],
    answer: "12",
    explanation: "La multiplication de 3 par 4 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 56 ÷ 7 ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "La division de 56 par 7 est 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 9 + 3 ?",
    options: ["12", "13", "14"],
    answer: "14",
    explanation: "On soustrait 9 de 20 puis on ajoute 3, ce qui donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 2 - 5 ?",
    options: ["7", "8", "9"],
    answer: "7",
    explanation: "On multiplie 6 par 2 puis on soustrait 5, ce qui donne 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 2 × 3 ?",
    options: ["14", "16", "18"],
    answer: "16",
    explanation:
        "On effectue d'abord la multiplication puis l'addition, soit 10 + 6 = 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 2) × 3 ?",
    options: ["18", "20", "21"],
    answer: "18",
    explanation:
        "On additionne 4 et 2 puis on multiplie par 3, soit 6 × 3 = 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (2 + 4) - 5 ?",
    options: ["15", "16", "17"],
    answer: "15",
    explanation:
        "On additionne 2 et 4 puis on multiplie par 3, puis on soustrait 5, soit 18 - 5 = 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - 25 ÷ 5 ?",
    options: ["95", "90", "85"],
    answer: "95",
    explanation:
        "On divise 25 par 5 puis on soustrait le résultat de 100, soit 100 - 5 = 95.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 6 ÷ 3 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "On divise 6 par 3 puis on additionne à 9, soit 9 + 2 = 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × 5 + 10 ÷ 2 ?",
    options: ["20", "25", "22"],
    answer: "25",
    explanation:
        "On effectue d'abord les multiplications et divisions, soit 10 + 15 = 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 80 ÷ 4 + 10 ?",
    options: ["20", "30", "25"],
    answer: "30",
    explanation: "On divise 80 par 4 puis on ajoute 10, soit 20 + 10 = 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 5 ?",
    options: ["35", "40", "45"],
    answer: "40",
    explanation:
        "On soustrait 2 de 10 puis on multiplie par 5, soit 8 × 5 = 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 10 - 5 ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation: "15 + 10 - 5 égale 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 2 ?",
    options: ["4", "6", "8"],
    answer: "8",
    explanation: "18 divisé par 3 plus 2 égale 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (3 × 5) ?",
    options: ["10", "15", "20"],
    answer: "10",
    explanation: "25 - (3 × 5) égale 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) × 2 ?",
    options: ["20", "22", "24"],
    answer: "24",
    explanation: "(8 + 4) multiplié par 2 égale 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - 5 × (2 + 3) ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation: "30 - 5 multiplié par (2 + 3) égale 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 ÷ 2) + (3 × 4) ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "(6 ÷ 2) plus (3 × 4) égale 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 3) × (2 + 1) ?",
    options: ["12", "15", "18"],
    answer: "18",
    explanation: "(9 - 3) multiplié par (2 + 1) égale 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (6 ÷ 2) ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "14 - (6 ÷ 2) égale 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 3 + 6 ?",
    options: ["12", "15", "18"],
    answer: "15",
    explanation: "3 multiplié par 3 plus 6 égale 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "12 - 4 + 1 = ?",
    options: ["7", "8", "9"],
    answer: "9",
    explanation: "On soustrait 4 de 12 pour obtenir 8, puis on ajoute 1.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 ÷ 4 + 3 = ?",
    options: ["5", "8", "7"],
    answer: "8",
    explanation: "On divise 20 par 4 pour obtenir 5, puis on ajoute 3.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 + 2) × 2 = ?",
    options: ["14", "16", "12"],
    answer: "16",
    explanation:
        "On additionne 6 et 2 pour obtenir 8, puis on multiplie par 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(15 - 3) ÷ 3 = ?",
    options: ["4", "5", "6"],
    answer: "4",
    explanation: "On soustrait 3 de 15 pour obtenir 12, puis on divise par 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "18 ÷ (2 + 4) = ?",
    options: ["3", "2", "4"],
    answer: "3",
    explanation:
        "On additionne 2 et 4 pour obtenir 6, puis on divise 18 par 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 + 3) × (2 - 1) = ?",
    options: ["6", "8", "10"],
    answer: "8",
    explanation:
        "On additionne 5 et 3 pour obtenir 8, et 2 moins 1 donne 1, donc 8 fois 1.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) × 2 + 4 = ?",
    options: ["16", "18", "20"],
    answer: "20",
    explanation:
        "On soustrait 2 de 10 pour obtenir 8, puis on multiplie par 2 et ajoute 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(7 + 5) ÷ (2 - 1) × 3 = ?",
    options: ["36", "24", "12"],
    answer: "36",
    explanation:
        "On additionne 7 et 5 pour obtenir 12, divisé par 1, puis multiplié par 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 - 3) × (4 + 2) = ?",
    options: ["36", "24", "30"],
    answer: "36",
    explanation:
        "On soustrait 3 de 9 pour obtenir 6, puis on additionne 4 et 2 pour obtenir 6, et on multiplie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 ÷ 2) + (3 × 4) = ?",
    options: ["14", "16", "10"],
    answer: "14",
    explanation:
        "On divise 8 par 2 pour obtenir 4, puis on multiplie 3 par 4 pour obtenir 12 et additionne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 × 4) - (8 ÷ 2) = ?",
    options: ["20", "22", "24"],
    answer: "20",
    explanation:
        "On multiplie 6 par 4 pour obtenir 24, puis on divise 8 par 2 pour obtenir 4 et soustrait.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 + 5) - (3 × 2) = ?",
    options: ["14", "15", "13"],
    answer: "13",
    explanation: "On additionne 10 et 5 pour obtenir 15, puis on soustrait 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(25 ÷ 5) + (6 × 2) = ?",
    options: ["17", "18", "16"],
    answer: "17",
    explanation:
        "On divise 25 par 5 pour obtenir 5, puis on multiplie 6 par 2 pour obtenir 12 et additionne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 3 ?",
    options: ["18", "20", "16"],
    answer: "18",
    explanation: "6 multiplié par 3 égale 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 2 - 3 ?",
    options: ["15", "12", "18"],
    answer: "15",
    explanation: "9 multiplié par 2 moins 3 égale 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 3 ?",
    options: ["4", "3", "5"],
    answer: "4",
    explanation: "12 divisé par 3 égale 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (2 + 1) ?",
    options: ["21", "20", "23"],
    answer: "21",
    explanation: "7 multiplié par 3 égale 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (10 × 3) ?",
    options: ["20", "30", "15"],
    answer: "20",
    explanation: "50 moins 30 égale 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × 5 ?",
    options: ["40", "30", "50"],
    answer: "40",
    explanation: "8 multiplié par 5 égale 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (3 + 5) - 8 ?",
    options: ["24", "16", "20"],
    answer: "16",
    explanation: "32 moins 16 égale 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ (5 × 4) ?",
    options: ["5", "4", "6"],
    answer: "5",
    explanation: "100 divisé par 20 égale 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (2 × 5) ?",
    options: ["15", "10", "5"],
    answer: "15",
    explanation: "25 moins 10 égale 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 4 ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "9 plus 4 égale 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 9 - 5 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "La somme de 7 et 9, moins 5, est égale à 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (3 × 4) ?",
    options: ["6", "8", "10"],
    answer: "6",
    explanation:
        "La multiplication de 3 par 4 donne 12, soustrait de 18 donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (3 + 2) ?",
    options: ["20", "25", "30"],
    answer: "25",
    explanation: "La somme de 3 et 2, multipliée par 5, donne 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ (2 + 3) ?",
    options: ["3", "4", "5"],
    answer: "4",
    explanation: "La division de 20 par la somme de 2 et 3 donne 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × (6 ÷ 2) ?",
    options: ["36", "32", "24"],
    answer: "32",
    explanation: "La soustraction de 2 à 10 est 8, multipliée par 3 donne 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 + 3) × (5 - 2) ?",
    options: ["15", "20", "30"],
    answer: "30",
    explanation: "La somme de 7 et 3 est 10, multipliée par 3 donne 30.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 15 - 10 ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "La somme de 12 et 15 moins 10 est 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 4 + 2 ?",
    options: ["22", "26", "24"],
    answer: "26",
    explanation: "La multiplication de 6 par 4 plus 2 donne 26.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 3 × 2 ?",
    options: ["12", "15", "9"],
    answer: "12",
    explanation: "La soustraction de 18 et 6 (3 × 2) donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (5 - 3) ?",
    options: ["10", "15", "20"],
    answer: "15",
    explanation: "La division de 30 par 2 (5 - 3) donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (3 + 7) - 5 ?",
    options: ["45", "40", "35"],
    answer: "40",
    explanation: "La multiplication de 5 par 10 (3 + 7) moins 5 donne 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 2) × (3 + 1) ?",
    options: ["24", "30", "20"],
    answer: "24",
    explanation: "La multiplication de 6 par 4 (8 - 2 et 3 + 1) donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (3 × 5) + 4 ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation: "La soustraction de 15 (3 × 5) de 25 plus 4 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 + 6 ÷ 2 ?",
    options: ["16", "18", "14"],
    answer: "16",
    explanation: "La somme de 14 et 3 (6 ÷ 2) donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ 6 + 4 ?",
    options: ["10", "8", "6"],
    answer: "8",
    explanation: "La division de 36 par 6 plus 4 donne 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (2 × 10) + 5 ?",
    options: ["45", "40", "35"],
    answer: "45",
    explanation: "La soustraction de 20 (2 × 10) de 50 plus 5 donne 45.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 5 ?",
    options: ["12", "10", "15"],
    answer: "12",
    explanation: "L'addition de 7 et 5 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 8 ?",
    options: ["12", "10", "15"],
    answer: "12",
    explanation: "En soustrayant 8 de 20, on obtient 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ 3 ?",
    options: ["12", "10", "15"],
    answer: "12",
    explanation: "En divisant 36 par 3, le résultat est 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 7 + 4 ?",
    options: ["12", "10", "15"],
    answer: "12",
    explanation: "On soustrait 7 de 15, puis on ajoute 4, ce qui donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (2 + 3) ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation: "50 divisé par 5 (2+3) donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (2 × 3) ?",
    options: ["12", "10", "15"],
    answer: "12",
    explanation: "On calcule d'abord 2 × 3 qui donne 6, puis 18 - 6 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 2) × 3 ?",
    options: ["18", "12", "15"],
    answer: "18",
    explanation: "La soustraction de 2 à 8 donne 6, multipliée par 3 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ (5 × 2) ?",
    options: ["10", "12", "15"],
    answer: "10",
    explanation:
        "La multiplication de 5 et 2 donne 10, donc 100 ÷ 10 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 2 ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation: "La multiplication de 7 par 2 donne 14.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 6 - 3 ?",
    options: ["10", "12", "15"],
    answer: "12",
    explanation: "La somme de 9 et 6, moins 3, donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - (3 × 2) ?",
    options: ["9", "11", "12"],
    answer: "9",
    explanation: "La soustraction de 6 à 15 donne 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (3 + 5) ?",
    options: ["24", "32", "28"],
    answer: "32",
    explanation: "La multiplication de 4 par 8 donne 32.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × (5 - 3) ?",
    options: ["16", "12", "8"],
    answer: "16",
    explanation: "La multiplication de 8 par 2 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 5 + 2 × 4 ?",
    options: ["27", "23", "19"],
    answer: "23",
    explanation: "La somme de 15 et 8 donne 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (18 ÷ 2) + (6 × 3) ?",
    options: ["24", "30", "21"],
    answer: "24",
    explanation: "La somme de 9 et 15 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (3 × 4) + 2 ?",
    options: ["15", "20", "17"],
    answer: "17",
    explanation: "La soustraction de 12 à 25, plus 2, donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (2 + 1) - 6 ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "La multiplication de 8 par 3, moins 6, donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 5 + 4 × 2 ?",
    options: ["14", "16", "12"],
    answer: "14",
    explanation: "La somme de 6 et 8 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (5 × 6) + 10 ?",
    options: ["40", "44", "50"],
    answer: "40",
    explanation: "La soustraction de 30 à 50, plus 10, donne 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 3 ?",
    options: ["12", "10", "15"],
    answer: "12",
    explanation: "La multiplication de 4 par 3 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 4 × 3 ?",
    options: ["8", "12", "16"],
    answer: "8",
    explanation:
        "En multipliant 4 par 3 puis en soustrayant de 20, on obtient 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 6 ?",
    options: ["16", "14", "12"],
    answer: "14",
    explanation:
        "La division de 50 par 5 donne 10, et en ajoutant 6 on obtient 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × (3 + 1) ?",
    options: ["32", "24", "28"],
    answer: "32",
    explanation:
        "En effectuant les opérations dans les parenthèses puis en multipliant, on obtient 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + (4 × 2) - 5 ?",
    options: ["9", "12", "10"],
    answer: "9",
    explanation:
        "En multipliant d'abord puis en ajoutant et soustrayant, on obtient 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - 8 ÷ 4 ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation:
        "En effectuant d'abord la multiplication et la division, on obtient 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 15 ÷ 3 ?",
    options: ["12", "14", "18"],
    answer: "18",
    explanation: "En divisant d'abord puis en ajoutant, on obtient 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 - 3 + 2 ?",
    options: ["8", "9", "10"],
    answer: "10",
    explanation: "En soustrayant puis en ajoutant, on obtient 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - 7 ?",
    options: ["5", "4", "6"],
    answer: "5",
    explanation: "12 moins 7 donne 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 6 - 4 ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "15 plus 6 moins 4 est égal à 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (3 - 1) ?",
    options: ["12", "14", "16"],
    answer: "16",
    explanation: "8 multiplié par 2 (qui est 3 moins 1) est 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) × 2 ?",
    options: ["18", "20", "22"],
    answer: "20",
    explanation: "La somme de 6 et 4 donne 10, multiplié par 2 est 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 6 × 2 ?",
    options: ["21", "20", "19"],
    answer: "21",
    explanation: "6 multiplié par 2 est 12, ajouté à 9 donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) × (4 - 2) ?",
    options: ["16", "14", "12"],
    answer: "16",
    explanation:
        "La somme donne 8 et la différence donne 2, donc 8 fois 2 est 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - (2 × 3) + 4 ?",
    options: ["8", "6", "10"],
    answer: "8",
    explanation: "10 moins 6 (qui est 2 fois 3) plus 4 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 - 2) × (3 + 1) ?",
    options: ["20", "15", "25"],
    answer: "20",
    explanation: "5 multiplié par 4 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 4 × 3 ?",
    options: ["9", "12", "10"],
    answer: "9",
    explanation: "12 divisé par 4 donne 3, multiplié par 3 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (5 + 5) + 3 ?",
    options: ["8", "10", "7"],
    answer: "8",
    explanation: "50 divisé par 10 donne 5, ajouté à 3 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - 4 ?",
    options: ["5", "6", "7"],
    answer: "5",
    explanation: "La soustraction de 4 à 9 donne 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ 4 ?",
    options: ["2", "3", "4"],
    answer: "3",
    explanation: "La division de 12 par 4 donne 3.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 9 + 2 ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "15 moins 9 plus 2 donne 8.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 9 - 5 ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "15 plus 9 moins 5 donne 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 6 + 3 ?",
    options: ["11", "10", "12"],
    answer: "11",
    explanation: "14 moins 6 plus 3 donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (7 - 2) ?",
    options: ["15", "20", "10"],
    answer: "15",
    explanation: "3 multiplié par 5 (7 moins 2) donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 2) × (8 - 3) ?",
    options: ["25", "20", "15"],
    answer: "25",
    explanation:
        "La somme de 3 et 2, multipliée par la différence de 8 et 3, donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (6 - 2) + 3 ?",
    options: ["19", "20", "18"],
    answer: "19",
    explanation: "4 multiplié par 4, plus 3, donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 4) × (5 + 1) ?",
    options: ["36", "30", "24"],
    answer: "36",
    explanation:
        "La différence de 10 et 4, multipliée par la somme de 5 et 1, est 36.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 + 3) ÷ 3 × 4 ?",
    options: ["16", "12", "20"],
    answer: "16",
    explanation:
        "La somme de 9 et 3, divisée par 3, puis multipliée par 4, est 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (3 × 2) + 5 ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "18 moins 6 (3 multiplié par 2), plus 5 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le produit de 6 × 7 ?",
    options: ["42", "36", "48"],
    answer: "42",
    explanation: "La multiplication de 6 par 7 donne 42.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 5 - 3 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "Le résultat de 9 + 5 - 3 est 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (2 + 3) ?",
    options: ["30", "35", "40"],
    answer: "35",
    explanation: "Le produit de 7 par la somme de 2 et 3 est 35.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 5 ?",
    options: ["9", "14", "15"],
    answer: "14",
    explanation: "La division de 18 par 2, ajoutée à 5, donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 2 × (3 + 1) ?",
    options: ["7", "11", "9"],
    answer: "7",
    explanation: "15 moins le double de la somme de 3 et 1 donne 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (3 - 1) + 4 ?",
    options: ["20", "24", "28"],
    answer: "20",
    explanation:
        "Le produit de 8 par la différence de 3 et 1, ajouté à 4, donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) ÷ 4 + 3 ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation:
        "La différence de 10 et 2, divisée par 4, ajoutée à 3, donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 + 3) × 2 - 6 ?",
    options: ["12", "18", "24"],
    answer: "12",
    explanation: "La somme de 9 et 3, multipliée par 2, moins 6, donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (4 - 2) + 6 ?",
    options: ["10", "16", "12"],
    answer: "16",
    explanation:
        "Le produit de 5 par la différence de 4 et 2, ajouté à 6, donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 6 - 3 ?",
    options: ["18", "21", "22"],
    answer: "18",
    explanation: "15 plus 6 moins 3 donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (6 × 7) ?",
    options: ["8", "14", "26"],
    answer: "8",
    explanation: "50 moins 42 (6 fois 7) donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (4 + 5) ?",
    options: ["27", "27", "30"],
    answer: "27",
    explanation: "3 multiplié par 9 (4 plus 5) donne 27.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (3 + 4) - 5 ?",
    options: ["30", "25", "20"],
    answer: "30",
    explanation: "5 multiplié par 7 (3 plus 4) moins 5 donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + (6 ÷ 2) × 3 ?",
    options: ["20", "24", "26"],
    answer: "20",
    explanation: "8 plus 9 (6 divisé par 2 multiplié par 3) donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 5) ÷ 3 + 2 ?",
    options: ["5", "7", "8"],
    answer: "7",
    explanation: "(15 divisé par 3) plus 2 donne 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (5 × 4) + 3 ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "25 moins 20 (5 fois 4) plus 3 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 2 + 5 ?",
    options: ["19", "21", "17"],
    answer: "19",
    explanation: "7 multiplié par 2 plus 5 égale 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (2 × 10) ?",
    options: ["10", "20", "15"],
    answer: "10",
    explanation: "30 moins (2 multiplié par 10) égale 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 + 3 × 4 ?",
    options: ["14", "20", "18"],
    answer: "14",
    explanation: "2 plus 3 multiplié par 4 égale 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ 3 + 6 ?",
    options: ["8", "10", "6"],
    answer: "10",
    explanation: "12 divisé par 3 plus 6 égale 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (5 + 5) × 2 ?",
    options: ["15", "5", "10"],
    answer: "15",
    explanation: "25 moins (5 + 5 multiplié par 2) égale 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - 4 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation: "Il s'agit d'une soustraction de deux nombres entiers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × 3 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation: "C'est une multiplication de deux nombres entiers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 6 - 8 ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "On effectue d'abord l'addition puis la soustraction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 2 - 5 ?",
    options: ["10", "13", "15"],
    answer: "13",
    explanation: "On commence par la multiplication, puis on soustrait.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (6 - 2) ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation: "On effectue d'abord la soustraction, puis la multiplication.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 3 × 2 ?",
    options: ["10", "13", "17"],
    answer: "13",
    explanation: "On effectue d'abord la multiplication, puis l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (6 ÷ 2) ?",
    options: ["27", "28", "29"],
    answer: "28",
    explanation: "On divise d'abord, puis on soustrait.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 4 + 2 ?",
    options: ["14", "16", "18"],
    answer: "18",
    explanation: "On effectue d'abord la multiplication, puis l'addition.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 10 + 5 ?",
    options: ["15", "20", "25"],
    answer: "20",
    explanation: "On soustrait d'abord, puis on ajoute.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (3 + 2) ?",
    options: ["4", "5", "6"],
    answer: "4",
    explanation: "9 moins la somme de 3 et 2 donne 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de (8 + 4) × 2 ?",
    options: ["20", "24", "22"],
    answer: "24",
    explanation: "La somme de 8 et 4 multipliée par 2 donne 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (10 × 4) ?",
    options: ["10", "20", "30"],
    answer: "10",
    explanation: "50 moins 40 est égal à 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × (3 - 1) ?",
    options: ["12", "16", "14"],
    answer: "16",
    explanation:
        "La somme de 6 et 2 multipliée par la différence de 3 et 1 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ (5 + 5) ?",
    options: ["5", "10", "15"],
    answer: "10",
    explanation: "100 divisé par 10 est égal à 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 × 3) + (6 ÷ 2) ?",
    options: ["14", "16", "12"],
    answer: "14",
    explanation: "Le produit de 4 et 3 plus le quotient de 6 et 2 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (3 × 7) ?",
    options: ["9", "12", "15"],
    answer: "9",
    explanation: "30 moins 21 est égal à 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 7 + 2 ?",
    options: ["8", "9", "10"],
    answer: "10",
    explanation: "15 moins 7 plus 2 égale 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 5) × 2 ?",
    options: ["14", "16", "18"],
    answer: "16",
    explanation: "La somme de 3 et 5, multipliée par 2, donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ (2 + 4) ?",
    options: ["3", "4", "5"],
    answer: "4",
    explanation: "24 divisé par la somme de 2 et 4 donne 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 4 + 6 ?",
    options: ["34", "38", "40"],
    answer: "34",
    explanation: "7 multiplié par 4 plus 6 égale 34.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) × (2 - 1) ?",
    options: ["8", "10", "12"],
    answer: "8",
    explanation:
        "La somme de 5 et 3 multipliée par la différence de 2 et 1 donne 8.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 12 - 4 ?",
    options: ["8", "9", "7"],
    answer: "8",
    explanation: "En soustrayant 4 de 12, on obtient 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le produit de 3 x 4 ?",
    options: ["12", "10", "14"],
    answer: "12",
    explanation: "La multiplication de 3 par 4 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ 5 ?",
    options: ["4", "5", "3"],
    answer: "4",
    explanation: "La division de 20 par 5 est 4.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 15 + 9 - 5 ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "15 plus 9 moins 5 donne 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la différence entre 50 et 18 + 12 ?",
    options: ["20", "22", "18"],
    answer: "20",
    explanation: "50 moins la somme de 18 et 12 est 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) x 3 ?",
    options: ["30", "24", "36"],
    answer: "30",
    explanation: "La somme de 6 et 4 multipliée par 3 donne 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 8 x 3 - 10 ?",
    options: ["14", "22", "24"],
    answer: "14",
    explanation: "8 multiplié par 3 moins 10 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + 2 x 5 ?",
    options: ["16", "12", "10"],
    answer: "16",
    explanation:
        "Selon l'ordre des opérations, 2 x 5 est calculé avant d'ajouter 6, donnant 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait (5 + 3) x 2 - 4 ?",
    options: ["12", "14", "10"],
    answer: "12",
    explanation: "La somme de 5 et 3 multipliée par 2, moins 4, donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (3 x 4) ?",
    options: ["13", "17", "15"],
    answer: "13",
    explanation: "25 moins le produit de 3 et 4 donne 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 3 x 4 + 2 ?",
    options: ["14", "10", "12"],
    answer: "14",
    explanation: "Le produit de 3 et 4, additionné de 2, donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 7 ?",
    options: ["15", "16", "14"],
    answer: "16",
    explanation: "La division de 18 par 2, ajoutée de 7, donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 9 ?",
    options: ["6", "5", "4"],
    answer: "6",
    explanation: "La soustraction de 15 et 9 donne 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 5 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation: "30 divisé par 5 est égal à 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 12 × 3 ?",
    options: ["36", "34", "38"],
    answer: "36",
    explanation: "12 multiplié par 3 donne 36.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 - 7 + 3 ?",
    options: ["20", "21", "22"],
    answer: "20",
    explanation: "24 moins 7 plus 3 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × (2 + 1) ?",
    options: ["27", "28", "26"],
    answer: "27",
    explanation: "9 multiplié par 3 (2 + 1) donne 27.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 + 3) × 2 ?",
    options: ["20", "22", "18"],
    answer: "20",
    explanation: "La somme de 7 et 3 est 10, multiplié par 2 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (8 × 4) ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "50 moins 32 (8 multiplié par 4) donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (3 + 5) - 4 ?",
    options: ["12", "10", "8"],
    answer: "12",
    explanation: "2 multiplié par 8 (3 + 5) moins 4 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) × (3 - 1) ?",
    options: ["20", "24", "22"],
    answer: "20",
    explanation: "10 multiplié par 2 (3 - 1) donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ 5 + 15 ?",
    options: ["25", "30", "35"],
    answer: "30",
    explanation: "100 divisé par 5 donne 20, plus 15 donne 35.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 6 - (4 + 2) ?",
    options: ["28", "30", "26"],
    answer: "28",
    explanation: "30 moins 6 (4 + 2) donne 28.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 ÷ (2 + 2) × 5 ?",
    options: ["50", "40", "60"],
    answer: "50",
    explanation: "40 divisé par 4 (2 + 2) donne 10, multiplié par 5 donne 50.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 12 - 4 ?",
    options: ["8", "9", "7"],
    answer: "8",
    explanation: "Soustraire 4 de 12 donne 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 20 ÷ 5 ?",
    options: ["4", "5", "6"],
    answer: "4",
    explanation: "Diviser 20 par 5 donne 4.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 6 × (2 + 1) ?",
    options: ["18", "12", "15"],
    answer: "18",
    explanation: "On calcule d'abord 2 + 1, puis on multiplie par 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculer 9 - (3 × 2) ?",
    options: ["3", "5", "4"],
    answer: "3",
    explanation: "On effectue d'abord la multiplication puis la soustraction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de (6 + 2) × 3 - 5 ?",
    options: ["19", "17", "21"],
    answer: "19",
    explanation:
        "On effectue d'abord l'addition, puis la multiplication et enfin la soustraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 5 - (3 + 2) ?",
    options: ["15", "10", "20"],
    answer: "15",
    explanation:
        "On commence par multiplier, puis on soustrait le résultat de l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculer 18 ÷ (2 + 4) + 3 ?",
    options: ["6", "5", "4"],
    answer: "6",
    explanation:
        "On effectue d'abord l'addition, puis la division et enfin l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (5 × 4) + 2 ?",
    options: ["12", "22", "18"],
    answer: "22",
    explanation: "On commence par multiplier, puis on soustrait et on ajoute.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 50 ÷ (5 + 5) × 2 ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation:
        "On effectue d'abord l'addition, puis la division et enfin la multiplication.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculer (3 + 4) × (2 - 1) ?",
    options: ["7", "6", "8"],
    answer: "7",
    explanation: "On additionne et on soustrait avant de multiplier.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 4 ?",
    options: ["20", "24", "18"],
    answer: "24",
    explanation: "Multiplier 6 par 4 donne 24.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 6 - 4 ?",
    options: ["11", "10", "12"],
    answer: "11",
    explanation: "9 plus 6 moins 4 donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 5 + 7 ?",
    options: ["22", "20", "17"],
    answer: "22",
    explanation: "Multiplier 3 par 5 donne 15, puis ajouter 7 donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 3) ÷ 2 + 4 ?",
    options: ["8", "10", "7"],
    answer: "10",
    explanation:
        "Soustraire 3 de 15 donne 12, diviser par 2 donne 6, puis ajouter 4 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 + (6 - 2) × 3 ?",
    options: ["23", "22", "21"],
    answer: "23",
    explanation:
        "D'abord soustraire 2 de 6, ce qui donne 4, puis multiplier par 3 donne 12, et 11 plus 12 donne 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (3 + 2) - 4 ?",
    options: ["21", "22", "19"],
    answer: "21",
    explanation:
        "Additionner 3 et 2 donne 5, multiplier par 5 donne 25, puis soustraire 4 donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 3 - 5 ?",
    options: ["22", "27", "32"],
    answer: "22",
    explanation: "9 multiplié par 3 moins 5 est égal à 22.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + (6 ÷ 2) ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "10 plus 6 divisé par 2 donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 3) × 4 + 2 ?",
    options: ["20", "22", "18"],
    answer: "20",
    explanation: "La différence de 8 et 3 multipliée par 4, plus 2, donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 6 ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation: "25 divisé par 5 plus 6 est égal à 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 5) ÷ 3 ?",
    options: ["5", "4", "3"],
    answer: "5",
    explanation: "La somme de 10 et 5 divisée par 3 donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 7 + 2 ?",
    options: ["11", "13", "9"],
    answer: "13",
    explanation: "D'abord, 18 - 7 donne 11, puis 11 + 2 donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (3 + 1) ?",
    options: ["12", "16", "8"],
    answer: "16",
    explanation: "Il faut d'abord additionner 3 et 1, puis multiplier par 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 - 5) ÷ 3 ?",
    options: ["5", "4", "3"],
    answer: "5",
    explanation: "D'abord, 20 - 5 donne 15, puis 15 ÷ 3 donne 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 5 - 2 ?",
    options: ["13", "15", "10"],
    answer: "13",
    explanation: "Multiplier 3 par 5 donne 15, puis soustraire 2 donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 ÷ 4 + 6 ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation: "Diviser 8 par 4 donne 2, puis 2 + 6 donne 10.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 7 ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "20 moins 7 égale 13.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 81 ÷ 9 ?",
    options: ["7", "8", "9"],
    answer: "9",
    explanation: "81 divisé par 9 égale 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 6 - 5 ?",
    options: ["15", "16", "14"],
    answer: "16",
    explanation: "15 plus 6 moins 5 égale 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - 2 × 10 ?",
    options: ["30", "40", "20"],
    answer: "30",
    explanation: "50 moins 2 multiplié par 10 égale 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + (6 × 2) - 5 ?",
    options: ["16", "17", "18"],
    answer: "17",
    explanation: "9 plus 6 multiplié par 2, moins 5, égale 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (3 + 5) - 6 ?",
    options: ["22", "26", "30"],
    answer: "22",
    explanation: "4 multiplié par la somme de 3 et 5, moins 6, donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 ÷ 3) + (4 × 2) ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation: "La division de 12 par 3 plus 4 multiplié par 2 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 5 × 3 ?",
    options: ["10", "15", "20"],
    answer: "10",
    explanation: "25 moins 5 multiplié par 3 égale 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + 7 ?",
    options: ["12", "10", "13"],
    answer: "12",
    explanation: "5 + 7 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 6 ?",
    options: ["9", "8", "7"],
    answer: "9",
    explanation: "15 - 6 égale 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × 3 ?",
    options: ["24", "18", "20"],
    answer: "24",
    explanation: "(6 + 2) égale 8, et 8 × 3 égale 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 4 ?",
    options: ["14", "12", "10"],
    answer: "14",
    explanation: "50 divisé par 5 donne 10, et 10 + 4 égale 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (4 + 5) - 6 ?",
    options: ["21", "27", "18"],
    answer: "21",
    explanation: "3 × 9 (4 + 5) moins 6 donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 3) × (2 + 1) ?",
    options: ["15", "12", "18"],
    answer: "15",
    explanation: "(5) × (3) donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (20 ÷ 4) × 3 ?",
    options: ["75", "85", "70"],
    answer: "85",
    explanation: "(5 × 3) soustrait de 100 donne 85.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 + 4 ÷ 2 ?",
    options: ["22", "23", "21"],
    answer: "23",
    explanation: "21 plus 2 donne 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 × 2 - (5 + 3) ?",
    options: ["12", "10", "8"],
    answer: "12",
    explanation: "20 moins 8 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) × 2 - 5 ?",
    options: ["15", "20", "10"],
    answer: "15",
    explanation: "20 moins 5 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (3 + 1) ?",
    options: ["28", "26", "30"],
    answer: "28",
    explanation: "La multiplication de 7 par la somme de 3 et 1 donne 28.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (6 × 6) ?",
    options: ["14", "16", "18"],
    answer: "14",
    explanation: "La soustraction de 36 de 50 donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) × (2 + 1) ?",
    options: ["24", "20", "32"],
    answer: "24",
    explanation: "La multiplication de 8 par 3 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ (5 + 5) × 2 ?",
    options: ["10", "20", "5"],
    answer: "10",
    explanation: "La division de 100 par 10, multipliée par 2, donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 - 4) × (3 + 1) ?",
    options: ["32", "28", "24"],
    answer: "32",
    explanation: "La multiplication de 8 par 4 donne 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 + 1) × 5 - 10 ?",
    options: ["40", "38", "42"],
    answer: "40",
    explanation: "La multiplication de 10 par 5, moins 10, donne 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (9 ÷ 3) × 2 ?",
    options: ["14", "16", "12"],
    answer: "14",
    explanation:
        "La division de 9 par 3, multipliée par 2, donne 6, et 18 moins 6 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 6 - 2 ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "La somme de 9 et 6, moins 2, est 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (6 ÷ 2) ?",
    options: ["15", "16", "17"],
    answer: "15",
    explanation: "La division donne 3, donc 18 - 3 = 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (5 + 5) × 2 ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation:
        "On effectue d'abord l'addition : 5 + 5 = 10, puis 50 ÷ 10 × 2 = 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 2 + 10 ÷ 5 ?",
    options: ["13", "14", "15"],
    answer: "14",
    explanation:
        "On effectue d'abord la division : 10 ÷ 5 = 2, puis 7 × 2 + 2 = 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 6) × (2 - 1) ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation: "On calcule d'abord les parenthèses : 10 × 1 = 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 3 × (2 + 1) ?",
    options: ["12", "15", "18"],
    answer: "18",
    explanation:
        "On effectue d'abord les parenthèses : 2 + 1 = 3, donc 9 + 3 × 3 = 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 5 + 4 × 2 ?",
    options: ["8", "10", "12"],
    answer: "12",
    explanation:
        "On effectue d'abord la division et la multiplication : 6 + 8 = 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (3 × 5) + 2 ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation:
        "On effectue d'abord la multiplication : 3 × 5 = 15, donc 25 - 15 + 2 = 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (2 + 1) ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation:
        "La somme dans les parenthèses est 3, multiplié par 6 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (5 × 4) ?",
    options: ["10", "15", "20"],
    answer: "10",
    explanation: "La multiplication donne 20, donc 30 - 20 est 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 + 7 - 3 ?",
    options: ["15", "16", "17"],
    answer: "15",
    explanation: "La somme de 11 et 7 est 18, moins 3 donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 5 ?",
    options: ["10", "15", "20"],
    answer: "15",
    explanation: "La division donne 10, plus 5 est 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 - (9 ÷ 3) ?",
    options: ["42", "43", "44"],
    answer: "42",
    explanation: "La division donne 3, donc 45 - 3 est 42.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 ÷ 5 ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation: "45 ÷ 5 = 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 + 15 - 5 ?",
    options: ["30", "35", "40"],
    answer: "30",
    explanation: "20 + 15 - 5 = 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (4 + 2) ?",
    options: ["36", "42", "48"],
    answer: "36",
    explanation: "6 × (4 + 2) = 36.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - 20 ÷ 4 ?",
    options: ["45", "48", "47"],
    answer: "48",
    explanation: "50 - 20 ÷ 4 = 48.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 × 2 - 5 ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "12 × 2 - 5 = 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (3 + 5) - 10 ?",
    options: ["22", "24", "26"],
    answer: "22",
    explanation: "4 × (3 + 5) - 10 = 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 - 2) × (5 + 3) ?",
    options: ["40", "36", "42"],
    answer: "40",
    explanation: "(7 - 2) × (5 + 3) = 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 2 + 10 ?",
    options: ["25", "20", "15"],
    answer: "20",
    explanation: "30 ÷ 2 + 10 = 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 5 + 5 ?",
    options: ["35", "30", "25"],
    answer: "30",
    explanation: "5 × 5 + 5 = 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ 4 + 25 ?",
    options: ["50", "75", "80"],
    answer: "75",
    explanation: "100 ÷ 4 + 25 = 75.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (3 × 10) + 5 ?",
    options: ["35", "40", "45"],
    answer: "35",
    explanation: "50 - 30 + 5 donne 35.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) ÷ 2 × 5 ?",
    options: ["20", "25", "30"],
    answer: "25",
    explanation: "(6 + 4) donne 10, et 10 ÷ 2 × 5 donne 25.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 3 ?",
    options: ["12", "9", "15"],
    answer: "12",
    explanation: "Diviser 18 par 2 puis ajouter 3 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (4 + 2) - 5 ?",
    options: ["13", "10", "15"],
    answer: "13",
    explanation:
        "Multiplier 3 par la somme de 4 et 2 puis soustraire 5 donne 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (4 × 3) + 7 ?",
    options: ["20", "21", "22"],
    answer: "20",
    explanation: "Soustraire 12 de 25 puis ajouter 7 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (5 - 3) + 10 ?",
    options: ["25", "20", "15"],
    answer: "25",
    explanation: "Diviser 30 par 2 puis ajouter 10 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (4 + 6) ÷ 5 ?",
    options: ["4", "5", "6"],
    answer: "4",
    explanation: "Multiplier 2 par 10 puis diviser par 5 donne 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 9 - 4 ?",
    options: ["5", "6", "7"],
    answer: "5",
    explanation: "Le résultat de 9 - 4 est 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 15 ÷ 3 ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "Le résultat de 15 ÷ 3 est 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 10 × 3 - 5 ?",
    options: ["25", "20", "15"],
    answer: "25",
    explanation: "Le résultat de 10 × 3 - 5 est 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (6 + 4) ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation: "Le résultat de 20 - (6 + 4) est 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 2 × 6 ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation: "Le résultat de 50 ÷ 5 + 2 × 6 est 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 5 - 6 ÷ 3 ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "Le résultat de 4 × 5 - 6 ÷ 3 est 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 + 3 × 3 ?",
    options: ["9", "12", "15"],
    answer: "12",
    explanation: "Le résultat de 3 + 3 × 3 est 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 16 ÷ 4 + 5 × 2 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "Le résultat de 16 ÷ 4 + 5 × 2 est 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 2 - (3 + 1) ?",
    options: ["10", "11", "12"],
    answer: "10",
    explanation: "Le résultat de 7 × 2 - (3 + 1) est 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 6 + 2 ?",
    options: ["14", "16", "12"],
    answer: "14",
    explanation: "Il s'agit d'une soustraction suivie d'une addition.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 ÷ 2 + 3 × 2 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation:
        "Cette question implique plusieurs opérations avec des priorités.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 3) × 3 ?",
    options: ["15", "18", "12"],
    answer: "18",
    explanation:
        "Cette question nécessite une soustraction suivie d'une multiplication.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 ÷ (2 + 2) ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation:
        "Il s'agit d'une division après une addition dans les parenthèses.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ 6 + 5 ?",
    options: ["11", "9", "10"],
    answer: "11",
    explanation: "En divisant 36 par 6 puis en ajoutant 5, on obtient 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 6) × (3 - 1) ?",
    options: ["20", "30", "10"],
    answer: "20",
    explanation:
        "La somme de 4 et 6, multipliée par la différence de 3 et 1, donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ (5 × 2) + 10 ?",
    options: ["30", "20", "25"],
    answer: "20",
    explanation:
        "En multipliant 5 par 2, divisant 100 et ajoutant 10, on obtient 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (2 + 3) × (4 - 1) + 5 ?",
    options: ["20", "25", "15"],
    answer: "20",
    explanation:
        "La somme de 2 et 3, multipliée par la différence de 4 et 1, plus 5, donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 - (9 ÷ 3) × 4 ?",
    options: ["33", "36", "30"],
    answer: "33",
    explanation:
        "En effectuant la division puis la multiplication, on soustrait 12 de 45 pour obtenir 33.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - 5 + 2 ?",
    options: ["16", "18", "19"],
    answer: "16",
    explanation: "La multiplication de 7 par 3, moins 5, plus 2, donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 2 ?",
    options: ["6", "8", "5"],
    answer: "6",
    explanation:
        "D'abord, 18 divisé par 3 donne 6, puis on ajoute 2 pour obtenir 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (3 x 2) ?",
    options: ["3", "5", "7"],
    answer: "3",
    explanation:
        "On multiplie d'abord 3 par 2 pour obtenir 6, puis on soustrait de 9, ce qui donne 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (2 x 10) + 5 ?",
    options: ["35", "40", "30"],
    answer: "35",
    explanation:
        "On commence par multiplier 2 par 10 pour obtenir 20, puis on soustrait de 50 et ajoute 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 x 3) + (2 x 5) ?",
    options: ["22", "26", "20"],
    answer: "22",
    explanation:
        "On multiplie 4 par 3 pour obtenir 12 et 2 par 5 pour obtenir 10, puis on additionne les deux résultats.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 2 x 3 ?",
    options: ["14", "16", "18"],
    answer: "14",
    explanation:
        "On effectue d'abord la multiplication 2 x 3 pour obtenir 6, puis on additionne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 - (4 ÷ 2) ?",
    options: ["5", "4", "6"],
    answer: "5",
    explanation: "On divise 4 par 2 pour obtenir 2, puis on soustrait de 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 x (4 + 2) - 5 ?",
    options: ["15", "10", "12"],
    answer: "15",
    explanation:
        "On additionne 4 et 2 pour obtenir 6, puis on multiplie par 3 et soustrait 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 × 2 - 5 = ?",
    options: ["9", "10", "11"],
    answer: "9",
    explanation:
        "Sept multiplié par deux est quatorze, et en soustrayant cinq, on obtient neuf.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 - 3 + 2 = ?",
    options: ["5", "6", "7"],
    answer: "7",
    explanation:
        "Huit moins trois donne cinq, et en ajoutant deux, on obtient sept.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(3 + 5) × 2 = ?",
    options: ["12", "16", "14"],
    answer: "16",
    explanation: "Trois plus cinq est huit, et multiplié par deux donne seize.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) ÷ 2 = ?",
    options: ["4", "3", "5"],
    answer: "4",
    explanation: "Dix moins deux est huit, et divisé par deux donne quatre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - (3 × 2) = ?",
    options: ["9", "11", "12"],
    answer: "9",
    explanation:
        "Trois multiplié par deux est six, et quinze moins six donne neuf.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 ÷ 4) + (3 × 2) = ?",
    options: ["11", "10", "12"],
    answer: "11",
    explanation: "Vingt divisé par quatre est cinq, et six ajouté donne onze.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 + 4) × 3 - 5 = ?",
    options: ["25", "28", "20"],
    answer: "25",
    explanation:
        "Dix multiplié par trois est trente, et en soustrayant cinq, on obtient vingt-cinq.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 ÷ 2) + (5 × 3) = ?",
    options: ["25", "24", "26"],
    answer: "24",
    explanation:
        "Dix-huit divisé par deux est neuf, et quinze ajouté donne vingt-quatre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(25 ÷ 5) × (6 - 1) = ?",
    options: ["25", "30", "20"],
    answer: "25",
    explanation: "Cinq multiplié par cinq donne vingt-cinq.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(14 ÷ 2) + (8 - 3) = ?",
    options: ["12", "15", "10"],
    answer: "12",
    explanation: "Sept plus cinq donne douze.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(16 - 4) ÷ 2 + 5 = ?",
    options: ["11", "10", "12"],
    answer: "11",
    explanation:
        "Douze divisé par deux est six, et en ajoutant cinq, on obtient onze.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(30 ÷ 6) + (7 × 2) = ?",
    options: ["20", "18", "22"],
    answer: "20",
    explanation: "Cinq plus quatorze donne dix-neuf.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (18 - 3) ÷ 3 ?",
    options: ["5", "6", "7"],
    answer: "5",
    explanation: "(18 - 3) divisé par 3 donne 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 × 3 - 5 ?",
    options: ["25", "28", "30"],
    answer: "25",
    explanation: "10 multiplié par 3 moins 5 donne 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ (5 - 2) ?",
    options: ["5", "7", "10"],
    answer: "5",
    explanation: "25 divisé par (5 - 2) donne 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (50 - 10) ÷ 2 + 5 ?",
    options: ["25", "30", "35"],
    answer: "25",
    explanation: "(50 - 10) divisé par 2 plus 5 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × 3 - 10 ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation: "(6 + 2) multiplié par 3 moins 10 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 5 + 2 × 6 ?",
    options: ["36", "30", "28"],
    answer: "36",
    explanation: "3 multiplié par 5 plus 2 multiplié par 6 donne 36.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ (2 + 2) + 5 ?",
    options: ["8", "7", "6"],
    answer: "8",
    explanation: "12 divisé par (2 + 2) plus 5 donne 8.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 5) × 2 ?",
    options: ["25", "30", "20"],
    answer: "30",
    explanation: "La somme de 10 et 5, multipliée par 2, est 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 × 3) - (2 × 4) ?",
    options: ["20", "22", "24"],
    answer: "20",
    explanation: "Le produit de 24 moins 8 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 2 + 10 ?",
    options: ["20", "25", "30"],
    answer: "25",
    explanation: "La division donne 25, auquel on ajoute 10 pour obtenir 35.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (3 + 1) × 2 ?",
    options: ["6", "8", "10"],
    answer: "10",
    explanation: "La soustraction de 14 moins 8 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 4 - 10 ?",
    options: ["18", "20", "28"],
    answer: "18",
    explanation: "Le produit de 28 moins 10 donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 5 + 12 ?",
    options: ["32", "20", "28"],
    answer: "32",
    explanation: "Le produit de 20, plus 12, est 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 + 8 - 2 ?",
    options: ["9", "8", "10"],
    answer: "9",
    explanation: "La somme de 3 et 8, moins 2, est 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + 9 - 3 ?",
    options: ["12", "10", "11"],
    answer: "12",
    explanation: "La somme de 6 et 9, moins 3, est 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 3 + 2 ?",
    options: ["15", "16", "17"],
    answer: "17",
    explanation: "18 moins 3 plus 2 donne 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 4 ?",
    options: ["32", "36", "28"],
    answer: "32",
    explanation: "La différence de 10 et 2 multipliée par 4 donne 32.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 + 4 × 2 ?",
    options: ["10", "14", "11"],
    answer: "11",
    explanation:
        "D'après l'ordre des opérations, 4 multiplié par 2 puis ajouté à 3 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) × (6 - 2) ?",
    options: ["32", "30", "40"],
    answer: "32",
    explanation:
        "La somme de 5 et 3 multipliée par la différence de 6 et 2 donne 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ (4 + 4) ?",
    options: ["2", "3", "4"],
    answer: "3",
    explanation: "24 divisé par la somme de 4 et 4 donne 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (3 - 1) + 5 ?",
    options: ["19", "18", "20"],
    answer: "19",
    explanation:
        "7 multiplié par la différence de 3 et 1, puis ajouté à 5 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 ÷ 2) + (6 - 1) ?",
    options: ["11", "10", "12"],
    answer: "11",
    explanation:
        "La division de 8 par 2 plus la différence de 6 et 1 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 + 4) ÷ 4 ?",
    options: ["4", "3", "5"],
    answer: "4",
    explanation: "La somme de 12 et 4 divisée par 4 donne 4.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 15 - 7 ?",
    options: ["6", "8", "7"],
    answer: "8",
    explanation: "15 - 7 donne 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 12 + 15 - 6 ?",
    options: ["21", "20", "19"],
    answer: "21",
    explanation: "12 + 15 - 6 donne 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de (8 + 2) × 3 ?",
    options: ["30", "24", "32"],
    answer: "30",
    explanation: "(8 + 2) multiplié par 3 égale 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (3 + 2) - 5 ?",
    options: ["30", "25", "32"],
    answer: "30",
    explanation: "7 multiplié par (3 + 2) moins 5 égale 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 2 × (6 + 4) ÷ 2 ?",
    options: ["10", "12", "20"],
    answer: "10",
    explanation: "2 multiplié par (6 + 4) divisé par 2 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 4 - (3 × 2) ?",
    options: ["14", "18", "16"],
    answer: "14",
    explanation: "5 multiplié par 4 moins (3 multiplié par 2) égale 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 50 - (6 × 7) + 4 ?",
    options: ["12", "14", "10"],
    answer: "12",
    explanation: "50 moins (6 multiplié par 7) plus 4 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 + 9 ÷ 3 × 2 ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation: "3 plus 9 divisé par 3 multiplié par 2 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait (5 × 3) + (12 ÷ 4) ?",
    options: ["18", "17", "15"],
    answer: "18",
    explanation: "(5 multiplié par 3) plus (12 divisé par 4) égale 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 16 ÷ 4 + 2 × 3 ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "16 divisé par 4 plus 2 multiplié par 3 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 9 - 6 ?",
    options: ["18", "19", "20"],
    answer: "18",
    explanation: "15 + 9 - 6 égale 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 7 + 3 ?",
    options: ["20", "21", "22"],
    answer: "21",
    explanation: "25 - 7 + 3 égale 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (30 ÷ 5) × 2 ?",
    options: ["10", "12", "8"],
    answer: "12",
    explanation: "(30 ÷ 5) × 2 égale 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + (2 × 3) - 4 ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "8 + (2 × 3) - 4 égale 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (50 - 20) ÷ 5 + 3 ?",
    options: ["5", "7", "8"],
    answer: "7",
    explanation: "(50 - 20) ÷ 5 + 3 égale 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (5 - 2) + 4 ?",
    options: ["22", "20", "24"],
    answer: "22",
    explanation: "6 × (5 - 2) + 4 égale 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 2 × 3 - 4 ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation: "10 + 2 × 3 - 4 égale 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 4 × 2 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "18 ÷ 3 + 4 × 2 égale 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ (6 + 6) ?",
    options: ["3", "2", "4"],
    answer: "3",
    explanation: "36 ÷ (6 + 6) égale 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 3 - 15 ?",
    options: ["12", "18", "24"],
    answer: "12",
    explanation: "9 × 3 - 15 égale 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 6 - 10 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "La somme de 15 et 6, moins 10, donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 3 - 5 ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "La multiplication de 8 par 3, moins 5, donne 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ (5 × 2) + 15 ?",
    options: ["20", "25", "30"],
    answer: "25",
    explanation: "La division de 100 par 10, plus 15, donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 5 + 4 × 2 ?",
    options: ["25", "26", "27"],
    answer: "27",
    explanation: "La multiplication et addition respectives donnent 27.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 - (12 ÷ 3) ?",
    options: ["36", "38", "39"],
    answer: "38",
    explanation: "La soustraction de 4 à 40, après la division, donne 38.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 3 + 2 ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "La soustraction et addition respectives donnent 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - 2 + 3 ?",
    options: ["9", "10", "11"],
    answer: "11",
    explanation: "La soustraction de 2 à 10, plus 3, donne 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 3 + 4 ?",
    options: ["28", "26", "30"],
    answer: "28",
    explanation: "On obtient 28 en suivant l'ordre des opérations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 2 + 4 ÷ 2 ?",
    options: ["18", "16", "20"],
    answer: "18",
    explanation:
        "En effectuant les opérations dans le bon ordre, on obtient 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (5 + 5) × 2 ?",
    options: ["5", "10", "15"],
    answer: "10",
    explanation: "Le calcul donne 10 après avoir simplifié l'expression.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 3) + (6 ÷ 2) ?",
    options: ["20", "19", "18"],
    answer: "19",
    explanation:
        "En effectuant les multiplications et divisions, on obtient 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 + 8 × 2 ?",
    options: ["20", "24", "16"],
    answer: "20",
    explanation: "En respectant l'ordre des opérations, le résultat est 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 6 - 4 ?",
    options: ["9", "10", "11"],
    answer: "9",
    explanation: "La somme de 7 et 6, moins 4, donne 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 - 4) ÷ 4 ?",
    options: ["4", "5", "6"],
    answer: "4",
    explanation:
        "On soustrait d'abord 4 à 20, puis on divise par 4 : 16 ÷ 4 = 4.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 6 - 3 ?",
    options: ["9", "10", "11"],
    answer: "10",
    explanation: "La somme de 7 et 6, moins 3, donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - (2 × 3) + 5 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "12 moins 6, plus 5, donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - (2 + 3) × 2 ?",
    options: ["0", "1", "2"],
    answer: "0",
    explanation:
        "La somme de 2 et 3 est 5, multiplié par 2 donne 10, donc 10 moins 10 est 0.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (3 + 1) - 6 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "La somme de 3 et 1 est 4, 4 fois 4 est 16, moins 6 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (5 × 3) + 2 ?",
    options: ["17", "18", "19"],
    answer: "18",
    explanation: "5 fois 3 est 15, 25 moins 15 plus 2 donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 2 + 3 ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "10 moins 2 est 8, 8 fois 2 est 16, et 16 plus 3 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ (2 + 4) ?",
    options: ["2", "3", "4"],
    answer: "3",
    explanation: "La division de 18 par la somme de 2 et 4 donne 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (6 - 2) ?",
    options: ["24", "28", "30"],
    answer: "28",
    explanation: "La multiplication de 7 par la différence de 6 et 2 donne 28.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ (3 + 3) ?",
    options: ["3", "4", "5"],
    answer: "4",
    explanation: "La division de 24 par la somme de 3 et 3 donne 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 2 - 5 ?",
    options: ["11", "12", "13"],
    answer: "11",
    explanation: "Le produit de 8 et 2, diminué de 5, donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (2 + 2) × (3 + 1) ?",
    options: ["12", "10", "8"],
    answer: "8",
    explanation:
        "La somme de 2 et 2, multipliée par la somme de 3 et 1, donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 16 ÷ 2 + 4 ?",
    options: ["10", "8", "6"],
    answer: "8",
    explanation: "La division de 16 par 2, augmentée de 4, donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) × (2 - 1) ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation:
        "La somme de 6 et 4, multipliée par la différence de 2 et 1, est 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (5 + 3) ÷ 2 ?",
    options: ["16", "14", "12"],
    answer: "16",
    explanation: "Quatre fois la somme de 5 et 3, divisée par 2, donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 ÷ 4) + (3 × 5) ?",
    options: ["25", "20", "30"],
    answer: "25",
    explanation:
        "La division de 20 par 4, ajoutée au produit de 3 et 5, donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 3 - (4 ÷ 2) ?",
    options: ["25", "26", "27"],
    answer: "25",
    explanation:
        "La multiplication de 9 par 3, moins la division de 4 par 2, est 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 5) × 2 + 3 ?",
    options: ["23", "25", "22"],
    answer: "23",
    explanation:
        "La différence de 15 et 5, multipliée par 2 et ajoutée à 3, est 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (2 + 4) ?",
    options: ["18", "21", "20"],
    answer: "18",
    explanation: "3 multiplié par la somme de 2 et 4 donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (6 × 7) ?",
    options: ["8", "2", "5"],
    answer: "2",
    explanation: "50 moins 42 donne 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 2 + 6 ÷ 3 ?",
    options: ["8", "9", "7"],
    answer: "8",
    explanation: "3 multiplié par 2 plus 2 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 3 + 5 ?",
    options: ["25", "27", "28"],
    answer: "28",
    explanation: "La multiplication de 8 par 3 plus 5 donne 29.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 ÷ 2 + 6 ?",
    options: ["10", "9", "8"],
    answer: "10",
    explanation: "Diviser 14 par 2 et ajouter 6 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - 8 ?",
    options: ["13", "21", "15"],
    answer: "13",
    explanation: "La multiplication de 7 par 3 moins 8 donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) × 2 - 6 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "La somme de 5 et 3, multipliée par 2, moins 6 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + 2 × (3 - 1) ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "6 plus 4 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 7 - 5 ?",
    options: ["17", "18", "16"],
    answer: "17",
    explanation: "15 plus 7 moins 5 égalent 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 x 4 - 10 ?",
    options: ["26", "36", "22"],
    answer: "26",
    explanation:
        "La multiplication de 9 par 4 donne 36, puis 36 moins 10 égalent 26.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (6 x 4) ?",
    options: ["6", "12", "18"],
    answer: "6",
    explanation: "30 moins 24 (6 fois 4) donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 7 ?",
    options: ["9", "10", "11"],
    answer: "11",
    explanation: "18 divisé par 3 donne 6, et 6 plus 7 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (3 x 2) + 5 ?",
    options: ["16", "15", "14"],
    answer: "15",
    explanation:
        "D'abord, 3 fois 2 est 6, ensuite 14 moins 6 est 8, et 8 plus 5 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 8 - 3 ?",
    options: ["12", "11", "13"],
    answer: "12",
    explanation: "La somme de 7 et 8 est 15, et 15 moins 3 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 10 ÷ 2 ?",
    options: ["20", "15", "22"],
    answer: "20",
    explanation: "D'abord, 10 divisé par 2 donne 5, puis 25 moins 5 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 18 ÷ 2 ?",
    options: ["7", "8", "9"],
    answer: "9",
    explanation: "18 divisé par 2 donne 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 14 - 4 ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "9 plus 14 moins 4 égale 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (3 × 4) ?",
    options: ["8", "10", "12"],
    answer: "8",
    explanation: "20 moins 12 donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (2 + 3) ?",
    options: ["20", "22", "24"],
    answer: "20",
    explanation: "4 multiplié par la somme de 2 et 3 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 3 + 2 ?",
    options: ["20", "22", "24"],
    answer: "20",
    explanation: "6 multiplié par 3 plus 2 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 2 + 3 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "La somme de 8 et 4 divisée par 2, plus 3 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 ÷ 3) + (5 × 2) ?",
    options: ["14", "15", "16"],
    answer: "14",
    explanation: "La somme de 4 et 10 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - 6 ÷ 3 = ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation:
        "6 divisé par 3 donne 2, et en soustrayant de 15, on obtient 13.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 + (5 × 2) = ?",
    options: ["16", "18", "20"],
    answer: "18",
    explanation: "5 multiplié par 2 donne 10, et en ajoutant 8, on obtient 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 ÷ 4) + (3 × 5) = ?",
    options: ["15", "16", "17"],
    answer: "17",
    explanation:
        "20 divisé par 4 donne 5, et 3 multiplié par 5 donne 15, soit 5 + 15 = 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 × 3) - (4 ÷ 2) = ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation:
        "6 multiplié par 3 donne 18, et 4 divisé par 2 donne 2, soit 18 - 2 = 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 + 3) × 2 - 6 = ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation:
        "9 plus 3 donne 12, multiplié par 2 donne 24, et en soustrayant 6, on obtient 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(25 - 5 × 3) ÷ 2 = ?",
    options: ["5", "7", "10"],
    answer: "5",
    explanation:
        "5 multiplié par 3 donne 15, 25 moins 15 donne 10, et 10 divisé par 2 donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 ÷ 3) + (6 × 2) = ?",
    options: ["14", "16", "18"],
    answer: "18",
    explanation:
        "18 divisé par 3 donne 6, et 6 multiplié par 2 donne 12, soit 6 + 12 = 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(40 - 8) ÷ (4 + 4) = ?",
    options: ["4", "5", "6"],
    answer: "4",
    explanation: "40 moins 8 donne 32, et 4 plus 4 donne 8, soit 32 ÷ 8 = 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(16 ÷ 2) + (10 - 3) = ?",
    options: ["13", "14", "15"],
    answer: "13",
    explanation:
        "16 divisé par 2 donne 8, et 10 moins 3 donne 7, soit 8 + 5 = 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(30 ÷ 6) × (2 + 1) = ?",
    options: ["5", "10", "15"],
    answer: "15",
    explanation:
        "30 divisé par 6 donne 5, et 2 plus 1 donne 3, soit 5 × 3 = 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 14 - 6 ?",
    options: ["20", "18", "22"],
    answer: "20",
    explanation: "12 + 14 - 6 égale 20.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 3) × 4 ?",
    options: ["20", "16", "24"],
    answer: "20",
    explanation: "La différence de 8 et 3, multipliée par 4, donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - (4 ÷ 2) ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation:
        "La multiplication de 7 par 3, moins la division de 4 par 2, donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (5 × 3) + 2 ?",
    options: ["14", "15", "16"],
    answer: "14",
    explanation: "La soustraction de 5 multiplié par 3 à 25, plus 2, donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 ÷ 2) + (3 × 4) ?",
    options: ["15", "14", "16"],
    answer: "15",
    explanation: "La division de 6 par 2, plus 3 multiplié par 4, donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + (2 × 5) - 3 ?",
    options: ["17", "14", "18"],
    answer: "17",
    explanation: "La somme de 10 et 2 multiplié par 5, moins 3, donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 5 - 2 ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "La multiplication de 4 par 5, moins 2, donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (5 - 2) ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation: "La division de 30 par la différence de 5 et 2 est 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + 4 × 2 ?",
    options: ["14", "16", "12"],
    answer: "14",
    explanation:
        "On effectue d'abord la multiplication : 4 × 2 = 8, puis 6 + 8 = 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 2) × 4 ?",
    options: ["20", "18", "22"],
    answer: "20",
    explanation: "On commence par 3 + 2 = 5, puis 5 × 4 = 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (6 ÷ 2) ?",
    options: ["47", "48", "49"],
    answer: "49",
    explanation: "On effectue d'abord 6 ÷ 2 = 3, puis 50 - 3 = 47.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 6 × (3 - 1) ?",
    options: ["24", "30", "18"],
    answer: "24",
    explanation:
        "On effectue d'abord 3 - 1 = 2, puis 6 × 2 = 12, et enfin 12 + 12 = 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 5 × 2 ?",
    options: ["16", "14", "18"],
    answer: "16",
    explanation:
        "On effectue d'abord 18 ÷ 2 = 9, puis 5 × 2 = 10, et enfin 9 + 10 = 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (4 + 6) - 5 ?",
    options: ["25", "20", "30"],
    answer: "25",
    explanation:
        "On commence par 4 + 6 = 10, puis 3 × 10 = 30, et enfin 30 - 5 = 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 3) × (2 + 2) ?",
    options: ["20", "25", "15"],
    answer: "20",
    explanation:
        "On effectue d'abord 8 - 3 = 5, puis 2 + 2 = 4, et enfin 5 × 4 = 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 3 × 4 - 2 ?",
    options: ["21", "19", "17"],
    answer: "19",
    explanation:
        "On effectue d'abord 3 × 4 = 12, puis 7 + 12 = 19, et enfin 19 - 2 = 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (2 × 5) + 8 ?",
    options: ["28", "26", "30"],
    answer: "28",
    explanation:
        "On effectue d'abord 2 × 5 = 10, puis 30 - 10 = 20, et enfin 20 + 8 = 28.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 2 + 1 ?",
    options: ["19", "20", "18"],
    answer: "19",
    explanation: "La multiplication de 9 par 2 plus 1 donne 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 2) × 3 ?",
    options: ["30", "33", "28"],
    answer: "30",
    explanation: "La somme de 8 et 2, multipliée par 3, est 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (5 + 3) ?",
    options: ["6", "5", "4"],
    answer: "6",
    explanation: "14 moins la somme de 5 et 3 donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 × 4) + (6 ÷ 2) ?",
    options: ["14", "12", "16"],
    answer: "14",
    explanation: "La multiplication et la division donnent 14 en tout.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (3 + 5) - 10 ?",
    options: ["50", "54", "56"],
    answer: "50",
    explanation: "Le produit moins 10 donne 50.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ (5 - 3) ?",
    options: ["12", "10", "15"],
    answer: "12",
    explanation: "La division de 25 par 2 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × (4 - 1) ?",
    options: ["24", "20", "18"],
    answer: "24",
    explanation: "La somme multipliée par la différence donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 - 3 + 5 ?",
    options: ["13", "12", "14"],
    answer: "13",
    explanation: "La soustraction suivie de l'addition donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 4 × 3 ?",
    options: ["8", "12", "16"],
    answer: "12",
    explanation:
        "La multiplication est effectuée avant la soustraction, donc 20 - 12 = 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 6 ?",
    options: ["9", "12", "15"],
    answer: "12",
    explanation:
        "On divise d'abord 18 par 2, puis on ajoute 6, ce qui donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 × (2 + 3) ?",
    options: ["40", "50", "60"],
    answer: "50",
    explanation:
        "On additionne 2 et 3, puis on multiplie par 10, ce qui donne 50.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (3 × 5) + 10 ?",
    options: ["15", "20", "25"],
    answer: "20",
    explanation:
        "On effectue d'abord la multiplication, puis la soustraction et l'addition, ce qui donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ (4 + 4) × 5 ?",
    options: ["25", "50", "75"],
    answer: "25",
    explanation:
        "On additionne d'abord 4 et 4, puis on divise 100 par 8 et on multiplie par 5, ce qui donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - 2 × (5 + 5) ?",
    options: ["10", "20", "30"],
    answer: "10",
    explanation:
        "On effectue d'abord l'addition puis la multiplication, ce qui donne 10 après soustraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × (4 + 1) ?",
    options: ["40", "50", "60"],
    answer: "40",
    explanation:
        "On effectue les opérations à l'intérieur des parenthèses, puis on multiplie, ce qui donne 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 ÷ 2 + 3 × 2 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation:
        "On effectue d'abord la division puis la multiplication, et enfin l'addition, ce qui donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 6 - 3 ?",
    options: ["13", "14", "12"],
    answer: "13",
    explanation: "D'abord 10 + 6 = 16, puis 16 - 3 = 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - (3 + 2) ?",
    options: ["5", "6", "4"],
    answer: "5",
    explanation: "On calcule d'abord 3 + 2 = 5, puis 10 - 5 = 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (2 + 3) - 5 ?",
    options: ["15", "10", "20"],
    answer: "15",
    explanation: "On effectue d'abord 2 + 3 = 5, puis 4 × 5 - 5 = 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (5 × 2) ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation: "On calcule d'abord 5 × 2 = 10, puis 50 ÷ 10 = 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 3) × 3 + 1 ?",
    options: ["16", "15", "14"],
    answer: "16",
    explanation: "On effectue d'abord 8 - 3 = 5, puis 5 × 3 + 1 = 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (6 ÷ 2) × 3 ?",
    options: ["21", "24", "18"],
    answer: "21",
    explanation: "On effectue d'abord 6 ÷ 2 = 3, puis 30 - 3 × 3 = 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ 4 + 5 ?",
    options: ["8", "7", "6"],
    answer: "8",
    explanation: "On effectue d'abord 12 ÷ 4 = 3, puis 3 + 5 = 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 3 × 2 ?",
    options: ["12", "15", "18"],
    answer: "15",
    explanation: "On effectue d'abord 3 × 2 = 6, puis 9 + 6 = 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 16 ÷ 2 ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "La division de 16 par 2 donne 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (2 + 3) × 2 ?",
    options: ["8", "9", "10"],
    answer: "10",
    explanation: "La somme de 2 et 3 multipliée par 2 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (2 + 3) ?",
    options: ["5", "6", "4"],
    answer: "4",
    explanation: "La soustraction de la somme (2 + 3) à 9 donne 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (3 - 1) ?",
    options: ["14", "15", "16"],
    answer: "14",
    explanation: "La multiplication de 7 par la différence (3 - 1) donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 3 + 2 ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "La multiplication de 5 par 3, ajoutée à 2, donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 ÷ 2) + (5 × 2) ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation: "La somme de 3 et 10 donne 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 2 ?",
    options: ["4", "5", "6"],
    answer: "6",
    explanation: "La somme de 8 et 4, divisée par 2, donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 5 - 3 ?",
    options: ["12", "13", "14"],
    answer: "12",
    explanation: "La somme de 10 et 5, moins 3, donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 5) × 2 - 4 ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation: "La multiplication de 8 par 2, moins 4, donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 6 ?",
    options: ["20", "22", "24"],
    answer: "24",
    explanation: "La multiplication de 4 par 6 est 24.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) × 2 - 5 ?",
    options: ["19", "20", "17"],
    answer: "19",
    explanation: "12 multiplié par 2 moins 5 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) ÷ 2 + 3 ?",
    options: ["7", "8", "6"],
    answer: "7",
    explanation: "8 divisé par 2 est 4, donc 4 plus 3 donne 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (3 + 1) - 6 ?",
    options: ["14", "20", "10"],
    answer: "14",
    explanation: "5 multiplié par 4 est 20, moins 6 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 ÷ (5 + 5) ?",
    options: ["4", "2", "6"],
    answer: "4",
    explanation: "40 divisé par 10 est 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 6 ÷ 3 ?",
    options: ["11", "13", "14"],
    answer: "13",
    explanation: "6 divisé par 3 est 2, donc 9 plus 2 donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 7 ?",
    options: ["19", "20", "18"],
    answer: "19",
    explanation: "Il suffit d'additionner 12 et 7 pour obtenir 19.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 3 ?",
    options: ["24", "22", "26"],
    answer: "24",
    explanation: "La multiplication de 8 par 3 donne 24.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 22 - 14 + 5 ?",
    options: ["13", "11", "10"],
    answer: "13",
    explanation:
        "Il faut d'abord soustraire 14 de 22, puis ajouter 5 pour obtenir 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (8 - 2) + 6 ?",
    options: ["24", "30", "18"],
    answer: "30",
    explanation:
        "On commence par soustraire 2 de 8, puis multiplier par 3 et ajouter 6 pour obtenir 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 + 3) ÷ 3 × 4 ?",
    options: ["16", "12", "18"],
    answer: "12",
    explanation:
        "On additionne 9 et 3 pour obtenir 12, puis on divise par 3 et multiplie par 4 pour obtenir 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (20 ÷ 4) × 5 ?",
    options: ["75", "80", "85"],
    answer: "75",
    explanation:
        "D'abord, on divise 20 par 4 pour obtenir 5, puis on multiplie par 5 pour obtenir 25 et enfin on soustrait de 100 pour obtenir 75.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 + 5) × 2 - 10 ?",
    options: ["20", "30", "40"],
    answer: "20",
    explanation:
        "On additionne 15 et 5 pour obtenir 20, puis on multiplie par 2 et soustrait 10 pour obtenir 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (5 × 3) + 2 ?",
    options: ["20", "18", "22"],
    answer: "20",
    explanation:
        "On commence par multiplier 5 par 3 pour obtenir 15, puis on soustrait de 25 et ajoute 2 pour obtenir 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 ÷ 9 + 1 ?",
    options: ["6", "5", "7"],
    answer: "6",
    explanation:
        "On divise 45 par 9 pour obtenir 5, puis on ajoute 1 pour obtenir 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 2 - 4 ?",
    options: ["12", "10", "14"],
    answer: "12",
    explanation: "8 multiplié par 2 moins 4 égale 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 3 ?",
    options: ["8", "13", "10"],
    answer: "13",
    explanation: "50 divisé par 5 plus 3 égale 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 5) × (4 - 2) ?",
    options: ["16", "8", "12"],
    answer: "16",
    explanation:
        "La somme de 3 et 5 multipliée par la différence de 4 et 2 égale 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 9 ÷ 3 ?",
    options: ["12", "15", "18"],
    answer: "12",
    explanation: "9 plus 9 divisé par 3 égale 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 2 - 5 ?",
    options: ["9", "10", "11"],
    answer: "9",
    explanation: "7 multiplié par 2 moins 5 égale 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 6 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "25 divisé par 5 plus 6 égale 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - 3 × 2 ?",
    options: ["4", "2", "6"],
    answer: "4",
    explanation: "10 moins le produit de 3 et 2 égale 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 6 + 2 ?",
    options: ["9", "7", "11"],
    answer: "11",
    explanation: "15 moins 6 plus 2 est égal à 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 2 - 10 ?",
    options: ["6", "14", "4"],
    answer: "6",
    explanation: "8 multiplié par 2 moins 10 donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) × 3 - 5 ?",
    options: ["25", "20", "30"],
    answer: "25",
    explanation: "La multiplication de 10 par 3 moins 5 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (2 + 3) - 4 ÷ 2 ?",
    options: ["23", "24", "22"],
    answer: "23",
    explanation: "5 fois 5 moins 2 donne 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + (3 × 4) - 5 ?",
    options: ["22", "19", "20"],
    answer: "22",
    explanation: "7 plus 12 moins 5 donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (3 × 2) + 4 ?",
    options: ["10", "8", "9"],
    answer: "8",
    explanation: "9 moins 6 plus 4 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (5 × 2) + 3 ?",
    options: ["8", "10", "7"],
    answer: "8",
    explanation: "50 divisé par 10 plus 3 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 ?",
    options: ["6", "5", "7"],
    answer: "6",
    explanation: "18 divisé par 3 est égal à 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - 4 + 2 ?",
    options: ["10", "8", "9"],
    answer: "10",
    explanation: "12 moins 4 plus 2 est égal à 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 3 - 4 ?",
    options: ["11", "10", "12"],
    answer: "11",
    explanation: "5 multiplié par 3 donne 15, moins 4 égale 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (3 + 2) ?",
    options: ["35", "30", "25"],
    answer: "35",
    explanation: "7 multiplié par la somme de 3 et 2 (5) est 35.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (45 ÷ 5) ?",
    options: ["91", "89", "93"],
    answer: "91",
    explanation: "45 divisé par 5 est 9, 100 moins 9 donne 91.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × 3 - 5 ?",
    options: ["19", "21", "18"],
    answer: "19",
    explanation:
        "La somme de 6 et 2 est 8, multiplié par 3 donne 24, moins 5 est 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 3 - (6 ÷ 2) ?",
    options: ["25", "26", "27"],
    answer: "25",
    explanation:
        "9 multiplié par 3 est 27, 6 divisé par 2 est 3, donc 27 moins 3 est 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 4) + 12 - 10 ?",
    options: ["22", "24", "20"],
    answer: "22",
    explanation: "5 multiplié par 4 est 20, plus 12 donne 32, moins 10 est 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 + (9 - 3) × 2 ?",
    options: ["23", "21", "22"],
    answer: "23",
    explanation:
        "9 moins 3 est 6, multiplié par 2 donne 12, donc 11 plus 12 est 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ (6 - 2) ?",
    options: ["4", "6", "8"],
    answer: "6",
    explanation: "24 divisé par 4 (6 moins 2) donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 4 × 2 ?",
    options: ["16", "20", "12"],
    answer: "16",
    explanation: "4 multiplié par 2, plus 8, donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ 6 + 5 × 2 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "36 divisé par 6 plus 10 (5 fois 2) donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 10 + 4 × 2 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "5 plus 8 (4 multiplié par 2) donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 2 ÷ 3 ?",
    options: ["6", "3", "9"],
    answer: "6",
    explanation: "Le produit de 9 et 2 divisé par 3 donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + 2 × (3 - 1) ?",
    options: ["9", "11", "10"],
    answer: "9",
    explanation: "5 plus 2 fois 2 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 ÷ 2) + (6 × 3) ?",
    options: ["26", "22", "24"],
    answer: "24",
    explanation: "La division de 8 par 2 plus 18 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 × 2 - (4 + 2) ?",
    options: ["14", "12", "16"],
    answer: "14",
    explanation: "Le produit de 10 et 2 moins 6 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (3 + 3) ?",
    options: ["5", "6", "4"],
    answer: "5",
    explanation: "La division de 30 par 6 donne 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 + 1) × 2 - 3 ?",
    options: ["11", "13", "9"],
    answer: "13",
    explanation: "La somme de 8 multipliée par 2 moins 3 donne 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 8 + 3 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "La somme de 8 et 3 est 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 6 × 4 ?",
    options: ["20", "24", "26"],
    answer: "24",
    explanation: "Le produit de 6 et 4 est 24.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 5 × 6 - 10 ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation: "5 fois 6 moins 10 est égal à 20.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 5 + 3 ?",
    options: ["7", "8", "9"],
    answer: "8",
    explanation: "La somme de 5 et 3 est 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - 5 ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation: "12 moins 5 donne 7.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 4 × 2 ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "4 multiplié par 2 est égal à 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 7 × 3 - 5 ?",
    options: ["16", "17", "18"],
    answer: "16",
    explanation: "7 multiplié par 3 donne 21, moins 5 est 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 9 - (2 + 3) ?",
    options: ["3", "4", "5"],
    answer: "4",
    explanation: "2 plus 3 fait 5, donc 9 moins 5 donne 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 ÷ 3 + 5 ?",
    options: ["8", "7", "6"],
    answer: "8",
    explanation: "15 divisé par 3 est 5, plus 5 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (10 - 4) × 2 + 6 ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "10 moins 4 est 6, multiplié par 2 donne 12, plus 6 fait 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + 2 × (3 + 1) ?",
    options: ["11", "12", "13"],
    answer: "13",
    explanation: "3 plus 1 est 4, multiplié par 2 donne 8, plus 5 fait 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 8 ÷ 4 + 6 × 2 ?",
    options: ["14", "12", "10"],
    answer: "14",
    explanation:
        "8 divisé par 4 est 2, et 6 multiplié par 2 est 12, donc 2 plus 12 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 6 - 2 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "7 + 6 égale 13, et 13 - 2 égale 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - 2 × 3 ?",
    options: ["3", "5", "6"],
    answer: "3",
    explanation: "2 multiplié par 3 égale 6, puis 9 - 6 égale 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 2 + 6 ÷ 3 ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation:
        "4 multiplié par 2 égale 8, et 6 divisé par 3 égale 2, donc 8 + 2 égale 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - 3 + 5 ?",
    options: ["11", "12", "10"],
    answer: "12",
    explanation: "10 - 3 égale 7, puis 7 + 5 égale 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 4 ?",
    options: ["7", "8", "9"],
    answer: "9",
    explanation: "25 divisé par 5 égale 5, puis 5 + 4 égale 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (4 + 2) - 6 ?",
    options: ["12", "15", "18"],
    answer: "12",
    explanation: "(4 + 2) égale 6, puis 3 × 6 - 6 égale 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 16 ÷ 4 ?",
    options: ["3", "4", "5"],
    answer: "4",
    explanation: "16 divisé par 4 donne 4.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ (4 - 2) ?",
    options: ["10", "15", "8"],
    answer: "10",
    explanation: "20 divisé par (4 - 2) donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 5 + 4 ?",
    options: ["19", "17", "18"],
    answer: "19",
    explanation: "3 multiplié par 5 plus 4 est égal à 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 + 2 - 5 ?",
    options: ["8", "6", "7"],
    answer: "8",
    explanation: "11 plus 2 moins 5 est égal à 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 ÷ 7 + 6 ?",
    options: ["8", "10", "12"],
    answer: "8",
    explanation: "14 divisé par 7 plus 6 donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × 3 - 4 ?",
    options: ["20", "22", "18"],
    answer: "22",
    explanation: "(6 + 2) multiplié par 3 moins 4 est égal à 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 25 - 10 ?",
    options: ["30", "25", "20"],
    answer: "30",
    explanation: "15 plus 25 moins 10 donne 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 x (2 + 4) ?",
    options: ["36", "42", "24"],
    answer: "36",
    explanation: "2 plus 4 est 6, multiplié par 6 donne 36.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (8 x 5) ?",
    options: ["10", "20", "30"],
    answer: "10",
    explanation: "8 multiplié par 5 donne 40, 50 moins 40 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 x (4 - 1) + 2 ?",
    options: ["23", "21", "20"],
    answer: "23",
    explanation:
        "4 moins 1 est 3, 7 multiplié par 3 est 21, puis 21 plus 2 donne 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) x (5 - 3) ?",
    options: ["24", "20", "26"],
    answer: "24",
    explanation:
        "10 plus 2 est 12, 5 moins 3 est 2, 12 multiplié par 2 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 x 4 + 2 x 5 ?",
    options: ["26", "23", "22"],
    answer: "26",
    explanation:
        "3 multiplié par 4 est 12, 2 multiplié par 5 est 10, 12 plus 10 donne 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - (2 x 5) + 3 ?",
    options: ["13", "8", "10"],
    answer: "13",
    explanation: "2 multiplié par 5 est 10, 15 moins 10 plus 3 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 4 x 2 ?",
    options: ["6", "8", "4"],
    answer: "6",
    explanation:
        "8 plus 4 est 12, divisé par 4 donne 3, multiplié par 2 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 7 + 3 ?",
    options: ["10", "11", "9"],
    answer: "11",
    explanation: "15 moins 7 plus 3 donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 3 + 2 ?",
    options: ["14", "13", "15"],
    answer: "14",
    explanation: "4 multiplié par 3 plus 2 donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 ÷ 2 + 5 ?",
    options: ["6", "5", "7"],
    answer: "6",
    explanation: "8 divisé par 2 plus 5 donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ 4 + 3 ?",
    options: ["8", "7", "6"],
    answer: "8",
    explanation: "20 divisé par 4 plus 3 donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 2 - 1 ?",
    options: ["9", "10", "8"],
    answer: "9",
    explanation: "5 multiplié par 2 moins 1 donne 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 5) × (2 - 1) ?",
    options: ["9", "8", "10"],
    answer: "9",
    explanation: "La somme de 4 et 5 multipliée par 1 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ 4 ?",
    options: ["7", "8", "9"],
    answer: "9",
    explanation: "36 divisé par 4 donne 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 3 ?",
    options: ["8", "10", "11"],
    answer: "11",
    explanation: "50 divisé par 5, plus 3, donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (3 × 4) + 5 ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "20 moins 12, plus 5, donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) ÷ 2 + 3 ?",
    options: ["6", "5", "7"],
    answer: "6",
    explanation: "La somme de 6 et 2, divisée par 2, plus 3, donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - (5 + 4) ?",
    options: ["18", "19", "20"],
    answer: "18",
    explanation: "21 moins la somme de 5 et 4 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 ÷ (5 + 5) + 2 ?",
    options: ["6", "8", "7"],
    answer: "6",
    explanation: "40 divisé par 10, plus 2, donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 3) × 4 + 1 ?",
    options: ["25", "22", "24"],
    answer: "25",
    explanation: "6 multiplié par 4, plus 1, donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 + 6 - 3 ?",
    options: ["16", "17", "18"],
    answer: "17",
    explanation: "14 plus 6 moins 3 donne 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (2 × 4) ?",
    options: ["14", "10", "16"],
    answer: "10",
    explanation: "18 moins 8 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (3 + 2) ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation: "30 divisé par 5 donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 4 + 2 ?",
    options: ["14", "10", "12"],
    answer: "14",
    explanation: "3 multiplié par 4 plus 2 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 - 4) × 3 ?",
    options: ["24", "28", "30"],
    answer: "24",
    explanation: "La différence de 12 et 4 multipliée par 3 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 5 × 2 ?",
    options: ["17", "19", "16"],
    answer: "17",
    explanation: "5 multiplié par 2 donne 10, puis 7 plus 10 donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (3 + 2) × 4 ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation: "25 moins 20 donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 3 + 6 - 2 ?",
    options: ["16", "18", "14"],
    answer: "16",
    explanation: "12 plus 6 moins 2 donne 16.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 3) × 2 ?",
    options: ["10", "12", "11"],
    answer: "10",
    explanation:
        "On soustrait 3 de 8, puis on multiplie le résultat par 2 pour obtenir 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (3 + 4) - 10 ?",
    options: ["25", "30", "20"],
    answer: "25",
    explanation:
        "On additionne 3 et 4, on multiplie par 5, puis on soustrait 10 pour obtenir 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 2 × (6 - 4) ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation:
        "On soustrait 4 de 6, on multiplie par 2, puis on additionne à 10 pour obtenir 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 2) × (4 - 1) ?",
    options: ["15", "20", "12"],
    answer: "15",
    explanation:
        "On additionne 3 et 2, puis on multiplie par la soustraction de 4 et 1 pour obtenir 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 ÷ 5 + 3 × 2 ?",
    options: ["14", "16", "18"],
    answer: "14",
    explanation:
        "On divise 40 par 5 puis on ajoute le produit de 3 et 2 pour obtenir 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 3) × (5 + 1) ?",
    options: ["36", "42", "30"],
    answer: "36",
    explanation:
        "On soustrait 3 de 9, on additionne 5 et 1, puis on multiplie les résultats pour obtenir 36.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (4 × 8) ?",
    options: ["18", "22", "14"],
    answer: "18",
    explanation:
        "On multiplie 4 par 8, puis on soustrait le résultat de 50 pour obtenir 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 6 + 3 × 4 ?",
    options: ["18", "15", "12"],
    answer: "18",
    explanation:
        "On divise 30 par 6 et on ajoute le produit de 3 et 4 pour obtenir 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (2 + 2) ?",
    options: ["32", "24", "28"],
    answer: "32",
    explanation: "8 multiplié par 4 (2 plus 2) donne 32.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 4 × 3 ?",
    options: ["24", "20", "18"],
    answer: "24",
    explanation:
        "La multiplication est effectuée avant l'addition, donc 4 fois 3 est 12, et 12 plus 12 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (4 × 5) ?",
    options: ["10", "20", "15"],
    answer: "10",
    explanation: "4 multiplié par 5 est 20, donc 30 moins 20 est 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 ÷ 2 + 3 ?",
    options: ["10", "11", "9"],
    answer: "11",
    explanation: "14 divisé par 2 est 7, et 7 plus 3 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 9 ?",
    options: ["15", "12", "13"],
    answer: "15",
    explanation: "18 divisé par 3 est 6, et 6 plus 9 donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (6 ÷ 2) ?",
    options: ["22", "23", "20"],
    answer: "23",
    explanation: "6 divisé par 2 est 3, donc 25 moins 3 est 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 3 ?",
    options: ["10", "11", "9"],
    answer: "10",
    explanation: "La somme de 7 et 3 est 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 5 ?",
    options: ["20", "18", "22"],
    answer: "20",
    explanation: "La multiplication de 4 par 5 donne 20.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ 6 ?",
    options: ["6", "5", "7"],
    answer: "6",
    explanation: "La division de 36 par 6 est 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 15 - 5 ?",
    options: ["22", "20", "21"],
    answer: "22",
    explanation: "La somme de 12 et 15 moins 5 est 22.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 6 × 2 ?",
    options: ["30", "24", "28"],
    answer: "30",
    explanation: "La division de 18 par 2, ajoutée à 12, donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (7 + 5) ?",
    options: ["36", "40", "42"],
    answer: "36",
    explanation: "La multiplication de 3 par la somme de 7 et 5 donne 36.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (3 + 4) ?",
    options: ["5", "7", "6"],
    answer: "7",
    explanation: "La soustraction de 14 moins 7 donne 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 6 - 10 ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation: "La multiplication de 5 par 6 moins 10 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 3) × 4 ?",
    options: ["24", "20", "18"],
    answer: "24",
    explanation: "La différence de 9 et 3, multipliée par 4, donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 15 - 10 ?",
    options: ["20", "30", "25"],
    answer: "20",
    explanation: "On effectue d'abord l'addition puis la soustraction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (25 ÷ 5) ?",
    options: ["80", "75", "85"],
    answer: "85",
    explanation: "On effectue d'abord la division avant la soustraction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × (3 + 1) ÷ 2 ?",
    options: ["16", "12", "14"],
    answer: "16",
    explanation:
        "On résout les opérations dans les parenthèses avant de diviser.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (3 × 2) + 5 ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation:
        "On effectue la multiplication avant la soustraction et l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 4 × 2 ?",
    options: ["10", "14", "12"],
    answer: "14",
    explanation:
        "On effectue d'abord la division puis la multiplication, suivi de l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (6 ÷ 2) + 4 ?",
    options: ["26", "28", "24"],
    answer: "26",
    explanation: "On effectue la division avant la soustraction et l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) × (2 + 2) - 4 ?",
    options: ["28", "32", "24"],
    answer: "28",
    explanation:
        "On résout d'abord les opérations dans les parenthèses avant de soustraire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ 6 ?",
    options: ["4", "5", "6"],
    answer: "4",
    explanation: "24 divisé par 6 égale 4.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 + 9 - 6 ?",
    options: ["21", "22", "23"],
    answer: "21",
    explanation: "18 plus 9 moins 6 égale 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 5 - 10 ?",
    options: ["25", "30", "35"],
    answer: "25",
    explanation: "7 multiplié par 5 moins 10 égale 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 × 3) + (2 × 4) ?",
    options: ["26", "28", "30"],
    answer: "30",
    explanation: "Le produit de 6 et 3 plus le produit de 2 et 4 donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 3) × (2 + 1) ?",
    options: ["36", "40", "42"],
    answer: "36",
    explanation:
        "La différence de 15 et 3 multipliée par la somme de 2 et 1 donne 36.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (4 ÷ 2) + 10 ?",
    options: ["44", "46", "48"],
    answer: "46",
    explanation: "Le produit de 8 et 4 divisé par 2, ajouté à 10, donne 46.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 10) ÷ 2 × 5 ?",
    options: ["50", "60", "70"],
    answer: "50",
    explanation:
        "La somme de 10 et 10, divisée par 2 et multipliée par 5, donne 50.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ (3 - 1) + 6 ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation: "12 divisé par la différence de 3 et 1, ajouté à 6, donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (2 + 3) - 4 ?",
    options: ["21", "22", "23"],
    answer: "21",
    explanation: "Le produit de 5 et la somme de 2 et 3, moins 4, donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - 6 + 2 = ?",
    options: ["11", "10", "9"],
    answer: "11",
    explanation: "Quinze moins six est 9, puis en ajoutant 2, on obtient 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "3 × (4 + 2) = ?",
    options: ["18", "21", "12"],
    answer: "18",
    explanation:
        "On effectue d'abord l'addition dans les parenthèses, puis on multiplie par 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 - 3) × 4 = ?",
    options: ["20", "15", "25"],
    answer: "20",
    explanation:
        "On commence par soustraire 3 de 8, puis on multiplie le résultat par 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 + 5) ÷ 3 = ?",
    options: ["5", "3", "4"],
    answer: "5",
    explanation:
        "On additionne d'abord 10 et 5, puis on divise par 3, ce qui donne 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - 4) ÷ 2 + 1 = ?",
    options: ["9", "8", "7"],
    answer: "9",
    explanation: "On soustrait 4 de 20, puis on divise par 2 et on ajoute 1.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 + 3) × (4 - 2) = ?",
    options: ["10", "16", "12"],
    answer: "16",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses avant de multiplier.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 × 3) - (5 + 1) = ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation:
        "On multiplie d'abord 6 par 3, puis on soustrait le résultat de l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 - 3) × (2 + 1) = ?",
    options: ["18", "24", "12"],
    answer: "18",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses et ensuite on multiplie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(30 ÷ 5) + (4 × 2) = ?",
    options: ["14", "12", "16"],
    answer: "14",
    explanation: "On divise 30 par 5, puis on ajoute le produit de 4 et 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(15 - 5) × 2 + 3 = ?",
    options: ["23", "20", "25"],
    answer: "23",
    explanation:
        "On soustrait d'abord 5 de 15, puis on multiplie par 2 et on ajoute 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(24 ÷ 3) + (6 - 2) = ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation:
        "On divise 24 par 3, puis on ajoute le résultat de la soustraction.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 6 + 3 ?",
    options: ["15", "16", "17"],
    answer: "15",
    explanation: "18 moins 6 plus 3 donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 × 3) + (10 ÷ 2) ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation: "Le produit de 4 et 3 plus le quotient de 10 par 2 est 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - (2 + 1) ?",
    options: ["18", "19", "20"],
    answer: "18",
    explanation:
        "La multiplication de 7 par 3 moins la somme de 2 et 1 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (5 × 4) ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation: "25 moins le produit de 5 et 4 donne 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 ÷ 2 + 6 ?",
    options: ["7", "8", "9"],
    answer: "7",
    explanation: "Le quotient de 10 par 2 plus 6 donne 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 ÷ 2) + (3 × 4) ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation: "Le quotient de 6 par 2 plus le produit de 3 et 4 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 3) × 2 ?",
    options: ["14", "15", "13"],
    answer: "14",
    explanation:
        "On soustrait d'abord 3 de 10, puis on multiplie le résultat par 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + (3 × 4) ?",
    options: ["20", "26", "24"],
    answer: "20",
    explanation:
        "On effectue d'abord la multiplication puis on additionne 8 au résultat.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 ÷ (5 + 3) ?",
    options: ["5", "4", "6"],
    answer: "5",
    explanation: "On additionne 5 et 3 puis on divise 40 par ce résultat.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 ÷ 4) + (3 × 2) ?",
    options: ["9", "8", "10"],
    answer: "9",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses avant d'additionner.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (25 ÷ 5) ?",
    options: ["80", "90", "75"],
    answer: "80",
    explanation:
        "On divise d'abord 25 par 5 puis on soustrait le résultat de 100.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × (2 + 1) - 3 ?",
    options: ["24", "26", "21"],
    answer: "24",
    explanation:
        "On effectue d'abord l'addition dans la parenthèse puis on multiplie et soustrait.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 5) × 2 + 4 ?",
    options: ["24", "26", "20"],
    answer: "24",
    explanation:
        "On soustrait d'abord puis on multiplie et enfin on additionne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 9 - 3 ?",
    options: ["21", "20", "22"],
    answer: "21",
    explanation: "15 plus 9 moins 3 donne 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 - (6 × 5) ?",
    options: ["10", "14", "20"],
    answer: "10",
    explanation: "40 moins 30 (6 fois 5) égale 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 6 ?",
    options: ["12", "10", "14"],
    answer: "12",
    explanation: "6 plus 6 égale 12 après la division.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (16 ÷ 4) × (3 + 1) ?",
    options: ["12", "16", "8"],
    answer: "12",
    explanation: "4 multiplié par 3 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (8 × 4) + 2 ?",
    options: ["10", "6", "14"],
    answer: "10",
    explanation: "50 moins 32 plus 2 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (2 + 3) × (5 - 2) ?",
    options: ["15", "10", "20"],
    answer: "15",
    explanation: "5 multiplié par 3 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 6 ÷ 2 ?",
    options: ["12", "15", "18"],
    answer: "12",
    explanation: "6 divisé par 2 donne 3, donc 9 plus 3 égale 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 5) ÷ (1 + 1) ?",
    options: ["5", "10", "2"],
    answer: "5",
    explanation: "10 divisé par 2 donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 7 - 3 ?",
    options: ["12", "13", "14"],
    answer: "12",
    explanation: "8 plus 7 moins 3 est égal à 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 4 + 2 ?",
    options: ["16", "15", "17"],
    answer: "16",
    explanation: "18 moins 4 plus 2 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (4 + 6) - 2 ?",
    options: ["28", "30", "32"],
    answer: "28",
    explanation: "3 multiplié par la somme de 4 et 6 moins 2 donne 28.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 ÷ 2 + 5 ?",
    options: ["12", "10", "9"],
    answer: "12",
    explanation: "14 divisé par 2 plus 5 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 + 2 × 4 ?",
    options: ["19", "17", "15"],
    answer: "19",
    explanation: "11 plus le produit de 2 et 4 donne 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 3 + 5 ?",
    options: ["15", "20", "10"],
    answer: "15",
    explanation: "30 divisé par 3 plus 5 donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 9 + 2 ?",
    options: ["17", "18", "16"],
    answer: "18",
    explanation: "En soustrayant 9 de 25 et en ajoutant 2, on obtient 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (5 + 1) - 4 ?",
    options: ["14", "15", "16"],
    answer: "14",
    explanation: "Le produit de 3 et (5 + 1) moins 4 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (6 - 3) + 4 ?",
    options: ["14", "16", "18"],
    answer: "16",
    explanation: "La division de 30 par (6 - 3) et ajout de 4 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - 2 × 20 ?",
    options: ["10", "20", "30"],
    answer: "10",
    explanation: "La soustraction de 2 fois 20 à 50 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 3 + 5 ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "Le produit de 4 et 3, additionné à 5, donne 17.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (2 + 1) - 5 ?",
    options: ["16", "17", "18"],
    answer: "16",
    explanation: "Le produit de 7 et (2 + 1) moins 5 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 8 - 5 ?",
    options: ["10", "11", "12"],
    answer: "10",
    explanation: "La somme de 7 et 8 moins 5 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (6 ÷ 2) ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation: "On divise d'abord, puis on soustrait : 14 - 3 = 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 2 + 4 ?",
    options: ["18", "16", "14"],
    answer: "18",
    explanation: "On multiplie d'abord, puis on additionne : 14 + 4 = 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 4 - 6 ?",
    options: ["10", "14", "14"],
    answer: "10",
    explanation: "On multiplie d'abord, puis on soustrait : 16 - 6 = 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 2) × (4 + 1) ?",
    options: ["30", "25", "35"],
    answer: "30",
    explanation: "La multiplication de 6 par 5 donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (2 + 3) × (4 - 1) ?",
    options: ["15", "10", "12"],
    answer: "15",
    explanation: "La multiplication de 5 par 3 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (3 × 5) + 2 ?",
    options: ["17", "20", "22"],
    answer: "17",
    explanation: "La soustraction de 15 de 30, plus 2, donne 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 + 1) × (2 - 1) ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation: "La multiplication de 10 par 1 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 ÷ 3 + 4 ?",
    options: ["5", "7", "6"],
    answer: "7",
    explanation: "On divise 15 par 3, puis on ajoute 4, ce qui donne 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 5) ÷ (2 + 3) ?",
    options: ["2", "1", "3"],
    answer: "2",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses avant de diviser.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (5 + 5) + 2 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation:
        "D'abord, on additionne dans la parenthèse, puis on divise et ajoute 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 + 6 ÷ 2 ?",
    options: ["17", "20", "16"],
    answer: "17",
    explanation: "On divise d'abord 6 par 2 puis on additionne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 - (2 + 1) × 3 ?",
    options: ["5", "2", "6"],
    answer: "2",
    explanation:
        "On effectue d'abord l'addition dans les parenthèses avant de multiplier et soustraire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - 3 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation: "9 - 3 donne 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 2 ?",
    options: ["14", "16", "18"],
    answer: "16",
    explanation: "8 multiplié par 2 donne 16.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 48 ÷ 6 + 2 ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation: "48 divisé par 6 plus 2 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (50 - 10) ÷ 2 + 5 ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation: "(50 - 10) divisé par 2 plus 5 donne 20.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 7 ?",
    options: ["22", "23", "21"],
    answer: "22",
    explanation: "15 plus 7 égale 22.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - 19 ?",
    options: ["31", "30", "32"],
    answer: "31",
    explanation: "50 moins 19 donne 31.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 15 - 4 ?",
    options: ["23", "24", "22"],
    answer: "23",
    explanation: "12 plus 15 moins 4 donne 23.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 ÷ 5 + 2 ?",
    options: ["11", "10", "12"],
    answer: "11",
    explanation: "45 divisé par 5 donne 9, puis 9 plus 2 égale 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (2 + 3) × 4 ?",
    options: ["20", "18", "24"],
    answer: "20",
    explanation: "La somme de 2 et 3 est 5, multiplié par 4 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (20 ÷ 4) ?",
    options: ["95", "90", "92"],
    answer: "95",
    explanation: "20 divisé par 4 est 5, donc 100 moins 5 égale 95.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) × 2 - 10 ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation:
        "La somme de 8 et 4 est 12, multiplié par 2 donne 24, moins 10 égale 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 5) × (2 + 3) ?",
    options: ["50", "40", "60"],
    answer: "50",
    explanation:
        "15 moins 5 est 10, 2 plus 3 est 5, 10 multiplié par 5 donne 50.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 2 + 6 ÷ 3 ?",
    options: ["21", "20", "22"],
    answer: "20",
    explanation:
        "9 multiplié par 2 donne 18, 6 divisé par 3 donne 2, donc 18 plus 2 égale 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (6 ÷ 2) × 3 ?",
    options: ["12", "9", "15"],
    answer: "9",
    explanation:
        "6 divisé par 2 est 3, multiplié par 3 donne 9, donc 18 moins 9 égale 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (2 + 1) - 5 ?",
    options: ["13", "15", "17"],
    answer: "13",
    explanation: "6 multiplié par 3 donne 18, moins 5 donne 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 ÷ 2) + (3 × 4) ?",
    options: ["14", "15", "16"],
    answer: "14",
    explanation: "(8 ÷ 2) donne 4, et (3 × 4) donne 12, donc 4 + 12 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (2 + 4) × 2 ?",
    options: ["6", "8", "10"],
    answer: "10",
    explanation:
        "(2 + 4) donne 6, multiplié par 2 donne 12, donc 18 - 12 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 5) × 2 - 3 ?",
    options: ["10", "12", "15"],
    answer: "12",
    explanation:
        "(5 + 5) donne 10, multiplié par 2 donne 20, moins 3 donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 - 5 × (6 - 2) ?",
    options: ["20", "30", "10"],
    answer: "20",
    explanation: "5 multiplié par 4 donne 20, donc 40 - 20 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - (5 + 1) ?",
    options: ["18", "19", "20"],
    answer: "18",
    explanation: "7 multiplié par 3 donne 21, moins 6 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ 5 + 10 ?",
    options: ["30", "20", "25"],
    answer: "20",
    explanation: "La division de 100 par 5, puis addition de 10 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (4 + 2) ?",
    options: ["12", "10", "16"],
    answer: "12",
    explanation: "18 moins la somme de 4 et 2 est 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 ÷ 3) + (4 × 2) ?",
    options: ["14", "10", "12"],
    answer: "14",
    explanation: "La division de 15 par 3, plus 4 multiplié par 2 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 6 - (2 + 3) ?",
    options: ["27", "28", "30"],
    answer: "27",
    explanation: "5 multiplié par 6, moins la somme de 2 et 3 est 27.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 10 + 4 × 3 ?",
    options: ["17", "18", "16"],
    answer: "17",
    explanation: "La division de 50 par 10, plus 4 multiplié par 3 donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 × 3 - 5 = ?",
    options: ["16", "17", "18"],
    answer: "16",
    explanation:
        "Sept multiplié par trois est vingt et un, moins cinq donne seize.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - 6 + 4 = ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "Quinze moins six est neuf, plus quatre donne treize.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 + 2) × 3 = ?",
    options: ["15", "18", "20"],
    answer: "18",
    explanation:
        "On additionne quatre et deux pour obtenir six, puis on multiplie par trois.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 - (3 × 4) = ?",
    options: ["8", "10", "12"],
    answer: "8",
    explanation:
        "Trois multiplié par quatre donne douze, puis on soustrait ce résultat de vingt.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) ÷ 2 + 5 = ?",
    options: ["6", "7", "8"],
    answer: "6",
    explanation:
        "D'abord, on soustrait deux de dix pour obtenir huit, puis on divise par deux et ajoute cinq.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(16 ÷ 4) + (2 × 3) = ?",
    options: ["8", "9", "10"],
    answer: "10",
    explanation: "Quatre plus six donne dix après les opérations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(30 - 10) ÷ 4 + 2 = ?",
    options: ["5", "6", "7"],
    answer: "7",
    explanation: "Vingt divisé par quatre est cinq, plus deux donne sept.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 × (1 + 2) - 6 = ?",
    options: ["21", "24", "27"],
    answer: "21",
    explanation:
        "Trois multiplié par neuf donne vingt-sept, moins six donne vingt et un.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 2) + (8 ÷ 4) = ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "Dix plus deux donne onze après les opérations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 - 6) ÷ 2 + 1 = ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation: "Douze divisé par deux est six, plus un donne sept.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(2 + 4) × (3 - 1) = ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation: "Six multiplié par deux donne douze.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (10 + 5) ?",
    options: ["35", "40", "45"],
    answer: "35",
    explanation: "50 moins la somme de 10 et 5 donne 35.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (2 + 1) ?",
    options: ["20", "22", "24"],
    answer: "24",
    explanation: "8 multiplié par la somme de 2 et 1 donne 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 ÷ 2) + 5 ?",
    options: ["8", "9", "7"],
    answer: "8",
    explanation: "La division de 6 par 2, ajoutée à 5, donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (3 × 2) + 5 ?",
    options: ["10", "12", "8"],
    answer: "12",
    explanation: "14 moins 6, plus 5, donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 15) ÷ 4 ?",
    options: ["5", "6", "7"],
    answer: "5",
    explanation: "La somme de 5 et 15, divisée par 4, donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × (4 - 2) + 3 ?",
    options: ["21", "24", "27"],
    answer: "21",
    explanation: "9 multiplié par 2, plus 3, donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 2 × 3 ?",
    options: ["13", "15", "17"],
    answer: "13",
    explanation: "7 plus 6 (2 multiplié par 3) donne 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 8 ?",
    options: ["7", "6", "5"],
    answer: "7",
    explanation: "15 moins 8 est égal à 7.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 9 + 4 ?",
    options: ["20", "19", "21"],
    answer: "20",
    explanation: "25 moins 9 plus 4 est égal à 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (5 + 4) ?",
    options: ["27", "24", "27"],
    answer: "27",
    explanation: "3 multiplié par la somme de 5 et 4 donne 27.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (6 - 2) + 3 ?",
    options: ["23", "25", "22"],
    answer: "23",
    explanation: "5 multiplié par la différence de 6 et 2, plus 3, donne 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 6) ÷ 2 × 5 ?",
    options: ["25", "20", "30"],
    answer: "25",
    explanation:
        "La somme de 4 et 6, divisée par 2, multipliée par 5 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ (3 - 1) × 4 ?",
    options: ["24", "20", "22"],
    answer: "24",
    explanation:
        "12 divisé par la différence de 3 et 1, multiplié par 4, donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 16 - (3 × 2) + 5 ?",
    options: ["12", "15", "10"],
    answer: "15",
    explanation: "16 moins 6 plus 5 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 7) × 2 ?",
    options: ["18", "20", "22"],
    answer: "20",
    explanation: "La somme de 3 et 7, multipliée par 2, donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 2 + 10 ?",
    options: ["25", "30", "35"],
    answer: "35",
    explanation: "La division de 50 par 2, plus 10, donne 35.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 9 × 2 - 5 ?",
    options: ["10", "13", "15"],
    answer: "13",
    explanation: "Le produit de 9 et 2 moins 5 est 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (8 - 3) × 4 ?",
    options: ["20", "22", "24"],
    answer: "20",
    explanation: "La différence de 8 et 3 multipliée par 4 est 20.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 2 - 7 ?",
    options: ["11", "9", "10"],
    answer: "11",
    explanation: "Le calcul donne 9 × 2 = 18, puis 18 - 7 = 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (6 - 4) + 3 ?",
    options: ["15", "17", "10"],
    answer: "17",
    explanation: "D'abord, on fait 6 - 4 = 2, puis 7 × 2 + 3 = 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (5 + 5) × 3 ?",
    options: ["9", "6", "12"],
    answer: "9",
    explanation: "On additionne d'abord : 5 + 5 = 10, puis 30 ÷ 10 × 3 = 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (3 × 5) + 10 ?",
    options: ["40", "35", "45"],
    answer: "40",
    explanation: "On effectue d'abord 3 × 5 = 15, puis 50 - 15 + 10 = 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 3 × 4 ?",
    options: ["24", "30", "20"],
    answer: "24",
    explanation:
        "On effectue d'abord la multiplication : 3 × 4 = 12, puis 12 + 12 = 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 6 + 2 ?",
    options: ["7", "6", "8"],
    answer: "7",
    explanation: "5 plus 2 donne 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 6 - 9 ?",
    options: ["12", "10", "11"],
    answer: "12",
    explanation: "15 plus 6 moins 9 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 2 ?",
    options: ["16", "14", "18"],
    answer: "16",
    explanation: "La soustraction de 2 à 10, multipliée par 2, donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (5 + 3) - 4 ?",
    options: ["10", "12", "8"],
    answer: "12",
    explanation: "La multiplication de 2 par 8, moins 4, donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ (2 + 4) × 3 ?",
    options: ["12", "9", "6"],
    answer: "12",
    explanation: "La division de 24 par 6, multipliée par 3, donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 3) × (4 + 1) ?",
    options: ["25", "20", "30"],
    answer: "25",
    explanation: "5 multiplié par 5 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 3 × 2 + 4 ?",
    options: ["10", "5", "8"],
    answer: "10",
    explanation: "3 multiplié par 2 donne 6, 15 moins 6 plus 4 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (5 + 5) + 2 ?",
    options: ["7", "10", "8"],
    answer: "8",
    explanation: "La division de 50 par 10, plus 2, donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 × 2 - 10 = ?",
    options: ["6", "10", "14"],
    answer: "6",
    explanation:
        "8 multiplié par 2 est 16, puis on soustrait 10, ce qui donne 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - 7 + 2 = ?",
    options: ["8", "10", "6"],
    answer: "10",
    explanation: "15 moins 7 est 8, puis on ajoute 2, ce qui donne 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 ÷ 5 × 2 = ?",
    options: ["4", "6", "8"],
    answer: "8",
    explanation: "20 divisé par 5 est 4, multiplié par 2 donne 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 4) × 3 = ?",
    options: ["18", "24", "20"],
    answer: "18",
    explanation: "10 moins 4 est 6, multiplié par 3 donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 + 2) ÷ 2 + 3 = ?",
    options: ["6", "5", "4"],
    answer: "5",
    explanation:
        "La somme de 6 et 2 est 8, divisée par 2 donne 4, puis on ajoute 3, ce qui donne 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 - 6) ÷ 2 + 5 = ?",
    options: ["9", "8", "10"],
    answer: "9",
    explanation:
        "18 moins 6 est 12, divisé par 2 donne 6, puis on ajoute 5, ce qui donne 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 4) - (2 × 3) = ?",
    options: ["14", "18", "10"],
    answer: "14",
    explanation:
        "5 multiplié par 4 est 20, 2 multiplié par 3 est 6, donc 20 moins 6 est 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 + 3) × (4 - 2) = ?",
    options: ["24", "18", "12"],
    answer: "24",
    explanation:
        "9 plus 3 est 12, 4 moins 2 est 2, donc 12 multiplié par 2 est 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(7 + 5) × (10 - 8) = ?",
    options: ["24", "16", "12"],
    answer: "24",
    explanation:
        "7 plus 5 est 12, 10 moins 8 est 2, donc 12 multiplié par 2 est 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(15 - 3) + (6 × 2) = ?",
    options: ["21", "24", "18"],
    answer: "24",
    explanation:
        "15 moins 3 est 12, 6 multiplié par 2 est 12, donc 12 plus 12 est 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 × 5) ÷ (2 + 3) = ?",
    options: ["4", "5", "3"],
    answer: "4",
    explanation:
        "4 multiplié par 5 est 20, 2 plus 3 est 5, donc 20 divisé par 5 est 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 - 5) × 2 ?",
    options: ["30", "25", "35"],
    answer: "30",
    explanation:
        "On soustrait 5 de 20 et on multiplie le résultat par 2, soit 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (4 + 5) - 7 ?",
    options: ["20", "25", "22"],
    answer: "20",
    explanation:
        "On multiplie 3 par la somme de 4 et 5, puis on soustrait 7, soit 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (2 + 3) ÷ 4 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation:
        "On additionne 2 et 3, multiplie par 8 et divise par 4, soit 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 ÷ 3) + (4 × 2) ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "On divise 15 par 3 et ajoute le double de 4, soit 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 35 - (5 × 4) + 2 ?",
    options: ["27", "30", "32"],
    answer: "27",
    explanation: "On soustrait 20 de 35 puis on ajoute 2, soit 27.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 4 ?",
    options: ["9", "10", "11"],
    answer: "11",
    explanation: "La soustraction de 15 et 4 donne 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (3 × 10) ?",
    options: ["20", "30", "40"],
    answer: "20",
    explanation:
        "La multiplication de 3 par 10 est 30, soustraite de 50 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) × 2 - 6 ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation: "La somme de 8 et 4, multipliée par 2, moins 6, est 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (5 + 7) - 9 ?",
    options: ["15", "18", "21"],
    answer: "18",
    explanation:
        "La somme de 5 et 7 est 12, multipliée par 3, moins 9, donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 + 6) ÷ 3 × 2 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation:
        "La somme de 9 et 6 est 15, divisée par 3, multipliée par 2 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 5 + 6 - 2 ?",
    options: ["20", "22", "24"],
    answer: "22",
    explanation:
        "La multiplication de 4 par 5 est 20, ajoutée à 6, moins 2, donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (3 + 3) + 2 ?",
    options: ["4", "6", "8"],
    answer: "6",
    explanation:
        "La somme de 3 et 3 est 6, 30 divisé par 6, ajouté à 2, donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × 3 + 4 × 2 ?",
    options: ["14", "16", "18"],
    answer: "14",
    explanation:
        "La multiplication de 2 par 3 est 6, et 4 par 2 est 8, leur somme est 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 2 + 3 × 4 ?",
    options: ["29", "26", "32"],
    answer: "26",
    explanation: "50 divisé par 2 plus 3 multiplié par 4 égale 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 15 - 7 ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "10 + 15 - 7 égale 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le produit de 4 × 3 ?",
    options: ["10", "11", "12"],
    answer: "12",
    explanation: "4 multiplié par 3 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 8 - 5 ?",
    options: ["10", "11", "12"],
    answer: "12",
    explanation: "9 plus 8 moins 5 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 5 ?",
    options: ["9", "11", "13"],
    answer: "11",
    explanation: "18 divisé par 3 donne 6, plus 5 donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (6 ÷ 2) × 3 ?",
    options: ["16", "17", "18"],
    answer: "16",
    explanation: "25 moins 9 (6 divisé par 2, puis multiplié par 3) donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 3) × 4 + 2 ?",
    options: ["16", "18", "20"],
    answer: "18",
    explanation: "5 fois 4 plus 2 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 4 × 2 ?",
    options: ["20", "22", "24"],
    answer: "20",
    explanation: "4 fois 2 donne 8, plus 12 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (2 + 1) ?",
    options: ["9", "10", "11"],
    answer: "10",
    explanation: "30 divisé par 3 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 5 - (3 + 2) ?",
    options: ["20", "22", "23"],
    answer: "20",
    explanation: "25 moins 5 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 8 - 5 ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "La somme de 15 et 8, moins 5, est 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 2 + 6 ÷ 3 ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation:
        "On fait d'abord la multiplication et la division, puis on additionne, ce qui donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) × (2 + 2) ?",
    options: ["32", "24", "16"],
    answer: "32",
    explanation:
        "On additionne dans chaque parenthèse, puis on multiplie les résultats, soit 32.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (2 + 1) - 10 ?",
    options: ["14", "10", "16"],
    answer: "14",
    explanation: "8 multiplié par (2 + 1) - 10 égale 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (5 - 2) + 6 ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "4 multiplié par (5 - 2) + 6 égale 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 ÷ 2) × 4 + 3 ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "(8 ÷ 2) multiplié par 4 + 3 égale 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (6 × 4) + 2 ?",
    options: ["12", "14", "10"],
    answer: "12",
    explanation: "30 - (6 × 4) + 2 égale 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 + 15 - 5 ?",
    options: ["35", "40", "30"],
    answer: "35",
    explanation: "25 + 15 - 5 égale 35.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 2 + 3 ?",
    options: ["21", "18", "15"],
    answer: "21",
    explanation: "La multiplication de 9 par 2, plus 3, donne 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + (3 × 5) ?",
    options: ["22", "20", "25"],
    answer: "22",
    explanation: "La multiplication de 3 par 5, plus 7, donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 ÷ 2) + (4 × 3) ?",
    options: ["20", "16", "14"],
    answer: "20",
    explanation: "La division de 8 par 2, plus 4 fois 3, donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (6 × 5) + 2 ?",
    options: ["20", "22", "24"],
    answer: "22",
    explanation: "La soustraction de 6 fois 5 à 50, plus 2, donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 3) × 2 + 4 ?",
    options: ["18", "20", "16"],
    answer: "18",
    explanation:
        "La différence de 10 et 3, multipliée par 2, plus 4, donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 2 ?",
    options: ["6", "8", "10"],
    answer: "8",
    explanation: "C'est le produit de 4 et 2.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 ÷ 3 + 5 ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "On divise d'abord 9 par 3, puis on ajoute 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (3 - 1) + 7 ?",
    options: ["15", "17", "13"],
    answer: "17",
    explanation:
        "On effectue d'abord la soustraction, puis on multiplie et ajoute.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 3) × (2 + 1) ?",
    options: ["21", "22", "23"],
    answer: "21",
    explanation:
        "On soustrait d'abord, puis on additionne et multiplie les résultats.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 4 × 3 ?",
    options: ["20", "22", "24"],
    answer: "24",
    explanation:
        "On divise d'abord, puis on effectue la multiplication et l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 5) × 2 - 3 ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "On additionne d'abord, puis on multiplie et soustrait.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 - (3 × 2) ?",
    options: ["2", "4", "6"],
    answer: "2",
    explanation:
        "On effectue d'abord la multiplication puis la soustraction, soit 8 - 6 = 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (2 + 3) - 5 ?",
    options: ["30", "32", "34"],
    answer: "30",
    explanation:
        "On effectue d'abord l'addition, puis la multiplication et enfin la soustraction, soit 7 × 5 - 5 = 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) × 2 - 10 ?",
    options: ["10", "14", "16"],
    answer: "14",
    explanation:
        "On effectue d'abord l'addition, puis la multiplication et enfin la soustraction, soit 12 × 2 - 10 = 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 + 3 × 5 ?",
    options: ["15", "17", "19"],
    answer: "17",
    explanation:
        "On effectue d'abord la multiplication puis l'addition, soit 2 + 15 = 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 ÷ 2 + 4 ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation:
        "On effectue d'abord la division puis l'addition, soit 5 + 4 = 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 + 5 ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "La somme de 3 et 5 est égale à 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le produit de 6 × 3 ?",
    options: ["18", "17", "19"],
    answer: "18",
    explanation: "Multiplier 6 par 3 donne 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) × 2 ?",
    options: ["22", "24", "20"],
    answer: "24",
    explanation: "La somme de 10 et 2 multipliée par 2 donne 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (20 ÷ 5) ?",
    options: ["40", "45", "42"],
    answer: "40",
    explanation: "La division de 20 par 5, soustraite de 50, donne 40.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (3 + 2) ?",
    options: ["20", "18", "22"],
    answer: "20",
    explanation: "Multiplier 4 par la somme de 3 et 2 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (6 × 4) + 2 ?",
    options: ["12", "16", "14"],
    answer: "14",
    explanation: "30 moins le produit de 6 et 4, plus 2, donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 15 - 8 ?",
    options: ["16", "14", "18"],
    answer: "16",
    explanation: "La somme de 9 et 15, moins 8, donne 16.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 ÷ 2) + (5 × 3) ?",
    options: ["25", "20", "15"],
    answer: "20",
    explanation:
        "La division de 10 par 2, plus le produit de 5 et 3, donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (5 - 2) + 4 ?",
    options: ["10", "9", "11"],
    answer: "11",
    explanation: "3 multiplié par (5 - 2) plus 4 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × 3 - 5 ?",
    options: ["21", "22", "20"],
    answer: "21",
    explanation: "(6 + 2) multiplié par 3 moins 5 donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 2 × 5 ?",
    options: ["17", "19", "15"],
    answer: "17",
    explanation: "7 plus 2 multiplié par 5 donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ 3 ?",
    options: ["3", "4", "5"],
    answer: "4",
    explanation: "12 divisé par 3 donne 4.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 10 + 5 ?",
    options: ["10", "5", "15"],
    answer: "10",
    explanation: "15 moins 10 plus 5 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (2 + 1) ?",
    options: ["6", "7", "9"],
    answer: "9",
    explanation: "3 multiplié par la somme de 2 et 1 donne 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ 4 - 2 ?",
    options: ["3", "4", "5"],
    answer: "3",
    explanation: "20 divisé par 4 moins 2 donne 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 6 - 3 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "8 plus 6 moins 3 donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (3 + 2) - 10 ?",
    options: ["15", "20", "25"],
    answer: "15",
    explanation: "5 multiplié par la somme de 3 et 2 moins 10 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 5 + 6 ÷ 2 ?",
    options: ["15", "18", "21"],
    answer: "18",
    explanation: "3 multiplié par 5 plus 6 divisé par 2 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 4 × 3 ?",
    options: ["20", "24", "28"],
    answer: "20",
    explanation: "8 plus 4 multiplié par 3 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - (2 × 3) + 5 ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "2 multiplié par 3 est 6, donc 10 moins 6 plus 5 est 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (2 + 1) - 4 ?",
    options: ["14", "16", "18"],
    answer: "14",
    explanation: "2 plus 1 est 3, multiplié par 6 donne 18, moins 4 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 4 - 2 ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation: "8 plus 4 moins 2 donne 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 2 + 4 ?",
    options: ["16", "20", "18"],
    answer: "20",
    explanation: "D'abord 8 × 2 donne 16, puis 16 + 4 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 6 + 2 ?",
    options: ["10", "8", "9"],
    answer: "10",
    explanation: "14 - 6 donne 8, puis 8 + 2 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 3 - 2 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "4 × 3 donne 12, puis 12 - 2 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 9 + 3 ?",
    options: ["7", "8", "9"],
    answer: "9",
    explanation: "15 - 9 + 3 égale 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 2 × 5 ?",
    options: ["18", "20", "10"],
    answer: "18",
    explanation: "8 + 2 multiplié par 5 égale 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (3 + 1) - 2 ?",
    options: ["14", "10", "12"],
    answer: "14",
    explanation: "4 multiplié par (3 + 1) moins 2 égale 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 2 - 4 ÷ 2 ?",
    options: ["16", "17", "18"],
    answer: "16",
    explanation: "9 multiplié par 2 moins 4 divisé par 2 égale 16.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 15 - 9 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation: "15 moins 9 égale 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 3 × 4 ?",
    options: ["10", "11", "12"],
    answer: "12",
    explanation: "3 multiplié par 4 égale 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de (6 × 3) + 4 ?",
    options: ["20", "22", "24"],
    answer: "22",
    explanation: "6 multiplié par 3 plus 4 égale 22.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 25 - (3 × 5) ?",
    options: ["10", "15", "20"],
    answer: "10",
    explanation: "25 moins 15 égale 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (5 + 3) ?",
    options: ["16", "14", "12"],
    answer: "16",
    explanation: "2 multiplié par 8 égale 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de (9 - 3) × (2 + 2) ?",
    options: ["24", "20", "18"],
    answer: "24",
    explanation: "6 multiplié par 4 égale 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ (2 + 1) + 5 ?",
    options: ["11", "9", "8"],
    answer: "11",
    explanation: "6 plus 5 égale 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait (10 - 2) × 3 ?",
    options: ["21", "24", "22"],
    answer: "24",
    explanation: "8 multiplié par 3 égale 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 5 × 5 + 5 ?",
    options: ["25", "30", "35"],
    answer: "30",
    explanation: "25 plus 5 égale 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 ÷ 2 + 4 × 3 ?",
    options: ["14", "16", "18"],
    answer: "16",
    explanation: "5 plus 12 égale 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 15 - 6 ?",
    options: ["9", "8", "7"],
    answer: "9",
    explanation: "15 moins 6 égalent 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 18 - (3 × 4).",
    options: ["6", "9", "12"],
    answer: "6",
    explanation: "18 moins 12 égalent 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 36 ÷ 6 + 4.",
    options: ["10", "8", "9"],
    answer: "10",
    explanation: "6 plus 4 égalent 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez (7 - 2) × (5 + 3).",
    options: ["40", "35", "30"],
    answer: "40",
    explanation: "5 multiplié par 8 donne 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 × 3 - (8 ÷ 2) ?",
    options: ["28", "25", "26"],
    answer: "25",
    explanation: "30 moins 5 égalent 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez (6 + 2) × 3 - 4.",
    options: ["20", "22", "18"],
    answer: "20",
    explanation: "24 moins 4 égalent 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (5 × 2) + 5 ?",
    options: ["10", "15", "20"],
    answer: "10",
    explanation: "5 plus 5 égalent 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 25 - (3 × 5) + 2.",
    options: ["12", "10", "8"],
    answer: "12",
    explanation: "25 moins 15 plus 2 égalent 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 + 7 - 10 ?",
    options: ["11", "12", "10"],
    answer: "11",
    explanation: "14 plus 7 moins 10 égalent 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (4 × 3) ?",
    options: ["13", "17", "19"],
    answer: "13",
    explanation: "25 moins 12 (4 multiplié par 3) égale 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 3 + 5 ?",
    options: ["23", "25", "28"],
    answer: "23",
    explanation: "18 plus 5 égale 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (6 × 4) + 2 ?",
    options: ["32", "38", "42"],
    answer: "32",
    explanation: "50 moins 24 plus 2 égale 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 × 4) + (5 × 2) ?",
    options: ["22", "26", "28"],
    answer: "22",
    explanation: "12 plus 10 égale 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 3 + 1 ?",
    options: ["23", "25", "27"],
    answer: "25",
    explanation: "8 multiplié par 3 plus 1 égale 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 4 + 10 ÷ 2 ?",
    options: ["16", "18", "14"],
    answer: "16",
    explanation: "3 multiplié par 4 plus 10 divisé par 2 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + 2 × (5 - 3) ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "6 plus 2 multiplié par la différence de 5 et 3 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 2 + 5 - 3 ?",
    options: ["20", "21", "22"],
    answer: "20",
    explanation: "9 multiplié par 2 plus 5 moins 3 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 ÷ 2 + 7 ?",
    options: ["8", "6", "9"],
    answer: "9",
    explanation: "10 divisé par 2 plus 7 donne 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 6 + 4 ?",
    options: ["10", "12", "8"],
    answer: "12",
    explanation: "14 moins 6 plus 4 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 6 ?",
    options: ["40", "41", "42"],
    answer: "42",
    explanation: "La multiplication de 7 par 6 donne 42.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (3 + 2) ?",
    options: ["11", "12", "13"],
    answer: "13",
    explanation:
        "On effectue d'abord l'addition, puis la soustraction : 18 - 5 = 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ 6 + 4 ?",
    options: ["8", "9", "10"],
    answer: "10",
    explanation:
        "On effectue d'abord la division, puis l'addition : 6 + 4 = 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 - 4) × 3 + 2 ?",
    options: ["26", "28", "30"],
    answer: "26",
    explanation:
        "On effectue d'abord la soustraction, la multiplication, puis l'addition : 8 × 3 + 2 = 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (3 × 5) ?",
    options: ["35", "40", "45"],
    answer: "35",
    explanation:
        "On effectue d'abord la multiplication, puis la soustraction : 50 - 15 = 35.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) ÷ 4 ?",
    options: ["2", "3", "4"],
    answer: "3",
    explanation:
        "On additionne d'abord 10 et 2, puis on divise par 4 : 12 ÷ 4 = 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 3 × (2 + 1) ?",
    options: ["16", "19", "22"],
    answer: "19",
    explanation:
        "On effectue d'abord l'addition, puis la multiplication, et enfin la soustraction : 25 - 9 = 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + (3 x 4) ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "5 plus 12 égale 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 ÷ 4) + (5 x 2) ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "5 plus 10 égale 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (2 + 3) x 1 ?",
    options: ["4", "5", "6"],
    answer: "4",
    explanation: "9 moins 5 égale 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 3) ÷ (3 - 1) ?",
    options: ["6", "8", "10"],
    answer: "6",
    explanation: "12 divisé par 2 égale 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 12 - 5 ?",
    options: ["13", "15", "17"],
    answer: "15",
    explanation: "8 plus 12 moins 5 égale 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 x 3) + (6 ÷ 2) ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "Le produit de 4 et 3 plus le quotient de 6 et 2 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 x (3 + 5) - 6 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "2 multiplié par la somme de 3 et 5 moins 6 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 ÷ 2) + (10 - 4) ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation:
        "Le quotient de 8 et 2 plus la différence de 10 et 4 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - (8 ÷ 4) + 5 ?",
    options: ["9", "10", "11"],
    answer: "11",
    explanation: "12 moins le quotient de 8 et 4 plus 5 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 ?",
    options: ["21", "24", "18"],
    answer: "21",
    explanation: "Le produit de 7 et 3 est 21.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (3 × 10) + 5 ?",
    options: ["25", "30", "35"],
    answer: "25",
    explanation: "50 moins 30 plus 5 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (3 × 2) + 4 ?",
    options: ["16", "14", "12"],
    answer: "14",
    explanation: "18 moins 6 plus 4 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 9 - 5 ?",
    options: ["15", "12", "13"],
    answer: "13",
    explanation: "9 plus 9 moins 5 donne 13.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (4 + 6) ?",
    options: ["30", "25", "20"],
    answer: "30",
    explanation: "3 multiplié par la somme de 4 et 6 donne 30.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 - 3 × 2 = ?",
    options: ["3", "6", "12"],
    answer: "3",
    explanation: "On effectue d'abord la multiplication, puis la soustraction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 ÷ (3 + 2) = ?",
    options: ["3", "5", "2"],
    answer: "3",
    explanation: "On additionne 3 et 2, puis on divise 15 par le résultat.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 + 4) ÷ 4 = ?",
    options: ["3", "2", "4"],
    answer: "3",
    explanation: "On additionne 8 et 4, puis on divise par 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 - (4 × 3) = ?",
    options: ["8", "12", "16"],
    answer: "8",
    explanation: "On effectue d'abord la multiplication, puis la soustraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "18 ÷ 3 + 4 = ?",
    options: ["10", "6", "8"],
    answer: "10",
    explanation: "On divise 18 par 3, puis on ajoute 4.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "6 × (1 + 2) = ?",
    options: ["12", "18", "20"],
    answer: "18",
    explanation: "On additionne d'abord, puis on multiplie par 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "25 - (5 × 4) = ?",
    options: ["5", "15", "20"],
    answer: "5",
    explanation: "On effectue d'abord la multiplication, puis la soustraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "3 × 3 + 3 = ?",
    options: ["6", "9", "12"],
    answer: "12",
    explanation: "On multiplie 3 par 3, puis on ajoute 3.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "14 - 6 ÷ 2 = ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "On divise 6 par 2 avant de soustraire de 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "30 ÷ (5 + 5) = ?",
    options: ["3", "2", "1"],
    answer: "3",
    explanation: "On additionne 5 et 5, puis on divise 30 par le résultat.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "10 + 2 × 5 = ?",
    options: ["20", "30", "20"],
    answer: "20",
    explanation: "On effectue d'abord la multiplication, puis l'addition.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "16 - 4 × 2 = ?",
    options: ["8", "10", "12"],
    answer: "8",
    explanation: "On effectue d'abord la multiplication, puis la soustraction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (5 × 8) ?",
    options: ["10", "30", "40"],
    answer: "10",
    explanation: "50 - (5 multiplié par 8) donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ 5 + 15 ?",
    options: ["25", "35", "20"],
    answer: "35",
    explanation: "100 divisé par 5 plus 15 donne 35.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 6 ÷ 2 ?",
    options: ["15", "18", "12"],
    answer: "15",
    explanation: "12 plus 6 divisé par 2 donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 - (9 × 4) ?",
    options: ["9", "21", "27"],
    answer: "9",
    explanation: "45 moins (9 multiplié par 4) donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 8 ÷ 4 ?",
    options: ["10", "12", "16"],
    answer: "10",
    explanation: "8 plus 8 divisé par 4 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ 6 + 2 ?",
    options: ["6", "8", "10"],
    answer: "8",
    explanation: "La division de 36 par 6 est 6, et 6 plus 2 donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) × 3 ?",
    options: ["30", "36", "32"],
    answer: "36",
    explanation: "La somme de 10 et 2 est 12, et 12 multiplié par 3 donne 36.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (4 × 9) + 3 ?",
    options: ["38", "43", "44"],
    answer: "38",
    explanation: "50 moins 36 plus 3 est égal à 38.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 3) + (6 ÷ 2) ?",
    options: ["18", "19", "20"],
    answer: "18",
    explanation: "15 plus 3 est 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 ÷ 4) × (2 + 1) ?",
    options: ["10", "12", "15"],
    answer: "15",
    explanation: "5 multiplié par 3 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 3 + 5 ?",
    options: ["15", "16", "17"],
    answer: "16",
    explanation: "La soustraction de 3 à 14, plus 5, donne 16.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 5 - 2 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "La somme de 8 et 5, moins 2, donne 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ (3 + 3) ?",
    options: ["2", "3", "4"],
    answer: "3",
    explanation: "18 divisé par 6 donne 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 3) + (2 × 4) ?",
    options: ["27", "23", "26"],
    answer: "27",
    explanation: "La multiplication et addition donnent 27 au total.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 5 ?",
    options: ["10", "8", "7"],
    answer: "8",
    explanation: "La division et addition donnent 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 7 × 2 ?",
    options: ["11", "15", "9"],
    answer: "11",
    explanation: "25 moins 7 multiplié par 2 est 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) × (6 - 4) ?",
    options: ["16", "12", "20"],
    answer: "16",
    explanation:
        "La somme de 5 et 3 multipliée par la différence de 6 et 4 est 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 6 + 5 ?",
    options: ["13", "15", "12"],
    answer: "13",
    explanation: "14 moins 6 plus 5 donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 6 × 5 ?",
    options: ["25", "30", "35"],
    answer: "25",
    explanation: "30 divisé par 6 multiplié par 5 est 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 2 × 4 ?",
    options: ["6", "8", "10"],
    answer: "6",
    explanation: "14 moins 8 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - 9 ?",
    options: ["12", "15", "18"],
    answer: "12",
    explanation: "21 moins 9 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (3 + 2) ?",
    options: ["8", "10", "6"],
    answer: "10",
    explanation: "2 multiplié par la somme de 3 et 2 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 2 - 3 ?",
    options: ["6", "5", "7"],
    answer: "6",
    explanation: "7 plus 2 moins 3 donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (3 × 2) + 1 ?",
    options: ["9", "10", "8"],
    answer: "9",
    explanation: "3 multiplié par 2 est 6, donc 14 moins 6 plus 1 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ (5 - 2) ?",
    options: ["5", "10", "15"],
    answer: "10",
    explanation:
        "5 moins 2 est 3, et 25 divisé par 3 est environ 8, mais les options sont incorrectes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 5) × 2 - 4 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "3 plus 5 est 8, multiplié par 2 donne 16, moins 4 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 9 - 3 ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation:
        "En ajoutant 7 et 9, puis en soustrayant 3, le résultat est 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 ÷ 3 + 2 ?",
    options: ["5", "6", "7"],
    answer: "7",
    explanation:
        "La division de 15 par 3 donne 5, puis en ajoutant 2 on obtient 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) ÷ 2 + 5 ?",
    options: ["6", "7", "8"],
    answer: "6",
    explanation: "D'abord, 10 - 2 = 8, puis 8 ÷ 2 = 4, et enfin 4 + 5 = 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 ÷ (4 - 2) + 3 ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "D'abord, 4 - 2 = 2, puis 8 ÷ 2 = 4, et enfin 4 + 3 = 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 5 + 3 ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "La somme de 5 et 3 est 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Que donne 3 × 4 ?",
    options: ["10", "11", "12"],
    answer: "12",
    explanation: "La multiplication de 3 par 4 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 9 + 6 - 4 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "9 plus 6 moins 4 donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Que donne 20 ÷ 4 + 2 ?",
    options: ["5", "6", "8"],
    answer: "6",
    explanation: "20 divisé par 4 est 5, puis 5 plus 2 donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait (3 × 2) + (4 ÷ 2) ?",
    options: ["7", "8", "6"],
    answer: "7",
    explanation: "6 (3 fois 2) plus 2 (4 divisé par 2) donne 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + (2 × 5) - 3 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "6 plus 10 (2 fois 5) moins 3 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Que donne (5 + 3) × 2 - 4 ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation: "8 (5 plus 3) fois 2 est 16, moins 4 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 10 - (3 + 2) × 2 ?",
    options: ["0", "1", "2"],
    answer: "0",
    explanation: "10 moins 10 (5 fois 2) donne 0.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 + 7 - 5 ?",
    options: ["20", "21", "22"],
    answer: "20",
    explanation: "18 + 7 - 5 égale 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 2 - (5 ÷ 5) ?",
    options: ["11", "12", "13"],
    answer: "11",
    explanation: "6 multiplié par 2 moins (5 divisé par 5) égale 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 8) × 2 ?",
    options: ["16", "20", "24"],
    answer: "24",
    explanation: "La somme de 4 et 8 multipliée par 2 égale 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ (6 - 2) + 1 ?",
    options: ["7", "9", "6"],
    answer: "7",
    explanation: "24 divisé par la différence de 6 et 2 plus 1 égale 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ 3 ?",
    options: ["6", "8", "7"],
    answer: "8",
    explanation: "24 divisé par 3 donne 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 2 × 5 ?",
    options: ["20", "12", "10"],
    answer: "20",
    explanation: "Selon l'ordre des opérations, 10 + (2 × 5) donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (3 + 3) × 5 ?",
    options: ["25", "30", "20"],
    answer: "25",
    explanation: "30 divisé par (3 + 3) multiplié par 5 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ 4 + 2 × 3 ?",
    options: ["32", "24", "28"],
    answer: "32",
    explanation: "100 divisé par 4 plus 2 multiplié par 3 donne 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 7 - 3 ?",
    options: ["12", "14", "13"],
    answer: "13",
    explanation: "9 + 7 - 3 égale 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ (2 + 1) ?",
    options: ["6", "4", "5"],
    answer: "6",
    explanation: "2 + 1 égale 3, donc 18 ÷ 3 égale 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 x (5 - 3) + 4 ?",
    options: ["18", "16", "14"],
    answer: "18",
    explanation: "(5 - 3) égale 2, donc 7 x 2 + 4 égale 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 4 x 3 ?",
    options: ["19", "17", "15"],
    answer: "19",
    explanation: "25 ÷ 5 égale 5 et 4 x 3 égale 12, donc 5 + 12 égale 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (3 x 2) + 6 ?",
    options: ["16", "18", "14"],
    answer: "16",
    explanation: "3 x 2 égale 6, donc 14 - 6 + 6 égale 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 7 - 5 ?",
    options: ["10", "12", "11"],
    answer: "10",
    explanation: "8 + 7 - 5 égale 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 6 + 2 ?",
    options: ["6", "8", "5"],
    answer: "8",
    explanation: "30 ÷ 6 égale 5, donc 5 + 2 égale 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 + 5) x 2 - 4 ?",
    options: ["16", "18", "14"],
    answer: "16",
    explanation: "(7 + 5) égale 12, donc 12 x 2 - 4 égale 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 6 ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "30 divisé par 6 égale 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 2 × (5 - 3) ?",
    options: ["10", "12", "11"],
    answer: "10",
    explanation: "8 + 2 multiplié par (5 - 3) égale 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + (4 × 3) - 10 ?",
    options: ["12", "14", "10"],
    answer: "12",
    explanation: "6 + (4 multiplié par 3) - 10 égale 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - 5 + 3 ?",
    options: ["9", "10", "11"],
    answer: "10",
    explanation: "12 moins 5 plus 3 égale 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (2 + 3) - 8 ?",
    options: ["22", "26", "28"],
    answer: "22",
    explanation: "6 multiplié par (2 plus 3) moins 8 égale 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) × 3 - 5 ?",
    options: ["25", "28", "30"],
    answer: "25",
    explanation: "(10 plus 2) multiplié par 3 moins 5 égale 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 3) × (4 + 2) ?",
    options: ["30", "36", "24"],
    answer: "36",
    explanation: "(9 moins 3) multiplié par (4 plus 2) égale 36.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (2 × 3) + 5 ?",
    options: ["16", "17", "18"],
    answer: "17",
    explanation: "18 moins (2 multiplié par 3) plus 5 égale 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ (3 + 3) × 4 ?",
    options: ["6", "8", "10"],
    answer: "8",
    explanation: "12 divisé par (3 plus 3) multiplié par 4 égale 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 3 - 10 ?",
    options: ["14", "10", "14"],
    answer: "14",
    explanation: "8 multiplié par 3 donne 24, puis 24 - 10 donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (5 + 3) - 12 ?",
    options: ["20", "16", "24"],
    answer: "20",
    explanation: "4 multiplié par 8 donne 32, puis 32 - 12 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (2 + 4) ÷ 2 ?",
    options: ["9", "6", "7"],
    answer: "9",
    explanation: "3 multiplié par 6 donne 18, divisé par 2 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (6 + 4) × 2 ?",
    options: ["5", "15", "10"],
    answer: "5",
    explanation:
        "(6 + 4) est 10, multiplié par 2 donne 20, puis 25 - 20 donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 + 2 × 3 ?",
    options: ["10", "8", "6"],
    answer: "8",
    explanation: "2 + (2 × 3) donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 7 - 4 ?",
    options: ["10", "11", "12"],
    answer: "12",
    explanation: "Le calcul 9 + 7 - 4 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 5 - 7 ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "Le calcul 5 × 5 - 7 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 ÷ 2 + 6 × 2 ?",
    options: ["14", "16", "18"],
    answer: "14",
    explanation: "Le calcul 8 ÷ 2 + 6 × 2 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - 5 + 1 ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "Le calcul 7 × 3 - 5 + 1 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 5 × 2 ?",
    options: ["18", "19", "20"],
    answer: "19",
    explanation: "Le calcul 9 + 5 × 2 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 4 ÷ 2 ?",
    options: ["6", "8", "10"],
    answer: "8",
    explanation: "Le calcul 4 × 4 ÷ 2 donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - 7 + 3 = ?",
    options: ["11", "9", "13"],
    answer: "11",
    explanation: "15 moins 7 donne 8, puis on ajoute 3 pour obtenir 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 + 2) × 2 = ?",
    options: ["24", "20", "22"],
    answer: "24",
    explanation:
        "D'abord, 10 plus 2 donne 12, puis 12 multiplié par 2 donne 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "18 ÷ (3 + 3) = ?",
    options: ["3", "2", "5"],
    answer: "3",
    explanation: "3 plus 3 fait 6, et 18 divisé par 6 donne 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 3) + (6 ÷ 2) = ?",
    options: ["19", "21", "18"],
    answer: "21",
    explanation:
        "5 multiplié par 3 donne 15, et 6 divisé par 2 donne 3, donc 15 plus 3 donne 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 + 2) × (3 - 1) = ?",
    options: ["12", "10", "8"],
    answer: "12",
    explanation:
        "4 plus 2 donne 6, et 3 moins 1 donne 2, donc 6 multiplié par 2 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 - 2) × (4 + 1) = ?",
    options: ["30", "32", "36"],
    answer: "30",
    explanation:
        "8 moins 2 donne 6, et 4 plus 1 donne 5, donc 6 multiplié par 5 donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(14 ÷ 2) + (6 × 3) = ?",
    options: ["30", "26", "28"],
    answer: "26",
    explanation:
        "14 divisé par 2 donne 7, et 6 multiplié par 3 donne 18, donc 7 plus 18 donne 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 × (3 - 1) + 5 = ?",
    options: ["23", "25", "27"],
    answer: "25",
    explanation:
        "3 moins 1 donne 2, et 9 multiplié par 2 donne 18, donc 18 plus 5 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(12 - 4) ÷ 2 + 6 = ?",
    options: ["10", "8", "9"],
    answer: "10",
    explanation:
        "12 moins 4 donne 8, divisé par 2 donne 4, et 4 plus 6 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - 4) ÷ (2 + 2) = ?",
    options: ["4", "5", "6"],
    answer: "4",
    explanation:
        "20 moins 4 donne 16, et 2 plus 2 donne 4, donc 16 divisé par 4 donne 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(3 + 5) × (2 + 1) = ?",
    options: ["24", "28", "30"],
    answer: "24",
    explanation:
        "3 plus 5 donne 8, et 2 plus 1 donne 3, donc 8 multiplié par 3 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 + 2) × (5 - 3) = ?",
    options: ["16", "12", "8"],
    answer: "16",
    explanation:
        "6 plus 2 donne 8, et 5 moins 3 donne 2, donc 8 multiplié par 2 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 + 6 - 4 ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation: "14 plus 6 moins 4 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ (2 + 4) ?",
    options: ["6", "4", "5"],
    answer: "6",
    explanation: "36 divisé par 6 donne 6.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 3 + 2 ?",
    options: ["12", "13", "14"],
    answer: "14",
    explanation: "En soustrayant 3 de 15 et en ajoutant 2, on obtient 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 48 ÷ (2 + 4) ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "48 divisé par la somme de 2 et 4 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 × 4) + (8 ÷ 2) ?",
    options: ["10", "11", "12"],
    answer: "12",
    explanation: "La multiplication et la division donnent 12 après addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + (3 × 5) ?",
    options: ["20", "21", "22"],
    answer: "21",
    explanation: "6 plus 15 donne 21 après multiplication.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (16 ÷ 4) + (2 × 3) ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation: "La division et la multiplication donnent 9 après addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 3 + 1 ?",
    options: ["25", "22", "21"],
    answer: "22",
    explanation:
        "La différence de 10 et 2, multipliée par 3, plus 1, égale 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + 2 × 3 ?",
    options: ["11", "10", "9"],
    answer: "11",
    explanation: "2 multiplié par 3, plus 5, égale 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 ÷ 4) + (3 × 2) ?",
    options: ["11", "10", "12"],
    answer: "11",
    explanation: "Le quotient de 20 et 4, plus le produit de 3 et 2, égale 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (4 + 2) - 5 ?",
    options: ["10", "12", "11"],
    answer: "11",
    explanation:
        "Multiplier 3 par la somme de 4 et 2, puis soustraire 5 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (25 ÷ 5) × 3 ?",
    options: ["85", "90", "80"],
    answer: "85",
    explanation:
        "Soustraire le produit de 25 divisé par 5 et multiplié par 3 de 100 donne 85.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 12) ÷ 4 × 3 ?",
    options: ["15", "12", "9"],
    answer: "15",
    explanation:
        "La somme de 8 et 12 divisée par 4, multipliée par 3 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ (4 - 2) + 9 ?",
    options: ["27", "18", "30"],
    answer: "27",
    explanation:
        "Diviser 36 par la différence de 4 et 2, puis ajouter 9 donne 27.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 5 × 5 - (3 + 2) ?",
    options: ["20", "15", "25"],
    answer: "20",
    explanation:
        "Multiplier 5 par 5 puis soustraire la somme de 3 et 2 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 10) ÷ 2 + 15 ?",
    options: ["30", "25", "20"],
    answer: "25",
    explanation:
        "La somme de 10 et 10 divisée par 2, puis ajoutée à 15 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 12 - 4 ?",
    options: ["7", "8", "9"],
    answer: "8",
    explanation: "La différence entre 12 et 4 est 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 2 + 3 ?",
    options: ["16", "17", "18"],
    answer: "17",
    explanation: "Le calcul est 7 fois 2 plus 3, ce qui donne 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 ÷ (2 × 2) ?",
    options: ["3", "4", "5"],
    answer: "4",
    explanation: "On commence par multiplier 2 par 2, puis on divise 14 par 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × 3 + 5 - 1 ?",
    options: ["9", "10", "11"],
    answer: "10",
    explanation:
        "On effectue d'abord la multiplication, puis on additionne et soustrait.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 + 7 - 6 ?",
    options: ["11", "12", "13"],
    answer: "12",
    explanation: "La somme de 11 et 7 moins 6 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 2 + 6 ?",
    options: ["22", "20", "18"],
    answer: "22",
    explanation:
        "La multiplication est effectuée avant l'addition, ce qui donne 22.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (20 ÷ 4) ?",
    options: ["48", "49", "47"],
    answer: "49",
    explanation:
        "On divise d'abord 20 par 4, puis on soustrait le résultat de 50, soit 49.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ 3 + 8 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "On divise 12 par 3, puis on ajoute 8, ce qui donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + (4 × 2) - 6 ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation:
        "On effectue d'abord la multiplication, puis on additionne et soustrait, ce qui donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (6 - 3) + 4 ?",
    options: ["19", "20", "22"],
    answer: "19",
    explanation:
        "On effectue d'abord la soustraction, puis la multiplication et l'addition, ce qui donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 + 3) × 2 - 10 ?",
    options: ["16", "18", "14"],
    answer: "16",
    explanation:
        "On effectue d'abord l'addition, puis la multiplication et la soustraction, ce qui donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 + 5 - 8 ?",
    options: ["20", "21", "22"],
    answer: "20",
    explanation:
        "On effectue d'abord la multiplication, puis l'addition et la soustraction, ce qui donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 8 + 5 ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "8 + 5 égale 13.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 6 × 3 ?",
    options: ["18", "19", "20"],
    answer: "18",
    explanation: "6 multiplié par 3 donne 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ 4 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation: "24 divisé par 4 égale 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 14 - 3 + 5 ?",
    options: ["16", "15", "14"],
    answer: "16",
    explanation: "14 - 3 + 5 égale 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 4 ?",
    options: ["6", "8", "7"],
    answer: "8",
    explanation: "18 divisé par 3 plus 4 donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (10 - 2) × (5 + 1) ?",
    options: ["48", "50", "52"],
    answer: "48",
    explanation: "(10 - 2) multiplié par (5 + 1) donne 48.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + 3 × 2 ?",
    options: ["11", "16", "10"],
    answer: "11",
    explanation: "5 plus 3 multiplié par 2 donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 8 × 2 - 4 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "8 multiplié par 2 moins 4 égale 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 10 ?",
    options: ["15", "20", "12"],
    answer: "20",
    explanation: "50 divisé par 5 plus 10 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 7 × (3 + 1) ?",
    options: ["24", "28", "30"],
    answer: "28",
    explanation: "7 multiplié par (3 + 1) donne 28.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 5) ÷ 2 + 3 ?",
    options: ["5", "8", "7"],
    answer: "8",
    explanation: "(15 - 5) divisé par 2 plus 3 égale 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 2 × 3 ?",
    options: ["16", "18", "14"],
    answer: "16",
    explanation: "10 plus 6 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ (5 × 2) + 5 ?",
    options: ["15", "20", "10"],
    answer: "15",
    explanation: "10 plus 5 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - 2 + 4 ?",
    options: ["11", "12", "10"],
    answer: "11",
    explanation: "9 moins 2 plus 4 donne 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 6 ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation: "La division de 18 par 3, ajoutée à 6, donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 3) + (12 ÷ 4) ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "Le produit de 5 et 3, ajouté à 3, donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 15 - 10 ?",
    options: ["13", "12", "11"],
    answer: "13",
    explanation: "8 plus 15 moins 10 égale 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 4 × 2 ?",
    options: ["12", "16", "8"],
    answer: "12",
    explanation: "20 moins 8 (4 fois 2) égale 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × (2 + 1) - 6 ?",
    options: ["21", "27", "33"],
    answer: "21",
    explanation: "9 multiplié par 3 (2 plus 1) moins 6 égale 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 × 3) + (5 ÷ 5) ?",
    options: ["13", "12", "11"],
    answer: "13",
    explanation: "12 (4 fois 3) plus 1 (5 divisé par 5) égale 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (25 × 2) + 5 ?",
    options: ["55", "60", "65"],
    answer: "55",
    explanation: "100 moins 50 (25 fois 2) plus 5 égale 55.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 + (3 × 4) - 2 ?",
    options: ["20", "22", "18"],
    answer: "20",
    explanation: "14 plus 12 (3 fois 4) moins 2 égale 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 2 × (3 - 1) ?",
    options: ["11", "13", "9"],
    answer: "11",
    explanation: "7 plus 4 (2 fois 2) égale 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (2 + 1) + 8 ?",
    options: ["22", "26", "18"],
    answer: "22",
    explanation: "30 divisé par 3 (2 plus 1) plus 8 égale 22.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (3 + 7) - 6 ?",
    options: ["24", "30", "36"],
    answer: "24",
    explanation:
        "On effectue d'abord les parenthèses : 3 + 7 = 10, puis 5 × 10 - 6 = 44.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - (4 × 2) + 3 ?",
    options: ["7", "9", "11"],
    answer: "9",
    explanation:
        "On effectue d'abord la multiplication : 4 × 2 = 8, puis 12 - 8 + 3 = 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ 6 + 4 × 2 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation:
        "On effectue d'abord la division : 36 ÷ 6 = 6, puis 4 × 2 = 8, et 6 + 8 = 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (5 × 8) ÷ 2 ?",
    options: ["30", "35", "40"],
    answer: "30",
    explanation:
        "On effectue d'abord la multiplication : 5 × 8 = 40, puis 40 ÷ 2 = 20, et 50 - 20 = 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 3 + 6 ÷ 2 ?",
    options: ["12", "15", "18"],
    answer: "18",
    explanation:
        "On effectue d'abord la division : 6 ÷ 2 = 3, puis 4 × 3 + 3 = 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 2) x 2 ?",
    options: ["16", "20", "18"],
    answer: "20",
    explanation: "La somme de 8 et 2 multipliée par 2 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (20 ÷ 5) ?",
    options: ["48", "46", "45"],
    answer: "48",
    explanation: "50 moins 20 divisé par 5 donne 48.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (14 - 4) x 3 ?",
    options: ["30", "32", "36"],
    answer: "30",
    explanation: "La différence de 14 et 4 multipliée par 3 donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ (5 + 5) + 10 ?",
    options: ["20", "30", "25"],
    answer: "20",
    explanation: "100 divisé par la somme de 5 et 5 plus 10 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 x 2) + (10 ÷ 2) ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation: "Le produit de 6 et 2 plus le quotient de 10 et 2 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 + 16 - 5 ?",
    options: ["25", "22", "21"],
    answer: "25",
    explanation: "La somme de 14 et 16, moins 5, est 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 ÷ 5 + 3 ?",
    options: ["12", "10", "11"],
    answer: "12",
    explanation:
        "La division de 45 par 5 donne 9, auquel on ajoute 3 pour obtenir 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) × 2 - 4 ?",
    options: ["14", "12", "10"],
    answer: "14",
    explanation:
        "On additionne d'abord 5 et 3, on multiplie par 2, puis on soustrait 4 pour obtenir 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 4 + (3 × 5) ?",
    options: ["23", "18", "22"],
    answer: "23",
    explanation:
        "On calcule d'abord 3 fois 5, puis on effectue les additions et soustractions pour obtenir 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 3 - 8 ÷ 4 ?",
    options: ["25", "27", "26"],
    answer: "25",
    explanation:
        "On effectue d'abord les multiplications et divisions, puis on soustrait pour obtenir 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 6) × 3 ÷ 2 ?",
    options: ["15", "12", "18"],
    answer: "15",
    explanation:
        "On additionne d'abord 4 et 6, on multiplie par 3, puis on divise par 2 pour obtenir 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - 3 + 6 ?",
    options: ["15", "14", "13"],
    answer: "15",
    explanation:
        "On soustrait d'abord 3 de 12, puis on ajoute 6 pour obtenir 15.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - (6 ÷ 2) ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation:
        "On effectue d'abord la division puis la soustraction : 15 - 3 = 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ 5 + 4 ?",
    options: ["6", "8", "10"],
    answer: "8",
    explanation: "On effectue d'abord la division puis l'addition : 4 + 4 = 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (6 - 2) + 3 ?",
    options: ["19", "20", "23"],
    answer: "23",
    explanation:
        "On effectue d'abord la soustraction puis la multiplication : 4 × 4 + 3 = 16 + 3 = 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - (3 × 2) + 5 ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation:
        "On effectue d'abord la multiplication puis les additions et soustractions : 10 - 6 + 5 = 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ (2 + 2) ?",
    options: ["3", "4", "5"],
    answer: "3",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses : 12 ÷ 4 = 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (3 + 5) × 2 ?",
    options: ["0", "2", "6"],
    answer: "0",
    explanation:
        "On effectue d'abord l'addition puis la multiplication : 14 - 16 = -2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 ÷ (9 - 6) ?",
    options: ["15", "18", "20"],
    answer: "15",
    explanation: "45 divisé par (9 moins 6) donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 2 + 6 ?",
    options: ["16", "17", "18"],
    answer: "18",
    explanation: "14 moins 2 plus 6 égale 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 × 2 - 5 ?",
    options: ["10", "15", "20"],
    answer: "15",
    explanation: "10 multiplié par 2 moins 5 donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 4 - 10 ?",
    options: ["14", "20", "24"],
    answer: "14",
    explanation: "6 multiplié par 4 moins 10 est 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 ÷ 4) × (6 - 3) ?",
    options: ["6", "9", "3"],
    answer: "9",
    explanation: "3 multiplié par 3 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 15) ÷ 4 + 2 ?",
    options: ["5", "7", "8"],
    answer: "7",
    explanation: "La somme de 5 et 15 divisée par 4, plus 2, donne 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 2 - (4 ÷ 2) ?",
    options: ["14", "15", "16"],
    answer: "14",
    explanation: "16 moins 2 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le produit de 6 × 2 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "Le produit de 6 et 2 est 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 3 - 1 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "Le produit de 4 et 3 moins 1 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (3 + 2) × 2 ?",
    options: ["0", "-1", "-2"],
    answer: "-1",
    explanation: "Neuf moins le produit de la somme de 3 et 2 par 2 donne -1.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 3 + 1 ?",
    options: ["22", "24", "26"],
    answer: "24",
    explanation: "La différence de 10 et 2 multipliée par 3 plus 1 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 2 + 5 - 6 ?",
    options: ["11", "12", "13"],
    answer: "11",
    explanation: "Le produit de 7 et 2 plus 5 moins 6 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - (3 x 2) + 5 ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "Le calcul donne 10 - 6 + 5 = 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (6 + 4) ?",
    options: ["22", "24", "20"],
    answer: "20",
    explanation: "La soustraction de 10 à 30 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + (16 ÷ 4) ?",
    options: ["10", "12", "14"],
    answer: "14",
    explanation: "La division de 16 par 4 donne 4, puis 8 + 4 = 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (4 + 5) - 9 ?",
    options: ["18", "21", "24"],
    answer: "18",
    explanation: "La somme de 4 et 5 est 9, donc 3 × 9 - 9 = 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 6 - 4 ?",
    options: ["10", "12", "8"],
    answer: "12",
    explanation: "10 plus 6 moins 4 égale 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ (5 + 0) ?",
    options: ["5", "6", "4"],
    answer: "5",
    explanation: "25 divisé par 5 égale 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 16 ÷ 2 + 3 × 2 ?",
    options: ["10", "11", "12"],
    answer: "10",
    explanation: "16 divisé par 2 plus 6 égale 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 + 5) × 2 - 8 ?",
    options: ["18", "20", "16"],
    answer: "18",
    explanation: "12 multiplié par 2 moins 8 égale 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (6 × 4) + 2 ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation: "30 moins 24 plus 2 égale 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 5) × (2 - 1) ?",
    options: ["10", "15", "20"],
    answer: "10",
    explanation: "10 multiplié par 1 égale 10.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - 18 ?",
    options: ["32", "30", "28"],
    answer: "32",
    explanation: "50 moins 18 donne 32.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 6 ?",
    options: ["48", "46", "50"],
    answer: "48",
    explanation: "8 multiplié par 6 égale 48.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 72 ÷ 8 ?",
    options: ["9", "8", "10"],
    answer: "9",
    explanation: "72 divisé par 8 donne 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 + 40 - 15 ?",
    options: ["45", "50", "55"],
    answer: "45",
    explanation: "20 plus 40 moins 15 égale 45.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (25 + 10) ?",
    options: ["65", "70", "75"],
    answer: "65",
    explanation: "100 moins 35 (25 plus 10) donne 65.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 × 3 - 10 ?",
    options: ["32", "42", "34"],
    answer: "32",
    explanation: "14 multiplié par 3 est 42, puis moins 10 donne 32.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) × 5 ?",
    options: ["50", "55", "40"],
    answer: "50",
    explanation: "(6 plus 4) donne 10, multiplié par 5 est 50.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 90 ÷ 9 + 5 ?",
    options: ["15", "10", "20"],
    answer: "15",
    explanation: "90 divisé par 9 est 10, puis plus 5 donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (6 + 4) - 10 ?",
    options: ["40", "30", "50"],
    answer: "40",
    explanation:
        "(6 plus 4) est 10, multiplié par 5 donne 50, puis moins 10 donne 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 7 - (5 + 1) ?",
    options: ["41", "42", "40"],
    answer: "41",
    explanation:
        "6 multiplié par 7 est 42, moins (5 plus 1) qui est 6 donne 41.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 4 + 2 × 3 ?",
    options: ["26", "24", "22"],
    answer: "26",
    explanation:
        "5 multiplié par 4 est 20, plus 2 multiplié par 3 qui est 6 donne 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (2 + 3) - 10 ?",
    options: ["30", "32", "28"],
    answer: "30",
    explanation:
        "(2 plus 3) est 5, multiplié par 8 donne 40, moins 10 donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (6 ÷ 2) ?",
    options: ["17", "18", "16"],
    answer: "17",
    explanation: "20 - (6 ÷ 2) égale 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ (3 - 1) + 6 ?",
    options: ["12", "9", "15"],
    answer: "12",
    explanation: "18 divisé par (3 - 1) plus 6 égale 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - (2 × 3) + 5 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "10 moins (2 multiplié par 3) plus 5 égale 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 5 × 4 + 2 ?",
    options: ["13", "15", "17"],
    answer: "13",
    explanation: "25 moins 5 multiplié par 4 plus 2 égale 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 3 × 2 ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation: "50 divisé par 5 plus 3 multiplié par 2 égale 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 7 - 3 ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "15 plus 7 moins 3 égale 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (18 - 6) ÷ 2 + 4 ?",
    options: ["6", "8", "10"],
    answer: "10",
    explanation: "La différence de 18 et 6 divisée par 2 plus 4 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (3 + 1) - 6 ?",
    options: ["22", "24", "26"],
    answer: "22",
    explanation: "7 multiplié par la somme de 3 et 1 moins 6 donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (2 + 4) ÷ 2 ?",
    options: ["15", "20", "25"],
    answer: "15",
    explanation:
        "5 multiplié par la somme de 2 et 4, puis divisé par 2, donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 3) × (4 - 2) ?",
    options: ["10", "12", "15"],
    answer: "12",
    explanation:
        "La différence de 9 et 3 multipliée par la différence de 4 et 2 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 - 4) ÷ 2 ?",
    options: ["7", "8", "9"],
    answer: "8",
    explanation: "La différence de 20 et 4, divisée par 2, est 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × 5 + 10 ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation: "Le produit de 2 et 5, plus 10, est 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 7 × 2 ?",
    options: ["20", "21", "22"],
    answer: "20",
    explanation: "La division de 18 par 3, plus le produit de 7 et 2, est 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + (6 ÷ 2) × 3 ?",
    options: ["15", "18", "21"],
    answer: "18",
    explanation:
        "La division de 6 par 2, multipliée par 3, ajoutée à 9, donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (4 × 9) + 2 ?",
    options: ["26", "28", "30"],
    answer: "26",
    explanation:
        "La multiplication de 4 et 9, soustraite de 50, plus 2, donne 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (1 + 2) × 5 ?",
    options: ["50", "60", "70"],
    answer: "50",
    explanation: "La division de 30 par 3, multipliée par 5, donne 50.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 x 2 + 10 ÷ 5 ?",
    options: ["20", "22", "24"],
    answer: "22",
    explanation:
        "On multiplie d'abord puis on divise, ce qui donne 14 + 2 = 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + (3 x 4) - 6 ?",
    options: ["20", "22", "18"],
    answer: "20",
    explanation:
        "On effectue d'abord la multiplication, puis on additionne et soustrait pour obtenir 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 3 - 2 x 4 ?",
    options: ["10", "8", "6"],
    answer: "8",
    explanation:
        "On effectue d'abord la multiplication, puis les additions et soustractions pour obtenir 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 7 + 3 ?",
    options: ["15", "16", "14"],
    answer: "16",
    explanation: "En soustrayant 7 de 20 puis en ajoutant 3, on obtient 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 5 ?",
    options: ["11", "12", "10"],
    answer: "11",
    explanation:
        "La division de 18 par 2 donne 9, auquel on ajoute 5, ce qui donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (12 ÷ 4) ?",
    options: ["48", "49", "47"],
    answer: "49",
    explanation: "La division de 12 par 4 donne 3, donc 50 moins 3 est 49.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 3) + (20 ÷ 5) ?",
    options: ["18", "17", "19"],
    answer: "18",
    explanation:
        "La multiplication donne 15 et la division donne 4, donc 15 plus 4 est 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 + 4 × 2 - 1 ?",
    options: ["10", "11", "9"],
    answer: "11",
    explanation:
        "La multiplication est effectuée en premier, donc 4 fois 2 est 8, et 3 plus 8 moins 1 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (3 × 2) + 5 ?",
    options: ["10", "11", "9"],
    answer: "11",
    explanation: "La multiplication donne 6, donc 9 moins 6 plus 5 est 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + (12 ÷ 4) × 2 ?",
    options: ["14", "16", "12"],
    answer: "16",
    explanation:
        "La division donne 3, multipliée par 2 donne 6, donc 8 plus 6 est 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (5 + 5) ÷ 5 ?",
    options: ["22", "20", "21"],
    answer: "22",
    explanation:
        "La somme donne 10, divisée par 5 donne 2, donc 25 moins 2 est 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) × 3 ?",
    options: ["24", "20", "18"],
    answer: "24",
    explanation: "La somme de 5 et 3 multipliée par 3 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - 15 + 5 ?",
    options: ["20", "15", "10"],
    answer: "20",
    explanation: "30 moins 15 plus 5 donne 20.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "10 - 4 + 2 = ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "On effectue d'abord la soustraction, puis l'addition.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "6 × 3 - 7 = ?",
    options: ["11", "12", "13"],
    answer: "11",
    explanation: "On effectue d'abord la multiplication, puis la soustraction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 - 3) × 2 = ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation:
        "Les parenthèses indiquent d'abord de soustraire avant de multiplier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 + 5 - (3 × 2) = ?",
    options: ["10", "11", "12"],
    answer: "10",
    explanation:
        "On résout d'abord le calcul dans les parenthèses avant de faire les additions et soustractions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 ÷ 3 + 4 × 2 = ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation:
        "On effectue d'abord la division, puis la multiplication, et enfin l'addition.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 ÷ 5) + (3 × 4) = ?",
    options: ["15", "16", "17"],
    answer: "15",
    explanation:
        "Les opérations dans les parenthèses sont effectuées avant l'addition.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(7 + 3) × 2 - 4 = ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation:
        "On additionne d'abord, puis on multiplie, et enfin on soustrait.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) × (5 + 3) = ?",
    options: ["56", "64", "72"],
    answer: "64",
    explanation:
        "On effectue les opérations dans les parenthèses avant de multiplier.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 × 2) + (9 ÷ 3) = ?",
    options: ["15", "16", "17"],
    answer: "15",
    explanation:
        "On résout chaque parenthèse avant d'additionner les résultats.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 × 3 ÷ 5 ?",
    options: ["6", "7", "8"],
    answer: "6",
    explanation: "On multiplie 10 par 3 puis on divise par 5, ce qui donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 6 - 2 × 3 ?",
    options: ["15", "16", "17"],
    answer: "15",
    explanation:
        "On effectue d'abord la multiplication puis les additions et soustractions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ 4 + 5 ?",
    options: ["8", "10", "15"],
    answer: "10",
    explanation: "On divise 20 par 4 puis on ajoute 5, ce qui donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) ÷ 2 + 3 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation:
        "On effectue d'abord la soustraction, puis la division et enfin l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (4 × 3) + 5 ?",
    options: ["18", "19", "20"],
    answer: "18",
    explanation:
        "On effectue d'abord la multiplication, puis les additions et soustractions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + (6 × 3) ?",
    options: ["18", "20", "22"],
    answer: "20",
    explanation:
        "On effectue d'abord la division, puis la multiplication et enfin l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (3 + 5) ?",
    options: ["16", "12", "14"],
    answer: "16",
    explanation: "2 multiplié par la somme de 3 et 5 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (2 × 10) + 5 ?",
    options: ["15", "20", "25"],
    answer: "15",
    explanation: "30 moins 20 plus 5 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 2 × 5 ?",
    options: ["5", "10", "7"],
    answer: "5",
    explanation: "On effectue d'abord la multiplication puis la soustraction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (5 + 1) ?",
    options: ["18", "21", "24"],
    answer: "18",
    explanation: "On effectue d'abord l'addition puis on multiplie par 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + (6 × 2) ?",
    options: ["19", "18", "20"],
    answer: "19",
    explanation: "On effectue d'abord la multiplication, puis l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 16 - (3 × 4) + 2 ?",
    options: ["6", "8", "10"],
    answer: "6",
    explanation:
        "On effectue d'abord la multiplication, puis on soustrait et additionne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) × (3 - 1) ?",
    options: ["24", "20", "22"],
    answer: "24",
    explanation:
        "On effectue d'abord les opérations entre parenthèses puis on multiplie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (2 + 1) × 5 ?",
    options: ["50", "60", "45"],
    answer: "50",
    explanation:
        "On effectue d'abord l'addition, puis la division et enfin la multiplication.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 15) ÷ 4 × 2 ?",
    options: ["10", "5", "8"],
    answer: "10",
    explanation:
        "On effectue d'abord l'addition, puis la division et enfin la multiplication.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ 4 + 5 ?",
    options: ["11", "10", "12"],
    answer: "11",
    explanation: "La division de 24 par 4, ajoutée à 5, donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ (5 - 3) + 6 ?",
    options: ["16", "20", "18"],
    answer: "16",
    explanation: "La division de 20 par 2, ajoutée à 6, donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 10 + 3 ?",
    options: ["5", "8", "7"],
    answer: "8",
    explanation: "La division de 50 par 10, ajoutée à 3, donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (3 - 1) + 4 ?",
    options: ["20", "24", "22"],
    answer: "24",
    explanation:
        "Multiplier 8 par la différence de 3 et 1, puis ajouter 4, donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) × 3 - 6 ?",
    options: ["30", "36", "24"],
    answer: "30",
    explanation:
        "La somme de 10 et 2, multipliée par 3 et soustraite de 6, donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (2 + 3) × 4 ?",
    options: ["20", "25", "10"],
    answer: "20",
    explanation:
        "Diviser 50 par la somme de 2 et 3, puis multiplier par 4, donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - (4 + 1) ?",
    options: ["18", "20", "16"],
    answer: "18",
    explanation:
        "Multiplier 7 par 3 et soustraire la somme de 4 et 1 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 2) + (3 × 4) ?",
    options: ["26", "22", "20"],
    answer: "26",
    explanation:
        "Multiplier 5 par 2 et 3 par 4, puis additionner les résultats, donne 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le produit de 6 × 4 ?",
    options: ["20", "24", "26"],
    answer: "24",
    explanation: "6 multiplié par 4 donne 24.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 15 + 6 - 4 ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "15 + 6 - 4 égale 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 4) ÷ 2 ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation: "(10 + 4) divisé par 2 donne 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 5 + 2 ?",
    options: ["15", "17", "18"],
    answer: "17",
    explanation: "3 multiplié par 5 plus 2 égale 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 2) × 3 - 6 ?",
    options: ["24", "26", "30"],
    answer: "24",
    explanation: "(8 + 2) multiplié par 3 moins 6 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (2 + 3) + 8 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "50 divisé par 5 plus 8 égale 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (3 + 1) × 2 ?",
    options: ["2", "4", "6"],
    answer: "2",
    explanation: "9 moins 8 donne 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (3 + 5) - 4 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "16 moins 6 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "12 ÷ 4 + 2 = ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "D'abord diviser 12 par 4, puis ajouter 2 au résultat.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "10 × 3 ÷ 5 = ?",
    options: ["6", "5", "7"],
    answer: "6",
    explanation: "Multiplier 10 par 3, puis diviser le résultat par 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 + 2) ÷ 2 × 3 = ?",
    options: ["18", "12", "15"],
    answer: "18",
    explanation: "Additionner 10 et 2, diviser par 2, puis multiplier par 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 + 4) × (2 - 1) = ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation:
        "Additionner 6 et 4, puis multiplier par le résultat de 2 moins 1.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 + 3) × (6 - 4) ÷ 2 = ?",
    options: ["8", "4", "6"],
    answer: "8",
    explanation:
        "Additionner 5 et 3, soustraire 4 de 6, puis diviser le produit par 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 ÷ 2) + (4 × 3) = ?",
    options: ["24", "22", "20"],
    answer: "24",
    explanation: "Diviser 18 par 2 et ajouter le produit de 4 et 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 - 3) × (5 + 1) = ?",
    options: ["36", "30", "24"],
    answer: "36",
    explanation:
        "Soustraire 3 de 9, additionner 5 et 1, puis multiplier les résultats.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(14 ÷ 2) + (6 × 2) = ?",
    options: ["20", "18", "22"],
    answer: "20",
    explanation: "Diviser 14 par 2, puis ajouter le produit de 6 et 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(7 + 3) × (2 + 2) = ?",
    options: ["40", "32", "30"],
    answer: "40",
    explanation: "Additionner 7 et 3, puis multiplier par la somme de 2 et 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 3) + (9 - 6) = ?",
    options: ["16", "18", "15"],
    answer: "16",
    explanation: "Multiplier 5 par 3, puis ajouter le résultat de 9 moins 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (6 - 2) ?",
    options: ["16", "20", "24"],
    answer: "16",
    explanation: "On soustrait d'abord 2 à 6 puis on multiplie par 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 18 ÷ 3 ?",
    options: ["15", "18", "21"],
    answer: "21",
    explanation: "D'abord, on divise 18 par 3 puis on ajoute 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (3 + 2) - 7 ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation:
        "On additionne d'abord puis on multiplie et enfin on soustrait.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 ÷ (2 + 3) ?",
    options: ["2", "3", "4"],
    answer: "2",
    explanation:
        "On additionne d'abord 2 et 3 puis on divise 14 par le résultat.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 - 4 ÷ 2 ?",
    options: ["6", "8", "4"],
    answer: "6",
    explanation: "On divise d'abord avant de soustraire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 4 × 2 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "18 moins 4 multiplié par 2 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ (2 + 4) + 3 ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation: "36 divisé par la somme de 2 et 4, plus 3, donne 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 15 ÷ 3 ?",
    options: ["17", "19", "15"],
    answer: "17",
    explanation: "12 plus 15 divisé par 3 donne 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 2 ?",
    options: ["10", "12", "8"],
    answer: "12",
    explanation: "50 divisé par 5 plus 2 donne 12.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (5 + 3) × 2 ?",
    options: ["6", "8", "10"],
    answer: "6",
    explanation:
        "On effectue d'abord l'opération dans les parenthèses, puis la multiplication et enfin la soustraction : 20 - 16 = 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 3 + 9 ÷ 3 ?",
    options: ["14", "15", "16"],
    answer: "14",
    explanation:
        "On effectue d'abord la multiplication, puis la division, et enfin l'addition : 15 + 3 = 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 5 × 3 ?",
    options: ["25", "21", "27"],
    answer: "21",
    explanation:
        "On effectue d'abord la division puis la multiplication, et enfin l'addition : 9 + 15 = 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 2 × 5 - 4 ?",
    options: ["16", "18", "14"],
    answer: "16",
    explanation:
        "On effectue d'abord la multiplication, puis l'addition et la soustraction : 10 + 10 - 4 = 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - 3 + 6 ?",
    options: ["10", "11", "12"],
    answer: "12",
    explanation: "La soustraction et l'addition donnent 12 : 9 - 3 + 6 = 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 ÷ (3 + 2) ?",
    options: ["2", "3", "5"],
    answer: "3",
    explanation:
        "On additionne d'abord 3 et 2 puis on divise 15 par le résultat.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (5 - 3) + 6 ?",
    options: ["10", "12", "14"],
    answer: "14",
    explanation:
        "On effectue d'abord la soustraction dans les parenthèses, puis on multiplie et enfin on additionne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (3 × 2) + 5 ?",
    options: ["7", "8", "9"],
    answer: "8",
    explanation:
        "On commence par multiplier 3 par 2, puis on effectue les opérations restantes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 2 × (3 + 1) ?",
    options: ["11", "13", "15"],
    answer: "15",
    explanation:
        "On commence par additionner dans les parenthèses, puis on multiplie et on additionne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) ÷ 2 × 3 ?",
    options: ["15", "18", "30"],
    answer: "15",
    explanation:
        "On effectue d'abord l'addition dans les parenthèses, suivi de la division et enfin de la multiplication.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 3 × 4 + 2 ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation:
        "On commence par multiplier, puis on effectue les soustractions et additions dans l'ordre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 3 + 4 ÷ 2 ?",
    options: ["16", "17", "18"],
    answer: "17",
    explanation:
        "On effectue d'abord la multiplication, puis la division et enfin l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 14 - 5 ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "9 plus 14 moins 5 égale 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (15 + 10) ?",
    options: ["25", "30", "35"],
    answer: "25",
    explanation: "50 moins la somme de 15 et 10 égale 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (4 - 2) ?",
    options: ["16", "12", "20"],
    answer: "16",
    explanation: "8 multiplié par la différence de 4 et 2 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 ÷ 5 + 3 ?",
    options: ["11", "10", "12"],
    answer: "11",
    explanation: "40 divisé par 5 plus 3 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 7 - (5 + 4) ?",
    options: ["12", "10", "14"],
    answer: "12",
    explanation: "3 multiplié par 7 moins la somme de 5 et 4 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 5 - 10 ?",
    options: ["15", "20", "25"],
    answer: "15",
    explanation: "5 multiplié par 5 moins 10 donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 4 + 4 ÷ 4 ?",
    options: ["17", "16", "18"],
    answer: "17",
    explanation: "4 multiplié par 4 plus 4 divisé par 4 donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 ÷ (2 + 3) ?",
    options: ["2", "3", "5"],
    answer: "2",
    explanation:
        "On effectue d'abord l'addition, puis la division, ce qui donne 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (3 - 1) + 4 ?",
    options: ["18", "20", "16"],
    answer: "18",
    explanation:
        "On effectue d'abord la parenthèse, puis la multiplication et l'addition, ce qui donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 15 ÷ 3 - 2 ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation:
        "On effectue d'abord la division, puis les additions et soustractions, ce qui donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 × 5) - (2 × 3) ?",
    options: ["14", "16", "10"],
    answer: "16",
    explanation:
        "On effectue d'abord les multiplications, puis la soustraction, ce qui donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (5 - 3) + 6 ?",
    options: ["21", "24", "18"],
    answer: "21",
    explanation:
        "On effectue d'abord la parenthèse, puis la division et l'addition, ce qui donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 18 + 7 ?",
    options: ["12", "14", "10"],
    answer: "14",
    explanation: "25 moins 18 plus 7 égale 14.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + (6 × 3) ?",
    options: ["23", "24", "18"],
    answer: "23",
    explanation:
        "On effectue d'abord la multiplication, puis l'addition, ce qui donne 23.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (2 + 3) - 10 ?",
    options: ["15", "10", "25"],
    answer: "15",
    explanation: "Le produit de 5 et 5 moins 10 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (2 + 1) + 5 ?",
    options: ["15", "10", "20"],
    answer: "15",
    explanation: "La division de 30 par 3 plus 5 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × 3 + 6 ÷ 3 ?",
    options: ["8", "10", "12"],
    answer: "8",
    explanation: "Le produit de 2 et 3 plus 2 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 6 × 2 ?",
    options: ["10", "11", "12"],
    answer: "12",
    explanation: "La multiplication de 6 par 2 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (3 + 7) × 2 ?",
    options: ["20", "18", "22"],
    answer: "20",
    explanation: "Ajouter 3 et 7 puis multiplier par 2 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 5 × (3 + 1) ?",
    options: ["20", "15", "25"],
    answer: "20",
    explanation: "Multiplier 5 par la somme de 3 et 1 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (8 ÷ 2) + (9 - 3) ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "Calculer les opérations dans les parenthèses donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 25 ÷ 5 + 3 ?",
    options: ["8", "7", "6"],
    answer: "8",
    explanation: "Diviser 25 par 5 puis ajouter 3 donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 14 - 6 + 5 ?",
    options: ["13", "12", "14"],
    answer: "13",
    explanation: "Effectuer les opérations donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 × 2 - 5 = ?",
    options: ["10", "13", "18"],
    answer: "13",
    explanation:
        "9 multiplié par 2 donne 18, et en soustrayant 5, on obtient 13.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 + 4 ÷ 2 = ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "4 divisé par 2 donne 2, et 8 plus 2 donne 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) × 3 + 1 = ?",
    options: ["24", "25", "26"],
    answer: "25",
    explanation:
        "10 moins 2 donne 8, multiplié par 3 donne 24, et en ajoutant 1, on obtient 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 ÷ 2) + (6 × 2) = ?",
    options: ["18", "20", "24"],
    answer: "24",
    explanation:
        "18 divisé par 2 donne 9, et 6 multiplié par 2 donne 12, la somme est 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 3) - (4 ÷ 2) = ?",
    options: ["14", "15", "16"],
    answer: "14",
    explanation:
        "5 multiplié par 3 donne 15, et 4 divisé par 2 donne 2, 15 moins 2 donne 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 3) × (2 + 1) = ?",
    options: ["21", "24", "27"],
    answer: "21",
    explanation:
        "10 moins 3 donne 7, et 2 plus 1 donne 3, multipliés donnent 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 ÷ 2) + (9 - 3) × 2 = ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation:
        "8 divisé par 2 donne 4, et 9 moins 3 donne 6, multipliés donnent 12, additionnés donnent 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(15 - 5) ÷ (2 + 3) = ?",
    options: ["2", "3", "4"],
    answer: "2",
    explanation:
        "15 moins 5 donne 10, et 2 plus 3 donne 5, 10 divisé par 5 donne 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 3 - 6 ?",
    options: ["27", "21", "24"],
    answer: "21",
    explanation: "9 multiplié par 3 donne 27, moins 6 égale 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + (6 × 2) - 3 ?",
    options: ["14", "12", "16"],
    answer: "14",
    explanation: "6 multiplié par 2 est 12, plus 5 moins 3 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ (3 - 1) + 4 ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation: "3 moins 1 est 2, 12 divisé par 2 est 6, plus 4 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 15 - (5 × 2) ?",
    options: ["16", "18", "20"],
    answer: "18",
    explanation: "5 multiplié par 2 est 10, 9 plus 15 moins 10 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (7 + 3) × 2 ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation:
        "La somme de 7 et 3 est 10, multiplié par 2 donne 20, 25 moins 20 est 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 5) ÷ 2 + 2 ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation:
        "La somme de 5 et 5 est 10, divisé par 2 donne 5, puis ajouter 2 fait 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 35 ÷ 5 + 3 ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation: "Diviser 35 par 5 donne 7, puis ajouter 3 fait 10.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 6 - 2 ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation: "10 plus 6 moins 2 égale 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × (2 + 3) ?",
    options: ["45", "50", "55"],
    answer: "45",
    explanation: "9 multiplié par (2 plus 3) égale 45.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 × (3 - 1) + 6 ?",
    options: ["30", "24", "36"],
    answer: "30",
    explanation: "12 multiplié par (3 moins 1) plus 6 égale 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "3 × 5 + 2 = ?",
    options: ["15", "17", "19"],
    answer: "17",
    explanation: "3 × 5 = 15, puis 15 + 2 = 17.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 × 2) - (3 + 1) = ?",
    options: ["8", "9", "10"],
    answer: "8",
    explanation: "6 × 2 = 12, puis 3 + 1 = 4, et 12 - 4 = 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 ÷ (5 - 3) = ?",
    options: ["5", "10", "15"],
    answer: "10",
    explanation: "5 - 3 = 2, puis 20 ÷ 2 = 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(3 + 5) × (2 - 1) = ?",
    options: ["8", "10", "16"],
    answer: "8",
    explanation: "3 + 5 = 8, et 2 - 1 = 1, donc 8 × 1 = 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(12 ÷ 3) × (5 - 2) = ?",
    options: ["8", "10", "12"],
    answer: "12",
    explanation: "12 ÷ 3 = 4, puis 5 - 2 = 3, donc 4 × 3 = 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(15 + 5) - (3 × 5) = ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation: "15 + 5 = 20, puis 3 × 5 = 15, donc 20 - 15 = 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 4) - (8 ÷ 2) = ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation: "5 × 4 = 20, puis 8 ÷ 2 = 4, donc 20 - 4 = 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - (3 × 2) + 1 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation:
        "La multiplication de 3 par 2, soustraite de 10, ajoutée à 1 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (2 + 3) × 2 ?",
    options: ["6", "7", "8"],
    answer: "6",
    explanation:
        "La somme de 2 et 3, multipliée par 2, soustraite de 14 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 + 9 ÷ 3 ?",
    options: ["5", "6", "8"],
    answer: "8",
    explanation: "La division de 9 par 3, ajoutée à 3, donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 - 4 + 2 = ?",
    options: ["5", "6", "7"],
    answer: "7",
    explanation:
        "En soustrayant 4 de 9, on obtient 5, puis en ajoutant 2, on atteint 7.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "6 × 2 ÷ 3 = ?",
    options: ["2", "3", "4"],
    answer: "4",
    explanation:
        "La multiplication de 6 par 2 donne 12, et 12 divisé par 3 égale 4.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 ÷ 4 + 5 = ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation: "La division de 8 par 4 donne 2 et 2 plus 5 donne 7.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 × 2) + (6 ÷ 3) = ?",
    options: ["10", "11", "12"],
    answer: "10",
    explanation:
        "La multiplication donne 8 et la division donne 2, ensemble ils font 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - (3 × 4) = ?",
    options: ["3", "6", "9"],
    answer: "3",
    explanation:
        "La multiplication de 3 par 4 donne 12, et 15 moins 12 donne 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(12 ÷ 3) + (4 × 2) = ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation:
        "La division donne 4 et la multiplication donne 8, ensemble ils font 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "((6 + 4) × 2) - 8 = ?",
    options: ["8", "10", "12"],
    answer: "8",
    explanation:
        "La somme donne 10, multipliée par 2 donne 20, et 20 moins 12 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 ÷ 4) + (3 × 3) = ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation:
        "La division donne 5 et la multiplication donne 9, ensemble ils font 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 - 3) × (5 ÷ 5) = ?",
    options: ["6", "7", "8"],
    answer: "6",
    explanation:
        "La soustraction donne 6 et la division donne 1, donc 6 multiplié par 1 reste 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + (3 × 2) ?",
    options: ["10", "14", "12"],
    answer: "14",
    explanation: "8 plus 6 (3 fois 2) est égal à 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (5 + 3) ?",
    options: ["24", "28", "32"],
    answer: "32",
    explanation: "4 multiplié par la somme de 5 et 3 donne 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - 2 × (3 + 1) ?",
    options: ["4", "6", "8"],
    answer: "4",
    explanation: "10 moins 8 (2 fois 4) est égal à 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (4 - 2) ?",
    options: ["12", "10", "14"],
    answer: "14",
    explanation:
        "On effectue d'abord la soustraction : 4 - 2 = 2, puis 7 × 2 = 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (1 + 5) ?",
    options: ["5", "6", "4"],
    answer: "5",
    explanation:
        "On additionne d'abord 1 et 5 pour obtenir 6, puis 30 ÷ 6 = 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (5 + 3) - 6 ?",
    options: ["34", "26", "28"],
    answer: "34",
    explanation:
        "On additionne d'abord 5 et 3 pour obtenir 8, puis 5 × 8 = 40, puis 40 - 6 = 34.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 4 × 2 ?",
    options: ["14", "16", "10"],
    answer: "14",
    explanation:
        "On effectue d'abord la division : 50 ÷ 5 = 10, puis 4 × 2 = 8, enfin 10 + 8 = 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 ÷ 3) + (10 - 2) ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses : 12 ÷ 3 = 4 et 10 - 2 = 8, puis 4 + 8 = 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 ÷ 3 + 4 ?",
    options: ["3", "5", "7"],
    answer: "5",
    explanation: "On effectue d'abord la division avant l'addition.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - 5 × 9 ?",
    options: ["5", "45", "10"],
    answer: "5",
    explanation: "On effectue d'abord la multiplication puis la soustraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 2 + 3 ?",
    options: ["8", "7", "5"],
    answer: "8",
    explanation:
        "On effectue d'abord l'opération dans les parenthèses puis les autres opérations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 6 × 2 ?",
    options: ["12", "18", "24"],
    answer: "18",
    explanation:
        "On effectue d'abord la division et la multiplication avant l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 5 - 3 × 4 ?",
    options: ["13", "17", "21"],
    answer: "13",
    explanation:
        "On effectue d'abord les multiplications puis la soustraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (3 + 3) + 4 ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation:
        "On effectue d'abord l'opération dans les parenthèses puis la division et l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (2 × 3) ?",
    options: ["8", "6", "4"],
    answer: "8",
    explanation: "14 moins 6 (2 fois 3) donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - 2 × (3 + 1) ?",
    options: ["6", "2", "8"],
    answer: "6",
    explanation: "10 moins 8 (2 fois 4) donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 4 × (3 - 1) ?",
    options: ["16", "12", "14"],
    answer: "16",
    explanation: "20 moins 8 (4 fois 2) donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ (2 + 1) + 4 ?",
    options: ["6", "8", "10"],
    answer: "10",
    explanation: "Diviser 18 par la somme de 2 et 1, puis ajouter 4, donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (3 × 5) + 2 ?",
    options: ["15", "18", "20"],
    answer: "18",
    explanation: "Soustraire 3 multiplié par 5 de 25 et ajouter 2 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 4) × 3 ?",
    options: ["15", "16", "18"],
    answer: "18",
    explanation: "Soustraire 4 de 10, puis multiplier par 3 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 5 + 7 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "Diviser 30 par 5 et ajouter 7 donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 2 - 6 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "Multiplier 8 par 2 et soustraire 6 donne 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 3 × (2 + 1) ?",
    options: ["16", "12", "10"],
    answer: "16",
    explanation:
        "On effectue d'abord la parenthèse : 3 fois 3 est 9, plus 7 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) ÷ 2 × 4 ?",
    options: ["16", "14", "12"],
    answer: "16",
    explanation:
        "La somme dans les parenthèses est 8, divisé par 2 donne 4, multiplié par 4 donne 16.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 ÷ 2 + 3 ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation: "8 divisé par 2 plus 3 donne 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (3 + 4) - 5 ?",
    options: ["9", "10", "11"],
    answer: "9",
    explanation: "2 multiplié par la somme de 3 et 4 moins 5 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (2 + 3) × 6 ?",
    options: ["36", "42", "48"],
    answer: "36",
    explanation: "30 divisé par la somme de 2 et 3 multiplié par 6 donne 36.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (25 × 3) ?",
    options: ["25", "50", "75"],
    answer: "25",
    explanation: "100 moins 25 multiplié par 3 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 3 × 4 ?",
    options: ["20", "22", "24"],
    answer: "22",
    explanation: "50 divisé par 5 plus 3 multiplié par 4 donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 × 2) + (12 ÷ 3) ?",
    options: ["20", "22", "24"],
    answer: "22",
    explanation:
        "La multiplication de 8 par 2 plus la division de 12 par 3 donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 9 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "La différence entre 20 et 9 est 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 × 2 ?",
    options: ["20", "22", "24"],
    answer: "24",
    explanation: "Le produit de 12 et 2 est 24.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 ÷ 2) × 3 + 4 ?",
    options: ["18", "20", "22"],
    answer: "22",
    explanation: "Le calcul donne (10 ÷ 2) × 3 + 4 = 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + (2 × 4) ?",
    options: ["13", "14", "15"],
    answer: "13",
    explanation: "Le calcul donne 5 + (2 × 4) = 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (3 + 2) × 2 ?",
    options: ["0", "1", "2"],
    answer: "0",
    explanation: "Le calcul donne 9 - (3 + 2) × 2 = 0.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 2 + 5 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "(8 plus 4) divisé par 2 plus 5 égale 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (6 + 4) × 2 ?",
    options: ["15", "10", "5"],
    answer: "15",
    explanation: "25 moins (6 plus 4 multiplié par 2) égale 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ (2 + 4) + 3 ?",
    options: ["6", "8", "5"],
    answer: "6",
    explanation: "18 divisé par (2 plus 4) plus 3 égale 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - (2 + 1) ?",
    options: ["20", "21", "19"],
    answer: "20",
    explanation: "7 multiplié par 3 moins (2 plus 1) égale 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (3 × 5) + 2 ?",
    options: ["20", "22", "23"],
    answer: "22",
    explanation: "30 moins (3 multiplié par 5) plus 2 égale 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 15 - 3 × 2 ?",
    options: ["9", "12", "6"],
    answer: "9",
    explanation: "La multiplication est faite en premier, donc 15 - 6 donne 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 50 ÷ (5 + 5) ?",
    options: ["5", "10", "2"],
    answer: "5",
    explanation:
        "On additionne d'abord 5 et 5 pour obtenir 10, puis on divise 50 par 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (3 × 4) + 2 ?",
    options: ["10", "14", "8"],
    answer: "14",
    explanation:
        "On effectue d'abord la multiplication, puis les additions et soustractions dans l'ordre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (6 + 2) - 4 ?",
    options: ["20", "22", "18"],
    answer: "20",
    explanation:
        "On additionne 6 et 2, puis on multiplie par 3 et soustrait 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (3 + 5) - 8 ÷ 2 ?",
    options: ["28", "30", "24"],
    answer: "28",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses et ensuite les multiplications et divisions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait (5 + 3) × (4 - 2) ?",
    options: ["16", "14", "12"],
    answer: "16",
    explanation:
        "On additionne 5 et 3, puis on soustrait 2 de 4 et on multiplie les résultats.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 9 - 2 + 3 ?",
    options: ["6", "4", "10"],
    answer: "10",
    explanation:
        "On effectue les opérations de gauche à droite : 9 - 2 est 7, puis 7 + 3 est 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 2) x 4 ?",
    options: ["24", "25", "26"],
    answer: "24",
    explanation: "La multiplication de 6 par 4 donne 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 x (2 + 3) - 5 ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation: "Le calcul donne 5 fois 5 moins 5, soit 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (2 + 3) x 3 ?",
    options: ["12", "15", "18"],
    answer: "18",
    explanation: "La division de 30 par 5 fois 3 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) x 2 - 4 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "Le calcul donne 8 fois 2 moins 4, soit 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (5 + 5) ?",
    options: ["15", "10", "20"],
    answer: "15",
    explanation: "La soustraction donne 25 moins 10, soit 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (6 - 2) + 4 ?",
    options: ["24", "26", "22"],
    answer: "24",
    explanation: "5 multiplié par la différence de 6 et 2, plus 4, égale 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ 6 + 5 ?",
    options: ["8", "9", "7"],
    answer: "9",
    explanation: "36 divisé par 6 plus 5 égale 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 3 - 5 ?",
    options: ["7", "9", "10"],
    answer: "7",
    explanation: "4 multiplié par 3 moins 5 égale 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 6 - 2 ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "La somme de 15 et 6, moins 2, est 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 7 + 5 ?",
    options: ["16", "17", "18"],
    answer: "16",
    explanation: "18 moins 7 plus 5 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 6) × (5 - 3) ?",
    options: ["20", "15", "25"],
    answer: "20",
    explanation: "10 multiplié par 2 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (5 × 4) + 10 ?",
    options: ["10", "15", "20"],
    answer: "15",
    explanation: "25 moins 20, plus 10, donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (3 + 1) ?",
    options: ["32", "30", "28"],
    answer: "32",
    explanation: "La somme de 3 et 1 est 4, multipliée par 8 donne 32.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 5 + 6 ?",
    options: ["26", "22", "24"],
    answer: "26",
    explanation: "La multiplication de 4 par 5 est 20, ajoutée à 6 donne 26.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - (8 ÷ 2) ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "La multiplication de 7 par 3 est 21, moins 4 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 6) × 2 - 8 ?",
    options: ["28", "24", "32"],
    answer: "28",
    explanation:
        "La somme de 10 et 6 est 16, multipliée par 2 donne 32, moins 8 est 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ (2 + 1) × 3 ?",
    options: ["18", "12", "15"],
    answer: "18",
    explanation:
        "La somme de 2 et 1 est 3, donc 18 divisé par 3 est 6, multiplié par 3 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 - 4) × 2 + 3 ?",
    options: ["22", "20", "18"],
    answer: "22",
    explanation:
        "La soustraction de 4 à 12 est 8, multipliée par 2 donne 16, ajoutée à 3 est 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + (2 × 4) ?",
    options: ["15", "14", "16"],
    answer: "15",
    explanation:
        "On effectue d'abord la multiplication, puis l'addition : 7 + 8 = 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ 4 + 2 ?",
    options: ["3", "5", "7"],
    answer: "7",
    explanation:
        "On effectue d'abord la division, puis l'addition : 5 + 2 = 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 2 × (3 + 1) ?",
    options: ["18", "16", "14"],
    answer: "18",
    explanation:
        "On effectue d'abord l'addition dans les parenthèses, puis la multiplication : 10 + 8 = 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 - (6 × 2) ?",
    options: ["12", "10", "8"],
    answer: "12",
    explanation: "24 moins 12 est égal à 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 12) × 2 ?",
    options: ["36", "40", "32"],
    answer: "40",
    explanation: "8 plus 12 est 20, multiplié par 2 donne 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 3 - (4 ÷ 2) ?",
    options: ["26", "27", "28"],
    answer: "26",
    explanation: "9 multiplié par 3 est 27, moins 2 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ 5 + 5 ?",
    options: ["20", "25", "30"],
    answer: "25",
    explanation: "100 divisé par 5 est 20, plus 5 donne 25.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 6 - 5 ?",
    options: ["10", "11", "12"],
    answer: "10",
    explanation: "La somme de 9 et 6, moins 5, donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 3 × (4 + 2).",
    options: ["12", "15", "18"],
    answer: "18",
    explanation:
        "On effectue d'abord l'addition, puis la multiplication, ce qui donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 7 × 3 - 4 ÷ 2.",
    options: ["19", "20", "21"],
    answer: "19",
    explanation:
        "On effectue d'abord la multiplication, puis la division, et enfin la soustraction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez (3 + 5) × (4 - 2).",
    options: ["12", "16", "14"],
    answer: "16",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses, puis la multiplication.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 5 × (6 - 2) + 3.",
    options: ["23", "28", "20"],
    answer: "23",
    explanation:
        "On effectue d'abord la soustraction, puis la multiplication, et enfin l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 ÷ 2) + (3 × 4) ?",
    options: ["14", "18", "16"],
    answer: "14",
    explanation:
        "On effectue d'abord les divisions et multiplications, puis l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 4 × 5 - 6 ÷ 3 + 2.",
    options: ["16", "18", "20"],
    answer: "16",
    explanation:
        "On effectue d'abord les multiplications et divisions, puis les additions et soustractions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 1 + 2 + 3 + 4 ?",
    options: ["8", "9", "10"],
    answer: "10",
    explanation: "La somme de 1, 2, 3 et 4 donne 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "5 + 3 × 2 = ?",
    options: ["11", "16", "10"],
    answer: "11",
    explanation: "On effectue d'abord la multiplication, puis l'addition.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - 6 ÷ 2 = ?",
    options: ["9", "12", "6"],
    answer: "12",
    explanation: "On effectue d'abord la division, puis la soustraction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 × (2 + 3) = ?",
    options: ["40", "50", "30"],
    answer: "40",
    explanation:
        "On effectue d'abord l'opération dans les parenthèses, puis la multiplication.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - 4) × 2 = ?",
    options: ["32", "36", "28"],
    answer: "32",
    explanation: "On soustrait d'abord 4 de 20, puis on multiplie par 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(3 + 5) × (4 - 2) = ?",
    options: ["16", "12", "8"],
    answer: "16",
    explanation:
        "On effectue les opérations dans les parenthèses avant de multiplier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "18 ÷ 3 × 2 = ?",
    options: ["6", "12", "9"],
    answer: "12",
    explanation: "On divise d'abord 18 par 3, puis on multiplie par 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 - 3) × (6 ÷ 2) = ?",
    options: ["18", "12", "24"],
    answer: "18",
    explanation:
        "On effectue les calculs dans les parenthèses avant de multiplier.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 + 2) ÷ (3 - 1) × 4 = ?",
    options: ["24", "20", "16"],
    answer: "24",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses, puis on multiplie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 3) + (8 ÷ 2) = ?",
    options: ["19", "23", "17"],
    answer: "19",
    explanation:
        "On effectue les multiplications et divisions avant d'additionner.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(14 - 6) × 3 + 2 = ?",
    options: ["26", "28", "24"],
    answer: "26",
    explanation: "On soustrait d'abord, puis on multiplie, et enfin on ajoute.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 × 4 - 10 = ?",
    options: ["18", "28", "24"],
    answer: "18",
    explanation: "On multiplie d'abord, puis on soustrait.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 ÷ 5 + 6 = ?",
    options: ["8", "4", "6"],
    answer: "8",
    explanation: "On divise d'abord avant d'additionner.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(15 ÷ 3) × 5 - 2 = ?",
    options: ["23", "25", "20"],
    answer: "23",
    explanation: "On commence par la division, puis on multiplie et soustrait.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × 2 ?",
    options: ["12", "14", "16"],
    answer: "16",
    explanation: "La somme de 6 et 2, multipliée par 2, donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 2 + 5 ?",
    options: ["25", "30", "35"],
    answer: "30",
    explanation: "50 divisé par 2 donne 25, puis en ajoutant 5 on obtient 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 2 × (6 - 4) ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "9 plus 2 fois 2 (6 moins 4) donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (5 - 2) + 3 ?",
    options: ["15", "16", "17"],
    answer: "15",
    explanation: "La multiplication de 4 par 3 (5 moins 2) plus 3 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 10) ÷ 2 ?",
    options: ["10", "15", "20"],
    answer: "10",
    explanation: "La somme de 10 et 10, divisée par 2, donne 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 21 - (6 ÷ 3) ?",
    options: ["19", "20", "21"],
    answer: "20",
    explanation: "21 moins 2 (6 divisé par 3) est égal à 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (30 ÷ 3) + (4 × 2) ?",
    options: ["14", "16", "18"],
    answer: "16",
    explanation: "10 (30 divisé par 3) plus 8 (4 fois 2) donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 ÷ 2 + 4 = ?",
    options: ["8", "6", "4"],
    answer: "6",
    explanation: "On divise d'abord puis on additionne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "12 - 4 × 2 = ?",
    options: ["4", "8", "6"],
    answer: "4",
    explanation:
        "On effectue d'abord la multiplication et ensuite la soustraction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 + 2) × 3 = ?",
    options: ["24", "18", "28"],
    answer: "24",
    explanation:
        "On effectue d'abord l'addition dans les parenthèses, puis la multiplication.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) ÷ 2 + 3 = ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation:
        "On effectue d'abord la soustraction, puis la division et enfin l'addition.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 + 3) × (2 - 1) = ?",
    options: ["12", "9", "15"],
    answer: "12",
    explanation: "On effectue d'abord les opérations dans les parenthèses.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 × 3) + (2 × 2) = ?",
    options: ["16", "14", "12"],
    answer: "14",
    explanation:
        "On effectue les multiplications dans chaque parenthèse avant d'additionner.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 + 5) ÷ (2 + 3) = ?",
    options: ["2", "1", "3"],
    answer: "2",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses, puis la division.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 ÷ 4 × 3 = ?",
    options: ["15", "12", "18"],
    answer: "15",
    explanation: "On effectue d'abord la division, puis la multiplication.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 + 5 - 3 = ?",
    options: ["9", "11", "10"],
    answer: "9",
    explanation: "On effectue d'abord l'addition, puis la soustraction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "18 - 9 + 3 = ?",
    options: ["12", "10", "8"],
    answer: "12",
    explanation: "On effectue d'abord la soustraction, puis l'addition.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(3 × 3) + (4 × 2) = ?",
    options: ["18", "17", "14"],
    answer: "17",
    explanation: "On effectue d'abord les multiplications, puis l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) + (4 × 3) ?",
    options: ["14", "16", "18"],
    answer: "16",
    explanation: "Dix moins deux plus douze (quatre fois trois) donne seize.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 5 + 10 ?",
    options: ["12", "14", "16"],
    answer: "16",
    explanation: "Trente divisé par cinq, plus dix, donne seize.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 7 - 5 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "Neuf plus sept moins cinq donne onze.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 2 + 3 ?",
    options: ["15", "16", "17"],
    answer: "15",
    explanation: "Six fois deux plus trois donne quinze.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 2) × 5 ?",
    options: ["30", "32", "36"],
    answer: "30",
    explanation:
        "La différence de huit et deux, multipliée par cinq, donne trente.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ (3 - 1) + 6 ?",
    options: ["9", "12", "6"],
    answer: "9",
    explanation: "12 divisé par (3 - 1) plus 6 égale 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 5) ÷ 3 × 2 ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation: "(10 + 5) divisé par 3 multiplié par 2 égale 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (7 - 3) + 10 ?",
    options: ["26", "30", "22"],
    answer: "26",
    explanation: "4 multiplié par (7 - 3) plus 10 égale 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 3 + 9 ?",
    options: ["21", "19", "22"],
    answer: "21",
    explanation: "15 moins 3 plus 9 donne 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (2 + 3) ?",
    options: ["6", "5", "4"],
    answer: "6",
    explanation:
        "On additionne d'abord 2 et 3, puis on divise 30 par 5, ce qui donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (10 ÷ 2) ?",
    options: ["45", "40", "35"],
    answer: "45",
    explanation:
        "On divise d'abord 10 par 2, puis on soustrait de 50, ce qui donne 45.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 2 + 6 ÷ 3 ?",
    options: ["21", "18", "24"],
    answer: "21",
    explanation: "9 × 2 + (6 ÷ 3) donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 8 × 2 ?",
    options: ["26", "22", "28"],
    answer: "26",
    explanation: "50 ÷ 5 + (8 × 2) donne 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (6 ÷ 2) + 5 ?",
    options: ["13", "12", "11"],
    answer: "13",
    explanation: "14 - (6 ÷ 2) + 5 donne 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 3 + 10 - 5 ?",
    options: ["15", "10", "20"],
    answer: "15",
    explanation: "30 ÷ 3 + 10 - 5 donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 x 2 = ?",
    options: ["16", "14", "18"],
    answer: "16",
    explanation: "La multiplication de 8 par 2 donne 16.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "10 - 4 + 3 = ?",
    options: ["9", "8", "7"],
    answer: "9",
    explanation: "On soustrait 4 de 10, puis on ajoute 3, ce qui donne 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "12 ÷ 3 + 1 = ?",
    options: ["5", "4", "3"],
    answer: "5",
    explanation: "On divise 12 par 3, puis on ajoute 1, ce qui donne 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "6 x 3 - 5 = ?",
    options: ["13", "15", "18"],
    answer: "13",
    explanation: "On multiplie 6 par 3 puis on soustrait 5, ce qui donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 ÷ 4 + 5 = ?",
    options: ["10", "7", "8"],
    answer: "10",
    explanation: "On divise 20 par 4, puis on ajoute 5, ce qui donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "4 x (2 + 3) = ?",
    options: ["20", "15", "25"],
    answer: "20",
    explanation:
        "On effectue d'abord l'opération entre parenthèses, puis on multiplie par 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "18 - 3 x 4 = ?",
    options: ["6", "12", "10"],
    answer: "6",
    explanation:
        "On effectue d'abord la multiplication, puis on soustrait le résultat de 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 + 6) ÷ 3 x 2 = ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation:
        "On effectue d'abord l'addition, puis la division, et enfin la multiplication.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "40 - (8 ÷ 2) x 5 = ?",
    options: ["30", "20", "25"],
    answer: "30",
    explanation:
        "On effectue d'abord la division, puis la multiplication, et enfin la soustraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "3 x (5 + 4) - 7 = ?",
    options: ["20", "14", "17"],
    answer: "20",
    explanation:
        "On effectue d'abord l'addition dans les parenthèses, puis la multiplication et la soustraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 - 3) ÷ 3 + 7 = ?",
    options: ["8", "9", "7"],
    answer: "8",
    explanation:
        "On effectue d'abord la soustraction, puis la division, et enfin l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (14 - 6) × 2 ?",
    options: ["16", "12", "14"],
    answer: "16",
    explanation: "La différence de 14 et 6 multipliée par 2 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 5) × (6 - 2) ?",
    options: ["32", "24", "48"],
    answer: "32",
    explanation:
        "La somme de 3 et 5 multipliée par la différence de 6 et 2 donne 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 7 + 7 ?",
    options: ["21", "20", "19"],
    answer: "21",
    explanation: "La somme de trois fois 7 donne 21.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (5 + 5) ?",
    options: ["2", "3", "4"],
    answer: "3",
    explanation: "30 divisé par (5 + 5) égale 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 ÷ 2 + 6 ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation: "8 divisé par 2 plus 6 égale 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "5 + 3",
    options: ["7", "8", "9"],
    answer: "8",
    explanation: "La somme de 5 et 3 est 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "12 - 4",
    options: ["8", "7", "9"],
    answer: "8",
    explanation: "Soustraire 4 de 12 donne 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "6 × 2",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "Multiplier 6 par 2 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 ÷ 3",
    options: ["5", "4", "6"],
    answer: "5",
    explanation: "Diviser 15 par 3 donne 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 + 6 - 3",
    options: ["12", "10", "15"],
    answer: "12",
    explanation: "9 plus 6 moins 3 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "18 - 7 + 2",
    options: ["13", "12", "14"],
    answer: "13",
    explanation: "18 moins 7 plus 2 donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "25 ÷ (5 - 3)",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "25 divisé par 2 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 + 4 × 2 - 6",
    options: ["10", "14", "12"],
    answer: "10",
    explanation: "Suivant l'ordre des opérations, on obtient 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "4 × (3 + 1) - 2",
    options: ["14", "10", "12"],
    answer: "14",
    explanation: "Calculer d'abord la parenthèse pour obtenir 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "30 ÷ (6 - 3) + 4",
    options: ["12", "14", "16"],
    answer: "14",
    explanation: "30 divisé par 3 plus 4 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "16 - 4 ÷ 2 + 5",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "En suivant l'ordre des opérations, on obtient 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 8 + 5 ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "La somme de 8 et 5 est 13.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Que vaut 7 x 3 ?",
    options: ["21", "24", "19"],
    answer: "21",
    explanation: "La multiplication de 7 par 3 est 21.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 + 18 - 10 ?",
    options: ["33", "34", "35"],
    answer: "33",
    explanation: "La somme de 25 et 18, moins 10, donne 33.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez : 6 x 4 - 8 ÷ 2 ?",
    options: ["22", "20", "18"],
    answer: "20",
    explanation:
        "La multiplication et la division sont effectuées avant la soustraction, ce qui donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 12 + (15 - 3) x 2 ?",
    options: ["30", "36", "24"],
    answer: "30",
    explanation:
        "On effectue d'abord la parenthèse, puis la multiplication et enfin l'addition pour obtenir 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - 2 x (5 + 5) ?",
    options: ["30", "40", "20"],
    answer: "30",
    explanation:
        "On effectue d'abord l'opération dans la parenthèse, puis la multiplication et enfin la soustraction, ce qui donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez : (10 - 2) x 4 + 6 ?",
    options: ["38", "40", "42"],
    answer: "38",
    explanation:
        "On effectue d'abord la parenthèse, puis la multiplication et enfin l'addition pour obtenir 38.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 10 - 2 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation:
        "La division est effectuée en premier, suivie de l'addition et de la soustraction, ce qui donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez : 9 + 6 - 5 ?",
    options: ["10", "8", "11"],
    answer: "10",
    explanation: "La somme de 9 et 6, moins 5, donne 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "10 × 2 - 5 = ?",
    options: ["15", "20", "10"],
    answer: "15",
    explanation: "Multipliez 10 par 2, puis soustrayez 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) × 2 + 1 = ?",
    options: ["15", "17", "18"],
    answer: "17",
    explanation: "Soustrayez 2 de 10, multipliez par 2 et ajoutez 1.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 + 3) × (6 - 4) + 2 = ?",
    options: ["10", "14", "12"],
    answer: "10",
    explanation:
        "Additionnez 5 et 3, soustrayez 4 de 6, multipliez les résultats et ajoutez 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 - 3) × (2 + 1) - 3 = ?",
    options: ["21", "18", "15"],
    answer: "18",
    explanation:
        "Soustrayez 3 de 9, additionnez 2 et 1, multipliez et soustrayez 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 + 4) × (3 - 1) ÷ 2 = ?",
    options: ["12", "16", "8"],
    answer: "16",
    explanation:
        "Additionnez 4 et 4, soustrayez 1 de 3, multipliez et divisez par 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "6 × 3 + 2 × 4 = ?",
    options: ["26", "30", "28"],
    answer: "30",
    explanation:
        "Multipliez 6 par 3 et 2 par 4, puis additionnez les résultats.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 - (2 × 3) + 1 = ?",
    options: ["15", "16", "17"],
    answer: "15",
    explanation:
        "Multipliez 2 par 3, soustrayez le résultat de 20 et ajoutez 1.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 2) + (10 ÷ 2) = ?",
    options: ["15", "12", "20"],
    answer: "15",
    explanation:
        "Multipliez 5 par 2, divisez 10 par 2, puis additionnez les résultats.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (4 - 2) + 3 ?",
    options: ["17", "15", "19"],
    answer: "17",
    explanation: "7 multiplié par 2, plus 3, donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 5 + 1 ?",
    options: ["10", "9", "11"],
    answer: "10",
    explanation: "14 moins 5, plus 1, donne 10.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 2 + 4 ÷ 2 ?",
    options: ["16", "18", "14"],
    answer: "16",
    explanation:
        "On multiplie 8 par 2, puis on ajoute le résultat de 4 divisé par 2, soit 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 ÷ 3) × 4 ?",
    options: ["20", "18", "15"],
    answer: "20",
    explanation:
        "On divise 15 par 3, puis on multiplie par 4, ce qui donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 2 + 10 ÷ 2 ?",
    options: ["16", "18", "17"],
    answer: "16",
    explanation: "On multiplie 7 par 2, puis on ajoute 5, soit 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 3) × (4 + 1) ?",
    options: ["25", "30", "20"],
    answer: "30",
    explanation: "On soustrait 3 de 9, puis on multiplie par 5, soit 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le produit de 7 × 2 ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation: "7 multiplié par 2 égale 14.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + 7 - 4 ?",
    options: ["9", "10", "11"],
    answer: "9",
    explanation: "6 + 7 - 4 égale 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 × 5) + (8 ÷ 2) ?",
    options: ["20", "22", "23"],
    answer: "23",
    explanation: "15 plus 4 égale 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (16 - 4) × 2 ?",
    options: ["20", "24", "28"],
    answer: "24",
    explanation: "12 multiplié par 2 égale 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 ÷ 2 ?",
    options: ["5", "6", "7"],
    answer: "7",
    explanation: "La division de 14 par 2 donne 7.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 7 - 5 ?",
    options: ["16", "17", "18"],
    answer: "16",
    explanation: "Le résultat de 3 fois 7 moins 5 est 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 4 × 2 ?",
    options: ["15", "18", "14"],
    answer: "15",
    explanation: "La somme de 7 et 4 fois 2 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (4 + 6) × 2 ?",
    options: ["2", "4", "6"],
    answer: "4",
    explanation: "Le résultat de 20 moins (4 plus 6) multiplié par 2 est 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (8 ÷ 4) + 5 ?",
    options: ["9", "10", "11"],
    answer: "9",
    explanation: "Le résultat de 2 fois (8 divisé par 4) plus 5 est 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 - 3 × 2 + 4 ?",
    options: ["9", "10", "8"],
    answer: "9",
    explanation: "Le calcul donne 11 moins 3 fois 2 plus 4 égale 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 + 2 × (5 - 3) ?",
    options: ["5", "7", "6"],
    answer: "7",
    explanation: "Le résultat de 3 plus 2 fois (5 moins 3) est 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + 3 × 2 - 4 ?",
    options: ["10", "11", "12"],
    answer: "10",
    explanation:
        "On suit l'ordre des opérations : multiplication avant addition et soustraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 5 × 2 ?",
    options: ["16", "14", "12"],
    answer: "16",
    explanation:
        "On effectue d'abord la division, puis les multiplications et enfin l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (3 + 2) × 2 ?",
    options: ["10", "5", "15"],
    answer: "10",
    explanation:
        "On commence par l'addition dans les parenthèses, puis la multiplication et enfin la soustraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + 3 ?",
    options: ["8", "9", "7"],
    answer: "9",
    explanation: "6 plus 3 égale 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 4 - 2 ?",
    options: ["9", "10", "8"],
    answer: "9",
    explanation: "7 plus 4 moins 2 égale 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 3 - 2 ?",
    options: ["15", "13", "10"],
    answer: "13",
    explanation: "5 multiplié par 3 moins 2 égale 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (2 + 3) × (5 - 1) ?",
    options: ["20", "15", "25"],
    answer: "20",
    explanation:
        "La somme de 2 et 3 multipliée par la différence de 5 et 1 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (3 - 1) + 2 ?",
    options: ["14", "12", "16"],
    answer: "14",
    explanation: "6 multiplié par la différence de 3 et 1, plus 2, donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (4 + 6) ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "En soustrayant la somme de 4 et 6 de 20, on obtient 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 7 × 2 ?",
    options: ["18", "19", "20"],
    answer: "18",
    explanation: "Diviser 25 par 5 et ajouter 14 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (6 ÷ 2 + 3) ?",
    options: ["24", "20", "21"],
    answer: "24",
    explanation: "Soustraire la somme de 6 divisé par 2 et 3 de 30 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 + 6 - 5 ?",
    options: ["15", "16", "13"],
    answer: "15",
    explanation: "La somme de 14 et 6 moins 5 donne 15.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 5 × 2 ?",
    options: ["20", "25", "15"],
    answer: "20",
    explanation: "Ajouter 10 à 5 multiplié par 2 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (3 + 5) - 8 ?",
    options: ["24", "28", "16"],
    answer: "24",
    explanation:
        "Multiplier 4 par la somme de 3 et 5, puis soustraire 8 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 6 - 10 ?",
    options: ["14", "14", "24"],
    answer: "14",
    explanation: "4 multiplié par 6 moins 10 donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - (4 × 2) + 3 ?",
    options: ["1", "2", "3"],
    answer: "3",
    explanation: "12 moins (4 multiplié par 2) plus 3 donne 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 3 + 6 ?",
    options: ["16", "17", "18"],
    answer: "17",
    explanation: "14 moins 3 plus 6 donne 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 10 ?",
    options: ["12", "13", "15"],
    answer: "13",
    explanation: "25 divisé par 5 plus 10 donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 x 3 + 6 ÷ 2 ?",
    options: ["10", "12", "15"],
    answer: "12",
    explanation: "Le produit de 3 et 3, plus la division de 6 par 2, donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + (6 x 2) - 3 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation:
        "La multiplication de 6 par 2, ajoutée à 5 et diminuée de 3, donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 x 5) - (3 x 2) ?",
    options: ["23", "25", "27"],
    answer: "23",
    explanation:
        "Le produit de 5 par 5, moins le produit de 3 par 2, donne 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 ÷ 2 + 3 x 4 ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation:
        "La division de 10 par 2, ajoutée au produit de 3 et 4, donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 ÷ 3) + (4 x 3) ?",
    options: ["14", "16", "18"],
    answer: "18",
    explanation:
        "La division de 12 par 3, ajoutée au produit de 4 et 3, donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (5 - 2) + 3 ?",
    options: ["10", "13", "16"],
    answer: "13",
    explanation: "La parenthèse est résolue avant la division et l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 6 ÷ 3 - 2 ?",
    options: ["5", "7", "9"],
    answer: "7",
    explanation:
        "La division est effectuée avant l'addition et la soustraction, donnant 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - 3 × 20 ?",
    options: ["40", "60", "20"],
    answer: "40",
    explanation:
        "La multiplication de 3 par 20 est 60, et 100 moins 60 donne 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 - 4) × (2 + 1) ?",
    options: ["24", "30", "12"],
    answer: "24",
    explanation:
        "La soustraction donne 8 et la somme donne 3, soit 8 × 3 = 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 60 ÷ (3 × 2) + 5 ?",
    options: ["10", "15", "20"],
    answer: "10",
    explanation:
        "La multiplication donne 6, 60 divisé par 6 donne 10, plus 5 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - (5 + 2) ?",
    options: ["12", "11", "10"],
    answer: "11",
    explanation: "La multiplication donne 21, moins 7 donne 14, soit 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 ÷ 5 + 8 ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "La division donne 9, et 9 plus 4 donne 13.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (5 - 2) ?",
    options: ["15", "18", "21"],
    answer: "21",
    explanation: "La différence est 3, puis 7 multiplié par 3 donne 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ (6 - 4) ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "La différence est 2, puis 24 divisé par 2 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 + 4 × 2 - 5 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation:
        "On effectue d'abord la multiplication : 4 × 2 = 8, donc 3 + 8 - 5 = 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (6 + 4) ÷ 2 ?",
    options: ["25", "30", "20"],
    answer: "25",
    explanation: "D'abord, 6 + 4 = 10, puis 5 × 10 = 50, et enfin 50 ÷ 2 = 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (6 + 4) ?",
    options: ["14", "15", "16"],
    answer: "15",
    explanation: "Soustraire 10 de 25 donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 2) × (5 + 1) ?",
    options: ["36", "40", "42"],
    answer: "36",
    explanation: "D'abord calculer 6 × 6 donne 36.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (2 + 3) × 5 ?",
    options: ["10", "15", "20"],
    answer: "10",
    explanation: "D'abord 50 ÷ 5 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (25 ÷ 5) ?",
    options: ["80", "85", "90"],
    answer: "90",
    explanation: "Diviser 25 par 5 donne 5, puis soustraire de 100 donne 90.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 6 + 2 × 3 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "Diviser 30 par 6 donne 5, puis ajouter 6 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ 4 + 5 ?",
    options: ["8", "9", "10"],
    answer: "8",
    explanation: "La division de 20 par 4 donne 5, et 5 plus 5 égale 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (7 + 3) ?",
    options: ["8", "10", "12"],
    answer: "8",
    explanation:
        "En additionnant 7 et 3, puis en soustrayant de 18, on obtient 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ 2 + 6 ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation: "La division de 12 par 2 donne 6, et 6 plus 6 égale 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 3 ?",
    options: ["4", "5", "6"],
    answer: "6",
    explanation: "La division de 25 par 5 donne 5, et 5 plus 3 égale 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 × 2 ÷ 7 = ?",
    options: ["2", "1", "3"],
    answer: "2",
    explanation: "7 multiplié par 2 donne 14, puis 14 divisé par 7 est 2.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 ÷ 3 + 4 = ?",
    options: ["9", "8", "7"],
    answer: "9",
    explanation: "15 divisé par 3 donne 5, puis on ajoute 4 pour obtenir 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 + 4) × 2 = ?",
    options: ["20", "18", "22"],
    answer: "20",
    explanation: "La somme de 6 et 4 est 10, multipliée par 2 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 - 2) × 3 = ?",
    options: ["18", "20", "16"],
    answer: "18",
    explanation:
        "On soustrait 2 de 8, puis on multiplie le résultat par 3, soit 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 + (3 × 2) = ?",
    options: ["15", "12", "18"],
    answer: "15",
    explanation:
        "On effectue d'abord la multiplication, puis on additionne 9 pour obtenir 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 3) ÷ (7 - 5) = ?",
    options: ["5", "4", "3"],
    answer: "3",
    explanation:
        "On effectue d'abord les soustractions, puis on divise 7 par 2 pour obtenir 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(14 ÷ 2) + (3 × 4) = ?",
    options: ["20", "18", "22"],
    answer: "20",
    explanation:
        "On divise 14 par 2 pour obtenir 7, puis on ajoute 12 pour obtenir 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 - (2 × 3)) + 7 = ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation:
        "On effectue d'abord la multiplication, puis on soustrait et ajoute pour obtenir 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 ÷ 2) + (5 × 2) = ?",
    options: ["16", "19", "20"],
    answer: "16",
    explanation:
        "On divise 18 par 2 pour obtenir 9, puis on ajoute 10 pour obtenir 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - 5) ÷ (5 - 2) = ?",
    options: ["5", "4", "3"],
    answer: "5",
    explanation:
        "On soustrait d'abord pour obtenir 15, puis on divise par 3 pour obtenir 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 + 4) × (3 - 1) = ?",
    options: ["20", "22", "18"],
    answer: "20",
    explanation:
        "On additionne d'abord puis on multiplie par 2, ce qui donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 15 - (3 × 2) ?",
    options: ["9", "11", "7"],
    answer: "9",
    explanation: "15 moins 6 (3 fois 2) donne 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 8 × (2 + 1) ?",
    options: ["24", "20", "16"],
    answer: "24",
    explanation: "8 multiplié par 3 (2 plus 1) est 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (2 × 15) ?",
    options: ["20", "10", "30"],
    answer: "20",
    explanation: "50 moins 30 (2 fois 15) donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 6 + 2 × 5 ?",
    options: ["16", "20", "18"],
    answer: "16",
    explanation: "6 plus 10 (2 fois 5) donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × 4 - 10 ?",
    options: ["30", "28", "26"],
    answer: "30",
    explanation: "8 multiplié par 4 moins 10 donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (6 - 1) ?",
    options: ["25", "30", "20"],
    answer: "25",
    explanation: "5 multiplié par la différence de 6 et 1 égale 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 + 4 × 2 ?",
    options: ["18", "19", "20"],
    answer: "19",
    explanation: "11 plus 4 multiplié par 2 égale 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (2 + 3) × (4 - 2) ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation:
        "La somme de 2 et 3 multipliée par la différence de 4 et 2 égale 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 5 + 3 ?",
    options: ["22", "23", "20"],
    answer: "23",
    explanation: "25 moins 5 plus 3 égale 23.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 6 + 2 ?",
    options: ["14", "16", "18"],
    answer: "16",
    explanation: "Le calcul 20 moins 6 plus 2 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 5 ?",
    options: ["7", "8", "9"],
    answer: "9",
    explanation: "La division de 18 par 3 plus 5 donne 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 4) × (3 + 1) ?",
    options: ["24", "28", "36"],
    answer: "24",
    explanation: "Le calcul (10 moins 4) multiplié par (3 plus 1) donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 ÷ (5 + 4) ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "La division de 45 par (5 plus 4) donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 2 × (3 + 1) ?",
    options: ["6", "8", "10"],
    answer: "6",
    explanation: "Le calcul 14 moins (2 multiplié par (3 plus 1)) donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "5 + 7 - 3 = ?",
    options: ["9", "10", "11"],
    answer: "9",
    explanation:
        "La somme de 5 et 7 est 12, et en soustrayant 3, on obtient 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "12 - 4 + 6 = ?",
    options: ["10", "12", "14"],
    answer: "14",
    explanation:
        "En soustrayant 4 de 12, on obtient 8, puis en ajoutant 6, le résultat est 14.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 × 3 ÷ 2 = ?",
    options: ["12", "10", "14"],
    answer: "12",
    explanation:
        "Huit multiplié par trois donne 24, et 24 divisé par 2 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - 6 × 2 = ?",
    options: ["3", "9", "6"],
    answer: "3",
    explanation:
        "On effectue d'abord la multiplication : 6 × 2 = 12, puis 15 - 12 = 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 × (3 + 5) = ?",
    options: ["56", "48", "40"],
    answer: "56",
    explanation:
        "Il faut d'abord additionner 3 et 5 pour obtenir 8, puis multiplier par 7 : 7 × 8 = 56.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 + 2) × 4 = ?",
    options: ["48", "44", "52"],
    answer: "48",
    explanation:
        "On additionne d'abord 10 et 2 pour obtenir 12, puis on multiplie par 4 : 12 × 4 = 48.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 - 3) × (6 + 2) = ?",
    options: ["48", "36", "54"],
    answer: "48",
    explanation:
        "On soustrait d'abord 3 de 9 pour obtenir 6, puis on additionne 6 et 2 pour obtenir 8 : 6 × 8 = 48.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 + 6) ÷ (2 + 3) × 5 = ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation:
        "On additionne d'abord 4 et 6 pour obtenir 10, et 2 et 3 pour obtenir 5 : 10 ÷ 5 × 5 = 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(15 ÷ 3) + (4 × 2) = ?",
    options: ["14", "10", "12"],
    answer: "14",
    explanation:
        "On divise 15 par 3 pour obtenir 5 et on multiplie 4 par 2 pour obtenir 8 : 5 + 8 = 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "18 - (4 × 3) + 2 = ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation:
        "On multiplie d'abord 4 par 3 pour obtenir 12, puis on soustrait 12 de 18 et ajoute 2 : 18 - 12 + 2 = 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 + 3) × (7 - 5) = ?",
    options: ["16", "8", "12"],
    answer: "16",
    explanation:
        "On additionne 5 et 3 pour obtenir 8, et on soustrait 5 de 7 pour obtenir 2 : 8 × 2 = 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) × 3 ÷ 2 = ?",
    options: ["12", "15", "18"],
    answer: "12",
    explanation:
        "On soustrait 2 de 10 pour obtenir 8, puis on multiplie par 3 et divise par 2 : 8 × 3 ÷ 2 = 12.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 5 + 2 ?",
    options: ["14", "15", "16"],
    answer: "15",
    explanation: "En soustrayant 5 de 18 et en ajoutant 2, le résultat est 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 ÷ 3 + 6 ?",
    options: ["7", "8", "9"],
    answer: "7",
    explanation: "La division de 15 par 3 donne 5, et 5 + 6 = 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (3 × 5) ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation: "La multiplication de 3 par 5 donne 15, et 20 - 15 = 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (5 + 3) - 4 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "D'abord, 5 + 3 = 8, puis 2 × 8 - 4 = 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 7) × (4 - 2) ?",
    options: ["20", "30", "40"],
    answer: "20",
    explanation: "D'abord, 3 + 7 = 10, puis 10 × 2 = 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "6 × 3 = ?",
    options: ["18", "20", "21"],
    answer: "18",
    explanation: "Le produit de 6 et 3 est 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 ÷ 4 = ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "La division de 20 par 4 donne 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 + 6 - 4 = ?",
    options: ["16", "17", "18"],
    answer: "17",
    explanation: "15 plus 6 moins 4 égale 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 × 2 + 4 = ?",
    options: ["20", "24", "22"],
    answer: "20",
    explanation: "Le calcul donne 8 multiplié par 2, puis ajouté à 4, soit 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(25 ÷ 5) + (3 × 4) = ?",
    options: ["15", "16", "17"],
    answer: "16",
    explanation: "Le calcul se décompose en 5 plus 12, ce qui fait 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(3 × 4) + (6 ÷ 2) = ?",
    options: ["14", "16", "12"],
    answer: "14",
    explanation: "Le produit donne 12, plus 3 de la division, soit 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 - 6) ÷ 2 + 5 = ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation:
        "La différence donne 12, divisée par 2 et ajoutée à 5, soit 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 + 3) × 2 = ?",
    options: ["14", "16", "12"],
    answer: "16",
    explanation: "La somme fait 8, multipliée par 2 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(2 + 2) × 5 = ?",
    options: ["20", "25", "22"],
    answer: "20",
    explanation: "La somme donne 4, multipliée par 5 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 + (2 × 3) = ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "Le produit fait 6, donc 7 plus 6 donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 3) + (2 × 4) ?",
    options: ["22", "23", "24"],
    answer: "22",
    explanation:
        "On effectue d'abord les multiplications, puis on additionne les résultats pour obtenir 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (4 × 10) + 5 ?",
    options: ["45", "50", "55"],
    answer: "45",
    explanation:
        "On calcule d'abord 4 fois 10, puis on soustrait ce résultat de 50 et ajoute 5 pour obtenir 45.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (16 ÷ 4) × (2 + 3) ?",
    options: ["20", "24", "28"],
    answer: "20",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses, puis on multiplie les résultats pour obtenir 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 15 + 7 ?",
    options: ["22", "20", "25"],
    answer: "22",
    explanation: "L'addition de 15 et 7 donne 22.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 8 × 4 ?",
    options: ["32", "28", "36"],
    answer: "32",
    explanation: "La multiplication de 8 par 4 donne 32.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 15 - 3 ?",
    options: ["24", "22", "20"],
    answer: "24",
    explanation: "L'addition de 12 et 15, moins 3, donne 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 18 ÷ 2 + 5 ?",
    options: ["14", "13", "12"],
    answer: "14",
    explanation: "La division de 18 par 2, plus 5, donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (10 + 5) × 2 ?",
    options: ["30", "25", "20"],
    answer: "30",
    explanation: "L'addition de 10 et 5, multipliée par 2, donne 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (6 + 2) × (5 - 3) ?",
    options: ["16", "8", "12"],
    answer: "16",
    explanation:
        "L'addition de 6 et 2, multipliée par la soustraction de 5 et 3, donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 45 ÷ 5 + 9 ?",
    options: ["18", "12", "15"],
    answer: "12",
    explanation: "La division de 45 par 5, plus 9, donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (25 ÷ 5) × 2 ?",
    options: ["90", "80", "70"],
    answer: "90",
    explanation:
        "La division de 25 par 5, multipliée par 2, soustraite de 100, donne 90.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 30 ÷ 3 + 15 ?",
    options: ["20", "25", "18"],
    answer: "25",
    explanation: "La division de 30 par 3, plus 15, donne 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 7 ?",
    options: ["10", "12", "8"],
    answer: "8",
    explanation: "On divise 25 par 5, puis on ajoute 7 pour obtenir 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 5 - 3 ?",
    options: ["14", "15", "16"],
    answer: "14",
    explanation: "12 + 5 - 3 donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 - 4) × 2 ?",
    options: ["30", "32", "36"],
    answer: "32",
    explanation: "(20 - 4) multiplié par 2 égale 32.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - (2 × 3) + 8 ?",
    options: ["10", "12", "14"],
    answer: "14",
    explanation: "10 moins (2 multiplié par 3) plus 8 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 2 + 15 ?",
    options: ["30", "35", "40"],
    answer: "35",
    explanation: "50 divisé par 2 plus 15 donne 35.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ 4 + 3 ?",
    options: ["4", "5", "6"],
    answer: "6",
    explanation: "12 divisé par 4 plus 3 donne 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 ÷ 2 + 3 ?",
    options: ["8", "9", "10"],
    answer: "10",
    explanation: "14 divisé par 2 plus 3 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 x 5 - 10 ÷ 2 ?",
    options: ["20", "21", "22"],
    answer: "21",
    explanation: "5 multiplié par 5 moins 10 divisé par 2 donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (4 x 3) + 2 ?",
    options: ["14", "15", "16"],
    answer: "15",
    explanation: "20 moins (4 multiplié par 3) plus 2 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 3 x 2 ?",
    options: ["9", "10", "11"],
    answer: "11",
    explanation: "25 divisé par 5 plus 3 multiplié par 2 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 2 + 5 ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "(8 + 4) divisé par 2 plus 5 donne 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 x 3 + 9 ÷ 3 ?",
    options: ["10", "11", "12"],
    answer: "12",
    explanation: "3 multiplié par 3 plus 9 divisé par 3 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + (6 × 2) - 4 ?",
    options: ["17", "19", "15"],
    answer: "17",
    explanation: "La somme de 9 et 12 moins 4 donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ (3 - 1) ?",
    options: ["6", "8", "5"],
    answer: "6",
    explanation: "12 divisé par la différence de 3 et 1 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (10 × 3) + 5 ?",
    options: ["25", "20", "15"],
    answer: "25",
    explanation: "50 moins 30 plus 5 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 + 9 ÷ 3 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "11 plus 3 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (2 + 1) - 4 ?",
    options: ["11", "9", "10"],
    answer: "11",
    explanation: "5 multiplié par 3 moins 4 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 - (18 ÷ 2) ?",
    options: ["36", "33", "30"],
    answer: "36",
    explanation: "18 divisé par 2 donne 9, et 45 moins 9 égale 36.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 14 ÷ 2 ?",
    options: ["10", "12", "14"],
    answer: "14",
    explanation: "14 divisé par 2 donne 7, et 7 plus 7 égale 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 3) × 4 + 2 ?",
    options: ["22", "23", "24"],
    answer: "22",
    explanation:
        "8 moins 3 égale 5, multiplié par 4 donne 20, plus 2 égale 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ (2 + 1) + 4 ?",
    options: ["8", "10", "12"],
    answer: "8",
    explanation: "2 plus 1 donne 3, 12 divisé par 3 est 4, plus 4 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (6 × 2) + 3 ?",
    options: ["9", "11", "15"],
    answer: "9",
    explanation: "6 multiplié par 2 donne 12, 18 moins 12 plus 3 égale 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 × 3 - (4 + 2) ?",
    options: ["26", "28", "30"],
    answer: "28",
    explanation: "10 multiplié par 3 est 30, moins 6 donne 24.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 8 ?",
    options: ["20", "23", "22"],
    answer: "23",
    explanation: "La somme de 15 et 8 est 23.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - 27 ?",
    options: ["23", "22", "24"],
    answer: "23",
    explanation: "La soustraction de 27 à 50 donne 23.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 - (3 × 10) ?",
    options: ["15", "12", "18"],
    answer: "15",
    explanation:
        "La soustraction de 30 à 45 donne 15 après avoir effectué la multiplication.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 32 ÷ 4 + 6 ?",
    options: ["14", "10", "12"],
    answer: "14",
    explanation: "La division de 32 par 4, ajoutée à 6, donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ 3 + 5 ?",
    options: ["8", "7", "9"],
    answer: "9",
    explanation: "La division de 12 par 3, ajoutée à 5, donne 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 15 + 10 ?",
    options: ["20", "15", "25"],
    answer: "20",
    explanation: "La soustraction de 15 à 25, ajoutée à 10, donne 20.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (18 ÷ 2) + (4 × 3) ?",
    options: ["30", "24", "20"],
    answer: "30",
    explanation: "Le calcul donne 9 + 12 = 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ 4 + 25 ?",
    options: ["50", "75", "70"],
    answer: "50",
    explanation: "La division de 100 par 4, ajoutée à 25, donne 50.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 3) × 5 ?",
    options: ["20", "25", "15"],
    answer: "25",
    explanation: "On effectue d'abord la soustraction, puis la multiplication.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 3 × 3 - 5 ?",
    options: ["12", "15", "10"],
    answer: "12",
    explanation:
        "On effectue les multiplications avant les additions et soustractions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 2 × (5 - 3) ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation:
        "On effectue d'abord l'opération dans les parenthèses, puis la multiplication.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 2 - (4 + 1) ?",
    options: ["9", "10", "11"],
    answer: "9",
    explanation:
        "On fait d'abord l'addition puis on soustrait le résultat de la multiplication.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (3 ÷ 1) ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation: "On effectue d'abord la division, puis la soustraction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + 2 × (5 - 3) ?",
    options: ["8", "10", "12"],
    answer: "8",
    explanation: "6 plus 2 multiplié par la différence de 5 et 3 égale 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 3 + 6 ÷ 2 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "3 multiplié par 3 plus 6 divisé par 2 égale 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 - (2 + 2) × 2 ?",
    options: ["0", "2", "4"],
    answer: "0",
    explanation: "8 moins le produit de la somme de 2 et 2 égale 0.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - 8 + 3 = ?",
    options: ["10", "9", "8"],
    answer: "10",
    explanation: "Soustraire 8 de 15 donne 7, puis ajouter 3 donne 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 + 6 ÷ 3 = ?",
    options: ["11", "12", "15"],
    answer: "11",
    explanation: "La division de 6 par 3 donne 2, ajoutant 9 donne 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - 5) × 2 = ?",
    options: ["30", "25", "20"],
    answer: "30",
    explanation: "Soustraire 5 de 20 donne 15, multiplié par 2 donne 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 3) + (12 ÷ 4) = ?",
    options: ["20", "18", "16"],
    answer: "18",
    explanation:
        "La multiplication donne 15 et la division donne 3, leur somme est 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) × (4 + 1) = ?",
    options: ["40", "35", "30"],
    answer: "40",
    explanation:
        "Soustraire 2 de 10 donne 8, additionner 4 et 1 donne 5, puis multiplier 8 par 5 donne 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(14 - 6) ÷ 2 + 5 = ?",
    options: ["9", "8", "10"],
    answer: "9",
    explanation:
        "Soustraire 6 de 14 donne 8, divisé par 2 donne 4, ajoutant 5 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(3 + 5) × (2 + 2) - 6 = ?",
    options: ["22", "26", "20"],
    answer: "22",
    explanation:
        "L'addition donne 8 et 4, leur produit est 32, soustraire 6 donne 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 + 3) × 2 - 5 = ?",
    options: ["17", "21", "19"],
    answer: "17",
    explanation:
        "L'addition donne 12, multiplié par 2 donne 24, soustraire 5 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(7 × 3) - (4 ÷ 2) = ?",
    options: ["20", "21", "19"],
    answer: "20",
    explanation:
        "La multiplication donne 21, la division donne 2, soustraire 2 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(16 ÷ 4) + (5 × 2) = ?",
    options: ["16", "12", "10"],
    answer: "12",
    explanation:
        "La division donne 4 et la multiplication donne 10, leur somme est 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 15 - 7 ?",
    options: ["20", "18", "25"],
    answer: "20",
    explanation: "12 plus 15 moins 7 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (5 + 2) ?",
    options: ["21", "18", "15"],
    answer: "21",
    explanation: "3 multiplié par la somme de 5 et 2 donne 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (4 - 2) + 6 ?",
    options: ["14", "16", "12"],
    answer: "14",
    explanation: "8 multiplié par la différence de 4 et 2 plus 6 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 4 + 12 ÷ 4 ?",
    options: ["15", "18", "12"],
    answer: "15",
    explanation: "3 fois 4 plus 12 divisé par 4 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 - (15 ÷ 3) ?",
    options: ["40", "30", "35"],
    answer: "40",
    explanation: "45 moins 15 divisé par 3 donne 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ 6 + 9 ?",
    options: ["12", "10", "15"],
    answer: "12",
    explanation: "36 divisé par 6 plus 9 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 + 9 - 3 ?",
    options: ["20", "18", "21"],
    answer: "20",
    explanation: "La somme de 14 et 9 moins 3 est 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 4 - 5 ?",
    options: ["24", "19", "23"],
    answer: "19",
    explanation: "Le produit de 6 et 4 moins 5 donne 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (3 + 4) - 10 ?",
    options: ["25", "20", "15"],
    answer: "20",
    explanation: "Le produit de 5 et la somme de 3 et 4 moins 10 est 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 2 × (6 - 4) ?",
    options: ["9", "11", "10"],
    answer: "11",
    explanation: "La somme de 7 et le produit de 2 et (6 - 4) est 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 2) ÷ (5 - 3) ?",
    options: ["5", "4", "10"],
    answer: "5",
    explanation:
        "La somme de 8 et 2 divisée par la différence de 5 et 3 est 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ 5 + 20 ?",
    options: ["40", "60", "30"],
    answer: "40",
    explanation: "La division de 100 par 5 plus 20 donne 40.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 2 - (3 + 6) ?",
    options: ["10", "9", "12"],
    answer: "9",
    explanation: "9 multiplié par 2 moins la somme de 3 et 6 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (6 - 2) ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation: "14 moins la différence de 6 et 2 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + 5 × 2 ?",
    options: ["15", "10", "20"],
    answer: "15",
    explanation:
        "La multiplication est effectuée avant l'addition, donc 5 plus 10 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 × 3 = ?",
    options: ["20", "21", "22"],
    answer: "21",
    explanation: "La multiplication de 7 par 3 donne 21.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 ÷ 3 = ?",
    options: ["2", "3", "4"],
    answer: "3",
    explanation: "Diviser 9 par 3 donne 3.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 + 15 - 10 = ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "La somme de 8 et 15, moins 10, est 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 + 8) ÷ 2 = ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation: "La somme de 6 et 8, divisée par 2, est 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 4) - 6 = ?",
    options: ["14", "20", "18"],
    answer: "14",
    explanation: "Multiplier 5 par 4 et soustraire 6 donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 ÷ 4) + (5 × 3) = ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "Diviser 20 par 4 et ajouter 15 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(7 + 3) × (5 - 2) = ?",
    options: ["25", "30", "20"],
    answer: "30",
    explanation: "Multiplier 10 par 3 donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 - 6) ÷ 2 + 5 = ?",
    options: ["7", "8", "9"],
    answer: "8",
    explanation: "La soustraction et la division donnent 6, plus 5, fait 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 + 2 × 5 = ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "Multiplier 2 par 5 donne 10, plus 9 fait 19.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "18 ÷ (3 × 2) + 1 = ?",
    options: ["4", "5", "6"],
    answer: "4",
    explanation:
        "Multiplier 3 par 2 donne 6, puis diviser 18 par 6 donne 3, et ajouter 1 donne 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 + 6) × (2 - 1) = ?",
    options: ["10", "20", "15"],
    answer: "10",
    explanation: "La somme de 4 et 6 est 10, et multiplier par 1 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 ÷ 2) + (6 - 4) × 3 = ?",
    options: ["9", "10", "8"],
    answer: "9",
    explanation:
        "Diviser 8 par 2 donne 4, la soustraction de 6 et 4 donne 2, multiplier par 3 donne 6, et 4 plus 6 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(7 + 3) × 2 - 5 = ?",
    options: ["15", "20", "10"],
    answer: "15",
    explanation:
        "La somme de 7 et 3 est 10, multiplier par 2 donne 20, soustraire 5 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 2) + (3 × 4) - 7 = ?",
    options: ["17", "18", "15"],
    answer: "17",
    explanation:
        "Multiplier 5 par 2 donne 10, multiplier 3 par 4 donne 12, et 10 plus 12 moins 7 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ (2 + 2) + 3 ?",
    options: ["6", "5", "4"],
    answer: "6",
    explanation:
        "D'abord, 2 + 2 donne 4, puis 12 ÷ 4 donne 3, enfin 3 + 3 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (3 × 2) + 4 ?",
    options: ["16", "14", "12"],
    answer: "16",
    explanation: "3 × 2 donne 6, puis 18 - 6 donne 12, enfin 12 + 4 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ (6 ÷ 2) ?",
    options: ["12", "18", "15"],
    answer: "18",
    explanation: "6 ÷ 2 donne 3, puis 36 ÷ 3 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 6 ?",
    options: ["20", "21", "22"],
    answer: "21",
    explanation: "15 + 6 égale 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 7 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "18 - 7 égale 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 4 × 3 ?",
    options: ["10", "11", "12"],
    answer: "12",
    explanation: "4 multiplié par 3 est 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 9 + 6 - 3 ?",
    options: ["10", "12", "15"],
    answer: "12",
    explanation: "9 plus 6 moins 3 est égal à 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 3 × (2 + 4) ?",
    options: ["18", "21", "12"],
    answer: "18",
    explanation: "3 multiplié par la somme de 2 et 4 donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 50 ÷ (2 + 3) ?",
    options: ["10", "15", "12"],
    answer: "10",
    explanation: "50 divisé par la somme de 2 et 3 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (2 + 3) - 4 ?",
    options: ["26", "30", "32"],
    answer: "26",
    explanation: "Le produit de 6 et la somme de 2 et 3 moins 4 est 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (8 + 6) × 2 - 10 ?",
    options: ["22", "28", "26"],
    answer: "22",
    explanation: "La somme de 8 et 6 multipliée par 2, moins 10 donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 7 × 4 - 10 ÷ 2 ?",
    options: ["26", "28", "24"],
    answer: "26",
    explanation: "Le produit de 7 et 4 moins 10 divisé par 2 est 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 3) × 5 + 2 ?",
    options: ["30", "32", "28"],
    answer: "32",
    explanation: "La différence de 9 et 3 multipliée par 5 plus 2 donne 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 25 - (5 × 3) + 2 ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation: "25 moins le produit de 5 et 3 plus 2 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × (3 - 1) ?",
    options: ["18", "27", "36"],
    answer: "18",
    explanation: "9 multiplié par la différence de 3 et 1 donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ 5 + 3 ?",
    options: ["5", "7", "6"],
    answer: "7",
    explanation: "20 divisé par 5 plus 3 égale 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 5 × 2 ?",
    options: ["16", "19", "18"],
    answer: "19",
    explanation: "18 divisé par 2 plus 5 multiplié par 2 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (6 × 7) + 2 ?",
    options: ["2", "8", "16"],
    answer: "8",
    explanation: "50 moins 42, plus 2 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + (6 ÷ 2) - 3 ?",
    options: ["7", "8", "9"],
    answer: "9",
    explanation: "6 divisé par 2 donne 3, donc 8 plus 3 moins 3 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ 4 + 7 - 2 ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation: "3 plus 7 moins 2 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 × 3) + (10 - 2) ?",
    options: ["26", "28", "30"],
    answer: "28",
    explanation: "18 plus 10 moins 2 donne 28.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (10 × 4) + 2 ?",
    options: ["12", "22", "32"],
    answer: "12",
    explanation: "50 moins 40 plus 2 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 + 11 - 6 ?",
    options: ["16", "15", "17"],
    answer: "16",
    explanation: "11 plus 11 moins 6 donne 16.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 × 2) - (3 × 1) ?",
    options: ["11", "12", "10"],
    answer: "11",
    explanation: "14 moins 3 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 60 ÷ (3 + 3) ?",
    options: ["6", "8", "10"],
    answer: "10",
    explanation: "60 divisé par la somme de 3 et 3 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 5 - 5 ?",
    options: ["20", "15", "25"],
    answer: "20",
    explanation: "Le produit de 5 et 5, moins 5, donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 3) + (10 ÷ 2) ?",
    options: ["25", "20", "15"],
    answer: "20",
    explanation: "Le produit de 5 et 3, plus 10 divisé par 2, donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - (3 × 2) + 4 ?",
    options: ["10", "8", "6"],
    answer: "10",
    explanation: "12 moins le produit de 3 et 2, plus 4, donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (10 ÷ 2) × 3 ?",
    options: ["40", "35", "30"],
    answer: "35",
    explanation: "50 moins le produit de 10 divisé par 2 et 3 donne 35.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "12 - 4 + 2 = ?",
    options: ["8", "10", "6"],
    answer: "10",
    explanation:
        "En soustrayant 4 de 12, on obtient 8, puis en ajoutant 2, on a 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 × 3 ÷ 3 = ?",
    options: ["6", "9", "3"],
    answer: "9",
    explanation: "Multiplier 9 par 3 donne 27, puis diviser par 3 donne 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 ÷ 2 + 1 = ?",
    options: ["3", "5", "4"],
    answer: "5",
    explanation: "Diviser 8 par 2 donne 4, puis en ajoutant 1, on obtient 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) × 3 + 4 = ?",
    options: ["28", "22", "26"],
    answer: "26",
    explanation: "D'abord 10 - 2 = 8, puis 8 × 3 = 24, et enfin 24 + 4 = 26.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "24 ÷ (6 - 4) + 10 = ?",
    options: ["12", "14", "10"],
    answer: "12",
    explanation: "D'abord 6 - 4 = 2, puis 24 ÷ 2 = 12, et 12 + 10 = 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 4) - (3 × 2) = ?",
    options: ["14", "10", "12"],
    answer: "14",
    explanation:
        "Multiplier 5 par 4 donne 20, et 3 par 2 donne 6, donc 20 - 6 = 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 ÷ 3) + (5 × 2) = ?",
    options: ["16", "14", "18"],
    answer: "16",
    explanation: "18 ÷ 3 = 6, et 5 × 2 = 10, donc 6 + 10 = 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - (4 × 3)) ÷ 2 = ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "D'abord 4 × 3 = 12, puis 20 - 12 = 8, et enfin 8 ÷ 2 = 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(15 - 3) × (2 + 1) = ?",
    options: ["36", "30", "24"],
    answer: "36",
    explanation: "15 - 3 = 12, puis 2 + 1 = 3, donc 12 × 3 = 36.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 + 5) × 2 - 4 = ?",
    options: ["16", "14", "18"],
    answer: "16",
    explanation:
        "La somme 5 + 5 est 10, multiplier par 2 donne 20, puis 20 - 4 = 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ (5 - 3) ?",
    options: ["12", "13", "25"],
    answer: "25",
    explanation: "25 divisé par 2 est égal à 12,5, arrondi à 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (6 + 4) × 2 ?",
    options: ["10", "20", "30"],
    answer: "20",
    explanation: "30 moins 20 est égal à 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 4 + 2 ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "La somme de 8 et 4, divisée par 4, plus 2, est égale à 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 2 + (3 - 1) ?",
    options: ["10", "12", "8"],
    answer: "12",
    explanation: "6 multiplié par 2 plus 2 est égal à 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 5) × 2 - 5 ?",
    options: ["20", "25", "15"],
    answer: "25",
    explanation: "15 multiplié par 2 moins 5 est égal à 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - (10 ÷ 2) ?",
    options: ["15", "16", "17"],
    answer: "16",
    explanation: "21 moins 5 est égal à 16.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ (6 - 2) ?",
    options: ["6", "8", "9"],
    answer: "9",
    explanation:
        "On soustrait 2 de 6, puis on divise 36 par 4, ce qui donne 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 3 + 2 ?",
    options: ["6", "8", "10"],
    answer: "6",
    explanation:
        "On additionne 8 et 4, puis on divise par 3 et ajoute 2, ce qui donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 4 - 3 ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation: "En ajoutant 8 et 4, puis en soustrayant 3, on obtient 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 2 × 4 ?",
    options: ["3", "7", "11"],
    answer: "7",
    explanation:
        "D'abord on multiplie 2 et 4 pour obtenir 8, puis 15 - 8 donne 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ (5 - 2) ?",
    options: ["5", "7", "8"],
    answer: "8",
    explanation:
        "On soustrait 5 et 2 pour obtenir 3, puis 25 ÷ 3 donne 8 (arrondi).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 2 + 3 ?",
    options: ["20", "18", "22"],
    answer: "18",
    explanation:
        "On soustrait 2 de 10 pour obtenir 8, puis on multiplie par 2 et ajoute 3 pour obtenir 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + (4 × 2) - 3 ?",
    options: ["10", "15", "17"],
    answer: "15",
    explanation:
        "On multiplie 4 par 2 pour obtenir 8, puis on additionne et soustrait pour obtenir 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (3 + 1) - 10 ?",
    options: ["14", "16", "18"],
    answer: "14",
    explanation:
        "On additionne 3 et 1 pour obtenir 4, puis on multiplie par 6 et soustrait 10 pour obtenir 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (2 + 3) + 6 ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation:
        "On additionne 2 et 3 pour obtenir 5, puis 50 ÷ 5 donne 10, et on ajoute 6 pour obtenir 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 - (5 ÷ 1) + 3 ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation: "On divise 5 par 1 pour obtenir 5, puis 11 - 5 + 3 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (2 + 5) - 10 ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation:
        "On additionne 2 et 5 pour obtenir 7, puis on multiplie par 4 et soustrait 10 pour obtenir 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 5 - 2 ?",
    options: ["10", "11", "12"],
    answer: "10",
    explanation: "Additionner 7 et 5 puis soustraire 2 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 8 + 3 ?",
    options: ["15", "14", "16"],
    answer: "15",
    explanation: "Soustraire 8 de 20 puis ajouter 3 donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 3 + 6 ?",
    options: ["18", "22", "14"],
    answer: "18",
    explanation: "Multiplier 4 par 3 puis ajouter 6 donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + (6 - 3) × 4 ?",
    options: ["20", "24", "16"],
    answer: "20",
    explanation:
        "Soustraire 3 de 6, multiplier par 4, puis ajouter 8 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 ÷ (3 - 1) + 7 ?",
    options: ["10", "11", "12"],
    answer: "10",
    explanation: "Diviser 9 par 2, puis ajouter 7 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - (3 × 2) + 5 ?",
    options: ["10", "8", "9"],
    answer: "9",
    explanation:
        "Multiplier 3 par 2, soustraire de 10, puis ajouter 5 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 3 - (8 ÷ 4) ?",
    options: ["16", "18", "14"],
    answer: "16",
    explanation: "Multiplier 6 par 3, puis soustraire 2 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - (3 + 2) = ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation:
        "On additionne 3 et 2 pour obtenir 5, puis on soustrait de 15, ce qui donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 × 3 - 10 = ?",
    options: ["24", "14", "18"],
    answer: "14",
    explanation:
        "8 multiplié par 3 donne 24, et en soustrayant 10, on obtient 14.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 - 5 × 3 = ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation:
        "On effectue d'abord la multiplication : 5 × 3 = 15, puis 20 - 15 = 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(3 × 4) + (2 × 3) = ?",
    options: ["18", "20", "15"],
    answer: "18",
    explanation:
        "On calcule 3 × 4 = 12 et 2 × 3 = 6, puis on additionne 12 et 6 pour obtenir 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 - 4) × (5 + 1) = ?",
    options: ["24", "18", "20"],
    answer: "24",
    explanation:
        "On calcule d'abord 8 - 4 = 4 et 5 + 1 = 6, puis on multiplie 4 et 6 pour obtenir 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 + 14 ÷ 2 = ?",
    options: ["10", "14", "21"],
    answer: "14",
    explanation:
        "On effectue d'abord la division : 14 ÷ 2 = 7, puis 7 + 7 = 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 + 8 - 5 = ?",
    options: ["10", "12", "11"],
    answer: "12",
    explanation:
        "On additionne 9 et 8 pour obtenir 17, puis on soustrait 5, ce qui donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(15 - 3) ÷ 2 = ?",
    options: ["6", "8", "12"],
    answer: "6",
    explanation:
        "On soustrait 3 de 15 pour obtenir 12, puis on divise par 2, ce qui donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 2) + (4 ÷ 2) = ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation:
        "On calcule 5 × 2 = 10 et 4 ÷ 2 = 2, puis on additionne 10 et 2 pour obtenir 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 3 × 2 ?",
    options: ["14", "16", "18"],
    answer: "14",
    explanation:
        "D'abord multiplier 3 par 2, puis soustraire le résultat de 20 donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (2 + 1) ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "Multiplier 4 par la somme de 2 et 1 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 3 - 4 ÷ 2 ?",
    options: ["13", "14", "15"],
    answer: "13",
    explanation:
        "Multiplier 5 par 3, puis soustraire le résultat de 4 divisé par 2 donne 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × 2 - 5 ?",
    options: ["9", "10", "11"],
    answer: "9",
    explanation:
        "Additionner 6 et 2, multiplier par 2, puis soustraire 5 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - (3 × 2) + 4 ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation:
        "Soustraire le produit de 3 et 2 de 10, puis ajouter 4 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 17 - 5 + 3 ?",
    options: ["13", "14", "15"],
    answer: "15",
    explanation: "Soustraire 5 de 17, puis ajouter 3 donne 15.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (8 + 2) × 3 ?",
    options: ["30", "28", "32"],
    answer: "28",
    explanation: "50 moins (8 plus 2) multiplié par 3 égale 28.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 2 × (5 - 3) ?",
    options: ["16", "18", "14"],
    answer: "16",
    explanation: "12 plus 2 multiplié par (5 moins 3) égale 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 9 ?",
    options: ["14", "13", "15"],
    answer: "14",
    explanation: "25 divisé par 5 plus 9 égale 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 3 × 4 ?",
    options: ["19", "20", "18"],
    answer: "19",
    explanation: "7 plus 3 multiplié par 4 égale 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (4 + 2) - 6 ÷ 2 ?",
    options: ["18", "16", "12"],
    answer: "16",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses, puis on multiplie et enfin on soustrait, ce qui donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + (3 × 5) - 4 ?",
    options: ["18", "20", "16"],
    answer: "18",
    explanation:
        "On multiplie 3 par 5, on ajoute 7 et on soustrait 4, ce qui donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 ÷ 4) + (6 × 2) ?",
    options: ["14", "10", "12"],
    answer: "14",
    explanation:
        "On divise 20 par 4 et on multiplie 6 par 2, puis on additionne les résultats, ce qui donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 3) × (2 + 2) ?",
    options: ["24", "20", "12"],
    answer: "24",
    explanation:
        "On soustrait 3 de 9 et on additionne 2 et 2, puis on multiplie les résultats, ce qui donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 3) + 6 ?",
    options: ["21", "19", "18"],
    answer: "21",
    explanation: "On multiplie 5 par 3 et on ajoute 6, ce qui donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (2 × 5) + 4 ?",
    options: ["20", "24", "26"],
    answer: "24",
    explanation:
        "On effectue les parenthèses en premier, donc 30 - 10 + 4 = 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 8) × 2 - 10 ?",
    options: ["10", "14", "16"],
    answer: "14",
    explanation:
        "On additionne d'abord, puis on multiplie et soustrait : 12 × 2 - 10 = 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 3 - (15 ÷ 3) ?",
    options: ["24", "18", "21"],
    answer: "24",
    explanation: "La multiplication de 9 par 3, moins 5, donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 10 ÷ 2 ?",
    options: ["15", "20", "25"],
    answer: "15",
    explanation: "La division de 10 par 2, ajoutée à 10, donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 4 × (3 - 1) ?",
    options: ["16", "20", "12"],
    answer: "16",
    explanation:
        "La multiplication de 4 par la différence de 3 et 1, ajoutée à 8, donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ (5 - 3) ?",
    options: ["5", "10", "15"],
    answer: "10",
    explanation: "La soustraction donne 2, donc 20 divisé par 2 est 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - 2 + 6 ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation: "La soustraction de 2 à 10 donne 8, puis 8 plus 6 est 14.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ 4 + 10 ?",
    options: ["25", "30", "35"],
    answer: "35",
    explanation: "On divise 100 par 4, puis on ajoute 10, ce qui donne 35.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 ÷ 5) × (3 + 1) ?",
    options: ["12", "15", "16"],
    answer: "16",
    explanation:
        "On divise 20 par 5, puis on multiplie par la somme de 3 et 1, ce qui donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (8 ÷ 2) × 3 ?",
    options: ["21", "24", "27"],
    answer: "21",
    explanation:
        "On divise 8 par 2, multiplie par 3, puis soustrait de 30, ce qui donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (6 ÷ 2) + 5 ?",
    options: ["15", "16", "17"],
    answer: "17",
    explanation:
        "On divise 6 par 2, soustrait le résultat de 18 puis ajoute 5, ce qui donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 × 2) + (3 × 5) ?",
    options: ["27", "29", "31"],
    answer: "29",
    explanation:
        "On multiplie d'abord 4 par 2 et 3 par 5, puis on additionne les résultats, ce qui donne 29.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) ÷ 2 ?",
    options: ["3", "4", "5"],
    answer: "4",
    explanation:
        "On effectue d'abord la soustraction : 10 - 2 = 8, puis 8 ÷ 2 = 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (3 + 3) + 5 ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation:
        "On effectue d'abord l'addition : 3 + 3 = 6, puis 30 ÷ 6 + 5 = 5 + 5 = 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 3 × 4 ?",
    options: ["11", "12", "10"],
    answer: "12",
    explanation: "Le produit de 3 et 4 est 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 6 + 9 - 4 ?",
    options: ["11", "10", "12"],
    answer: "11",
    explanation: "La somme de 6 et 9, moins 4, est 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait (8 + 4) ÷ 4 ?",
    options: ["3", "2", "4"],
    answer: "3",
    explanation:
        "D'abord, on additionne 8 et 4 pour obtenir 12, puis 12 ÷ 4 = 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 14 ÷ 2 + 3 ?",
    options: ["8", "10", "11"],
    answer: "11",
    explanation: "D'abord, 14 ÷ 2 = 7, puis 7 + 3 = 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + (6 - 2) × 3 ?",
    options: ["18", "24", "22"],
    answer: "24",
    explanation:
        "On effectue d'abord l'opération dans les parenthèses : 6 - 2 = 4, puis 12 + 4 × 3 = 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait (5 + 3) × (2 + 1) ?",
    options: ["24", "18", "16"],
    answer: "24",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses : 5 + 3 = 8 et 2 + 1 = 3, donc 8 × 3 = 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 2 + 5 ?",
    options: ["20", "25", "22"],
    answer: "22",
    explanation: "D'abord, on effectue 10 - 2 = 8, puis 8 × 2 + 5 = 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 9 × 2 + 6 ÷ 2 ?",
    options: ["20", "22", "21"],
    answer: "22",
    explanation:
        "On effectue d'abord les multiplications et divisions : 9 × 2 = 18 et 6 ÷ 2 = 3, puis 18 + 3 = 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 4 + 3 × 2 ?",
    options: ["26", "28", "30"],
    answer: "26",
    explanation:
        "On effectue d'abord les multiplications : 5 × 4 = 20 et 3 × 2 = 6, puis 20 + 6 = 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 18 ÷ 3 + 4 × 2 ?",
    options: ["14", "16", "15"],
    answer: "16",
    explanation: "On commence par 18 ÷ 3 = 6 et 4 × 2 = 8, donc 6 + 8 = 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 10 ?",
    options: ["12", "15", "10"],
    answer: "15",
    explanation: "Le résultat de 25 ÷ 5 + 10 est 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) × (5 - 3) ?",
    options: ["20", "24", "30"],
    answer: "20",
    explanation: "Le résultat de (6 + 4) × (5 - 3) est 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (2 + 3) × 4 ?",
    options: ["40", "20", "10"],
    answer: "40",
    explanation: "Le résultat de 50 ÷ (2 + 3) × 4 est 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 3 + 7 ?",
    options: ["22", "17", "18"],
    answer: "22",
    explanation: "5 multiplié par 3 plus 7 donne 22.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (6 - 2) + 8 ?",
    options: ["24", "20", "16"],
    answer: "24",
    explanation: "4 multiplié par la différence de 6 et 2, plus 8, donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 5) ÷ 2 + 4 ?",
    options: ["9", "10", "8"],
    answer: "9",
    explanation: "La somme de 5 et 5 divisée par 2, plus 4, donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ 3 + 7 ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation: "12 divisé par 3 plus 7 donne 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (4 + 1) ?",
    options: ["20", "25", "15"],
    answer: "25",
    explanation: "4 plus 1 donne 5, multiplié par 5 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 ÷ 2) + (3 × 4) ?",
    options: ["20", "18", "22"],
    answer: "20",
    explanation:
        "8 divisé par 2 est 4, et 3 multiplié par 4 est 12, donc 4 plus 12 est 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (6 × 5) + 3 ?",
    options: ["13", "17", "18"],
    answer: "13",
    explanation: "50 moins 30 (6 fois 5) plus 3 donne 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 + 5) × 2 - 6 ?",
    options: ["16", "14", "18"],
    answer: "16",
    explanation: "7 plus 5 donne 12, multiplié par 2 est 24, moins 6 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × (3 + 1) - 10 ?",
    options: ["26", "32", "20"],
    answer: "26",
    explanation:
        "3 plus 1 donne 4, 9 multiplié par 4 est 36, moins 10 donne 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (3 + 2) + 1 ?",
    options: ["21", "20", "22"],
    answer: "21",
    explanation: "3 plus 2 donne 5, 4 multiplié par 5 est 20, plus 1 donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 7 ?",
    options: ["42", "36", "48"],
    answer: "42",
    explanation: "6 multiplié par 7 égale 42.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de (12 - 4) × 2 ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation: "12 moins 4 multiplié par 2 égale 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (12 ÷ 4) ?",
    options: ["46", "48", "44"],
    answer: "48",
    explanation: "50 moins 3 égale 48.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) × (2 - 1) ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation: "La somme de 8 et 4 multipliée par 1 égale 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 × 2 - (3 + 7) ?",
    options: ["25", "27", "20"],
    answer: "25",
    explanation: "30 moins 10 égale 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 6) ÷ 2 ?",
    options: ["7", "8", "9"],
    answer: "8",
    explanation: "10 + 6 = 16, donc 16 ÷ 2 = 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 2) + (10 ÷ 2) ?",
    options: ["10", "15", "20"],
    answer: "15",
    explanation: "5 × 2 = 10 et 10 ÷ 2 = 5, donc 10 + 5 = 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (14 - 4) × 2 ?",
    options: ["20", "22", "24"],
    answer: "20",
    explanation: "14 - 4 = 10, donc 10 × 2 = 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ 4 + 6 ?",
    options: ["8", "10", "4"],
    answer: "10",
    explanation: "Diviser 20 par 4 puis ajouter 6 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (5 + 3) - 6 ?",
    options: ["26", "22", "30"],
    answer: "26",
    explanation:
        "Multiplier 4 par la somme de 5 et 3, puis soustraire 6 donne 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - (3 × 4) + 2 ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation: "Effectuer les opérations dans l'ordre donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × 3 - 10 ?",
    options: ["20", "14", "16"],
    answer: "14",
    explanation: "Calculer la somme, multiplier puis soustraire donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (5 + 5) + 5 ?",
    options: ["10", "15", "5"],
    answer: "10",
    explanation: "Diviser 50 par 10 puis ajouter 5 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 2 - (3 + 1) ?",
    options: ["14", "12", "16"],
    answer: "14",
    explanation: "Multiplier puis soustraire la somme donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 3 + 4 × 2 ?",
    options: ["10", "14", "12"],
    answer: "14",
    explanation: "Calculer chaque opération donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 3 - 4 ?",
    options: ["20", "22", "24"],
    answer: "20",
    explanation: "8 multiplié par 3 donne 24, moins 4 égale 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - (4 × 2) ?",
    options: ["6", "8", "10"],
    answer: "6",
    explanation: "4 multiplié par 2 est 8, donc 12 moins 8 donne 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ 5 + 15 ?",
    options: ["20", "25", "30"],
    answer: "25",
    explanation: "100 divisé par 5 donne 20, plus 15 donne 35.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (3 + 4) + 1 ?",
    options: ["15", "14", "13"],
    answer: "15",
    explanation: "2 multiplié par 7 donne 14, plus 1 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + (3 × 3) ?",
    options: ["15", "18", "12"],
    answer: "18",
    explanation: "9 plus 9 donne 18.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - 7 + 3 ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "12 moins 7 plus 3 équivaut à 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + (3 × 4) ?",
    options: ["20", "22", "24"],
    answer: "24",
    explanation:
        "La division donne 9, et la multiplication donne 12, donc 9 plus 12 est 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 2) + (3 × 3) ?",
    options: ["19", "20", "21"],
    answer: "21",
    explanation: "La multiplication donne 10 et 9, donc 10 plus 9 est 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (5 × 4) + 3 ?",
    options: ["10", "12", "13"],
    answer: "12",
    explanation: "25 moins 20 est 5, puis 5 plus 3 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (6 ÷ 3) ?",
    options: ["16", "14", "12"],
    answer: "16",
    explanation: "La division donne 2, et 18 moins 2 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 2) × 2 ?",
    options: ["8", "9", "10"],
    answer: "10",
    explanation: "La somme de 3 et 2, multipliée par 2, donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + 7 - 2 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "6 plus 7 moins 2 donne 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 2 - 4 ?",
    options: ["8", "6", "10"],
    answer: "8",
    explanation:
        "On multiplie d'abord, puis on soustrait : 6 × 2 = 12, 12 - 4 = 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 6) ÷ 2 ?",
    options: ["5", "4", "6"],
    answer: "5",
    explanation:
        "On additionne d'abord, puis on divise : (4 + 6) = 10, 10 ÷ 2 = 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (3 + 5) ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation:
        "On additionne d'abord, puis on soustrait : 3 + 5 = 8, 18 - 8 = 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 2) + (6 ÷ 3) ?",
    options: ["11", "10", "12"],
    answer: "11",
    explanation:
        "On effectue d'abord les multiplications et divisions : 5 × 2 = 10, 6 ÷ 3 = 2, puis 10 + 2 = 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (5 - 2) ?",
    options: ["6", "4", "7"],
    answer: "6",
    explanation:
        "On effectue d'abord la soustraction dans les parenthèses : 5 - 2 = 3, puis 9 - 3 = 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + (6 ÷ 2) ?",
    options: ["9", "10", "11"],
    answer: "11",
    explanation: "La division de 6 par 2, ajoutée à 8, donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - (3 × 4) ?",
    options: ["3", "6", "9"],
    answer: "3",
    explanation: "La multiplication de 3 par 4, soustraite de 15, donne 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 5) × 4 + 1 ?",
    options: ["13", "15", "17"],
    answer: "13",
    explanation: "La différence de 9 et 5, multipliée par 4, plus 1, donne 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 5 × (2 - 1) ?",
    options: ["9", "10", "11"],
    answer: "10",
    explanation:
        "Le quotient de 18 par 3, plus le produit de 5 et la différence de 2 et 1, donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (10 ÷ 2) × 3 ?",
    options: ["10", "15", "20"],
    answer: "10",
    explanation:
        "La division de 10 par 2, multipliée par 3, soustraite de 25, donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 × 3) - (4 ÷ 2) ?",
    options: ["20", "21", "22"],
    answer: "21",
    explanation: "Le produit de 7 et 3 moins la division de 4 par 2 donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + (3 × 4) - 5 ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "La somme de 12 et le produit de 3 et 4 moins 5 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (2 × 3) + 5 ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation:
        "La différence de 14 moins le produit de 2 et 3 plus 5 donne 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ (5 - 2) + 3 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation:
        "La division de 25 par la différence de 5 et 2 plus 3 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (4 + 2) × 2 ?",
    options: ["6", "7", "8"],
    answer: "6",
    explanation:
        "La différence de 18 moins le produit de (4 + 2) et 2 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 5) ÷ 2 × 4 ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation:
        "La somme de 3 et 5 divisée par 2 puis multipliée par 4 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 15 + 6 - 4 ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "En ajoutant 6 à 15 puis en soustrayant 4, on obtient 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 3 - 7 ?",
    options: ["20", "22", "26"],
    answer: "20",
    explanation:
        "La multiplication de 9 par 3 donne 27, puis 27 moins 7 égale 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 36 ÷ (2 + 4) ?",
    options: ["4", "6", "8"],
    answer: "6",
    explanation:
        "On additionne d'abord 2 et 4 pour obtenir 6, puis on divise 36 par 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (3 + 4) ?",
    options: ["30", "35", "40"],
    answer: "35",
    explanation:
        "On additionne 3 et 4 pour obtenir 7, puis on multiplie par 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (3 × 10) + 2 ?",
    options: ["32", "42", "52"],
    answer: "32",
    explanation:
        "On effectue d'abord la multiplication, puis les additions et soustractions dans l'ordre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait (12 ÷ 3) + (4 × 5) ?",
    options: ["20", "22", "24"],
    answer: "22",
    explanation:
        "On divise 12 par 3 pour obtenir 4, puis on multiplie 4 par 5 pour obtenir 20, et enfin on additionne les deux résultats.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 18 ÷ 2 + 7 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation:
        "On divise 18 par 2 pour obtenir 9, puis on ajoute 7 pour obtenir 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 4 + 8 ÷ 2 ?",
    options: ["18", "20", "22"],
    answer: "20",
    explanation:
        "On multiplie d'abord 4 par 4 pour obtenir 16, puis on divise 8 par 2 pour obtenir 4, et enfin on additionne les deux résultats.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - 5 × 5 ?",
    options: ["5", "15", "25"],
    answer: "5",
    explanation:
        "On effectue d'abord la multiplication, puis la soustraction, pour obtenir 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) ÷ 2 ?",
    options: ["6", "5", "7"],
    answer: "6",
    explanation:
        "On additionne d'abord, puis on divise : 12 divisé par 2 est 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (4 - 2) + 3 ?",
    options: ["13", "15", "12"],
    answer: "13",
    explanation:
        "On effectue d'abord la parenthèse, puis la multiplication et enfin l'addition : 10 plus 3 est 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 ÷ 2) + (4 × 3) ?",
    options: ["16", "18", "12"],
    answer: "16",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses : 3 plus 12 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 ÷ 2) + (6 ÷ 3) ?",
    options: ["5", "6", "4"],
    answer: "5",
    explanation: "On effectue d'abord les divisions : 4 plus 2 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - (2 + 3) × 2 ?",
    options: ["4", "5", "3"],
    answer: "4",
    explanation:
        "On effectue d'abord l'addition dans la parenthèse, puis la multiplication et enfin la soustraction : 10 moins 10 donne 0.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 ÷ (2 + 6) ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation:
        "On additionne 2 et 6, puis on divise 40 par 8 pour obtenir 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 3 + 4 ?",
    options: ["22", "24", "26"],
    answer: "26",
    explanation:
        "On soustrait 2 de 10, on multiplie par 3 et on ajoute 4 pour obtenir 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 5 + (2 × 3) ?",
    options: ["15", "16", "17"],
    answer: "16",
    explanation:
        "On effectue la multiplication d'abord, puis on fait les additions et soustractions pour obtenir 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + (6 ÷ 3) × 4 ?",
    options: ["10", "12", "14"],
    answer: "14",
    explanation:
        "On commence par diviser 6 par 3, puis on multiplie par 4 et on additionne 9 pour obtenir 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (3 + 1) - 5 ?",
    options: ["18", "19", "20"],
    answer: "19",
    explanation:
        "D'abord, additionner 3 et 1 donne 4, multiplié par 6 donne 24, moins 5 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (3 × 2) + 1 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation: "D'abord, 3 fois 2 est 6, donc 9 moins 6 plus 1 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 2 + 4 ÷ 2 ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "D'abord, 4 divisé par 2 donne 2, donc 10 plus 2 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 5) × 2 + 1 ?",
    options: ["20", "21", "22"],
    answer: "21",
    explanation:
        "D'abord, 15 moins 5 est 10, multiplié par 2 donne 20, plus 1 donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × 2 - 4 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation:
        "D'abord, 6 plus 2 est 8, multiplié par 2 donne 16, moins 4 donne 12.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 × 2 - 3 = ?",
    options: ["11", "10", "12"],
    answer: "11",
    explanation: "On multiplie 7 par 2, puis on soustrait 3, ce qui donne 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "18 - 3 × 2 = ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation:
        "On multiplie 3 par 2, puis on soustrait le résultat de 18, ce qui donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "10 + (6 - 4) × 3 = ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation:
        "On effectue d'abord le calcul dans les parenthèses, puis les multiplications et additions, ce qui donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - 5) ÷ 3 + 2 = ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation:
        "On soustrait 5 de 20, puis on divise par 3 et on ajoute 2, ce qui donne 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 × (2 + 1) - 5 = ?",
    options: ["22", "24", "26"],
    answer: "22",
    explanation:
        "On effectue d'abord le calcul dans les parenthèses, puis la multiplication et la soustraction, ce qui donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "36 ÷ (6 - 3) + 4 × 2 = ?",
    options: ["10", "14", "16"],
    answer: "14",
    explanation:
        "On effectue d'abord le calcul dans les parenthèses, puis la division et enfin l'addition, ce qui donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "5 × (3 + 2) - 7 ÷ 1 = ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation:
        "On effectue d'abord le calcul dans les parenthèses, puis la multiplication et la soustraction, ce qui donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 + 4) ÷ 4 × 3 = ?",
    options: ["9", "10", "12"],
    answer: "9",
    explanation:
        "On effectue d'abord le calcul dans les parenthèses, puis la division et la multiplication, ce qui donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "14 - 3 × (2 + 1) = ?",
    options: ["5", "8", "11"],
    answer: "5",
    explanation:
        "On effectue d'abord le calcul dans les parenthèses, puis la multiplication et la soustraction, ce qui donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "28 ÷ (7 - 3) + 6 = ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation:
        "On effectue d'abord le calcul dans les parenthèses, puis la division et enfin l'addition, ce qui donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 + 6 - 2 ?",
    options: ["18", "20", "16"],
    answer: "18",
    explanation: "14 plus 6 moins 2 égale 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 22 - 7 + 5 ?",
    options: ["20", "21", "22"],
    answer: "20",
    explanation: "22 moins 7 plus 5 égale 20.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 16 - 5 ?",
    options: ["23", "22", "24"],
    answer: "23",
    explanation: "12 plus 16 moins 5 est égal à 23.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 ÷ 5 + 6 ?",
    options: ["15", "12", "11"],
    answer: "15",
    explanation: "45 divisé par 5 plus 6 donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 2) × (3 - 1) ?",
    options: ["20", "24", "22"],
    answer: "20",
    explanation: "La multiplication des résultats des parenthèses donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (10 ÷ 2) + 6 ?",
    options: ["46", "48", "44"],
    answer: "46",
    explanation: "Le calcul donne 46 après les opérations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - (3 × 4) + 2 ?",
    options: ["5", "8", "7"],
    answer: "5",
    explanation: "Le résultat du calcul est 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) × 2 - 10 ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "Le résultat final est 10 après les opérations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 3) + (12 ÷ 4) ?",
    options: ["19", "16", "18"],
    answer: "19",
    explanation: "La somme des résultats donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ 6 + 2 ?",
    options: ["4", "6", "8"],
    answer: "6",
    explanation: "Diviser 36 par 6 donne 6, puis ajouter 2 donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 9 + 3 ?",
    options: ["12", "10", "11"],
    answer: "12",
    explanation: "18 moins 9 plus 3 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ (2 + 6) ?",
    options: ["4", "3", "6"],
    answer: "4",
    explanation: "D'abord, 2 plus 6 donne 8, puis 36 divisé par 8 donne 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 × 4) + (5 × 2) ?",
    options: ["26", "22", "20"],
    answer: "26",
    explanation:
        "D'abord, 3 fois 4 donne 12 et 5 fois 2 donne 10, puis 12 plus 10 donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + (4 × 3) - 2 ?",
    options: ["20", "24", "22"],
    answer: "22",
    explanation:
        "D'abord, 4 fois 3 donne 12, puis 10 plus 12 moins 2 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 5) × 2 ?",
    options: ["20", "15", "25"],
    answer: "20",
    explanation:
        "D'abord, 15 moins 5 donne 10, puis 10 multiplié par 2 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × (2 + 1) - 10 ?",
    options: ["17", "18", "16"],
    answer: "17",
    explanation:
        "D'abord, 2 plus 1 donne 3, puis 9 fois 3 donne 27, puis 27 moins 10 donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (2 + 6) - 10 ?",
    options: ["50", "42", "46"],
    answer: "50",
    explanation: "8 multiplié par 8 moins 10 égale 50.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 3) × (2 + 4) ?",
    options: ["36", "42", "30"],
    answer: "36",
    explanation: "La différence multipliée par la somme donne 36.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ (5 × 4) + 1 ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation: "100 divisé par 20 plus 1 donne 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + (8 ÷ 2) × 3 ?",
    options: ["24", "30", "18"],
    answer: "24",
    explanation: "12 plus 12 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (4 + 2) × 2 ?",
    options: ["8", "10", "6"],
    answer: "8",
    explanation: "20 moins 12 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + 8 ?",
    options: ["12", "13", "11"],
    answer: "13",
    explanation: "5 + 8 égale 13.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 4 ?",
    options: ["16", "15", "14"],
    answer: "16",
    explanation: "20 - 4 égale 16.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 2) × (7 - 5) ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "(3 + 2) multiplié par (7 - 5) égale 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - 3 + 9 ?",
    options: ["18", "17", "19"],
    answer: "18",
    explanation: "12 - 3 plus 9 égale 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × 5 + 10 ÷ 2 ?",
    options: ["15", "20", "12"],
    answer: "15",
    explanation: "2 multiplié par 5 plus 10 divisé par 2 égale 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + 15 - 5 ?",
    options: ["15", "17", "18"],
    answer: "17",
    explanation: "7 plus 15 moins 5 égale 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (30 ÷ 6) ?",
    options: ["45", "48", "47"],
    answer: "48",
    explanation: "50 moins 5 (30 divisé par 6) égale 48.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 6 - 10 ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "9 plus 6 moins 10 égale 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 ÷ 9 + 5 ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation: "5 plus 5 égale 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 2 × 4 ?",
    options: ["10", "12", "14"],
    answer: "14",
    explanation:
        "On effectue d'abord la division : 18 ÷ 3 = 6, puis 2 × 4 = 8, enfin 6 + 8 = 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) × 2 + 4 ?",
    options: ["20", "22", "24"],
    answer: "24",
    explanation:
        "On effectue d'abord l'addition : 5 + 3 = 8, puis 8 × 2 = 16, enfin 16 + 4 = 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 4 × (3 - 1) ?",
    options: ["16", "18", "20"],
    answer: "18",
    explanation:
        "On effectue d'abord la soustraction : 3 - 1 = 2, puis 4 × 2 = 8, enfin 10 + 8 = 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ (2 + 2) × 3 ?",
    options: ["18", "24", "30"],
    answer: "18",
    explanation:
        "On effectue d'abord l'addition : 2 + 2 = 4, puis 24 ÷ 4 = 6, enfin 6 × 3 = 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (5 × 4) + 2 ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation:
        "On effectue d'abord la multiplication : 5 × 4 = 20, puis 30 - 20 + 2 = 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 ÷ 3 × 2 = ?",
    options: ["8", "5", "10"],
    answer: "10",
    explanation: "On effectue la division avant la multiplication.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 - 5 + 10 = ?",
    options: ["15", "25", "10"],
    answer: "25",
    explanation: "On effectue d'abord la soustraction puis l'addition.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 - 3) × 5 = ?",
    options: ["25", "30", "35"],
    answer: "25",
    explanation: "D'abord, on soustrait puis on multiplie le résultat.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 ÷ 2) + (4 × 3) = ?",
    options: ["20", "16", "14"],
    answer: "16",
    explanation:
        "On effectue d'abord les opérations dans chaque parenthèse puis on additionne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 × 5) - (4 × 3) = ?",
    options: ["24", "18", "30"],
    answer: "24",
    explanation:
        "On effectue d'abord les multiplications puis la soustraction.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 ÷ 8 ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation: "40 divisé par 8 est égal à 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - (3 × 2) ?",
    options: ["6", "8", "7"],
    answer: "6",
    explanation: "12 moins le produit de 3 et 2 est égal à 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 + 3) × (6 - 2) ?",
    options: ["40", "30", "20"],
    answer: "40",
    explanation:
        "La somme de 7 et 3, multipliée par la différence de 6 et 2, donne 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (10 - 3) + 4 ?",
    options: ["18", "16", "20"],
    answer: "18",
    explanation:
        "Le produit de 2 et la différence de 10 et 3, plus 4, donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 2 + 7 ?",
    options: ["12", "10", "11"],
    answer: "12",
    explanation: "La somme de 8 et 4, divisée par 2, plus 7, donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 3) + (4 - 1) ?",
    options: ["17", "18", "16"],
    answer: "17",
    explanation:
        "Le produit de 5 et 3, plus la différence de 4 et 1, donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (3 × 4) + 2 ?",
    options: ["10", "14", "12"],
    answer: "10",
    explanation: "20 moins le produit de 3 et 4, plus 2, donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 3) ÷ 3 + 5 ?",
    options: ["9", "7", "8"],
    answer: "8",
    explanation: "La division de 12 par 3, ajoutée à 5, donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 × 2) + (3 × 2) ?",
    options: ["10", "14", "12"],
    answer: "10",
    explanation: "La somme des produits donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 5) × (6 + 1) ?",
    options: ["28", "24", "30"],
    answer: "28",
    explanation: "La multiplication des résultats donne 28.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (10 ÷ 2) × 5 ?",
    options: ["45", "40", "35"],
    answer: "40",
    explanation: "50 moins 25 égale 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 + 5) × (3 - 1) ?",
    options: ["24", "26", "20"],
    answer: "24",
    explanation: "12 multiplié par 2 égale 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 7 - 2 ?",
    options: ["9", "8", "7"],
    answer: "9",
    explanation: "6 plus 7 moins 2 égale 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 4 + 6 ?",
    options: ["38", "34", "36"],
    answer: "38",
    explanation: "8 multiplié par 4 plus 6 égale 38.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 + 6 - (3 × 2) ?",
    options: ["16", "20", "18"],
    answer: "16",
    explanation: "14 plus 6 moins 6 égale 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 3) + (4 × 2) ?",
    options: ["23", "22", "20"],
    answer: "22",
    explanation: "15 plus 8 égale 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 + 7 - 4 ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "15 plus 7 moins 4 est égal à 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) ÷ 4 ?",
    options: ["2", "3", "4"],
    answer: "2",
    explanation: "La différence de 10 et 2, divisée par 4, est 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 ÷ 2) + 5 ?",
    options: ["5", "6", "9"],
    answer: "9",
    explanation: "4 plus 5 donne 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (3 + 2) - 6 ?",
    options: ["14", "16", "18"],
    answer: "14",
    explanation: "20 moins 6 égale 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 - 4) × 2 + 1 ?",
    options: ["14", "15", "16"],
    answer: "15",
    explanation: "8 multiplié par 2 plus 1 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - 5 ÷ 5 ?",
    options: ["20", "21", "22"],
    answer: "21",
    explanation: "7 multiplié par 3 moins 5 divisé par 5 égale 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (2 + 1) + 10 ?",
    options: ["10", "20", "30"],
    answer: "20",
    explanation: "30 divisé par (2 + 1) plus 10 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 3 - 5 + 1 ?",
    options: ["22", "23", "24"],
    answer: "23",
    explanation: "9 multiplié par 3 moins 5 plus 1 donne 23.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "5 + 7 = ?",
    options: ["12", "11", "13"],
    answer: "12",
    explanation: "La somme de 5 et 7 est 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - 6 = ?",
    options: ["8", "9", "7"],
    answer: "9",
    explanation: "La différence entre 15 et 6 est 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "4 × 3 = ?",
    options: ["12", "10", "15"],
    answer: "12",
    explanation: "Le produit de 4 et 3 est 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "18 ÷ 3 = ?",
    options: ["5", "6", "4"],
    answer: "6",
    explanation: "La division de 18 par 3 donne 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 + 4) - 5 = ?",
    options: ["7", "6", "8"],
    answer: "7",
    explanation: "La somme de 8 et 4 est 12, et 12 moins 5 est 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - 8) + 3 = ?",
    options: ["15", "14", "16"],
    answer: "15",
    explanation: "La différence de 20 et 8 est 12, ajoutée à 3 donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 × (2 + 1) = ?",
    options: ["27", "18", "36"],
    answer: "27",
    explanation:
        "Le calcul dans les parenthèses donne 3, et 9 multiplié par 3 est 27.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(50 - 10) ÷ 2 + 5 = ?",
    options: ["30", "25", "20"],
    answer: "25",
    explanation:
        "La différence de 50 et 10 est 40, divisée par 2 donne 20, puis ajout de 5 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(3 × 3) + (2 × 4) = ?",
    options: ["21", "18", "20"],
    answer: "21",
    explanation:
        "Le produit de 3 et 3 est 9, et de 2 et 4 est 8, leur somme est 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(25 ÷ 5) × 3 - 2 = ?",
    options: ["13", "10", "11"],
    answer: "13",
    explanation:
        "La division donne 5, multipliée par 3 donne 15, moins 2 est 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "12 × (1 + 2) - 6 = ?",
    options: ["30", "36", "24"],
    answer: "30",
    explanation:
        "La somme dans les parenthèses est 3, multipliée par 12 donne 36, moins 6 est 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(14 - 6) × 2 + 1 = ?",
    options: ["17", "20", "18"],
    answer: "17",
    explanation:
        "La différence est 8, multipliée par 2 donne 16, ajout de 1 donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 - (5 + 3) = ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation: "La somme dans les parenthèses est 8, 20 moins 8 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ 5 + 3 × 2 ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation:
        "On effectue d'abord la division, puis la multiplication, et enfin l'addition, ce qui donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 9 - 3 ?",
    options: ["12", "13", "14"],
    answer: "12",
    explanation:
        "On effectue d'abord la division, puis l'addition et la soustraction, ce qui donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 4 ÷ 2 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation:
        "On effectue d'abord la division, puis l'addition, ce qui donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 3 + 5 × 2 ?",
    options: ["21", "22", "23"],
    answer: "21",
    explanation:
        "On effectue d'abord les multiplications, puis on additionne pour obtenir 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 - 3) × (8 ÷ 2) ?",
    options: ["12", "16", "20"],
    answer: "12",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses, ce qui donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (6 - 1) + 3 ?",
    options: ["18", "22", "23"],
    answer: "22",
    explanation:
        "On effectue d'abord la soustraction, puis la multiplication et enfin l'addition, ce qui donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 ÷ 2 + 1 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation:
        "On effectue d'abord la division, puis l'addition, ce qui donne 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (3 + 1) ?",
    options: ["10", "11", "12"],
    answer: "10",
    explanation:
        "On effectue d'abord l'addition dans les parenthèses, puis la soustraction, ce qui donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 3 - 2 ?",
    options: ["10", "11", "12"],
    answer: "10",
    explanation: "9 plus 3 moins 2 égale 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (3 × 2) + 5 ?",
    options: ["13", "14", "15"],
    answer: "13",
    explanation: "14 moins le produit de 3 et 2 plus 5 égale 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 ÷ 8 + 6 ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation: "40 divisé par 8 plus 6 égale 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - 2 × (3 + 7) ?",
    options: ["30", "40", "20"],
    answer: "30",
    explanation: "50 moins 2 multiplié par la somme de 3 et 7 égale 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + 15 ÷ 3 ?",
    options: ["10", "15", "20"],
    answer: "20",
    explanation: "5 plus 15 divisé par 3 égale 20.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (2 × 6) + 4 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "Le résultat est 18 moins 12 plus 4, soit 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (5 + 3) × 2 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "25 moins 16 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 4 - 5 ?",
    options: ["31", "32", "33"],
    answer: "31",
    explanation: "La multiplication de 9 par 4, moins 5, donne 31.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 ÷ 4) + (5 × 3) ?",
    options: ["20", "21", "22"],
    answer: "20",
    explanation:
        "La division de 20 par 4, plus la multiplication de 5 par 3, donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 × 2 - (3 × 4) ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "La multiplication de 12 par 2, moins 12, donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ (5 × 4) + 3 ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation: "La division de 100 par 20, plus 3, donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 + 2 ?",
    options: ["21", "22", "23"],
    answer: "23",
    explanation: "La multiplication de 7 par 3, plus 2, donne 23.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (8 ÷ 2) ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "La division de 8 par 2, soustraite de 14, donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "3 × 4 ÷ 2 = ?",
    options: ["6", "12", "8"],
    answer: "6",
    explanation: "3 multiplié par 4 donne 12, divisé par 2 donne 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 ÷ 3 + 4 = ?",
    options: ["5", "7", "6"],
    answer: "7",
    explanation: "15 divisé par 3 est 5, plus 4 donne 7.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(12 - 4) × 2 = ?",
    options: ["16", "14", "12"],
    answer: "16",
    explanation: "12 moins 4 est 8, multiplié par 2 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 + 4) ÷ 2 = ?",
    options: ["6", "8", "7"],
    answer: "6",
    explanation: "La somme de 8 et 4 est 12, divisé par 2 donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 ÷ 6) + (5 × 2) = ?",
    options: ["8", "10", "9"],
    answer: "8",
    explanation:
        "18 divisé par 6 est 3, 5 multiplié par 2 est 10, 3 plus 10 donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - 5) ÷ (3 - 1) = ?",
    options: ["7", "10", "8"],
    answer: "7",
    explanation: "20 moins 5 est 15, 3 moins 1 est 2, 15 divisé par 2 donne 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 × 5) - (2 × 3) + 1 = ?",
    options: ["23", "21", "22"],
    answer: "21",
    explanation:
        "4 multiplié par 5 est 20, 2 multiplié par 3 est 6, 20 moins 6 plus 1 donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) × (3 + 1) = ?",
    options: ["32", "28", "30"],
    answer: "32",
    explanation:
        "10 moins 2 est 8, 3 plus 1 est 4, 8 multiplié par 4 donne 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(30 ÷ 5) + (4 × 6) = ?",
    options: ["34", "36", "32"],
    answer: "34",
    explanation:
        "30 divisé par 5 est 6, 4 multiplié par 6 est 24, 6 plus 24 donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(50 ÷ 5) + (15 - 10) = ?",
    options: ["13", "10", "12"],
    answer: "13",
    explanation:
        "50 divisé par 5 est 10, 15 moins 10 est 5, 10 plus 5 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - 7 + 4 = ?",
    options: ["12", "10", "9"],
    answer: "12",
    explanation: "15 - 7 = 8, puis 8 + 4 = 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "9 × 2 - 10 = ?",
    options: ["8", "7", "6"],
    answer: "8",
    explanation: "9 × 2 = 18, puis 18 - 10 = 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "18 ÷ 3 + 7 = ?",
    options: ["4", "5", "11"],
    answer: "11",
    explanation: "18 ÷ 3 = 6, puis 6 + 7 = 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - 4) ÷ 4 = ?",
    options: ["4", "5", "6"],
    answer: "4",
    explanation: "20 - 4 = 16, puis 16 ÷ 4 = 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 + 2) × 3 - 6 = ?",
    options: ["24", "30", "18"],
    answer: "30",
    explanation: "(10 + 2) = 12, puis 12 × 3 = 36, ensuite 36 - 6 = 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 × 3) + (4 ÷ 2) = ?",
    options: ["19", "20", "21"],
    answer: "20",
    explanation: "6 × 3 = 18, puis 4 ÷ 2 = 2, ensuite 18 + 2 = 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 + 4) × (2 - 1) = ?",
    options: ["12", "15", "16"],
    answer: "12",
    explanation: "(8 + 4) = 12, puis (2 - 1) = 1, ensuite 12 × 1 = 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(7 + 5) - (3 × 2) = ?",
    options: ["9", "8", "7"],
    answer: "8",
    explanation: "(7 + 5) = 12, puis (3 × 2) = 6, ensuite 12 - 6 = 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 9 × 2 - 5 ?",
    options: ["13", "10", "11"],
    answer: "13",
    explanation: "On multiplie 9 par 2, puis on soustrait 5, ce qui donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait (10 ÷ 2) + (4 × 3) ?",
    options: ["20", "18", "16"],
    answer: "20",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses puis on additionne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (2 × 20) + 10 ?",
    options: ["20", "30", "10"],
    answer: "20",
    explanation:
        "On effectue d'abord la multiplication puis les additions et soustractions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait (5 + 3) × (2 - 1) ?",
    options: ["8", "6", "10"],
    answer: "8",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses puis on multiplie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) ÷ 2 + 5 ?",
    options: ["10", "8", "9"],
    answer: "10",
    explanation:
        "On effectue d'abord l'addition dans les parenthèses, puis la division et enfin l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 100 ÷ (5 × 2) ?",
    options: ["10", "5", "20"],
    answer: "10",
    explanation: "On effectue d'abord la multiplication puis la division.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - 10 + 5 ?",
    options: ["25", "20", "15"],
    answer: "25",
    explanation: "On soustrait 10 de 30 puis on ajoute 5, ce qui donne 25.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 4) x 2 ?",
    options: ["14", "12", "10"],
    answer: "14",
    explanation: "La somme de 3 et 4, multipliée par 2, donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (6 x 5) ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation: "La soustraction de 30 à 50 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 x (5 + 3) - 10 ?",
    options: ["22", "26", "18"],
    answer: "22",
    explanation: "La multiplication donne 32, moins 10 donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 x 3 + 4 ?",
    options: ["25", "26", "27"],
    answer: "25",
    explanation: "La multiplication donne 21, additionné à 4 donne 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 x (5 + 5) - 6 ?",
    options: ["14", "12", "16"],
    answer: "14",
    explanation: "La multiplication donne 20, moins 6 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (2 × 5) ?",
    options: ["8", "10", "12"],
    answer: "8",
    explanation: "La soustraction de 10 (2 fois 5) à 18 donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 4 - (2 + 6) ?",
    options: ["20", "22", "18"],
    answer: "20",
    explanation: "La multiplication de 6 par 4, moins 8, est 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (5 - 3) + 9 ?",
    options: ["24", "21", "15"],
    answer: "24",
    explanation: "La division de 30 par 2, plus 9, donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 4 × 2 ?",
    options: ["14", "10", "16"],
    answer: "14",
    explanation: "La somme de 5 et 8 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 5 + 2 ?",
    options: ["16", "17", "18"],
    answer: "17",
    explanation: "20 moins 5 plus 2 est égal à 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (3 + 6) - 4 ?",
    options: ["10", "12", "14"],
    answer: "14",
    explanation: "Deux fois la somme de 3 et 6 moins 4 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + (8 × 2) - 5 ?",
    options: ["14", "15", "16"],
    answer: "14",
    explanation: "La somme de 7 et 16 moins 5 est égale à 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 3) × (6 ÷ 2) ?",
    options: ["12", "15", "18"],
    answer: "18",
    explanation: "La différence de 9 et 3 multipliée par 3 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 7 + 3 ?",
    options: ["12", "13", "14"],
    answer: "14",
    explanation: "18 moins 7 plus 3 est égal à 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 3 ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation: "50 divisé par 5 donne 10, puis on ajoute 0.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + (6 ÷ 2) × 3 ?",
    options: ["18", "20", "22"],
    answer: "20",
    explanation:
        "On effectue d'abord la division, puis la multiplication et enfin l'addition, soit 10 + 9 = 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 5) × (10 - 6) ?",
    options: ["32", "36", "40"],
    answer: "32",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses, soit 8 × 4 = 32.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (2 + 3) ?",
    options: ["30", "40", "50"],
    answer: "40",
    explanation: "On additionne d'abord : 2 + 3 = 5, puis 8 × 5 = 40.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 2 + 6 ?",
    options: ["14", "16", "12"],
    answer: "14",
    explanation:
        "On effectue d'abord la multiplication : 4 × 2 = 8, puis 8 + 6 = 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ 4 + 10 ?",
    options: ["25", "30", "20"],
    answer: "30",
    explanation: "100 divisé par 4 plus 10 est 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2 × 3) ÷ 2 ?",
    options: ["5", "6", "8"],
    answer: "5",
    explanation: "La somme de 6 et 2 multiplié par 3, divisé par 2 est 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (4 × 5) + 10 ?",
    options: ["20", "25", "15"],
    answer: "20",
    explanation: "30 moins 4 multiplié par 5 plus 10 est 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - 8 + 3 ?",
    options: ["10", "9", "8"],
    answer: "10",
    explanation: "15 - 8 + 3 égale 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 × 2 - 6 ?",
    options: ["24", "18", "20"],
    answer: "18",
    explanation: "12 multiplié par 2 moins 6 égale 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 2 + 3 ?",
    options: ["10", "9", "11"],
    answer: "9",
    explanation: "(8 + 4) divisé par 2 plus 3 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 - 2) × 5 + 3 ?",
    options: ["23", "20", "22"],
    answer: "23",
    explanation: "(6 - 2) multiplié par 5 plus 3 donne 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 ÷ 4) + (6 × 2) ?",
    options: ["15", "18", "12"],
    answer: "18",
    explanation:
        "La division donne 3, la multiplication donne 12, leur somme est 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 48 ÷ 6 + 4 × 3 ?",
    options: ["20", "16", "24"],
    answer: "16",
    explanation:
        "La division donne 8, la multiplication donne 12, leur somme est 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 5 - (4 ÷ 2) ?",
    options: ["13", "12", "10"],
    answer: "13",
    explanation:
        "La multiplication donne 15, la division donne 2, leur différence est 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 25 - 9 ?",
    options: ["14", "16", "15"],
    answer: "16",
    explanation: "25 moins 9 donne 16.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 15 + 20 - 10.",
    options: ["25", "30", "35"],
    answer: "25",
    explanation: "15 plus 20 moins 10 donne 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 18 ÷ 2 + 7 ?",
    options: ["10", "11", "12"],
    answer: "12",
    explanation: "18 divisé par 2 est 9, et 9 plus 7 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez (6 + 4) × 2.",
    options: ["20", "18", "22"],
    answer: "20",
    explanation: "La somme de 6 et 4 est 10, multiplié par 2 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 50 - (3 × 10) + 5.",
    options: ["35", "40", "45"],
    answer: "35",
    explanation: "3 multiplié par 10 est 30, 50 moins 30 plus 5 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 12) ÷ 4 ?",
    options: ["5", "6", "4"],
    answer: "5",
    explanation: "La somme de 8 et 12 est 20, divisé par 4 donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 2 × (3 + 5) - 4.",
    options: ["10", "12", "8"],
    answer: "12",
    explanation: "3 plus 5 est 8, multiplié par 2 donne 16, moins 4 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 45 - (5 × 4) + 3.",
    options: ["23", "20", "18"],
    answer: "18",
    explanation: "5 multiplié par 4 est 20, 45 moins 20 plus 3 donne 28.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 8 × 2 ?",
    options: ["32", "28", "20"],
    answer: "28",
    explanation: "8 multiplié par 2 est 16, 12 plus 16 donne 28.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (5 × 4) + 2 ?",
    options: ["12", "18", "22"],
    answer: "18",
    explanation: "30 moins (5 multiplié par 4) plus 2 égale 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 5 - 3 ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "4 multiplié par 5 moins 3 égale 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 + 16 - 10 ?",
    options: ["20", "18", "22"],
    answer: "20",
    explanation: "La somme de 14 et 16, moins 10, est 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (12 ÷ 3) ?",
    options: ["46", "44", "48"],
    answer: "48",
    explanation: "La soustraction de 50 par 4 (12 divisé par 3) donne 48.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 2 - 5 + 3 ?",
    options: ["12", "14", "10"],
    answer: "12",
    explanation: "Le calcul donne 14 (7 fois 2), moins 5, plus 3, soit 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 5 + 10 ÷ 2 ?",
    options: ["24", "20", "22"],
    answer: "24",
    explanation: "Le produit de 4 et 5, plus 5 (10 divisé par 2), donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + (6 ÷ 2) × 3 ?",
    options: ["18", "24", "20"],
    answer: "24",
    explanation: "Le calcul donne 12 plus 9 (3 fois 3), soit 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (6 × 3) + 9 ?",
    options: ["21", "24", "27"],
    answer: "21",
    explanation: "Le calcul donne 30 moins 18, plus 9, soit 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 4 + 6 ?",
    options: ["22", "18", "20"],
    answer: "22",
    explanation: "La soustraction de 4 à 20, ajoutée à 6, donne 22.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (3 × 4) + 2 ?",
    options: ["15", "16", "14"],
    answer: "15",
    explanation:
        "La soustraction du produit de 3 et 4 à 25, ajoutée à 2, donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 × 2 - (3 + 2) ?",
    options: ["15", "16", "18"],
    answer: "16",
    explanation:
        "La multiplication de 10 par 2, moins la somme de 3 et 2, donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (30 ÷ 5) + (10 - 4) ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation:
        "La division de 30 par 5 ajoutée à la différence de 10 et 4 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 x 5 - 3 ?",
    options: ["22", "20", "18"],
    answer: "22",
    explanation: "5 multiplié par 5 donne 25, moins 3 égale 22.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (25 + 25) ?",
    options: ["50", "60", "70"],
    answer: "50",
    explanation: "100 moins 50 (25 plus 25) donne 50.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ 3 + 4 ?",
    options: ["8", "6", "10"],
    answer: "8",
    explanation: "12 divisé par 3 donne 4, plus 4 égale 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 3) ÷ 3 + 2 ?",
    options: ["6", "5", "4"],
    answer: "6",
    explanation: "12 divisé par 3 est 4, plus 2 égale 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 x 3 - (6 ÷ 2) ?",
    options: ["19", "21", "17"],
    answer: "19",
    explanation: "21 moins 3 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 ÷ 4) x (2 + 3) ?",
    options: ["25", "30", "20"],
    answer: "25",
    explanation: "5 multiplié par 5 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 - (12 ÷ 4) x 3 ?",
    options: ["30", "24", "18"],
    answer: "30",
    explanation: "36 moins 9 donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 12 - 4.",
    options: ["7", "9", "8"],
    answer: "8",
    explanation: "12 moins 4 donne 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 15 + 10 - 5.",
    options: ["20", "25", "30"],
    answer: "20",
    explanation: "15 plus 10 moins 5 donne 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez (8 + 4) ÷ 4.",
    options: ["3", "2", "4"],
    answer: "3",
    explanation: "La somme de 8 et 4, divisée par 4, donne 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 5 × 5 + 10.",
    options: ["35", "25", "30"],
    answer: "35",
    explanation: "5 multiplié par 5 plus 10 donne 35.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 7 × 3 - (5 + 2) ?",
    options: ["16", "17", "14"],
    answer: "16",
    explanation:
        "La multiplication de 7 par 3 moins la somme de 5 et 2 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ (2 × 3) ?",
    options: ["6", "9", "12"],
    answer: "6",
    explanation: "36 divisé par 6 (qui est 2 fois 3) donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez (10 + 2) × 3 - 4.",
    options: ["26", "32", "30"],
    answer: "32",
    explanation: "La somme de 10 et 2 multipliée par 3 moins 4 donne 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 8 × 4 - (12 ÷ 3).",
    options: ["28", "30", "26"],
    answer: "28",
    explanation: "32 moins 4 (qui est 12 divisé par 3) donne 28.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (8 + 2) ?",
    options: ["42", "40", "38"],
    answer: "40",
    explanation: "50 moins la somme de 8 et 2 égale 40.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 4 - 6 ?",
    options: ["30", "24", "27"],
    answer: "30",
    explanation: "9 multiplié par 4 moins 6 égale 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (1 + 2) - 6 ?",
    options: ["18", "20", "16"],
    answer: "18",
    explanation: "8 multiplié par la somme de 1 et 2 moins 6 égale 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 5) ÷ 2 × 4 ?",
    options: ["20", "15", "10"],
    answer: "20",
    explanation: "La somme de 5 et 5 divisée par 2 multipliée par 4 égale 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 × 3) + (4 ÷ 2) ?",
    options: ["20", "22", "18"],
    answer: "20",
    explanation: "6 multiplié par 3 plus 4 divisé par 2 égale 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question:
        "Si tu as 20 pommes et que tu en donnes 5, combien t'en reste-t-il ?",
    options: ["15", "10", "25"],
    answer: "15",
    explanation: "Il reste 15 pommes après avoir donné 5 pommes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 12 + 15 - 5 ?",
    options: ["22", "20", "25"],
    answer: "22",
    explanation:
        "On additionne 12 et 15, puis on soustrait 5, ce qui donne 22.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (6 + 4) - 5 ?",
    options: ["15", "10", "20"],
    answer: "15",
    explanation:
        "On additionne 6 et 4, on multiplie par 2, puis on soustrait 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 2 - 3 × 4 ?",
    options: ["2", "4", "0"],
    answer: "0",
    explanation:
        "On effectue d'abord les multiplications, puis on soustrait les résultats.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (2 + 3) + 4 ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation:
        "On additionne d'abord 2 et 3, puis on divise 30 par 5 et on ajoute 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 3 - 5 + 2 ?",
    options: ["24", "20", "22"],
    answer: "24",
    explanation:
        "On effectue d'abord la multiplication, puis on soustrait et ajoute les résultats.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - (3 × 2) + 5 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "La multiplication donne 6, 12 moins 6 plus 5 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) ÷ 2 + 3 ?",
    options: ["8", "7", "6"],
    answer: "8",
    explanation:
        "On effectue d'abord (10 + 2) = 12, puis 12 ÷ 2 = 6, et enfin 6 + 3 = 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 2) + (8 ÷ 4) ?",
    options: ["12", "10", "9"],
    answer: "12",
    explanation:
        "On effectue d'abord les multiplications et divisions, donc 10 + 2 = 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 4 - 2 ?",
    options: ["11", "12", "10"],
    answer: "11",
    explanation:
        "En ajoutant 9 et 4 puis en soustrayant 2, le résultat est 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 1 - 3 ?",
    options: ["5", "6", "7"],
    answer: "5",
    explanation:
        "La multiplication donne 8, et en soustrayant 3, on obtient 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 + 2 × 4 ?",
    options: ["11", "10", "12"],
    answer: "11",
    explanation:
        "On effectue d'abord la multiplication : 2 × 4 = 8, puis 3 + 8 = 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 15 - (3 + 2) ?",
    options: ["10", "9", "11"],
    answer: "10",
    explanation:
        "On effectue d'abord l'opération entre parenthèses : 3 + 2 = 5, puis 15 - 5 = 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - 3 + 2 × 4 ?",
    options: ["14", "10", "8"],
    answer: "14",
    explanation:
        "On effectue d'abord la multiplication : 2 × 4 = 8, puis 9 - 3 + 8 = 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (8 + 4) ÷ 4 ?",
    options: ["3", "2", "4"],
    answer: "3",
    explanation:
        "On effectue d'abord l'opération entre parenthèses : 8 + 4 = 12, puis 12 ÷ 4 = 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 25 - (5 × 3) + 4 ?",
    options: ["16", "18", "14"],
    answer: "16",
    explanation:
        "On effectue d'abord la multiplication : 5 × 3 = 15, puis 25 - 15 + 4 = 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 3 - 4 ?",
    options: ["14", "15", "16"],
    answer: "14",
    explanation: "6 multiplié par 3 donne 18, moins 4 fait 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (18 ÷ 2) + (6 × 3) ?",
    options: ["20", "21", "22"],
    answer: "21",
    explanation:
        "18 divisé par 2 est 9, et 6 multiplié par 3 est 18, donc 9 plus 18 donne 27.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 60 ÷ 5 + 2 ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation: "60 divisé par 5 est 12, donc 12 plus 2 donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (3 + 6) ?",
    options: ["9", "10", "11"],
    answer: "9",
    explanation: "18 moins la somme de 3 et 6 est 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (2 × 20) + 5 ?",
    options: ["5", "15", "25"],
    answer: "5",
    explanation: "50 moins 40 plus 5 donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ (5 - 2) + 10 ?",
    options: ["15", "20", "25"],
    answer: "20",
    explanation: "25 divisé par 3, puis ajouté à 10 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 3 - 10 ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "La multiplication de 9 par 3, moins 10, est 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 15 - 7 ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "15 moins 7 égalent 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (6 + 4) × 2 ?",
    options: ["20", "18", "22"],
    answer: "20",
    explanation: "La somme de 6 et 4 multipliée par 2 égalent 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 12 ÷ (4 - 2) ?",
    options: ["4", "6", "8"],
    answer: "6",
    explanation: "12 divisé par 2 (4 moins 2) égalent 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - 3 + 2 ?",
    options: ["9", "8", "7"],
    answer: "9",
    explanation: "10 moins 3 plus 2 égalent 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 3 × (4 + 2) - 5 ?",
    options: ["15", "10", "12"],
    answer: "15",
    explanation: "3 multiplié par 6 moins 5 égalent 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (2 × 4) + 3 ?",
    options: ["9", "8", "10"],
    answer: "9",
    explanation: "14 moins 8 plus 3 égalent 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (3 + 5) × 2 - 6 ?",
    options: ["10", "14", "8"],
    answer: "10",
    explanation: "8 multiplié par 2 moins 6 égalent 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 - 2) × 4 + 1 ?",
    options: ["18", "20", "16"],
    answer: "18",
    explanation: "5 multiplié par 4 plus 1 égalent 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "2 + 3 × 4 = ?",
    options: ["14", "20", "18"],
    answer: "14",
    explanation:
        "On effectue d'abord la multiplication : 3 × 4 = 12, puis on additionne : 2 + 12 = 14.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "6 ÷ 2 + 1 = ?",
    options: ["4", "5", "3"],
    answer: "4",
    explanation:
        "On divise d'abord 6 par 2 pour obtenir 3, puis on ajoute 1, ce qui donne 4.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 - 3 × 2 = ?",
    options: ["2", "4", "6"],
    answer: "2",
    explanation:
        "On effectue d'abord la multiplication : 3 × 2 = 6, puis on soustrait : 8 - 6 = 2.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 × 3) + (6 ÷ 2) = ?",
    options: ["14", "16", "12"],
    answer: "14",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses : 4 × 3 = 12 et 6 ÷ 2 = 3, puis on additionne : 12 + 3 = 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "12 ÷ (3 + 1) - 2 = ?",
    options: ["0", "1", "2"],
    answer: "1",
    explanation:
        "On effectue d'abord l'opération dans les parenthèses : 3 + 1 = 4, puis on divise 12 par 4 pour obtenir 3, puis on soustrait 2, ce qui donne 1.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - 4) ÷ 4 + 2 = ?",
    options: ["4", "6", "8"],
    answer: "6",
    explanation:
        "On effectue d'abord la soustraction : 20 - 4 = 16, puis on divise par 4 pour obtenir 4, et enfin on ajoute 2, ce qui donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 × 2) - (3 × 2) = ?",
    options: ["10", "14", "8"],
    answer: "10",
    explanation:
        "On effectue d'abord les multiplications : 8 × 2 = 16 et 3 × 2 = 6, puis on soustrait : 16 - 6 = 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 + 2) × (10 - 6) ÷ 2 = ?",
    options: ["16", "8", "12"],
    answer: "16",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses : 6 + 2 = 8 et 10 - 6 = 4, puis on multiplie : 8 × 4 = 32, et enfin on divise par 2, ce qui donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 - 6) ÷ (3 + 3) × 2 = ?",
    options: ["4", "6", "5"],
    answer: "4",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses : 18 - 6 = 12 et 3 + 3 = 6, puis on divise 12 par 6 pour obtenir 2, et enfin on multiplie par 2, ce qui donne 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(30 ÷ 5) + (10 - 4) × 2 = ?",
    options: ["10", "16", "14"],
    answer: "14",
    explanation:
        "On effectue d'abord les opérations : 30 ÷ 5 = 6 et 10 - 4 = 6, puis on multiplie : 6 × 2 = 12, enfin on additionne 6 + 12 = 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × (5 + 3) ?",
    options: ["48", "56", "64"],
    answer: "64",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses : 10 - 2 = 8 et 5 + 3 = 8, puis 8 × 8 = 64.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 + 3) ÷ 3 ?",
    options: ["3", "4", "5"],
    answer: "4",
    explanation:
        "On effectue d'abord l'addition : 9 + 3 = 12, puis 12 ÷ 3 = 4.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 ÷ 2 + 3 ?",
    options: ["5", "6", "7"],
    answer: "5",
    explanation: "On effectue d'abord la division : 8 ÷ 2 = 4, puis 4 + 3 = 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 3) × 2 + 4 ?",
    options: ["14", "16", "10"],
    answer: "14",
    explanation:
        "On commence par 8 - 3 = 5, puis 5 × 2 = 10, enfin 10 + 4 = 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × 3 - (4 ÷ 2) ?",
    options: ["16", "17", "18"],
    answer: "17",
    explanation:
        "On effectue d'abord 4 ÷ 2 = 2, puis 6 × 3 = 18, enfin 18 - 2 = 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + 9 - 4 ?",
    options: ["10", "11", "12"],
    answer: "10",
    explanation: "La somme de 5 et 9 moins 4 donne 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 6 ÷ 3 ?",
    options: ["12", "15", "10"],
    answer: "12",
    explanation: "On divise d'abord 6 par 3, puis on additionne : 9 + 2 = 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ (2 + 4) × 3 ?",
    options: ["9", "6", "12"],
    answer: "9",
    explanation:
        "On effectue d'abord l'addition : 2 + 4 = 6, puis 18 ÷ 6 × 3 = 3 × 3 = 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 6) ÷ 2 + 5 ?",
    options: ["8", "9", "7"],
    answer: "9",
    explanation:
        "On effectue d'abord l'addition : 4 + 6 = 10, puis 10 ÷ 2 + 5 = 5 + 5 = 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × 3 + 4 × 5 ?",
    options: ["26", "32", "20"],
    answer: "26",
    explanation:
        "On effectue d'abord les multiplications : 2 × 3 = 6 et 4 × 5 = 20, puis 6 + 20 = 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ 5 + 3 ?",
    options: ["23", "20", "25"],
    answer: "23",
    explanation:
        "On divise d'abord 100 par 5 : 100 ÷ 5 = 20, puis 20 + 3 = 23.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (6 ÷ 2) ?",
    options: ["16", "18", "14"],
    answer: "18",
    explanation: "La division de 6 par 2, soustraite de 20, donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 5) × 2 + 3 ?",
    options: ["23", "25", "27"],
    answer: "25",
    explanation:
        "La soustraction de 5 à 15, multipliée par 2 et ajoutée à 3, donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 4 - (5 × 2) ?",
    options: ["20", "22", "24"],
    answer: "22",
    explanation: "La multiplication de 7 par 4, moins 10, donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (3 + 3) + 2 ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation:
        "La division de 30 par la somme de 3 et 3, ajoutée à 2, donne 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 9 × 2 ?",
    options: ["18", "17", "19"],
    answer: "18",
    explanation: "Multiplier 9 par 2 donne 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 20 ÷ 4 + 3 ?",
    options: ["5", "8", "7"],
    answer: "8",
    explanation: "Diviser 20 par 4 donne 5, puis ajouter 3 donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (4 + 5) × 2 ?",
    options: ["18", "9", "20"],
    answer: "18",
    explanation: "Additionner 4 et 5 donne 9, puis multiplier par 2 donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (3 × 5) + 2 ?",
    options: ["12", "10", "15"],
    answer: "12",
    explanation: "Multiplier 3 par 5 donne 15, 25 moins 15 plus 2 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (10 ÷ 2) + (3 × 4) ?",
    options: ["20", "18", "22"],
    answer: "20",
    explanation:
        "Diviser 10 par 2 donne 5, multiplier 3 par 4 donne 12, et 5 plus 12 donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × 3 - 4 ?",
    options: ["22", "20", "18"],
    answer: "20",
    explanation:
        "Additionner 6 et 2 donne 8, multiplier par 3 donne 24, puis soustraire 4 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 8 × 3 - (5 + 3) ?",
    options: ["22", "20", "24"],
    answer: "20",
    explanation:
        "Multiplier 8 par 3 donne 24, additionner 5 et 3 donne 8, et 24 moins 8 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (6 ÷ 3) × 2 ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation:
        "Diviser 6 par 3 donne 2, multiplier par 2 donne 4, et 14 moins 4 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (5 + 7) × (2 - 1) ?",
    options: ["12", "15", "10"],
    answer: "12",
    explanation: "Additionner 5 et 7 donne 12, et multiplier par 1 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 + 14 ?",
    options: ["39", "40", "41"],
    answer: "39",
    explanation: "25 plus 14 égale 39.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 - 19 ?",
    options: ["15", "16", "17"],
    answer: "17",
    explanation: "36 moins 19 égale 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) ÷ 2 ?",
    options: ["3", "4", "5"],
    answer: "4",
    explanation: "La somme de 6 et 2 divisé par 2 égale 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - 7 × 5 ?",
    options: ["15", "20", "25"],
    answer: "15",
    explanation: "50 moins 35 (7 fois 5) égale 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (6 + 4) × 2 ?",
    options: ["10", "5", "0"],
    answer: "10",
    explanation: "30 moins 20 (somme de 6 et 4 multipliée par 2) égale 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 + (6 ÷ 3) × 4 ?",
    options: ["16", "18", "20"],
    answer: "18",
    explanation: "14 plus 8 (6 divisé par 3 multiplié par 4) donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 - (9 × 4) + 3 ?",
    options: ["6", "9", "12"],
    answer: "6",
    explanation: "45 moins 36 (9 multiplié par 4) plus 3 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 27 ÷ 3 + 8 - 4 ?",
    options: ["5", "9", "11"],
    answer: "9",
    explanation: "27 divisé par 3 plus 8 moins 4 égale 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - 3 + 2 ?",
    options: ["7", "8", "9"],
    answer: "8",
    explanation: "Soustraire 3 de 9 donne 6, ajouter 2 donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 - 3) × 5 = ?",
    options: ["25", "30", "35"],
    answer: "30",
    explanation: "La soustraction de 3 à 9 donne 6, multiplié par 5 donne 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 ÷ 2) + (3 × 4) = ?",
    options: ["15", "18", "21"],
    answer: "21",
    explanation:
        "La division donne 9 et la multiplication 12, 9 + 12 égale 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 + 2) × (3 - 1) = ?",
    options: ["12", "16", "8"],
    answer: "16",
    explanation:
        "La somme donne 8 et la soustraction 2, 8 multiplié par 2 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 3) + (12 ÷ 4) - 2 = ?",
    options: ["15", "16", "17"],
    answer: "16",
    explanation:
        "La multiplication donne 15, la division 3, et 15 + 3 - 2 égale 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 ÷ 4) × (2 + 1) = ?",
    options: ["10", "15", "20"],
    answer: "15",
    explanation:
        "La division donne 5, la somme 3, et 5 multiplié par 3 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(14 - 2) × (3 + 1) = ?",
    options: ["48", "52", "56"],
    answer: "48",
    explanation:
        "La soustraction donne 12, la somme 4, et 12 multiplié par 4 donne 48.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(30 ÷ 5) + (3 × 6) = ?",
    options: ["18", "24", "30"],
    answer: "24",
    explanation:
        "La division donne 6 et la multiplication 18, 6 + 18 égale 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 + 4) ÷ (2 + 2) = ?",
    options: ["3", "4", "5"],
    answer: "3",
    explanation:
        "La somme donne 12, et la somme des dénominateurs 4, 12 divisé par 4 donne 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(16 - 8) × (2 + 1) = ?",
    options: ["16", "24", "32"],
    answer: "24",
    explanation:
        "La soustraction donne 8, la somme 3, et 8 multiplié par 3 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ 5 + 10 ?",
    options: ["20", "30", "25"],
    answer: "30",
    explanation: "On divise 100 par 5 puis on ajoute 10, ce qui donne 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 2 + (6 × 3) ?",
    options: ["24", "30", "36"],
    answer: "24",
    explanation:
        "On divise 30 par 2 puis on additionne le produit de 6 et 3 pour obtenir 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 3) + (14 ÷ 2) ?",
    options: ["25", "26", "27"],
    answer: "26",
    explanation:
        "On multiplie 5 par 3 et additionne le résultat de 14 divisé par 2 pour obtenir 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (3 + 5) - 10 ?",
    options: ["22", "18", "26"],
    answer: "18",
    explanation:
        "On effectue d'abord l'addition puis la multiplication, ensuite on soustrait 10 pour obtenir 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 7 × 2 ?",
    options: ["26", "28", "22"],
    answer: "26",
    explanation:
        "On effectue la division et la multiplication avant d'additionner pour obtenir 26.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 ÷ 2) + (6 × 2) ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses, puis on additionne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + (9 - 3) × 2 ?",
    options: ["10", "14", "12"],
    answer: "14",
    explanation:
        "On effectue d'abord l'opération dans les parenthèses, puis la multiplication et l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 5 × (2 + 3) ?",
    options: ["0", "5", "10"],
    answer: "0",
    explanation:
        "On effectue d'abord l'addition dans les parenthèses, puis la multiplication et la soustraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 5 - 2 × 3 ?",
    options: ["14", "16", "18"],
    answer: "14",
    explanation: "4 fois 5 moins 2 fois 3 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) ÷ 2 × 3 ?",
    options: ["18", "12", "6"],
    answer: "18",
    explanation:
        "La somme de 10 et 2 divisée par 2, puis multipliée par 3 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 2 + 10 ÷ 2 ?",
    options: ["22", "23", "24"],
    answer: "22",
    explanation: "La multiplication de 7 par 2 plus 10 divisé par 2 donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ 5 + 15 ?",
    options: ["20", "25", "30"],
    answer: "25",
    explanation: "50 divisé par 5 plus 15 donne 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 ÷ 4) + (3 × 2) ?",
    options: ["5", "6", "7"],
    answer: "7",
    explanation: "La somme des résultats des deux opérations donne 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 2 - 10 ÷ 5 ?",
    options: ["14", "15", "16"],
    answer: "14",
    explanation: "Le calcul donne 14 après avoir suivi l'ordre des opérations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 ÷ 9 + 6 ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation: "La division de 45 par 9 ajoutée à 6 donne 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (5 + 5) × 2 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation:
        "Le calcul aboutit à 10 après avoir effectué les opérations dans l'ordre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 3) × 2 + 4 ?",
    options: ["26", "28", "30"],
    answer: "26",
    explanation:
        "On soustrait 3 de 15, multiplie par 2 et ajoute 4, ce qui donne 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 - 2 × 10 ?",
    options: ["20", "30", "10"],
    answer: "20",
    explanation:
        "On multiplie 2 par 10 puis on soustrait le résultat de 40, ce qui donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (2 + 3) × (6 - 1) ?",
    options: ["25", "30", "35"],
    answer: "25",
    explanation:
        "On additionne 2 et 3, soustrait 1 de 6 et multiplie les résultats, ce qui donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 9 × 2 ?",
    options: ["18", "16", "20"],
    answer: "18",
    explanation: "9 multiplié par 2 donne 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait (6 + 2) × 2 ?",
    options: ["14", "12", "16"],
    answer: "16",
    explanation: "(6 + 2) multiplié par 2 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 8 × (2 + 1) ?",
    options: ["24", "20", "28"],
    answer: "24",
    explanation: "8 multiplié par (2 + 1) donne 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (6 ÷ 2) ?",
    options: ["16", "15", "17"],
    answer: "16",
    explanation: "18 moins (6 divisé par 2) donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait (10 - 3) × (4 + 2) ?",
    options: ["42", "36", "48"],
    answer: "42",
    explanation: "(10 - 3) multiplié par (4 + 2) donne 42.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 7 × 3 - 5 ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation: "7 multiplié par 3 moins 5 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait (8 + 4) - (2 × 3) ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "(8 + 4) moins (2 multiplié par 3) donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - 6 ÷ 2 ?",
    options: ["27", "28", "29"],
    answer: "27",
    explanation: "30 moins (6 divisé par 2) donne 27.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 30 - 12 ?",
    options: ["18", "19", "17"],
    answer: "18",
    explanation: "30 moins 12 donne 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Que donne 48 ÷ 6 ?",
    options: ["8", "9", "7"],
    answer: "8",
    explanation: "48 divisé par 6 donne 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 14 x 3 - 10 ?",
    options: ["32", "32", "34"],
    answer: "32",
    explanation: "14 multiplié par 3 est 42, moins 10 égale 32.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 100 - (25 + 25) ÷ 5.",
    options: ["90", "80", "85"],
    answer: "90",
    explanation: "100 moins (25 plus 25 divisé par 5) est 90.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 12 + 4 × 3 - 6 ÷ 2.",
    options: ["22", "20", "18"],
    answer: "22",
    explanation: "12 plus 4 multiplié par 3 moins 6 divisé par 2 donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 60 ÷ 4 + 10 ?",
    options: ["25", "15", "20"],
    answer: "25",
    explanation: "60 divisé par 4 est 15, plus 10 donne 25.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 21 - 7 + 3 ?",
    options: ["16", "17", "15"],
    answer: "17",
    explanation: "21 moins 7 plus 3 égale 17.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez 18 ÷ 2 + 9.",
    options: ["18", "12", "15"],
    answer: "18",
    explanation: "18 divisé par 2 est 9, plus 9 donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 8 × 2 + 4 ÷ 2 ?",
    options: ["18", "16", "14"],
    answer: "18",
    explanation: "8 multiplié par 2 est 16, plus 4 divisé par 2 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - 2 + 5 ?",
    options: ["10", "12", "11"],
    answer: "12",
    explanation: "Il faut d'abord faire la soustraction puis l'addition.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 48 ÷ 6 + 2 × 3 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation:
        "On suit l'ordre des opérations : d'abord la division, puis l'addition et la multiplication.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 5 - 10 ÷ 2 ?",
    options: ["20", "15", "25"],
    answer: "20",
    explanation:
        "On suit l'ordre des opérations : multiplication, puis division, puis soustraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 4 + 6 - 2 ?",
    options: ["16", "14", "12"],
    answer: "14",
    explanation:
        "On suit l'ordre des opérations : multiplication, puis addition, puis soustraction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + 6 ÷ 2 ?",
    options: ["3", "6", "9"],
    answer: "9",
    explanation: "On effectue d'abord la division avant l'addition.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) × 2 - 8 ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation: "12 multiplié par 2, moins 8, donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 21 - 3 × 3 ?",
    options: ["12", "15", "18"],
    answer: "12",
    explanation: "9 soustrait de 21 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez : 15 + 6 - 3.",
    options: ["17", "18", "19"],
    answer: "18",
    explanation: "La somme de 15 et 6, moins 3, est 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez : 18 - (2 × 3).",
    options: ["12", "15", "18"],
    answer: "12",
    explanation: "2 multiplié par 3 est 6, donc 18 moins 6 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (4 + 2) ?",
    options: ["30", "40", "42"],
    answer: "42",
    explanation: "La somme de 4 et 2 est 6, multiplié par 7 donne 42.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez : (10 - 2) × 3 + 4.",
    options: ["28", "30", "34"],
    answer: "34",
    explanation:
        "D'abord, 10 moins 2 est 8, multiplié par 3 donne 24, plus 4 fait 34.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez : 50 ÷ (5 + 5).",
    options: ["2", "4", "5"],
    answer: "5",
    explanation: "La somme de 5 et 5 est 10, donc 50 divisé par 10 donne 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculez : 9 + 3 × (2 + 1).",
    options: ["12", "15", "18"],
    answer: "18",
    explanation:
        "D'abord, 2 plus 1 est 3, multiplié par 3 donne 9, et 9 plus 9 fait 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 3 + 4 ?",
    options: ["10", "14", "18"],
    answer: "14",
    explanation: "30 divisé par 3 est 10, et 10 plus 4 donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 + 4 - 5 ?",
    options: ["15", "16", "17"],
    answer: "17",
    explanation: "La somme de 18 et 4, moins 5, est 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 3) + (7 - 2) ?",
    options: ["20", "15", "18"],
    answer: "18",
    explanation: "Le produit de 5 et 3, plus la différence de 7 et 2, est 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + (6 ÷ 2) × 3 ?",
    options: ["18", "21", "24"],
    answer: "21",
    explanation: "La somme de 9 et le produit de 3 et 3 donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (3 × 2) + 1 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "La différence de 14 et 6, plus 1, donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 4 + 2 ?",
    options: ["20", "22", "24"],
    answer: "22",
    explanation: "Le produit de 5 et 4, plus 2, est 22.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 15 - 7 ?",
    options: ["6", "8", "7"],
    answer: "8",
    explanation: "15 moins 7 donne 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 13 ?",
    options: ["22", "21", "20"],
    answer: "22",
    explanation: "La somme de 9 et 13 est 22.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 9 + 3 ?",
    options: ["19", "17", "18"],
    answer: "19",
    explanation: "25 moins 9 plus 3 donne 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 18 ÷ 2 + 7 ?",
    options: ["16", "15", "14"],
    answer: "16",
    explanation: "18 divisé par 2 plus 7 donne 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 48 ÷ 6 × 4 ?",
    options: ["32", "28", "36"],
    answer: "32",
    explanation: "48 divisé par 6 puis multiplié par 4 donne 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (3 × 20) + 5 ?",
    options: ["45", "35", "55"],
    answer: "55",
    explanation: "100 moins 60 plus 5 donne 55.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 6) × 3 - 8 ?",
    options: ["46", "42", "44"],
    answer: "42",
    explanation: "La somme de 10 et 6 multipliée par 3 puis moins 8 donne 42.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (30 ÷ 5) × (2 + 3) ?",
    options: ["30", "25", "35"],
    answer: "30",
    explanation:
        "30 divisé par 5 puis multiplié par la somme de 2 et 3 donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 75 - (5 × 7) + 10 ?",
    options: ["60", "65", "70"],
    answer: "60",
    explanation: "75 moins 35 plus 10 donne 60.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (50 - 10) ÷ 2 + 15 ?",
    options: ["30", "25", "20"],
    answer: "25",
    explanation: "40 divisé par 2 plus 15 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ (5 - 2) + 10 ?",
    options: ["15", "20", "25"],
    answer: "15",
    explanation:
        "On effectue d'abord la soustraction puis la division et additionne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 3) + (6 ÷ 2) ?",
    options: ["16", "17", "18"],
    answer: "17",
    explanation:
        "On effectue d'abord les multiplications et divisions, puis on additionne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (8 + 2) × 3 ?",
    options: ["30", "20", "10"],
    answer: "20",
    explanation:
        "On additionne 8 et 2, on multiplie par 3, puis on soustrait de 50, ce qui donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (3 + 1) - 8 ÷ 2 ?",
    options: ["20", "22", "24"],
    answer: "22",
    explanation:
        "On effectue les opérations dans les parenthèses et on suit l'ordre, ce qui donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × (5 - 3) ?",
    options: ["10", "12", "16"],
    answer: "16",
    explanation:
        "On effectue les soustractions dans les parenthèses, puis on multiplie les résultats, ce qui donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 10 - 3 ?",
    options: ["10", "12", "13"],
    answer: "12",
    explanation:
        "On divise en premier, puis on additionne et on soustrait, ce qui donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) ÷ 2 + 3 ?",
    options: ["7", "8", "9"],
    answer: "8",
    explanation: "La somme de 6 et 4 divisée par 2, plus 3, est 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (4 + 3) ?",
    options: ["10", "12", "14"],
    answer: "14",
    explanation: "La multiplication de 2 par la somme de 4 et 3 est 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 ÷ 3 + 4 ?",
    options: ["5", "6", "7"],
    answer: "7",
    explanation: "La division de 9 par 3, ajoutée à 4, donne 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 4) × 3 + 2 ?",
    options: ["18", "20", "22"],
    answer: "20",
    explanation: "La multiplication de 6 par 3, ajoutée à 2, est 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (5 + 7) - 6 ?",
    options: ["24", "26", "30"],
    answer: "24",
    explanation: "La multiplication de 12 par 3, moins 6, est 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ 4 + 5 ?",
    options: ["9", "11", "14"],
    answer: "14",
    explanation: "La division de 36 par 4, ajoutée à 5, donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) ÷ 4 + 1 ?",
    options: ["3", "4", "5"],
    answer: "4",
    explanation: "La somme de 12, divisée par 4, plus 1, est 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "12 - 4 ÷ 2 = ?",
    options: ["10", "8", "6"],
    answer: "10",
    explanation: "On effectue d'abord la division, puis la soustraction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) × 4 = ?",
    options: ["32", "28", "24"],
    answer: "32",
    explanation: "On effectue d'abord la soustraction, puis la multiplication.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 × (2 + 2) - 4 = ?",
    options: ["28", "32", "24"],
    answer: "28",
    explanation:
        "On effectue d'abord l'addition, puis la multiplication, puis la soustraction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - 8) ÷ 4 + 3 = ?",
    options: ["5", "7", "6"],
    answer: "7",
    explanation:
        "On effectue d'abord la soustraction, puis la division, puis l'addition.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(3 × 5) + (2 × 4) = ?",
    options: ["27", "26", "23"],
    answer: "27",
    explanation: "On effectue d'abord les multiplications, puis l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 ÷ 3) + (9 - 5) × 2 = ?",
    options: ["12", "14", "10"],
    answer: "12",
    explanation:
        "On effectue d'abord la division, puis la soustraction, puis la multiplication, puis l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 × (3 + 1) - 6 = ?",
    options: ["22", "26", "20"],
    answer: "22",
    explanation:
        "On effectue d'abord l'addition, puis la multiplication, puis la soustraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 + 6) × (10 ÷ 2) = ?",
    options: ["60", "40", "80"],
    answer: "60",
    explanation:
        "On effectue d'abord l'addition et la division, puis la multiplication.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(25 - 5) ÷ 4 + 3 × 2 = ?",
    options: ["13", "15", "12"],
    answer: "13",
    explanation:
        "On effectue d'abord la soustraction, puis la division, puis les multiplications, puis l'addition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(12 ÷ 4) × (6 - 2) = ?",
    options: ["12", "8", "6"],
    answer: "12",
    explanation:
        "On effectue d'abord la division et la soustraction, puis la multiplication.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - (3 × 2) + 1 ?",
    options: ["6", "7", "5"],
    answer: "7",
    explanation: "10 moins 6 (produit de 3 et 2) plus 1 égale 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - (7 - 2) × 2 ?",
    options: ["9", "8", "7"],
    answer: "9",
    explanation: "15 moins 10 (produit de 5 et 2) égale 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 3 - 5 + 2 ?",
    options: ["9", "10", "11"],
    answer: "9",
    explanation: "12 (produit de 4 et 3) moins 5 plus 2 égale 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - (6 + 4) ?",
    options: ["3", "4", "5"],
    answer: "5",
    explanation: "La somme de 6 et 4 est 10, donc 15 - 10 = 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (2 + 4) - 6 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation:
        "La somme de 2 et 4 est 6, multiplié par 3 donne 18, moins 6 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 6) × (3 - 2) ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation:
        "La somme de 4 et 6 est 10, la différence de 3 et 2 est 1, donc 10 × 1 = 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + (8 ÷ 4) × 2 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation:
        "La division donne 2, multiplié par 2 donne 4, donc 7 + 4 = 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 3) × (5 + 2) ?",
    options: ["49", "50", "51"],
    answer: "49",
    explanation:
        "La différence de 10 et 3 est 7, la somme de 5 et 2 est 7, donc 7 × 7 = 49.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 3 × (2 + 1) ?",
    options: ["20", "21", "22"],
    answer: "21",
    explanation: "La somme de 2 et 1 est 3, donc 3 × 3 = 9, donc 25 - 9 = 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 5 + (6 ÷ 2) ?",
    options: ["21", "22", "23"],
    answer: "21",
    explanation:
        "Multiplier 3 par 5 puis ajouter 3 (le résultat de 6 ÷ 2) donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 - (3 × 5) = ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation:
        "Trois multiplié par cinq est quinze, et vingt moins quinze donne cinq.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 × 3) + (10 ÷ 2) = ?",
    options: ["14", "16", "18"],
    answer: "16",
    explanation: "Douze plus cinq donne seize.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(15 - 3) ÷ (2 + 1) = ?",
    options: ["4", "5", "6"],
    answer: "4",
    explanation: "Douze divisé par trois donne quatre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 + 3) × 2 - 6 = ?",
    options: ["10", "14", "16"],
    answer: "10",
    explanation: "Huit multiplié par deux est seize, moins six donne dix.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 × 4) ÷ 3 + 1 = ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "Treize est le résultat de douze plus un.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 - 2) × (5 - 3) = ?",
    options: ["8", "10", "12"],
    answer: "12",
    explanation: "Six multiplié par deux donne douze.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(7 + 1) × 2 - 4 = ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "Huit multiplié par deux est seize, moins quatre donne dix.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (4 - 2) ?",
    options: ["12", "8", "10"],
    answer: "12",
    explanation: "La soustraction de 4 et 2 est 2, multipliée par 6 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 + 2 × (5 - 3) ?",
    options: ["12", "14", "10"],
    answer: "12",
    explanation:
        "La soustraction de 5 et 3 est 2, multipliée par 2 et ajoutée à 10 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 15 ÷ 3 ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation: "La division donne 5, et 9 plus 5 donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ 3 + 5 ?",
    options: ["8", "9", "7"],
    answer: "9",
    explanation: "24 divisé par 3 plus 5 donne 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 + 2 × (4 - 1) ?",
    options: ["12", "10", "14"],
    answer: "12",
    explanation: "6 plus 2 multiplié par (4 - 1) donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - (2 × 5) + 3 ?",
    options: ["8", "10", "6"],
    answer: "8",
    explanation: "15 moins (2 multiplié par 5) plus 3 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ 4 + 5 × 2 ?",
    options: ["14", "16", "12"],
    answer: "14",
    explanation: "12 divisé par 4 plus 5 multiplié par 2 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 ÷ 4) + (3 × 2) = ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation:
        "20 divisé par 4 donne 5, et 3 multiplié par 2 donne 6, puis on additionne 5 et 6 pour obtenir 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 - 6) ÷ 2 + 4 = ?",
    options: ["7", "8", "9"],
    answer: "8",
    explanation:
        "18 moins 6 est 12, divisé par 2 donne 6, puis on ajoute 4 pour obtenir 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(3 × 4) - (2 × 3) = ?",
    options: ["6", "7", "8"],
    answer: "6",
    explanation:
        "3 multiplié par 4 est 12, 2 multiplié par 3 est 6, donc 12 moins 6 donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 + 3) × 2 - 4 = ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation:
        "5 plus 3 est 8, multiplié par 2 donne 16, puis on soustrait 4 pour obtenir 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 ÷ 2) + (5 × 3) = ?",
    options: ["20", "22", "25"],
    answer: "22",
    explanation:
        "10 divisé par 2 donne 5, 5 multiplié par 3 donne 15, puis on additionne pour obtenir 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 × 3) + (8 ÷ 2) = ?",
    options: ["16", "18", "20"],
    answer: "18",
    explanation:
        "4 multiplié par 3 est 12, 8 divisé par 2 est 4, donc 12 plus 4 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 5 + 10 ?",
    options: ["30", "29", "31"],
    answer: "30",
    explanation: "En soustrayant 5 de 25 puis en ajoutant 10, on obtient 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (4 + 6) - 5 ?",
    options: ["15", "20", "25"],
    answer: "15",
    explanation:
        "En ajoutant 4 et 6, multipliant par 2, puis soustrayant 5, on obtient 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - 10 ?",
    options: ["11", "12", "13"],
    answer: "11",
    explanation: "La multiplication de 7 par 3, moins 10, donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - 4) × 3 = ?",
    options: ["48", "50", "56"],
    answer: "48",
    explanation: "20 moins 4 donne 16, et 16 multiplié par 3 donne 48.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(3 + 5) × (10 - 6) = ?",
    options: ["32", "28", "24"],
    answer: "32",
    explanation:
        "La somme de 3 et 5 est 8, et la différence de 10 et 6 est 4, donc 8 multiplié par 4 donne 32.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(16 ÷ 4) + (5 × 3) = ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation:
        "16 divisé par 4 donne 4, et 5 multiplié par 3 donne 15, donc 4 plus 15 donne 19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(7 × 3) - (10 ÷ 2) = ?",
    options: ["18", "19", "20"],
    answer: "18",
    explanation:
        "7 multiplié par 3 donne 21, et 10 divisé par 2 donne 5, donc 21 moins 5 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 + 3) × (2 + 2) = ?",
    options: ["28", "32", "36"],
    answer: "32",
    explanation:
        "La somme de 5 et 3 est 8, et la somme de 2 et 2 est 4, donc 8 multiplié par 4 donne 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(12 - 4) × (2 + 1) = ?",
    options: ["20", "24", "28"],
    answer: "24",
    explanation:
        "12 moins 4 donne 8, et 2 plus 1 donne 3, donc 8 multiplié par 3 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 + 1) ÷ (3 - 1) = ?",
    options: ["5", "4", "6"],
    answer: "5",
    explanation:
        "La somme de 9 et 1 est 10, et la différence de 3 et 1 est 2, donc 10 divisé par 2 donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(15 ÷ 3) + (6 × 2) = ?",
    options: ["20", "21", "22"],
    answer: "21",
    explanation:
        "15 divisé par 3 donne 5, et 6 multiplié par 2 donne 12, donc 5 plus 12 donne 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 - (4 × 3) + 2 = ?",
    options: ["10", "12", "14"],
    answer: "14",
    explanation:
        "4 multiplié par 3 donne 12, donc 20 moins 12 plus 2 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 ÷ 2) + (5 × 2) = ?",
    options: ["16", "17", "18"],
    answer: "17",
    explanation:
        "18 divisé par 2 donne 9, et 5 multiplié par 2 donne 10, donc 9 plus 10 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 7 + 5 ?",
    options: ["11", "12", "13"],
    answer: "12",
    explanation: "L'addition de 7 et 5 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le produit de 4 × 6 ?",
    options: ["24", "20", "22"],
    answer: "24",
    explanation: "Multiplier 4 par 6 donne 24.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 36 ÷ 6 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation: "Diviser 36 par 6 donne 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 4 + 2 ?",
    options: ["16", "18", "15"],
    answer: "18",
    explanation: "Effectuer 20 moins 4 puis ajouter 2 donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 100 - (20 ÷ 4) ?",
    options: ["95", "90", "85"],
    answer: "95",
    explanation: "Diviser 20 par 4 puis soustraire de 100 donne 95.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 5) × (2 + 3) ?",
    options: ["25", "30", "35"],
    answer: "25",
    explanation:
        "Soustraire 5 de 10 puis multiplier par la somme de 2 et 3 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (6 + 2) - 10 ?",
    options: ["20", "18", "22"],
    answer: "18",
    explanation:
        "Multiplier 3 par la somme de 6 et 2 puis soustraire 10 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (3 + 2) - 5 ?",
    options: ["20", "25", "15"],
    answer: "20",
    explanation:
        "Multiplier 5 par la somme de 3 et 2 puis soustraire 5 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 4 × 3 ?",
    options: ["10", "11", "12"],
    answer: "12",
    explanation: "4 multiplié par 3 donne 12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 15 + 9 - 3 ?",
    options: ["21", "22", "23"],
    answer: "21",
    explanation: "15 plus 9 moins 3 donne 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - 3 × 4 ?",
    options: ["38", "40", "42"],
    answer: "38",
    explanation: "50 moins 12 (3 fois 4) est égal à 38.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de (8 + 4) ÷ 4 ?",
    options: ["2", "3", "4"],
    answer: "3",
    explanation: "12 divisé par 4 donne 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait (5 + 15) ÷ 4 ?",
    options: ["3", "5", "6"],
    answer: "5",
    explanation: "20 divisé par 4 est égal à 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 18 ÷ 3 + 2 × 4 ?",
    options: ["10", "11", "12"],
    answer: "10",
    explanation: "6 plus 8 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 × 2) - (3 + 1) ?",
    options: ["8", "9", "10"],
    answer: "10",
    explanation: "12 moins 2 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 9 - (2 × 3) + 5 ?",
    options: ["7", "8", "9"],
    answer: "8",
    explanation: "9 moins 6 plus 5 donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 12 ÷ 4 + 3 × 2 ?",
    options: ["6", "7", "8"],
    answer: "8",
    explanation: "3 plus 6 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) × 3 - 5 ?",
    options: ["29", "30", "31"],
    answer: "31",
    explanation: "36 moins 5 donne 31.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) x (4 + 2) ?",
    options: ["48", "50", "52"],
    answer: "48",
    explanation: "8 multiplié par 6 égale 48.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 ÷ (2 x 5) ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation: "50 divisé par 10 égale 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 3) x (6 - 4) ?",
    options: ["6", "8", "10"],
    answer: "10",
    explanation: "5 multiplié par 2 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 x 4 + 4 - 4 ?",
    options: ["12", "16", "20"],
    answer: "16",
    explanation: "16 est le résultat final après les opérations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 4 - 3 ?",
    options: ["15", "17", "20"],
    answer: "17",
    explanation: "20 moins 3 donne 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - (3 × 2) + 1 ?",
    options: ["5", "6", "7"],
    answer: "7",
    explanation: "6 plus 1 donne 7.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "12 ÷ 4 + 2 = ?",
    options: ["2", "4", "6"],
    answer: "4",
    explanation: "On divise 12 par 4, puis on ajoute 2.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "3 × 4 - 5 = ?",
    options: ["7", "12", "9"],
    answer: "7",
    explanation: "On multiplie 3 par 4, puis on soustrait 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) × 3 + 4 = ?",
    options: ["28", "26", "30"],
    answer: "28",
    explanation: "On soustrait 2 de 10, multiplie par 3, puis on ajoute 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 × (2 + 3) - 8 = ?",
    options: ["27", "35", "32"],
    answer: "27",
    explanation: "On additionne 2 et 3, multiplie par 7, puis on soustrait 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 - 3) × (4 + 2) ÷ 3 = ?",
    options: ["12", "8", "6"],
    answer: "12",
    explanation:
        "On soustrait 3 de 9, additionne 4 et 2, puis on divise le produit par 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "5 × (3 + 5) - 10 ÷ 2 = ?",
    options: ["38", "34", "30"],
    answer: "34",
    explanation:
        "On additionne 3 et 5, multiplie par 5, puis soustrait 10 divisé par 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 ÷ 4) + (5 × 3) = ?",
    options: ["20", "15", "10"],
    answer: "20",
    explanation: "On divise 20 par 4, puis on ajoute le produit de 5 et 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(15 - 5) × (2 + 1) = ?",
    options: ["30", "20", "25"],
    answer: "30",
    explanation: "On soustrait 5 de 15, puis on multiplie par 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 + 2) ÷ (3 - 1) × 5 = ?",
    options: ["25", "20", "30"],
    answer: "25",
    explanation:
        "On additionne 8 et 2, puis on divise par 2, et finalement on multiplie par 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(24 ÷ 6) + (5 × 4) = ?",
    options: ["26", "28", "22"],
    answer: "26",
    explanation: "On divise 24 par 6, puis on ajoute le produit de 5 et 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 ÷ 3) + (2 × 4) ?",
    options: ["10", "12", "9"],
    answer: "10",
    explanation: "La division de 15 par 3 plus 8 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (4 × 3) + 2 ?",
    options: ["10", "14", "12"],
    answer: "10",
    explanation: "La soustraction de 12 à 20 plus 2 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) × 2 - 4 ?",
    options: ["10", "14", "12"],
    answer: "12",
    explanation: "La multiplication de 8 par 2 moins 4 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 × (2 + 3) - 5 ?",
    options: ["45", "40", "35"],
    answer: "40",
    explanation: "10 multiplié par (2 + 3) moins 5 égale 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 × 2) + (3 × 4) ?",
    options: ["30", "24", "26"],
    answer: "30",
    explanation: "(6 multiplié par 2) plus (3 multiplié par 4) égale 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 3) × (5 + 1) ?",
    options: ["30", "25", "35"],
    answer: "30",
    explanation: "(8 - 3) multiplié par (5 + 1) égale 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 × 5) + (3 × 2) ?",
    options: ["26", "28", "30"],
    answer: "26",
    explanation: "Multiplier 4 par 5 et 3 par 2 puis additionner donne 26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 6 + 4 ?",
    options: ["6", "8", "10"],
    answer: "8",
    explanation: "Diviser 30 par 6 puis ajouter 4 donne 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ 6 + 5 ?",
    options: ["7", "8", "6"],
    answer: "7",
    explanation: "On commence par la division puis on additionne 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 ÷ 5 + 3 × 2 ?",
    options: ["15", "18", "16"],
    answer: "16",
    explanation:
        "On effectue la division et la multiplication avant d'additionner.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (6 × 7) + 4 ?",
    options: ["28", "30", "32"],
    answer: "28",
    explanation: "On effectue d'abord la multiplication dans les parenthèses.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 3 ÷ 2 ?",
    options: ["12", "10", "14"],
    answer: "12",
    explanation: "On effectue la multiplication puis la division.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ (6 ÷ 3) ?",
    options: ["6", "9", "12"],
    answer: "9",
    explanation: "18 divisé par 2 (6 divisé par 3) donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 × 4) + (6 ÷ 2) ?",
    options: ["20", "22", "24"],
    answer: "22",
    explanation: "20 plus 3 donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - 4 ?",
    options: ["17", "20", "19"],
    answer: "17",
    explanation: "7 multiplié par 3 moins 4 égale 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 2 + 1 ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "(10 - 2) multiplié par 2 plus 1 égale 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (18 ÷ 3) + (2 × 4) ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "(18 divisé par 3) plus (2 multiplié par 4) égale 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (6 ÷ 2) + 3 ?",
    options: ["11", "12", "13"],
    answer: "11",
    explanation: "14 moins (6 divisé par 2) plus 3 égale 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ (5 - 2) + 5 ?",
    options: ["10", "15", "20"],
    answer: "15",
    explanation: "25 divisé par (5 - 2) plus 5 égale 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 × 3 - 10 = ?",
    options: ["11", "21", "17"],
    answer: "11",
    explanation: "On multiplie 7 par 3 puis on soustrait 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 + 5) ÷ (3 - 1) = ?",
    options: ["7", "15", "5"],
    answer: "7",
    explanation: "On additionne 10 et 5 puis on divise par 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 × 2) + (3 × 3) - 5 = ?",
    options: ["16", "15", "14"],
    answer: "16",
    explanation:
        "On effectue les multiplications puis on additionne et soustrait.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(25 - 5) ÷ 4 + 3 = ?",
    options: ["8", "10", "7"],
    answer: "8",
    explanation: "On soustrait 5 de 25, divise par 4 et ajoute 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(30 ÷ 5) - (2 × 3) = ?",
    options: ["0", "3", "6"],
    answer: "0",
    explanation: "On divise 30 par 5 puis on soustrait le produit de 2 et 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "4 × (3 + 5) - 10 = ?",
    options: ["22", "26", "18"],
    answer: "22",
    explanation: "On additionne 3 et 5, multiplie par 4 et soustrait 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(50 ÷ 5) + (6 × 2) = ?",
    options: ["22", "20", "28"],
    answer: "22",
    explanation: "On divise 50 par 5 puis on additionne le produit de 6 et 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(12 - 4) ÷ 2 + 10 = ?",
    options: ["8", "10", "6"],
    answer: "10",
    explanation: "On soustrait 4 de 12, divise par 2 et ajoute 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (6 + 2) ?",
    options: ["32", "24", "28"],
    answer: "32",
    explanation: "4 multiplié par 8 donne 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (16 ÷ 2) + (6 × 3) ?",
    options: ["28", "26", "24"],
    answer: "28",
    explanation: "8 plus 18 donne 28.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 + 4) - (2 × 3) ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "12 moins 6 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 18 ÷ 2 ?",
    options: ["7", "8", "9"],
    answer: "9",
    explanation: "En divisant 18 par 2, on obtient 9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 20 - 3 × 2 ?",
    options: ["14", "16", "18"],
    answer: "14",
    explanation: "On effectue d'abord la multiplication, donc 20 - 6 = 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (10 - 2) × (3 + 1) ?",
    options: ["28", "32", "36"],
    answer: "32",
    explanation: "10 - 2 = 8 et 3 + 1 = 4, donc 8 × 4 = 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ (3 - 1) + 5 ?",
    options: ["11", "12", "13"],
    answer: "11",
    explanation: "12 ÷ 2 = 6, puis 6 + 5 = 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 25 - (10 ÷ 2) ?",
    options: ["22", "23", "24"],
    answer: "22",
    explanation: "10 ÷ 2 = 5, donc 25 - 5 = 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 3 × (2 + 1) ?",
    options: ["9", "12", "15"],
    answer: "9",
    explanation: "2 + 1 = 3, donc 3 × 3 = 9, donc 18 - 9 = 9.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "18 ÷ 3 + 5 = ?",
    options: ["9", "11", "13"],
    answer: "11",
    explanation: "18 divisé par 3 donne 6, puis ajouter 5 donne 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "6 + 2 × (3 - 1) = ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation: "3 moins 1 donne 2, multiplié par 2 et ajouté à 6 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "5 × (4 + 2) - 10 = ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation:
        "4 plus 2 donne 6, multiplié par 5 donne 30, puis soustraire 10 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "2 × (3 + 5) - 4 × 2 = ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation:
        "3 plus 5 donne 8, multiplié par 2 donne 16, puis soustraire 8 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 - 3) × 2 + 1 = ?",
    options: ["11", "12", "13"],
    answer: "11",
    explanation:
        "8 moins 3 donne 5, multiplié par 2 donne 10, puis ajouter 1 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "14 ÷ 2 + (6 - 4) × 3 = ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation:
        "14 divisé par 2 donne 7, 6 moins 4 donne 2, multiplié par 3 donne 6, puis ajouter 7 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "3 × (5 + 2) - 4 × (1 + 2) = ?",
    options: ["9", "10", "11"],
    answer: "9",
    explanation:
        "5 plus 2 donne 7, multiplié par 3 donne 21, 1 plus 2 donne 3, multiplié par 4 donne 12, puis 21 moins 12 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "10 + 5 × (2 - 1) = ?",
    options: ["12", "15", "17"],
    answer: "15",
    explanation:
        "2 moins 1 donne 1, multiplié par 5 donne 5, puis ajouter 10 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (5 - 1) ?",
    options: ["16", "20", "24"],
    answer: "16",
    explanation: "Il faut d'abord soustraire 1 de 5, puis multiplier par 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ (2 + 3) × 4 ?",
    options: ["16", "12", "8"],
    answer: "16",
    explanation:
        "Il faut d'abord additionner 2 et 3, puis diviser 20 par le résultat, puis multiplier par 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 ÷ 4) + (5 × 3) ?",
    options: ["15", "16", "17"],
    answer: "15",
    explanation:
        "Il faut d'abord diviser 20 par 4, puis multiplier 5 par 3 et additionner les résultats.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Si tu as 12 pommes et que tu en donnes 4, combien en as-tu ?",
    options: ["9", "8", "7"],
    answer: "8",
    explanation: "Il reste 12 - 4 = 8 pommes après en avoir donné 4.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le produit de 7 × 3 ?",
    options: ["20", "21", "22"],
    answer: "21",
    explanation: "7 multiplié par 3 donne 21.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien fait 3 × (4 + 2) ?",
    options: ["18", "24", "21"],
    answer: "18",
    explanation: "3 fois la somme de 4 et 2 donne 3 × 6 = 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (18 ÷ 2) + (12 ÷ 3) ?",
    options: ["12", "10", "14"],
    answer: "12",
    explanation: "18 ÷ 2 = 9 et 12 ÷ 3 = 4, donc 9 + 4 = 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 + 5) × 2 - 6 ?",
    options: ["10", "12", "14"],
    answer: "14",
    explanation: "(7 + 5) = 12, puis 12 × 2 - 6 = 24 - 6 = 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (2 × 15) + 5 ?",
    options: ["25", "20", "30"],
    answer: "20",
    explanation: "50 - 30 + 5 = 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (9 - 3) × (5 + 2) ?",
    options: ["42", "36", "48"],
    answer: "42",
    explanation: "(6) × (7) = 42.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 6) ÷ 2 + 5 ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation: "(10) ÷ 2 + 5 = 5 + 5 = 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 5) ÷ (2 + 3) ?",
    options: ["3", "4", "5"],
    answer: "3",
    explanation:
        "La somme de 10 et 5 donne 15, et la somme de 2 et 3 donne 5, donc 15 divisé par 5 égale 3.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 ÷ 2) + (4 × 3) ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation:
        "La division de 6 par 2 donne 3, et la multiplication de 4 par 3 donne 12, donc 3 plus 12 égale 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 15 - 9 ?",
    options: ["4", "5", "6"],
    answer: "6",
    explanation: "En soustrayant 9 de 15, on obtient 6.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la somme de 8 + 15 ?",
    options: ["22", "23", "24"],
    answer: "23",
    explanation: "En additionnant 8 et 15, on obtient 23.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 9 ?",
    options: ["27", "26", "28"],
    answer: "27",
    explanation: "La multiplication de 3 par 9 donne 27.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 12 ÷ 4 + 3 ?",
    options: ["6", "5", "4"],
    answer: "6",
    explanation: "On divise 12 par 4 puis on ajoute 3, ce qui donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 5 × (2 + 6) - 10 ?",
    options: ["30", "25", "20"],
    answer: "30",
    explanation:
        "On additionne 2 et 6, multiplie par 5, puis soustrait 10 pour obtenir 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 ÷ 5 + (3 × 4) ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation: "On divise 45 par 5 et on ajoute 12, ce qui donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (8 + 2) × 4 ?",
    options: ["30", "20", "10"],
    answer: "10",
    explanation:
        "On additionne 8 et 2, multiplie par 4, puis soustrait de 50 pour obtenir 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 - 4) × (6 ÷ 2) ?",
    options: ["36", "32", "28"],
    answer: "32",
    explanation: "Le calcul donne 8 × 4, soit 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 ÷ 2) + (4 × 3) ?",
    options: ["20", "22", "24"],
    answer: "22",
    explanation: "Le calcul donne 5 + 12, soit 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × (2 + 3) ÷ 5 ?",
    options: ["4", "3", "2"],
    answer: "4",
    explanation: "4 multiplié par (2 + 3) divisé par 5 donne 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 ÷ 2) + (6 × 2) ?",
    options: ["18", "14", "16"],
    answer: "18",
    explanation: "(10 divisé par 2) plus (6 multiplié par 2) donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "4 + 3 - 2 = ?",
    options: ["5", "6", "7"],
    answer: "5",
    explanation: "La somme de 4 et 3 est 7, puis 7 moins 2 donne 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 ÷ 5 + 1 = ?",
    options: ["4", "3", "2"],
    answer: "4",
    explanation: "Diviser 15 par 5 donne 3, puis ajouter 1 donne 4.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(10 - 2) ÷ 2 + 3 = ?",
    options: ["3", "4", "5"],
    answer: "5",
    explanation:
        "Soustraire 2 de 10 donne 8, puis diviser 8 par 2 donne 4, et ajouter 3 donne 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 ÷ 3) + (2 × 2) = ?",
    options: ["10", "8", "12"],
    answer: "10",
    explanation:
        "Diviser 18 par 3 donne 6, multiplier 2 par 2 donne 4, et 6 plus 4 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 - 4) ÷ 4 + (3 × 2) = ?",
    options: ["9", "10", "11"],
    answer: "11",
    explanation:
        "Soustraire 4 de 20 donne 16, divisé par 4 donne 4, et 3 multiplié par 2 donne 6, donc 4 plus 6 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 3) - (10 ÷ 2) = ?",
    options: ["10", "12", "8"],
    answer: "8",
    explanation:
        "Multiplier 5 par 3 donne 15, divisé 10 par 2 donne 5, et 15 moins 5 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 + 3) × 2 - 10 = ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation:
        "La somme de 9 et 3 est 12, multiplié par 2 donne 24, puis soustraire 10 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(7 × 2) + (5 ÷ 5) = ?",
    options: ["15", "14", "16"],
    answer: "14",
    explanation:
        "Multiplier 7 par 2 donne 14, et 5 divisé par 5 donne 1, donc 14 plus 1 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(30 ÷ 5) + (4 × 3) = ?",
    options: ["24", "22", "26"],
    answer: "22",
    explanation:
        "Diviser 30 par 5 donne 6, multiplier 4 par 3 donne 12, donc 6 plus 12 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - 4 + 3 ?",
    options: ["9", "10", "11"],
    answer: "11",
    explanation: "12 moins 4 plus 3 est égal à 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (2 × 15) + 5 ?",
    options: ["25", "30", "35"],
    answer: "30",
    explanation: "50 moins 30 plus 5 donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (3 + 1) - 5 ?",
    options: ["23", "24", "25"],
    answer: "24",
    explanation: "7 multiplié par 4 est 28, moins 5 donne 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (5 + 4) - 7 ?",
    options: ["20", "22", "23"],
    answer: "20",
    explanation: "27 moins 7 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ (2 × 5) ?",
    options: ["5", "10", "20"],
    answer: "10",
    explanation: "100 divisé par 10 (2 fois 5) donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (6 × 5) + 2 ?",
    options: ["22", "20", "18"],
    answer: "20",
    explanation: "50 moins 30, plus 2 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 + 3) × (10 ÷ 2) ?",
    options: ["50", "60", "40"],
    answer: "50",
    explanation: "La somme de 7 et 3 est 10, multipliée par 5 donne 50.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 2 + 8 ?",
    options: ["23", "20", "18"],
    answer: "23",
    explanation: "30 divisé par 2 donne 15, plus 8 égale 23.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × 3 + 10 ÷ 2 ?",
    options: ["15", "14", "16"],
    answer: "14",
    explanation: "2 fois 3 est 6, plus 5 donne 14.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 8 - 3 ?",
    options: ["14", "15", "16"],
    answer: "14",
    explanation: "En ajoutant 9 et 8, puis en soustrayant 3, on obtient 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 3) × 4 ?",
    options: ["28", "30", "24"],
    answer: "28",
    explanation:
        "D'abord, on soustrait 3 de 10 pour obtenir 7, puis on multiplie par 4 pour obtenir 28.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 6 × (3 + 2) - 10 ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation:
        "On additionne d'abord dans les parenthèses, puis on multiplie par 6, et enfin on soustrait 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - (8 × 2) + 5 ?",
    options: ["19", "21", "22"],
    answer: "19",
    explanation:
        "On multiplie d'abord 8 par 2, puis on soustrait le résultat de 30 et on ajoute 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 + 15 - 9 ?",
    options: ["18", "16", "15"],
    answer: "18",
    explanation: "On additionne 12 et 15, puis on soustrait 9 pour obtenir 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 7 + 4 ?",
    options: ["21", "25", "22"],
    answer: "25",
    explanation: "On multiplie 3 par 7, puis on ajoute 4 pour obtenir 25.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × 6 ?",
    options: ["54", "56", "52"],
    answer: "54",
    explanation: "9 multiplié par 6 donne 54.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - 37 ?",
    options: ["63", "67", "60"],
    answer: "63",
    explanation: "100 moins 37 donne 63.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question:
        "Si vous avez 45 pommes et que vous en donnez 15, combien vous reste-t-il ?",
    options: ["30", "25", "20"],
    answer: "30",
    explanation: "45 moins 15 donne 30.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 7 - 10 ?",
    options: ["46", "54", "50"],
    answer: "46",
    explanation: "8 multiplié par 7 donne 56, moins 10 donne 46.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 3) × 4 ?",
    options: ["32", "28", "30"],
    answer: "32",
    explanation: "La somme de 5 et 3 est 8, multiplié par 4 donne 32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 - 4) ÷ 2 + 10 ?",
    options: ["18", "14", "12"],
    answer: "18",
    explanation: "20 moins 4 donne 16, divisé par 2 donne 8, plus 10 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 - (5 × 6) ?",
    options: ["10", "20", "15"],
    answer: "10",
    explanation: "5 multiplié par 6 donne 30, 40 moins 30 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × 4 + 8 ÷ 4 ?",
    options: ["14", "16", "12"],
    answer: "14",
    explanation:
        "3 multiplié par 4 donne 12, 8 divisé par 4 donne 2, donc 12 plus 2 donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) × 3 - 5 ?",
    options: ["29", "30", "31"],
    answer: "29",
    explanation:
        "10 plus 2 donne 12, multiplié par 3 donne 36, moins 5 donne 31.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (3 + 4) - 6 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "2 multiplié par la somme de 3 et 4 moins 6 est 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 5) × (2 + 1) ?",
    options: ["25", "30", "35"],
    answer: "30",
    explanation:
        "La différence de 15 et 5 multipliée par la somme de 2 et 1 est 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 ÷ (4 × 5) ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation: "100 divisé par le produit de 4 et 5 est 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 6 - 3 × 2 ?",
    options: ["12", "15", "18"],
    answer: "12",
    explanation: "9 plus 6 moins 3 multiplié par 2 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 5 + 6 ?",
    options: ["26", "28", "30"],
    answer: "30",
    explanation: "4 multiplié par 5 plus 6 est 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 × 2 ÷ 2 = ?",
    options: ["7", "14", "3"],
    answer: "7",
    explanation: "Multiplier 7 par 2 donne 14, puis diviser par 2 donne 7.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "12 - 4 + 3 = ?",
    options: ["11", "10", "9"],
    answer: "11",
    explanation: "Soustraire 4 de 12 donne 8, puis ajouter 3 donne 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 + 4) × 2 = ?",
    options: ["24", "20", "16"],
    answer: "24",
    explanation: "La somme de 8 et 4 est 12, puis multiplier par 2 donne 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 + 3) ÷ 3 = ?",
    options: ["4", "3", "6"],
    answer: "4",
    explanation: "La somme de 9 et 3 est 12, puis diviser par 3 donne 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(16 - 4) ÷ 2 + 5 = ?",
    options: ["10", "8", "6"],
    answer: "10",
    explanation:
        "Soustraire 4 de 16 donne 12, diviser par 2 donne 6, puis ajouter 5 donne 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(3 × 5) + (2 × 6) - 4 = ?",
    options: ["26", "20", "22"],
    answer: "22",
    explanation:
        "Multiplier 3 par 5 donne 15 et 2 par 6 donne 12, puis 15 + 12 - 4 = 23.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "((10 - 2) × 3) ÷ 4 = ?",
    options: ["6", "8", "4"],
    answer: "6",
    explanation:
        "Soustraire 2 de 10 donne 8, multiplier par 3 donne 24, puis diviser par 4 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 ÷ 5) + (3 × 4) = ?",
    options: ["18", "16", "20"],
    answer: "16",
    explanation:
        "Diviser 20 par 5 donne 4, multiplier par 3 donne 12, puis 4 + 12 = 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 × 2) + (10 ÷ 2) = ?",
    options: ["10", "12", "8"],
    answer: "12",
    explanation:
        "Multiplier 4 par 2 donne 8, diviser 10 par 2 donne 5, puis 8 + 5 = 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 + 10) - (3 × 2) = ?",
    options: ["12", "8", "10"],
    answer: "8",
    explanation:
        "La somme de 5 et 10 est 15, multiplier 3 par 2 donne 6, puis 15 - 6 = 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) × (9 - 5) ?",
    options: ["40", "36", "32"],
    answer: "40",
    explanation: "La somme et la différence donnent 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 2 + 6 ÷ 3 ?",
    options: ["14", "16", "12"],
    answer: "16",
    explanation: "Le produit et la division donnent 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 × 5) - (6 ÷ 2) ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "Le produit moins le quotient donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 + (7 × 2) - 4 ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "Les opérations successives donnent 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 ÷ 3) + (2 × 5) ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation:
        "On calcule 12 ÷ 3 = 4 et 2 × 5 = 10, puis on additionne 4 + 10 = 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + (3 × 4) - 5 ?",
    options: ["12", "15", "14"],
    answer: "14",
    explanation: "On calcule d'abord 3 × 4 = 12, puis 7 + 12 - 5 = 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 2) × (6 ÷ 2) ?",
    options: ["24", "28", "20"],
    answer: "24",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses : 6 ÷ 2 = 3, puis (8 - 2) × 3 = 6 × 3 = 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - (3 × 5) + 4 ?",
    options: ["17", "18", "16"],
    answer: "18",
    explanation:
        "On effectue d'abord la multiplication : 3 × 5 = 15, puis 25 - 15 + 4 = 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (3 x 2) ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation:
        "On multiplie 3 par 2 puis on soustrait le résultat de 14, obtenant 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 2) x (4 - 2) ?",
    options: ["12", "14", "16"],
    answer: "16",
    explanation:
        "On additionne 6 et 2, puis on multiplie par la différence de 4 et 2, obtenant 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ 5 + 4 x 2 ?",
    options: ["8", "10", "12"],
    answer: "10",
    explanation:
        "On divise 20 par 5 puis on ajoute le produit de 4 et 2, ce qui donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 15 - (3 x 2) + 5 ?",
    options: ["12", "13", "14"],
    answer: "14",
    explanation:
        "On multiplie 3 par 2, on soustrait ce résultat de 15 et on ajoute 5, ce qui donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 4 - (3 + 1) ?",
    options: ["24", "25", "26"],
    answer: "24",
    explanation: "7 multiplié par 4 moins (3 + 1) égale 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ (3 + 3) + 5 ?",
    options: ["10", "8", "12"],
    answer: "8",
    explanation: "30 divisé par (3 + 3) plus 5 égale 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(8 × 2) + 4 - 6 = ?",
    options: ["10", "14", "12"],
    answer: "10",
    explanation: "Multipliez d'abord, ajoutez 4, puis soustrayez 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 + 3) × 2 - 4 = ?",
    options: ["14", "16", "10"],
    answer: "14",
    explanation: "Additionnez d'abord, multipliez par 2, puis soustrayez 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 + 6) × (3 - 2) = ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "Additionnez, puis multipliez par la différence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "25 ÷ 5 + 3 × 2 = ?",
    options: ["8", "10", "6"],
    answer: "10",
    explanation: "Divisez d'abord, puis ajoutez le produit de 3 et 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(6 + 2) × (5 - 3) + 1 = ?",
    options: ["9", "11", "10"],
    answer: "11",
    explanation:
        "Effectuez les opérations dans les parenthèses, puis multipliez et ajoutez 1.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(9 - 3) × (4 + 2) ÷ 3 = ?",
    options: ["8", "6", "10"],
    answer: "6",
    explanation: "Résolvez les parenthèses, multipliez, puis divisez.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 × 2 - 6 = ?",
    options: ["8", "10", "12"],
    answer: "8",
    explanation:
        "La multiplication de 7 par 2 donne 14, puis en soustrayant 6, on obtient 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "15 - 4 + 6 = ?",
    options: ["17", "19", "18"],
    answer: "17",
    explanation: "Soustraire 4 de 15 donne 11, puis ajouter 6 donne 17.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(20 ÷ 5) + (3 × 4) = ?",
    options: ["20", "22", "18"],
    answer: "22",
    explanation:
        "Diviser 20 par 5 donne 4, et 3 multiplié par 4 donne 12, leur somme est 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(4 + 8) ÷ 2 × 3 = ?",
    options: ["18", "12", "15"],
    answer: "18",
    explanation:
        "L'addition de 4 et 8 donne 12, divisé par 2 donne 6, multiplié par 3 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(12 - 4) × 3 + 6 = ?",
    options: ["30", "26", "28"],
    answer: "30",
    explanation:
        "Soustraire 4 de 12 donne 8, multiplié par 3 donne 24, puis ajouter 6 donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(18 ÷ 2) + (4 × 3) = ?",
    options: ["30", "24", "26"],
    answer: "30",
    explanation:
        "Diviser 18 par 2 donne 9, et 4 multiplié par 3 donne 12, leur somme est 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(5 × 2) + (6 ÷ 2) = ?",
    options: ["16", "14", "12"],
    answer: "16",
    explanation:
        "La multiplication de 5 par 2 donne 10, la division de 6 par 2 donne 3, leur somme est 13.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(2 + 3) × 4 - 2 = ?",
    options: ["18", "20", "16"],
    answer: "18",
    explanation:
        "L'addition de 2 et 3 donne 5, multiplié par 4 donne 20, puis soustraire 2 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (6 - 2) + 4 ?",
    options: ["16", "14", "12"],
    answer: "16",
    explanation: "La multiplication donne 12, ajoutée à 4 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (2 + 3) × 4 - 6 ?",
    options: ["14", "16", "12"],
    answer: "14",
    explanation: "La multiplication donne 20, soustraire 6 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - 12 ?",
    options: ["38", "37", "36"],
    answer: "38",
    explanation: "50 moins 12 est égal à 38.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 - 18 + 9 ?",
    options: ["36", "37", "38"],
    answer: "36",
    explanation: "45 moins 18 plus 9 égale 36.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 6) × 3 ?",
    options: ["30", "28", "32"],
    answer: "30",
    explanation: "La somme de 4 et 6 multipliée par 3 donne 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 72 ÷ (8 - 4) ?",
    options: ["18", "20", "22"],
    answer: "18",
    explanation: "72 divisé par 4 (8 moins 4) donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × (5 + 3) - 10 ?",
    options: ["42", "40", "38"],
    answer: "40",
    explanation: "7 multiplié par 8 moins 10 donne 40.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (15 × 5) ?",
    options: ["25", "20", "30"],
    answer: "25",
    explanation: "100 moins 75 (15 multiplié par 5) est 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (50 ÷ 2) + (3 × 10) ?",
    options: ["35", "40", "45"],
    answer: "40",
    explanation: "25 plus 30 donne 40.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 × 3 - (2 × 5) ?",
    options: ["37", "40", "35"],
    answer: "37",
    explanation: "42 moins 10 donne 37.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 + 8) ÷ 4 × 3 ?",
    options: ["15", "20", "18"],
    answer: "15",
    explanation: "20 divisé par 4 puis multiplié par 3 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 90 - (2 × 25) + 5 ?",
    options: ["45", "50", "55"],
    answer: "50",
    explanation: "90 moins 50 plus 5 donne 45.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 3 + 6 × 2 ?",
    options: ["24", "26", "22"],
    answer: "24",
    explanation: "10 plus 12 donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 60 ÷ (3 + 3) + 5 ?",
    options: ["15", "10", "20"],
    answer: "15",
    explanation: "60 divisé par 6 plus 5 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 6 × 3 - 5 ?",
    options: ["13", "15", "17"],
    answer: "13",
    explanation: "6 multiplié par 3 est 18, moins 5 égale 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 25 - (4 × 3) ?",
    options: ["13", "16", "19"],
    answer: "13",
    explanation: "4 multiplié par 3 est 12, 25 moins 12 égale 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 18 - 3 × 4 ?",
    options: ["6", "9", "12"],
    answer: "6",
    explanation: "3 multiplié par 4 est 12, 18 moins 12 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (10 - 2) × 3 + 4 ?",
    options: ["26", "28", "30"],
    answer: "28",
    explanation: "10 moins 2 est 8, multiplié par 3 donne 24, plus 4 égale 28.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 30 - (2 × 10) + 5 ?",
    options: ["15", "20", "25"],
    answer: "15",
    explanation: "2 multiplié par 10 est 20, 30 moins 20 plus 5 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 50 - (10 ÷ 2) × 5 ?",
    options: ["45", "40", "35"],
    answer: "40",
    explanation:
        "10 divisé par 2 est 5, multiplié par 5 donne 25, 50 moins 25 égale 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (5 + 5) ÷ 2 ?",
    options: ["5", "6", "7"],
    answer: "5",
    explanation: "La somme de 5 et 5, divisée par 2, donne 5.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - (6 + 4) ?",
    options: ["44", "40", "46"],
    answer: "40",
    explanation:
        "On effectue d'abord l'addition, puis la soustraction : 50 - 10 = 40.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (5 + 7) ?",
    options: ["36", "24", "30"],
    answer: "36",
    explanation:
        "On effectue d'abord l'addition, puis la multiplication : 3 × 12 = 36.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (8 - 3) + 4 ?",
    options: ["14", "18", "16"],
    answer: "14",
    explanation:
        "On effectue d'abord la soustraction, puis la multiplication, puis l'addition : 2 × 5 + 4 = 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 6 - (2 + 3) ?",
    options: ["25", "28", "30"],
    answer: "25",
    explanation:
        "On effectue d'abord l'addition, puis la multiplication et enfin la soustraction : 30 - 5 = 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 ÷ 2) × (3 + 1) ?",
    options: ["16", "12", "20"],
    answer: "16",
    explanation:
        "On effectue d'abord les opérations dans les parenthèses : 4 × 4 = 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 × 2 - (6 ÷ 3) ?",
    options: ["19", "20", "18"],
    answer: "19",
    explanation:
        "On effectue d'abord la division, puis la multiplication et enfin la soustraction : 20 - 2 = 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 ÷ (2 + 2) × 3 ?",
    options: ["9", "6", "12"],
    answer: "9",
    explanation:
        "On effectue d'abord l'addition, puis la division et enfin la multiplication : 12 ÷ 4 × 3 = 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 - 4) ÷ 4 + 3 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation: "La différence de 20 et 4 divisée par 4, plus 3 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 - 2 x 5 ?",
    options: ["20", "25", "30"],
    answer: "20",
    explanation: "30 moins 2 multiplié par 5 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 3 + 7 ?",
    options: ["7", "8", "9"],
    answer: "9",
    explanation: "18 divisé par 3 plus 7 donne 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 45 - 5 x 8 ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation: "45 moins 5 multiplié par 8 donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 24 ÷ 4 + 5 ?",
    options: ["7", "8", "9"],
    answer: "8",
    explanation: "La division de 24 par 4, plus 5, est 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - (5 × 3) ?",
    options: ["5", "7", "10"],
    answer: "5",
    explanation: "La soustraction de 15 à 20 donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 1 ?",
    options: ["7", "8", "9"],
    answer: "8",
    explanation: "La multiplication de 8 par 1 est 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 3) × 2 ?",
    options: ["22", "24", "26"],
    answer: "24",
    explanation: "La multiplication de 12 par 2 donne 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 5 + 2 ?",
    options: ["6", "8", "10"],
    answer: "8",
    explanation: "La division de 30 par 5, plus 2, est 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 - (2 × 3) + 4 ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation: "10 moins 6 plus 4 égale 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 + 4 - 5 ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation: "8 plus 4 moins 5 égale 7.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 11 + 5 - 3 ?",
    options: ["12", "13", "14"],
    answer: "13",
    explanation: "11 plus 5 moins 3 égale 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - 6 + 1 ?",
    options: ["8", "9", "10"],
    answer: "9",
    explanation: "14 moins 6 plus 1 égale 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 2) ÷ 4 × 2 ?",
    options: ["5", "6", "7"],
    answer: "6",
    explanation: "D'abord, 10 + 2 = 12, puis 12 ÷ 4 = 3, et enfin 3 × 2 = 6.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × (5 + 3) ÷ 4 ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation:
        "Il faut respecter l'ordre des opérations en commençant par les parenthèses.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - (6 ÷ 2) ?",
    options: ["12", "14", "16"],
    answer: "12",
    explanation: "Il faut d'abord diviser avant de soustraire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ 4 + 6 ?",
    options: ["8", "10", "14"],
    answer: "8",
    explanation: "20 divisé par 4 plus 6 égale 8.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (2 + 3) - 4 ?",
    options: ["15", "20", "25"],
    answer: "15",
    explanation: "5 multiplié par (2 + 3) moins 4 égale 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 12 - (4 ÷ 2) ?",
    options: ["10", "8", "9"],
    answer: "10",
    explanation: "4 divisé par 2 est 2, 12 moins 2 égale 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) × 2 - 8 ?",
    options: ["12", "16", "8"],
    answer: "12",
    explanation: "10 multiplié par 2 est 20, moins 8 donne 12.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × 6 ÷ 3 ?",
    options: ["10", "15", "12"],
    answer: "10",
    explanation: "5 multiplié par 6 est 30, divisé par 3 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + (5 - 2) × 3 ?",
    options: ["16", "19", "15"],
    answer: "16",
    explanation: "5 moins 2 est 3, multiplié par 3 donne 9, 7 plus 9 égale 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × (3 + 1) - 4 ?",
    options: ["28", "32", "24"],
    answer: "28",
    explanation:
        "On additionne 3 et 1, on multiplie par 8, puis on soustrait 4 pour obtenir 28.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (14 - 6) × 2 + 3 ?",
    options: ["22", "24", "20"],
    answer: "22",
    explanation:
        "On soustrait 6 de 14, on multiplie par 2, puis on ajoute 3 pour obtenir 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 × (2 + 1) - 5 ?",
    options: ["22", "27", "23"],
    answer: "22",
    explanation:
        "On additionne 2 et 1, on multiplie par 9, puis on soustrait 5 pour obtenir 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (20 ÷ 4) + 6 × 2 ?",
    options: ["20", "22", "24"],
    answer: "22",
    explanation:
        "On divise 20 par 4, puis on ajoute le produit de 6 et 2 pour obtenir 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 × 3 - 5 + 2 ?",
    options: ["21", "20", "19"],
    answer: "20",
    explanation:
        "On multiplie 7 par 3, on soustrait 5, puis on ajoute 2 pour obtenir 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (8 - 2) ÷ 3 + 1 ?",
    options: ["3", "2", "1"],
    answer: "2",
    explanation: "D'abord, 8 - 2 = 6, puis 6 ÷ 3 = 2, et enfin 2 + 1 = 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 10 × (2 + 3) - 15 ?",
    options: ["25", "50", "35"],
    answer: "35",
    explanation: "D'abord, 2 + 3 = 5, donc 10 × 5 = 50, et 50 - 15 = 35.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 40 ÷ (5 - 3) + 10 ?",
    options: ["20", "30", "25"],
    answer: "20",
    explanation: "D'abord, 5 - 3 = 2, donc 40 ÷ 2 = 20, et 20 + 10 = 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 + 4) ÷ 2 × 3 ?",
    options: ["21", "24", "18"],
    answer: "21",
    explanation:
        "Additionner 10 et 4, diviser par 2, puis multiplier par 3 donne 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 + 6 ÷ 2 ?",
    options: ["19", "20", "18"],
    answer: "19",
    explanation: "Diviser 6 par 2 puis ajouter à 14 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 16 + (8 ÷ 4) ?",
    options: ["18", "20", "19"],
    answer: "18",
    explanation: "Diviser 8 par 4 puis ajouter à 16 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 - 4 + 3 ?",
    options: ["16", "17", "18"],
    answer: "17",
    explanation: "18 moins 4 plus 3 est 17.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + (6 - 3) x 4 ?",
    options: ["21", "22", "23"],
    answer: "21",
    explanation: "9 plus 12 (3 fois 4) est 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (7 + 3) ÷ 2 x 5 ?",
    options: ["25", "20", "30"],
    answer: "25",
    explanation: "10 divisé par 2, multiplié par 5, donne 25.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Que vaut 12 - 4 ?",
    options: ["7", "8", "9"],
    answer: "8",
    explanation: "La différence entre 12 et 4 est 8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Que vaut 8 × 2 - 5 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "8 multiplié par 2 moins 5 est égal à 11.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Que vaut 10 - (2 × 3) + 4 ?",
    options: ["7", "8", "9"],
    answer: "8",
    explanation:
        "On effectue d'abord la multiplication, puis on soustrait et additionne, ce qui donne 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 + 5 × (2 - 1) ?",
    options: ["13", "14", "15"],
    answer: "14",
    explanation:
        "On effectue d'abord la parenthèse, puis la multiplication, et enfin l'addition, ce qui donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 ÷ 4 + 3 × 2 ?",
    options: ["8", "9", "10"],
    answer: "10",
    explanation:
        "On effectue d'abord la division et la multiplication, puis on additionne pour obtenir 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Que vaut 7 × 3 - 5 ?",
    options: ["16", "17", "18"],
    answer: "16",
    explanation: "La multiplication de 7 par 3 donne 21, et 21 moins 5 est 16.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Que vaut 6 × 2 + 2 ?",
    options: ["12", "13", "14"],
    answer: "14",
    explanation:
        "On effectue d'abord la multiplication, puis on additionne pour obtenir 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 6 × 3 ?",
    options: ["18", "20", "21"],
    answer: "18",
    explanation: "6 multiplié par 3 égale 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 12 × 2 - 3 ?",
    options: ["21", "22", "23"],
    answer: "21",
    explanation: "12 multiplié par 2 donne 24, puis 24 moins 3 égale 21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (4 + 6) × 2 - 5 ?",
    options: ["15", "16", "17"],
    answer: "15",
    explanation:
        "(4 plus 6) donne 10, multiplié par 2 donne 20, puis 20 moins 5 égale 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de (10 - 2) × 3 + 4 ?",
    options: ["28", "30", "32"],
    answer: "28",
    explanation:
        "(10 moins 2) donne 8, multiplié par 3 donne 24, puis 24 plus 4 égale 28.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 40 ÷ (5 + 5) ?",
    options: ["4", "5", "6"],
    answer: "4",
    explanation: "40 divisé par (5 plus 5) donne 4.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quelle est la valeur de 3 × (4 + 5) - 6 ?",
    options: ["21", "22", "23"],
    answer: "21",
    explanation:
        "(4 plus 5) donne 9, multiplié par 3 donne 27, puis 27 moins 6 égale 21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 7 × 4 - 10 ?",
    options: ["18", "22", "26"],
    answer: "18",
    explanation: "7 multiplié par 4 donne 28, puis 28 moins 10 égale 18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "20 - 5 × 2 = ?",
    options: ["10", "12", "15"],
    answer: "10",
    explanation: "On multiplie d'abord 5 par 2, puis on soustrait de 20.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "36 ÷ 6 + 7 = ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "On divise 36 par 6, puis on ajoute 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "5 × (2 + 3) = ?",
    options: ["25", "30", "35"],
    answer: "25",
    explanation: "On additionne 2 et 3, puis on multiplie par 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "8 × (2 + 1) - 10 = ?",
    options: ["14", "16", "18"],
    answer: "14",
    explanation:
        "On additionne 2 et 1, puis on multiplie par 8 et on soustrait 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "7 + (3 × 4) - 5 = ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "On multiplie 3 par 4, on additionne 7, puis on soustrait 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "(15 ÷ 3) × 4 = ?",
    options: ["18", "20", "22"],
    answer: "20",
    explanation: "On divise 15 par 3, puis on multiplie par 4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "50 - (6 × 7) + 2 = ?",
    options: ["16", "18", "20"],
    answer: "16",
    explanation: "On multiplie 6 par 7, puis on soustrait de 50 et ajoute 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "100 ÷ (5 + 5) + 10 = ?",
    options: ["20", "15", "10"],
    answer: "20",
    explanation:
        "On additionne 5 et 5, puis on divise 100 par le résultat et on ajoute 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "40 ÷ 8 + 4 = ?",
    options: ["10", "8", "6"],
    answer: "8",
    explanation: "On divise 40 par 8, puis on ajoute 4.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 50 - 23 ?",
    options: ["27", "28", "26"],
    answer: "27",
    explanation: "50 moins 23 égale 27.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 60 ÷ (2 + 4) ?",
    options: ["10", "12", "8"],
    answer: "10",
    explanation: "60 divisé par la somme de 2 et 4 donne 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 100 - (40 ÷ 5) ?",
    options: ["80", "75", "85"],
    answer: "80",
    explanation: "100 moins 40 divisé par 5 égale 80.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 x (2 + 3) ?",
    options: ["125", "100", "150"],
    answer: "125",
    explanation: "25 multiplié par la somme de 2 et 3 donne 125.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) x (6 ÷ 3) ?",
    options: ["24", "32", "16"],
    answer: "16",
    explanation:
        "La différence de 10 et 2 multipliée par 6 divisé par 3 donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 + 6 x 2 ?",
    options: ["30", "36", "24"],
    answer: "30",
    explanation: "18 plus 6 multiplié par 2 donne 30.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (4 + 8) ÷ 3 + 5 ?",
    options: ["9", "8", "10"],
    answer: "9",
    explanation: "La somme de 4 et 8 divisée par 3 plus 5 donne 9.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 72 ÷ 8 + 5 ?",
    options: ["14", "13", "12"],
    answer: "14",
    explanation: "72 divisé par 8 plus 5 donne 14.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 33 - (9 ÷ 3) ?",
    options: ["30", "27", "26"],
    answer: "30",
    explanation: "33 moins 9 divisé par 3 donne 30.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 x (3 + 1) - 2 ?",
    options: ["18", "20", "16"],
    answer: "18",
    explanation: "5 multiplié par la somme de 3 et 1 moins 2 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 5 + 6 ÷ 3 ?",
    options: ["22", "20", "18"],
    answer: "22",
    explanation: "Le produit de 4 et 5 plus la division de 6 par 3 donne 22.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (7 - 2) + 4 ?",
    options: ["19", "20", "21"],
    answer: "19",
    explanation: "Le produit de 3 et la différence de 7 et 2 plus 4 donne 19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 - (3 + 2) ?",
    options: ["2", "3", "1"],
    answer: "3",
    explanation: "8 moins la somme de 3 et 2 donne 3.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 18 ÷ 2 + 4 ?",
    options: ["13", "12", "14"],
    answer: "13",
    explanation: "La division de 18 par 2 plus 4 donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 7 + (6 × 2) - 4 ?",
    options: ["12", "14", "16"],
    answer: "14",
    explanation: "7 plus 12 moins 4 donne 14.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 × (4 - 1) + 3 ?",
    options: ["15", "18", "20"],
    answer: "18",
    explanation: "5 multiplié par 3 plus 3 donne 18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 36 ÷ 6 + 3 × 2 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "6 plus 6 donne 12, respectant l'ordre des opérations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 - 2) × 2 + 4 ?",
    options: ["18", "20", "22"],
    answer: "20",
    explanation: "8 multiplié par 2 plus 4 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 ÷ 5 + 3 × 2 ?",
    options: ["10", "12", "14"],
    answer: "12",
    explanation: "5 plus 6 donne 12, selon l'ordre des opérations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 - (2 + 1) × 2 ?",
    options: ["3", "4", "5"],
    answer: "3",
    explanation: "9 moins 6 donne 3, en respectant l'ordre des opérations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (15 - 3) ÷ 2 ?",
    options: ["6", "8", "7"],
    answer: "6",
    explanation: "La différence de 15 et 3, divisée par 2, donne 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (10 ÷ 2) + (4 × 2) ?",
    options: ["10", "12", "14"],
    answer: "10",
    explanation: "La somme de 5 et 8 donne 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 14 - (3 + 5) ?",
    options: ["6", "8", "10"],
    answer: "6",
    explanation: "La différence de 14 et la somme de 3 et 5 donne 6.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 9 ÷ 3 ?",
    options: ["2", "3", "4"],
    answer: "3",
    explanation: "9 divisé par 3 donne 3.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Résoudre 12 + 8 - 5 ?",
    options: ["15", "18", "20"],
    answer: "15",
    explanation: "12 plus 8 moins 5 est égal à 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculer 6 × (3 + 1) ?",
    options: ["18", "24", "30"],
    answer: "24",
    explanation: "6 multiplié par la somme de 3 et 1 donne 24.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Résoudre 14 - (3 × 2) ?",
    options: ["8", "10", "12"],
    answer: "8",
    explanation: "3 multiplié par 2 est 6, donc 14 moins 6 est égal à 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculer (5 + 15) ÷ 4 ?",
    options: ["5", "6", "7"],
    answer: "5",
    explanation: "La somme de 5 et 15 est 20, divisé par 4 donne 5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Résoudre 3 × (2 + 4) - 5 ?",
    options: ["10", "11", "12"],
    answer: "11",
    explanation: "3 multiplié par 6 est 18, moins 5 égale 11.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 16 ÷ 4 + 2 ?",
    options: ["4", "6", "8"],
    answer: "6",
    explanation: "16 divisé par 4 donne 4, plus 2 égale 6.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Calculer 9 - (3 + 1) × 2 ?",
    options: ["3", "5", "7"],
    answer: "5",
    explanation:
        "La somme de 3 et 1 est 4, multiplié par 2 est 8, donc 9 moins 8 est 1.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 20 - 5 × 3 ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation: "5 multiplié par 3 est 15, donc 20 moins 15 est 5.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) × 2 - 3 ?",
    options: ["17", "18", "19"],
    answer: "17",
    explanation: "La somme de 6 et 4, multipliée par 2, moins 3, est 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (4 + 5) - 6 ?",
    options: ["24", "25", "26"],
    answer: "24",
    explanation: "Le produit de 3 et 9 (4 + 5), moins 6, est 24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 2 × (3 + 4) + 5 ?",
    options: ["16", "17", "18"],
    answer: "17",
    explanation: "Le produit de 2 et 7 (3 + 4), plus 5, est 17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 25 - 5 × (2 + 3) ?",
    options: ["10", "15", "20"],
    answer: "10",
    explanation: "La différence de 25 et 25 (5 × (2 + 3)) est 10.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 3 × (7 - 2) + 5 ?",
    options: ["20", "25", "15"],
    answer: "20",
    explanation:
        "7 moins 2 donne 5, multiplié par 3 donne 15, puis 15 plus 5 donne 20.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 8 × 2 - 3 ?",
    options: ["13", "10", "12"],
    answer: "13",
    explanation: "8 multiplié par 2 donne 16, puis moins 3 donne 13.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 5 + (3 × 4) - 2 ?",
    options: ["15", "10", "11"],
    answer: "15",
    explanation: "3 multiplié par 4 donne 12, et 5 moins 2 donne 15.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 30 ÷ 5 + 6 ?",
    options: ["10", "12", "8"],
    answer: "12",
    explanation: "30 divisé par 5 donne 6, et 6 plus 6 donne 12.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de 4 × 3 + 5 - 2 ?",
    options: ["15", "14", "16"],
    answer: "15",
    explanation: "4 fois 3 est 12, puis 12 plus 5 moins 2 donne 15.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 7 + 6 - 4 ?",
    options: ["9", "10", "11"],
    answer: "9",
    explanation: "7 plus 6 moins 4 donne 9.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 3 × (4 + 2) ?",
    options: ["18", "20", "21"],
    answer: "18",
    explanation: "3 multiplié par la somme de 4 et 2 donne 18.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 20 - (3 × 4) ?",
    options: ["8", "12", "16"],
    answer: "8",
    explanation: "20 moins 12 (3 multiplié par 4) égale 8.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font (6 + 2) × (3 - 1) ?",
    options: ["14", "16", "18"],
    answer: "16",
    explanation:
        "La somme de 6 et 2, multipliée par la différence de 3 et 1, donne 16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 9 - 3 + 4 ?",
    options: ["8", "9", "10"],
    answer: "10",
    explanation: "9 moins 3 plus 4 donne 10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Combien font 30 ÷ 5 + 1 ?",
    options: ["5", "6", "7"],
    answer: "7",
    explanation: "30 divisé par 5 plus 1 donne 7.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (6 + 4) ÷ 2 + 3 ?",
    options: ["6", "7", "8"],
    answer: "7",
    explanation: "(6 + 4) divisé par 2 plus 3 égale 7.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tests psychotechniques — Calcul rapide",
    question: "Quel est le résultat de (12 - 4) × 2 ?",
    options: ["14", "16", "18"],
    answer: "16",
    explanation: "(12 - 4) multiplié par 2 égale 16.",
    difficulty: "Moyenne",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizPsycotechniquesCalcul extends StatefulWidget {
  static const String routeName =
      '/gpx_exam/concours/tests_psychotechniques/calcul_rapide';
  final String uid;
  final String email;

  const QuizPsycotechniquesCalcul({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizPsycotechniquesCalcul> createState() =>
      _QuizPsycotechniquesCalculState();
}

class _QuizPsycotechniquesCalculState extends State<QuizPsycotechniquesCalcul>
    with TickerProviderStateMixin {
  // Page & data
  late final PageController _page;
  late math.Random _rng;
  late List<QuizQuestion> _qs;
  late List<List<String>> _opts;
  late List<String?> _answers;

  // Audio (✓ / ✕)
  late final AudioPlayer _goodSfx;
  late final AudioPlayer _badSfx;

  bool _hasQuiz = false;
  int get _qsSafeLength => _hasQuiz ? _qs.length : 0;

  int _index = 0;
  int _score = 0;

  // Sélection & validation
  String? _currentChoice;
  bool _validated = false;
  bool _isCorrect = false;

  // Splash / difficulté
  bool _showSplash = true;
  String? _selectedDifficulty; // "Facile" | "Moyenne" | "Difficile" | null
  bool _mixMode = false; // true si clic sur "Aléatoire"

  late final AnimationController _splashCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..forward();
  late final Animation<double> _splashFade = CurvedAnimation(
    parent: _splashCtrl,
    curve: Curves.easeOutCubic,
  );

  // Animation de feedback
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  // Historique
  int? _historyRowId;
  SupabaseClient get _sb => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _page = PageController(initialPage: 0);
    _rng = math.Random(DateTime.now().millisecondsSinceEpoch);

    // --- Audio ---
    _goodSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    _badSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

    // Pré-charge
    unawaited(_goodSfx.setSource(AssetSource('sfx/correct_answer.mp3')));
    unawaited(_badSfx.setSource(AssetSource('sfx/wrong_answer.mp3')));
  }

  @override
  void dispose() {
    _page.dispose();
    _splashCtrl.dispose();
    _pulseCtrl.dispose();
    _goodSfx.dispose();
    _badSfx.dispose();
    super.dispose();
  }

  // ==================================================================
  // HELPERS
  // ==================================================================
  void _seedAndShuffle() {
    final useAll = _mixMode || _selectedDifficulty == null;

    // ⚠️ Liste à définir dans tes données quiz
    final pool = useAll
        ? questionPsycotechniquesCalcul
        : questionPsycotechniquesCalcul
              .where((q) => q.difficulty == _selectedDifficulty)
              .toList();

    _qs = List<QuizQuestion>.from(pool);
    _qs.shuffle(_rng);

    _opts = _qs.map((q) {
      final list = List<String>.from(q.options);
      list.shuffle(_rng);
      return list;
    }).toList();

    _answers = List<String?>.filled(_qs.length, null);
    _hasQuiz = true;
  }

  // ==================================================================
  // SUPABASE
  // ==================================================================
  Future<void> _createHistoryOnStart() async {
    try {
      final res = await _sb
          .from('quiz_history')
          .insert({
            'uid': widget.uid,
            'email': widget.email,
            'module_name': 'Tests psychotechniques - Calcul',
            'quiz_name': 'Quiz tests psychotechniques calcul',
            'score': 0,
            'total_questions': _qs.length,
            'correct_count': 0,
            'started_at': DateTime.now().toUtc().toIso8601String(),
          })
          .select('id')
          .single();
      _historyRowId = (res['id'] as num).toInt();
    } catch (e) {
      debugPrint('❌ quiz_history (start) insert failed: $e');
    }
  }

  Future<void> _updateHistoryOnFinish() async {
    if (_historyRowId == null) return;

    try {
      // Nombre réel de questions auxquelles l'utilisateur a répondu
      final int answered = _answers.where((a) => a != null).length;

      // On évite la division par 0 (cas où il arrête sans répondre)
      final int totalForScore = answered <= 0 ? 1 : answered;

      final int percent = ((_score / totalForScore) * 100).round();

      await _sb
          .from('quiz_history')
          .update({
            'score': percent,
            'correct_count': _score,
            // 🔥 on stocke le nombre de questions réellement traitées
            'total_questions': answered,
            'finished_at': DateTime.now().toUtc().toIso8601String(),
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _historyRowId!)
          .eq('uid', widget.uid);
    } catch (e) {
      debugPrint('❌ quiz_history (finish) update failed: $e');
    }
  }

  Future<void> _endQuizNow() async {
    if (!_hasQuiz) return;

    // Nombre de questions réellement répondues
    final int answered = _answers.where((a) => a != null).length;

    final int totalForScore = answered <= 0 ? 1 : answered;

    await _updateHistoryOnFinish();

    if (!mounted) return;
    _openResultDialog(_score, totalForScore);
  }

  Future<void> _saveAnswer({
    required String question,
    required String userAnswer,
    required String correctAnswer,
    required bool isCorrect,
    required String difficulty,
  }) async {
    try {
      await _sb.from('quiz_psycotechniques_calcul_pages').insert({
        'user_uid': widget.uid,
        'email': widget.email,
        'question': question,
        'user_answer': userAnswer,
        'correct_answer': correctAnswer,
        'is_correct': isCorrect,
        'score': _score,
        'difficulty': difficulty,
      });
    } catch (e) {
      debugPrint('❌ quiz_psycotechniques_calcul_pages insert failed: $e');
    }
  }

  // ==================================================================
  // AUDIO
  // ==================================================================
  Future<void> _playAnswerSfx(bool good) async {
    try {
      HapticFeedback.mediumImpact();
      final AudioPlayer p = good ? _goodSfx : _badSfx;
      await p.stop();
      await p.setSource(
        AssetSource(good ? 'sfx/correct_answer.mp3' : 'sfx/wrong_answer.mp3'),
      );
      await p.resume();
    } catch (_) {}
  }

  // ==================================================================
  // ACTIONS
  // ==================================================================
  Future<void> _startQuiz({bool mix = false}) async {
    _mixMode = mix;
    if (!mix && _selectedDifficulty == null) {
      AppNotifier.info(
        context,
        title: 'Choisis un niveau',
        message: 'Sélectionne une difficulté pour commencer.',
      );
      return;
    }

    _seedAndShuffle();

    setState(() {
      _index = 0;
      _score = 0;
      _validated = false;
      _isCorrect = false;
      _currentChoice = null;
      _showSplash = false;
    });

    await _createHistoryOnStart();
  }

  void _select(String v) {
    if (_validated) return;
    setState(() => _currentChoice = v);
  }

  Future<void> _validate() async {
    if (_currentChoice == null) {
      AppNotifier.error(
        context,
        title: 'Réponse requise',
        message: 'Sélectionne une option pour valider.',
      );
      return;
    }

    final q = _qs[_index];
    final ok = _currentChoice == q.answer;

    setState(() {
      _validated = true;
      _isCorrect = ok;
      _answers[_index] = _currentChoice;
      if (ok) _score++;
    });

    _pulseCtrl
      ..reset()
      ..forward();

    unawaited(_playAnswerSfx(ok));

    unawaited(
      _saveAnswer(
        question: q.question,
        userAnswer: _currentChoice!,
        correctAnswer: q.answer,
        isCorrect: ok,
        difficulty: q.difficulty,
      ),
    );
  }

  Future<void> _next() async {
    if (!_validated) return;
    if (_index < _qs.length - 1) {
      setState(() {
        _index++;
        _validated = false;
        _isCorrect = false;
        _currentChoice = null;
      });
      if (mounted && _page.hasClients) {
        await _page.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    } else {
      // Dernière question : on calcule sur les questions réellement répondues
      final int answered = _answers.where((a) => a != null).length;
      final int totalForScore = answered <= 0 ? 1 : answered;

      await _updateHistoryOnFinish();
      if (!mounted) return;
      _openResultDialog(_score, totalForScore);
    }
  }

  void _restart() {
    setState(() {
      _index = 0;
      _score = 0;
      _validated = false;
      _isCorrect = false;
      _currentChoice = null;
      _showSplash = true;
      _selectedDifficulty = null;
      _mixMode = false;
    });
    _page.jumpToPage(0);
  }

  // ==================================================================
  // UI
  // ==================================================================
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppSettingsController.I.themeMode,
      builder: (_, mode, __) {
        final sysDark = Theme.of(context).brightness == Brightness.dark;
        final isDark = switch (mode) {
          ThemeMode.dark => true,
          ThemeMode.light => false,
          ThemeMode.system => sysDark,
        };
        final bg = isDark ? Colors.black : _Brand.bgLight;
        final textCol = isDark ? Colors.white : _Brand.textDark;
        final base = isDark ? ThemeData.dark() : ThemeData.light();

        const double kButtonHeight = 56;
        const double kButtonVPad = 16;
        final double bottomBarReserved = kButtonHeight + kButtonVPad + 8;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: isDark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Theme(
            data: base.copyWith(
              scaffoldBackgroundColor: bg,
              textTheme: base.textTheme.apply(
                displayColor: textCol,
                bodyColor: textCol,
              ),
              colorScheme: base.colorScheme.copyWith(
                primary: _Brand.accent,
                surface: bg,
              ),
            ),
            child: Scaffold(
              backgroundColor: bg,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.close_rounded, color: textCol),
                  onPressed: () => Navigator.maybePop(context),
                  tooltip: 'Fermer',
                ),
              ),
              body: SafeArea(
                top: false,
                child: LayoutBuilder(
                  builder: (context, viewport) {
                    final double animSize = (viewport.maxWidth * 0.56).clamp(
                      140.0,
                      240.0,
                    );

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                              child: _TopProgressBar(
                                index: _qsSafeLength == 0 ? 0 : _index,
                                total: _qsSafeLength == 0 ? 1 : _qs.length,
                                accent: isDark ? _Brand.white : _Brand.accent,
                              ),
                            ),
                            Expanded(
                              child: PageView.builder(
                                controller: _page,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _qsSafeLength == 0 ? 1 : _qs.length,
                                itemBuilder: (_, i) {
                                  if (_qsSafeLength == 0) {
                                    return const Center(
                                      child: Text(
                                        'Sélectionne une difficulté pour commencer.',
                                      ),
                                    );
                                  }
                                  final q = _qs[i];
                                  final opts = _opts[i];

                                  final bool animVisible =
                                      i == _index && _validated;

                                  final double bottomInsetForThisPage =
                                      (animVisible ? animSize : 0) +
                                      bottomBarReserved;

                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      8,
                                      20,
                                      0,
                                    ),
                                    child: KeyedSubtree(
                                      key: ValueKey(
                                        'page_${i}_${animVisible}_${_isCorrect}_${_currentChoice ?? ''}',
                                      ),
                                      child: _QuestionCard(
                                        question: q,
                                        options: opts,
                                        selected: i == _index
                                            ? _currentChoice
                                            : null,
                                        onSelect: _select,
                                        locked: _validated,
                                        showOutcome: animVisible,
                                        isCorrect: _isCorrect,
                                        bottomSafeInset: bottomInsetForThisPage,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SafeArea(
                              top: false,
                              minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                              child: Row(
                                children: [
                                  // Bouton principal (Valider / Suivant / Terminer)
                                  Expanded(
                                    child: SizedBox(
                                      height: kButtonHeight,
                                      child: _PrimaryButton(
                                        label: !_validated
                                            ? 'Valider'
                                            : (_index ==
                                                      ((_qsSafeLength == 0
                                                              ? 1
                                                              : _qs.length) -
                                                          1)
                                                  ? 'Terminer'
                                                  : 'Suivant'),
                                        onTap: _qsSafeLength == 0
                                            ? null
                                            : (!_validated
                                                  ? (_currentChoice == null
                                                        ? null
                                                        : _validate)
                                                  : _next),
                                      ),
                                    ),
                                  ),

                                  // Bouton rouge "Mettre fin"
                                  if (_qsSafeLength != 0) ...[
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      height: kButtonHeight,
                                      child: _DangerButton(
                                        label: 'Mettre fin',
                                        // dispo dès que la série est lancée
                                        onTap: _endQuizNow,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),

                        if (_validated)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: bottomBarReserved,
                            child: IgnorePointer(
                              child: SizedBox(
                                height: animSize,
                                child: Center(
                                  child: _FeedbackStrip(
                                    controller: _pulseCtrl,
                                    good: _isCorrect,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        if (_showSplash)
                          _DifficultySplash(
                            fade: _splashFade,
                            isDark: isDark,
                            selected: _selectedDifficulty,
                            onSelect: (d) => setState(() {
                              _selectedDifficulty = d;
                              _mixMode = false;
                            }),
                            onStart: () => _startQuiz(mix: false),
                            onStartRandom: () => _startQuiz(mix: true),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ==================================================================
  // RESULT DIALOG
  // ==================================================================
  void _openResultDialog(int score, int total) {
    final pct = (score / total * 100).round();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Résultat',
      barrierColor: Colors.black.withOpacity(0.25),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: const SizedBox.expand(),
              ),
            ),
            Center(
              child: _ResultCard(
                score: score,
                total: total,
                percent: pct,
                onRestart: () {
                  Navigator.of(context).pop();
                  _restart();
                },
                onQuit: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).maybePop();
                },
              ),
            ),
          ],
        );
      },
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
        child: ScaleTransition(
          scale: Tween(
            begin: .98,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeOutBack)).animate(anim),
          child: child,
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pct >= 80) {
        AppNotifier.success(
          context,
          title: 'Excellent !',
          message: 'Tu maîtrises 💪',
        );
      } else if (pct >= 50) {
        AppNotifier.info(
          context,
          title: 'Bien joué',
          message: 'Relis et retente 📈',
        );
      } else {
        AppNotifier.warning(
          context,
          title: 'À retravailler',
          message: 'Reprends les fiches.',
        );
      }
    });
  }
}

// ============================================================================
// WIDGETS
// ============================================================================
class _TopProgressBar extends StatelessWidget {
  final int index, total;
  final Color accent;
  const _TopProgressBar({
    required this.index,
    required this.total,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final totalSafe = total <= 0 ? 1 : total;
    final value = ((index + 1) / totalSafe).clamp(0.0, 1.0);
    final track = _Brand.radioTrack(context);
    final labelColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withAlpha(200)
        : _Brand.textDark.withAlpha(230);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${index + 1}/$totalSafe',
          style: _Brand.small(
            context,
          ).copyWith(color: labelColor, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 12,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: track,
                  valueColor: AlwaysStoppedAnimation<Color>(accent),
                ),
              ),
              FractionallySizedBox(
                widthFactor: value,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _opa(accent, .35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _DangerButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isEnabled ? _Brand.bad : _Brand.radioTrack(context),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;
  final bool locked;
  final bool showOutcome;
  final bool isCorrect;

  /// Marge basse à ajouter dans le scroll pour éviter toute coupe
  final double bottomSafeInset;

  const _QuestionCard({
    super.key,
    required this.question,
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.locked,
    required this.showOutcome,
    required this.isCorrect,
    this.bottomSafeInset = 0,
  });

  @override
  Widget build(BuildContext context) {
    final textCol = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : _Brand.textDark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: 8,
        // marge bas normale + réserve (animation + bouton)
        bottom: 12 + bottomSafeInset,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question.question,
            style: _Brand.h1(context).copyWith(color: textCol),
          ),
          if (question.sub != null) ...[
            const SizedBox(height: 6),
            Text(
              question.sub!,
              style: TextStyle(
                color: textCol.withAlpha(180),
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Options
          ...options.map((o) {
            final isSel = selected == o;
            final correctShown = showOutcome && o == question.answer;
            final wrongShown = showOutcome && isSel && o != question.answer;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OptionTile(
                label: o,
                selected: isSel,
                locked: locked,
                correct: correctShown,
                wrong: wrongShown,
                onTap: () => onSelect(o),
              ),
            );
          }),

          // Explication
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            layoutBuilder: (currentChild, previousChildren) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (currentChild != null) currentChild,
                ...previousChildren,
              ],
            ),
            child: showOutcome
                ? _OutcomeCard(
                    key: ValueKey<bool>(isCorrect),
                    good: isCorrect,
                    explanation: question.explanation,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final bool locked;
  final bool correct;
  final bool wrong;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.selected,
    required this.locked,
    required this.correct,
    required this.wrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg() {
      if (correct) return _opa(_Brand.good, .14);
      if (wrong) return _opa(_Brand.bad, .12);
      return isDark ? _opa(Colors.white, .06) : Colors.white;
    }

    Color border() {
      if (correct) return _opa(_Brand.good, .85);
      if (wrong) return _opa(_Brand.bad, .85);
      return isDark
          ? _opa(Colors.white, selected ? .55 : .22)
          : const Color(0xFFE8E8ED);
    }

    Widget dot(bool filled) => Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: correct
              ? _Brand.good
              : wrong
              ? _Brand.bad
              : selected
              ? _Brand.accent
              : _Brand.radioTrack(context),
          width: 2,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: filled ? 10 : 0,
          height: filled ? 10 : 0,
          decoration: BoxDecoration(
            color: correct
                ? _Brand.good
                : wrong
                ? _Brand.bad
                : _Brand.accent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      // ⬇️ plus de height fixe !
      constraints: const BoxConstraints(minHeight: 64),
      decoration: BoxDecoration(
        color: bg(),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border()),
        boxShadow: [
          if (!isDark)
            const BoxShadow(
              color: Color(0x11000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
        ],
      ),
      child: InkWell(
        onTap: locked ? null : onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          // ⬇️ padding vertical pour laisser respirer du texte multi-lignes
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dot(selected || correct || wrong),
              const SizedBox(width: 14),
              // ⬇️ le texte peut prendre plusieurs lignes
              Expanded(
                child: Text(
                  label,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: _Brand.option(context).copyWith(
                    color: isDark ? Colors.white : _Brand.textDark,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  final bool good;
  final String explanation;
  const _OutcomeCard({
    super.key,
    required this.good,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    final color = good ? _Brand.good : _Brand.bad;
    final icon = good ? Icons.check_circle_rounded : Icons.cancel_rounded;

    return Material(
      // Bordure interne évitant toute “coupure”
      type: MaterialType.transparency,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: _opa(color, .55), width: 1.2),
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _opa(color, .10),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                explanation,
                softWrap: true,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : _Brand.textDark,
                  fontWeight: FontWeight.w600,
                  height: 1.32,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isEnabled
              ? _Brand.accent
              : _Brand.radioTrack(context),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _FeedbackStrip extends StatelessWidget {
  final AnimationController controller;
  final bool good;

  const _FeedbackStrip({required this.controller, required this.good});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final maxW = constraints.maxWidth;
        // Taille dépend de la largeur du bloc, plus raisonnable
        final size = (maxW * 0.4).clamp(80.0, 160.0);

        return SizedBox(
          height: size * 1.1,
          child: Center(
            child: _FeedbackSparkles(
              controller: controller,
              good: good,
              size: size,
            ),
          ),
        );
      },
    );
  }
}

class _FeedbackStrokeDraw extends StatelessWidget {
  final AnimationController controller;
  final bool good;
  final double size;
  const _FeedbackStrokeDraw({
    required this.controller,
    required this.good,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final color = good ? _Brand.good : _Brand.bad;
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => CustomPaint(
        size: Size.square(size),
        painter: _StrokePainter(
          t: CurvedAnimation(parent: controller, curve: Curves.easeOut).value,
          color: color,
          good: good,
        ),
      ),
    );
  }
}

class _StrokePainter extends CustomPainter {
  final double t; // 0..1
  final Color color;
  final bool good;
  _StrokePainter({required this.t, required this.color, required this.good});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .06
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final r = size.width * .38;
    final c = Offset(size.width / 2, size.height / 2);

    // 1) Cercle (0 → 0.55 du temps)
    final tCircle = (t / .55).clamp(0.0, 1.0);
    if (tCircle > 0) {
      final sweep = 2 * math.pi * tCircle;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        -math.pi / 2,
        sweep,
        false,
        stroke,
      );
    }

    // 2) Symbole (0.55 → 1.0)
    final tMark = ((t - .55) / .45).clamp(0.0, 1.0);
    if (tMark <= 0) return;

    if (good) {
      // Check ✓
      final p = Path();
      final a = Offset(c.dx - r * .6, c.dy + r * .05);
      final b = Offset(c.dx - r * .15, c.dy + r * .45);
      final d = Offset(c.dx + r * .55, c.dy - r * .35);
      p.moveTo(a.dx, a.dy);
      p.lineTo(b.dx, b.dy);
      p.lineTo(d.dx, d.dy);

      _drawPartialPath(canvas, p, stroke, tMark);
    } else {
      // X : deux traits se dessinent
      final p1 = Path()
        ..moveTo(c.dx - r * .5, c.dy - r * .5)
        ..lineTo(c.dx + r * .5, c.dy + r * .5);
      final p2 = Path()
        ..moveTo(c.dx + r * .5, c.dy - r * .5)
        ..lineTo(c.dx - r * .5, c.dy + r * .5);

      final half = (tMark * 2).clamp(0.0, 1.0);
      _drawPartialPath(canvas, p1, stroke, half);
      if (tMark > .5) {
        final second = ((tMark - .5) * 2).clamp(0.0, 1.0);
        _drawPartialPath(canvas, p2, stroke, second);
      }
    }
  }

  void _drawPartialPath(Canvas canvas, Path path, Paint paint, double t) {
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    double remain = t;
    final out = Path();
    for (final m in metrics) {
      final len = m.length;
      final take = (remain.clamp(0.0, 1.0)) * len;
      out.addPath(m.extractPath(0, take), Offset.zero);
      remain -= 1;
      if (remain <= 0) break;
    }
    canvas.drawPath(out, paint);
  }

  @override
  bool shouldRepaint(covariant _StrokePainter old) =>
      old.t != t || old.color != color || old.good != good;
}

class _FeedbackSparkles extends StatelessWidget {
  final AnimationController controller;
  final bool good;
  final double size;

  const _FeedbackSparkles({
    required this.controller,
    required this.good,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final base = good ? _Brand.good : _Brand.bad;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        // Normalisation 0 → 1
        final t = controller.value.clamp(0.0, 1.0);

        final icon = good ? Icons.check_rounded : Icons.close_rounded;
        final iconSize = size * .30;

        const n = 8;
        final maxR = size * .58;

        // ⭐⭐⭐ MASQUER LES ÉTOILES SI t == 1.0 ⭐⭐⭐
        final showStars = t < 0.999;

        final kids = <Widget>[];

        if (showStars) {
          for (var i = 0; i < n; i++) {
            final ang = (i / n) * 2 * math.pi;
            final r = maxR * t;
            final dx = r * math.cos(ang);
            final dy = r * math.sin(ang);

            final scale = 0.2 + t * 0.8;
            final op = (1 - t * 0.9).clamp(0.0, 1.0);

            kids.add(
              Transform.translate(
                offset: Offset(dx, dy),
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: op,
                    child: _Star(color: base, size: size * .10),
                  ),
                ),
              ),
            );
          }
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            ...kids, // Étoiles si showStars == true
            Transform.scale(
              scale: 0.86 + t * 0.24,
              child: Icon(icon, size: iconSize, color: base),
            ),
          ],
        );
      },
    );
  }
}

class _Star extends StatelessWidget {
  final Color color;
  final double size;
  const _Star({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _StarPainter(color));
  }
}

class _StarPainter extends CustomPainter {
  final Color color;
  _StarPainter(this.color);

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final cx = s.width / 2, cy = s.height / 2;
    final r1 = s.width * .5, r2 = s.width * .22;
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final r = i.isEven ? r1 : r2;
      final a = (math.pi / 5) * i - math.pi / 2;
      final x = cx + r * math.cos(a);
      final y = cy + r * math.sin(a);
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) => old.color != color;
}

class _ResultCard extends StatefulWidget {
  final int score;
  final int total;
  final int percent;
  final VoidCallback onRestart;
  final VoidCallback onQuit;
  const _ResultCard({
    required this.score,
    required this.total,
    required this.percent,
    required this.onRestart,
    required this.onQuit,
  });

  @override
  State<_ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<_ResultCard>
    with TickerProviderStateMixin {
  late final AnimationController a = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  late final Animation<double> fade = CurvedAnimation(
    parent: a,
    curve: Curves.easeOutCubic,
  );

  late final Animation<double> pop = Tween(
    begin: .94,
    end: 1.0,
  ).chain(CurveTween(curve: Curves.easeOutBack)).animate(a);

  late final AnimationController spinCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  (Color color, IconData icon, String headline, String subline) _style() {
    final pct = (widget.score / widget.total) * 100.0;
    if (pct >= 80) {
      return (
        _Brand.good,
        Icons.emoji_events_rounded,
        'Excellent !',
        'Tu maîtrises parfaitement le sujet ✨',
      );
    }
    if (pct >= 50) {
      return (
        _Brand.accent,
        Icons.auto_graph_rounded,
        'Bon travail',
        'Encore un petit effort 💪',
      );
    }
    return (
      _Brand.bad,
      Icons.refresh_rounded,
      'À retravailler',
      'Revois la leçon et retente',
    );
  }

  @override
  void dispose() {
    spinCtrl.dispose();
    a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (accent, icon, headline, subline) = _style();
    final pct = ((widget.score / widget.total) * 100).round().clamp(0, 100);

    return ScaleTransition(
      scale: pop,
      child: FadeTransition(
        opacity: fade,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: 340,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(26),
                border: Border.all(color: Colors.white.withAlpha(64)),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: .18),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Anneau animé infini autour de l'icône
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Cercle d'arrière-plan
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accent.withValues(alpha: .12),
                          ),
                        ),
                        // Icône
                        Icon(icon, color: accent, size: 44),
                        // Anneau 1 (spin)
                        AnimatedBuilder(
                          animation: spinCtrl,
                          builder: (_, __) => Transform.rotate(
                            angle: spinCtrl.value * 2 * math.pi,
                            child: SizedBox(
                              width: 108,
                              height: 108,
                              child: CircularProgressIndicator(
                                strokeWidth: 8,
                                value: null, // indéterminé = spin infini
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  accent,
                                ),
                                backgroundColor: Colors.white.withValues(
                                  alpha: .15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    headline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'InstrumentSans',
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      height: 1.2,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subline,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      color: Colors.white.withAlpha(235),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.score}/${widget.total} bonnes réponses • $pct%',
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      color: accent.withValues(alpha: .95),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onQuit,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withAlpha(190),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            textStyle: const TextStyle(
                              fontFamily: 'InstrumentSans',
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          child: const Text('Quitter'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onRestart,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            foregroundColor: _Brand.textDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: const TextStyle(
                              fontFamily: 'InstrumentSans',
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              letterSpacing: .2,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          child: const Text('Recommencer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SPLASH: Choix de difficulté — full-screen, sans flou, FR + bouton ALÉATOIRE
// ============================================================================

class _DifficultySplash extends StatefulWidget {
  final Animation<double> fade;
  final bool isDark;
  final String? selected; // Facile | Moyenne | Difficile
  final ValueChanged<String> onSelect;
  final VoidCallback onStart;
  final VoidCallback onStartRandom;

  const _DifficultySplash({
    required this.fade,
    required this.isDark,
    required this.selected,
    required this.onSelect,
    required this.onStart,
    required this.onStartRandom,
  });

  @override
  State<_DifficultySplash> createState() => _DifficultySplashState();
}

class _DifficultySplashState extends State<_DifficultySplash>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat(reverse: true);

  late final AnimationController _floatCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _bgCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final textMain = isDark ? Colors.white : _Brand.textDark;
    final sub = isDark
        ? Colors.white.withAlpha(210)
        : _Brand.textDark.withAlpha(210);

    return Positioned.fill(
      child: FadeTransition(
        opacity: widget.fade,
        child: Stack(
          children: [
            // Fond dégradé animé + halos doux
            Positioned.fill(
              child: _AnimatedBackground(ctrl: _bgCtrl, isDark: isDark),
            ),
            _Halo(
              color: _Brand.accent,
              size: 260,
              dx: -140,
              dy: -160,
              ctrl: _bgCtrl,
              strength: isDark ? .18 : .14,
            ),
            _Halo(
              color: _Brand.good,
              size: 220,
              dx: 120,
              dy: 260,
              ctrl: _bgCtrl,
              strength: isDark ? .15 : .12,
            ),
            _Halo(
              color: _Brand.bad,
              size: 180,
              dx: -10,
              dy: 120,
              ctrl: _bgCtrl,
              strength: isDark ? .12 : .10,
            ),

            // Contenu
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sélectionne le niveau de difficulté',
                          textAlign: TextAlign.center,
                          style: _Brand.h1(
                            context,
                          ).copyWith(color: textMain, fontSize: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choisis Facile, Moyen ou Difficile pour adapter les questions à ton niveau.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: sub,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Trois cartes
                        LayoutBuilder(
                          builder: (ctx, c) {
                            final wide = c.maxWidth >= 420;
                            final spacing = 12.0;
                            final itemW = wide
                                ? (c.maxWidth - spacing * 2) / 3
                                : c.maxWidth;
                            final children = [
                              _LevelCard(
                                label: 'Facile',
                                emoji: '🌱',
                                tint: const Color(0xFFB7F0C1),
                                active: widget.selected == 'Facile',
                                onTap: () => widget.onSelect('Facile'),
                                isDark: isDark,
                                floatCtrl: _floatCtrl,
                              ),
                              _LevelCard(
                                label: 'Moyen',
                                emoji: '🏅',
                                tint: const Color(0xFFFCE7B2),
                                active: widget.selected == 'Moyenne',
                                onTap: () => widget.onSelect('Moyenne'),
                                isDark: isDark,
                                floatCtrl: _floatCtrl,
                                floatDelay: .15,
                              ),
                              _LevelCard(
                                label: 'Difficile',
                                emoji: '🏆',
                                tint: const Color(0xFFF8C2BE),
                                active: widget.selected == 'Difficile',
                                onTap: () => widget.onSelect('Difficile'),
                                isDark: isDark,
                                floatCtrl: _floatCtrl,
                                floatDelay: .30,
                              ),
                            ];

                            if (wide) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: itemW, child: children[0]),
                                  SizedBox(width: spacing),
                                  SizedBox(width: itemW, child: children[1]),
                                  SizedBox(width: spacing),
                                  SizedBox(width: itemW, child: children[2]),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  children[0],
                                  const SizedBox(height: 10),
                                  children[1],
                                  const SizedBox(height: 10),
                                  children[2],
                                ],
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 20),

                        // Bouton Commencer
                        SizedBox(
                          height: 56,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: widget.selected == null
                                ? null
                                : widget.onStart,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: widget.selected == null
                                  ? _Brand.radioTrack(context)
                                  : (isDark ? Colors.white : _Brand.textDark),
                              foregroundColor: widget.selected == null
                                  ? (isDark
                                        ? Colors.white.withAlpha(180)
                                        : _Brand.textDark.withAlpha(180))
                                  : (isDark ? Colors.black : Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'InstrumentSans',
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            child: const Text('Commencer'),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Bouton Aléatoire (mix 3 niveaux)
                        SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: widget.onStartRandom,
                            icon: const Icon(Icons.shuffle_rounded, size: 20),
                            label: const Text('Aléatoire'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isDark
                                  ? Colors.white
                                  : _Brand.textDark,
                              side: BorderSide(
                                color: isDark
                                    ? Colors.white.withAlpha(160)
                                    : _Brand.textDark.withAlpha(160),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'InstrumentSans',
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ],
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

class _AnimatedBackground extends StatelessWidget {
  final AnimationController ctrl;
  final bool isDark;
  const _AnimatedBackground({required this.ctrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final base1 = isDark ? const Color(0xFF0B0C10) : const Color(0xFFF7F8FA);
    final base2 = isDark ? const Color(0xFF11131A) : const Color(0xFFFFFFFF);

    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final t = ctrl.value;
        final a1 = Alignment.lerp(
          const Alignment(-0.9, -1.0),
          const Alignment(0.6, -0.6),
          t,
        )!;
        final a2 = Alignment.lerp(
          const Alignment(0.9, 1.0),
          const Alignment(-0.6, 0.6),
          t,
        )!;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: a1,
              end: a2,
              colors: [base1, base2],
            ),
          ),
        );
      },
    );
  }
}

class _Halo extends StatelessWidget {
  final Color color;
  final double size;
  final double dx, dy;
  final double strength;
  final AnimationController ctrl;
  const _Halo({
    required this.color,
    required this.size,
    required this.dx,
    required this.dy,
    required this.ctrl,
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final t = ctrl.value;
        final shiftX = dx + 8 * math.sin(2 * math.pi * t);
        final shiftY = dy + 8 * math.cos(2 * math.pi * t);
        return IgnorePointer(
          child: Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(shiftX, shiftY),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withValues(alpha: strength),
                      color.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String label;
  final String emoji;
  final Color tint;
  final bool active;
  final bool isDark;
  final VoidCallback onTap;
  final AnimationController floatCtrl;
  final double floatDelay;

  const _LevelCard({
    required this.label,
    required this.emoji,
    required this.tint,
    required this.active,
    required this.onTap,
    required this.isDark,
    required this.floatCtrl,
    this.floatDelay = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final track = _Brand.radioTrack(context);

    return AnimatedBuilder(
      animation: floatCtrl,
      builder: (_, __) {
        final t = ((floatCtrl.value + floatDelay) % 1.0);
        final y = 2.0 * math.sin(2 * math.pi * t); // léger flottement
        final scale = active ? 1.02 : 1.0;

        return Transform.translate(
          offset: Offset(0, y),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 180),
            scale: scale,
            curve: Curves.easeOutCubic,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                height: 112,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: _opa(tint, isDark ? .18 : .16),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active ? tint : track,
                    width: active ? 2 : 1,
                  ),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: tint.withValues(alpha: .18),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    // pastille
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _opa(tint, isDark ? .35 : .32),
                        border: Border.all(
                          color: active ? tint : _opa(Colors.white, .25),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // label
                    Expanded(
                      child: Text(
                        label,
                        style: _Brand.option(context).copyWith(
                          color: isDark ? Colors.white : _Brand.textDark,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    // radio
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: active ? tint : track,
                          width: 2,
                        ),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active ? tint : Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
