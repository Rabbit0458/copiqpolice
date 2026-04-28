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
import 'package:copiqpolice/core/widgets/app_notifier.dart'
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

final List<QuizQuestion> questionLangueEtrangereAllemand = [
  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ ein Buch.",
    options: ["lese", "sehen", "essen"],
    answer: "lese",
    explanation: "Le verbe 'lesen' signifie lire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat _____ Hund.",
    options: ["ein", "eine", "einen"],
    answer: "einen",
    explanation: "'Hund' est masculin et nécessite l'accusatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir gehen _____ Schule.",
    options: ["zur", "zu", "in"],
    answer: "zur",
    explanation: "'Zur' est utilisé pour indiquer un lieu féminin.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie arbeiten _____ Büro.",
    options: ["im", "in", "an"],
    answer: "im",
    explanation: "'Im' est la contraction de 'in dem'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich liebe _____ Kaffee.",
    options: ["der", "den", "das"],
    answer: "den",
    explanation: "'Kaffee' est masculin et à l'accusatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Du spielst _____ Fußball.",
    options: ["gerne", "gut", "viel"],
    answer: "gerne",
    explanation: "'Gerne' exprime le plaisir de faire quelque chose.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir haben _____ Zeit.",
    options: ["viel", "wenig", "ganz"],
    answer: "viel",
    explanation: "'Viel' signifie beaucoup de temps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie fährt _____ Zug.",
    options: ["mit", "zu", "an"],
    answer: "mit",
    explanation: "'Mit' indique le moyen de transport utilisé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Wetter ist heute _____.",
    options: ["schön", "schlecht", "warm"],
    answer: "schön",
    explanation: "'Schön' signifie beau.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich gehe morgen _____ Party.",
    options: ["zu", "in", "an"],
    answer: "zu",
    explanation: "'Zu' indique la direction vers un événement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er mag _____ Apfel.",
    options: ["einen", "ein", "eine"],
    answer: "einen",
    explanation: "'Apfel' est masculin à l'accusatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie tanzt _____ Musik.",
    options: ["zur", "mit", "von"],
    answer: "zur",
    explanation: "'Zur' indique le mouvement vers un événement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ Geschenk bekommen.",
    options: ["ein", "einen", "eine"],
    answer: "ein",
    explanation: "'Geschenk' est neutre au nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Du bist _____ müde.",
    options: ["sehr", "nicht", "immer"],
    answer: "sehr",
    explanation: "'Sehr' signifie très.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir essen _____ Pizza.",
    options: ["eine", "ein", "einen"],
    answer: "eine",
    explanation: "'Pizza' est féminin au nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich sehe _____ Film.",
    options: ["einen", "eine", "ein"],
    answer: "einen",
    explanation: "'Film' est masculin à l'accusatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er liest _____ Buch.",
    options: ["ein", "eine", "einen"],
    answer: "ein",
    explanation: "'Buch' est neutre au nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie fährt _____ Auto.",
    options: ["mit", "in", "zu"],
    answer: "mit",
    explanation: "'Mit' indique le moyen de transport.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte _____ Kaffee.",
    options: ["einen", "ein", "eine"],
    answer: "einen",
    explanation: "'Kaffee' est masculin à l'accusatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir gehen _____ Haus.",
    options: ["ins", "in", "an"],
    answer: "ins",
    explanation: "'Ins' est une contraction de 'in das'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Du hast _____ Idee.",
    options: ["eine", "ein", "einen"],
    answer: "eine",
    explanation: "'Idee' est féminin au nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich finde das _____ interessant.",
    options: ["sehr", "nicht", "immer"],
    answer: "sehr",
    explanation: "'Sehr' exprime le degré d'intérêt.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er möchte _____ essen.",
    options: ["etwas", "nichts", "alles"],
    answer: "etwas",
    explanation: "'Etwas' signifie quelque chose.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie kommt _____ Stadt.",
    options: ["aus", "von", "in"],
    answer: "aus",
    explanation: "'Aus' indique l'origine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir gehen _____ Schwimmen.",
    options: ["zum", "in", "an"],
    answer: "zum",
    explanation: "'Zum' indique une destination.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ Hunger.",
    options: ["viel", "wenig", "keinen"],
    answer: "viel",
    explanation: "'Viel' signifie beaucoup de faim.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Buch liegt _____ Tisch.",
    options: ["auf", "an", "in"],
    answer: "auf",
    explanation: "'Auf' indique une position sur une surface.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie spielt _____ Klavier.",
    options: ["das", "ein", "eine"],
    answer: "das",
    explanation: "'Klavier' est neutre au nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich gehe _____ Kino.",
    options: ["ins", "in", "an"],
    answer: "ins",
    explanation: "'Ins' est une contraction de 'in das'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er ist _____ Lehrer.",
    options: ["ein", "eine", "einen"],
    answer: "ein",
    explanation: "'Lehrer' est masculin au nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir haben _____ Spaß.",
    options: ["viel", "wenig", "keinen"],
    answer: "viel",
    explanation: "'Viel' signifie beaucoup de plaisir.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie fährt _____ Fahrrad.",
    options: ["mit", "auf", "in"],
    answer: "mit",
    explanation: "'Mit' indique le moyen de transport utilisé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich finde das _____ schön.",
    options: ["sehr", "nicht", "immer"],
    answer: "sehr",
    explanation: "'Sehr' exprime un degré d'appréciation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Du bist _____ nett.",
    options: ["sehr", "nicht", "immer"],
    answer: "sehr",
    explanation: "'Sehr' signifie très gentil.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat _____ Idee.",
    options: ["eine", "ein", "einen"],
    answer: "eine",
    explanation: "'Idee' est féminin au nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte _____ trinken.",
    options: ["etwas", "nichts", "alles"],
    answer: "etwas",
    explanation: "'Etwas' signifie quelque chose à boire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir gehen _____ Urlaub.",
    options: ["in", "zu", "auf"],
    answer: "in",
    explanation:
        "'In' est utilisé pour indiquer une destination de type 'vacances'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie isst _____ Brot.",
    options: ["ein", "eine", "einen"],
    answer: "ein",
    explanation: "'Brot' est neutre au nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat _____ Auto.",
    options: ["ein", "eine", "einen"],
    answer: "ein",
    explanation: "'Auto' est neutre au nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir gehen _____ einkaufen.",
    options: ["zum", "in", "an"],
    answer: "zum",
    explanation: "'Zum' indique une destination commerciale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich sehe _____ Fernsehen.",
    options: ["das", "ein", "eine"],
    answer: "das",
    explanation: "'Fernsehen' est neutre au nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat _____ Hund.",
    options: ["einen", "ein", "eine"],
    answer: "einen",
    explanation: "'Hund' est masculin à l'accusatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ ein Bild malen.",
    options: ["möchte", "will", "kann"],
    answer: "möchte",
    explanation: "'Möchte' exprime un souhait.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir essen _____ Abendessen.",
    options: ["das", "eine", "ein"],
    answer: "das",
    explanation: "'Abendessen' est neutre au nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie macht _____ Hausaufgaben.",
    options: ["die", "eine", "ein"],
    answer: "die",
    explanation: "'Hausaufgaben' est féminin au pluriel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich höre _____ Musik.",
    options: ["die", "eine", "ein"],
    answer: "die",
    explanation: "'Musik' est féminin au nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er geht _____ Schule.",
    options: ["in", "zu", "an"],
    answer: "zu",
    explanation: "'Zu' indique la direction vers un établissement scolaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir fahren _____ Auto.",
    options: ["mit", "in", "zu"],
    answer: "mit",
    explanation: "'Mit' indique le moyen de transport utilisé.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Wetter ist heute sehr _____ .",
    options: ["schön", "schlecht", "neu"],
    answer: "schön",
    explanation: "Le mot 'schön' signifie beau.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Mein Bruder ist _____ als ich.",
    options: ["älter", "jünger", "kleiner"],
    answer: "älter",
    explanation: "Le mot 'älter' signifie plus âgé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er spielt _____ Fußball jeden Samstag.",
    options: ["gern", "nicht", "immer"],
    answer: "gern",
    explanation: "Le mot 'gern' signifie avec plaisir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe ein _____ Buch gelesen.",
    options: ["interessantes", "langweiliges", "kurzes"],
    answer: "interessantes",
    explanation: "Le mot 'interessantes' signifie intéressant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie spricht _____ Englisch und Deutsch.",
    options: ["gut", "schlecht", "wenig"],
    answer: "gut",
    explanation: "Le mot 'gut' signifie bien.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er arbeitet _____ in einer Firma.",
    options: ["jeden Tag", "manchmal", "nie"],
    answer: "jeden Tag",
    explanation: "Le mot 'jeden Tag' signifie tous les jours.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir fahren _____ nach Berlin.",
    options: ["nächste Woche", "gestern", "jetzt"],
    answer: "nächste Woche",
    explanation: "Le mot 'nächste Woche' signifie la semaine prochaine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ Zeit, um zu lernen.",
    options: ["wenig", "viel", "keine"],
    answer: "viel",
    explanation: "Le mot 'viel' signifie beaucoup.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Die Katze schläft _____ auf dem Sofa.",
    options: ["oft", "nie", "manchmal"],
    answer: "oft",
    explanation: "Le mot 'oft' signifie souvent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich brauche mehr _____ für das Projekt.",
    options: ["Zeit", "Hilfe", "Geld"],
    answer: "Hilfe",
    explanation: "Le mot 'Hilfe' signifie aide.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Mein Lieblingsfilm ist _____ .",
    options: ["spannend", "langweilig", "kurz"],
    answer: "spannend",
    explanation: "Le mot 'spannend' signifie captivant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ ins Kino gehen.",
    options: ["möchte", "gehen", "sehe"],
    answer: "möchte",
    explanation: "Le verbe 'möchte' signifie 'je voudrais'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Heute ist es sehr _____ draußen.",
    options: ["schön", "schlecht", "warm"],
    answer: "schön",
    explanation: "Le mot 'schön' signifie 'beau' en français.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ morgen einen Ausflug machen.",
    options: ["werden", "haben", "sind"],
    answer: "werden",
    explanation: "Le verbe 'werden' signifie 'devenir' ou 'aller faire'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Der Hund _____ im Garten.",
    options: ["spielt", "schläft", "isst"],
    answer: "spielt",
    explanation: "Le verbe 'spielen' signifie 'jouer'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ ein neues Buch gekauft.",
    options: ["gestern", "heute", "morgen"],
    answer: "gestern",
    explanation: "Le mot 'gestern' signifie 'hier'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat seine Hausaufgaben _____ gemacht.",
    options: ["schnell", "gut", "langsam"],
    answer: "gut",
    explanation: "Le mot 'gut' signifie 'bien'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Die Blumen _____ im Frühling blühen.",
    options: ["wachsen", "verblühen", "warten"],
    answer: "wachsen",
    explanation: "Le verbe 'wachsen' signifie 'croître'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie _____ jeden Morgen joggen.",
    options: ["mögen", "geht", "läuft"],
    answer: "geht",
    explanation: "Le verbe 'gehen' signifie 'aller'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir haben _____ viel Spaß gehabt.",
    options: ["gestern", "schon", "immer"],
    answer: "gestern",
    explanation: "Le mot 'gestern' signifie 'hier'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich brauche ein neues _____ .",
    options: ["Auto", "Haus", "Buch"],
    answer: "Buch",
    explanation: "Le mot 'Buch' signifie 'livre'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er _____ gerne Musik.",
    options: ["hört", "sieht", "macht"],
    answer: "hört",
    explanation: "Le verbe 'hören' signifie 'écouter'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe heute _____ gegessen.",
    options: ["Pizza", "Salat", "Brot"],
    answer: "Pizza",
    explanation: "Le mot 'Pizza' est le même en français.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Der Lehrer _____ die Fragen.",
    options: ["stellt", "stellt vor", "schreibt"],
    answer: "stellt",
    explanation: "Le verbe 'stellen' signifie 'poser'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ nach Berlin reisen.",
    options: ["möchten", "können", "müssen"],
    answer: "möchten",
    explanation: "Le verbe 'möchten' signifie 'vouloir'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich gehe heute _____ ins Bett.",
    options: ["früh", "spät", "gerne"],
    answer: "früh",
    explanation: "Le mot 'früh' signifie 'tôt'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Die Katze _____ auf dem Tisch.",
    options: ["liegt", "sitzt", "steht"],
    answer: "liegt",
    explanation: "Le verbe 'liegen' signifie 'être couché'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ ins Kino gehen.",
    options: ["will", "nicht", "kann"],
    answer: "will",
    explanation: "Le verbe 'will' indique une intention future.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Wetter ist heute sehr _____.",
    options: ["schön", "schlecht", "warm"],
    answer: "schlecht",
    explanation: "Le mot 'schlecht' décrit un temps mauvais.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Mein Bruder _____ in Berlin.",
    options: ["lebt", "geht", "fährt"],
    answer: "lebt",
    explanation: "Le verbe 'lebt' signifie vivre dans une ville.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ einen neuen Film sehen.",
    options: ["möchten", "müssen", "sollen"],
    answer: "möchten",
    explanation: "'Möchten' exprime un souhait.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er spielt gerne _____ Fußball.",
    options: ["immer", "oft", "selten"],
    answer: "oft",
    explanation: "'Oft' signifie fréquemment.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir treffen uns _____ dem Café.",
    options: ["vor", "nach", "in"],
    answer: "in",
    explanation: "'In' désigne un lieu où l'on se retrouve.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Die Kinder _____ im Garten spielen.",
    options: ["können", "dürfen", "müssen"],
    answer: "dürfen",
    explanation: "'Dürfen' signifie avoir la permission.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Buch ist _____ interessant.",
    options: ["sehr", "nicht", "zu"],
    answer: "sehr",
    explanation: "'Sehr' signifie très, utilisé pour intensifier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ viele Freunde.",
    options: ["nicht", "so", "zu"],
    answer: "so",
    explanation: "'So' signifie beaucoup dans ce contexte.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir fahren _____ nach Deutschland.",
    options: ["nächste Woche", "heute", "morgen"],
    answer: "morgen",
    explanation: "'Morgen' indique le lendemain.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat _____ keine Zeit.",
    options: ["heute", "immer", "nie"],
    answer: "heute",
    explanation: "'Heute' signifie aujourd'hui.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte _____ ein neues Auto kaufen.",
    options: ["bald", "nie", "immer"],
    answer: "bald",
    explanation: "'Bald' signifie bientôt.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir gehen _____ ins Restaurant.",
    options: ["jetzt", "später", "früher"],
    answer: "jetzt",
    explanation: "'Jetzt' signifie maintenant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Die Blumen sind _____ schön.",
    options: ["sehr", "immer", "nicht"],
    answer: "sehr",
    explanation: "'Sehr' est utilisé pour renforcer l'adjectif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich finde deinen Vorschlag _____ gut.",
    options: ["auch", "sehr", "nicht"],
    answer: "sehr",
    explanation: "'Sehr' renforce l'idée que c'est un bon avis.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir müssen _____ gehen.",
    options: ["jetzt", "später", "immer"],
    answer: "jetzt",
    explanation: "'Jetzt' indique qu'il faut partir tout de suite.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ gerne Musik.",
    options: ["höre", "hören", "hörst"],
    answer: "höre",
    explanation: "Le verbe 'hören' signifie 'écouter'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe ein _____ Buch.",
    options: ["neues", "neu", "neueste"],
    answer: "neues",
    explanation: "'Neues' est l'adjectif au neutre pluriel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er ist mein bester _____ .",
    options: ["Freund", "Freunde", "Freundin"],
    answer: "Freund",
    explanation: "'Freund' signifie 'ami'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich finde das _____ interessant.",
    options: ["Film", "Filme", "Filmes"],
    answer: "Film",
    explanation: "'Film' est un nom masculin singulier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir fahren _____ nach Berlin.",
    options: ["nächste", "nächsten", "nächstes"],
    answer: "nächsten",
    explanation:
        "'Nächsten' est l'adjectif au masculin pour indiquer le futur proche.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Buch liegt _____ dem Tisch.",
    options: ["auf", "unter", "neben"],
    answer: "auf",
    explanation: "'Auf' signifie 'sur'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie hat _____ neue Schuhe gekauft.",
    options: ["ein", "eine", "einen"],
    answer: "eine",
    explanation: "'Eine' est l'article indéfini féminin en accusatif.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ ein Buch.",
    options: ["liebe", "liebt", "liebte"],
    answer: "liebe",
    explanation: "Le verbe 'lieben' signifie 'aimer'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ ins Kino gehen.",
    options: ["möchte", "möchten", "möchteen"],
    answer: "möchten",
    explanation:
        "'Möchten' est le conditionnel de 'mögen', signifiant 'vouloir'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie _____ in Berlin.",
    options: ["lebt", "leben", "lebte"],
    answer: "lebt",
    explanation: "'Lebt' est la forme correcte pour 'elle vit'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Wetter ist heute sehr _____.",
    options: ["schön", "schöne", "schöner"],
    answer: "schön",
    explanation: "'Schön' signifie 'beau' et s'accorde avec 'Wetter'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ einen Apfel.",
    options: ["esse", "isst", "essen"],
    answer: "esse",
    explanation: "'Esse' est la première personne du verbe 'essen' (manger).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ morgen eine Party.",
    options: ["haben", "hat", "hatten"],
    answer: "haben",
    explanation: "'Haben' signifie 'avoir' et est utilisé ici au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Die Katze _____ auf dem Tisch.",
    options: ["sitzt", "sitzen", "saß"],
    answer: "sitzt",
    explanation: "'Sitzt' est la forme correcte pour 'elle s'assoit'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er _____ gerne Fußball.",
    options: ["spielt", "spielen", "spielte"],
    answer: "spielt",
    explanation: "'Spielt' est la forme correcte pour 'il joue'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ kein Fleisch.",
    options: ["esse", "isst", "essen"],
    answer: "esse",
    explanation: "'Esse' est utilisé pour 'je mange'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ sehr müde.",
    options: ["sind", "sein", "ist"],
    answer: "sind",
    explanation:
        "'Sind' est la première personne du pluriel du verbe 'sein' (être).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ das Fenster auf.",
    options: ["mache", "machst", "macht"],
    answer: "mache",
    explanation: "'Mache' signifie 'faire', utilisé ici au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie _____ die ganze Nacht.",
    options: ["schlief", "schlafen", "schläft"],
    answer: "schlief",
    explanation: "'Schlief' est le passé du verbe 'schlafen' (dormir).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er _____ ein neues Auto.",
    options: ["kauft", "kaufen", "kaufe"],
    answer: "kauft",
    explanation: "'Kauft' est la forme correcte pour 'il achète'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ nach Hause.",
    options: ["fahren", "fährt", "fahre"],
    answer: "fahren",
    explanation:
        "'Fahren' signifie 'aller' en véhicule, utilisé ici au pluriel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ ein Geschenk für dich.",
    options: ["kaufe", "kauft", "kaufen"],
    answer: "kaufe",
    explanation:
        "'Kaufe' est la première personne du verbe 'kaufen' (acheter).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Heute ist es _____ draußen.",
    options: ["kalt", "schnell", "blau"],
    answer: "kalt",
    explanation: "Le mot 'kalt' signifie 'froid'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ gern Musik.",
    options: ["höre", "schau", "spiele"],
    answer: "höre",
    explanation: "Le verbe 'hören' signifie 'écouter'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Mein Bruder ist _____ alt.",
    options: ["fünf", "sieben", "drei"],
    answer: "sieben",
    explanation: "Le mot 'sieben' signifie 'sept'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir essen _____ am Abend.",
    options: ["frühstück", "zu Mittag", "Abendessen"],
    answer: "Abendessen",
    explanation: "'Abendessen' signifie 'dîner'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich trinke _____ Wasser.",
    options: ["viel", "wenig", "kein"],
    answer: "viel",
    explanation: "'Viel' signifie 'beaucoup'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das ist mein _____ Freund.",
    options: ["alter", "neuer", "schöner"],
    answer: "neuer",
    explanation: "'Neuer' signifie 'nouveau'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ einen Hund.",
    options: ["auch", "nicht", "gerne"],
    answer: "auch",
    explanation: "'Auch' signifie 'aussi'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er fährt _____ nach Berlin.",
    options: ["morgen", "freitag", "gestern"],
    answer: "morgen",
    explanation: "'Morgen' signifie 'demain'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe Lust auf _____ .",
    options: ["Schokolade", "Bücher", "Sport"],
    answer: "Schokolade",
    explanation: "'Schokolade' signifie 'chocolat'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat _____ viele Bücher.",
    options: ["sehr", "nicht", "wenig"],
    answer: "sehr",
    explanation: "'Sehr' signifie 'très'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie liest _____ ihre Nachrichten.",
    options: ["gern", "nicht", "immer"],
    answer: "gern",
    explanation: "'Gern' signifie 'volontiers'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich mache _____ eine Reise.",
    options: ["bald", "oft", "niemals"],
    answer: "bald",
    explanation: "'Bald' signifie 'bientôt'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir gehen _____ Kino.",
    options: ["zum", "in", "auf"],
    answer: "zum",
    explanation: "'Zum' est utilisé pour indiquer une destination.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte _____ Wasser.",
    options: ["ein", "eine", "einen"],
    answer: "ein",
    explanation: "'Ein' est utilisé pour un nom neutre au cas nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir haben _____ Haus gekauft.",
    options: ["ein", "eine", "einen"],
    answer: "ein",
    explanation: "'Ein' est utilisé pour un nom neutre au cas accusatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie ist _____ Lehrerin.",
    options: ["eine", "ein", "einen"],
    answer: "eine",
    explanation: "'Eine' est utilisé pour un nom féminin au cas nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich trinke _____ Kaffee.",
    options: ["ein", "eine", "einen"],
    answer: "einen",
    explanation: "'Einen' est utilisé pour un nom masculin au cas accusatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir fahren _____ Berlin.",
    options: ["nach", "in", "zu"],
    answer: "nach",
    explanation: "'Nach' est utilisé pour les villes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Du hast _____ neue Schuhe.",
    options: ["einen", "ein", "eine"],
    answer: "eine",
    explanation: "'Eine' est utilisé pour un nom féminin au cas accusatif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er ist _____ Arzt.",
    options: ["ein", "eine", "einen"],
    answer: "ein",
    explanation: "'Ein' est utilisé pour un nom masculin au cas nominatif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie geht _____ Schule.",
    options: ["in", "zu", "nach"],
    answer: "in",
    explanation: "'In' est utilisé pour les bâtiments.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ Katze.",
    options: ["eine", "einen", "ein"],
    answer: "eine",
    explanation: "'Eine' est utilisé pour un nom féminin au cas accusatif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er liest _____ Zeitung.",
    options: ["eine", "ein", "einen"],
    answer: "eine",
    explanation: "'Eine' est utilisé pour un nom féminin au cas accusatif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir spielen _____ Fußball.",
    options: ["einen", "ein", "eine"],
    answer: "einen",
    explanation: "'Einen' est utilisé pour un nom masculin au cas accusatif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Kind hat _____ Ball.",
    options: ["einen", "ein", "eine"],
    answer: "einen",
    explanation: "'Einen' est utilisé pour un nom masculin au cas accusatif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte _____ Apfel.",
    options: ["eine", "einen", "ein"],
    answer: "einen",
    explanation: "'Einen' est utilisé pour un nom masculin au cas accusatif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe einen neuen _____ gekauft.",
    options: ["Hund", "Auto", "Buch"],
    answer: "Hund",
    explanation: "Le mot 'Hund' signifie 'chien'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Morgen _____ wir eine Prüfung.",
    options: ["haben", "sehen", "essen"],
    answer: "haben",
    explanation: "Le verbe 'haben' signifie 'avoir'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie ist sehr _____ in der Schule.",
    options: ["intelligent", "schlecht", "langweilig"],
    answer: "intelligent",
    explanation: "Le mot 'intelligent' signifie 'intelligent'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir fahren im Sommer _____ .",
    options: ["nach Deutschland", "mit dem Auto", "zu Fuß"],
    answer: "nach Deutschland",
    explanation: "'Nach Deutschland' indique une destination.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte ein _____ essen.",
    options: ["Eis", "Buch", "Auto"],
    answer: "Eis",
    explanation: "Le mot 'Eis' signifie 'glace'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Der Lehrer fragt, ob wir _____ sind.",
    options: ["bereit", "schüchtern", "hungrig"],
    answer: "bereit",
    explanation: "Le mot 'bereit' signifie 'prêt'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir haben gestern einen _____ gesehen.",
    options: ["Film", "Buch", "Stuhl"],
    answer: "Film",
    explanation: "Le mot 'Film' signifie 'film'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich finde das Wetter heute _____ .",
    options: ["schön", "kalt", "heiß"],
    answer: "heiß",
    explanation: "Le mot 'heiß' signifie 'chaud'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat einen neuen _____ .",
    options: ["Job", "Film", "Hund"],
    answer: "Job",
    explanation: "Le mot 'Job' signifie 'emploi'.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich gehe _____ ins Kino.",
    options: ["gerne", "schön", "schnell"],
    answer: "gerne",
    explanation: "Le mot 'gerne' signifie 'volontiers'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Wetter ist heute _____.",
    options: ["schlecht", "schöner", "gut"],
    answer: "gut",
    explanation: "Le mot 'gut' signifie 'bien'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ Buch gelesen.",
    options: ["ein", "drei", "zwei"],
    answer: "ein",
    explanation: "Le mot 'ein' signifie 'un'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er spielt _____ Fußball.",
    options: ["oft", "schön", "gut"],
    answer: "oft",
    explanation: "Le mot 'oft' signifie 'souvent'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ Zeit.",
    options: ["wenig", "viel", "kein"],
    answer: "viel",
    explanation: "Le mot 'viel' signifie 'beaucoup'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das ist mein _____ Freund.",
    options: ["bester", "schöner", "neuer"],
    answer: "bester",
    explanation: "Le mot 'bester' signifie 'meilleur'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er fährt _____ nach Berlin.",
    options: ["schnell", "gern", "langsam"],
    answer: "gern",
    explanation: "Le mot 'gern' signifie 'volontiers'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir gehen _____ nach Hause.",
    options: ["jetzt", "schon", "immer"],
    answer: "jetzt",
    explanation: "Le mot 'jetzt' signifie 'maintenant'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Essen ist _____ lecker.",
    options: ["sehr", "nicht", "immer"],
    answer: "sehr",
    explanation: "Le mot 'sehr' signifie 'très'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich mag _____ Musik hören.",
    options: ["gern", "schlecht", "nie"],
    answer: "gern",
    explanation: "Le mot 'gern' signifie 'avec plaisir'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat _____ Geburtstag.",
    options: ["heute", "gestern", "morgen"],
    answer: "heute",
    explanation: "Le mot 'heute' signifie 'aujourd'hui'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir sind _____ zu Hause.",
    options: ["nicht", "schon", "immer"],
    answer: "nicht",
    explanation: "Le mot 'nicht' signifie 'pas'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie spricht _____ Deutsch.",
    options: ["fließend", "schlecht", "langsam"],
    answer: "fließend",
    explanation: "Le mot 'fließend' signifie 'couramment'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Buch ist _____ neu.",
    options: ["nicht", "sehr", "immer"],
    answer: "sehr",
    explanation: "Le mot 'sehr' signifie 'très'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir haben _____ Zeit.",
    options: ["keine", "viel", "wenig"],
    answer: "keine",
    explanation: "Le mot 'keine' signifie 'aucun'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich bin _____ müde.",
    options: ["sehr", "nicht", "immer"],
    answer: "sehr",
    explanation: "Le mot 'sehr' signifie 'très'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Wetter wird _____ schlecht.",
    options: ["nicht", "immer", "bald"],
    answer: "bald",
    explanation: "Le mot 'bald' signifie 'bientôt'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich gehe heute _____ ins Kino.",
    options: ["nicht", "ja", "vielleicht"],
    answer: "nicht",
    explanation: "Le mot 'nicht' signifie 'pas'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir essen heute _____ Pizza.",
    options: ["eine", "zwei", "drei"],
    answer: "eine",
    explanation: "Le mot 'eine' est l'article indéfini au féminin en allemand.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir fahren _____ nach Berlin.",
    options: ["morgen", "heute", "gestern"],
    answer: "morgen",
    explanation: "Le mot 'morgen' signifie 'demain'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ Hund.",
    options: ["einen", "eine", "das"],
    answer: "einen",
    explanation: "'Einen' est l'article indéfini au masculin en accusatif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie geht _____ in die Schule.",
    options: ["immer", "manchmal", "selten"],
    answer: "immer",
    explanation: "Le mot 'immer' signifie 'toujours'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte ein _____ kaufen.",
    options: ["Auto", "Haus", "Buch"],
    answer: "Auto",
    explanation: "Le mot 'Auto' signifie 'voiture'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat _____ viele Freunde.",
    options: ["nicht", "sehr", "zu"],
    answer: "sehr",
    explanation: "Le mot 'sehr' signifie 'très'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir essen _____ Abendbrot.",
    options: ["zum", "in", "auf"],
    answer: "zum",
    explanation: "Le mot 'zum' signifie 'pour le'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das ist mein _____ Lehrer.",
    options: ["neuer", "alter", "guter"],
    answer: "neuer",
    explanation: "Le mot 'neuer' signifie 'nouveau'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir haben _____ einen Test.",
    options: ["bald", "schon", "jetzt"],
    answer: "bald",
    explanation: "Le mot 'bald' signifie 'bientôt'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie liest _____ Buch.",
    options: ["ein", "das", "viele"],
    answer: "ein",
    explanation: "'Ein' est l'article indéfini au neutre en allemand.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich gehe _____ ins Bett.",
    options: ["früh", "spät", "gern"],
    answer: "früh",
    explanation: "Le mot 'früh' signifie 'tôt'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir haben _____ viel Spaß.",
    options: ["immer", "manchmal", "nicht"],
    answer: "immer",
    explanation: "Le mot 'immer' signifie 'toujours'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ jeden Morgen um sieben Uhr auf.",
    options: ["stehe auf", "gehe zur Schule", "esse Frühstück"],
    answer: "stehe auf",
    explanation: "Le verbe 'aufstehen' signifie se lever.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat _____ ein neues Auto gekauft.",
    options: ["sich", "mir", "ihm"],
    answer: "sich",
    explanation: "Le pronom 'sich' est utilisé pour les verbes réflexifs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ im Sommer nach Deutschland reisen.",
    options: ["wollen", "können", "müssen"],
    answer: "wollen",
    explanation: "Le verbe 'wollen' signifie vouloir.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich finde den Film _____ interessant.",
    options: ["sehr", "nicht", "weniger"],
    answer: "sehr",
    explanation: "L'adverbe 'sehr' signifie très.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Die Katze schläft _____ auf dem Sofa.",
    options: ["gerne", "schnell", "immer"],
    answer: "immer",
    explanation: "L'adverbe 'immer' signifie toujours.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Hast du _____ Zeit, um zu helfen?",
    options: ["viel", "wenig", "kein"],
    answer: "viel",
    explanation: "L'adjectif 'viel' signifie beaucoup.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ am Freitag ein Fest.",
    options: ["feiern", "sehen", "essen"],
    answer: "feiern",
    explanation: "Le verbe 'feiern' signifie célébrer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie _____ jeden Tag joggen.",
    options: ["möchte", "geht", "hat"],
    answer: "geht",
    explanation: "Le verbe 'gehen' signifie aller.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ gerne Bücher lesen.",
    options: ["liebe", "esse", "trinke"],
    answer: "liebe",
    explanation: "Le verbe 'lieben' signifie aimer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Kannst du mir _____ helfen?",
    options: ["ein bisschen", "nichts", "alles"],
    answer: "ein bisschen",
    explanation: "L'expression 'ein bisschen' signifie un peu.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Wetter ist heute _____ schön.",
    options: ["sehr", "nicht", "wenig"],
    answer: "sehr",
    explanation: "L'adverbe 'sehr' signifie très.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ immer früh ins Bett.",
    options: ["gehe", "schlafe", "esse"],
    answer: "gehe",
    explanation: "Le verbe 'gehen' signifie aller.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Die Blumen _____ im Frühling blühen.",
    options: ["werden", "gehen", "sind"],
    answer: "werden",
    explanation: "Le verbe 'werden' signifie devenir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ in der Schule viel lernen.",
    options: ["müssen", "können", "wollen"],
    answer: "müssen",
    explanation: "Le verbe 'müssen' signifie devoir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ nach der Schule nach Hause.",
    options: ["gehe", "komme", "schreibe"],
    answer: "gehe",
    explanation: "Le verbe 'gehen' signifie aller.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat _____ einen Hund.",
    options: ["nicht", "kein", "wenig"],
    answer: "kein",
    explanation: "Le mot 'kein' signifie aucun.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ am Wochenende wandern.",
    options: ["möchten", "können", "müssen"],
    answer: "möchten",
    explanation: "Le verbe 'möchten' signifie aimer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ heute Abend nach Hause.",
    options: ["komme", "gehe", "esse"],
    answer: "gehe",
    explanation: "Le verbe 'gehen' signifie aller.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie _____ immer pünktlich zur Arbeit.",
    options: ["kommt", "geht", "fahren"],
    answer: "kommt",
    explanation: "Le verbe 'kommen' signifie venir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ ein Buch lesen.",
    options: ["möchte", "will", "kann"],
    answer: "möchte",
    explanation: "Le verbe 'möchte' exprime un souhait.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ Buch gelesen.",
    options: ["ein", "die", "das"],
    answer: "das",
    explanation: "Le mot 'Buch' est neutre en allemand, donc on utilise 'das'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir gehen _____ Park.",
    options: ["in", "auf", "an"],
    answer: "in",
    explanation:
        "On utilise 'in' pour indiquer un mouvement vers un lieu fermé comme un parc.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Die Katze sitzt _____ Tisch.",
    options: ["auf", "in", "neben"],
    answer: "auf",
    explanation:
        "On utilise 'auf' pour indiquer que quelque chose est sur une surface.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich mag _____ Musik.",
    options: ["die", "der", "das"],
    answer: "die",
    explanation: "'Musik' est féminin, donc on utilise 'die'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er kommt _____ München.",
    options: ["aus", "von", "in"],
    answer: "aus",
    explanation: "'Aus' signifie 'de' en allemand, utilisé pour les villes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie spricht _____ schnell.",
    options: ["zu", "nicht", "sehr"],
    answer: "sehr",
    explanation:
        "'Sehr' signifie 'très', utilisé pour intensifier un adjectif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe keine _____ Zeit.",
    options: ["mehr", "weniger", "viel"],
    answer: "mehr",
    explanation:
        "'Keine mehr' signifie 'plus de', utilisé pour exprimer une absence.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat _____ viele Freunde.",
    options: ["zu", "sehr", "genug"],
    answer: "zu",
    explanation:
        "'Zu viele' signifie 'trop de', utilisé pour exprimer une quantité excessive.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe das Buch _____ gelesen.",
    options: ["schon", "nie", "immer"],
    answer: "schon",
    explanation: "'Schon' signifie 'déjà', indiquant une action accomplie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das ist der _____ Weg.",
    options: ["lange", "lange", "längste"],
    answer: "längste",
    explanation:
        "'Längste' est le superlatif de 'lang', utilisé pour décrire le chemin.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich kann das nicht _____.",
    options: ["glauben", "glaubt", "glaubt"],
    answer: "glauben",
    explanation: "'Glauben' est l'infinitif utilisé après 'kann'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir haben _____ viele Aufgaben.",
    options: ["nicht", "so", "wenig"],
    answer: "so",
    explanation:
        "'So viele' signifie 'tant de', utilisé pour exprimer une grande quantité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir treffen uns _____ Café.",
    options: ["im", "auf", "an"],
    answer: "im",
    explanation:
        "'Im' est la contraction de 'in dem', utilisé pour les lieux fermés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Wetter ist _____ heute.",
    options: ["schön", "schöne", "schöner"],
    answer: "schön",
    explanation: "L'adjectif 'schön' signifie 'beau'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich sehe _____ Film.",
    options: ["das", "den", "die"],
    answer: "den",
    explanation: "Le mot 'den' est l'article défini accusatif masculin.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie _____ gerne Musik.",
    options: ["hören", "hörst", "hört"],
    answer: "hören",
    explanation: "Le verbe 'hören' signifie 'écouter'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir fahren _____ Urlaub.",
    options: ["in", "nach", "zu"],
    answer: "in",
    explanation: "La préposition 'in' est utilisée pour les pays.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Die Katze ist _____ Tisch.",
    options: ["unter", "über", "neben"],
    answer: "unter",
    explanation: "Le mot 'unter' signifie 'sous'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ Idee.",
    options: ["eine", "ein", "einen"],
    answer: "eine",
    explanation: "Le mot 'eine' est un article indéfini féminin.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Auto ist _____ neu.",
    options: ["nicht", "kein", "sehr"],
    answer: "sehr",
    explanation: "Le mot 'sehr' signifie 'très'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte _____ kaufen.",
    options: ["das", "einen", "ein"],
    answer: "ein",
    explanation: "Le mot 'ein' est un article indéfini.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie ist _____ freundlich.",
    options: ["sehr", "viel", "wenig"],
    answer: "sehr",
    explanation: "L'adverbe 'sehr' signifie 'très'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich spiele _____ Fußball.",
    options: ["gerne", "gern", "lieber"],
    answer: "gern",
    explanation: "Le mot 'gern' signifie 'avec plaisir'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das ist _____ beste Geschenk.",
    options: ["das", "die", "den"],
    answer: "das",
    explanation: "Le mot 'das' est un article défini neutre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ Apfel gekauft.",
    options: ["ein", "eine", "einen"],
    answer: "einen",
    explanation: "Le mot 'Apfel' est masculin, donc on utilise 'einen'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er geht _____ Schule.",
    options: ["in die", "zum", "an die"],
    answer: "in die",
    explanation: "On dit 'in die Schule' pour aller à l'école.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Wetter ist heute _____ .",
    options: ["schön", "schöne", "schöner"],
    answer: "schön",
    explanation: "On utilise l'adjectif 'schön' au neutre ici.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich spiele gern _____ Fußball.",
    options: ["die", "den", "das"],
    answer: "den",
    explanation: "On dit 'den Fußball' pour parler du football.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte _____ gehen.",
    options: ["nach Hause", "zu Hause", "in Haus"],
    answer: "nach Hause",
    explanation: "On dit 'nach Hause' pour indiquer le retour à la maison.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir fahren _____ Urlaub.",
    options: ["zum", "in", "auf"],
    answer: "zum",
    explanation: "On dit 'zum Urlaub' pour aller en vacances.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er arbeitet _____ Lehrer.",
    options: ["als", "zu", "von"],
    answer: "als",
    explanation: "On utilise 'als' pour indiquer la profession.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie hat _____ Hund.",
    options: ["einen", "eine", "ein"],
    answer: "einen",
    explanation: "'Hund' est masculin, donc on utilise 'einen'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat _____ neue Schuhe.",
    options: ["ein", "einen", "neue"],
    answer: "ein",
    explanation:
        "'Schuhe' est pluriel, donc on utilise 'ein' pour parler d'un type de chaussure.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ gern Fußball.",
    options: ["spiele", "essen", "trinke"],
    answer: "spiele",
    explanation: "Le verbe 'spielen' signifie 'jouer'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich gehe _____ ins Kino.",
    options: ["nicht", "auch", "immer"],
    answer: "auch",
    explanation: "'Auch' signifie 'aussi'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich wohne in einem _____ Haus.",
    options: ["schönen", "großen", "alten"],
    answer: "großen",
    explanation: "'Großen' signifie 'grand'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Hast du _____ Zeit?",
    options: ["ein wenig", "viel", "keine"],
    answer: "viel",
    explanation: "'Viel' signifie 'beaucoup'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie ist meine beste _____ .",
    options: ["Freundin", "Schwester", "Lehrerin"],
    answer: "Freundin",
    explanation: "'Freundin' signifie 'amie'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Buch liegt _____ dem Tisch.",
    options: ["unter", "über", "neben"],
    answer: "unter",
    explanation: "'Unter' signifie 'sous'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ ein Geschenk bekommen.",
    options: ["gestern", "morgen", "heute"],
    answer: "gestern",
    explanation: "'Gestern' signifie 'hier'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich mag _____ Musik hören.",
    options: ["gerne", "nie", "schlecht"],
    answer: "gerne",
    explanation: "'Gerne' signifie 'avec plaisir'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir haben _____ einen Ausflug gemacht.",
    options: ["immer", "schon", "oft"],
    answer: "schon",
    explanation: "'Schon' signifie 'déjà'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das ist _____ teuer.",
    options: ["zu", "nicht", "sehr"],
    answer: "sehr",
    explanation: "'Sehr' signifie 'très'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie arbeitet _____ im Büro.",
    options: ["gerne", "nie", "manchmal"],
    answer: "gerne",
    explanation: "'Gerne' signifie 'avec plaisir'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ gekauft.",
    options: ["ein Buch", "ein Auto", "eine Katze"],
    answer: "ein Buch",
    explanation: "Le verbe 'kaufen' signifie acheter.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir gehen _____ Kino.",
    options: ["ins", "zum", "auf"],
    answer: "ins",
    explanation:
        "La préposition 'ins' est utilisée pour indiquer un mouvement vers un lieu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er spielt _____ Klavier.",
    options: ["das", "ein", "viele"],
    answer: "ein",
    explanation:
        "Le mot 'ein' est utilisé pour désigner un objet non spécifique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie trinkt _____ Wasser.",
    options: ["viel", "wenig", "ein"],
    answer: "viel",
    explanation: "Le mot 'viel' signifie beaucoup.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich mache _____ Sport.",
    options: ["gern", "nicht", "wenig"],
    answer: "gern",
    explanation: "Le mot 'gern' signifie avec plaisir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er kommt _____ Berlin.",
    options: ["aus", "von", "in"],
    answer: "aus",
    explanation: "La préposition 'aus' signifie 'de'.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er geht _____ nach Hause.",
    options: ["schnell", "schneller", "schnellste"],
    answer: "schnell",
    explanation: "'Schnell' signifie 'vite' en allemand.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ihr _____ immer zu spät.",
    options: ["seid", "sind", "ist"],
    answer: "seid",
    explanation: "'Seid' est la forme pour 'vous' au pluriel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Mein Freund spielt _____ Gitarre.",
    options: ["die", "das", "eine"],
    answer: "die",
    explanation: "'Die' est l'article défini féminin en allemand.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir haben _____ viel Spaß.",
    options: ["sehr", "zu", "wenig"],
    answer: "sehr",
    explanation: "'Sehr' signifie 'très' en allemand.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte einen Kaffee _____ .",
    options: ["trinken", "trinke", "trinkst"],
    answer: "trinken",
    explanation: "'Trinken' signifie 'boire'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Die Katze schläft _____ auf dem Sofa.",
    options: ["gerne", "gern", "lieber"],
    answer: "gerne",
    explanation: "'Gerne' signifie 'volontiers'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie spricht _____ gut Englisch.",
    options: ["sehr", "wenig", "nicht"],
    answer: "sehr",
    explanation: "'Sehr' signifie 'très'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich finde den Film _____ langweilig.",
    options: ["sehr", "ein", "zu"],
    answer: "sehr",
    explanation: "'Sehr' signifie 'très'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ viele Fragen.",
    options: ["sehr", "wenig", "manche"],
    answer: "sehr",
    explanation: "'Sehr' signifie 'beaucoup'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das ist ein _____ Auto.",
    options: ["schnell", "schnelles", "schneller"],
    answer: "schnelles",
    explanation: "'Schnelles' est l'adjectif au neutre en allemand.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir gehen _____ Park.",
    options: ["ins", "auf", "an"],
    answer: "ins",
    explanation:
        "'Ins' est la contraction de 'in das', utilisée pour indiquer un mouvement vers un lieu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat einen _____ Hund.",
    options: ["schönen", "neu", "groß"],
    answer: "schönen",
    explanation:
        "'Schönen' est l'adjectif qui signifie 'beau', accordé au nom 'Hund'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie _____ nach Hause.",
    options: ["geht", "laufen", "fährt"],
    answer: "geht",
    explanation: "'Geht' est le verbe pour 'aller' à pied.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ ein neues Auto.",
    options: ["kaufe", "verkaufe", "benutze"],
    answer: "kaufe",
    explanation: "'Kaufen' signifie 'acheter', une action courante.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie _____ sehr gut Deutsch.",
    options: ["spricht", "hören", "sehen"],
    answer: "spricht",
    explanation: "'Spricht' est le verbe pour 'parler' en allemand.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Mein Bruder _____ Fußball.",
    options: ["spielt", "macht", "geht"],
    answer: "spielt",
    explanation:
        "'Spielt' signifie 'jouer', utilisé dans le contexte des sports.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ gerne Kaffee.",
    options: ["trinke", "esse", "höre"],
    answer: "trinke",
    explanation: "'Trinke' signifie 'boire', utilisé pour les boissons.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Kind spielt _____ Garten.",
    options: ["im", "an", "auf"],
    answer: "im",
    explanation:
        "'Im' est la contraction de 'in dem', utilisée pour les lieux intérieurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie haben _____ Zeit.",
    options: ["viel", "wenig", "keine"],
    answer: "viel",
    explanation:
        "'Viel' signifie 'beaucoup', souvent utilisé pour parler de temps.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte _____ lernen.",
    options: ["Deutsch", "Französisch", "Englisch"],
    answer: "Deutsch",
    explanation:
        "'Deutsch' signifie 'allemand', la langue que l'on veut apprendre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie gehen _____ Schule.",
    options: ["zur", "in", "auf"],
    answer: "zur",
    explanation:
        "'Zur' est la contraction de 'zu der', utilisée pour indiquer un lieu.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir treffen uns _____ Abend.",
    options: ["am", "in", "auf"],
    answer: "am",
    explanation: "'Am' est utilisé pour indiquer un moment de la journée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Auto ist _____ teuer.",
    options: ["sehr", "nicht", "wenig"],
    answer: "sehr",
    explanation:
        "'Sehr' signifie 'très', utilisé pour intensifier un adjectif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ gerne Bücher.",
    options: ["lesen", "schreiben", "essen"],
    answer: "lesen",
    explanation: "Le verbe 'lesen' signifie 'lire'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe einen _____ gekauft.",
    options: ["Hund", "Auto", "Haus"],
    answer: "Hund",
    explanation: "Le mot 'Hund' signifie 'chien'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er fährt mit dem _____ zur Arbeit.",
    options: ["Auto", "Zug", "Bus"],
    answer: "Bus",
    explanation: "Le mot 'Bus' signifie 'autobus'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Die Katze schläft auf dem _____.",
    options: ["Sofa", "Tisch", "Stuhl"],
    answer: "Sofa",
    explanation: "Le mot 'Sofa' signifie 'canapé'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte ein neues _____ kaufen.",
    options: ["Handy", "Auto", "Buch"],
    answer: "Handy",
    explanation: "Le mot 'Handy' signifie 'téléphone portable'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Im Sommer gehen wir oft _____ Strand.",
    options: ["an den", "auf den", "in den"],
    answer: "an den",
    explanation: "L'expression 'an den Strand' signifie 'à la plage'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe jeden Tag _____ Schule.",
    options: ["viel", "wenig", "keine"],
    answer: "viel",
    explanation: "Le mot 'viel' signifie 'beaucoup'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat seine Hausaufgaben _____.",
    options: ["gemacht", "vergessen", "gehabt"],
    answer: "gemacht",
    explanation: "Le mot 'gemacht' signifie 'fait'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ gesehen.",
    options: ["einen Film", "eine Katze", "ein Buch"],
    answer: "einen Film",
    explanation: "L'expression 'einen Film' signifie 'un film'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Der Lehrer erklärt die _____ gut.",
    options: ["Aufgabe", "Frage", "Antwort"],
    answer: "Aufgabe",
    explanation: "Le mot 'Aufgabe' signifie 'tâche'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir müssen jetzt _____ gehen.",
    options: ["nach Hause", "zum Markt", "in die Schule"],
    answer: "nach Hause",
    explanation: "L'expression 'nach Hause' signifie 'à la maison'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das ist ein _____ Bild.",
    options: ["schönes", "schlechtes", "altes"],
    answer: "schönes",
    explanation: "Le mot 'schönes' signifie 'beau'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ morgen eine Prüfung haben.",
    options: ["haben", "hast", "hat"],
    answer: "haben",
    explanation: "Le verbe 'haben' est conjugué pour 'wir'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie _____ gerne Bücher lesen.",
    options: ["liest", "lese", "lesen"],
    answer: "liest",
    explanation: "Le verbe 'lesen' est conjugué pour 'sie'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich trinke _____ Wasser.",
    options: ["ein", "einen", "das"],
    answer: "ein",
    explanation: "'Ein' est utilisé pour un nom masculin au nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das ist mein _____ Freund.",
    options: ["guter", "gutes", "guten"],
    answer: "guter",
    explanation: "L'adjectif 'gut' s'accorde au nominatif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Kannst du mir bitte _____ helfen?",
    options: ["einmal", "ein wenig", "ein bisschen"],
    answer: "ein bisschen",
    explanation: "'Ein bisschen' signifie 'un peu'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte _____ ins Ausland reisen.",
    options: ["auch", "gerne", "nicht"],
    answer: "gerne",
    explanation: "'Gerne' exprime le désir de faire quelque chose.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wo ist der _____ Bahnhof?",
    options: ["nächste", "nächsten", "nächster"],
    answer: "nächste",
    explanation: "'Nächste' est utilisé pour indiquer la proximité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ viele Freunde.",
    options: ["so", "zwei", "ein"],
    answer: "zwei",
    explanation: "'Zwei' signifie 'deux'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er liebt es, _____ zu schwimmen.",
    options: ["oft", "gerne", "manchmal"],
    answer: "gerne",
    explanation: "'Gerne' indique que l'on aime faire quelque chose.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir treffen uns _____ dem Park.",
    options: ["in", "an", "vor"],
    answer: "in",
    explanation: "'In' est utilisé pour indiquer un lieu.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich kann nicht _____ kommen.",
    options: ["morgen", "schon", "dort"],
    answer: "morgen",
    explanation: "'Morgen' signifie 'demain'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Essen schmeckt _____ gut.",
    options: ["sehr", "nicht", "zu"],
    answer: "sehr",
    explanation: "'Sehr' intensifie l'adjectif 'gut'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Wetter ist heute _____ und sonnig.",
    options: ["kalt", "heiß", "warm"],
    answer: "warm",
    explanation: "Le mot 'warm' signifie une température agréable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ Hund und zwei Katzen.",
    options: ["ein", "eine", "einen"],
    answer: "einen",
    explanation: "Le mot 'einen' est utilisé pour les objets masculins.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat _____ Freunde in Berlin.",
    options: ["viele", "wenig", "einige"],
    answer: "viele",
    explanation: "Le mot 'viele' indique une grande quantité.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er spielt _____ Fußball.",
    options: ["gerne", "nie", "oft"],
    answer: "gerne",
    explanation: "'Gerne' signifie 'avec plaisir'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie fährt _____ nach Berlin.",
    options: ["immer", "manchmal", "nie"],
    answer: "manchmal",
    explanation: "'Manchmal' signifie 'parfois'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich liebe _____ Musik.",
    options: ["deutsche", "alte", "schöne"],
    answer: "schöne",
    explanation: "'Schöne' signifie 'belle'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er ist _____ Lehrer.",
    options: ["guter", "schlechter", "bester"],
    answer: "guter",
    explanation: "'Guter' signifie 'bon'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir kaufen _____ ein Geschenk.",
    options: ["bald", "nie", "oft"],
    answer: "bald",
    explanation: "'Bald' signifie 'bientôt'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie spricht _____ Deutsch.",
    options: ["sehr gut", "wenig", "gar nicht"],
    answer: "sehr gut",
    explanation: "'Sehr gut' signifie 'très bien'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ einen Hund.",
    options: ["jetzt", "schon", "nie"],
    answer: "schon",
    explanation: "'Schon' signifie 'déjà'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich finde das _____ schön.",
    options: ["Haus", "Auto", "Buch"],
    answer: "Haus",
    explanation: "'Haus' signifie 'maison'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie möchte _____ gehen.",
    options: ["schlafen", "essen", "trinken"],
    answer: "essen",
    explanation: "'Essen' signifie 'manger'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie _____ in Berlin.",
    options: ["wohnt", "wohnst", "wohnen"],
    answer: "wohnt",
    explanation: "La bonne conjugaison pour 'sie' est 'wohnt'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ am Wochenende reisen.",
    options: ["wollen", "will", "wünscht"],
    answer: "wollen",
    explanation: "'Wollen' signifie vouloir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ mein Zimmer auf.",
    options: ["räume", "räumt", "räumen"],
    answer: "räume",
    explanation: "La première personne du singulier est 'räume'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er _____ sehr schnell.",
    options: ["läuft", "läufst", "laufen"],
    answer: "läuft",
    explanation: "'Er' exige la forme 'läuft'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ Pizza essen.",
    options: ["möchten", "mag", "mögt"],
    answer: "möchten",
    explanation: "'Möchten' est utilisé pour exprimer un désir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ in der Schule.",
    options: ["lerne", "lernst", "lernen"],
    answer: "lerne",
    explanation: "La bonne conjugaison pour 'ich' est 'lerne'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich _____ gern schwimmen.",
    options: ["mag", "möchte", "lieben"],
    answer: "mag",
    explanation: "Le verbe 'mögen' signifie aimer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ einen Film sehen.",
    options: ["sehen", "sieht", "seht"],
    answer: "sehen",
    explanation: "La forme correcte pour 'wir' est 'sehen'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das ist _____ tolle Idee.",
    options: ["eine", "ein", "einen"],
    answer: "eine",
    explanation: "'Idee' est féminin, donc 'eine' est correct.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er _____ ein Auto.",
    options: ["hat", "hast", "haben"],
    answer: "hat",
    explanation: "La forme correcte pour 'er' est 'hat'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir _____ nach Deutschland fahren.",
    options: ["fahren", "fährt", "fahre"],
    answer: "fahren",
    explanation: "La forme correcte pour 'wir' est 'fahren'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir gehen _____ ins Kino.",
    options: ["nicht", "gern", "sehr"],
    answer: "gern",
    explanation: "Le mot 'gern' signifie 'volontiers'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Die Katze sitzt _____ dem Tisch.",
    options: ["auf", "unter", "neben"],
    answer: "unter",
    explanation: "Le mot 'unter' signifie 'sous'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er hat _____ einen Hund.",
    options: ["nicht", "auch", "gerade"],
    answer: "auch",
    explanation: "Le mot 'auch' signifie 'aussi'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte _____ gehen.",
    options: ["nicht", "gerne", "immer"],
    answer: "gerne",
    explanation: "Le mot 'gerne' signifie 'volontiers'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie _____ sehr freundlich.",
    options: ["ist", "sind", "hat"],
    answer: "ist",
    explanation: "Le verbe 'sein' signifie 'être'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Heute ist es _____ warm.",
    options: ["sehr", "nicht", "immer"],
    answer: "sehr",
    explanation: "Le mot 'sehr' signifie 'très'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Wetter ist _____ schön.",
    options: ["nicht", "sehr", "immer"],
    answer: "sehr",
    explanation: "Le mot 'sehr' signifie 'très'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir essen _____ Pizza.",
    options: ["gerade", "nicht", "auch"],
    answer: "gerade",
    explanation: "Le mot 'gerade' signifie 'juste'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wo ist das _____ Restaurant?",
    options: ["neue", "alte", "schöne"],
    answer: "alte",
    explanation: "Le mot 'alte' signifie 'ancien'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie spielt _____ Klavier.",
    options: ["gut", "schlecht", "nicht"],
    answer: "gut",
    explanation: "Le mot 'gut' signifie 'bien'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich möchte _____ einen Kaffee.",
    options: ["trinken", "essen", "schlafen"],
    answer: "trinken",
    explanation: "Le verbe 'trinken' signifie 'boire'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich gehe _____ zur Schule.",
    options: ["nicht", "immer", "gerne"],
    answer: "gerne",
    explanation: "Le mot 'gerne' signifie 'volontiers'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir haben _____ einen neuen Lehrer.",
    options: ["nicht", "auch", "gerade"],
    answer: "gerade",
    explanation: "Le mot 'gerade' signifie 'juste'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Der Hund _____ schnell.",
    options: ["läuft", "schläft", "springt"],
    answer: "läuft",
    explanation: "Le verbe 'laufen' signifie 'courir'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie _____ gern Musik.",
    options: ["hört", "sieht", "macht"],
    answer: "hört",
    explanation: "Le verbe 'hören' signifie 'écouter'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Es ist _____ heute.",
    options: ["kalt", "heiß", "trocken"],
    answer: "kalt",
    explanation: "Le mot 'kalt' signifie 'froid'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Kannst du mir bitte _____ geben?",
    options: ["das Buch", "den Stift", "die Tasse"],
    answer: "den Stift",
    explanation: "'Den Stift' est l'article défini au masculin accusatif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Wir spielen _____ Fußball.",
    options: ["im", "auf", "zum"],
    answer: "im",
    explanation: "On dit 'im Fußball' pour 'au football'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das Wetter ist _____ heute.",
    options: ["schön", "schlecht", "warm"],
    answer: "schlecht",
    explanation: "Le mot 'schlecht' signifie 'mauvais'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich brauche _____ für die Schule.",
    options: ["ein Buch", "eine Tasse", "ein Stift"],
    answer: "ein Buch",
    explanation: "Le mot 'Buch' signifie 'livre'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er bringt _____ nach Hause.",
    options: ["das Essen", "die Blumen", "die Zeitung"],
    answer: "das Essen",
    explanation: "'Das Essen' signifie 'la nourriture'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe einen _____ gesehen.",
    options: ["Hund", "Hunde", "Hunden"],
    answer: "Hund",
    explanation: "Le mot 'Hund' signifie 'chien'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Mein Bruder spielt _____ Fußball.",
    options: ["gern", "gerne", "gert"],
    answer: "gern",
    explanation: "Le mot 'gern' signifie 'volontiers'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie _____ sehr schnell.",
    options: ["läuft", "lauf", "laufen"],
    answer: "läuft",
    explanation: "Le verbe 'laufen' signifie 'courir'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Das ist mein Lieblingsfilm. Ich finde ihn _____ .",
    options: ["toll", "tolle", "toller"],
    answer: "toll",
    explanation: "Adjectif 'toll' signifie 'super'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Er kommt _____ nach Hause.",
    options: ["spät", "späte", "später"],
    answer: "spät",
    explanation: "Le mot 'spät' signifie 'tard'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Ich habe _____ Fragen.",
    options: ["viele", "viel", "vielen"],
    answer: "viele",
    explanation: "Le mot 'viele' signifie 'beaucoup de'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Sie _____ ein schönes Kleid.",
    options: ["trägt", "tragen", "trage"],
    answer: "trägt",
    explanation: "Le verbe 'tragen' signifie 'porter'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Der Lehrer erklärt die _____ .",
    options: ["Regeln", "Regel", "Regeln"],
    answer: "Regeln",
    explanation: "Le mot 'Regeln' signifie 'règles'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Allemand — Texte à trous",
    question: "Es ist _____ kalt heute.",
    options: ["sehr", "viel", "manchmal"],
    answer: "sehr",
    explanation: "Le mot 'sehr' signifie 'très'.",
    difficulty: "Moyenne",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizLangueEtrangereAllemand extends StatefulWidget {
  static const String routeName =
      '/gpx_exam/concours/langue_etrangere/exemples_allemand';
  final String uid;
  final String email;

  const QuizLangueEtrangereAllemand({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizLangueEtrangereAllemand> createState() =>
      _QuizLangueEtrangereAllemandState();
}

class _QuizLangueEtrangereAllemandState
    extends State<QuizLangueEtrangereAllemand>
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
        ? questionLangueEtrangereAllemand
        : questionLangueEtrangereAllemand
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
            'module_name': 'Langue étrangère - Allemand',
            'quiz_name': 'Quiz langue étrangère allemand',
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
      await _sb.from('quiz_langue_etrangere_allemand').insert({
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
      debugPrint('❌ quiz_langue_etrangere_allemand insert failed: $e');
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
