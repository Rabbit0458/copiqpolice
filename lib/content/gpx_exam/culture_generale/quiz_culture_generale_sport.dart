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

final List<QuizQuestion> questionCultureSport = [
  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a remporté le plus de médailles d'or aux Jeux Olympiques ?",
    options: ["Michael Phelps", "Usain Bolt", "Carl Lewis"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps détient le record avec 23 médailles d'or aux JO.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est le plus pratiqué dans le monde ?",
    options: ["Basketball", "Football", "Tennis"],
    answer: "Football",
    explanation:
        "Le football est reconnu comme le sport le plus populaire et le plus pratiqué au monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel entraîneur a remporté le plus de titres en Ligue des Champions ?",
    options: ["Carlo Ancelotti", "Pep Guardiola", "Alex Ferguson"],
    answer: "Carlo Ancelotti",
    explanation:
        "Carlo Ancelotti a remporté 4 titres en Ligue des Champions, un record.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport utilise une raquette et une balle jaune ?",
    options: ["Badminton", "Tennis", "Squash"],
    answer: "Tennis",
    explanation:
        "Le tennis se joue avec une raquette et une balle jaune sur un court.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est le champion du monde de Formule 1 2021 ?",
    options: ["Lewis Hamilton", "Max Verstappen", "Sebastian Vettel"],
    answer: "Max Verstappen",
    explanation:
        "Max Verstappen a été couronné champion du monde de F1 en 2021.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le terme pour désigner le dernier tour d'une course ?",
    options: ["Laps", "Sprint", "Finale"],
    answer: "Laps",
    explanation: "Le terme 'laps' désigne le nombre de tours dans une course.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté le Golden Boot lors de la Coupe du Monde 2018 ?",
    options: ["Harry Kane", "Cristiano Ronaldo", "Kylian Mbappé"],
    answer: "Harry Kane",
    explanation:
        "Harry Kane a été le meilleur buteur de la Coupe du Monde 2018.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport se joue sur un terrain avec des buts et un ballon rond ?",
    options: ["Rugby", "Handball", "Football"],
    answer: "Football",
    explanation:
        "Le football se joue avec un ballon rond sur un terrain avec des buts.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre tournoi de tennis disputé à Londres chaque année ?",
    options: ["Roland-Garros", "Wimbledon", "US Open"],
    answer: "Wimbledon",
    explanation:
        "Wimbledon est le tournoi de tennis prestigieux qui se déroule à Londres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel célèbre boxeur américain est connu pour avoir remporté 50 combats sans défaite ?",
    options: ["Floyd Mayweather", "Mike Tyson", "Manny Pacquiao"],
    answer: "Floyd Mayweather",
    explanation:
        "Floyd Mayweather est célèbre pour son record de 50 victoires en boxe sans défaite.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le pays d'origine du cyclisme sur route ?",
    options: ["France", "Italie", "Royaume-Uni"],
    answer: "France",
    explanation:
        "Le cyclisme sur route a émergé en France à la fin du 19ème siècle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la durée d'un match de football professionnel ?",
    options: ["70 minutes", "90 minutes", "80 minutes"],
    answer: "90 minutes",
    explanation:
        "Un match de football professionnel se joue en deux mi-temps de 45 minutes chacune, totalisant 90 minutes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est associé à une planche et des vagues ?",
    options: ["Surf", "Kitesurf", "Skateboard"],
    answer: "Surf",
    explanation:
        "Le surf est un sport nautique pratiqué sur des vagues avec une planche.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du jeu dans le basketball ?",
    options: ["Marquer des paniers", "Dribbler", "Passer la balle"],
    answer: "Marquer des paniers",
    explanation:
        "Le but principal du basketball est de marquer des paniers en lançant le ballon dans le cerceau.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition de football des clubs européens ?",
    options: ["Ligue des Champions", "Europa League", "Coupe de la Ligue"],
    answer: "Ligue des Champions",
    explanation:
        "La Ligue des Champions est la compétition de football la plus prestigieuse pour les clubs européens.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a remporté le plus de médailles aux Jeux Olympiques d'été ?",
    options: ["Russie", "États-Unis", "Chine"],
    answer: "États-Unis",
    explanation:
        "Les États-Unis détiennent le record du plus grand nombre de médailles aux JO d'été.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la danse traditionnelle qui accompagne souvent les matchs de rugby en Nouvelle-Zélande ?",
    options: ["Samba", "Haka", "Cumbia"],
    answer: "Haka",
    explanation:
        "Le haka est une danse traditionnelle néo-zélandaise exécutée avant les matchs de rugby.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport qui se joue en équipe avec un batteur et un lanceur ?",
    options: ["Baseball", "Softball", "Cricket"],
    answer: "Baseball",
    explanation:
        "Le baseball est un sport d'équipe qui oppose un batteur et un lanceur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le terme utilisé pour désigner un athlète qui excelle dans plusieurs sports ?",
    options: ["Polyvalent", "Omni-sport", "Multi-sport"],
    answer: "Multi-sport",
    explanation:
        "Un athlète multi-sport excelle dans plusieurs disciplines sportives.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de l'événement sportif appelé 'les Jeux Olympiques d'hiver' ?",
    options: [
      "Jeux Olympiques",
      "Jeux de la Francophonie",
      "Jeux Panaméricains",
    ],
    answer: "Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques d'hiver se déroulent tous les quatre ans et mettent en avant des sports d'hiver.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du sport où les athlètes s'affrontent sur des patins à roulettes ?",
    options: ["Roller Derby", "Hockey sur glace", "Patinage artistique"],
    answer: "Roller Derby",
    explanation:
        "Le roller derby est un sport d'équipe pratiqué sur des patins à roulettes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport dans lequel on utilise un slip, un bonnet et une piscine ?",
    options: ["Natation", "Water-polo", "Plongée"],
    answer: "Natation",
    explanation:
        "La natation est un sport aquatique pratiqué en piscine avec un slip et un bonnet.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a remporté la médaille d'or du marathon aux JO de 1960 à Rome ?",
    options: ["Abebe Bikila", "Frank Shorter", "Marcel Hug"],
    answer: "Abebe Bikila",
    explanation:
        "Abebe Bikila a remporté la médaille d'or du marathon aux JO de 1960, courant pieds nus.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport où les joueurs doivent marquer des points en cassant des quilles avec une boule ?",
    options: ["Bowling", "Golf", "Cricket"],
    answer: "Bowling",
    explanation:
        "Le bowling consiste à faire tomber des quilles en lançant une boule sur la piste.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel champion de tennis a remporté le plus de titres du Grand Chelem ?",
    options: ["Roger Federer", "Rafael Nadal", "Novak Djokovic"],
    answer: "Novak Djokovic",
    explanation:
        "Novak Djokovic a récemment établi le record du plus grand nombre de titres du Grand Chelem en simple.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quelle est la discipline sportive qui consiste à monter sur un cheval en sautant des obstacles ?",
    options: ["Equitation", "Saut d'obstacles", "Dressage"],
    answer: "Saut d'obstacles",
    explanation:
        "Le saut d'obstacles est une épreuve d'équitation où le cavalier doit franchir des obstacles avec son cheval.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition internationale de football qui se déroule tous les quatre ans ?",
    options: ["Euro", "Coupe du Monde", "Copa América"],
    answer: "Coupe du Monde",
    explanation:
        "La Coupe du Monde de football est le tournoi international majeur, organisé tous les quatre ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est l'organe principal utilisé pour le tir à l'arc ?",
    options: ["Arc", "Flèche", "Corde"],
    answer: "Arc",
    explanation:
        "L'organe principal du tir à l'arc est l'arc, qui lance les flèches.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est considéré comme le plus ancien ?",
    options: ["Lutte", "Polo", "Course à pied"],
    answer: "Lutte",
    explanation:
        "La lutte est considérée comme l'un des sports les plus anciens au monde, pratiquée depuis l'Antiquité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du championnat de football de premier niveau en Angleterre ?",
    options: ["Premier League", "Championship", "Serie A"],
    answer: "Premier League",
    explanation:
        "La Premier League est le championnat de football de premier niveau en Angleterre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a établi un record du monde en saut à la perche dans les années 90 ?",
    options: ["Sergey Bubka", "Yelena Isinbayeva", "Renaud Lavillenie"],
    answer: "Sergey Bubka",
    explanation:
        "Sergey Bubka a été un pionnier du saut à la perche, établissant plusieurs records du monde dans les années 90.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du tournoi annuel de tennis disputé à Roland-Garros ?",
    options: ["Open de France", "Roland-Garros", "Masters 1000"],
    answer: "Roland-Garros",
    explanation:
        "Roland-Garros est le tournoi de tennis sur terre battue, disputé à Paris chaque printemps.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est le joueur de basketball considéré comme le meilleur de tous les temps ?",
    options: ["Larry Bird", "Kobe Bryant", "Michael Jordan"],
    answer: "Michael Jordan",
    explanation:
        "Michael Jordan est souvent considéré comme le meilleur joueur de basketball de tous les temps.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la danse populaire dans les compétitions de patinage artistique ?",
    options: ["Valse", "Tango", "Danse libre"],
    answer: "Danse libre",
    explanation:
        "La danse libre est un élément central des compétitions de patinage artistique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport qui combine le ski et le tir à la carabine ?",
    options: ["Biathlon", "Ski alpin", "Ski de fond"],
    answer: "Biathlon",
    explanation:
        "Le biathlon combine le ski de fond et le tir à la carabine en une seule épreuve.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel type de chaussures est requis pour jouer au football ?",
    options: ["Baskets", "Chaussons", "Chaussures à crampons"],
    answer: "Chaussures à crampons",
    explanation:
        "Les chaussures à crampons sont spécifiquement conçues pour jouer au football sur terrain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le nom de la plus célèbre course de chevaux au monde ?",
    options: [
      "Derby du Kentucky",
      "Prix de l'Arc de Triomphe",
      "Preakness Stakes",
    ],
    answer: "Derby du Kentucky",
    explanation:
        "Le Derby du Kentucky est l'une des courses de chevaux les plus prestigieuses au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre événement sportif qui réunit des athlètes paralympiques du monde entier ?",
    options: [
      "Jeux Olympiques",
      "Jeux Paralympiques",
      "Jeux de la Francophonie",
    ],
    answer: "Jeux Paralympiques",
    explanation:
        "Les Jeux Paralympiques sont un événement sportif majeur pour les athlètes en situation de handicap.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre tournoi de golf qui a lieu chaque année à Augusta ?",
    options: ["US Open", "British Open", "Masters Tournament"],
    answer: "Masters Tournament",
    explanation:
        "Le Masters Tournament est l'un des tournois de golf les plus prestigieux, organisé à Augusta.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du sport qui se joue avec un volant et un filet ?",
    options: ["Badminton", "Tennis", "Squash"],
    answer: "Badminton",
    explanation:
        "Le badminton se joue avec un volant et un filet, opposant deux équipes ou joueurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le pays qui a remporté le plus de médailles d'or aux Jeux Olympiques d'hiver ?",
    options: ["Canada", "Russie", "Norvège"],
    answer: "Norvège",
    explanation:
        "La Norvège a remporté le plus grand nombre de médailles d'or aux JO d'hiver.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport est associé à la glisse sur la neige avec une planche ?",
    options: ["Ski", "Snowboard", "Luge"],
    answer: "Snowboard",
    explanation:
        "Le snowboard est un sport de glisse sur la neige avec une planche spécifique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel événement sportif a lieu tous les quatre ans et est le plus regardé au monde ?",
    options: ["Coupe du Monde de football", "Jeux Olympiques", "Super Bowl"],
    answer: "Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques sont l'événement sportif le plus regardé à l'échelle mondiale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport qui consiste à grimper des rochers ou des murs artificiels ?",
    options: ["Escalade", "Parkour", "Alpinisme"],
    answer: "Escalade",
    explanation:
        "L'escalade est un sport qui consiste à grimper sur des surfaces verticales ou inclinées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a remporté le plus de médailles d'or aux Jeux Paralympiques ?",
    options: ["Trischa Zorn", "Natalie du Toit", "Michael Edgson"],
    answer: "Trischa Zorn",
    explanation:
        "Trischa Zorn détient le record de médailles d'or aux Jeux Paralympiques.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui détient le record du monde du 100 mètres chez les hommes ?",
    options: ["Usain Bolt", "Carl Lewis", "Jesse Owens"],
    answer: "Usain Bolt",
    explanation:
        "Usain Bolt détient le record du monde du 100 mètres avec un temps de 9,58 secondes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel événement sportif se déroule tous les quatre ans et est considéré comme le plus prestigieux ?",
    options: ["Les Jeux Olympiques", "La Coupe du Monde", "Le Tour de France"],
    answer: "Les Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques sont un événement sportif international majeur qui se déroule tous les quatre ans.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle nation est célèbre pour ses performances en baseball ?",
    options: ["Japon", "Russie", "France"],
    answer: "Japon",
    explanation:
        "Le Japon est reconnu pour son haut niveau de compétition en baseball à l'international.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport le plus populaire aux États-Unis ?",
    options: ["Baseball", "Football américain", "Basket-ball"],
    answer: "Football américain",
    explanation:
        "Le football américain est le sport le plus populaire aux États-Unis, notamment grâce au Super Bowl.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est considéré comme le meilleur joueur de basketball de tous les temps ?",
    options: ["Michael Jordan", "LeBron James", "Kobe Bryant"],
    answer: "Michael Jordan",
    explanation:
        "Michael Jordan est souvent cité comme le meilleur joueur de basketball de tous les temps pour ses accomplissements.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a remporté le plus de fois la Coupe du Monde de football ?",
    options: ["Italie", "Argentine", "Brésil"],
    answer: "Brésil",
    explanation:
        "Le Brésil a remporté la Coupe du Monde de football à cinq reprises, ce qui en fait le pays le plus victorieux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport se joue sur un court avec des raquettes et une balle ?",
    options: ["Tennis", "Golf", "Rugby"],
    answer: "Tennis",
    explanation:
        "Le tennis se joue sur un court avec des raquettes et une balle, opposant deux ou quatre joueurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est le fondateur des Jeux Olympiques modernes ?",
    options: ["Pierre de Coubertin", "Baron de Coubertin", "Jean de Coubertin"],
    answer: "Pierre de Coubertin",
    explanation:
        "Pierre de Coubertin est le fondateur des Jeux Olympiques modernes en 1896.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la célèbre course cycliste qui traverse la France chaque été ?",
    options: ["Tour de France", "Vuelta", "Giro d'Italia"],
    answer: "Tour de France",
    explanation:
        "Le Tour de France est une célèbre course cycliste annuelle qui parcourt la France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté le plus de titres en Formule 1 ?",
    options: ["Michael Schumacher", "Lewis Hamilton", "Ayrton Senna"],
    answer: "Lewis Hamilton",
    explanation:
        "Lewis Hamilton détient le record du plus grand nombre de titres en Formule 1.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a inventé le rugby ?",
    options: ["Angleterre", "France", "Nouvelle-Zélande"],
    answer: "Angleterre",
    explanation:
        "Le rugby a été inventé en Angleterre au XIXe siècle dans des écoles publiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal tournoi de tennis joué à Wimbledon ?",
    options: ["Open d'Australie", "French Open", "Wimbledon"],
    answer: "Wimbledon",
    explanation:
        "Wimbledon est le principal tournoi de tennis jouant sur gazon, considéré comme le plus prestigieux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est souvent considéré comme le plus grand boxeur de tous les temps ?",
    options: ["Mike Tyson", "Muhammad Ali", "Floyd Mayweather"],
    answer: "Muhammad Ali",
    explanation:
        "Muhammad Ali est souvent cité comme le plus grand boxeur en raison de sa carrière exceptionnelle et de son impact culturel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport qui se pratique sur un terrain avec un ballon ovale ?",
    options: ["Rugby", "Tennis", "Golf"],
    answer: "Rugby",
    explanation:
        "Le rugby se joue sur un terrain avec un ballon ovale, opposant deux équipes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est la nageuse la plus médaillée aux Jeux Olympiques ?",
    options: ["Katie Ledecky", "Michael Phelps", "Missy Franklin"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps est le nageur le plus médaillé de l'histoire des Jeux Olympiques avec 28 médailles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport de raquette se joue sur une table ?",
    options: ["Tennis", "Ping-pong", "Badminton"],
    answer: "Ping-pong",
    explanation:
        "Le ping-pong, ou tennis de table, se pratique sur une table avec des raquettes et une petite balle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport principal étudié à l'université de Stanford ?",
    options: ["Football", "Basket-ball", "Natation"],
    answer: "Basket-ball",
    explanation:
        "Le basket-ball est un sport majeur à l'université de Stanford, avec une forte tradition et succès.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a été le premier athlète à franchir la barre des 9 mètres au saut en longueur ?",
    options: ["Bob Beamon", "Jesse Owens", "Carl Lewis"],
    answer: "Bob Beamon",
    explanation:
        "Bob Beamon a été le premier à dépasser les 9 mètres au saut en longueur en 1968.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le principal événement de natation qui se déroulent tous les quatre ans ?",
    options: ["Jeux Olympiques", "Championnat du monde", "Coupe du monde"],
    answer: "Jeux Olympiques",
    explanation:
        "Les épreuves de natation aux Jeux Olympiques sont les plus prestigieuses au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a été le premier à remporter la Coupe du Monde féminine de football ?",
    options: ["États-Unis", "Allemagne", "Norvège"],
    answer: "Norvège",
    explanation:
        "La Norvège a remporté la première Coupe du Monde féminine de football en 1995.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est l'âge minimum pour participer aux Jeux Olympiques ?",
    options: ["14 ans", "16 ans", "18 ans"],
    answer: "14 ans",
    explanation:
        "L'âge minimum pour participer aux Jeux Olympiques est fixé à 14 ans, selon les règles de la plupart des sports.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport collectif le plus populaire en Europe ?",
    options: ["Football", "Basket-ball", "Handball"],
    answer: "Football",
    explanation:
        "Le football est le sport collectif le plus populaire en Europe, avec de nombreux fans et clubs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté les plus grandes victoires au Tour de France ?",
    options: ["Eddy Merckx", "Bernard Hinault", "Lance Armstrong"],
    answer: "Eddy Merckx",
    explanation:
        "Eddy Merckx détient le record de victoires au Tour de France avec cinq titres.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de l'équipe nationale de football de l'Argentine ?",
    options: ["La Albiceleste", "Les Bleus", "La Roja"],
    answer: "La Albiceleste",
    explanation:
        "L'équipe nationale de football de l'Argentine est surnommée 'La Albiceleste', signifiant 'blanc et bleu'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a remporté 8 médailles d'or aux Jeux Olympiques de Pékin en 2008 ?",
    options: ["Michael Phelps", "Usain Bolt", "Carl Lewis"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps a remporté 8 médailles d'or aux Jeux Olympiques de Pékin en 2008, établissant un record.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport de combat d'origine japonaise utilisant des kimonos ?",
    options: ["Judo", "Karate", "Aikido"],
    answer: "Judo",
    explanation:
        "Le judo est un sport de combat d'origine japonaise pratiqué avec des kimonos.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a gagné la Coupe du Monde de football féminine en 2019 ?",
    options: ["États-Unis", "Pays-Bas", "Japon"],
    answer: "États-Unis",
    explanation:
        "Les États-Unis ont remporté la Coupe du Monde de football féminine en 2019 en battant les Pays-Bas en finale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre tournoi de tennis qui se joue sur terre battue à Paris ?",
    options: ["Roland-Garros", "Wimbledon", "US Open"],
    answer: "Roland-Garros",
    explanation:
        "Roland-Garros est le tournoi de tennis majeur se déroulant sur terre battue à Paris.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport oppose deux équipes de six joueurs sur un terrain en herbe ?",
    options: ["Rugby à XV", "Football", "Hockey sur gazon"],
    answer: "Rugby à XV",
    explanation:
        "Le rugby à XV se joue entre deux équipes de six joueurs sur un terrain en herbe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a été le premier joueur à dépasser les 1 000 points dans la NBA ?",
    options: ["Bill Russell", "Kareem Abdul-Jabbar", "Wilt Chamberlain"],
    answer: "Wilt Chamberlain",
    explanation:
        "Wilt Chamberlain a été le premier joueur à dépasser les 1 000 points dans l'histoire de la NBA.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal événement de football européen ?",
    options: ["Ligue des champions", "Euro", "Ligue 1"],
    answer: "Ligue des champions",
    explanation:
        "La Ligue des champions est le principal événement de football au niveau européen.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport nautique consistant à glisser sur l'eau à l'aide d'une planche ?",
    options: ["Surf", "Voile", "Aviron"],
    answer: "Surf",
    explanation:
        "Le surf est un sport nautique où l'on glisse sur les vagues à l'aide d'une planche.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté la Coupe du Monde de rugby en 2019 ?",
    options: ["Nouvelle-Zélande", "Afrique du Sud", "Angleterre"],
    answer: "Afrique du Sud",
    explanation:
        "L'Afrique du Sud a remporté la Coupe du Monde de rugby en 2019 en battant l'Angleterre en finale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le terme utilisé pour désigner l'athlétisme en salle ?",
    options: ["Indoor", "Outdoor", "Athlétisme de salle"],
    answer: "Indoor",
    explanation:
        "Le terme 'indoor' désigne les compétitions d'athlétisme se déroulant en intérieur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre ancien joueur de football argentin, considéré comme l'un des plus grands ?",
    options: ["Diego Maradona", "Lionel Messi", "Gabriel Batistuta"],
    answer: "Diego Maradona",
    explanation:
        "Diego Maradona est reconnu comme l'un des plus grands joueurs de football de tous les temps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se pratique sur un terrain de sable avec un filet ?",
    options: ["Beach-volley", "Football", "Rugby à VII"],
    answer: "Beach-volley",
    explanation:
        "Le beach-volley se pratique sur un terrain de sable, opposant deux équipes de joueurs sur un filet.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est le sportif ayant remporté le plus de médailles d'or aux JO d'été ?",
    options: ["Michael Phelps", "Larisa Latynina", "Paavo Nurmi"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps est le sportif ayant remporté le plus de médailles d'or aux JO d'été, avec 23 médailles d'or.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition de football entre sélections nationales européennes ?",
    options: ["Euro", "Champions League", "Copa America"],
    answer: "Euro",
    explanation:
        "L'Euro est la compétition de football entre sélections nationales d'Europe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est l'âge minimum pour participer aux Jeux olympiques de la jeunesse ?",
    options: ["15 ans", "12 ans", "14 ans"],
    answer: "14 ans",
    explanation:
        "L'âge minimum pour les Jeux olympiques de la jeunesse est fixé à 14 ans.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a remporté la première Coupe du Monde de rugby en 1987 ?",
    options: ["Nouvelle-Zélande", "Australie", "Afrique du Sud"],
    answer: "Nouvelle-Zélande",
    explanation:
        "La Nouvelle-Zélande a remporté la première Coupe du Monde de rugby en 1987.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a été le premier joueur de football à gagner le Ballon d'or ?",
    options: ["Stanley Matthews", "Alfredo Di Stéfano", "Lionel Messi"],
    answer: "Stanley Matthews",
    explanation:
        "Stanley Matthews a été le premier joueur à recevoir le Ballon d'or en 1956.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport qui utilise des chevaux et des bâtons pour marquer des buts ?",
    options: ["Polocrosse", "Polo", "Équitation"],
    answer: "Polo",
    explanation:
        "Le polo est un sport qui se joue à cheval et consiste à marquer des buts avec un bâton.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a gagné la médaille d'or en football aux JO de 2016 ?",
    options: ["Brésil", "Argentine", "Espagne"],
    answer: "Brésil",
    explanation:
        "Le Brésil a remporté la médaille d'or en football aux JO de 2016, battant l'Allemagne en finale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté le championnat d'Europe de football 2016 ?",
    options: ["France", "Portugal", "Espagne"],
    answer: "Portugal",
    explanation:
        "Le Portugal a remporté le championnat d'Europe de football 2016 en battant la France en finale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre tournoi de tennis sur gazon en Grande-Bretagne ?",
    options: ["Wimbledon", "Roland-Garros", "US Open"],
    answer: "Wimbledon",
    explanation:
        "Wimbledon est le tournoi de tennis sur gazon le plus prestigieux en Grande-Bretagne.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a remporté la Coupe du Monde de football 1998 ?",
    options: ["France", "Brésil", "Allemagne"],
    answer: "France",
    explanation:
        "La France a remporté sa première Coupe du Monde en 1998 en battant le Brésil en finale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est connu sous le nom de 'roque' en France ?",
    options: ["Golf", "Tennis", "Pétanque"],
    answer: "Pétanque",
    explanation:
        "La pétanque, parfois appelée 'roque', est un jeu de boules très populaire en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a été le premier joueur à dépasser les 1000 points en NBA ?",
    options: ["Kareem Abdul-Jabbar", "Bill Russell", "Wilt Chamberlain"],
    answer: "Wilt Chamberlain",
    explanation:
        "Wilt Chamberlain a été le premier joueur de la NBA à marquer plus de 1000 points en une saison.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la longueur d'un marathon en kilomètres ?",
    options: ["42.195 km", "40 km", "45 km"],
    answer: "42.195 km",
    explanation: "Un marathon officiel mesure exactement 42,195 kilomètres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est le pays hôte des Jeux Olympiques d'été de 2024 ?",
    options: ["France", "Japon", "États-Unis"],
    answer: "France",
    explanation:
        "Les Jeux Olympiques d'été de 2024 se tiendront à Paris, France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se pratique sur un court avec un filet central ?",
    options: ["Basket-ball", "Tennis", "Badminton"],
    answer: "Tennis",
    explanation:
        "Le tennis se joue sur un court divisé par un filet entre deux joueurs ou équipes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le plus grand championnat de football en Angleterre ?",
    options: ["Premier League", "Championship", "League One"],
    answer: "Premier League",
    explanation:
        "La Premier League est le plus haut niveau de compétition du football anglais.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est associé aux termes 'flèche' et 'tir' ?",
    options: ["Tir à l'arc", "Golf", "Baseball"],
    answer: "Tir à l'arc",
    explanation:
        "Le tir à l'arc utilise des flèches et un arc comme principales équipements.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quelle est la distance d'un sprint classique dans une course d'athlétisme ?",
    options: ["100 mètres", "200 mètres", "400 mètres"],
    answer: "100 mètres",
    explanation: "Le sprint classique en athlétisme est de 100 mètres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est connu pour avoir inventé le judo ?",
    options: ["France", "Japon", "Brésil"],
    answer: "Japon",
    explanation: "Le judo a été créé au Japon par Jigoro Kano en 1882.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel joueur de tennis a été surnommé 'King of Clay' ?",
    options: ["Roger Federer", "Rafael Nadal", "Novak Djokovic"],
    answer: "Rafael Nadal",
    explanation:
        "Rafael Nadal est surnommé 'King of Clay' en raison de ses performances exceptionnelles sur terre battue.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport est représenté par la Fédération Internationale de Luge ?",
    options: ["Ski", "Luge", "Snowboard"],
    answer: "Luge",
    explanation:
        "La luge est le sport d'hiver géré par la Fédération Internationale de Luge.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel joueur de football est souvent considéré comme le meilleur de l'histoire ?",
    options: ["Pelé", "Maradona", "Messi"],
    answer: "Pelé",
    explanation:
        "Pelé est souvent cité comme l'un des meilleurs footballeurs de tous les temps avec de nombreux records.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du tournoi de tennis sur gazon le plus prestigieux ?",
    options: ["Roland-Garros", "Wimbledon", "US Open"],
    answer: "Wimbledon",
    explanation:
        "Wimbledon est considéré comme le tournoi de tennis sur gazon le plus prestigieux au monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel exercice est primordial dans un entraînement de musculation ?",
    options: ["Pompes", "Jogging", "Natation"],
    answer: "Pompes",
    explanation:
        "Les pompes sont un exercice de base essentiel pour renforcer le haut du corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quelle est la nationalité de la légende du football Johan Cruyff ?",
    options: ["Néerlandaise", "Allemande", "Belge"],
    answer: "Néerlandaise",
    explanation: "Johan Cruyff était un footballeur néerlandais emblématique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal objectif dans le basketball ?",
    options: ["Marquer des points", "Arrêter le temps", "Défendre son panier"],
    answer: "Marquer des points",
    explanation:
        "Le principal objectif du basketball est de marquer des points en faisant entrer le ballon dans le panier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "À quelle fréquence doit-on pratiquer une activité sportive pour rester en bonne santé ?",
    options: ["Une fois par semaine", "Chaque jour", "Deux fois par mois"],
    answer: "Chaque jour",
    explanation:
        "Il est recommandé de pratiquer une activité physique modérée chaque jour pour maintenir la santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète est célèbre pour avoir réalisé le premier quadruple saut au patinage artistique ?",
    options: ["Elvis Stojko", "Yuzuru Hanyu", "Kurt Browning"],
    answer: "Kurt Browning",
    explanation:
        "Kurt Browning a été le premier patineur à réaliser un quadruple saut en compétition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel événement sportif a lieu tous les quatre ans et met en compétition les pays du monde entier ?",
    options: ["Les Jeux Olympiques", "La Coupe du Monde", "Le Tour de France"],
    answer: "Les Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques sont un événement international qui se tient tous les quatre ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la hauteur du panier de basketball en mètres ?",
    options: ["2,44 mètres", "3,05 mètres", "2,10 mètres"],
    answer: "3,05 mètres",
    explanation:
        "La hauteur réglementaire d'un panier de basketball est de 3,05 mètres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a remporté le prix du meilleur joueur de football de la FIFA en 2019 ?",
    options: ["Lionel Messi", "Cristiano Ronaldo", "Virgil van Dijk"],
    answer: "Lionel Messi",
    explanation:
        "Lionel Messi a remporté le prix du meilleur joueur de football de la FIFA en 2019.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a remporté le plus de médailles d'or aux Jeux Olympiques d'été ?",
    options: ["États-Unis", "Russie", "Chine"],
    answer: "États-Unis",
    explanation:
        "Les États-Unis ont remporté le plus grand nombre de médailles d'or aux Jeux Olympiques d'été.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se pratique avec des skis sur la neige ?",
    options: ["Ski nautique", "Ski alpin", "Snowboard"],
    answer: "Ski alpin",
    explanation:
        "Le ski alpin est pratiqué sur la neige avec des skis spécialisés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le surnom de la compétition de football entre les pays d'Amérique du Sud ?",
    options: ["Copa America", "Gold Cup", "Euro 2020"],
    answer: "Copa America",
    explanation:
        "La Copa America est le tournoi de football des nations d'Amérique du Sud.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a été le premier homme à avoir couru un marathon en moins de deux heures ?",
    options: ["Eliud Kipchoge", "Haile Gebrselassie", "Dennis Kipruto Kimetto"],
    answer: "Eliud Kipchoge",
    explanation:
        "Eliud Kipchoge a réalisé un marathon en moins de deux heures en 2019, mais ce n'était pas une course officielle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la discipline reine des Jeux Olympiques d'été ?",
    options: ["Athlétisme", "Natation", "Gymnastique"],
    answer: "Athlétisme",
    explanation:
        "L'athlétisme est souvent considéré comme la discipline reine des Jeux Olympiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel mouvement est considéré comme le dribble le plus célèbre au basket ?",
    options: [
      "Dribble croisé",
      "Dribble derrière le dos",
      "Dribble entre les jambes",
    ],
    answer: "Dribble entre les jambes",
    explanation:
        "Le dribble entre les jambes est un mouvement emblématique au basketball, souvent associé à des joueurs comme Allen Iverson.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le nom du célèbre stade de football de Barcelone ?",
    options: ["Camp Nou", "Santiago Bernabéu", "Old Trafford"],
    answer: "Camp Nou",
    explanation:
        "Le Camp Nou est le stade emblématique du FC Barcelone, reconnu pour sa capacité et son ambiance.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le pays d'origine de la danse sportive connue sous le nom de salsa ?",
    options: ["Cuba", "Brésil", "Espagne"],
    answer: "Cuba",
    explanation:
        "La salsa est une danse qui trouve ses racines à Cuba, influencée par des rythmes africains et espagnols.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel club de football a remporté le plus de titres en Ligue des champions de l'UEFA ?",
    options: ["Real Madrid", "AC Milan", "Liverpool"],
    answer: "Real Madrid",
    explanation:
        "Le Real Madrid a remporté un nombre record de titres en Ligue des champions de l'UEFA.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport consiste à grimper sur des surfaces verticales à l'aide de cordes ?",
    options: ["Escalade", "Alpinisme", "Parkour"],
    answer: "Escalade",
    explanation:
        "L'escalade est un sport de montagne qui nécessite des compétences techniques et physiques pour grimper des parois.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quelle sport américain implique des batailles de pouces entre deux personnes ?",
    options: ["Lutte", "Boxe", "Tir à la corde"],
    answer: "Tir à la corde",
    explanation:
        "Le tir à la corde est un sport qui consiste à tirer une corde dans des directions opposées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le principal avantage d'un bon échauffement avant un entraînement ?",
    options: [
      "Améliorer la performance",
      "Réduire les risques de blessure",
      "Augmenter la fatigue",
    ],
    answer: "Réduire les risques de blessure",
    explanation:
        "Un bon échauffement aide à préparer le corps à l'effort et réduit les risques de blessures.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la longueur d'un terrain de football ?",
    options: ["90 à 120 mètres", "70 à 100 mètres", "100 à 130 mètres"],
    answer: "90 à 120 mètres",
    explanation:
        "La longueur d'un terrain de football varie de 90 à 120 mètres selon les règles officielles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le terme utilisé pour désigner un joueur qui marque un but contre son propre camp ?",
    options: ["But contre son camp", "Auto-but", "But personnel"],
    answer: "Auto-but",
    explanation:
        "Un 'auto-but' est le terme utilisé pour désigner un but marqué par un joueur dans son propre but.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a remporté le plus grand nombre de médailles dans l’histoire des Jeux Olympiques ?",
    options: ["Michael Phelps", "Larisa Latynina", "Bjørn Dæhlie"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps détient le record du plus grand nombre de médailles aux Jeux Olympiques avec 28 médailles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la principale compétition de football en Europe ?",
    options: ["Ligue des champions", "Coupe de l'UEFA", "Euro 2020"],
    answer: "Ligue des champions",
    explanation:
        "La Ligue des champions est le tournoi de clubs le plus prestigieux en Europe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le pays d'origine du célèbre catcheur Hulk Hogan ?",
    options: ["États-Unis", "Canada", "Royaume-Uni"],
    answer: "États-Unis",
    explanation:
        "Hulk Hogan est un catcheur américain emblématique des années 80 et 90.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal objectif du badminton ?",
    options: ["Marquer des points", "Éliminer l'adversaire", "Gagner le set"],
    answer: "Marquer des points",
    explanation:
        "Comme dans de nombreux sports, le principal objectif du badminton est de marquer des points.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté le Gold Medal au ski alpin lors des JO de 2014 ?",
    options: ["Bode Miller", "Marcel Hirscher", "Ted Ligety"],
    answer: "Ted Ligety",
    explanation:
        "Ted Ligety a remporté la médaille d'or en ski alpin lors des JO de Sotchi en 2014.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel événement célèbre la lutte entre les pays d'Asie ?",
    options: [
      "Asian Cup",
      "AFC Champions League",
      "Asian Athletics Championships",
    ],
    answer: "Asian Cup",
    explanation:
        "L'Asian Cup est le tournoi de football qui célèbre la lutte entre les nations asiatiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la principale compétition de rugby à XV ?",
    options: ["Six Nations", "Coupe du Monde", "Top 14"],
    answer: "Coupe du Monde",
    explanation:
        "La Coupe du Monde de rugby à XV est la compétition la plus prestigieuse au niveau international.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport national du Canada ?",
    options: ["Hochey sur glace", "Baseball", "Football"],
    answer: "Hochey sur glace",
    explanation:
        "Le hockey sur glace est considéré comme le sport national du Canada.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal objectif du cyclisme sur route ?",
    options: ["Finir la course", "Gagner des points", "Marquer des buts"],
    answer: "Finir la course",
    explanation:
        "Dans le cyclisme sur route, l'objectif principal est de terminer la course le plus rapidement possible.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a remporté la Coupe du Monde de la FIFA 1998 ?",
    options: ["Brésil", "Allemagne", "France"],
    answer: "France",
    explanation:
        "La France a remporté la Coupe du Monde de la FIFA 1998 en battant le Brésil en finale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui détient le record du plus grand nombre de victoires en Formule 1 ?",
    options: ["Michael Schumacher", "Lewis Hamilton", "Ayrton Senna"],
    answer: "Lewis Hamilton",
    explanation:
        "Lewis Hamilton a dépassé Michael Schumacher en nombre de victoires en Formule 1.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quelle discipline sportive fait partie des Jeux Olympiques d'été depuis 1900 ?",
    options: ["Rugby", "Surf", "Tennis"],
    answer: "Tennis",
    explanation:
        "Le tennis a été inclus dans les Jeux Olympiques d'été depuis 1900.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel joueur a marqué le plus de buts en Coupe du Monde de la FIFA ?",
    options: ["Ronaldo", "Gerd Müller", "Marta"],
    answer: "Ronaldo",
    explanation:
        "Ronaldo détient le record des buts marqués en Coupe du Monde de la FIFA avec 15 buts.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la distance d'un marathon en kilomètres ?",
    options: ["21 km", "42 km", "50 km"],
    answer: "42 km",
    explanation: "Un marathon standard mesure 42,195 kilomètres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Combien de joueurs composent une équipe de rugby à XV ?",
    options: ["13", "15", "7"],
    answer: "15",
    explanation:
        "Une équipe de rugby à XV est composée de 15 joueurs sur le terrain.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la première édition des Jeux Olympiques modernes ?",
    options: ["1896", "1900", "1920"],
    answer: "1896",
    explanation:
        "La première édition des Jeux Olympiques modernes a eu lieu à Athènes en 1896.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a remporté la médaille d'or au 100 mètres aux Jeux Olympiques de 2008 ?",
    options: ["Usain Bolt", "Carl Lewis", "Michael Johnson"],
    answer: "Usain Bolt",
    explanation:
        "Usain Bolt a remporté la médaille d'or au 100 mètres aux Jeux Olympiques de Pékin en 2008.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le symbole olympique ?",
    options: [
      "Cinq cercles entrelacés",
      "Un flambeau",
      "Une couronne de laurier",
    ],
    answer: "Cinq cercles entrelacés",
    explanation:
        "Le symbole olympique est constitué de cinq cercles entrelacés représentant les cinq continents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport où les athlètes utilisent une planche à roulettes ?",
    options: ["Ski", "Snowboard", "Skateboard"],
    answer: "Skateboard",
    explanation:
        "Le skateboard est le sport qui utilise une planche dotée de roulettes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel joueur est considéré comme le meilleur basketteur de tous les temps ?",
    options: ["LeBron James", "Kobe Bryant", "Michael Jordan"],
    answer: "Michael Jordan",
    explanation:
        "Michael Jordan est souvent considéré comme le meilleur basketteur de tous les temps.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition annuelle de football interclubs en Europe ?",
    options: [
      "Ligue des champions",
      "Europa League",
      "Coupe du Monde des clubs",
    ],
    answer: "Ligue des champions",
    explanation:
        "La Ligue des champions est la principale compétition de clubs en football en Europe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel pays se déroule le Grand Prix de Monaco ?",
    options: ["France", "Monaco", "Italie"],
    answer: "Monaco",
    explanation:
        "Le Grand Prix de Monaco se déroule dans les rues de la principauté de Monaco.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a organisé les Jeux Olympiques d'hiver en 2014 ?",
    options: ["Russie", "Canada", "Corée du Sud"],
    answer: "Russie",
    explanation:
        "Les Jeux Olympiques d'hiver de 2014 ont eu lieu à Sotchi, en Russie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport est pratiqué au sein d'un court avec des zones de service ?",
    options: ["Tennis", "Badminton", "Squash"],
    answer: "Tennis",
    explanation:
        "Le tennis est pratiqué sur un court avec des zones de service spécifiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel joueur de tennis est surnommé 'Rafa' ?",
    options: ["Roger Federer", "Rafael Nadal", "Novak Djokovic"],
    answer: "Rafael Nadal",
    explanation:
        "Rafael Nadal est souvent appelé 'Rafa' par ses fans et les médias.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a remporté le titre de meilleur footballeur du monde en 2021 selon le Ballon d'Or ?",
    options: ["Lionel Messi", "Cristiano Ronaldo", "Robert Lewandowski"],
    answer: "Lionel Messi",
    explanation: "Lionel Messi a remporté son septième Ballon d'Or en 2021.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du tournoi de tennis joué sur gazon à Wimbledon ?",
    options: ["US Open", "Roland-Garros", "Wimbledon"],
    answer: "Wimbledon",
    explanation:
        "Wimbledon est le tournoi de tennis le plus prestigieux joué sur gazon.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel athlète américain est connu pour ses records en sprint ?",
    options: ["Jesse Owens", "Carl Lewis", "Usain Bolt"],
    answer: "Carl Lewis",
    explanation:
        "Carl Lewis a établi plusieurs records mondiaux en sprint et en saut en longueur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la danse sportive qui se pratique en couple ?",
    options: ["Salsa", "Ballroom", "Hip-hop"],
    answer: "Ballroom",
    explanation:
        "La danse de salon, ou 'Ballroom', est une danse sportive pratiquée par des couples.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se joue avec un volant et une raquette ?",
    options: ["Badminton", "Golf", "Tennis de table"],
    answer: "Badminton",
    explanation:
        "Le badminton est un sport de raquette qui se joue avec un volant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté le titre de champion de la NBA en 2020 ?",
    options: ["Los Angeles Lakers", "Miami Heat", "Golden State Warriors"],
    answer: "Los Angeles Lakers",
    explanation:
        "Les Los Angeles Lakers ont remporté le titre de la NBA en 2020.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but d'une partie de football ?",
    options: [
      "Marquer des points",
      "Marquer des buts",
      "Avoir le plus de passes possibles",
    ],
    answer: "Marquer des buts",
    explanation:
        "Le but d'une partie de football est de marquer le plus de buts possible.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel coureur a remporté le Tour de France à vélo en 2019 ?",
    options: ["Egan Bernal", "Chris Froome", "Geraint Thomas"],
    answer: "Egan Bernal",
    explanation:
        "Egan Bernal a remporté le Tour de France en 2019, devenant le plus jeune vainqueur depuis 1909.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition de football la plus prestigieuse au niveau club ?",
    options: ["Ligue 1", "Liga", "Ligue des champions"],
    answer: "Ligue des champions",
    explanation:
        "La Ligue des champions est considérée comme la compétition de football la plus prestigieuse au niveau des clubs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est surnommé 'La bête noire' dans le cyclisme ?",
    options: ["Eddy Merckx", "Bernard Hinault", "Fausto Coppi"],
    answer: "Bernard Hinault",
    explanation:
        "Bernard Hinault est surnommé 'La bête noire' en raison de ses performances redoutables sur le vélo.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport de combat utilise des gants et se pratique sur un ring ?",
    options: ["Karate", "Boxe", "Judo"],
    answer: "Boxe",
    explanation:
        "La boxe est un sport de combat qui se pratique sur un ring avec des gants.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel événement sportif regroupe les meilleures équipes de football d'Amérique du Sud ?",
    options: ["Copa América", "Champions League", "Euro 2020"],
    answer: "Copa América",
    explanation:
        "La Copa América est le tournoi de football réunissant les meilleures équipes d'Amérique du Sud.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport où l'on pratique le saut à ski ?",
    options: ["Ski alpin", "Ski de fond", "Saut à ski"],
    answer: "Saut à ski",
    explanation:
        "Le saut à ski est un sport qui consiste à sauter sur une rampe et atterrir sur la neige.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal tournoi de tennis en France ?",
    options: ["Roland-Garros", "Wimbledon", "US Open"],
    answer: "Roland-Garros",
    explanation:
        "Roland-Garros est le principal tournoi de tennis qui se déroule chaque année en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport voit-on des athlètes utiliser un archet ?",
    options: ["Tir à l'arc", "Escrime", "Athlétisme"],
    answer: "Tir à l'arc",
    explanation:
        "Le tir à l'arc est une discipline qui utilise un archet pour tirer des flèches.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est le footballeur français surnommé 'Platini' ?",
    options: ["Zinedine Zidane", "Michel Platini", "Thierry Henry"],
    answer: "Michel Platini",
    explanation:
        "Michel Platini est un ancien footballeur français, considéré comme l'un des meilleurs de son époque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport est pratiqué avec un cercle et un ballon dans l'eau ?",
    options: ["Water-polo", "Natation synchronisée", "Aqua fitness"],
    answer: "Water-polo",
    explanation:
        "Le water-polo est un sport d'équipe joué dans l'eau avec un ballon.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le record du monde du 100 mètres masculin (2021) ?",
    options: ["9,58 secondes", "9,69 secondes", "9,84 secondes"],
    answer: "9,58 secondes",
    explanation:
        "Le record du monde du 100 mètres masculin est de 9,58 secondes, établi par Usain Bolt.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre festival de musique organisé chaque année à Coachella ?",
    options: ["Lollapalooza", "Coachella", "Glastonbury"],
    answer: "Coachella",
    explanation:
        "Le festival de Coachella est un événement musical majeur qui a lieu chaque année en Californie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la course de voile qui se déroule entre Monaco et Saint-Tropez ?",
    options: ["Route du Rhum", "Transpacific Yacht Race", "Copa América"],
    answer: "Route du Rhum",
    explanation:
        "La Route du Rhum est une célèbre course de voile qui relie la France aux Antilles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le nombre de joueurs dans une équipe de handball ?",
    options: ["5", "7", "9"],
    answer: "7",
    explanation:
        "Une équipe de handball est composée de 7 joueurs sur le terrain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a remporté la médaille d'or au saut en longueur aux Jeux Olympiques de 1968 ?",
    options: ["Bob Beamon", "Carl Lewis", "Jesse Owens"],
    answer: "Bob Beamon",
    explanation:
        "Bob Beamon a établi un record du monde au saut en longueur aux Jeux Olympiques de 1968.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est associé à la figure emblématique de Pelé ?",
    options: ["Rugby", "Basket-ball", "Football"],
    answer: "Football",
    explanation:
        "Pelé est une légende du football, connu pour ses performances exceptionnelles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du tournoi de tennis qui se joue chaque année en Australie ?",
    options: ["Australian Open", "Wimbledon", "Roland-Garros"],
    answer: "Australian Open",
    explanation:
        "L'Australian Open est le tournoi de tennis qui se tient chaque année en Australie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est le champion du monde de football en 2022 ?",
    options: ["France", "Argentine", "Brésil"],
    answer: "Argentine",
    explanation:
        "L'Argentine a remporté la Coupe du Monde de la FIFA 2022 au Qatar.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Dans quel sport utilise-t-on un 'sapin' pour les épreuves de ski ?",
    options: ["Ski alpin", "Ski de fond", "Saut à ski"],
    answer: "Saut à ski",
    explanation:
        "Un 'sapin' est un terme utilisé dans le saut à ski pour désigner une plateforme de saut.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition de football regroupant les sélections nationales des pays européens ?",
    options: ["Euro 2020", "Copa América", "Ligue des champions"],
    answer: "Euro 2020",
    explanation:
        "L'Euro 2020 est le championnat de football d'Europe pour les équipes nationales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport où se déroulent des matchs en six sets ?",
    options: ["Tennis", "Badminton", "Volley-ball"],
    answer: "Volley-ball",
    explanation:
        "Le volley-ball se joue souvent en sets, avec un nombre de sets variant selon les formats de compétition.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de l'équipe nationale de football de l'Espagne ?",
    options: ["La Roja", "Les Bleus", "La Verde"],
    answer: "La Roja",
    explanation:
        "L'équipe nationale de football d'Espagne est surnommée 'La Roja', signifiant 'la rouge'.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est considéré comme le plus grand sprinter de tous les temps ?",
    options: ["Michael Johnson", "Usain Bolt", "Carl Lewis"],
    answer: "Usain Bolt",
    explanation:
        "Usain Bolt détient le record du monde du 100 mètres et du 200 mètres, consolidant sa réputation de sprinter exceptionnel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a remporté la première Coupe d'Europe des Nations de football en 1960 ?",
    options: ["URSS", "Espagne", "France"],
    answer: "URSS",
    explanation:
        "L'URSS a été la première nation à remporter la Coupe d'Europe des Nations en 1960.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport utilise-t-on un 'puck' ?",
    options: ["Hockey sur glace", "Lacrosse", "Rugby"],
    answer: "Hockey sur glace",
    explanation:
        "Le 'puck' est utilisé dans le hockey sur glace comme objet à frapper pour marquer des buts.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Combien de joueurs y a-t-il dans une équipe de rugby ?",
    options: ["11", "15", "13"],
    answer: "15",
    explanation:
        "Une équipe de rugby à XV est composée de 15 joueurs sur le terrain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le symbole des Jeux Olympiques ?",
    options: ["Des anneaux entrelacés", "Une flamme", "Une médaille"],
    answer: "Des anneaux entrelacés",
    explanation:
        "Les cinq anneaux entrelacés représentent les cinq continents participant aux Jeux Olympiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le record du monde du 100 mètres homme ?",
    options: ["9.58 secondes", "10.01 secondes", "9.63 secondes"],
    answer: "9.58 secondes",
    explanation:
        "Le record du monde actuel du 100 mètres masculin est de 9.58 secondes, établi par Usain Bolt en 2009.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la discipline sportive la plus pratiquée au monde ?",
    options: ["Football", "Basket-ball", "Tennis"],
    answer: "Football",
    explanation:
        "Le football est considéré comme le sport le plus pratiqué et populaire au monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quelle est la durée d'un match de football professionnel régulier ?",
    options: ["90 minutes", "80 minutes", "100 minutes"],
    answer: "90 minutes",
    explanation:
        "Un match de football se joue en deux périodes de 45 minutes, totalisant 90 minutes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel joueur de tennis a remporté le plus de titres du Grand Chelem ?",
    options: ["Roger Federer", "Rafael Nadal", "Novak Djokovic"],
    answer: "Novak Djokovic",
    explanation:
        "Novak Djokovic détient le record du plus grand nombre de titres du Grand Chelem en simple masculin.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport est pratiqué lors des Tournois du Grand Chelem à Wimbledon ?",
    options: ["Tennis", "Golf", "Badminton"],
    answer: "Tennis",
    explanation:
        "Wimbledon est l'un des quatre tournois du Grand Chelem de tennis, connu pour son gazon.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté les Jeux Olympiques d'été de 2008 en natation ?",
    options: ["Michael Phelps", "Ryan Lochte", "Mark Spitz"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps a remporté huit médailles d'or aux Jeux Olympiques d'été de 2008 à Pékin.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel pays se dérouleront les Jeux Olympiques de 2024 ?",
    options: ["Tokyo", "Los Angeles", "Parc Olympique de Londres"],
    answer: "Los Angeles",
    explanation: "Los Angeles accueillera les Jeux Olympiques d'été de 2024.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal championnat de football en Angleterre ?",
    options: ["La Liga", "Bundesliga", "Premier League"],
    answer: "Premier League",
    explanation:
        "La Premier League est le championnat de football le plus prestigieux d'Angleterre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est la seule athlète à avoir remporté le marathon de Boston cinq fois ?",
    options: ["Kara Goucher", "Shalane Flanagan", "Patricia McCormick"],
    answer: "Shalane Flanagan",
    explanation:
        "Shalane Flanagan a remporté le marathon de Boston en 2017, devenant la première femme à le gagner après 33 ans d'attente.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition annuelle de football entre clubs européens ?",
    options: ["Ligue des champions", "Coupe UEFA", "Ligue Europa"],
    answer: "Ligue des champions",
    explanation:
        "La Ligue des champions est la compétition la plus prestigieuse entre clubs de football européens.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport se joue avec une balle et un filet, le long d'un court ?",
    options: ["Tennis", "Squash", "Ping-pong"],
    answer: "Tennis",
    explanation:
        "Le tennis se joue sur un court avec une balle et un filet séparant les deux côtés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre marathon qui a lieu chaque année à New York ?",
    options: [
      "Marathon de Boston",
      "Marathon de Paris",
      "Marathon de New York",
    ],
    answer: "Marathon de New York",
    explanation:
        "Le Marathon de New York est l'un des marathons les plus renommés au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est le plus pratiqué en hiver ?",
    options: ["Ski", "Patinage artistique", "Hockey sur glace"],
    answer: "Ski",
    explanation:
        "Le ski est largement pratiqué pendant la saison hivernale dans le monde entier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle équipe est souvent désignée comme les 'All Blacks' ?",
    options: [
      "Équipe de rugby de Nouvelle-Zélande",
      "Équipe de cricket d'Inde",
      "Équipe de basket des États-Unis",
    ],
    answer: "Équipe de rugby de Nouvelle-Zélande",
    explanation:
        "Les All Blacks sont connus pour leur haka et leur domination dans le rugby international.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est le boxeur connu sous le nom de 'Iron Mike' ?",
    options: ["Muhammad Ali", "Mike Tyson", "Floyd Mayweather"],
    answer: "Mike Tyson",
    explanation:
        "Mike Tyson, surnommé 'Iron Mike', est un ancien champion du monde poids lourd en boxe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel événement sportif a lieu tous les quatre ans et célèbre les athlètes de tous les pays ?",
    options: [
      "Jeux Olympiques",
      "Coupe du Monde de Football",
      "Jeux Panaméricains",
    ],
    answer: "Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques rassemblent des athlètes du monde entier tous les quatre ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la distance d'un marathon en kilomètres ?",
    options: ["42.195 km", "40 km", "45 km"],
    answer: "42.195 km",
    explanation:
        "La distance officielle d'un marathon est de 42.195 kilomètres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition de football interclubs d'Amérique du Sud ?",
    options: ["Copa America", "Copa Libertadores", "Copa Sudamericana"],
    answer: "Copa Libertadores",
    explanation:
        "La Copa Libertadores est le tournoi de football le plus prestigieux d'Amérique du Sud.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport utilise des raquettes et des volants ?",
    options: ["Tennis", "Badminton", "Squash"],
    answer: "Badminton",
    explanation:
        "Le badminton se joue avec des raquettes et un volant, souvent sur un court divisé par un filet.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a été le premier à franchir les 4 minutes au mile ?",
    options: ["Roger Bannister", "Jim Ryun", "Hicham El Guerrouj"],
    answer: "Roger Bannister",
    explanation: "Roger Bannister a réalisé cet exploit historique en 1954.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est connu pour être le berceau du judo ?",
    options: ["Japon", "Corée", "Chine"],
    answer: "Japon",
    explanation:
        "Le judo a été créé au Japon par Jigoro Kano à la fin du XIXe siècle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport utilise-t-on un trampoline ?",
    options: ["Gymnastique", "Saut en hauteur", "Basket-ball"],
    answer: "Gymnastique",
    explanation:
        "Le trampoline est une discipline gymnastique où les athlètes effectuent des sauts et des acrobaties.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre tournoi de tennis sur gazon en Angleterre ?",
    options: ["US Open", "Roland-Garros", "Wimbledon"],
    answer: "Wimbledon",
    explanation:
        "Wimbledon est le tournoi de tennis le plus ancien et prestigieux au monde, joué sur gazon.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est l'athlète le plus médaillé des Jeux Olympiques d'été ?",
    options: ["Michael Phelps", "Larisa Latynina", "Bjørn Dæhlie"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps détient le plus grand nombre de médailles aux Jeux Olympiques d'été avec 28 médailles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport où l'on utilise une planche pour se déplacer sur l'eau ?",
    options: ["Surf", "Kayak", "Planche à voile"],
    answer: "Surf",
    explanation:
        "Le surf consiste à utiliser une planche pour glisser sur les vagues de l'océan.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom des jeux d'hiver qui se déroulent tous les quatre ans ?",
    options: [
      "Jeux Olympiques d'hiver",
      "Jeux Panaméricains",
      "Coupe du Monde de ski",
    ],
    answer: "Jeux Olympiques d'hiver",
    explanation:
        "Les Jeux Olympiques d'hiver sont organisés tous les quatre ans et comprennent des sports d'hiver.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a accueilli les Jeux Olympiques de 2016 ?",
    options: ["Brésil", "Royaume-Uni", "Chine"],
    answer: "Brésil",
    explanation:
        "Le Brésil a accueilli les Jeux Olympiques d'été de 2016 à Rio de Janeiro.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport qui utilise des chevaux et des obstacles ?",
    options: ["Saut d'obstacles", "Course de chevaux", "Polo"],
    answer: "Saut d'obstacles",
    explanation:
        "Le saut d'obstacles est une compétition équestre où les cavaliers franchissent des obstacles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a établi le record du monde du 200 mètres nage libre en 2021 ?",
    options: ["Caeleb Dressel", "Kyle Chalmers", "César Cielo"],
    answer: "Caeleb Dressel",
    explanation:
        "Caeleb Dressel a établi le record au championnat du monde de natation 2021.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal tournoi de golf masculin au monde ?",
    options: ["The Masters", "US Open", "British Open"],
    answer: "The Masters",
    explanation:
        "The Masters est l'un des quatre tournois majeurs en golf et se tient chaque année à Augusta, en Géorgie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport représenté par le logo avec une silhouette en pleine action et une raquette ?",
    options: ["Tennis", "Badminton", "Squash"],
    answer: "Badminton",
    explanation:
        "Le logo avec une silhouette en pleine action et une raquette représente le badminton.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a remporté la Coupe du Monde de football féminin en 2019 ?",
    options: ["États-Unis", "Japon", "France"],
    answer: "États-Unis",
    explanation:
        "Les États-Unis ont remporté la Coupe du Monde féminine en 2019, leur quatrième titre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport qui se pratique sur une piste ovale et consiste à tourner autour d'un virage ?",
    options: ["Cyclisme sur piste", "Athlétisme", "Ski de fond"],
    answer: "Cyclisme sur piste",
    explanation:
        "Le cyclisme sur piste se pratique sur une piste ovale en bois ou en béton, avec des virages inclinés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre coureur qui a battu le record du marathon en 2018 ?",
    options: ["Eliud Kipchoge", "Haile Gebrselassie", "Dennis Kipruto"],
    answer: "Eliud Kipchoge",
    explanation:
        "Eliud Kipchoge a battu le record du marathon en 2018 avec un temps de 2h01'39 à Berlin.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport où le but est de marquer des paniers ?",
    options: ["Basket-ball", "Handball", "Football"],
    answer: "Basket-ball",
    explanation:
        "Le basket-ball consiste à marquer des points en lançant un ballon dans un panier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de l'événement annuel qui récompense les meilleurs joueurs de la Ligue nationale de football américain ?",
    options: ["Super Bowl", "World Series", "NCAA Championship"],
    answer: "Super Bowl",
    explanation:
        "Le Super Bowl est la finale du championnat de la NFL et est l'un des événements sportifs les plus regardés au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la danse emblématique réalisée par les joueurs de football américains après un touché ?",
    options: ["Touchdown Dance", "Victory Dance", "End Zone Dance"],
    answer: "End Zone Dance",
    explanation:
        "L'End Zone Dance est une danse souvent exécutée par les joueurs après avoir marqué un touchdown.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel athlète a été surnommé 'La Bête de l'Est' ?",
    options: ["Serena Williams", "Danica Patrick", "Novak Djokovic"],
    answer: "Serena Williams",
    explanation:
        "Serena Williams est surnommée 'La Bête de l'Est' en raison de sa puissance sur le court.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a produit le plus de champions du monde en boxe ?",
    options: ["États-Unis", "Cuba", "Royaume-Uni"],
    answer: "États-Unis",
    explanation:
        "Les États-Unis sont le pays qui a produit le plus de champions du monde en boxe dans l'histoire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel événement sportif a été annulé à cause de la pandémie de COVID-19 en 2020 ?",
    options: [
      "Jeux Olympiques d'été",
      "Coupe du Monde de football",
      "Tour de France",
    ],
    answer: "Jeux Olympiques d'été",
    explanation:
        "Les Jeux Olympiques d'été de 2020 ont été annulés en raison de la pandémie de COVID-19.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre tournoi annuel de tennis qui se déroule à Roland-Garros ?",
    options: ["French Open", "Wimbledon", "Australian Open"],
    answer: "French Open",
    explanation:
        "Le tournoi de Roland-Garros est également connu sous le nom de French Open en raison de sa localisation en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel joueur de football a marqué le plus de buts en Coupe du Monde ?",
    options: ["Marta", "Ronaldo", "Pele"],
    answer: "Ronaldo",
    explanation:
        "Ronaldo détient le record du plus grand nombre de buts marqués en Coupe du Monde avec 15 buts.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport est pratiqué lors des Jeux Olympiques d'été et d'hiver ?",
    options: ["Natation", "Ski", "Tennis"],
    answer: "Natation",
    explanation:
        "La natation est un sport olympique qui se pratique aux Jeux d'été.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le terme utilisé pour désigner le score de 0 en tennis ?",
    options: ["Love", "No point", "Zero"],
    answer: "Love",
    explanation: "En tennis, 'love' désigne un score de zéro.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Dans quelle discipline sportive utilise-t-on un cercle et des munitions ?",
    options: ["Tir à l'arc", "Ski alpin", "Lancer de poids"],
    answer: "Lancer de poids",
    explanation:
        "Le lancer de poids utilise un poids sphérique lancé dans une zone délimitée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Lequel de ces pays a remporté le plus de Coupes du Monde de football ?",
    options: ["Allemagne", "Brésil", "Italie"],
    answer: "Brésil",
    explanation: "Le Brésil a remporté cinq Coupes du Monde de football.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel coureur célèbre a été surnommé 'The Flying Finn' ?",
    options: ["Paavo Nurmi", "Carl Lewis", "Usain Bolt"],
    answer: "Paavo Nurmi",
    explanation:
        "Paavo Nurmi, un athlète finlandais, était connu sous le nom de 'The Flying Finn'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a accueilli les premiers Jeux Olympiques modernes en 1896 ?",
    options: ["France", "Grèce", "Royaume-Uni"],
    answer: "Grèce",
    explanation:
        "La Grèce a été le pays hôte des premiers Jeux Olympiques modernes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le record du plus grand nombre de médailles d'or gagnées par un athlète aux Jeux Olympiques ?",
    options: ["Michael Phelps", "Usain Bolt", "Carl Lewis"],
    answer: "Michael Phelps",
    explanation: "Michael Phelps détient le record avec 23 médailles d'or.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport est associé à la découverte des 'routes de la soie' ?",
    options: ["Alpinisme", "Cyclisme", "Randonnée"],
    answer: "Cyclisme",
    explanation:
        "Le cyclisme est souvent associé aux expéditions sur les anciennes routes de la soie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel joueur de basketball est surnommé 'His Airness' ?",
    options: ["Kobe Bryant", "Larry Bird", "Michael Jordan"],
    answer: "Michael Jordan",
    explanation:
        "Michael Jordan est surnommé 'His Airness' pour ses capacités aériennes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a remporté la Ligue des Champions de football en 2021 ?",
    options: ["Chelsea", "Manchester City", "Bayern Munich"],
    answer: "Chelsea",
    explanation: "Chelsea a remporté la Ligue des Champions en 2021.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal objectif dans le sport du rugby ?",
    options: ["Marquer des essais", "Marquer des paniers", "Marquer des buts"],
    answer: "Marquer des essais",
    explanation:
        "Dans le rugby, l'objectif principal est de marquer des essais.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "En natation, quel est le style le plus rapide ?",
    options: ["Crawl", "Brasse", "Papillon"],
    answer: "Crawl",
    explanation: "Le crawl est le style de natation le plus rapide.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a été le premier joueur à marquer 1000 buts dans sa carrière professionnelle ?",
    options: ["Pelé", "Cristiano Ronaldo", "Diego Maradona"],
    answer: "Pelé",
    explanation:
        "Pelé est le premier joueur à avoir marqué 1000 buts dans sa carrière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se joue avec une raquette et un volant ?",
    options: ["Tennis", "Badminton", "Squash"],
    answer: "Badminton",
    explanation: "Le badminton se joue avec une raquette et un volant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle discipline est incluse dans le triathlon ?",
    options: ["Natation", "Basketball", "Equitation"],
    answer: "Natation",
    explanation:
        "Le triathlon comprend la natation, le cyclisme et la course à pied.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est le joueur le plus titré de l'histoire du tennis masculin ?",
    options: ["Roger Federer", "Rafael Nadal", "Novak Djokovic"],
    answer: "Roger Federer",
    explanation:
        "Roger Federer détient de nombreux titres, le plaçant parmi les plus titrés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport utilise-t-on un vélo ?",
    options: ["Cyclisme", "Athlétisme", "Natation"],
    answer: "Cyclisme",
    explanation: "Le cyclisme implique l'utilisation d'un vélo.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel joueur de football est connu pour son dribble exceptionnel et son numéro 10 ?",
    options: ["Lionel Messi", "Cristiano Ronaldo", "Ronaldinho"],
    answer: "Lionel Messi",
    explanation:
        "Lionel Messi est célèbre pour son dribble et porte le numéro 10.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition annuelle de football entre les meilleures équipes européennes ?",
    options: ["Champions League", "Europa League", "Copa América"],
    answer: "Champions League",
    explanation:
        "La Champions League est la compétition phare du football européen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a été le premier à courir un marathon en moins de 2 heures ?",
    options: ["Eliud Kipchoge", "Haile Gebrselassie", "Usain Bolt"],
    answer: "Eliud Kipchoge",
    explanation: "Eliud Kipchoge a réalisé cet exploit en 2019.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du sport qui combine danse et acrobaties sur la glace ?",
    options: ["Patinage artistique", "Hockey sur glace", "Ballet"],
    answer: "Patinage artistique",
    explanation:
        "Le patinage artistique combine acrobaties et danse sur la glace.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel animal est souvent associé au sport du rugby ?",
    options: ["Lion", "Tigre", "Ours"],
    answer: "Lion",
    explanation: "Le lion est souvent utilisé comme symbole dans le rugby.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est connu sous le nom de 'king of sports' ?",
    options: ["Football", "Basketball", "Golf"],
    answer: "Football",
    explanation: "Le football est souvent appelé 'le roi des sports'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est pratiqué dans un octogone ?",
    options: ["MMA", "Boxe", "Judo"],
    answer: "MMA",
    explanation: "Le MMA (arts martiaux mixtes) se pratique dans un octogone.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a organisé la Coupe du Monde de football en 1998 ?",
    options: ["France", "Brésil", "Allemagne"],
    answer: "France",
    explanation: "La France a accueilli la Coupe du Monde de football en 1998.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport où l'on peut faire des flips et des sauts acrobatiques ?",
    options: ["Gymnastique", "Boxe", "Natation"],
    answer: "Gymnastique",
    explanation: "La gymnastique est connue pour ses sauts et acrobaties.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le nom de l'épreuve de 100 mètres en athlétisme ?",
    options: ["Sprint", "Marathon", "Relais"],
    answer: "Sprint",
    explanation: "L'épreuve de 100 mètres est connue comme un sprint.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le symbole du football féminin ?",
    options: ["Féminité", "Ballon de foot", "Soutien-gorge"],
    answer: "Ballon de foot",
    explanation:
        "Le ballon de foot est un symbole emblématique du football féminin.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quels sont les 3 critères principaux d'un bon arbitre ?",
    options: [
      "Impartialité, connaissance, communication",
      "Amabilité, rapidité, force",
      "Savoir-faire, charisme, expérience",
    ],
    answer: "Impartialité, connaissance, communication",
    explanation:
        "Un bon arbitre doit être impartial, bien informé et capable de communiquer.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la distanciation standard pour un marathon ?",
    options: ["42.195 km", "21.097 km", "30 km"],
    answer: "42.195 km",
    explanation: "La distance standard d'un marathon est de 42.195 km.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est le champion du monde de rugby à XV en 2023 ?",
    options: ["Afrique du Sud", "Angleterre", "France"],
    answer: "Afrique du Sud",
    explanation: "L'Afrique du Sud a remporté la Coupe du Monde de Rugby 2023.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a remporté la médaille d'or aux Jeux Olympiques de Londres en 2012 pour le saut à la perche ?",
    options: ["Renaud Lavillenie", "Sergey Bubka", "Thiago Braz"],
    answer: "Renaud Lavillenie",
    explanation: "Renaud Lavillenie a remporté la médaille d'or en 2012.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la célèbre course de voitures qui se tient chaque année à Monaco ?",
    options: ["Grand Prix de Monaco", "24 Heures du Mans", "Indianapolis 500"],
    answer: "Grand Prix de Monaco",
    explanation: "Le Grand Prix de Monaco est une course célèbre de Formule 1.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport qui se joue sur un terrain en herbe, avec des poteaux ?",
    options: ["Football", "Hockey", "Equitation"],
    answer: "Football",
    explanation:
        "Le football se joue sur un terrain en herbe avec des poteaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète est connu pour avoir remporté le Tour de France à plusieurs reprises ?",
    options: ["Lance Armstrong", "Chris Froome", "Eddy Merckx"],
    answer: "Eddy Merckx",
    explanation:
        "Eddy Merckx est une légende du cyclisme ayant remporté le Tour de France plusieurs fois.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du water-polo ?",
    options: ["Marquer des buts", "Nager rapidement", "S'associer en équipe"],
    answer: "Marquer des buts",
    explanation:
        "Le but du water-polo est de marquer des buts dans le but adverse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition de tennis sur gazon à Londres ?",
    options: ["Roland Garros", "Wimbledon", "US Open"],
    answer: "Wimbledon",
    explanation:
        "Wimbledon est le tournoi de tennis sur gazon le plus prestigieux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se pratique sur une surface de glace ?",
    options: ["Patinage", "Hockey sur glace", "Curling"],
    answer: "Hockey sur glace",
    explanation: "Le hockey sur glace se joue sur une surface de glace.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est une combinaison de lutte et de gymnastique ?",
    options: ["Judo", "Haltérophilie", "Karate"],
    answer: "Judo",
    explanation:
        "Le judo est un sport qui allie des techniques de lutte et de gymnastique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel célèbre stade est situé à Barcelone ?",
    options: ["Camp Nou", "Wembley", "Maracanã"],
    answer: "Camp Nou",
    explanation: "Le Camp Nou est le célèbre stade du FC Barcelone.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel événement sportif est célébré tous les quatre ans ?",
    options: [
      "Jeux Olympiques",
      "Coupe du Monde de Football",
      "Championnat du Monde de Formule 1",
    ],
    answer: "Jeux Olympiques",
    explanation: "Les Jeux Olympiques se tiennent tous les quatre ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est le berceau du judo ?",
    options: ["Japon", "France", "Etats-Unis"],
    answer: "Japon",
    explanation: "Le judo est un art martial originaire du Japon.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nombre de rounds dans un match de boxe professionnel ?",
    options: ["10", "12", "15"],
    answer: "12",
    explanation:
        "Un match de boxe professionnel compte généralement 12 rounds.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est le plus tendance chez les jeunes aujourd'hui ?",
    options: ["Skateboard", "Basketball", "Surf"],
    answer: "Skateboard",
    explanation:
        "Le skateboard est de plus en plus populaire parmi les jeunes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du golf ?",
    options: [
      "Faire un hole-in-one",
      "Marquer des points",
      "Terminer le parcours",
    ],
    answer: "Terminer le parcours",
    explanation:
        "Le but du golf est de terminer le parcours en utilisant le moins de coups possibles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du trophée remis au vainqueur de la Ligue des Champions ?",
    options: ["Coupe aux grandes oreilles", "Coupe du Monde", "Trophée UEFA"],
    answer: "Coupe aux grandes oreilles",
    explanation:
        "Le trophée de la Ligue des Champions est surnommé la 'Coupe aux grandes oreilles'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la danse utilisée dans la gymnastique rythmique ?",
    options: ["Danse classique", "Hip-hop", "Danse contemporaine"],
    answer: "Danse classique",
    explanation:
        "La gymnastique rythmique utilise souvent des éléments de danse classique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se pratique sur un court entouré de filets ?",
    options: ["Tennis", "Football", "Basket-ball"],
    answer: "Tennis",
    explanation:
        "Le tennis se joue sur un court où les joueurs se renvoient la balle par-dessus un filet.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui détient le record du plus grand nombre de médailles d'or aux Jeux Olympiques ?",
    options: ["Michael Phelps", "Usain Bolt", "Carl Lewis"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps a remporté 23 médailles d'or aux Jeux Olympiques, un record inégalé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a écrit le livre 'La puissance de la pensée positive' ?",
    options: ["Tony Robbins", "Norman Vincent Peale", "Dale Carnegie"],
    answer: "Norman Vincent Peale",
    explanation:
        "Norman Vincent Peale a écrit 'La puissance de la pensée positive', influençant de nombreux athlètes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le nom de l'équipe de football de Paris ?",
    options: ["Olympique de Marseille", "Paris Saint-Germain", "Lille OSC"],
    answer: "Paris Saint-Germain",
    explanation:
        "Le Paris Saint-Germain est l'équipe de football emblématique de la ville de Paris.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle ville a accueilli les Jeux Olympiques d'été en 2016 ?",
    options: ["Tokyo", "Rio de Janeiro", "Londres"],
    answer: "Rio de Janeiro",
    explanation:
        "Rio de Janeiro a été la ville hôte des Jeux Olympiques d'été en 2016.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel athlète est surnommé 'La Foudre' ?",
    options: ["Usain Bolt", "Michael Johnson", "Carl Lewis"],
    answer: "Usain Bolt",
    explanation:
        "Usain Bolt est surnommé 'La Foudre' pour sa vitesse exceptionnelle sur 100 et 200 mètres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport utilise-t-on un bâton pour frapper une balle ?",
    options: ["Hockey", "Baseball", "Golf"],
    answer: "Baseball",
    explanation:
        "Le baseball est un sport où un bâton est utilisé pour frapper une balle lancée par le lanceur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a remporté la Ligue des Champions en 2021 ?",
    options: ["Manchester City", "Chelsea", "Bayern Munich"],
    answer: "Chelsea",
    explanation:
        "Chelsea a remporté la Ligue des Champions en 2021 en battant Manchester City en finale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du tournoi de tennis qui se déroule à Wimbledon ?",
    options: ["Roland-Garros", "Open d'Australie", "Wimbledon"],
    answer: "Wimbledon",
    explanation:
        "Wimbledon est un tournoi de tennis prestigieux, connu pour ses traditions sur gazon.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport qui utilise un trampoline et un cerceau ?",
    options: ["Gymnastique", "Basket-ball", "Athlétisme"],
    answer: "Gymnastique",
    explanation:
        "La gymnastique inclut des disciplines comme le trampoline et les cerceaux, mettant en avant l'agilité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a été le premier pilote à remporter 7 titres de champion du monde de Formule 1 ?",
    options: ["Michael Schumacher", "Lewis Hamilton", "Ayrton Senna"],
    answer: "Michael Schumacher",
    explanation:
        "Michael Schumacher a été le premier pilote à décrocher 7 titres de champion du monde.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport se joue sur un terrain en gazon avec des buts à chaque extrémité ?",
    options: ["Rugby", "Football", "Handball"],
    answer: "Football",
    explanation:
        "Le football se joue sur un terrain en gazon avec des buts pour marquer des points.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel joueur de tennis est surnommé 'Le Maestro' ?",
    options: ["Roger Federer", "Rafael Nadal", "Novak Djokovic"],
    answer: "Roger Federer",
    explanation:
        "Roger Federer est souvent appelé 'Le Maestro' pour son élégance et sa technique sur le court.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la distance d'un marathon en kilomètres ?",
    options: ["21", "42", "50"],
    answer: "42",
    explanation: "Un marathon fait officiellement 42,195 kilomètres de long.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle équipe a remporté la Coupe du Monde de Rugby en 2019 ?",
    options: ["Angleterre", "Afrique du Sud", "Nouvelle-Zélande"],
    answer: "Afrique du Sud",
    explanation:
        "L'Afrique du Sud a remporté la Coupe du Monde de Rugby en 2019 contre l'Angleterre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se joue sur une surface de glace avec un palet ?",
    options: ["Hockey sur glace", "Curling", "Patinage artistique"],
    answer: "Hockey sur glace",
    explanation:
        "Le hockey sur glace se joue sur une surface de glace avec un palet, deux équipes s'affrontent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but principal du jeu de handball ?",
    options: ["Marquer des buts", "Dribbler le ballon", "Passer le ballon"],
    answer: "Marquer des buts",
    explanation:
        "Le but du handball est de marquer des buts en lançant un ballon dans le but adverse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel athlète a remporté le Tour de France à 7 reprises ?",
    options: ["Eddy Merckx", "Lance Armstrong", "Bernard Hinault"],
    answer: "Lance Armstrong",
    explanation:
        "Lance Armstrong a remporté le Tour de France 7 fois, mais ses titres ont été annulés pour dopage.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est le créateur de la série de jeux vidéo 'FIFA' ?",
    options: ["EA Sports", "Konami", "Nintendo"],
    answer: "EA Sports",
    explanation:
        "EA Sports est le développeur derrière la célèbre série de jeux vidéo 'FIFA'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est célèbre pour le cricket ?",
    options: ["Inde", "Canada", "Brésil"],
    answer: "Inde",
    explanation:
        "Le cricket est extrêmement populaire en Inde, considérée comme une religion sportive.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du tournoi de football qui se déroule tous les quatre ans entre les équipes nationales ?",
    options: ["Euro", "Copa América", "Coupe du Monde"],
    answer: "Coupe du Monde",
    explanation:
        "La Coupe du Monde de la FIFA a lieu tous les quatre ans et réunit les meilleures équipes nationales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport utilise-t-on une raquette et un volant ?",
    options: ["Tennis", "Badminton", "Squash"],
    answer: "Badminton",
    explanation:
        "Le badminton se joue avec une raquette et un volant, et se pratique en simple ou en double.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté le Ballon d'Or en 2009 ?",
    options: ["Cristiano Ronaldo", "Lionel Messi", "Andrés Iniesta"],
    answer: "Lionel Messi",
    explanation:
        "Lionel Messi a remporté son premier Ballon d'Or en 2009, marquant le début d'une série de titres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du sport de tir à l'arc ?",
    options: ["Toucher une cible", "Viser un mouvement", "Attraper une proie"],
    answer: "Toucher une cible",
    explanation:
        "Le tir à l'arc consiste à tirer des flèches sur une cible précise pour accumuler des points.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition européenne de football des clubs ?",
    options: ["Ligue Europa", "Ligue des Champions", "Supercoupe d'Europe"],
    answer: "Ligue des Champions",
    explanation:
        "La Ligue des Champions est la compétition phare pour les clubs de football en Europe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel joueur est le meilleur marqueur de l'histoire de la NBA ?",
    options: ["Kareem Abdul-Jabbar", "Michael Jordan", "LeBron James"],
    answer: "Kareem Abdul-Jabbar",
    explanation:
        "Kareem Abdul-Jabbar détient le record du plus grand nombre de points marqués en NBA.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a accueilli les Jeux Olympiques d'hiver en 2014 ?",
    options: ["Sotchi", "Pyeongchang", "Vancouver"],
    answer: "Sotchi",
    explanation:
        "Sotchi a été la ville hôte des Jeux Olympiques d'hiver en 2014.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport utilise-t-on un piggyback ?",
    options: ["Rugby", "Football américain", "Lutte"],
    answer: "Football américain",
    explanation:
        "Le piggyback est une technique utilisée dans le football américain pour porter un joueur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition annuelle de football entre les équipes de clubs professionnels en France ?",
    options: ["Ligue 1", "Ligue 2", "Coupe de France"],
    answer: "Ligue 1",
    explanation:
        "La Ligue 1 est la première division du football professionnel en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète est connu pour ses exploits en athlétisme et a été surnommé 'L'homme le plus rapide du monde' ?",
    options: ["Usain Bolt", "Carl Lewis", "Jesse Owens"],
    answer: "Usain Bolt",
    explanation:
        "Usain Bolt est reconnu comme l'homme le plus rapide du monde grâce à ses records en sprint.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel célèbre coureur cycliste a remporté le plus de Tours de France ?",
    options: ["Eddy Merckx", "Bernard Hinault", "Lance Armstrong"],
    answer: "Eddy Merckx",
    explanation:
        "Eddy Merckx a remporté 5 Tours de France, un des records dans l'histoire du cyclisme.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du championnat de football professionnel en Angleterre ?",
    options: ["Premier League", "Bundesliga", "La Liga"],
    answer: "Premier League",
    explanation:
        "La Premier League est la plus haute division du football anglais et est célèbre mondialement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport où les joueurs utilisent une planche pour glisser sur la neige ?",
    options: ["Ski", "Snowboard", "Luge"],
    answer: "Snowboard",
    explanation:
        "Le snowboard est un sport de glisse qui se pratique sur la neige à l'aide d'une planche.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète français a remporté le plus de médailles aux Jeux Olympiques ?",
    options: ["Marie-José Pérec", "Teddy Riner", "Jean-Claude Killy"],
    answer: "Teddy Riner",
    explanation:
        "Teddy Riner est un judoka français qui a remporté de nombreuses médailles aux JO.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel événement sportif est considéré comme le plus prestigieux au monde ?",
    options: [
      "Jeux Olympiques",
      "Coupe du Monde de Football",
      "Ligue des Champions",
    ],
    answer: "Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques rassemblent des athlètes du monde entier pour concourir dans diverses disciplines.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a remporté la Coupe du Monde de Football en 2014 ?",
    options: ["Argentine", "Allemagne", "Espagne"],
    answer: "Allemagne",
    explanation:
        "L'Allemagne a remporté la Coupe du Monde de Football en 2014 en battant l'Argentine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se joue avec une balle sphérique dans un but ?",
    options: ["Football", "Rugby", "Hockey"],
    answer: "Football",
    explanation:
        "Le football se joue avec une balle sphérique et l'objectif est de marquer des buts dans le camp adverse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est le sportif français le plus titré aux Jeux Olympiques d'été ?",
    options: ["Teddy Riner", "David Douillet", "Marie-José Pérec"],
    answer: "Teddy Riner",
    explanation:
        "Teddy Riner est le sportif français le plus titré aux JO d'été avec ses médailles en judo.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport qui mêle danse et acrobaties ?",
    options: ["Gymnastique", "Patinage artistique", "Ballet"],
    answer: "Patinage artistique",
    explanation:
        "Le patinage artistique combine la danse et les mouvements acrobatiques sur glace.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport où les athlètes portent des patins et glissent sur la glace ?",
    options: ["Hockey sur glace", "Patinage artistique", "Curling"],
    answer: "Hockey sur glace",
    explanation:
        "Le hockey sur glace se joue sur une patinoire, avec des patins et un palet.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté le Tour de France en 2018 ?",
    options: ["Geraint Thomas", "Chris Froome", "Egan Bernal"],
    answer: "Geraint Thomas",
    explanation:
        "Geraint Thomas a remporté le Tour de France en 2018, devenant le premier Gallois à le faire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport est pratiqué lors des Jeux Olympiques d'été et d'hiver ?",
    options: ["Athlétisme", "Ski", "Luge"],
    answer: "Athlétisme",
    explanation:
        "L'athlétisme est un sport universel pratiqué à la fois aux JO d'été et d'hiver par différents disciplines.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le principal événement de natation organisé par la FINA ?",
    options: ["Championnats du Monde", "Coupe du Monde", "Jeux Olympiques"],
    answer: "Championnats du Monde",
    explanation:
        "Les Championnats du Monde de natation sont un événement majeur organisé par la FINA tous les deux ans.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport où l'on utilise une canne pour lancer une balle ?",
    options: ["Golf", "Baseball", "Cricket"],
    answer: "Golf",
    explanation:
        "Le golf utilise une canne (club) pour frapper une balle et la mettre dans un trou.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le plus grand événement sportif au monde ?",
    options: ["Coupe du Monde", "Jeux Olympiques", "Ligue des Champions"],
    answer: "Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques sont considérés comme l'événement sportif le plus prestigieux à l'échelle mondiale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a remporté la Américaine en 2021 ?",
    options: ["Argentine", "Brésil", "Chili"],
    answer: "Argentine",
    explanation:
        "L'Argentine a remporté la Copa América en 2021, battant le Brésil en finale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport qui se joue avec une balle de tennis sur gazon ?",
    options: ["Tennis", "Badminton", "Squash"],
    answer: "Tennis",
    explanation:
        "Le tennis se joue traditionnellement sur gazon, avec des règles spécifiques pour le service et le jeu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la grande course de vélo qui se déroule en France chaque été ?",
    options: ["Tour de France", "Vuelta a España", "Giro d'Italia"],
    answer: "Tour de France",
    explanation:
        "Le Tour de France est une course cycliste emblématique qui se déroule chaque été en France.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quelle est la capitale du pays où se déroule le tournoi de Wimbledon ?",
    options: ["Madrid", "Londres", "Rome"],
    answer: "Londres",
    explanation:
        "Wimbledon est un tournoi de tennis qui se déroule à Londres, en Angleterre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est pratiqué aux Jeux Olympiques d'hiver ?",
    options: ["Cyclisme", "Ski alpin", "Football"],
    answer: "Ski alpin",
    explanation:
        "Le ski alpin est l'un des sports d'hiver présentés aux Jeux Olympiques d'hiver.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le maximum de points qu’un joueur peut marquer dans un match de basket-ball avec un tir à trois points ?",
    options: ["1", "2", "3"],
    answer: "3",
    explanation:
        "Un tir à trois points au basket-ball rapporte trois points au joueur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition annuelle de football entre les clubs européens les plus prestigieux ?",
    options: ["Ligue des champions", "Europa League", "Coupe du monde"],
    answer: "Ligue des champions",
    explanation:
        "La Ligue des champions est la compétition phare pour les clubs de football en Europe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le nombre de joueurs dans une équipe de football ?",
    options: ["9", "11", "7"],
    answer: "11",
    explanation:
        "Une équipe de football est composée de 11 joueurs sur le terrain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète est connu pour avoir remporté 8 médailles d'or aux Jeux Olympiques de Pékin en 2008 ?",
    options: ["Usain Bolt", "Michael Phelps", "Carl Lewis"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps a remporté 8 médailles d'or aux Jeux Olympiques de Pékin en natation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a organisé les Jeux Olympiques d'été en 2016 ?",
    options: ["Brésil", "Royaume-Uni", "Japon"],
    answer: "Brésil",
    explanation:
        "Le Brésil a été l'hôte des Jeux Olympiques d'été en 2016 à Rio de Janeiro.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la durée d'un match de rugby à XV ?",
    options: ["60 minutes", "80 minutes", "90 minutes"],
    answer: "80 minutes",
    explanation:
        "Un match de rugby à XV se joue en deux périodes de 40 minutes, soit 80 minutes au total.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport utilise-t-on un tee pour le premier coup ?",
    options: ["Golf", "Tennis", "Base-ball"],
    answer: "Golf",
    explanation:
        "Le tee est utilisé dans le golf pour surélever la balle lors du premier coup.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre marathon qui se déroule chaque année à Boston ?",
    options: [
      "Marathon de New York",
      "Marathon de Londres",
      "Marathon de Boston",
    ],
    answer: "Marathon de Boston",
    explanation:
        "Le Marathon de Boston est l'un des marathons les plus connus et historiques au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport est pratiqué sur un court en gazon lors de Wimbledon ?",
    options: ["Basket-ball", "Tennis", "Handball"],
    answer: "Tennis",
    explanation:
        "Wimbledon est un prestigieux tournoi de tennis joué sur gazon.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté le Tour de France en 2019 ?",
    options: ["Chris Froome", "Egan Bernal", "Geraint Thomas"],
    answer: "Egan Bernal",
    explanation:
        "Egan Bernal a remporté le Tour de France 2019, devenant le premier Colombien à le faire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le record mondial du 100 mètres en athlétisme (hommes) ?",
    options: ["9,58 secondes", "9,98 secondes", "10,08 secondes"],
    answer: "9,58 secondes",
    explanation:
        "Usain Bolt détient le record du monde du 100 mètres avec un temps de 9,58 secondes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quelle est la principale compétition de football pour les équipes nationales ?",
    options: ["Champions League", "Coupe du Monde", "Ligue 1"],
    answer: "Coupe du Monde",
    explanation:
        "La Coupe du Monde est le tournoi international de football le plus prestigieux pour les équipes nationales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est considéré comme le « roi des sports » ?",
    options: ["Football", "Rugby", "Tennis"],
    answer: "Football",
    explanation:
        "Le football est souvent désigné comme le « roi des sports » en raison de sa popularité mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel équipement est nécessaire pour pratiquer le baseball ?",
    options: ["Batte", "Raquette", "Balle de tennis"],
    answer: "Batte",
    explanation: "La batte est essentielle pour frapper la balle au baseball.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a dominé le rugby avec 3 titres de Coupe du Monde ?",
    options: ["Nouvelle-Zélande", "Angleterre", "Australie"],
    answer: "Nouvelle-Zélande",
    explanation:
        "La Nouvelle-Zélande a remporté la Coupe du Monde de rugby à trois reprises.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport les athlètes utilisent-ils un cheval ?",
    options: ["Natation", "Équitation", "Football"],
    answer: "Équitation",
    explanation:
        "L'équitation est le sport qui implique la pratique sur un cheval.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la distance d'un marathon complet ?",
    options: ["32 km", "42,195 km", "26,2 km"],
    answer: "42,195 km",
    explanation: "Un marathon mesure officiellement 42,195 kilomètres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de l’organisme qui régit le football au niveau mondial ?",
    options: ["FIFA", "UEFA", "CONCACAF"],
    answer: "FIFA",
    explanation:
        "La FIFA est l'organisme international qui régit le football dans le monde entier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a été le premier joueur de tennis à réaliser le Grand Chelem ?",
    options: ["Rod Laver", "Roger Federer", "Pete Sampras"],
    answer: "Rod Laver",
    explanation:
        "Rod Laver est le seul joueur à avoir réalisé le Grand Chelem en une seule année, en 1969.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Dans quel sport les joueurs ont-ils une raquette et jouent sur un court ?",
    options: ["Badminton", "Rugby", "Golf"],
    answer: "Badminton",
    explanation:
        "Le badminton se joue avec une raquette sur un court et une volée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport combine ski et tir à la carabine ?",
    options: ["Ski alpin", "Biathlon", "Ski de fond"],
    answer: "Biathlon",
    explanation:
        "Le biathlon est un sport combinant le ski nordique et le tir à la carabine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est célèbre pour ses équipes de cricket ?",
    options: ["Inde", "Allemagne", "Canada"],
    answer: "Inde",
    explanation:
        "L'Inde a une forte culture de cricket et a remporté de nombreux championnats.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la danse de compétition à deux, populaire dans les danses sportives ?",
    options: ["Samba", "Valse", "Rock'n'roll"],
    answer: "Valse",
    explanation:
        "La valse est une danse de salon classique souvent utilisée en compétition de danse sportive.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est l'entraîneur le plus titré de l'histoire du football ?",
    options: ["Pep Guardiola", "Alex Ferguson", "Carlo Ancelotti"],
    answer: "Alex Ferguson",
    explanation:
        "Alex Ferguson est considéré comme l'entraîneur le plus titré de l'histoire du football moderne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition emblématique de football entre les équipes de club en Europe ?",
    options: ["Ligue des champions", "Ligue Europa", "Supercoupe d'Europe"],
    answer: "Ligue des champions",
    explanation:
        "La Ligue des champions est la compétition de clubs la plus prestigieuse en Europe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la discipline phare des Jeux Olympiques d'été ?",
    options: ["Athlétisme", "Natation", "Gymnastique"],
    answer: "Athlétisme",
    explanation:
        "L'athlétisme est considéré comme la discipline phare des Jeux Olympiques d'été.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport de combat qui utilise des techniques de coups de pied et de poing ?",
    options: ["Boxe", "Karate", "Judo"],
    answer: "Boxe",
    explanation:
        "La boxe est un sport de combat basé sur des techniques de coups de poing.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a remporté le plus de médailles aux Jeux Olimpique d'été ?",
    options: ["États-Unis", "Chine", "Russie"],
    answer: "États-Unis",
    explanation:
        "Les États-Unis détiennent le record du plus grand nombre de médailles d'or aux Jeux Olympiques d'été.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport utilise une planche et une voile pour naviguer sur l'eau ?",
    options: ["Surf", "Kitesurf", "Planche à voile"],
    answer: "Planche à voile",
    explanation:
        "La planche à voile combine surf et navigation grâce à une voile attachée à une planche.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la distance d'un sprint de 200 mètres ?",
    options: ["100 mètres", "200 mètres", "400 mètres"],
    answer: "200 mètres",
    explanation:
        "Un sprint de 200 mètres est une course de vitesse sur cette distance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le nom du tournoi de tennis sur terre battue à Paris ?",
    options: ["Roland-Garros", "Wimbledon", "US Open"],
    answer: "Roland-Garros",
    explanation:
        "Roland-Garros est le tournoi de tennis sur terre battue qui se tient à Paris.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel type de course de voitures est connu pour se dérouler sur circuit fermé ?",
    options: ["Formule 1", "Rallye", "Tourisme"],
    answer: "Formule 1",
    explanation:
        "La Formule 1 est un championnat de course automobile qui se déroule sur des circuits fermés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du hockey sur glace ?",
    options: [
      "Marquer des points",
      "Défendre son but",
      "Disputer un match amical",
    ],
    answer: "Marquer des points",
    explanation:
        "Le but du hockey sur glace est de marquer des points en insérant le palet dans le but adverse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la danse sportive internationale avec des couples ?",
    options: ["Salsa", "Tango", "Danses de salon"],
    answer: "Danses de salon",
    explanation:
        "Les danses de salon incluent plusieurs danses populaires pratiquées en couple.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport collectif joue-t-on en marquant des buts avec un ballon ?",
    options: ["Handball", "Baseball", "Rugby"],
    answer: "Handball",
    explanation:
        "Le handball est un sport collectif où l'objectif est de marquer des buts avec un ballon.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté le dernier Super Bowl ?",
    options: [
      "Les Chiefs de Kansas City",
      "Les Patriots de la Nouvelle-Angleterre",
      "Les 49ers de San Francisco",
    ],
    answer: "Les Chiefs de Kansas City",
    explanation:
        "Les Chiefs de Kansas City ont remporté le dernier Super Bowl, confirmant leur domination en NFL.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel nageur a remporté le plus de médailles aux Jeux Olympiques ?",
    options: ["Ryan Lochte", "Michael Phelps", "Mark Spitz"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps détient le record du plus grand nombre de médailles olympiques dans l'histoire de la natation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport de raquette se joue sur un court en plein air ou en intérieur ?",
    options: ["Tennis", "Badminton", "Squash"],
    answer: "Tennis",
    explanation:
        "Le tennis se joue sur un court, en extérieur ou en intérieur, avec des raquettes et une balle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a remporté le Championnat d'Europe de football en 2016 ?",
    options: ["Portugal", "France", "Espagne"],
    answer: "Portugal",
    explanation:
        "Le Portugal a remporté le Championnat d'Europe 2016 en battant la France en finale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport américain se joue avec une balle ovale ?",
    options: ["Basket-ball", "Football américain", "Baseball"],
    answer: "Football américain",
    explanation:
        "Le football américain se joue avec une balle ovale, et chaque équipe tente de marquer des points en avançant le ballon.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel coureur est célèbre pour ses exploits en marathon ?",
    options: ["Haile Gebrselassie", "Usain Bolt", "Mo Farah"],
    answer: "Haile Gebrselassie",
    explanation:
        "Haile Gebrselassie est un des marathoniens les plus célèbres, ayant établi de nombreux records.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport d’équipe avec un ballon ovale ?",
    options: ["Rugby", "Handball", "Basket-ball"],
    answer: "Rugby",
    explanation:
        "Le rugby est un sport d'équipe qui se joue avec un ballon ovale, en marquant des essais.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel événement sportif majeur a lieu chaque année à Monaco ?",
    options: [
      "Grand Prix de formule 1",
      "Championnat du monde de football",
      "Marathon de Monaco",
    ],
    answer: "Grand Prix de formule 1",
    explanation:
        "Le Grand Prix de Monaco de Formule 1 est un événement prestigieux du sport automobile.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui détient le record du nombre de médailles d'or aux Jeux Olympiques d'été ?",
    options: ["Michael Phelps", "Usain Bolt", "Larisa Latynina"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps a remporté 23 médailles d'or aux Jeux Olympiques d'été, un record inégalé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du tournoi de tennis sur gazon qui se déroule à Wimbledon ?",
    options: ["Open d'Australie", "Roland-Garros", "Wimbledon"],
    answer: "Wimbledon",
    explanation:
        "Wimbledon est le tournoi de tennis le plus prestigieux disputé sur gazon à Londres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Dans quel sport pratique-t-on des figures telles que le saut de la mort ?",
    options: ["Patinage artistique", "Saut à ski", "Gymnastique"],
    answer: "Patinage artistique",
    explanation:
        "Le saut de la mort est une figure spectaculaire couramment exécutée en patinage artistique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel coureur détient le record du monde du 100 mètres ?",
    options: ["Usain Bolt", "Carl Lewis", "Jesse Owens"],
    answer: "Usain Bolt",
    explanation:
        "Usain Bolt a établi le record du monde du 100 mètres avec un temps de 9,58 secondes en 2009.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport pratiqué lors des Jeux Olympiques d'hiver ?",
    options: ["Surf", "Hockey sur glace", "Rugby"],
    answer: "Hockey sur glace",
    explanation:
        "Le hockey sur glace est l'un des sports phares des Jeux Olympiques d'hiver.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la distance d'un marathon ?",
    options: ["21 km", "30 km", "42 km"],
    answer: "42 km",
    explanation:
        "La distance officielle d'un marathon est de 42,195 kilomètres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition annuelle de football entre les équipes de clubs européens ?",
    options: [
      "Ligue des champions",
      "Europa League",
      "Coupe du monde des clubs",
    ],
    answer: "Ligue des champions",
    explanation:
        "La Ligue des champions est la plus prestigieuse compétition de clubs de football en Europe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "En quelle année ont eu lieu les premiers Jeux Olympiques modernes ?",
    options: ["1896", "1900", "1924"],
    answer: "1896",
    explanation:
        "Les premiers Jeux Olympiques modernes se sont tenus à Athènes en 1896.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quelle discipline est associée aux épreuves de natation en piscine et en eau libre ?",
    options: ["Aviron", "Pentathlon moderne", "Natation"],
    answer: "Natation",
    explanation:
        "La natation englobe les épreuves en piscine et en eau libre dans le cadre des compétitions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel célèbre boxeur était surnommé 'The Greatest' ?",
    options: ["Mike Tyson", "Muhammad Ali", "Floyd Mayweather"],
    answer: "Muhammad Ali",
    explanation:
        "Muhammad Ali était surnommé 'The Greatest' pour son talent exceptionnel sur le ring.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est pratiqué dans la discipline du biathlon ?",
    options: ["Ski de fond et tir", "Ski alpin", "Surf"],
    answer: "Ski de fond et tir",
    explanation: "Le biathlon combine le ski de fond et le tir à la carabine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a été le premier joueur à marquer un million de dollars en salaires dans le football américain ?",
    options: ["Jim Brown", "Joe Namath", "John Elway"],
    answer: "Joe Namath",
    explanation:
        "Joe Namath a été le premier joueur à dépasser le million de dollars en salaires dans la NFL.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le surnom de la fameuse équipe de football brésilienne des années 1970 ?",
    options: ["Les Bleus", "Les Séléçao", "Les Azzurri"],
    answer: "Les Séléçao",
    explanation:
        "L'équipe du Brésil est surnommée 'Les Séléçao' en raison de sa sélection nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport est associé à la discipline des courses de Formule 1 ?",
    options: ["Vélo", "Automobile", "Moto"],
    answer: "Automobile",
    explanation:
        "La Formule 1 est une compétition de courses de voitures de haute performance.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté le Tour de France 2021 ?",
    options: ["Tadej Pogačar", "Chris Froome", "Egan Bernal"],
    answer: "Tadej Pogačar",
    explanation:
        "Tadej Pogačar a été le vainqueur du Tour de France en 2021, portant son titre au niveau international.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel joueur de basketball a remporté le plus de titres NBA ?",
    options: ["Michael Jordan", "Kareem Abdul-Jabbar", "Bill Russell"],
    answer: "Bill Russell",
    explanation:
        "Bill Russell détient le record avec 11 titres NBA au cours de sa carrière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est le créateur du jeu de football américain ?",
    options: ["Walter Camp", "Lombardi", "Belichick"],
    answer: "Walter Camp",
    explanation:
        "Walter Camp est considéré comme le 'père du football américain' pour ses contributions au développement du sport.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel événement se déroule à Roland-Garros chaque année ?",
    options: [
      "Le Super Bowl",
      "Le Tour de France",
      "Les Internationaux de France de tennis",
    ],
    answer: "Les Internationaux de France de tennis",
    explanation:
        "Roland-Garros est le tournoi majeur de tennis sur terre battue en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est le pilote le plus titré en Formule 1 ?",
    options: ["Michael Schumacher", "Lewis Hamilton", "Ayrton Senna"],
    answer: "Lewis Hamilton",
    explanation:
        "Lewis Hamilton détient le record du plus grand nombre de championnats du monde en Formule 1.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport utilise-t-on une planche et des palmes ?",
    options: ["Natation", "Surf", "Plongée libre"],
    answer: "Plongée libre",
    explanation:
        "La plongée libre implique l'utilisation d'une planche et de palmes pour explorer sous l'eau.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté le Ballon d'Or en 2021 ?",
    options: ["Cristiano Ronaldo", "Lionel Messi", "Robert Lewandowski"],
    answer: "Lionel Messi",
    explanation:
        "Lionel Messi a remporté le Ballon d'Or pour la septième fois en 2021.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le nom des plus célèbres courses de chevaux ?",
    options: ["Les 24 Heures du Mans", "Preakness Stakes", "Derby d'Epsom"],
    answer: "Derby d'Epsom",
    explanation:
        "Le Derby d'Epsom est l'une des courses de chevaux les plus prestigieuses au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays organisera les Jeux Olympiques d'été en 2024 ?",
    options: ["Japon", "France", "Brésil"],
    answer: "France",
    explanation:
        "La France accueillera les Jeux Olympiques d'été en 2024 à Paris.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel équipement est essentiel pour la pratique du cyclisme ?",
    options: ["Baskets", "Vélo", "Raquette"],
    answer: "Vélo",
    explanation:
        "Le vélo est l'équipement principal nécessaire à la pratique du cyclisme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du basketball ?",
    options: ["Marquer des paniers", "Dribbler", "Passer le ballon"],
    answer: "Marquer des paniers",
    explanation:
        "Le principal objectif du basketball est de marquer des paniers en lançant le ballon dans le cerceau.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a été le premier à courir un marathon en moins de deux heures ?",
    options: ["Eliud Kipchoge", "Haile Gebrselassie", "Kenenisa Bekele"],
    answer: "Eliud Kipchoge",
    explanation:
        "Eliud Kipchoge a réalisé cet exploit lors d'une course spéciale en 2019.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le terme utilisé pour désigner la compétition de football entre clubs européens ?",
    options: ["Ligue des champions", "Premier League", "La Liga"],
    answer: "Ligue des champions",
    explanation:
        "La Ligue des champions est la principale compétition de clubs en Europe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "D'où provient le sport du judo ?",
    options: ["Chine", "Japon", "Corée"],
    answer: "Japon",
    explanation:
        "Le judo est un art martial qui a été développé au Japon à la fin du 19ème siècle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport où l'on utilise un pogo stick ?",
    options: ["Saut à la perche", "Saut en longueur", "Saut à la corde"],
    answer: "Saut à la perche",
    explanation:
        "Le pogo stick est un équipement de saut utilisé dans le saut à la perche pour prendre de la hauteur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est souvent considéré comme le berceau du rugby ?",
    options: ["Australie", "Angleterre", "Nouvelle-Zélande"],
    answer: "Angleterre",
    explanation: "Le rugby a été inventé en Angleterre au 19ème siècle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la spécialité du cycliste Bernard Hinault ?",
    options: ["VTT", "Piste", "Route"],
    answer: "Route",
    explanation:
        "Bernard Hinault est un coureur cycliste célèbre pour ses performances sur route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la célèbre route de la course Paris-Roubaix ?",
    options: ["Rues pavées", "Route de la Paix", "Avenue des Champs-Élysées"],
    answer: "Rues pavées",
    explanation:
        "La course Paris-Roubaix est célèbre pour ses sections de routes pavées difficiles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de l'équipe nationale de football de l'Uruguay ?",
    options: ["Los Ticos", "La Celeste", "Los Charrúas"],
    answer: "La Celeste",
    explanation:
        "L'équipe nationale uruguayenne est surnommée 'La Celeste' en raison de sa couleur bleu ciel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est pratiqué lors des Jeux Méditerranéens ?",
    options: ["Athlétisme", "Football", "Tennis"],
    answer: "Athlétisme",
    explanation:
        "L'athlétisme est une des disciplines principales des Jeux Méditerranéens.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport utilise le terme 'set' ?",
    options: ["Tennis", "Basketball", "Handball"],
    answer: "Tennis",
    explanation:
        "Le terme 'set' est couramment utilisé dans le tennis pour désigner un ensemble de jeux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté la Coupe du Monde FIFA en 2006 ?",
    options: ["Italie", "France", "Brésil"],
    answer: "Italie",
    explanation:
        "L'Italie a remporté la Coupe du Monde 2006 en battant la France en finale aux tirs au but.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est pratiqué sur un skate ?",
    options: ["Vélo", "Skateboard", "Trottinette"],
    answer: "Skateboard",
    explanation:
        "Le skateboard est un sport de glisse pratiqué sur une planche avec des roulettes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est le pays d'origine du karaté ?",
    options: ["Chine", "Japon", "Corée"],
    answer: "Japon",
    explanation:
        "Le karaté est un art martial originaire du Japon, développé sur l'île d'Okinawa.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est le premier joueur de tennis à avoir remporté le Grand Chelem en carrière ?",
    options: ["Rod Laver", "Pete Sampras", "Roger Federer"],
    answer: "Rod Laver",
    explanation:
        "Rod Laver est le premier et seul joueur à avoir remporté le Grand Chelem deux fois en carrière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport associé à la discipline des 'chutes' ?",
    options: ["Gymnastique", "Patinage artistique", "Surf"],
    answer: "Patinage artistique",
    explanation:
        "Les chutes sont une partie intégrante des performances en patinage artistique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel événement sportif majeur a lieu chaque année à Monaco ?",
    options: ["Grand Prix de Monaco", "Tour de France", "Roland-Garros"],
    answer: "Grand Prix de Monaco",
    explanation:
        "Le Grand Prix de Monaco est l'une des courses de Formule 1 les plus célèbres au monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Vitali Klitschko et Wladimir Klitschko sont connus pour être des champions dans quel sport ?",
    options: ["Boxe", "MMA", "Karate"],
    answer: "Boxe",
    explanation:
        "Les frères Klitschko sont célèbres dans le monde de la boxe poids lourds.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport doit-on marquer des touchdowns ?",
    options: ["Rugby", "Football américain", "Handball"],
    answer: "Football américain",
    explanation:
        "Le touchdown est le moyen principal de marquer des points dans le football américain.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a remporté la première Coupe du Monde de football en 1930 ?",
    options: ["Brésil", "Uruguay", "Argentine"],
    answer: "Uruguay",
    explanation:
        "L'Uruguay a été le premier pays à remporter la Coupe du Monde de football en 1930.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport de l'escalade de compétition ?",
    options: ["Alpinisme", "Escalade de compétition", "Via ferrata"],
    answer: "Escalade de compétition",
    explanation:
        "L'escalade de compétition est un sport reconnu avec des compétitions internationales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport pratique-t-on dans le cadre des Jeux Paralympiques ?",
    options: ["Ski", "Basketball", "Natation"],
    answer: "Basketball",
    explanation:
        "Le basketball en fauteuil roulant est un sport majeur aux Jeux Paralympiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la célèbre course de voile qui traverse l'Atlantique ?",
    options: ["Route du Rhum", "Vendée Globe", "Transat Jacques Vabre"],
    answer: "Route du Rhum",
    explanation:
        "La Route du Rhum est une célèbre course transatlantique de voiliers.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a remporté la Coupe du Monde de football 2018 ?",
    options: ["Brésil", "France", "Allemagne"],
    answer: "France",
    explanation:
        "La France a remporté la Coupe du Monde de football 2018 en battant la Croatie en finale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport est pratiqué lors des Jeux Olympiques d'été avec un tableau et des pièces ?",
    options: ["Basket-ball", "Échecs", "Tennis"],
    answer: "Échecs",
    explanation:
        "Les échecs sont reconnus comme un sport cérébral aux Jeux Olympiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète est célèbre pour ses victoires en sprint aux Jeux Olympiques ?",
    options: ["Usain Bolt", "Michael Phelps", "Serena Williams"],
    answer: "Usain Bolt",
    explanation:
        "Usain Bolt est reconnu comme le roi du sprint avec des médailles d'or aux JO.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "En quelle année a eu lieu la première Coupe du Monde de rugby ?",
    options: ["1987", "1995", "2003"],
    answer: "1987",
    explanation:
        "La première Coupe du Monde de rugby a été organisée en Nouvelle-Zélande et en Australie en 1987.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition de tennis se déroulant sur gazon à Wimbledon ?",
    options: ["Roland-Garros", "US Open", "Wimbledon"],
    answer: "Wimbledon",
    explanation:
        "Wimbledon est le tournoi de tennis le plus prestigieux sur gazon qui se tient chaque été en Angleterre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté le Tour de France en 2021 ?",
    options: ["Tadej Pogačar", "Chris Froome", "Egan Bernal"],
    answer: "Tadej Pogačar",
    explanation:
        "Tadej Pogačar a gagné le Tour de France 2021 avec une performance impressionnante.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle équipe a remporté le Super Bowl de 2020 ?",
    options: [
      "Kansas City Chiefs",
      "San Francisco 49ers",
      "New England Patriots",
    ],
    answer: "Kansas City Chiefs",
    explanation:
        "Les Kansas City Chiefs ont triomphé lors du Super Bowl LIV en 2020.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est le plus titré en Ligue des champions de l'UEFA ?",
    options: ["Espagne", "Italie", "Angleterre"],
    answer: "Espagne",
    explanation:
        "Les clubs espagnols ont remporté le plus de titres en Ligue des champions de l'UEFA.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est Julius Erving célèbre pour avoir popularisé ?",
    options: ["Football", "Basket-ball", "Baseball"],
    answer: "Basket-ball",
    explanation:
        "Julius Erving est célèbre pour avoir révolutionné le basket-ball avec son style de jeu spectaculaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du jeu au football ?",
    options: ["Marquer des essais", "Marquer des paniers", "Marquer des buts"],
    answer: "Marquer des buts",
    explanation:
        "Le but du jeu au football est de marquer des buts en faisant entrer le ballon dans le but adverse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal événement de natation sportive ?",
    options: [
      "Les championnats du monde",
      "Les Jeux Olympiques",
      "Le Tour de France",
    ],
    answer: "Les Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques sont la plus grande compétition internationale de natation et d'autres sports.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport d'équipe le plus populaire au monde ?",
    options: ["Cricket", "Basket-ball", "Football"],
    answer: "Football",
    explanation:
        "Le football est reconnu comme le sport d'équipe le plus suivi et joué dans le monde entier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel célèbre tournoi de tennis se déroule chaque année en France ?",
    options: ["Wimbledon", "Roland-Garros", "US Open"],
    answer: "Roland-Garros",
    explanation:
        "Roland-Garros est le tournoi de tennis majeur se tenant sur terre battue à Paris.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est le footballeur ayant remporté le plus de Ballons d'Or ?",
    options: ["Cristiano Ronaldo", "Lionel Messi", "Johan Cruyff"],
    answer: "Lionel Messi",
    explanation:
        "Lionel Messi détient le record avec sept Ballons d'Or gagnés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se joue avec une raquette et une balle jaune ?",
    options: ["Badminton", "Tennis", "Squash"],
    answer: "Tennis",
    explanation:
        "Le tennis est un sport de raquette où les joueurs frappent une balle en caoutchouc au-dessus d'un filet.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a été le premier à remporter la Coupe du Monde de foot féminine ?",
    options: ["États-Unis", "Norvège", "Allemagne"],
    answer: "États-Unis",
    explanation:
        "Les États-Unis ont remporté la première Coupe du Monde féminine en 1991.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport utilise-t-on un 'pallon' ?",
    options: ["Rugby", "Football", "Handball"],
    answer: "Handball",
    explanation:
        "Dans le handball, le 'pallon' est un synonyme de la balle utilisée dans le jeu.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a remporté le plus de médailles aux Jeux Olympiques d'hiver ?",
    options: ["Marit Bjørgen", "Pyeongchang", "Mikaela Shiffrin"],
    answer: "Marit Bjørgen",
    explanation:
        "Marit Bjørgen est la plus médaillée en ski de fond aux Jeux Olympiques d'hiver.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport le plus pratiqué en France ?",
    options: ["Football", "Basket-ball", "Tennis"],
    answer: "Football",
    explanation:
        "Le football est le sport le plus pratiqué et populaire en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport de glisse le plus populaire ?",
    options: ["Ski", "Planche à neige", "Surf"],
    answer: "Surf",
    explanation:
        "Le surf est un sport de glisse très populaire pratiqué sur les vagues des océans.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Comment s'appelle le championnat de football professionnel en Angleterre ?",
    options: ["La Liga", "Premier League", "Bundesliga"],
    answer: "Premier League",
    explanation:
        "La Premier League est le championnat de football professionnel le plus suivi en Angleterre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se déroule sur un tatami ?",
    options: ["Judo", "Boxe", "Karate"],
    answer: "Judo",
    explanation:
        "Le judo se pratique sur un tatami, une surface spécialement conçue pour le combat.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a dominé le cyclisme avec le Tour de France ?",
    options: ["France", "Italie", "Espagne"],
    answer: "France",
    explanation:
        "Le Tour de France est une course cycliste qui se déroule principalement en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le plus grand événement sportif mondial ?",
    options: ["Coupe du Monde de football", "Jeux Olympiques", "Wimbledon"],
    answer: "Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques sont considérés comme le plus grand événement sportif mondial réunissant de nombreuses disciplines.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal organe de régulation de la FIFA ?",
    options: [
      "UEFA",
      "CONCACAF",
      "Fédération Internationale de Football Association",
    ],
    answer: "Fédération Internationale de Football Association",
    explanation:
        "La FIFA est l'entité responsable de l'organisation du football au niveau mondial.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but d'un marathon ?",
    options: [
      "Parcourir 10 kilomètres",
      "Parcourir 21 kilomètres",
      "Parcourir 42 kilomètres",
    ],
    answer: "Parcourir 42 kilomètres",
    explanation:
        "Le marathon est une course de fond de 42,195 kilomètres, un défi pour les coureurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est fortement associé à la ville de Barcelone ?",
    options: ["Basket-ball", "Football", "Cyclisme"],
    answer: "Football",
    explanation:
        "Le FC Barcelone est le club de football le plus emblématique de cette ville.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport pratique le club de football du Bayern Munich ?",
    options: ["Rugby", "Football", "Hockey sur glace"],
    answer: "Football",
    explanation:
        "Le Bayern Munich est un club de football reconnu au niveau international.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le record du nombre de buts marqués en une saison de Ligue 1 ?",
    options: ["31 buts", "44 buts", "39 buts"],
    answer: "44 buts",
    explanation:
        "Le record de 44 buts en une saison de Ligue 1 a été établi par Jean-Pierre Papin en 1990.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a remporté les derniers Jeux Olympiques d'hiver ?",
    options: ["Suisse", "Chine", "Corée du Sud"],
    answer: "Chine",
    explanation:
        "La Chine a accueilli et remporté des médailles aux derniers Jeux Olympiques d'hiver en 2022.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est l'âge minimum pour participer aux Jeux Olympiques ?",
    options: ["16 ans", "18 ans", "14 ans"],
    answer: "16 ans",
    explanation:
        "L'âge minimum pour participer aux Jeux Olympiques est de 16 ans, selon les règles de différentes fédérations sportives.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport national du Canada ?",
    options: ["Hockey sur glace", "Baseball", "Rugby"],
    answer: "Hockey sur glace",
    explanation:
        "Le hockey sur glace est reconnu comme le sport national du Canada.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel athlète a remporté le plus de médailles aux JO d'été ?",
    options: ["Carl Lewis", "Michael Phelps", "Bjørn Dæhlie"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps est le nageur ayant remporté le plus de médailles aux JO d'été avec 28 médailles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est le coureur le plus titré du Tour de France ?",
    options: ["Eddy Merckx", "Bernard Hinault", "Lance Armstrong"],
    answer: "Eddy Merckx",
    explanation:
        "Eddy Merckx est considéré comme le plus grand coureur avec 5 victoires au Tour de France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le nombre de joueurs sur le terrain en football ?",
    options: ["9", "10", "11"],
    answer: "11",
    explanation:
        "Chaque équipe de football est composée de 11 joueurs sur le terrain pendant un match.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quelle discipline est à la fois un sport de combat et un art martial ?",
    options: ["Karate", "Boxe", "Judo"],
    answer: "Judo",
    explanation:
        "Le judo est à la fois un sport de combat et un art martial d'origine japonaise.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport fait partie des 5 disciplines au pentathlon moderne ?",
    options: ["Natation", "Football", "Tennis"],
    answer: "Natation",
    explanation:
        "La natation est l'une des disciplines du pentathlon moderne, qui combine plusieurs épreuves.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport préféré des Français ?",
    options: ["Rugby", "Football", "Basket-ball"],
    answer: "Football",
    explanation:
        "Le football est le sport le plus apprécié par les Français, tant en pratique qu'en spectacle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le record du monde du 100 mètres ?",
    options: ["9.58 secondes", "10.28 secondes", "9.74 secondes"],
    answer: "9.58 secondes",
    explanation:
        "Le record du monde du 100 mètres est détenu par Usain Bolt avec un temps de 9.58 secondes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le secteur le plus populaire pour les sports d'hiver ?",
    options: ["Ski", "Snowboard", "Luge"],
    answer: "Ski",
    explanation:
        "Le ski est le sport d'hiver le plus populaire et pratiqué dans le monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le plus grand événement de cricket au monde ?",
    options: ["Coupes du Monde", "Championnats du Monde", "World Twenty20"],
    answer: "Coupes du Monde",
    explanation:
        "La Coupe du Monde de cricket est le tournoi le plus prestigieux dans ce sport.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport où les joueurs utilisent des clubs pour frapper une balle dans des trous ?",
    options: ["Golf", "Hockey", "Baseball"],
    answer: "Golf",
    explanation:
        "Le golf consiste à frapper une balle dans des trous à l'aide de clubs sur un parcours.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport qui se joue avec un palet ?",
    options: ["Football", "Hockey sur glace", "Basket-ball"],
    answer: "Hockey sur glace",
    explanation:
        "Le hockey sur glace se joue avec un palet que les joueurs doivent envoyer dans le but adverse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du jeu de volley-ball ?",
    options: [
      "Marquer des points",
      "Attraper des ballons",
      "Frapper des cibles",
    ],
    answer: "Marquer des points",
    explanation:
        "Le volley-ball a pour but de marquer des points en frappant le ballon au sol dans le camp adverse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est associé à la ville de Rio de Janeiro ?",
    options: ["Football", "Baseball", "Rugby"],
    answer: "Football",
    explanation:
        "Le football est le sport phare et populaire à Rio de Janeiro, notamment avec le célèbre club Flamengo.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le record du monde de saut à la perche ?",
    options: ["6,05 mètres", "6,18 mètres", "6,15 mètres"],
    answer: "6,18 mètres",
    explanation:
        "Le record du monde de saut à la perche est de 6,18 mètres, établi par Armand Duplantis.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a remporté la Coupe du Monde de football en 2018 ?",
    options: ["France", "Brésil", "Allemagne"],
    answer: "France",
    explanation:
        "La France a gagné la Coupe du Monde de football pour la deuxième fois en 2018 après l'avoir déjà remportée en 1998.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport utilise-t-on un volant ?",
    options: ["Tennis", "Badminton", "Football"],
    answer: "Badminton",
    explanation:
        "Le badminton est le sport qui se joue avec un volant, un petit projectile qu'on frappe avec une raquette.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est considéré comme le plus grand nageur de tous les temps ?",
    options: ["Michael Phelps", "Ryan Lochte", "Mark Spitz"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps détient le record du plus grand nombre de médailles d'or aux Jeux Olympiques avec 23 médailles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel événement sportif se déroule tous les quatre ans et est considéré comme les Jeux Olympiques d'été ?",
    options: [
      "La Coupe du Monde de Football",
      "Le Tour de France",
      "Les Jeux Olympiques",
    ],
    answer: "Les Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques d'été sont un événement international majeur qui a lieu tous les quatre ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le pays d'origine du sport du sumo ?",
    options: ["Chine", "Japon", "Corée"],
    answer: "Japon",
    explanation:
        "Le sumo est un sport traditionnel japonais, avec des origines remontant à plusieurs siècles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a remporté le plus de médailles d'or aux Jeux Olympiques d'hiver ?",
    options: ["Ole Einar Bjørndalen", "Marit Bjørgen", "Bjørn Dæhlie"],
    answer: "Ole Einar Bjørndalen",
    explanation:
        "Ole Einar Bjørndalen a remporté 13 médailles d'or aux Jeux Olympiques d'hiver, ce qui fait de lui le plus titré dans cette catégorie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport principal où l'on utilise une planche de surf ?",
    options: ["Planche à voile", "Surf", "Kitesurf"],
    answer: "Surf",
    explanation:
        "Le surf est un sport nautique qui consiste à glisser sur les vagues sur une planche de surf.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "En quelle année les premiers Jeux Olympiques modernes ont-ils eu lieu ?",
    options: ["1896", "1900", "1924"],
    answer: "1896",
    explanation:
        "Les premiers Jeux Olympiques modernes ont eu lieu à Athènes en 1896.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport collectif le plus pratiqué au monde ?",
    options: ["Basket-ball", "Football", "Rugby"],
    answer: "Football",
    explanation:
        "Le football est considéré comme le sport collectif le plus pratiqué à l'échelle mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel championnat de football est le plus prestigieux en Europe ?",
    options: ["Ligue 1", "Premier League", "La Liga"],
    answer: "Premier League",
    explanation:
        "La Premier League anglaise est souvent considérée comme le championnat de football le plus compétitif et prestigieux en Europe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du rugby à XV ?",
    options: ["Marquer des buts", "Marquer des essais", "Marquer des paniers"],
    answer: "Marquer des essais",
    explanation:
        "Dans le rugby à XV, l'objectif est de marquer des essais en posant le ballon dans l'en-but adverse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a accueilli les Jeux Olympiques d'hiver en 2010 ?",
    options: ["Canada", "Russie", "Italie"],
    answer: "Canada",
    explanation:
        "Le Canada a accueilli les Jeux Olympiques d'hiver en 2010, à Vancouver.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est le joueur de tennis le plus titré en Grand Chelem ?",
    options: ["Roger Federer", "Rafael Nadal", "Novak Djokovic"],
    answer: "Novak Djokovic",
    explanation:
        "Novak Djokovic a atteint un total de 24 titres de Grand Chelem, ce qui en fait le joueur le plus titré.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la course cycliste qui traverse la France chaque année ?",
    options: ["Le Giro", "La Vuelta", "Le Tour de France"],
    answer: "Le Tour de France",
    explanation:
        "Le Tour de France est une compétition de cyclisme sur route qui se déroule chaque été en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal tournoi de tennis sur gazon ?",
    options: ["Roland-Garros", "Wimbledon", "Open d'Australie"],
    answer: "Wimbledon",
    explanation:
        "Wimbledon est le tournoi de tennis le plus ancien et réputé, se jouant sur gazon chaque été à Londres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a remporté le plus de titres de champion du monde de Formule 1 ?",
    options: ["Lewis Hamilton", "Michael Schumacher", "Sebastian Vettel"],
    answer: "Lewis Hamilton",
    explanation:
        "Lewis Hamilton a remporté 7 titres de champion du monde, égalant le record de Michael Schumacher.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se déroule sur une superficie d'eau glacée ?",
    options: ["Hockey sur glace", "Patinage artistique", "Curling"],
    answer: "Hockey sur glace",
    explanation:
        "Le hockey sur glace se joue sur une patinoire, nécessitant des patins adaptés et une rondelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est associé aux Jeux Paralympiques ?",
    options: ["Athlétisme", "Basket-ball", "Natation"],
    answer: "Athlétisme",
    explanation:
        "L'athlétisme est l'un des sports phares des Jeux Paralympiques, avec de nombreuses disciplines.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du handball ?",
    options: ["Marquer des paniers", "Marquer des buts", "Marquer des essais"],
    answer: "Marquer des buts",
    explanation:
        "Le but du handball est de marquer le plus de buts possible dans le but adverse en lançant un ballon.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport se joue généralement sur un court avec un filet et des raquettes ?",
    options: ["Badminton", "Tennis", "Squash"],
    answer: "Tennis",
    explanation:
        "Le tennis se joue sur un court, utilisant un filet et des raquettes pour frapper une balle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Comment s'appelle le terme utilisé pour décrire un match de boxe se déroulant sur plusieurs rounds ?",
    options: ["Combat", "Bataille", "Match"],
    answer: "Combat",
    explanation:
        "Le terme 'combat' est utilisé pour désigner un match de boxe se concluant par plusieurs rounds.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a écrit le livre 'La méthode de travail du champion' en athlétisme ?",
    options: ["Paavo Nurmi", "Carl Lewis", "Usain Bolt"],
    answer: "Carl Lewis",
    explanation:
        "Carl Lewis a écrit plusieurs ouvrages sur son expérience et ses méthodes d'entraînement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport combine ski et tir ?",
    options: ["Ski alpin", "Biathlon", "Ski de fond"],
    answer: "Biathlon",
    explanation:
        "Le biathlon est un sport qui combine le ski de fond et le tir à la carabine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est l'objectif principal du volleyball ?",
    options: ["Marquer des points", "Éviter de perdre", "Contrôler le jeu"],
    answer: "Marquer des points",
    explanation:
        "L'objectif du volleyball est de marquer des points en envoyant le ballon dans le camp adverse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est la première femme à avoir remporté un titre de champion du monde en boxe professionnelle ?",
    options: ["Laila Ali", "Christy Martin", "Mikaela Mayer"],
    answer: "Laila Ali",
    explanation:
        "Laila Ali, fille de Muhammad Ali, est devenue une icône de la boxe et a remporté des titres majeurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du symbole de la victoire des athlètes aux Jeux Olympiques ?",
    options: ["Médaille", "Flamme", "Couronne d'olivier"],
    answer: "Couronne d'olivier",
    explanation:
        "La couronne d'olivier était traditionnellement offerte aux vainqueurs des Jeux Olympiques de l'Antiquité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se joue avec un cercle et un ballon ?",
    options: ["Basket-ball", "Football", "Hockey"],
    answer: "Basket-ball",
    explanation:
        "Le basket-ball se joue en lançant un ballon dans un cercle suspendu à une certaine hauteur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a remporté les Jeux Olympiques d'été de 2008 ?",
    options: ["Chine", "États-Unis", "Russie"],
    answer: "Chine",
    explanation:
        "La Chine a accueilli et remporté le plus de médailles aux Jeux Olympiques d'été de 2008 à Pékin.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport utilise-t-on des raquettes et un shuttlecock ?",
    options: ["Tennis", "Badminton", "Squash"],
    answer: "Badminton",
    explanation:
        "Le badminton est le seul sport parmi ces options qui utilise un shuttlecock, ou volant.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays est le plus titré dans l'histoire de la Coupe du Monde de la FIFA ?",
    options: ["Brésil", "Allemagne", "Argentine"],
    answer: "Brésil",
    explanation:
        "Le Brésil a remporté la Coupe du Monde de la FIFA à 5 reprises, un record mondial.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a été le premier joueur français à gagner le Ballon d'Or ?",
    options: ["Michel Platini", "Zinedine Zidane", "Raymond Kopa"],
    answer: "Raymond Kopa",
    explanation:
        "Raymond Kopa a été le premier joueur français à gagner le Ballon d'Or en 1958.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est associé au terme 'slam dunk' ?",
    options: ["Basket-ball", "Handball", "Volleyball"],
    answer: "Basket-ball",
    explanation:
        "Le 'slam dunk' est une technique de basket-ball où un joueur marque en dunkant le ballon dans le panier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le plus grand événement de sports d'hiver ?",
    options: [
      "Jeux Olympiques d'hiver",
      "Coupe du Monde de Ski",
      "Jeux Paralympiques d'hiver",
    ],
    answer: "Jeux Olympiques d'hiver",
    explanation:
        "Les Jeux Olympiques d'hiver rassemblent les meilleurs athlètes du monde en sports d'hiver tous les quatre ans.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quelle est la durée d’un match de football professionnel, sans les arrêts de jeu ?",
    options: ["90 minutes", "80 minutes", "120 minutes"],
    answer: "90 minutes",
    explanation:
        "Un match de football professionnel se joue en deux mi-temps de 45 minutes chacune, soit un total de 90 minutes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète français a remporté la médaille d'or au 3000 mètres steeple aux Jeux Olympiques de 2008 ?",
    options: ["Mahiedine Mekhissi-Benabbad", "Yoann Kowal", "Boris Berian"],
    answer: "Mahiedine Mekhissi-Benabbad",
    explanation:
        "Mahiedine Mekhissi-Benabbad a remporté la médaille d'or au 3000 mètres steeple à Pékin.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport utilise-t-on des quilles ?",
    options: ["Bowling", "Golf", "Tennis"],
    answer: "Bowling",
    explanation:
        "Le bowling est un sport où l'on lance une boule pour renverser des quilles disposées en triangle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nombre d'athlètes participant aux Jeux Olympiques d'été en moyenne ?",
    options: ["10 000", "5 000", "20 000"],
    answer: "10 000",
    explanation:
        "En moyenne, environ 10 000 athlètes participent aux Jeux Olympiques d'été.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est le coureur le plus rapide du monde sur 100 mètres ?",
    options: ["Usain Bolt", "Tyson Gay", "Justin Gatlin"],
    answer: "Usain Bolt",
    explanation:
        "Usain Bolt détient le record du monde du 100 mètres avec un temps de 9,58 secondes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quelle est la vitesse maximale atteinte sur un tapis de course en compétition ?",
    options: ["20 km/h", "30 km/h", "40 km/h"],
    answer: "20 km/h",
    explanation:
        "Lors de compétitions, la vitesse maximale atteinte sur un tapis de course est généralement de 20 km/h.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport où l'on joue avec un petit palet noir ?",
    options: ["Hockey sur glace", "Football", "Basket-ball"],
    answer: "Hockey sur glace",
    explanation:
        "Le hockey sur glace utilise un palet noir qu'il faut frapper pour marquer des buts.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport le plus réglementé et où la lutte est interdite ?",
    options: ["Boxe", "MMA", "Karate"],
    answer: "Boxe",
    explanation:
        "La boxe est très réglementée et la lutte est interdite contrairement à d'autres arts martiaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a remporté la Coupe du monde de rugby en 2023 ?",
    options: ["Nouvelle-Zélande", "Afrique du Sud", "Angleterre"],
    answer: "Afrique du Sud",
    explanation:
        "L'Afrique du Sud a remporté la Coupe du monde de rugby de 2023, consolidant son statut dans ce sport.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le nombre de joueurs dans une équipe de rugby à XV ?",
    options: ["15", "12", "10"],
    answer: "15",
    explanation:
        "Une équipe de rugby à XV est composée de 15 joueurs sur le terrain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel ancien président français est un grand amateur de tennis ?",
    options: ["François Mitterrand", "Jacques Chirac", "Nicolas Sarkozy"],
    answer: "Jacques Chirac",
    explanation:
        "Jacques Chirac était connu pour son affection pour le tennis et sa présence fréquente aux grands tournois.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du cyclisme sur route ?",
    options: [
      "Rouler sur de longues distances",
      "Faire des sauts",
      "Monter des collines",
    ],
    answer: "Rouler sur de longues distances",
    explanation:
        "Le cyclisme sur route consiste principalement à parcourir de longues distances sur des routes asphaltées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre tournoi de tennis joué à Roland-Garros ?",
    options: ["Open d'Australie", "Wimbledon", "Roland-Garros"],
    answer: "Roland-Garros",
    explanation:
        "Roland-Garros est le tournoi de tennis sur terre battue le plus prestigieux au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport fait appel à la concentration et à la stratégie, souvent joué en silence ?",
    options: ["Échecs", "Poker", "Billard"],
    answer: "Échecs",
    explanation:
        "Les échecs sont un jeu de société qui nécessite une grande concentration et une stratégie réfléchie.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est le coureur le plus titré dans l'histoire du Tour de France ?",
    options: ["Eddy Merckx", "Bernard Hinault", "Lance Armstrong"],
    answer: "Eddy Merckx",
    explanation:
        "Eddy Merckx a gagné le Tour de France à cinq reprises, ce qui reste un record.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel tennisman a remporté le plus de titres du Grand Chelem ?",
    options: ["Roger Federer", "Rafael Nadal", "Novak Djokovic"],
    answer: "Novak Djokovic",
    explanation:
        "Novak Djokovic détient le record du plus grand nombre de titres du Grand Chelem en simple masculin.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport utilise un palet ?",
    options: ["Hockey sur glace", "Football", "Basketball"],
    answer: "Hockey sur glace",
    explanation:
        "Le hockey sur glace est le seul sport parmi ces options qui utilise un palet.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est l'athlète le plus médaillé des Jeux Olympiques ?",
    options: ["Michael Phelps", "Usain Bolt", "Larisa Latynina"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps a remporté un total de 28 médailles aux Jeux Olympiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le nom de la plus grande course automobile au monde ?",
    options: ["Le Mans", "Monaco", "Indianapolis 500"],
    answer: "Indianapolis 500",
    explanation:
        "L'Indianapolis 500 est souvent considérée comme la plus grande course automobile au monde.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se joue avec un ballon ovale ?",
    options: ["Rugby", "Football", "Volley-ball"],
    answer: "Rugby",
    explanation:
        "Le rugby est le seul sport parmi ces choix qui utilise un ballon ovale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a écrit le livre 'Open', une autobiographie de tennis ?",
    options: ["Andre Agassi", "Serena Williams", "Roger Federer"],
    answer: "Andre Agassi",
    explanation:
        "Andre Agassi est l'auteur du livre 'Open', qui raconte sa carrière au tennis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle ville a accueilli les Jeux Olympiques d'été en 1936 ?",
    options: ["Berlin", "Paris", "Tokyo"],
    answer: "Berlin",
    explanation: "Berlin a accueilli les Jeux Olympiques d'été en 1936.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel joueur de basketball est surnommé 'Air Jordan' ?",
    options: ["Kobe Bryant", "Michael Jordan", "LeBron James"],
    answer: "Michael Jordan",
    explanation:
        "Michael Jordan est connu sous le surnom d'Air Jordan en raison de son style de jeu aérien.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal tournoi de tennis sur terre battue ?",
    options: ["Roland-Garros", "Wimbledon", "US Open"],
    answer: "Roland-Garros",
    explanation:
        "Roland-Garros est le principal tournoi de tennis sur terre battue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le pays d'origine du judo ?",
    options: ["Japon", "Chine", "Corée"],
    answer: "Japon",
    explanation: "Le judo est un art martial qui a été créé au Japon.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport national du Canada ?",
    options: ["Hockey sur glace", "Lacrosse", "Football"],
    answer: "Lacrosse",
    explanation: "Le lacrosse est le sport national du Canada.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a remporté la médaille d'or en athlétisme au 100 mètres aux Jeux Olympiques de 2008 ?",
    options: ["Usain Bolt", "Justin Gatlin", "Tyson Gay"],
    answer: "Usain Bolt",
    explanation:
        "Usain Bolt a remporté la médaille d'or du 100 mètres aux JO de 2008.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la durée d'un match de football réglementaire ?",
    options: ["90 minutes", "80 minutes", "70 minutes"],
    answer: "90 minutes",
    explanation:
        "Un match de football réglementaire dure 90 minutes, réparties en deux mi-temps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a organisé les Jeux Olympiques d'été en 2004 ?",
    options: ["Grèce", "Australie", "États-Unis"],
    answer: "Grèce",
    explanation: "La Grèce a accueilli les Jeux Olympiques d'été en 2004.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal championnat de football en Espagne ?",
    options: ["Serie A", "Premier League", "La Liga"],
    answer: "La Liga",
    explanation:
        "La Liga est le championnat de football professionnel en Espagne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se pratique sur un court avec un filet ?",
    options: ["Tennis", "Football", "Rugby"],
    answer: "Tennis",
    explanation: "Le tennis se pratique sur un court divisé par un filet.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel athlète a battu le record du monde du 100 mètres en 2009 ?",
    options: ["Usain Bolt", "Carl Lewis", "Maurice Greene"],
    answer: "Usain Bolt",
    explanation:
        "Usain Bolt a battu le record du monde du 100 mètres en 2009 avec un temps de 9,58 secondes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport se pratique en équipe de sept joueurs sur un terrain de gazon ?",
    options: ["Rugby à VII", "Football", "Hockey sur gazon"],
    answer: "Rugby à VII",
    explanation:
        "Le rugby à VII se joue en équipe de sept sur un terrain de gazon.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a remporté le tournoi de Wimbledon en 2019 chez les hommes ?",
    options: ["Novak Djokovic", "Roger Federer", "Rafael Nadal"],
    answer: "Novak Djokovic",
    explanation:
        "Novak Djokovic a remporté le tournoi de Wimbledon en 2019 après un match épique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays est connu pour ses skieurs célèbres comme Marcel Hirscher ?",
    options: ["Suisse", "Autriche", "France"],
    answer: "Autriche",
    explanation:
        "L'Autriche est célèbre pour ses skieurs de ski alpin, dont Marcel Hirscher.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport mêle arts martiaux et danse ?",
    options: ["Capoeira", "Taekwondo", "Boxe"],
    answer: "Capoeira",
    explanation:
        "La capoeira est un art martial brésilien qui allie combat et danse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le nom du célèbre marathon qui a lieu à Boston ?",
    options: ["Boston Marathon", "New York Marathon", "Chicago Marathon"],
    answer: "Boston Marathon",
    explanation:
        "Le Boston Marathon est l'une des courses les plus anciennes et les plus prestigieuses au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a été le premier homme à marcher sur la Lune ?",
    options: ["Neil Armstrong", "Yuri Gagarin", "Buzz Aldrin"],
    answer: "Neil Armstrong",
    explanation:
        "Neil Armstrong a été le premier homme à marcher sur la Lune en 1969.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est le berceau du football ?",
    options: ["Angleterre", "France", "Brésil"],
    answer: "Angleterre",
    explanation:
        "Le football moderne trouve ses origines en Angleterre au 19ème siècle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le tournoi de tennis le plus prestigieux au monde ?",
    options: ["Roland-Garros", "Wimbledon", "US Open"],
    answer: "Wimbledon",
    explanation:
        "Wimbledon est considéré comme le tournoi de tennis le plus prestigieux au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport se joue principalement sur un terrain en terre battue ?",
    options: ["Tennis", "Basketball", "Baseball"],
    answer: "Tennis",
    explanation:
        "Le tennis est le sport qui se joue principalement sur un terrain en terre battue.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel joueur de football est surnommé 'La Pulga' ?",
    options: ["Cristiano Ronaldo", "Lionel Messi", "Neymar"],
    answer: "Lionel Messi",
    explanation:
        "Lionel Messi est surnommé 'La Pulga', signifiant 'la puce' en espagnol.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a remporté les Jeux Olympiques d'hiver de 2014 ?",
    options: ["Russie", "Canada", "Norvège"],
    answer: "Russie",
    explanation:
        "La Russie a remporté les Jeux Olympiques d'hiver de 2014 à Sotchi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle compétition est le Championnat du monde de football ?",
    options: ["Copa América", "Euro", "FIFA World Cup"],
    answer: "FIFA World Cup",
    explanation:
        "La FIFA World Cup est la compétition internationale de football la plus prestigieuse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport pratiqué lors des Jeux Olympiques d'été ?",
    options: ["Athlétisme", "Hockey sur glace", "Ski alpin"],
    answer: "Athlétisme",
    explanation: "L'athlétisme est un sport clé des Jeux Olympiques d'été.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a remporté la médaille d'or aux JO d'Athènes en 2004 au saut en longueur ?",
    options: ["Dwight Phillips", "Mike Powell", "Bob Beamon"],
    answer: "Dwight Phillips",
    explanation:
        "Dwight Phillips a remporté la médaille d'or au saut en longueur aux JO d'Athènes en 2004.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est le plus titré en Coupe du Monde de football ?",
    options: ["Brésil", "Allemagne", "Argentine"],
    answer: "Brésil",
    explanation:
        "Le Brésil est la nation la plus titrée avec cinq victoires en Coupe du Monde.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal événement sportif annuel en natation ?",
    options: [
      "Championnats du Monde",
      "Jeux Olympiques",
      "Championnat d'Europe",
    ],
    answer: "Championnats du Monde",
    explanation:
        "Les Championnats du Monde de natation sont un événement majeur du calendrier sportif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a remporté le tournoi de Roland Garros en 2018 chez les hommes ?",
    options: ["Rafael Nadal", "Novak Djokovic", "Roger Federer"],
    answer: "Rafael Nadal",
    explanation:
        "Rafael Nadal a remporté Roland Garros en 2018, poursuivant son règne sur la terre battue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "En quelle année se sont déroulés les premiers Jeux Olympiques modernes ?",
    options: ["1896", "1900", "1924"],
    answer: "1896",
    explanation:
        "Les premiers Jeux Olympiques modernes ont eu lieu à Athènes en 1896.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est connu pour ses exploits en gymnastique artistique ?",
    options: ["Simone Biles", "Nastia Liukin", "Shannon Miller"],
    answer: "Simone Biles",
    explanation:
        "Simone Biles est une gymnaste artistique reconnue pour sa domination dans le sport.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est le berceau des arts martiaux ?",
    options: ["Chine", "Japon", "Inde"],
    answer: "Chine",
    explanation:
        "La Chine est souvent considérée comme le berceau des arts martiaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport collectif où le but est de marquer des paniers ?",
    options: ["Basketball", "Handball", "Rugby"],
    answer: "Basketball",
    explanation:
        "Le basketball est un sport collectif où les équipes marquent des points en mettant le ballon dans un panier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel athlète a remporté le Tour de France à cinq reprises ?",
    options: ["Eddy Merckx", "Bradley Wiggins", "Greg LeMond"],
    answer: "Eddy Merckx",
    explanation:
        "Eddy Merckx est l'un des rares cyclistes à avoir remporté le Tour de France cinq fois.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays était le premier à accueillir les Jeux Olympiques d'hiver ?",
    options: ["France", "Suisse", "Norvège"],
    answer: "France",
    explanation:
        "La France a été le premier pays à accueillir les Jeux Olympiques d'hiver en 1924.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est le créateur du mouvement olympique moderne ?",
    options: [
      "Pierre de Coubertin",
      "Baron de Coubertin",
      "Henri de Coubertin",
    ],
    answer: "Pierre de Coubertin",
    explanation:
        "Pierre de Coubertin est reconnu comme le fondateur des Jeux Olympiques modernes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se joue avec une balle jaune et un filet ?",
    options: ["Tennis", "Badminton", "Squash"],
    answer: "Tennis",
    explanation:
        "Le tennis se joue avec une balle jaune et un filet sur un court.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Dans quel sport utilise t-on une palette pour frapper la balle ?",
    options: ["Tennis", "Squash", "Badminton"],
    answer: "Badminton",
    explanation: "Au badminton, on utilise une palette pour frapper un volant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel grand événement sportif a lieu tous les quatre ans ?",
    options: ["Coupe du Monde", "Jeux Olympiques", "Championnats d'Europe"],
    answer: "Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques ont lieu tous les quatre ans dans des villes du monde entier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport utilise des clubs pour frapper une balle dans des trous ?",
    options: ["Golf", "Cricket", "Baseball"],
    answer: "Golf",
    explanation:
        "Le golf est le sport où l'on utilise des clubs pour frapper une balle dans des trous.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel athlète a dominé le sprint féminin dans les années 1980 ?",
    options: [
      "Florence Griffith-Joyner",
      "Mary Decker",
      "Shelly-Ann Fraser-Pryce",
    ],
    answer: "Florence Griffith-Joyner",
    explanation:
        "Florence Griffith-Joyner a marqué les années 1980 avec ses performances au sprint.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a remporté la Coupe du Monde de la FIFA en 1998 ?",
    options: ["Brésil", "France", "Allemagne"],
    answer: "France",
    explanation:
        "La France a remporté sa première Coupe du Monde en 1998 en battant le Brésil en finale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui détient le record du monde du 100 mètres pour les hommes ?",
    options: ["Usain Bolt", "Carl Lewis", "Justin Gatlin"],
    answer: "Usain Bolt",
    explanation:
        "Usain Bolt a établi le record du monde du 100 mètres en 2009 avec un temps de 9,58 secondes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel événement sportif se déroule tous les quatre ans et comprend des disciplines olympiques ?",
    options: [
      "Coupe du Monde de Football",
      "Jeux Olympiques",
      "Championnat d'Europe de Football",
    ],
    answer: "Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques se tiennent tous les quatre ans et incluent de nombreux sports.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Dans quel sport utilise-t-on un cirque pour effectuer des acrobaties ?",
    options: ["Athlétisme", "Arts martiaux", "Gymnastique"],
    answer: "Gymnastique",
    explanation:
        "La gymnastique fait appel à un appareil appelé 'cirque' pour réaliser des figures acrobatiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est considéré comme le berceau du judo ?",
    options: ["Russie", "Japon", "Brésil"],
    answer: "Japon",
    explanation: "Le judo a été inventé au Japon par Jigoro Kano en 1882.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le vinage dans le cyclisme ?",
    options: ["Saut d'obstacles", "Tour d'Italie", "Tour de France"],
    answer: "Tour de France",
    explanation:
        "Le Tour de France est la course de cyclisme la plus prestigieuse au monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal trophée du football européen ?",
    options: ["Ligue des champions", "Euro", "Coupe du Monde"],
    answer: "Ligue des champions",
    explanation:
        "La Ligue des champions est le tournoi le plus convoité pour les clubs de football en Europe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a remporté le plus de titres en Grand Chelem au tennis masculin ?",
    options: ["Roger Federer", "Rafael Nadal", "Novak Djokovic"],
    answer: "Novak Djokovic",
    explanation:
        "Novak Djokovic détient le record du plus grand nombre de titres en Grand Chelem chez les hommes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la distance d'un marathon ?",
    options: ["42,195 km", "26,2 km", "30 km"],
    answer: "42,195 km",
    explanation:
        "La distance officielle d'un marathon est de 42,195 kilomètres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a remporté le dernier Euro de football masculin avant 2021 ?",
    options: ["Espagne", "Portugal", "France"],
    answer: "Portugal",
    explanation:
        "Le Portugal a remporté l'Euro 2016 en battant la France en finale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel mouvement est à la base de l'escalade ?",
    options: ["Rapidité", "Force", "Techniques de grimpe"],
    answer: "Techniques de grimpe",
    explanation:
        "L'escalade repose principalement sur des techniques de grimpe adaptées aux surfaces verticales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se joue sur un court en terre battue ?",
    options: ["Badminton", "Tennis", "Squash"],
    answer: "Tennis",
    explanation:
        "Le tennis peut être pratiqué sur différentes surfaces, dont la terre battue, qui est très populaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel mouvement de danse est pratiqué dans la rythmique sportive ?",
    options: ["Salsa", "Ballet", "Danse moderne"],
    answer: "Ballet",
    explanation:
        "Le ballet est une forme de danse classique souvent intégrée aux performances de rythmique sportive.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est le footballeur argentin connu sous le surnom de 'La Pulga' ?",
    options: ["Diego Maradona", "Lionel Messi", "Gabriel Batistuta"],
    answer: "Lionel Messi",
    explanation:
        "Lionel Messi, surnommé 'La Pulga', est considéré comme l'un des meilleurs footballeurs de l'histoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but principal dans un match de hockey sur glace ?",
    options: ["Marquer des buts", "Faire des passes", "Bloquer des tirs"],
    answer: "Marquer des buts",
    explanation:
        "Le but principal dans un match de hockey sur glace est de marquer des buts dans le but adverse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Dans quelle discipline olympique les athlètes s'affrontent-ils sur une poutre ?",
    options: ["Natation", "Gymnastique", "Escrime"],
    answer: "Gymnastique",
    explanation:
        "La poutre est un agrès utilisé en gymnastique artistique durant les compétitions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui a été le premier joueur de NBA à être élu MVP à l'unanimité ?",
    options: ["Stephen Curry", "LeBron James", "Michael Jordan"],
    answer: "Stephen Curry",
    explanation:
        "Stephen Curry a été élu MVP à l'unanimité en 2016, une première dans l'histoire de la NBA.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport de combat utilise des gants rembourrés ?",
    options: ["Boxe", "Karate", "Judo"],
    answer: "Boxe",
    explanation:
        "La boxe se pratique avec des gants rembourrés pour protéger les mains des combattants.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel événement sportif se déroule en décembre et met en compétition des équipes de football de clubs ?",
    options: [
      "Coupes d'Afrique des Nations",
      "Coupe du Monde des Clubs",
      "Européennes de Football",
    ],
    answer: "Coupe du Monde des Clubs",
    explanation:
        "La Coupe du Monde des Clubs est un tournoi annuel qui regroupe les meilleurs clubs du monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a gagné la Coupe du Monde féminine de football en 2019 ?",
    options: ["États-Unis", "Pays-Bas", "Japon"],
    answer: "États-Unis",
    explanation:
        "Les États-Unis ont remporté la Coupe du Monde féminine de football en 2019.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport national du Japon ?",
    options: ["Karate", "Baseball", "Sumo"],
    answer: "Sumo",
    explanation:
        "Le sumo est considéré comme le sport national traditionnel du Japon.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal organe dirigeant du football mondial ?",
    options: ["FIFA", "UEFA", "LFP"],
    answer: "FIFA",
    explanation:
        "La FIFA est l'organisation qui régit le football au niveau mondial.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le pays d'origine du baseball ?",
    options: ["États-Unis", "Japon", "Cuba"],
    answer: "États-Unis",
    explanation:
        "Le baseball est largement associé aux États-Unis, où il est devenu un sport majeur au 19ème siècle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la durée d'un match de football officiel ?",
    options: ["60 minutes", "90 minutes", "120 minutes"],
    answer: "90 minutes",
    explanation:
        "Un match de football standard dure 90 minutes, réparties en deux mi-temps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre coureur de fond éthiopien qui a battu des records mondiaux ?",
    options: ["Haile Gebrselassie", "Mo Farah", "Usain Bolt"],
    answer: "Haile Gebrselassie",
    explanation:
        "Haile Gebrselassie est une légende de la course de fond, avec plusieurs records du monde à son actif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition de football interclubs la plus prestigieuse en Europe ?",
    options: ["Europa League", "Ligue des champions", "Supercoupe d'Europe"],
    answer: "Ligue des champions",
    explanation:
        "La Ligue des champions est la compétition la plus prestigieuse entre clubs de football européens.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le sport qui consiste à grimper sur des surfaces rocheuses ?",
    options: ["Escalade", "Randonnée", "VTT"],
    answer: "Escalade",
    explanation:
        "L'escalade est le sport consacré à l'ascension de surfaces rocheuses ou d'installations artificielles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le principal tournoi de tennis masculin sur terre battue ?",
    options: ["Roland-Garros", "Wimbledon", "US Open"],
    answer: "Roland-Garros",
    explanation:
        "Roland-Garros est le tournoi de tennis le plus prestigieux sur terre battue au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre footballeur brésilien surnommé 'Pelé' ?",
    options: ["Edson Arantes do Nascimento", "Ronaldinho", "Zico"],
    answer: "Edson Arantes do Nascimento",
    explanation:
        "Pelé est le surnom d'Edson Arantes do Nascimento, considéré comme l'un des meilleurs footballeurs de tous les temps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la couleur des médailles d'or aux Jeux Olympiques ?",
    options: ["Argent", "Or", "Bronze"],
    answer: "Or",
    explanation:
        "Les médailles d'or attribuées aux vainqueurs des Jeux Olympiques sont en fait recouvertes d'or.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport où l'on utilise un kayak ?",
    options: ["Canoë-Kayak", "Surf", "Rame"],
    answer: "Canoë-Kayak",
    explanation:
        "Le canoë-kayak est un sport aquatique où l'on navigue sur un kayak.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a récemment créé la Ligue professionnelle de Football ?",
    options: ["France", "Italie", "Allemagne"],
    answer: "France",
    explanation:
        "La Ligue professionnelle de Football a été créée récemment pour organiser le football professionnel en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète est célèbre pour sa capacité à courir un marathon en moins de deux heures ?",
    options: ["Kipchoge", "Bolt", "Farah"],
    answer: "Kipchoge",
    explanation:
        "Eliud Kipchoge a réalisé cet exploit en 2019 lors du projet INEOS 1:59.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le principal obstacle dans une course d'obstacles ?",
    options: ["Haies", "Eaux", "Virages"],
    answer: "Haies",
    explanation:
        "Les haies sont les principaux obstacles à franchir dans une course d'obstacles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel joueur de football a connu le plus grand nombre de Ballons d'Or ?",
    options: ["Lionel Messi", "Cristiano Ronaldo", "Johan Cruyff"],
    answer: "Lionel Messi",
    explanation:
        "Lionel Messi détient le record avec un nombre record de Ballons d'Or remportés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Combien de joueurs composaient une équipe de basket-ball sur le terrain ?",
    options: ["4", "5", "6"],
    answer: "5",
    explanation:
        "Une équipe de basket-ball se compose de 5 joueurs sur le terrain pendant le jeu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport fait partie des Jeux d'Hiver depuis leur création ?",
    options: ["Ski", "Patinage artistique", "Luge"],
    answer: "Ski",
    explanation:
        "Le ski est l'un des sports originaux des premiers Jeux Olympiques d'Hiver.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le terme pour désigner l'absence de score dans un match de football ?",
    options: ["Nul", "Match nul", "0-0"],
    answer: "0-0",
    explanation:
        "Un match de football sans score est désigné par '0-0' dans la notation des résultats.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète américain a révolutionné le sport du basket-ball avec un style de jeu unique ?",
    options: ["Michael Jordan", "Kobe Bryant", "Shaquille O'Neal"],
    answer: "Michael Jordan",
    explanation:
        "Michael Jordan est souvent considéré comme le plus grand joueur de basket-ball de tous les temps.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport se joue dans une piscine et utilise des bâtons pour toucher une balle ?",
    options: ["Water-polo", "Natation synchronisée", "Plongeon"],
    answer: "Water-polo",
    explanation:
        "Le water-polo se joue dans l'eau et nécessite des bâtons pour marquer des buts.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre tournoi de tennis sur gazon qui se déroule à Londres ?",
    options: ["US Open", "Open d'Australie", "Wimbledon"],
    answer: "Wimbledon",
    explanation:
        "Wimbledon est le tournoi de tennis sur gazon le plus prestigieux au monde, organisé à Londres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport d'équipe utilise des raquettes et une petite balle ?",
    options: ["Tennis", "Badminton", "Squash"],
    answer: "Badminton",
    explanation:
        "Le badminton se joue avec des raquettes et un volant, mais se joue aussi avec une petite balle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre boxeur américain qui a été champion du monde des poids lourds ?",
    options: ["Mike Tyson", "Muhammad Ali", "Joe Louis"],
    answer: "Muhammad Ali",
    explanation:
        "Muhammad Ali est célèbre pour ses exploits en boxe et son titre de champion du monde des poids lourds.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel championnat de football est le plus suivi dans le monde ?",
    options: ["Championship", "Ligue 1", "Premier League"],
    answer: "Premier League",
    explanation:
        "La Premier League est le championnat de football le plus regardé à l'échelle mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le plus grand tournoi de football d'Amérique du Sud ?",
    options: ["Copa Libertadores", "Copa América", "Maracanã"],
    answer: "Copa Libertadores",
    explanation:
        "La Copa Libertadores est le tournoi de football interclubs le plus prestigieux d'Amérique du Sud.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a remporté le plus de médailles aux Jeux Olympiques ?",
    options: ["Michael Phelps", "Carl Lewis", "Boris Becker"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps détient le record du nombre de médailles Olympiques avec un total de 28 médailles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la principale activité physique dans le triathlon ?",
    options: ["Natation", "Course à pied", "Vélo"],
    answer: "Natation",
    explanation:
        "Le triathlon commence par une épreuve de natation avant de passer au vélo et à la course à pied.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but principal des épreuves de saut en hauteur ?",
    options: [
      "Sauter le plus haut possible",
      "Effectuer des figures acrobatiques",
      "Atteindre la ligne d'arrivée",
    ],
    answer: "Sauter le plus haut possible",
    explanation:
        "Le saut en hauteur consiste à franchir une barre à la hauteur maximale possible.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a remporté la Coupe du Monde de football en 1998 ?",
    options: ["Brésil", "France", "Allemagne"],
    answer: "France",
    explanation:
        "La France a remporté sa première Coupe du Monde en 1998 en battant le Brésil en finale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est le coureur le plus titré de l'histoire des Jeux Olympiques ?",
    options: ["Michael Phelps", "Usain Bolt", "Carl Lewis"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps a remporté 28 médailles aux Jeux Olympiques, dont 23 en or.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport est connu comme le 'roi des sports' ?",
    options: ["Rugby", "Football", "Tennis"],
    answer: "Football",
    explanation:
        "Le football est souvent désigné comme le 'roi des sports' en raison de sa popularité mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le plus grand événement de football au monde ?",
    options: ["Coupe du Monde", "Championnat d'Europe", "Copa América"],
    answer: "Coupe du Monde",
    explanation:
        "La Coupe du Monde de la FIFA est le plus grand tournoi de football intercontinental.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport utilise-t-on un disque appelé 'frisbee' ?",
    options: ["Ultimate frisbee", "Golf", "Tennis"],
    answer: "Ultimate frisbee",
    explanation:
        "L'ultimate frisbee est un sport d'équipe joué avec un disque frisbee.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté le Tour de France en 2020 ?",
    options: ["Tadej Pogačar", "Primož Roglič", "Chris Froome"],
    answer: "Tadej Pogačar",
    explanation:
        "Tadej Pogačar a remporté le Tour de France 2020 avec une performance exceptionnelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays est le berceau du sumo ?",
    options: ["Chine", "Japon", "Corée du Sud"],
    answer: "Japon",
    explanation:
        "Le sumo est un sport traditionnel japonais ayant des racines anciennes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Dans quel sport utilise-t-on une ‘vague’ pour marquer des points ?",
    options: ["Surf", "Natation", "Basket-ball"],
    answer: "Surf",
    explanation:
        "Le surf consiste à glisser sur les vagues pour effectuer des manœuvres et gagner des points.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport national au Canada ?",
    options: ["Hockey sur glace", "Football canadien", "Crosse"],
    answer: "Hockey sur glace",
    explanation:
        "Le hockey sur glace est reconnu comme le sport national d'hiver du Canada.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Combien de joueurs y a-t-il dans une équipe de rugby à XV ?",
    options: ["15", "11", "13"],
    answer: "15",
    explanation:
        "Une équipe de rugby à XV est composée de 15 joueurs sur le terrain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui détient le record du monde du 100 mètres ?",
    options: ["Usain Bolt", "Carl Lewis", "Jesse Owens"],
    answer: "Usain Bolt",
    explanation:
        "Usain Bolt a établi le record du 100 mètres en 9,58 secondes en 2009.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport le plus pratiqué au monde ?",
    options: ["Basket-ball", "Football", "Cricket"],
    answer: "Football",
    explanation:
        "Le football est le sport le plus pratiqué et regardé au monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est la seule femme à avoir remporté trois médailles d'or en athlétisme aux Jeux Olympiques ?",
    options: ["Florence Griffith-Joyner", "Mary Decker", "Bjørn Dæhlie"],
    answer: "Florence Griffith-Joyner",
    explanation:
        "Florence Griffith-Joyner a réalisé cet exploit aux Jeux de Séoul en 1988.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le plus prestigieux tournoi de tennis sur terre battue ?",
    options: ["Wimbledon", "Roland-Garros", "US Open"],
    answer: "Roland-Garros",
    explanation:
        "Roland-Garros est le principal tournoi de tennis sur terre battue dans le monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel animal est l'emblème des Jeux Olympiques ?",
    options: ["Aigle", "Loup", "Ours"],
    answer: "Aigle",
    explanation:
        "L'aigle est souvent utilisé comme symbole de force et de compétition aux Jeux Olympiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel sport se joue avec des clubs et des balles sur un parcours ?",
    options: ["Golf", "Tennis", "Hockey"],
    answer: "Golf",
    explanation:
        "Le golf consiste à frapper une balle dans des trous en un minimum de coups sur un parcours.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le nom du célèbre marathon de Boston ?",
    options: [
      "Marathon de Chicago",
      "Marathon de New York",
      "Marathon de Boston",
    ],
    answer: "Marathon de Boston",
    explanation:
        "Le marathon de Boston est l'un des marathons les plus prestigieux au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est le joueur le plus titré en NBA ?",
    options: ["Michael Jordan", "LeBron James", "Bill Russell"],
    answer: "Bill Russell",
    explanation:
        "Bill Russell a remporté 11 championnats NBA, un record inégalé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport de combat pratiqué sur un tatami ?",
    options: ["Judo", "Boxe", "Karate"],
    answer: "Judo",
    explanation:
        "Le judo est un art martial pratiqué sur un tatami, axé sur les techniques de projection.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quelle est la distance d'un marathon en kilomètres ?",
    options: ["42,195 km", "40 km", "45 km"],
    answer: "42,195 km",
    explanation:
        "Un marathon officiel fait exactement 42,195 kilomètres de long.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se pratique sur une patinoire ?",
    options: ["Hockey", "Football", "Rugby"],
    answer: "Hockey",
    explanation: "Le hockey sur glace se pratique sur une patinoire glacée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel athlète a remporté 8 médailles d'or aux Jeux Olympiques d'été en 2008 ?",
    options: ["Michael Phelps", "Usain Bolt", "Mark Spitz"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps a remporté 8 médailles d'or aux JO de Pékin en 2008.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le pays d'origine du taekwondo ?",
    options: ["Japon", "Chine", "Corée du Sud"],
    answer: "Corée du Sud",
    explanation: "Le taekwondo est un art martial originaire de Corée du Sud.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre tournoi de tennis masculin joué sur gazon ?",
    options: ["US Open", "Roland-Garros", "Wimbledon"],
    answer: "Wimbledon",
    explanation:
        "Wimbledon est le plus ancien et prestigieux tournoi de tennis sur gazon.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel joueur est souvent considéré comme le meilleur footballeur de tous les temps ?",
    options: ["Lionel Messi", "Pele", "Cristiano Ronaldo"],
    answer: "Pele",
    explanation:
        "Pele est souvent cité comme l'un des plus grands footballeurs de l'histoire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport automobile se déroule sur circuit ?",
    options: ["Rallye", "Formule 1", "NASCAR"],
    answer: "Formule 1",
    explanation:
        "La Formule 1 est la principale compétition de sport automobile sur circuit fermé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Où se déroulent les Jeux Olympiques d'hiver ?",
    options: ["Alpes", "Montagnes Rocheuses", "Cercles Polaires"],
    answer: "Alpes",
    explanation:
        "Les Jeux Olympiques d'hiver peuvent se tenir dans des régions montagneuses comme les Alpes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du jeu de handball ?",
    options: ["Marquer des touchdowns", "Marquer des buts", "Gagner des sets"],
    answer: "Marquer des buts",
    explanation:
        "Le but du handball est de marquer des buts en lançant le ballon dans le but adverse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a le plus de médailles aux Jeux Olympiques d'été ?",
    options: ["États-Unis", "Russie", "Chine"],
    answer: "États-Unis",
    explanation:
        "Les États-Unis détiennent le plus grand nombre de médailles d'or aux Jeux Olympiques d'été.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qu'est-ce que le décathlon ?",
    options: [
      "Une course",
      "Une compétition de 10 épreuves",
      "Un sport d'équipe",
    ],
    answer: "Une compétition de 10 épreuves",
    explanation:
        "Le décathlon est un événement d'athlétisme constitué de 10 épreuves combinées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le nom de la course cycliste la plus célèbre ?",
    options: ["Tour de France", "Giro d'Italia", "Vuelta a España"],
    answer: "Tour de France",
    explanation:
        "Le Tour de France est la course cycliste la plus prestigieuse au monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Dans quel sport utilise-t-on un ‘racket’ ?",
    options: ["Tennis", "Football", "Athlétisme"],
    answer: "Tennis",
    explanation:
        "Le tennis est un sport qui se joue avec une raquette pour frapper la balle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du curling ?",
    options: [
      "Marquer des buts",
      "Glisser des pierres",
      "Attraper des anneaux",
    ],
    answer: "Glisser des pierres",
    explanation:
        "Le curling consiste à glisser des pierres sur la glace vers une cible.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui est le joueur de football le plus cher au monde ?",
    options: ["Neymar Jr", "Lionel Messi", "Cristiano Ronaldo"],
    answer: "Neymar Jr",
    explanation:
        "Neymar Jr a été transféré pour 222 millions d'euros, un record mondial.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la salle de sport pour réaliser des arts martiaux ?",
    options: ["Salle de boxe", "Dojo", "Tatami"],
    answer: "Dojo",
    explanation:
        "Un dojo est un lieu réservé à la pratique des arts martiaux, notamment le judo et le karaté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du volley-ball ?",
    options: [
      "Faire tomber le ballon",
      "Marquer des points",
      "1 et 2 sont corrects",
    ],
    answer: "1 et 2 sont corrects",
    explanation:
        "Le volley-ball vise à faire tomber le ballon dans le camp adverse et marquer des points.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays a remporté la Coupe du Monde de rugby en 2019 ?",
    options: ["Nouvelle-Zélande", "Angleterre", "Afrique du Sud"],
    answer: "Afrique du Sud",
    explanation:
        "L'Afrique du Sud a remporté la Coupe du Monde de rugby en battant l'Angleterre en 2019.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Qui est souvent considéré comme le meilleur nageur de tous les temps ?",
    options: ["Ryan Lochte", "Michael Phelps", "Mark Spitz"],
    answer: "Michael Phelps",
    explanation:
        "Michael Phelps est reconnu comme le meilleur nageur de tous les temps.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du sport où les joueurs dribblent un ballon orange ?",
    options: ["Football", "Basket-ball", "Rugby"],
    answer: "Basket-ball",
    explanation:
        "Le basket-ball est un sport où les joueurs dribblent un ballon orange pour marquer des points.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté le plus de grands chelems en tennis ?",
    options: ["Roger Federer", "Rafael Nadal", "Novak Djokovic"],
    answer: "Novak Djokovic",
    explanation:
        "Novak Djokovic a remporté un nombre record de titres du Grand Chelem en tennis.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel pays d'Amérique du Sud est célèbre pour son football ?",
    options: ["Brésil", "Colombie", "Équateur"],
    answer: "Brésil",
    explanation:
        "Le Brésil est célèbre pour sa riche histoire et ses succès en football.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se joue sur une planche avec des vagues ?",
    options: ["Surf", "Planche à roulettes", "Kitesurf"],
    answer: "Surf",
    explanation:
        "Le surf se pratique en glissant sur les vagues à l'aide d'une planche.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du jeu de baseball ?",
    options: ["Marquer des home runs", "Toucher le sol", "Attraper des balles"],
    answer: "Marquer des home runs",
    explanation:
        "Le but du baseball est de marquer des points en effectuant des home runs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom de la compétition de basketball universitaire aux États-Unis ?",
    options: ["NCAA Tournament", "NBA Finals", "Olympics"],
    answer: "NCAA Tournament",
    explanation:
        "Le tournoi NCAA est la compétition de basketball universitaire la plus importante aux États-Unis.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Qui a remporté la première Coupe du Monde de football en 1930 ?",
    options: ["Uruguay", "Brésil", "Italie"],
    answer: "Uruguay",
    explanation:
        "L'Uruguay a remporté la première Coupe du Monde de football en 1930.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel sport se joue avec des raquettes et un filet ?",
    options: ["Badminton", "Tennis de table", "Tennis"],
    answer: "Tennis",
    explanation:
        "Le tennis se joue entre deux ou quatre joueurs avec des raquettes et un filet.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel est le nom du célèbre événement de course en Angleterre, souvent associé aux paris ?",
    options: ["Grand National", "Kentucky Derby", "Preakness Stakes"],
    answer: "Grand National",
    explanation:
        "Le Grand National est une course de chevaux prestigieuse se déroulant en Angleterre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le sport qui utilise un ballon ovale ?",
    options: ["Rugby", "Football américain", "Aussie Rules"],
    answer: "Rugby",
    explanation:
        "Le rugby se joue avec un ballon ovale et est très populaire dans de nombreux pays.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question:
        "Quel pays a gagné le plus de fois la Coupe du Monde de football féminin ?",
    options: ["États-Unis", "Allemagne", "Brésil"],
    answer: "États-Unis",
    explanation:
        "Les États-Unis ont remporté la Coupe du Monde de football féminin à quatre reprises.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sport",
    question: "Quel est le but du jeu de tennis ?",
    options: [
      "Marquer des sets",
      "Frapper le ballon dans le camp adverse",
      "Les deux réponses sont correctes",
    ],
    answer: "Les deux réponses sont correctes",
    explanation:
        "En tennis, le but est de marquer des sets et de frapper la balle dans le camp adverse.",
    difficulty: "Moyenne",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizCultureGeneraleSport extends StatefulWidget {
  static const String routeName = '/gpx_exam/concours/culture_generale_sport';
  final String uid;
  final String email;

  const QuizCultureGeneraleSport({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCultureGeneraleSport> createState() =>
      _QuizCultureGeneraleSportState();
}

class _QuizCultureGeneraleSportState extends State<QuizCultureGeneraleSport>
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
        ? questionCultureSport
        : questionCultureSport
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
            'module_name': 'Culture générale - Sport',
            'quiz_name': 'Quiz culture générale sport',
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
      await _sb.from('quiz_culture_generale_sport_pages').insert({
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
      debugPrint('❌ quiz_culture_generale_sport_pages insert failed: $e');
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
