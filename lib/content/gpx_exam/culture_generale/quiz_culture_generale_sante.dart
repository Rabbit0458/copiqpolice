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

final List<QuizQuestion> questionCultureSante = [
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale cause des maladies cardiovasculaires ?",
    options: [
      "Le tabagisme",
      "L'exercice physique",
      "Une alimentation riche en légumes",
    ],
    answer: "Le tabagisme",
    explanation:
        "Le tabagisme est un facteur de risque majeur pour les maladies cardiovasculaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'organe principal du système respiratoire ?",
    options: ["Le cœur", "Les poumons", "Le foie"],
    answer: "Les poumons",
    explanation:
        "Les poumons sont responsables de l'échange gazeux dans le corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel vaccin est administré pour prévenir la variole ?",
    options: [
      "Vaccin contre la grippe",
      "Vaccin contre la variole",
      "Vaccin contre la rougeole",
    ],
    answer: "Vaccin contre la variole",
    explanation:
        "Le vaccin contre la variole a été essentiel pour éradiquer cette maladie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moyen de prévenir la transmission du VIH ?",
    options: [
      "Utiliser des préservatifs",
      "Éviter le tabac",
      "Prendre des antibiotiques",
    ],
    answer: "Utiliser des préservatifs",
    explanation:
        "L'utilisation de préservatifs est efficace pour réduire le risque de transmission du VIH.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle vitamine est essentielle pour renforcer le système immunitaire ?",
    options: ["Vitamine D", "Vitamine C", "Vitamine A"],
    answer: "Vitamine C",
    explanation:
        "La vitamine C est connue pour son rôle dans le soutien du système immunitaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quels aliments sont souvent associés à un risque accru de diabète de type 2 ?",
    options: ["Fruits frais", "Aliments riches en sucre", "Légumes crus"],
    answer: "Aliments riches en sucre",
    explanation:
        "Une consommation excessive de sucres augmente le risque de diabète de type 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal de l'eau pour le corps humain ?",
    options: [
      "Réguler la température",
      "Transporter l'oxygène",
      "Fournir des calories",
    ],
    answer: "Réguler la température",
    explanation:
        "L'eau est cruciale pour maintenir l'homéostasie thermique du corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'âge recommandé pour commencer le dépistage du cancer du sein ?",
    options: ["20 ans", "30 ans", "50 ans"],
    answer: "50 ans",
    explanation:
        "Le dépistage du cancer du sein est généralement recommandé à partir de 50 ans.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle sont les conséquences d'une exposition prolongée au soleil sans protection ?",
    options: [
      "Augmentation de la vitamine D",
      "Risque de coups de soleil",
      "Amélioration de l'humeur",
    ],
    answer: "Risque de coups de soleil",
    explanation:
        "Une exposition prolongée au soleil sans protection augmente le risque de coups de soleil.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est un effet secondaire courant de la consommation excessive de sel ?",
    options: [
      "Hypertension artérielle",
      "Perte de poids",
      "Augmentation de l'énergie",
    ],
    answer: "Hypertension artérielle",
    explanation:
        "Une consommation excessive de sel peut entraîner une hypertension artérielle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le type d'exercice recommandé pour la santé cardiovasculaire ?",
    options: [
      "Exercices de musculation",
      "Exercices d'étirement",
      "Exercices d'endurance",
    ],
    answer: "Exercices d'endurance",
    explanation:
        "Les exercices d'endurance, comme la course, sont bénéfiques pour la santé cardiovasculaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal effet du tabagisme sur la santé ?",
    options: [
      "Amélioration de la vision",
      "Augmentation du risque de cancer",
      "Renforcement des os",
    ],
    answer: "Augmentation du risque de cancer",
    explanation:
        "Le tabagisme est un facteur de risque avéré pour plusieurs types de cancer.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un moyen efficace de prévenir la grippe ?",
    options: [
      "Se laver les mains régulièrement",
      "Manger beaucoup de sucre",
      "Éviter de se moucher",
    ],
    answer: "Se laver les mains régulièrement",
    explanation:
        "Se laver les mains régulièrement réduit le risque de contracter la grippe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Pourquoi est-il important de consommer des fruits et légumes ?",
    options: [
      "Pour réduire le stress",
      "Pour obtenir des nutriments essentiels",
      "Pour augmenter le poids",
    ],
    answer: "Pour obtenir des nutriments essentiels",
    explanation:
        "Les fruits et légumes fournissent des vitamines, minéraux et fibres nécessaires à la santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal avantage de l'exercice physique régulier ?",
    options: [
      "Augmentation du stress",
      "Amélioration de la santé mentale",
      "Diminution de l'énergie",
    ],
    answer: "Amélioration de la santé mentale",
    explanation:
        "L'exercice physique régulier est associé à une meilleure santé mentale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "À quel âge les examens de santé préventifs deviennent-ils cruciaux ?",
    options: ["20 ans", "40 ans", "60 ans"],
    answer: "40 ans",
    explanation:
        "Les examens de santé préventifs sont particulièrement importants à partir de 40 ans.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal symptôme d'une carence en fer ?",
    options: ["Fatigue", "Perte de cheveux", "Douleurs articulaires"],
    answer: "Fatigue",
    explanation: "La fatigue est un symptôme courant d'une carence en fer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de maladie est le diabète ?",
    options: [
      "Maladie infectieuse",
      "Maladie génétique",
      "Maladie métabolique",
    ],
    answer: "Maladie métabolique",
    explanation: "Le diabète est classé comme une maladie métabolique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale fonction du foie ?",
    options: [
      "Produire des hormones",
      "Détoxifier le sang",
      "Fabriquer des globules rouges",
    ],
    answer: "Détoxifier le sang",
    explanation: "Le foie joue un rôle clé dans la détoxification du sang.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des fibres alimentaires ?",
    options: [
      "Améliorer la digestion",
      "Augmenter le poids",
      "Déshydrater le corps",
    ],
    answer: "Améliorer la digestion",
    explanation: "Les fibres alimentaires contribuent à une bonne digestion.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal objectif des campagnes de vaccination ?",
    options: [
      "Augmenter les ventes de médicaments",
      "Prévenir les maladies infectieuses",
      "Faire des profits pour les hôpitaux",
    ],
    answer: "Prévenir les maladies infectieuses",
    explanation:
        "Les campagnes de vaccination visent à prévenir la propagation des maladies infectieuses.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le meilleur moment pour faire un dépistage de cholestérol ?",
    options: ["À tout âge", "À partir de 20-30 ans", "À partir de 60 ans"],
    answer: "À partir de 20-30 ans",
    explanation:
        "Le dépistage du cholestérol est recommandé à partir de 20-30 ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est l'une des causes du surpoids chez les adultes ?",
    options: ["Alimentation équilibrée", "Sédentarité", "Consommation d'eau"],
    answer: "Sédentarité",
    explanation:
        "Un mode de vie sédentaire contribue à l'augmentation du surpoids chez les adultes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du stress chronique sur la santé ?",
    options: [
      "Amélioration des performances",
      "Aucune influence",
      "Détérioration de la santé mentale",
    ],
    answer: "Détérioration de la santé mentale",
    explanation:
        "Le stress chronique peut gravement affecter la santé mentale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal de la vitamine D dans l'organisme ?",
    options: [
      "Renforcer les muscles",
      "Aider à l'absorption du calcium",
      "Améliorer la vue",
    ],
    answer: "Aider à l'absorption du calcium",
    explanation:
        "La vitamine D est essentielle pour l'absorption du calcium et la santé osseuse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est souvent recommandé pour la santé cardiaque ?",
    options: ["Chocolat noir", "Soda", "Bonbons"],
    answer: "Chocolat noir",
    explanation:
        "Le chocolat noir, en modération, peut bénéfiquer la santé cardiaque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal effet de la caféine sur le corps ?",
    options: ["Relaxation", "Énergie accrue", "Diminution de l'attention"],
    answer: "Énergie accrue",
    explanation:
        "La caféine est connue pour ses effets stimulants et d'augmentation de l'énergie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la recommandation quotidienne d'activité physique pour les adultes ?",
    options: ["30 minutes", "1 heure", "2 heures"],
    answer: "30 minutes",
    explanation:
        "Il est recommandé de faire au moins 30 minutes d'activité physique par jour.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le but principal d'une alimentation équilibrée ?",
    options: [
      "Perdre du poids rapidement",
      "Répondre aux besoins nutritionnels",
      "Éviter de manger des glucides",
    ],
    answer: "Répondre aux besoins nutritionnels",
    explanation:
        "Une alimentation équilibrée assure que le corps reçoit tous les nutriments nécessaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de maladie est le cancer ?",
    options: [
      "Maladie infectieuse",
      "Maladie auto-immune",
      "Maladie non transmissible",
    ],
    answer: "Maladie non transmissible",
    explanation: "Le cancer est classé comme une maladie non transmissible.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Qu'est-ce qu'une allergie alimentaire ?",
    options: [
      "Réaction à un aliment spécifique",
      "Préférence pour certains aliments",
      "Habitude alimentaire",
    ],
    answer: "Réaction à un aliment spécifique",
    explanation:
        "Une allergie alimentaire est une réaction nuisible à un aliment particulier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moyen de maintenir un poids santé ?",
    options: [
      "Équilibrer l'alimentation et l'exercice",
      "Prendre des suppléments",
      "Jeûner régulièrement",
    ],
    answer: "Équilibrer l'alimentation et l'exercice",
    explanation:
        "Un équilibre entre une alimentation saine et l'exercice est essentiel pour maintenir un poids santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "À quel moment faut-il consulter un médecin ?",
    options: [
      "En cas de maladie grave",
      "Lorsqu'on se sent bien",
      "Lorsque l'on n'a pas de symptômes",
    ],
    answer: "En cas de maladie grave",
    explanation:
        "Il est important de consulter un médecin en cas de maladie grave.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel sport est recommandé pour améliorer l'endurance ?",
    options: ["Yoga", "Natation", "Échecs"],
    answer: "Natation",
    explanation:
        "La natation est un excellent exercice pour améliorer l'endurance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est l'un des principaux objectifs de la médecine préventive ?",
    options: [
      "Guérir les maladies",
      "Prévenir les maladies",
      "Traiter les symptômes",
    ],
    answer: "Prévenir les maladies",
    explanation:
        "La médecine préventive vise à éviter l'apparition de maladies.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet d'une hydratation adéquate ?",
    options: [
      "Diminution de la fatigue",
      "Augmentation de l'appétit",
      "Perte de poids instantanée",
    ],
    answer: "Diminution de la fatigue",
    explanation:
        "Une bonne hydratation aide à réduire la fatigue et à maintenir l'énergie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un vrai moyen de réduire le stress ?",
    options: [
      "Boire des boissons énergisantes",
      "Faire du yoga",
      "Se coucher tard",
    ],
    answer: "Faire du yoga",
    explanation:
        "Le yoga est connu pour ses effets relaxants et réducteurs de stress.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quels aliments sont réputés pour leurs propriétés antioxydantes ?",
    options: ["Fruits et légumes", "Viande rouge", "Produits laitiers"],
    answer: "Fruits et légumes",
    explanation:
        "Les fruits et légumes sont riches en antioxydants bénéfiques pour la santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bénéfice d'une bonne nuit de sommeil ?",
    options: [
      "Amélioration de la concentration",
      "Augmentation du stress",
      "Diminution de l'immunité",
    ],
    answer: "Amélioration de la concentration",
    explanation:
        "Un bon sommeil favorise la concentration et la performance cognitive.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le lien entre l'alimentation et la santé mentale ?",
    options: [
      "Aucun lien",
      "L'alimentation peut influencer l'humeur",
      "Les aliments sucrés sont toujours bénéfiques",
    ],
    answer: "L'alimentation peut influencer l'humeur",
    explanation:
        "Une alimentation saine contribue à la santé mentale et à l'humeur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de graisses est considéré comme sain ?",
    options: ["Graisses saturées", "Graisses trans", "Graisses insaturées"],
    answer: "Graisses insaturées",
    explanation:
        "Les graisses insaturées, comme celles des noix et de l'huile d'olive, sont considérées comme saines.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un symptôme de déshydratation ?",
    options: ["Peau sèche", "Peau éclatante", "Aucune soif"],
    answer: "Peau sèche",
    explanation: "Une peau sèche est un signe courant de déshydratation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact des exercices de respiration sur le stress ?",
    options: [
      "Augmentent le stress",
      "Réduisent le stress",
      "N'ont aucun effet",
    ],
    answer: "Réduisent le stress",
    explanation: "Les exercices de respiration aident à réduire le stress.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des probiotiques dans l'alimentation ?",
    options: [
      "Renforcer le système immunitaire",
      "Favoriser la digestion",
      "Énergiser le corps",
    ],
    answer: "Favoriser la digestion",
    explanation:
        "Les probiotiques aident à maintenir un équilibre sain de la flore intestinale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la durée recommandée de sommeil pour un adulte ?",
    options: ["6 à 7 heures", "7 à 9 heures", "9 à 10 heures"],
    answer: "7 à 9 heures",
    explanation:
        "Les adultes ont besoin de 7 à 9 heures de sommeil pour un fonctionnement optimal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le meilleur moment pour pratiquer une activité physique ?",
    options: [
      "Avant de dormir",
      "À tout moment de la journée",
      "Dès le réveil",
    ],
    answer: "Dès le réveil",
    explanation:
        "Faire de l'exercice le matin peut stimuler le métabolisme pour la journée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal message de la campagne anti-tabac ?",
    options: [
      "Le tabac est inoffensif",
      "Le tabagisme est dangereux",
      "Fumer est tendance",
    ],
    answer: "Le tabagisme est dangereux",
    explanation:
        "La campagne anti-tabac met en avant les dangers du tabagisme pour la santé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est riche en oméga-3 ?",
    options: ["Huile de lin", "Pâtisseries", "Chips"],
    answer: "Huile de lin",
    explanation: "L'huile de lin est une excellente source d'oméga-3.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la meilleure façon de gérer le stress ?",
    options: [
      "Ignorez-le",
      "Adoptez des techniques de détente",
      "Ne pas en parler",
    ],
    answer: "Adoptez des techniques de détente",
    explanation:
        "Les techniques de détente peuvent aider à mieux gérer le stress.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est un effet secondaire courant des boissons énergisantes ?",
    options: ["Détente", "Anxiété", "Somnolence"],
    answer: "Anxiété",
    explanation:
        "Les boissons énergisantes peuvent provoquer de l'anxiété chez certaines personnes.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal objectif de la vaccination ?",
    options: [
      "Prévenir des maladies",
      "Gérer les crises sanitaires",
      "Augmenter le taux de natalité",
    ],
    answer: "Prévenir des maladies",
    explanation:
        "La vaccination vise principalement à protéger les individus contre des maladies infectieuses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le meilleur moyen de prévenir la transmission des maladies infectieuses ?",
    options: [
      "Se laver les mains",
      "Utiliser des antibiotiques",
      "Éviter les contacts sociaux",
    ],
    answer: "Se laver les mains",
    explanation:
        "Se laver les mains régulièrement est essentiel pour réduire la propagation des agents pathogènes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel aliment est riche en vitamines et recommandé pour une bonne santé ?",
    options: ["Chips", "Fruits et légumes", "Boissons sucrées"],
    answer: "Fruits et légumes",
    explanation:
        "Les fruits et légumes sont importants car ils apportent des vitamines essentielles et des fibres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l’effet principal du tabagisme sur la santé ?",
    options: [
      "Amélioration de la respiration",
      "Augmentation des risques de cancers",
      "Renforcement du système immunitaire",
    ],
    answer: "Augmentation des risques de cancers",
    explanation:
        "Le tabagisme est fortement associé à un risque accru de plusieurs types de cancers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal du fer dans l'organisme ?",
    options: [
      "Produire des hormones",
      "Transporter l'oxygène",
      "Améliorer la digestion",
    ],
    answer: "Transporter l'oxygène",
    explanation:
        "Le fer est crucial pour la production d'hémoglobine, qui transporte l'oxygène dans le sang.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "À quelle fréquence les adultes devraient-ils faire de l'exercice ?",
    options: [
      "Chaque jour",
      "Au moins 150 minutes par semaine",
      "Une fois par mois",
    ],
    answer: "Au moins 150 minutes par semaine",
    explanation:
        "Les recommandations suggèrent au moins 150 minutes d'exercice modéré par semaine pour maintenir une bonne santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale cause de mortalité liée à l'alcool ?",
    options: ["Accidents de la route", "Cancers", "Maladies cardiovasculaires"],
    answer: "Maladies cardiovasculaires",
    explanation:
        "Consommer de l'alcool de manière excessive peut entraîner des maladies cardiovasculaires, une des principales causes de décès.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal du stress chronique sur la santé ?",
    options: [
      "Amélioration de la concentration",
      "Affaiblissement du système immunitaire",
      "Augmentation de la créativité",
    ],
    answer: "Affaiblissement du système immunitaire",
    explanation:
        "Le stress chronique peut avoir des effets négatifs sur le système immunitaire, augmentant les risques de maladies.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quels sont les bienfaits d'une hydratation adéquate ?",
    options: [
      "Amélioration de la peau",
      "Diminution de la fatigue",
      "Renforcement des os",
    ],
    answer: "Diminution de la fatigue",
    explanation:
        "Une bonne hydratation aide à maintenir l'énergie et réduit la fatigue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal avantage d'une alimentation équilibrée ?",
    options: [
      "Prévenir les maladies chroniques",
      "Augmenter le stress",
      "Améliorer la productivité au travail",
    ],
    answer: "Prévenir les maladies chroniques",
    explanation:
        "Une alimentation équilibrée aide à réduire le risque de maladies chroniques comme le diabète et les maladies cardiaques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle vitamine est principalement synthétisée par la peau lors d'une exposition au soleil ?",
    options: ["Vitamine A", "Vitamine C", "Vitamine D"],
    answer: "Vitamine D",
    explanation:
        "La vitamine D est produite par la peau lorsqu'elle est exposée aux rayons ultraviolets du soleil.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Qu'est-ce qu'une allergie alimentaire ?",
    options: [
      "Une intolérance au lactose",
      "Une réaction immunitaire à un aliment",
      "Une maladie infectieuse",
    ],
    answer: "Une réaction immunitaire à un aliment",
    explanation:
        "Une allergie alimentaire est une réponse du système immunitaire à certaines protéines présentes dans les aliments.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un symptôme courant de la déshydratation ?",
    options: ["Fatigue accrue", "Énergie constante", "Cris d'enthousiasme"],
    answer: "Fatigue accrue",
    explanation:
        "La déshydratation peut causer de la fatigue et réduire l'énergie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel micronutriment est essentiel pour la santé des os ?",
    options: ["Calcium", "Potassium", "Magnésium"],
    answer: "Calcium",
    explanation:
        "Le calcium est crucial pour le développement et le maintien de la santé osseuse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact principal de l'obésité sur la santé ?",
    options: [
      "Amélioration de la santé mentale",
      "Augmentation des risques de maladies chroniques",
      "Renforcement du système immunitaire",
    ],
    answer: "Augmentation des risques de maladies chroniques",
    explanation:
        "L'obésité est un facteur de risque important pour de nombreuses maladies chroniques, incluant le diabète et les maladies cardiaques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale fonction du système immunitaire ?",
    options: [
      "Digérer les aliments",
      "Protéger contre les infections",
      "Réguler la température corporelle",
    ],
    answer: "Protéger contre les infections",
    explanation:
        "Le système immunitaire défend l'organisme contre les agents pathogènes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet principal du manque de sommeil sur la santé mentale ?",
    options: [
      "Amélioration de la mémoire",
      "Diminution de l'anxiété",
      "Augmentation de l'irritabilité",
    ],
    answer: "Augmentation de l'irritabilité",
    explanation:
        "Un manque de sommeil peut contribuer à une augmentation de l'irritabilité et des difficultés émotionnelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal avantage de l'activité physique régulière ?",
    options: [
      "Maintien du poids",
      "Augmentation de l'appétit",
      "Diminution de la concentration",
    ],
    answer: "Maintien du poids",
    explanation:
        "L'activité physique aide à contrôler le poids et à prévenir l'obésité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des antioxydants dans le corps ?",
    options: [
      "Renforcer les muscles",
      "Protéger les cellules du stress oxydatif",
      "Accélérer la digestion",
    ],
    answer: "Protéger les cellules du stress oxydatif",
    explanation:
        "Les antioxydants aident à neutraliser les radicaux libres et à protéger les cellules.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le premier signe d'une maladie cardiaque ?",
    options: ["Douleur à la poitrine", "Éruption cutanée", "Perte de cheveux"],
    answer: "Douleur à la poitrine",
    explanation:
        "La douleur à la poitrine est souvent un signe précurseur des maladies cardiaques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moyen de prévenir la grippe ?",
    options: [
      "Se laver les mains",
      "Avoir une alimentation riche en sucres",
      "Réduire les exercices physiques",
    ],
    answer: "Se laver les mains",
    explanation:
        "Se laver les mains régulièrement est l'une des meilleures façons de prévenir la grippe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal effet de la consommation excessive de sucre ?",
    options: [
      "Augmentation de l'énergie",
      "Risque de diabète",
      "Amélioration de l'humeur",
    ],
    answer: "Risque de diabète",
    explanation:
        "La consommation excessive de sucre peut augmenter le risque de développer un diabète de type 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est l'importance de la santé mentale ?",
    options: [
      "Elle n'a pas d'impact sur la santé physique",
      "Elle est cruciale pour le bien-être global",
      "Elle est secondaire par rapport à la santé physique",
    ],
    answer: "Elle est cruciale pour le bien-être global",
    explanation:
        "La santé mentale joue un rôle essentiel dans la qualité de vie et l'efficacité de la vie quotidienne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal bénéfice de l'allaitement pour le nouveau-né ?",
    options: [
      "Préparation à l'école",
      "Soutien immunitaire",
      "Diminution de la taille",
    ],
    answer: "Soutien immunitaire",
    explanation:
        "L'allaitement fournit des anticorps qui aident à protéger le bébé contre les infections.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la première étape pour arrêter de fumer ?",
    options: [
      "Consulter un médecin",
      "Prendre des médicaments",
      "Évaluer sa motivation",
    ],
    answer: "Évaluer sa motivation",
    explanation:
        "Évaluer sa motivation est crucial pour réussir à arrêter de fumer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal risque de l'exposition au soleil sans protection ?",
    options: [
      "Amélioration de la vue",
      "Cancer de la peau",
      "Augmentation de la production de vitamine D",
    ],
    answer: "Cancer de la peau",
    explanation:
        "L'exposition excessive au soleil sans protection augmente le risque de cancer de la peau.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un signe courant d’allergie saisonnière ?",
    options: ["Éruption cutanée", "Éternuements", "Augmentation de l'appétit"],
    answer: "Éternuements",
    explanation:
        "Les éternuements sont un symptôme classique des allergies saisonnières.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du stress sur le corps ?",
    options: [
      "Réduction du poids",
      "Problèmes digestifs",
      "Amélioration de la vision",
    ],
    answer: "Problèmes digestifs",
    explanation:
        "Le stress peut causer divers problèmes digestifs, incluant des douleurs abdominales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la fonction principale des fibres alimentaires ?",
    options: [
      "Augmenter le goût",
      "Améliorer le transit intestinal",
      "Fournir des protéines",
    ],
    answer: "Améliorer le transit intestinal",
    explanation:
        "Les fibres alimentaires sont importantes pour maintenir un bon transit intestinal et éviter la constipation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moyen de protéger ses yeux ?",
    options: [
      "Regarder des écrans toute la journée",
      "Porter des lunettes de soleil",
      "Éviter toute lumière",
    ],
    answer: "Porter des lunettes de soleil",
    explanation:
        "Les lunettes de soleil protègent les yeux des rayons UV nocifs et préviennent les dommages.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est un facteur de risque courant pour les maladies cardiovasculaires ?",
    options: [
      "Pratique régulière de sport",
      "Consommation élevée de sel",
      "Hydratation adéquate",
    ],
    answer: "Consommation élevée de sel",
    explanation:
        "Une consommation excessive de sel peut augmenter la pression artérielle, un facteur de risque pour les maladies cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un effet positif du yoga sur la santé ?",
    options: [
      "Aucune amélioration",
      "Réduction du stress",
      "Diminution de la souplesse",
    ],
    answer: "Réduction du stress",
    explanation:
        "Le yoga est reconnu pour ses effets bénéfiques sur la réduction du stress et l'anxiété.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'un des principaux symptômes du diabète ?",
    options: [
      "Augmentation de la soif",
      "Diminution de la mémoire",
      "Amélioration du métabolisme",
    ],
    answer: "Augmentation de la soif",
    explanation:
        "L'augmentation de la soif est un symptôme courant du diabète dû à une hyperglycémie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet principal d'une exposition prolongée au bruit ?",
    options: [
      "Amélioration de la concentration",
      "Augmentation du stress",
      "Diminution de la qualité du sommeil",
    ],
    answer: "Augmentation du stress",
    explanation:
        "Une exposition prolongée au bruit peut provoquer une élévation des niveaux de stress.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel type de graisse est considéré comme bénéfique pour la santé ?",
    options: ["Graisses saturées", "Graisses trans", "Graisses insaturées"],
    answer: "Graisses insaturées",
    explanation:
        "Les graisses insaturées, comme celles présentes dans les huiles végétales, sont bénéfiques pour la santé cardiaque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des protéines dans l'alimentation ?",
    options: [
      "Fournir de l'énergie rapidement",
      "Construire et réparer les tissus",
      "Réguler la température corporelle",
    ],
    answer: "Construire et réparer les tissus",
    explanation:
        "Les protéines sont essentielles pour la croissance, la réparation et l'entretien des tissus corporels.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est l'importance de la santé bucco-dentaire ?",
    options: [
      "Réduire le risque d'accidents",
      "Améliorer le goût des aliments",
      "Prévenir des maladies générales",
    ],
    answer: "Prévenir des maladies générales",
    explanation:
        "Une bonne santé bucco-dentaire peut aider à prévenir des maladies systémiques, comme les maladies cardiaques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "À quelle fréquence les adultes devraient-ils consulter un médecin pour un examen de santé ?",
    options: ["Tous les mois", "Tous les ans", "Tous les cinq ans"],
    answer: "Tous les ans",
    explanation:
        "Il est recommandé aux adultes de passer un examen de santé annuel pour détecter d'éventuels problèmes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal d’une mauvaise posture ?",
    options: [
      "Amélioration de la circulation",
      "Douleurs musculosquelettiques",
      "Augmentation de l'énergie",
    ],
    answer: "Douleurs musculosquelettiques",
    explanation:
        "Une mauvaise posture peut entraîner des douleurs dans le dos et d'autres douleurs musculosquelettiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le meilleur moyen de s'assurer d'une bonne santé mentale ?",
    options: [
      "Prendre des médicaments uniquement",
      "Maintenir des relations sociales",
      "Éviter toute activité relaxante",
    ],
    answer: "Maintenir des relations sociales",
    explanation:
        "Les relations sociales jouent un rôle crucial dans le soutien de la santé mentale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact de l'isolement social sur la santé physique ?",
    options: [
      "Amélioration de la longévité",
      "Diminution du risque de maladies",
      "Détérioration de la santé physique",
    ],
    answer: "Détérioration de la santé physique",
    explanation:
        "L'isolement social est lié à des problèmes de santé physique, incluant des maladies cardiaques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet positif du rire sur la santé ?",
    options: [
      "Diminution de la motivation",
      "Augmentation du stress",
      "Amélioration de l'humeur",
    ],
    answer: "Amélioration de l'humeur",
    explanation:
        "Le rire est reconnu pour ses effets bénéfiques sur l'humeur et la réduction de l'anxiété.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le lien entre l'activité physique et la santé mentale ?",
    options: [
      "L'absence de lien",
      "Amélioration de l'humeur",
      "Augmentation du stress",
    ],
    answer: "Amélioration de l'humeur",
    explanation:
        "L'activité physique régulière est étroitement liée à l'amélioration de la santé mentale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bénéfice de la méditation sur la santé ?",
    options: [
      "Augmentation du stress",
      "Amélioration de la concentration",
      "Diminution de la confiance en soi",
    ],
    answer: "Amélioration de la concentration",
    explanation:
        "La méditation aide à améliorer la concentration et à réduire le stress.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des os dans le corps humain ?",
    options: [
      "Supporter le corps",
      "Aider à la digestion",
      "Produire des hormones",
    ],
    answer: "Supporter le corps",
    explanation:
        "Les os fournissent une structure et un soutien au corps human.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Qu'est-ce qui est recommandé pour une bonne santé cardiovasculaire ?",
    options: [
      "Éviter les repas équilibrés",
      "Pratiquer une activité physique régulière",
      "Augmenter la consommation de sucres",
    ],
    answer: "Pratiquer une activité physique régulière",
    explanation:
        "L'exercice régulier est essentiel pour maintenir une bonne santé cardiovasculaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal risque du surpoids ?",
    options: [
      "Meilleure santé globale",
      "Augmentation des risques de maladies",
      "Amélioration de la qualité de vie",
    ],
    answer: "Augmentation des risques de maladies",
    explanation:
        "Le surpoids peut accroître les risques de développer diverses maladies chroniques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact d'une mauvaise alimentation sur la santé ?",
    options: [
      "Aucune incidence",
      "Risque accru de maladies",
      "Amélioration de la concentration",
    ],
    answer: "Risque accru de maladies",
    explanation:
        "Une mauvaise alimentation est liée à un risque accru de maladies chroniques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bénéfice de l'éducation à la santé ?",
    options: [
      "Diminution des coûts de santé",
      "Augmentation des maladies",
      "Amélioration de la qualité de vie",
    ],
    answer: "Amélioration de la qualité de vie",
    explanation:
        "L'éducation à la santé aide les individus à prendre des décisions éclairées pour leur bien-être.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est l'une des principales causes de l'obésité ?",
    options: [
      "Manque d'exercice",
      "Consommation de protéines",
      "Hydratation adéquate",
    ],
    answer: "Manque d'exercice",
    explanation:
        "Un mode de vie sédentaire est l'une des principales causes de l'obésité.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal facteur de risque pour les maladies cardiovasculaires ?",
    options: ["Obésité", "Consommation de fruits", "Activité physique"],
    answer: "Obésité",
    explanation:
        "L'obésité est un facteur de risque majeur pour les maladies cardiovasculaires en raison de son impact sur la pression artérielle et le cholestérol.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est considéré comme un probiotique ?",
    options: ["Yaourt", "Pomme de terre", "Viande"],
    answer: "Yaourt",
    explanation:
        "Le yaourt contient des bactéries vivantes bénéfiques qui favorisent la santé intestinale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal de l'eau dans le corps humain ?",
    options: [
      "Réguler la température corporelle",
      "Fournir des calories",
      "Augmenter la masse musculaire",
    ],
    answer: "Réguler la température corporelle",
    explanation:
        "L'eau aide à maintenir une température corporelle stable par le biais de la transpiration et d'autres mécanismes de thermorégulation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet principal de la nicotine sur le système cardiovasculaire ?",
    options: [
      "Vasodilatation",
      "Augmentation de la fréquence cardiaque",
      "Réduction du cholestérol",
    ],
    answer: "Augmentation de la fréquence cardiaque",
    explanation:
        "La nicotine stimule le système nerveux, ce qui entraîne une augmentation de la fréquence cardiaque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Lequel des suivants est un symptôme courant de la déshydratation ?",
    options: ["Frissons", "Fatigue", "Euphorie"],
    answer: "Fatigue",
    explanation:
        "La déshydratation entraîne souvent une fatigue due à un manque d'eau dans le corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel vaccin est recommandé pour prévenir la grippe ?",
    options: ["BCG", "Antigrippal", "Hépatite B"],
    answer: "Antigrippal",
    explanation:
        "Le vaccin antigrippal est conçu pour protéger contre les souches de virus de la grippe circulantes chaque saison.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est riche en oméga-3 ?",
    options: ["Huile d'olive", "Saumon", "Avocat"],
    answer: "Saumon",
    explanation:
        "Le saumon est une excellente source d'acides gras oméga-3, bénéfiques pour la santé cardiaque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'un des principaux bénéfices de l'exercice régulier ?",
    options: [
      "Augmentation du stress",
      "Amélioration de la concentration",
      "Diminution de la force musculaire",
    ],
    answer: "Amélioration de la concentration",
    explanation:
        "L'exercice régulier améliore la circulation sanguine, ce qui peut augmenter la concentration et les performances cognitives.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal agent pathogène causant la tuberculose ?",
    options: ["Virus", "Bactérie", "Champignon"],
    answer: "Bactérie",
    explanation:
        "La tuberculose est causée par la bactérie Mycobacterium tuberculosis.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la meilleure façon de prévenir la propagation des infections ?",
    options: [
      "Se laver les mains",
      "Éviter de manger des fruits",
      "Ne pas faire d'exercice",
    ],
    answer: "Se laver les mains",
    explanation:
        "Se laver les mains régulièrement est une méthode efficace pour réduire la transmission des agents infectieux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel type de fruits est particulièrement riche en antioxydants ?",
    options: ["Agrumes", "Baies", "Citrons"],
    answer: "Baies",
    explanation:
        "Les baies, comme les myrtilles et les framboises, contiennent des niveaux élevés d'antioxydants, qui aident à lutter contre le stress oxydatif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Qu'est-ce qu'une maladie chronique ?",
    options: [
      "Une maladie qui guérit rapidement",
      "Une maladie qui dure longtemps",
      "Une maladie contagieuse",
    ],
    answer: "Une maladie qui dure longtemps",
    explanation:
        "Une maladie chronique persiste sur une longue période et nécessite souvent une gestion continue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est un des effets du tabagisme sur le système respiratoire ?",
    options: [
      "Amélioration de la capacité pulmonaire",
      "Augmentation de la toux",
      "Diminution de la respiration",
    ],
    answer: "Augmentation de la toux",
    explanation:
        "Le tabagisme irrite les voies respiratoires, entraînant une augmentation de la toux et d'autres problèmes respiratoires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal avantage d'une alimentation équilibrée ?",
    options: [
      "Augmentation du poids",
      "Amélioration de la santé générale",
      "Réduction de l'énergie",
    ],
    answer: "Amélioration de la santé générale",
    explanation:
        "Une alimentation équilibrée fournit les nutriments nécessaires pour maintenir une bonne santé et prévenir les maladies.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale source de vitamine C ?",
    options: ["Citrons", "Pain complet", "Oeufs"],
    answer: "Citrons",
    explanation:
        "Les citrons et d'autres agrumes sont des sources riches en vitamine C, essentielle pour le système immunitaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet de l'alcool sur le système nerveux central ?",
    options: ["Stimulation", "Inhibition", "Aucune effet"],
    answer: "Inhibition",
    explanation:
        "L'alcool agit comme un dépresseur du système nerveux central, ralentissant les fonctions cérébrales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la meilleure méthode pour réduire le stress ?",
    options: [
      "Ignorer ses soucis",
      "Pratiquer la méditation",
      "Manger des sucreries",
    ],
    answer: "Pratiquer la méditation",
    explanation:
        "La méditation est reconnue pour ses effets bénéfiques sur la réduction du stress et l'amélioration du bien-être mental.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle de l’insuline dans l'organisme ?",
    options: [
      "Augmenter la glycémie",
      "Réguler le métabolisme des glucides",
      "Élevé le taux de cholestérol",
    ],
    answer: "Réguler le métabolisme des glucides",
    explanation:
        "L'insuline aide à réguler le métabolisme des glucides en facilitant l'absorption du glucose par les cellules.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact d'une consommation excessive de sucre sur la santé ?",
    options: [
      "Amélioration de l'énergie",
      "Risque accru de diabète",
      "Augmentation de la digestibilité",
    ],
    answer: "Risque accru de diabète",
    explanation:
        "Une consommation excessive de sucre peut entraîner une résistance à l'insuline et augmenter le risque de diabète de type 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'organe principal du système respiratoire ?",
    options: ["Coeur", "Poumons", "Estomac"],
    answer: "Poumons",
    explanation:
        "Les poumons sont responsables de l'échange de gaz, permettant la respiration et l'oxygénation du sang.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la meilleure période pour consulter un médecin en cas de symptôme préoccupant ?",
    options: [
      "À tout moment",
      "Une fois par an",
      "Dès l'apparition des symptômes",
    ],
    answer: "Dès l'apparition des symptômes",
    explanation:
        "Consulter un médecin dès l'apparition de symptômes préoccupants permet un diagnostic précoce et un meilleur traitement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet de l'exposition prolongée au soleil sans protection ?",
    options: [
      "Amélioration de la peau",
      "Risque de cancer de la peau",
      "Augmentation de la production de collagène",
    ],
    answer: "Risque de cancer de la peau",
    explanation:
        "Une exposition prolongée au soleil sans protection augmente le risque de développer un cancer de la peau en raison des rayons UV.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de cancer est souvent associé au tabagisme ?",
    options: ["Cancer du cœur", "Cancer du poumon", "Cancer du colon"],
    answer: "Cancer du poumon",
    explanation:
        "Le tabagisme est le principal facteur de risque pour le développement du cancer du poumon.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du stress chronique sur le corps ?",
    options: [
      "Aucun effet",
      "Renforcement du système immunitaire",
      "Affaiblissement du système immunitaire",
    ],
    answer: "Affaiblissement du système immunitaire",
    explanation:
        "Le stress chronique peut affaiblir le système immunitaire, rendant le corps plus vulnérable aux infections.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact d'une activité physique régulière sur la santé mentale ?",
    options: [
      "Aucun impact",
      "Amélioration de l'humeur",
      "Augmentation de l'anxiété",
    ],
    answer: "Amélioration de l'humeur",
    explanation:
        "L'activité physique régulière libère des endorphines, contribuant ainsi à une meilleure humeur et à la réduction du stress.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bénéfice de consommer des fibres ?",
    options: [
      "Augmentation du cholestérol",
      "Amélioration du transit intestinal",
      "Diminution de la sensation de faim",
    ],
    answer: "Amélioration du transit intestinal",
    explanation:
        "Les fibres contribuent à réguler le transit intestinal et à prévenir la constipation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le lien entre le sommeil et la mémoire ?",
    options: [
      "Pas de lien",
      "Le sommeil amélioré la mémoire",
      "Le sommeil affaiblit la mémoire",
    ],
    answer: "Le sommeil amélioré la mémoire",
    explanation:
        "Un sommeil adéquat est essentiel pour la consolidation de la mémoire et le bon fonctionnement cognitif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact de la pollution de l'air sur la santé ?",
    options: [
      "Aucun impact",
      "Augmentation des maladies respiratoires",
      "Amélioration de la santé cardiovasculaire",
    ],
    answer: "Augmentation des maladies respiratoires",
    explanation:
        "La pollution de l'air est liée à une hausse des maladies respiratoires, en raison de l'inhalation de particules nocives.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moyen de prévenir les caries dentaires ?",
    options: [
      "Consommer des bonbons",
      "Se brosser les dents régulièrement",
      "Éviter l'eau potable",
    ],
    answer: "Se brosser les dents régulièrement",
    explanation:
        "Un brossage régulier des dents aide à éliminer la plaque dentaire et à prévenir les caries.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet bénéfique du thé vert sur la santé ?",
    options: [
      "Augmenter le poids",
      "Réduire le risque de maladies cardiaques",
      "Ne pas affecter la santé",
    ],
    answer: "Réduire le risque de maladies cardiaques",
    explanation:
        "Le thé vert contient des composés qui peuvent améliorer la santé cardiaque en réduisant le cholestérol.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'un des bénéfices du yoga sur la santé mentale ?",
    options: [
      "Augmentation du stress",
      "Amélioration de la flexibilité",
      "Réduction de l'anxiété",
    ],
    answer: "Réduction de l'anxiété",
    explanation:
        "Le yoga est une pratique bénéfique qui aide à réduire l'anxiété et à promouvoir le bien-être mental.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel fruit est souvent associé à des bienfaits pour la santé du cœur ?",
    options: ["Banane", "Avocat", "Pomme"],
    answer: "Avocat",
    explanation:
        "L'avocat est riche en acides gras monoinsaturés, bénéfiques pour la santé cardiovasculaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bénéfice du lait dans l'alimentation ?",
    options: [
      "Source de protéines",
      "Riche en glucides",
      "Augmente le risque d'obésité",
    ],
    answer: "Source de protéines",
    explanation:
        "Le lait est une excellente source de protéines et apporte des nutriments essentiels au corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle de la vitamine K dans le corps ?",
    options: [
      "Favoriser la coagulation sanguine",
      "Augmenter le niveau d'énergie",
      "Réduire le stress",
    ],
    answer: "Favoriser la coagulation sanguine",
    explanation:
        "La vitamine K est essentielle pour la coagulation du sang et la santé des os.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du stress sur le cœur ?",
    options: [
      "Amélioration de la santé cardiaque",
      "Augmentation du risque de maladies cardiaques",
      "Diminution du rythme cardiaque",
    ],
    answer: "Augmentation du risque de maladies cardiaques",
    explanation:
        "Le stress chronique peut contribuer à des problèmes cardiaques en augmentant la pression artérielle et le rythme cardiaque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet néfaste du tabac sur les dents ?",
    options: [
      "Renforcement des gencives",
      "Diminution des taches dentaires",
      "Augmentation du risque de maladies parodontales",
    ],
    answer: "Augmentation du risque de maladies parodontales",
    explanation:
        "Le tabac augmente le risque de maladies des gencives et de perte dentaire en affectant la santé bucco-dentaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'un des principaux causes de l'obésité ?",
    options: [
      "Consommation d'eau excessive",
      "Alimentation déséquilibrée",
      "Activité physique régulière",
    ],
    answer: "Alimentation déséquilibrée",
    explanation:
        "Une alimentation déséquilibrée, riche en calories et pauvre en nutriments, est un des principaux facteurs de l'obésité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact des fruits et légumes sur la santé ?",
    options: [
      "Mauvaise digestion",
      "Réduction du risque de maladies",
      "Augmentation de la fatigue",
    ],
    answer: "Réduction du risque de maladies",
    explanation:
        "La consommation de fruits et légumes est associée à une diminution du risque de nombreuses maladies, y compris les maladies chroniques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle de la globuline dans le sang ?",
    options: [
      "Transporter les gaz respiratoires",
      "Lutter contre les infections",
      "Fournir de l'énergie",
    ],
    answer: "Lutter contre les infections",
    explanation:
        "Les globulines jouent un rôle clé dans le système immunitaire en aidant à combattre les infections.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet de l'exposition au soleil sur la vitamine D ?",
    options: [
      "Inhibition de sa production",
      "Stimulation de sa production",
      "Aucun effet",
    ],
    answer: "Stimulation de sa production",
    explanation:
        "L'exposition au soleil déclenche la production de vitamine D dans la peau, essentielle pour la santé osseuse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact de la sédentarité sur la santé ?",
    options: [
      "Amélioration de la santé cardiovasculaire",
      "Augmentation des risques de maladies chroniques",
      "Diminution de la qualité de sommeil",
    ],
    answer: "Augmentation des risques de maladies chroniques",
    explanation:
        "La sédentarité est liée à un risque accru de maladies chroniques, y compris le diabète et les maladies cardiaques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact de la consommation de légumes sur la digestion ?",
    options: [
      "Aucun impact",
      "Favorise une bonne digestion",
      "Ralentit la digestion",
    ],
    answer: "Favorise une bonne digestion",
    explanation:
        "Une consommation adéquate de légumes apporte des fibres qui favorisent un bon transit intestinal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est une bonne pratique pour maintenir une bonne hygiène dentaire ?",
    options: [
      "Ne pas se brosser les dents",
      "Utiliser du fil dentaire",
      "Manger beaucoup de bonbons",
    ],
    answer: "Utiliser du fil dentaire",
    explanation:
        "L'utilisation du fil dentaire aide à éliminer la plaque et les résidus alimentaires entre les dents, important pour la santé dentaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le rôle des acides gras essentiels dans l'alimentation ?",
    options: [
      "Aider à la digestion",
      "Fournir de l'énergie uniquement",
      "Soutenir la santé cellulaire",
    ],
    answer: "Soutenir la santé cellulaire",
    explanation:
        "Les acides gras essentiels sont nécessaires pour la santé cellulaire et le bon fonctionnement de l'organisme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un effet secondaire du manque de sommeil ?",
    options: [
      "Amélioration de la fonction cognitive",
      "Augmentation du risque d'obésité",
      "Diminution de la productivité",
    ],
    answer: "Augmentation du risque d'obésité",
    explanation:
        "Le manque de sommeil peut perturber les hormones de la faim et augmenter le risque d'obésité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal objectif d'une bonne nutrition ?",
    options: [
      "Manger uniquement des sucreries",
      "Avoir un poids sain",
      "Manger moins d'hydrates de carbone",
    ],
    answer: "Avoir un poids sain",
    explanation:
        "Une bonne nutrition vise à maintenir un poids sain et à soutenir la santé globale de l'individu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact de la caféine sur le corps ?",
    options: [
      "Sensation de fatigue",
      "Stimulation du système nerveux",
      "Augmentation du besoin de sommeil",
    ],
    answer: "Stimulation du système nerveux",
    explanation:
        "La caféine stimule le système nerveux, augmentant temporairement l'énergie et la concentration.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal mode de transmission du VIH ?",
    options: [
      "Par les relations sexuelles non protégées",
      "Par le partage d'ustensiles",
      "Par la toux",
    ],
    answer: "Par les relations sexuelles non protégées",
    explanation:
        "Le VIH se transmet principalement par contact sexuel non protégé avec une personne infectée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel vaccin est essentiel pour prévenir la rougeole ?",
    options: [
      "Vaccin MMR",
      "Vaccin contre la grippe",
      "Vaccin contre l'hépatite",
    ],
    answer: "Vaccin MMR",
    explanation:
        "Le vaccin MMR protège contre la rougeole, les oreillons et la rubéole.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal objectif de la vaccination ?",
    options: [
      "Éliminer toutes les maladies",
      "Renforcer le système immunitaire",
      "Augmenter la durée de vie",
    ],
    answer: "Renforcer le système immunitaire",
    explanation:
        "La vaccination vise à stimuler le système immunitaire pour prévenir certaines maladies infectieuses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est riche en vitamine C ?",
    options: ["Banane", "Orange", "Pomme"],
    answer: "Orange",
    explanation:
        "L'orange est une excellente source de vitamine C, essentielle pour le système immunitaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle pratique aide à réduire le risque de maladies cardio-vasculaires ?",
    options: [
      "Fumer modérément",
      "Manger des aliments riches en sucre",
      "Faire de l'exercice régulièrement",
    ],
    answer: "Faire de l'exercice régulièrement",
    explanation:
        "L'exercice régulier aide à maintenir un cœur en bonne santé et à réduire le risque de maladies cardio-vasculaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal symptôme de la grippe ?",
    options: ["Éruption cutanée", "Fièvre", "Mal de tête"],
    answer: "Fièvre",
    explanation: "La fièvre est un symptôme commun et fréquent de la grippe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal de l'alcool sur le corps ?",
    options: [
      "Amélioration de la concentration",
      "Diminution des réflexes",
      "Augmentation de l'énergie",
    ],
    answer: "Diminution des réflexes",
    explanation:
        "L'alcool diminue les réflexes et peut altérer le jugement et la coordination.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la meilleure manière de prévenir les infections respiratoires ?",
    options: [
      "Boire beaucoup de café",
      "Éviter le jardinage",
      "Se laver fréquemment les mains",
    ],
    answer: "Se laver fréquemment les mains",
    explanation:
        "Se laver les mains régulièrement est une méthode efficace pour prévenir les maladies infectieuses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "À quel âge est-il recommandé de commencer les dépistages réguliers du cancer du sein ?",
    options: ["40 ans", "30 ans", "50 ans"],
    answer: "40 ans",
    explanation:
        "Les dépistages réguliers du cancer du sein commencent généralement à 40 ans pour les femmes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'un des effets d'une mauvaise alimentation ?",
    options: [
      "Amélioration de la mémoire",
      "Prise de poids",
      "Augmentation de l'énergie",
    ],
    answer: "Prise de poids",
    explanation:
        "Une mauvaise alimentation peut entraîner une prise de poids et des problèmes de santé associés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'organe principal affecté par le tabagisme ?",
    options: ["Cœur", "Poumons", "Foie"],
    answer: "Poumons",
    explanation:
        "Le tabagisme est particulièrement nocif pour les poumons et peut causer de graves maladies respiratoires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un symptôme courant de l'allergie au pollen ?",
    options: ["Nausées", "Éternuements", "Céphalées"],
    answer: "Éternuements",
    explanation:
        "Les éternuements sont un symptôme fréquent des allergies, notamment au pollen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bénéfice du port du masque ?",
    options: [
      "Augmenter la température corporelle",
      "Réduire la transmission des germes",
      "Améliorer la vision",
    ],
    answer: "Réduire la transmission des germes",
    explanation:
        "Le port du masque aide à réduire la transmission des germes, particulièrement dans les espaces publics.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal des antibiotiques ?",
    options: [
      "Traiter les maladies virales",
      "Éliminer les bactéries",
      "Renforcer le système immunitaire",
    ],
    answer: "Éliminer les bactéries",
    explanation:
        "Les antibiotiques sont utilisés pour traiter les infections causées par des bactéries.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal effet du stress sur la santé ?",
    options: [
      "Augmentation de la concentration",
      "Réduction de l'appétit",
      "Affaiblissement du système immunitaire",
    ],
    answer: "Affaiblissement du système immunitaire",
    explanation:
        "Le stress chronique peut affaiblir le système immunitaire, rendant l'individu plus vulnérable aux maladies.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de vaccin est le vaccin antigrippal ?",
    options: ["Inactivé", "Atténué", "Combiné"],
    answer: "Inactivé",
    explanation:
        "Le vaccin antigrippal est un vaccin inactivé qui protège contre les virus de la grippe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal risque associé à l'exposition au soleil ?",
    options: ["Cécité", "Cancer de la peau", "Rhumes fréquents"],
    answer: "Cancer de la peau",
    explanation:
        "Une exposition excessive au soleil augmente le risque de développer un cancer de la peau.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle vitamine est souvent associée à la santé des os ?",
    options: ["Vitamine A", "Vitamine C", "Vitamine D"],
    answer: "Vitamine D",
    explanation:
        "La vitamine D est essentielle pour la santé des os en aidant à l'absorption du calcium.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "À quoi sert une trousse de premiers secours ?",
    options: [
      "Pour des soins cosmétiques",
      "Pour traiter des blessures mineures",
      "Pour le rangement d'outils",
    ],
    answer: "Pour traiter des blessures mineures",
    explanation:
        "Une trousse de premiers secours est utilisée pour fournir des soins immédiats en cas de blessure ou d'accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du tabac au niveau cardiovascular ?",
    options: [
      "Diminution du rythme cardiaque",
      "Augmente la pression artérielle",
      "Améliore la circulation",
    ],
    answer: "Augmente la pression artérielle",
    explanation:
        "Le tabac augmente la pression artérielle, ce qui peut aggraver les problèmes cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Qu'est-ce qu'une allergie ?",
    options: [
      "Une réaction immunitaire excessive",
      "Une infection virale",
      "Une maladie génétique",
    ],
    answer: "Une réaction immunitaire excessive",
    explanation:
        "Une allergie est une réaction inappropriée du système immunitaire à des substances normalement inoffensives.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est une des conséquences d'une déshydratation ?",
    options: [
      "Amélioration du sommeil",
      "Fatigue",
      "Augmentation de l'appétit",
    ],
    answer: "Fatigue",
    explanation:
        "La déshydratation peut entraîner une fatigue accrue et un manque d'énergie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un signe précoce de l'hypertension ?",
    options: ["Maux de tête", "Perte de poids", "Forte fièvre"],
    answer: "Maux de tête",
    explanation:
        "Les maux de tête peuvent être un signe précoce d'hypertension, bien que souvent asymptomatique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Comment peut-on prévenir le diabète de type 2 ?",
    options: [
      "Par une activité physique régulière",
      "En mangeant beaucoup de sucre",
      "En évitant de dormir",
    ],
    answer: "Par une activité physique régulière",
    explanation:
        "Une activité physique régulière aide à maintenir un poids santé et peut prévenir le diabète de type 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal du sommeil sur la santé ?",
    options: [
      "Augmente le stress",
      "Favorise la récupération",
      "Diminue l'énergie",
    ],
    answer: "Favorise la récupération",
    explanation:
        "Le sommeil joue un rôle crucial dans la récupération physique et mentale du corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un facteur de risque majeur pour le cancer du poumon ?",
    options: ["Pratique d'un sport", "Consommation de fruits", "Tabagisme"],
    answer: "Tabagisme",
    explanation:
        "Le tabagisme est le principal facteur de risque associé au cancer du poumon.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal risque de ne pas se faire vacciner ?",
    options: [
      "Devenir plus fort",
      "Être plus résistant aux maladies",
      "Contracter des maladies évitables",
    ],
    answer: "Contracter des maladies évitables",
    explanation:
        "Ne pas se faire vacciner augmente le risque de contracter des maladies qui peuvent être prévenues par la vaccination.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal symptôme de la dépression ?",
    options: ["Joie constante", "Perte d'intérêt", "Énergie débordante"],
    answer: "Perte d'intérêt",
    explanation:
        "La perte d'intérêt pour des activités auparavant plaisantes est un symptôme commun de la dépression.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle activité aide à réduire le stress ?",
    options: ["Travailler plus", "Méditer", "Regarder des écrans"],
    answer: "Méditer",
    explanation:
        "La méditation est une pratique reconnue pour aider à réduire le stress et favoriser la relaxation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du sucre sur la santé dentaire ?",
    options: [
      "Renforce les dents",
      "Provoque des caries",
      "Améliore la santé gencive",
    ],
    answer: "Provoque des caries",
    explanation:
        "Une consommation excessive de sucre peut entraîner la formation de caries dentaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moyen de garder ses os en bonne santé ?",
    options: [
      "Prendre des douches froides",
      "Avoir une alimentation riche en calcium",
      "Éviter de faire de l'exercice",
    ],
    answer: "Avoir une alimentation riche en calcium",
    explanation:
        "Une alimentation riche en calcium est essentielle pour maintenir la santé osseuse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "À quelle fréquence devrait-on se faire examiner par un médecin ?",
    options: ["Une fois par an", "Tous les cinq ans", "Jamais"],
    answer: "Une fois par an",
    explanation:
        "Il est recommandé de se faire examiner par un médecin au moins une fois par an pour maintenir sa santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un risque de la consommation excessive de sel ?",
    options: [
      "Amélioration de la digestion",
      "Hypertension artérielle",
      "Réduction de l'anxiété",
    ],
    answer: "Hypertension artérielle",
    explanation:
        "Une consommation excessive de sel peut contribuer à l'hypertension artérielle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle de l'eau pour le corps humain ?",
    options: [
      "Augmenter la température corporelle",
      "Réguler la température corporelle",
      "Rendre la peau plus épaisse",
    ],
    answer: "Réguler la température corporelle",
    explanation:
        "L'eau aide à réguler la température corporelle et maintient l'hydratation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Qu'est-ce que l'hygiène bucco-dentaire ?",
    options: [
      "Se laver les cheveux",
      "Prendre des bains",
      "Prendre soin des dents et des gencives",
    ],
    answer: "Prendre soin des dents et des gencives",
    explanation:
        "L'hygiène bucco-dentaire consiste à maintenir la propreté des dents et des gencives pour prévenir les maladies.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bénéfice de l'allaitement ?",
    options: [
      "Protéger contre les allergies",
      "Favoriser le développement des dents",
      "Augmenter la croissance des cheveux",
    ],
    answer: "Protéger contre les allergies",
    explanation:
        "L'allaitement peut aider à protéger les nourrissons contre le développement d'allergies.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la meilleure façon de prévenir les maladies cardiaques ?",
    options: [
      "Manger des aliments frits",
      "Maintenir un poids santé",
      "Vivre dans une région froide",
    ],
    answer: "Maintenir un poids santé",
    explanation:
        "Maintenir un poids santé est crucial pour réduire le risque de maladies cardiaques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du tabac sur la peau ?",
    options: [
      "Rend la peau plus lisse",
      "Cause un vieillissement prématuré",
      "Améliore l'éclat",
    ],
    answer: "Cause un vieillissement prématuré",
    explanation:
        "Le tabagisme contribue au vieillissement prématuré de la peau, réduisant son élasticité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet d'une alimentation équilibrée ?",
    options: [
      "Augmentation de l'énergie",
      "Augmentation de l'anxiété",
      "Risque accru de maladies",
    ],
    answer: "Augmentation de l'énergie",
    explanation:
        "Une alimentation équilibrée contribue à une meilleure énergie et santé générale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Comment peut-on réduire le risque de diabète ?",
    options: [
      "Augmenter la consommation de sucre",
      "Pratiquer une activité physique régulière",
      "Éviter de dormir",
    ],
    answer: "Pratiquer une activité physique régulière",
    explanation:
        "L'activité physique régulière aide à réguler le poids et à réduire le risque de diabète.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "À quoi sert le cholestérol dans l'organisme ?",
    options: [
      "Produire des cellules cérébrales",
      "Favoriser la digestion",
      "Aider à la production d'hormones",
    ],
    answer: "Aider à la production d'hormones",
    explanation:
        "Le cholestérol joue un rôle clé dans la production de certaines hormones dans le corps.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un moyen de gérer le stress au travail ?",
    options: [
      "Travailler sans pause",
      "Prendre des pauses régulières",
      "Éviter les conversations",
    ],
    answer: "Prendre des pauses régulières",
    explanation:
        "Prendre des pauses régulières peut aider à gérer le stress et améliorer la productivité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal rôle des fibres alimentaires ?",
    options: [
      "Améliorer la digestion",
      "Augmenter le risque de maladies",
      "Favoriser le gain de poids",
    ],
    answer: "Améliorer la digestion",
    explanation:
        "Les fibres alimentaires favorisent une bonne digestion et aident à réguler le transit intestinal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet principal de la consommation de fruits et légumes ?",
    options: [
      "Augmenter la soif",
      "Fournir des nutriments essentiels",
      "Rendre la peau plus grasse",
    ],
    answer: "Fournir des nutriments essentiels",
    explanation:
        "Les fruits et légumes fournissent des nutriments essentiels pour une bonne santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moment pour faire de l'exercice ?",
    options: ["Avant de dormir", "À jeun", "Lorsque l'on se sent le mieux"],
    answer: "Lorsque l'on se sent le mieux",
    explanation:
        "L'exercice est plus bénéfique lorsqu'il est effectué à des moments où l'on se sent le mieux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la principale source d'énergie pour le corps humain ?",
    options: ["Protéines", "Glucides", "Lipides"],
    answer: "Glucides",
    explanation:
        "Les glucides sont la principale source d'énergie pour le corps humain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le meilleur moyen de prévenir les maladies infectieuses ?",
    options: [
      "Avoir des relations sexuelles non protégées",
      "Se laver les mains régulièrement",
      "Ignorer les symptômes",
    ],
    answer: "Se laver les mains régulièrement",
    explanation:
        "Se laver les mains régulièrement est l'une des façons les plus efficaces de prévenir les maladies infectieuses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Comment peut-on améliorer la concentration ?",
    options: [
      "Manger des aliments sains",
      "Boire des boissons sucrées",
      "Regarder la télévision",
    ],
    answer: "Manger des aliments sains",
    explanation:
        "Une alimentation saine contribue à améliorer la concentration et le fonctionnement cognitif.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal vecteur de transmission du VIH ?",
    options: [
      "Les rapports sexuels non protégés",
      "Les piqûres de moustiques",
      "Le partage de vêtements",
    ],
    answer: "Les rapports sexuels non protégés",
    explanation:
        "Le VIH se transmet principalement par les rapports sexuels non protégés avec une personne infectée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est considéré comme riche en vitamine C ?",
    options: ["Les carottes", "Les agrumes", "Les pommes de terre"],
    answer: "Les agrumes",
    explanation:
        "Les agrumes, comme les oranges et les citrons, sont particulièrement riches en vitamine C.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal du tabac sur la santé ?",
    options: [
      "Amélioration de l'endurance",
      "Risque accru de maladies respiratoires",
      "Renforcement du système immunitaire",
    ],
    answer: "Risque accru de maladies respiratoires",
    explanation:
        "Le tabac nuit à la santé en augmentant le risque de maladies respiratoires et cardiovasculaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'âge recommandé pour commencer à faire des mammographies ?",
    options: ["40 ans", "50 ans", "60 ans"],
    answer: "50 ans",
    explanation:
        "Les mammographies sont généralement recommandées à partir de 50 ans pour détecter précocement le cancer du sein.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal du vaccin contre la grippe ?",
    options: [
      "Guérir la grippe",
      "Prévenir l'infection",
      "Rendre le corps résistant à toutes les maladies",
    ],
    answer: "Prévenir l'infection",
    explanation:
        "Le vaccin contre la grippe a pour but de prévenir l'infection par les virus de la grippe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal risque du surpoids ?",
    options: [
      "Amélioration de la santé cardiovasculaire",
      "Risque accru de diabète de type 2",
      "Réduction de la pression artérielle",
    ],
    answer: "Risque accru de diabète de type 2",
    explanation:
        "Le surpoids est un facteur de risque important pour le développement du diabète de type 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la durée recommandée d'activité physique modérée par semaine pour un adulte ?",
    options: ["60 minutes", "150 minutes", "30 minutes"],
    answer: "150 minutes",
    explanation:
        "Les adultes devraient viser au moins 150 minutes d'activité physique modérée par semaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal effet du stress sur le corps ?",
    options: [
      "Amélioration du sommeil",
      "Affaiblissement du système immunitaire",
      "Gain de poids rapide",
    ],
    answer: "Affaiblissement du système immunitaire",
    explanation:
        "Le stress chronique peut affaiblir le système immunitaire, augmentant ainsi le risque de maladies.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet de l'alcool sur le système nerveux ?",
    options: ["Stimulation", "Aucune influence", "Dépression"],
    answer: "Dépression",
    explanation:
        "L'alcool agit comme un dépresseur du système nerveux central, perturbant les fonctions cérébrales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bénéfice du sommeil ?",
    options: [
      "Augmentation de l'appétit",
      "Récupération physique et mentale",
      "Diminution de la productivité",
    ],
    answer: "Récupération physique et mentale",
    explanation:
        "Un sommeil de qualité favorise la récupération physique et mentale de l'organisme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal symptôme d'une allergie alimentaire ?",
    options: [
      "Éruption cutanée",
      "Amélioration de la digestion",
      "Augmentation de l'énergie",
    ],
    answer: "Éruption cutanée",
    explanation:
        "Les allergies alimentaires peuvent entraîner divers symptômes, notamment des éruptions cutanées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal risque d'une exposition excessive au soleil ?",
    options: [
      "Amélioration de la santé cutanée",
      "Cancers de la peau",
      "Augmentation de la vitamine D",
    ],
    answer: "Cancers de la peau",
    explanation:
        "Une exposition excessive au soleil augmente le risque de développer des cancers de la peau.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal du yoga sur la santé ?",
    options: [
      "Amélioration de la flexibilité",
      "Augmentation du poids corporel",
      "Diminution de la souplesse",
    ],
    answer: "Amélioration de la flexibilité",
    explanation:
        "Le yoga favorise l'amélioration de la flexibilité et la réduction du stress.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal effet du tabagisme passif ?",
    options: [
      "Amélioration de la santé respiratoire",
      "Risque accru de cancers",
      "Aucune conséquence",
    ],
    answer: "Risque accru de cancers",
    explanation:
        "Le tabagisme passif est lié à un risque accru de diverses formes de cancers chez les non-fumeurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet d'une alimentation riche en fruits et légumes ?",
    options: [
      "Augmentation du poids",
      "Amélioration de la santé générale",
      "Diminution de l'énergie",
    ],
    answer: "Amélioration de la santé générale",
    explanation:
        "Une alimentation riche en fruits et légumes contribue à une meilleure santé générale et à la prévention des maladies.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal objectif de la vaccination ?",
    options: [
      "Traiter les maladies",
      "Prévenir les infections",
      "Augmenter la fièvre",
    ],
    answer: "Prévenir les infections",
    explanation:
        "La vaccination vise à prévenir les infections en stimulant le système immunitaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le lien entre l'exercice physique régulier et la santé mentale ?",
    options: [
      "Aucune corrélation",
      "Amélioration de l'humeur",
      "Diminution des capacités cognitives",
    ],
    answer: "Amélioration de l'humeur",
    explanation:
        "L'exercice physique régulier est associé à une amélioration de l'humeur et à la réduction des symptômes dépressifs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le danger principal de la consommation excessive de sucre ?",
    options: [
      "Augmentation de la concentration",
      "Risque de diabète",
      "Amélioration des performances sportives",
    ],
    answer: "Risque de diabète",
    explanation:
        "Une consommation excessive de sucre augmente le risque de développer un diabète de type 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de graisses est recommandé en quantité modérée ?",
    options: ["Graisses saturées", "Graisses insaturées", "Graisses trans"],
    answer: "Graisses insaturées",
    explanation:
        "Les graisses insaturées, présentes dans les noix et les poissons gras, sont recommandées en quantité modérée pour une bonne santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel test est utilisé pour dépister le diabète ?",
    options: ["Test de glycémie", "Test de cholestérol", "Test de la vue"],
    answer: "Test de glycémie",
    explanation:
        "Le test de glycémie permet de mesurer le taux de sucre dans le sang et de dépister le diabète.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le bénéfice principal d'un sevrage tabagique ?",
    options: [
      "Amélioration de la santé respiratoire",
      "Augmentation du stress",
      "Risque accru de maladies",
    ],
    answer: "Amélioration de la santé respiratoire",
    explanation:
        "Le sevrage tabagique améliore la santé respiratoire et réduit le risque de maladies liées au tabac.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la conséquence d'une mauvaise hygiène bucco-dentaire ?",
    options: [
      "Risque de caries",
      "Amélioration de l'haleine",
      "Aucune conséquence",
    ],
    answer: "Risque de caries",
    explanation:
        "Une mauvaise hygiène bucco-dentaire augmente le risque de caries et de maladies des gencives.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est l'importance des échographies pendant la grossesse ?",
    options: [
      "Déterminer le sexe du bébé seulement",
      "Surveiller le développement du fœtus",
      "Éliminer tous les risques de grossesse",
    ],
    answer: "Surveiller le développement du fœtus",
    explanation:
        "Les échographies sont essentielles pour surveiller le développement et la santé du fœtus.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle de l'OMS (Organisation Mondiale de la Santé) ?",
    options: [
      "Promouvoir la santé",
      "Gérer des entreprises",
      "Imposer des lois",
    ],
    answer: "Promouvoir la santé",
    explanation:
        "L'OMS a pour mission de promouvoir la santé, de contrôler les maladies et de défendre les droits des individus en matière de santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal de l'exercice sur le stress ?",
    options: [
      "Augmentation du stress",
      "Réduction du stress",
      "Aucune influence",
    ],
    answer: "Réduction du stress",
    explanation:
        "L'exercice physique est reconnu pour sa capacité à réduire le stress et l'anxiété.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le risque principal d'une consommation excessive de sel ?",
    options: [
      "Meilleure circulation sanguine",
      "Hypertension",
      "Amélioration de la mémoire",
    ],
    answer: "Hypertension",
    explanation:
        "Une consommation excessive de sel peut conduire à des problèmes d'hypertension artérielle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bénéfice du port de lunettes de soleil ?",
    options: [
      "Protection contre le vent",
      "Protection contre les rayons UV",
      "Augmentation de la luminosité",
    ],
    answer: "Protection contre les rayons UV",
    explanation:
        "Les lunettes de soleil protègent les yeux des effets nocifs des rayons UV.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le facteur de risque principal pour les maladies cardiovasculaires ?",
    options: ["Exercice régulier", "Tabagisme", "Consommation de fruits"],
    answer: "Tabagisme",
    explanation:
        "Le tabagisme est l'un des principaux facteurs de risque des maladies cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle donnée doit être surveillée pour prévenir l'hypercholestérolémie ?",
    options: ["Taux de glucose", "Taux de cholestérol", "Taux de sodium"],
    answer: "Taux de cholestérol",
    explanation:
        "Surveiller le taux de cholestérol est essentiel pour prévenir l'hypercholestérolémie et ses complications.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un moyen efficace de se protéger contre la grippe ?",
    options: [
      "Se laver régulièrement les mains",
      "Consommer des agrumes",
      "Éviter les exercices",
    ],
    answer: "Se laver régulièrement les mains",
    explanation:
        "Se laver les mains régulièrement est un moyen efficace de réduire le risque de contracter la grippe et d'autres infections.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal rôle des fibres dans l'alimentation ?",
    options: [
      "Augmentation du poids",
      "Amélioration de la digestion",
      "Réduction du cholesterol",
    ],
    answer: "Amélioration de la digestion",
    explanation:
        "Les fibres alimentaires jouent un rôle important en améliorant la digestion et en régulant le transit intestinal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du stress sur le sommeil ?",
    options: [
      "Amélioration du sommeil",
      "Perturbation du sommeil",
      "Rien du tout",
    ],
    answer: "Perturbation du sommeil",
    explanation:
        "Le stress peut entraîner des troubles du sommeil, rendant difficile l'endormissement et le maintien du sommeil.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal but de l'éducation à la santé ?",
    options: [
      "Promouvoir le bien-être",
      "Réduire les coûts de la santé",
      "Encourager le tabagisme",
    ],
    answer: "Promouvoir le bien-être",
    explanation:
        "L'éducation à la santé vise à promouvoir le bien-être et à informer les individus sur les comportements sains.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel fruit est connu pour être riche en antioxydants ?",
    options: ["Banane", "Framboise", "Carotte"],
    answer: "Framboise",
    explanation:
        "La framboise est riche en antioxydants, ce qui aide à protéger les cellules du corps des radicaux libres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact principal du manque d'hydratation ?",
    options: [
      "Amélioration des performances",
      "Fatigue",
      "Diminution de l'appétit",
    ],
    answer: "Fatigue",
    explanation:
        "Le manque d'hydratation peut entraîner une fatigue et une baisse de performance physique et mentale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet bénéfique du chocolat noir sur la santé ?",
    options: [
      "Augmentation du cholestérol",
      "Amélioration de l'humeur",
      "Risque de diabète",
    ],
    answer: "Amélioration de l'humeur",
    explanation:
        "Le chocolat noir contient des composés qui peuvent aider à améliorer l'humeur et réduire le stress.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la meilleure façon de prévenir l'obésité ?",
    options: [
      "Manger sans restriction",
      "Avoir une alimentation équilibrée et faire de l'exercice",
      "Éviter toutes les graisses",
    ],
    answer: "Avoir une alimentation équilibrée et faire de l'exercice",
    explanation:
        "Une alimentation équilibrée couplée à une activité physique régulière est la meilleure façon de prévenir l'obésité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact principal de l'isolement social sur la santé ?",
    options: [
      "Amélioration de la santé mentale",
      "Augmentation du risque de maladies",
      "Aucune conséquence",
    ],
    answer: "Augmentation du risque de maladies",
    explanation:
        "L'isolement social est associé à un risque accru de maladies physiques et mentales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle habitude est recommandée pour maintenir un cœur en bonne santé ?",
    options: [
      "Consommer des graisses saturées",
      "Manger des fruits et légumes",
      "Ignorer l'exercice",
    ],
    answer: "Manger des fruits et légumes",
    explanation:
        "Une alimentation riche en fruits et légumes contribue à maintenir une bonne santé cardiaque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le rôle des antiseptiques dans la prévention des infections ?",
    options: [
      "Rendre les tissus plus sensibles",
      "Éliminer les bactéries",
      "Augmenter la douleur",
    ],
    answer: "Éliminer les bactéries",
    explanation:
        "Les antiseptiques sont utilisés pour éliminer ou réduire la charge bactérienne sur les surfaces et les plaies.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal du manque de sommeil sur la santé ?",
    options: [
      "Amélioration de l'humeur",
      "Baisse des performances cognitives",
      "Aucune influence",
    ],
    answer: "Baisse des performances cognitives",
    explanation:
        "Le manque de sommeil peut entraîner des baisses significatives des performances cognitives et de la concentration.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet bénéfique du thé vert ?",
    options: [
      "Amélioration de la mémoire",
      "Augmentation du stress",
      "Effet anti-inflammatoire",
    ],
    answer: "Effet anti-inflammatoire",
    explanation:
        "Le thé vert contient des antioxydants qui ont un effet anti-inflammatoire et bénéfique pour la santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal du calcium dans l'organisme ?",
    options: [
      "Renforcement des os",
      "Amélioration de la vision",
      "Augmentation des réserves de graisse",
    ],
    answer: "Renforcement des os",
    explanation:
        "Le calcium est essentiel pour le renforcement et la solidité des os et des dents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact principal de la pollution de l'air sur la santé ?",
    options: [
      "Amélioration de la respiration",
      "Risque accru de maladies respiratoires",
      "Aucune conséquence",
    ],
    answer: "Risque accru de maladies respiratoires",
    explanation:
        "La pollution de l'air est liée à un risque accru de maladies respiratoires et cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la meilleure pratique pour éviter les infections lors de la manipulation des aliments ?",
    options: [
      "Ne rien faire de spécial",
      "Se laver les mains",
      "Utiliser des gants en permanence",
    ],
    answer: "Se laver les mains",
    explanation:
        "Se laver les mains fréquemment est essentiel pour prévenir les infections lors de la manipulation des aliments.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des probiotiques dans l'alimentation ?",
    options: [
      "Amélioration de la digestion",
      "Risque accru de maladies",
      "Aucune influence",
    ],
    answer: "Amélioration de la digestion",
    explanation:
        "Les probiotiques contribuent à maintenir une flore intestinale saine et améliorent la digestion.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet positif du rire sur la santé ?",
    options: [
      "Augmentation de la pression artérielle",
      "Réduction du stress",
      "Diminution de l'énergie",
    ],
    answer: "Réduction du stress",
    explanation:
        "Le rire est reconnu pour sa capacité à réduire le stress et améliorer le bien-être général.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal effet du manque d'exercice sur la santé ?",
    options: [
      "Protection du cœur",
      "Perte de poids",
      "Risque accru de maladies",
    ],
    answer: "Risque accru de maladies",
    explanation:
        "Le manque d'exercice est associé à un risque accru de maladies chroniques, telles que le diabète et les maladies cardiaques.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal moyen de prévention contre la grippe ?",
    options: [
      "Se laver régulièrement les mains",
      "Prendre des antibiotiques",
      "Manger des fruits",
    ],
    answer: "Se laver régulièrement les mains",
    explanation:
        "Se laver régulièrement les mains aide à réduire la transmission des virus, y compris celui de la grippe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le symptôme principal de la COVID-19 ?",
    options: ["Fatigue sévère", "Perte du goût", "Douleurs abdominales"],
    answer: "Perte du goût",
    explanation:
        "La perte du goût est l'un des symptômes caractéristiques de l'infection par le virus SARS-CoV-2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel vaccin est recommandé pour prévenir le tétanos ?",
    options: ["Vaccin BCG", "Vaccin DTP", "Vaccin anti-grippal"],
    answer: "Vaccin DTP",
    explanation:
        "Le vaccin DTP protège contre la diphtérie, le tétanos et la coqueluche.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel aliment est riche en vitamine C et aide à renforcer le système immunitaire ?",
    options: ["Carottes", "Citrons", "Pâtes"],
    answer: "Citrons",
    explanation:
        "Les citrons sont une excellente source de vitamine C, qui soutient le système immunitaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des campagnes de vaccination ?",
    options: [
      "Réduire la pollution",
      "Prévenir les maladies infectieuses",
      "Augmenter la population",
    ],
    answer: "Prévenir les maladies infectieuses",
    explanation:
        "Les campagnes de vaccination visent à prévenir la propagation des maladies infectieuses dans la population.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la meilleure méthode pour éviter les maladies respiratoires ?",
    options: [
      "Éviter de sortir",
      "Porter un masque",
      "Consommer des boissons chaudes",
    ],
    answer: "Porter un masque",
    explanation:
        "Le port d'un masque réduit la transmission des maladies respiratoires, en particulier en période d'épidémie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel comportement est essentiel pour prévenir les infections ?",
    options: [
      "Se laver les mains fréquemment",
      "Boire beaucoup d'eau",
      "Faire du sport",
    ],
    answer: "Se laver les mains fréquemment",
    explanation:
        "Se laver les mains fréquemment est crucial pour prévenir la propagation des infections.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel test est souvent effectué pour dépister le cancer du sein ?",
    options: ["Mamographie", "Scintigraphie", "IRM"],
    answer: "Mamographie",
    explanation:
        "La mammographie est un examen radiologique utilisé pour dépister les cancers du sein.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal facteur de risque pour les maladies cardiovasculaires ?",
    options: ["Consommation de fruits", "Sédentarité", "Pratique d'un sport"],
    answer: "Sédentarité",
    explanation:
        "La sédentarité est un facteur de risque majeur pour le développement des maladies cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal du tabagisme sur la santé ?",
    options: [
      "Augmente l'appétit",
      "Provoque des maladies pulmonaires",
      "Renforce le système immunitaire",
    ],
    answer: "Provoque des maladies pulmonaires",
    explanation:
        "Le tabagisme est responsable de nombreuses maladies pulmonaires, y compris le cancer du poumon.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'organe principalement touché par l'hépatite ?",
    options: ["Les reins", "Le foie", "Les poumons"],
    answer: "Le foie",
    explanation:
        "L'hépatite est une inflammation du foie, souvent causée par des virus.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un effet bénéfique de l'exercice physique régulier ?",
    options: [
      "Augmentation du stress",
      "Amélioration de la santé mentale",
      "Diminution du sommeil",
    ],
    answer: "Amélioration de la santé mentale",
    explanation:
        "L'exercice physique régulier contribue à améliorer la santé mentale et à réduire le stress.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est recommandé pour une bonne santé osseuse ?",
    options: ["Chocolat", "Produits laitiers", "Sucre"],
    answer: "Produits laitiers",
    explanation:
        "Les produits laitiers sont riches en calcium, essentiel pour la santé osseuse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'objectif principal des examens de santé réguliers ?",
    options: [
      "Évaluer la performance physique",
      "Détecter les maladies précocement",
      "Réduire le stress",
    ],
    answer: "Détecter les maladies précocement",
    explanation:
        "Les examens de santé réguliers aident à détecter les maladies de manière précoce pour un traitement efficace.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le moyen le plus efficace de prévenir la dengue ?",
    options: [
      "Vaccination",
      "Élimination des moustiques",
      "Port de vêtements longs",
    ],
    answer: "Élimination des moustiques",
    explanation:
        "L'élimination des moustiques et de leurs habitats est cruciale pour prévenir la dengue.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel comportement de vie est recommandé pour prévenir l'obésité ?",
    options: [
      "Manger rapidement",
      "Éviter les fruits",
      "Pratiquer une activité physique",
    ],
    answer: "Pratiquer une activité physique",
    explanation:
        "L'activité physique régulière est essentielle pour maintenir un poids santé et prévenir l'obésité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le meilleur moment pour se faire vacciner contre la grippe ?",
    options: ["En été", "Avant l'hiver", "Pendant les vacances"],
    answer: "Avant l'hiver",
    explanation:
        "Il est recommandé de se faire vacciner contre la grippe avant le début de l'hiver pour une protection optimale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de pression artérielle est considéré comme normal ?",
    options: ["140/90 mmHg", "120/80 mmHg", "180/120 mmHg"],
    answer: "120/80 mmHg",
    explanation:
        "Une pression artérielle de 120/80 mmHg est considérée comme normale pour un adulte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel nutriment est essentiel pour la santé des yeux ?",
    options: ["Vitamine A", "Calcium", "Fibre"],
    answer: "Vitamine A",
    explanation:
        "La vitamine A est essentielle pour la santé des yeux et la vision nocturne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal de l'alcool sur le corps ?",
    options: [
      "Améliore la digestion",
      "Aggrave les maladies cardiaques",
      "Renforce le système immunitaire",
    ],
    answer: "Aggrave les maladies cardiaques",
    explanation:
        "La consommation excessive d'alcool peut aggraver les maladies cardiaques et d'autres problèmes de santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale cause de l'obésité infantile ?",
    options: [
      "Manque d'activité physique",
      "Consommation de légumes",
      "Lecture excessive",
    ],
    answer: "Manque d'activité physique",
    explanation:
        "Le manque d'activité physique est une cause majeure de l'obésité infantile dans les sociétés modernes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel produit est souvent utilisé pour désinfecter les mains ?",
    options: ["Savon", "Crème solaire", "Shampooing"],
    answer: "Savon",
    explanation:
        "Le savon est utilisé pour désinfecter les mains en éliminant efficacement les germes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est l'affection liée à une carence en iode ?",
    options: ["Astigmatisme", "Goitre", "Diabète"],
    answer: "Goitre",
    explanation:
        "Le goitre est une affection causée par une carence en iode dans l'alimentation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est un des principaux avantages de l'allaitement maternel ?",
    options: [
      "Renforce l'immunité du nourrisson",
      "Ralentit la croissance",
      "Provoque des allergies",
    ],
    answer: "Renforce l'immunité du nourrisson",
    explanation:
        "L'allaitement maternel renforce l'immunité du nourrisson grâce aux anticorps contenus dans le lait maternel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Comment se transmet le VIH ?",
    options: [
      "Par des gestes de salutation",
      "Par contact avec l'eau",
      "Par contact sexuel",
    ],
    answer: "Par contact sexuel",
    explanation:
        "Le VIH se transmet principalement par voie sexuelle, en particulier sans protection.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle habitude peut réduire le risque de maladies chroniques ?",
    options: [
      "Manger des aliments transformés",
      "Faire de l'exercice régulièrement",
      "Dormir moins de 6 heures par nuit",
    ],
    answer: "Faire de l'exercice régulièrement",
    explanation:
        "Faire de l'exercice régulièrement aide à réduire le risque de nombreuses maladies chroniques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'âge recommandé pour le premier dépistage du cancer du col de l'utérus ?",
    options: ["10 ans", "25 ans", "40 ans"],
    answer: "25 ans",
    explanation:
        "Le dépistage du cancer du col de l'utérus est recommandé à partir de 25 ans chez les femmes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal avantage de la méditation ?",
    options: [
      "Augmentation de l'anxiété",
      "Amélioration de la concentration",
      "Diminution de l'énergie",
    ],
    answer: "Amélioration de la concentration",
    explanation:
        "La méditation est connue pour améliorer la concentration et réduire le stress mental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle forme de dépistage est utilisée pour le cancer du prostate ?",
    options: ["IRM", "Test PSA", "Échographie abdominale"],
    answer: "Test PSA",
    explanation:
        "Le test PSA mesure le taux d'antigène prostatique spécifique pour dépister le cancer de la prostate.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est un facteur de risque majeur pour le diabète de type 2 ?",
    options: [
      "Activité physique régulière",
      "Consommation élevée de sucre",
      "Sommeil suffisant",
    ],
    answer: "Consommation élevée de sucre",
    explanation:
        "Une consommation élevée de sucre peut contribuer au développement du diabète de type 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la meilleure façon de protéger la peau du soleil ?",
    options: [
      "Éviter les douches",
      "Utiliser une crème solaire",
      "Porter des vêtements légers",
    ],
    answer: "Utiliser une crème solaire",
    explanation:
        "L'utilisation d'une crème solaire aide à protéger la peau des dommages causés par les UV.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact de la pollution sur la santé ?",
    options: [
      "Renforce le système immunitaire",
      "Provoque des troubles respiratoires",
      "Améliore la qualité de vie",
    ],
    answer: "Provoque des troubles respiratoires",
    explanation:
        "La pollution de l'air est associée à divers troubles respiratoires et maladies chroniques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'examen courant pour évaluer le taux de cholestérol sanguin ?",
    options: ["Électrocardiogramme", "Analyse de sang", "Radiographie"],
    answer: "Analyse de sang",
    explanation:
        "Une analyse de sang permet de mesurer le taux de cholestérol et d'évaluer les risques cardiovasculaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le moyen de prévention le plus efficace contre le VIH ?",
    options: [
      "Utiliser des préservatifs",
      "Manger des aliments sains",
      "Se faire vacciner",
    ],
    answer: "Utiliser des préservatifs",
    explanation:
        "L'utilisation de préservatifs est l'une des méthodes les plus efficaces pour prévenir la transmission du VIH.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est l'importance des fibres dans l'alimentation ?",
    options: [
      "Augmentent le poids",
      "Favorisent la digestion",
      "Rendent les aliments plus sucrés",
    ],
    answer: "Favorisent la digestion",
    explanation:
        "Les fibres alimentaires favorisent la digestion et aident à prévenir la constipation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel âge est recommandé pour commencer à faire un suivi dentaire régulier ?",
    options: ["Avant un an", "À cinq ans", "À quinze ans"],
    answer: "Avant un an",
    explanation:
        "Il est conseillé d'initier un suivi dentaire régulier dès le plus jeune âge, idéalement avant un an.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un signe précoce de déshydratation ?",
    options: ["Toux fréquente", "Diminution de l'urine", "Frissons"],
    answer: "Diminution de l'urine",
    explanation:
        "Une diminution de la production d'urine peut être un signe précoce de déshydratation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle maladie est souvent prévenue par la vaccination systématique ?",
    options: ["Grippe", "Pneumonie", "Diabète"],
    answer: "Grippe",
    explanation:
        "La vaccination systématique aide à prévenir la grippe, une infection respiratoire fréquente.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'un des bénéfices du rire pour la santé ?",
    options: [
      "Augmentation du stress",
      "Diminution de la production d'hormones",
      "Amélioration de l'humeur",
    ],
    answer: "Amélioration de l'humeur",
    explanation:
        "Le rire stimule la production d'endorphines, améliorant ainsi l'humeur et réduisant le stress.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du tabac sur la santé bucco-dentaire ?",
    options: [
      "Améliore la santé des gencives",
      "Provoque des maladies parodontales",
      "N'a aucun impact",
    ],
    answer: "Provoque des maladies parodontales",
    explanation:
        "Le tabagisme augmente le risque de maladies parodontales, affectant gravement la santé bucco-dentaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le bénéfice principal de l'hydratation adéquate ?",
    options: [
      "Améliore la concentration",
      "Ralentit la digestion",
      "Favorise la prise de poids",
    ],
    answer: "Améliore la concentration",
    explanation:
        "Une bonne hydratation aide à maintenir la concentration et la fonction cognitive optimale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un facteur déclenchant de l'asthme ?",
    options: [
      "L'exercice physique",
      "L'odeur des fleurs",
      "La pollution de l'air",
    ],
    answer: "La pollution de l'air",
    explanation:
        "La pollution de l'air est un des facteurs déclenchants majeurs des crises d'asthme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact de la consommation excessive de sel sur la santé ?",
    options: [
      "Améliore la mémoire",
      "Augmente la pression artérielle",
      "Favorise le sommeil",
    ],
    answer: "Augmente la pression artérielle",
    explanation:
        "Une consommation excessive de sel est associée à une augmentation de la pression artérielle, augmentant les risques cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un bon moyen de renforcer le système immunitaire ?",
    options: [
      "Manger des sucreries",
      "Pratiquer une activité physique",
      "Regarder la télévision",
    ],
    answer: "Pratiquer une activité physique",
    explanation:
        "L'exercice physique régulier aide à renforcer le système immunitaire et à améliorer la santé globale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'âge recommandé pour le dépistage du cancer colorectal ?",
    options: ["50 ans", "60 ans", "70 ans"],
    answer: "50 ans",
    explanation:
        "Le dépistage du cancer colorectal est recommandé à partir de 50 ans pour une détection précoce.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'un des principaux avantages d'une alimentation équilibrée ?",
    options: [
      "Favorise la fatigue",
      "Augmente le risque de maladies",
      "Améliore la santé générale",
    ],
    answer: "Améliore la santé générale",
    explanation:
        "Une alimentation équilibrée contribue à améliorer la santé générale et à réduire les risques de maladies.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale préoccupation d'une mauvaise posture ?",
    options: [
      "Amélioration de la digestion",
      "Douleurs dorsales",
      "Augmentation de l'énergie",
    ],
    answer: "Douleurs dorsales",
    explanation:
        "Une mauvaise posture peut entraîner des douleurs dorsales et d'autres problèmes musculo-squelettiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est un des principaux risques de l'exposition excessive au soleil ?",
    options: [
      "Amélioration de la circulation sanguine",
      "Risque de cancer de la peau",
      "Diminution de la chaleur corporelle",
    ],
    answer: "Risque de cancer de la peau",
    explanation:
        "Une exposition excessive au soleil augmente considérablement le risque de cancer de la peau.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact de la consommation de fruits et légumes sur la santé ?",
    options: [
      "Augmente les maladies",
      "Améliore la santé globale",
      "N'a aucun effet",
    ],
    answer: "Améliore la santé globale",
    explanation:
        "Une consommation riche en fruits et légumes est associée à une meilleure santé globale et à une réduction des maladies.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle vitamine est principalement synthétisée par la peau sous l'effet du soleil ?",
    options: ["Vitamine A", "Vitamine C", "Vitamine D"],
    answer: "Vitamine D",
    explanation:
        "La vitamine D est produite par la peau lorsqu'elle est exposée aux rayons ultraviolets B du soleil.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal mode de transmission du VIH ?",
    options: [
      "Contact avec le sang",
      "Transmission par l'air",
      "Transmission par l'eau",
    ],
    answer: "Contact avec le sang",
    explanation:
        "Le VIH se transmet principalement par le biais du contact avec des fluides corporels infectés, notamment le sang.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal des vaccins ?",
    options: [
      "Traiter les maladies",
      "Prévenir les maladies",
      "Augmenter la température corporelle",
    ],
    answer: "Prévenir les maladies",
    explanation:
        "Les vaccins aident à préparer le système immunitaire à combattre des maladies spécifiques avant leur exposition.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet bénéfique de la consommation régulière de fruits et légumes ?",
    options: [
      "Augmentation du cholestérol",
      "Réduction du risque de maladies cardiovasculaires",
      "Augmentation du poids",
    ],
    answer: "Réduction du risque de maladies cardiovasculaires",
    explanation:
        "Une alimentation riche en fruits et légumes contribue à la santé cardiovasculaire en réduisant divers risques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal facteur de risque de cancer du poumon ?",
    options: ["Tabagisme", "Consommation de fruits", "Exercice physique"],
    answer: "Tabagisme",
    explanation:
        "Le tabagisme est le principal facteur de risque pour le développement du cancer du poumon.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal nutriment manquant dans l'alimentation de nombreuses personnes ?",
    options: ["Fibres", "Glucides", "Protéines"],
    answer: "Fibres",
    explanation:
        "Beaucoup de gens consomment moins de fibres que la quantité recommandée, ce qui peut nuire à leur santé digestive.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'agent pathogène responsable de la grippe ?",
    options: ["Bactérie", "Virus", "Champignon"],
    answer: "Virus",
    explanation:
        "La grippe est causée par un virus qui infecte les voies respiratoires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle méthode est souvent utilisée pour réduire le risque de maladies transmissibles ?",
    options: ["Vaccination", "Jeûne", "Bain de soleil"],
    answer: "Vaccination",
    explanation:
        "La vaccination est une méthode efficace pour prévenir les maladies transmissibles en immunisant le corps.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal bénéfice de l'activité physique régulière ?",
    options: [
      "Augmentation du stress",
      "Amélioration de l'humeur",
      "Perte d'énergie",
    ],
    answer: "Amélioration de l'humeur",
    explanation:
        "L'exercice physique libère des endorphines qui améliorent l'état émotionnel et l'humeur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel aliment est souvent recommandé pour son effet bénéfique sur le cœur ?",
    options: ["Chocolat", "Avocat", "Soda"],
    answer: "Avocat",
    explanation:
        "L'avocat contient des graisses saines qui peuvent contribuer à réduire le risque de maladies cardiaques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le terme qui désigne un état de stress prolongé ?",
    options: ["Fatigue", "Épuisement professionnel", "Repos"],
    answer: "Épuisement professionnel",
    explanation:
        "L'épuisement professionnel décrit un état de fatigue physique et émotionnelle dû à un stress intense et prolongé au travail.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet de la consommation excessive d'alcool ?",
    options: [
      "Amélioration de la mémoire",
      "Augmentation du risque de maladies hépatiques",
      "Renforcement du système immunitaire",
    ],
    answer: "Augmentation du risque de maladies hépatiques",
    explanation:
        "La consommation excessive d'alcool peut endommager le foie et augmenter le risque de maladies hépatiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle pratique est essentielle pour maintenir une bonne hygiène dentaire ?",
    options: [
      "Utiliser du fil dentaire",
      "Boire beaucoup de soda",
      "Manger des bonbons",
    ],
    answer: "Utiliser du fil dentaire",
    explanation:
        "L'utilisation quotidienne du fil dentaire aide à prévenir les caries et les maladies des gencives.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact des sucres ajoutés sur la santé ?",
    options: [
      "Renforcement des os",
      "Prise de poids",
      "Amélioration de la concentration",
    ],
    answer: "Prise de poids",
    explanation:
        "Une consommation élevée de sucres ajoutés est souvent associée à un gain de poids et à divers problèmes de santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal symptôme de la déshydratation ?",
    options: ["Fatigue", "Nausées", "Soif intense"],
    answer: "Soif intense",
    explanation:
        "La soif intense est un signe clair que le corps a besoin de plus d'eau pour fonctionner correctement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de graisse est considéré comme le plus sain ?",
    options: ["Gras trans", "Graisses saturées", "Graisses insaturées"],
    answer: "Graisses insaturées",
    explanation:
        "Les graisses insaturées, présentes dans des aliments comme l'huile d'olive, sont bénéfiques pour la santé cardiaque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal danger lié au tabagisme passif ?",
    options: [
      "Augmentation de la taille",
      "Risque de maladies respiratoires",
      "Amélioration de l'odorat",
    ],
    answer: "Risque de maladies respiratoires",
    explanation:
        "Le tabagisme passif expose les non-fumeurs à des substances nocives, augmentant leur risque de maladies respiratoires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact d’une mauvaise alimentation sur la santé mentale ?",
    options: [
      "Amélioration de la mémoire",
      "Augmentation de l'anxiété",
      "Réduction du stress",
    ],
    answer: "Augmentation de l'anxiété",
    explanation:
        "Une mauvaise alimentation peut influencer négativement l'humeur et favoriser des symptômes d'anxiété.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le but de l'examen médical régulier ?",
    options: [
      "Évaluer l'état de santé",
      "Établir un régime strict",
      "Réduire l'exercice physique",
    ],
    answer: "Évaluer l'état de santé",
    explanation:
        "Les examens médicaux réguliers aident à détecter des problèmes de santé avant qu'ils ne deviennent graves.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du stress sur le système immunitaire ?",
    options: [
      "Renforce le système immunitaire",
      "Affaiblit le système immunitaire",
      "N'a aucun effet",
    ],
    answer: "Affaiblit le système immunitaire",
    explanation:
        "Le stress prolongé peut affaiblir le système immunitaire, rendant l'individu plus vulnérable aux infections.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal effet de la pollution sur la santé ?",
    options: [
      "Amélioration de la circulation sanguine",
      "Augmentation des maladies respiratoires",
      "Diminution des allergies",
    ],
    answer: "Augmentation des maladies respiratoires",
    explanation:
        "La pollution peut aggraver les problèmes respiratoires et augmenter le risque de maladies pulmonaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle pratique aide à prévenir les maladies infectieuses ?",
    options: [
      "Laver les mains régulièrement",
      "Prendre des antibiotiques",
      "Éviter de manger des légumes",
    ],
    answer: "Laver les mains régulièrement",
    explanation:
        "Se laver les mains régulièrement réduit la transmission des germes et des infections.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact d'un sommeil insuffisant sur la santé ?",
    options: [
      "Amélioration de la concentration",
      "Augmentation du risque d'accidents",
      "Réduction de l'appétit",
    ],
    answer: "Augmentation du risque d'accidents",
    explanation:
        "Le manque de sommeil peut entraîner une diminution de la vigilance et augmenter le risque d'accidents.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal nutriment que l'on trouve dans les produits laitiers ?",
    options: ["Protéines", "Calcium", "Fibres"],
    answer: "Calcium",
    explanation:
        "Les produits laitiers sont une source importante de calcium, essentiel pour la santé des os.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est une des principales conséquences de l'obésité ?",
    options: [
      "Amélioration de la condition physique",
      "Augmentation du risque de diabète de type 2",
      "Diminution du stress",
    ],
    answer: "Augmentation du risque de diabète de type 2",
    explanation:
        "L'obésité augmente significativement le risque de développer un diabète de type 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le terme médical pour désigner une pression artérielle élevée ?",
    options: ["Hypertension", "Hypotension", "Normotension"],
    answer: "Hypertension",
    explanation:
        "L'hypertension est une condition où la pression sanguine dans les artères est excessivement élevée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet d'une bonne hydratation sur le corps ?",
    options: [
      "Diminution de l'énergie",
      "Amélioration de la performance physique",
      "Augmentation de la fatigue",
    ],
    answer: "Amélioration de la performance physique",
    explanation:
        "Une bonne hydratation soutient la performance physique en maintenant l'équilibre et l'énergie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la durée de vie moyenne d'un moustique ?",
    options: ["1-2 jours", "1-2 semaines", "1-2 mois"],
    answer: "1-2 mois",
    explanation:
        "La durée de vie d'un moustique peut varier, mais en moyenne, elle est de 1 à 2 mois.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal avantage de la méditation ?",
    options: [
      "Augmentation de l'anxiété",
      "Réduction du stress",
      "Perte de mémoire",
    ],
    answer: "Réduction du stress",
    explanation:
        "La méditation est reconnue pour ses effets bénéfiques sur la réduction du stress et l'amélioration du bien-être mental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal effet du tabagisme sur les poumons ?",
    options: [
      "Renforcement des poumons",
      "Réduction de la capacité pulmonaire",
      "Amélioration de la respiration",
    ],
    answer: "Réduction de la capacité pulmonaire",
    explanation:
        "Le tabagisme nuit aux poumons, réduisant leur capacité fonctionnelle à long terme.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact de la vitamine A sur la vision ?",
    options: [
      "Améliore la vision nocturne",
      "Réduit la fatigue oculaire",
      "N'a aucun effet",
    ],
    answer: "Améliore la vision nocturne",
    explanation:
        "La vitamine A est essentielle pour maintenir une bonne vision, en particulier la vision nocturne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le lien entre le stress et la santé cardiaque ?",
    options: [
      "Diminution du risque cardiaque",
      "Augmentation du rythme cardiaque",
      "Aucun lien",
    ],
    answer: "Augmentation du rythme cardiaque",
    explanation:
        "Le stress peut provoquer une augmentation du rythme cardiaque et accroître le risque de problèmes cardiaques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal nutriment que l'on trouve dans les poissons gras ?",
    options: ["Oméga-3", "Fibres", "Glucides"],
    answer: "Oméga-3",
    explanation:
        "Les poissons gras sont une excellente source d'acides gras oméga-3, bénéfiques pour la santé cardiaque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal risque d'une exposition prolongée au soleil sans protection ?",
    options: [
      "Amélioration de la peau",
      "Augmentation du risque de cancer de la peau",
      "Diminution des rides",
    ],
    answer: "Augmentation du risque de cancer de la peau",
    explanation:
        "Une exposition excessive au soleil sans protection augmente significativement le risque de cancer de la peau.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est riche en fibres ?",
    options: ["Pain blanc", "Pâtes raffinées", "Légumineuses"],
    answer: "Légumineuses",
    explanation:
        "Les légumineuses, comme les lentilles et les pois chiches, sont particulièrement riches en fibres, favorisant la santé digestive.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la meilleure boisson pour rester hydraté ?",
    options: ["Soda", "Café", "Eau"],
    answer: "Eau",
    explanation:
        "L'eau est la meilleure boisson pour maintenir une bonne hydratation et est essentielle pour la santé globale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du sucre sur les dents ?",
    options: ["Renforce l'émail", "Provoque des caries", "N'a aucun effet"],
    answer: "Provoque des caries",
    explanation:
        "Une consommation excessive de sucre peut entraîner la formation de caries dentaires en nourrissant les bactéries buccales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet bénéfique des acides gras oméga-3 ?",
    options: [
      "Augmentation du cholestérol LDL",
      "Réduction de l'inflammation",
      "Diminution du métabolisme",
    ],
    answer: "Réduction de l'inflammation",
    explanation:
        "Les acides gras oméga-3 sont connus pour leurs propriétés anti-inflammatoires, bénéfiques pour la santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale source de fibres solubles ?",
    options: ["Fruits", "Viande", "Produits laitiers"],
    answer: "Fruits",
    explanation:
        "Les fruits, comme les pommes et les oranges, sont une excellente source de fibres solubles, bénéfiques pour la santé digestive.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le meilleur moyen de prévenir les maladies cardiaques ?",
    options: [
      "Exercice régulier",
      "Consommation de sucreries",
      "Fumer des cigarettes",
    ],
    answer: "Exercice régulier",
    explanation:
        "L'exercice régulier est clé pour réduire le risque de maladies cardiaques et améliorer la santé globale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact de l'obésité sur le diabète ?",
    options: [
      "Réduction du risque",
      "Augmentation du risque de diabète de type 2",
      "Aucun impact",
    ],
    answer: "Augmentation du risque de diabète de type 2",
    explanation:
        "L'obésité augmente le risque de développer un diabète de type 2 en affectant la régulation de la glycémie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la nécessité d'une bonne hygiène des mains ?",
    options: [
      "Éviter les maladies",
      "Augmenter le poids",
      "Diminuer la fatigue",
    ],
    answer: "Éviter les maladies",
    explanation:
        "Une bonne hygiène des mains est essentielle pour prévenir la propagation des maladies infectieuses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le bénéfice principal des grains entiers dans l'alimentation ?",
    options: [
      "Augmentation du cholestérol",
      "Diminution du risque de maladies cardiaques",
      "Aucun bénéfice",
    ],
    answer: "Diminution du risque de maladies cardiaques",
    explanation:
        "Les grains entiers sont associés à un risque réduit de maladies cardiaques en raison de leur richesse en fibres et nutriments.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'inconvénient de la sédentarité ?",
    options: [
      "Amélioration de la circulation sanguine",
      "Augmentation du risque de maladies chroniques",
      "Renforcement musculaire",
    ],
    answer: "Augmentation du risque de maladies chroniques",
    explanation:
        "La sédentarité est liée à un risque accru de développer des maladies chroniques telles que le diabète et les maladies cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet de l'exposition au soleil sur la peau ?",
    options: [
      "Amélioration de l'élasticité",
      "Risque de coups de soleil",
      "Pas d'effet",
    ],
    answer: "Risque de coups de soleil",
    explanation:
        "Une exposition excessive au soleil sans protection augmente le risque de coups de soleil et de dommages cutanés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du chocolat noir sur la santé ?",
    options: [
      "Augmentation du cholestérol",
      "Bénéfique pour le cœur",
      "Pas d'effet",
    ],
    answer: "Bénéfique pour le cœur",
    explanation:
        "Le chocolat noir, en raison de ses antioxydants, peut avoir des effets bénéfiques sur la santé cardiaque.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle vitamine est principalement synthétisée par la peau en réponse au soleil ?",
    options: ["Vitamine A", "Vitamine C", "Vitamine D"],
    answer: "Vitamine D",
    explanation:
        "La vitamine D est produite par la peau lorsqu'elle est exposée aux rayons UV du soleil.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'âge recommandé pour commencer à pratiquer des dépistages du cancer du sein ?",
    options: ["40 ans", "30 ans", "50 ans"],
    answer: "40 ans",
    explanation:
        "La plupart des recommandations suggèrent de commencer le dépistage à 40 ans pour les femmes à risque moyen.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est une source importante de fer ?",
    options: ["Pommes de terre", "Épinards", "Pâtes"],
    answer: "Épinards",
    explanation:
        "Les épinards contiennent une quantité significative de fer, essentiel pour prévenir l'anémie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle maladie est causée par une carence en vitamine C ?",
    options: ["Scorbut", "Rachitisme", "Anémie"],
    answer: "Scorbut",
    explanation:
        "Le scorbut résulte d'un manque de vitamine C dans l'alimentation, entraînant des symptômes tels que fatigue et douleurs articulaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal moyen de prévention contre la transmission du VIH ?",
    options: [
      "L'utilisation de préservatifs",
      "Les tests réguliers",
      "Vaccination",
    ],
    answer: "L'utilisation de préservatifs",
    explanation:
        "Utiliser des préservatifs réduit considérablement le risque de transmission du VIH lors des rapports sexuels.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle boisson est souvent recommandée pour une bonne hydratation ?",
    options: ["Soda", "Eau", "Jus d'orange"],
    answer: "Eau",
    explanation:
        "L'eau est la meilleure boisson pour l'hydratation en raison de son absence de calories et de sucres ajoutés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal objectif de la vaccination ?",
    options: [
      "Guérir les maladies",
      "Prévenir les maladies",
      "Traiter les symptômes",
    ],
    answer: "Prévenir les maladies",
    explanation:
        "La vaccination vise à stimuler le système immunitaire pour prévenir l'apparition de certaines maladies infectieuses.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du tabagisme sur la santé ?",
    options: [
      "Améliore la circulation",
      "Diminue le risque de cancer",
      "Augmente le risque de maladies cardiaques",
    ],
    answer: "Augmente le risque de maladies cardiaques",
    explanation:
        "Le tabagisme est un facteur de risque majeur pour les maladies cardiaques et d'autres problèmes de santé graves.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'aliment riche en oméga-3 ?",
    options: ["Viande rouge", "Saumon", "Pain"],
    answer: "Saumon",
    explanation:
        "Le saumon est une excellente source d'oméga-3, qui sont bénéfiques pour la santé cardiaque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Qu'est-ce qui est principalement affecté par l'hypertension ?",
    options: ["Les os", "Le cœur", "La peau"],
    answer: "Le cœur",
    explanation:
        "L'hypertension, ou pression artérielle élevée, impacte directement la santé cardiaque et peut entraîner des maladies cardiovasculaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact d'un excès de sucre sur la santé ?",
    options: [
      "Améliore la mémoire",
      "Contribue à l'obésité",
      "Renforce les os",
    ],
    answer: "Contribue à l'obésité",
    explanation:
        "Un excès de sucre peut entraîner un gain de poids et augmenter le risque d'obésité et de diabète.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel organe est responsable de la filtration du sang ?",
    options: ["Le cœur", "Les reins", "Le foie"],
    answer: "Les reins",
    explanation:
        "Les reins filtrent le sang pour éliminer les déchets et réguler les électrolytes du corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale source de vitamine B12 ?",
    options: ["Produits laitiers", "Légumes", "Viande"],
    answer: "Viande",
    explanation:
        "La vitamine B12 est principalement trouvée dans les produits d'origine animale, en particulier la viande.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal risque d'un manque d'exercice physique ?",
    options: [
      "Amélioration du sommeil",
      "Augmentation de l'énergie",
      "Augmentation du risque de maladies chroniques",
    ],
    answer: "Augmentation du risque de maladies chroniques",
    explanation:
        "Une inactivité physique est associée à un risque accru de maladies comme le diabète et les maladies cardiaques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle du calcium dans le corps humain ?",
    options: [
      "Renforcer le système immunitaire",
      "Améliorer la digestion",
      "Renforcer les os",
    ],
    answer: "Renforcer les os",
    explanation:
        "Le calcium est essentiel à la construction et à l'entretien des os solides et en bonne santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du stress sur la santé ?",
    options: [
      "Améliore la concentration",
      "Peut affaiblir le système immunitaire",
      "Favorise la bonne humeur",
    ],
    answer: "Peut affaiblir le système immunitaire",
    explanation:
        "Un stress chronique peut nuire au système immunitaire, rendant une personne plus vulnérable aux maladies.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal avantage des fruits et légumes ?",
    options: [
      "Riches en calories",
      "Riche en fibres et vitamines",
      "Faciles à préparer",
    ],
    answer: "Riche en fibres et vitamines",
    explanation:
        "Les fruits et légumes sont essentiels pour une alimentation équilibrée grâce à leur haute teneur en fibres et en vitamines.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel dérivé du tabac est souvent responsable de dépendance ?",
    options: ["Alcool", "Nicotine", "Caféine"],
    answer: "Nicotine",
    explanation:
        "La nicotine, présente dans le tabac, est une substance hautement addictive qui entraîne une dépendance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle hormone est souvent appelée l'hormone du bonheur ?",
    options: ["Adrénaline", "Sérotonine", "Insuline"],
    answer: "Sérotonine",
    explanation:
        "La sérotonine est souvent liée à la régulation de l'humeur et est appelée l'hormone du bonheur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le risque principal d'une exposition prolongée au soleil ?",
    options: [
      "Coup de soleil",
      "Cancer de la peau",
      "Éclaircissement de la peau",
    ],
    answer: "Cancer de la peau",
    explanation:
        "Une exposition prolongée au soleil augmente considérablement le risque de développer un cancer de la peau.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des antioxydants dans le corps ?",
    options: [
      "Protéger les cellules du vieillissement",
      "Augmenter l'appétit",
      "Favoriser la digestion",
    ],
    answer: "Protéger les cellules du vieillissement",
    explanation:
        "Les antioxydants aident à neutraliser les radicaux libres, protégeant ainsi les cellules du vieillissement prématuré.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la durée moyenne recommandée d'exercice par semaine pour les adultes ?",
    options: ["30 minutes", "150 minutes", "60 minutes"],
    answer: "150 minutes",
    explanation:
        "Les recommandations de santé suggèrent au moins 150 minutes d'exercice modéré par semaine pour les adultes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal du sommeil sur la santé ?",
    options: [
      "Réduit le stress",
      "Favorise la croissance musculaire",
      "Restaure l'énergie et améliore la concentration",
    ],
    answer: "Restaure l'énergie et améliore la concentration",
    explanation:
        "Un bon sommeil permet de se recharger et favorise une meilleure concentration durant la journée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal risque pour la santé associé à une consommation excessive d'alcool ?",
    options: [
      "Amélioration de l'hydratation",
      "Maladies hépatiques",
      "Augmentation de la longévité",
    ],
    answer: "Maladies hépatiques",
    explanation:
        "La consommation excessive d'alcool est un facteur de risque majeur pour le développement de maladies hépatiques, comme la cirrhose.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la principale cause des maladies respiratoires chroniques ?",
    options: [
      "Fumer des cigarettes",
      "S'exposer à des allergènes",
      "Manger des aliments épicés",
    ],
    answer: "Fumer des cigarettes",
    explanation:
        "Le tabagisme est la cause principale des maladies respiratoires chroniques, comme la BPCO.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quels sont les bienfaits des probiotiques pour la santé ?",
    options: [
      "Améliorent la digestion",
      "Augmentent la fatigue",
      "Ralentissent le métabolisme",
    ],
    answer: "Améliorent la digestion",
    explanation:
        "Les probiotiques aident à maintenir l'équilibre de la flore intestinale, favorisant une bonne digestion.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet d'une alimentation riche en sucres ajoutés ?",
    options: [
      "Amélioration de la santé dentaire",
      "Risque accru de diabète",
      "Renforcement des os",
    ],
    answer: "Risque accru de diabète",
    explanation:
        "Une consommation excessive de sucres ajoutés est liée à un risque accru de développer un diabète de type 2.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel type d'exercice est particulièrement bénéfique pour le cœur ?",
    options: [
      "Exercices de force",
      "Exercices d'étirement",
      "Exercices aérobiques",
    ],
    answer: "Exercices aérobiques",
    explanation:
        "Les exercices aérobiques, comme la course et la natation, sont excellents pour la santé cardiovasculaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la première mesure à prendre en cas d'allergie alimentaire ?",
    options: [
      "Consulter un médecin",
      "Éviter l'allergène",
      "Prendre un antihistaminique",
    ],
    answer: "Éviter l'allergène",
    explanation:
        "La première mesure pour gérer une allergie alimentaire est d'éviter strictement l'allergène concerné.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel aspect de la santé est directement lié au niveau de stress ?",
    options: ["État de la peau", "Taux de glycémie", "Santé mentale"],
    answer: "Santé mentale",
    explanation:
        "Un niveau de stress élevé peut avoir un impact négatif sur la santé mentale, entraînant des troubles comme l'anxiété et la dépression.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la norme de consommation d'eau recommandée par jour pour un adulte ?",
    options: ["1 litre", "2 litres", "3 litres"],
    answer: "2 litres",
    explanation:
        "Il est généralement conseillé de boire environ 2 litres d'eau par jour pour rester bien hydraté.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bénéfice de la méditation ?",
    options: [
      "Renforce le système immunitaire",
      "Améliore la posture",
      "Réduit le stress",
    ],
    answer: "Réduit le stress",
    explanation:
        "La méditation est largement reconnue pour aider à réduire les niveaux de stress et d'anxiété.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est l'une des recommandations d'une alimentation équilibrée ?",
    options: [
      "Manger moins de fruits",
      "Augmenter la consommation de légumes",
      "Éviter les protéines",
    ],
    answer: "Augmenter la consommation de légumes",
    explanation:
        "Une alimentation équilibrée doit inclure une consommation élevée de légumes pour un apport nutritionnel optimal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact de la pollution de l'air sur la santé ?",
    options: [
      "Amélioration de la respiration",
      "Peut affecter la santé respiratoire",
      "Aucun impact",
    ],
    answer: "Peut affecter la santé respiratoire",
    explanation:
        "La pollution de l'air peut exacerber des problèmes respiratoires et nuire à la santé pulmonaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle pratique est recommandée pour augmenter la longévité ?",
    options: [
      "Manger beaucoup de sucreries",
      "Avoir des relations sociales positives",
      "Ne pas faire d'exercice",
    ],
    answer: "Avoir des relations sociales positives",
    explanation:
        "Des relations sociales saines et positives sont liées à une meilleure longévité et à une meilleure santé globale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bienfait d'une bonne nuit de sommeil ?",
    options: [
      "Augmentation du poids",
      "Renforcement du système immunitaire",
      "Élasticité de la peau",
    ],
    answer: "Renforcement du système immunitaire",
    explanation:
        "Un sommeil adéquat est essentiel pour maintenir un système immunitaire fort et efficace.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est favorable à une bonne santé cardiaque ?",
    options: ["Beurre", "Huile d'olive", "Chips"],
    answer: "Huile d'olive",
    explanation:
        "L'huile d'olive est riche en acides gras insaturés, bénéfiques pour la santé cardiaque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet d'une exposition excessive à des écrans ?",
    options: [
      "Amélioration de la vision",
      "Fatigue oculaire",
      "Ralentissement des réflexes",
    ],
    answer: "Fatigue oculaire",
    explanation:
        "Une exposition prolongée aux écrans peut provoquer une fatigue oculaire due à la lumière bleue.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Qu'est-ce qui contribue le plus à une bonne santé dentaire ?",
    options: [
      "Consommation de sucreries",
      "Brossage régulier des dents",
      "Absence de boissons",
    ],
    answer: "Brossage régulier des dents",
    explanation:
        "Un brossage régulier aide à prévenir les caries et à maintenir une bonne santé dentaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type d'aliment est recommandé pour augmenter l'énergie ?",
    options: [
      "Produits riches en sucres ajoutés",
      "Produits céréaliers complets",
      "Produits laitiers",
    ],
    answer: "Produits céréaliers complets",
    explanation:
        "Les produits céréaliers complets fournissent des glucides complexes qui libèrent de l'énergie progressivement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel effet a la pratique régulière de l'exercice sur le bien-être mental ?",
    options: [
      "Peut réduire le stress",
      "Augmente le risque de dépression",
      "N'a aucun effet",
    ],
    answer: "Peut réduire le stress",
    explanation:
        "L'exercice régulier favorise la libération d'endorphines, ce qui contribue à réduire le stress.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'avantage d'un petit-déjeuner équilibré ?",
    options: [
      "Augmente la fatigue",
      "Améliore la concentration",
      "Favorise l'alimentation déséquilibrée",
    ],
    answer: "Améliore la concentration",
    explanation:
        "Un petit-déjeuner équilibré aide à maintenir l'énergie et à améliorer la concentration tout au long de la journée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact des graisses trans sur la santé ?",
    options: [
      "Améliorent le cholestérol",
      "Augmentent le risque de maladies cardiaques",
      "N'ont aucun impact",
    ],
    answer: "Augmentent le risque de maladies cardiaques",
    explanation:
        "Les graisses trans sont associées à un risque accru de maladies cardiovasculaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de respiration est conseillé pour réduire le stress ?",
    options: [
      "Respiration rapide",
      "Respiration contrôlée",
      "Respiration superficielle",
    ],
    answer: "Respiration contrôlée",
    explanation:
        "La respiration contrôlée aide à activer le système nerveux parasympathique, réduisant le stress et l'anxiété.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est un des principaux bienfaits de l'exercice physique régulier ?",
    options: [
      "Ralentissement du métabolisme",
      "Amélioration de la force musculaire",
      "Diminution de l'énergie",
    ],
    answer: "Amélioration de la force musculaire",
    explanation:
        "L'exercice physique régulier renforce les muscles et améliore la force physique globale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale fonction de la vitamine K ?",
    options: [
      "Aider à la coagulation du sang",
      "Renforcer les os",
      "Améliorer la vision",
    ],
    answer: "Aider à la coagulation du sang",
    explanation:
        "La vitamine K joue un rôle crucial dans le processus de coagulation sanguine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet de la consommation de café sur la santé ?",
    options: [
      "Augmente le sommeil",
      "Stimule le système nerveux",
      "Affaiblit le système immunitaire",
    ],
    answer: "Stimule le système nerveux",
    explanation:
        "La caféine dans le café est un stimulant du système nerveux central, augmentant la vigilance.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'aliment recommandé pour une meilleure digestion ?",
    options: ["Fruits secs", "Viande rouge", "Yogourt"],
    answer: "Yogourt",
    explanation:
        "Le yogourt contient des probiotiques qui favorisent une bonne santé digestive.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal risque d'un mode de vie sédentaire ?",
    options: [
      "Amélioration de la circulation",
      "Augmentation du risque d'obésité",
      "Renforcement du cœur",
    ],
    answer: "Augmentation du risque d'obésité",
    explanation:
        "Un mode de vie sédentaire contribue à l'accumulation de poids et à l'obésité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des fibres dans l'alimentation ?",
    options: [
      "Augmenter le taux de cholestérol",
      "Faciliter le transit intestinal",
      "Ralentir la digestion",
    ],
    answer: "Faciliter le transit intestinal",
    explanation:
        "Les fibres alimentaires aident à réguler le transit intestinal et à prévenir la constipation.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel vitamine est principalement produite par l'exposition au soleil ?",
    options: ["Vitamine A", "Vitamine D", "Vitamine C"],
    answer: "Vitamine D",
    explanation:
        "La vitamine D est synthétisée par la peau sous l'effet des rayons UV du soleil.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'organe principal de la respiration ?",
    options: ["Cœur", "Poumon", "Foie"],
    answer: "Poumon",
    explanation:
        "Les poumons sont responsables de l'oxygénation du sang en échangeant l'oxygène et le dioxyde de carbone.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est une bonne source de calcium ?",
    options: ["Pain", "Lait", "Viande"],
    answer: "Lait",
    explanation:
        "Le lait est riche en calcium, essentiel pour la santé des os.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle maladie est causée par un virus ?",
    options: ["Diabète", "Grippe", "Hypertension"],
    answer: "Grippe",
    explanation:
        "La grippe est une infection virale aiguë qui touche le système respiratoire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal vecteur de transmission de la dengue ?",
    options: ["Culex", "Aedes", "Anopheles"],
    answer: "Aedes",
    explanation:
        "Le moustique Aedes, notamment Aedes aegypti, transmet le virus de la dengue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle méthode est utilisée pour prévenir les infections sexuellement transmissibles ?",
    options: ["Vaccin", "Antibiotiques", "Préservatif"],
    answer: "Préservatif",
    explanation:
        "Les préservatifs réduisent le risque de transmission des infections sexuellement transmissibles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal du tabac sur la santé ?",
    options: [
      "Amélioration de l'humeur",
      "Augmentation de l'énergie",
      "Maladies respiratoires",
    ],
    answer: "Maladies respiratoires",
    explanation:
        "Le tabac est une cause majeure de maladies respiratoires comme le cancer du poumon.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moyen de prévenir la grippe ?",
    options: ["Se laver les mains", "Prendre des antibiotiques", "Se vacciner"],
    answer: "Se vacciner",
    explanation:
        "Le vaccin est la méthode la plus efficace pour prévenir la grippe saisonnière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal nutriment à éviter pour contrôler le cholestérol ?",
    options: ["Sucres", "Fibres", "Graisses saturées"],
    answer: "Graisses saturées",
    explanation:
        "Les graisses saturées peuvent augmenter le taux de cholestérol sanguin.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la recommandation de consommation d'eau par jour pour un adulte ?",
    options: ["1 litre", "2 litres", "3 litres"],
    answer: "2 litres",
    explanation:
        "Une consommation quotidienne d'environ 2 litres d'eau est recommandée pour rester hydraté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel examen est utilisé pour détecter le cancer du sein ?",
    options: ["IRM", "Mammographie", "Échographie"],
    answer: "Mammographie",
    explanation:
        "La mammographie est un examen radiologique permettant de détecter les anomalies dans le tissu mammaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact d'une alimentation riche en fruits et légumes ?",
    options: [
      "Perte de poids rapide",
      "Amélioration de la digestion",
      "Augmentation du stress",
    ],
    answer: "Amélioration de la digestion",
    explanation:
        "Une alimentation riche en fibres, provenant des fruits et légumes, favorise une bonne digestion.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal du vaccin contre la COVID-19 ?",
    options: [
      "Traitement de la maladie",
      "Prévention de l'infection",
      "Soulagement des symptômes",
    ],
    answer: "Prévention de l'infection",
    explanation:
        "Le vaccin est conçu pour prévenir l'infection par le virus SARS-CoV-2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la conséquence d'une exposition prolongée au soleil sans protection ?",
    options: ["Bronzage", "Cancer de la peau", "Amélioration de la santé"],
    answer: "Cancer de la peau",
    explanation:
        "Une exposition excessive au soleil augmente le risque de développer un cancer de la peau.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal avantage des exercices physiques réguliers ?",
    options: [
      "Augmentation du stress",
      "Perte de mémoire",
      "Amélioration de la santé cardiovasculaire",
    ],
    answer: "Amélioration de la santé cardiovasculaire",
    explanation:
        "L'activité physique régulière renforce le cœur et améliore la circulation sanguine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal risque lié à la consommation excessive d'alcool ?",
    options: [
      "Problèmes de peau",
      "Maladies cardiovasculaires",
      "Amélioration de l'humeur",
    ],
    answer: "Maladies cardiovasculaires",
    explanation:
        "Une consommation excessive d'alcool peut entraîner des maladies cardiovasculaires et d'autres problèmes de santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal type de sucre à limiter dans l'alimentation ?",
    options: ["Sucre naturel", "Sucre ajouté", "Sucre complexe"],
    answer: "Sucre ajouté",
    explanation:
        "Les sucres ajoutés, présents dans de nombreux aliments transformés, doivent être limités pour une bonne santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du stress chronique sur la santé ?",
    options: [
      "Amélioration de la concentration",
      "Diminution de la fatigue",
      "Affaiblissement du système immunitaire",
    ],
    answer: "Affaiblissement du système immunitaire",
    explanation:
        "Le stress chronique peut nuire au système immunitaire, rendant l'organisme plus vulnérable aux infections.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact des antibiotiques sur des infections virales ?",
    options: ["Efficaces", "Inefficaces", "Aident à guérir"],
    answer: "Inefficaces",
    explanation:
        "Les antibiotiques ne sont pas efficaces contre les infections virales comme le rhume ou la grippe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal indice de la santé cardiovasculaire ?",
    options: ["Taux de cholestérol", "Taille des pieds", "Couleur des yeux"],
    answer: "Taux de cholestérol",
    explanation:
        "Le taux de cholestérol dans le sang est un indicateur clé de la santé cardiovasculaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal danger du tabagisme passif ?",
    options: [
      "Amélioration de la santé",
      "Maladies respiratoires",
      "Développement de la musculature",
    ],
    answer: "Maladies respiratoires",
    explanation:
        "Le tabagisme passif est associé à un risque accru de maladies respiratoires chez les non-fumeurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle de la vitamine C ?",
    options: [
      "Renforcement des os",
      "Amélioration de la vue",
      "Renforcement du système immunitaire",
    ],
    answer: "Renforcement du système immunitaire",
    explanation:
        "La vitamine C contribue à la protection des cellules et au bon fonctionnement du système immunitaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est une des principales recommandations pour une bonne hygiène dentaire ?",
    options: [
      "Utiliser des brosses à dents usées",
      "Se brosser les dents deux fois par jour",
      "Éviter de se rincer la bouche",
    ],
    answer: "Se brosser les dents deux fois par jour",
    explanation:
        "Un brossage régulier aide à prévenir les caries et les maladies parodontales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal facteur de risque de l'hypertension artérielle ?",
    options: [
      "Consommation de fruits",
      "Sédentarité",
      "Pratique régulière du sport",
    ],
    answer: "Sédentarité",
    explanation:
        "Un mode de vie sédentaire augmente le risque de développer une hypertension artérielle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet principal de la pollution de l'air sur la santé ?",
    options: [
      "Amélioration de la santé pulmonaire",
      "Problèmes respiratoires",
      "Augmentation de l'énergie",
    ],
    answer: "Problèmes respiratoires",
    explanation:
        "La pollution de l'air est associée à divers problèmes respiratoires et cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle boisson est recommandée pour rester hydraté ?",
    options: ["Soda", "Eau", "Café"],
    answer: "Eau",
    explanation:
        "L'eau est la meilleure boisson pour maintenir une bonne hydratation sans calories ajoutées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du manque de sommeil sur la santé ?",
    options: [
      "Amélioration de la mémoire",
      "Augmentation de la concentration",
      "Affaiblissement du système immunitaire",
    ],
    answer: "Affaiblissement du système immunitaire",
    explanation:
        "Un sommeil insuffisant peut nuire à la fonction immunitaire, rendant l'organisme plus vulnérable aux infections.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est une mesure de prévention contre le cancer du col de l'utérus ?",
    options: ["Vaccin HPV", "Exposition au soleil", "Consommation de fruits"],
    answer: "Vaccin HPV",
    explanation:
        "Le vaccin contre le virus du papillome humain (HPV) aide à prévenir le cancer du col de l'utérus.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet de la consommation de sucre sur la santé dentaire ?",
    options: ["Renforce les dents", "Causes des caries", "Améliore l'haleine"],
    answer: "Causes des caries",
    explanation:
        "Une consommation élevée de sucre favorise la formation de caries dentaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le risque principal d'un régime alimentaire déséquilibré ?",
    options: [
      "Amélioration de la digestion",
      "Développement de maladies chroniques",
      "Augmentation de l'énergie",
    ],
    answer: "Développement de maladies chroniques",
    explanation:
        "Une alimentation déséquilibrée peut entraîner des maladies chroniques telles que le diabète et les maladies cardiaques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le signe le plus courant d'une allergie alimentaire ?",
    options: [
      "Éruptions cutanées",
      "Augmentation de l'énergie",
      "Amélioration de l'humeur",
    ],
    answer: "Éruptions cutanées",
    explanation:
        "Les éruptions cutanées sont un symptôme fréquent des réactions allergiques alimentaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle maladie est causée par une carence en iode ?",
    options: ["Cécité", "Goitre", "Anémie"],
    answer: "Goitre",
    explanation:
        "La carence en iode peut provoquer un gonflement de la glande thyroïdienne, connu sous le nom de goitre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal effet d'une activité physique régulière sur le poids ?",
    options: ["Prise de poids", "Stabilisation du poids", "Perte de poids"],
    answer: "Perte de poids",
    explanation:
        "Une activité physique régulière peut aider à maintenir ou à réduire le poids corporel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal de la déshydratation sur le corps ?",
    options: [
      "Amélioration de la concentration",
      "Fatigue",
      "Augmentation de l'énergie",
    ],
    answer: "Fatigue",
    explanation:
        "La déshydratation peut entraîner une fatigue générale et une baisse de performance physique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact de la consommation excessive de sel sur la santé ?",
    options: [
      "Hypertension",
      "Amélioration de la circulation sanguine",
      "Renforcement des os",
    ],
    answer: "Hypertension",
    explanation:
        "Une consommation excessive de sel est un facteur de risque pour l'hypertension artérielle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel documentaire a sensibilisé à l'obésité chez les enfants ?",
    options: ["Supersize Me", "Food Inc.", "Forks Over Knives"],
    answer: "Supersize Me",
    explanation:
        "Le documentaire 'Supersize Me' met en lumière les impacts de la malbouffe sur la santé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle mesure est essentielle pour réduire le risque de maladies cardiovasculaires ?",
    options: [
      "Consommer plus de sucre",
      "Réduire le tabagisme",
      "Éviter l'exercice",
    ],
    answer: "Réduire le tabagisme",
    explanation:
        "Réduire le tabagisme diminue considérablement le risque de maladies cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la meilleure boisson pour hydrater après un exercice physique ?",
    options: ["Soda", "Eau", "Café"],
    answer: "Eau",
    explanation:
        "L'eau est la meilleure option pour réhydrater le corps après un effort physique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel minéral est essentiel pour la formation de l'hémoglobine ?",
    options: ["Calcium", "Fer", "Zinc"],
    answer: "Fer",
    explanation:
        "Le fer est un composant clé de l'hémoglobine, permettant le transport de l'oxygène dans le sang.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet de la caféine sur le corps à forte dose ?",
    options: ["Relaxation", "Insomnie", "Amélioration de la digestion"],
    answer: "Insomnie",
    explanation:
        "Une consommation excessive de caféine peut provoquer des troubles du sommeil, comme l'insomnie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la conséquence de l'alcool sur le foie ?",
    options: [
      "Rénovation cellulaire",
      "Accumulation de graisses",
      "Amélioration de la santé",
    ],
    answer: "Accumulation de graisses",
    explanation:
        "La consommation excessive d'alcool entraîne une accumulation de graisses dans le foie, ce qui peut causer des maladies hépatiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal avantage de consommer des oméga-3 ?",
    options: [
      "Augmentation de la douleur",
      "Amélioration de la santé cardiovasculaire",
      "Diminution de la mémoire",
    ],
    answer: "Amélioration de la santé cardiovasculaire",
    explanation:
        "Les oméga-3 contribuent à la santé du cœur et des vaisseaux sanguins.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un des signes d'une maladie cardiovasculaire ?",
    options: [
      "Fatigue excessive",
      "Amélioration de l'énergie",
      "Diminution de l'appétit",
    ],
    answer: "Fatigue excessive",
    explanation:
        "La fatigue excessive peut être un symptôme précoce des maladies cardiovasculaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet principal de la consommation de fruits et légumes sur la santé ?",
    options: [
      "Réduction du risque de maladies",
      "Augmentation de l'indice glycémique",
      "Diminution de l'hydratation",
    ],
    answer: "Réduction du risque de maladies",
    explanation:
        "Une consommation suffisante de fruits et légumes est associée à un risque réduit de maladies chroniques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est un des principaux effets de la consommation d'aliments transformés ?",
    options: [
      "Amélioration de la concentration",
      "Diminution de la santé cardiovasculaire",
      "Augmentation de la croissance musculaire",
    ],
    answer: "Diminution de la santé cardiovasculaire",
    explanation:
        "Les aliments transformés sont souvent riches en gras saturés et sucres, nuisant à la santé cardiovasculaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le bénéfice principal de marcher régulièrement ?",
    options: [
      "Amélioration de la circulation sanguine",
      "Diminution de la flexibilité",
      "Augmentation du stress",
    ],
    answer: "Amélioration de la circulation sanguine",
    explanation:
        "Marcher régulièrement favorise une meilleure circulation sanguine et une meilleure santé générale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des antioxydants ?",
    options: [
      "Renforcer le système immunitaire",
      "Lutter contre le vieillissement cellulaire",
      "Augmenter l'appétit",
    ],
    answer: "Lutter contre le vieillissement cellulaire",
    explanation:
        "Les antioxydants protègent les cellules contre le stress oxydatif et peuvent ralentir le vieillissement cellulaire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'organe principal de la respiration chez l'homme ?",
    options: ["Le cœur", "Les poumons", "Le foie"],
    answer: "Les poumons",
    explanation:
        "Les poumons sont les organes responsables de l'échange des gaz, permettant ainsi la respiration.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal vecteur de transmission du VIH ?",
    options: ["Les moustiques", "Le sang", "L'eau"],
    answer: "Le sang",
    explanation:
        "Le VIH se transmet principalement par le sang, notamment lors de rapports sexuels non protégés ou le partage de matériel d'injection.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle vitamine est essentielle pour la vision ?",
    options: ["La vitamine C", "La vitamine A", "La vitamine D"],
    answer: "La vitamine A",
    explanation:
        "La vitamine A est cruciale pour la santé des yeux et la vision nocturne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est le plus riche en fibres ?",
    options: ["Les lentilles", "Le pain blanc", "Le chocolat"],
    answer: "Les lentilles",
    explanation:
        "Les lentilles sont une excellente source de fibres, favorisant la digestion.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal symptôme d'une déshydratation ?",
    options: [
      "Une forte fièvre",
      "Une soif excessive",
      "Des douleurs abdominales",
    ],
    answer: "Une soif excessive",
    explanation:
        "La soif excessive est un indicateur principal de déshydratation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle maladie est causée par le virus de l'influenza ?",
    options: ["La grippe", "Le rhume", "La varicelle"],
    answer: "La grippe",
    explanation:
        "Le virus de l'influenza est responsable de la grippe, une maladie respiratoire contagieuse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal du tabagisme sur la santé ?",
    options: [
      "L'augmentation de l'énergie",
      "L'amélioration de la circulation",
      "L'accroissement du risque de cancer",
    ],
    answer: "L'accroissement du risque de cancer",
    explanation:
        "Le tabagisme est un facteur de risque majeur pour plusieurs types de cancer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moyen de prévenir la grippe ?",
    options: ["Manger des agrumes", "Se faire vacciner", "Éviter les fruits"],
    answer: "Se faire vacciner",
    explanation:
        "La vaccination est la méthode la plus efficace pour prévenir la grippe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Qu'est-ce qui est recommandé pour une bonne hygiène dentaire ?",
    options: [
      "Se brosser les dents quotidiennement",
      "Manger des bonbons",
      "Boire des sodas",
    ],
    answer: "Se brosser les dents quotidiennement",
    explanation:
        "Un brossage quotidien des dents aide à prévenir les caries et les maladies gingivales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal constituant de l'os ?",
    options: ["Calcium", "Fer", "Potassium"],
    answer: "Calcium",
    explanation:
        "Le calcium est l'élément principal des os, assurant leur solidité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal des vaccinations ?",
    options: [
      "Guérir les maladies",
      "Prévenir les maladies",
      "Augmenter la fatigue",
    ],
    answer: "Prévenir les maladies",
    explanation:
        "Les vaccinations aident à prévenir l'apparition de maladies infectieuses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal objectif d'une campagne anti-tabac ?",
    options: [
      "Promouvoir le tabac",
      "Réduire la consommation de tabac",
      "Augmenter les ventes de cigarette",
    ],
    answer: "Réduire la consommation de tabac",
    explanation:
        "Les campagnes anti-tabac visent à diminuer la consommation de tabac et ses effets nocifs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel type d'activité physique est recommandé pour la santé cardiaque ?",
    options: [
      "Le yoga",
      "Les exercices de résistance",
      "Les exercices aérobiques",
    ],
    answer: "Les exercices aérobiques",
    explanation:
        "Les exercices aérobiques améliorent la santé cardiaque en stimulant le cœur et les poumons.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du stress chronique sur la santé ?",
    options: [
      "Amélioration du sommeil",
      "Affaiblissement du système immunitaire",
      "Augmentation de l'énergie",
    ],
    answer: "Affaiblissement du système immunitaire",
    explanation:
        "Le stress chronique peut affaiblir le système immunitaire, rendant les individus plus vulnérables aux maladies.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal symptôme d'une allergie ?",
    options: ["Nausées", "Éternuements", "Fatigue"],
    answer: "Éternuements",
    explanation:
        "Les éternuements sont un symptôme fréquent des allergies, notamment aux pollens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est source de protéines végétales ?",
    options: ["Le poisson", "Le riz", "Les pois chiches"],
    answer: "Les pois chiches",
    explanation:
        "Les pois chiches sont une excellente source de protéines d'origine végétale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal risque du surpoids ?",
    options: [
      "Une meilleure santé",
      "Un risque accru de maladies cardiovasculaires",
      "Une augmentation de la force",
    ],
    answer: "Un risque accru de maladies cardiovasculaires",
    explanation:
        "Le surpoids augmente le risque de maladies cardiovasculaires en raison de la surcharge du cœur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du soleil sur la peau sans protection ?",
    options: [
      "Coup de soleil",
      "Hydratation",
      "Amélioration de la couleur de la peau",
    ],
    answer: "Coup de soleil",
    explanation:
        "Une exposition au soleil sans protection peut entraîner des coups de soleil et des dommages cutanés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle boisson est souvent associée à une hydratation efficace ?",
    options: ["Le thé", "Le jus de fruits", "L'eau"],
    answer: "L'eau",
    explanation:
        "L'eau est la meilleure boisson pour maintenir une bonne hydratation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un des effets de la consommation excessive d'alcool ?",
    options: [
      "Amélioration de la mémoire",
      "Augmentation des risques de maladies hépatiques",
      "Meilleure concentration",
    ],
    answer: "Augmentation des risques de maladies hépatiques",
    explanation:
        "Une consommation excessive d'alcool peut endommager le foie et entraîner des maladies hépatiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal effet d'une alimentation déséquilibrée ?",
    options: ["Bonne humeur", "Mauvaise santé", "Énergie accrue"],
    answer: "Mauvaise santé",
    explanation:
        "Une alimentation déséquilibrée peut conduire à divers problèmes de santé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bénéfice de l'exercice régulier ?",
    options: ["Fatigue accrue", "Énergie et vitalité", "Isolation sociale"],
    answer: "Énergie et vitalité",
    explanation:
        "L'exercice régulier augmente les niveaux d'énergie et améliore la vitalité générale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal but de l'éducation à la santé ?",
    options: [
      "Informer sur l'alimentation",
      "Promouvoir les comportements sains",
      "Augmenter le stress",
    ],
    answer: "Promouvoir les comportements sains",
    explanation:
        "L'éducation à la santé vise à encourager des comportements bénéfiques pour la santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des antioxydants dans l'alimentation ?",
    options: [
      "Protéger les cellules",
      "Augmenter le cholesterol",
      "Réduire la fatigue",
    ],
    answer: "Protéger les cellules",
    explanation:
        "Les antioxydants aident à protéger les cellules des dommages causés par les radicaux libres.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel produit est utilisé pour désinfecter les mains ?",
    options: ["Le vinaigre", "L'eau", "Le gel hydroalcoolique"],
    answer: "Le gel hydroalcoolique",
    explanation:
        "Le gel hydroalcoolique est couramment utilisé pour désinfecter les mains lorsque l'eau et le savon ne sont pas disponibles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la fonction principale de la vitamine D ?",
    options: [
      "Renforcer le système immunitaire",
      "Aider à la digestion",
      "Faciliter l'absorption du calcium",
    ],
    answer: "Faciliter l'absorption du calcium",
    explanation:
        "La vitamine D joue un rôle clé dans l'absorption du calcium, essentiel pour la santé osseuse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale cause des maladies cardiovasculaires ?",
    options: [
      "Manque d'exercice",
      "Consommation de légumes",
      "Hydratation adéquate",
    ],
    answer: "Manque d'exercice",
    explanation:
        "Un mode de vie sédentaire est un facteur de risque majeur pour les maladies cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est l'un des symptômes du diabète ?",
    options: [
      "Perte de poids inexpliquée",
      "Meilleure vision",
      "Augmentation de l'énergie",
    ],
    answer: "Perte de poids inexpliquée",
    explanation:
        "Une perte de poids inexpliquée peut être un signe précoce de diabète.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la meilleure source de vitamine C ?",
    options: ["Les oranges", "Le pain", "Le chocolat"],
    answer: "Les oranges",
    explanation:
        "Les oranges sont une excellente source de vitamine C, essentielle pour le système immunitaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet principal d'une exposition prolongée à la pollution de l'air ?",
    options: [
      "Amélioration de la santé respiratoire",
      "Diminution des allergies",
      "Problèmes respiratoires",
    ],
    answer: "Problèmes respiratoires",
    explanation:
        "L'exposition prolongée à la pollution de l'air peut causer des problèmes respiratoires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal des fibres dans l'alimentation ?",
    options: [
      "Aider à la digestion",
      "Augmenter la fatigue",
      "Apporter des calories",
    ],
    answer: "Aider à la digestion",
    explanation:
        "Les fibres aident à réguler le transit intestinal et à favoriser la digestion.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un des bénéfices d'un sommeil de qualité ?",
    options: [
      "Augmentation du stress",
      "Mauvaise concentration",
      "Amélioration de la mémoire",
    ],
    answer: "Amélioration de la mémoire",
    explanation:
        "Un sommeil de qualité est essentiel pour la récupération cognitive et l'amélioration de la mémoire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moyen de réduire le stress au quotidien ?",
    options: [
      "Ignorer les problèmes",
      "Pratiquer la méditation",
      "Consommer plus de café",
    ],
    answer: "Pratiquer la méditation",
    explanation:
        "La méditation est une technique efficace pour réduire le stress et favoriser le bien-être.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet de la consommation régulière de fruits et légumes ?",
    options: [
      "Amélioration de la santé",
      "Aucune différence",
      "Augmentation de la fatigue",
    ],
    answer: "Amélioration de la santé",
    explanation:
        "Une consommation régulière de fruits et légumes est associée à une meilleure santé globale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du tabac sur la santé respiratoire ?",
    options: [
      "Amélioration de la fonction pulmonaire",
      "Aucune influence",
      "Diminution de la capacité respiratoire",
    ],
    answer: "Diminution de la capacité respiratoire",
    explanation:
        "Le tabagisme nuit gravement à la santé respiratoire en réduisant la capacité pulmonaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bénéfice de rester actif physiquement ?",
    options: [
      "Risques accrus de maladies",
      "Amélioration du bien-être général",
      "Fatigue chronique",
    ],
    answer: "Amélioration du bien-être général",
    explanation:
        "Rester actif contribue à une meilleure santé physique et mentale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale cause de l'obésité ?",
    options: ["Sédentarité", "Consommation de légumes", "Exercice régulier"],
    answer: "Sédentarité",
    explanation:
        "La sédentarité, combinée à une alimentation déséquilibrée, contribue majoritairement à l'obésité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet d'une bonne alimentation sur l'humeur ?",
    options: ["Amélioration de l'humeur", "Fatigue accrue", "Aucune influence"],
    answer: "Amélioration de l'humeur",
    explanation:
        "Une bonne alimentation peut avoir un effet positif sur l'humeur et le bien-être émotionnel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de graisse est le plus nocif pour la santé ?",
    options: [
      "Acides gras mono-insaturés",
      "Acides gras trans",
      "Acides gras polyinsaturés",
    ],
    answer: "Acides gras trans",
    explanation:
        "Les acides gras trans sont associés à un risque accru de maladies cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des oméga-3 dans l'alimentation ?",
    options: [
      "Réduire le cholestérol",
      "Améliorer la digestion",
      "Protéger le cœur",
    ],
    answer: "Protéger le cœur",
    explanation:
        "Les oméga-3 protègent la santé cardiaque en réduisant l'inflammation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la meilleure façon d'éviter la transmission des maladies infectieuses ?",
    options: [
      "Ignorer les symptômes",
      "Pratiques d'hygiène",
      "Éviter le contact social",
    ],
    answer: "Pratiques d'hygiène",
    explanation:
        "Les bonnes pratiques d'hygiène, comme le lavage des mains, sont essentielles pour prévenir la transmission des infections.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact d'une bonne hydratation sur la santé ?",
    options: [
      "Amélioration des performances physiques",
      "Augmentation de la fatigue",
      "Aucune différence",
    ],
    answer: "Amélioration des performances physiques",
    explanation:
        "Une bonne hydratation est essentielle pour maintenir des performances physiques optimales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet d'une exposition prolongée au soleil sans protection ?",
    options: [
      "Risque de cancer de la peau",
      "Amélioration de l'humeur",
      "Absorption de vitamine D",
    ],
    answer: "Risque de cancer de la peau",
    explanation:
        "Une exposition prolongée au soleil sans protection augmente le risque de cancer cutané.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale fonction des probiotiques ?",
    options: [
      "Renforcer le système immunitaire",
      "Améliorer la santé digestive",
      "Produire des vitamines",
    ],
    answer: "Améliorer la santé digestive",
    explanation:
        "Les probiotiques contribuent à maintenir une flore intestinale saine, favorisant ainsi la digestion.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de stress est considéré comme bénéfique ?",
    options: ["Stress chronique", "Stress aigu", "Stress permanent"],
    answer: "Stress aigu",
    explanation:
        "Le stress aigu peut être bénéfique en mobilisant des ressources pour faire face à des défis.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal effet d'une consommation excessive de sucre ?",
    options: [
      "Augmentation de l'énergie",
      "Risque de diabète",
      "Meilleure concentration",
    ],
    answer: "Risque de diabète",
    explanation:
        "Une consommation excessive de sucre peut augmenter le risque de diabète de type 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'avantage du petit-déjeuner ?",
    options: [
      "Augmentation de la fatigue",
      "Amélioration de la concentration",
      "Diminution de l'énergie",
    ],
    answer: "Amélioration de la concentration",
    explanation:
        "Le petit-déjeuner fournit l'énergie nécessaire pour améliorer la concentration tout au long de la journée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du tabagisme passif sur la santé des enfants ?",
    options: [
      "Aucune influence",
      "Amélioration de la santé",
      "Risques accrus de maladies respiratoires",
    ],
    answer: "Risques accrus de maladies respiratoires",
    explanation:
        "Le tabagisme passif expose les enfants à un risque accru de problèmes respiratoires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le but d'une alimentation équilibrée ?",
    options: [
      "Augmenter la fatigue",
      "Améliorer la santé",
      "Diminuer la concentration",
    ],
    answer: "Améliorer la santé",
    explanation:
        "Une alimentation équilibrée vise à promouvoir la santé et le bien-être général.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'organe principal de la respiration chez l'humain ?",
    options: ["Le cœur", "Le poumon", "Le foie"],
    answer: "Le poumon",
    explanation:
        "Les poumons sont les organes responsables de l'échange gazeux entre l'air et le sang.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est riche en vitamine C ?",
    options: ["Les carottes", "Les oranges", "Les pommes de terre"],
    answer: "Les oranges",
    explanation:
        "Les oranges sont connues pour leur haute teneur en vitamine C, essentielle pour le système immunitaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la meilleure activité physique pour la santé cardiovasculaire ?",
    options: ["La natation", "Le jardinage", "La lecture"],
    answer: "La natation",
    explanation:
        "La natation est un excellent exercice aérobique qui améliore la santé du cœur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal agent pathogène responsable de la grippe ?",
    options: ["Un virus", "Une bactérie", "Un champignon"],
    answer: "Un virus",
    explanation:
        "La grippe est causée par des virus influenza qui infectent les voies respiratoires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du tabac sur la santé ?",
    options: [
      "Il renforce le système immunitaire",
      "Il améliore la circulation sanguine",
      "Il augmente les risques de cancers",
    ],
    answer: "Il augmente les risques de cancers",
    explanation:
        "Le tabac est un facteur de risque majeur pour plusieurs types de cancers, notamment ceux du poumon.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "À quelle fréquence devrait-on se laver les mains pour prévenir les infections ?",
    options: [
      "Une fois par jour",
      "Avant et après chaque repas",
      "Une fois par semaine",
    ],
    answer: "Avant et après chaque repas",
    explanation:
        "Se laver les mains avant et après les repas réduit le risque de transmission des germes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet de l'alcool sur le corps humain ?",
    options: [
      "Il hydrate le corps",
      "Il est un stimulant naturel",
      "Il déshydrate le corps",
    ],
    answer: "Il déshydrate le corps",
    explanation:
        "L'alcool a un effet diurétique qui peut entraîner une déshydratation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle maladie est causée par une carence en insuline ?",
    options: ["Le diabète", "L'hypertension", "L'arthrite"],
    answer: "Le diabète",
    explanation:
        "Le diabète est une maladie métabolique qui se produit lorsque l'insuline est insuffisante.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des vaccins ?",
    options: [
      "Protéger contre les maladies infectieuses",
      "Avoir des effets secondaires",
      "Affaiblir le système immunitaire",
    ],
    answer: "Protéger contre les maladies infectieuses",
    explanation:
        "Les vaccins stimulent le système immunitaire pour prévenir des infections spécifiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel nutriment est essentiel pour la santé des os ?",
    options: ["Le fer", "Le calcium", "La vitamine A"],
    answer: "Le calcium",
    explanation:
        "Le calcium est crucial pour le développement et le maintien d'une ossature solide.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Que signifie l'acronyme VIH ?",
    options: [
      "Virus d'Immunodéficience Humaine",
      "Vaccine pour l'Immunité Humaine",
      "Virus Infectieux des Hommes",
    ],
    answer: "Virus d'Immunodéficience Humaine",
    explanation:
        "Le VIH est responsable de l'affaiblissement du système immunitaire chez les personnes infectées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal symptôme d'une déshydratation ?",
    options: ["La fatigue", "L'hyperactivité", "La fièvre"],
    answer: "La fatigue",
    explanation:
        "La fatigue est un symptôme courant de déshydratation, indiquant un manque d'eau dans le corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du stress chronique sur la santé ?",
    options: [
      "Il améliore la concentration",
      "Il peut causer des problèmes de santé",
      "Il n'a aucun effet",
    ],
    answer: "Il peut causer des problèmes de santé",
    explanation:
        "Le stress chronique est associé à divers problèmes de santé physique et mentale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le meilleur moyen de prévenir les maladies cardiaques ?",
    options: [
      "Manger équilibré",
      "Regarder la télévision",
      "Utiliser des écrans",
    ],
    answer: "Manger équilibré",
    explanation:
        "Une alimentation équilibrée joue un rôle clé dans la prévention des maladies cardiovasculaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal avantage de l'exercice régulier ?",
    options: [
      "Augmentation du risque de maladie",
      "Amélioration de la santé mentale",
      "Diminution de la force musculaire",
    ],
    answer: "Amélioration de la santé mentale",
    explanation:
        "L'exercice régulier est prouvé pour améliorer l'humeur et réduire le stress.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la recommandation quotidienne d'eau pour un adulte moyen ?",
    options: ["1 litre", "2 litres", "3 litres"],
    answer: "2 litres",
    explanation:
        "Il est recommandé de boire environ 2 litres d'eau par jour pour rester bien hydraté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal des fibres dans l'alimentation ?",
    options: [
      "Renforcer les muscles",
      "Améliorer la digestion",
      "Augmenter le cholesterol",
    ],
    answer: "Améliorer la digestion",
    explanation:
        "Les fibres favorisent un bon transit intestinal et aident à la digestion.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le nom de la condition caractérisée par une pression artérielle persistante élevée ?",
    options: ["L'hypertension", "L'hypotension", "L'arthrite"],
    answer: "L'hypertension",
    explanation:
        "L'hypertension est une condition où la pression sanguine est constamment élevée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'un des principaux risques associés à l'obésité ?",
    options: [
      "Diminution de l'énergie",
      "Augmentation des risques de maladies chroniques",
      "Amélioration de l'endurance",
    ],
    answer: "Augmentation des risques de maladies chroniques",
    explanation:
        "L'obésité est associée à un risque accru de diabète et de maladies cardiaques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de gras est considéré comme le plus sain ?",
    options: ["Les gras saturés", "Les gras trans", "Les gras insaturés"],
    answer: "Les gras insaturés",
    explanation:
        "Les gras insaturés, présents dans les huiles végétales, sont bénéfiques pour la santé cardiaque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal objectif d'une alimentation équilibrée ?",
    options: [
      "Perdre du poids",
      "Fournir des nutriments essentiels",
      "Gagner du muscle rapidement",
    ],
    answer: "Fournir des nutriments essentiels",
    explanation:
        "Une alimentation équilibrée vise à fournir les nutriments nécessaires au bon fonctionnement du corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Qu'est-ce que le cholestérol ?",
    options: ["Une vitamine", "Une hormone", "Un lipide"],
    answer: "Un lipide",
    explanation:
        "Le cholestérol est un type de lipide essentiel à la formation des membranes cellulaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moyen de protéger sa peau des rayons UV ?",
    options: [
      "Utiliser une crème solaire",
      "Faire bronzer",
      "Porter des vêtements légers",
    ],
    answer: "Utiliser une crème solaire",
    explanation:
        "La crème solaire protège la peau en bloquant les rayons UV nocifs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet de l'alimentation riche en sucre sur la santé dentaire ?",
    options: [
      "Elle renforce les dents",
      "Elle cause des caries",
      "Elle n'a aucun effet",
    ],
    answer: "Elle cause des caries",
    explanation:
        "Une consommation excessive de sucre est l'une des principales causes de caries dentaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet de l'exposition prolongée au soleil sans protection ?",
    options: [
      "Cela renforce la peau",
      "Cela pourrait entraîner un coup de soleil",
      "Cela n'a aucun effet",
    ],
    answer: "Cela pourrait entraîner un coup de soleil",
    explanation:
        "Une exposition prolongée au soleil sans protection peut provoquer des brûlures cutanées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'un des principaux symptômes d'une allergie alimentaire ?",
    options: ["La constipation", "L'éruption cutanée", "La fatigue"],
    answer: "L'éruption cutanée",
    explanation:
        "Les allergies alimentaires peuvent provoquer des éruptions cutanées en raison de la réaction immunitaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la durée minimale recommandée d'activité physique par semaine pour un adulte ?",
    options: ["30 minutes", "150 minutes", "60 minutes"],
    answer: "150 minutes",
    explanation:
        "Il est recommandé de faire au moins 150 minutes d'activité physique modérée chaque semaine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du manque de sommeil sur la santé ?",
    options: [
      "Il améliore la concentration",
      "Il affecte le bien-être mental",
      "Il n'a aucun effet",
    ],
    answer: "Il affecte le bien-être mental",
    explanation:
        "Un manque de sommeil peut entraîner des problèmes d'humeur et de santé mentale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle du fer dans le corps humain ?",
    options: [
      "Transporter l'oxygène",
      "Aider à la digestion",
      "Renforcer les muscles",
    ],
    answer: "Transporter l'oxygène",
    explanation:
        "Le fer est essentiel pour la formation des globules rouges qui transportent l'oxygène.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quels sont les effets de la malnutrition sur le corps ?",
    options: [
      "Amélioration de la santé",
      "Affaiblissement du système immunitaire",
      "Augmentation d'énergie",
    ],
    answer: "Affaiblissement du système immunitaire",
    explanation:
        "La malnutrition peut affaiblir le système immunitaire et augmenter la vulnérabilité aux infections.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de boisson est idéal pour une bonne hydratation ?",
    options: ["Le café", "L'eau", "Les sodas"],
    answer: "L'eau",
    explanation:
        "L'eau est la meilleure boisson pour maintenir une bonne hydratation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact d'une alimentation riche en fruits et légumes ?",
    options: [
      "Augmentation des risques de maladies",
      "Amélioration de la santé globale",
      "Diminution de l'énergie",
    ],
    answer: "Amélioration de la santé globale",
    explanation:
        "Une alimentation riche en fruits et légumes est associée à une meilleure santé et à une longévité accrue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des antioxydants dans le corps ?",
    options: [
      "Protéger les cellules",
      "Augmenter l'appétit",
      "Affaiblir le système immunitaire",
    ],
    answer: "Protéger les cellules",
    explanation:
        "Les antioxydants aident à neutraliser les radicaux libres et à protéger les cellules des dommages.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale fonction du système immunitaire ?",
    options: [
      "Stimuler la prise de poids",
      "Protéger l'organisme contre les maladies",
      "Augmenter la fatigue",
    ],
    answer: "Protéger l'organisme contre les maladies",
    explanation:
        "Le système immunitaire défend le corps contre les infections et les maladies.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un symptôme commun de l'anémie ?",
    options: ["L'irritabilité", "La pâleur", "La fatigue"],
    answer: "La fatigue",
    explanation:
        "La fatigue est un symptôme fréquent de l'anémie due à une carence en fer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Combien de groupes alimentaires sont recommandés dans le modèle 'Pyramid alimentaire' ?",
    options: ["Cinq", "Quatre", "Six"],
    answer: "Cinq",
    explanation:
        "Le modèle de la pyramide alimentaire recommande cinq groupes alimentaires pour une alimentation équilibrée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du tabagisme sur les poumons ?",
    options: [
      "Renforcement des poumons",
      "Diminution de leur capacité",
      "Aucune conséquence",
    ],
    answer: "Diminution de leur capacité",
    explanation:
        "Le tabagisme entraîne une diminution importante de la capacité pulmonaire et de la fonction respiratoire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal risque associé à une exposition excessive au soleil ?",
    options: [
      "Le bronzage",
      "Le cancer de la peau",
      "L'amélioration de la vision",
    ],
    answer: "Le cancer de la peau",
    explanation:
        "Une exposition excessive au soleil augmente le risque de développer un cancer de la peau.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Qu'est-ce qui peut aider à réduire le cholestérol sanguin ?",
    options: ["L'exercice régulier", "Le repos", "Le sucre"],
    answer: "L'exercice régulier",
    explanation:
        "L'exercice régulier aide à maintenir un taux de cholestérol sain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal effet des acides gras oméga-3 ?",
    options: [
      "Réduction de l'inflammation",
      "Augmentation de l'appétit",
      "Perte de poids rapide",
    ],
    answer: "Réduction de l'inflammation",
    explanation:
        "Les acides gras oméga-3 sont connus pour leurs propriétés anti-inflammatoires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal du potassium dans le corps ?",
    options: [
      "Réguler la pression sanguine",
      "Augmenter le cholestérol",
      "Protéger les articulations",
    ],
    answer: "Réguler la pression sanguine",
    explanation:
        "Le potassium aide à réguler la pression sanguine et à maintenir la fonction cardiaque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet d'une consommation excessive de sel sur la santé ?",
    options: [
      "Diminution de la chaleur corporelle",
      "Augmentation de la pression artérielle",
      "Amélioration de la digestion",
    ],
    answer: "Augmentation de la pression artérielle",
    explanation:
        "Une consommation excessive de sel peut entraîner une hypertension artérielle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle vitamine est essentielle à la coagulation sanguine ?",
    options: ["La vitamine A", "La vitamine C", "La vitamine K"],
    answer: "La vitamine K",
    explanation:
        "La vitamine K joue un rôle crucial dans le processus de coagulation sanguine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le lien entre le sommeil et la santé mentale ?",
    options: [
      "Le sommeil n'a aucun impact",
      "Le sommeil améliore l'humeur",
      "Le sommeil aggrave la dépression",
    ],
    answer: "Le sommeil améliore l'humeur",
    explanation:
        "Un sommeil de qualité est essentiel pour maintenir un bon équilibre mental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal effet du sédentarisme sur la santé ?",
    options: [
      "Amélioration de la forme physique",
      "Augmentation du stress",
      "Diminution de la condition physique",
    ],
    answer: "Diminution de la condition physique",
    explanation:
        "Le sédentarisme peut entraîner une diminution significative de la condition physique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quels sont les avantages d'une bonne hydratation ?",
    options: [
      "Amélioration de la concentration",
      "Diminution du bien-être",
      "Augmentation du stress",
    ],
    answer: "Amélioration de la concentration",
    explanation:
        "Une bonne hydratation est essentielle pour maintenir une concentration optimale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'aliment recommandé pour la santé du cœur ?",
    options: ["Les fruits oléagineux", "Les sucreries", "Les plats préparés"],
    answer: "Les fruits oléagineux",
    explanation:
        "Les fruits oléagineux, riches en acides gras insaturés, sont bénéfiques pour la santé cardiaque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est l'importance des échauffements avant l'exercice ?",
    options: [
      "Élever le rythme cardiaque",
      "Éviter les blessures",
      "Diminuer la souplesse",
    ],
    answer: "Éviter les blessures",
    explanation:
        "Les échauffements aident à préparer les muscles et à réduire le risque de blessures.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet de l'isolement social sur la santé ?",
    options: [
      "Amélioration de la santé mentale",
      "Diminution du stress",
      "Augmentation des risques de dépression",
    ],
    answer: "Augmentation des risques de dépression",
    explanation:
        "L'isolement social est lié à un risque accru de dépression et d'anxiété.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal conseil pour prévenir la grippe ?",
    options: [
      "Se laver les mains régulièrement",
      "Éviter de sortir par temps froid",
      "Manger des agrumes",
    ],
    answer: "Se laver les mains régulièrement",
    explanation:
        "Se laver les mains est une méthode efficace pour réduire la transmission des virus, y compris la grippe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel vaccin est recommandé pour les jeunes enfants pour prévenir la rougeole ?",
    options: [
      "Vaccin contre la grippe",
      "Vaccin ROR (rougeole, oreillons, rubéole)",
      "Vaccin contre le tétanos",
    ],
    answer: "Vaccin ROR (rougeole, oreillons, rubéole)",
    explanation:
        "Le vaccin ROR protège contre la rougeole, une maladie contagieuse et grave.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel acte simple peut réduire le risque de maladies cardiaques ?",
    options: [
      "Faire du yoga",
      "Pratiquer une activité physique régulière",
      "Manger du chocolat",
    ],
    answer: "Pratiquer une activité physique régulière",
    explanation:
        "L'exercice physique aide à maintenir un cœur en bonne santé et à réduire le risque de maladies cardiaques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale cause des maladies liées au tabac ?",
    options: [
      "La nicotine",
      "Le monoxyde de carbone",
      "Les substances cancérigènes",
    ],
    answer: "Les substances cancérigènes",
    explanation:
        "Les substances cancérigènes présentes dans la fumée de tabac sont responsables de nombreux cancers et maladies respiratoires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet principal du port d'un casque lors d'une activité cycliste ?",
    options: [
      "Améliorer l'équilibre",
      "Réduire le bruit",
      "Protéger la tête en cas de chute",
    ],
    answer: "Protéger la tête en cas de chute",
    explanation:
        "Le casque est conçu pour absorber les chocs et protéger le crâne lors d'accidents à vélo.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle mesure est efficace pour prévenir la transmission des IST ?",
    options: [
      "Utiliser des préservatifs",
      "Éviter les rapports sexuels",
      "Prendre des antibiotiques",
    ],
    answer: "Utiliser des préservatifs",
    explanation:
        "Les préservatifs sont un moyen efficace de réduire le risque de transmission des infections sexuellement transmissibles (IST).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel minéral est crucial pour la santé des os ?",
    options: ["Le fer", "Le calcium", "Le potassium"],
    answer: "Le calcium",
    explanation:
        "Le calcium est essentiel pour le développement et le maintien de la santé osseuse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal bénéfice de la vaccination contre le COVID-19 ?",
    options: [
      "Réduire les symptômes de la grippe",
      "Prévenir les hospitalisations graves",
      "Éviter de contracter le rhume",
    ],
    answer: "Prévenir les hospitalisations graves",
    explanation:
        "La vaccination COVID-19 vise principalement à réduire le risque de maladie grave nécessitant une hospitalisation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la première étape en cas de brûlure ?",
    options: [
      "Appliquer de la glace",
      "Passer sous l'eau froide",
      "Mettre un bandage",
    ],
    answer: "Passer sous l'eau froide",
    explanation:
        "Passer la brûlure sous une eau froide aide à réduire la température de la peau et à soulager la douleur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'aliment le plus riche en vitamine C ?",
    options: ["L'orange", "Le kiwi", "Le poivron rouge"],
    answer: "Le poivron rouge",
    explanation:
        "Le poivron rouge contient plus de vitamine C que l'orange, ce qui en fait un excellent choix pour renforcer le système immunitaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la durée recommandée pour se laver les mains ?",
    options: ["10 secondes", "20 secondes", "30 secondes"],
    answer: "20 secondes",
    explanation:
        "Se laver les mains pendant au moins 20 secondes est recommandé pour éliminer les germes efficacement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Qu'est-ce que l'hypertension artérielle ?",
    options: [
      "Un faible taux de glycémie",
      "Une pression artérielle élevée",
      "Une infection virale",
    ],
    answer: "Une pression artérielle élevée",
    explanation:
        "L'hypertension artérielle est une condition où la pression dans les artères est anormalement élevée, augmentant le risque de maladies cardiaques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du tabagisme sur la santé pulmonaire ?",
    options: [
      "Il améliore la fonction pulmonaire",
      "Il cause des dommages aux poumons",
      "Il n'a aucun effet",
    ],
    answer: "Il cause des dommages aux poumons",
    explanation:
        "Le tabagisme est l'une des principales causes de maladies pulmonaires, y compris le cancer du poumon.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moyen de prévenir les caries dentaires ?",
    options: [
      "Manger moins de sucre",
      "Utiliser un bain de bouche",
      "Brosser ses dents quotidiennement",
    ],
    answer: "Brosser ses dents quotidiennement",
    explanation:
        "Un brossage quotidien aide à éliminer la plaque dentaire et à prévenir les caries.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un signe précoce du diabète de type 2 ?",
    options: ["Perte de poids rapide", "Soif accrue", "Nausées fréquentes"],
    answer: "Soif accrue",
    explanation:
        "La soif excessive est un symptôme courant du diabète de type 2 dû à une glycémie élevée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le risque principal d'une exposition excessive au soleil ?",
    options: ["Les coups de soleil", "L'hypothermie", "La déshydratation"],
    answer: "Les coups de soleil",
    explanation:
        "Une exposition excessive au soleil peut entraîner des coups de soleil et augmenter le risque de cancer de la peau.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la principale recommandation pour prévenir l'obésité ?",
    options: [
      "Consommer plus de sucreries",
      "Manger équilibré et faire de l'exercice",
      "Sauter des repas",
    ],
    answer: "Manger équilibré et faire de l'exercice",
    explanation:
        "Une alimentation équilibrée et une activité physique régulière sont clés pour maintenir un poids santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de cancer est le plus fréquent chez les femmes ?",
    options: [
      "Le cancer du poumon",
      "Le cancer du sein",
      "Le cancer de la peau",
    ],
    answer: "Le cancer du sein",
    explanation:
        "Le cancer du sein est le cancer le plus diagnostiqué chez les femmes dans de nombreux pays.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est connu pour ses propriétés antioxydantes ?",
    options: ["Les pommes", "Le thé vert", "Le pain complet"],
    answer: "Le thé vert",
    explanation:
        "Le thé vert est riche en antioxydants, qui aident à protéger les cellules du corps contre les dommages.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'âge recommandé pour le premier dépistage du cancer du sein ?",
    options: ["30 ans", "40 ans", "50 ans"],
    answer: "40 ans",
    explanation:
        "Le dépistage du cancer du sein est généralement recommandé à partir de 40 ans pour les femmes à risque moyen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Comment peut-on prévenir la déshydratation ?",
    options: [
      "Manger des aliments secs",
      "Boire suffisamment d'eau",
      "Éviter de sortir quand il fait chaud",
    ],
    answer: "Boire suffisamment d'eau",
    explanation:
        "Boire de l'eau régulièrement aide à maintenir une bonne hydratation, particulièrement par temps chaud.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle vitamine est principalement produite par la peau au soleil ?",
    options: ["Vitamine A", "Vitamine C", "Vitamine D"],
    answer: "Vitamine D",
    explanation:
        "La vitamine D est synthétisée par la peau en réponse à l'exposition au soleil.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal symptôme de l'allergie au pollen ?",
    options: ["Coup de soleil", "Éternuements", "Frissons"],
    answer: "Éternuements",
    explanation:
        "Les éternuements sont un symptôme courant des allergies au pollen, souvent déclenchés par une irritation des voies respiratoires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du stress sur la santé ?",
    options: [
      "Il renforce le système immunitaire",
      "Il peut causer des problèmes de santé",
      "Il n'a aucun effet",
    ],
    answer: "Il peut causer des problèmes de santé",
    explanation:
        "Le stress chronique est lié à divers problèmes de santé, y compris les maladies cardiaques et l'anxiété.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle méthode est la plus efficace pour se protéger des infections virales ?",
    options: ["Porter un masque", "Éviter les foules", "Se faire vacciner"],
    answer: "Se faire vacciner",
    explanation:
        "Les vaccins sont conçus pour fournir une protection immunitaire contre des infections virales spécifiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un effet néfaste du sucre sur la santé dentaire ?",
    options: [
      "Il renforce l'émail",
      "Il favorise les caries",
      "Il aide à la croissance dentaire",
    ],
    answer: "Il favorise les caries",
    explanation:
        "Une consommation élevée de sucre peut entraîner une accumulation de plaque et favoriser la formation de caries dentaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est un moyen efficace de prévenir les chutes chez les personnes âgées ?",
    options: [
      "Augmenter la consommation de café",
      "Faire des exercices d'équilibre",
      "Éviter l'exercice physique",
    ],
    answer: "Faire des exercices d'équilibre",
    explanation:
        "Les exercices d'équilibre aident à renforcer les muscles et à améliorer la coordination, réduisant ainsi le risque de chutes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'un des premiers signes de déshydratation ?",
    options: ["Fatigue", "Maux de tête", "Soif"],
    answer: "Soif",
    explanation:
        "La sensation de soif est un des premiers signaux du corps indiquant un besoin d'hydratation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un symptôme courant d'une allergie alimentaire ?",
    options: ["Évanouissement", "Éruptions cutanées", "Fatigue"],
    answer: "Éruptions cutanées",
    explanation:
        "Les éruptions cutanées peuvent survenir suite à une réaction allergique alimentaire, souvent accompagnées d'autres symptômes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal danger de l'usage abusif de l'alcool ?",
    options: [
      "Risque de déshydratation",
      "Risque de maladies du foie",
      "Risque de fatigue",
    ],
    answer: "Risque de maladies du foie",
    explanation:
        "Une consommation excessive d'alcool peut endommager le foie et causer des maladies hépatiques graves.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est une bonne pratique pour prévenir les problèmes de vue ?",
    options: [
      "Regarder la télévision de près",
      "Faire des pauses régulières lors de l'utilisation d'écrans",
      "Porter des lunettes de soleil",
    ],
    answer: "Faire des pauses régulières lors de l'utilisation d'écrans",
    explanation:
        "Faire des pauses régulières aide à réduire la fatigue oculaire liée à l'utilisation prolongée d'écrans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l’un des principaux objectifs de l'OMS ?",
    options: [
      "Promouvoir les loisirs",
      "Accroître la biodiversité",
      "Améliorer la santé globale des populations",
    ],
    answer: "Améliorer la santé globale des populations",
    explanation:
        "L'OMS se consacre à améliorer la santé et le bien-être des personnes dans le monde entier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la première chose à faire en cas de saignement nasal ?",
    options: [
      "Se pencher en arrière",
      "Se moucher",
      "Se pencher en avant et pincer le nez",
    ],
    answer: "Se pencher en avant et pincer le nez",
    explanation:
        "Se pencher en avant et pincer le nez permet de réduire le flux sanguin et d'éviter d'avaler du sang.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel type de sucre est associé à une augmentation rapide de la glycémie ?",
    options: ["Sucre naturel", "Sucre ajouté", "Sucre complexe"],
    answer: "Sucre ajouté",
    explanation:
        "Les sucres ajoutés provoquent une augmentation rapide de la glycémie, ce qui peut être néfaste pour la santé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur conseil pour des yeux en santé ?",
    options: [
      "Regarder la télévision longtemps",
      "Utiliser des écrans uniquement la nuit",
      "Prendre des pauses régulières des écrans",
    ],
    answer: "Prendre des pauses régulières des écrans",
    explanation:
        "Les pauses régulières aident à réduire la fatigue oculaire et à maintenir une bonne santé visuelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle de l'eau dans le corps humain ?",
    options: [
      "Soutenir le métabolisme",
      "Rendre les os plus solides",
      "Accélérer la digestion",
    ],
    answer: "Soutenir le métabolisme",
    explanation:
        "L'eau est essentielle au métabolisme et à de nombreuses fonctions corporelles vitales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'un des principaux effets du stress sur l'organisme ?",
    options: [
      "Amélioration de la concentration",
      "Risque accru de maladies",
      "Augmentation de l'énergie",
    ],
    answer: "Risque accru de maladies",
    explanation:
        "Le stress prolongé est lié à un risque accru de maladies cardiovasculaires et d'autres problèmes de santé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la meilleure méthode pour désinfecter une plaie ?",
    options: [
      "Utiliser de l'alcool à friction",
      "Appliquer de l'eau chaude",
      "Nettoyer avec de l'eau et du savon",
    ],
    answer: "Nettoyer avec de l'eau et du savon",
    explanation:
        "L'eau et le savon sont efficaces pour éliminer les bactéries et désinfecter la plaie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un effet bénéfique de l'exercice régulier ?",
    options: [
      "Augmente la fatigue",
      "Réduit le stress",
      "Accroît le risque de maladies",
    ],
    answer: "Réduit le stress",
    explanation:
        "L'exercice régulier peut diminuer les niveaux de stress et améliorer le bien-être général.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la première action à prendre en cas d'allergie sévère ?",
    options: [
      "Prendre un antihistaminique",
      "Appeler les secours",
      "Éliminer l'allergène",
    ],
    answer: "Appeler les secours",
    explanation:
        "En cas d'allergie sévère, il est crucial d'appeler les secours immédiatement pour une assistance médicale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est particulièrement riche en fer ?",
    options: ["Les épinards", "Les carottes", "Les pommes de terre"],
    answer: "Les épinards",
    explanation:
        "Les épinards sont une excellente source de fer, essentielle pour prévenir l'anémie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal bénéfice des activités sportives pour les enfants ?",
    options: [
      "Favoriser le développement musculaire",
      "Encourager l'isolement social",
      "Avoir moins de devoirs",
    ],
    answer: "Favoriser le développement musculaire",
    explanation:
        "Les activités sportives renforcent la musculature et aident au développement physique des enfants.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale cause des maladies respiratoires ?",
    options: ["Le tabagisme", "Le stress", "La pollution de l'air"],
    answer: "Le tabagisme",
    explanation:
        "Le tabagisme est une cause majeure des maladies respiratoires telles que la bronchite et le cancer du poumon.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'objectif principal du dépistage du cancer ?",
    options: [
      "Détecter le cancer à un stade précoce",
      "Éliminer le cancer",
      "Éviter le cancer",
    ],
    answer: "Détecter le cancer à un stade précoce",
    explanation:
        "Le dépistage vise à identifier le cancer avant l'apparition des symptômes, augmentant ainsi les chances de traitement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est un moyen efficace de renforcer le système immunitaire ?",
    options: [
      "Dormir suffisamment",
      "Regarder des films",
      "Ne pas faire d'exercice",
    ],
    answer: "Dormir suffisamment",
    explanation:
        "Un sommeil de qualité est essentiel pour le bon fonctionnement du système immunitaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel test est souvent réalisé pour dépister le diabète ?",
    options: [
      "Test de glycémie à jeun",
      "Radiographie thoracique",
      "Électrocardiogramme",
    ],
    answer: "Test de glycémie à jeun",
    explanation:
        "Le test de glycémie à jeun mesure le taux de sucre dans le sang pour détecter le diabète.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est l'une des principales causes d'accidents domestiques ?",
    options: [
      "Le manque d'éclairage",
      "L'utilisation excessive de médicaments",
      "L'indiscipline des enfants",
    ],
    answer: "Le manque d'éclairage",
    explanation:
        "Un éclairage inadéquat peut contribuer à des accidents domestiques, comme les chutes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est considéré comme un bon choix pour le cœur ?",
    options: ["Le chocolat noir", "Les bonbons", "Les chips"],
    answer: "Le chocolat noir",
    explanation:
        "Le chocolat noir, riche en flavonoïdes, peut contribuer à la santé cardiaque lorsqu'il est consommé avec modération.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un bon moyen de prévenir le stress ?",
    options: [
      "Faire des respirations profondes",
      "Augmenter la consommation de café",
      "Ne rien faire",
    ],
    answer: "Faire des respirations profondes",
    explanation:
        "Les respirations profondes peuvent aider à réduire le stress et à apaiser l'esprit.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal vecteur de transmission du virus de la grippe ?",
    options: [
      "Les gouttelettes respiratoires",
      "Les insectes",
      "L'eau contaminée",
    ],
    answer: "Les gouttelettes respiratoires",
    explanation:
        "Le virus de la grippe se propage principalement par les gouttelettes émises lors de la toux ou des éternuements.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la durée recommandée pour un lavage de mains efficace ?",
    options: ["10 secondes", "20 secondes", "30 secondes"],
    answer: "20 secondes",
    explanation:
        "Il est recommandé de se laver les mains pendant au moins 20 secondes pour éliminer efficacement les germes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est riche en vitamine C ?",
    options: ["La banane", "L'orange", "Le pain"],
    answer: "L'orange",
    explanation:
        "L'orange est bien connue pour sa forte teneur en vitamine C, essentielle pour le système immunitaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal symptôme de la déshydratation ?",
    options: ["Fatigue", "Perte de poids", "Fièvre"],
    answer: "Fatigue",
    explanation:
        "La fatigue est un symptôme courant de la déshydratation, car le corps manque de fluides essentiels.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est l'utilité du vaccin contre la grippe ?",
    options: ["Prévenir la grippe", "Traiter la grippe", "Réduire la fièvre"],
    answer: "Prévenir la grippe",
    explanation:
        "Le vaccin contre la grippe est conçu pour prévenir l'infection par le virus de la grippe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la meilleure option pour hydrater son corps pendant l'été ?",
    options: ["Boire des sodas", "Boire de l'eau", "Manger des bonbons"],
    answer: "Boire de l'eau",
    explanation:
        "L'eau est la meilleure source d'hydratation pour le corps, surtout en période de chaleur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le nom de la maladie causée par un manque de vitamine D ?",
    options: ["Système immunitaire faible", "Rachitisme", "Diabète"],
    answer: "Rachitisme",
    explanation:
        "Le rachitisme est une maladie causée par une carence en vitamine D, affectant la croissance osseuse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel fruit est connu pour ses propriétés antioxydantes ?",
    options: ["La pomme", "Le raisin", "Le concombre"],
    answer: "Le raisin",
    explanation:
        "Le raisin est riche en antioxydants qui aident à combattre les radicaux libres dans le corps.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Qui est le principal responsable de la sécurité alimentaire ?",
    options: [
      "Les consommateurs",
      "Les producteurs",
      "Les organismes gouvernementaux",
    ],
    answer: "Les organismes gouvernementaux",
    explanation:
        "Les organismes gouvernementaux sont responsables de la régulation et de la sécurité alimentaire pour protéger la santé publique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet principal du tabagisme sur la santé respiratoire ?",
    options: [
      "Augmentation de la capacité pulmonaire",
      "Réduction de la capacité pulmonaire",
      "Amélioration de la circulation",
    ],
    answer: "Réduction de la capacité pulmonaire",
    explanation:
        "Le tabagisme entraîne une réduction de la capacité pulmonaire, nuisant à la respiration.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la fréquence recommandée pour un contrôle médical de routine ?",
    options: ["Chaque année", "Tous les cinq ans", "Tous les mois"],
    answer: "Chaque année",
    explanation:
        "Il est conseillé de passer un contrôle médical de routine au moins une fois par an pour surveiller sa santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du stress sur la santé ?",
    options: [
      "Amélioration de l'humeur",
      "Effets néfastes sur le système immunitaire",
      "Augmentation de l'énergie",
    ],
    answer: "Effets néfastes sur le système immunitaire",
    explanation:
        "Le stress chronique peut affaiblir le système immunitaire, rendant l'individu plus vulnérable aux maladies.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale cause de l'obésité ?",
    options: [
      "Un excès de sommeil",
      "Une alimentation déséquilibrée",
      "L'exercice physique",
    ],
    answer: "Une alimentation déséquilibrée",
    explanation:
        "Une alimentation riche en calories et pauvre en nutriments est la principale cause de l'obésité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal des fibres alimentaires ?",
    options: [
      "Augmenter le poids corporel",
      "Faciliter la digestion",
      "Élever la glycémie",
    ],
    answer: "Faciliter la digestion",
    explanation:
        "Les fibres alimentaires aident à réguler la digestion et à prévenir la constipation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal risque de l'hypertension artérielle non traitée ?",
    options: ["Mal de tête", "Accidents vasculaires cérébraux", "Fièvre"],
    answer: "Accidents vasculaires cérébraux",
    explanation:
        "L'hypertension artérielle non traitée augmente le risque d'accidents vasculaires cérébraux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'objectif principal de l'OMS dans le domaine de la santé publique ?",
    options: [
      "Éradiquer toutes les maladies",
      "Améliorer la santé des populations",
      "Réduire les coûts de santé",
    ],
    answer: "Améliorer la santé des populations",
    explanation:
        "L'objectif de l'OMS est d'améliorer la santé des populations à travers le monde.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'effet de la consommation excessive d'alcool sur le foie ?",
    options: [
      "Amélioration des fonctions hépatiques",
      "Cirrhose",
      "Aucune conséquence",
    ],
    answer: "Cirrhose",
    explanation:
        "Une consommation excessive d'alcool peut endommager le foie et conduire à une cirrhose.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelles sont les causes principales de l'acné ?",
    options: ["L'alimentation", "Les hormones", "Le manque de sommeil"],
    answer: "Les hormones",
    explanation:
        "Les fluctuations hormonales sont l'une des principales causes de l'acné, surtout à l'adolescence.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la durée de validité d'un don de sang ?",
    options: ["3 mois", "6 mois", "1 an"],
    answer: "1 an",
    explanation:
        "Un don de sang a une durée de validité de 1 an après le prélèvement, selon le type de produit.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le lien entre l'activité physique et la santé mentale ?",
    options: [
      "Aucun lien",
      "Elle améliore l'humeur",
      "Elle augmente le stress",
    ],
    answer: "Elle améliore l'humeur",
    explanation:
        "L'activité physique est reconnue pour ses effets positifs sur la santé mentale et l'humeur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale méthode de prévention contre le VIH ?",
    options: [
      "Le port de lunettes de soleil",
      "L'utilisation de préservatifs",
      "L'exercice physique",
    ],
    answer: "L'utilisation de préservatifs",
    explanation:
        "L'utilisation de préservatifs est une méthode efficace pour réduire le risque de transmission du VIH.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal facteur de risque pour les maladies cardiovasculaires ?",
    options: [
      "La consommation de fruits",
      "Le tabagisme",
      "L'exercice régulier",
    ],
    answer: "Le tabagisme",
    explanation:
        "Le tabagisme est un facteur de risque majeur pour le développement des maladies cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du manque de sommeil sur le corps ?",
    options: [
      "Amélioration de la concentration",
      "Diminution des performances",
      "Augmentation de l'énergie",
    ],
    answer: "Diminution des performances",
    explanation:
        "Un manque de sommeil peut entraîner une diminution des performances cognitives et physiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des antioxydants ?",
    options: [
      "Augmenter l'appétit",
      "Protéger les cellules du stress oxydatif",
      "Ralentir la digestion",
    ],
    answer: "Protéger les cellules du stress oxydatif",
    explanation:
        "Les antioxydants protègent les cellules contre les dommages causés par les radicaux libres.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal avantage du petit-déjeuner ?",
    options: [
      "Il permet de dormir plus longtemps",
      "Il fournit de l'énergie pour la journée",
      "Il fait perdre du poids",
    ],
    answer: "Il fournit de l'énergie pour la journée",
    explanation:
        "Le petit-déjeuner est important car il fournit l'énergie nécessaire pour commencer la journée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le groupe sanguin le plus courant ?",
    options: ["O", "A", "AB"],
    answer: "O",
    explanation:
        "Le groupe sanguin O est le plus courant dans la population mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet de l'exposition au soleil sur la peau ?",
    options: [
      "Amélioration de l'hydratation",
      "Production de vitamine D",
      "Augmentation des rides",
    ],
    answer: "Production de vitamine D",
    explanation:
        "L'exposition au soleil stimule la production de vitamine D dans la peau, essentielle pour la santé osseuse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type d'exercice est le plus bénéfique pour le cœur ?",
    options: ["Musculation", "Étirements", "Cardio-training"],
    answer: "Cardio-training",
    explanation:
        "Les exercices de cardio-training sont particulièrement bénéfiques pour la santé cardiovasculaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal danger des drogues illicites sur la santé ?",
    options: [
      "Amélioration des performances",
      "Addiction",
      "Aucune conséquence",
    ],
    answer: "Addiction",
    explanation:
        "Les drogues illicites peuvent entraîner une forte addiction, nuisant gravement à la santé physique et mentale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle de l'insuline dans le corps ?",
    options: [
      "Réguler la glycémie",
      "Augmenter le poids",
      "Améliorer la digestion",
    ],
    answer: "Réguler la glycémie",
    explanation:
        "L'insuline est une hormone qui joue un rôle crucial dans la régulation des niveaux de sucre dans le sang.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la principale source de protéines dans un régime végétarien ?",
    options: ["Fruits", "Légumineuses", "Produits laitiers"],
    answer: "Légumineuses",
    explanation:
        "Les légumineuses sont une excellente source de protéines pour ceux qui suivent un régime végétarien.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal du stress sur le corps ?",
    options: [
      "Augmentation de la concentration",
      "Affaiblissement du système immunitaire",
      "Amélioration de la mémoire",
    ],
    answer: "Affaiblissement du système immunitaire",
    explanation:
        "Le stress chronique peut affaiblir le système immunitaire et donc la résistance aux maladies.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le meilleur moyen de prévenir les maladies infectieuses ?",
    options: ["Se laver les mains", "Manger des fruits", "Faire de l'exercice"],
    answer: "Se laver les mains",
    explanation:
        "Se laver les mains régulièrement est l'un des moyens les plus efficaces de prévenir les maladies infectieuses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moment pour faire un examen de santé ?",
    options: ["Avant un événement stressant", "Régulièrement", "Jamais"],
    answer: "Régulièrement",
    explanation:
        "Il est important de faire des examens de santé régulièrement pour surveiller son état de santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal effet d'une alimentation déséquilibrée ?",
    options: [
      "Amélioration de la santé générale",
      "Prise de poids",
      "Aucune conséquence",
    ],
    answer: "Prise de poids",
    explanation:
        "Une alimentation déséquilibrée entraînant un excès de calories peut conduire à une prise de poids.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type d'aliment est riche en oméga-3 ?",
    options: ["Viande rouge", "Poisson", "Produits laitiers"],
    answer: "Poisson",
    explanation:
        "Le poisson, en particulier les poissons gras, est une excellente source d'oméga-3, bénéfiques pour la santé cardiaque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale fonction des vaccins ?",
    options: [
      "Prévenir les maladies",
      "Traiter les maladies",
      "Augmenter le risque de maladies",
    ],
    answer: "Prévenir les maladies",
    explanation:
        "Les vaccins aident à prévenir l'apparition de nombreuses maladies infectieuses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal du calcium dans le corps ?",
    options: [
      "Rendre les ongles plus forts",
      "Renforcer les os",
      "Améliorer la vision",
    ],
    answer: "Renforcer les os",
    explanation:
        "Le calcium est essentiel pour maintenir des os solides et en bonne santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est connu pour sa richesse en fer ?",
    options: ["Épinards", "Carottes", "Pommes de terre"],
    answer: "Épinards",
    explanation:
        "Les épinards sont réputés pour leur forte teneur en fer, bénéfique pour la santé sanguine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal but d'un mode de vie sain ?",
    options: [
      "Augmenter le stress",
      "Améliorer la qualité de vie",
      "Ralentir le vieillissement",
    ],
    answer: "Améliorer la qualité de vie",
    explanation:
        "Un mode de vie sain vise à améliorer la qualité de vie en prévenant les maladies et en favorisant le bien-être.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le meilleur moyen de renforcer son système immunitaire ?",
    options: ["Manger équilibré", "Éviter les fruits", "Faire peu d'exercice"],
    answer: "Manger équilibré",
    explanation:
        "Une alimentation équilibrée est essentielle pour maintenir un système immunitaire fort et efficace.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact principal de l'exposition au soleil sur la peau ?",
    options: [
      "Rides",
      "Production de collagène",
      "Amélioration de l'hydratation",
    ],
    answer: "Rides",
    explanation:
        "Une exposition excessive au soleil peut causer des rides et un vieillissement prématuré de la peau.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le but d'une campagne de vaccination ?",
    options: [
      "Promouvoir le tabagisme",
      "Prevenir les maladies",
      "Diminuer le poids corporel",
    ],
    answer: "Prevenir les maladies",
    explanation:
        "Les campagnes de vaccination visent à prévenir la propagation de maladies infectieuses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est l'une des clés pour maintenir un équilibre émotionnel ?",
    options: [
      "Éviter de parler de ses émotions",
      "Pratiquer la méditation",
      "Regarder des films d'horreur",
    ],
    answer: "Pratiquer la méditation",
    explanation:
        "La méditation peut aider à équilibrer les émotions et à réduire le stress.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du sucre sur la santé dentaire ?",
    options: [
      "Renforce les dents",
      "Augmente le risque de caries",
      "N'a aucun effet",
    ],
    answer: "Augmente le risque de caries",
    explanation:
        "Une consommation excessive de sucre est un facteur majeur dans le développement des caries dentaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le plus grand organe du corps humain ?",
    options: ["Le cœur", "Les poumons", "La peau"],
    answer: "La peau",
    explanation:
        "La peau est le plus grand organe du corps humain, jouant un rôle clé dans la protection et la régulation thermique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet d'une bonne hydratation sur le corps ?",
    options: [
      "Améliore l'énergie",
      "Augmente le stress",
      "Diminue la concentration",
    ],
    answer: "Améliore l'énergie",
    explanation:
        "Une bonne hydratation contribue à maintenir un niveau d'énergie élevé et à améliorer les performances.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des acides gras essentiels ?",
    options: [
      "Augmenter le poids",
      "Réguler la glycémie",
      "Soutenir la santé cardiaque",
    ],
    answer: "Soutenir la santé cardiaque",
    explanation:
        "Les acides gras essentiels sont importants pour la santé cardiaque et le fonctionnement cellulaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal bénéfice de l'activité physique régulière ?",
    options: [
      "Améliorer la digestion",
      "Renforcer le cœur",
      "Ralentir le métabolisme",
    ],
    answer: "Renforcer le cœur",
    explanation:
        "L'activité physique régulière renforce le muscle cardiaque et améliore la circulation sanguine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est l'une des conséquences de la sédentarité ?",
    options: [
      "Augmentation de la force musculaire",
      "Perte de poids",
      "Prise de poids",
    ],
    answer: "Prise de poids",
    explanation:
        "La sédentarité est souvent associée à une prise de poids en raison du manque d'activité physique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale fonction de la vaccination ?",
    options: [
      "Prévenir les maladies infectieuses",
      "Accélérer la guérison",
      "Soulager la douleur",
    ],
    answer: "Prévenir les maladies infectieuses",
    explanation:
        "La vaccination vise à stimuler le système immunitaire pour combattre les infections.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal agent pathogène de la grippe ?",
    options: ["Bactérie", "Virus", "Champignon"],
    answer: "Virus",
    explanation:
        "La grippe est causée par un virus, principalement le virus influenza.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal du tabagisme sur la santé ?",
    options: [
      "Amélioration de la respiration",
      "Augmentation du risque de cancer",
      "Renforcement du système immunitaire",
    ],
    answer: "Augmentation du risque de cancer",
    explanation:
        "Le tabagisme est fortement lié à divers types de cancer, en particulier le cancer du poumon.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des antibiotiques ?",
    options: [
      "Traiter les infections virales",
      "Traiter les infections bactériennes",
      "Prévenir les maladies",
    ],
    answer: "Traiter les infections bactériennes",
    explanation:
        "Les antibiotiques sont efficaces contre les infections causées par des bactéries.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle maladie est causée par un déficit en vitamine C ?",
    options: ["Scorbut", "Anémie", "Diabète"],
    answer: "Scorbut",
    explanation:
        "Le scorbut est une maladie due à une carence en vitamine C, entraînant des problèmes de santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'âge recommandé pour commencer à effectuer des bilans de santé réguliers ?",
    options: ["15 ans", "25 ans", "40 ans"],
    answer: "25 ans",
    explanation:
        "Les bilans de santé réguliers sont conseillés à partir de 25 ans pour détecter tôt des problèmes de santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'organe principal touché par l'alcoolisme ?",
    options: ["Le cœur", "Le foie", "Les poumons"],
    answer: "Le foie",
    explanation:
        "Le foie est l'organe principalement affecté par l'abus d'alcool, pouvant entraîner des maladies telles que la cirrhose.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la méthode la plus efficace pour prévenir les accidents vasculaires cérébraux ?",
    options: [
      "Réduire le stress",
      "Éviter le tabagisme",
      "Consommer plus de sucre",
    ],
    answer: "Éviter le tabagisme",
    explanation:
        "Éviter le tabagisme réduit considérablement les risques d'accidents vasculaires cérébraux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quels aliments sont riches en fibres ?",
    options: ["Fruits et légumes", "Produits laitiers", "Viandes"],
    answer: "Fruits et légumes",
    explanation:
        "Les fruits et légumes sont une source excellente de fibres, essentielles pour la digestion.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du stress sur le système immunitaire ?",
    options: ["Il le renforce", "Il l'affaiblit", "Il n'a aucun effet"],
    answer: "Il l'affaiblit",
    explanation:
        "Le stress chronique peut affaiblir le système immunitaire, rendant la personne plus susceptible aux infections.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la durée recommandée pour se laver les mains afin d'éliminer les germes ?",
    options: ["5 secondes", "20 secondes", "1 minute"],
    answer: "20 secondes",
    explanation:
        "Se laver les mains pendant au moins 20 secondes est recommandé pour éliminer efficacement les germes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un des symptômes courants de l'allergie au pollen ?",
    options: ["Éruptions cutanées", "Éternuements", "Fatigue"],
    answer: "Éternuements",
    explanation:
        "Les éternuements sont un symptôme classique des allergies saisonnières au pollen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'un des avantages de l'exercice physique régulier ?",
    options: [
      "Augmentation du stress",
      "Amélioration de la santé mentale",
      "Augmentation du cholestérol",
    ],
    answer: "Amélioration de la santé mentale",
    explanation:
        "L'exercice physique régulier contribue à réduire le stress et à améliorer l'humeur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal objectif de la médecine préventive ?",
    options: [
      "Guérir les maladies",
      "Détecter les maladies tôt",
      "Améliorer le goût des médicaments",
    ],
    answer: "Détecter les maladies tôt",
    explanation:
        "La médecine préventive vise à identifier les maladies à un stade précoce pour faciliter le traitement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal effet de la consommation excessive de sel ?",
    options: [
      "Baisse de la pression artérielle",
      "Augmentation de la pression artérielle",
      "Amélioration de la santé digestive",
    ],
    answer: "Augmentation de la pression artérielle",
    explanation:
        "Un excès de sel peut entraîner une hypertension, augmentant le risque de maladies cardiovasculaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un des bienfaits du sommeil sur la santé ?",
    options: [
      "Augmentation de la productivité",
      "Diminution des risques de maladies",
      "Oreilles plus grandes",
    ],
    answer: "Diminution des risques de maladies",
    explanation:
        "Un bon sommeil est essentiel pour réduire les risques de diverses maladies.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le meilleur moyen de prévenir la propagation des maladies infectieuses ?",
    options: [
      "Manger des fruits",
      "Se laver les mains fréquemment",
      "Faire du sport",
    ],
    answer: "Se laver les mains fréquemment",
    explanation:
        "Se laver les mains est l'une des mesures les plus efficaces pour prévenir les infections.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du soleil sur la peau ?",
    options: ["Brûlures", "Hydratation", "Renforcement"],
    answer: "Brûlures",
    explanation:
        "Une exposition excessive au soleil peut causer des brûlures cutanées et des dommages à long terme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal risque associé à l'obésité ?",
    options: [
      "Augmentation de la flexibilité",
      "Augmentation du risque de diabète",
      "Diminution de la respiration",
    ],
    answer: "Augmentation du risque de diabète",
    explanation:
        "L'obésité est un facteur de risque majeur pour le développement du diabète de type 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle vitamine est essentielle pour la vision ?",
    options: ["Vitamine A", "Vitamine C", "Vitamine D"],
    answer: "Vitamine A",
    explanation:
        "La vitamine A joue un rôle crucial dans la santé des yeux et la vision.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bénéfice de la méditation ?",
    options: [
      "Augmentation du stress",
      "Amélioration de la concentration",
      "Diminution de l'alimentation",
    ],
    answer: "Amélioration de la concentration",
    explanation:
        "La méditation aide à améliorer la concentration et la clarté mentale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal des antioxydants dans le corps ?",
    options: [
      "Protéger les cellules du stress oxydatif",
      "Renforcer les os",
      "Équilibrer les hormones",
    ],
    answer: "Protéger les cellules du stress oxydatif",
    explanation:
        "Les antioxydants aident à neutraliser les radicaux libres et à protéger les cellules.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle condition est due à un excès de stress ?",
    options: ["Diabète de type 2", "Hyperactivité", "Syndrome d'alerte"],
    answer: "Syndrome d'alerte",
    explanation:
        "Un excès de stress peut entraîner le syndrome d'alerte, affectant le bien-être général.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale cause de la carie dentaire ?",
    options: [
      "Consommation de sucre",
      "Manque d'exercice",
      "Exposition au soleil",
    ],
    answer: "Consommation de sucre",
    explanation:
        "Le sucre est un facteur majeur contribuant à la formation de caries dentaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le but des campagnes de sensibilisation à la santé ?",
    options: [
      "Promouvoir la vente de médicaments",
      "Informer le public sur les risques de santé",
      "Augmenter les impôts sur le tabac",
    ],
    answer: "Informer le public sur les risques de santé",
    explanation:
        "Les campagnes de sensibilisation visent à informer la population sur les risques et les pratiques de santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal facteur de risque de maladies cardiaques ?",
    options: [
      "Consommation d'eau",
      "Consommation de tabac",
      "Consommation de légumes",
    ],
    answer: "Consommation de tabac",
    explanation:
        "Le tabagisme est l'un des principaux facteurs de risque pour les maladies cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de régime est conseillé pour une bonne santé ?",
    options: [
      "Riche en graisses saturées",
      "Équilibré et varié",
      "Composé uniquement de protéines",
    ],
    answer: "Équilibré et varié",
    explanation:
        "Un régime équilibré et varié est crucial pour maintenir une bonne santé générale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du sommeil sur la mémoire ?",
    options: ["Améliore la mémoire", "N'a aucun impact", "Diminue la mémoire"],
    answer: "Améliore la mémoire",
    explanation:
        "Un sommeil adéquat est essentiel pour la consolidation de la mémoire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du surpoids sur la santé mentale ?",
    options: [
      "Amélioration de l'estime de soi",
      "Réduction du stress",
      "Augmentation du risque de dépression",
    ],
    answer: "Augmentation du risque de dépression",
    explanation:
        "Le surpoids peut contribuer à des problèmes de santé mentale comme la dépression.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de maladie est le diabète ?",
    options: ["Maladie infectieuse", "Maladie chronique", "Maladie aiguë"],
    answer: "Maladie chronique",
    explanation:
        "Le diabète est une maladie chronique nécessitant un suivi et une gestion à long terme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle de l'eau dans le corps humain ?",
    options: [
      "Stimuler le métabolisme",
      "Augmenter le poids",
      "Diminuer la libido",
    ],
    answer: "Stimuler le métabolisme",
    explanation:
        "L'eau est essentielle pour de nombreuses fonctions corporelles, y compris le métabolisme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Comment les fruits et légumes affectent-ils la santé ?",
    options: [
      "Idéal pour augmenter le cholestérol",
      "Réduisent le risque de maladies",
      "Provoquent des allergies",
    ],
    answer: "Réduisent le risque de maladies",
    explanation:
        "Une consommation élevée de fruits et légumes est associée à un risque diminué de maladies chroniques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le bon moyen de gérer le stress ?",
    options: [
      "Ignorer les problèmes",
      "Pratiquer des techniques de relaxation",
      "Consommer plus de café",
    ],
    answer: "Pratiquer des techniques de relaxation",
    explanation:
        "Les techniques de relaxation, comme la méditation, aident à gérer le stress de manière efficace.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact de l'isolement social sur la santé ?",
    options: [
      "Amélioration de la santé mentale",
      "Aucun impact",
      "Diminution de la santé mentale",
    ],
    answer: "Diminution de la santé mentale",
    explanation:
        "L'isolement social peut nuire à la santé mentale, augmentant le risque de problèmes psychologiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la meilleure manière de prévenir les maladies respiratoires ?",
    options: [
      "Éviter les exercices physiques",
      "Renforcer son système immunitaire",
      "Éviter les fruits",
    ],
    answer: "Renforcer son système immunitaire",
    explanation:
        "Un système immunitaire fort aide à prévenir les infections respiratoires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un des symptômes de la déshydratation ?",
    options: ["Énergie accrue", "Fatigue", "Bonne digestion"],
    answer: "Fatigue",
    explanation:
        "La déshydratation peut entraîner une fatigue, affectant la performance physique et mentale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel type de produits laitiers est recommandé pour une bonne santé ?",
    options: [
      "Produits riches en matières grasses",
      "Produits allégés",
      "Produits sucrés",
    ],
    answer: "Produits allégés",
    explanation:
        "Les produits laitiers allégés sont souvent recommandés pour un régime équilibré.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact d'une alimentation trop sucrée sur la santé ?",
    options: [
      "Amélioration de la santé dentaire",
      "Augmentation du risque de diabète",
      "Diminution des caries",
    ],
    answer: "Augmentation du risque de diabète",
    explanation:
        "Une consommation excessive de sucre est liée à un risque accru de diabète de type 2.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la meilleure méthode d'hydratation pendant l'exercice ?",
    options: [
      "Boire des boissons sucrées",
      "Boire de l'eau",
      "Éviter de boire",
    ],
    answer: "Boire de l'eau",
    explanation:
        "L'eau est la meilleure boisson pour rester hydraté pendant l'exercice.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel élément est essentiel pour la formation des os ?",
    options: ["Calcium", "Sucre", "Cholestérol"],
    answer: "Calcium",
    explanation:
        "Le calcium est essentiel pour le développement et le maintien de la santé des os.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un des rôles des acides gras oméga-3 ?",
    options: [
      "Augmenter l'inflammation",
      "Réduire le cholestérol",
      "Améliorer la mémoire",
    ],
    answer: "Améliorer la mémoire",
    explanation:
        "Les acides gras oméga-3 sont connus pour leurs effets positifs sur la fonction cognitive.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact d'une consommation élevée de caféine sur le corps ?",
    options: [
      "Amélioration du sommeil",
      "Augmentation de l'anxiété",
      "Diminution de l'énergie",
    ],
    answer: "Augmentation de l'anxiété",
    explanation:
        "Une consommation excessive de caféine peut provoquer une augmentation de l'anxiété.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un effet du manque de sommeil prolongé ?",
    options: [
      "Amélioration de la concentration",
      "Augmentation de la productivité",
      "Affaiblissement du système immunitaire",
    ],
    answer: "Affaiblissement du système immunitaire",
    explanation:
        "Un manque de sommeil prolongé peut gravement affecter le système immunitaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle des fibres dans l'alimentation ?",
    options: [
      "Favoriser la digestion",
      "Accroître le taux de cholestérol",
      "Ralentir le métabolisme",
    ],
    answer: "Favoriser la digestion",
    explanation:
        "Les fibres aident à réguler la digestion et à prévenir la constipation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est l'importance d'un bon équilibre de la flore intestinale ?",
    options: [
      "Aucune importance",
      "Risque accru d'obésité",
      "Risque diminué de problèmes digestifs",
    ],
    answer: "Risque diminué de problèmes digestifs",
    explanation:
        "Un bon équilibre de la flore intestinale contribue à une digestion saine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est un des principaux effets du stress chronique sur la santé physique ?",
    options: [
      "Amélioration de la santé cardiovasculaire",
      "Augmentation de la pression artérielle",
      "Diminution de la masse musculaire",
    ],
    answer: "Augmentation de la pression artérielle",
    explanation:
        "Le stress chronique peut entraîner une augmentation de la pression artérielle, affectant la santé cardiovasculaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la meilleure façon de prévenir les infections respiratoires en hiver ?",
    options: [
      "Consommer beaucoup de sucre",
      "Boire beaucoup d'eau",
      "Éviter les fruits",
    ],
    answer: "Boire beaucoup d'eau",
    explanation:
        "Rester hydraté est crucial pour renforcer le système immunitaire et prévenir les infections.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal bénéfice d'une alimentation riche en antioxydants ?",
    options: [
      "Stimuler l'appétit",
      "Réduire le vieillissement cellulaire",
      "Accélérer la prise de poids",
    ],
    answer: "Réduire le vieillissement cellulaire",
    explanation:
        "Les antioxydants aident à protéger les cellules du vieillissement prématuré.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le lien entre l'hydratation et la concentration ?",
    options: [
      "Pas de lien",
      "Une bonne hydratation améliore la concentration",
      "Une mauvaise hydratation améliore la concentration",
    ],
    answer: "Une bonne hydratation améliore la concentration",
    explanation:
        "Une hydratation adéquate est essentielle pour maintenir un bon niveau de concentration.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact de l'alcool sur la santé mentale ?",
    options: [
      "Amélioration de l'humeur",
      "Aucune influence",
      "Augmentation du risque de dépression",
    ],
    answer: "Augmentation du risque de dépression",
    explanation:
        "Une consommation excessive d'alcool est associée à un risque accru de dépression.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal du tabac sur la santé ?",
    options: [
      "Améliore la circulation sanguine",
      "Provoque des maladies respiratoires",
      "Augmente l'énergie",
    ],
    answer: "Provoque des maladies respiratoires",
    explanation:
        "Le tabac est une cause majeure de maladies respiratoires, comme le cancer du poumon.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale fonction du vaccin contre la grippe ?",
    options: [
      "Protéger contre le virus",
      "Augmenter la température corporelle",
      "Assurer une guérison rapide",
    ],
    answer: "Protéger contre le virus",
    explanation:
        "Le vaccin contre la grippe vise à stimuler le système immunitaire pour se défendre contre le virus de la grippe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel aliment est riche en vitamine C ?",
    options: ["Pommes de terre", "Citrons", "Pain"],
    answer: "Citrons",
    explanation:
        "Les citrons sont connus pour leur haute teneur en vitamine C, essentielle pour le système immunitaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la durée conseillée pour un lavage des mains efficace ?",
    options: ["10 secondes", "20 secondes", "30 secondes"],
    answer: "20 secondes",
    explanation:
        "Il est recommandé de se laver les mains pendant au moins 20 secondes pour éliminer les germes efficacement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de grasse est le plus dangereux pour la santé ?",
    options: [
      "Les acides gras trans",
      "Les acides gras insaturés",
      "Les acides gras saturés",
    ],
    answer: "Les acides gras trans",
    explanation:
        "Les acides gras trans augmentent le risque de maladies cardiovasculaires et doivent être évités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact de l'alcool sur le foie ?",
    options: [
      "Renforce son fonctionnement",
      "Peut provoquer des maladies",
      "Améliore sa régénération",
    ],
    answer: "Peut provoquer des maladies",
    explanation:
        "Une consommation excessive d'alcool peut causer des maladies hépatiques, comme la cirrhose.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal risque du surpoids ?",
    options: [
      "Augmentation de la créativité",
      "Risque accru de maladies métaboliques",
      "Amélioration de la condition physique",
    ],
    answer: "Risque accru de maladies métaboliques",
    explanation:
        "Le surpoids est associé à un risque élevé de maladies comme le diabète et les maladies cardiaques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle pratique favorise une bonne hygiène dentaire ?",
    options: [
      "Se brosser les dents une fois par mois",
      "Utiliser un fil dentaire quotidiennement",
      "Éviter complètement le sucre",
    ],
    answer: "Utiliser un fil dentaire quotidiennement",
    explanation:
        "L'utilisation quotidienne du fil dentaire aide à éliminer la plaque dentaire et à prévenir les caries.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet de l'exercice régulier sur la santé mentale ?",
    options: ["Il l'aggrave", "Il n'a aucun effet", "Il l'améliore"],
    answer: "Il l'améliore",
    explanation:
        "L'exercice régulier est prouvé pour réduire le stress et améliorer l'humeur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'objectif principal de la prévention du VIH ?",
    options: [
      "Éliminer le virus du corps",
      "Éviter la transmission du virus",
      "Guérir les personnes infectées",
    ],
    answer: "Éviter la transmission du virus",
    explanation:
        "Les stratégies de prévention visent à empêcher la transmission du VIH entre individus.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un symptôme courant d'une déshydratation ?",
    options: [
      "Augmentation de la soif",
      "Raccourcissement des ongles",
      "Perte de poids rapide",
    ],
    answer: "Augmentation de la soif",
    explanation:
        "Une soif accrue est un signe classique de déshydratation, indiquant un besoin accru en liquides.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet de l'exposition au soleil sur la peau ?",
    options: [
      "Renforce les défenses immunitaires",
      "Peut provoquer des coups de soleil",
      "N'a aucun effet",
    ],
    answer: "Peut provoquer des coups de soleil",
    explanation:
        "Une exposition excessive au soleil sans protection peut entraîner des coups de soleil et endommager la peau.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale source de mélatonine ?",
    options: ["Les céréales", "Le lait", "Le chocolat"],
    answer: "Le lait",
    explanation:
        "Le lait contient de la mélatonine, qui peut aider à réguler le sommeil.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel type de cancer est le plus fréquent chez les femmes ?",
    options: ["Cancer du poumon", "Cancer du sein", "Cancer du foie"],
    answer: "Cancer du sein",
    explanation:
        "Le cancer du sein est le cancer le plus diagnostiqué chez les femmes dans de nombreux pays.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet du stress chronique sur la santé ?",
    options: [
      "Améliore la concentration",
      "Peut affaiblir le système immunitaire",
      "Augmente l'énergie",
    ],
    answer: "Peut affaiblir le système immunitaire",
    explanation:
        "Le stress chronique peut nuire au système immunitaire, rendant les individus plus vulnérables aux maladies.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'objectif principal de la nutrition équilibrée ?",
    options: [
      "Augmenter le poids corporel",
      "Assurer suffisamment de nutriments",
      "Réduire le stress uniquement",
    ],
    answer: "Assurer suffisamment de nutriments",
    explanation:
        "Une nutrition équilibrée vise à fournir tous les nutriments nécessaires pour un bon fonctionnement du corps.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel type de pollution a le plus d'impact sur la santé respiratoire ?",
    options: ["Pollution sonore", "Pollution de l'eau", "Pollution de l'air"],
    answer: "Pollution de l'air",
    explanation:
        "La pollution de l'air est un facteur majeur de maladies respiratoires et cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal but d'une campagne de vaccination ?",
    options: [
      "Créer de nouvelles souches de virus",
      "Éliminer complètement la maladie",
      "Atteindre l'immunité collective",
    ],
    answer: "Atteindre l'immunité collective",
    explanation:
        "Les campagnes de vaccination visent à protéger la population en atteignant l'immunité collective contre les maladies transmissibles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quels aliments sont souvent impliqués dans les intoxications alimentaires ?",
    options: [
      "Fruits et légumes crus",
      "Produits laitiers non pasteurisés",
      "Céréales complètes",
    ],
    answer: "Produits laitiers non pasteurisés",
    explanation:
        "Les produits laitiers non pasteurisés sont souvent une source courante d'intoxications alimentaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moyen de se protéger contre la grippe ?",
    options: [
      "Se laver les mains moins souvent",
      "Éviter le contact avec les malades",
      "Se faire vacciner",
    ],
    answer: "Se faire vacciner",
    explanation:
        "La vaccination est le moyen le plus efficace de prévenir la grippe et ses complications.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact de la consommation excessive de sucre sur la santé ?",
    options: [
      "Améliore la concentration",
      "Peut entraîner le diabète",
      "Renforce le système immunitaire",
    ],
    answer: "Peut entraîner le diabète",
    explanation:
        "Une consommation excessive de sucre est liée à un risque accru de diabète de type 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est un moyen efficace de prévenir les maladies cardiovasculaires ?",
    options: [
      "Réduire le stress uniquement",
      "Avoir une alimentation équilibrée",
      "Éviter complètement l'exercice",
    ],
    answer: "Avoir une alimentation équilibrée",
    explanation:
        "Une alimentation équilibrée aide à maintenir une bonne santé cardiovasculaire et à réduire le risque de maladies.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le temps recommandé pour pratiquer une activité physique par semaine ?",
    options: ["30 minutes", "150 minutes", "3 heures"],
    answer: "150 minutes",
    explanation:
        "Les recommandations actuelles suggèrent au moins 150 minutes d'activité physique modérée par semaine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un signe de dépression ?",
    options: [
      "Augmentation de l'énergie",
      "Perte d'intérêt pour les activités",
      "Meilleure concentration",
    ],
    answer: "Perte d'intérêt pour les activités",
    explanation:
        "La perte d'intérêt pour des activités auparavant appréciées est un symptôme courant de la dépression.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact de l'obésité sur la santé ?",
    options: [
      "Améliore la santé mentale",
      "Augmente le risque de maladies chroniques",
      "N'a aucun effet",
    ],
    answer: "Augmente le risque de maladies chroniques",
    explanation:
        "L'obésité est un facteur de risque majeur pour de nombreuses maladies chroniques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal de l'eau dans l'organisme ?",
    options: [
      "Remplacer les nutriments",
      "Réguler la température corporelle",
      "Augmenter le poids corporel",
    ],
    answer: "Réguler la température corporelle",
    explanation:
        "L'eau aide à maintenir la température corporelle stable, notamment par la transpiration.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel minéral est essentiel pour la santé des os ?",
    options: ["Fer", "Calcium", "Potassium"],
    answer: "Calcium",
    explanation:
        "Le calcium est crucial pour le développement et le maintien de la santé osseuse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un effet bénéfique de l'activité physique ?",
    options: [
      "Diminution de l'endurance",
      "Augmentation du stress",
      "Amélioration de la circulation sanguine",
    ],
    answer: "Amélioration de la circulation sanguine",
    explanation:
        "L'activité physique régulière aide à améliorer la circulation sanguine dans le corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le principal risque lié à la consommation de viande rouge en excès ?",
    options: [
      "Amélioration de la digestion",
      "Risque accru de maladies cardiovasculaires",
      "Aucune conséquence",
    ],
    answer: "Risque accru de maladies cardiovasculaires",
    explanation:
        "Une consommation excessive de viande rouge est associée à un risque accru de maladies cardiovasculaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quelle est la meilleure façon de prévenir le cancer de la peau ?",
    options: [
      "Éviter l'exposition au soleil",
      "Utiliser des crèmes solaires",
      "Porter des vêtements sombres",
    ],
    answer: "Utiliser des crèmes solaires",
    explanation:
        "L'utilisation de crèmes solaires peut réduire considérablement le risque de cancer de la peau lié au soleil.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet bénéfique de l'ail pour la santé ?",
    options: [
      "Améliore la vue",
      "Renforce le système immunitaire",
      "Augmente le cholestérol",
    ],
    answer: "Renforce le système immunitaire",
    explanation:
        "L'ail est reconnu pour ses propriétés antimicrobiennes et son effet bénéfique sur le système immunitaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est un effet secondaire commun des antibiotiques ?",
    options: ["Prise de poids", "Diarrhée", "Amélioration de la vision"],
    answer: "Diarrhée",
    explanation:
        "La diarrhée est un effet secondaire fréquent des antibiotiques en raison de la perturbation de la flore intestinale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est l'importance de la vitamine D ?",
    options: [
      "Renforce la vue",
      "Aide à l'absorption du calcium",
      "Améliore la digestion",
    ],
    answer: "Aide à l'absorption du calcium",
    explanation:
        "La vitamine D est essentielle pour une bonne absorption du calcium, important pour la santé des os.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le meilleur moment pour se faire vacciner contre la grippe ?",
    options: ["En été", "À l'automne", "Au printemps"],
    answer: "À l'automne",
    explanation:
        "Se faire vacciner contre la grippe à l'automne est recommandé pour une protection optimale durant l'hiver.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le but principal de l'allaitement maternel ?",
    options: [
      "Augmenter le poids du bébé",
      "Fournir des nutriments essentiels",
      "Protéger l'environnement",
    ],
    answer: "Fournir des nutriments essentiels",
    explanation:
        "L'allaitement maternel fournit des nutriments et anticorps essentiels au développement du nourrisson.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est l'impact du manque de sommeil sur les performances cognitives ?",
    options: ["Il les améliore", "Il n'a aucun impact", "Il les dégrade"],
    answer: "Il les dégrade",
    explanation:
        "Le manque de sommeil affecte négativement la mémoire, l'attention et la concentration.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la cause principale du diabète de type 2 ?",
    options: [
      "Consommation élevée de sucre",
      "Manque de sommeil",
      "Exercice régulier",
    ],
    answer: "Consommation élevée de sucre",
    explanation:
        "Une consommation élevée de sucre et de calories contribuent au développement du diabète de type 2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact d'une alimentation riche en fibres ?",
    options: [
      "Augmente l'appétit",
      "Améliore la digestion",
      "Ralentit le métabolisme",
    ],
    answer: "Améliore la digestion",
    explanation:
        "Une alimentation riche en fibres facilite le transit intestinal et améliore la digestion.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est un facteur de risque majeur pour les maladies cardiaques ?",
    options: [
      "Activité physique régulière",
      "Hypertension artérielle",
      "Sommeil suffisant",
    ],
    answer: "Hypertension artérielle",
    explanation:
        "L'hypertension artérielle est un facteur de risque majeur pour le développement des maladies cardiaques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est la principale source de fer dans l'alimentation ?",
    options: ["Fruits", "Viande rouge", "Produits laitiers"],
    answer: "Viande rouge",
    explanation:
        "La viande rouge est une source riche et facilement absorbable de fer dans l'alimentation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact de la consommation de café sur la santé ?",
    options: [
      "Améliore le sommeil",
      "Peut augmenter l'anxiété",
      "Renforce le système immunitaire",
    ],
    answer: "Peut augmenter l'anxiété",
    explanation:
        "Une consommation excessive de café peut provoquer de l'anxiété chez certaines personnes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quelle est une conséquence du vieillissement sur la santé ?",
    options: [
      "Augmentation de la force",
      "Diminution de la mémoire",
      "Amélioration de l'humeur",
    ],
    answer: "Diminution de la mémoire",
    explanation:
        "Le vieillissement peut entraîner des troubles de la mémoire et des fonctions cognitives.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet des légumes crus sur la santé ?",
    options: [
      "Peuvent provoquer des allergies",
      "Sont souvent moins nutritifs que cuits",
      "Sont riches en nutriments",
    ],
    answer: "Sont riches en nutriments",
    explanation:
        "Les légumes crus conservent de nombreux nutriments, vitamines et minéraux essentiels à la santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le meilleur moyen de prévenir les caries dentaires ?",
    options: [
      "Éviter de se brosser les dents",
      "Consommer beaucoup de sucre",
      "Se brosser les dents deux fois par jour",
    ],
    answer: "Se brosser les dents deux fois par jour",
    explanation:
        "Un brossage régulier aide à éliminer la plaque dentaire et prévient les caries.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le rôle principal des acides gras oméga-3 ?",
    options: [
      "Améliorer la digestion",
      "Réduire l'inflammation",
      "Augmenter le cholestérol",
    ],
    answer: "Réduire l'inflammation",
    explanation:
        "Les acides gras oméga-3 sont connus pour leurs propriétés anti-inflammatoires bénéfiques pour la santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du bruit sur la santé ?",
    options: [
      "Améliore la concentration",
      "Peut provoquer des troubles du sommeil",
      "N'a aucun impact",
    ],
    answer: "Peut provoquer des troubles du sommeil",
    explanation:
        "Une exposition prolongée au bruit peut nuire à la qualité du sommeil et entraîner des problèmes de santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est le principal bénéfice de la pratique du yoga ?",
    options: [
      "Augmentation de la souplesse",
      "Diminution du poids",
      "Amélioration de la vue",
    ],
    answer: "Augmentation de la souplesse",
    explanation:
        "Le yoga aide à améliorer la souplesse et la force musculaire tout en réduisant le stress.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question:
        "Quel est le meilleur moment pour consommer des fruits et légumes ?",
    options: [
      "À tout moment de la journée",
      "Uniquement le matin",
      "Pas du tout",
    ],
    answer: "À tout moment de la journée",
    explanation:
        "Les fruits et légumes peuvent être consommés à tout moment pour bénéficier de leurs nutriments.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'impact du télétravail sur la santé ?",
    options: [
      "Amélioration de la santé physique",
      "Risque accru de sédentarité",
      "Diminution du stress uniquement",
    ],
    answer: "Risque accru de sédentarité",
    explanation:
        "Le télétravail peut entraîner une augmentation du temps passé assis et, donc, un risque accru de sédentarité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Santé (prévention)",
    question: "Quel est l'effet principal des protéines sur l'organisme ?",
    options: [
      "Fournissent de l'énergie uniquement",
      "Aident à la construction musculaire",
      "Réduisent le stress",
    ],
    answer: "Aident à la construction musculaire",
    explanation:
        "Les protéines jouent un rôle crucial dans la construction et la réparation des muscles dans le corps.",
    difficulty: "Moyenne",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizCultureGeneraleSante extends StatefulWidget {
  static const String routeName = '/gpx_exam/concours/culture_generale_sante';
  final String uid;
  final String email;

  const QuizCultureGeneraleSante({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCultureGeneraleSante> createState() =>
      _QuizCultureGeneraleSanteState();
}

class _QuizCultureGeneraleSanteState extends State<QuizCultureGeneraleSante>
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
        ? questionCultureSante
        : questionCultureSante
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
            'module_name': 'Culture générale - Santé',
            'quiz_name': 'Quiz culture générale santé',
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
      await _sb.from('quiz_culture_generale_sante_pages').insert({
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
      debugPrint('❌ quiz_culture_generale_sante_pages insert failed: $e');
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
