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

final List<QuizQuestion> questionLangueEtrangereAnglais = [
  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to the store every Saturday.",
    options: ["goes", "going", "went"],
    answer: "goes",
    explanation: "C'est le présent simple pour une action habituelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ playing soccer in the park.",
    options: ["is", "are", "be"],
    answer: "are",
    explanation: "Le verbe 'to be' au pluriel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his homework after dinner.",
    options: ["do", "does", "did"],
    answer: "does",
    explanation: "On utilise 'does' avec he/she dans le présent simple.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The weather is often _____ in summer.",
    options: ["hot", "hotter", "hottest"],
    answer: "hot",
    explanation: "C'est un adjectif pour décrire la température.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my friends at the café.",
    options: ["meet", "meets", "met"],
    answer: "meet",
    explanation: "C'est le présent simple pour une action régulière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to the cinema last night.",
    options: ["go", "went", "gone"],
    answer: "went",
    explanation: "'Went' est le passé de 'go'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She usually _____ breakfast at 8 o'clock.",
    options: ["has", "have", "had"],
    answer: "has",
    explanation: "On utilise 'has' pour he/she/it dans le présent simple.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ very happy today.",
    options: ["is", "are", "be"],
    answer: "are",
    explanation: "'Are' est le verbe 'to be' au pluriel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I want to _____ a book this weekend.",
    options: ["read", "reads", "reading"],
    answer: "read",
    explanation: "C'est l'infinitif du verbe 'lire'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The cat _____ on the roof.",
    options: ["sits", "sit", "sitted"],
    answer: "sits",
    explanation: "C'est le présent simple pour 'she/he/it'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He plays the guitar _____ every day.",
    options: ["often", "seldom", "never"],
    answer: "often",
    explanation: "C'est un adverbe de fréquence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the party last week.",
    options: ["go", "went", "going"],
    answer: "went",
    explanation: "'Went' est le passé de 'go'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ like ice cream.",
    options: ["doesn't", "don't", "didn't"],
    answer: "doesn't",
    explanation: "On utilise 'doesn't' pour la négation au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Anglais — Texte à trous",
    question: "I _____ to music while I study.",
    options: ["listen", "listened", "listens"],
    answer: "listen",
    explanation: "C'est le présent simple pour une action habituelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ a lot of fun at the festival.",
    options: ["had", "have", "has"],
    answer: "had",
    explanation: "'Had' est le passé de 'have'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The dog _____ in the garden.",
    options: ["plays", "play", "playing"],
    answer: "plays",
    explanation: "C'est le présent simple pour 'he/she/it'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I am _____ in London this week.",
    options: ["staying", "stay", "stayed"],
    answer: "staying",
    explanation: "C'est le présent continu pour une action actuelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to finish her project on time.",
    options: ["wants", "want", "wanted"],
    answer: "wants",
    explanation: "C'est le présent simple pour 'she'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a good friend from school.",
    options: ["is", "are", "was"],
    answer: "is",
    explanation: "C'est le verbe 'to be' au présent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my keys at home yesterday.",
    options: ["forgot", "forgets", "forget"],
    answer: "forgot",
    explanation: "'Forgot' est le passé de 'forget'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ the movie last weekend.",
    options: ["liked", "likes", "like"],
    answer: "liked",
    explanation: "'Liked' est le passé de 'like'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ going to the beach tomorrow.",
    options: ["are", "was", "is"],
    answer: "are",
    explanation: "'Are' est le verbe 'to be' au pluriel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ the report last week.",
    options: ["completed", "completes", "complete"],
    answer: "completed",
    explanation: "'Completed' est le passé de 'complete'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my homework before dinner.",
    options: ["finished", "finish", "finishes"],
    answer: "finished",
    explanation: "'Finished' est le passé de 'finish'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to the park every day.",
    options: ["go", "goes", "went"],
    answer: "goes",
    explanation: "On utilise 'goes' pour 'she' au présent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ a trip to France next summer.",
    options: ["plan", "planned", "plans"],
    answer: "plan",
    explanation: "C'est le présent simple pour une action future.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to learn new languages.",
    options: ["want", "wants", "wanted"],
    answer: "want",
    explanation: "C'est le présent simple pour une action actuelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to help her friends.",
    options: ["tries", "try", "tried"],
    answer: "tries",
    explanation: "C'est le présent simple pour 'she'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my favorite show last night.",
    options: ["watched", "watch", "watches"],
    answer: "watched",
    explanation: "'Watched' est le passé de 'watch'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a very good book last month.",
    options: ["read", "reads", "reading"],
    answer: "read",
    explanation: "'Read' se prononce comme 'red' au passé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to finish their work quickly.",
    options: ["want", "wants", "wanted"],
    answer: "want",
    explanation: "C'est le présent simple pour 'they'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a great time at the concert.",
    options: ["had", "have", "has"],
    answer: "had",
    explanation: "'Had' est le passé de 'have'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her friends yesterday.",
    options: ["met", "meet", "meets"],
    answer: "met",
    explanation: "'Met' est le passé de 'meet'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ a lot of questions during the meeting.",
    options: ["had", "have", "has"],
    answer: "had",
    explanation: "'Had' est le passé de 'have'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to travel to many countries.",
    options: ["wants", "want", "wanted"],
    answer: "wants",
    explanation: "C'est le présent simple pour 'he'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the exhibition last week.",
    options: ["went", "go", "going"],
    answer: "went",
    explanation: "'Went' est le passé de 'go'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a lot of chocolates on Valentine's Day.",
    options: ["received", "receives", "receive"],
    answer: "received",
    explanation: "'Received' est le passé de 'receive'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a letter from my pen pal yesterday.",
    options: ["received", "receive", "receives"],
    answer: "received",
    explanation: "'Received' est le passé de 'receive'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They usually _____ breakfast in the morning.",
    options: ["have", "has", "had"],
    answer: "have",
    explanation: "C'est le présent simple pour une action habituelle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a good job last year.",
    options: ["got", "get", "gets"],
    answer: "got",
    explanation: "'Got' est le passé de 'get'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a presentation at the meeting yesterday.",
    options: ["gave", "give", "gives"],
    answer: "gave",
    explanation: "'Gave' est le passé de 'give'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ to start a new project next week.",
    options: ["hope", "hopes", "hoped"],
    answer: "hope",
    explanation: "C'est le présent simple pour une intention.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to learn a new language.",
    options: ["want", "wants", "wanted"],
    answer: "want",
    explanation: "C'est le présent simple pour 'they'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a long walk every morning.",
    options: ["takes", "take", "took"],
    answer: "takes",
    explanation: "C'est le présent simple pour 'he'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ well in the competition last week.",
    options: ["performed", "perform", "performs"],
    answer: "performed",
    explanation: "'Performed' est le passé de 'perform'.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ playing football in the park.",
    options: ["is", "are", "be"],
    answer: "are",
    explanation: "Le verbe 'to be' doit s'accorder avec le sujet 'they'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I have _____ friends in London.",
    options: ["many", "much", "a lot"],
    answer: "many",
    explanation:
        "On utilise 'many' avec des noms dénombrables comme 'friends'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to music every day.",
    options: ["listen", "listens", "listening"],
    answer: "listens",
    explanation: "La forme correcte du verbe pour 'he' au présent simple.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ a great time at the party.",
    options: ["had", "have", "has"],
    answer: "had",
    explanation: "'Had' est le passé simple du verbe 'to have'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The cat is _____ the tree.",
    options: ["on", "in", "under"],
    answer: "in",
    explanation: "'In' indique que le chat est à l'intérieur de l'arbre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a beautiful dress yesterday.",
    options: ["wore", "wear", "wearing"],
    answer: "wore",
    explanation: "'Wore' est le passé simple de 'to wear'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my homework before dinner.",
    options: ["did", "do", "doing"],
    answer: "did",
    explanation: "'Did' est le passé simple du verbe 'to do'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He is _____ than his brother.",
    options: ["taller", "tall", "tallest"],
    answer: "taller",
    explanation: "On utilise 'taller' pour comparer deux personnes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ go to the cinema last week.",
    options: ["didn't", "don't", "doesn't"],
    answer: "didn't",
    explanation: "'Didn't' est la négation du passé simple.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Anglais — Texte à trous",
    question: "She _____ to finish her project.",
    options: ["needs", "needed", "need"],
    answer: "needs",
    explanation: "'Needs' est la forme correcte avec 'she'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to the beach next weekend.",
    options: ["are going", "go", "went"],
    answer: "are going",
    explanation: "'Are going' indique un futur proche.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He was _____ tired after the game.",
    options: ["very", "much", "many"],
    answer: "very",
    explanation: "'Very' est un adverbe de degré.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to the gym three times a week.",
    options: ["goes", "going", "gone"],
    answer: "goes",
    explanation: "La forme correcte au présent simple pour 'she'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ their vacation in Spain last year.",
    options: ["spent", "spend", "spending"],
    answer: "spent",
    explanation: "'Spent' est le passé de 'to spend'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ breakfast every morning.",
    options: ["have", "has", "had"],
    answer: "have",
    explanation: "La forme correcte pour 'I' au présent simple.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her keys on the table.",
    options: ["left", "leaving", "leave"],
    answer: "left",
    explanation: "'Left' est le passé de 'to leave'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his homework right now.",
    options: ["is doing", "does", "do"],
    answer: "is doing",
    explanation: "'Is doing' est la forme continue du verbe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to travel this summer.",
    options: ["want", "wants", "wanting"],
    answer: "want",
    explanation: "'Want' est la forme correcte pour 'we'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The children _____ happy today.",
    options: ["are", "is", "were"],
    answer: "are",
    explanation: "'Are' est la forme correcte pour le pluriel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a book when you called me.",
    options: ["was reading", "read", "reading"],
    answer: "was reading",
    explanation: "'Was reading' est une action continue dans le passé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a great singer.",
    options: ["is", "are", "was"],
    answer: "is",
    explanation: "'Is' est la forme correcte du verbe 'to be'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to her friend yesterday.",
    options: ["talked", "talk", "talking"],
    answer: "talked",
    explanation: "'Talked' est le passé de 'to talk'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ in the garden at the moment.",
    options: ["is working", "works", "worked"],
    answer: "is working",
    explanation: "'Is working' indique une action en cours.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my keys at home.",
    options: ["forgot", "forget", "forgetting"],
    answer: "forgot",
    explanation: "'Forgot' est le passé de 'to forget'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ a lot of fun at the concert.",
    options: ["had", "have", "has"],
    answer: "had",
    explanation: "'Had' est le passé de 'to have'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his phone at school.",
    options: ["left", "leave", "leaving"],
    answer: "left",
    explanation: "'Left' est le passé de 'to leave'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The movie _____ interesting.",
    options: ["is", "are", "was"],
    answer: "is",
    explanation: "'Is' est la forme correcte pour décrire un film.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a new bike for my birthday.",
    options: ["got", "get", "getting"],
    answer: "got",
    explanation: "'Got' est le passé de 'to get'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to finish their work on time.",
    options: ["need", "needed", "needing"],
    answer: "need",
    explanation: "'Need' est correct pour 'they'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her homework before dinner.",
    options: ["finished", "finishing", "finish"],
    answer: "finished",
    explanation: "'Finished' est le passé de 'to finish'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to swim very well.",
    options: ["learned", "learn", "learning"],
    answer: "learned",
    explanation: "'Learned' est le passé de 'to learn'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ a trip to Paris last summer.",
    options: ["took", "take", "taking"],
    answer: "took",
    explanation: "'Took' est le passé de 'to take'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a great time at the party.",
    options: ["had", "have", "has"],
    answer: "had",
    explanation: "'Had' est le passé de 'to have'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my favorite song on the radio.",
    options: ["heard", "hear", "hearing"],
    answer: "heard",
    explanation: "'Heard' est le passé de 'to hear'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a big surprise for her birthday.",
    options: ["planned", "plan", "planning"],
    answer: "planned",
    explanation: "'Planned' est le passé de 'to plan'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ their holiday in Spain last year.",
    options: ["spent", "spend", "spending"],
    answer: "spent",
    explanation: "'Spent' est le passé de 'to spend'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a letter to her friend.",
    options: ["wrote", "write", "writing"],
    answer: "wrote",
    explanation: "'Wrote' est le passé de 'to write'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to play the guitar.",
    options: ["learned", "learn", "learning"],
    answer: "learned",
    explanation: "'Learned' est le passé de 'to learn'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ breakfast for everyone.",
    options: ["made", "make", "making"],
    answer: "made",
    explanation: "'Made' est le passé de 'to make'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my best friend at school.",
    options: ["met", "meet", "meeting"],
    answer: "met",
    explanation: "'Met' est le passé de 'to meet'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his bike every day to work.",
    options: ["rides", "riding", "rode"],
    answer: "rides",
    explanation: "'Rides' est la forme correcte pour 'he'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the museum last weekend.",
    options: ["went", "go", "going"],
    answer: "went",
    explanation: "'Went' est le passé de 'to go'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a good movie last night.",
    options: ["saw", "see", "seeing"],
    answer: "saw",
    explanation: "'Saw' est le passé de 'to see'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a new book from the library.",
    options: ["borrowed", "borrowing", "borrow"],
    answer: "borrowed",
    explanation: "'Borrowed' est le passé de 'to borrow'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to her favorite song in the car.",
    options: ["sings", "sing", "sang"],
    answer: "sang",
    explanation: "'Sang' est le passé de 'to sing'.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I always drink coffee in the _____",
    options: ["morning", "night", "afternoon"],
    answer: "morning",
    explanation: "Le matin est un moment courant pour boire du café.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to the gym every day.",
    options: ["goes", "gone", "going"],
    answer: "goes",
    explanation: "Le verbe 'to go' se conjugue avec 'she' au présent simple.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They are _____ a movie tonight.",
    options: ["watching", "watched", "watches"],
    answer: "watching",
    explanation: "Le verbe 'to watch' est à la forme progressive ici.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his homework after school.",
    options: ["does", "do", "doing"],
    answer: "does",
    explanation: "Utilisation correcte du verbe 'to do' au présent simple.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The cat is _____ on the sofa.",
    options: ["sleeping", "sleep", "sleeps"],
    answer: "sleeping",
    explanation: "La forme progressive est utilisée pour une action en cours.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I have _____ friends in my city.",
    options: ["many", "much", "few"],
    answer: "many",
    explanation: "Utilisation correcte de 'many' avec des noms dénombrables.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She loves to _____ music in her free time.",
    options: ["listen", "listens", "listening"],
    answer: "listen",
    explanation: "Infinitif 'to listen' est utilisé après 'loves to'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the concert last night.",
    options: ["went", "go", "going"],
    answer: "went",
    explanation: "Le passé simple du verbe 'to go' est 'went'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I don't like _____ tea in the morning.",
    options: ["drinking", "drink", "drinks"],
    answer: "drinking",
    explanation: "L'infinitif est utilisé après 'like' avec 'not'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a beautiful dress for the party.",
    options: ["has", "have", "had"],
    answer: "has",
    explanation: "Utilisation correcte du verbe 'to have' avec 'she'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We are going to _____ a trip next month.",
    options: ["take", "takes", "took"],
    answer: "take",
    explanation: "L'infinitif 'to take' est utilisé après 'going to'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ breakfast before work every day.",
    options: ["eats", "eat", "eating"],
    answer: "eats",
    explanation: "Verbe 'to eat' conjugué au présent simple avec 'he'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Anglais — Texte à trous",
    question: "My favorite color is _____ .",
    options: ["blue", "bluer", "bluest"],
    answer: "blue",
    explanation: "Le nom de couleur est utilisé ici sans comparatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ in the park yesterday.",
    options: ["played", "play", "playing"],
    answer: "played",
    explanation: "Le passé simple du verbe 'to play' est 'played'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "Can you _____ the window, please?",
    options: ["open", "opened", "opening"],
    answer: "open",
    explanation: "L'infinitif est utilisé après 'can'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I will _____ you tomorrow.",
    options: ["call", "called", "calling"],
    answer: "call",
    explanation: "Utilisation de l'infinitif après 'will'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We enjoy _____ to the beach in summer.",
    options: ["going", "go", "went"],
    answer: "going",
    explanation: "L'infinitif est utilisé après 'enjoy'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He is _____ to play football after school.",
    options: ["going", "go", "gone"],
    answer: "going",
    explanation: "Le verbe 'to go' utilisé dans la forme progressive.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "What time does the train _____?",
    options: ["leave", "leaves", "leaving"],
    answer: "leave",
    explanation: "L'infinitif est utilisé après 'does'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The weather is _____ today than yesterday.",
    options: ["better", "good", "best"],
    answer: "better",
    explanation: "Comparatif utilisé pour décrire la météo.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his keys on the table.",
    options: ["left", "leave", "leaving"],
    answer: "left",
    explanation: "Passé simple de 'to leave' est 'left'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ to the store to buy some milk.",
    options: ["went", "going", "go"],
    answer: "went",
    explanation: "Le passé simple utilisé pour une action passée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ their friends at the café.",
    options: ["met", "meet", "meeting"],
    answer: "met",
    explanation: "Le passé simple de 'to meet' est 'met'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ for a new job at the moment.",
    options: ["is looking", "looked", "looks"],
    answer: "is looking",
    explanation: "Forme progressive pour une action actuelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a good student last year.",
    options: ["was", "is", "be"],
    answer: "was",
    explanation: "Le passé simple du verbe 'to be' est 'was'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The children _____ in the garden yesterday.",
    options: ["played", "play", "playing"],
    answer: "played",
    explanation: "Passé simple du verbe 'to play' est 'played'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I want to _____ a new book.",
    options: ["read", "reads", "reading"],
    answer: "read",
    explanation: "L'infinitif utilisé après 'want to'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to the party last weekend.",
    options: ["went", "go", "going"],
    answer: "went",
    explanation: "Le passé simple du verbe 'to go' est 'went'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They are _____ a great time at the concert.",
    options: ["having", "have", "had"],
    answer: "having",
    explanation: "Forme progressive pour une activité en cours.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ breakfast every morning.",
    options: ["makes", "make", "making"],
    answer: "makes",
    explanation: "Verbe 'to make' conjugué au présent simple.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I am _____ a sandwich for lunch.",
    options: ["making", "make", "makes"],
    answer: "making",
    explanation: "Forme progressive pour une action actuelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the beach last summer.",
    options: ["went", "go", "going"],
    answer: "went",
    explanation: "Le passé simple du verbe 'to go' est 'went'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She loves _____ in the summer.",
    options: ["swimming", "swim", "swims"],
    answer: "swimming",
    explanation: "L'infinitif est utilisé après 'loves'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He is _____ to the store now.",
    options: ["going", "go", "gone"],
    answer: "going",
    explanation: "Forme progressive pour une action actuelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ our friends at the park yesterday.",
    options: ["met", "meet", "meeting"],
    answer: "met",
    explanation: "Le passé simple de 'to meet' est 'met'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I will _____ you the truth.",
    options: ["tell", "told", "telling"],
    answer: "tell",
    explanation: "L'infinitif est utilisé après 'will'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They are _____ a movie right now.",
    options: ["watching", "watched", "watches"],
    answer: "watching",
    explanation: "Forme progressive pour une action actuelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her bike to school every day.",
    options: ["rides", "ride", "riding"],
    answer: "rides",
    explanation:
        "Le verbe 'to ride' est conjugué au présent simple avec 'she'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a letter to his friend yesterday.",
    options: ["wrote", "write", "writing"],
    answer: "wrote",
    explanation: "Le passé simple du verbe 'to write' est 'wrote'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I like _____ to music while I work.",
    options: ["listening", "listen", "listens"],
    answer: "listening",
    explanation: "L'infinitif est utilisé après 'like'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They are _____ to go home now.",
    options: ["ready", "read", "reads"],
    answer: "ready",
    explanation: "Le mot 'ready' signifie être préparé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a beautiful song yesterday.",
    options: ["sang", "sing", "sings"],
    answer: "sang",
    explanation: "Le passé simple du verbe 'to sing' est 'sang'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I have _____ many books at home.",
    options: ["too", "to", "two"],
    answer: "too",
    explanation: "'Too' signifie en excès ou énormément.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his friends every weekend.",
    options: ["sees", "see", "seeing"],
    answer: "sees",
    explanation: "Le verbe 'to see' conjugué au présent simple avec 'he'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ going to the cinema tonight.",
    options: ["are", "is", "were"],
    answer: "are",
    explanation: "Utilisation correcte du verbe 'to be' avec 'we'.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to the store yesterday.",
    options: ["went", "going", "go"],
    answer: "went",
    explanation: "'Went' est le passé du verbe 'go'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a book every month.",
    options: ["read", "reads", "reading"],
    answer: "read",
    explanation: "'Read' est la forme correcte pour 'I'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ playing football now.",
    options: ["is", "are", "am"],
    answer: "are",
    explanation: "'Are' est utilisé avec 'they'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to the cinema last week.",
    options: ["go", "went", "going"],
    answer: "went",
    explanation: "'Went' est le passé de 'go'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his homework after dinner.",
    options: ["do", "did", "doing"],
    answer: "did",
    explanation: "'Did' est le passé de 'do'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her friends at the park.",
    options: ["meets", "meet", "met"],
    answer: "meets",
    explanation: "'Meets' est la forme correcte pour le présent simple.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my keys on the table.",
    options: ["leave", "leaving", "left"],
    answer: "left",
    explanation: "'Left' est le passé de 'leave'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the party last night.",
    options: ["go", "going", "went"],
    answer: "went",
    explanation: "'Went' est utilisé pour le passé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ a great time at the concert.",
    options: ["had", "have", "having"],
    answer: "had",
    explanation: "'Had' est le passé du verbe 'have'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to play the piano.",
    options: ["want", "wants", "wanting"],
    answer: "wants",
    explanation: "'Wants' est correct pour 'she'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a lot of friends in school.",
    options: ["has", "have", "had"],
    answer: "has",
    explanation: "'Has' est utilisé avec 'he'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to visit their grandmother.",
    options: ["want", "wants", "wanting"],
    answer: "want",
    explanation: "'Want' est correct pour 'they'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my breakfast at 8 AM.",
    options: ["eat", "eating", "ate"],
    answer: "eat",
    explanation: "'Eat' est la forme correcte pour le présent simple.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her homework every day.",
    options: ["does", "do", "doing"],
    answer: "does",
    explanation: "'Does' est utilisé avec 'she'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to the gym regularly.",
    options: ["goes", "going", "went"],
    answer: "goes",
    explanation: "'Goes' est correct pour 'he'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ to learn new languages.",
    options: ["want", "wants", "wanting"],
    answer: "want",
    explanation: "'Want' est correct pour 'I'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a beautiful dress.",
    options: ["has", "have", "had"],
    answer: "has",
    explanation: "'Has' est utilisé avec 'she'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ a picnic in the park.",
    options: ["had", "have", "having"],
    answer: "had",
    explanation: "'Had' est le passé de 'have'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my homework after dinner.",
    options: ["do", "did", "doing"],
    answer: "do",
    explanation: "C'est la forme correcte du verbe au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a great movie yesterday.",
    options: ["see", "saw", "seen"],
    answer: "saw",
    explanation: "Le passé du verbe 'see' est 'saw'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to the beach last summer.",
    options: ["go", "went", "going"],
    answer: "went",
    explanation: "Le passé du verbe 'go' est 'went'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ coffee every morning.",
    options: ["drink", "drinks", "drank"],
    answer: "drinks",
    explanation: "C'est la forme correcte du verbe au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to play the guitar when he was young.",
    options: ["learn", "learned", "learning"],
    answer: "learned",
    explanation: "Le passé du verbe 'learn' est 'learned'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ a lot of fun at the concert.",
    options: ["have", "has", "had"],
    answer: "had",
    explanation: "Le passé du verbe 'have' est 'had'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to France last year.",
    options: ["travel", "traveled", "travels"],
    answer: "traveled",
    explanation: "Le passé du verbe 'travel' est 'traveled'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his bike to school every day.",
    options: ["ride", "rides", "rode"],
    answer: "rides",
    explanation: "C'est la forme correcte du verbe au présent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a cake for her birthday.",
    options: ["make", "made", "makes"],
    answer: "made",
    explanation: "Le passé du verbe 'make' est 'made'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ a new restaurant in town.",
    options: ["open", "opened", "opens"],
    answer: "opened",
    explanation: "Le passé du verbe 'open' est 'opened'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a book every month.",
    options: ["read", "reads", "reading"],
    answer: "reads",
    explanation: "C'est la forme correcte du verbe au présent.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ to the gym every day.",
    options: ["go", "gone", "went"],
    answer: "go",
    explanation: "C'est la forme correcte du verbe au présent.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to the beach every summer.",
    options: ["go", "goes", "going"],
    answer: "go",
    explanation: "La forme correcte pour 'we' est 'go'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "My sister _____ a new dress for the party.",
    options: ["buy", "buys", "buying"],
    answer: "buys",
    explanation: "La forme correcte pour 'she' est 'buys'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ their friends at the café.",
    options: ["meet", "meets", "meeting"],
    answer: "meet",
    explanation: "La forme correcte pour 'they' est 'meet'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ to music while studying.",
    options: ["listen", "listens", "listening"],
    answer: "listen",
    explanation: "La forme correcte pour 'I' est 'listen'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her keys at home.",
    options: ["forget", "forgets", "forgetting"],
    answer: "forgets",
    explanation: "La forme correcte pour 'she' est 'forgets'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ breakfast every morning.",
    options: ["makes", "make", "making"],
    answer: "makes",
    explanation: "La forme correcte pour 'he' est 'makes'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my best friend yesterday.",
    options: ["call", "called", "calling"],
    answer: "called",
    explanation: "Le passé du verbe 'to call' est 'called'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a beautiful song.",
    options: ["sings", "sing", "singing"],
    answer: "sings",
    explanation: "La forme correcte pour 'she' est 'sings'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his homework before dinner.",
    options: ["finished", "finish", "finishing"],
    answer: "finished",
    explanation: "Le passé du verbe 'to finish' est 'finished'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a letter to my grandmother.",
    options: ["wrote", "write", "writing"],
    answer: "wrote",
    explanation: "Le passé du verbe 'to write' est 'wrote'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ the game last week.",
    options: ["won", "win", "winning"],
    answer: "won",
    explanation: "Le passé du verbe 'to win' est 'won'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a great idea for the project.",
    options: ["has", "have", "having"],
    answer: "has",
    explanation: "La forme correcte pour 'she' est 'has'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to visit our cousins next month.",
    options: ["plan", "plans", "planning"],
    answer: "plan",
    explanation: "La forme correcte pour 'we' est 'plan'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She is very _____ today.",
    options: ["happy", "quickly", "book"],
    answer: "happy",
    explanation: "Le mot 'happy' signifie content.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to the gym every day.",
    options: ["goes", "went", "going"],
    answer: "goes",
    explanation: "Le verbe 'goes' est au présent simple.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I have _____ friends in this city.",
    options: ["many", "much", "few"],
    answer: "many",
    explanation: "On utilise 'many' avec des noms dénombrables.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The book is _____ the table.",
    options: ["on", "in", "under"],
    answer: "on",
    explanation: "'On' indique une position supérieure.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a beautiful dress.",
    options: ["wears", "wear", "wearing"],
    answer: "wears",
    explanation: "Le verbe 'wears' est au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "It _____ rain tomorrow.",
    options: ["might", "must", "can"],
    answer: "might",
    explanation: "'Might' exprime une possibilité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to the beach last weekend.",
    options: ["went", "go", "going"],
    answer: "went",
    explanation: "'Went' est le passé du verbe 'go'.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ to the store yesterday.",
    options: ["went", "goes", "going"],
    answer: "went",
    explanation: "Le verbe 'went' est le passé de 'go'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a beautiful dress for the party.",
    options: ["wears", "wear", "wore"],
    answer: "wore",
    explanation: "'Wore' est le passé de 'wear'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ breakfast every morning.",
    options: ["eat", "eats", "eaten"],
    answer: "eat",
    explanation: "'Eat' est la forme correcte pour le présent simple avec 'I'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to play guitar when he was young.",
    options: ["learned", "learn", "learning"],
    answer: "learned",
    explanation: "'Learned' est le passé du verbe 'learn'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ at the concert last night.",
    options: ["sang", "sing", "sings"],
    answer: "sang",
    explanation: "'Sang' est le passé de 'sing'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The cat _____ on the sofa all day.",
    options: ["sleeps", "sleeping", "slept"],
    answer: "slept",
    explanation: "'Slept' est le passé de 'sleep'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my friend tomorrow.",
    options: ["see", "saw", "seeing"],
    answer: "see",
    explanation: "'See' est la forme correcte pour le futur avec 'I'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a great job last year.",
    options: ["finds", "found", "finding"],
    answer: "found",
    explanation: "'Found' est le passé de 'find'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the party if they are invited.",
    options: ["come", "came", "coming"],
    answer: "come",
    explanation: "'Come' est la forme correcte pour le futur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He usually _____ coffee in the morning.",
    options: ["drinks", "drink", "drank"],
    answer: "drinks",
    explanation:
        "'Drinks' est la forme correcte pour le présent simple avec 'he'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ to finish my project by Friday.",
    options: ["need", "needs", "needed"],
    answer: "need",
    explanation:
        "'Need' est la forme correcte pour le présent simple avec 'I'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a letter to her grandmother last week.",
    options: ["wrote", "writes", "writing"],
    answer: "wrote",
    explanation: "'Wrote' est le passé de 'write'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ their vacation in July.",
    options: ["enjoyed", "enjoy", "enjoying"],
    answer: "enjoyed",
    explanation: "'Enjoyed' est le passé de 'enjoy'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to the gym every Saturday.",
    options: ["goes", "went", "going"],
    answer: "goes",
    explanation:
        "'Goes' est la forme correcte pour le présent simple avec 'he'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ a great time at the beach.",
    options: ["had", "have", "having"],
    answer: "had",
    explanation: "'Had' est le passé de 'have'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She always _____ her homework after dinner.",
    options: ["does", "do", "doing"],
    answer: "does",
    explanation: "Le verbe 'does' est utilisé avec 'she'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the cinema on weekends.",
    options: ["go", "goes", "going"],
    answer: "go",
    explanation: "Le verbe 'go' est utilisé avec 'they'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ like to play football.",
    options: ["doesn't", "don't", "not"],
    answer: "doesn't",
    explanation: "'Doesn't' est la forme négative pour 'he'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to music every day.",
    options: ["listens", "listen", "listening"],
    answer: "listens",
    explanation: "'Listens' est la forme correcte pour 'she'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his bike to school.",
    options: ["rides", "ride", "riding"],
    answer: "rides",
    explanation: "'Rides' est utilisé avec 'he'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my friend tomorrow.",
    options: ["will meet", "meet", "met"],
    answer: "will meet",
    explanation: "'Will meet' est le futur pour 'I'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her homework right now.",
    options: ["is doing", "does", "do"],
    answer: "is doing",
    explanation: "'Is doing' est la forme continue pour 'she'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a book when I called.",
    options: ["was reading", "read", "reads"],
    answer: "was reading",
    explanation: "'Was reading' est la forme continue au passé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to finish the project by Friday.",
    options: ["need", "needs", "needing"],
    answer: "need",
    explanation: "'Need' est utilisé avec 'they'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a cake for his birthday.",
    options: ["baked", "bake", "baking"],
    answer: "baked",
    explanation: "'Baked' est le passé du verbe 'bake'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my phone at the café yesterday.",
    options: ["lost", "lose", "losing"],
    answer: "lost",
    explanation: "'Lost' est le passé de 'lose'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to learn a new language.",
    options: ["wants", "want", "wanting"],
    answer: "wants",
    explanation: "'Wants' est utilisé avec 'he'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ their friends for dinner next week.",
    options: ["are inviting", "invite", "invited"],
    answer: "are inviting",
    explanation: "'Are inviting' est la forme continue pour 'they'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ a lot of fun at the amusement park.",
    options: ["had", "have", "having"],
    answer: "had",
    explanation: "'Had' est le passé du verbe 'have'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ playing soccer right now.",
    options: ["is", "are", "was"],
    answer: "are",
    explanation: "'Are' est utilisé pour le présent continu avec 'they'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my homework last night.",
    options: ["finish", "finished", "finishing"],
    answer: "finished",
    explanation: "'Finished' est le passé du verbe 'finish'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a letter to her friend.",
    options: ["writes", "wrote", "write"],
    answer: "writes",
    explanation: "'Writes' est la forme correcte pour le présent avec 'she'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ like chocolate ice cream.",
    options: ["doesn't", "don't", "didn't"],
    answer: "don't",
    explanation: "'Don't' est la contraction de 'do not' au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ at the park every Sunday.",
    options: ["played", "play", "playing"],
    answer: "play",
    explanation: "'Play' est la forme correcte pour le présent avec 'they'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his bike to school yesterday.",
    options: ["rided", "rides", "rode"],
    answer: "rode",
    explanation: "'Rode' est le passé du verbe 'ride'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ a great time at the party last night.",
    options: ["had", "have", "has"],
    answer: "had",
    explanation: "'Had' est le passé du verbe 'have'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a new car next month.",
    options: ["buy", "buys", "will buy"],
    answer: "will buy",
    explanation: "'Will buy' est utilisé pour le futur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to help you with your homework.",
    options: ["want", "wants", "wanting"],
    answer: "want",
    explanation: "'Want' est la forme correcte pour le présent avec 'we'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ about the news yesterday.",
    options: ["talked", "talks", "talking"],
    answer: "talked",
    explanation: "'Talked' est le passé du verbe 'talk'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my friend on the phone last night.",
    options: ["called", "call", "calling"],
    answer: "called",
    explanation: "'Called' est le passé du verbe 'call'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to finish their work before noon.",
    options: ["need", "needed", "needing"],
    answer: "need",
    explanation: "'Need' est la forme correcte pour le présent avec 'they'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to travel next summer.",
    options: ["plans", "plan", "planning"],
    answer: "plans",
    explanation: "'Plans' est la forme correcte pour 'he' au présent.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I usually _____ coffee in the morning.",
    options: ["drink", "drinks", "drinking"],
    answer: "drink",
    explanation: "Le verbe 'drink' est utilisé avec 'I'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He is _____ tall than his brother.",
    options: ["more", "most", "less"],
    answer: "more",
    explanation:
        "Le comparatif 'more' est utilisé pour des adjectifs de deux syllabes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The book is _____ interesting than the movie.",
    options: ["more", "most", "less"],
    answer: "more",
    explanation: "Le comparatif 'more' est utilisé ici.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my keys on the table.",
    options: ["leave", "leaves", "leaving"],
    answer: "leave",
    explanation: "Le verbe 'leave' est au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to play the guitar.",
    options: ["want", "wants", "wanting"],
    answer: "wants",
    explanation: "Le verbe 'wants' est utilisé avec 'he'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to visit our friends this weekend.",
    options: ["plan", "plans", "planning"],
    answer: "plan",
    explanation: "Le verbe 'plan' est au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her lunch at noon.",
    options: ["eats", "ate", "eating"],
    answer: "eats",
    explanation: "Le verbe 'eats' est au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a letter to my friend yesterday.",
    options: ["write", "writes", "wrote"],
    answer: "wrote",
    explanation: "Le verbe 'wrote' est le passé de 'write'.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a book on the table.",
    options: ["see", "saw", "seeing"],
    answer: "see",
    explanation: "Le verbe au présent simple pour une observation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ breakfast at 8 AM.",
    options: ["has", "have", "had"],
    answer: "has",
    explanation: "Utilisation de 'to have' pour parler d'un repas.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her homework every evening.",
    options: ["does", "do", "did"],
    answer: "does",
    explanation: "Utilisation de 'to do' pour une routine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the party last week.",
    options: ["didn't go", "not go", "don't go"],
    answer: "didn't go",
    explanation: "Négation au passé simple.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my friends at the café tomorrow.",
    options: ["will meet", "meet", "met"],
    answer: "will meet",
    explanation: "Futur simple pour une action planifiée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The cat _____ under the table right now.",
    options: ["is sleeping", "was sleeping", "sleeping"],
    answer: "is sleeping",
    explanation: "Présent continu pour une action en cours.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a beautiful dress for the event.",
    options: ["wore", "wears", "wear"],
    answer: "wore",
    explanation: "Passé simple pour une action terminée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ coffee every morning before work.",
    options: ["drinks", "drink", "drank"],
    answer: "drinks",
    explanation: "Présent simple pour une habitude.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to travel next summer.",
    options: ["want", "wants", "wanted"],
    answer: "want",
    explanation: "Présent simple pour exprimer un souhait.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my keys somewhere in the house.",
    options: ["lost", "lose", "losing"],
    answer: "lost",
    explanation: "Passé simple pour une action terminée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to finish his project on time.",
    options: ["needs", "need", "needing"],
    answer: "needs",
    explanation: "Présent simple pour exprimer un besoin.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ their vacation in France last year.",
    options: ["enjoyed", "enjoy", "enjoying"],
    answer: "enjoyed",
    explanation: "Passé simple pour une action passée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a letter to her friend yesterday.",
    options: ["wrote", "write", "writing"],
    answer: "wrote",
    explanation: "Passé simple pour une action terminée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to finish our homework before dinner.",
    options: ["have", "had", "has"],
    answer: "have",
    explanation: "Présent simple pour une obligation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my bike to school every day.",
    options: ["ride", "rides", "riding"],
    answer: "ride",
    explanation: "Présent simple pour une routine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ the piano very well.",
    options: ["plays", "play", "played"],
    answer: "plays",
    explanation: "Présent simple pour une compétence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ playing soccer now.",
    options: ["is", "are", "am"],
    answer: "are",
    explanation: "'Are' est utilisé pour le pluriel au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my homework every day.",
    options: ["do", "does", "doing"],
    answer: "do",
    explanation: "'Do' est utilisé avec 'I' au présent simple.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a beautiful dress at the party.",
    options: ["wears", "wore", "wear"],
    answer: "wore",
    explanation: "'Wore' est le passé de 'wear'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to music while studying.",
    options: ["listens", "listened", "listen"],
    answer: "listens",
    explanation: "'Listens' est la forme correcte au présent simple.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ their friends at the park.",
    options: ["meet", "meets", "meeting"],
    answer: "meet",
    explanation: "'Meet' est la forme correcte au présent simple.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her bike every weekend.",
    options: ["rides", "ride", "riding"],
    answer: "rides",
    explanation: "'Rides' est la forme correcte au présent simple.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ a trip to London last summer.",
    options: ["took", "take", "taking"],
    answer: "took",
    explanation: "'Took' est le passé de 'take'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his lunch before the meeting.",
    options: ["ate", "eat", "eating"],
    answer: "ate",
    explanation: "'Ate' est le passé de 'eat'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his keys in the car.",
    options: ["forgot", "forgets", "forgetting"],
    answer: "forgot",
    explanation: "'Forgot' est le passé de 'forget'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ their vacation in Spain last year.",
    options: ["enjoyed", "enjoy", "enjoying"],
    answer: "enjoyed",
    explanation: "'Enjoyed' est le passé de 'enjoy'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my favorite movie three times.",
    options: ["watched", "watch", "watching"],
    answer: "watched",
    explanation: "'Watched' est le passé de 'watch'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my homework yesterday.",
    options: ["finish", "finished", "finishing"],
    answer: "finished",
    explanation: "Le passé simple du verbe 'finish' est 'finished'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a great time at the party.",
    options: ["have", "has", "had"],
    answer: "had",
    explanation: "Le passé du verbe 'have' est 'had'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to the cinema next weekend.",
    options: ["go", "going", "will go"],
    answer: "will go",
    explanation: "Pour parler d'un futur, on utilise 'will go'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ in London for two years.",
    options: ["live", "lived", "have lived"],
    answer: "have lived",
    explanation:
        "Pour exprimer une durée, on utilise le présent perfect 'have lived'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my friends to the concert last night.",
    options: ["bring", "brought", "brings"],
    answer: "brought",
    explanation: "Le passé du verbe 'bring' est 'brought'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a beautiful dress for the wedding.",
    options: ["wear", "wore", "wears"],
    answer: "wore",
    explanation: "Le passé du verbe 'wear' est 'wore'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a book when I called him.",
    options: ["read", "was reading", "reads"],
    answer: "was reading",
    explanation:
        "Pour décrire une action en cours, on utilise le past continuous 'was reading'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The weather _____ nice tomorrow.",
    options: ["is", "will be", "was"],
    answer: "will be",
    explanation: "Pour parler du futur, on utilise 'will be'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to the gym every day last month.",
    options: ["went", "go", "goes"],
    answer: "went",
    explanation: "Le passé du verbe 'go' est 'went'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to visit the museum next week.",
    options: ["plan", "planning", "planned"],
    answer: "plan",
    explanation: "Pour exprimer une intention future, on utilise 'plan'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his bicycle to school every day.",
    options: ["rides", "rode", "ride"],
    answer: "rides",
    explanation:
        "Le présent du verbe 'ride' pour la troisième personne est 'rides'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ dinner when I arrived.",
    options: ["have", "had", "having"],
    answer: "had",
    explanation: "Le passé du verbe 'have' est 'had'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a movie last night.",
    options: ["see", "saw", "seeing"],
    answer: "saw",
    explanation: "Le passé du verbe 'see' est 'saw'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a new job last month.",
    options: ["gets", "got", "get"],
    answer: "got",
    explanation: "Le passé du verbe 'get' est 'got'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to school every day.",
    options: ["walks", "walk", "walking"],
    answer: "walks",
    explanation: "Le verbe doit être conjugué au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ like chocolate ice cream.",
    options: ["doesn't", "don't", "isn't"],
    answer: "doesn't",
    explanation: "Utilisez la négation correcte pour 'he'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The sun _____ in the east.",
    options: ["rise", "rises", "rose"],
    answer: "rises",
    explanation:
        "Le verbe doit être au présent simple pour une vérité générale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her keys at home yesterday.",
    options: ["forget", "forgot", "forgets"],
    answer: "forgot",
    explanation: "Utilisez le passé simple pour une action passée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to the park every weekend.",
    options: ["go", "going", "gone"],
    answer: "go",
    explanation: "Utilisez le présent simple pour une action habituelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to play the guitar very well.",
    options: ["learned", "learn", "learning"],
    answer: "learned",
    explanation: "Utilisez le passé simple pour une compétence acquise.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They are _____ a new house.",
    options: ["building", "build", "built"],
    answer: "building",
    explanation: "Le verbe doit être au gérondif pour une action en cours.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my friend tomorrow.",
    options: ["meet", "meets", "meeting"],
    answer: "meet",
    explanation: "Utilisez le futur simple pour un rendez-vous prévu.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The children _____ in the garden now.",
    options: ["are playing", "play", "played"],
    answer: "are playing",
    explanation: "Utilisez le présent continu pour une action actuelle.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a beautiful painting.",
    options: ["painted", "paint", "painting"],
    answer: "painted",
    explanation: "Le verbe 'painted' est le passé de 'paint'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his homework last night.",
    options: ["finished", "finish", "finishing"],
    answer: "finished",
    explanation: "Le verbe 'finished' est le passé de 'finish'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my friend at the cafe.",
    options: ["met", "meet", "meeting"],
    answer: "met",
    explanation: "'Met' est le passé de 'meet'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She usually _____ to music in the evening.",
    options: ["listens", "listen", "listening"],
    answer: "listens",
    explanation:
        "'Listens' est la bonne forme pour le présent simple avec 'she'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The cat _____ on the sofa.",
    options: ["is sleeping", "sleeping", "sleeps"],
    answer: "is sleeping",
    explanation: "'Is sleeping' est la forme correcte pour le présent continu.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ to finish my project tomorrow.",
    options: ["need", "needed", "needing"],
    answer: "need",
    explanation: "'Need' est la forme correcte pour le présent simple.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a new bike last month.",
    options: ["bought", "buy", "buying"],
    answer: "bought",
    explanation: "'Bought' est le passé de 'buy'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "My sister _____ a great dancer.",
    options: ["is", "was", "be"],
    answer: "is",
    explanation:
        "'Is' est la forme correcte pour le présent simple avec 'sister'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to Paris last summer.",
    options: ["traveled", "travel", "traveling"],
    answer: "traveled",
    explanation: "'Traveled' est le passé de 'travel'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his friends every weekend.",
    options: ["meets", "meet", "meeting"],
    answer: "meets",
    explanation:
        "'Meets' est la forme correcte pour le présent simple avec 'he'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a big dog.",
    options: ["have", "has", "having"],
    answer: "has",
    explanation: "'Has' est utilisé avec 'he' au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the cinema last week.",
    options: ["go", "went", "gone"],
    answer: "went",
    explanation: "'Went' est le passé du verbe 'go'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a nice dress for the party.",
    options: ["wears", "wore", "wear"],
    answer: "wore",
    explanation: "'Wore' est le passé de 'wear'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ playing video games all day.",
    options: ["is", "are", "was"],
    answer: "is",
    explanation: "'Is' est la forme correcte du verbe 'to be' au singulier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ to visit my grandparents this weekend.",
    options: ["want", "wants", "wanting"],
    answer: "want",
    explanation: "'Want' est la forme correcte pour 'I' au présent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the beach every summer.",
    options: ["go", "going", "went"],
    answer: "go",
    explanation: "'Go' est la forme correcte au présent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ breakfast when I arrived.",
    options: ["was having", "is having", "had"],
    answer: "was having",
    explanation: "'Was having' est le passé continu.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ a great time at the party.",
    options: ["had", "have", "having"],
    answer: "had",
    explanation: "'Had' est le passé de 'have'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my friends every weekend.",
    options: ["see", "sees", "seeing"],
    answer: "see",
    explanation: "'See' est la forme correcte pour 'I' au présent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the cinema last night.",
    options: ["go", "went", "going"],
    answer: "went",
    explanation: "'Went' est le passé du verbe 'go'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ going to the museum tomorrow.",
    options: ["are", "is", "am"],
    answer: "are",
    explanation: "'Are' est utilisé avec 'we' pour indiquer le futur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to the store every week.",
    options: ["goes", "going", "went"],
    answer: "goes",
    explanation:
        "'Goes' est la forme correcte pour la troisième personne du singulier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a book right now.",
    options: ["am reading", "reading", "read"],
    answer: "am reading",
    explanation: "'Am reading' indique une action en cours.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to the gym three times a week.",
    options: ["goes", "go", "gone"],
    answer: "goes",
    explanation: "'Goes' est la forme correcte pour 'he' au présent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a new dress for the party.",
    options: ["buy", "buys", "bought"],
    answer: "bought",
    explanation: "'Bought' est le passé du verbe 'buy'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ playing video games every evening.",
    options: ["enjoys", "enjoy", "enjoyed"],
    answer: "enjoys",
    explanation: "'Enjoys' est utilisé pour 'he' au présent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ a picnic in the park last weekend.",
    options: ["had", "have", "has"],
    answer: "had",
    explanation: "'Had' est le passé du verbe 'have'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a lot of fun at the concert.",
    options: ["had", "have", "has"],
    answer: "had",
    explanation: "'Had' est utilisé pour exprimer une expérience passée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to finish our homework before dinner.",
    options: ["need", "needs", "needing"],
    answer: "need",
    explanation: "'Need' est utilisé pour exprimer une nécessité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She is going to the _____ tomorrow.",
    options: ["party", "school", "cinema"],
    answer: "party",
    explanation: "Le mot 'party' indique un événement social.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I want to buy a _____ for my birthday.",
    options: ["new car", "old book", "big house"],
    answer: "new car",
    explanation: "'New car' indique un désir pour un objet récent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She loves to _____ in the morning.",
    options: ["run", "ran", "running"],
    answer: "run",
    explanation: "'Run' est l'infinitif correct après 'loves to'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He is taller _____ his brother.",
    options: ["than", "then", "with"],
    answer: "than",
    explanation: "'Than' est utilisé pour comparer deux choses.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to the museum last week.",
    options: ["went", "go", "gone"],
    answer: "went",
    explanation: "'Went' est le passé du verbe 'go'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "This book is _____ interesting than the last one.",
    options: ["more", "most", "less"],
    answer: "more",
    explanation: "'More' est utilisé pour comparer des adjectifs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Anglais — Texte à trous",
    question: "She has lived here _____ five years.",
    options: ["since", "for", "by"],
    answer: "for",
    explanation: "'For' indique une durée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my friend at the café yesterday.",
    options: ["met", "meet", "meeting"],
    answer: "met",
    explanation: "'Met' est le passé de 'meet'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "If it rains, we will _____ inside.",
    options: ["stay", "stayed", "staying"],
    answer: "stay",
    explanation: "'Stay' est l'infinitif correct pour le futur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her keys in the car.",
    options: ["forgot", "forgets", "forgetting"],
    answer: "forgot",
    explanation: "'Forgot' est le passé de 'forget'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They are _____ to the concert tonight.",
    options: ["going", "go", "gone"],
    answer: "going",
    explanation: "'Going' est le présent continu.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "You should _____ your homework before dinner.",
    options: ["finish", "finished", "finishing"],
    answer: "finish",
    explanation: "'Finish' est l'infinitif après 'should'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I have never _____ sushi before.",
    options: ["eaten", "eat", "eats"],
    answer: "eaten",
    explanation: "'Eaten' est le participe passé de 'eat'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She wishes she _____ a better job.",
    options: ["had", "has", "have"],
    answer: "had",
    explanation: "'Had' est utilisé dans les souhaits au passé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "If I _____ you, I would apologize.",
    options: ["were", "was", "am"],
    answer: "were",
    explanation: "'Were' est utilisé dans les phrases conditionnelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The book, _____ I read last week, was amazing.",
    options: ["that", "who", "which"],
    answer: "that",
    explanation: "'That' est utilisé pour relier des clauses.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I will call you when I _____ home.",
    options: ["get", "got", "getting"],
    answer: "get",
    explanation: "'Get' est l'infinitif après 'will'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his homework every evening.",
    options: ["do", "does", "doing"],
    answer: "does",
    explanation: "Pour 'he', on utilise 'does' au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ like chocolate ice cream.",
    options: ["doesn't", "don't", "not"],
    answer: "doesn't",
    explanation: "Pour 'she', on utilise 'doesn't' pour la négation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my keys on the table.",
    options: ["put", "puts", "putting"],
    answer: "put",
    explanation: "Le verbe 'to put' au passé est 'put'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to finish their project.",
    options: ["need", "needs", "needing"],
    answer: "need",
    explanation: "Le verbe 'to need' reste 'need' pour le pluriel.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a book in my bag.",
    options: ["have", "has", "had"],
    answer: "have",
    explanation: "Utilisez 'have' pour la première personne du singulier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to music every evening.",
    options: ["listens", "listen", "listened"],
    answer: "listens",
    explanation:
        "'Listens' est la forme correcte pour la troisième personne du singulier au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to finish the project by Friday.",
    options: ["need", "needs", "needing"],
    answer: "need",
    explanation: "Utilisez 'need' avec 'we'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my homework before dinner.",
    options: ["do", "did", "doing"],
    answer: "do",
    explanation: "Utilisez 'do' pour la première personne au présent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ in Paris last summer.",
    options: ["were", "was", "are"],
    answer: "were",
    explanation: "'Were' est le passé du verbe 'to be' pour le pluriel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to the gym every day.",
    options: ["go", "went", "going"],
    answer: "go",
    explanation: "Utilisez 'go' pour parler d'une habitude.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ very happy about the news.",
    options: ["is", "are", "were"],
    answer: "is",
    explanation:
        "'Is' est la forme correcte pour la troisième personne au présent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my friends at the park.",
    options: ["meet", "meets", "met"],
    answer: "meet",
    explanation: "Utilisez 'meet' pour parler d'une habitude.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ a great time at the concert.",
    options: ["had", "have", "has"],
    answer: "had",
    explanation: "'Had' est le passé du verbe 'to have'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to help his mother every weekend.",
    options: ["tries", "try", "tried"],
    answer: "tries",
    explanation: "Utilisez 'tries' pour la troisième personne au présent.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ the train at 5 PM yesterday.",
    options: ["caught", "catch", "catches"],
    answer: "caught",
    explanation: "'Caught' est le passé du verbe 'to catch'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ to the beach last weekend.",
    options: ["went", "going", "go"],
    answer: "went",
    explanation: "'Went' est le passé du verbe 'to go'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his homework before dinner.",
    options: ["did", "doing", "do"],
    answer: "did",
    explanation: "C'est la forme correcte du verbe au passé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She is _____ than her sister.",
    options: ["taller", "tallest", "tall"],
    answer: "taller",
    explanation: "On utilise 'taller' pour comparer deux personnes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the party last weekend.",
    options: ["went", "go", "going"],
    answer: "went",
    explanation: "C'est le passé simple du verbe 'go'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her keys again.",
    options: ["lost", "losing", "lose"],
    answer: "lost",
    explanation: "C'est le passé simple du verbe 'lose'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ a lot of fun at the park.",
    options: ["had", "having", "have"],
    answer: "had",
    explanation: "C'est le passé simple du verbe 'have'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "It _____ raining when I left.",
    options: ["was", "is", "were"],
    answer: "was",
    explanation: "C'est la forme correcte du verbe au passé continu.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He doesn't _____ coffee in the morning.",
    options: ["drink", "drinks", "drinking"],
    answer: "drink",
    explanation: "C'est la forme correcte de la négation au présent.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She is _____ a great artist.",
    options: ["becoming", "became", "become"],
    answer: "becoming",
    explanation: "C'est la forme du verbe au présent continu.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my friend yesterday.",
    options: ["met", "meet", "meeting"],
    answer: "met",
    explanation: "C'est le passé simple du verbe 'meet'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to visit us next month.",
    options: ["plan", "planning", "planned"],
    answer: "plan",
    explanation: "C'est la forme correcte du verbe au présent.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I have _____ friends in my class.",
    options: ["many", "much", "a little"],
    answer: "many",
    explanation: "'Many' est utilisé avec des noms dénombrables.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "What _____ you like to eat for breakfast?",
    options: ["do", "does", "is"],
    answer: "do",
    explanation: "Forme interrogative avec 'do' pour le présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her homework yesterday.",
    options: ["finished", "finishes", "finish"],
    answer: "finished",
    explanation: "Utilisation du passé simple pour une action terminée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to the cinema next week.",
    options: ["go", "going", "will go"],
    answer: "will go",
    explanation: "Futur simple avec 'will'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ likes to play video games.",
    options: ["often", "seldom", "never"],
    answer: "often",
    explanation: "Adverbe de fréquence en anglais.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my keys at home.",
    options: ["left", "leave", "leaving"],
    answer: "left",
    explanation: "Passé simple du verbe 'to leave'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ a beautiful dress.",
    options: ["wears", "is wearing", "wore"],
    answer: "is wearing",
    explanation: "Présent continu pour une action en cours.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ never been to Paris.",
    options: ["has", "is", "was"],
    answer: "has",
    explanation: "Utilisation de 'have' pour les expériences.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "Can you _____ me the answer?",
    options: ["give", "gives", "giving"],
    answer: "give",
    explanation: "Forme de l'impératif en anglais.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to the gym regularly.",
    options: ["goes", "went", "going"],
    answer: "goes",
    explanation: "Présent simple pour une habitude.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ in London last summer.",
    options: ["visited", "visits", "visiting"],
    answer: "visited",
    explanation: "Passé simple pour une action terminée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He is _____ than his friend at math.",
    options: ["better", "good", "well"],
    answer: "better",
    explanation: "Comparatif de 'good'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a book from the library.",
    options: ["borrowed", "borrowing", "borrows"],
    answer: "borrowed",
    explanation: "Passé simple du verbe 'to borrow'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ soccer in the park.",
    options: ["play", "plays", "playing"],
    answer: "play",
    explanation:
        "Le verbe 'to play' au présent simple pour la troisième personne du pluriel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to the beach in summer.",
    options: ["go", "going", "gone"],
    answer: "go",
    explanation:
        "Le verbe 'to go' au présent simple pour la première personne du pluriel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ her friends on weekends.",
    options: ["meets", "meet", "meeting"],
    answer: "meets",
    explanation:
        "Le verbe 'to meet' au présent simple pour la troisième personne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his bicycle to school.",
    options: ["rides", "ride", "riding"],
    answer: "rides",
    explanation:
        "Le verbe 'to ride' au présent simple pour la troisième personne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ a picnic in the park.",
    options: ["have", "has", "had"],
    answer: "have",
    explanation:
        "Le verbe 'to have' au présent simple pour la première personne du pluriel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the concert last week.",
    options: ["went", "go", "going"],
    answer: "went",
    explanation: "Le verbe 'to go' au passé simple.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a letter last month.",
    options: ["wrote", "write", "writing"],
    answer: "wrote",
    explanation: "Le verbe 'to write' au passé simple.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a new job next year.",
    options: ["will start", "start", "started"],
    answer: "will start",
    explanation: "Utilisation du futur simple avec 'will'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to Paris next summer.",
    options: ["is going", "goes", "go"],
    answer: "is going",
    explanation: "Utilisation du futur proche avec 'is going to'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ the project next month.",
    options: ["will finish", "finish", "finished"],
    answer: "will finish",
    explanation: "Utilisation du futur simple avec 'will'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ in London for two years.",
    options: ["has lived", "lived", "is living"],
    answer: "has lived",
    explanation: "Utilisation du présent perfect pour une action continue.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to the gym every week.",
    options: ["go", "gone", "went"],
    answer: "go",
    explanation: "Le verbe au présent simple est 'go'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to London last summer.",
    options: ["travelled", "travels", "traveling"],
    answer: "travelled",
    explanation: "Le verbe au passé est 'travelled'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his friends at the café.",
    options: ["meets", "met", "meet"],
    answer: "met",
    explanation: "Le verbe au passé est 'met'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The children _____ in the park.",
    options: ["play", "played", "plays"],
    answer: "play",
    explanation: "Le verbe au présent simple est 'play'.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ soccer in the park yesterday.",
    options: ["played", "play", "playing"],
    answer: "played",
    explanation: "Le passé du verbe 'to play' est 'played'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a great time at the party last night.",
    options: ["had", "have", "having"],
    answer: "had",
    explanation: "Le passé du verbe 'to have' est 'had'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my friends at the café last week.",
    options: ["met", "meet", "meeting"],
    answer: "met",
    explanation: "Le passé du verbe 'to meet' est 'met'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ a movie on Friday night.",
    options: ["watched", "watch", "watching"],
    answer: "watched",
    explanation: "Le passé du verbe 'to watch' est 'watched'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I usually _____ breakfast at 8 AM.",
    options: ["have", "had", "having"],
    answer: "have",
    explanation: "Le verbe 'to have' au présent simple est 'have'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to the gym every morning.",
    options: ["goes", "went", "go"],
    answer: "goes",
    explanation:
        "Le verbe 'to go' au présent simple pour la troisième personne est 'goes'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ their vacation in Italy last year.",
    options: ["enjoyed", "enjoy", "enjoying"],
    answer: "enjoyed",
    explanation: "Le passé du verbe 'to enjoy' est 'enjoyed'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to her favorite song on the radio.",
    options: ["listens", "listened", "listening"],
    answer: "listened",
    explanation: "Le passé du verbe 'to listen' est 'listened'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ for a walk in the evening.",
    options: ["went", "go", "going"],
    answer: "went",
    explanation: "Le passé du verbe 'to go' est 'went'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ the guitar every day after school.",
    options: ["plays", "played", "playing"],
    answer: "plays",
    explanation: "Le verbe 'to play' au présent simple est 'plays'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ a picnic in the park last Sunday.",
    options: ["had", "have", "having"],
    answer: "had",
    explanation: "Le passé du verbe 'to have' est 'had'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ the book before the meeting.",
    options: ["read", "reads", "reading"],
    answer: "read",
    explanation: "Le passé du verbe 'to read' est 'read' (prononcé 'red').",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ a lot of photos during my trip.",
    options: ["took", "take", "taking"],
    answer: "took",
    explanation: "Le passé du verbe 'to take' est 'took'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ swimming in the lake yesterday.",
    options: ["go", "went", "gone"],
    answer: "went",
    explanation: "Le passé simple du verbe 'to go'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the party last night.",
    options: ["come", "came", "coming"],
    answer: "came",
    explanation: "Le passé simple du verbe 'to come'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I will _____ you tomorrow.",
    options: ["see", "saw", "seen"],
    answer: "see",
    explanation: "La forme de base du verbe 'to see'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to music while studying.",
    options: ["listens", "listening", "listen"],
    answer: "listens",
    explanation: "Verbe au présent simple pour la troisième personne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The weather is _____ today than yesterday.",
    options: ["worse", "bad", "worst"],
    answer: "worse",
    explanation: "Comparatif pour décrire la météo.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I have _____ to the cinema this week.",
    options: ["gone", "went", "go"],
    answer: "gone",
    explanation: "Participe passé du verbe 'to go'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ not like spicy food.",
    options: ["does", "do", "is"],
    answer: "does",
    explanation: "Utilisation de 'does' dans une phrase négative.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I will _____ my vacation next month.",
    options: ["enjoy", "enjoying", "enjoys"],
    answer: "enjoy",
    explanation: "Verbe à l'infinitif sans 'to'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The cat is _____ the sofa.",
    options: ["under", "over", "next"],
    answer: "under",
    explanation: "Préposition pour indiquer une position.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ a car last year.",
    options: ["buys", "buy", "bought"],
    answer: "bought",
    explanation: "Le passé de 'buy' est 'bought'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I have _____ homework to do.",
    options: ["some", "any", "no"],
    answer: "some",
    explanation:
        "On utilise 'some' dans les phrases affirmatives avec des quantités.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to the cinema on Fridays.",
    options: ["go", "going", "gone"],
    answer: "go",
    explanation:
        "Le verbe 'to go' est utilisé pour des actions habituelles au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ like to eat pizza.",
    options: ["would", "will", "can"],
    answer: "would",
    explanation:
        "'Would' est utilisé pour exprimer un souhait ou une préférence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my favorite movie last night.",
    options: ["watched", "watch", "watches"],
    answer: "watched",
    explanation: "Le passé de 'watch' est 'watched'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ going to the park later.",
    options: ["are", "is", "be"],
    answer: "are",
    explanation: "On utilise 'are' pour 'they' au présent continu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ to read books in my free time.",
    options: ["love", "loves", "loving"],
    answer: "love",
    explanation: "'Love' est utilisé avec 'I' au présent simple.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to play soccer every weekend.",
    options: ["love", "loves", "loving"],
    answer: "loves",
    explanation: "Pour la troisième personne, 'love' devient 'loves'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ a picnic in the park tomorrow.",
    options: ["have", "has", "having"],
    answer: "have",
    explanation: "Le verbe 'have' est utilisé avec 'we' au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The cat is _____ on the chair.",
    options: ["sleeping", "sleep", "sleeps"],
    answer: "sleeping",
    explanation: "Le verbe 'sleep' au présent continu prend 'ing'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She _____ to the gym twice a week.",
    options: ["go", "goes", "going"],
    answer: "goes",
    explanation: "Avec 'she', le verbe 'go' devient 'goes'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the concert last Friday.",
    options: ["went", "go", "going"],
    answer: "went",
    explanation: "Le passé de 'go' est 'went'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ my friends after school.",
    options: ["meet", "meets", "meeting"],
    answer: "meet",
    explanation: "Le verbe 'meet' est utilisé au présent simple.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We _____ to visit the museum next week.",
    options: ["are going", "go", "going"],
    answer: "are going",
    explanation: "La forme correcte pour le futur est 'are going to'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ coffee every morning.",
    options: ["drinks", "drink", "drinking"],
    answer: "drinks",
    explanation: "Pour la troisième personne, 'drink' devient 'drinks'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I _____ to learn a new language.",
    options: ["want", "wants", "wanting"],
    answer: "want",
    explanation: "Le verbe 'want' n'a pas de 's' avec 'I'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ his homework every day.",
    options: ["does", "do", "doing"],
    answer: "does",
    explanation: "Avec 'he', on utilise 'does'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She is going to _____ a cake for the party.",
    options: ["bake", "make", "cook"],
    answer: "bake",
    explanation: "Le verbe 'bake' signifie cuire au four.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "They _____ to the movies last night.",
    options: ["went", "go", "going"],
    answer: "went",
    explanation: "'Went' est le passé du verbe 'go'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He _____ to the gym every week.",
    options: ["go", "goes", "going"],
    answer: "goes",
    explanation: "'Goes' est utilisé avec 'he' au présent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I will _____ a letter to my friend.",
    options: ["write", "writes", "writing"],
    answer: "write",
    explanation: "'Write' est l'infinitif du verbe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We are _____ to the beach this weekend.",
    options: ["going", "go", "gone"],
    answer: "going",
    explanation: "'Going' est la forme correcte pour le futur proche.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "The film was _____ interesting than the book.",
    options: ["more", "most", "much"],
    answer: "more",
    explanation: "'More' est utilisé pour former le comparatif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I enjoy _____ to new places.",
    options: ["traveling", "travel", "travels"],
    answer: "traveling",
    explanation: "'Traveling' est le gérondif du verbe 'travel'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "He has _____ ideas for the project.",
    options: ["great", "greater", "greatest"],
    answer: "great",
    explanation: "'Great' est un adjectif positif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "I would like to _____ a new car.",
    options: ["buy", "buys", "buying"],
    answer: "buy",
    explanation: "'Buy' est l'infinitif du verbe.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "She has been working here _____ three years.",
    options: ["for", "since", "during"],
    answer: "for",
    explanation: "'For' est utilisé avec des périodes de temps.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Anglais — Texte à trous",
    question: "We will meet _____ the park tomorrow.",
    options: ["at", "in", "on"],
    answer: "at",
    explanation: "'At' est utilisé pour des points spécifiques.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizLangueEtrangereAnglais extends StatefulWidget {
  static const String routeName =
      '/gpx_exam/concours/langue_etrangere/exemples_anglais';
  final String uid;
  final String email;

  const QuizLangueEtrangereAnglais({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizLangueEtrangereAnglais> createState() =>
      _QuizLangueEtrangereAnglaisState();
}

class _QuizLangueEtrangereAnglaisState extends State<QuizLangueEtrangereAnglais>
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
        ? questionLangueEtrangereAnglais
        : questionLangueEtrangereAnglais
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
            'module_name': 'Langue étrangère - Anglais',
            'quiz_name': 'Quiz langue étrangère anglais',
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
      await _sb.from('quiz_langue_etrangere_anglais').insert({
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
      debugPrint('❌ quiz_langue_etrangere_anglais insert failed: $e');
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
