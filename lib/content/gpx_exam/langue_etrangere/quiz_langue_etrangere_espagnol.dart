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

final List<QuizQuestion> questionLangueEtrangereEspagnol = [
  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta comer _____ en la cena.",
    options: ["pasta", "rápido", "feliz"],
    answer: "pasta",
    explanation: "Pasta est un plat courant en Espagne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Hoy hace mucho _____ en la playa.",
    options: ["nieve", "calor", "nublado"],
    answer: "calor",
    explanation: "Calor indique une température élevée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella va a _____ a sus amigos este fin de semana.",
    options: ["visitar", "verbo", "rápido"],
    answer: "visitar",
    explanation: "Visiter des amis est une activité fréquente.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro _____ en el parque.",
    options: ["correr", "rápidamente", "salta"],
    answer: "salta",
    explanation: "Les chiens aiment sauter dans les parcs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi hermana tiene un _____ muy bonito.",
    options: ["gato", "rápido", "rojo"],
    answer: "gato",
    explanation: "Les chats sont des animaux de compagnie populaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ a la escuela todos los días.",
    options: ["vamos", "rápido", "feliz"],
    answer: "vamos",
    explanation: "Aller à l'école est une routine quotidienne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Quiero comprar _____ para mi cumpleaños.",
    options: ["un coche", "rápido", "feliz"],
    answer: "un coche",
    explanation: "Acheter une voiture est un souhait courant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La película fue muy _____ y divertida.",
    options: ["aburrida", "interesante", "lenta"],
    answer: "interesante",
    explanation: "Les films intéressants attirent l'attention.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mañana _____ un examen importante.",
    options: ["tenemos", "feliz", "rápido"],
    answer: "tenemos",
    explanation: "Avoir un examen est courant dans les études.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El libro que leo es muy _____.",
    options: ["interesante", "rápido", "feliz"],
    answer: "interesante",
    explanation: "Un livre intéressant est captivant.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ayer _____ a mi abuela en el mercado.",
    options: ["vi", "feliz", "rápido"],
    answer: "vi",
    explanation: "Voir des membres de la famille est courant.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa de Juan es _____ que la mía.",
    options: ["más grande", "feliz", "rápido"],
    answer: "más grande",
    explanation: "Comparer les tailles des maisons est fréquent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Cuando llueve, llevo _____.",
    options: ["un paraguas", "feliz", "rápido"],
    answer: "un paraguas",
    explanation: "Un parapluie est utilisé pour la pluie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Los estudiantes _____ estudiar para el examen.",
    options: ["necesitan", "feliz", "rápido"],
    answer: "necesitan",
    explanation: "Les étudiants ont besoin d'étudier pour réussir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos y yo _____ al cine esta noche.",
    options: ["vamos", "feliz", "rápido"],
    answer: "vamos",
    explanation: "Aller au cinéma est une sortie populaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La comida en este restaurante es muy _____ .",
    options: ["rica", "feliz", "rápido"],
    answer: "rica",
    explanation: "La nourriture délicieuse attire les clients.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El clima en verano es _____ aquí.",
    options: ["caliente", "feliz", "rápido"],
    answer: "caliente",
    explanation: "Le climat est souvent chaud en été.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Quiero _____ un viaje a España el próximo año.",
    options: ["hacer", "feliz", "rápido"],
    answer: "hacer",
    explanation: "Faire un voyage est un projet excitant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El profesor _____ a explicar la lección.",
    options: ["empieza", "feliz", "rápido"],
    answer: "empieza",
    explanation: "Commencer une leçon est essentiel en classe.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Voy a _____ a mis amigos el sábado.",
    options: ["ver", "hablar", "encontrar"],
    answer: "ver",
    explanation: "Le verbe 'ver' signifie 'voir'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa es _____ grande que la mía.",
    options: ["más", "menos", "tan"],
    answer: "más",
    explanation: "Le mot 'más' signifie 'plus'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi hermana _____ dos años mayor que yo.",
    options: ["tiene", "es", "hace"],
    answer: "es",
    explanation: "Le verbe 'es' signifie 'est'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ a la playa el fin de semana.",
    options: ["vamos", "fuimos", "ir"],
    answer: "vamos",
    explanation: "Le verbe 'vamos' signifie 'nous allons'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ellos _____ muchas películas al mes.",
    options: ["ven", "ver", "vieron"],
    answer: "ven",
    explanation: "Le verbe 'ven' signifie 'ils voient'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ayer _____ un día muy bonito.",
    options: ["fue", "es", "era"],
    answer: "fue",
    explanation: "Le mot 'fue' indique le passé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Tienes _____ tiempo para hablar?",
    options: ["poco", "más", "mucho"],
    answer: "mucho",
    explanation: "Le mot 'mucho' signifie 'beaucoup'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Carlos _____ en Madrid desde hace un año.",
    options: ["vive", "vivió", "vivir"],
    answer: "vive",
    explanation: "Le verbe 'vive' signifie 'il vit'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi comida favorita es _____ pizza.",
    options: ["la", "un", "una"],
    answer: "la",
    explanation:
        "L'article 'la' est utilisé pour les noms féminins singuliers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mañana _____ a la escuela temprano.",
    options: ["voy", "fui", "va"],
    answer: "voy",
    explanation: "Le verbe 'voy' signifie 'je vais'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El clima hoy está _____ que ayer.",
    options: ["mejor", "peor", "igual"],
    answer: "mejor",
    explanation: "Le mot 'mejor' signifie 'meilleur'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ un vestido rojo para la fiesta.",
    options: ["lleva", "llevó", "llevar"],
    answer: "lleva",
    explanation: "Le verbe 'lleva' signifie 'elle porte'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El niño _____ a su hermana.",
    options: ["ayuda", "ayudó", "ayudar"],
    answer: "ayuda",
    explanation: "Le verbe 'ayuda' signifie 'aide'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Hoy es un día _____ para estudiar.",
    options: ["bueno", "malo", "interesante"],
    answer: "bueno",
    explanation: "Le mot 'bueno' signifie 'bon'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿_____ te gusta más, el té o el café?",
    options: ["Qué", "Cuál", "Cómo"],
    answer: "Cuál",
    explanation: "Le mot 'Cuál' est utilisé pour poser des choix.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El gato está _____ en la ventana.",
    options: ["sentado", "durmiendo", "comiendo"],
    answer: "sentado",
    explanation: "Le mot 'sentado' signifie 'assis'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa es muy _____.",
    options: ["grande", "pequeña", "rápida"],
    answer: "grande",
    explanation: "L'adjectif 'grande' signifie 'grand'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Voy a la tienda para comprar _____.",
    options: ["pan", "rápido", "grande"],
    answer: "pan",
    explanation: "Le pain est un aliment de base en Espagne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro es muy _____.",
    options: ["amable", "rápido", "grande"],
    answer: "amable",
    explanation: "Amable signifie 'gentil' ou 'aimable'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El clima hoy está muy _____.",
    options: ["frío", "rápido", "largo"],
    answer: "frío",
    explanation: "Frío signifie 'froid', un mot courant pour décrire la météo.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Quiero un café _____.",
    options: ["caliente", "rápido", "grande"],
    answer: "caliente",
    explanation:
        "Caliente signifie 'chaud', souvent utilisé pour les boissons.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El libro es muy _____.",
    options: ["interesante", "rápido", "frío"],
    answer: "interesante",
    explanation: "Utilisé pour décrire des livres captivants.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El coche es muy _____.",
    options: ["rápido", "amable", "pequeño"],
    answer: "rápido",
    explanation:
        "Rapide est un adjectif pour décrire la vitesse d'un véhicule.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El examen fue bastante _____.",
    options: ["fácil", "rápido", "largo"],
    answer: "fácil",
    explanation: "Facile indique que l'examen n'était pas difficile.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta el clima _____.",
    options: ["cálido", "rápido", "grande"],
    answer: "cálido",
    explanation: "Cálido signifie 'chaud', souvent utilisé pour le temps.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La ciudad es muy _____.",
    options: ["bonita", "rápida", "pequeña"],
    answer: "bonita",
    explanation: "Bonita signifie 'belle', utilisé pour décrire des lieux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Hoy tengo una reunión muy _____.",
    options: ["importante", "rápida", "fría"],
    answer: "importante",
    explanation: "Important indique la valeur d'une réunion.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mañana voy a visitar a mi _____.",
    options: ["abuela", "rápida", "largo"],
    answer: "abuela",
    explanation: "Abuela signifie 'grand-mère' en espagnol.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El tren es muy _____.",
    options: ["rápido", "bonito", "pequeño"],
    answer: "rápido",
    explanation: "Rapide décrit la vitesse d'un train.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La comida está muy _____.",
    options: ["rica", "rápida", "fría"],
    answer: "rica",
    explanation: "Rica signifie 'délicieuse' en espagnol.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El café está _____.",
    options: ["frío", "rápido", "grande"],
    answer: "frío",
    explanation: "Frío signifie 'froid', souvent pour les boissons.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta mucho _____ en la playa.",
    options: ["nadar", "correr", "leer"],
    answer: "nadar",
    explanation: "Nager est une activité populaire à la plage.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella tiene un gato _____",
    options: ["negro", "azul", "grande"],
    answer: "negro",
    explanation: "Le chat est noir.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ a la fiesta el sábado.",
    options: ["vamos", "fui", "ir"],
    answer: "vamos",
    explanation: "Nous allons à la fête samedi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi hermano _____ cinco años.",
    options: ["tiene", "es", "cumple"],
    answer: "tiene",
    explanation: "Mon frère a cinq ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Quiero comer _____ pizza.",
    options: ["una", "el", "los"],
    answer: "una",
    explanation: "Je veux manger une pizza.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El libro está _____ la mesa.",
    options: ["sobre", "bajo", "dentro"],
    answer: "sobre",
    explanation: "Le livre est sur la table.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro es muy _____",
    options: ["grande", "pequeño", "largo"],
    answer: "grande",
    explanation: "Le chien est très grand.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos _____ al cine el viernes.",
    options: ["van", "fueron", "ir"],
    answer: "van",
    explanation: "Mes amis vont au cinéma vendredi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Necesito _____ para mi examen.",
    options: ["estudiar", "jugar", "dormir"],
    answer: "estudiar",
    explanation: "J'ai besoin d'étudier pour mon examen.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El tren sale _____ las tres.",
    options: ["a", "en", "por"],
    answer: "a",
    explanation: "Le train part à trois heures.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa es _____ que la tuya.",
    options: ["más grande", "grande", "pequeña"],
    answer: "más grande",
    explanation: "La maison est plus grande que la tienne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El profesor _____ la clase.",
    options: ["da", "dar", "dando"],
    answer: "da",
    explanation: "Le professeur donne le cours.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Si tengo tiempo, _____ un libro.",
    options: ["leo", "leer", "leí"],
    answer: "leo",
    explanation: "Si j'ai le temps, je lis un livre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta mucho el _____ de la música.",
    options: ["estilo", "canción", "bailar"],
    answer: "canción",
    explanation: "La chanson est une forme musicale populaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella siempre lleva un _____ en su bolso.",
    options: ["libro", "zapato", "comida"],
    answer: "libro",
    explanation: "Un livre est souvent un objet personnel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El clima hoy está muy _____ y soleado.",
    options: ["frío", "caliente", "nublado"],
    answer: "caliente",
    explanation: "Le temps chaud est typique en été.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi hermano juega al _____ todos los domingos.",
    options: ["fútbol", "comida", "coche"],
    answer: "fútbol",
    explanation: "Le football est un sport très populaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ayer _____ una película muy interesante.",
    options: ["miramos", "comimos", "dormimos"],
    answer: "miramos",
    explanation: "Regarder un film est une activité de loisir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa tiene un _____ jardín muy bonito.",
    options: ["pequeño", "grande", "hermoso"],
    answer: "hermoso",
    explanation: "Un jardin beau est agréable à voir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La profesora _____ a los estudiantes todos los días.",
    options: ["ayuda", "escucha", "habla"],
    answer: "ayuda",
    explanation: "Aider les étudiants est une tâche essentielle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos y yo vamos a _____ una fiesta este fin de semana.",
    options: ["hacer", "ver", "organizar"],
    answer: "organizar",
    explanation: "Organiser une fête est une activité sociale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El coche está _____ en el garaje.",
    options: ["nuevo", "viejo", "rápido"],
    answer: "nuevo",
    explanation: "Une voiture neuve est souvent plus fiable.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Para el desayuno, me gusta comer _____ y café.",
    options: ["fruta", "pan", "tortilla"],
    answer: "pan",
    explanation: "Le pain est un aliment courant au petit déjeuner.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El libro que estoy leyendo es muy _____ y emocionante.",
    options: ["aburrido", "divertido", "largo"],
    answer: "divertido",
    explanation: "Un livre amusant attire souvent les lecteurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella siempre _____ muy elegante en las fiestas.",
    options: ["se viste", "se siente", "se duerme"],
    answer: "se viste",
    explanation: "S'habiller élégamment est important pour les occasions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros vamos a _____ en la playa este verano.",
    options: ["nadar", "cocinar", "dormir"],
    answer: "nadar",
    explanation: "Nager est une activité estivale populaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El profesor _____ la tarea para mañana.",
    options: ["da", "hace", "recibe"],
    answer: "da",
    explanation: "Donner des devoirs est une pratique courante.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi abuela cocina la mejor _____ del mundo.",
    options: ["sopa", "pastel", "ensalada"],
    answer: "sopa",
    explanation: "La soupe est souvent un plat réconfortant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Para la cena, quiero _____ pollo y arroz.",
    options: ["comer", "hacer", "ver"],
    answer: "comer",
    explanation: "Manger est une activité essentielle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El gato _____ en el sofá durante todo el día.",
    options: ["duerme", "juega", "come"],
    answer: "duerme",
    explanation: "Les chats dorment beaucoup.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mañana _____ al parque con mis amigos.",
    options: ["voy", "voyes", "van"],
    answer: "voy",
    explanation: "Aller au parc est une activité agréable.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El tren sale _____ a las cinco.",
    options: ["siempre", "nunca", "a veces"],
    answer: "siempre",
    explanation: "Toujours indique une régularité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella siempre _____ en la mañana.",
    options: ["canta", "duerme", "come"],
    answer: "canta",
    explanation: "Le verbe 'cantar' signifie chanter en français.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ a la playa el sábado.",
    options: ["vamos", "vamos a", "fui"],
    answer: "vamos",
    explanation: "Le verbe 'ir' signifie aller en français.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos _____ muy divertidos.",
    options: ["son", "están", "fueron"],
    answer: "son",
    explanation: "Le verbe 'ser' signifie être en français.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Quiero ir al _____ este fin de semana.",
    options: ["cine", "hospital", "trabajo"],
    answer: "cine",
    explanation: "Le mot 'cine' signifie cinéma en français.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro juega _____ en el jardín.",
    options: ["solo", "juntos", "solos"],
    answer: "solo",
    explanation: "Le mot 'solo' signifie seul en français.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Dónde _____ el libro que dejé aquí?",
    options: ["está", "estuve", "estar"],
    answer: "está",
    explanation: "Le verbe 'estar' signifie être en français.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La película fue _____ interesante.",
    options: ["muy", "poco", "más"],
    answer: "muy",
    explanation: "Le mot 'muy' signifie très en français.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La tienda cierra _____ a las ocho.",
    options: ["siempre", "nunca", "a veces"],
    answer: "siempre",
    explanation: "Le mot 'siempre' signifie toujours en français.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El coche es _____ rápido que el mío.",
    options: ["más", "tan", "menos"],
    answer: "más",
    explanation: "Le mot 'más' signifie plus en français.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Cuando _____ llueve, me quedo en casa.",
    options: ["siempre", "nunca", "a veces"],
    answer: "siempre",
    explanation: "Le mot 'siempre' signifie toujours en français.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Si tengo tiempo, _____ a la fiesta.",
    options: ["voy", "fui", "vaya"],
    answer: "voy",
    explanation: "Le verbe 'ir' signifie aller en français.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta el _____ de chocolate.",
    options: ["helado", "fruta", "pastel"],
    answer: "helado",
    explanation: "Le verbe 'gustar' est souvent utilisé avec des aliments.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Hoy es un _____ día.",
    options: ["frío", "largo", "rápido"],
    answer: "frío",
    explanation: "Les adjectifs décrivent les conditions météorologiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ en la playa.",
    options: ["jugamos", "cocinar", "miramos"],
    answer: "jugamos",
    explanation: "Le verbe 'jugar' signifie jouer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro _____ muy rápido.",
    options: ["corre", "salta", "duerme"],
    answer: "corre",
    explanation: "Les animaux peuvent être décrits par leurs actions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos y yo _____ al cine.",
    options: ["vamos", "vemos", "comemos"],
    answer: "vamos",
    explanation: "Le verbe 'ir' est utilisé pour exprimer une sortie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ una canción bonita.",
    options: ["canta", "escucha", "baila"],
    answer: "canta",
    explanation: "Le verbe 'cantar' signifie chanter.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Dónde está el _____?",
    options: ["banco", "coche", "puerta"],
    answer: "banco",
    explanation: "Les lieux sont souvent demandés.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Él _____ en la playa.",
    options: ["juega", "jugó", "jugar"],
    answer: "juega",
    explanation: "Le verbe 'jugar' signifie jouer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos _____ en el cine.",
    options: ["están", "estuve", "estar"],
    answer: "están",
    explanation: "'Están' est la forme du verbe 'estar' pour le pluriel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro _____ en el jardín.",
    options: ["está", "estuvo", "estar"],
    answer: "está",
    explanation: "'Está' est la forme du verbe 'estar' au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Yo _____ a mis abuelos este fin de semana.",
    options: ["visité", "visitar", "visito"],
    answer: "visito",
    explanation:
        "'Visito' est la première personne du singulier du verbe 'visitar'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Dónde _____ el libro que compré?",
    options: ["está", "fue", "estar"],
    answer: "está",
    explanation: "'Está' indique la localisation au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ellos _____ en la escuela todos los días.",
    options: ["estudian", "estudió", "estudiar"],
    answer: "estudian",
    explanation:
        "'Estudian' est la troisième personne du pluriel du verbe 'estudiar'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi hermana _____ a la universidad.",
    options: ["va", "fue", "ir"],
    answer: "va",
    explanation: "'Va' est la forme du verbe 'ir' au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ mucho en verano.",
    options: ["viajamos", "viajar", "viajé"],
    answer: "viajamos",
    explanation:
        "'Viajamos' est la première personne du pluriel du verbe 'viajar'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Cuál _____ tu comida favorita?",
    options: ["es", "fue", "ser"],
    answer: "es",
    explanation:
        "'Es' est utilisé pour poser des questions sur des caractéristiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El coche _____ muy rápido.",
    options: ["es", "fue", "ser"],
    answer: "es",
    explanation: "'Es' décrit une caractéristique du coche.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Tú _____ un buen amigo.",
    options: ["eres", "fuiste", "ser"],
    answer: "eres",
    explanation: "'Eres' est la deuxième personne du singulier du verbe 'ser'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Yo _____ un libro interesante.",
    options: ["leí", "leer", "leo"],
    answer: "leo",
    explanation: "'Leo' est la première personne du singulier du verbe 'leer'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ en casa esta tarde.",
    options: ["estará", "está", "fue"],
    answer: "está",
    explanation: "'Está' indique un état présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Los estudiantes _____ en clase ahora.",
    options: ["estudian", "estudiaron", "estudiar"],
    answer: "estudian",
    explanation: "'Estudian' est la forme correcte pour le présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ a la playa mañana.",
    options: ["vamos", "correr", "ver"],
    answer: "vamos",
    explanation: "Le verbe 'ir' signifie aller.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El gato _____ sobre la mesa.",
    options: ["dormir", "salta", "comer"],
    answer: "dormir",
    explanation: "Le verbe 'dormir' signifie dormir.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Dónde _____ el supermercado?",
    options: ["está", "ir", "correr"],
    answer: "está",
    explanation: "Le verbe 'estar' signifie être.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ellos _____ en el cine.",
    options: ["están", "jugar", "ver"],
    answer: "están",
    explanation: "Le verbe 'estar' signifie être.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Yo _____ café por la mañana.",
    options: ["bebo", "ver", "comer"],
    answer: "bebo",
    explanation: "Le verbe 'beber' signifie boire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi hermana _____ en Madrid.",
    options: ["vive", "correr", "jugar"],
    answer: "vive",
    explanation: "Le verbe 'vivir' signifie vivre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Qué _____ tú en la clase?",
    options: ["haces", "ver", "dormir"],
    answer: "haces",
    explanation: "Le verbe 'hacer' signifie faire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ellas _____ en el parque.",
    options: ["juegan", "ver", "comer"],
    answer: "juegan",
    explanation: "Le verbe 'jugar' signifie jouer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Yo _____ a la música.",
    options: ["escucho", "ver", "hablar"],
    answer: "escucho",
    explanation: "Le verbe 'escuchar' signifie écouter.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Dónde _____ la fiesta?",
    options: ["es", "ver", "ir"],
    answer: "es",
    explanation: "Le verbe 'ser' signifie être.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Tú _____ el piano muy bien.",
    options: ["tocas", "ver", "comer"],
    answer: "tocas",
    explanation: "Le verbe 'tocar' signifie jouer (d'un instrument).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ellos _____ en la casa.",
    options: ["están", "ver", "comer"],
    answer: "están",
    explanation: "Le verbe 'estar' signifie être.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Yo _____ un regalo para ti.",
    options: ["tengo", "ver", "comer"],
    answer: "tengo",
    explanation: "Le verbe 'tener' signifie avoir.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ muy feliz hoy.",
    options: ["está", "ver", "comer"],
    answer: "está",
    explanation: "Le verbe 'estar' indique l'état.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta mucho el _____.",
    options: ["chocolate", "zapato", "árbol"],
    answer: "chocolate",
    explanation: "C'est un aliment sucré apprécié par beaucoup.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella tiene un gato que se llama _____.",
    options: ["Luna", "Mesa", "Cielo"],
    answer: "Luna",
    explanation: "C'est un nom courant pour les animaux de compagnie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La comida en este restaurante es muy _____.",
    options: ["sabrosa", "fea", "pequeña"],
    answer: "sabrosa",
    explanation: "C'est un adjectif qui décrit le goût de la nourriture.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta _____ en la playa.",
    options: ["nadar", "correr", "leer"],
    answer: "nadar",
    explanation: "Nadar est une activité courante à la plage.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El gato está _____ en la ventana.",
    options: ["dormido", "comiendo", "jugando"],
    answer: "dormido",
    explanation: "Les chats aiment dormir dans des endroits ensoleillés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Voy a comprar _____ para la fiesta.",
    options: ["comida", "ropa", "libros"],
    answer: "comida",
    explanation: "La nourriture est essentielle pour une fête.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa es _____ grande que la tuya.",
    options: ["más", "menos", "tan"],
    answer: "más",
    explanation: "On utilise 'más' pour comparer des tailles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi hermano _____ juega al fútbol los domingos.",
    options: ["siempre", "nunca", "a veces"],
    answer: "siempre",
    explanation: "Toujours est une fréquence qui indique régularité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El coche es _____ que la bicicleta.",
    options: ["más rápido", "más lento", "más pequeño"],
    answer: "más rápido",
    explanation: "On compare la vitesse des véhicules.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Dónde _____ el restaurante?",
    options: ["está", "estás", "estamos"],
    answer: "está",
    explanation: "On demande la localisation avec 'está'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos _____ al parque todos los sábados.",
    options: ["van", "voy", "vas"],
    answer: "van",
    explanation: "Ils utilisent 'van' pour le pluriel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mañana _____ una reunión importante.",
    options: ["tendré", "tenemos", "tiene"],
    answer: "tendré",
    explanation: "Le futur est exprimé par 'tendré'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro _____ corre rápido.",
    options: ["siempre", "nunca", "a veces"],
    answer: "siempre",
    explanation: "Toujours indique une habitude.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La clase empieza _____ a las diez.",
    options: ["siempre", "nunca", "a veces"],
    answer: "siempre",
    explanation: "La classe commence toujours à la même heure.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "A mí me gusta _____ chocolate.",
    options: ["el", "la", "los"],
    answer: "el",
    explanation: "On utilise 'el' pour le chocolat au masculin.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Cuántas horas _____ al día?",
    options: ["duermes", "duermo", "duerme"],
    answer: "duermes",
    explanation: "On demande à quelqu'un combien il dort.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi hermana _____ toca la guitarra.",
    options: ["siempre", "nunca", "a veces"],
    answer: "siempre",
    explanation: "Elle joue toujours de la guitare.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Los niños _____ en el parque después de la escuela.",
    options: ["juegan", "juego", "juegas"],
    answer: "juegan",
    explanation: "Ils jouent au pluriel avec 'juegan'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El gato está _____ en la silla.",
    options: ["durmiendo", "comiendo", "jugando"],
    answer: "durmiendo",
    explanation: "Le verbe 'dormir' est utilisé ici.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ a la fiesta el sábado.",
    options: ["va", "fue", "ir"],
    answer: "va",
    explanation: "Le verbe 'ir' au présent est utilisé ici.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ el libro en la biblioteca.",
    options: ["leemos", "leer", "lee"],
    answer: "leemos",
    explanation: "Le verbe 'leer' au présent pour 'nosotros'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Dónde _____ la estación de tren?",
    options: ["está", "estás", "estamos"],
    answer: "está",
    explanation: "Le verbe 'estar' pour indiquer un lieu.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta comer _____ en el desayuno.",
    options: ["pan", "fruta", "chocolate"],
    answer: "fruta",
    explanation: "'Fruta' se refiere a 'fruits'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro está _____ en el jardín.",
    options: ["corriendo", "durmiendo", "comiendo"],
    answer: "durmiendo",
    explanation: "'Durmiendo' signifie 'en train de dormir'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi color favorito es el _____.",
    options: ["azul", "rojo", "verde"],
    answer: "azul",
    explanation: "'Azul' signifie 'bleu'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Voy a la tienda _____ comprar pan.",
    options: ["para", "con", "sin"],
    answer: "para",
    explanation: "'Para' signifie 'pour'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El gato es muy _____.",
    options: ["grande", "pequeño", "rápido"],
    answer: "pequeño",
    explanation: "'Pequeño' signifie 'petit'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi amigo tiene un _____ nuevo.",
    options: ["coche", "libro", "juego"],
    answer: "coche",
    explanation: "'Coche' signifie 'voiture'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa es _____ y bonita.",
    options: ["grande", "pequeña", "antigua"],
    answer: "grande",
    explanation: "'Grande' signifie 'grande'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ayer _____ mucho en la ciudad.",
    options: ["llovió", "fue", "hizo"],
    answer: "llovió",
    explanation: "'Llovió' signifie 'il a plu'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El tren llega _____ las cinco.",
    options: ["a", "en", "por"],
    answer: "a",
    explanation: "'A' indique une direction ou un moment.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Dónde está _____ libro que presté?",
    options: ["el", "un", "mi"],
    answer: "el",
    explanation: "'El' est un article défini.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El café está _____ caliente.",
    options: ["demasiado", "poco", "muy"],
    answer: "muy",
    explanation: "'Muy' signifie 'très'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro está _____ en el sofá.",
    options: ["dormido", "comiendo", "jugando"],
    answer: "dormido",
    explanation: "Le verbe 'dormir' signifie dormir.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta mucho _____ música clásica.",
    options: ["escuchar", "ver", "hablar"],
    answer: "escuchar",
    explanation: "'Escuchar' signifie écouter.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ en el parque los domingos.",
    options: ["jugamos", "comemos", "leemos"],
    answer: "jugamos",
    explanation: "'Jugar' signifie jouer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Los niños _____ en la playa durante el verano.",
    options: ["nadan", "cantan", "cocinan"],
    answer: "nadan",
    explanation: "'Nadar' signifie nager.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Dónde está la _____ de la casa?",
    options: ["puerta", "ventana", "mesa"],
    answer: "puerta",
    explanation: "'Puerta' signifie porte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi hermana _____ un libro interesante.",
    options: ["lee", "come", "bebe"],
    answer: "lee",
    explanation: "'Leer' signifie lire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Hoy hace _____ que ayer.",
    options: ["calor", "frío", "nieve"],
    answer: "calor",
    explanation: "'Calor' signifie chaleur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El coche es _____ que el mío.",
    options: ["más rápido", "más lento", "más pequeño"],
    answer: "más rápido",
    explanation: "'Más rápido' signifie plus rapide.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El tren sale a las _____ de la tarde.",
    options: ["dos", "tres", "cuatro"],
    answer: "tres",
    explanation: "'Tres' signifie trois.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La película que vimos fue muy _____ .",
    options: ["divertida", "aburrida", "interesante"],
    answer: "divertida",
    explanation: "'Divertida' signifie amusante.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi amigo tiene una _____ de fútbol.",
    options: ["pelota", "raqueta", "cama"],
    answer: "pelota",
    explanation: "'Pelota' signifie balle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El profesor nos _____ mucho en clase.",
    options: ["ayuda", "habla", "escucha"],
    answer: "ayuda",
    explanation: "'Ayudar' signifie aider.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me encanta _____ en la naturaleza.",
    options: ["caminar", "correr", "saltar"],
    answer: "caminar",
    explanation: "'Caminar' signifie marcher.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El restaurante cierra a las _____ de la noche.",
    options: ["diez", "nueve", "ocho"],
    answer: "diez",
    explanation: "'Diez' signifie dix.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El libro está _____ en la mesa.",
    options: ["abierto", "cerrado", "nuevo"],
    answer: "abierto",
    explanation: "'Abierto' signifie 'ouvert'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Dónde _____ el coche de Juan?",
    options: ["está", "estuve", "estar"],
    answer: "está",
    explanation: "'Está' est le verbe au présent pour 'être'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa _____ grande y bonita.",
    options: ["es", "fue", "era"],
    answer: "es",
    explanation: "'Es' signifie 'est' en espagnol.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El profesor _____ a los estudiantes.",
    options: ["ayuda", "ayudó", "ayudará"],
    answer: "ayuda",
    explanation: "'Ayuda' est le verbe au présent pour 'aider'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mañana _____ una fiesta en mi casa.",
    options: ["hay", "hubo", "habrá"],
    answer: "hay",
    explanation: "'Hay' signifie 'il y a' au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El gato _____ en la ventana.",
    options: ["mira", "miró", "mirará"],
    answer: "mira",
    explanation: "'Mira' est le verbe au présent pour 'regarder'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis padres _____ en la cocina.",
    options: ["cocinan", "cocinaban", "cocinarán"],
    answer: "cocinan",
    explanation: "'Cocinan' est le verbe au présent pour 'cuisiner'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La niña _____ su muñeca.",
    options: ["abraza", "abrazó", "abrazará"],
    answer: "abraza",
    explanation: "'Abraza' signifie 'elle embrasse' au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El sol _____ en el cielo.",
    options: ["brilla", "brilló", "brillará"],
    answer: "brilla",
    explanation: "'Brilla' est le verbe au présent pour 'briller'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ café por la mañana.",
    options: ["tomamos", "tomamos", "tomar"],
    answer: "tomamos",
    explanation: "'Tomamos' est la première personne du pluriel au présent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La profesora _____ muchas preguntas.",
    options: ["hace", "hizo", "hará"],
    answer: "hace",
    explanation: "'Hace' est le verbe au présent pour 'faire'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La fruta _____ fresca y deliciosa.",
    options: ["es", "fue", "era"],
    answer: "es",
    explanation: "'Es' signifie 'est' en espagnol.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ellos _____ a la escuela todos los días.",
    options: ["van", "fueron", "irán"],
    answer: "van",
    explanation: "'Van' est le verbe au présent pour 'aller'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El tren _____ a las ocho.",
    options: ["sale", "salió", "saldrá"],
    answer: "sale",
    explanation: "'Sale' est le verbe au présent pour 'partir'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ a la escuela todos los días.",
    options: ["va", "viene", "sale"],
    answer: "va",
    explanation: "Le verbe 'va' est la forme correcte pour 'aller'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ a la playa en verano.",
    options: ["vamos", "vamos a", "fuimos"],
    answer: "vamos",
    explanation: "'Vamos' signifie 'nous allons'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Dónde _____ el libro que presté?",
    options: ["está", "estás", "estamos"],
    answer: "está",
    explanation: "'Está' est la forme correcte pour 'il/elle est'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ayer _____ una película muy interesante.",
    options: ["vi", "ver", "veo"],
    answer: "vi",
    explanation: "'Vi' est le passé du verbe 'voir'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos _____ en casa este fin de semana.",
    options: ["están", "estuve", "estoy"],
    answer: "están",
    explanation: "'Están' est la forme correcte pour 'ils sont'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis padres _____ en España el año pasado.",
    options: ["estuvieron", "están", "estuve"],
    answer: "estuvieron",
    explanation: "'Estuvieron' est le passé du verbe 'être' pour 'ils'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa _____ muy grande y bonita.",
    options: ["es", "son", "fue"],
    answer: "es",
    explanation: "'Es' indique une caractéristique permanente.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Los niños _____ en el parque ahora.",
    options: ["juegan", "jugaron", "jugaban"],
    answer: "juegan",
    explanation: "'Juegan' est la forme actuelle du verbe 'jouer'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El libro _____ en la mesa.",
    options: ["está", "estuve", "están"],
    answer: "está",
    explanation: "'Está' signifie 'il/elle est à un endroit'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos _____ a la fiesta el sábado.",
    options: ["van", "fueron", "vienen"],
    answer: "van",
    explanation: "'Van' est la forme correcte pour 'ils vont'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El gato _____ en el sofá.",
    options: ["duerme", "dormía", "dormir"],
    answer: "duerme",
    explanation: "'Duerme' signifie 'il/elle dort'.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella tiene un perro _____.",
    options: ["grande", "rápido", "lento"],
    answer: "grande",
    explanation: "Un chien peut être de différentes tailles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros vamos a la _____ mañana.",
    options: ["playa", "montaña", "ciudad"],
    answer: "playa",
    explanation: "La plage est un lieu de vacances populaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Tengo que estudiar para el _____.",
    options: ["examen", "trabajo", "viaje"],
    answer: "examen",
    explanation: "Les examens nécessitent souvent une préparation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El gato está en la _____.",
    options: ["silla", "puerta", "ventana"],
    answer: "ventana",
    explanation: "Les chats aiment souvent s'asseoir près des fenêtres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi hermano juega al _____.",
    options: ["fútbol", "tenis", "baloncesto"],
    answer: "fútbol",
    explanation: "Le football est un sport très apprécié.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El coche es de color _____.",
    options: ["negro", "blanco", "gris"],
    answer: "blanco",
    explanation: "Les voitures peuvent avoir différentes couleurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nos encontramos en la _____.",
    options: ["estación", "escuela", "tienda"],
    answer: "estación",
    explanation: "Les stations sont des lieux de rencontre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Quiero un vaso de _____.",
    options: ["agua", "vino", "cerveza"],
    answer: "agua",
    explanation: "L'eau est essentielle pour la santé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi madre trabaja en una _____.",
    options: ["oficina", "tienda", "casa"],
    answer: "oficina",
    explanation: "De nombreuses personnes travaillent dans des bureaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La película fue muy _____.",
    options: ["interesante", "aburrida", "lenta"],
    answer: "interesante",
    explanation: "Les films peuvent avoir différents niveaux d'intérêt.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta escuchar música en la _____.",
    options: ["casa", "playa", "calle"],
    answer: "casa",
    explanation: "Beaucoup de gens écoutent de la musique chez eux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El verano es la _____.",
    options: ["mejor", "peor", "más larga"],
    answer: "mejor",
    explanation: "L'été est souvent considéré comme la meilleure saison.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Hoy es un día _____.",
    options: ["hermoso", "triste", "feo"],
    answer: "hermoso",
    explanation: "Les jours peuvent être jugés par leur météo.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta mucho _____ en el parque.",
    options: ["correr", "la comida", "el cine"],
    answer: "correr",
    explanation: "Correr est une activité populaire en plein air.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ ir al cine este fin de semana.",
    options: ["queremos", "vamos", "puedo"],
    answer: "queremos",
    explanation: "Queremos signifie nous voulons, indiquant une intention.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro _____ muy feliz en el parque.",
    options: ["está", "es", "tiene"],
    answer: "está",
    explanation: "Está se utilise pour décrire un état temporaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Marta _____ muchas frutas en su casa.",
    options: ["tiene", "hace", "va"],
    answer: "tiene",
    explanation: "Tiene signifie avoir, indiquant possession.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ayer _____ un partido de fútbol.",
    options: ["hubo", "hacer", "jugar"],
    answer: "hubo",
    explanation: "Hubo est le passé de haber, indiquant un événement passé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El libro que leo _____ muy interesante.",
    options: ["es", "fue", "era"],
    answer: "es",
    explanation: "Es décrit une caractéristique actuelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos _____ en la playa ahora.",
    options: ["están", "fueron", "estuve"],
    answer: "están",
    explanation: "Están est le présent pour indiquer une action actuelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa _____ más grande que la tuya.",
    options: ["es", "fue", "era"],
    answer: "es",
    explanation: "Es est utilisé pour comparer des caractéristiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Si tuviera dinero, _____ un coche nuevo.",
    options: ["compraría", "compra", "comprar"],
    answer: "compraría",
    explanation: "Compraría est le conditionnel pour une action future.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El verano pasado _____ a España.",
    options: ["viajé", "viajar", "viajo"],
    answer: "viajé",
    explanation: "Viajé est le passé simple pour une action terminée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Si llueve, _____ en casa.",
    options: ["quedamos", "quedarse", "quedé"],
    answer: "quedamos",
    explanation: "Quedamos signifie rester, utilisé pour un plan.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Dónde _____ mi libro?",
    options: ["está", "fue", "era"],
    answer: "está",
    explanation: "Está se demande la localisation actuelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "No puedo _____ el examen mañana.",
    options: ["hacer", "hago", "hacia"],
    answer: "hacer",
    explanation: "Hacer signifie réaliser une action.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis padres _____ en casa ahora.",
    options: ["están", "fueron", "fue"],
    answer: "están",
    explanation: "Están indique un état présent.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Si tengo tiempo, _____ al gimnasio.",
    options: ["voy", "fui", "iba"],
    answer: "voy",
    explanation: "Voy est le présent pour une action future.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La película que vimos _____ muy aburrida.",
    options: ["fue", "es", "era"],
    answer: "fue",
    explanation: "Fue est utilisé pour décrire une expérience passée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Cuando era niño, _____ mucho en el parque.",
    options: ["jugaba", "jugar", "juego"],
    answer: "jugaba",
    explanation: "Jugaba est l'imparfait pour décrire une habitude passée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "No sé si _____ a la fiesta esta noche.",
    options: ["voy", "fui", "fue"],
    answer: "voy",
    explanation: "Voy indique une intention future.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi comida favorita es _____",
    options: ["la pizza", "el helado", "las verduras"],
    answer: "la pizza",
    explanation: "La pizza est un plat populaire en Espagne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Hoy hace _____ que ayer.",
    options: ["más frío", "más calor", "más viento"],
    answer: "más frío",
    explanation: "La comparaison de la température est courante.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ a la escuela todos los días.",
    options: ["caminamos", "camina", "caminas"],
    answer: "camina",
    explanation: "Le verbe 'caminar' est souvent utilisé pour aller à l'école.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro _____ muy grande.",
    options: ["es", "está", "fue"],
    answer: "es",
    explanation:
        "'Es' est utilisé pour décrire des caractéristiques permanentes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa tiene _____ ventanas.",
    options: ["tres", "cuatro", "cinco"],
    answer: "tres",
    explanation:
        "Les nombres sont souvent utilisés pour décrire des quantités.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella vive en _____ ciudad.",
    options: ["una", "un", "el"],
    answer: "una",
    explanation: "L'article 'una' est utilisé pour les noms féminins.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El coche es _____ rápido.",
    options: ["muy", "poco", "más"],
    answer: "muy",
    explanation: "'Muy' est un adverbe utilisé pour intensifier les adjectifs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta _____ café por la mañana.",
    options: ["tomar", "tomo", "tomas"],
    answer: "tomar",
    explanation: "'Tomar' signifie prendre ou consommer en espagnol.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis padres _____ en casa.",
    options: ["están", "estás", "estoy"],
    answer: "están",
    explanation: "'Estar' est utilisé pour indiquer la localisation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El niño juega _____ la pelota.",
    options: ["con", "sin", "bajo"],
    answer: "con",
    explanation: "'Con' signifie 'avec' en espagnol.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mañana _____ a la playa.",
    options: ["vamos", "voy", "van"],
    answer: "vamos",
    explanation: "'Vamos' est la première personne plurielle du verbe 'ir'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El tren llega a las _____.",
    options: ["ocho", "nueve", "diez"],
    answer: "nueve",
    explanation: "Les heures se disent en espagnol avec des nombres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El verano _____ muy caluroso.",
    options: ["es", "fue", "está"],
    answer: "es",
    explanation: "On utilise 'es' pour décrire des caractéristiques générales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La tienda _____ cierra a las seis.",
    options: ["siempre", "nunca", "a veces"],
    answer: "siempre",
    explanation: "'Siempre' signifie toujours en espagnol.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Yo _____ en el parque.",
    options: ["camino", "correr", "corriendo"],
    answer: "camino",
    explanation: "Le verbe 'caminar' signifie 'marcher'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ una carta a su amiga.",
    options: ["escribe", "escribir", "escribiendo"],
    answer: "escribe",
    explanation: "Le verbe 'escribir' signifie 'écrire'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ al cine mañana.",
    options: ["vamos", "ir", "yendo"],
    answer: "vamos",
    explanation: "Le verbe 'ir' signifie 'aller'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro _____ en el jardín.",
    options: ["juega", "jugar", "jugando"],
    answer: "juega",
    explanation: "Le verbe 'jugar' signifie 'jouer'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Yo _____ una película interesante.",
    options: ["veo", "ver", "viendo"],
    answer: "veo",
    explanation: "Le verbe 'ver' signifie 'voir'.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Voy a _____ a la playa este fin de semana.",
    options: ["ir", "ver", "hacer"],
    answer: "ir",
    explanation: "Le verbe 'ir' signifie 'aller'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ una carta a su abuela.",
    options: ["escribe", "lee", "come"],
    answer: "escribe",
    explanation: "Le verbe 'escribe' signifie 'écrit'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ en la casa de Juan.",
    options: ["vivimos", "jugamos", "cocinamos"],
    answer: "vivimos",
    explanation: "Le verbe 'vivimos' signifie 'nous vivons'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El coche es _____ que el tuyo.",
    options: ["más rápido", "más lento", "más viejo"],
    answer: "más rápido",
    explanation: "L'expression 'más rápido' signifie 'plus rapide'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos _____ al cine esta noche.",
    options: ["van", "vienen", "están"],
    answer: "van",
    explanation: "Le verbe 'van' signifie 'ils vont'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella siempre _____ café por la mañana.",
    options: ["bebe", "come", "prepara"],
    answer: "bebe",
    explanation: "Le verbe 'bebe' signifie 'elle boit'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Los niños _____ en el parque.",
    options: ["juegan", "corren", "duermen"],
    answer: "juegan",
    explanation: "Le verbe 'juegan' signifie 'ils jouent'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "¿Dónde _____ la tienda más cercana?",
    options: ["está", "hay", "fue"],
    answer: "está",
    explanation: "Le verbe 'está' signifie 'est'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La fiesta comienza _____ a las ocho.",
    options: ["exactamente", "tarde", "temprano"],
    answer: "exactamente",
    explanation: "Le mot 'exactamente' signifie 'exactement'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El tren _____ a las diez.",
    options: ["sale", "llega", "para"],
    answer: "sale",
    explanation: "Le verbe 'sale' signifie 'il part'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa es _____ que la otra.",
    options: ["más grande", "más pequeña", "más bonita"],
    answer: "más grande",
    explanation: "L'expression 'más grande' signifie 'plus grande'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella tiene _____ amigos en la ciudad.",
    options: ["muchos", "pocos", "ningunos"],
    answer: "muchos",
    explanation: "Le mot 'muchos' signifie 'beaucoup'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El gato está _____ en la silla.",
    options: ["sentado", "caminando", "saltando"],
    answer: "sentado",
    explanation: "Le mot 'sentado' signifie 'assis'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta el _____ de chocolate.",
    options: ["pastel", "fruta", "agua"],
    answer: "pastel",
    explanation:
        "Le chocolat est souvent utilisé dans les desserts comme le gâteau.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ en la playa durante el verano.",
    options: ["nada", "comer", "correr"],
    answer: "nada",
    explanation: "Nager est une activité populaire à la plage.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ a la fiesta mañana.",
    options: ["vamos", "ir", "fui"],
    answer: "vamos",
    explanation: "Le verbe 'aller' au présent est 'vamos'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro _____ muy feliz.",
    options: ["es", "está", "fue"],
    answer: "está",
    explanation: "L'état d'un chien peut changer, donc on utilise 'está'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ayer _____ una película interesante.",
    options: ["vi", "ver", "veré"],
    answer: "vi",
    explanation: "Le passé du verbe 'voir' est 'vi'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ su libro en la biblioteca.",
    options: ["dejó", "dejar", "dejas"],
    answer: "dejó",
    explanation: "Le passé du verbe 'laisser' est 'dejó'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El clima hoy _____ muy agradable.",
    options: ["es", "está", "fue"],
    answer: "está",
    explanation: "On utilise 'está' pour décrire le temps actuel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos _____ en el restaurante.",
    options: ["comen", "comer", "comió"],
    answer: "comen",
    explanation: "Le verbe 'manger' au présent pour 'ils' est 'comen'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mañana _____ un examen importante.",
    options: ["tengo", "tuve", "tenía"],
    answer: "tengo",
    explanation: "Le verbe 'avoir' au futur est 'tengo'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El libro que leí _____ muy interesante.",
    options: ["fue", "es", "será"],
    answer: "fue",
    explanation: "On utilise 'fue' pour parler d'un événement passé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ al cine todos los viernes.",
    options: ["vamos", "fue", "ir"],
    answer: "vamos",
    explanation: "Le verbe 'aller' au présent pour 'nous' est 'vamos'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El coche _____ rápido.",
    options: ["es", "está", "fue"],
    answer: "es",
    explanation:
        "On utilise 'es' pour parler d'une caractéristique permanente.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ayer _____ un buen día.",
    options: ["tuve", "tengo", "tenía"],
    answer: "tuve",
    explanation: "Le passé du verbe 'avoir' est 'tuve'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El profesor _____ las preguntas.",
    options: ["explica", "explicar", "explicó"],
    answer: "explica",
    explanation: "Le verbe 'expliquer' au présent pour 'il' est 'explica'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ a la montaña en invierno.",
    options: ["vamos", "fue", "ir"],
    answer: "vamos",
    explanation: "Le verbe 'aller' au présent pour 'nous' est 'vamos'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa _____ cerca del parque.",
    options: ["está", "es", "fue"],
    answer: "está",
    explanation:
        "On utilise 'está' pour indiquer la localisation d'un endroit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Hoy es un día muy _____.",
    options: ["hermoso", "triste", "nublado"],
    answer: "hermoso",
    explanation: "L'adjectif 'hermoso' signifie beau.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta mucho el _____ de la playa.",
    options: ["sonido", "sabor", "olor"],
    answer: "sonido",
    explanation: "Le 'sonido' se réfère au bruit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella tiene un perro muy _____.",
    options: ["grande", "pequeño", "rápido"],
    answer: "pequeño",
    explanation: "L'adjectif 'pequeño' signifie petit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El libro está sobre la _____.",
    options: ["mesa", "silla", "cama"],
    answer: "mesa",
    explanation: "La 'mesa' est une table.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi hermano juega al _____ los sábados.",
    options: ["fútbol", "ajedrez", "tenis"],
    answer: "fútbol",
    explanation: "Le 'fútbol' est un sport populaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Quiero un café _____ por favor.",
    options: ["sin azúcar", "con leche", "frío"],
    answer: "con leche",
    explanation: "'Con leche' signifie avec du lait.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa es muy _____.",
    options: ["bonita", "grande", "pequeña"],
    answer: "bonita",
    explanation: "L'adjectif 'bonita' signifie jolie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El cielo está _____.",
    options: ["azul", "gris", "verde"],
    answer: "azul",
    explanation: "'Azul' signifie bleu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta _____ en el parque.",
    options: ["caminar", "correr", "saltar"],
    answer: "caminar",
    explanation: "'Caminar' signifie marcher.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El tren sale a las _____.",
    options: ["dos", "tres", "cuatro"],
    answer: "dos",
    explanation: "'Dos' signifie deux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella estudia para _____ en la universidad.",
    options: ["trabajar", "jugar", "viajar"],
    answer: "trabajar",
    explanation: "'Trabajar' signifie travailler.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El verano es mi estación _____.",
    options: ["favorita", "menos", "más"],
    answer: "favorita",
    explanation: "'Favorita' signifie préférée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La comida en este restaurante es _____.",
    options: ["deliciosa", "sosa", "cara"],
    answer: "deliciosa",
    explanation: "'Deliciosa' signifie délicieuse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gustaría viajar a _____.",
    options: ["España", "Francia", "Italia"],
    answer: "España",
    explanation: "'España' est un pays.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos _____ en el parque ahora.",
    options: ["están", "está", "estamos"],
    answer: "están",
    explanation: "Utilisation du verbe 'estar'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ muy bonita hoy.",
    options: ["es", "está", "fue"],
    answer: "está",
    explanation: "Utilisation de 'estar' pour un état temporaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ pizza para la cena.",
    options: ["comemos", "come", "comen"],
    answer: "comemos",
    explanation: "Conjugaison du verbe 'comer'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Él _____ a su hermana en la escuela.",
    options: ["veo", "ve", "ver"],
    answer: "ve",
    explanation: "Conjugaison du verbe 'ver'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ayer _____ un buen día.",
    options: ["fue", "es", "ser"],
    answer: "fue",
    explanation: "Passé simple du verbe 'ser'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis padres siempre _____ en casa los domingos.",
    options: ["están", "está", "estuvimos"],
    answer: "están",
    explanation: "Utilisation de 'estar' pour décrire une habitude.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mañana _____ a la fiesta.",
    options: ["voy", "fui", "va"],
    answer: "voy",
    explanation: "Futur proche avec 'ir a'.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La capital de España es _____.",
    options: ["Madrid", "Barcelona", "Sevilla"],
    answer: "Madrid",
    explanation: "La capitale de l'Espagne est Madrid.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El sol sale por el _____ y se pone por el oeste.",
    options: ["norte", "este", "sur"],
    answer: "este",
    explanation: "Le soleil se lève à l'est.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta mucho el _____ en verano.",
    options: ["frío", "calor", "otoño"],
    answer: "calor",
    explanation: "En été, il fait chaud.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La lengua oficial de México es _____.",
    options: ["español", "francés", "inglés"],
    answer: "español",
    explanation: "La langue officielle du Mexique est l'espagnol.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La fiesta se celebra en _____ de diciembre.",
    options: ["el 5", "el 25", "el 31"],
    answer: "el 31",
    explanation: "La fête du Nouvel An est le 31 décembre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi hermano trabaja en un _____ de construcción.",
    options: ["hotel", "sitio", "proyecto"],
    answer: "proyecto",
    explanation: "Mon frère travaille sur un projet de construction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta el café sin _____.",
    options: ["leche", "azúcar", "agua"],
    answer: "azúcar",
    explanation: "J'aime le café sans sucre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El _____ es un instrumento musical de cuerda.",
    options: ["piano", "violín", "batería"],
    answer: "violín",
    explanation: "Le violon est un instrument à cordes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La _____ es un lugar para ver animales.",
    options: ["escuela", "zoológico", "tienda"],
    answer: "zoológico",
    explanation: "Le zoo est un endroit pour voir des animaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Los estudiantes _____ en la biblioteca.",
    options: ["estudian", "comen", "juegan"],
    answer: "estudian",
    explanation: "Les étudiants étudient à la bibliothèque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La ______ es la estación más fría del año.",
    options: ["primavera", "verano", "invierno"],
    answer: "invierno",
    explanation: "L'hiver est la saison la plus froide de l'année.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Voy a comprar frutas en el _____.",
    options: ["mercado", "parque", "cine"],
    answer: "mercado",
    explanation: "On achète des fruits au marché.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La ______ es una bebida muy popular en España.",
    options: ["cerveza", "vino", "agua"],
    answer: "vino",
    explanation: "Le vin est une boisson très populaire en Espagne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El tren llega a la _____ a las cinco.",
    options: ["estación", "casa", "ciudad"],
    answer: "estación",
    explanation: "Le train arrive à la gare à cinq heures.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi amigo tiene un perro muy _____.",
    options: ["grande", "pequeño", "alto"],
    answer: "grande",
    explanation: "Mon ami a un très grand chien.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El _____ es un deporte muy popular en España.",
    options: ["fútbol", "tenis", "natación"],
    answer: "fútbol",
    explanation: "Le football est un sport très populaire en Espagne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La _____ es la capital de Argentina.",
    options: ["Lima", "Buenos Aires", "Santiago"],
    answer: "Buenos Aires",
    explanation: "Buenos Aires est la capitale de l'Argentine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El verano en España es muy _____.",
    options: ["caliente", "frío", "nublado"],
    answer: "caliente",
    explanation: "L'été en Espagne est très chaud.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La pizza es un plato _____ en Italia.",
    options: ["sobre", "famoso", "rápido"],
    answer: "famoso",
    explanation: "La pizza est un plat célèbre en Italie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta ir al _____ en verano.",
    options: ["mar", "montaña", "campo"],
    answer: "mar",
    explanation: "J'aime aller à la mer en été.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El coche es más _____ que la bicicleta.",
    options: ["rápido", "lento", "pequeño"],
    answer: "rápido",
    explanation: "La voiture est plus rapide que le vélo.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa tiene un _____ en el jardín.",
    options: ["árbol", "perro", "coche"],
    answer: "árbol",
    explanation: "La maison a un arbre dans le jardin.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Las flores son _____ en primavera.",
    options: ["hermosas", "tristes", "oscuras"],
    answer: "hermosas",
    explanation: "Les fleurs sont belles au printemps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La _____ es la tercera planeta del sistema solar.",
    options: ["Tierra", "Luna", "Marte"],
    answer: "Tierra",
    explanation: "La Terre est la troisième planète du système solaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta leer un _____ antes de dormir.",
    options: ["libro", "diario", "revista"],
    answer: "libro",
    explanation: "J'aime lire un livre avant de dormir.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro ladra cuando está _____.",
    options: ["feliz", "triste", "enojado"],
    answer: "feliz",
    explanation: "Le chien aboie quand il est content.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El _____ es un animal que vuela.",
    options: ["perro", "pájaro", "gato"],
    answer: "pájaro",
    explanation: "L'oiseau est un animal qui vole.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La _____ es una fruta tropical.",
    options: ["manzana", "piña", "naranja"],
    answer: "piña",
    explanation: "L'ananas est un fruit tropical.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El _____ está en la cima de la montaña.",
    options: ["sol", "viento", "agua"],
    answer: "sol",
    explanation: "Le soleil est au sommet de la montagne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La _____ es un tipo de queso español.",
    options: ["mozzarella", "parmesano", "manchego"],
    answer: "manchego",
    explanation: "Le manchego est un fromage espagnol.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El _____ es un lugar donde se cultivan plantas.",
    options: ["jardín", "parque", "bosque"],
    answer: "jardín",
    explanation: "Le jardin est un endroit où l'on cultive des plantes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El _____ es un medio de transporte.",
    options: ["avión", "piano", "cuaderno"],
    answer: "avión",
    explanation: "L'avion est un moyen de transport.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La _____ se usa para escribir.",
    options: ["lápiz", "mesa", "silla"],
    answer: "lápiz",
    explanation: "Le crayon est utilisé pour écrire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Los estudiantes _____ en clase.",
    options: ["escuchan", "comen", "juegan"],
    answer: "escuchan",
    explanation: "Les étudiants écoutent en classe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La _____ es un deporte muy divertido.",
    options: ["natación", "pintura", "cocina"],
    answer: "natación",
    explanation: "La natation est un sport très amusant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El _____ es un lugar para comprar comida.",
    options: ["supermercado", "cine", "parque"],
    answer: "supermercado",
    explanation: "Le supermarché est un endroit pour acheter de la nourriture.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta la música _____ en la tarde.",
    options: ["clásica", "moderna", "popular"],
    answer: "clásica",
    explanation: "J'aime écouter de la musique classique l'après-midi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La _____ es una bebida fría.",
    options: ["sopa", "cerveza", "té"],
    answer: "té",
    explanation: "Le thé est une boisson froide.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El _____ es un lugar para ver películas.",
    options: ["cine", "teatro", "casa"],
    answer: "cine",
    explanation: "Le cinéma est un endroit pour voir des films.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El _____ es un animal que puede volar.",
    options: ["perro", "pájaro", "gato"],
    answer: "pájaro",
    explanation: "L'oiseau est un animal qui peut voler.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La _____ es un lugar donde se cultivan flores.",
    options: ["jardín", "parque", "bosque"],
    answer: "jardín",
    explanation: "Le jardin est un endroit où l'on cultive des fleurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta comer _____ en la mañana.",
    options: ["huevos", "tacos", "pizza"],
    answer: "huevos",
    explanation: "J'aime manger des œufs le matin.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El _____ es un lugar para aprender.",
    options: ["escuela", "casa", "tienda"],
    answer: "escuela",
    explanation: "L'école est un endroit pour apprendre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La _____ es un medio de transporte muy rápido.",
    options: ["bicicleta", "coche", "avión"],
    answer: "avión",
    explanation: "L'avion est un moyen de transport très rapide.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El _____ es un animal que vive en el agua.",
    options: ["perro", "pez", "gato"],
    answer: "pez",
    explanation: "Le poisson est un animal qui vit dans l'eau.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El _____ es un instrumento musical de viento.",
    options: ["piano", "flauta", "guitarra"],
    answer: "flauta",
    explanation: "La flûte est un instrument à vent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La _____ es una fruta roja.",
    options: ["manzana", "plátano", "naranja"],
    answer: "manzana",
    explanation: "La pomme est un fruit rouge.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El _____ es un lugar donde se venden libros.",
    options: ["biblioteca", "librería", "escuela"],
    answer: "librería",
    explanation: "La librairie est un endroit où l'on vend des livres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La _____ es un día festivo muy importante.",
    options: ["Navidad", "lunes", "fin de semana"],
    answer: "Navidad",
    explanation: "Noël est un jour férié très important.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Hoy es un día muy _____.",
    options: ["bonito", "feo", "triste"],
    answer: "bonito",
    explanation: "L'adjectif 'bonito' signifie 'beau'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta mucho el _____ de la playa.",
    options: ["sol", "nieve", "viento"],
    answer: "sol",
    explanation: "Le 'sol' est essentiel pour profiter de la plage.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro es un _____ muy fiel.",
    options: ["gato", "animal", "pájaro"],
    answer: "animal",
    explanation: "Tous les chiens sont des animaux fidèles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El libro está _____ de la mesa.",
    options: ["encima", "debajo", "al lado"],
    answer: "debajo",
    explanation: "'Debajo' signifie 'en dessous'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Voy a comprar un _____ para la cena.",
    options: ["libro", "plato", "juego"],
    answer: "plato",
    explanation: "Un 'plato' est un élément essentiel d'un repas.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella siempre lleva una _____ en su bolso.",
    options: ["computadora", "cartera", "silla"],
    answer: "cartera",
    explanation: "Une 'cartera' est un portefeuille.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nos gusta ir al _____ en verano.",
    options: ["cine", "frío", "esquí"],
    answer: "cine",
    explanation: "Le 'cine' est un lieu de divertissement populaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El café está muy _____.",
    options: ["frío", "caliente", "rápido"],
    answer: "caliente",
    explanation: "Un café est généralement servi chaud.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El sábado vamos a _____ al parque.",
    options: ["correr", "sentar", "comer"],
    answer: "correr",
    explanation: "'Correr' est une activité de loisir courante.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Quiero _____ una película esta noche.",
    options: ["ver", "leer", "hacer"],
    answer: "ver",
    explanation: "'Ver' signifie 'regarder'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El coche es _____ que compré ayer.",
    options: ["nuevo", "viejo", "rápido"],
    answer: "nuevo",
    explanation: "'Nuevo' signifie 'neuf'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos y yo vamos a _____ un concierto.",
    options: ["ver", "escuchar", "cantar"],
    answer: "ver",
    explanation: "'Ver' est utilisé pour assister à un événement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa es _____ y grande.",
    options: ["pequeña", "hermosa", "bonita"],
    answer: "hermosa",
    explanation: "'Hermosa' signifie 'magnifique'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Yo _____ en la universidad.",
    options: ["estudio", "canto", "bailo"],
    answer: "estudio",
    explanation: "'Estudiar' signifie 'étudier'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ayer fui al _____ con mi familia.",
    options: ["cine", "teatro", "museo"],
    answer: "cine",
    explanation: "Le 'cine' est un lieu de loisirs populaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El verano pasado viajé a _____.",
    options: ["España", "casa", "escuela"],
    answer: "España",
    explanation: "'España' est un pays populaire pour voyager.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La fruta que más me gusta es _____.",
    options: ["la banana", "la mesa", "el agua"],
    answer: "la banana",
    explanation: "'La banana' est un fruit courant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Cada mañana bebo un _____ de café.",
    options: ["taza", "cucharada", "botella"],
    answer: "taza",
    explanation: "Une 'taza' est utilisée pour boire des liquides.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis padres están de _____ este fin de semana.",
    options: ["vacaciones", "trabajo", "estudio"],
    answer: "vacaciones",
    explanation: "'Vacaciones' signifie 'vacances'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta escuchar _____ por la mañana.",
    options: ["música", "televisión", "radio"],
    answer: "música",
    explanation: "'Música' est souvent écoutée le matin.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La maestra nos enseñó _____.",
    options: ["inglés", "matemáticas", "historia"],
    answer: "matemáticas",
    explanation: "'Matemáticas' signifie 'mathématiques'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El gato está _____ del sofá.",
    options: ["debajo", "encima", "dentro"],
    answer: "debajo",
    explanation: "'Debajo' signifie 'en dessous'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Las estrellas brillan en la _____ .",
    options: ["noche", "tarde", "mañana"],
    answer: "noche",
    explanation: "Les étoiles sont visibles la nuit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Voy a _____ mi libro en casa.",
    options: ["dejar", "tomar", "vender"],
    answer: "dejar",
    explanation: "'Dejar' signifie 'laisser'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El tren sale a las _____ de la tarde.",
    options: ["cinco", "diez", "siete"],
    answer: "cinco",
    explanation: "Les horaires de train sont importants à connaître.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La comida está _____ y deliciosa.",
    options: ["caliente", "fría", "sucia"],
    answer: "caliente",
    explanation: "'Caliente' signifie 'chaud'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Quiero _____ un regalo a mi amigo.",
    options: ["dar", "tomar", "comprar"],
    answer: "dar",
    explanation: "'Dar' signifie 'donner'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El reloj está _____ de la pared.",
    options: ["en", "debajo", "fuera"],
    answer: "en",
    explanation: "'En' indique la position sur la surface.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La película fue muy _____.",
    options: ["divertida", "triste", "rápida"],
    answer: "divertida",
    explanation: "'Divertida' signifie 'amusante'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La habitación está _____ y limpia.",
    options: ["ordenada", "sucia", "desordenada"],
    answer: "ordenada",
    explanation: "'Ordenada' signifie 'rangée'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El clima hoy es muy _____.",
    options: ["frío", "caliente", "nublado"],
    answer: "caliente",
    explanation: "'Caliente' signifie 'chaud'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Los estudiantes _____ en la clase.",
    options: ["estudian", "juegan", "cantan"],
    answer: "estudian",
    explanation: "'Estudian' signifie 'étudier'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La comida de hoy está _____.",
    options: ["rica", "sosa", "fea"],
    answer: "rica",
    explanation: "'Rica' signifie 'délicieuse'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El agua está _____ en el vaso.",
    options: ["fría", "caliente", "sucia"],
    answer: "fría",
    explanation: "L'eau est souvent servie froide.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro corre muy _____.",
    options: ["rápido", "lento", "tranquilo"],
    answer: "rápido",
    explanation: "'Rápido' signifie 'vite'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me encanta _____ en el verano.",
    options: ["nadar", "correr", "leer"],
    answer: "nadar",
    explanation: "'Nadar' signifie 'nager'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La tarea está _____ en mi escritorio.",
    options: ["aquí", "ahí", "allí"],
    answer: "aquí",
    explanation: "'Aquí' signifie 'ici'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El verano es mi estación _____ .",
    options: ["favorita", "fea", "triste"],
    answer: "favorita",
    explanation: "'Favorita' signifie 'préférée'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El maestro es muy _____.",
    options: ["estricto", "simpático", "feo"],
    answer: "simpático",
    explanation: "'Simpático' signifie 'sympathique'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La escuela está _____ de mi casa.",
    options: ["cerca", "lejos", "dentro"],
    answer: "cerca",
    explanation: "'Cerca' signifie 'près'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Hoy tengo que _____ la ropa.",
    options: ["lavar", "planchar", "cocinar"],
    answer: "lavar",
    explanation: "'Lavar' signifie 'laver'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El gato está _____ en la ventana.",
    options: ["mirando", "dormido", "jugando"],
    answer: "mirando",
    explanation: "'Mirando' signifie 'regardant'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El tren llega a las _____ de la tarde.",
    options: ["seis", "ocho", "nueve"],
    answer: "seis",
    explanation: "Les horaires sont importants pour voyager.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Me gusta _____ en mi tiempo libre.",
    options: ["leer", "correr", "escribir"],
    answer: "leer",
    explanation: "'Leer' signifie 'lire'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El sol brilla en el _____.",
    options: ["cielo", "mar", "suelo"],
    answer: "cielo",
    explanation: "'Cielo' signifie 'ciel'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La pizza está muy _____.",
    options: ["rica", "mala", "fría"],
    answer: "rica",
    explanation: "'Rica' signifie 'délicieuse'.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El perro está _____ en el jardín.",
    options: ["dormido", "comiendo", "jugando"],
    answer: "dormido",
    explanation: "Le mot 'dormido' signifie 'endormi'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Yo _____ a la playa todos los veranos.",
    options: ["voy", "vengo", "voy a"],
    answer: "voy",
    explanation: "Le verbe 'ir' au présent est 'voy'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ que le gusta el chocolate.",
    options: ["dice", "decir", "diciendo"],
    answer: "dice",
    explanation: "Le verbe 'decir' au présent est 'dice'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ en casa mañana.",
    options: ["estamos", "estará", "estar"],
    answer: "estamos",
    explanation: "Le verbe 'estar' au présent est 'estamos'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa es _____ grande.",
    options: ["muy", "más", "poco"],
    answer: "muy",
    explanation: "Le mot 'muy' signifie 'très'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Él tiene _____ libros en su mochila.",
    options: ["muchos", "poco", "más"],
    answer: "muchos",
    explanation: "Le mot 'muchos' signifie 'beaucoup'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi hermana _____ una guitarra nueva.",
    options: ["tiene", "tenido", "tendrá"],
    answer: "tiene",
    explanation: "Le verbe 'tener' au présent est 'tiene'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Hoy _____ un día soleado.",
    options: ["es", "está", "fue"],
    answer: "es",
    explanation: "Le verbe 'ser' au présent est 'es'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Quiero _____ en el parque.",
    options: ["caminar", "camino", "caminando"],
    answer: "caminar",
    explanation: "Le verbe 'caminar' signifie 'marcher'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La niña _____ una manzana roja.",
    options: ["come", "comer", "comiendo"],
    answer: "come",
    explanation: "Le verbe 'comer' au présent est 'come'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Juan _____ en el trabajo ahora.",
    options: ["está", "es", "fue"],
    answer: "está",
    explanation: "Le verbe 'estar' au présent est 'está'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Los estudiantes _____ en clase.",
    options: ["estudian", "estudiar", "estudiando"],
    answer: "estudian",
    explanation: "Le verbe 'estudiar' au présent est 'estudian'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis padres _____ de vacaciones.",
    options: ["están", "estuvieran", "estar"],
    answer: "están",
    explanation: "Le verbe 'estar' au présent est 'están'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ayer _____ una fiesta en mi casa.",
    options: ["hubo", "hay", "había"],
    answer: "hubo",
    explanation:
        "Le mot 'hubo' indique qu'il y a eu quelque chose dans le passé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La película _____ muy interesante.",
    options: ["fue", "es", "está"],
    answer: "es",
    explanation: "Le verbe 'ser' au présent est 'es'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ su tarea en la biblioteca.",
    options: ["hace", "hizo", "haciendo"],
    answer: "hace",
    explanation: "Le verbe 'hacer' au présent est 'hace'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ a Madrid el próximo mes.",
    options: ["vamos", "fue", "ir"],
    answer: "vamos",
    explanation: "Le verbe 'ir' au présent est 'vamos'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos _____ en el parque.",
    options: ["juegan", "jugando", "jugar"],
    answer: "juegan",
    explanation: "Le verbe 'jugar' au présent est 'juegan'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi familia _____ una casa grande.",
    options: ["tiene", "teniendo", "tuvo"],
    answer: "tiene",
    explanation: "Le verbe 'tener' au présent est 'tiene'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mañana _____ a la escuela.",
    options: ["voy", "fui", "vengo"],
    answer: "voy",
    explanation: "Le verbe 'ir' au présent est 'voy'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El coche _____ muy rápido.",
    options: ["va", "fue", "ir"],
    answer: "va",
    explanation: "Le verbe 'ir' au présent est 'va'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La clase _____ a las nueve.",
    options: ["empieza", "empezar", "está"],
    answer: "empieza",
    explanation: "Le verbe 'empezar' au présent est 'empieza'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Hoy _____ un buen día para salir.",
    options: ["es", "está", "fue"],
    answer: "es",
    explanation: "Le verbe 'ser' au présent est 'es'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ellos _____ en la fiesta anoche.",
    options: ["bailaron", "bailan", "bailar"],
    answer: "bailaron",
    explanation: "Le verbe 'bailar' au passé est 'bailaron'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mi hermano _____ un libro muy interesante.",
    options: ["lee", "leía", "leyendo"],
    answer: "lee",
    explanation: "Le verbe 'leer' au présent est 'lee'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ en el restaurante ayer.",
    options: ["comimos", "comer", "comiendo"],
    answer: "comimos",
    explanation: "Le verbe 'comer' au passé est 'comimos'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Mis amigos _____ a la playa el fin de semana.",
    options: ["fueron", "van", "ir"],
    answer: "fueron",
    explanation: "Le verbe 'ir' au passé est 'fueron'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El gato _____ en el sofá.",
    options: ["está", "estuvo", "estar"],
    answer: "está",
    explanation: "Le verbe 'estar' au présent est 'está'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa _____ del abuelo.",
    options: ["es", "está", "fue"],
    answer: "es",
    explanation: "Le verbe 'ser' au présent est 'es'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Él _____ en la universidad el año pasado.",
    options: ["estudió", "estudia", "estudiando"],
    answer: "estudió",
    explanation: "Le verbe 'estudiar' au passé est 'estudió'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ un viaje a España el año pasado.",
    options: ["hicimos", "hacemos", "hacer"],
    answer: "hicimos",
    explanation: "Le verbe 'hacer' au passé est 'hicimos'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La película que vimos _____ muy emocionante.",
    options: ["fue", "es", "ser"],
    answer: "fue",
    explanation: "Le verbe 'ser' au passé est 'fue'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Cuando _____ niño, me gustaba jugar al fútbol.",
    options: ["era", "soy", "ser"],
    answer: "era",
    explanation: "Le verbe 'ser' au passé est 'era'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ellos _____ en la reunión la semana pasada.",
    options: ["estuvieron", "están", "estar"],
    answer: "estuvieron",
    explanation: "Le verbe 'estar' au passé est 'estuvieron'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La comida que preparé _____ muy rica.",
    options: ["estaba", "está", "ser"],
    answer: "estaba",
    explanation: "Le verbe 'estar' au passé est 'estaba'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El clima de hoy _____ perfecto para salir.",
    options: ["es", "fue", "está"],
    answer: "es",
    explanation: "Le verbe 'ser' au présent est 'es'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Cuando llegué, ellos _____ en la casa.",
    options: ["estaban", "están", "estar"],
    answer: "estaban",
    explanation: "Le verbe 'estar' au passé est 'estaban'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Ella _____ un libro de aventuras.",
    options: ["lee", "leía", "leído"],
    answer: "lee",
    explanation: "Le verbe 'leer' au présent est 'lee'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "El tren _____ a las cinco.",
    options: ["sale", "salió", "salir"],
    answer: "sale",
    explanation: "Le verbe 'salir' au présent est 'sale'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La reunión _____ en la sala grande.",
    options: ["fue", "es", "está"],
    answer: "fue",
    explanation: "Le verbe 'ser' au passé est 'fue'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Cuando era niño, _____ en la playa cada verano.",
    options: ["jugaba", "jugar", "jugaría"],
    answer: "jugaba",
    explanation: "Le verbe 'jugar' au passé est 'jugaba'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Él no _____ a la fiesta porque estaba enfermo.",
    options: ["fue", "va", "ir"],
    answer: "fue",
    explanation: "Le verbe 'ir' au passé est 'fue'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La casa _____ muy antigua y bonita.",
    options: ["es", "fue", "está"],
    answer: "es",
    explanation: "Le verbe 'ser' au présent est 'es'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "La comida que preparó mi madre _____ deliciosa.",
    options: ["fue", "es", "ser"],
    answer: "fue",
    explanation: "Le verbe 'ser' au passé est 'fue'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Nosotros _____ en la montaña el año pasado.",
    options: ["esquiamos", "esquiar", "esquiando"],
    answer: "esquiamos",
    explanation: "Le verbe 'esquiar' au passé est 'esquiamos'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Langue étrangère — Espagnol — Texte à trous",
    question: "Cuando era joven, siempre _____ al cine los viernes.",
    options: ["iba", "ir", "fui"],
    answer: "iba",
    explanation: "Le verbe 'ir' au passé est 'iba'.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizLangueEtrangereEspagnol extends StatefulWidget {
  static const String routeName =
      '/gpx_exam/concours/langue_etrangere/exemples_espagnol';
  final String uid;
  final String email;

  const QuizLangueEtrangereEspagnol({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizLangueEtrangereEspagnol> createState() =>
      _QuizLangueEtrangereEspagnolState();
}

class _QuizLangueEtrangereEspagnolState
    extends State<QuizLangueEtrangereEspagnol>
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
        ? questionLangueEtrangereEspagnol
        : questionLangueEtrangereEspagnol
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
            'module_name': 'Langue étrangère - Espagnol',
            'quiz_name': 'Quiz langue étrangère espagnol',
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
      await _sb.from('quiz_langue_etrangere_espagnol').insert({
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
      debugPrint('❌ quiz_langue_etrangere_espagnol insert failed: $e');
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
