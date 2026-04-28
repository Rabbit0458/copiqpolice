// placement_questions.dart

import 'package:copiqpolice/features/placement/placement_engine.dart';

enum PlacementDomain { francais, logique, deontologie, histoire, sport }

class PlacementQuestion {
  final String id;
  final PlacementDomain domain;
  final String question;
  final List<String> answers;
  final int correctIndex;
  final Difficulty difficulty;
  final int weight;

  PlacementQuestion({
    required this.id,
    required this.domain,
    required this.question,
    required this.answers,
    required this.correctIndex,
    required this.difficulty,
    required this.weight,
  });
}

Map<PlacementDomain, List<PlacementQuestion>> generateQuestions() {
  return {
    PlacementDomain.francais: [
      PlacementQuestion(
        id: "fr_1",
        domain: PlacementDomain.francais,
        question:
            "Dans la phrase suivante, quelle est la nature de la subordonnée : "
            "Le policier affirme qu’il interviendra immédiatement.",
        answers: [
          "Subordonnée relative",
          "Subordonnée complétive",
          "Subordonnée circonstancielle",
          "Proposition indépendante",
        ],
        correctIndex: 1,
        difficulty: Difficulty.medium,
        weight: 2,
      ),
      // ➜ Ajoute ici 5 autres questions FR avec mix easy/medium/hard
    ],

    PlacementDomain.logique: [
      PlacementQuestion(
        id: "log_1",
        domain: PlacementDomain.logique,
        question:
            "Si tous les A sont B et que certains B sont C, peut-on affirmer que certains A sont C ?",
        answers: [
          "Oui, toujours",
          "Non, jamais",
          "Impossible à déterminer",
          "Oui, si C ⊂ B",
        ],
        correctIndex: 2,
        difficulty: Difficulty.hard,
        weight: 3,
      ),
    ],

    PlacementDomain.deontologie: [
      PlacementQuestion(
        id: "deo_1",
        domain: PlacementDomain.deontologie,
        question:
            "Un agent découvre une infraction commise par un collègue. Quelle est l’obligation prioritaire ?",
        answers: [
          "Ignorer pour préserver la cohésion",
          "Informer sa hiérarchie",
          "En parler aux médias",
          "Attendre confirmation extérieure",
        ],
        correctIndex: 1,
        difficulty: Difficulty.medium,
        weight: 2,
      ),
    ],

    PlacementDomain.histoire: [
      PlacementQuestion(
        id: "his_1",
        domain: PlacementDomain.histoire,
        question: "Le préfet représente l’État dans :",
        answers: [
          "La commune",
          "Le département",
          "La région uniquement",
          "La commune et le département",
        ],
        correctIndex: 3,
        difficulty: Difficulty.medium,
        weight: 2,
      ),
    ],

    PlacementDomain.sport: [
      PlacementQuestion(
        id: "sp_1",
        domain: PlacementDomain.sport,
        question:
            "Quelle filière énergétique est prioritairement sollicitée lors d’un sprint de 100m ?",
        answers: [
          "Aérobie",
          "Anaérobie lactique",
          "Anaérobie alactique",
          "Oxydative",
        ],
        correctIndex: 2,
        difficulty: Difficulty.hard,
        weight: 3,
      ),
    ],
  };
}
