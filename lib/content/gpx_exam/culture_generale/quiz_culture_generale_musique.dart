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

final List<QuizQuestion> questionCultureMusique = [
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour ses symphonies, dont la Cinquième qui commence par trois coups de tonnerre ?",
    options: [
      "Ludwig van Beethoven",
      "Johannes Brahms",
      "Wolfgang Amadeus Mozart",
    ],
    answer: "Ludwig van Beethoven",
    explanation:
        "Beethoven est célèbre pour sa Cinquième Symphonie, souvent décrite par ses motifs dramatiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument à cordes est souvent associé à la musique classique et à des compositeurs comme Bach ?",
    options: ["Guitare", "Violon", "Piano"],
    answer: "Violon",
    explanation:
        "Le violon est un instrument central dans la musique classique, apprécié pour sa capacité d'expression.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est le plus associé à des festivals comme Coachella ?",
    options: ["Rock", "Pop", "Jazz"],
    answer: "Pop",
    explanation:
        "La pop est dominante dans de nombreux festivals contemporains, attirant les plus grandes foules.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé l'opéra 'Carmen' ?",
    options: ["Giuseppe Verdi", "Georges Bizet", "Richard Wagner"],
    answer: "Georges Bizet",
    explanation: "Bizet a écrit 'Carmen', un opéra célèbre, en 1875.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur est connu pour le titre 'Billie Jean' ?",
    options: ["Prince", "Michael Jackson", "Elton John"],
    answer: "Michael Jackson",
    explanation:
        "'Billie Jean' est l'un des titres les plus emblématiques de Michael Jackson.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style musical s'est développé dans les années 1920 aux États-Unis et a influencé le jazz ?",
    options: ["Blues", "Reggae", "Classique"],
    answer: "Blues",
    explanation:
        "Le blues est un genre qui a profondément influencé le jazz américain.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel musicien est connu pour son célèbre concerto pour piano en la mineur ?",
    options: [
      "Sergei Rachmaninoff",
      "Frédéric Chopin",
      "Wolfgang Amadeus Mozart",
    ],
    answer: "Frédéric Chopin",
    explanation:
        "Le 'Concerto en la mineur' de Chopin est une œuvre emblématique du répertoire pianistique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe britannique a révolutionné le rock dans les années 1960 avec des albums comme 'Sgt. Pepper's Lonely Hearts Club Band' ?",
    options: ["The Rolling Stones", "The Beatles", "Led Zeppelin"],
    answer: "The Beatles",
    explanation:
        "Les Beatles ont profondément marqué l'histoire de la musique avec leurs innovations sonores.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre de musique est caractérisé par des rythmes syncopés et originaire de la Nouvelle-Orléans ?",
    options: ["Jazz", "Rock", "Blues"],
    answer: "Jazz",
    explanation:
        "Le jazz est un genre qui a émergé au début du 20e siècle à la Nouvelle-Orléans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre musicien a dit un jour : 'J'ai joué chaque note, mais pas toujours dans le bon ordre' ?",
    options: ["Eric Clapton", "Jimi Hendrix", "Miles Davis"],
    answer: "Miles Davis",
    explanation:
        "Miles Davis est célèbre pour ses improvisations novatrices dans le jazz.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style de musique est souvent associé à des mouvements sociaux et à des luttes pour les droits civiques ?",
    options: ["Rock", "Reggae", "Hip-Hop"],
    answer: "Hip-Hop",
    explanation:
        "Le hip-hop est né comme un moyen d'expression pour les luttes sociales et politiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a interprété la célèbre chanson 'I Will Always Love You' ?",
    options: ["Whitney Houston", "Mariah Carey", "Celine Dion"],
    answer: "Whitney Houston",
    explanation:
        "Whitney Houston a rendu cette chanson emblématique dans les années 90.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du célèbre festival de musique qui se tient chaque année à Glastonbury ?",
    options: ["Woodstock", "Glastonbury Festival", "Coachella"],
    answer: "Glastonbury Festival",
    explanation:
        "Le festival de Glastonbury est l'un des plus grands et des plus célèbres au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument de percussion est souvent utilisé dans la musique classique et moderne ?",
    options: ["Tambour", "Flûte", "Piano"],
    answer: "Tambour",
    explanation:
        "Le tambour est un instrument de percussion essentiel dans divers genres musicaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est connu pour son album 'The Dark Side of the Moon' ?",
    options: ["Pink Floyd", "Led Zeppelin", "The Who"],
    answer: "Pink Floyd",
    explanation:
        "L'album 'The Dark Side of the Moon' est l'un des plus influents de Pink Floyd.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est souvent considéré comme le père de la symphonie ?",
    options: [
      "Joseph Haydn",
      "Wolfgang Amadeus Mozart",
      "Ludwig van Beethoven",
    ],
    answer: "Joseph Haydn",
    explanation:
        "Haydn a été un pionnier dans le développement de la forme symphonique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanson de Queen est connue pour son célèbre solo de guitare ?",
    options: [
      "Bohemian Rhapsody",
      "We Will Rock You",
      "Another One Bites the Dust",
    ],
    answer: "Bohemian Rhapsody",
    explanation:
        "Le solo de guitare de 'Bohemian Rhapsody' est l'un des plus emblématiques du rock.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel musicien est célèbre pour son style de jeu de guitare innovant et son utilisation de la distorsion ?",
    options: ["Eric Clapton", "Jimi Hendrix", "B.B. King"],
    answer: "Jimi Hendrix",
    explanation:
        "Jimi Hendrix est souvent considéré comme l'un des plus grands guitaristes de tous les temps.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style musical a émergé dans les années 1980 et a influencé la pop moderne ?",
    options: ["Synthpop", "Folk", "Rock alternatif"],
    answer: "Synthpop",
    explanation:
        "La synthpop a marqué les années 1980 avec des sons électroniques et des mélodies accrocheuses.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est le plus souvent associé à Mozart ?",
    options: ["Piano", "Clarinette", "Violoncelle"],
    answer: "Piano",
    explanation:
        "Mozart a composé de nombreuses œuvres pour piano, le rendant emblématique de son style.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle célèbre chanson commence par les mots 'Is this the real life ?' ?",
    options: ["Somebody to Love", "Bohemian Rhapsody", "Imagine"],
    answer: "Bohemian Rhapsody",
    explanation:
        "La chanson 'Bohemian Rhapsody' de Queen est connue pour son introduction mémorable.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanteuse est connue pour sa voix puissante et son rôle dans 'Le Fantôme de l'Opéra' ?",
    options: ["Sarah Brightman", "Adele", "Céline Dion"],
    answer: "Sarah Brightman",
    explanation:
        "Sarah Brightman a interprété le rôle d'Christine dans la célèbre comédie musicale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement musical du XXe siècle a mis en avant l'improvisation et le rythme ?",
    options: ["Jazz", "Classique", "Folk"],
    answer: "Jazz",
    explanation:
        "Le jazz se caractérise par son improvisation et son rythme syncopé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel album légendaire de Bob Dylan a marqué le folk rock dans les années 1960 ?",
    options: ["Highway 61 Revisited", "The Freewheelin' Bob Dylan", "Desire"],
    answer: "Highway 61 Revisited",
    explanation:
        "Cet album est un pilier du mouvement folk rock et a influencé de nombreux artistes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur est surnommé le 'Roi de la Pop' ?",
    options: ["Justin Bieber", "Michael Jackson", "Elvis Presley"],
    answer: "Michael Jackson",
    explanation:
        "Michael Jackson est souvent appelé le 'Roi de la Pop' pour son immense succès.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur russe est connu pour son ballet 'Le Lac des cygnes' ?",
    options: [
      "Igor Stravinsky",
      "Pyotr Ilyich Tchaikovsky",
      "Sergei Rachmaninoff",
    ],
    answer: "Pyotr Ilyich Tchaikovsky",
    explanation:
        "Tchaikovsky a composé 'Le Lac des cygnes', une œuvre emblématique du ballet.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle technique vocale est souvent utilisée par les chanteurs d'opéra ?",
    options: ["Falsetto", "Vibrato", "Chuchotement"],
    answer: "Vibrato",
    explanation:
        "Le vibrato est une technique clé pour enrichir le son des chanteurs d'opéra.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre musicien a remporté le prix Nobel de littérature en 2016 ?",
    options: ["Bob Dylan", "Leonard Cohen", "Paul Simon"],
    answer: "Bob Dylan",
    explanation:
        "Bob Dylan a été récompensé pour sa contribution à la musique et à la littérature.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du mouvement artistique qui cherchait à briser les conventions musicales à la fin du XIXe siècle ?",
    options: ["Impressionnisme", "Surréalisme", "Romantisme"],
    answer: "Impressionnisme",
    explanation:
        "L'impressionnisme musical a visé à évoquer des émotions plutôt qu'à suivre des formes strictes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe est célèbre pour son morceau 'Stairway to Heaven' ?",
    options: ["The Rolling Stones", "The Beatles", "Led Zeppelin"],
    answer: "Led Zeppelin",
    explanation:
        "'Stairway to Heaven' est l'un des morceaux les plus iconiques de Led Zeppelin.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle star de la musique pop a gagné de nombreux prix pour son album '25' ?",
    options: ["Adele", "Taylor Swift", "Beyoncé"],
    answer: "Adele",
    explanation:
        "Adele a remporté de nombreux prix, dont plusieurs Grammy Awards, pour son album '25'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste est reconnu pour son engagement social à travers ses chansons ?",
    options: ["Bruce Springsteen", "Elton John", "David Bowie"],
    answer: "Bruce Springsteen",
    explanation:
        "Bruce Springsteen est souvent appelé 'The Boss' pour ses chansons engagées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur est connu pour son style flamboyant et ses performances théâtrales ?",
    options: ["Freddie Mercury", "Adam Lambert", "David Bowie"],
    answer: "Freddie Mercury",
    explanation:
        "Freddie Mercury était célèbre pour ses performances énergiques et son charisme sur scène.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical a été popularisé par des artistes comme Elvis Presley ?",
    options: ["Rock and Roll", "Jazz", "Country"],
    answer: "Rock and Roll",
    explanation:
        "Elvis Presley est souvent considéré comme le roi du Rock and Roll.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre compositeur autrichien a écrit 'La Flûte enchantée' ?",
    options: ["Johann Strauss", "Wolfgang Amadeus Mozart", "Franz Schubert"],
    answer: "Wolfgang Amadeus Mozart",
    explanation:
        "La Flûte enchantée est l'un des opéras les plus connus de Mozart.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de l'instrument à vent qui se joue en soufflant dans un bec ?",
    options: ["Flûte", "Saxophone", "Trompette"],
    answer: "Flûte",
    explanation:
        "La flûte est un instrument à vent joué en soufflant dans un bec.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé la musique du film 'Star Wars' ?",
    options: ["Hans Zimmer", "John Williams", "Danny Elfman"],
    answer: "John Williams",
    explanation:
        "John Williams est le compositeur emblématique de la bande originale de 'Star Wars'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est souvent associé à des paroles engagées et à des rythmes voilés ?",
    options: ["Reggae", "Classique", "Pop"],
    answer: "Reggae",
    explanation:
        "Le reggae est connu pour ses messages sociaux et ses sons relaxants.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le nom du célèbre chanteur de 'Like a Rolling Stone' ?",
    options: ["Bruce Springsteen", "Bob Dylan", "Johnny Cash"],
    answer: "Bob Dylan",
    explanation:
        "Bob Dylan est l'auteur et interprète de 'Like a Rolling Stone', une chanson iconique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de la chanteuse connue sous le nom de 'Queen of Soul' ?",
    options: ["Aretha Franklin", "Tina Turner", "Diana Ross"],
    answer: "Aretha Franklin",
    explanation:
        "Aretha Franklin est surnommée la 'Reine de la Soul' pour sa voix puissante et son influence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument est principalement utilisé dans la musique classique pour ses aigus clairs ?",
    options: ["Piano", "Clarinette", "Hautbois"],
    answer: "Hautbois",
    explanation:
        "L'hautbois est un instrument à vent connu pour son timbre distinctif dans les orchestres.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical mélange fréquemment des éléments de blues et de rock ?",
    options: ["Rockabilly", "Pop", "Folk"],
    answer: "Rockabilly",
    explanation:
        "Le rockabilly est un genre qui combine des éléments du rock et du blues.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre compositeur a écrit la musique de 'L'Année Dernière à Marienbad' ?",
    options: ["Franz Liszt", "Alfred Schnittke", "Erik Satie"],
    answer: "Erik Satie",
    explanation:
        "Erik Satie est connu pour sa musique minimaliste et ses compositions uniques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est le chanteur des Rolling Stones ?",
    options: ["Mick Jagger", "Keith Richards", "Brian Jones"],
    answer: "Mick Jagger",
    explanation:
        "Mick Jagger est le chanteur emblématique du groupe de rock The Rolling Stones.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le nom du premier album des Beatles ?",
    options: ["Help!", "Please Please Me", "Rubber Soul"],
    answer: "Please Please Me",
    explanation:
        "'Please Please Me' est le premier album studio des Beatles, sorti en 1963.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement musical est associé à des artistes comme Antonio Vivaldi ?",
    options: ["Baroque", "Classique", "Romantique"],
    answer: "Baroque",
    explanation:
        "L'époque baroque est marquée par des compositeurs comme Vivaldi et Bach.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style de chant est caractérisé par des harmonies vocales riches et des arrangements complexes ?",
    options: ["Chœur", "A cappella", "Harmonie"],
    answer: "A cappella",
    explanation:
        "Le chant a cappella se fait sans accompagnement instrumental et met l'accent sur les voix.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanson de Nirvana est devenue l'hymne de la génération grunge ?",
    options: ["Smells Like Teen Spirit", "Come As You Are", "Lithium"],
    answer: "Smells Like Teen Spirit",
    explanation:
        "'Smells Like Teen Spirit' est considérée comme l'hymne du mouvement grunge.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument est souvent utilisé dans la musique traditionnelle celtique ?",
    options: ["Uilleann Pipes", "Saxophone", "Piano"],
    answer: "Uilleann Pipes",
    explanation:
        "Les uilleann pipes sont des cornemuses irlandaises utilisées dans la musique celtique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est Elvis Presley considéré comme le pionnier ?",
    options: ["Rock", "Jazz", "Reggae"],
    answer: "Rock",
    explanation:
        "Elvis Presley est souvent considéré comme l'un des pionniers du Rock.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est connu comme le roi du rock ?",
    options: ["Elvis Presley", "Freddie Mercury", "Michael Jackson"],
    answer: "Elvis Presley",
    explanation:
        "Elvis Presley est souvent surnommé le roi du rock en raison de son immense influence sur le genre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle composition de Beethoven est surnommée la 'Symphonie Héroïque' ?",
    options: ["Symphonie n° 3", "Symphonie n° 5", "Symphonie n° 7"],
    answer: "Symphonie n° 3",
    explanation:
        "La Symphonie n° 3 de Beethoven est appelée 'Eroica' ou 'Symphonie Héroïque' pour honorer Napoléon.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument est associé au compositeur Johann Sebastian Bach ?",
    options: ["Piano", "Violon", "Orgue"],
    answer: "Orgue",
    explanation:
        "Bach est célèbre pour ses œuvres pour orgue, instrument qu'il maîtrisait parfaitement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe britannique a sorti l'album 'Abbey Road' ?",
    options: ["The Rolling Stones", "The Beatles", "Pink Floyd"],
    answer: "The Beatles",
    explanation:
        "'Abbey Road' est un des albums les plus célèbres des Beatles, sorti en 1969.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel rythme musical est caractéristique du reggae ?",
    options: ["4/4", "3/4", "6/8"],
    answer: "4/4",
    explanation:
        "Le reggae est principalement joué en rythme 4/4, ce qui lui confère son groove distinctif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est associé au mouvement impressionniste en musique ?",
    options: ["Claude Debussy", "Johannes Brahms", "Antonín Dvořák"],
    answer: "Claude Debussy",
    explanation:
        "Claude Debussy est considéré comme le père de l'impressionnisme musical, influençant de nombreux compositeurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur a popularisé le mouvement grunge dans les années 1990 ?",
    options: ["Kurt Cobain", "Eddie Vedder", "Chris Cornell"],
    answer: "Kurt Cobain",
    explanation:
        "Kurt Cobain, leader de Nirvana, a été une figure emblématique du mouvement grunge.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle danse est souvent associée à la musique classique ?",
    options: ["Salsa", "Valse", "Hip-hop"],
    answer: "Valse",
    explanation:
        "La valse est une danse classique populaire, souvent présente dans les compositions orchestrales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle chanson de Queen parle de la lutte personnelle ?",
    options: ["We Will Rock You", "Bohemian Rhapsody", "Somebody to Love"],
    answer: "Bohemian Rhapsody",
    explanation:
        "'Bohemian Rhapsody' aborde des thèmes de lutte intérieure et de désespoir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre festival de musique a lieu chaque année à Woodstock ?",
    options: ["Glastonbury", "Montreux Jazz", "Woodstock Festival"],
    answer: "Woodstock Festival",
    explanation:
        "Le Woodstock Festival, célèbre pour son ambiance pacifiste, a eu lieu en 1969.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est Ray Charles célèbre pour avoir fusionné ?",
    options: ["Jazz et blues", "Rock et pop", "Classique et folk"],
    answer: "Jazz et blues",
    explanation:
        "Ray Charles est connu pour avoir fusionné le jazz et le blues dans sa musique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est le célèbre compositeur de 'Le Voleur de Pain' ?",
    options: ["Erik Satie", "Maurice Ravel", "Debussy"],
    answer: "Erik Satie",
    explanation:
        "Erik Satie a composé 'Le Voleur de Pain', illustrant son style unique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qu'est-ce qui caractérise le style musical d'Aretha Franklin ?",
    options: ["Jazz", "Blues", "Gospel"],
    answer: "Gospel",
    explanation:
        "Aretha Franklin est souvent associée au gospel, qui a influencé sa carrière musicale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de l'album qui a propulsé David Bowie au succès ?",
    options: ["The Rise and Fall of Ziggy Stardust", "Let’s Dance", "Heroes"],
    answer: "The Rise and Fall of Ziggy Stardust",
    explanation:
        "Cet album a marqué le début de la carrière emblématique de David Bowie en tant que rock star.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit la chanson 'Imagine' ?",
    options: ["Paul McCartney", "John Lennon", "George Harrison"],
    answer: "John Lennon",
    explanation:
        "'Imagine' a été écrite par John Lennon en 1971 et est devenue un hymne pour la paix.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument est principalement utilisé dans un concerto pour piano ?",
    options: ["Piano", "Guitare", "Violoncelle"],
    answer: "Piano",
    explanation:
        "Le piano est l'instrument principal dans un concerto pour piano, souvent accompagné d'un orchestre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est connu pour son célèbre morceau 'Clair de Lune' ?",
    options: ["Frédéric Chopin", "Claude Debussy", "Ludwig van Beethoven"],
    answer: "Claude Debussy",
    explanation:
        "'Clair de Lune' est une célèbre pièce de piano composée par Claude Debussy.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel genre musical est souvent associé à la Nouvelle-Orléans ?",
    options: ["Jazz", "Pop", "Classique"],
    answer: "Jazz",
    explanation:
        "Le jazz est né à la Nouvelle-Orléans et est profondément ancré dans sa culture musicale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est considéré comme le 'Pape du Punk' ?",
    options: ["Johnny Rotten", "Joey Ramone", "Iggy Pop"],
    answer: "Iggy Pop",
    explanation:
        "Iggy Pop est souvent reconnu comme le 'Pape du Punk' pour son influence sur la scène punk.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel album de Nirvana a popularisé le grunge ?",
    options: ["Nevermind", "In Utero", "Bleach"],
    answer: "Nevermind",
    explanation:
        "L'album 'Nevermind' de Nirvana a été un tournant dans la popularité du grunge dans les années 90.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre trompettiste américain est connu comme 'Satchmo' ?",
    options: ["Louis Armstrong", "Miles Davis", "Dizzy Gillespie"],
    answer: "Louis Armstrong",
    explanation:
        "Louis Armstrong, surnommé 'Satchmo', est une légende du jazz pour sa virtuosité à la trompette.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur a écrit 'La Traviata' ?",
    options: ["Giuseppe Verdi", "Giacomo Puccini", "Richard Wagner"],
    answer: "Giuseppe Verdi",
    explanation:
        "'La Traviata' est un opéra célèbre composé par Giuseppe Verdi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanson de Michael Jackson parle de prendre soin de la planète ?",
    options: ["Heal the World", "Billie Jean", "Thriller"],
    answer: "Heal the World",
    explanation:
        "'Heal the World' promeut un message de paix et de responsabilité envers la planète.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a réalisé le célèbre album 'The Dark Side of the Moon' ?",
    options: ["Led Zeppelin", "Pink Floyd", "The Who"],
    answer: "Pink Floyd",
    explanation:
        "Pink Floyd a publié 'The Dark Side of the Moon', un album emblématique de l'histoire du rock.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de la célèbre danse associée à la musique disco ?",
    options: ["La Macarena", "Le Cha-Cha", "Le Disco"],
    answer: "Le Disco",
    explanation:
        "Le disco a influencé une danse populaire qui a marqué les années 1970.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel courant musical est caractérisé par des improvisations ?",
    options: ["Jazz", "Classique", "Pop"],
    answer: "Jazz",
    explanation:
        "Le jazz est connu pour son improvisation, permettant aux musiciens d'exprimer leur créativité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit la célèbre musique de film 'Star Wars' ?",
    options: ["Hans Zimmer", "John Williams", "Ennio Morricone"],
    answer: "John Williams",
    explanation:
        "John Williams a composé la musique emblématique de la saga 'Star Wars'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel artiste est connu pour son style de musique country ?",
    options: ["Johnny Cash", "Frank Sinatra", "Elton John"],
    answer: "Johnny Cash",
    explanation:
        "Johnny Cash est un artiste légendaire connu pour sa musique country et folk.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle artiste est célèbre pour sa voix puissante et son album 'Back to Black' ?",
    options: ["Adele", "Amy Winehouse", "Taylor Swift"],
    answer: "Amy Winehouse",
    explanation:
        "Amy Winehouse est célèbre pour sa voix unique et son album 'Back to Black', qui lui a valu des récompenses.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre instrument à cordes est joué avec un archet ?",
    options: ["Guitare", "Violon", "Piano"],
    answer: "Violon",
    explanation:
        "Le violon est un instrument à cordes joué principalement avec un archet.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a popularisé le hip-hop avec son album 'The Chronic' ?",
    options: ["Snoop Dogg", "Dr. Dre", "Tupac Shakur"],
    answer: "Dr. Dre",
    explanation:
        "Dr. Dre a joué un rôle crucial dans la popularisation du hip-hop avec son album 'The Chronic'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle est la langue principale utilisée dans les chansons de Shakira ?",
    options: ["Français", "Espagnol", "Anglais"],
    answer: "Espagnol",
    explanation:
        "Shakira chante principalement en espagnol, bien qu'elle utilise également l'anglais dans sa musique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe de rock est connu pour avoir été formé à Seattle en 1990 ?",
    options: ["Soundgarden", "Nirvana", "Pearl Jam"],
    answer: "Pearl Jam",
    explanation:
        "Pearl Jam est un groupe de rock emblématique formé à Seattle au début des années 90.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle est la principale différence entre un sonata et un concerto ?",
    options: ["Taille", "nombre de musiciens", "forme"],
    answer: "nombre de musiciens",
    explanation:
        "La principale différence est que le concerto implique souvent un soliste accompagné d'un orchestre, tandis que la sonate est généralement pour un ou deux instruments.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit la célèbre chanson 'Let It Be' ?",
    options: ["George Harrison", "Paul McCartney", "John Lennon"],
    answer: "Paul McCartney",
    explanation:
        "'Let It Be' est une chanson des Beatles écrite par Paul McCartney.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le principal instrument utilisé dans un orchestre symphonique ?",
    options: ["Piano", "Violoncelle", "Violons"],
    answer: "Violons",
    explanation:
        "Les violons constituent une part importante de l'orchestre symphonique, souvent en nombre supérieur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel genre de musique est commencé par l'artiste Bob Marley ?",
    options: ["Reggae", "Ska", "R&B"],
    answer: "Reggae",
    explanation:
        "Bob Marley est un pionnier du reggae, popularisant ce genre à l'international.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle célèbre chanteuse est connue pour ses performances scéniques audacieuses ?",
    options: ["Lady Gaga", "Beyoncé", "Rihanna"],
    answer: "Lady Gaga",
    explanation:
        "Lady Gaga est reconnue pour ses performances scéniques innovantes et provocantes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument joue un rôle central dans la musique folk ?",
    options: ["Guitare acoustique", "Batterie", "Piano"],
    answer: "Guitare acoustique",
    explanation:
        "La guitare acoustique est un instrument fondamental dans le genre folk, souvent utilisé pour accompagner le chant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel producteur est souvent nommé 'le cinquième Beatle' ?",
    options: ["George Martin", "Phil Spector", "Brian Epstein"],
    answer: "George Martin",
    explanation:
        "George Martin est fréquemment appelé 'le cinquième Beatle' pour son rôle clé dans la production des albums des Beatles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanson de Whitney Houston a été un énorme succès dans les années 1990 ?",
    options: ["I Will Always Love You", "My Heart Will Go On", "Like a Prayer"],
    answer: "I Will Always Love You",
    explanation:
        "'I Will Always Love You' est l'un des plus grands succès de Whitney Houston, sorti en 1992.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel type de musique est associé aux années folles ?",
    options: ["Swing", "Techno", "Rock"],
    answer: "Swing",
    explanation:
        "Le swing est un genre de musique jazz qui a prospéré pendant les années folles dans les années 1920.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle est la pièce musicale célèbre de Sibelius ?",
    options: [
      "Finlandia",
      "The Nutcracker Suite",
      "In the Hall of the Mountain King",
    ],
    answer: "Finlandia",
    explanation:
        "'Finlandia' est une œuvre symphonique célèbre de Jean Sibelius, incarnant l'esprit finlandais.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a chanté la chanson thème du film 'Titanic' ?",
    options: ["Celine Dion", "Shania Twain", "Adele"],
    answer: "Celine Dion",
    explanation:
        "Celine Dion a interprété la chanson 'My Heart Will Go On', thème principal du film 'Titanic'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel artiste est connu pour ses clips musicaux extravagants ?",
    options: ["Madonna", "Katy Perry", "Miley Cyrus"],
    answer: "Madonna",
    explanation:
        "Madonna est célèbre pour ses clips musicaux audacieux et innovants qui ont marqué l'histoire de la pop.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le style musical de Mozart ?",
    options: ["Classique", "Baroque", "Romantique"],
    answer: "Classique",
    explanation:
        "Wolfgang Amadeus Mozart est l'un des compositeurs majeurs du mouvement classique en musique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel mouvement musical a émergé dans les années 1980 ?",
    options: ["Romantique", "Reggae", "New Wave"],
    answer: "New Wave",
    explanation:
        "Le mouvement New Wave a émergé dans les années 1980, fusionnant rock et synthétiseurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est l'instrument principal de la musique celtique ?",
    options: ["Flûte", "Harpe", "Batterie"],
    answer: "Harpe",
    explanation:
        "La harpe est souvent considérée comme l'instrument emblématique de la musique celtique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Qui a popularisé le blues avec sa célèbre chanson 'Cross Road Blues' ?",
    options: ["Robert Johnson", "B.B. King", "Muddy Waters"],
    answer: "Robert Johnson",
    explanation:
        "Robert Johnson est souvent cité comme l'un des pionniers du blues, surtout connu pour 'Cross Road Blues'.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est surnommé le 'Roi de la Pop' ?",
    options: ["Madonna", "Michael Jackson", "Elvis Presley"],
    answer: "Michael Jackson",
    explanation:
        "Michael Jackson est mondialement reconnu pour avoir popularisé la musique pop dans les années 1980 et 1990.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument est traditionnellement associé à la musique classique ?",
    options: ["Guitare", "Piano", "Batterie"],
    answer: "Piano",
    explanation:
        "Le piano est un instrument central dans la musique classique et a été utilisé par de nombreux compositeurs célèbres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel genre musical est Elvis Presley principalement associé à ?",
    options: ["Jazz", "Rock and Roll", "Reggae"],
    answer: "Rock and Roll",
    explanation:
        "Elvis Presley est souvent considéré comme le pionnier du Rock and Roll dans les années 1950.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe britannique est célèbre pour son album 'The Dark Side of the Moon' ?",
    options: ["The Beatles", "Pink Floyd", "Queen"],
    answer: "Pink Floyd",
    explanation:
        "L'album 'The Dark Side of the Moon' de Pink Floyd est reconnu pour son innovation musicale et ses thèmes profonds.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "En quelle année est sorti l'album 'Thriller' de Michael Jackson ?",
    options: ["1980", "1982", "1984"],
    answer: "1982",
    explanation:
        "L'album 'Thriller' a été publié en 1982 et est devenu l'album le plus vendu de tous les temps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour ses symphonies, notamment la 9e 'Ode à la Joie' ?",
    options: [
      "Ludwig van Beethoven",
      "Johann Sebastian Bach",
      "Frédéric Chopin",
    ],
    answer: "Ludwig van Beethoven",
    explanation:
        "La 9e symphonie de Beethoven, avec son 'Ode à la Joie', est un chef-d'œuvre de la musique classique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style musical est associé à des artistes comme Billie Holiday et Louis Armstrong ?",
    options: ["Blues", "Jazz", "Classique"],
    answer: "Jazz",
    explanation:
        "Le jazz est un genre musical qui a émergé au début du 20ème siècle, influençant de nombreux artistes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit la célèbre chanson 'Imagine' ?",
    options: ["John Lennon", "Paul McCartney", "Bob Dylan"],
    answer: "John Lennon",
    explanation:
        "'Imagine' est une chanson emblématique de John Lennon, promouvant la paix mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du célèbre festival de musique qui se tient à Woodstock ?",
    options: [
      "Monterey Pop Festival",
      "Woodstock Festival",
      "Glastonbury Festival",
    ],
    answer: "Woodstock Festival",
    explanation:
        "Le festival de Woodstock, tenu en 1969, est considéré comme un événement marquant de la culture musicale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur est connu pour son rôle dans le film 'Purple Rain' ?",
    options: ["Michael Jackson", "Prince", "Stevie Wonder"],
    answer: "Prince",
    explanation:
        "Prince a sorti la bande originale 'Purple Rain' qui a connu un immense succès commercial et critique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est au cœur d'un orchestre symphonique ?",
    options: ["Violoncelle", "Guitare", "Synthétiseur"],
    answer: "Violoncelle",
    explanation:
        "Le violoncelle est un instrument clé dans l'ensemble des cordes d'un orchestre symphonique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est caractérisé par des improvisations et des rythmes complexes ?",
    options: ["Rock", "Jazz", "Hip-Hop"],
    answer: "Jazz",
    explanation:
        "Le jazz se distingue par son approche improvisée et ses structures rythmiques uniques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a créé la célèbre composition 'The Four Seasons' ?",
    options: ["Antonio Vivaldi", "Johann Bach", "Frédéric Chopin"],
    answer: "Antonio Vivaldi",
    explanation:
        "'The Four Seasons' est une série de concertos pour violon écrite par Antonio Vivaldi au 18ème siècle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur est le leader du groupe U2 ?",
    options: ["Bono", "Chris Martin", "Sting"],
    answer: "Bono",
    explanation:
        "Bono est le chanteur principal et le visage emblématique du groupe irlandais U2.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel musicien est connu pour le morceau 'Billie Jean' ?",
    options: ["Prince", "Elton John", "Michael Jackson"],
    answer: "Michael Jackson",
    explanation:
        "'Billie Jean' est l'un des plus grands succès de Michael Jackson, issu de l'album 'Thriller'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit des ballets comme 'Casse-Noisette' ?",
    options: ["Igor Stravinsky", "Pyotr Ilyich Tchaikovsky", "Claude Debussy"],
    answer: "Pyotr Ilyich Tchaikovsky",
    explanation:
        "Tchaikovsky est célèbre pour ses ballets, dont 'Casse-Noisette' qui est incontournable à Noël.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe est célèbre pour la chanson 'Bohemian Rhapsody' ?",
    options: ["The Rolling Stones", "Queen", "Led Zeppelin"],
    answer: "Queen",
    explanation:
        "'Bohemian Rhapsody' est une œuvre emblématique du groupe Queen, connue pour sa structure unique et ses harmonies.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument à vent est souvent utilisé dans la musique jazz ?",
    options: ["Saxophone", "Hautbois", "Harmonica"],
    answer: "Saxophone",
    explanation:
        "Le saxophone est un instrument emblématique du jazz, apprécié pour son expressivité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur est célèbre pour sa chanson 'Like a Rolling Stone' ?",
    options: ["Elvis Presley", "Bob Dylan", "Bruce Springsteen"],
    answer: "Bob Dylan",
    explanation:
        "Bob Dylan est un songwriter légendaire, et 'Like a Rolling Stone' est l'une de ses œuvres les plus célèbres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour sa musique d'accompagnement de film, notamment dans 'Star Wars' ?",
    options: ["Hans Zimmer", "John Williams", "Ennio Morricone"],
    answer: "John Williams",
    explanation:
        "John Williams a composé les célèbres thèmes musicaux pour des films comme 'Star Wars', 'Indiana Jones' et 'Jurassic Park'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est souvent associé à des danses latines comme la salsa ?",
    options: ["Reggae", "Pop", "Latino"],
    answer: "Latino",
    explanation:
        "Le genre latino englobe plusieurs styles musicaux, dont la salsa, influençant de nombreuses cultures à travers le monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit la symphonie 'Symphony No. 5'?",
    options: [
      "Ludwig van Beethoven",
      "Wolfgang Amadeus Mozart",
      "Claude Debussy",
    ],
    answer: "Ludwig van Beethoven",
    explanation:
        "La 'Symphony No. 5' de Beethoven est connue pour son motif d'ouverture emblématique et son impact sur la musique classique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur a popularisé le tube 'Rolling in the Deep' ?",
    options: ["Adele", "Rihanna", "Beyoncé"],
    answer: "Adele",
    explanation:
        "'Rolling in the Deep' est la chanson qui a propulsé Adele au sommet des charts internationaux en 2011.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est reconnu pour ses nombreux concertos pour piano ?",
    options: ["Frédéric Chopin", "Sergei Rachmaninoff", "Johannes Brahms"],
    answer: "Frédéric Chopin",
    explanation:
        "Chopin est célèbre pour ses compositions pour piano, dont plusieurs concertos qui sont des classiques du répertoire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel artiste est souvent appelé 'The Queen of Soul' ?",
    options: ["Aretha Franklin", "Whitney Houston", "Tina Turner"],
    answer: "Aretha Franklin",
    explanation:
        "Aretha Franklin est célébrée pour sa voix puissante et son influence sur la musique soul.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe a sorti l'album 'Abbey Road' ?",
    options: ["The Beach Boys", "The Beatles", "The Rolling Stones"],
    answer: "The Beatles",
    explanation:
        "'Abbey Road' est l'un des albums les plus emblématiques des Beatles, sorti en 1969.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est au centre de la musique folk américaine ?",
    options: ["Piano", "Guitare", "Saxophone"],
    answer: "Guitare",
    explanation:
        "La guitare est un instrument clé dans la musique folk américaine, souvent utilisée pour accompagner le chant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a créé le célèbre morceau 'Clair de Lune' ?",
    options: ["Claude Debussy", "Erik Satie", "Gabriel Fauré"],
    answer: "Claude Debussy",
    explanation:
        "'Clair de Lune' est une pièce emblématique de Debussy, reconnue pour sa beauté impressionniste.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste a influencé le genre reggae avec des titres comme 'No Woman, No Cry' ?",
    options: ["Bob Marley", "Jimmy Cliff", "Burning Spear"],
    answer: "Bob Marley",
    explanation:
        "Bob Marley est considéré comme l'icône du reggae, et 'No Woman, No Cry' est l'une de ses chansons les plus célèbres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est le fondateur du groupe Nirvana ?",
    options: ["Kurt Cobain", "Dave Grohl", "Krist Novoselic"],
    answer: "Kurt Cobain",
    explanation:
        "Kurt Cobain était le chanteur et compositeur principal de Nirvana, un groupe emblématique du grunge.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument est considéré comme le roi des instruments à cordes ?",
    options: ["Guitare", "Violon", "Piano"],
    answer: "Piano",
    explanation:
        "Souvent appelé le 'roi des instruments', le piano est très polyvalent et utilisé dans de nombreux styles musicaux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel album de Pink Floyd est centré autour des troubles mentaux ?",
    options: ["Animals", "The Wall", "Wish You Were Here"],
    answer: "The Wall",
    explanation:
        "L'album 'The Wall' aborde des thèmes de la solitude et de la santé mentale à travers la musique et les paroles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit 'La Traviata' ?",
    options: ["Giuseppe Verdi", "Giacomo Puccini", "Wolfgang Amadeus Mozart"],
    answer: "Giuseppe Verdi",
    explanation:
        "'La Traviata' est l'un des opéras les plus célèbres de Verdi, reconnu pour son émotion et sa mélodie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du mouvement musical né dans les années 1950 qui a ensuite influencé le rock ?",
    options: ["Blues", "Jazz", "Gospel"],
    answer: "Blues",
    explanation:
        "Le blues, né dans le sud des États-Unis, a joué un rôle essentiel dans le développement du rock et d'autres genres musicaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste est connu pour avoir chanté 'I Will Always Love You' ?",
    options: ["Beyoncé", "Whitney Houston", "Celine Dion"],
    answer: "Whitney Houston",
    explanation:
        "Whitney Houston a popularisé 'I Will Always Love You', une chanson initialement écrite par Dolly Parton.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style de musique est associé à des festivals comme Coachella ?",
    options: ["Rock", "Pop", "Indie"],
    answer: "Indie",
    explanation:
        "Le festival de Coachella met en avant de nombreux artistes du genre indie, représentant des scènes musicales variées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé la musique de 'Star Wars' ?",
    options: ["Hans Zimmer", "John Williams", "Danny Elfman"],
    answer: "John Williams",
    explanation:
        "John Williams a composé la musique emblématique de la saga 'Star Wars', marquant le cinéma moderne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel monument américain rend hommage à des artistes de jazz ?",
    options: [
      "Jazz Hall of Fame",
      "Rock and Roll Hall of Fame",
      "Country Music Hall of Fame",
    ],
    answer: "Jazz Hall of Fame",
    explanation:
        "Le Jazz Hall of Fame honore les contributions des artistes qui ont façonné le genre jazz.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur est célèbre pour ses performances vocales puissantes et son rôle dans le groupe Queen ?",
    options: ["Freddie Mercury", "Robert Plant", "Axl Rose"],
    answer: "Freddie Mercury",
    explanation:
        "Freddie Mercury, le chanteur de Queen, est connu pour sa voix dynamique et sa présence scénique charismatique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est associé à la fonction de 'maître du concerto' ?",
    options: [
      "Wolfgang Amadeus Mozart",
      "Johann Sebastian Bach",
      "Franz Joseph Haydn",
    ],
    answer: "Wolfgang Amadeus Mozart",
    explanation:
        "Mozart est reconnu pour la qualité et la quantité de ses concertos, établissant les normes du genre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel courant musical est né en réaction au rock des années 1980 ?",
    options: ["Grunge", "Heavy Metal", "Punk"],
    answer: "Grunge",
    explanation:
        "Le grunge a émergé dans les années 1990 en réaction contre le glam rock et le hard rock, privilégiant un son brut et authentique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel duo pop est célèbre pour sa chanson 'Shallow' ?",
    options: [
      "Lady Gaga et Bradley Cooper",
      "Beyoncé et Jay-Z",
      "Sam Smith et Normani",
    ],
    answer: "Lady Gaga et Bradley Cooper",
    explanation:
        "'Shallow' est une chanson devenue emblématique grâce à sa performance dans le film 'A Star is Born'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel acteur est également connu comme chanteur de country et a reçu plusieurs Grammy Awards ?",
    options: ["Johnny Depp", "Tim McGraw", "Will Smith"],
    answer: "Tim McGraw",
    explanation:
        "Tim McGraw est un chanteur de country à succès, connu pour ses nombreuses chansons et ses performances.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe a enregistré la célèbre chanson 'Hotel California' ?",
    options: ["The Eagles", "Fleetwood Mac", "The Doors"],
    answer: "The Eagles",
    explanation:
        "'Hotel California' est l'un des morceaux les plus connus des Eagles, abordant des thèmes complexes de la vie et de la culture américaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour ses œuvres sur piano uniquement ?",
    options: ["Frederic Chopin", "Claude Debussy", "Ludwig van Beethoven"],
    answer: "Frederic Chopin",
    explanation:
        "Chopin est reconnu principalement pour ses compositions pour piano, marquant l'évolution de la musique romantique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est caractérisé par des rythmes syncopés et une forte influence africaine ?",
    options: ["Jazz", "Reggae", "Hip-Hop"],
    answer: "Jazz",
    explanation:
        "Le jazz se distingue par ses rythmes syncopés, ses improvisations et ses racines africaines.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel festival est mondialement connu pour sa culture musicale alternatif ?",
    options: ["Glastonbury", "Lollapalooza", "Coachella"],
    answer: "Glastonbury",
    explanation:
        "Le festival de Glastonbury est célèbre pour sa diversité musicale et son atmosphère festive.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste a reçu le prix Nobel de littérature pour ses contributions musicales et poétiques ?",
    options: ["Bob Dylan", "Leonard Cohen", "David Bowie"],
    answer: "Bob Dylan",
    explanation:
        "Bob Dylan a été récompensé par le prix Nobel de littérature pour sa poésie et son impact sur la musique et la culture.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur est connu pour être un pionnier du rock alternatif dans les années 1990 ?",
    options: ["Kurt Cobain", "Chris Cornell", "Eddie Vedder"],
    answer: "Kurt Cobain",
    explanation:
        "Kurt Cobain, en tant que leader de Nirvana, a défini le son du rock alternatif dans les années 1990.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle est la nationalité de Mozart ?",
    options: ["Autrichienne", "Allemande", "Italienne"],
    answer: "Autrichienne",
    explanation: "Wolfgang Amadeus Mozart est né à Salzbourg, en Autriche.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est principalement associé au jazz ?",
    options: ["Guitare", "Piano", "Saxophone"],
    answer: "Saxophone",
    explanation:
        "Le saxophone est un instrument emblématique du jazz, créé par Adolphe Sax.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé l'œuvre 'La Traviata' ?",
    options: ["Giuseppe Verdi", "Giacomo Puccini", "Wolfgang Amadeus Mozart"],
    answer: "Giuseppe Verdi",
    explanation:
        "La Traviata est un opéra en trois actes de Giuseppe Verdi, créé en 1853.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical a émergé à la Nouvelle-Orléans dans les années 1910 ?",
    options: ["Blues", "Jazz", "Rock"],
    answer: "Jazz",
    explanation:
        "Le jazz est né dans les années 1910 à la Nouvelle-Orléans, mélangeant plusieurs influences musicales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Qui est la célèbre chanteuse connue comme 'La Reine de la Soul' ?",
    options: ["Aretha Franklin", "Tina Turner", "Whitney Houston"],
    answer: "Aretha Franklin",
    explanation:
        "Aretha Franklin est surnommée 'La Reine de la Soul' en raison de sa voix puissante et de ses contributions au genre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style musical est lié au mouvement hippie des années 1960 ?",
    options: ["Reggae", "Folk", "Punk"],
    answer: "Folk",
    explanation:
        "La musique folk a joué un rôle central dans le mouvement hippie, exprimant des idéaux pacifistes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a chanté 'Imagine' ?",
    options: ["John Lennon", "Paul McCartney", "George Harrison"],
    answer: "John Lennon",
    explanation:
        "'Imagine' est une chanson emblématique écrite et interprétée par John Lennon.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du festival de musique qui se tient à Woodstock ?",
    options: ["Woodstock Music Festival", "Coachella", "Glastonbury"],
    answer: "Woodstock Music Festival",
    explanation:
        "Le festival de Woodstock, qui a eu lieu en 1969, est célèbre pour sa promotion de la paix et de la musique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a fondé le groupe The Rolling Stones ?",
    options: ["Mick Jagger", "Keith Richards", "Brian Jones"],
    answer: "Brian Jones",
    explanation:
        "Brian Jones a cofondé The Rolling Stones en 1962, devenant une figure emblématique du rock.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour ses symphonies et son 'Hymne à la joie' ?",
    options: ["Beethoven", "Brahms", "Haydn"],
    answer: "Beethoven",
    explanation:
        "L'Hymne à la joie est extrait de la 9ème symphonie de Ludwig van Beethoven.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument de musique est également appelé 'violon alto' ?",
    options: ["Violon", "Alto", "Viole"],
    answer: "Alto",
    explanation:
        "L'alto est un instrument à cordes de la famille du violon, légèrement plus grand.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit la célèbre chanson 'Billie Jean' ?",
    options: ["Prince", "Michael Jackson", "Madonna"],
    answer: "Michael Jackson",
    explanation:
        "'Billie Jean' est l'une des chansons les plus célèbres de Michael Jackson, sortie en 1982.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qu'est-ce que le 'rap' ?",
    options: ["Un style de danse", "Une forme de poésie", "Un genre musical"],
    answer: "Un genre musical",
    explanation:
        "Le rap est un genre musical caractérisé par la rime et le rythme, souvent associé à la culture hip-hop.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur est lié au ballet 'Casse-noisette' ?",
    options: ["Tchaïkovski", "Stravinsky", "Chopin"],
    answer: "Tchaïkovski",
    explanation:
        "Casse-noisette est un ballet composé par Piotr Ilitch Tchaïkovski.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe est connu pour le tube 'Bohemian Rhapsody' ?",
    options: ["Queen", "The Beatles", "Led Zeppelin"],
    answer: "Queen",
    explanation:
        "'Bohemian Rhapsody' est une chanson emblématique du groupe britannique Queen, sortie en 1975.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est le chanteur du groupe U2 ?",
    options: ["Bono", "Edge", "Larry Mullen Jr."],
    answer: "Bono",
    explanation:
        "Bono est le chanteur principal et co-fondateur du groupe de rock U2.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Dans quel pays la musique flamenco est-elle originaire ?",
    options: ["Espagne", "Portugal", "Italie"],
    answer: "Espagne",
    explanation:
        "Le flamenco est un genre musical et de danse originaire d'Andalousie, en Espagne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel duo a chanté 'I Got You Babe' ?",
    options: ["Sonny & Cher", "Simon & Garfunkel", "The Everly Brothers"],
    answer: "Sonny & Cher",
    explanation:
        "'I Got You Babe' est une chanson emblématique du duo Sonny & Cher sortie en 1965.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le célèbre festival de musique en Californie ?",
    options: ["Lollapalooza", "Coachella", "Glastonbury"],
    answer: "Coachella",
    explanation:
        "Le festival Coachella est un événement musical majeur qui se déroule chaque année en Californie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel artiste est connu pour le mouvement 'New Wave' ?",
    options: ["David Bowie", "Madonna", "The Cure"],
    answer: "The Cure",
    explanation:
        "The Cure est l'un des groupes emblématiques du mouvement New Wave des années 1980.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument de musique a six cordes et est souvent utilisé dans le rock ?",
    options: ["Basse", "Guitare électrique", "Piano"],
    answer: "Guitare électrique",
    explanation:
        "La guitare électrique est un instrument essentiel dans de nombreux genres de musique, y compris le rock.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le véritable nom de Lady Gaga ?",
    options: ["Stefani Germanotta", "Ariana Grande", "Demi Lovato"],
    answer: "Stefani Germanotta",
    explanation:
        "Le vrai nom de Lady Gaga est Stefani Joanne Angelina Germanotta.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé les 'Quatre saisons' ?",
    options: ["Bach", "Vivaldi", "Handel"],
    answer: "Vivaldi",
    explanation:
        "Les 'Quatre saisons' est un ensemble de concertos pour violon composés par Antonio Vivaldi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est représenté par des artistes comme Elvis Presley ?",
    options: ["Rock and roll", "Jazz", "Classique"],
    answer: "Rock and roll",
    explanation:
        "Elvis Presley est souvent considéré comme le roi du rock and roll.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a remporté le plus de Grammy Awards en 2020 ?",
    options: ["Billie Eilish", "Taylor Swift", "Ariana Grande"],
    answer: "Billie Eilish",
    explanation:
        "Billie Eilish a remporté cinq Grammy Awards lors de la cérémonie de 2020.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe a interprété 'Stairway to Heaven' ?",
    options: ["Led Zeppelin", "Pink Floyd", "The Doors"],
    answer: "Led Zeppelin",
    explanation:
        "'Stairway to Heaven' est une chanson emblématique du groupe Led Zeppelin.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel pays est le berceau du reggae ?",
    options: ["Jamaïque", "Cuba", "Trinidad"],
    answer: "Jamaïque",
    explanation:
        "Le reggae est un genre musical qui est originaire de Jamaïque, particulièrement dans les années 1960.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est le compositeur de 'La Flûte enchantée' ?",
    options: ["Wolfgang Amadeus Mozart", "Giuseppe Verdi", "Richard Wagner"],
    answer: "Wolfgang Amadeus Mozart",
    explanation:
        "La Flûte enchantée est un opéra de Wolfgang Amadeus Mozart, créé en 1791.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel mouvement musical est caractérisé par le punk rock ?",
    options: ["Gothique", "Rock alternatif", "Punk"],
    answer: "Punk",
    explanation:
        "Le punk est un mouvement musical qui a émergé dans les années 1970, souvent associé à une attitude rebelle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel artiste est célèbre pour son titre 'Shape of You' ?",
    options: ["Ed Sheeran", "Justin Bieber", "Drake"],
    answer: "Ed Sheeran",
    explanation:
        "'Shape of You' est l'une des chansons les plus populaires d'Ed Sheeran, sortie en 2017.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a dirigé l'orchestre de 'Carmen' ?",
    options: ["Georges Bizet", "Giacomo Puccini", "Richard Wagner"],
    answer: "Georges Bizet",
    explanation: "Carmen est un opéra composé par Georges Bizet, créé en 1875.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel type de musique utilise principalement des samples et un rythme fort ?",
    options: ["Classique", "Hip-hop", "Jazz"],
    answer: "Hip-hop",
    explanation:
        "Le hip-hop se caractérise souvent par l'utilisation de samples et d'un rythme entraînant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est souvent considéré comme le 'Roi du Pop' ?",
    options: ["Elvis Presley", "Michael Jackson", "Prince"],
    answer: "Michael Jackson",
    explanation:
        "Michael Jackson est souvent surnommé le 'Roi du Pop' pour ses nombreuses contributions au genre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel festival de musique a lieu chaque année à Glastonbury ?",
    options: ["Glastonbury Festival", "Reading Festival", "Lollapalooza"],
    answer: "Glastonbury Festival",
    explanation:
        "Le Glastonbury Festival est l'un des festivals de musique les plus célèbres au monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel artiste a popularisé le style musical 'soul' ?",
    options: ["James Brown", "Stevie Wonder", "Aretha Franklin"],
    answer: "Aretha Franklin",
    explanation:
        "Aretha Franklin est souvent vue comme l'artiste qui a popularisé le genre soul.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du groupe de rock britannique qui a sorti l'album 'Dark Side of the Moon' ?",
    options: ["Led Zeppelin", "Pink Floyd", "The Rolling Stones"],
    answer: "Pink Floyd",
    explanation:
        "'Dark Side of the Moon' est un album célèbre de Pink Floyd, sorti en 1973.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a chanté 'Like a Virgin' ?",
    options: ["Katy Perry", "Madonna", "Britney Spears"],
    answer: "Madonna",
    explanation:
        "'Like a Virgin' est l'un des titres les plus emblématiques de Madonna, sorti en 1984.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le symbole du mouvement grunge ?",
    options: ["Nirvana", "Pearl Jam", "Soundgarden"],
    answer: "Nirvana",
    explanation:
        "Nirvana est souvent considéré comme le groupe phare du mouvement grunge des années 1990.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est souvent utilisé dans le blues ?",
    options: ["Harmonica", "Clarinette", "Flûte"],
    answer: "Harmonica",
    explanation:
        "L'harmonica est un instrument emblématique souvent associé au blues.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du célèbre compositeur de l'opéra 'Don Giovanni' ?",
    options: ["Mozart", "Verdi", "Bach"],
    answer: "Mozart",
    explanation:
        "'Don Giovanni' est un opéra composé par Wolfgang Amadeus Mozart.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a popularisé la chanson 'Gangnam Style' ?",
    options: ["Psy", "Snoop Dogg", "Lil Nas X"],
    answer: "Psy",
    explanation:
        "'Gangnam Style' est une chanson du rappeur sud-coréen Psy, devenue virale en 2012.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel genre musical est associé au chanteur Bob Marley ?",
    options: ["Reggae", "Pop", "Rock"],
    answer: "Reggae",
    explanation:
        "Bob Marley est célèbre pour avoir popularisé le reggae à l'échelle mondiale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle est la langue originale de la chanson 'Despacito' ?",
    options: ["Français", "Anglais", "Espagnol"],
    answer: "Espagnol",
    explanation:
        "'Despacito' est une chanson en espagnol du chanteur Luis Fonsi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument à cordes est joué avec un archet ?",
    options: ["Guitare", "Violoncelle", "Piano"],
    answer: "Violoncelle",
    explanation:
        "Le violoncelle est un instrument à cordes qui se joue avec un archet.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste est connu pour ses performances extravagantes et son style flamboyant ?",
    options: ["Elton John", "David Bowie", "Prince"],
    answer: "Elton John",
    explanation:
        "Elton John est célèbre pour ses costumes flamboyants et ses performances musicales énergiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur est connu comme 'Le Boss' ?",
    options: ["Bruce Springsteen", "Bob Dylan", "Billy Joel"],
    answer: "Bruce Springsteen",
    explanation:
        "Bruce Springsteen est surnommé 'Le Boss' en raison de son charisme sur scène et de son influence musicale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel ancien membre des Beatles a eu un succès solo avec le titre 'My Sweet Lord' ?",
    options: ["George Harrison", "Ringo Starr", "John Lennon"],
    answer: "George Harrison",
    explanation:
        "George Harrison a sorti 'My Sweet Lord' en tant que single solo, devenant un grand succès.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe est connu pour son album 'Abbey Road' ?",
    options: ["The Who", "The Beatles", "The Rolling Stones"],
    answer: "The Beatles",
    explanation:
        "'Abbey Road' est l'un des albums les plus célèbres des Beatles, sorti en 1969.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel genre de musique est associé à la danse 'salsa' ?",
    options: ["Jazz", "Reggae", "Latino"],
    answer: "Latino",
    explanation:
        "La salsa est un genre musical et une danse qui provient de la culture latino-américaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit et composé 'The Sound of Silence' ?",
    options: ["Simon & Garfunkel", "Bob Dylan", "The Beatles"],
    answer: "Simon & Garfunkel",
    explanation:
        "'The Sound of Silence' est une chanson emblématique écrite par Simon & Garfunkel.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour ses œuvres symphoniques au XIXe siècle ?",
    options: [
      "Ludwig van Beethoven",
      "Johann Sebastian Bach",
      "Claude Debussy",
    ],
    answer: "Ludwig van Beethoven",
    explanation:
        "Ludwig van Beethoven est célèbre pour ses symphonies qui ont marqué la transition entre le classicisme et le romantisme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre groupe britannique a enregistré l'album \"The Dark Side of the Moon\" ?",
    options: ["The Rolling Stones", "Led Zeppelin", "Pink Floyd"],
    answer: "Pink Floyd",
    explanation:
        "\"The Dark Side of the Moon\" est un album emblématique de Pink Floyd, sorti en 1973.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé l'opéra \"Carmen\" ?",
    options: ["Giuseppe Verdi", "Georges Bizet", "Wolfgang Amadeus Mozart"],
    answer: "Georges Bizet",
    explanation:
        "\"Carmen\" est un opéra composé par Georges Bizet, créé en 1875.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel genre musical est associé à Bob Marley ?",
    options: ["Reggae", "Blues", "Rock"],
    answer: "Reggae",
    explanation:
        "Bob Marley est un icône du reggae, célèbre pour sa musique engagée et son message de paix.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur a écrit la \"Symphonie Fantastique\" ?",
    options: ["Hector Berlioz", "Frédéric Chopin", "Johannes Brahms"],
    answer: "Hector Berlioz",
    explanation:
        "Hector Berlioz est l'auteur de la \"Symphonie Fantastique\", une œuvre majeure du romantisme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste a popularisé le mouvement grunge dans les années 1990 ?",
    options: ["Kurt Cobain", "Eddie Vedder", "Chris Cornell"],
    answer: "Kurt Cobain",
    explanation:
        "Kurt Cobain, chanteur de Nirvana, est souvent considéré comme la figure emblématique du grunge.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du célèbre festival de musique qui se déroule à Woodstock ?",
    options: ["Coachella", "Glastonbury", "Woodstock Music Festival"],
    answer: "Woodstock Music Festival",
    explanation:
        "Le Woodstock Music Festival, qui a eu lieu en 1969, est un symbole de la culture hippie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quand a été fondé le mouvement du rock and roll ?",
    options: [
      "Dans les années 1940",
      "Dans les années 1950",
      "Dans les années 1960",
    ],
    answer: "Dans les années 1950",
    explanation:
        "Le rock and roll est né dans les années 1950, influençant de nombreux genres musicaux par la suite.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste est connu pour sa voix puissante et ses performances scéniques spectaculaires ?",
    options: ["Whitney Houston", "Céline Dion", "Mariah Carey"],
    answer: "Whitney Houston",
    explanation:
        "Whitney Houston est célèbre pour sa voix exceptionnelle et ses nombreux succès dans les années 80 et 90.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical a émergé dans les années 70 et combine funk, soul et jazz ?",
    options: ["Disco", "Rock alternatif", "Hip-hop"],
    answer: "Disco",
    explanation:
        "Le disco a émergé dans les années 70, caractérisé par ses rythmes entraînants et ses danses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est l'interprète de la chanson \"Imagine\" ?",
    options: ["Paul McCartney", "John Lennon", "George Harrison"],
    answer: "John Lennon",
    explanation:
        "\"Imagine\" est une chanson emblématique de John Lennon, promouvant la paix et l'unité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe a popularisé le style punk dans les années 1970 ?",
    options: ["The Clash", "The Beatles", "Queen"],
    answer: "The Clash",
    explanation:
        "The Clash est considéré comme l'un des groupes majeurs du mouvement punk rock.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le principal instrument de l'orchestre classique ?",
    options: ["Le violon", "La trompette", "Le piano"],
    answer: "Le violon",
    explanation:
        "Le violon est généralement considéré comme l'instrument central d'un orchestre classique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle célèbre chanteuse a interprété \"Like a Prayer\" ?",
    options: ["Madonna", "Beyoncé", "Lady Gaga"],
    answer: "Madonna",
    explanation:
        "\"Like a Prayer\" est une chanson emblématique de Madonna, sortie en 1989.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument à cordes est souvent utilisé dans la musique classique ?",
    options: ["Guitare", "Violoncelle", "Ukulélé"],
    answer: "Violoncelle",
    explanation:
        "Le violoncelle est un instrument à cordes très apprécié dans la musique classique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel artiste est célèbre pour le morceau \"Billie Jean\" ?",
    options: ["Elton John", "Michael Jackson", "Prince"],
    answer: "Michael Jackson",
    explanation:
        "\"Billie Jean\" est l'une des chansons les plus célèbres de Michael Jackson.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est caractérisé par des paroles engagées et un rythme entraînant ?",
    options: ["Reggae", "Jazz", "Classique"],
    answer: "Reggae",
    explanation:
        "Le reggae est connu pour ses paroles sociale et politique, associé à un rythme distinctif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel musicien est connu pour son utilisation innovante du piano dans le jazz ?",
    options: ["Thelonious Monk", "Oscar Peterson", "Bill Evans"],
    answer: "Thelonious Monk",
    explanation:
        "Thelonious Monk est connu pour son style unique et ses compositions novatrices au piano.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle chanson de Queen est devenue un hymne sportif ?",
    options: ["We Will Rock You", "Don't Stop Me Now", "Bohemian Rhapsody"],
    answer: "We Will Rock You",
    explanation:
        "\"We Will Rock You\" est souvent joué lors d'événements sportifs pour motiver le public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur autrichien est surnommé le `Roi de la Valse` ?",
    options: ["Johann Strauss II", "Franz Schubert", "Anton Bruckner"],
    answer: "Johann Strauss II",
    explanation:
        "Johann Strauss II est célèbre pour ses valses, notamment \"Le beau Danube bleu\".",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit la célèbre chanson \"Yesterday\" ?",
    options: ["John Lennon", "Paul McCartney", "George Harrison"],
    answer: "Paul McCartney",
    explanation:
        "\"Yesterday\" est une chanson écrite par Paul McCartney, sortie en 1965.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le surnom de l'opéra de Verdi \"La Traviata\" ?",
    options: ["La Dame aux Camélias", "Aida", "Rigoletto"],
    answer: "La Dame aux Camélias",
    explanation:
        "\"La Traviata\" est inspirée du roman \"La Dame aux Camélias\" d'Alexandre Dumas.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel pays est le berceau de la musique flamenco ?",
    options: ["Espagne", "France", "Italie"],
    answer: "Espagne",
    explanation:
        "Le flamenco est une forme de musique et de danse originaire de la région de l'Andalousie en Espagne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est considéré comme le père du blues ?",
    options: ["Robert Johnson", "B.B. King", "Muddy Waters"],
    answer: "Robert Johnson",
    explanation:
        "Robert Johnson est souvent appelé le père du blues, influençant de nombreux artistes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel genre musical combine rap et musique électronique ?",
    options: ["Hip-hop", "House", "Trap"],
    answer: "Trap",
    explanation:
        "Le trap est un sous-genre du hip-hop qui utilise des rythmes électroniques et des basses profondes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a chanté la chanson \"Rolling in the Deep\" ?",
    options: ["Adele", "Beyoncé", "Taylor Swift"],
    answer: "Adele",
    explanation:
        "\"Rolling in the Deep\" est une chanson emblématique d'Adele, sortie en 2010.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Dans quel pays le groupe ABBA a-t-il été formé ?",
    options: ["Suède", "Norvège", "Finlande"],
    answer: "Suède",
    explanation:
        "ABBA est un groupe suédois célèbre pour ses succès dans les années 70 et 80.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur est connu pour sa chanson \"Purple Rain\" ?",
    options: ["Prince", "David Bowie", "George Michael"],
    answer: "Prince",
    explanation:
        "\"Purple Rain\" est une chanson emblématique de Prince, sortie en 1984.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel type de danse est associé à la musique classique russe ?",
    options: ["Polka", "Valse", "Tango"],
    answer: "Valse",
    explanation:
        "La valse est une danse souvent associée à la musique classique russe et à des compositeurs comme Tchaïkovski.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle est la nationalité de l'artiste Fela Kuti, pionnier de l'Afrobeat ?",
    options: ["Nigérienne", "Ghanéenne", "Nigériane"],
    answer: "Nigériane",
    explanation:
        "Fela Kuti est un musicien nigérian connu pour avoir créé le genre musical Afrobeat.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement musical est caractérisé par l'expérimentation et l'improvisation ?",
    options: ["Jazz", "Pop", "Classique"],
    answer: "Jazz",
    explanation:
        "Le jazz se distingue par son improvisation et son fusionnement de différents styles musicaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du festival de musique qui se tient chaque année à Coachella ?",
    options: [
      "Glastonbury",
      "Montreux Jazz Festival",
      "Coachella Valley Music and Arts Festival",
    ],
    answer: "Coachella Valley Music and Arts Festival",
    explanation:
        "Le Coachella Valley Music and Arts Festival est un événement majeur de la musique contemporaine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre leader de la musique pop a remporté 15 Grammy Awards au cours de sa carrière ?",
    options: ["Taylor Swift", "Adele", "Usher"],
    answer: "Adele",
    explanation:
        "Adele est une artiste mondiale qui a remporté de nombreux Grammy Awards pour ses contributions à la musique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour ses valses, notamment \"Le Beau Danube Bleu\" ?",
    options: ["Johann Strauss II", "Johannes Brahms", "Franz Schubert"],
    answer: "Johann Strauss II",
    explanation:
        "Johann Strauss II est réputé pour ses célèbres valses qui restent des incontournables.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe est connu pour des chansons comme \"Stairway to Heaven\" ?",
    options: ["Led Zeppelin", "The Who", "Pink Floyd"],
    answer: "Led Zeppelin",
    explanation:
        "\"Stairway to Heaven\" est un titre emblématique du groupe Led Zeppelin.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanteuse a été révélée par l'émission \"The Voice\" en France et a connu un immense succès ?",
    options: ["Amir", "Louane", "Slimane"],
    answer: "Louane",
    explanation:
        "Louane a gagné en notoriété grâce à sa participation à \"The Voice\" et a ensuite connu un grand succès.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit la célèbre chanson \"Hallelujah\" ?",
    options: ["Leonard Cohen", "Bob Dylan", "Paul Simon"],
    answer: "Leonard Cohen",
    explanation:
        "Leonard Cohen a écrit la chanson \"Hallelujah\", devenue un classique interprété par de nombreux artistes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle période de la musique classique se caractérise par son utilisation de la forme sonate ?",
    options: ["Baroque", "Classique", "Romantique"],
    answer: "Classique",
    explanation:
        "La période classique est reconnue pour son développement de la forme sonate et sa clarté musicale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style musical est souvent associé à la contre-culture des années 1960 ?",
    options: ["Rock psychédélique", "Pop", "Classique"],
    answer: "Rock psychédélique",
    explanation:
        "Le rock psychédélique est un genre de musique associé à la contre-culture des années 1960.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur est souvent surnommé le \"Roi du Pop\" ?",
    options: ["Michael Jackson", "Elton John", "Prince"],
    answer: "Michael Jackson",
    explanation:
        "Michael Jackson est connu pour sa contribution significative à la musique pop et sa renommée mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe a été formé à Liverpool en 1960 ?",
    options: ["The Beatles", "The Rolling Stones", "The Who"],
    answer: "The Beatles",
    explanation:
        "The Beatles, formé à Liverpool, est l'un des groupes les plus influents de l'histoire de la musique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le nom du célèbre guitariste des Rolling Stones ?",
    options: ["Mick Jagger", "Keith Richards", "Ronnie Wood"],
    answer: "Keith Richards",
    explanation:
        "Keith Richards est le guitariste emblématique des Rolling Stones, connu pour son style distinctif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est souvent utilisé dans la musique celtique ?",
    options: ["Cornemuse", "Piano", "Synthétiseur"],
    answer: "Cornemuse",
    explanation:
        "La cornemuse est un instrument traditionnel associé à la musique celtique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur a créé la musique de \"La Flûte enchantée\" ?",
    options: ["Wolfgang Amadeus Mozart", "Richard Wagner", "Giuseppe Verdi"],
    answer: "Wolfgang Amadeus Mozart",
    explanation:
        "Mozart est l'auteur de l'opéra \"La Flûte enchantée\", considéré comme un chef-d'œuvre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est l'instrument de percussion traditionnel des Indiens d'Amérique ?",
    options: ["Batterie", "Cajón", "Tambour"],
    answer: "Tambour",
    explanation:
        "Le tambour joue un rôle central dans la musique traditionnelle des Indiens d'Amérique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur est célèbre pour sa chanson \"Shape of You\" ?",
    options: ["Ed Sheeran", "Justin Bieber", "Sam Smith"],
    answer: "Ed Sheeran",
    explanation:
        "\"Shape of You\" est l'un des plus grands succès d'Ed Sheeran.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est inspiré par la musique des années 1980, avec des synthétiseurs ?",
    options: ["Synthwave", "Soul", "Disco"],
    answer: "Synthwave",
    explanation:
        "Le synthwave est un genre qui évoque la musique des années 1980, utilisant des synthétiseurs modernes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanteuse est connue pour sa voix de soprano et a interprété \"The Power of Love\" ?",
    options: ["Céline Dion", "Whitney Houston", "Barbra Streisand"],
    answer: "Céline Dion",
    explanation:
        "Céline Dion est célèbre pour sa voix puissante, notamment dans \"The Power of Love\".",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel musicien est connu pour le morceau \"Fur Elise\" ?",
    options: ["Ludwig van Beethoven", "Frédéric Chopin", "Johannes Brahms"],
    answer: "Ludwig van Beethoven",
    explanation:
        "\"Für Elise\" est une composition célèbre de Ludwig van Beethoven.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre compositeur autrichien est connu pour ses symphonies et son opéra 'Don Giovanni'?",
    options: [
      "Ludwig van Beethoven",
      "Wolfgang Amadeus Mozart",
      "Johann Sebastian Bach",
    ],
    answer: "Wolfgang Amadeus Mozart",
    explanation:
        "Mozart est reconnu comme l'un des plus grands compositeurs de l'histoire de la musique classique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument à cordes est souvent joué avec un archet dans un orchestre?",
    options: ["Piano", "Guitare", "Violoncelle"],
    answer: "Violoncelle",
    explanation:
        "Le violoncelle est un instrument à cordes qui se joue avec un archet et se trouve dans la section des cordes d'un orchestre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Dans quelle année est décédé le célèbre chanteur Elvis Presley?",
    options: ["1977", "1980", "1969"],
    answer: "1977",
    explanation: "Elvis Presley, le 'Roi du Rock', est mort le 16 août 1977.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est associé aux artistes comme N.W.A et Tupac?",
    options: ["Country", "Rap", "Jazz"],
    answer: "Rap",
    explanation:
        "N.W.A et Tupac sont des figures emblématiques du genre rap, qui a émergé dans les années 1980.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de la célèbre festival de musique qui se tient chaque année à Woodstock?",
    options: ["Burning Man", "Coachella", "Woodstock Music Festival"],
    answer: "Woodstock Music Festival",
    explanation:
        "Le Woodstock Music Festival est un événement emblématique de la contre-culture des années 1960 et 1970.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé l'opéra 'Carmen'?",
    options: ["Giacomo Puccini", "Georges Bizet", "Richard Wagner"],
    answer: "Georges Bizet",
    explanation:
        "Georges Bizet est l'auteur de l'opéra 'Carmen', créé en 1875.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel musicien est célèbre pour son livre 'Le Art of Piano'?",
    options: ["Frédéric Chopin", "Bill Evans", "Bach"],
    answer: "Bill Evans",
    explanation:
        "Bill Evans est connu pour ses innovations et son influence dans le domaine du jazz au piano.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur a popularisé la chanson 'Like a Rolling Stone'?",
    options: ["Bob Dylan", "Bruce Springsteen", "John Lennon"],
    answer: "Bob Dylan",
    explanation:
        "Bob Dylan a sorti 'Like a Rolling Stone' en 1965, une chanson emblématique du rock.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est au centre du jazz traditionnel?",
    options: ["Saxophone", "Trompette", "Piano"],
    answer: "Saxophone",
    explanation:
        "Le saxophone est souvent considéré comme l'un des instruments emblématiques du jazz.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est célèbre pour ses ballets 'Le Sacre du Printemps' et 'L'Oiseau de Feu'?",
    options: ["Igor Stravinsky", "Claude Debussy", "Maurice Ravel"],
    answer: "Igor Stravinsky",
    explanation:
        "Igor Stravinsky a révolutionné la musique avec ses ballets innovants au début du XXe siècle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur est souvent appelé 'La voix' en raison de son impressionnante tessiture?",
    options: ["Whitney Houston", "Mariah Carey", "Adele"],
    answer: "Mariah Carey",
    explanation:
        "Mariah Carey est connue pour sa vaste tessiture vocale, lui permettant de chanter plusieurs octaves.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est l'interprète de la chanson emblématique 'Billie Jean'?",
    options: ["Michael Jackson", "Prince", "Elton John"],
    answer: "Michael Jackson",
    explanation:
        "Michael Jackson a sorti 'Billie Jean' en 1982, un titre qui a marqué l'histoire de la pop.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe britannique a marqué les années 60 avec des chansons comme 'Hey Jude' et 'Let It Be'?",
    options: ["The Rolling Stones", "The Beatles", "The Who"],
    answer: "The Beatles",
    explanation:
        "The Beatles sont l'un des groupes les plus influents de l'histoire de la musique, avec de nombreux succès.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de la musique classique jouée lors des mariages traditionnels?",
    options: [
      "Mélodie de Beethoven",
      "Mélodie de Wagner",
      "Mélodie de Mendelssohn",
    ],
    answer: "Mélodie de Mendelssohn",
    explanation:
        "La 'Marche nuptiale' de Mendelssohn est couramment jouée lors des cérémonies de mariage.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical a émergé dans les années 1950 et est souvent associé à Chuck Berry?",
    options: ["Blues", "Rock and Roll", "Soul"],
    answer: "Rock and Roll",
    explanation:
        "Chuck Berry est l'un des pionniers du rock and roll, influençant des générations d'artistes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre album des Pink Floyd est centré autour d'un thème de santé mentale?",
    options: ["The Dark Side of the Moon", "The Wall", "Animals"],
    answer: "The Wall",
    explanation:
        "L'album 'The Wall' aborde des thèmes de l'isolement et de la santé mentale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel musicien est reconnu pour son influence sur le blues et le rock?",
    options: ["Robert Johnson", "Chuck Berry", "Buddy Holly"],
    answer: "Robert Johnson",
    explanation:
        "Robert Johnson est souvent considéré comme le 'père du blues' grâce à son style unique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur français est célèbre pour ses préludes et ses nocturnes?",
    options: ["Claude Debussy", "Gabriel Fauré", "Maurice Ravel"],
    answer: "Claude Debussy",
    explanation:
        "Claude Debussy est surtout connu pour son œuvre impressionniste en musique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe a été formé par Robert Plant et Jimmy Page?",
    options: ["The Doors", "Led Zeppelin", "AC/DC"],
    answer: "Led Zeppelin",
    explanation:
        "Led Zeppelin est un groupe légendaire du rock, connu pour ses performances énergétiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement musical est associé à des artistes comme Nirvana et Pearl Jam?",
    options: ["Grunge", "Punk", "Metal"],
    answer: "Grunge",
    explanation:
        "Le grunge est un genre musical qui a émergé dans les années 1990, principalement à Seattle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du festival de musique qui a eu lieu à Monterey en 1967?",
    options: ["Woodstock", "Monterey Pop Festival", "Glastonbury"],
    answer: "Monterey Pop Festival",
    explanation:
        "Le Monterey Pop Festival est considéré comme l'un des premiers grands festivals de musique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel musicien est célèbre pour son rôle dans le développement de l'hip-hop?",
    options: ["Kendrick Lamar", "Grandmaster Flash", "Dr. Dre"],
    answer: "Grandmaster Flash",
    explanation:
        "Grandmaster Flash est reconnu pour ses innovations dans le DJing et le rap.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument à vent est souvent utilisé dans les orchestres symphoniques?",
    options: ["Piano", "Flûte", "Guitare"],
    answer: "Flûte",
    explanation:
        "La flûte est un instrument à vent courant dans les formations orchestrales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre album des Beatles a été enregistré en dernier?",
    options: [
      "Sgt. Pepper's Lonely Hearts Club Band",
      "Abbey Road",
      "The White Album",
    ],
    answer: "Abbey Road",
    explanation:
        "'Abbey Road' est l'ultime album studio des Beatles, sorti en 1969.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel artiste est souvent appelé 'The Boss'?",
    options: ["Bruce Springsteen", "Billy Joel", "Bob Dylan"],
    answer: "Bruce Springsteen",
    explanation:
        "Bruce Springsteen a acquis le surnom de 'The Boss' pour son charisme sur scène.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur est connu pour avoir interprété le titre 'Imagine'?",
    options: ["John Lennon", "Paul McCartney", "George Harrison"],
    answer: "John Lennon",
    explanation:
        "'Imagine' est une chanson emblématique écrite et interprétée par John Lennon.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel festival de musique est réputé pour ses performances en plein air en Angleterre?",
    options: ["Glastonbury", "Rock Werchter", "Lollapalooza"],
    answer: "Glastonbury",
    explanation:
        "Le festival de Glastonbury est l'un des plus célèbres festivals de musique en plein air.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style de musique est caractérisé par des rythmes rapides et des paroles contestataires?",
    options: ["Reggae", "Punk", "Soul"],
    answer: "Punk",
    explanation:
        "Le punk est un mouvement musical qui a émergé dans les années 1970, souvent associé à des thèmes de rébellion.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a été le premier rappeur à remporter un Grammy Award?",
    options: ["DJ Jazzy Jeff", "Kurtis Blow", "Will Smith"],
    answer: "DJ Jazzy Jeff",
    explanation:
        "DJ Jazzy Jeff a remporté le premier Grammy Award pour un enregistrement de rap en 1989.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur a popularisé la chanson 'I Will Always Love You'?",
    options: ["Whitney Houston", "Celine Dion", "Tina Turner"],
    answer: "Whitney Houston",
    explanation:
        "Whitney Houston a rendu 'I Will Always Love You' célèbre avec sa performance dans le film 'The Bodyguard'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur est connu pour ses concertos pour piano?",
    options: ["Frédéric Chopin", "Johannes Brahms", "Antonín Dvořák"],
    answer: "Frédéric Chopin",
    explanation:
        "Chopin a composé de nombreux concertos pour piano, particulièrement appréciés dans la musique classique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur a été le premier à recevoir un prix Grammy à titre posthume?",
    options: ["Jimi Hendrix", "John Lennon", "Sam Cooke"],
    answer: "Jimi Hendrix",
    explanation:
        "Jimi Hendrix a été le premier artiste à recevoir un Grammy Award posthume en 1970.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre de musique est associé au célèbre chanteur Bob Marley?",
    options: ["Salsa", "Reggae", "Pop"],
    answer: "Reggae",
    explanation:
        "Bob Marley est souvent considéré comme le roi du reggae et a propulsé le genre sur la scène internationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanteuse est connue pour avoir interprété 'Hips Don't Lie'?",
    options: ["Shakira", "Jennifer Lopez", "Rihanna"],
    answer: "Shakira",
    explanation:
        "Shakira a connu un grand succès avec 'Hips Don't Lie', une chanson influencée par la musique latine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le nom de l'album le plus vendu de tous les temps?",
    options: ["Back in Black", "Thriller", "The Dark Side of the Moon"],
    answer: "Thriller",
    explanation:
        "'Thriller' de Michael Jackson est l'album le plus vendu de l'histoire de la musique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé la célèbre oeuvre 'Boléro'?",
    options: ["Maurice Ravel", "Claude Debussy", "Gabriel Fauré"],
    answer: "Maurice Ravel",
    explanation:
        "Le 'Boléro' de Maurice Ravel est une pièce orchestralement célèbre pour son crescendo.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe a sorti l'album 'Dark Side of the Moon'?",
    options: ["The Rolling Stones", "Led Zeppelin", "Pink Floyd"],
    answer: "Pink Floyd",
    explanation:
        "'The Dark Side of the Moon' est l'un des albums les plus célèbres de Pink Floyd.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanteuse a remporté le plus de Grammy Awards dans l'histoire?",
    options: ["Beyoncé", "Taylor Swift", "Adele"],
    answer: "Beyoncé",
    explanation:
        "Beyoncé détient le record du plus grand nombre de Grammy Awards remportés par une artiste.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est associé au mouvement hippie des années 1960?",
    options: ["Folk", "Rock", "Jazz"],
    answer: "Rock",
    explanation:
        "Le rock était le genre dominant associé à la culture hippie et aux mouvements de contre-culture.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre orchestre est basé à Vienne, connu pour ses valses?",
    options: [
      "Berliner Philharmoniker",
      "Vienne Philharmonique",
      "London Symphony Orchestra",
    ],
    answer: "Vienne Philharmonique",
    explanation:
        "L'Orchestre philharmonique de Vienne est réputé pour ses valses et sa tradition musicale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du genre musical né dans les ghettos de Chicago dans les années 1980?",
    options: ["House", "Techno", "Disco"],
    answer: "House",
    explanation:
        "La musique house a émergé à Chicago et a influencé de nombreux genres modernes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de l'album emblématique de Fleetwood Mac sorti en 1977?",
    options: ["Rumours", "Tusk", "Mirage"],
    answer: "Rumours",
    explanation:
        "'Rumours' est un album emblématique de Fleetwood Mac, connu pour ses harmonies vocales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel artiste est célèbre pour son album 'Born to Run'?",
    options: ["Bruce Springsteen", "Elton John", "David Bowie"],
    answer: "Bruce Springsteen",
    explanation:
        "'Born to Run' est un album marquant de Bruce Springsteen, sorti en 1975.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé la musique du film 'Star Wars'?",
    options: ["Hans Zimmer", "John Williams", "Ennio Morricone"],
    answer: "John Williams",
    explanation:
        "John Williams a composé la célèbre musique de la saga 'Star Wars'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur a écrit 'La Flûte enchantée'?",
    options: ["Wolfgang Amadeus Mozart", "Gioachino Rossini", "Giuseppe Verdi"],
    answer: "Wolfgang Amadeus Mozart",
    explanation: "'La Flûte enchantée' est un opéra de Mozart, créé en 1791.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de la technique vocal utilisée par des artistes comme Whitney Houston?",
    options: ["Belting", "Yodeling", "Falas"],
    answer: "Belting",
    explanation:
        "Le 'belting' est une technique vocale permettant de chanter fort dans les registres supérieurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du célèbre opéra italien 'La Bohème' de Puccini?",
    options: ["Aida", "Carmen", "La Bohème"],
    answer: "La Bohème",
    explanation:
        "'La Bohème' est un opéra de Giacomo Puccini, connu pour son émotion et sa mélodie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit le célèbre opéra 'Aida'?",
    options: ["Giuseppe Verdi", "Giacomo Puccini", "Richard Wagner"],
    answer: "Giuseppe Verdi",
    explanation:
        "Giuseppe Verdi est l'auteur de l'opéra 'Aida', qui a été créé en 1871.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est souvent associé aux fêtes des années 1980?",
    options: ["Synthpop", "Disco", "Rock"],
    answer: "Synthpop",
    explanation:
        "Le synthpop a trouvé sa popularité dans les années 1980 avec des groupes utilisant des synthétiseurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre musicien a popularisé l'utilisation de la guitare électrique dans le rock?",
    options: ["Chuck Berry", "Jimi Hendrix", "Eric Clapton"],
    answer: "Jimi Hendrix",
    explanation:
        "Jimi Hendrix a révolutionné l'utilisation de la guitare électrique dans le rock.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour ses symphonies, notamment la Symphonie n° 5 ?",
    options: [
      "Ludwig van Beethoven",
      "Johann Sebastian Bach",
      "Wolfgang Amadeus Mozart",
    ],
    answer: "Ludwig van Beethoven",
    explanation:
        "Beethoven est célèbre pour sa Symphonie n° 5, qui est un symbole de la musique classique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument est considéré comme l'instrument roi dans une orchestre symphonique ?",
    options: ["Le violon", "La trompette", "Le piano"],
    answer: "Le violon",
    explanation:
        "Le violon est souvent considéré comme l'instrument principal des cordes dans un orchestre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel style musical est associé à la Nouvelle-Orléans ?",
    options: ["Le jazz", "Le rock", "La pop"],
    answer: "Le jazz",
    explanation:
        "Le jazz est né à la Nouvelle-Orléans, influencé par des traditions africaines et européennes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe britannique a chanté 'Hey Jude' ?",
    options: ["The Rolling Stones", "The Beatles", "Led Zeppelin"],
    answer: "The Beatles",
    explanation:
        "'Hey Jude' est une chanson emblématique des Beatles, sortie en 1968.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Qui est célèbre pour ses talents de guitariste et pour le titre 'Purple Haze' ?",
    options: ["Eric Clapton", "Jimi Hendrix", "Jimmy Page"],
    answer: "Jimi Hendrix",
    explanation:
        "Jimi Hendrix est reconnu comme l'un des plus grands guitaristes de tous les temps, notamment avec 'Purple Haze'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement musical est associé à l'art de la performance vivante et de la composition expérimentale dans les années 1960 ?",
    options: ["Le rock progressif", "Le punk", "La musique minimaliste"],
    answer: "La musique minimaliste",
    explanation:
        "La musique minimaliste a émergé dans les années 1960 avec des compositeurs comme Steve Reich et Philip Glass.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est caractérisé par des textes engagés et des rythmes syncopés, souvent en relation avec des luttes sociales ?",
    options: ["Le reggae", "Le blues", "Le hip-hop"],
    answer: "Le hip-hop",
    explanation:
        "Le hip-hop est souvent associé à des messages politiques et sociaux dans ses paroles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Qui est l'interprète de la célèbre chanson 'I Will Always Love You' ?",
    options: ["Celine Dion", "Whitney Houston", "Mariah Carey"],
    answer: "Whitney Houston",
    explanation:
        "Whitney Houston a popularisé cette chanson, originairement écrite par Dolly Parton.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est célèbre pour sa musique de film, notamment pour 'Star Wars' ?",
    options: ["Hans Zimmer", "John Williams", "Ennio Morricone"],
    answer: "John Williams",
    explanation:
        "John Williams est connu pour ses compositions de musique de film, dont celles de 'Star Wars'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est l'instrument de musique traditionnel associé aux cultures andines ?",
    options: ["La flûte de Pan", "Le violon", "Le tambour"],
    answer: "La flûte de Pan",
    explanation:
        "La flûte de Pan est un instrument emblématique des musiques andines d'Amérique du Sud.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre musicien est souvent appelé 'le roi de la pop' ?",
    options: ["Elvis Presley", "Michael Jackson", "Prince"],
    answer: "Michael Jackson",
    explanation:
        "Michael Jackson est couramment désigné comme 'le roi de la pop' pour son immense influence musicale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le style musical né à Kingston, en Jamaïque, à la fin des années 1960 ?",
    options: ["Le ska", "Le reggae", "Le dancehall"],
    answer: "Le reggae",
    explanation:
        "Le reggae est un style musical aux rythmes caractéristiques, né à Kingston.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit 'Le Lac des cygnes' ?",
    options: ["Pyotr Ilyich Tchaikovsky", "Igor Stravinsky", "Claude Debussy"],
    answer: "Pyotr Ilyich Tchaikovsky",
    explanation:
        "Tchaïkovski est l'auteur du ballet 'Le Lac des cygnes', connu pour sa musique romantique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe est connu pour ses albums tels que 'Dark Side of the Moon' ?",
    options: ["The Rolling Stones", "Led Zeppelin", "Pink Floyd"],
    answer: "Pink Floyd",
    explanation:
        "Pink Floyd a marqué l'histoire de la musique avec des albums conceptuels comme 'Dark Side of the Moon'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Dans quel pays est né le flamenco ?",
    options: ["Espagne", "France", "Italie"],
    answer: "Espagne",
    explanation:
        "Le flamenco est une forme de musique et de danse originaire d'Andalousie, en Espagne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur est célèbre pour ses 'Quatuors à cordes' ?",
    options: [
      "Franz Schubert",
      "Ludwig van Beethoven",
      "Wolfgang Amadeus Mozart",
    ],
    answer: "Ludwig van Beethoven",
    explanation:
        "Beethoven a composé plusieurs quatuors à cordes, considérés comme des chefs-d'œuvre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur a popularisé le titre 'Your Song' ?",
    options: ["Elton John", "Billy Joel", "David Bowie"],
    answer: "Elton John",
    explanation:
        "Elton John a sorti 'Your Song' en 1970, qui est devenu un grand succès.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement artistique a influencé le développement du jazz ?",
    options: ["Le cubisme", "Le romantisme", "Le surréalisme"],
    answer: "Le cubisme",
    explanation:
        "Le cubisme a influencé des artistes de jazz dans leur approche créative et improvisée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel fameux festival de musique a lieu chaque année à Woodstock ?",
    options: ["Woodstock Festival", "Coachella", "Glastonbury"],
    answer: "Woodstock Festival",
    explanation:
        "Le Woodstock Festival, qui a eu lieu en 1969, est devenu emblématique du mouvement hippie et de la musique rock.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanteuse est connue pour sa voix puissante et sa chanson 'Think' ?",
    options: ["Aretha Franklin", "Diana Ross", "Tina Turner"],
    answer: "Aretha Franklin",
    explanation:
        "Aretha Franklin est souvent appelée 'la reine de la soul' et est célèbre pour des titres tels que 'Think'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre de musique est caractérisé par des rythmes rapides et des paroles souvent politiques ?",
    options: ["Le punk", "Le jazz", "La musique classique"],
    answer: "Le punk",
    explanation:
        "Le punk est un genre musical connu pour son attitude rebelle et ses paroles engagées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est l'artiste derrière le succès 'Rolling in the Deep' ?",
    options: ["Adele", "Beyoncé", "Taylor Swift"],
    answer: "Adele",
    explanation:
        "Adele a connu un succès mondial avec sa chanson 'Rolling in the Deep'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du mouvement musical qui a émergé dans les années 1980, caractérisé par l'utilisation d'instruments électroniques ?",
    options: ["La new wave", "Le rock alternatif", "Le grunge"],
    answer: "La new wave",
    explanation:
        "La new wave incorpore des éléments de musique pop et de synthétiseurs, populaire dans les années 1980.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre chef d'orchestre a dirigé l'Orchestre philharmonique de Berlin ?",
    options: ["Herbert von Karajan", "Leonard Bernstein", "Daniel Barenboim"],
    answer: "Herbert von Karajan",
    explanation:
        "Karajan a été un chef d'orchestre influent, connu pour son travail avec l'Orchestre philharmonique de Berlin.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement artistique a marqué la musique française dans les années 1920 ?",
    options: ["Le surréalisme", "Le dadaïsme", "Le mouvement impressionniste"],
    answer: "Le mouvement impressionniste",
    explanation:
        "Le mouvement impressionniste a influencé des compositeurs comme Debussy, qui ont exploré de nouvelles sonorités.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur est connu pour son hymne 'Born to Run' ?",
    options: ["Bruce Springsteen", "Bob Dylan", "Neil Young"],
    answer: "Bruce Springsteen",
    explanation:
        "Bruce Springsteen a sorti 'Born to Run' en 1975, symbolisant l'esprit américain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur est souvent associé à la musique baroque ?",
    options: [
      "Johann Sebastian Bach",
      "Wolfgang Amadeus Mozart",
      "Frédéric Chopin",
    ],
    answer: "Johann Sebastian Bach",
    explanation:
        "Bach est l'un des compositeurs les plus emblématiques de la période baroque, connu pour ses œuvres complexes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Qui a popularisé le style musical 'disco' dans les années 1970 ?",
    options: ["Donna Summer", "Madonna", "Cher"],
    answer: "Donna Summer",
    explanation:
        "Donna Summer était une icône du disco, avec des hits à succès dans les années 70.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe de rock a sorti l'album 'Hotel California' ?",
    options: ["The Eagles", "Fleetwood Mac", "The Who"],
    answer: "The Eagles",
    explanation:
        "'Hotel California' est l'un des albums les plus célèbres des Eagles, sorti en 1976.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical fusionne des éléments de funk, jazz et soul, souvent associé à des grooves complexes ?",
    options: ["Le hip-hop", "La musique funk", "Le rock"],
    answer: "La musique funk",
    explanation:
        "La musique funk est caractérisée par ses rythmes syncopés et son accent sur la basse et les cuivres.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est associé aux motifs répétitifs et à l'utilisation de boucles ?",
    options: ["Le hip-hop", "La musique électronique", "Le classique"],
    answer: "La musique électronique",
    explanation:
        "La musique électronique utilise souvent des motifs répétitifs et des techniques comme le sampling.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit l'opéra 'La Bohème' ?",
    options: ["Giacomo Puccini", "Gaetano Donizetti", "Giuseppe Verdi"],
    answer: "Giacomo Puccini",
    explanation:
        "'La Bohème' est un opéra célèbre de Puccini, représentant des thèmes de l'amour et de la souffrance.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste a remporté le plus grand nombre de Grammy Awards dans l'histoire ?",
    options: ["Beyoncé", "Stevie Wonder", "Taylor Swift"],
    answer: "Beyoncé",
    explanation:
        "Beyoncé détient le record du plus grand nombre de Grammy Awards remportés par une seule artiste.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel musicien est connu pour avoir popularisé l'utilisation de la guitare électrique dans le rock ?",
    options: ["Chuck Berry", "Elvis Presley", "Johnny Cash"],
    answer: "Chuck Berry",
    explanation:
        "Chuck Berry est souvent considéré comme l'un des pionniers de l'utilisation de la guitare électrique dans le rock.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel type de chant est associé aux traditionnels chants de marins ?",
    options: ["Le chant choral", "Le shanty", "Le gospel"],
    answer: "Le shanty",
    explanation:
        "Le shanty est un chant traditionnel utilisé par les marins pour rythmer leurs travaux en mer.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur français est connu pour ses ballets, notamment 'Daphnis et Chloé' ?",
    options: ["Gabriel Fauré", "Maurice Ravel", "Claude Debussy"],
    answer: "Maurice Ravel",
    explanation:
        "Ravel est célèbre pour son ballet 'Daphnis et Chloé', qui met en avant son style impressionniste.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Qui a écrit la fameuse chanson anti-guerre 'Give Peace a Chance' ?",
    options: ["John Lennon", "Bob Dylan", "Paul Simon"],
    answer: "John Lennon",
    explanation:
        "'Give Peace a Chance' est une chanson emblématique de John Lennon, prônant la paix.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre festival de musique a eu lieu en 1969 à New York ?",
    options: ["Glastonbury", "Woodstock", "Monterey Pop Festival"],
    answer: "Woodstock",
    explanation:
        "Le festival de Woodstock en 1969 est devenu un symbole de la culture musicale des années 60.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour avoir écrit 'Les Quatre Saisons' ?",
    options: ["Antonio Vivaldi", "Johann Sebastian Bach", "Frédéric Chopin"],
    answer: "Antonio Vivaldi",
    explanation:
        "'Les Quatre Saisons' est une œuvre célèbre écrite par Vivaldi au XVIIIe siècle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style musical est né dans les années 1990 et est souvent associé à la musique électronique et à des rythmes dansants ?",
    options: ["La house", "Le grunge", "Le rap"],
    answer: "La house",
    explanation:
        "La house est un genre musical qui a émergé dans les années 1980 et a prospéré dans les années 1990.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur russe est connu pour son œuvre 'Le Casse-Noisette' ?",
    options: [
      "Igor Stravinsky",
      "Piotr Ilitch Tchaïkovski",
      "Sergei Rachmaninoff",
    ],
    answer: "Piotr Ilitch Tchaïkovski",
    explanation:
        "'Le Casse-Noisette' est un ballet célèbre de Tchaïkovski, souvent joué pendant les fêtes de fin d'année.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste est connu pour ses performances théâtrales et son personnage de Ziggy Stardust ?",
    options: ["David Bowie", "Prince", "Freddie Mercury"],
    answer: "David Bowie",
    explanation:
        "David Bowie a créé le personnage de Ziggy Stardust, symbolisant l'expérimentation musicale des années 1970.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style musical a émergé dans le Bronx dans les années 1970 ?",
    options: ["Le disco", "Le reggae", "Le hip-hop"],
    answer: "Le hip-hop",
    explanation:
        "Le hip-hop a émergé dans le Bronx comme un mouvement culturel et musical influent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste est célèbre pour la chanson 'Like a Rolling Stone' ?",
    options: ["Elvis Presley", "Bob Dylan", "Johnny Cash"],
    answer: "Bob Dylan",
    explanation:
        "'Like a Rolling Stone' est une œuvre emblématique de Bob Dylan, sortie en 1965.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel festival de musique, célèbre pour son ambiance, a lieu chaque été à Nice, en France ?",
    options: [
      "Le Printemps de Bourges",
      "Le Festival de Nice",
      "Les Nuits du Jazz",
    ],
    answer: "Le Festival de Nice",
    explanation:
        "Le Festival de Nice est un événement musical majeur célébrant divers genres chaque été.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle est la nationalité de la chanteuse Celine Dion ?",
    options: ["Française", "Canadienne", "Belge"],
    answer: "Canadienne",
    explanation:
        "Celine Dion est une chanteuse canadienne originaire de Charlemagne, au Québec.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste a remporté le Grammy Award de l'Album de l'année en 2021 pour 'Folklore' ?",
    options: ["Billie Eilish", "Ariana Grande", "Taylor Swift"],
    answer: "Taylor Swift",
    explanation:
        "Taylor Swift a remporté ce prix pour son album 'Folklore', salué par la critique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le nom du morceau le plus célèbre de Beethoven ?",
    options: ["La Letra à Elise", "Symphonie n° 9", "Sonate au clair de lune"],
    answer: "Symphonie n° 9",
    explanation:
        "La Symphonie n° 9, avec son célèbre 'Ode à la joie', est l'œuvre la plus célèbre de Beethoven.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste a popularisé le style musical du punk rock dans les années 1970 ?",
    options: ["Sex Pistols", "The Clash", "Green Day"],
    answer: "Sex Pistols",
    explanation:
        "Les Sex Pistols sont souvent considérés comme les pionniers du punk rock avec leur attitude rebelle.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est associé à Mozart dans ses compositions?",
    options: ["Piano", "Guitare", "Flûte"],
    answer: "Piano",
    explanation:
        "Mozart était un virtuose du piano et a composé de nombreuses œuvres pour cet instrument.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre groupe britannique a sorti l'album 'Abbey Road'?",
    options: ["The Rolling Stones", "The Beatles", "Led Zeppelin"],
    answer: "The Beatles",
    explanation:
        "L'album 'Abbey Road' des Beatles est sorti en 1969 et est devenu emblématique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est connu comme le 'Roi de la Pop'?",
    options: ["Michael Jackson", "Elvis Presley", "Prince"],
    answer: "Michael Jackson",
    explanation:
        "Michael Jackson est souvent surnommé le 'Roi de la Pop' pour son immense influence musicale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit la symphonie 'Eroica'?",
    options: ["Beethoven", "Brahms", "Tchaïkovski"],
    answer: "Beethoven",
    explanation:
        "La symphonie 'Eroica' est une œuvre majeure de Ludwig van Beethoven, composée en 1803.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est célèbre pour ses ballets comme 'Le Lac des cygnes'?",
    options: [
      "Igor Stravinsky",
      "Pyotr Ilyich Tchaikovsky",
      "Sergei Prokofiev",
    ],
    answer: "Pyotr Ilyich Tchaikovsky",
    explanation:
        "Tchaikovsky est connu pour ses ballets, dont 'Le Lac des cygnes'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle œuvre est souvent considérée comme l'hymne des droits civiques aux États-Unis?",
    options: ["Imagine", "We Shall Overcome", "What's Going On"],
    answer: "We Shall Overcome",
    explanation:
        "'We Shall Overcome' a été un chant emblématique du mouvement des droits civiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est né dans les années 1920 à la Nouvelle-Orléans?",
    options: ["Jazz", "Rock", "Blues"],
    answer: "Jazz",
    explanation:
        "Le jazz est né à la Nouvelle-Orléans dans les années 1920 et a rapidement gagné en popularité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument est majeur dans la musique classique et souvent joué en orchestre?",
    options: ["Violon", "Saxophone", "Batterie"],
    answer: "Violon",
    explanation:
        "Le violon est un instrument clé dans les orchestres classiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a popularisé la chanson 'Like a Rolling Stone'?",
    options: ["Bob Dylan", "Simon & Garfunkel", "The Who"],
    answer: "Bob Dylan",
    explanation:
        "Bob Dylan a sorti 'Like a Rolling Stone' en 1965, une œuvre marquante du rock.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style musical a émergé dans les années 1960 et combine rock et rhythm & blues?",
    options: ["Reggae", "Funk", "Soul"],
    answer: "Soul",
    explanation:
        "La soul music a émergé dans les années 1960, mélangeant le rock et le rhythm & blues.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement musical Britannique a influencé le rock dans les années 1970?",
    options: ["Punk", "Gothique", "Synthpop"],
    answer: "Punk",
    explanation:
        "Le mouvement punk a radicalement changé le paysage musical dans les années 1970.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Qui a été le premier musicien à avoir gagné le prix Nobel de littérature?",
    options: ["Bob Dylan", "Leonard Cohen", "Toni Morrison"],
    answer: "Bob Dylan",
    explanation:
        "Bob Dylan a reçu le prix Nobel de littérature en 2016 pour son impact sur la culture.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel type de musique utilise souvent les harmonies vocales et les instruments à cordes?",
    options: ["Blues", "Folk", "Techno"],
    answer: "Folk",
    explanation:
        "La musique folk est connue pour ses harmonies vocales et ses arrangements acoustiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé la 'Cinquième symphonie'?",
    options: ["Schubert", "Beethoven", "Bach"],
    answer: "Beethoven",
    explanation:
        "La 'Cinquième symphonie' est l'une des œuvres les plus célèbres de Beethoven.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical a connu une montée en popularité dans les années 1990 avec des artistes comme Nirvana?",
    options: ["Hip-hop", "Grunge", "Pop"],
    answer: "Grunge",
    explanation:
        "Le grunge a émergé dans les années 1990 avec des groupes comme Nirvana.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument est souvent associé au jazz et est joué en soliste?",
    options: ["Saxophone", "Harmonica", "Clarinette"],
    answer: "Saxophone",
    explanation:
        "Le saxophone est un instrument emblématique du jazz, souvent utilisé en soliste.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel musicien est connu pour sa chanson 'Purple Rain'?",
    options: ["Prince", "Beyoncé", "David Bowie"],
    answer: "Prince",
    explanation:
        "La chanson 'Purple Rain' est l'une des œuvres les plus célèbres de Prince.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel type de danse est associé à l'opéra 'Coppélia'?",
    options: ["Danse classique", "Salsa", "Hip-hop"],
    answer: "Danse classique",
    explanation:
        "'Coppélia' est un ballet classique, mettant en avant la danse classique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle chanteuse a popularisé 'I Will Always Love You'?",
    options: ["Céline Dion", "Whitney Houston", "Madonna"],
    answer: "Whitney Houston",
    explanation:
        "Whitney Houston a rendu célèbre la chanson 'I Will Always Love You' dans les années 1990.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Dans quelle ville se trouve la célèbre salle de concert 'Carnegie Hall'?",
    options: ["New York", "Paris", "Londres"],
    answer: "New York",
    explanation:
        "Carnegie Hall est l'une des salles de concert les plus célèbres, située à New York.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur classique a écrit 'Les Quatre Saisons'?",
    options: ["Vivaldi", "Handel", "Bach"],
    answer: "Vivaldi",
    explanation:
        "Antonio Vivaldi a composé l'œuvre 'Les Quatre Saisons', un ensemble de concertos.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style de musique est caractérisé par des beats électroniques et des synthétiseurs?",
    options: ["Classique", "Techno", "Jazz"],
    answer: "Techno",
    explanation:
        "La techno est un genre musical électronique avec des beats et des rythmes synthétiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste est célèbre pour ses performances live énergiques et son album 'The Rise and Fall of Ziggy Stardust'?",
    options: ["Elton John", "David Bowie", "Freddie Mercury"],
    answer: "David Bowie",
    explanation:
        "David Bowie a marqué la musique avec son personnage Ziggy Stardust.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Dans le rock, quelle est la période connue pour des groupes comme The Who et Led Zeppelin?",
    options: ["Années 1960", "Années 1980", "Années 1990"],
    answer: "Années 1960",
    explanation:
        "Les années 1960 ont été marquées par l'essor du rock avec des groupes légendaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical mélange des éléments de blues, de jazz et de gospel?",
    options: ["Rock", "Soul", "Country"],
    answer: "Soul",
    explanation:
        "La musique soul fusionne des influences du blues, du jazz et du gospel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle œuvre de Beethoven est connue pour son célèbre 'Air' du premier mouvement?",
    options: ["Symphonie No. 9", "Symphonie No. 5", "Symphonie No. 6"],
    answer: "Symphonie No. 6",
    explanation:
        "La 'Symphonie No. 6', aussi connue comme la 'Pastorale', commence avec un air paisible.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanteuse française est connue pour sa voix unique et ses chansons comme 'La Vie en rose'?",
    options: ["Edith Piaf", "Françoise Hardy", "Céline Dion"],
    answer: "Edith Piaf",
    explanation:
        "Edith Piaf est célèbre pour sa chanson 'La Vie en rose', un classique de la chanson française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit l'opéra 'La Bohème'?",
    options: ["Puccini", "Verdi", "Bizet"],
    answer: "Puccini",
    explanation:
        "Giacomo Puccini est l'auteur de l'opéra 'La Bohème', créé en 1896.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est souvent associé à des paroles sociales et politiques?",
    options: ["Pop", "Reggae", "Country"],
    answer: "Reggae",
    explanation:
        "Le reggae est connu pour ses paroles ayant souvent des thèmes sociaux et politiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument à cordes est souvent utilisé dans la musique folk?",
    options: ["Violoncelle", "Guitare", "Piano"],
    answer: "Guitare",
    explanation: "La guitare est l'instrument central de la musique folk.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel style musical a vu le jour à Kingston, en Jamaïque?",
    options: ["Reggae", "Rap", "Blues"],
    answer: "Reggae",
    explanation:
        "Le reggae est un genre musical qui a émergé à Kingston, en Jamaïque, dans les années 1960.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé 'Le Boléro'?",
    options: ["Maurice Ravel", "Claude Debussy", "Gabriel Fauré"],
    answer: "Maurice Ravel",
    explanation:
        "Le célèbre 'Boléro' est une œuvre emblématique composée par Maurice Ravel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel artiste a popularisé la chanson 'Shake It Off'?",
    options: ["Taylor Swift", "Katy Perry", "Lady Gaga"],
    answer: "Taylor Swift",
    explanation:
        "Taylor Swift a sorti 'Shake It Off' en 2014, qui a connu un grand succès.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est l'instrument principal des orchestres symphoniques?",
    options: ["Trompette", "Violoncelle", "Flûte"],
    answer: "Violoncelle",
    explanation:
        "Le violoncelle est un instrument essentiel et souvent central dans les orchestres symphoniques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est caractérisé par des riffs de guitare électrique et des solos?",
    options: ["Reggae", "Rock", "Jazz"],
    answer: "Rock",
    explanation:
        "Le rock est célèbre pour ses riffs de guitare électrique et ses solos énergiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du festival de musique qui a eu lieu à Woodstock en 1969?",
    options: ["Woodstock Festival", "Glastonbury Festival", "Coachella"],
    answer: "Woodstock Festival",
    explanation:
        "Le Woodstock Festival de 1969 est devenu un symbole de la contre-culture des années 60.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel musicien est souvent considéré comme le 'Père du Blues'?",
    options: ["B.B. King", "Muddy Waters", "Robert Johnson"],
    answer: "Robert Johnson",
    explanation:
        "Robert Johnson est considéré comme l'un des pionniers du blues au XXe siècle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle chanteuse a interprété 'Toxic'?",
    options: ["Britney Spears", "Christina Aguilera", "Lady Gaga"],
    answer: "Britney Spears",
    explanation:
        "Britney Spears a sorti 'Toxic' en 2004, une chanson à succès de sa carrière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical a influencé le développement du rock et du blues?",
    options: ["Gospel", "Jazz", "Reggae"],
    answer: "Gospel",
    explanation:
        "Le gospel a eu une forte influence sur le développement du rock et du blues.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur a écrit 'L'Eté' dans 'Les Quatre Saisons'?",
    options: ["Vivaldi", "Beethoven", "Mozart"],
    answer: "Vivaldi",
    explanation:
        "Vivaldi a composé 'L'Eté', l'un des concertos de 'Les Quatre Saisons'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe est connu pour le hit 'Bohemian Rhapsody'?",
    options: ["The Rolling Stones", "Queen", "U2"],
    answer: "Queen",
    explanation:
        "Queen a sorti 'Bohemian Rhapsody' en 1975, une chanson emblématique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement musical a émergé dans les années 1980 avec des artistes comme Madonna?",
    options: ["Rock", "Pop", "Folk"],
    answer: "Pop",
    explanation:
        "Les années 1980 ont vu l'essor de la musique pop avec des artistes comme Madonna.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel type de musique est caractérisé par des percussions, des chants et des danses rituelles?",
    options: ["Folk", "Classique", "Traditionnelle"],
    answer: "Traditionnelle",
    explanation:
        "La musique traditionnelle inclut souvent des percussions et des chants rituels.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre guitariste a fondé le groupe The Jimi Hendrix Experience?",
    options: ["Eric Clapton", "Jimi Hendrix", "Jimmy Page"],
    answer: "Jimi Hendrix",
    explanation:
        "Jimi Hendrix est le guitariste emblématique du groupe The Jimi Hendrix Experience.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel genre musical est associé à des danses comme le tango?",
    options: ["Salsa", "Classique", "Latino"],
    answer: "Latino",
    explanation:
        "Le tango est un type de danse latino, souvent accompagné de musique latine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour ses opéras tels que 'Le Barbier de Séville'?",
    options: ["Mozart", "Rossini", "Verdi"],
    answer: "Rossini",
    explanation:
        "Gioachino Rossini est célèbre pour ses opéras, dont 'Le Barbier de Séville'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel album de Pink Floyd est souvent considéré comme un chef-d'œuvre conceptuel?",
    options: ["The Wall", "Dark Side of the Moon", "Wish You Were Here"],
    answer: "Dark Side of the Moon",
    explanation:
        "'The Dark Side of the Moon' est souvent vu comme un chef-d'œuvre de l'album concept.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé la célèbre œuvre 'Le Sacre du Printemps'?",
    options: ["Igor Stravinsky", "Maurice Ravel", "Claude Debussy"],
    answer: "Igor Stravinsky",
    explanation:
        "Igor Stravinsky est l'auteur du ballet 'Le Sacre du Printemps', créé en 1913.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est associé aux années 80 et inclut des synthétiseurs?",
    options: ["Pop", "Rock", "Disco"],
    answer: "Disco",
    explanation:
        "La musique disco des années 80 est caractérisée par des rythmes dansants et des synthétiseurs.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est souvent associé à la musique classique ?",
    options: ["Guitare", "Piano", "Batterie"],
    answer: "Piano",
    explanation:
        "Le piano est un instrument central dans la musique classique, largement utilisé par de nombreux compositeurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé la célèbre symphonie 'Symphonie n°9' ?",
    options: [
      "Ludwig van Beethoven",
      "Wolfgang Amadeus Mozart",
      "Johann Sebastian Bach",
    ],
    answer: "Ludwig van Beethoven",
    explanation:
        "Beethoven a composé la 'Symphonie n°9', qui a été achevée en 1824 et est célèbre pour son chœur final.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical a émergé dans les années 1950 et a été popularisé par des artistes comme Elvis Presley ?",
    options: ["Jazz", "Rock'n'roll", "Blues"],
    answer: "Rock'n'roll",
    explanation:
        "Le rock'n'roll a émergé dans les années 1950, combinant des éléments de musique blues et country.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du festival de musique qui se déroule chaque année à Coachella, en Californie ?",
    options: ["Woodstock", "Lollapalooza", "Coachella Festival"],
    answer: "Coachella Festival",
    explanation:
        "Le Coachella Festival est l'un des plus grands festivals de musique enregistrant une participation massive chaque année.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est connu comme le 'Roi de la Pop' ?",
    options: ["Michael Jackson", "Prince", "Madonna"],
    answer: "Michael Jackson",
    explanation:
        "Michael Jackson est souvent référencé comme le 'Roi de la Pop' en raison de son influence dans le genre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur est célèbre pour ses opéras comme 'Carmen' ?",
    options: ["Giacomo Puccini", "Georges Bizet", "Richard Wagner"],
    answer: "Georges Bizet",
    explanation:
        "Georges Bizet est le compositeur de l'opéra 'Carmen', qui est l'un des plus populaires au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe britannique a sorti l'album emblématique 'The Dark Side of the Moon' ?",
    options: ["The Rolling Stones", "Pink Floyd", "The Beatles"],
    answer: "Pink Floyd",
    explanation:
        "Pink Floyd a sorti 'The Dark Side of the Moon' en 1973, un album qui a marqué l'histoire de la musique rock.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chant est attribué à la culture des chants grégoriens ?",
    options: ["Chant polyphonique", "Chant monodique", "Chant chorale"],
    answer: "Chant monodique",
    explanation:
        "Les chants grégoriens sont caractérisés par leur chant monodique, souvent utilisé dans les liturgies chrétiennes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste est connu pour sa voix puissante et ses performances au sein du groupe Queen ?",
    options: ["Freddie Mercury", "Elton John", "David Bowie"],
    answer: "Freddie Mercury",
    explanation:
        "Freddie Mercury est le chanteur emblématique du groupe Queen, connu pour sa voix unique et ses performances dynamiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle célèbre chanson commence par les paroles 'Imagine there's no heaven' ?",
    options: ["Let It Be", "Imagine", "Hey Jude"],
    answer: "Imagine",
    explanation:
        "'Imagine' est une chanson de John Lennon qui prône la paix et l'unité mondiale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre de musique est associé à des artistes comme Billie Eilish et Lana Del Rey ?",
    options: ["Country", "Pop alternatif", "Rap"],
    answer: "Pop alternatif",
    explanation:
        "Billie Eilish et Lana Del Rey sont souvent classées dans le genre de la pop alternative pour leur style distinctif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit la musique du ballet 'Le Lac des cygnes' ?",
    options: ["Tchaïkovski", "Stravinski", "Brahms"],
    answer: "Tchaïkovski",
    explanation:
        "Tchaïkovski est le compositeur du ballet 'Le Lac des cygnes', qui est l'une de ses œuvres les plus célèbres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel appareil est utilisé pour accorder les instruments de musique ?",
    options: ["Métronome", "Accordeur", "Synthétiseur"],
    answer: "Accordeur",
    explanation:
        "Un accordeur est un dispositif qui aide les musiciens à accorder leurs instruments avec précision.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur est connu pour son tube 'Rolling in the Deep' ?",
    options: ["Beyoncé", "Adele", "Taylor Swift"],
    answer: "Adele",
    explanation:
        "Adele a sorti 'Rolling in the Deep' en 2010, un titre qui a rencontré un immense succès mondial.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style musical est souvent associé au mouvement hippie des années 1960 ?",
    options: ["Blues", "Rock psychédélique", "Reggae"],
    answer: "Rock psychédélique",
    explanation:
        "Le rock psychédélique a connu une grande popularité durant les années 1960, souvent lié à la contre-culture hippie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle est la principale fonction d'un chef d'orchestre ?",
    options: [
      "Composer de la musique",
      "Diriger les musiciens",
      "Écrire des paroles",
    ],
    answer: "Diriger les musiciens",
    explanation:
        "Le chef d'orchestre dirige les musiciens pour interpréter la musique de manière cohérente et harmonieuse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel artiste a popularisé la chanson 'Like a Rolling Stone' ?",
    options: ["Bob Dylan", "Bruce Springsteen", "Elton John"],
    answer: "Bob Dylan",
    explanation:
        "Bob Dylan a écrit et enregistré 'Like a Rolling Stone', une chanson qui a révolutionné la musique contemporaine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel type de musique est souvent interprété par des choeurs ?",
    options: ["Opéra", "Jazz", "Blues"],
    answer: "Opéra",
    explanation:
        "L'opéra est souvent interprété par des choeurs, intégrant des voix et des instruments pour une expérience théâtrale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe a chanté 'Hotel California' ?",
    options: ["The Eagles", "Fleetwood Mac", "Led Zeppelin"],
    answer: "The Eagles",
    explanation:
        "'Hotel California' est une chanson emblématique du groupe The Eagles, sortie en 1976.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement musical prône l'improvisation et l'expression personnelle, souvent associé au jazz ?",
    options: ["Classique", "Blues", "Free jazz"],
    answer: "Free jazz",
    explanation:
        "Le free jazz est un mouvement qui valorise l'improvisation et la liberté d'expression musicale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de l'album emblématique de Nirvana sorti en 1991 ?",
    options: ["Nevermind", "In Utero", "Bleach"],
    answer: "Nevermind",
    explanation:
        "'Nevermind' est l'album qui a propulsé Nirvana sur le devant de la scène musicale, marquant le grunge.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle musique est souvent utilisée dans les mariages comme rituel de danse ?",
    options: ["La valse", "Le tango", "La salsa"],
    answer: "La valse",
    explanation:
        "La valse est souvent choisie pour sa grâce et son élégance lors de danses de mariage.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument à cordes utilise un archet ?",
    options: ["Guitare", "Violoncelle", "Ukulele"],
    answer: "Violoncelle",
    explanation:
        "Le violoncelle est un instrument à cordes qui est joué avec un archet pour produire des sons riches.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Qui a chanté 'I Will Always Love You' dans le film 'The Bodyguard' ?",
    options: ["Celine Dion", "Whitney Houston", "Mariah Carey"],
    answer: "Whitney Houston",
    explanation:
        "Whitney Houston a interprété 'I Will Always Love You' dans 'The Bodyguard', un des plus grands succès de sa carrière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel type de musique est souvent joué lors de funérailles ?",
    options: ["Musique classique", "Jazz", "Pop"],
    answer: "Musique classique",
    explanation:
        "La musique classique est souvent choisie pour les funérailles en raison de sa profondeur émotionnelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste a popularisé le terme 'Britpop' dans les années 1990 ?",
    options: ["Oasis", "Blur", "Radiohead"],
    answer: "Oasis",
    explanation:
        "Oasis est le groupe emblématique du mouvement Britpop, caractérisé par des mélodies accrocheuses et des paroles nostalgiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Que signifie le terme 'acapella' en musique ?",
    options: ["Avec instruments", "Sans instruments", "Avec choeur"],
    answer: "Sans instruments",
    explanation:
        "Le terme 'acapella' désigne une performance vocale effectuée sans accompagnement instrumental.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre de musique est traditionnellement associé aux racines afro-américaines ?",
    options: ["Reggae", "Blues", "Country"],
    answer: "Blues",
    explanation:
        "Le blues est un genre musical qui a émergé des expériences et des luttes des Africains-Américains.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est le créateur du personnage fictif 'Ziggy Stardust' ?",
    options: ["Elton John", "David Bowie", "Prince"],
    answer: "David Bowie",
    explanation:
        "David Bowie a créé le personnage de 'Ziggy Stardust', représentant de l'ère glam rock.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument de percussion est souvent utilisé dans la musique latino-américaine ?",
    options: ["Tambour", "Batterie", "Maracas"],
    answer: "Maracas",
    explanation:
        "Les maracas sont un instrument de percussion populaire dans de nombreux styles de musique latino-américaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel duo célèbre a chanté 'The Sound of Silence' ?",
    options: ["Simon & Garfunkel", "The Everly Brothers", "The Beach Boys"],
    answer: "Simon & Garfunkel",
    explanation:
        "Simon & Garfunkel ont sorti 'The Sound of Silence', une chanson emblématique des années 1960.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le nom du célèbre orchestre symphonique de Vienne ?",
    options: [
      "Orchestre philharmonique de Berlin",
      "Orchestre symphonique de Londres",
      "Orchestre philharmonique de Vienne",
    ],
    answer: "Orchestre philharmonique de Vienne",
    explanation:
        "L'Orchestre philharmonique de Vienne est réputé pour ses concerts du Nouvel An et son riche héritage musical.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur a popularisé le mouvement 'Chanson française' ?",
    options: ["Edith Piaf", "Charles Aznavour", "Georges Brassens"],
    answer: "Edith Piaf",
    explanation:
        "Edith Piaf est une icône de la chanson française, connue pour ses thèmes de l'amour et de la perte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle musique est souvent utilisée dans les films pour créer une ambiance dramatique ?",
    options: ["Musique classique", "Rock", "Rap"],
    answer: "Musique classique",
    explanation:
        "La musique classique est fréquemment utilisée dans les films pour accentuer les émotions et le drame.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style musical est souvent associé à des danses folkloriques ?",
    options: ["Salsa", "Folk", "Pop"],
    answer: "Folk",
    explanation:
        "La musique folk est traditionnellement liée aux danses folkloriques et aux cultures régionales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle est la principale caractéristique de la musique baroque ?",
    options: [
      "Improvisation",
      "Utilisation de la basse continue",
      "Simplicité",
    ],
    answer: "Utilisation de la basse continue",
    explanation:
        "La musique baroque se caractérise par l'utilisation d'une basse continue, essentiel à sa structure harmonique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est le compositeur du 'Boléro' ?",
    options: ["Maurice Ravel", "Claude Debussy", "Gabriel Fauré"],
    answer: "Maurice Ravel",
    explanation:
        "Maurice Ravel est célèbre pour son 'Boléro', une pièce orchestralement riche et répétitive.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le nom du plus ancien instrument à vent connu ?",
    options: ["Flûte", "Clarinette", "Saxophone"],
    answer: "Flûte",
    explanation:
        "La flûte est l'un des plus anciens instruments à vent, datant de plusieurs milliers d'années.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de la notation musicale utilisant des portée de cinq lignes ?",
    options: ["Notation moderne", "Notation pentatonique", "Notation musicale"],
    answer: "Notation musicale",
    explanation:
        "La notation musicale classique utilise des portées de cinq lignes pour représenter les notes et les rythmes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel artiste a écrit 'Purple Rain' ?",
    options: ["Prince", "Jimi Hendrix", "Stevie Wonder"],
    answer: "Prince",
    explanation:
        "Prince a écrit et interprété 'Purple Rain', une de ses chansons les plus emblématiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel type de morceau est un 'Sonate' ?",
    options: ["Instrumental", "Vocal", "Choral"],
    answer: "Instrumental",
    explanation:
        "La sonate est principalement un morceau instrumental, conçu pour être joué sur des instruments sans voix.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel moment de la journée est souvent associé à des concerts en plein air ?",
    options: ["Matin", "Après-midi", "Soirée"],
    answer: "Soirée",
    explanation:
        "Les concerts en plein air sont généralement programmés le soir pour une atmosphère festive et conviviale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre guitariste est connu pour son jeu innovant ?",
    options: ["Eric Clapton", "Jimmy Page", "Jimi Hendrix"],
    answer: "Jimi Hendrix",
    explanation:
        "Jimi Hendrix est reconnu pour son style de jeu de guitare révolutionnaire qui a redéfini le rock.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument à vent est fait de métal et produit un son doux ?",
    options: ["Trompette", "Trombone", "Cor"],
    answer: "Cor",
    explanation:
        "Le cor est un instrument à vent en métal qui produit un son chaud et riche, utilisé dans les orchestres classiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel festival de musique a lieu chaque été à Glastonbury ?",
    options: [
      "Reading Festival",
      "Glastonbury Festival",
      "Isle of Wight Festival",
    ],
    answer: "Glastonbury Festival",
    explanation:
        "Le Glastonbury Festival est l'un des plus grands festivals de musique et de performances artistiques au Royaume-Uni.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le nom de la musique traditionnelle irlandaise ?",
    options: ["Folk irlandais", "Celtique", "Traditionnelle"],
    answer: "Celtique",
    explanation:
        "La musique celtique englobe les styles traditionnels irlandais et écossais, riches en histoire et en culture.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé la musique du célèbre ballet 'Coppélia' ?",
    options: ["Léo Delibes", "Pyotr Ilyich Tchaikovsky", "Igor Stravinsky"],
    answer: "Léo Delibes",
    explanation:
        "Léo Delibes a composé la musique du ballet 'Coppélia', qui se distingue par ses mélodies charmantes et légères.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le principal appareil utilisé pour enregistrer de la musique en studio ?",
    options: ["Enregistreur numérique", "Mélangeur", "Synthétiseur"],
    answer: "Enregistreur numérique",
    explanation:
        "L'enregistreur numérique est essentiel en studio pour capturer et stocker les performances musicales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement artistique est souvent associé à la musique minimaliste ?",
    options: ["Impressionnisme", "Futurisme", "Minimalisme"],
    answer: "Minimalisme",
    explanation:
        "Le minimalisme dans la musique se concentre sur des répétitions et des motifs simples, caractéristiques du mouvement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle chanson des Beatles parle d'un bateau ?",
    options: ["Yellow Submarine", "Here Comes the Sun", "Help!"],
    answer: "Yellow Submarine",
    explanation:
        "'Yellow Submarine' est une chanson des Beatles qui évoque un monde fantasque sous-marin.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur est connu pour son opéra 'Carmen'?",
    options: ["Giuseppe Verdi", "Georges Bizet", "Wolfgang Amadeus Mozart"],
    answer: "Georges Bizet",
    explanation:
        "Georges Bizet est le compositeur de l'opéra 'Carmen', créé en 1875.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est au centre d'un concerto pour piano?",
    options: ["Violoncelle", "Piano", "Flûte"],
    answer: "Piano",
    explanation:
        "Le concerto pour piano met en avant le piano comme instrument soliste.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé la célèbre symphonie 'Symphonie No. 9'?",
    options: [
      "Ludwig van Beethoven",
      "Johann Sebastian Bach",
      "Frédéric Chopin",
    ],
    answer: "Ludwig van Beethoven",
    explanation:
        "La 'Symphonie No. 9' de Beethoven est célèbre pour son mouvement final 'Ode à la Joie'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe britannique a sorti l'album 'The Dark Side of the Moon'?",
    options: ["The Beatles", "Pink Floyd", "Led Zeppelin"],
    answer: "Pink Floyd",
    explanation:
        "'The Dark Side of the Moon' est un album emblématique de Pink Floyd, sorti en 1973.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel style musical est associé à Louis Armstrong?",
    options: ["Classique", "Jazz", "Rock"],
    answer: "Jazz",
    explanation: "Louis Armstrong est une figure emblématique du jazz.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste est connu pour sa voix distinctive et son album 'Back to Black'?",
    options: ["Adele", "Beyoncé", "Lady Gaga"],
    answer: "Adele",
    explanation:
        "Adele a explosé en popularité avec son album 'Back to Black' sorti en 2006.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel pays est le berceau du flamenco?",
    options: ["Espagne", "Italie", "Grèce"],
    answer: "Espagne",
    explanation:
        "Le flamenco est un genre musical et de danse originaire d'Espagne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du mouvement musical né à Vienne au XVIIIe siècle?",
    options: ["Romantisme", "Baroque", "Classique"],
    answer: "Classique",
    explanation: "Le mouvement classique a prospéré à Vienne au XVIIIe siècle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur est réputé pour ses 'Quatre Saisons'?",
    options: ["Antonio Vivaldi", "Johannes Brahms", "Claude Debussy"],
    answer: "Antonio Vivaldi",
    explanation:
        "Antonio Vivaldi est connu pour ses concertos 'Les Quatre Saisons'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur a popularisé la chanson 'Billie Jean'?",
    options: ["Elton John", "Michael Jackson", "Prince"],
    answer: "Michael Jackson",
    explanation:
        "Michael Jackson est l'interprète de la célèbre chanson 'Billie Jean'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a fondé le groupe The Rolling Stones?",
    options: ["Mick Jagger", "Keith Richards", "Brian Jones"],
    answer: "Brian Jones",
    explanation: "Brian Jones a cofondé le groupe The Rolling Stones en 1962.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qu'est-ce qui définit un 'sonate' en musique classique?",
    options: ["Monophonie", "Forme en trois mouvements", "Forme de variation"],
    answer: "Forme en trois mouvements",
    explanation: "Une sonate est généralement structurée en trois mouvements.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel rythme musicien est connu pour son style de guitare 'fingerpicking'?",
    options: ["Eric Clapton", "Kurt Cobain", "Jimi Hendrix"],
    answer: "Eric Clapton",
    explanation:
        "Eric Clapton est célèbre pour sa technique de guitare 'fingerpicking'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel type de musique est associé à la danse salsa?",
    options: ["Country", "Jazz", "Latino"],
    answer: "Latino",
    explanation: "La salsa est un genre musical d'origine latino-américaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé le ballet 'Le Lac des cygnes'?",
    options: [
      "Pyotr Ilyich Tchaikovsky",
      "Igor Stravinsky",
      "Sergei Rachmaninoff",
    ],
    answer: "Pyotr Ilyich Tchaikovsky",
    explanation:
        "Tchaikovsky est le compositeur du ballet 'Le Lac des cygnes'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est également appelé 'orgue de barbarie'?",
    options: ["Piano", "Accordéon", "Orgue"],
    answer: "Orgue",
    explanation: "L'orgue de barbarie est un type d'orgue portatif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du célèbre festival de musique qui se tient à Indio, Californie?",
    options: ["Glastonbury", "Coachella", "Lollapalooza"],
    answer: "Coachella",
    explanation:
        "Le festival de Coachella est connu pour ses performances musicales variées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur a été surnommé 'The Boss'?",
    options: ["Bruce Springsteen", "Bob Dylan", "Van Morrison"],
    answer: "Bruce Springsteen",
    explanation: "Bruce Springsteen est souvent appelé 'The Boss'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanson des Beatles commence par les mots 'Help, I need somebody'?",
    options: ["Hey Jude", "Let It Be", "Help!"],
    answer: "Help!",
    explanation: "La chanson 'Help!' des Beatles parle d'une quête de soutien.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a créé le genre musical du reggae?",
    options: ["Bob Marley", "James Brown", "Louis Armstrong"],
    answer: "Bob Marley",
    explanation: "Bob Marley est considéré comme le roi du reggae.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel genre de musique est le minimalisme?",
    options: ["Jazz", "Classique", "Pop"],
    answer: "Classique",
    explanation:
        "Le minimalisme est un mouvement au sein de la musique classique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre groupe de rock britannique a sorti 'A Night at the Opera'?",
    options: ["Queen", "Led Zeppelin", "The Who"],
    answer: "Queen",
    explanation:
        "Le groupe Queen est connu pour son album 'A Night at the Opera'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument à cordes est utilisé dans un orchestre symphonique?",
    options: ["Hautbois", "Violon", "Trompette"],
    answer: "Violon",
    explanation:
        "Le violon est un instrument à cordes essentiel dans les orchestres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle est la langue originale de la chanson 'La Vie en rose'?",
    options: ["Anglais", "Français", "Espagnol"],
    answer: "Français",
    explanation:
        "La chanson 'La Vie en rose' est écrite en français par Édith Piaf.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de la chanteuse connue pour 'Rolling in the Deep'?",
    options: ["Adele", "Taylor Swift", "Beyoncé"],
    answer: "Adele",
    explanation:
        "Adele a rencontré un grand succès avec 'Rolling in the Deep'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement musical a influencé le développement du punk rock?",
    options: ["Glam rock", "Classic rock", "Jazz"],
    answer: "Glam rock",
    explanation:
        "Le glam rock a inspiré le développement du punk rock dans les années 70.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre festival de musique a lieu chaque année à Montreux?",
    options: ["Montreux Jazz Festival", "Coachella", "Tomorrowland"],
    answer: "Montreux Jazz Festival",
    explanation:
        "Le Montreux Jazz Festival est un événement musical renommé en Suisse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le nom de la musique folklorique irlandaise?",
    options: ["Folk", "Celtique", "Country"],
    answer: "Celtique",
    explanation:
        "La musique folklorique irlandaise est souvent appelée musique celtique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur a interprété 'Imagine'?",
    options: ["John Lennon", "Paul McCartney", "George Harrison"],
    answer: "John Lennon",
    explanation:
        "John Lennon a écrit et interprété la chanson emblématique 'Imagine'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel type de danse est dansé sur la musique de tango?",
    options: ["Samba", "Cha-cha", "Tango"],
    answer: "Tango",
    explanation: "Le tango est une danse originaire d'Argentine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel type de musique est caractérisé par des improvisations?",
    options: ["Classique", "Jazz", "Blues"],
    answer: "Jazz",
    explanation: "Le jazz est bien connu pour ses improvisations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument de musique est principalement utilisé dans le rock?",
    options: ["Batterie", "Saxophone", "Harmonica"],
    answer: "Batterie",
    explanation: "La batterie est un instrument clé dans la musique rock.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le terme musical pour désigner une répétition d'une phrase mélodique?",
    options: ["Refrain", "Mélodie", "Variation"],
    answer: "Refrain",
    explanation:
        "Un refrain est une partie d'une chanson qui est répétée plusieurs fois.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur russe est connu pour son ballet 'Casse-Noisette'?",
    options: [
      "Igor Stravinsky",
      "Pyotr Ilyich Tchaikovsky",
      "Sergei Prokofiev",
    ],
    answer: "Pyotr Ilyich Tchaikovsky",
    explanation: "Tchaikovsky a composé le célèbre ballet 'Casse-Noisette'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanson de Bob Dylan a remporté le prix Nobel de littérature?",
    options: [
      "Like a Rolling Stone",
      "Blowin' in the Wind",
      "The Times They Are a-Changin'",
    ],
    answer: "Blowin' in the Wind",
    explanation:
        "'Blowin' in the Wind' est une chanson emblématique de Bob Dylan.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le principal instrument utilisé dans la musique de chambre?",
    options: ["Guitare", "Piano", "Violon"],
    answer: "Violon",
    explanation:
        "Le violon est souvent un instrument central dans la musique de chambre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé l'oratorio 'Le Messie'?",
    options: [
      "George Frideric Handel",
      "Johann Sebastian Bach",
      "Wolfgang Amadeus Mozart",
    ],
    answer: "George Frideric Handel",
    explanation: "Le 'Messie' est un oratorio célèbre composé par Handel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Dans quelle ville se trouve l'Opéra de Paris?",
    options: ["Lyon", "Marseille", "Paris"],
    answer: "Paris",
    explanation:
        "L'Opéra de Paris est l'un des opéras les plus célèbres au monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est surnommé le 'King of Rock and Roll'?",
    options: ["Elvis Presley", "Chuck Berry", "Little Richard"],
    answer: "Elvis Presley",
    explanation: "Elvis Presley est souvent appelé le 'King of Rock and Roll'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour ses œuvres pour piano solo au style romantique?",
    options: ["Frédéric Chopin", "Claude Debussy", "Johannes Brahms"],
    answer: "Frédéric Chopin",
    explanation:
        "Chopin est célèbre pour ses compositions de piano dans le style romantique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est caractérisé par des sonorités électroniques?",
    options: ["Jazz", "Rock", "Musique électronique"],
    answer: "Musique électronique",
    explanation:
        "La musique électronique utilise principalement des instruments électroniques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du style de musique traditionnel des États-Unis inventé par les Afro-Américains?",
    options: ["Jazz", "Blues", "Gospel"],
    answer: "Blues",
    explanation:
        "Le blues est un genre musical né des communautés afro-américaines aux États-Unis.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanteuse a interprété la célèbre chanson 'I Will Always Love You'?",
    options: ["Whitney Houston", "Tina Turner", "Celine Dion"],
    answer: "Whitney Houston",
    explanation:
        "Whitney Houston est connue pour sa version de 'I Will Always Love You'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste est célèbre pour ses performances théâtrales extravagantes?",
    options: ["David Bowie", "Elton John", "Madonna"],
    answer: "David Bowie",
    explanation:
        "David Bowie était connu pour ses performances visuellement spectaculaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe a sorti l'album 'Abbey Road'?",
    options: ["The Rolling Stones", "The Beatles", "The Who"],
    answer: "The Beatles",
    explanation:
        "Les Beatles ont sorti l'album légendaire 'Abbey Road' en 1969.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle est l'origine du terme 'opera'?",
    options: ["Latine", "Greque", "Allemande"],
    answer: "Latine",
    explanation:
        "Le terme 'opera' vient du mot latin 'opus', qui signifie 'œuvre'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel genre de musique a évolué à partir du blues et du jazz?",
    options: ["Rock", "Pop", "Funk"],
    answer: "Rock",
    explanation: "Le rock a émergé comme un dérivé du blues et du jazz.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel auteur de texte est connu pour avoir écrit la musique de 'West Side Story'?",
    options: ["Leonard Bernstein", "Stephen Sondheim", "Andrew Lloyd Webber"],
    answer: "Leonard Bernstein",
    explanation:
        "Leonard Bernstein a composé la musique pour 'West Side Story'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument à vent est connu dans de nombreuses cultures?",
    options: ["Trompette", "Flûte", "Saxophone"],
    answer: "Flûte",
    explanation:
        "La flûte est un instrument à vent présent dans de nombreuses traditions musicales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel terme désigne la vitesse d'une composition musicale?",
    options: ["Tempo", "Rythme", "Harmonie"],
    answer: "Tempo",
    explanation:
        "Le tempo indique la vitesse à laquelle la musique doit être jouée.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est au centre d'un concerto pour piano ?",
    options: ["Violon", "Piano", "Flûte"],
    answer: "Piano",
    explanation:
        "Le concerto pour piano met en avant le piano comme instrument soliste.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le style musical associé à Johann Sebastian Bach ?",
    options: ["Baroque", "Classique", "Romantique"],
    answer: "Baroque",
    explanation: "Bach est une figure emblématique de la musique baroque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a popularisé le jazz au XXe siècle ?",
    options: ["Louis Armstrong", "Beethoven", "Brahms"],
    answer: "Louis Armstrong",
    explanation:
        "Louis Armstrong est considéré comme l'un des pionniers du jazz.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nombre de symphonies composées par Ludwig van Beethoven ?",
    options: ["5", "9", "7"],
    answer: "9",
    explanation:
        "Beethoven a composé neuf symphonies, dont la célèbre 'Hymne à la joie'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel mouvement musical a influencé les Beatles ?",
    options: ["Rock and Roll", "Punk", "Ragtime"],
    answer: "Rock and Roll",
    explanation:
        "Les Beatles ont été fortement influencés par le mouvement Rock and Roll des années 1950.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle chanteuse a interprété 'Like a Prayer' ?",
    options: ["Madonna", "Whitney Houston", "Céline Dion"],
    answer: "Madonna",
    explanation:
        "'Like a Prayer' est une chanson emblématique de Madonna sortie en 1989.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du festival de musique qui se déroule à Woodstock ?",
    options: ["Woodstock Festival", "Coachella", "Glastonbury"],
    answer: "Woodstock Festival",
    explanation:
        "Le Woodstock Festival, tenu en 1969, est légendaire pour son ambiance pacifiste.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a créé la célèbre œuvre 'Les Quatre Saisons' ?",
    options: ["Pachelbel", "Vivaldi", "Haendel"],
    answer: "Vivaldi",
    explanation:
        "Antonio Vivaldi a composé 'Les Quatre Saisons', une série de concertos pour violon.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe britannique est connu pour l'album 'The Dark Side of the Moon' ?",
    options: ["Queen", "Pink Floyd", "The Rolling Stones"],
    answer: "Pink Floyd",
    explanation:
        "'The Dark Side of the Moon' est un album culte de Pink Floyd sorti en 1973.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle est la principale caractéristique du blues ?",
    options: [
      "Rapport avec le jazz",
      "Utilisation de la guitare électrique",
      "Structure de 12 mesures",
    ],
    answer: "Structure de 12 mesures",
    explanation: "Le blues est souvent basé sur une structure de 12 mesures.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Comment s'appelle le célèbre compositeur de 'La Flûte enchantée' ?",
    options: ["Mozart", "Chopin", "Haydn"],
    answer: "Mozart",
    explanation:
        "Wolfgang Amadeus Mozart a composé 'La Flûte enchantée', un opéra en deux actes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le style musical d'origine brésilienne fait de samba et de bossa nova ?",
    options: ["Salsa", "Funk", "MPB"],
    answer: "MPB",
    explanation:
        "La MPB, ou Música Popular Brasileira, mélange samba et bossa nova.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement a influencé la musique classique au XIXe siècle ?",
    options: ["Romantisme", "Baroque", "Impressionnisme"],
    answer: "Romantisme",
    explanation:
        "Le romantisme a profondément influencé la musique classique du XIXe siècle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est principalement associé avec Mozart ?",
    options: ["Piano", "Guitare", "Batterie"],
    answer: "Piano",
    explanation:
        "Mozart était un virtuose du piano et a écrit de nombreuses œuvres pour cet instrument.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a chanté ‘Tous les mêmes’ ?",
    options: ["Stromae", "Calogero", "Mika"],
    answer: "Stromae",
    explanation:
        "Stromae est l'interprète de la chanson ‘Tous les mêmes’, sortie en 2013.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle célèbre danse populaire est associée à la musique tango ?",
    options: ["Samba", "Valse", "Tango"],
    answer: "Tango",
    explanation: "Le tango est une danse passionnée originaire d'Argentine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur français est connu pour 'La Vie en rose' ?",
    options: ["Édith Piaf", "Charles Aznavour", "Joe Dassin"],
    answer: "Édith Piaf",
    explanation:
        "Édith Piaf a popularisé 'La Vie en rose', chanson emblématique de la chanson française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanteuse a remporté l'Eurovision en 1975 avec 'Dancing Queen' ?",
    options: ["Céline Dion", "ABBA", "Lara Fabian"],
    answer: "ABBA",
    explanation:
        "ABBA a remporté l'Eurovision avec 'Waterloo' en 1974, mais 'Dancing Queen' est un de leurs succès.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel musicien est considéré comme le roi de la pop ?",
    options: ["Prince", "Michael Jackson", "Elton John"],
    answer: "Michael Jackson",
    explanation:
        "Michael Jackson est surnommé le roi de la pop pour ses contributions à la musique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre album des Beatles est souvent considéré comme le meilleur de tous les temps ?",
    options: [
      "Sgt. Pepper's Lonely Hearts Club Band",
      "Revolver",
      "Abbey Road",
    ],
    answer: "Sgt. Pepper's Lonely Hearts Club Band",
    explanation:
        "L'album 'Sgt. Pepper's' est considéré comme une œuvre innovante et emblématique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle est la période de l'histoire de la musique allant de 1750 à 1820 ?",
    options: ["Baroque", "Classique", "Romantique"],
    answer: "Classique",
    explanation:
        "La période classique en musique couvre les années 1750 à 1820.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Qui est l'auteur de la célèbre chanson 'I Will Always Love You' ?",
    options: ["Whitney Houston", "Dolly Parton", "Mariah Carey"],
    answer: "Dolly Parton",
    explanation:
        "Dolly Parton a écrit 'I Will Always Love You', popularisée par Whitney Houston.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel orchestre est connu comme l'orchestre de Vienne ?",
    options: [
      "L'Orchestre Philharmonique de Vienne",
      "L'Orchestre Symphonique de Vienne",
      "L'Orchestre de la Société de Concerts de Vienne",
    ],
    answer: "L'Orchestre Philharmonique de Vienne",
    explanation:
        "L'Orchestre Philharmonique de Vienne est célèbre pour ses concerts et ses enregistrements.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est l'instrument de musique le plus vendu au monde ?",
    options: ["Piano", "Guitare", "Violoncelle"],
    answer: "Guitare",
    explanation:
        "La guitare est souvent considérée comme l'instrument de musique le plus vendu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe est connu pour la chanson 'Bohemian Rhapsody' ?",
    options: ["The Beatles", "Queen", "Led Zeppelin"],
    answer: "Queen",
    explanation:
        "'Bohemian Rhapsody' est une chanson emblématique du groupe Queen.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle danse est souvent associée à la musique classique russe ?",
    options: ["Valse", "Mazurka", "Tango"],
    answer: "Mazurka",
    explanation:
        "La mazurka est une danse traditionnelle polonaise liée à la musique classique russe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a chanté 'My Heart Will Go On' ?",
    options: ["Céline Dion", "Whitney Houston", "Mariah Carey"],
    answer: "Céline Dion",
    explanation:
        "'My Heart Will Go On' est la chanson thème du film Titanic, interprétée par Céline Dion.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle est la principale caractéristique du rock progressif ?",
    options: [
      "Simplicité des mélodies",
      "Utilisation de synthétiseurs",
      "Longueur des morceaux",
    ],
    answer: "Longueur des morceaux",
    explanation:
        "Le rock progressif est caractérisé par des morceaux souvent longs et complexes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est l'instrument principal des orchestres symphoniques ?",
    options: ["Violoncelle", "Batterie", "Flûte"],
    answer: "Violoncelle",
    explanation:
        "Le violoncelle est un instrument clé dans les orchestres symphoniques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre chanteur a popularisé 'New York, New York' ?",
    options: ["Frank Sinatra", "Elvis Presley", "Tony Bennett"],
    answer: "Frank Sinatra",
    explanation:
        "Frank Sinatra est célèbre pour sa chanson 'New York, New York'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le genre de musique associé aux danses folkloriques irlandaises ?",
    options: ["Celtique", "Baroque", "Classique"],
    answer: "Celtique",
    explanation:
        "La musique celtique est étroitement liée aux danses folkloriques irlandaises.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle est la principale influence musicale du flamenco ?",
    options: ["Andalouse", "Latine", "Africaine"],
    answer: "Andalouse",
    explanation:
        "Le flamenco est un genre musical andalou traditionnel, imprégné de culture gitane.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe a composé la chanson 'Smells Like Teen Spirit' ?",
    options: ["Nirvana", "Pearl Jam", "Radiohead"],
    answer: "Nirvana",
    explanation:
        "'Smells Like Teen Spirit' est une chanson emblématique du groupe Nirvana.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Qui a interprété le rôle principal dans le film musical 'A Star is Born' en 2018 ?",
    options: ["Lady Gaga", "Beyoncé", "Adele"],
    answer: "Lady Gaga",
    explanation:
        "Lady Gaga a joué dans 'A Star is Born', un film musical acclamé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle célèbre plateforme de streaming est dédiée à la musique ?",
    options: ["Spotify", "Netflix", "YouTube"],
    answer: "Spotify",
    explanation:
        "Spotify est une plateforme de streaming largement utilisée pour écouter de la musique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel musicien est souvent appelé le 'Piano Man' ?",
    options: ["Billy Joel", "Elton John", "Bruce Springsteen"],
    answer: "Billy Joel",
    explanation:
        "Billy Joel est souvent surnommé le 'Piano Man' en référence à sa célèbre chanson.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre compositeur est connu pour ses opéras tels que 'Die Fledermaus' ?",
    options: ["Mozart", "Johann Strauss II", "Richard Wagner"],
    answer: "Johann Strauss II",
    explanation:
        "Johann Strauss II est célèbre pour ses opérettes, dont 'Die Fledermaus'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument de musique est un symbole du jazz ?",
    options: ["Saxophone", "Piano", "Trompette"],
    answer: "Saxophone",
    explanation:
        "Le saxophone est souvent considéré comme un symbole emblématique du jazz.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Combien de cordes a généralement une guitare ?",
    options: ["4", "5", "6"],
    answer: "6",
    explanation: "Une guitare standard a généralement six cordes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du célèbre chorégraphe et danseur associé à Michael Jackson ?",
    options: ["Usher", "Gene Kelly", "Jerome Robbins"],
    answer: "Usher",
    explanation:
        "Usher a été fortement influencé par Michael Jackson et est reconnu pour ses talents de danseur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de la danse folklorique espagnole qui utilise des castagnettes ?",
    options: ["Samba", "Flamenco", "Bailando"],
    answer: "Flamenco",
    explanation:
        "Le flamenco utilise souvent des castagnettes et est une danse folklorique espagnole.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le nom du célèbre chanteur du groupe Queen ?",
    options: ["Freddie Mercury", "Brian May", "Roger Taylor"],
    answer: "Freddie Mercury",
    explanation:
        "Freddie Mercury était le chanteur emblématique du groupe Queen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanson de Whitney Houston est associée au film 'Bodyguard' ?",
    options: [
      "I Will Always Love You",
      "Greatest Love of All",
      "I Wanna Dance with Somebody",
    ],
    answer: "I Will Always Love You",
    explanation:
        "'I Will Always Love You' est la chanson principale du film 'Bodyguard'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du genre musical né des chants des esclaves africains aux États-Unis ?",
    options: ["Blues", "Jazz", "Soul"],
    answer: "Blues",
    explanation:
        "Le blues est un genre musical né des chants des esclaves africains aux États-Unis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style musical est souvent défini par des rythmes syncopés et des improvisations ?",
    options: ["Jazz", "Classique", "Folklorique"],
    answer: "Jazz",
    explanation:
        "Le jazz est caractérisé par des rythmes syncopés et l'improvisation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument est couramment utilisé dans la musique bluegrass ?",
    options: ["Banjo", "Guitare", "Violoncelle"],
    answer: "Banjo",
    explanation:
        "Le banjo est un instrument emblématique de la musique bluegrass.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour ses symphonies et son opéra 'Don Giovanni' ?",
    options: [
      "Ludwig van Beethoven",
      "Wolfgang Amadeus Mozart",
      "Johann Sebastian Bach",
    ],
    answer: "Wolfgang Amadeus Mozart",
    explanation:
        "Mozart est célèbre pour ses œuvres majeures dans le domaine de la musique classique, y compris ses symphonies et opéras.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est l'instrument principal du musicien Yo-Yo Ma ?",
    options: ["Piano", "Violoncelle", "Guitare"],
    answer: "Violoncelle",
    explanation:
        "Yo-Yo Ma est un violoncelliste renommé, connu pour ses interprétations classiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a popularisé le style musical du reggae ?",
    options: ["Bob Marley", "Michael Jackson", "Elton John"],
    answer: "Bob Marley",
    explanation:
        "Bob Marley est souvent considéré comme le roi du reggae, ayant internationalisé ce genre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du célèbre festival de musique qui a lieu à Woodstock ?",
    options: ["Glastonbury", "Woodstock Festival", "Coachella"],
    answer: "Woodstock Festival",
    explanation:
        "Le festival de Woodstock en 1969 est devenu emblématique pour son impact culturel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a chanté la célèbre chanson 'I Will Always Love You' ?",
    options: ["Celine Dion", "Whitney Houston", "Mariah Carey"],
    answer: "Whitney Houston",
    explanation:
        "Whitney Houston a interprété cette chanson dans le film 'The Bodyguard'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre groupe britannique est connu pour des albums comme 'The Dark Side of the Moon' ?",
    options: ["The Beatles", "Led Zeppelin", "Pink Floyd"],
    answer: "Pink Floyd",
    explanation:
        "Pink Floyd est célèbre pour son album innovant et conceptuel 'The Dark Side of the Moon'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste est célèbre pour ses performances de pop et de rock, ainsi que pour son style flamboyant ?",
    options: ["David Bowie", "Freddie Mercury", "Prince"],
    answer: "David Bowie",
    explanation:
        "David Bowie est connu pour sa capacité à se réinventer et son impact sur la musique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est associé à des artistes comme Billie Holiday et Ella Fitzgerald ?",
    options: ["Jazz", "Rock", "Blues"],
    answer: "Jazz",
    explanation:
        "Billie Holiday et Ella Fitzgerald sont des figures emblématiques du jazz.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour ses concertos pour piano, notamment le 'Concerto n° 1 en si bémol mineur' ?",
    options: ["Frédéric Chopin", "Sergei Rachmaninoff", "Johannes Brahms"],
    answer: "Sergei Rachmaninoff",
    explanation:
        "Rachmaninoff est reconnu pour ses virtuoses concertos pour piano.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe a sorti l'album 'Hotel California' ?",
    options: ["Eagles", "Fleetwood Mac", "The Rolling Stones"],
    answer: "Eagles",
    explanation:
        "L'album 'Hotel California' est l'un des plus connus du groupe Eagles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est le créateur de la célèbre œuvre 'La Traviata' ?",
    options: ["Giuseppe Verdi", "Giacomo Puccini", "Richard Wagner"],
    answer: "Giuseppe Verdi",
    explanation: "'La Traviata' est un opéra emblématique de Giuseppe Verdi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est caractérisé par des rythmes syncopés et une forte influence de la culture afro-américaine ?",
    options: ["Jazz", "Classique", "Pop"],
    answer: "Jazz",
    explanation:
        "Le jazz est né de la fusion de plusieurs traditions musicales afro-américaines.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel musicien est célèbre pour ses performances de guitare électrique, notamment dans 'Purple Haze' ?",
    options: ["Eric Clapton", "Jimi Hendrix", "Jimmy Page"],
    answer: "Jimi Hendrix",
    explanation:
        "Jimi Hendrix est considéré comme l'un des plus grands guitaristes de l'histoire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle compositeur est connu pour sa musique minimaliste, notamment 'Music for 18 Musicians' ?",
    options: ["Steve Reich", "Philip Glass", "John Adams"],
    answer: "Steve Reich",
    explanation:
        "Steve Reich est un pionnier de la musique minimaliste avec des compositions innovantes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chœur est célèbre pour ses interprétations de musique classique et de gospel ?",
    options: [
      "The Mormon Tabernacle Choir",
      "The King's Singers",
      "The Sixteen",
    ],
    answer: "The Mormon Tabernacle Choir",
    explanation:
        "Ce chœur est reconnu pour ses performances de haute qualité dans la musique classique et gospel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est l'œuvre majeure du compositeur Claude Debussy ?",
    options: ["Boléro", "Clair de Lune", "La Mer"],
    answer: "Clair de Lune",
    explanation:
        "'Clair de Lune' est l'une des œuvres les plus célèbres de Debussy.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical a popularisé des artistes comme Elvis Presley et Johnny Cash ?",
    options: ["Jazz", "Rockabilly", "Blues"],
    answer: "Rockabilly",
    explanation:
        "Le rockabilly, mélange de rock et de country, a été popularisé par des artistes comme Elvis.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle est la principale caractéristique de la musique baroque ?",
    options: ["L'improvisation", "La polyphonie", "Le rythme simple"],
    answer: "La polyphonie",
    explanation:
        "La musique baroque se distingue par une utilisation complexe de la polyphonie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de l'album emblématique des Beatles sorti en 1967 ?",
    options: [
      "Abbey Road",
      "Sgt. Pepper's Lonely Hearts Club Band",
      "The White Album",
    ],
    answer: "Sgt. Pepper's Lonely Hearts Club Band",
    explanation:
        "Cet album est souvent considéré comme l'un des plus influents de l'histoire de la musique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur français est connu pour son opéra 'Les Troyens' ?",
    options: ["Hector Berlioz", "Gabriel Fauré", "Jules Massenet"],
    answer: "Hector Berlioz",
    explanation:
        "Berlioz a composé 'Les Troyens', une œuvre majeure du répertoire opératique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle est la première grande œuvre de Ludwig van Beethoven ?",
    options: [
      "Symphonie n°5",
      "Sonate au clair de lune",
      "Symphonie n°3 'Eroica'",
    ],
    answer: "Symphonie n°3 'Eroica'",
    explanation:
        "La Symphonie n°3 est souvent considérée comme une œuvre révolutionnaire dans la musique classique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel album de Michael Jackson est célèbre pour sa chanson 'Thriller' ?",
    options: ["Bad", "Dangerous", "Thriller"],
    answer: "Thriller",
    explanation:
        "L'album 'Thriller' est l'un des plus vendus de tous les temps, avec sa chanson titre emblématique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle est la principale différence entre un opéra et une opérette ?",
    options: ["Durée", "Intrigue", "Musique"],
    answer: "Durée",
    explanation:
        "L'opérette est généralement plus courte et plus légère que l'opéra.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument à vent est souvent utilisé dans les orchestres symphoniques ?",
    options: ["La trompette", "Le tambour", "Le violon"],
    answer: "La trompette",
    explanation:
        "La trompette est un instrument à vent commun dans les orchestres pour ses sonorités éclatantes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Qui a dirigé le Philharmonique de Berlin pendant de nombreuses années ?",
    options: ["Herbert von Karajan", "Leonard Bernstein", "Zubin Mehta"],
    answer: "Herbert von Karajan",
    explanation:
        "Karajan a été un chef d'orchestre influent, dirigeant le Philharmonique de Berlin pendant des décennies.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est souvent associé au mouvement romantique et à des oeuvres comme 'Lieux de mémoire' ?",
    options: ["Franz Schubert", "Pyotr Ilyich Tchaikovsky", "Johannes Brahms"],
    answer: "Pyotr Ilyich Tchaikovsky",
    explanation:
        "Tchaikovsky est un incontournable du romantisme avec ses compositions émotionnelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanson de Queen contient le célèbre refrain 'We Will Rock You' ?",
    options: [
      "Bohemian Rhapsody",
      "We Will Rock You",
      "Another One Bites the Dust",
    ],
    answer: "We Will Rock You",
    explanation:
        "'We Will Rock You' est célèbre pour son rythme emblématique, souvent chanté dans les stades.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style de musique est principalement associé à des artistes comme Frank Sinatra ?",
    options: ["Jazz", "Pop", "Rock"],
    answer: "Jazz",
    explanation:
        "Frank Sinatra est une figure emblématique du jazz et de la musique populaire du XXe siècle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé la célèbre œuvre 'Le Carnaval des animaux' ?",
    options: ["Camille Saint-Saëns", "Claude Debussy", "Maurice Ravel"],
    answer: "Camille Saint-Saëns",
    explanation:
        "'Le Carnaval des animaux' est une suite musicale célèbre de Camille Saint-Saëns.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe est connu pour le titre 'Stairway to Heaven' ?",
    options: ["Pink Floyd", "Led Zeppelin", "The Doors"],
    answer: "Led Zeppelin",
    explanation:
        "'Stairway to Heaven' est l'une des chansons les plus emblématiques de Led Zeppelin.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du festival de musique qui se déroule chaque année à Montreux ?",
    options: [
      "Montreux Jazz Festival",
      "Glastonbury Festival",
      "Coachella Festival",
    ],
    answer: "Montreux Jazz Festival",
    explanation:
        "Le Montreux Jazz Festival est l'un des festivals de musique les plus réputés au monde.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel type de musique comporte des éléments de blues, de jazz et de gospel ?",
    options: ["Soul", "Folk", "Classique"],
    answer: "Soul",
    explanation:
        "La musique soul mélange des éléments de blues, jazz et gospel pour créer un genre distinctif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur a écrit 'Peer Gynt', qui comprend la célèbre 'Morning Mood' ?",
    options: ["Edvard Grieg", "Carl Nielsen", "Jean Sibelius"],
    answer: "Edvard Grieg",
    explanation:
        "Grieg a composé la musique de 'Peer Gynt', dont 'Morning Mood' est un extrait célèbre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur est surnommé 'The Boss' ?",
    options: ["Bruce Springsteen", "Elton John", "Bob Dylan"],
    answer: "Bruce Springsteen",
    explanation:
        "Bruce Springsteen est souvent appelé 'The Boss' en raison de son charisme sur scène.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est surtout connu pour ses ballets 'Le Lac des cygnes' et 'Casse-Noisette' ?",
    options: [
      "Igor Stravinsky",
      "Pyotr Ilyich Tchaikovsky",
      "Sergei Prokofiev",
    ],
    answer: "Pyotr Ilyich Tchaikovsky",
    explanation:
        "Tchaikovsky est célèbre pour ses ballets, y compris 'Le Lac des cygnes'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical repose sur des compositions vocales et instrumentales traditionnelles, souvent associé aux fêtes de la Nouvelle-Orléans ?",
    options: ["Jazz", "Classique", "Folk"],
    answer: "Jazz",
    explanation:
        "Le jazz est un genre musical fondé à la Nouvelle-Orléans, intégrant des éléments vocaux et instrumentaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel apprenti musicien est devenu chanteur de l'album 'Back in Black' ?",
    options: ["Bon Scott", "Brian Johnson", "Axl Rose"],
    answer: "Brian Johnson",
    explanation:
        "Brian Johnson a pris la relève de Bon Scott et a chanté sur l'album à succès 'Back in Black'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur français est connu pour des titres comme 'Je te promets' ?",
    options: ["Francis Cabrel", "Johnny Hallyday", "Charles Aznavour"],
    answer: "Johnny Hallyday",
    explanation:
        "Johnny Hallyday est une icône de la chanson française, connu pour ses ballades.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur a écrit la célèbre 'Symphonie inachevée' ?",
    options: ["Franz Schubert", "Ludwig van Beethoven", "Anton Bruckner"],
    answer: "Franz Schubert",
    explanation:
        "La 'Symphonie inachevée' de Schubert est célèbre pour sa beauté et son mystère.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical a été popularisé dans les années 1960 par des artistes comme The Beach Boys ?",
    options: ["Rock", "Pop", "Folk"],
    answer: "Pop",
    explanation:
        "La pop des années 60, avec des harmonies vocales, a été popularisée par des groupes comme The Beach Boys.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de la célèbre chanson de Claude François connue pour ses refrains entraînants ?",
    options: ["Alexandrie, Alexandra", "Comme un enfant", "Le Lundi au soleil"],
    answer: "Alexandrie, Alexandra",
    explanation:
        "Cette chanson emblématique de Claude François est reconnue pour ses refrains entraînants.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du groupe britannique qui a popularisé le rock progressif avec des albums comme 'Fragile' ?",
    options: ["Genesis", "Yes", "Pink Floyd"],
    answer: "Yes",
    explanation:
        "Yes est reconnu pour son approche innovante du rock progressif avec des albums emblématiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel musicien a remporté le prix Nobel de littérature en 2016 ?",
    options: ["Leonard Cohen", "Bob Dylan", "Paul Simon"],
    answer: "Bob Dylan",
    explanation:
        "Bob Dylan a été le premier musicien à recevoir le prix Nobel de littérature.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle chanteuse française est connue pour son interprétation de la chanson 'Désenchantée' ?",
    options: ["Céline Dion", "Mylène Farmer", "Dalida"],
    answer: "Mylène Farmer",
    explanation:
        "Mylène Farmer a connu un immense succès avec 'Désenchantée', devenue un classique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur est lié à l'invention du piano-forte ?",
    options: ["Bartolomeo Cristofori", "Steinway", "Ferdinand Becker"],
    answer: "Bartolomeo Cristofori",
    explanation:
        "Bartolomeo Cristofori est reconnu comme l'inventeur du piano-forte.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de la célèbre chanson du groupe Queen sortie en 1975 ?",
    options: [
      "Don't Stop Me Now",
      "Bohemian Rhapsody",
      "Another One Bites the Dust",
    ],
    answer: "Bohemian Rhapsody",
    explanation:
        "'Bohemian Rhapsody' est l'une des chansons les plus emblématiques du groupe Queen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est l'album le plus vendu de tous les temps ?",
    options: ["Thriller", "Back in Black", "The Dark Side of the Moon"],
    answer: "Thriller",
    explanation:
        "L'album 'Thriller' de Michael Jackson détient le record de ventes le plus élevé dans l'histoire de la musique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur est connu pour son album 'The Wall' ?",
    options: ["David Bowie", "Roger Waters", "Roger Daltrey"],
    answer: "Roger Waters",
    explanation:
        "Roger Waters est le cofondateur de Pink Floyd et est associé à l'album 'The Wall'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit la musique du célèbre ballet 'Giselle' ?",
    options: ["Adolphe Adam", "Igor Stravinsky", "Léo Delibes"],
    answer: "Adolphe Adam",
    explanation:
        "Adolphe Adam a composé la musique pour le ballet 'Giselle', un classique du répertoire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur a popularisé le titre 'Like a Rolling Stone' ?",
    options: ["Bruce Springsteen", "Bob Dylan", "Johnny Cash"],
    answer: "Bob Dylan",
    explanation:
        "'Like a Rolling Stone' est l'une des chansons les plus emblématiques de Bob Dylan.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur est connu pour son opéra \"Carmen\" ?",
    options: ["Giuseppe Verdi", "Georges Bizet", "Wolfgang Amadeus Mozart"],
    answer: "Georges Bizet",
    explanation:
        "Georges Bizet est le compositeur de l'opéra \"Carmen\", une oeuvre emblématique du répertoire lyrique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument de musique est principalement associé au jazz ?",
    options: ["Guitare", "Piano", "Saxophone"],
    answer: "Saxophone",
    explanation:
        "Le saxophone est un instrument emblématique du jazz, créé par Adolphe Sax au 19e siècle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre groupe britannique a chanté \"Hey Jude\" ?",
    options: ["The Beatles", "The Rolling Stones", "Queen"],
    answer: "The Beatles",
    explanation:
        "\"Hey Jude\" est une célèbre chanson du groupe The Beatles, écrite par Paul McCartney.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé la symphonie \"Pastorale\" ?",
    options: [
      "Ludwig van Beethoven",
      "Johann Sebastian Bach",
      "Frédéric Chopin",
    ],
    answer: "Ludwig van Beethoven",
    explanation:
        "La symphonie \"Pastorale\" est la sixième symphonie de Ludwig van Beethoven, créée en 1808.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel musicien est célèbre pour avoir popularisé le piano-forte au 18e siècle ?",
    options: [
      "Franz Schubert",
      "Wolfgang Amadeus Mozart",
      "Ludwig van Beethoven",
    ],
    answer: "Wolfgang Amadeus Mozart",
    explanation:
        "Wolfgang Amadeus Mozart était un virtuose du piano-forte et a largement contribué à sa popularisation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur est connu pour sa voix puissante et son tube \"I Will Always Love You\" ?",
    options: ["Celine Dion", "Whitney Houston", "Mariah Carey"],
    answer: "Whitney Houston",
    explanation:
        "Whitney Houston est célèbre pour sa reprise de \"I Will Always Love You\", qui a connu un immense succès mondial.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel mouvement musical est associé à Claude Debussy ?",
    options: ["Romantisme", "Impressionnisme", "Classique"],
    answer: "Impressionnisme",
    explanation:
        "Claude Debussy est le représentant majeur de l'impressionnisme en musique, caractérisé par des sonorités fluides et évocatrices.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel type de danse est associé à la musique classique espagnole ?",
    options: ["Samba", "Flamenco", "Valse"],
    answer: "Flamenco",
    explanation:
        "Le flamenco est une danse traditionnelle espagnole souvent accompagnée de musique classique espagnole.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit la fameuse chanson \"La Vie en rose\" ?",
    options: ["Édith Piaf", "Charles Aznavour", "Juliette Gréco"],
    answer: "Édith Piaf",
    explanation:
        "Édith Piaf est l'autrice et interprète de la chanson emblématique \"La Vie en rose\".",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument est traditionnellement utilisé dans la musique celtique ?",
    options: ["Batterie", "Harpe", "Saxophone"],
    answer: "Harpe",
    explanation:
        "La harpe est un instrument emblématique de la musique celtique, souvent utilisée dans les compositions traditionnelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est le roi du rock'n'roll ?",
    options: ["Elvis Presley", "Chuck Berry", "Buddy Holly"],
    answer: "Elvis Presley",
    explanation:
        "Elvis Presley est surnommé le roi du rock'n'roll pour son immense influence sur ce genre musical.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur est connu pour ses concertos pour piano ?",
    options: [
      "Pyotr Ilyich Tchaikovsky",
      "Sergei Rachmaninoff",
      "Frédéric Chopin",
    ],
    answer: "Sergei Rachmaninoff",
    explanation:
        "Sergei Rachmaninoff est célèbre pour ses brillants concertos pour piano, notamment le deuxième et le troisième.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le rythme musical de base du tango ?",
    options: ["4/4", "3/4", "2/4"],
    answer: "4/4",
    explanation:
        "Le tango est généralement joué en mesure 4/4, ce qui contribue à sa danse rythmée et passionnée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a interprété \"Billie Jean\" ?",
    options: ["Prince", "Michael Jackson", "David Bowie"],
    answer: "Michael Jackson",
    explanation:
        "Michael Jackson a popularisé \"Billie Jean\", un des titres les plus emblématiques de sa carrière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle période musicale est souvent associée à Vivaldi ?",
    options: ["Baroque", "Classique", "Romantique"],
    answer: "Baroque",
    explanation:
        "Antonio Vivaldi est un compositeur emblématique de la période baroque, connue pour ses compositions orchestrales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument à cordes est joué avec un archet et est essentiel dans un orchestre ?",
    options: ["Violon", "Guitare", "Piano"],
    answer: "Violon",
    explanation:
        "Le violon est un instrument à cordes joué à l'archet et est indispensable dans les orchestres classiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé la célèbre \"Hymne à la joie\" ?",
    options: ["Ludwig van Beethoven", "Johann Strauss", "Richard Wagner"],
    answer: "Ludwig van Beethoven",
    explanation:
        "L'hymne à la joie, tiré de la 9e symphonie de Beethoven, est célèbre pour son message universel de fraternité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est souvent associé à la ville de Nashville ?",
    options: ["Jazz", "Blues", "Country"],
    answer: "Country",
    explanation:
        "Nashville est considérée comme la capitale de la musique country, attirant de nombreux artistes du genre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est l'instrument principal de l'orchestre symphonique ?",
    options: ["Flûte", "Trompette", "Violoncelle"],
    answer: "Violoncelle",
    explanation:
        "Le violoncelle joue un rôle crucial dans l'orchestre symphonique, apportant des sonorités riches et profondes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur est connu pour sa chanson \"Wonderwall\" ?",
    options: ["Oasis", "Blur", "Radiohead"],
    answer: "Oasis",
    explanation:
        "\"Wonderwall\" est une chanson emblématique du groupe britannique Oasis, sortie en 1995.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste a marqué le mouvement grunge dans les années 1990 ?",
    options: ["Nirvana", "Pearl Jam", "Soundgarden"],
    answer: "Nirvana",
    explanation:
        "Nirvana, avec Kurt Cobain, a été au centre du mouvement grunge, influençant la scène musicale des années 90.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du célèbre festival de musique qui se tient chaque année à Woodstock ?",
    options: ["Glastonbury", "Lollapalooza", "Woodstock Festival"],
    answer: "Woodstock Festival",
    explanation:
        "Le Woodstock Festival est célèbre pour avoir été un événement clé dans l'histoire de la musique et de contre-culture des années 1960.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel genre musical est associé au groupe ABBA ?",
    options: ["Disco", "Rock", "Pop"],
    answer: "Pop",
    explanation:
        "ABBA est un groupe suédois emblématique du genre pop, connu pour ses mélodies accrocheuses.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est souvent utilisé dans la musique baroque ?",
    options: ["Clavier", "Hautbois", "Saxophone"],
    answer: "Clavier",
    explanation:
        "Le clavier, en particulier le clavecin, était un instrument central dans la musique baroque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a réalisé l'album \"The Dark Side of the Moon\" ?",
    options: ["The Rolling Stones", "Led Zeppelin", "Pink Floyd"],
    answer: "Pink Floyd",
    explanation:
        "\"The Dark Side of the Moon\" est un album emblématique du groupe britannique Pink Floyd, sorti en 1973.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle danse est traditionnellement associée à la musique classique française ?",
    options: ["Boléro", "Samba", "Valse"],
    answer: "Boléro",
    explanation:
        "Le boléro est une danse et une pièce musicale française rendue célèbre par Maurice Ravel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur est connu pour son image de \"Bad Boy\" et sa chanson \"Like a Rolling Stone\" ?",
    options: ["Bob Dylan", "Bruce Springsteen", "Eric Clapton"],
    answer: "Bob Dylan",
    explanation:
        "Bob Dylan est célèbre pour son style et ses paroles percutantes, notamment dans \"Like a Rolling Stone\".",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre festival de musique se déroule chaque année à Coachella ?",
    options: [
      "Glastonbury",
      "Lollapalooza",
      "Coachella Valley Music and Arts Festival",
    ],
    answer: "Coachella Valley Music and Arts Festival",
    explanation:
        "Le Coachella Valley Music and Arts Festival est l'un des festivals les plus connus au monde, célébrant la musique et l'art.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est caractérisé par des paroles engagées et un rythme rapide ?",
    options: ["Reggae", "Rap", "Folk"],
    answer: "Rap",
    explanation:
        "Le rap est un genre musical qui utilise des paroles rythmées et souvent engagées socialement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre chanteur a popularisé le morceau \"Shape of You\" ?",
    options: ["Justin Bieber", "Ed Sheeran", "Sam Smith"],
    answer: "Ed Sheeran",
    explanation:
        "Ed Sheeran a connu un immense succès avec sa chanson \"Shape of You\", sortie en 2017.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe a chanté \"Bohemian Rhapsody\" ?",
    options: ["Led Zeppelin", "Pink Floyd", "Queen"],
    answer: "Queen",
    explanation:
        "\"Bohemian Rhapsody\" est une chanson emblématique du groupe britannique Queen, sortie en 1975.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre compositeur a écrit la \"Messe en si mineur\" ?",
    options: [
      "Johann Sebastian Bach",
      "Wolfgang Amadeus Mozart",
      "Ludwig van Beethoven",
    ],
    answer: "Johann Sebastian Bach",
    explanation:
        "La \"Messe en si mineur\" est l'une des œuvres majeures de Johann Sebastian Bach, une pièce baroque monumentale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel artiste a popularisé la chanson \"Umbrella\" ?",
    options: ["Rihanna", "Beyoncé", "Lady Gaga"],
    answer: "Rihanna",
    explanation:
        "Rihanna a connu un énorme succès avec sa chanson \"Umbrella\", sortie en 2007.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est souvent utilisé dans le rock progressif ?",
    options: ["Orgues", "Synthétiseur", "Guitare électrique"],
    answer: "Synthétiseur",
    explanation:
        "Le synthétiseur est un instrument clé dans le rock progressif, offrant une palette sonore riche et variée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel genre musical est associé à la ville de Nashville ?",
    options: ["Pop", "Rock", "Country"],
    answer: "Country",
    explanation:
        "Nashville est reconnue comme la capitale de la musique country, attirant de nombreux artistes du genre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre compositeur a écrit \"Les Quatre Saisons\" ?",
    options: [
      "Antonio Vivaldi",
      "Johann Sebastian Bach",
      "Ludwig van Beethoven",
    ],
    answer: "Antonio Vivaldi",
    explanation:
        "\"Les Quatre Saisons\" est un ensemble de concertos pour violon composés par Antonio Vivaldi au 18e siècle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe est connu pour le célèbre album \"Abbey Road\" ?",
    options: ["The Beatles", "The Rolling Stones", "The Who"],
    answer: "The Beatles",
    explanation:
        "\"Abbey Road\" est l'un des albums les plus célèbres du groupe britannique The Beatles, sorti en 1969.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel musicien a popularisé le bluegrass ?",
    options: ["Bill Monroe", "Johnny Cash", "Dolly Parton"],
    answer: "Bill Monroe",
    explanation:
        "Bill Monroe est souvent considéré comme le père du bluegrass, un genre musical américain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel chanteur a coécrit la chanson \"Imagine\" ?",
    options: ["Paul McCartney", "John Lennon", "George Harrison"],
    answer: "John Lennon",
    explanation:
        "\"Imagine\" est une chanson emblématique coécrite par John Lennon, véhiculant un message de paix.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est souvent associé à la culture afro-américaine ?",
    options: ["Pop", "Blues", "Country"],
    answer: "Blues",
    explanation:
        "Le blues est un genre musical qui a des racines profondes dans la culture afro-américaine et a influencé de nombreux styles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre musicien a sorti l'album \"Thriller\" ?",
    options: ["Elton John", "Michael Jackson", "Prince"],
    answer: "Michael Jackson",
    explanation:
        "L'album \"Thriller\" de Michael Jackson, sorti en 1982, est l'album le plus vendu de tous les temps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour ses opéras comme \"La Bohème\" et \"Tosca\" ?",
    options: ["Giacomo Puccini", "Giuseppe Verdi", "Richard Wagner"],
    answer: "Giacomo Puccini",
    explanation:
        "Giacomo Puccini est célèbre pour ses opéras, dont \"La Bohème\" et \"Tosca\", qui sont des classiques du répertoire lyrique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel musicien est réputé pour sa virtuosité à la guitare et son album \"Are You Experienced\" ?",
    options: ["Jimi Hendrix", "Eric Clapton", "Jimmy Page"],
    answer: "Jimi Hendrix",
    explanation:
        "Jimi Hendrix est reconnu pour ses innovations à la guitare et son album emblématique \"Are You Experienced\".",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a composé la célèbre \"Nouvelle Symphonie\" ?",
    options: ["Antonín Dvořák", "Johannes Brahms", "Franz Schubert"],
    answer: "Antonín Dvořák",
    explanation:
        "La \"Nouvelle Symphonie\" (Symphonie n°9) de Dvořák est une œuvre emblématique inspirée par les rythmes africains.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre festival de musique a eu lieu en 1969 ?",
    options: ["Woodstock", "Glastonbury", "Coachella"],
    answer: "Woodstock",
    explanation:
        "Le festival de Woodstock de 1969 est devenu un symbole de la contre-culture et de la musique des années 60.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel style musical mélange le jazz et le rock ?",
    options: ["Blues", "Jazz fusion", "Rock progressif"],
    answer: "Jazz fusion",
    explanation:
        "Le jazz fusion est un genre qui combine des éléments de jazz avec ceux du rock et d'autres styles musicaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre artiste a chanté \"Rolling in the Deep\" ?",
    options: ["Adele", "Beyoncé", "Rihanna"],
    answer: "Adele",
    explanation:
        "\"Rolling in the Deep\" est l'un des succès d'Adele, illustrant son puissant vocal et sa musicalité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur a écrit les \"Clair de Lune\" ?",
    options: ["Claude Debussy", "Frédéric Chopin", "Erik Satie"],
    answer: "Claude Debussy",
    explanation:
        "\"Clair de Lune\" est une célèbre pièce pour piano écrite par Claude Debussy, faisant partie de la Suite Bergamasque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe est connu pour sa chanson \"Sweet Child o' Mine\" ?",
    options: ["Nirvana", "Guns N' Roses", "Metallica"],
    answer: "Guns N' Roses",
    explanation:
        "\"Sweet Child o' Mine\" est un morceau emblématique du groupe Guns N' Roses, sorti en 1987.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour ses symphonies et son œuvre 'La 9ème Symphonie' ?",
    options: [
      "Ludwig van Beethoven",
      "Wolfgang Amadeus Mozart",
      "Johann Sebastian Bach",
    ],
    answer: "Ludwig van Beethoven",
    explanation:
        "Ludwig van Beethoven est célèbre pour sa 9ème Symphonie, qui est une des œuvres majeures de la musique classique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style musical est caractérisé par l'improvisation et les rythmes syncopés ?",
    options: ["Classique", "Jazz", "Rock"],
    answer: "Jazz",
    explanation:
        "Le jazz se distingue par son improvisation et ses rythmes syncopés, le rendant unique et innovant.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe britannique est connu pour ses chansons emblématiques comme 'Hey Jude' et 'Let It Be' ?",
    options: ["The Rolling Stones", "The Beatles", "Led Zeppelin"],
    answer: "The Beatles",
    explanation:
        "The Beatles sont un groupe légendaire, reconnu pour plusieurs succès emblématiques du XXe siècle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument de musique est souvent associé aux concerts classiques ?",
    options: ["Guitare", "Piano", "Batterie"],
    answer: "Piano",
    explanation:
        "Le piano est un instrument clé dans la musique classique, utilisé par de nombreux compositeurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle période musicale suit la période baroque ?",
    options: ["Classique", "Romantique", "Médiévale"],
    answer: "Classique",
    explanation:
        "La période classique suit le baroque, marquant une évolution dans le style musical et la forme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur français est célèbre pour sa chanson 'La Vie en rose' ?",
    options: ["Édith Piaf", "Charles Aznavour", "Johnny Hallyday"],
    answer: "Édith Piaf",
    explanation:
        "Édith Piaf est célèbre pour 'La Vie en rose', qui est devenue un symbole de la chanson française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle est la signification du terme 'concerto' en musique ?",
    options: [
      "Une œuvre pour violon seul",
      "Une composition pour soliste et orchestre",
      "Une suite de danses",
    ],
    answer: "Une composition pour soliste et orchestre",
    explanation:
        "Un concerto est généralement une œuvre écrite pour un soliste accompagné d'un orchestre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom du festival de musique qui se tient chaque été à Paris et met en avant des musiques variées ?",
    options: [
      "Le Printemps de Bourges",
      "La Fête de la musique",
      "Les Eurockéennes",
    ],
    answer: "La Fête de la musique",
    explanation:
        "La Fête de la musique est un événement annuel qui célèbre la musique avec des concerts gratuits dans toute la France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical a vu le jour dans les années 1950 aux États-Unis et mélange blues, country et gospel ?",
    options: ["Rock and Roll", "R&B", "Pop"],
    answer: "Rock and Roll",
    explanation:
        "Le rock and roll a émergé dans les années 1950, incorporant divers styles musicaux américains.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Combien de mouvements composent habituellement une symphonie classique ?",
    options: ["Deux", "Trois", "Quatre"],
    answer: "Quatre",
    explanation:
        "Traditionnellement, une symphonie classique comprend généralement quatre mouvements.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est connu comme le 'Roi du Pop' ?",
    options: ["Elvis Presley", "Michael Jackson", "Prince"],
    answer: "Michael Jackson",
    explanation:
        "Michael Jackson est surnommé le 'Roi du Pop' pour son influence dans le domaine de la musique populaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel musicien est célèbre pour ses concertos pour piano et pour avoir été un enfant prodige ?",
    options: ["Frédéric Chopin", "Wolfgang Amadeus Mozart", "Johannes Brahms"],
    answer: "Wolfgang Amadeus Mozart",
    explanation:
        "Wolfgang Amadeus Mozart, compositeur autrichien, a été un enfant prodige et a écrit de nombreux concertos pour piano.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel instrument à vent est souvent utilisé dans les orchestres symphoniques ?",
    options: ["Saxophone", "Trompette", "Flûte"],
    answer: "Flûte",
    explanation:
        "La flûte est fréquemment utilisée dans les orchestres symphoniques pour ses sonorités délicates.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel type de musique privilégie généralement l'harmonie et les mélodies vocales ?",
    options: ["Musique classique", "Musique électronique", "Musique pop"],
    answer: "Musique classique",
    explanation:
        "La musique classique met l'accent sur l'harmonie et les mélodies écrites pour les voix et les instruments.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a popularisé la musique reggae dans les années 1970 ?",
    options: ["Bob Marley", "Jimmy Cliff", "Peter Tosh"],
    answer: "Bob Marley",
    explanation:
        "Bob Marley est considéré comme le roi du reggae et a propulsé ce genre sur la scène internationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est souvent associé aux festivals de musique en plein air ?",
    options: ["Classique", "Electro", "Folk"],
    answer: "Folk",
    explanation:
        "La musique folk est souvent jouée lors de festivals en plein air, célébrant la culture et la tradition.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est célèbre pour ses ballets comme 'Le Lac des cygnes' ?",
    options: [
      "Igor Stravinsky",
      "Pyotr Ilyich Tchaikovsky",
      "Sergei Prokofiev",
    ],
    answer: "Pyotr Ilyich Tchaikovsky",
    explanation:
        "Tchaikovsky est reconnu pour ses ballets classiques, notamment 'Le Lac des cygnes' et 'Casse-Noisette'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe de rock britannique a sorti l'album 'Dark Side of the Moon' ?",
    options: ["Led Zeppelin", "Pink Floyd", "The Who"],
    answer: "Pink Floyd",
    explanation:
        "Pink Floyd a sorti 'The Dark Side of the Moon', un des albums les plus acclamés de l'histoire du rock.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de la célèbre compétition de violon qui se tient à Genève ?",
    options: [
      "Concours Reine Elizabeth",
      "Concours de Genève",
      "Concours international de violon",
    ],
    answer: "Concours de Genève",
    explanation:
        "Le Concours de Genève est une prestigieuse compétition qui met en avant les talents de violonistes du monde entier.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel courant musical s'est développé dans les années 1980 et est associé à l'utilisation d'outils électroniques ?",
    options: ["Synthpop", "Grunge", "Punk"],
    answer: "Synthpop",
    explanation:
        "La synthpop est un genre musical qui utilise des synthétiseurs et des sons électroniques, courant dans les années 1980.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle est la couleur de l'album 'The White Album' des Beatles ?",
    options: ["Blanc", "Noir", "Rouge"],
    answer: "Blanc",
    explanation:
        "L'album des Beatles surnommé 'The White Album' est entièrement blanc, sans aucune illustration de couverture.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Qui a écrit 'Les Quatre Saisons', une série de concertos pour violon ?",
    options: [
      "Antonio Vivaldi",
      "Johann Sebastian Bach",
      "George Frideric Handel",
    ],
    answer: "Antonio Vivaldi",
    explanation:
        "Antonio Vivaldi a composé 'Les Quatre Saisons', qui sont célèbres pour leur expressivité et leur virtuosité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur est connu pour son style flamboyant et ses spectacles théâtraux, notamment avec 'Bohemian Rhapsody' ?",
    options: ["Freddie Mercury", "David Bowie", "Elton John"],
    answer: "Freddie Mercury",
    explanation:
        "Freddie Mercury, le chanteur de Queen, est réputé pour ses performances énergiques et dramatiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel type de musique est associé à la danse et utilise souvent des rythmes rapides ?",
    options: ["Classique", "Electro", "Salsa"],
    answer: "Salsa",
    explanation:
        "La salsa est un genre musical dynamique et dansant, souvent joué lors de fêtes et de festivals.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est reconnu pour ses œuvres d'avant-garde et son influence sur la musique contemporaine ?",
    options: ["Pierre Boulez", "Claude Debussy", "Igor Stravinsky"],
    answer: "Pierre Boulez",
    explanation:
        "Pierre Boulez est un compositeur et chef d'orchestre connu pour ses contributions à la musique contemporaine et à l'avant-garde.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur français a popularisé la chanson 'Je te promets' ?",
    options: ["Johnny Hallyday", "Daniel Balavoine", "Claude François"],
    answer: "Johnny Hallyday",
    explanation:
        "Johnny Hallyday est célèbre en France pour ses ballades romantiques, dont 'Je te promets'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel style de musique folklorique est associé à la culture irlandaise ?",
    options: ["Celtique", "Flamenco", "Reggae"],
    answer: "Celtique",
    explanation:
        "La musique celtique est profondément enracinée dans la culture irlandaise, avec ses instruments traditionnels comme la harpe et le violon.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle artiste est connue pour son album 'The Fame' qui contient des hits comme 'Poker Face' ?",
    options: ["Beyoncé", "Lady Gaga", "Rihanna"],
    answer: "Lady Gaga",
    explanation:
        "Lady Gaga a gagné en popularité grâce à son album 'The Fame', qui a connu un immense succès commercial.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel musicien est célèbre pour avoir popularisé le blues dans les années 1960 ?",
    options: ["B.B. King", "Muddy Waters", "Eric Clapton"],
    answer: "Eric Clapton",
    explanation:
        "Eric Clapton est renommé pour son influence sur le blues, notamment grâce à des albums comme 'From the Cradle'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe de rock est célèbre pour ses performances live et ses chansons politiques ?",
    options: ["U2", "Nirvana", "Coldplay"],
    answer: "U2",
    explanation:
        "U2 est reconnu pour ses concerts énergiques et ses chansons abordant des thèmes sociaux et politiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre concours de chant se déroule chaque année en Europe et met en compétition différents pays ?",
    options: ["Eurovision", "American Idol", "The Voice"],
    answer: "Eurovision",
    explanation:
        "L'Eurovision est un concours de chant international, mettant en compétition des artistes de divers pays européens.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel rappeur américain est connu pour ses paroles engagées et ses albums à succès comme 'To Pimp a Butterfly' ?",
    options: ["Kendrick Lamar", "Drake", "Jay-Z"],
    answer: "Kendrick Lamar",
    explanation:
        "Kendrick Lamar est reconnu pour ses paroles percutantes et son impact sur le hip-hop contemporain.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre de musique est souvent associé à des instruments comme la guitare acoustique et le banjo ?",
    options: ["Country", "Jazz", "Classique"],
    answer: "Country",
    explanation:
        "La musique country utilise souvent des instruments traditionnels comme la guitare acoustique et le banjo, reflétant la culture américaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre chanteur a coécrit la chanson 'Candle in the Wind' en hommage à Marilyn Monroe ?",
    options: ["Elton John", "Billy Joel", "David Bowie"],
    answer: "Elton John",
    explanation:
        "Elton John a coécrit 'Candle in the Wind' en hommage à Marilyn Monroe devenu ensuite un hommage à Diana.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Dans quel pays la musique flamenco a-t-elle ses origines ?",
    options: ["Espagne", "Portugal", "Italie"],
    answer: "Espagne",
    explanation:
        "Le flamenco est un genre musical et de danse originaire du sud de l'Espagne, représentant la culture andalouse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre album de pink floyd est centré sur la santé mentale ?",
    options: ["The Wall", "Dark Side of the Moon", "Wish You Were Here"],
    answer: "The Wall",
    explanation:
        "L'album 'The Wall' de Pink Floyd aborde les thèmes de l'isolement et de la santé mentale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit la chanson 'Imagine' qui prône la paix ?",
    options: ["John Lennon", "Paul McCartney", "George Harrison"],
    answer: "John Lennon",
    explanation:
        "La chanson 'Imagine' de John Lennon est un hymne à la paix et à l'harmonie mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de l'auteur de la célèbre chanson 'Hallelujah' ?",
    options: ["Leonard Cohen", "Simon & Garfunkel", "David Bowie"],
    answer: "Leonard Cohen",
    explanation:
        "Leonard Cohen a écrit 'Hallelujah', une chanson devenue célèbre grâce à de nombreux artistes qui l'ont reprise.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est caractérisé par des refrains entraînants et des mélodies simples ?",
    options: ["Pop", "Blues", "Classique"],
    answer: "Pop",
    explanation:
        "La musique pop se caractérise par des refrains accrocheurs et des mélodies facilement mémorisables.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est l'interprète de la chanson 'I Will Always Love You' ?",
    options: ["Whitney Houston", "Madonna", "Tina Turner"],
    answer: "Whitney Houston",
    explanation:
        "Whitney Houston est célèbre pour sa version puissante de 'I Will Always Love You', initialement écrite par Dolly Parton.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle est la nationalité du compositeur Claude Debussy ?",
    options: ["Française", "Belge", "Suisse"],
    answer: "Française",
    explanation:
        "Claude Debussy est un compositeur français, connu pour son influence sur la musique impressionniste.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre de musique électronique utilise souvent des samples et des boucles rythmiques ?",
    options: ["House", "Trance", "Techno"],
    answer: "House",
    explanation:
        "La house est un genre de musique électronique reposant sur des samples et des beats répétitifs, souvent dansants.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel artiste a remporté le plus de Grammy Awards dans l'histoire ?",
    options: ["Beyoncé", "Taylor Swift", "Stevie Wonder"],
    answer: "Beyoncé",
    explanation:
        "Beyoncé détient le record du plus grand nombre de Grammy Awards remportés par une artiste, avec un impact considérable sur la musique moderne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le principal instrument de l'orchestre symphonique ?",
    options: ["Piano", "Violon", "Clarinet"],
    answer: "Violon",
    explanation:
        "Le violon est un instrument central dans la musique symphonique, souvent en tête des sections à cordes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est associé à la musique romantique et à l'expression des émotions dans ses compositions ?",
    options: ["Frédéric Chopin", "Johannes Brahms", "Anton Bruckner"],
    answer: "Frédéric Chopin",
    explanation:
        "Frédéric Chopin est un compositeur romantique, connu pour ses œuvres expressives pour piano.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement musical a été influencé par la culture afro-américaine et a évolué dans les années 1920 à Chicago ?",
    options: ["Jazz", "Blues", "R&B"],
    answer: "Jazz",
    explanation:
        "Le jazz a évolué à Chicago dans les années 1920, intégrant divers styles musicaux afro-américains.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe a connu un succès mondial avec sons album 'A Night at the Opera' ?",
    options: ["Pink Floyd", "Queen", "The Beatles"],
    answer: "Queen",
    explanation:
        "Queen a acquis une renommée mondiale avec 'A Night at the Opera', qui contient le classique 'Bohemian Rhapsody.'",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre compositeur a écrit la symphonie 'Sur le Danube bleu' ?",
    options: [
      "Johann Strauss II",
      "Ludwig van Beethoven",
      "Wolfgang Amadeus Mozart",
    ],
    answer: "Johann Strauss II",
    explanation:
        "Cette œuvre emblématique a été composée par Johann Strauss II, souvent appelé le 'roi de la valse'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quelle est la période de la musique baroque ?",
    options: ["1500-1750", "1600-1750", "1700-1800"],
    answer: "1600-1750",
    explanation:
        "La période baroque est généralement considérée comme s'étendant de 1600 à 1750.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est l'interprète de la chanson 'La Vie en rose' ?",
    options: ["Édith Piaf", "Charles Aznavour", "Juliette Gréco"],
    answer: "Édith Piaf",
    explanation:
        "Édith Piaf est l'artiste emblématique qui a popularisé 'La Vie en rose' dans les années 1940.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est souvent associé au jazz ?",
    options: ["Piano", "Violon", "Saxophone"],
    answer: "Saxophone",
    explanation:
        "Le saxophone est un instrument clé dans le jazz, souvent utilisé dans les solos improvisés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le nom du chanteur principal du groupe The Beatles ?",
    options: ["Mick Jagger", "Paul McCartney", "John Lennon"],
    answer: "John Lennon",
    explanation:
        "John Lennon était l'un des membres fondateurs et le chanteur principal des Beatles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle est la principale caractéristique du mouvement romantique en musique ?",
    options: [
      "L'utilisation de la polyphonie",
      "L'expression de l'émotion personnelle",
      "Le respect des formes classiques",
    ],
    answer: "L'expression de l'émotion personnelle",
    explanation:
        "Le romantisme musical met l'accent sur l'expression des émotions individuelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur est connu pour ses 'Concertos pour piano' ?",
    options: ["Frédéric Chopin", "Claude Debussy", "Johannes Brahms"],
    answer: "Frédéric Chopin",
    explanation:
        "Frédéric Chopin est célèbre pour ses concertos pour piano, qui mettent en valeur la virtuosité pianistique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le style musical qui a émergé au début du 20e siècle et combine jazz et musique classique ?",
    options: ["Funk", "Jazz fusion", "Blues"],
    answer: "Jazz fusion",
    explanation:
        "Le jazz fusion mélange des éléments de jazz avec ceux de la musique classique et d'autres genres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Qui a été le premier musicien à obtenir un disque d'or pour un album en France ?",
    options: ["Joe Dassin", "Édith Piaf", "Dalida"],
    answer: "Dalida",
    explanation:
        "Dalida a été la première artiste à recevoir un disque d'or en France pour ses ventes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel mouvement musical est associé à la lutte pour les droits civiques aux États-Unis ?",
    options: ["Le rock'n'roll", "Le folk", "Le blues"],
    answer: "Le blues",
    explanation:
        "Le blues est souvent lié à l'expression des luttes et des injustices des Afro-Américains durant les droits civiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur est connu comme le 'roi de l'opérette' ?",
    options: ["Jacques Offenbach", "Giacomo Puccini", "Giuseppe Verdi"],
    answer: "Jacques Offenbach",
    explanation:
        "Jacques Offenbach est célèbre pour ses opérettes légères et amusantes du 19e siècle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit le célèbre 'Boléro' ?",
    options: ["Maurice Ravel", "Igor Stravinsky", "Gabriel Fauré"],
    answer: "Maurice Ravel",
    explanation:
        "Le 'Boléro' a été composé par Maurice Ravel en 1928 et est célèbre pour sa progression répétitive.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel genre musical est souvent associé à Elvis Presley ?",
    options: ["Rock", "Pop", "Country"],
    answer: "Rock",
    explanation:
        "Elvis Presley est souvent considéré comme le 'roi du rock' en raison de son impact sur le genre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Qui a composé la 'Ninth Symphony', connue pour l'Hymne à la Joie ?",
    options: ["Ludwig van Beethoven", "Franz Schubert", "Richard Wagner"],
    answer: "Ludwig van Beethoven",
    explanation:
        "La 'Ninth Symphony', composée par Beethoven, est célèbre pour son chœur final qui célèbre la fraternité humaine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel artiste est connu pour son album 'Thriller' ?",
    options: ["Prince", "Michael Jackson", "Madonna"],
    answer: "Michael Jackson",
    explanation:
        "'Thriller' est l'album le plus vendu de tous les temps, interprété par Michael Jackson.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle technique musicale consiste à jouer plusieurs notes simultanément ?",
    options: ["Melodie", "Harmonie", "Rythme"],
    answer: "Harmonie",
    explanation:
        "L'harmonie désigne la combinaison de plusieurs notes jouées ou chantées en même temps.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le terme pour désigner un compositeur de musique classique vivant aujourd'hui ?",
    options: ["Contemporain", "Baroque", "Romantique"],
    answer: "Contemporain",
    explanation:
        "Un compositeur contemporain est un musicien qui compose de la musique aujourd'hui.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui est le compositeur de la célèbre 'Sérénade à la nuit' ?",
    options: ["Franz Schubert", "Wolfgang Amadeus Mozart", "Johann Strauss I"],
    answer: "Wolfgang Amadeus Mozart",
    explanation:
        "Mozart a composé la 'Sérénade à la nuit', mettant en valeur son style classique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel groupe de rock a sorti l'album 'The Dark Side of the Moon' ?",
    options: ["Led Zeppelin", "Pink Floyd", "The Rolling Stones"],
    answer: "Pink Floyd",
    explanation:
        "Pink Floyd est connu pour 'The Dark Side of the Moon', un album emblématique du rock progressif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de la chanteuse qui a popularisé le morceau 'Someone Like You' ?",
    options: ["Adele", "Beyoncé", "Taylor Swift"],
    answer: "Adele",
    explanation:
        "Adele a connu un immense succès international avec sa chanson 'Someone Like You'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a écrit la musique du film 'Star Wars' ?",
    options: ["Hans Zimmer", "John Williams", "Danny Elfman"],
    answer: "John Williams",
    explanation:
        "John Williams est le compositeur de la musique emblématique de la saga 'Star Wars'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le principal instrument de l'orchestre symphonique ?",
    options: ["Violoncelle", "Flûte", "Piano"],
    answer: "Violoncelle",
    explanation:
        "Le violoncelle est l'un des instruments majeurs de l'orchestre symphonique, jouant des parties mélodiques et harmoniques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical utilise les rythmes africains et s'est développé en Amérique ?",
    options: ["Jazz", "Funk", "Reggae"],
    answer: "Jazz",
    explanation:
        "Le jazz a émergé aux États-Unis en intégrant des rythmes africains et d'autres influences culturelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel opéra de Verdi est basé sur le personnage de Violetta ?",
    options: ["La Traviata", "Nabucco", "Rigoletto"],
    answer: "La Traviata",
    explanation:
        "'La Traviata' est un opéra de Verdi centré sur le personnage tragique de Violetta.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle invention a révolutionné l'enregistrement de la musique au 20e siècle ?",
    options: ["La radio", "Le phonographe", "Le CD"],
    answer: "Le phonographe",
    explanation:
        "Le phonographe a permis l'enregistrement et la reproduction sonore, transformant l'industrie musicale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Qui a popularisé la 'musique grunge' dans les années 1990 ?",
    options: ["Nirvana", "Pearl Jam", "Soundgarden"],
    answer: "Nirvana",
    explanation:
        "Nirvana est le groupe qui a le plus contribué à populariser le mouvement grunge des années 1990.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel compositeur a composé 'Les Quatre Saisons' ?",
    options: [
      "Antonio Vivaldi",
      "Johann Sebastian Bach",
      "George Frideric Handel",
    ],
    answer: "Antonio Vivaldi",
    explanation:
        "Antonio Vivaldi est célèbre pour 'Les Quatre Saisons', une série de concertos pour violon.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel groupe de rock britannique a sorti 'Hotel California' ?",
    options: ["The Eagles", "The Doors", "Led Zeppelin"],
    answer: "The Eagles",
    explanation:
        "'Hotel California' est une chanson emblématique du groupe The Eagles, sortie en 1976.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le terme utilisé pour désigner un style vocal féminin dans le jazz ?",
    options: ["Mezzo-soprano", "Soprano", "Contralto"],
    answer: "Soprano",
    explanation:
        "Dans le jazz, une voix de soprano est souvent utilisée pour interpréter des mélodies aiguës.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom complet de l'artiste connu sous le nom de 'Beyoncé' ?",
    options: [
      "Beyoncé Knowles-Carter",
      "Beyoncé Giselle Knowles",
      "Beyoncé Carter",
    ],
    answer: "Beyoncé Giselle Knowles",
    explanation:
        "Le vrai nom de Beyoncé est Beyoncé Giselle Knowles, qu'elle utilise dans sa carrière musicale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quelle est la principale caractéristique de la musique minimaliste ?",
    options: [
      "Des motifs répétitifs",
      "Des harmonies complexes",
      "Une orchestration élaborée",
    ],
    answer: "Des motifs répétitifs",
    explanation:
        "La musique minimaliste se caractérise par l'utilisation de motifs répétitifs et de variations simples.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre orchestre est basé à Vienne ?",
    options: [
      "L'Orchestre philharmonique de Vienne",
      "L'Orchestre symphonique de Vienne",
      "L'Orchestre national de Vienne",
    ],
    answer: "L'Orchestre philharmonique de Vienne",
    explanation:
        "L'Orchestre philharmonique de Vienne est l'un des orchestres les plus prestigieux du monde.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel genre de musique est associé au festival de Woodstock ?",
    options: ["Rock", "Classique", "R&B"],
    answer: "Rock",
    explanation:
        "Le festival de Woodstock en 1969 a été un événement majeur pour la musique rock et la culture contre-culturelle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est défini par l'utilisation d'instruments électroniques ?",
    options: ["Pop", "Électro", "Soul"],
    answer: "Électro",
    explanation:
        "La musique électro est caractérisée par l'utilisation d'instruments et de sons électroniques pour la composition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur est connu pour ses œuvres dans le style impressionniste ?",
    options: ["Claude Debussy", "Maurice Ravel", "Igor Stravinsky"],
    answer: "Claude Debussy",
    explanation:
        "Claude Debussy est souvent considéré comme le père de l'impressionnisme musical.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel est le nom de l'album le plus vendu de tous les temps ?",
    options: ["Back in Black", "The Dark Side of the Moon", "Thriller"],
    answer: "Thriller",
    explanation:
        "L'album 'Thriller' de Michael Jackson reste l'album le plus vendu de tous les temps dans l'histoire de la musique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel chanteur est célèbre pour sa voix puissante et son influence sur le rock ?",
    options: ["Freddie Mercury", "Jim Morrison", "David Bowie"],
    answer: "Freddie Mercury",
    explanation:
        "Freddie Mercury, le chanteur de Queen, est reconnu pour sa voix puissante et son charisme scénique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le nom de la première femme à remporter un Grammy Award ?",
    options: ["Ella Fitzgerald", "Aretha Franklin", "Billie Holiday"],
    answer: "Ella Fitzgerald",
    explanation:
        "Ella Fitzgerald a été la première femme à remporter un Grammy Award pour son excellence musicale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre festival de musique a lieu en été aux États-Unis et a été un symbole de la culture des années 1960 ?",
    options: ["Lollapalooza", "Woodstock", "Coachella"],
    answer: "Woodstock",
    explanation:
        "Le festival de Woodstock est un symbole emblématique de la contre-culture des années 1960.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel célèbre compositeur a créé le ballet 'Casse-Noisette' ?",
    options: ["Tchaïkovski", "Stravinsky", "Prokofiev"],
    answer: "Tchaïkovski",
    explanation:
        "Tchaïkovski est le compositeur du ballet 'Casse-Noisette', très apprécié pendant les fêtes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel est le style de musique né dans les années 1980 qui combine des éléments de hip-hop et de musique électronique ?",
    options: ["Electro-pop", "Rap", "New wave"],
    answer: "Electro-pop",
    explanation:
        "L'électro-pop est un genre musical qui combine des éléments de hip-hop avec des sons électroniques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel célèbre musicien est connu pour avoir été à la tête du mouvement de la soul music ?",
    options: ["Marvin Gaye", "Ray Charles", "Otis Redding"],
    answer: "Marvin Gaye",
    explanation:
        "Marvin Gaye est une figure emblématique de la soul music, influençant de nombreux artistes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question: "Quel instrument est au centre d'un orchestre symphonique ?",
    options: ["Guitare", "Piano", "Violoncelle"],
    answer: "Piano",
    explanation:
        "Le piano joue un rôle central dans l'orchestre symphonique, souvent en tant qu'instrument soliste.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel événement mondial célèbre la musique chaque année en juin ?",
    options: [
      "La Journée de la musique",
      "Le Festival de Cannes",
      "Le Concours de Eurovision",
    ],
    answer: "La Journée de la musique",
    explanation:
        "La Journée de la musique est célébrée chaque année en juin pour promouvoir l'art musical dans le monde entier.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel type de musique utilise des percussions et des chants traditionnels africains ?",
    options: ["Gospel", "Afrobeats", "Jazz"],
    answer: "Afrobeats",
    explanation:
        "L'Afrobeats intègre des éléments de musique traditionnelle africaine, notamment des percussions et des chants.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel compositeur a écrit la 'Cinquième Symphonie' connue pour son célèbre motif d'ouverture ?",
    options: ["Dmitri Shostakovich", "Ludwig van Beethoven", "Johannes Brahms"],
    answer: "Ludwig van Beethoven",
    explanation:
        "La 'Cinquième Symphonie' de Beethoven est célèbre pour son motif d'ouverture reconnaissable.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Arts (Musique)",
    question:
        "Quel genre musical est caractérisé par des balades et des rythme lent ?",
    options: ["Soul", "Rap", "Punk"],
    answer: "Soul",
    explanation:
        "La soul music est connue pour ses balades émotionnelles et ses rythmes lents.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizCultureGeneraleMusique extends StatefulWidget {
  static const String routeName = '/gpx_exam/concours/culture_generale_musique';
  final String uid;
  final String email;

  const QuizCultureGeneraleMusique({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCultureGeneraleMusique> createState() =>
      _QuizCultureGeneraleMusiqueState();
}

class _QuizCultureGeneraleMusiqueState extends State<QuizCultureGeneraleMusique>
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
        ? questionCultureMusique
        : questionCultureMusique
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
            'module_name': 'Culture générale',
            'quiz_name': 'Quiz culture générale musique',
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
      await _sb.from('quiz_culture_generale_musique_pages').insert({
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
      debugPrint('❌ quiz_culture_generale_musique_pages insert failed: $e');
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
