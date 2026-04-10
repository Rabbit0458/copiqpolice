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

final List<QuizQuestion> questionCultureSecuriteRoutiere = [
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le taux d'alcoolémie maximum autorisé pour conduire en France ?",
    options: ["0,2 g/l", "0,5 g/l", "1 g/l"],
    answer: "0,5 g/l",
    explanation:
        "Le taux d'alcoolémie maximum autorisé pour les conducteurs non professionnels est de 0,5 g/l.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la principale cause d'accidents de la route en France ?",
    options: [
      "Excès de vitesse",
      "Alcool au volant",
      "Distrait par un téléphone",
    ],
    answer: "Distrait par un téléphone",
    explanation:
        "La distraction au volant, notamment par le téléphone, est une cause fréquente d'accidents en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'âge minimum pour obtenir un permis de conduire de catégorie B en France ?",
    options: ["17 ans", "18 ans", "19 ans"],
    answer: "17 ans",
    explanation:
        "L'âge minimum pour obtenir un permis de conduire de catégorie B est de 17 ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le but principal du panneau de signalisation 'Cédez le passage' ?",
    options: ["Accélérer", "Ralentir", "Laisser passer"],
    answer: "Laisser passer",
    explanation:
        "Le panneau 'Cédez le passage' indique aux conducteurs de laisser passer les véhicules prioritaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle du gendarme ou policier en bord de route ?",
    options: [
      "Donner des amandes",
      "Assurer la sécurité",
      "Indiquer les directions",
    ],
    answer: "Assurer la sécurité",
    explanation:
        "Le gendarme ou policier a pour rôle principal d'assurer la sécurité routière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la vitesse maximale autorisée sur autoroute en France ?",
    options: ["110 km/h", "130 km/h", "150 km/h"],
    answer: "130 km/h",
    explanation: "La vitesse maximale autorisée sur autoroute est de 130 km/h.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel dispositif de sécurité est obligatoire pour les enfants en voiture ?",
    options: ["Siège auto", "Ceinture de sécurité", "Airbag"],
    answer: "Siège auto",
    explanation:
        "Un siège auto est obligatoire pour transporter un enfant en voiture.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un feu rouge clignotant ?",
    options: ["Arrêt obligatoire", "Avertissement", "Passage autorisé"],
    answer: "Arrêt obligatoire",
    explanation:
        "Un feu rouge clignotant signifie un arrêt obligatoire pour tous les véhicules.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la distance de sécurité recommandée entre deux véhicules ?",
    options: ["1 seconde", "2 secondes", "3 secondes"],
    answer: "2 secondes",
    explanation:
        "Il est recommandé de garder une distance de sécurité de 2 secondes entre deux véhicules.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel équivalent de signalisation indique une route à sens unique ?",
    options: ["Flèche verte", "Flèche rouge", "Flèche bleue"],
    answer: "Flèche bleue",
    explanation: "Une flèche bleue indique une route à sens unique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "En cas de panne sur autoroute, que devez-vous faire ?",
    options: [
      "Rester dans votre véhicule",
      "Sortir du véhicule",
      "Allumer vos phares",
    ],
    answer: "Rester dans votre véhicule",
    explanation:
        "En cas de panne sur autoroute, il est conseillé de rester dans votre véhicule.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel équipement est obligatoire dans tous les véhicules en France ?",
    options: ["Veste haute visibilité", "Sonnette", "Trousse de secours"],
    answer: "Veste haute visibilité",
    explanation:
        "Une veste haute visibilité est obligatoire dans tous les véhicules en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le symbole d'un panneau 'Fin de restrictions' ?",
    options: ["Cercle rouge", "Carré bleu", "Rectangle vert"],
    answer: "Cercle rouge",
    explanation:
        "Un cercle rouge indique la fin de restrictions liées à la circulation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "À quelle distance est-il recommandé de signaler un dépassement ?",
    options: ["50 mètres", "100 mètres", "150 mètres"],
    answer: "100 mètres",
    explanation:
        "Il est recommandé de signaler un dépassement 100 mètres avant de l'effectuer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'effet de la vitesse sur le temps de réaction du conducteur ?",
    options: ["Il l'augmente", "Il le diminue", "Il ne change rien"],
    answer: "Il le diminue",
    explanation:
        "Une vitesse élevée diminue le temps de réaction d'un conducteur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif d'un contrôle de gendarmerie sur la route ?",
    options: [
      "Vérifier les papiers",
      "Donner des amendes",
      "Évaluer la vitesse",
    ],
    answer: "Vérifier les papiers",
    explanation:
        "Le contrôle de gendarmerie sur la route a pour but de vérifier les papiers des véhicules.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle principal d'un panneau de signalisation ?",
    options: [
      "Prévenir les conducteurs",
      "Informer sur les routes",
      "Rappeler la vitesse",
    ],
    answer: "Prévenir les conducteurs",
    explanation:
        "Les panneaux de signalisation ont pour rôle principal de prévenir les conducteurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire en cas d'accident sans blessés ?",
    options: [
      "Appeler la police",
      "Rédiger un constat amiable",
      "Attendre sur place",
    ],
    answer: "Rédiger un constat amiable",
    explanation:
        "En cas d'accident sans blessés, il faut rédiger un constat amiable.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'importance du port de la ceinture de sécurité ?",
    options: ["Sécurité accrue", "Confort", "Esthétique"],
    answer: "Sécurité accrue",
    explanation:
        "Le port de la ceinture de sécurité permet d'accroître la sécurité du conducteur et des passagers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quel moment utiliser les feux de route ?",
    options: ["Sur route humide", "En pleine nuit", "En milieu urbain"],
    answer: "En pleine nuit",
    explanation:
        "Les feux de route doivent être utilisés principalement en pleine nuit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal risque de conduire sous l'emprise de drogues ?",
    options: [
      "Diminution de la vue",
      "Accélération de la vitesse",
      "Perte de contrôle",
    ],
    answer: "Perte de contrôle",
    explanation:
        "Conduire sous l'emprise de drogues augmente le risque de perte de contrôle du véhicule.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'indique un panneau de limitation de vitesse ?",
    options: [
      "La vitesse minimum",
      "La vitesse recommandée",
      "La vitesse maximum",
    ],
    answer: "La vitesse maximum",
    explanation:
        "Un panneau de limitation de vitesse indique la vitesse maximum autorisée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but d'un rond-point ?",
    options: [
      "Accélérer le trafic",
      "Ralentir le trafic",
      "Faciliter la circulation",
    ],
    answer: "Faciliter la circulation",
    explanation:
        "Un rond-point a pour but de faciliter la circulation des véhicules.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel feu doit-on suivre au carrefour après un feu rouge ?",
    options: ["Feu orange", "Feu vert", "Feu bleu"],
    answer: "Feu vert",
    explanation: "Après un feu rouge, il faut suivre le feu vert pour avancer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau 'Route barrée' ?",
    options: ["Passage interdit", "Passage autorisé", "Route en réfection"],
    answer: "Passage interdit",
    explanation: "Un panneau 'Route barrée' indique le passage interdit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que faut-il faire lors d'une circulation en condition de brouillard ?",
    options: [
      "Utiliser les feux de croisement",
      "Rouler vite",
      "Ne rien changer",
    ],
    answer: "Utiliser les feux de croisement",
    explanation:
        "Il est conseillé d'utiliser les feux de croisement en cas de brouillard.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Pourquoi les conducteurs doivent-ils faire attention au 'cycliste' ?",
    options: ["Lenteur", "Vulnérabilité", "Passage suprême"],
    answer: "Vulnérabilité",
    explanation:
        "Les cyclistes sont particulièrement vulnérables sur la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel document est essentiel pour conduire ?",
    options: ["Carte d'identité", "Permis de conduire", "Passeport"],
    answer: "Permis de conduire",
    explanation:
        "Le permis de conduire est le document essentiel requis pour conduire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la signification d'une ligne continue au sol ?",
    options: ["Dépassable", "Non dépassable", "Stationnement autorisé"],
    answer: "Non dépassable",
    explanation: "Une ligne continue indique une zone non dépassable.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie une flèche directionnelle sur un panneau ?",
    options: ["Interdiction", "Direction suggérée", "Priorité"],
    answer: "Direction suggérée",
    explanation: "Une flèche directionnelle indique une direction suggérée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet du port de casque à moto ?",
    options: ["Aucun effet", "Protection accrue", "Esthétique"],
    answer: "Protection accrue",
    explanation:
        "Le port du casque à moto offre une protection accrue en cas d'accident.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la durée de validité d'un permis de conduire de catégorie B ?",
    options: ["5 ans", "10 ans", "15 ans"],
    answer: "15 ans",
    explanation:
        "La durée de validité d'un permis de conduire de catégorie B est de 15 ans.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'impact d'un excès de vitesse sur la distance d'arrêt ?",
    options: [
      "Inaugure la distance",
      "Diminue la distance",
      "Augmente la distance",
    ],
    answer: "Augmente la distance",
    explanation:
        "Un excès de vitesse augmente la distance d'arrêt d'un véhicule.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle mesure peut réduire les comportements à risque des jeunes conducteurs ?",
    options: ["Interdiction totale", "Éducation routière", "Incentives"],
    answer: "Éducation routière",
    explanation:
        "L'éducation routière peut réduire les comportements à risque des jeunes conducteurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le message principal des campagnes de sécurité routière ?",
    options: ["Vitesse", "Alcool", "Prudence"],
    answer: "Prudence",
    explanation:
        "Les campagnes de sécurité routière mettent l'accent sur l'importance de la prudence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel instrument est utilisé pour contrôler la vitesse des véhicules ?",
    options: ["Radar", "Caméra", "Sonar"],
    answer: "Radar",
    explanation:
        "Le radar est l'instrument utilisé pour contrôler la vitesse des véhicules.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment réagir face à un piéton sur la chaussée ?",
    options: ["Accélérer", "Ralentir", "Ignorer"],
    answer: "Ralentir",
    explanation: "Il faut ralentir face à un piéton sur la chaussée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but d'un feu orange ?",
    options: [
      "Avertir d'un changement",
      "Indiquer un arrêt",
      "Autoriser la circulation",
    ],
    answer: "Avertir d'un changement",
    explanation: "Le feu orange avertit d'un changement imminent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet d'un virage sur la vitesse ?",
    options: ["Augmente la vitesse", "Diminue la vitesse", "N'a aucun effet"],
    answer: "Diminue la vitesse",
    explanation:
        "Un virage nécessite une diminution de la vitesse pour assurer la sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la règle des 'deux secondes' ?",
    options: [
      "Suivre le véhicule de devant",
      "Doubler un véhicule",
      "Conduire sur l'autoroute",
    ],
    answer: "Suivre le véhicule de devant",
    explanation:
        "La règle des 'deux secondes' recommande de suivre le véhicule de devant à une distance suffisante.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet de la fatigue sur la conduite ?",
    options: [
      "Améliore la concentration",
      "Ralentit la réaction",
      "Augmente la vigilance",
    ],
    answer: "Ralentit la réaction",
    explanation: "La fatigue ralentit les réactions du conducteur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quelle distance d'un passage piéton doit-on s'arrêter ?",
    options: ["5 mètres", "10 mètres", "15 mètres"],
    answer: "5 mètres",
    explanation:
        "Il est recommandé de s'arrêter à 5 mètres d'un passage piéton.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel panneau indique une zone scolaire ?",
    options: ["Panneau carré", "Panneau triangle", "Panneau rond"],
    answer: "Panneau triangle",
    explanation: "Un panneau en forme de triangle indique une zone scolaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le risque de conduire de nuit ?",
    options: [
      "Diminution de la visibilité",
      "Augmentation de la vitesse",
      "Risque d'ennui",
    ],
    answer: "Diminution de la visibilité",
    explanation:
        "La principale difficulté de conduire de nuit est la diminution de la visibilité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but de la signalisation horizontale ?",
    options: [
      "Délimiter les voies",
      "Accueillir les conducteurs",
      "Interdire le stationnement",
    ],
    answer: "Délimiter les voies",
    explanation:
        "La signalisation horizontale a pour but de délimiter les voies de circulation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la règle sur l'alcool pour les conducteurs débutants ?",
    options: ["0 g/l", "0,5 g/l", "1 g/l"],
    answer: "0 g/l",
    explanation:
        "Les conducteurs débutants ne doivent pas avoir d'alcool dans le sang, soit 0 g/l.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel comportement est à adopter en cas de pluie ?",
    options: ["Accélérer", "Ralentir", "Stationner"],
    answer: "Ralentir",
    explanation:
        "Il est conseillé de ralentir en cas de pluie pour éviter les accidents.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but d'un panneau d'interdiction ?",
    options: [
      "Encourager la circulation",
      "Limiter certaines actions",
      "Avertir la vitesse",
    ],
    answer: "Limiter certaines actions",
    explanation:
        "Un panneau d'interdiction a pour but de limiter certaines actions sur la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'un point de permis ?",
    options: ["Une contravention", "Un risque", "Une perte de crédit"],
    answer: "Une contravention",
    explanation: "Un point de permis est attribué suite à une contravention.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel comportement est à adopter face à un animal sur la route ?",
    options: ["Accélérer", "Ralentir", "Ignorer"],
    answer: "Ralentir",
    explanation:
        "Il faut ralentir face à un animal sur la route pour éviter un accident.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'élément le plus important à respecter lors de la conduite ?",
    options: [
      "Les limitations de vitesse",
      "Le port de la ceinture de sécurité",
      "L'utilisation du klaxon",
    ],
    answer: "Les limitations de vitesse",
    explanation:
        "Respecter les limitations de vitesse est crucial pour la sécurité sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle couleur de feu indique que vous devez vous arrêter ?",
    options: ["Vert", "Rouge", "Jaune"],
    answer: "Rouge",
    explanation:
        "Le feu rouge signifie que tous les véhicules doivent s'arrêter.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'usage principal des ronds-points ?",
    options: [
      "Accélérer la circulation",
      "Réduire les accidents",
      "Ralentir le trafic",
    ],
    answer: "Accélérer la circulation",
    explanation:
        "Les ronds-points facilitent le flux de la circulation et réduisent les arrêts nécessaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel document devez-vous toujours avoir en votre possession en conduisant ?",
    options: [
      "Le permis de conduire",
      "L'assurance santé",
      "Une pièce d'identité",
    ],
    answer: "Le permis de conduire",
    explanation:
        "Le permis de conduire est obligatoire pour conduire légalement un véhicule.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le taux d'alcoolémie autorisé pour conduire en France ?",
    options: ["0,5 g/L", "0,2 g/L", "0,8 g/L"],
    answer: "0,5 g/L",
    explanation:
        "La limite légale d'alcoolémie pour conduire est fixée à 0,5 g/L de sang.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau de signalisation triangulaire ?",
    options: ["Un danger à venir", "Une priorité", "Une information"],
    answer: "Un danger à venir",
    explanation:
        "Les panneaux triangulaires avertissent les conducteurs d'un danger potentiel sur la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle distance minimale doit-on laisser entre soi et le véhicule de devant ?",
    options: ["1m", "2m", "3m"],
    answer: "2m",
    explanation:
        "Une distance d'au moins 2 mètres est recommandée pour assurer la sécurité en cas de freinage.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "À quelle vitesse maximale un cycliste peut-il circuler sur la route ?",
    options: ["50 km/h", "30 km/h", "Pas de limite"],
    answer: "Pas de limite",
    explanation:
        "Un cycliste peut circuler à la vitesse qu'il souhaite, tant qu'il respecte les règles de circulation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des feux de détresse ?",
    options: [
      "Avertir d'un danger",
      "Signaler un stationnement",
      "Indiquer une vitesse élevée",
    ],
    answer: "Avertir d'un danger",
    explanation:
        "Les feux de détresse servent à signaler une situation dangereuse ou anormale sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la vitesse maximale autorisée en agglomération ?",
    options: ["50 km/h", "70 km/h", "90 km/h"],
    answer: "50 km/h",
    explanation:
        "En agglomération, la vitesse maximale est généralement limitée à 50 km/h pour la sécurité des piétons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Comment un conducteur doit-il réagir face à un piéton qui traverse la chaussée ?",
    options: [
      "Accélérer pour passer avant",
      "S'arrêter et lui céder le passage",
      "Klaxonner pour le prévenir",
    ],
    answer: "S'arrêter et lui céder le passage",
    explanation:
        "Les piétons ont toujours la priorité sur les passages piétons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet du port de la ceinture de sécurité ?",
    options: [
      "Augmente la sécurité",
      "Réduit la consommation de carburant",
      "Empêche le vol",
    ],
    answer: "Augmente la sécurité",
    explanation:
        "Le port de la ceinture de sécurité réduit considérablement les risques de blessures graves lors d'un accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel type de panneaux indique une interdiction ?",
    options: ["Ronds", "Carrés", "Triangulaires"],
    answer: "Ronds",
    explanation:
        "Les panneaux ronds signalent généralement une interdiction ou une obligation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "En cas de brouillard, que devez-vous faire ?",
    options: [
      "Conduire sans feux",
      "Allumer vos feux de croisement",
      "Augmenter la vitesse",
    ],
    answer: "Allumer vos feux de croisement",
    explanation:
        "En cas de brouillard, il est essentiel d'allumer les feux de croisement pour voir et être vu.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but des panneaux de signalisation ?",
    options: [
      "Informez les conducteurs",
      "Décorer la route",
      "Ralentir les voitures",
    ],
    answer: "Informez les conducteurs",
    explanation:
        "Les panneaux de signalisation fournissent des informations essentielles pour la sécurité routière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal risque d'une conduite fatigante ?",
    options: [
      "Réduction de l'attention",
      "Augmentation de la vitesse",
      "Diminution de la consommation de carburant",
    ],
    answer: "Réduction de l'attention",
    explanation:
        "La fatigue au volant réduit considérablement la concentration et augmente les risques d'accident.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'impact de l'utilisation du téléphone portable en conduisant ?",
    options: ["Aucun impact", "Améliore la sécurité", "Distrait le conducteur"],
    answer: "Distrait le conducteur",
    explanation:
        "L'utilisation du téléphone portable multiplie par plusieurs le risque d'accident.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'indique un panneau de limitation de vitesse ?",
    options: [
      "Un maximum autorisé",
      "Une vitesse minimum",
      "Une recommandation",
    ],
    answer: "Un maximum autorisé",
    explanation:
        "Un panneau de limitation de vitesse indique la vitesse maximale à ne pas dépasser.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel équipement est obligatoire pour les véhicules ?",
    options: [
      "Un extincteur",
      "Un gilet de sécurité",
      "Une trousse de premiers secours",
    ],
    answer: "Un gilet de sécurité",
    explanation:
        "Le gilet de sécurité est obligatoire pour être visible lors d'un arrêt sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie une ligne continue sur la route ?",
    options: [
      "Doubler est autorisé",
      "Doubler est interdit",
      "Changement de voie autorisé",
    ],
    answer: "Doubler est interdit",
    explanation:
        "Une ligne continue indique qu'il est interdit de changer de voie ou de doubler.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'effet d'un bon entretien de son véhicule sur la sécurité ?",
    options: ["Aucun effet", "Améliore la sécurité", "Coûte cher"],
    answer: "Améliore la sécurité",
    explanation:
        "Un bon entretien réduit les risques de pannes et d'accidents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment faire un créneau ?",
    options: [
      "S'arrêter en ligne droite",
      "Effectuer des manœuvres en marche arrière",
      "Rouler à vive allure",
    ],
    answer: "Effectuer des manœuvres en marche arrière",
    explanation:
        "Le créneau nécessite des manœuvres précises en marche arrière pour se garer.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des rétroviseurs ?",
    options: [
      "Améliorer l'apparence du véhicule",
      "Permettre de vérifier les angles morts",
      "Aider à stationner uniquement",
    ],
    answer: "Permettre de vérifier les angles morts",
    explanation:
        "Les rétroviseurs sont essentiels pour assurer la sécurité en surveillant les zones non visibles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand devez-vous utiliser vos feux de route ?",
    options: [
      "Jamais",
      "En dehors des agglomérations la nuit",
      "À tout moment",
    ],
    answer: "En dehors des agglomérations la nuit",
    explanation:
        "Les feux de route doivent être utilisés la nuit sur les routes non éclairées pour une meilleure visibilité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel geste doit-on faire pour signaler un changement de direction ?",
    options: ["Clignoter avec le feu", "Lève la main", "Accélérer"],
    answer: "Clignoter avec le feu",
    explanation:
        "Utiliser le clignotant est essentiel pour informer les autres usagers de la route de vos intentions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel type de permis est nécessaire pour conduire une voiture ?",
    options: ["Permis A", "Permis B", "Permis C"],
    answer: "Permis B",
    explanation:
        "Le permis B est requis pour conduire des voitures particulières dans la plupart des pays.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que représente un panneau de danger ?",
    options: [
      "Une indication de direction",
      "Une interdiction de vitesse",
      "Un risque potentiel",
    ],
    answer: "Un risque potentiel",
    explanation:
        "Les panneaux de danger alertent les conducteurs sur les situations à risque sur la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que faire si vous êtes témoin d'un accident ?",
    options: [
      "Ignorer l'accident",
      "Appeler les secours",
      "Prendre des photos uniquement",
    ],
    answer: "Appeler les secours",
    explanation:
        "Il est vital d'appeler les secours pour garantir une assistance rapide aux victimes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quelle distance doit-on se garer d'un passage piéton ?",
    options: ["5 mètres", "3 mètres", "1 mètre"],
    answer: "5 mètres",
    explanation:
        "Se garer à 5 mètres d'un passage piéton permet de garantir la visibilité et la sécurité des piétons.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal objectif des limitations de vitesse ?",
    options: [
      "Améliorer le confort de conduite",
      "Réduire le bruit",
      "Assurer la sécurité routière",
    ],
    answer: "Assurer la sécurité routière",
    explanation:
        "Les limitations de vitesse sont mises en place pour protéger tous les usagers de la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'un dispositif de sécurité comme l'ABS ?",
    options: [
      "Réduire la consommation d'essence",
      "Prévenir le blocage des roues",
      "Affecter la vitesse maximale",
    ],
    answer: "Prévenir le blocage des roues",
    explanation:
        "L'ABS empêche le blocage des roues lors d'un freinage d'urgence, améliorant ainsi le contrôle du véhicule.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'une contravention ?",
    options: [
      "Une amende pour infraction",
      "Un avertissement verbal",
      "Un document de sécurité",
    ],
    answer: "Une amende pour infraction",
    explanation:
        "Une contravention est une sanction pécuniaire pour violation des règles de circulation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but d'une formation à la sécurité routière ?",
    options: [
      "Améliorer les compétences de conduite",
      "Mieux comprendre les règles",
      "Obtenir un permis de conduire",
    ],
    answer: "Améliorer les compétences de conduite",
    explanation:
        "La formation à la sécurité routière vise à développer des comportements de conduite sûrs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Pourquoi est-il important de respecter les feux de signalisation ?",
    options: [
      "Pour éviter les embouteillages",
      "Pour assurer la sécurité de tous",
      "Pour réduire la consommation d'essence",
    ],
    answer: "Pour assurer la sécurité de tous",
    explanation:
        "Les feux de signalisation régulent la circulation pour prévenir les accidents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel type de permis est requis pour conduire un camion de plus de 3,5 tonnes ?",
    options: ["Permis B", "Permis C", "Permis D"],
    answer: "Permis C",
    explanation:
        "Le permis C est nécessaire pour conduire des poids lourds de plus de 3,5 tonnes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quels signes sur le tableau de bord indiquent une anomalie ?",
    options: ["Les feux de croisement", "Les témoins lumineux", "Le klaxon"],
    answer: "Les témoins lumineux",
    explanation:
        "Les témoins lumineux alertent le conducteur d'éventuels problèmes mécaniques ou électriques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la règle à suivre en cas d'accident avec des blessés ?",
    options: [
      "Partir rapidement",
      "Rester sur place et alerter les secours",
      "Discuter avec les témoins",
    ],
    answer: "Rester sur place et alerter les secours",
    explanation:
        "Il est essentiel de rester sur les lieux et de contacter les secours en cas de blessés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau de sens interdit ?",
    options: [
      "Accès autorisé",
      "Circulation interdite",
      "Stationnement autorisé",
    ],
    answer: "Circulation interdite",
    explanation:
        "Le panneau de sens interdit indique que l'accès à cette voie est interdit pour tous les véhicules.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel type de suspension est préférable pour le confort sur route ?",
    options: ["Rigide", "Souple", "Dur"],
    answer: "Souple",
    explanation:
        "Une suspension souple améliore le confort de conduite sur les routes irrégulières.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'objectif d'une campagne de sensibilisation à la sécurité routière ?",
    options: [
      "Vendre des voitures",
      "Éduquer le public",
      "Augmenter les amendes",
    ],
    answer: "Éduquer le public",
    explanation:
        "Les campagnes de sensibilisation visent à informer sur les dangers et à promouvoir la sécurité sur les routes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel type de panneau indique une direction à suivre ?",
    options: ["Rectangulaire", "Carré", "Triangulaire"],
    answer: "Rectangulaire",
    explanation:
        "Les panneaux rectangulaires donnent des informations directionnelles aux conducteurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire en cas de pluie ?",
    options: [
      "Conduire plus vite",
      "Activer les feux de croisement",
      "Ne rien changer",
    ],
    answer: "Activer les feux de croisement",
    explanation:
        "Il est recommandé d'activer les feux de croisement en cas de pluie pour une meilleure visibilité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel équipement permet de mesurer la vitesse d'un véhicule ?",
    options: ["Un chronomètre", "Un radar", "Un odomètre"],
    answer: "Un radar",
    explanation:
        "Les radars sont utilisés pour mesurer la vitesse à laquelle un véhicule circule.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal objectif des contrôles de police sur la route ?",
    options: [
      "Faire des amendes",
      "Informer le public",
      "Assurer la sécurité routière",
    ],
    answer: "Assurer la sécurité routière",
    explanation:
        "Les contrôles de police visent à garantir le respect des règles et à assurer la sécurité des usagers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la couleur des feux de position ?",
    options: ["Rouge", "Blanc", "Orange"],
    answer: "Blanc",
    explanation:
        "Les feux de position sont de couleur blanche et permettent de signaler la présence du véhicule.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel doit être l'état des pneus pour une conduite sécurisée ?",
    options: ["Usés", "Bien gonflés et en bon état", "Pas de limite"],
    answer: "Bien gonflés et en bon état",
    explanation:
        "Des pneus en bon état garantissent une meilleure adhérence et sécurité sur la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie le terme 'angle mort' ?",
    options: [
      "Une zone visible",
      "Un espace de stationnement",
      "Une zone non visible",
    ],
    answer: "Une zone non visible",
    explanation:
        "L'angle mort désigne les zones que le conducteur ne peut pas voir à travers les rétroviseurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelles sont les conséquences d'une conduite sans permis ?",
    options: ["Une amende", "Aucune conséquence", "Une suspension de permis"],
    answer: "Une amende",
    explanation:
        "Conduire sans permis entraîne généralement une amende et d'autres sanctions légales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire en cas de panne sur la route ?",
    options: [
      "Rester dans le véhicule",
      "Mettre des feux de détresse",
      "Quitter le véhicule",
    ],
    answer: "Mettre des feux de détresse",
    explanation:
        "Les feux de détresse doivent être activés pour avertir les autres conducteurs d'un danger.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact du non-respect des règles de circulation ?",
    options: [
      "Aucun impact",
      "Des sanctions et risques d'accidents",
      "Amélioration de l'expérience de conduite",
    ],
    answer: "Des sanctions et risques d'accidents",
    explanation:
        "Le non-respect des règles de circulation peut entraîner des accidents et des amendes.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la limite de vitesse sur autoroute en France pour les voitures légères ?",
    options: ["130 km/h", "110 km/h", "150 km/h"],
    answer: "130 km/h",
    explanation:
        "La limite de vitesse sur autoroute pour les voitures légères est fixée à 130 km/h.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal danger lors de la conduite sous l'effet de l'alcool ?",
    options: [
      "Diminution de la concentration",
      "Augmentation de la vitesse",
      "Amélioration des réflexes",
    ],
    answer: "Diminution de la concentration",
    explanation:
        "L'alcool affecte la concentration, ce qui augmente le risque d'accident.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle couleur est utilisée pour les panneaux de stop en France ?",
    options: ["Rouge", "Bleu", "Vert"],
    answer: "Rouge",
    explanation:
        "Les panneaux de stop sont de couleur rouge pour alerter les conducteurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'âge minimum pour obtenir un permis de conduire en France ?",
    options: ["17 ans", "21 ans", "16 ans"],
    answer: "17 ans",
    explanation:
        "L'âge minimum pour obtenir un permis de conduire en France est de 17 ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel type de ceinture est obligatoire pour tous les passagers d'un véhicule ?",
    options: [
      "Ceinture de sécurité",
      "Ceinture de maintien",
      "Ceinture d'harnachement",
    ],
    answer: "Ceinture de sécurité",
    explanation:
        "La ceinture de sécurité est obligatoire pour tous les passagers d'un véhicule.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'effet principal de la vitesse excessive sur la route ?",
    options: [
      "Réduction de la distance d'arrêt",
      "Augmentation du risque d'accident",
      "Meilleure maniabilité",
    ],
    answer: "Augmentation du risque d'accident",
    explanation:
        "Une vitesse excessive augmente considérablement le risque d'accidents routiers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Comment se nomme le document attestant de l'assurance d'un véhicule ?",
    options: ["Certificat d'assurance", "Contrat de vente", "Carte grise"],
    answer: "Certificat d'assurance",
    explanation:
        "Le certificat d'assurance prouve que le véhicule est assuré conformément à la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "À quoi sert le panneau de signalisation triangle réfléchissant ?",
    options: [
      "À avertir les autres conducteurs",
      "À indiquer une direction",
      "À signaler un arrêt",
    ],
    answer: "À avertir les autres conducteurs",
    explanation:
        "Le triangle réfléchissant est utilisé pour avertir les autres conducteurs d'un danger sur la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le taux d'alcoolémie autorisé pour un conducteur novice en France ?",
    options: ["0,2 g/l", "0,5 g/l", "0,8 g/l"],
    answer: "0,2 g/l",
    explanation:
        "Pour les conducteurs novices, la limite est de 0,2 g/l d'alcool dans le sang.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un feu rouge clignotant à un carrefour ?",
    options: ["Arrêt obligatoire", "Vitesse réduite", "Passage autorisé"],
    answer: "Arrêt obligatoire",
    explanation:
        "Un feu rouge clignotant indique un arrêt obligatoire avant de poursuivre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le comportement à adopter en cas d'accident corporel ?",
    options: [
      "Quitter les lieux",
      "Appeler les secours",
      "Discuter avec les autres conducteurs",
    ],
    answer: "Appeler les secours",
    explanation:
        "Il est essentiel d'appeler les secours en cas d'accident corporel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet de la fatigue sur la conduite ?",
    options: [
      "Amélioration de la concentration",
      "Ralentissement des réflexes",
      "Aucune influence",
    ],
    answer: "Ralentissement des réflexes",
    explanation:
        "La fatigue ralentit les réflexes du conducteur, augmentant le risque d'accident.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'un panneau de limitation de vitesse ?",
    options: [
      "Un panneau d'avertissement",
      "Un panneau d'interdiction",
      "Un panneau d'information",
    ],
    answer: "Un panneau d'interdiction",
    explanation:
        "Le panneau de limitation de vitesse est une interdiction de dépasser une certaine vitesse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la première chose à faire en cas de panne sur autoroute ?",
    options: [
      "Allumer les feux de détresse",
      "Quitter le véhicule",
      "Appeler une dépanneuse",
    ],
    answer: "Allumer les feux de détresse",
    explanation:
        "Il est crucial d'allumer les feux de détresse pour prévenir les autres conducteurs de la panne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que symbolise un feu orange clignotant ?",
    options: ["Avertissement", "Danger immédiat", "Passage interdit"],
    answer: "Avertissement",
    explanation:
        "Un feu orange clignotant est un avertissement qui requiert une vigilance accrue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel document faut-il présenter lors d'un contrôle routier ?",
    options: ["Permis de conduire", "Carte d'identité", "Passeport"],
    answer: "Permis de conduire",
    explanation:
        "Lors d'un contrôle routier, il est nécessaire de présenter son permis de conduire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Le port de la ceinture de sécurité est-il obligatoire en France ?",
    options: ["Oui", "Non", "Uniquement sur autoroute"],
    answer: "Oui",
    explanation:
        "Le port de la ceinture de sécurité est obligatoire pour tous les passagers en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact d'utiliser un téléphone au volant ?",
    options: [
      "Amélioration de la concentration",
      "Diminution de la vigilance",
      "Aucune conséquence",
    ],
    answer: "Diminution de la vigilance",
    explanation:
        "L'utilisation d'un téléphone au volant diminue la vigilance du conducteur, augmentant le risque d'accident.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert le contrôle technique des véhicules ?",
    options: [
      "Vérifier l'état technique",
      "Obliger à changer de véhicule",
      "Évaluer la valeur marchande",
    ],
    answer: "Vérifier l'état technique",
    explanation:
        "Le contrôle technique vise à vérifier l'état technique et la sécurité du véhicule.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal risque de conduire sans assurance ?",
    options: ["Amende", "Rapport à l'assurance", "Licenciement"],
    answer: "Amende",
    explanation:
        "Conduire sans assurance entraîne des amendes et des sanctions administratives.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment signaler un changement de direction sur la route ?",
    options: ["Avec le klaxon", "Avec les clignotants", "Avec le phare"],
    answer: "Avec les clignotants",
    explanation:
        "Les clignotants sont utilisés pour signaler un changement de direction aux autres conducteurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des lignes continues sur la route ?",
    options: [
      "Indiquer une voie réservée",
      "Interdire le dépassement",
      "Autoriser le stationnement",
    ],
    answer: "Interdire le dépassement",
    explanation:
        "Les lignes continues interdisent le dépassement pour assurer la sécurité des conducteurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'une priorité à droite ?",
    options: [
      "Obligation de s'arrêter",
      "Priorité à un véhicule venant à droite",
      "Passage libre",
    ],
    answer: "Priorité à un véhicule venant à droite",
    explanation:
        "La priorité à droite signifie qu'un véhicule venant de droite a la priorité sur les autres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le comportement à adopter en cas de brouillard ?",
    options: [
      "Rouler rapidement",
      "Utiliser les feux de croisement",
      "Allumer les feux de route",
    ],
    answer: "Utiliser les feux de croisement",
    explanation:
        "En cas de brouillard, il est recommandé d'utiliser les feux de croisement pour mieux voir et être vu.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but des panneaux de signalisation ?",
    options: [
      "À décorer les routes",
      "À informer et réguler le trafic",
      "À interdire l'accès",
    ],
    answer: "À informer et réguler le trafic",
    explanation:
        "Les panneaux de signalisation visent à informer les conducteurs et à réguler le trafic routier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le risque de dépasser un véhicule par la droite ?",
    options: ["Aucune conséquence", "Amende", "Accident"],
    answer: "Accident",
    explanation:
        "Dépasser par la droite est dangereux et peut entraîner des accidents.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau d'indication de cirque ?",
    options: ["Zone d'école", "Zone de danger", "Zone de divertissement"],
    answer: "Zone de divertissement",
    explanation:
        "Un panneau de cirque indique une zone où un événement de divertissement a lieu.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des feux stop ?",
    options: [
      "Prévenir un changement de direction",
      "Indiquer un arrêt",
      "Rendre le véhicule plus visible",
    ],
    answer: "Indiquer un arrêt",
    explanation:
        "Les feux stop signalent aux conducteurs derrière que le véhicule est en train de s'arrêter.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit faire un conducteur à un passage piéton ?",
    options: ["Accélérer", "S'arrêter", "Faire un demi-tour"],
    answer: "S'arrêter",
    explanation:
        "Le conducteur doit s'arrêter pour céder le passage aux piétons à un passage piéton.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel type de véhicule a des feux de gabarit ?",
    options: ["Les poids lourds", "Les voitures légères", "Les scooters"],
    answer: "Les poids lourds",
    explanation:
        "Les poids lourds sont équipés de feux de gabarit pour être mieux visibles sur la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but des ronds-points ?",
    options: [
      "Accélérer le trafic",
      "Faciliter le stationnement",
      "Réduire les accidents",
    ],
    answer: "Réduire les accidents",
    explanation:
        "Les ronds-points visent à réduire la vitesse et le risque d'accidents sur la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact de la vitesse sur la distance de freinage ?",
    options: ["Elle l'augmente", "Elle la diminue", "Elle ne l'affecte pas"],
    answer: "Elle l'augmente",
    explanation:
        "Une vitesse plus élevée augmente la distance de freinage nécessaire pour arrêter le véhicule.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le comportement à adopter en cas de verglas sur la route ?",
    options: ["Accélérer", "Rouler lentement", "Changer de voie rapidement"],
    answer: "Rouler lentement",
    explanation:
        "En cas de verglas, il est crucial de rouler lentement pour éviter de glisser.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel document atteste que le véhicule est en règle ?",
    options: [
      "Carte grise",
      "Certificat d'immatriculation",
      "Permis de conduire",
    ],
    answer: "Carte grise",
    explanation:
        "La carte grise atteste que le véhicule est immatriculé et en règle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la première cause d'accidents de la route en France ?",
    options: ["Vitesse", "Alcool", "Fatigue"],
    answer: "Vitesse",
    explanation:
        "La vitesse excessive est la première cause d'accidents de la route en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'une route prioritaire ?",
    options: [
      "Route avec des feux",
      "Route où l'on a la priorité",
      "Route sans circulation",
    ],
    answer: "Route où l'on a la priorité",
    explanation:
        "Une route prioritaire accorde la priorité de passage aux véhicules qui y circulent.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le temps de réaction moyen d'un conducteur en bonne santé ?",
    options: ["0,5 seconde", "1 seconde", "2 secondes"],
    answer: "1 seconde",
    explanation:
        "Le temps de réaction moyen d'un conducteur est d'environ 1 seconde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des feux de croisement ?",
    options: [
      "Éclairer la route de jour",
      "Éclairer la route la nuit",
      "Indiquer un arrêt",
    ],
    answer: "Éclairer la route la nuit",
    explanation:
        "Les feux de croisement sont utilisés pour éclairer la route la nuit sans éblouir les autres conducteurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le comportement à adopter lorsque l'on croise un véhicule d'urgence ?",
    options: ["Rouler au même rythme", "Se garer sur le bas-côté", "Accélérer"],
    answer: "Se garer sur le bas-côté",
    explanation:
        "Il est important de se garer sur le bas-côté pour laisser passer les véhicules d'urgence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif des zones 30 ?",
    options: [
      "Accélérer le trafic",
      "Réduire la vitesse",
      "Augmenter le nombre de voitures",
    ],
    answer: "Réduire la vitesse",
    explanation:
        "Les zones 30 visent à réduire la vitesse des véhicules pour protéger les piétons.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand doit-on utiliser les feux de détresse ?",
    options: ["Lors d'un arrêt d'urgence", "La nuit", "En cas de brouillard"],
    answer: "Lors d'un arrêt d'urgence",
    explanation:
        "Les feux de détresse doivent être utilisés pour signaler un arrêt d'urgence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'une voie de bus ?",
    options: [
      "Une voie réservée aux bus",
      "Une voie pour le stationnement",
      "Une sortie d'autoroute",
    ],
    answer: "Une voie réservée aux bus",
    explanation:
        "Une voie de bus est réservée exclusivement aux véhicules de transport en commun.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel matériel est requis pour passer un contrôle technique ?",
    options: [
      "Un gilet de sécurité",
      "Un triangle de signalisation",
      "Un extincteur",
    ],
    answer: "Un triangle de signalisation",
    explanation:
        "Le triangle de signalisation est requis pour être visible en cas de panne ou d'accident.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet de la pluie sur l'adhérence des pneus ?",
    options: ["Amélioration", "Diminution", "Aucune influence"],
    answer: "Diminution",
    explanation:
        "L'humidité réduit l'adhérence des pneus sur la route, augmentant le risque de glissade.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'un point de permis ?",
    options: [
      "Un point en faveur du conducteur",
      "Un retrait de points pour infractions",
      "Un bonus pour conduite prudente",
    ],
    answer: "Un retrait de points pour infractions",
    explanation:
        "Un point de permis est un retrait de points sur le permis en cas d'infraction au code de la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact d'un pneu sous-gonflé ?",
    options: [
      "Amélioration de la consommation",
      "Augmentation de l'usure",
      "Aucune conséquence",
    ],
    answer: "Augmentation de l'usure",
    explanation:
        "Un pneu sous-gonflé augmente l'usure et diminue la sécurité en conduite.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que doit faire un conducteur en cas d'accident avec dégât matériel ?",
    options: [
      "Échanger les informations",
      "Attendre la police",
      "Continuer à rouler",
    ],
    answer: "Échanger les informations",
    explanation:
        "Il est important d'échanger les informations avec l'autre conducteur en cas d'accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet d'une conduite agressive ?",
    options: [
      "Réduction de la consommation",
      "Augmentation des accidents",
      "Amélioration des temps de trajet",
    ],
    answer: "Augmentation des accidents",
    explanation:
        "Une conduite agressive augmente le risque d'accidents sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des voies réservées ?",
    options: [
      "Améliorer le passage",
      "Diminuer la vitesse",
      "Accumuler des véhicules",
    ],
    answer: "Améliorer le passage",
    explanation:
        "Les voies réservées permettent un passage fluide pour certains véhicules comme les bus.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal objectif des panneaux de signalisation ?",
    options: [
      "Réguler la circulation",
      "Décorer les routes",
      "Indiquer les lieux touristiques",
    ],
    answer: "Réguler la circulation",
    explanation:
        "Les panneaux de signalisation sont essentiels pour guider et réglementer le comportement des conducteurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la limitation de vitesse en agglomération en France ?",
    options: ["50 km/h", "30 km/h", "70 km/h"],
    answer: "50 km/h",
    explanation:
        "La vitesse maximale autorisée en agglomération est généralement fixée à 50 km/h.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un feu rouge ?",
    options: ["S'arrêter", "Aller", "Ralentir"],
    answer: "S'arrêter",
    explanation:
        "Le feu rouge indique aux conducteurs de s'arrêter pour garantir la sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel équipement est obligatoire pour les conducteurs de deux-roues ?",
    options: ["Gants", "Casque", "Lunettes de soleil"],
    answer: "Casque",
    explanation:
        "Le port du casque est obligatoire pour assurer la sécurité des motards.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des lignes d'arrêt au feu rouge ?",
    options: [
      "Indiquer un arrêt obligatoire",
      "Décorer la chaussée",
      "Séparer les voies",
    ],
    answer: "Indiquer un arrêt obligatoire",
    explanation:
        "Les lignes d'arrêt indiquent où les véhicules doivent s'arrêter au feu rouge.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la distance de sécurité recommandée entre deux véhicules sur autoroute ?",
    options: ["1 seconde", "2 secondes", "3 secondes"],
    answer: "2 secondes",
    explanation:
        "Il est recommandé de garder une distance de deux secondes pour permettre un freinage sécurisé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'un alcootest ?",
    options: [
      "Un appareil de mesure de vitesse",
      "Un appareil de mesure d'alcool",
      "Un appareil de mesure de pollution",
    ],
    answer: "Un appareil de mesure d'alcool",
    explanation:
        "L'alcootest est utilisé pour mesurer le taux d'alcool dans le sang des conducteurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit faire un conducteur lorsqu'un piéton traverse ?",
    options: ["Accélérer", "Ralentir et céder le passage", "Klaxonner"],
    answer: "Ralentir et céder le passage",
    explanation:
        "Les conducteurs doivent toujours céder le passage aux piétons sur un passage clouté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet d'une conduite sous l'emprise de l'alcool ?",
    options: [
      "Amélioration des réflexes",
      "Aucune influence",
      "Diminution des réflexes",
    ],
    answer: "Diminution des réflexes",
    explanation:
        "L'alcool altère les capacités de réaction et de jugement des conducteurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal risque d'une conduite en excès de vitesse ?",
    options: [
      "Augmentation du confort",
      "Réduction des distances",
      "Augmentation des accidents",
    ],
    answer: "Augmentation des accidents",
    explanation:
        "La vitesse excessive est l'une des principales causes d'accidents de la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la sanction pour un taux d'alcoolémie supérieur à la limite autorisée ?",
    options: ["Avertissement", "Amende et retrait de points", "Rien"],
    answer: "Amende et retrait de points",
    explanation:
        "Conduire avec un taux d'alcoolémie élevé entraîne des amendes et un retrait de points de permis.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des gendarmes sur la route ?",
    options: [
      "Surveiller le trafic",
      "Rédiger des articles",
      "Distribuer des flyers",
    ],
    answer: "Surveiller le trafic",
    explanation:
        "Les gendarmes sont responsables de la sécurité routière et du respect des règles de circulation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le risque principal de ne pas porter de ceinture de sécurité ?",
    options: [
      "Aucun risque",
      "Augmentation des blessures en cas d'accident",
      "Confort accru",
    ],
    answer: "Augmentation des blessures en cas d'accident",
    explanation:
        "Ne pas porter de ceinture de sécurité augmente considérablement le risque de blessures graves en cas d'accident.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but des zones 30 ?",
    options: [
      "Accélérer le trafic",
      "Réduire la vitesse",
      "Augmenter le nombre de voitures",
    ],
    answer: "Réduire la vitesse",
    explanation:
        "Les zones 30 sont conçues pour diminuer la vitesse des véhicules et améliorer la sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact de l'utilisation du téléphone au volant ?",
    options: [
      "Aucun impact",
      "Diminution de l'attention",
      "Augmentation de la vigilance",
    ],
    answer: "Diminution de l'attention",
    explanation:
        "Utiliser un téléphone au volant distrait et réduit l'attention du conducteur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le poids maximum autorisé pour une remorque ?",
    options: ["500 kg", "750 kg", "1000 kg"],
    answer: "750 kg",
    explanation:
        "La norme fixe le poids maximum d'une remorque à 750 kg sans permis additionnel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Une route à double sens est indiquée par quel panneau ?",
    options: [
      "Panneau de sens unique",
      "Panneau de route à double sens",
      "Panneau de voie de circulation alternée",
    ],
    answer: "Panneau de route à double sens",
    explanation:
        "Le panneau de route à double sens informe les conducteurs qu'ils partagent la route dans les deux directions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le comportement à adopter en cas de coupure de la route par un véhicule d'urgence ?",
    options: [
      "Continuer à rouler",
      "Céder le passage",
      "Accélérer pour passer avant le véhicule",
    ],
    answer: "Céder le passage",
    explanation:
        "Il est crucial de céder le passage aux véhicules d'urgence pour garantir leur intervention rapide.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des ronds-points ?",
    options: [
      "Accélérer le trafic",
      "Ralentir le trafic",
      "Faciliter les changements de direction",
    ],
    answer: "Faciliter les changements de direction",
    explanation:
        "Les ronds-points permettent de gérer plus efficacement les intersections en réduisant les arrêts.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel type de permis est nécessaire pour conduire un poids lourd ?",
    options: ["Permis B", "Permis C", "Permis D"],
    answer: "Permis C",
    explanation:
        "Le permis C est requis pour conduire des véhicules lourds transportant des marchandises.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel élément est essentiel à vérifier avant de prendre la route ?",
    options: [
      "Le niveau d'essence",
      "La propreté du véhicule",
      "Le bon fonctionnement des freins",
    ],
    answer: "Le bon fonctionnement des freins",
    explanation:
        "Vérifier les freins est crucial pour garantir la sécurité du conducteur et des passagers.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel comportement est à adopter en cas de fatigue au volant ?",
    options: [
      "Prendre un café et continuer",
      "Écouter de la musique",
      "S'arrêter et se reposer",
    ],
    answer: "S'arrêter et se reposer",
    explanation:
        "Il est impératif de s'arrêter et de se reposer pour éviter un endormissement au volant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Les enfants de moins de 10 ans doivent être placés dans quoi dans un véhicule ?",
    options: ["Siège auto", "Chaise normale", "En avant"],
    answer: "Siège auto",
    explanation:
        "Les sièges auto sont obligatoires pour sécuriser les enfants lors des trajets en voiture.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel panneau indique une voie réservée aux bus ?",
    options: [
      "Panneau de bus",
      "Panneau d'interdiction",
      "Panneau d'accès aux véhicules",
    ],
    answer: "Panneau de bus",
    explanation:
        "Le panneau de bus signale une voie réservée à la circulation des autobus.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand devons-nous utiliser les feux de croisement ?",
    options: [
      "La nuit uniquement",
      "En pleine lumière",
      "Par temps de faible visibilité",
    ],
    answer: "Par temps de faible visibilité",
    explanation:
        "Les feux de croisement doivent être allumés en cas de faible visibilité, comme la pluie ou le brouillard.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet d'une conduite sous l'emprise de stupéfiants ?",
    options: [
      "Amélioration des réflexes",
      "Aucune influence",
      "Diminution de la concentration",
    ],
    answer: "Diminution de la concentration",
    explanation:
        "Les stupéfiants altèrent gravement les capacités cognitives et la concentration des conducteurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie une flèche verte clignotante ?",
    options: [
      "Passez sans s'arrêter",
      "Indication de priorité",
      "Autorisation de tourner",
    ],
    answer: "Autorisation de tourner",
    explanation:
        "Une flèche verte clignotante indique aux conducteurs qu'ils peuvent tourner dans la direction indiquée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel document doit toujours être présent dans un véhicule ?",
    options: ["La carte grise", "Le manuel d'instruction", "Le livre de bord"],
    answer: "La carte grise",
    explanation:
        "La carte grise est obligatoire pour prouver la propriété et l'immatriculation du véhicule.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel comportement est à éviter lors d'un dépassement ?",
    options: [
      "Vérifier les rétroviseurs",
      "Utiliser les clignotants",
      "Accélérer soudainement",
    ],
    answer: "Accélérer soudainement",
    explanation:
        "Accélérer soudainement peut être dangereux et causer des accidents lors d'un dépassement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la priorité de passage aux intersections ?",
    options: [
      "Les véhicules à gauche",
      "Les véhicules à droite",
      "Les piétons",
    ],
    answer: "Les véhicules à droite",
    explanation:
        "La priorité est donnée aux véhicules venant de la droite, sauf indication contraire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'impact de la vitesse excessive sur les distances de freinage ?",
    options: [
      "Aucun impact",
      "Augmentation des distances de freinage",
      "Diminution des distances de freinage",
    ],
    answer: "Augmentation des distances de freinage",
    explanation:
        "La vitesse élevée accroît significativement les distances nécessaires pour s'arrêter.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la première chose à faire en cas d'accident ?",
    options: ["Appeler les secours", "Prendre des photos", "Quitter les lieux"],
    answer: "Appeler les secours",
    explanation:
        "Il est crucial de signaler l'accident aux services d'urgence pour obtenir de l'aide.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit faire un conducteur en cas de brouillard épais ?",
    options: [
      "Éteindre les feux",
      "Utiliser les feux de croisement",
      "Augmenter la vitesse",
    ],
    answer: "Utiliser les feux de croisement",
    explanation:
        "Les feux de croisement améliorent la visibilité et le signalement du véhicule en cas de brouillard.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but des feux de détresse ?",
    options: [
      "Avertir d'un danger",
      "Éclairer la route",
      "Aider au stationnement",
    ],
    answer: "Avertir d'un danger",
    explanation:
        "Les feux de détresse signalent aux autres conducteurs qu'il y a un danger ou un incident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la distance minimale à respecter lors d'un dépassement ?",
    options: ["1 mètre", "2 mètres", "Un mètre et demi"],
    answer: "Un mètre et demi",
    explanation:
        "Il est recommandé de respecter une distance d'au moins un mètre et demi lors d'un dépassement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert un triangle de pré-signalisation ?",
    options: [
      "À indiquer un ralentissement",
      "À signaler un arrêt d'urgence",
      "À indiquer une direction",
    ],
    answer: "À signaler un arrêt d'urgence",
    explanation:
        "Le triangle de pré-signalisation alerte les autres conducteurs d'un arrêt d'urgence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Qu'est-ce qu'un conducteur doit faire avant de changer de voie ?",
    options: [
      "Utiliser son klaxon",
      "Regarder dans ses rétroviseurs",
      "Accélérer",
    ],
    answer: "Regarder dans ses rétroviseurs",
    explanation:
        "Il est essentiel de vérifier les rétroviseurs avant de changer de voie pour éviter des accidents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le meilleur moment pour faire un contrôle technique ?",
    options: [
      "Tout moment",
      "Quand le véhicule est neuf",
      "Avant la date d'échéance",
    ],
    answer: "Avant la date d'échéance",
    explanation:
        "Il est recommandé de faire le contrôle technique avant la date d'échéance pour éviter des amendes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie une ligne continue sur la route ?",
    options: ["Dépassement autorisé", "Dépassement interdit", "Voie réservée"],
    answer: "Dépassement interdit",
    explanation: "Une ligne continue indique qu'il est interdit de dépasser.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal danger des conduites en état d'ivresse ?",
    options: [
      "Amélioration des réflexes",
      "Diminution des capacités de conduite",
      "Aucune influence",
    ],
    answer: "Diminution des capacités de conduite",
    explanation:
        "La conduite sous l'ivresse réduit considérablement les réflexes et le jugement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que doit faire un conducteur en approchant d'un passage à niveau ?",
    options: ["Ignorer les signaux", "Accélérer", "Ralentir et observer"],
    answer: "Ralentir et observer",
    explanation:
        "Il est crucial de ralentir et de vérifier la voie avant de traverser un passage à niveau.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le meilleur moyen de réduire les accidents de la route ?",
    options: [
      "Augmenter la vitesse",
      "Éduquer les conducteurs",
      "Ignorer les règles",
    ],
    answer: "Éduquer les conducteurs",
    explanation:
        "L'éducation des conducteurs sur la sécurité routière est essentielle pour réduire les accidents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quel âge peut-on passer le permis de conduire en France ?",
    options: ["17 ans", "21 ans", "16 ans"],
    answer: "17 ans",
    explanation:
        "L'âge minimum pour passer le permis de conduire en France est de 17 ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des dépistages d'alcoolémie sur les routes ?",
    options: [
      "Évaluer la vitesse",
      "Prévenir l'alcool au volant",
      "Améliorer la circulation",
    ],
    answer: "Prévenir l'alcool au volant",
    explanation:
        "Les dépistages d'alcoolémie visent à dissuader et à prévenir la conduite en état d'ivresse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel comportement est à adopter face à un véhicule de secours en intervention ?",
    options: [
      "Rouler normalement",
      "S'arrêter sur le côté",
      "Accélérer pour passer",
    ],
    answer: "S'arrêter sur le côté",
    explanation:
        "Il est essentiel de s'arrêter sur le côté pour laisser passer les véhicules de secours.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'un devoir de vigilance pour un conducteur ?",
    options: [
      "Éviter les distractions",
      "Avoir un passager",
      "Écouter de la musique",
    ],
    answer: "Éviter les distractions",
    explanation:
        "Le devoir de vigilance impose au conducteur d'être attentif et de ne pas se laisser distraire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel panneau indique une zone scolaire ?",
    options: [
      "Panneau de vitesse",
      "Panneau d'école",
      "Panneau d'interdiction",
    ],
    answer: "Panneau d'école",
    explanation:
        "Le panneau d'école avertit les conducteurs de la présence d'une zone scolaire et d'enfants.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal objectif des radars automatiques ?",
    options: [
      "Surveiller le trafic",
      "Sanctionner les excès de vitesse",
      "Améliorer les routes",
    ],
    answer: "Sanctionner les excès de vitesse",
    explanation:
        "Les radars automatiques sont installés pour détecter et sanctionner les excès de vitesse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel principe s'applique aux intersections ?",
    options: [
      "La priorité à droite",
      "La priorité à gauche",
      "La priorité aux piétons",
    ],
    answer: "La priorité à droite",
    explanation:
        "La règle de priorité à droite s'applique généralement aux intersections, sauf signalisation contraire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal objectif des panneaux de signalisation ?",
    options: [
      "Informer les usagers",
      "Beautifier les routes",
      "Augmenter la vitesse",
    ],
    answer: "Informer les usagers",
    explanation:
        "Les panneaux de signalisation ont pour but d'informer les usagers sur les règles et dangers de la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un feu rouge au feu de circulation ?",
    options: ["S'arrêter", "Continuer", "Ralentir"],
    answer: "S'arrêter",
    explanation:
        "Un feu rouge indique aux véhicules de s'arrêter pour laisser passer les autres usagers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la limite de vitesse en agglomération en France ?",
    options: ["30 km/h", "50 km/h", "70 km/h"],
    answer: "50 km/h",
    explanation:
        "La vitesse maximale autorisée en agglomération est généralement fixée à 50 km/h.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le rôle d'un gendarme en matière de sécurité routière ?",
    options: [
      "Rédiger des contraventions",
      "Donner des conseils de conduite",
      "Assurer un service de taxi",
    ],
    answer: "Rédiger des contraventions",
    explanation:
        "Les gendarmes peuvent dresser des contraventions pour infractions au code de la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire en cas d'accident matériel sans blessé ?",
    options: [
      "Échanger les coordonnées",
      "Déplacer les véhicules",
      "Appeler la police",
    ],
    answer: "Échanger les coordonnées",
    explanation:
        "Il est important d'échanger les informations entre les conducteurs impliqués dans l'accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel équipement est indispensable pour conduire un deux-roues motorisé ?",
    options: ["Gants de protection", "Casque", "Lunettes de soleil"],
    answer: "Casque",
    explanation:
        "Le port du casque est obligatoire pour assurer la sécurité du conducteur de deux-roues motorisés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'une priorité à droite ?",
    options: [
      "Laisser passer les véhicules venant de la droite",
      "Accélérer à droite",
      "S'arrêter à droite",
    ],
    answer: "Laisser passer les véhicules venant de la droite",
    explanation:
        "La priorité à droite signifie que l'on doit céder le passage aux véhicules arrivant de la droite.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le taux d'alcoolémie maximum autorisé pour un conducteur en France ?",
    options: ["0.2 g/L", "0.5 g/L", "0.8 g/L"],
    answer: "0.5 g/L",
    explanation:
        "Le taux d'alcoolémie maximum autorisé pour un conducteur est de 0.5 g/L de sang.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau de signalisation triangulaire rouge ?",
    options: ["Avertissement", "Interdiction", "Obligation"],
    answer: "Avertissement",
    explanation:
        "Un panneau triangulaire rouge avertit les usagers d'un danger à proximité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel type de véhicule doit respecter des distances de sécurité accrues ?",
    options: ["Voiture", "Camion", "Moto"],
    answer: "Camion",
    explanation:
        "Les camions doivent respecter des distances de sécurité plus grandes en raison de leur inertie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'effet principal de la vitesse excessive sur la sécurité routière ?",
    options: [
      "Ralentir les réactions",
      "Augmenter le temps de réaction",
      "Réduire le temps de réaction",
    ],
    answer: "Réduire le temps de réaction",
    explanation:
        "La vitesse excessive réduit le temps disponible pour réagir aux situations d'urgence.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand peut-on utiliser les feux de route ?",
    options: [
      "Dans les tunnels",
      "Sur les routes bien éclairées",
      "Sur les routes non éclairées",
    ],
    answer: "Sur les routes non éclairées",
    explanation:
        "Les feux de route doivent être utilisés sur des routes mal éclairées pour améliorer la visibilité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact du port de la ceinture de sécurité ?",
    options: [
      "Réduire les blessures",
      "Augmenter la vitesse",
      "Modifier le comportement de conduite",
    ],
    answer: "Réduire les blessures",
    explanation:
        "Le port de la ceinture de sécurité réduit le risque de blessures graves lors d'un accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'objectif principal des contrôles de police sur la route ?",
    options: [
      "Recueillir des preuves",
      "Assurer la sécurité routière",
      "Distribuer des brochures",
    ],
    answer: "Assurer la sécurité routière",
    explanation:
        "Les contrôles de police visent principalement à garantir la sécurité des usagers de la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle du système de freinage ABS ?",
    options: [
      "Augmenter la vitesse",
      "Éviter le blocage des roues",
      "Réduire le bruit",
    ],
    answer: "Éviter le blocage des roues",
    explanation:
        "Le système ABS empêche le blocage des roues pendant un freinage d'urgence, permettant de garder le contrôle du véhicule.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que faire en cas de panne sur autoroute ?",
    options: ["Rester dans le véhicule", "Changer de roue", "Appeler un ami"],
    answer: "Rester dans le véhicule",
    explanation:
        "Il est recommandé de rester dans le véhicule et d'allumer les feux de détresse en cas de panne sur autoroute.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'une voie réservée ?",
    options: [
      "Voie pour véhicules lents",
      "Voie pour bus",
      "Voie pour piétons",
    ],
    answer: "Voie pour bus",
    explanation:
        "Une voie réservée est spécifiquement dédiée à un type de véhicule, comme les bus.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal risque d'utiliser un téléphone au volant ?",
    options: [
      "Augmenter le stress",
      "Distraire le conducteur",
      "Réduire la concentration",
    ],
    answer: "Distraire le conducteur",
    explanation:
        "L'utilisation d'un téléphone au volant distrait le conducteur et augmente le risque d'accident.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel type de feu indique une intersection avec priorité ?",
    options: ["Feu orange", "Feu rouge", "Feu vert"],
    answer: "Feu vert",
    explanation:
        "Un feu vert signifie que les véhicules peuvent passer à l'intersection sans s'arrêter.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel comportement est dangereux lors de la conduite ?",
    options: [
      "Respecter les distances de sécurité",
      "Ralentir aux passages piétons",
      "Doubler sans visibilité",
    ],
    answer: "Doubler sans visibilité",
    explanation:
        "Doubler sans visibilité constitue un comportement dangereux qui peut entraîner des accidents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif de la limitation de vitesse ?",
    options: [
      "Améliorer la fluidité du trafic",
      "Diminuer le bruit",
      "Assurer la sécurité des usagers",
    ],
    answer: "Assurer la sécurité des usagers",
    explanation:
        "La limitation de vitesse vise à protéger la sécurité des usagers de la route contre les accidents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle couleur de feu indique qu'un véhicule doit céder le passage ?",
    options: ["Feu vert", "Feu orange", "Feu rouge"],
    answer: "Feu rouge",
    explanation:
        "Un feu rouge indique que le véhicule doit céder le passage et s'arrêter.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'effet des conditions météorologiques sur la conduite ?",
    options: ["Augmenter la vitesse", "Réduire l'adhérence", "Aucun effet"],
    answer: "Réduire l'adhérence",
    explanation:
        "Les conditions météorologiques peuvent réduire l'adhérence des pneus sur la route et rendre la conduite dangereuse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment signaler un changement de direction ?",
    options: ["Avec le klaxon", "Avec un clignotant", "En levant la main"],
    answer: "Avec un clignotant",
    explanation:
        "Les clignotants sont utilisés pour signaler aux autres usagers un changement de direction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel véhicule doit utiliser des chaînes à neige ?",
    options: ["Voiture de tourisme", "Camion", "Véhicule tout terrain"],
    answer: "Camion",
    explanation:
        "Les camions doivent utiliser des chaînes à neige dans des conditions de neige pour assurer leur traction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la signification d'un panneau de vitesse limitée à 30 km/h ?",
    options: ["Zone scolaire", "Route nationale", "Accès interdit"],
    answer: "Zone scolaire",
    explanation:
        "Un panneau de 30 km/h indique souvent un secteur à risque, comme une zone scolaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Pourquoi est-il important de respecter les distances de sécurité ?",
    options: [
      "Pour éviter les embouteillages",
      "Pour garantir des temps de trajet plus courts",
      "Pour éviter les collisions",
    ],
    answer: "Pour éviter les collisions",
    explanation:
        "Respecter les distances de sécurité permet d'avoir suffisamment de temps pour réagir en cas de freinage brusque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment une personne peut-elle être désignée comme piéton ?",
    options: [
      "En marchant sur la route",
      "En utilisant un vélo",
      "En traversant la route à pied",
    ],
    answer: "En traversant la route à pied",
    explanation:
        "Un piéton est défini comme une personne se déplaçant à pied sur la voie publique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des ronds-points ?",
    options: [
      "Faciliter le passage",
      "Obliger à s'arrêter",
      "Ralentir le trafic",
    ],
    answer: "Faciliter le passage",
    explanation:
        "Les ronds-points permettent de fluidifier le trafic en réduisant les arrêts aux intersections.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la couleur des panneaux d'interdiction ?",
    options: ["Rouge", "Bleu", "Vert"],
    answer: "Rouge",
    explanation:
        "Les panneaux d'interdiction sont généralement de couleur rouge pour signaler une interdiction claire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel comportement est attendu au passage piéton ?",
    options: [
      "Accélérer",
      "S'arrêter pour laisser passer",
      "Doubler les piétons",
    ],
    answer: "S'arrêter pour laisser passer",
    explanation:
        "Les conducteurs doivent s'arrêter pour laisser passer les piétons aux passages piétons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la sanction pour conduite sans permis ?",
    options: ["Avertissement", "Amende", "Interdiction de circulation"],
    answer: "Amende",
    explanation: "La conduite sans permis est punie par une amende en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel document est obligatoire de présenter lors d'un contrôle routier ?",
    options: [
      "Certificat d'immatriculation",
      "Facture d'assurance",
      "Permis de construire",
    ],
    answer: "Certificat d'immatriculation",
    explanation:
        "Le certificat d'immatriculation doit être présenté aux forces de l'ordre lors d'un contrôle routier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal risque encouru par un conducteur de vitesse excessive ?",
    options: ["Avoir un accident", "Perdre son permis", "Se faire verbaliser"],
    answer: "Avoir un accident",
    explanation:
        "La vitesse excessive augmente considérablement le risque d'accident sur la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire avant de changer de voie ?",
    options: ["Regarder dans le rétroviseur", "Accélérer", "Buzzer le klaxon"],
    answer: "Regarder dans le rétroviseur",
    explanation:
        "Il est essentiel de vérifier les rétroviseurs avant de changer de voie pour assurer la sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel type de panneaux est utilisé pour les informations temporaires ?",
    options: [
      "Panneaux lumineux",
      "Panneaux de direction",
      "Panneaux de construction",
    ],
    answer: "Panneaux lumineux",
    explanation:
        "Les panneaux lumineux sont souvent utilisés pour signaler des informations temporaires comme des travaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'intérêt d'utiliser les feux de croisements ?",
    options: [
      "Pour signaler aux autres véhicules",
      "Pour mieux voir la route",
      "Pour réduire la consommation de carburant",
    ],
    answer: "Pour mieux voir la route",
    explanation:
        "Les feux de croisements améliorent la visibilité du conducteur dans des conditions de faible luminosité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment un piéton doit-il traverser la route ?",
    options: ["En courant", "Sous un feu vert", "Au passage piéton"],
    answer: "Au passage piéton",
    explanation:
        "Les piétons doivent traverser au passage piéton pour garantir leur sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'effet de l'usage de la ceinture de sécurité en cas d'accident ?",
    options: [
      "Augmente les blessures",
      "Diminue les chances de survie",
      "Réduit la gravité des blessures",
    ],
    answer: "Réduit la gravité des blessures",
    explanation:
        "La ceinture de sécurité réduit la gravité des blessures en maintenant le conducteur en place lors d'un choc.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel type de permis est requis pour conduire un véhicule léger ?",
    options: ["Permis B", "Permis A", "Permis C"],
    answer: "Permis B",
    explanation:
        "Le permis B est nécessaire pour conduire des véhicules légers en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel appareil peut aider à améliorer la sécurité routière ?",
    options: ["Système GPS", "Téléphone portable", "Radio"],
    answer: "Système GPS",
    explanation:
        "Le système GPS aide à la navigation et permet d'éviter les routes dangereuses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que représente une ligne continue sur la route ?",
    options: [
      "Une zone de dépassement",
      "Une interdiction de dépasser",
      "Une voie réservée",
    ],
    answer: "Une interdiction de dépasser",
    explanation:
        "Une ligne continue indique qu'il est interdit de dépasser sur cette section de route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but des zones de circulation apaisée ?",
    options: [
      "Augmenter la vitesse",
      "Réduire le bruit",
      "Favoriser la sécurité des piétons",
    ],
    answer: "Favoriser la sécurité des piétons",
    explanation:
        "Les zones de circulation apaisée visent à protéger les piétons et rendre la circulation plus sûre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que faut-il faire lorsqu'un véhicule d'urgence approche ?",
    options: [
      "Accélérer pour le laisser passer",
      "S'arrêter sur le bas-côté",
      "Continuer comme si de rien n'était",
    ],
    answer: "S'arrêter sur le bas-côté",
    explanation:
        "Les conducteurs doivent s'arrêter sur le bas-côté pour laisser passer un véhicule d'urgence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Pourquoi est-il crucial de ne pas conduire sous l'emprise de drogues ?",
    options: [
      "Pour réduire le stress",
      "Pour respecter les lois",
      "Pour garantir la sécurité sur la route",
    ],
    answer: "Pour garantir la sécurité sur la route",
    explanation:
        "Conduire sous l'emprise de drogues compromet gravement la sécurité des usagers de la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la conséquence d'un refus d'obtempérer ?",
    options: ["Amende", "Sanction pénale", "Avertissement"],
    answer: "Sanction pénale",
    explanation:
        "Un refus d'obtempérer peut entraîner des sanctions pénales significatives pour le conducteur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Dans quel cas un cycliste doit-il porter un casque ?",
    options: [
      "En toute circonstance",
      "Uniquement dans les zones urbaines",
      "Jamais",
    ],
    answer: "En toute circonstance",
    explanation:
        "Les cyclistes sont tenus de porter un casque en toute circonstance pour leur sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but d'une campagne de sécurité routière ?",
    options: [
      "Promouvoir les nouveaux véhicules",
      "Informer sur les règles de conduite",
      "Organiser des courses de rue",
    ],
    answer: "Informer sur les règles de conduite",
    explanation:
        "Les campagnes de sécurité routière visent à sensibiliser les usagers aux règles de conduite et à la sécurité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand doit-on utiliser les feux de brouillard arrière ?",
    options: [
      "En cas de brouillard épais",
      "La nuit",
      "Lorsque l'on a des passagers",
    ],
    answer: "En cas de brouillard épais",
    explanation:
        "Les feux de brouillard arrière doivent être utilisés uniquement en cas de brouillard épais pour améliorer la visibilité.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal but du code de la route ?",
    options: [
      "Assurer la sécurité des usagers",
      "Réduire la pollution",
      "Améliorer les infrastructures",
    ],
    answer: "Assurer la sécurité des usagers",
    explanation:
        "Le code de la route vise à protéger les usagers en régissant leur comportement sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un feu rouge ?",
    options: ["Stopper son véhicule", "Accélérer", "Ralentir"],
    answer: "Stopper son véhicule",
    explanation:
        "Le feu rouge indique aux conducteurs de s'arrêter avant la ligne d'arrêt.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que représente un panneau avec un triangle rouge et un point d'exclamation à l'intérieur ?",
    options: ["Avertissement", "Danger", "Interdiction"],
    answer: "Avertissement",
    explanation:
        "Ce panneau indique un danger potentiel sur la route, attirant l'attention des conducteurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment réagir en cas d'accident matériel sans blessé ?",
    options: [
      "Déplacer les véhicules",
      "Appeler la police",
      "Rester sur place jusqu'à l'arrivée des secours",
    ],
    answer: "Appeler la police",
    explanation:
        "Il est important d'informer les autorités pour établir un constat des faits en cas d'accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'usage principal des ceintures de sécurité ?",
    options: [
      "Confort du passager",
      "Protection en cas de collision",
      "Économie de carburant",
    ],
    answer: "Protection en cas de collision",
    explanation:
        "Les ceintures de sécurité protègent les occupants du véhicule en cas d'accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le symbole d'un stop ?",
    options: ["Un triangle", "Un octogone", "Un carré"],
    answer: "Un octogone",
    explanation:
        "Le panneau stop est représenté par un octogone rouge, indiquant l'arrêt obligatoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle distance de sécurité doit-on respecter derrière un véhicule sur autoroute ?",
    options: ["1 seconde", "2 secondes", "3 secondes"],
    answer: "2 secondes",
    explanation:
        "Il est recommandé de maintenir une distance de 2 secondes avec le véhicule qui vous précède.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet du téléphone au volant ?",
    options: [
      "Améliore la concentration",
      "N'a aucun impact",
      "Diminue l'attention",
    ],
    answer: "Diminue l'attention",
    explanation:
        "L'utilisation du téléphone au volant réduit significativement la concentration du conducteur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'un gendarme ou policier sur la route ?",
    options: [
      "Contrôler la vitesse",
      "Vendre des contraventions",
      "Prendre des photos",
    ],
    answer: "Contrôler la vitesse",
    explanation:
        "Les forces de l'ordre sont responsables de veiller au respect des lois de circulation, dont la vitesse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau de limitation de vitesse ?",
    options: [
      "Indication de vitesse à ne pas dépasser",
      "Vitesse recommandée",
      "Vitesse minimale",
    ],
    answer: "Indication de vitesse à ne pas dépasser",
    explanation:
        "Un panneau de limitation de vitesse impose une vitesse maximale que les véhicules doivent respecter.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel comportement est interdit lors des rond-points ?",
    options: ["Céder le passage", "Doubler un autre véhicule", "Ralentir"],
    answer: "Doubler un autre véhicule",
    explanation:
        "Il est dangereux et interdit de doubler à l'intérieur d'un rond-point en raison des manœuvres des autres usagers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand doit-on utiliser les feux de croisement ?",
    options: ["La nuit seulement", "En cas de faible visibilité", "Jamais"],
    answer: "En cas de faible visibilité",
    explanation:
        "Les feux de croisement doivent être allumés lorsque la visibilité est réduite, de jour comme de nuit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qui est le plus dangereux sur la route ?",
    options: [
      "Conduite distraite",
      "Conduite défensive",
      "Conduite avec passagers",
    ],
    answer: "Conduite distraite",
    explanation:
        "La conduite distraite est l'une des principales causes d'accidents de la route, car elle réduit la vigilance du conducteur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif des zones 30 en ville ?",
    options: [
      "Accélérer le trafic",
      "Protéger les piétons",
      "Augmenter les frais de stationnement",
    ],
    answer: "Protéger les piétons",
    explanation:
        "Les zones 30 limitent la vitesse pour garantir la sécurité des piétons et réduire les accidents.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le premier geste à adopter en cas de panne sur autoroute ?",
    options: [
      "Déplacer le véhicule sur la bande d'arrêt d'urgence",
      "Allumer les feux de détresse",
      "Sortir du véhicule",
    ],
    answer: "Allumer les feux de détresse",
    explanation:
        "Allumer les feux de détresse avertit les autres conducteurs de votre situation d'urgence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la signification d'un panneau de ralentissement ?",
    options: [
      "Accélérer en toute sécurité",
      "Ralentir à cause d'un danger",
      "Pas de limitation de vitesse",
    ],
    answer: "Ralentir à cause d'un danger",
    explanation:
        "Un panneau de ralentissement indique aux conducteurs de diminuer leur vitesse en raison d'un danger imminent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'âge minimum pour conduire un véhicule léger en France ?",
    options: ["16 ans", "17 ans", "21 ans"],
    answer: "17 ans",
    explanation:
        "L'âge minimum requis pour obtenir un permis de conduire pour un véhicule léger est de 17 ans.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la priorité des piétons à un passage piéton ?",
    options: [
      "Aucune priorité",
      "Priorité de passage",
      "Priorité en dehors du passage",
    ],
    answer: "Priorité de passage",
    explanation:
        "Les piétons bénéficient d'une priorité au passage piéton afin de garantir leur sécurité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit faire un conducteur avant de changer de voie ?",
    options: ["Vérifier les rétroviseurs", "Accélérer", "Utiliser le klaxon"],
    answer: "Vérifier les rétroviseurs",
    explanation:
        "Il est crucial de vérifier les rétroviseurs pour s'assurer qu'il n'y a pas d'autres véhicules dans la zone de changement de voie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Pourquoi est-il important d'utiliser les clignotants ?",
    options: [
      "Pour signaler une intention",
      "Pour décorer la voiture",
      "Pour rendre le véhicule plus rapide",
    ],
    answer: "Pour signaler une intention",
    explanation:
        "Les clignotants informent les autres usagers de la route des manœuvres prévues par le conducteur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la distance minimale à respecter pour le stationnement à un feu ?",
    options: ["5 mètres", "3 mètres", "10 mètres"],
    answer: "5 mètres",
    explanation:
        "Il est interdit de stationner à moins de 5 mètres d'un feu pour assurer la visibilité des signaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le plus grand risque d'utiliser un véhicule sans ceinture de sécurité ?",
    options: ["Amende", "Blessures graves en cas d'accident", "Perte de temps"],
    answer: "Blessures graves en cas d'accident",
    explanation:
        "Ne pas porter la ceinture de sécurité augmente considérablement le risque de blessures graves en cas d'accident.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment se nomme le document nécessaire pour conduire ?",
    options: ["Permis de conduire", "Carte grise", "Assurance"],
    answer: "Permis de conduire",
    explanation:
        "Le permis de conduire est le document officiel qui autorise une personne à conduire un véhicule motorisé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire si un animal traverse la route ?",
    options: [
      "Accélérer pour le dépasser",
      "Freiner et klaxonner",
      "Faire demi-tour",
    ],
    answer: "Freiner et klaxonner",
    explanation:
        "Il est essentiel de freiner pour éviter la collision et d'utiliser le klaxon pour alerter l'animal.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la signification d'un panneau indiquant une chaussée glissante ?",
    options: [
      "Ralentir et être vigilant",
      "Continuer à vitesse normale",
      "Accélérer",
    ],
    answer: "Ralentir et être vigilant",
    explanation:
        "Ce panneau avertit d'un risque de glissement, nécessitant une réduction de vitesse et une attention accrue.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif d'un radar de vitesse ?",
    options: [
      "Dissuasion des infractions",
      "Vente de contraventions",
      "Augmenter les revenus de l'État",
    ],
    answer: "Dissuasion des infractions",
    explanation:
        "Les radars de vitesse sont installés pour dissuader les conducteurs de dépasser les limites de vitesse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que faire en cas de bris de glace sur autoroute ?",
    options: [
      "Continuer à conduire",
      "Stationner sur la bande d'arrêt d'urgence",
      "Appeler les secours",
    ],
    answer: "Stationner sur la bande d'arrêt d'urgence",
    explanation:
        "En cas de bris de glace, il est essentiel de stationner en toute sécurité pour éviter un accident.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert un gilet de sécurité ?",
    options: [
      "Pour être visible en cas de panne",
      "Comme accessoire de mode",
      "Pour augmenter la pression des pneus",
    ],
    answer: "Pour être visible en cas de panne",
    explanation:
        "Le gilet de sécurité permet d'être visible sur la route en cas de panne ou d'accident.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la signification d'une ligne continue au sol ?",
    options: [
      "Interdiction de dépasser",
      "Autorisation de stationner",
      "Aucune règle particulière",
    ],
    answer: "Interdiction de dépasser",
    explanation:
        "Une ligne continue indique aux conducteurs qu'il est interdit de dépasser un autre véhicule.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'un panneau de signalisation ?",
    options: [
      "Réguler le trafic",
      "Offrir un parcours touristique",
      "Vendre des billets",
    ],
    answer: "Réguler le trafic",
    explanation:
        "Les panneaux de signalisation sont conçus pour réguler la circulation et garantir la sécurité des usagers.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle distance doit-on maintenir lorsque l'on suit un cycliste ?",
    options: ["1 mètre", "2 mètres", "3 mètres"],
    answer: "1 mètre",
    explanation:
        "Il est recommandé de maintenir une distance d'au moins 1 mètre lors du dépassement d'un cycliste.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le plus grand risque lié à la conduite sous l'emprise de drogues ?",
    options: [
      "Augmentation de la concentration",
      "Diminution de l'attention",
      "Aucune conséquence",
    ],
    answer: "Diminution de l'attention",
    explanation:
        "La conduite sous l'influence de drogues entraîne une diminution de l'attention et des réflexes du conducteur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la fonction principale des ronds-points ?",
    options: [
      "Faciliter la circulation",
      "Ralentir les véhicules",
      "Augmenter le temps de trajet",
    ],
    answer: "Faciliter la circulation",
    explanation:
        "Les ronds-points permettent de fluidifier le trafic en offrant une alternative aux feux de signalisation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau d'interdiction de tourner à droite ?",
    options: [
      "On doit aller tout droit",
      "On doit tourner à gauche",
      "On peut choisir son direction",
    ],
    answer: "On doit aller tout droit",
    explanation:
        "Ce panneau signale aux conducteurs qu'ils ne peuvent pas effectuer de virage à droite à cet endroit.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal risque en cas de mauvaise visibilité ?",
    options: ["Accidents", "Ralentissement du trafic", "Aucune conséquence"],
    answer: "Accidents",
    explanation:
        "Une mauvaise visibilité augmente le risque d'accidents en rendant difficile la détection des dangers.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la signification d'un panneau indiquant des travaux ?",
    options: [
      "Route barrée",
      "Ralentissement de la circulation",
      "Pas de changement",
    ],
    answer: "Ralentissement de la circulation",
    explanation:
        "Ce panneau avertit les conducteurs d'une possible réduction de la vitesse en raison de travaux en cours.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le risque d'une conduite agressive ?",
    options: ["Conduite plus rapide", "Accidents", "Meilleure circulation"],
    answer: "Accidents",
    explanation:
        "Une conduite agressive augmente le risque d'accidents en raison de comportements imprévisibles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact de la fatigue sur la conduite ?",
    options: [
      "Amélioration des réflexes",
      "Diminution de la vigilance",
      "Aucune influence",
    ],
    answer: "Diminution de la vigilance",
    explanation:
        "La fatigue entraîne une diminution de la vigilance, augmentant le risque d'accidents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif principal des contrôles routiers ?",
    options: [
      "Vérifier l'état des véhicules",
      "Assurer la sécurité routière",
      "Améliorer le service public",
    ],
    answer: "Assurer la sécurité routière",
    explanation:
        "Les contrôles routiers sont mis en place pour garantir le respect des règles de sécurité sur la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit faire un conducteur avant de démarrer ?",
    options: [
      "Regarder autour de lui",
      "Ignorer les autres usagers",
      "Accélérer brutalement",
    ],
    answer: "Regarder autour de lui",
    explanation:
        "Il est important de vérifier l'environnement du véhicule avant de démarrer pour éviter les collisions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le risque d'une vitesse excessive ?",
    options: ["Aucun risque", "Amende seulement", "Accidents graves"],
    answer: "Accidents graves",
    explanation:
        "Une vitesse excessive augmente considérablement le risque de subir des accidents graves.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi correspond un panneau de danger ?",
    options: [
      "Avertir d'un danger potentiel",
      "Indiquer une direction",
      "Marquer une pause",
    ],
    answer: "Avertir d'un danger potentiel",
    explanation:
        "Un panneau de danger signale aux conducteurs un risque potentiel sur la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des feux de circulation ?",
    options: ["Réguler la vitesse", "Gérer le trafic", "Décorer la route"],
    answer: "Gérer le trafic",
    explanation:
        "Les feux de circulation sont conçus pour organiser le flux de voitures et piétons à des intersections.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que faire en cas de perte de contrôle du véhicule ?",
    options: [
      "Accélérer",
      "Freiner et diriger le véhicule",
      "Ignorer la situation",
    ],
    answer: "Freiner et diriger le véhicule",
    explanation:
        "Il est crucial de freiner et de garder le contrôle du véhicule pour éviter un accident.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand doit-on utiliser son klaxon ?",
    options: [
      "Jamais",
      "Pour prévenir d'un danger",
      "Pour encourager les passants",
    ],
    answer: "Pour prévenir d'un danger",
    explanation:
        "Le klaxon doit être utilisé pour avertir d'un danger imminent sur la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact de conduire sous l'emprise de l'alcool ?",
    options: [
      "Amélioration des réflexes",
      "Diminution de la capacité d'évaluation",
      "Aucune influence",
    ],
    answer: "Diminution de la capacité d'évaluation",
    explanation:
        "L'alcool altère les capacités d'évaluation et de réaction d'un conducteur, augmentant le risque d'accidents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Pourquoi les zones piétonnes sont-elles importantes ?",
    options: [
      "Pour favoriser le commerce",
      "Pour protéger les piétons",
      "Pour ralentir les voitures",
    ],
    answer: "Pour protéger les piétons",
    explanation:
        "Les zones piétonnes offrent un espace sécurisé pour les piétons, réduisant le risque d'accidents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le meilleur moyen d'informer les autres de votre intention de tourner ?",
    options: [
      "Utiliser les feux de détresse",
      "Alerter avec le klaxon",
      "Utiliser les clignotants",
    ],
    answer: "Utiliser les clignotants",
    explanation:
        "Les clignotants sont le moyen standard pour indiquer une intention de changement de direction aux autres usagers.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le seuil légal d'alcoolémie pour conduire en France ?",
    options: ["0,5 g/l", "0,2 g/l", "0,8 g/l"],
    answer: "0,5 g/l",
    explanation:
        "Le seuil légal d'alcoolémie pour conduire est de 0,5 gramme par litre de sang.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel panneau indique une sortie d'autoroute ?",
    options: ["Panneau de sortie", "Panneau d'entrée", "Panneau de danger"],
    answer: "Panneau de sortie",
    explanation:
        "Le panneau de sortie signale la possibilité de quitter l'autoroute.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "À quelle distance minimum doit-on stationner de l'intersection ?",
    options: ["5 mètres", "3 mètres", "10 mètres"],
    answer: "5 mètres",
    explanation:
        "Il est recommandé de stationner à au moins 5 mètres d'une intersection.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un feu rouge clignotant ?",
    options: ["Stop obligatoire", "Passage piéton", "Vitesse limitée"],
    answer: "Stop obligatoire",
    explanation:
        "Un feu rouge clignotant indique un arrêt obligatoire avant de continuer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'âge minimum pour passer le permis de conduire en France ?",
    options: ["17 ans", "16 ans", "21 ans"],
    answer: "17 ans",
    explanation:
        "L'âge minimum requis pour passer le permis de conduire est de 17 ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la vitesse maximale autorisée sur une autoroute en France ?",
    options: ["130 km/h", "110 km/h", "150 km/h"],
    answer: "130 km/h",
    explanation: "La vitesse maximale autorisée sur autoroute est de 130 km/h.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand devez-vous utiliser vos feux de croisement ?",
    options: ["Dans un tunnel", "En pleine journée", "Sur autoroute"],
    answer: "Dans un tunnel",
    explanation:
        "Les feux de croisement doivent être allumés dans les tunnels pour la sécurité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'arbre de signalisation de limitation de vitesse en France ?",
    options: ["Un cercle rouge", "Un triangle vert", "Un carré bleu"],
    answer: "Un cercle rouge",
    explanation: "Un cercle rouge indique une limitation de vitesse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'effet d'un véhicule qui prend un virage sans ralentir ?",
    options: ["Survirage", "Sous-virage", "Aucune de ces réponses"],
    answer: "Sous-virage",
    explanation:
        "Un véhicule qui prend un virage sans ralentir peut sous-virer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert l'anti-blocage des roues (ABS) ?",
    options: [
      "À freiner plus fort",
      "À empêcher le blocage des roues",
      "À accélérer",
    ],
    answer: "À empêcher le blocage des roues",
    explanation: "L'ABS évite le blocage des roues lors du freinage.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Pourquoi les ceintures de sécurité sont-elles importantes ?",
    options: [
      "Pour plus de confort",
      "Pour éviter les amendes",
      "Pour réduire les blessures",
    ],
    answer: "Pour réduire les blessures",
    explanation:
        "Les ceintures de sécurité réduisent les blessures lors d'un accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la signification d'un panneau triangulaire avec un bord rouge ?",
    options: ["Danger", "Interdiction", "Stopped area"],
    answer: "Danger",
    explanation: "Un panneau triangulaire avec bord rouge indique un danger.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Dans quel cas pouvez-vous dépasser une ligne continue ?",
    options: [
      "Jamais",
      "En cas d'urgence",
      "Quand aucun véhicule n'est en vue",
    ],
    answer: "Jamais",
    explanation: "Il est interdit de dépasser une ligne continue.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert un marquage au sol en zigzag ?",
    options: ["Stationnement interdit", "Zone de danger", "Vitesse limitée"],
    answer: "Stationnement interdit",
    explanation:
        "Le marquage au sol en zigzag indique une zone de stationnement interdit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que doit faire un conducteur en présence d'un piéton engagé sur un passage ?",
    options: ["Accélérer", "Ralentir", "Continuer"],
    answer: "Ralentir",
    explanation: "Le conducteur doit ralentir et céder le passage au piéton.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quels véhicules doivent obligatoirement avoir un gilet de sécurité à bord ?",
    options: [
      "Tous les véhicules",
      "Seulement les utilitaires",
      "Les motos uniquement",
    ],
    answer: "Tous les véhicules",
    explanation:
        "Tous les véhicules doivent avoir un gilet de sécurité à bord.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Qu'est-ce qu'un conducteur doit faire avant de changer de voie ?",
    options: [
      "Regarder dans le rétroviseur",
      "Accélérer",
      "Utiliser les feux de détresse",
    ],
    answer: "Regarder dans le rétroviseur",
    explanation:
        "Il est essentiel de vérifier le rétroviseur avant de changer de voie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qui est interdit de transporter dans un véhicule ?",
    options: ["Un enfant sans siège", "Un animal dans un cage", "Un passager"],
    answer: "Un enfant sans siège",
    explanation: "Il est interdit de transporter un enfant sans siège adapté.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif principal du code de la route ?",
    options: [
      "Réguler la circulation",
      "Augmenter les amendes",
      "Promouvoir la vitesse",
    ],
    answer: "Réguler la circulation",
    explanation:
        "Le code de la route vise à réguler la circulation pour la sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le symbole d'une voiture en panne sur un panneau ?",
    options: [
      "Un triangle avec un point d'exclamation",
      "Un cercle rouge",
      "Un carré jaune",
    ],
    answer: "Un triangle avec un point d'exclamation",
    explanation:
        "Un triangle avec un point d'exclamation indique un véhicule en panne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel comportement est conseillé lorsqu'on rencontre un cycliste sur la route ?",
    options: [
      "Ralentir et dépasser",
      "Accélérer pour le doubler",
      "Freiner brusquement",
    ],
    answer: "Ralentir et dépasser",
    explanation:
        "Il est conseillé de ralentir et de dépasser prudemment un cycliste.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la fonction d’un radar de vitesse ?",
    options: [
      "Mesurer la vitesse des véhicules",
      "Contrôler le trafic",
      "Évaluer l'état des routes",
    ],
    answer: "Mesurer la vitesse des véhicules",
    explanation:
        "Un radar de vitesse mesure la vitesse des véhicules en circulation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert un feu vert ?",
    options: ["À accélérer", "À ralentir", "À passer"],
    answer: "À passer",
    explanation: "Un feu vert permet aux véhicules de passer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau bleu avec une flèche blanche ?",
    options: [
      "Direction obligatoire",
      "Stationnement autorisé",
      "Interdiction de passage",
    ],
    answer: "Direction obligatoire",
    explanation:
        "Un panneau bleu avec une flèche blanche indique une direction obligatoire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire en cas d'accident avec des blessés ?",
    options: [
      "Appeler les secours",
      "Quitter les lieux",
      "Prendre des photos uniquement",
    ],
    answer: "Appeler les secours",
    explanation:
        "Il est impératif d'appeler les secours en cas d'accident avec des blessés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel type de panneau interdit de doubler ?",
    options: [
      "Panneau carré rouge",
      "Panneau circulaire rouge",
      "Panneau triangulaire jaune",
    ],
    answer: "Panneau circulaire rouge",
    explanation: "Un panneau circulaire rouge interdit de doubler.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la première chose à faire en cas de panne sur la route ?",
    options: [
      "Allumer les feux de détresse",
      "Sortir du véhicule",
      "Appeler un ami",
    ],
    answer: "Allumer les feux de détresse",
    explanation:
        "Il faut allumer les feux de détresse pour alerter les autres conducteurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit faire un conducteur avant de tourner à gauche ?",
    options: [
      "Vérifier les angles morts",
      "Accélérer",
      "Faire signe avec la main",
    ],
    answer: "Vérifier les angles morts",
    explanation:
        "Il est essentiel de vérifier les angles morts avant de tourner à gauche.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'un agent de circulation ?",
    options: [
      "Sanctionner les infractions",
      "Réguler le trafic",
      "Donner des conseils",
    ],
    answer: "Réguler le trafic",
    explanation:
        "Un agent de circulation régule le trafic pour assurer la sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment réagir face à un panneau de stop ?",
    options: [
      "S'arrêter complètement",
      "Ralentir sans s'arrêter",
      "Continuer à avancer",
    ],
    answer: "S'arrêter complètement",
    explanation:
        "Un panneau stop exige que le conducteur s'arrête complètement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'équipement obligatoire pour un véhicule ?",
    options: ["Un coffre de toit", "Un triangle de signalisation", "Un GPS"],
    answer: "Un triangle de signalisation",
    explanation:
        "Un triangle de signalisation est un équipement obligatoire dans un véhicule.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quelle distance doit-on signaler un changement de direction ?",
    options: ["50 mètres", "30 mètres", "100 mètres"],
    answer: "100 mètres",
    explanation:
        "Il est conseillé de signaler un changement de direction 100 mètres à l'avance.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but principal des feux de circulation ?",
    options: [
      "Gérer les priorités",
      "Alerter les piétons",
      "Rendre la route plus esthétique",
    ],
    answer: "Gérer les priorités",
    explanation:
        "Les feux de circulation servent à gérer les priorités de passage.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'une infraction au code de la route ?",
    options: [
      "Un comportement dangereux",
      "Un comportement correct",
      "Un comportement respectueux",
    ],
    answer: "Un comportement dangereux",
    explanation:
        "Une infraction au code de la route est un comportement dangereux sur la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel équipement est nécessaire pour conduire une moto ?",
    options: [
      "Un casque homologué",
      "Des gants en cuir",
      "Des lunettes de soleil",
    ],
    answer: "Un casque homologué",
    explanation:
        "Le port d'un casque homologué est obligatoire pour conduire une moto.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit faire un cycliste à un feu rouge ?",
    options: ["S'arrêter", "Passer", "Accélérer"],
    answer: "S'arrêter",
    explanation:
        "Un cycliste doit s'arrêter à un feu rouge, comme tout véhicule.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que représente un panneau de limitation de vitesse ?",
    options: ["Un conseil", "Une règle stricte", "Une option"],
    answer: "Une règle stricte",
    explanation:
        "Un panneau de limitation de vitesse représente une règle stricte à respecter.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quel moment peut-on utiliser les feux de route ?",
    options: [
      "La nuit sur routes dégagées",
      "À tout moment",
      "Pendant les jours de pluie",
    ],
    answer: "La nuit sur routes dégagées",
    explanation:
        "Les feux de route doivent être utilisés la nuit sur routes dégagées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Comment doit se comporter un conducteur face à un véhicule d'urgence ?",
    options: [
      "Ralentir et céder le passage",
      "Accélérer pour les dépasser",
      "Ignorer",
    ],
    answer: "Ralentir et céder le passage",
    explanation:
        "Il est crucial de ralentir et de céder le passage aux véhicules d'urgence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le temps de réaction moyen d'un conducteur ?",
    options: ["1 seconde", "0,5 seconde", "2 secondes"],
    answer: "1 seconde",
    explanation:
        "Le temps de réaction moyen d'un conducteur est d'environ 1 seconde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le risque principal de la vitesse excessive ?",
    options: [
      "Moins de contrôle",
      "Plus de confort",
      "Moins de carburant consommé",
    ],
    answer: "Moins de contrôle",
    explanation: "La vitesse excessive diminue le contrôle du véhicule.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel type de permis est requis pour conduire un camion ?",
    options: ["Permis C", "Permis B", "Permis A"],
    answer: "Permis C",
    explanation: "Le permis C est requis pour conduire un camion.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal effet des drogues sur la conduite ?",
    options: [
      "Amélioration de la concentration",
      "Diminution des réflexes",
      "Augmentation de l'énergie",
    ],
    answer: "Diminution des réflexes",
    explanation:
        "Les drogues diminuent les réflexes, ce qui impacte la conduite.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la première chose à vérifier avant de prendre le volant ?",
    options: [
      "L'état général du véhicule",
      "Le niveau de carburant",
      "La météo",
    ],
    answer: "L'état général du véhicule",
    explanation:
        "Vérifier l'état général du véhicule est essentiel avant de conduire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau indiquant une route glissante ?",
    options: ["Danger d'accident", "Vitesse recommandée", "Route fermée"],
    answer: "Danger d'accident",
    explanation:
        "Un panneau indiquant une route glissante avertit du danger d'accident.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment doit être positionné le siège lors de la conduite ?",
    options: [
      "À une distance confortable",
      "Incliné au maximum",
      "Au plus proche du volant",
    ],
    answer: "À une distance confortable",
    explanation:
        "Le siège doit être positionné à une distance confortable pour conduire en sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que doit faire un conducteur lorsqu'il se trouve dans un rond-point ?",
    options: [
      "Céder le passage à gauche",
      "Céder le passage à droite",
      "Céder le passage aux véhicules déjà dans le rond-point",
    ],
    answer: "Céder le passage aux véhicules déjà dans le rond-point",
    explanation:
        "Dans un rond-point, le conducteur doit céder le passage aux véhicules déjà présents.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel comportement est à éviter lorsque le feu est orange ?",
    options: ["Accélérer", "Ralentir", "S'arrêter"],
    answer: "Accélérer",
    explanation: "Il est dangereux d'accélérer lorsque le feu est orange.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal objectif du code de la route ?",
    options: [
      "Assurer la sécurité des usagers",
      "Réduire le nombre de voitures",
      "Réguler le prix de l'essence",
    ],
    answer: "Assurer la sécurité des usagers",
    explanation:
        "Le code de la route vise à garantir la sécurité de tous les usagers sur la voie publique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un feu tricolore rouge ?",
    options: ["Arrêt obligatoire", "Laissez passer", "Ralentir"],
    answer: "Arrêt obligatoire",
    explanation:
        "Un feu rouge indique aux conducteurs qu'ils doivent s'arrêter avant l'intersection.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel document est nécessaire pour conduire un véhicule léger ?",
    options: [
      "Permis de conduire",
      "Certificat d'immatriculation",
      "Assurance",
    ],
    answer: "Permis de conduire",
    explanation:
        "Le permis de conduire est obligatoire pour conduire légalement un véhicule léger.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des panneaux de signalisation ?",
    options: [
      "Indiquer les stations-service",
      "Avertir des conditions météorologiques",
      "Réguler le trafic",
    ],
    answer: "Réguler le trafic",
    explanation:
        "Les panneaux de signalisation servent à réguler le trafic et à informer les conducteurs des règles à suivre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelles sont les conséquences d'une conduite sous l'emprise de l'alcool ?",
    options: [
      "Aucune",
      "Amendes et retrait de permis",
      "Augmentation de la vitesse",
    ],
    answer: "Amendes et retrait de permis",
    explanation:
        "Conduire sous l'emprise de l'alcool entraîne des amendes et peut mener à un retrait de permis.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand est-il obligatoire de porter la ceinture de sécurité ?",
    options: [
      "Uniquement sur autoroute",
      "Tout le temps",
      "Seulement dans les voitures récentes",
    ],
    answer: "Tout le temps",
    explanation:
        "Le port de la ceinture de sécurité est obligatoire en toutes circonstances lorsque l'on est en voiture.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert la distance de sécurité entre véhicules ?",
    options: [
      "À réduire le bruit",
      "À éviter les accrochages",
      "À augmenter la vitesse",
    ],
    answer: "À éviter les accrochages",
    explanation:
        "Maintenir une distance de sécurité permet de prévenir les collisions en cas d'arrêt brusque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif principal des radars de vitesse ?",
    options: [
      "Surveiller le trafic",
      "Sanctionner les excès de vitesse",
      "Émettre des contraventions",
    ],
    answer: "Sanctionner les excès de vitesse",
    explanation:
        "Les radars de vitesse sont installés pour détecter et sanctionner les conducteurs qui dépassent les limites de vitesse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le taux d'alcoolémie maximal autorisé au volant en France pour un conducteur novice ?",
    options: ["0,5 g/L", "0,2 g/L", "0,8 g/L"],
    answer: "0,2 g/L",
    explanation:
        "Les conducteurs novices doivent respecter un taux d'alcoolémie maximal de 0,2 g/L lors de la conduite.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que faut-il faire en cas d'accident de la route ?",
    options: ["Rester sur place", "Appeler les secours", "Prendre des photos"],
    answer: "Appeler les secours",
    explanation:
        "Il est essentiel d'appeler les secours immédiatement après un accident pour recevoir de l'aide.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel équipement de sécurité est obligatoire pour les deux-roues motorisés ?",
    options: ["Gants", "Casque", "Veste réfléchissante"],
    answer: "Casque",
    explanation:
        "Le port du casque est obligatoire pour tous les conducteurs de deux-roues motorisés afin de garantir leur sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "En cas de panne sur l'autoroute, que devez-vous faire ?",
    options: [
      "Sortir du véhicule immédiatement",
      "Allumer vos feux de détresse",
      "Attendre sans rien faire",
    ],
    answer: "Allumer vos feux de détresse",
    explanation:
        "Il est important d'allumer les feux de détresse pour signaler votre présence aux autres conducteurs en cas de panne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert le triangle de présignalisation ?",
    options: [
      "À décorer le véhicule",
      "À signaler une panne",
      "À avertir d'un contrôle police",
    ],
    answer: "À signaler une panne",
    explanation:
        "Le triangle de présignalisation est utilisé pour avertir les autres conducteurs d'une panne ou d'un accident sur la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but des limitations de vitesse en zone scolaire ?",
    options: [
      "Ralentir les voitures",
      "Limiter les piétons",
      "Augmenter le temps de trajet",
    ],
    answer: "Ralentir les voitures",
    explanation:
        "Les limitations de vitesse en zone scolaire visent à protéger les enfants et à réduire les risques d'accidents.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal risque de l'utilisation du téléphone au volant ?",
    options: [
      "Écouter de la musique",
      "Se concentrer davantage",
      "Distraction",
    ],
    answer: "Distraction",
    explanation:
        "L'utilisation du téléphone au volant provoque une distraction qui augmente le risque d'accidents.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel type de feu peut être utilisé pour signaler une urgence sur la route ?",
    options: ["Feu orange", "Feu bleu", "Feu clignotant"],
    answer: "Feu clignotant",
    explanation:
        "Un feu clignotant est utilisé pour signaler une urgence et attirer l'attention des autres conducteurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'âge minimum pour obtenir un permis de conduire en France ?",
    options: ["16 ans", "17 ans", "18 ans"],
    answer: "17 ans",
    explanation:
        "Il est nécessaire d'avoir au moins 17 ans pour passer le permis de conduire en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principe de la priorité à droite ?",
    options: [
      "Les véhicules à gauche doivent céder",
      "Les véhicules à droite ont priorité",
      "Les piétons ont toujours la priorité",
    ],
    answer: "Les véhicules à droite ont priorité",
    explanation:
        "Le principe de la priorité à droite stipule que le conducteur doit céder le passage aux véhicules venant de sa droite.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand doit-on utiliser ses feux de croisement ?",
    options: ["À la tombée de la nuit", "En plein jour", "Jamais"],
    answer: "À la tombée de la nuit",
    explanation:
        "Les feux de croisement doivent être utilisés à la tombée de la nuit pour améliorer la visibilité et la sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doivent faire les cyclistes sur la route ?",
    options: [
      "Circuler sur la route",
      "Faire du vélo sur le trottoir",
      "Utiliser les pistes cyclables quand elles existent",
    ],
    answer: "Utiliser les pistes cyclables quand elles existent",
    explanation:
        "Les cyclistes sont tenus d'utiliser les pistes cyclables s'elles sont disponibles pour leur sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "En présence d'un piéton sur un passage protégé, que doit faire le conducteur ?",
    options: ["Accélérer", "S'arrêter", "Continuer sa route"],
    answer: "S'arrêter",
    explanation:
        "Le conducteur doit s'arrêter pour laisser passer le piéton sur un passage protégé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que symbolise la ligne blanche continue sur la route ?",
    options: [
      "Interdiction de dépasser",
      "Zone de stationnement",
      "Piste cyclable",
    ],
    answer: "Interdiction de dépasser",
    explanation:
        "Une ligne blanche continue indique qu'il est interdit de dépasser un véhicule sur cette partie de la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert un permis probatoire ?",
    options: [
      "À conduire sans restrictions",
      "À prouver la compétence",
      "À réduire le temps d'attente",
    ],
    answer: "À prouver la compétence",
    explanation:
        "Le permis probatoire est une période lors de laquelle le conducteur doit prouver sa compétence et respecter des règles strictes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but du contrôle technique ?",
    options: [
      "Vérifier l'état des véhicules",
      "Rendre les voitures plus rapides",
      "Réduire les coûts d'assurance",
    ],
    answer: "Vérifier l'état des véhicules",
    explanation:
        "Le contrôle technique vise à s'assurer que les véhicules respectent les normes de sécurité et d'environnement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'âge minimum pour conduire une moto légère en France ?",
    options: ["16 ans", "18 ans", "21 ans"],
    answer: "16 ans",
    explanation:
        "L'âge minimum pour conduire une moto légère est fixé à 16 ans en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la sanction pour un excès de vitesse important ?",
    options: [
      "Un simple avertissement",
      "Une amende et un retrait de points",
      "Une peine de prison",
    ],
    answer: "Une amende et un retrait de points",
    explanation:
        "Un excès de vitesse important entraîne généralement une amende et un retrait de points sur le permis de conduire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau avec un chiffre sur fond rouge ?",
    options: ["Interdiction", "Danger", "Accès restreint"],
    answer: "Interdiction",
    explanation:
        "Un panneau avec un chiffre sur fond rouge indique une interdiction, comme celle de dépasser.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'un agent de la circulation ?",
    options: [
      "Vérifier les assurances",
      "Diriger le trafic",
      "Vendre des billets de bus",
    ],
    answer: "Diriger le trafic",
    explanation:
        "Un agent de la circulation est responsable de la régulation du trafic et de la sécurité routière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelles substances sont interdites au volant en plus de l'alcool ?",
    options: ["Caféine", "Drogues", "Médicaments sans ordonnance"],
    answer: "Drogues",
    explanation:
        "La conduite sous l'emprise de drogues est illégale et considérée comme dangereuse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "En cas de route glissante, que doit faire le conducteur ?",
    options: ["Ralentir", "Accélérer", "Changement de voie"],
    answer: "Ralentir",
    explanation:
        "Sur une route glissante, il est essentiel de ralentir pour éviter les accidents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact de la vitesse sur la distance de freinage ?",
    options: ["Aucun impact", "Augmente la distance", "Diminue la distance"],
    answer: "Augmente la distance",
    explanation:
        "Plus la vitesse est élevée, plus la distance de freinage nécessaire pour s'arrêter est importante.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert un permis de conduire de catégorie B ?",
    options: [
      "Conduire un bus",
      "Conduire un véhicule léger",
      "Conduire une moto",
    ],
    answer: "Conduire un véhicule léger",
    explanation:
        "Le permis de catégorie B permet de conduire des véhicules légers, tels que les voitures particulières.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but de l'éthylotest ?",
    options: [
      "Mesurer la vitesse",
      "Déterminer le taux d'alcool",
      "Évaluer la distance de freinage",
    ],
    answer: "Déterminer le taux d'alcool",
    explanation:
        "L'éthylotest est utilisé pour mesurer le taux d'alcool dans le sang d'un conducteur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principe de la double ligne continue ?",
    options: [
      "Dépassement autorisé",
      "Dépassement interdit",
      "Zone de stationnement",
    ],
    answer: "Dépassement interdit",
    explanation:
        "La double ligne continue indique qu'il est interdit de dépasser tout véhicule sur cette portion de route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal objectif du contrôle routier ?",
    options: [
      "Surveiller le trafic",
      "Vérifier la conformité des véhicules",
      "Récupérer des amendes",
    ],
    answer: "Vérifier la conformité des véhicules",
    explanation:
        "Le contrôle routier vise à s'assurer que les véhicules respectent les normes de sécurité et d'assurance.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau représentant un piéton ?",
    options: ["Interdiction de dépasser", "Zone piétonne", "Vitesse limitée"],
    answer: "Zone piétonne",
    explanation:
        "Un panneau représentant un piéton indique une zone réservée aux piétons, où les véhicules doivent céder le passage.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact de l'usage des ceintures de sécurité ?",
    options: ["Aucun impact", "Réduit les blessures", "Augmente le confort"],
    answer: "Réduit les blessures",
    explanation:
        "Le port de la ceinture de sécurité réduit significativement le risque de blessures en cas d'accident.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que devez-vous faire si un panneau indique un danger ?",
    options: ["Ignorer le panneau", "Accélérer", "Redoubler de vigilance"],
    answer: "Redoubler de vigilance",
    explanation:
        "Il est crucial de redoubler de vigilance en présence d'un panneau signalant un danger sur la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'une voiture de police en patrouille ?",
    options: [
      "Contrôler les vitesses",
      "Sécuriser les événements",
      "Intercepter les véhicules",
    ],
    answer: "Sécuriser les événements",
    explanation:
        "Les voitures de police en patrouille ont pour rôle principal de sécuriser les événements et de veiller à la sécurité des usagers.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Comme doit-on se comporter en cas d'accident causé par un tiers ?",
    options: ["Fuir la scène", "Échanger les coordonnées", "Se venger"],
    answer: "Échanger les coordonnées",
    explanation:
        "Après un accident, il est important d'échanger les coordonnées pour pouvoir établir une déclaration d'accident.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel type de panneau indique une limitation de vitesse ?",
    options: ["Panneau bleu", "Panneau rouge", "Panneau vert"],
    answer: "Panneau rouge",
    explanation:
        "Le panneau rouge indique généralement les limitations de vitesse sur la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'un gendarme dans la circulation routière ?",
    options: [
      "Contrôler la vitesse",
      "Conseiller les conducteurs",
      "Récupérer les permis",
    ],
    answer: "Contrôler la vitesse",
    explanation:
        "Un gendarme dans la circulation routière est chargé de contrôler la vitesse des véhicules pour garantir la sécurité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert le feu de position sur un véhicule ?",
    options: [
      "À signaler une urgence",
      "À assurer la visibilité",
      "À réduire la consommation de carburant",
    ],
    answer: "À assurer la visibilité",
    explanation:
        "Le feu de position permet d'assurer la visibilité du véhicule sur la route, surtout la nuit.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif d'un panneau stop ?",
    options: [
      "Avertir d'un danger",
      "Exiger un arrêt",
      "Indiquer un sens unique",
    ],
    answer: "Exiger un arrêt",
    explanation:
        "Un panneau stop exige aux conducteurs de s'arrêter complètement avant de continuer.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment doit-on se comporter face à un feu clignotant ?",
    options: ["Accélérer", "Ralentir", "Stationner"],
    answer: "Ralentir",
    explanation:
        "Un feu clignotant signale aux conducteurs de ralentir et de rester vigilants.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'un panneau de warning sur la route ?",
    options: ["Interdire l'accès", "Avertir d'un danger", "Indiquer le chemin"],
    answer: "Avertir d'un danger",
    explanation:
        "Un panneau de warning est utilisé pour avertir les conducteurs d'un danger imminent sur la route.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal risque de conduire sous l'influence de l'alcool ?",
    options: [
      "Diminution des réflexes",
      "Amélioration des capacités",
      "Augmentation de la concentration",
    ],
    answer: "Diminution des réflexes",
    explanation:
        "L'alcool altère les capacités cognitives et ralentit les réflexes, augmentant le risque d'accidents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "À quelle distance devez-vous placer un triangle de signalisation en cas de panne ?",
    options: ["10 mètres", "30 mètres", "50 mètres"],
    answer: "30 mètres",
    explanation:
        "Le triangle de signalisation doit être placé à 30 mètres de votre véhicule pour prévenir les autres conducteurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un feu rouge clignotant à un passage à niveau ?",
    options: [
      "Passage interdit",
      "Avertissement de danger",
      "Passage autorisé",
    ],
    answer: "Avertissement de danger",
    explanation:
        "Un feu rouge clignotant indique qu'un train est en approche et qu'il faut s'arrêter.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la vitesse limite en agglomération, sauf indication contraire ?",
    options: ["30 km/h", "50 km/h", "70 km/h"],
    answer: "50 km/h",
    explanation:
        "La vitesse maximale autorisée en agglomération est généralement de 50 km/h pour assurer la sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel document devez-vous avoir en conduisant un véhicule ?",
    options: [
      "Attestation d'assurance",
      "Permis de conduire",
      "Contrôle technique",
    ],
    answer: "Permis de conduire",
    explanation:
        "Le permis de conduire est obligatoire pour légitimer votre capacité à conduire un véhicule.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que faire en cas de perte de contrôle sur la route ?",
    options: [
      "Accélérer pour récupérer",
      "Freiner fermement",
      "Garder le volant et rester calme",
    ],
    answer: "Garder le volant et rester calme",
    explanation:
        "Il est essentiel de rester calme et de garder le contrôle du volant en cas de perte d'adhérence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif des zones scolaires ?",
    options: [
      "Augmenter la vitesse des véhicules",
      "Réduire la vitesse des véhicules",
      "Augmenter le nombre de véhicules",
    ],
    answer: "Réduire la vitesse des véhicules",
    explanation:
        "Les zones scolaires visent à protéger les enfants en réduisant la vitesse des véhicules à proximité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le rôle du panneau de signalisation triangulaire avec un point d'exclamation ?",
    options: ["Danger", "Information", "Interdiction"],
    answer: "Danger",
    explanation:
        "Ce panneau avertit les conducteurs d'un danger potentiel sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la première cause d'accidents de la route ?",
    options: ["Vitesse excessive", "Inattention", "Conditions météorologiques"],
    answer: "Inattention",
    explanation:
        "L'inattention est la principale cause des accidents de la route, engendrant des comportements imprévisibles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand est-il interdit d'utiliser son téléphone au volant ?",
    options: [
      "Lorsque vous êtes arrêté",
      "À tout moment",
      "Lorsque vous conduisez",
    ],
    answer: "À tout moment",
    explanation:
        "L'utilisation du téléphone au volant est strictement interdite pour éviter les distractions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment devez-vous réagir en voyant un feu orange ?",
    options: [
      "Accélérer",
      "Ralentir et préparer l'arrêt",
      "Continuer sans changer de vitesse",
    ],
    answer: "Ralentir et préparer l'arrêt",
    explanation:
        "Le feu orange indique qu'il est temps de ralentir et de se préparer à s'arrêter.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel équipement est obligatoire pour les deux-roues motorisés ?",
    options: ["Gants", "Casque", "Veste réfléchissante"],
    answer: "Casque",
    explanation:
        "Le port du casque est obligatoire pour assurer la sécurité du conducteur de deux-roues motorisés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire en cas d'accident matériel sans blessé ?",
    options: [
      "Alerter la police",
      "Rester sur place et échanger des informations",
      "Continuer son chemin",
    ],
    answer: "Rester sur place et échanger des informations",
    explanation:
        "Il est important de rester sur place et d'échanger les coordonnées avec l'autre conducteur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le seuil d'alcoolémie légal au volant pour un conducteur novice ?",
    options: ["0,5 g/l", "0,2 g/l", "0,8 g/l"],
    answer: "0,2 g/l",
    explanation:
        "Les conducteurs novices doivent avoir un taux d'alcoolémie inférieur à 0,2 g/l.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des feux de circulation ?",
    options: [
      "Fluidifier le trafic",
      "Ralentir les véhicules",
      "Créer des embouteillages",
    ],
    answer: "Fluidifier le trafic",
    explanation:
        "Les feux de circulation organisent le flux de véhicules pour assurer la sécurité et fluidifier le trafic.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal effet des drogues au volant ?",
    options: [
      "Aggravation des capacités",
      "Amélioration des réflexes",
      "Réduction du temps de réaction",
    ],
    answer: "Aggravation des capacités",
    explanation:
        "Les drogues altèrent les capacités du conducteur, rendant la conduite dangereuse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Sur une route à double sens, que doit-on faire avant de dépasser ?",
    options: [
      "Regarder dans le rétroviseur",
      "Utiliser son clignotant",
      "Aceler avec prudence",
    ],
    answer: "Regarder dans le rétroviseur",
    explanation:
        "Il est crucial de vérifier le rétroviseur avant de dépasser pour s'assurer qu'aucun véhicule n'approche.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'impact d'une vitesse élevée sur le temps de réaction ?",
    options: [
      "Aucun impact",
      "Réduction du temps de réaction",
      "Augmentation du temps de réaction",
    ],
    answer: "Augmentation du temps de réaction",
    explanation:
        "Une vitesse élevée augmente le temps de réaction et diminue la capacité à réagir en cas de danger.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle phrase décrit le mieux les lignes continues sur la route ?",
    options: ["Passage libre", "Interdiction de dépasser", "Zone de sécurité"],
    answer: "Interdiction de dépasser",
    explanation:
        "Les lignes continues signalent qu'il est interdit de dépasser pour assurer la sécurité des usagers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit contenir une trousse de secours en voiture ?",
    options: [
      "Des médicaments",
      "Un kit de pneus",
      "Des bandages et un antiseptique",
    ],
    answer: "Des bandages et un antiseptique",
    explanation:
        "Une trousse de secours doit inclure des bandages et un antiseptique pour traiter les blessures légères.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment réagir face à un piéton sur un passage clouté ?",
    options: ["Accélérer", "S'arrêter", "Doubler par la droite"],
    answer: "S'arrêter",
    explanation:
        "Les automobilistes doivent s'arrêter pour laisser passer les piétons sur un passage clouté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but d'une vitesse limitée sur les routes ?",
    options: [
      "Économiser du carburant",
      "Assurer la sécurité",
      "Augmenter le nombre de voitures",
    ],
    answer: "Assurer la sécurité",
    explanation:
        "Les limitations de vitesse visent principalement à assurer la sécurité de tous les usagers de la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet du port de la ceinture de sécurité ?",
    options: [
      "Réduction des blessures en cas d'accident",
      "Augmentation de la vitesse",
      "Aucune influence",
    ],
    answer: "Réduction des blessures en cas d'accident",
    explanation:
        "La ceinture de sécurité réduit considérablement les blessures lors d'un accident de la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Un conducteur doit-il céder le passage aux bus sortant d'un arrêt ?",
    options: ["Oui, toujours", "Non, jamais", "Seulement en ville"],
    answer: "Oui, toujours",
    explanation:
        "Les conducteurs doivent céder le passage aux bus lorsqu'ils sortent d'un arrêt pour garantir la sécurité des passagers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que faut-il faire en cas d'aquaplaning ?",
    options: [
      "Accélérer pour sortir de l'eau",
      "Freiner brusquement",
      "Relâcher l'accélérateur et diriger le volant",
    ],
    answer: "Relâcher l'accélérateur et diriger le volant",
    explanation:
        "Il est crucial de rester calme et de relâcher l'accélérateur pour sortir de l'aquaplaning.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "À quelle distance peut-on légalement stationner d'un passage piéton ?",
    options: ["5 mètres", "10 mètres", "15 mètres"],
    answer: "5 mètres",
    explanation:
        "Il est interdit de stationner à moins de 5 mètres d'un passage piéton pour assurer la visibilité des piétons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que symbolise une flèche verte sur un panneau ?",
    options: ["Interdiction", "Passage autorisé", "Danger imminent"],
    answer: "Passage autorisé",
    explanation:
        "Une flèche verte indique qu'un mouvement est autorisé à la circulation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Combien de points sont retirés pour un excès de vitesse inférieur à 20 km/h ?",
    options: ["1 point", "2 points", "3 points"],
    answer: "1 point",
    explanation:
        "Un excès de vitesse inférieur à 20 km/h entraîne un retrait de 1 point du permis de conduire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif principal des panneaux de signalisation ?",
    options: [
      "Décorer la route",
      "Informer et réguler le trafic",
      "Ralentir les conducteurs",
    ],
    answer: "Informer et réguler le trafic",
    explanation:
        "Les panneaux de signalisation sont là pour informer les usagers et réguler le trafic en toute sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand un conducteur doit-il utiliser ses feux de croisement ?",
    options: [
      "Que la nuit",
      "Dans des conditions de faible visibilité",
      "Lorsqu'il pleut uniquement",
    ],
    answer: "Dans des conditions de faible visibilité",
    explanation:
        "Les feux de croisement doivent être utilisés dans des conditions de faible visibilité, comme le brouillard ou la pluie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'effet du port d'une ceinture de sécurité sur la sécurité des enfants en voiture ?",
    options: ["Inefficace", "Essentiel", "Pas nécessaire"],
    answer: "Essentiel",
    explanation:
        "Le port de la ceinture de sécurité est essentiel pour protéger les enfants en cas d'accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doivent faire les conducteurs à un rond-point ?",
    options: ["Accélérer", "Céder le passage", "S'arrêter"],
    answer: "Céder le passage",
    explanation:
        "Les conducteurs doivent céder le passage aux véhicules circulant déjà dans le rond-point.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'interdiction d'un panneau de signalisation octogonal ?",
    options: [
      "Interdiction de tourner à droite",
      "Interdiction de stationner",
      "Interdiction de dépasser",
    ],
    answer: "Interdiction de dépasser",
    explanation:
        "Un panneau de signalisation octogonal indique une interdiction de dépasser pour des raisons de sécurité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment doit-on se comporter à un feu rouge ?",
    options: ["Continuer sans s'arrêter", "S'arrêter", "Accélérer"],
    answer: "S'arrêter",
    explanation:
        "Le feu rouge exige que les véhicules s'arrêtent pour assurer la sécurité sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des ceintures de sécurité ?",
    options: [
      "Augmenter la vitesse",
      "Réduire les blessures",
      "Améliorer la visibilité",
    ],
    answer: "Réduire les blessures",
    explanation:
        "Les ceintures de sécurité sont conçues pour réduire les blessures lors d'un accident de la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que devez-vous faire si vous croisez un véhicule d'urgence avec sirène ?",
    options: [
      "Accélérer pour les laisser passer",
      "Vous arrêter sur le côté",
      "Continuer sans changer de vitesse",
    ],
    answer: "Vous arrêter sur le côté",
    explanation:
        "Les automobilistes doivent s'arrêter sur le côté pour laisser passer les véhicules d'urgence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le premier réflexe à avoir en cas d'accident corporel ?",
    options: ["Fuir la scène", "Alerter les secours", "Prendre des photos"],
    answer: "Alerter les secours",
    explanation:
        "Le premier réflexe doit être d'alerter les secours pour recevoir une assistance immédiate.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Qu'est-ce qu'un panneau de signalisation en forme de cercle rouge indique ?",
    options: ["Zone de vitesse", "Interdiction", "Avertissement"],
    answer: "Interdiction",
    explanation:
        "Le panneau circulaire rouge indique une interdiction et doit être respecté par tous les usagers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le premier but de la formation des conducteurs ?",
    options: [
      "S'assurer de la sécurité routière",
      "Apprendre à conduire rapidement",
      "Économiser du carburant",
    ],
    answer: "S'assurer de la sécurité routière",
    explanation:
        "La formation des conducteurs vise principalement à garantir la sécurité sur les routes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment devez-vous vous comporter dans un tunnel ?",
    options: [
      "Accélérer pour le traverser rapidement",
      "Rester concentré et respecter la vitesse",
      "Utiliser les feux de route",
    ],
    answer: "Rester concentré et respecter la vitesse",
    explanation:
        "La prudence et le respect des limitations de vitesse sont essentiels à la sécurité dans les tunnels.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact du non-respect des règles de circulation ?",
    options: [
      "Aucun impact",
      "Augmentation des accidents",
      "Réduction du temps de trajet",
    ],
    answer: "Augmentation des accidents",
    explanation:
        "Le non-respect des règles de circulation augmente considérablement le risque d'accidents de la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Lorsque vous entendez une sirène, que devez-vous faire ?",
    options: [
      "Ralentir et céder le passage",
      "Accélérer pour partir rapidement",
      "Ignorer la sirène",
    ],
    answer: "Ralentir et céder le passage",
    explanation:
        "Il est nécessaire de ralentir et céder le passage aux véhicules d'urgence en cas de sirène.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le rôle principal des panneaux de limitation de vitesse ?",
    options: [
      "Augmenter la circulation",
      "Réduire les accidents",
      "Ralentir les véhicules",
    ],
    answer: "Réduire les accidents",
    explanation:
        "Les panneaux de limitation de vitesse sont conçus pour réduire le nombre d'accidents en régulant la vitesse des véhicules.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'un panneau de danger ?",
    options: [
      "Un signal d'alerte",
      "Un avertissement de vitesse",
      "Une indication de stationnement",
    ],
    answer: "Un signal d'alerte",
    explanation:
        "Un panneau de danger sert d'alerte aux conducteurs sur un potentiel risque sur la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'impact du port de la ceinture de sécurité en cas d'accident ?",
    options: [
      "Aucun impact sur les blessures",
      "Diminue le risque de blessure",
      "Augmente le risque de blessures",
    ],
    answer: "Diminue le risque de blessure",
    explanation:
        "Le port de la ceinture de sécurité réduit considérablement le risque de blessure lors d'un accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'une route à double sens ?",
    options: [
      "Road avec une seule direction",
      "Deux voies pour chaque direction",
      "Une voie pour chaque direction",
    ],
    answer: "Une voie pour chaque direction",
    explanation:
        "Une route à double sens permet aux véhicules de circuler dans des directions opposées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal but de la signalisation routière ?",
    options: [
      "Amuser les conducteurs",
      "Prévenir les conducteurs des dangers",
      "Augmenter le nombre de voitures",
    ],
    answer: "Prévenir les conducteurs des dangers",
    explanation:
        "La signalisation routière est essentielle pour prévenir les conducteurs des dangers potentiels sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des bandes réfléchissantes sur la route ?",
    options: [
      "Améliorer l'esthétique",
      "Assurer la sécurité de nuit",
      "Augmenter la vitesse",
    ],
    answer: "Assurer la sécurité de nuit",
    explanation:
        "Les bandes réfléchissantes améliorent la visibilité des routes la nuit, contribuant ainsi à la sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment se comporte un conducteur responsable ?",
    options: [
      "Enfreint les règles",
      "Respecte les lois de circulation",
      "Roule à vive allure",
    ],
    answer: "Respecte les lois de circulation",
    explanation:
        "Un conducteur responsable respecte toutes les lois de circulation pour garantir la sécurité de tous.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que doit-on faire si le feu est vert, mais qu'un piéton traverse ?",
    options: [
      "Continuer en restant vigilant",
      "S'arrêter pour laisser passer le piéton",
      "Accélérer pour éviter un accident",
    ],
    answer: "S'arrêter pour laisser passer le piéton",
    explanation:
        "Les véhicules doivent s'arrêter pour laisser passer les piétons, même si le feu est vert.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel document est obligatoire pour conduire un véhicule à moteur en France ?",
    options: [
      "La carte grise",
      "Le permis de conduire",
      "L'attestation d'assurance",
    ],
    answer: "Le permis de conduire",
    explanation:
        "Le permis de conduire est requis pour légitimement conduire un véhicule à moteur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la limite d'alcoolémie autorisée pour un conducteur novice en France ?",
    options: ["0,2 g/L", "0,5 g/L", "0,8 g/L"],
    answer: "0,2 g/L",
    explanation:
        "Les conducteurs novices doivent respecter une limite d'alcoolémie de 0,2 g/L.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel panneau indique la fin d'une zone de danger ?",
    options: [
      "Panneau de fin de limitation de vitesse",
      "Panneau de danger",
      "Panneau de fin de zone de danger",
    ],
    answer: "Panneau de fin de zone de danger",
    explanation:
        "Ce panneau signale la sortie d'une zone où des risques sont présents.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but principal du port de la ceinture de sécurité ?",
    options: [
      "Confort du conducteur",
      "Protection des passagers",
      "Réduction des blessures en cas d'accident",
    ],
    answer: "Réduction des blessures en cas d'accident",
    explanation:
        "La ceinture de sécurité réduit significativement les risques de blessures lors d'un accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le symbole d'un véhicule prioritaire ?",
    options: ["Un gyrophare", "Une sirène", "Un feu bleu"],
    answer: "Un gyrophare",
    explanation:
        "Le gyrophare indique qu'un véhicule a la priorité de passage.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'age minimum pour passer le permis de conduire en France ?",
    options: ["16 ans", "17 ans", "21 ans"],
    answer: "17 ans",
    explanation:
        "Il faut avoir au moins 17 ans pour obtenir un permis de conduire en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand doit-on utiliser les feux de croisement ?",
    options: [
      "En pleine nuit",
      "Lorsque la visibilité est réduite",
      "En pleine journée",
    ],
    answer: "Lorsque la visibilité est réduite",
    explanation:
        "Les feux de croisement doivent être utilisés pour une meilleure visibilité dans des conditions de faible lumière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que faut-il faire à un stop ?",
    options: [
      "Accélérer pour passer",
      "S'arrêter et céder le passage",
      "Continuer sans ralentir",
    ],
    answer: "S'arrêter et céder le passage",
    explanation:
        "Au stop, il est obligatoire de s'arrêter et de céder le passage aux autres usagers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la signification d'une ligne continue sur la route ?",
    options: [
      "Dépassement autorisé",
      "Dépassement interdit",
      "Zone de stationnement",
    ],
    answer: "Dépassement interdit",
    explanation:
        "Une ligne continue indique que le dépassement est interdit pour des raisons de sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel document doit-on présenter lors d'un contrôle de police en voiture ?",
    options: [
      "La carte d'identité",
      "Le certificat d'immatriculation",
      "Le relevé d'identité bancaire",
    ],
    answer: "Le certificat d'immatriculation",
    explanation:
        "Le certificat d'immatriculation est requis lors des contrôles de police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert un triangle de pré-signalisation ?",
    options: [
      "À prévenir d'un accident",
      "À marquer une zone de danger",
      "À signaler un véhicule en panne",
    ],
    answer: "À signaler un véhicule en panne",
    explanation:
        "Le triangle de pré-signalisation avertit les autres conducteurs d'un véhicule en panne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau de limitation de vitesse de 50 km/h ?",
    options: [
      "Vitesse minimum",
      "Vitesse maximum autorisée",
      "Vitesse recommandée",
    ],
    answer: "Vitesse maximum autorisée",
    explanation:
        "Ce panneau indique la vitesse maximale autorisée sur cette route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel équipement de sécurité est obligatoire pour les motocyclistes en France ?",
    options: ["Gants de moto", "Casque", "Veste en cuir"],
    answer: "Casque",
    explanation:
        "Le port du casque est obligatoire pour la sécurité des motocyclistes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quelle distance d'un passage piéton doit-on stationner ?",
    options: ["5 mètres", "10 mètres", "15 mètres"],
    answer: "5 mètres",
    explanation:
        "Il est interdit de stationner à moins de 5 mètres d'un passage piéton.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire en cas d'accident avec dégâts matériels ?",
    options: [
      "Prendre la fuite",
      "Échanger les informations avec l'autre conducteur",
      "Attendre les secours sans rien faire",
    ],
    answer: "Échanger les informations avec l'autre conducteur",
    explanation:
        "Il est crucial d'échanger les informations pour assurer un bon suivi des assurances.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel panneau indique qu'un virage dangereux se profile ?",
    options: [
      "Panneau de virage à droite",
      "Panneau de virage à gauche",
      "Panneau de chute de pierres",
    ],
    answer: "Panneau de virage à droite",
    explanation:
        "Ce panneau avertit les conducteurs d'un virage dangereux à venir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'avantage principal des ronds-points ?",
    options: [
      "Réduction des collisions",
      "Augmentation du temps de trajet",
      "Diminution du nombre de véhicules",
    ],
    answer: "Réduction des collisions",
    explanation:
        "Les ronds-points permettent de réduire les risques de collisions à des intersections.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit faire un conducteur à un feu jaune ?",
    options: [
      "Accélérer pour passer",
      "S'arrêter sauf si dangereux",
      "Continuer normalement",
    ],
    answer: "S'arrêter sauf si dangereux",
    explanation:
        "Le feu jaune signifie qu'il faut s'arrêter, sauf si cela entraînerait une situation dangereuse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la signification d'une flèche verte dans une voie de bus ?",
    options: [
      "Autorisé à doubler",
      "Intersection à venir",
      "Voie réservée aux bus",
    ],
    answer: "Voie réservée aux bus",
    explanation:
        "Une flèche verte indique que la voie est réservée pour les véhicules de transport en commun.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert un appareil de contrôle de vitesse (radar) ?",
    options: [
      "À surveiller le comportement des piétons",
      "À contrôler la vitesse des véhicules",
      "À mesurer la distance sur la route",
    ],
    answer: "À contrôler la vitesse des véhicules",
    explanation:
        "Les radars sont utilisés pour surveiller les excès de vitesse des conducteurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel âge minimum faut-il avoir pour conduire une voiture sans accompagnateur ?",
    options: ["16 ans", "17 ans", "21 ans"],
    answer: "17 ans",
    explanation:
        "Il faut avoir au moins 17 ans pour conduire sans accompagnateur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le but des marquages au sol tels que des lignes discontinues ?",
    options: [
      "Favoriser le stationnement",
      "Indiquer les voies de circulation",
      "Restreindre la vitesse",
    ],
    answer: "Indiquer les voies de circulation",
    explanation:
        "Les lignes discontinues délimitent les voies de circulation et indiquent le dépassement possible.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel équipement est recommandé pour les enfants en bas âge dans une voiture ?",
    options: ["Siège auto", "Rehausseur", "Ceinture de sécurité normale"],
    answer: "Siège auto",
    explanation:
        "Un siège auto est indispensable pour garantir la sécurité des jeunes enfants en voiture.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle du gendarme sur la route ?",
    options: [
      "De faire la circulation uniquement",
      "De contrôler les infractions",
      "D'effectuer des contraventions uniquement",
    ],
    answer: "De contrôler les infractions",
    explanation:
        "Le gendarme a pour mission principale de faire respecter le code de la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet principal de la vitesse excessive ?",
    options: [
      "Amélioration du temps de trajet",
      "Augmentation du risque d'accidents",
      "Réduction de la consommation de carburant",
    ],
    answer: "Augmentation du risque d'accidents",
    explanation:
        "La vitesse excessive augmente considérablement le risque d'accidents de la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel type de panneau indique une interdiction ?",
    options: ["Panneau bleu", "Panneau rond rouge", "Panneau carré vert"],
    answer: "Panneau rond rouge",
    explanation:
        "Le panneau rond rouge signale une interdiction de circulation ou d'action.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le motif de la révision technique d'un véhicule ?",
    options: [
      "Amélioration esthétique",
      "Contrôle de sécurité",
      "Augmentation de la vitesse",
    ],
    answer: "Contrôle de sécurité",
    explanation:
        "La révision technique vise à s'assurer que le véhicule est en état de sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet de l'usage du téléphone au volant ?",
    options: [
      "Amélioration de la concentration",
      "Diminution de la vigilance",
      "Augmentation de la vitesse de réaction",
    ],
    answer: "Diminution de la vigilance",
    explanation:
        "L'utilisation du téléphone au volant nuit à la concentration et augmente le risque d'accidents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la première conséquence d'un non-respect de la distance de sécurité ?",
    options: [
      "Diminution de la consommation de carburant",
      "Augmentation du risque de collision",
      "Réduction de la vitesse",
    ],
    answer: "Augmentation du risque de collision",
    explanation:
        "Ne pas respecter la distance de sécurité augmente le risque d'accidents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la signification d'un panneau triangulaire avec un point d'exclamation ?",
    options: [
      "Danger potentiel",
      "Interdiction d'accès",
      "Avertissement de passage piéton",
    ],
    answer: "Danger potentiel",
    explanation:
        "Ce panneau avertit les conducteurs d'un danger potentiel à venir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau de signalisation en forme de losange ?",
    options: ["Avertissement", "Interdiction", "Ordre"],
    answer: "Avertissement",
    explanation:
        "Le losange est utilisé pour signaler un avertissement aux conducteurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel type de virage est marqué par un panneau en forme de flèche à droite ?",
    options: ["Virage à gauche", "Virage à droite", "U-turn"],
    answer: "Virage à droite",
    explanation:
        "Le panneau en forme de flèche indique un virage à droite à venir.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand faut-il utiliser les feux de route ?",
    options: [
      "À tout moment",
      "Lorsque la route est déserte",
      "En agglomération dense",
    ],
    answer: "Lorsque la route est déserte",
    explanation:
        "Les feux de route doivent être utilisés lorsque la route est suffisamment dégagée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal effet de la vitesse sur la distance d'arrêt ?",
    options: [
      "Aucune effet",
      "Augmentation de la distance d'arrêt",
      "Réduction de la distance d'arrêt",
    ],
    answer: "Augmentation de la distance d'arrêt",
    explanation:
        "Une vitesse plus élevée augmente la distance nécessaire pour s'arrêter.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que doit faire un conducteur lorsqu'il rencontre un véhicule de secours en intervention ?",
    options: [
      "Continuer à rouler",
      "Céder le passage",
      "Accélérer pour le doubler",
    ],
    answer: "Céder le passage",
    explanation:
        "Il est impératif de céder le passage aux véhicules de secours en intervention.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert un rond-point ?",
    options: [
      "À permettre des croisements par la droite",
      "À faciliter la circulation",
      "À forcer les véhicules à s'arrêter",
    ],
    answer: "À faciliter la circulation",
    explanation:
        "Les ronds-points sont conçus pour fluidifier le trafic en réduisant les arrêts.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'effet du port de la ceinture de sécurité lors d'un choc ?",
    options: [
      "Augmente la gravité des blessures",
      "Réduit le risque d'être éjecté",
      "N'a aucun effet",
    ],
    answer: "Réduit le risque d'être éjecté",
    explanation:
        "La ceinture de sécurité protège les occupants en les maintenant dans leur siège lors d'un choc.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal danger de la conduite en état de fatigue ?",
    options: [
      "Amélioration de la concentration",
      "Diminution de la vigilance",
      "Aucune conséquence",
    ],
    answer: "Diminution de la vigilance",
    explanation:
        "La fatigue affecte directement la vigilance et les réflexes du conducteur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but d'un sens interdit ?",
    options: [
      "Faciliter l'accès",
      "Prévenir les accidents",
      "Interdire de circuler dans cette direction",
    ],
    answer: "Interdire de circuler dans cette direction",
    explanation:
        "Le sens interdit indique qu'il est interdit de circuler dans cette direction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que représente un panneau de signalisation en forme de cercle bleu avec une barre blanche ?",
    options: [
      "Obligation d'arrêt",
      "Interdiction de dépasser",
      "Voie de circulation obligatoire",
    ],
    answer: "Voie de circulation obligatoire",
    explanation:
        "Ce panneau indique qu'il faut suivre la direction indiquée par le panneau.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal risque de la conduite sous l'emprise des médicaments ?",
    options: [
      "Diminution de la concentration",
      "Amélioration des réflexes",
      "Aucune influence",
    ],
    answer: "Diminution de la concentration",
    explanation:
        "Les médicaments peuvent altérer la concentration et les capacités de conduite.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Pourquoi est-il obligatoire de porter un casque à vélo ?",
    options: ["Pour le confort", "Pour la sécurité", "Pour l'esthétique"],
    answer: "Pour la sécurité",
    explanation:
        "Le casque est crucial pour protéger la tête en cas de chute ou d'accident.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle principal de la signalisation routière ?",
    options: [
      "Décorer les routes",
      "Informer et orienter les conducteurs",
      "Imposer des comportements",
    ],
    answer: "Informer et orienter les conducteurs",
    explanation:
        "La signalisation routière sert à informer les usagers et à réguler la circulation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel panneau indique une route glissante ?",
    options: [
      "Panneau de danger",
      "Panneau de limitation de vitesse",
      "Panneau d'alerte",
    ],
    answer: "Panneau de danger",
    explanation:
        "Ce panneau avertit les conducteurs d'une route glissante pour prévenir les accidents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit faire un conducteur qui souhaite changer de voie ?",
    options: [
      "Signaler son intention",
      "Accélérer et changer de voie rapidement",
      "Changer de voie sans avertir",
    ],
    answer: "Signaler son intention",
    explanation:
        "Il est essentiel de signaler son intention de changer de voie pour prévenir les autres conducteurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet d'un dépassement sur une ligne continue ?",
    options: [
      "Aucune conséquence",
      "Infraction au code de la route",
      "Amélioration du temps de trajet",
    ],
    answer: "Infraction au code de la route",
    explanation:
        "Dépassement sur une ligne continue constitue une infraction au code de la route.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la limite de vitesse sur autoroute en France pour les voitures particulières ?",
    options: ["130 km/h", "110 km/h", "150 km/h"],
    answer: "130 km/h",
    explanation:
        "La limite de vitesse sur autoroute pour les voitures particulières est de 130 km/h.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire quand on approche d'un passage piéton ?",
    options: [
      "Accélérer pour passer rapidement",
      "Ralentir et être prêt à s'arrêter",
      "Klaxonner pour avertir les piétons",
    ],
    answer: "Ralentir et être prêt à s'arrêter",
    explanation:
        "Il est essentiel de ralentir et de se préparer à s'arrêter si des piétons traversent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel panneau indique un danger ?",
    options: [
      "Signal de priorité",
      "Panneau d'avertissement",
      "Panneau de sortie",
    ],
    answer: "Panneau d'avertissement",
    explanation:
        "Un panneau d'avertissement signale un danger potentiel sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le taux d'alcoolémie autorisé pour les conducteurs novices en France ?",
    options: ["0,2 g/l", "0,5 g/l", "0,8 g/l"],
    answer: "0,2 g/l",
    explanation:
        "Les conducteurs novices doivent respecter un taux d'alcoolémie de 0,2 g/l.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la distance de sécurité recommandée entre deux voitures sur autoroute ?",
    options: ["10 mètres", "20 mètres", "50 mètres"],
    answer: "50 mètres",
    explanation:
        "Il est recommandé de garder une distance d'au moins 50 mètres entre deux voitures sur autoroute.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quel moment doit-on mettre son clignotant ?",
    options: ["Avant de tourner", "Après avoir tourné", "En ligne droite"],
    answer: "Avant de tourner",
    explanation:
        "Il faut toujours utiliser le clignotant avant de changer de direction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que doit faire un conducteur qui souhaite dépasser un autre véhicule ?",
    options: [
      "Faire un signe avec la main",
      "Vérifier les rétroviseurs et signaler",
      "Accélérer sans prévenir",
    ],
    answer: "Vérifier les rétroviseurs et signaler",
    explanation:
        "Il est crucial de vérifier les rétroviseurs et de signaler avant de dépasser.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'un agent de police sur la route ?",
    options: [
      "Présenter des contraventions",
      "Assurer la sécurité",
      "Contrôler la vitesse uniquement",
    ],
    answer: "Assurer la sécurité",
    explanation:
        "L'agent de police a pour rôle principal d'assurer la sécurité sur la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que représente un triangle de signalisation ?",
    options: ["Accident", "Interdiction", "Danger"],
    answer: "Danger",
    explanation:
        "Le triangle de signalisation indique la présence d'un danger sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Lorsqu'un véhicule d'urgence approche, que devez-vous faire ?",
    options: [
      "Accélérer pour dégager le passage",
      "Rester sur la voie",
      "Se ranger sur le côté",
    ],
    answer: "Se ranger sur le côté",
    explanation:
        "Il est essentiel de se ranger sur le côté pour laisser passer les véhicules d'urgence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'une zone 30 ?",
    options: [
      "Une zone de stationnement",
      "Une zone de circulation à 30 km/h maximum",
      "Une zone de piètons",
    ],
    answer: "Une zone de circulation à 30 km/h maximum",
    explanation: "Une zone 30 indique une limitation de vitesse à 30 km/h.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel document est obligatoire d'avoir en conduisant ?",
    options: ["Carte grise", "Permis de conduire", "Contrat d'assurance"],
    answer: "Permis de conduire",
    explanation:
        "Le permis de conduire est indispensable pour conduire légalement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment signaler une intention de tourner à gauche ?",
    options: ["Clignoter à droite", "Clignoter à gauche", "Ne rien faire"],
    answer: "Clignoter à gauche",
    explanation:
        "Il faut utiliser le clignotant à gauche pour signaler un virage à gauche.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but du contrôle technique ?",
    options: [
      "Vérifier les compétences du conducteur",
      "S'assurer que le véhicule est en bon état",
      "Renvoyer le véhicule à l'usine",
    ],
    answer: "S'assurer que le véhicule est en bon état",
    explanation:
        "Le contrôle technique garantit que le véhicule est conforme et en bon état de fonctionnement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire en cas d'accident sans blessé ?",
    options: [
      "Rester sur place et attendre les secours",
      "Echanger des informations avec l'autre conducteur",
      "S'en aller rapidement",
    ],
    answer: "Echanger des informations avec l'autre conducteur",
    explanation:
        "Il est important d'échanger les coordonnées et les informations d'assurance avec l'autre conducteur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qui doit céder le passage dans un rond-point ?",
    options: [
      "Les véhicules à l'intérieur",
      "Les véhicules entrant",
      "Aucun en particulier",
    ],
    answer: "Les véhicules entrant",
    explanation:
        "Dans un rond-point, les véhicules entrant doivent céder le passage à ceux qui sont déjà à l'intérieur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal facteur de risque d'accident de la route ?",
    options: [
      "Les conditions météorologiques",
      "La vitesse excessive",
      "La fatigue",
    ],
    answer: "La vitesse excessive",
    explanation:
        "La vitesse excessive est l'un des principaux facteurs contribuant aux accidents de la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert un gilet de sécurité dans un véhicule ?",
    options: [
      "À être vu en cas de panne",
      "À se protéger des intempéries",
      "À signaler un accident",
    ],
    answer: "À être vu en cas de panne",
    explanation:
        "Le gilet de sécurité permet d'augmenter la visibilité du conducteur en cas de panne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des panneaux lumineux sur la route ?",
    options: [
      "Informer sur les conditions de circulation",
      "Indiquer la vitesse minimale",
      "Avertir des radars",
    ],
    answer: "Informer sur les conditions de circulation",
    explanation:
        "Les panneaux lumineux informent les conducteurs des conditions de circulation en temps réel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on vérifier avant de prendre la route ?",
    options: [
      "Le niveau d'huile",
      "Le nombre de passagers",
      "La couleur de la voiture",
    ],
    answer: "Le niveau d'huile",
    explanation:
        "Vérifier le niveau d'huile est essentiel pour assurer le bon fonctionnement du moteur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la signification du panneau 'A' ?",
    options: ["Aire de repos", "Zone d'accélération", "Zone d'accident"],
    answer: "Zone d'accélération",
    explanation:
        "Le panneau 'A' indique une zone d'accélération pour les véhicules entrant sur la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif principal des radars automatiques ?",
    options: [
      "Contrôler la vitesse",
      "Flasher les automobilistes",
      "Surveiller les piétons",
    ],
    answer: "Contrôler la vitesse",
    explanation:
        "Les radars automatiques sont utilisés pour contrôler la vitesse des véhicules sur la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un feu vert clignotant ?",
    options: [
      "Passage autorisé avec prudence",
      "Feu hors service",
      "Passage obligatoire",
    ],
    answer: "Passage autorisé avec prudence",
    explanation:
        "Un feu vert clignotant indique que le passage est autorisé, mais avec prudence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel équipement est essentiel pour un cycliste en ville ?",
    options: ["Un casque", "Un klaxon", "Un gilet"],
    answer: "Un casque",
    explanation:
        "Le port du casque est essentiel pour la sécurité des cyclistes en milieu urbain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal but des zones piétonnes ?",
    options: [
      "Faciliter le transit des véhicules",
      "Réduire la pollution",
      "Protéger les piétons",
    ],
    answer: "Protéger les piétons",
    explanation:
        "Les zones piétonnes sont créées pour protéger la sécurité des piétons.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que représente un panneau bleu avec une flèche blanche ?",
    options: ["Interdiction", "Sens unique", "Aire de stationnement"],
    answer: "Sens unique",
    explanation:
        "Un panneau bleu avec une flèche blanche indique un sens de circulation unique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but de l'éthylotest ?",
    options: [
      "Mesurer la vitesse",
      "Analyser l'alcoolémie",
      "Contrôler la fatigue",
    ],
    answer: "Analyser l'alcoolémie",
    explanation:
        "L'éthylotest est utilisé pour mesurer le taux d'alcool dans le sang.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que dit la loi concernant l'utilisation du téléphone portable en conduisant ?",
    options: [
      "C'est autorisé si l'on utilise un kit mains libres",
      "C'est totalement interdit",
      "C'est recommandé de ne pas l'utiliser",
    ],
    answer: "C'est totalement interdit",
    explanation:
        "La loi interdit l'utilisation du téléphone portable en conduisant, même avec un kit mains libres.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Lorsqu'un feu est orange, que faut-il faire ?",
    options: [
      "Continuer à rouler à vitesse normale",
      "Accélérer pour passer avant le rouge",
      "Ralentir et se préparer à s'arrêter",
    ],
    answer: "Ralentir et se préparer à s'arrêter",
    explanation:
        "Lorsque le feu est orange, il faut ralentir et se préparer à s'arrêter avant le rouge.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "À quel moment un conducteur doit-il allumer ses feux de croisement ?",
    options: ["À la tombée de la nuit", "Lorsqu'il pleut", "Dans les tunnels"],
    answer: "À la tombée de la nuit",
    explanation:
        "Les feux de croisement doivent être allumés à la tombée de la nuit pour une meilleure visibilité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal risque lié au dépassement sur autoroute ?",
    options: [
      "Accident de faible gravité",
      "Collision frontale",
      "Accident de voiture à l'arrêt",
    ],
    answer: "Collision frontale",
    explanation:
        "Le principal risque en dépassant sur autoroute est de provoquer une collision frontale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel comportement adopter en cas de brouillard ?",
    options: [
      "Rouler à la vitesse maximum",
      "Utiliser les feux de brouillard",
      "Accélérer pour sortir du brouillard",
    ],
    answer: "Utiliser les feux de brouillard",
    explanation:
        "Il est recommandé d'utiliser les feux de brouillard pour améliorer la visibilité en cas de brouillard.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment réagir face à un piéton sur la route ?",
    options: [
      "Accélérer pour le dépasser",
      "Ralentir et s'arrêter si nécessaire",
      "Le klaxonner pour le prévenir",
    ],
    answer: "Ralentir et s'arrêter si nécessaire",
    explanation:
        "Un conducteur doit ralentir et être prêt à s'arrêter en présence de piétons sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel panneau indique une limitation de vitesse ?",
    options: [
      "Panneau d'interdiction",
      "Panneau d'information",
      "Panneau d'avertissement",
    ],
    answer: "Panneau d'interdiction",
    explanation:
        "Un panneau indiquant une limitation de vitesse est un panneau d'interdiction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que signifie un panneau de limitation de vitesse avec un chiffre barré ?",
    options: [
      "Interdiction de dépasser",
      "Avertissement sur la vitesse",
      "Fin de la limitation de vitesse",
    ],
    answer: "Fin de la limitation de vitesse",
    explanation:
        "Un panneau avec un chiffre barré indique la fin de la limitation de vitesse précédente.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le temps de réaction moyen d'un conducteur ?",
    options: ["1 seconde", "2 secondes", "3 secondes"],
    answer: "2 secondes",
    explanation:
        "Le temps de réaction moyen d'un conducteur est généralement d'environ 2 secondes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire en cas de panne sur autoroute ?",
    options: [
      "Rester dans son véhicule",
      "Se rendre sur la voie de droite",
      "Allumer les feux de détresse",
    ],
    answer: "Allumer les feux de détresse",
    explanation:
        "Il faut allumer les feux de détresse pour signaler une panne sur autoroute.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet de la vitesse sur la distance de freinage ?",
    options: ["Aucun effet", "Elle augmente", "Elle diminue"],
    answer: "Elle augmente",
    explanation:
        "La vitesse accrue augmente considérablement la distance de freinage.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que sont les points de permis de conduire ?",
    options: [
      "Des points pour des bonus",
      "Des points de sanction",
      "Des points d'assurance",
    ],
    answer: "Des points de sanction",
    explanation:
        "Les points de permis de conduire sont des points de sanction pour les infractions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment se déplacer en toute sécurité à vélo ?",
    options: [
      "Rouler sur les trottoirs",
      "Respecter le code de la route",
      "Ne pas signaler ses intentions",
    ],
    answer: "Respecter le code de la route",
    explanation:
        "Les cyclistes doivent respecter le code de la route pour assurer leur sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact de la fatigue sur la conduite ?",
    options: [
      "Aucun impact",
      "Augmente le temps de réaction",
      "Améliore la concentration",
    ],
    answer: "Augmente le temps de réaction",
    explanation:
        "La fatigue réduit la concentration et augmente le temps de réaction au volant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Pourquoi est-il dangereux de conduire sous influence de drogues ?",
    options: [
      "Cela améliore la concentration",
      "Cela augmente les temps de réaction",
      "Cela n'a aucun impact",
    ],
    answer: "Cela augmente les temps de réaction",
    explanation:
        "Conduire sous l'influence de drogues augmente les temps de réaction et diminue la capacité de jugement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est les risques de parler au téléphone en conduisant ?",
    options: [
      "Pas de risque",
      "Distrait le conducteur",
      "Améliore la conduite",
    ],
    answer: "Distrait le conducteur",
    explanation:
        "Parler au téléphone en conduisant distrait le conducteur et augmente le risque d'accident.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel type de véhicule doit rester en dehors de la voie de secours sur autoroute ?",
    options: [
      "Les véhicules de tourisme",
      "Les poids lourds",
      "Les deux types",
    ],
    answer: "Les poids lourds",
    explanation:
        "Les poids lourds ne doivent pas utiliser la voie de secours sauf en cas d'urgence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet de l'alcool sur la conduite ?",
    options: ["Améliore le jugement", "Ralentit les réflexes", "Aucun effet"],
    answer: "Ralentit les réflexes",
    explanation:
        "L'alcool ralentit considérablement les réflexes et nuit au jugement du conducteur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quand un cycliste doit-il utiliser ses feux ?",
    options: ["La nuit", "Quand il pleut", "Tout le temps"],
    answer: "La nuit",
    explanation:
        "Un cycliste doit utiliser ses feux la nuit pour être visible par les autres usagers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Pourquoi est-il interdit de conduire avec des écouteurs ?",
    options: [
      "Cela améliore l'écoute",
      "Cela nuit à la concentration",
      "Pas de risque",
    ],
    answer: "Cela nuit à la concentration",
    explanation:
        "Porter des écouteurs en conduisant nuit à la concentration et à la perception des sons environnants.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la conséquence d'utiliser un téléphone portable en conduisant ?",
    options: [
      "Amende voire retrait de permis",
      "Pas de conséquence",
      "Amélioration de la concentration",
    ],
    answer: "Amende voire retrait de permis",
    explanation:
        "Utiliser un téléphone portable en conduisant peut entraîner une amende et potentiellement un retrait de permis.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la vitesse maximale autorisée sur autoroute en France pour les véhicules légers ?",
    options: ["110 km/h", "130 km/h", "150 km/h"],
    answer: "130 km/h",
    explanation:
        "La vitesse maximale autorisée sur autoroute pour les véhicules légers est de 130 km/h.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que signifie un panneau de signalisation rouge avec un triangle jaune à l'intérieur ?",
    options: [
      "Risque de glissade",
      "Alerte de danger",
      "Fin de zone dangereuse",
    ],
    answer: "Alerte de danger",
    explanation: "Ce panneau indique un alerte de danger sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le taux d'alcoolémie maximum autorisé pour un conducteur novice en France ?",
    options: ["0,2 g/l", "0,5 g/l", "0,8 g/l"],
    answer: "0,2 g/l",
    explanation:
        "Le taux d'alcoolémie maximum pour un conducteur novice est de 0,2 g/l.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "En cas d'accident, quelle est la première chose à faire ?",
    options: [
      "Appeler les secours",
      "Échanger des informations",
      "Déplacer les véhicules",
    ],
    answer: "Appeler les secours",
    explanation:
        "La priorité est d'appeler les secours si quelqu'un est blessé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'un 'point de permis' ?",
    options: [
      "Un stage de conduite",
      "Une infraction",
      "Une sanction administrative",
    ],
    answer: "Une infraction",
    explanation:
        "Un point de permis est retiré en cas d'infraction au code de la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet du port de la ceinture de sécurité ?",
    options: [
      "Aucun effet",
      "Réduit le risque de blessures",
      "Augmente le risque de blessures",
    ],
    answer: "Réduit le risque de blessures",
    explanation:
        "Le port de la ceinture de sécurité réduit significativement le risque de blessures en cas d'accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau de limitation de vitesse de 50 km/h ?",
    options: ["Vitesse minimale", "Vitesse maximale", "Vitesse conseillée"],
    answer: "Vitesse maximale",
    explanation:
        "Ce panneau indique la vitesse maximale autorisée sur cette route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel équipement est obligatoire pour un conducteur de deux-roues motorisé ?",
    options: ["Gants", "Casque", "Veste réfléchissante"],
    answer: "Casque",
    explanation:
        "Le port du casque est obligatoire pour tous les conducteurs de deux-roues motorisés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'un feux tricolore ?",
    options: [
      "Réguler le trafic",
      "Indiquer la distance",
      "Informer sur la météo",
    ],
    answer: "Réguler le trafic",
    explanation:
        "Le feux tricolore a pour rôle de réguler le trafic à un carrefour.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que devez-vous faire en cas d'aquaplaning ?",
    options: [
      "Accélérer",
      "Ne pas freiner brutalement",
      "Tourner le volant rapidement",
    ],
    answer: "Ne pas freiner brutalement",
    explanation:
        "Il est crucial de ne pas freiner brutalement pour éviter de perdre le contrôle du véhicule.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "À quelle distance doit-on placer un triangle de présignalisation en cas d'accident ?",
    options: ["10 mètres", "30 mètres", "50 mètres"],
    answer: "30 mètres",
    explanation:
        "Le triangle de présignalisation doit être placé à 30 mètres derrière le véhicule en panne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'âge minimum pour obtenir un permis de conduire B en France ?",
    options: ["16 ans", "17 ans", "21 ans"],
    answer: "17 ans",
    explanation:
        "L'âge minimum requis pour obtenir un permis de conduire B est de 17 ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que représente une ligne continue sur la route ?",
    options: [
      "Interdiction de doubler",
      "Zone de stationnement",
      "Zone de dépassement",
    ],
    answer: "Interdiction de doubler",
    explanation: "Une ligne continue indique une interdiction de doubler.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la première cause d'accidents de la route en France ?",
    options: ["L'alcool au volant", "Les excès de vitesse", "L'inattention"],
    answer: "L'inattention",
    explanation:
        "L'inattention est la première cause d'accidents de la route en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est l'importance du klaxon ?",
    options: [
      "Attirer l'attention",
      "Avertir d'un danger",
      "Réprimander un autre conducteur",
    ],
    answer: "Avertir d'un danger",
    explanation:
        "Le klaxon sert principalement à avertir d'un danger imminent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle de l'alcoolémie dans la conduite ?",
    options: [
      "Améliorer la concentration",
      "Diminuer les réflexes",
      "Rendre plus prudent",
    ],
    answer: "Diminuer les réflexes",
    explanation:
        "L'alcool diminue les réflexes et les capacités de réaction du conducteur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la sanction pour un excès de vitesse de plus de 50 km/h ?",
    options: ["Amende de 135 euros", "Retrait de permis", "Peine de prison"],
    answer: "Retrait de permis",
    explanation:
        "Un excès de vitesse de plus de 50 km/h peut entraîner un retrait de permis.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la couleur d'un panneau 'Cédez le passage' ?",
    options: ["Vert", "Bleu", "Jaune"],
    answer: "Jaune",
    explanation: "Le panneau 'Cédez le passage' est de couleur jaune.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie une route à double sens de circulation ?",
    options: [
      "Circulation à sens unique",
      "Circulation alternée",
      "Circulation dans les deux sens",
    ],
    answer: "Circulation dans les deux sens",
    explanation:
        "Une route à double sens permet la circulation dans les deux directions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire en cas de brouillard ?",
    options: [
      "Allumer ses feux de croisement",
      "Accélérer",
      "Roulant avec les feux de route",
    ],
    answer: "Allumer ses feux de croisement",
    explanation:
        "Il est conseillé d'allumer ses feux de croisement en cas de brouillard.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but d'un contrôle routier ?",
    options: [
      "Améliorer le flux de trafic",
      "Vérifier la conformité des véhicules",
      "Récupérer les contraventions",
    ],
    answer: "Vérifier la conformité des véhicules",
    explanation:
        "Le contrôle routier vise à vérifier la conformité des véhicules et des conducteurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel équipement de sécurité est obligatoire pour les enfants dans une voiture ?",
    options: ["Siège auto", "Ceinture de sécurité", "Veste réfléchissante"],
    answer: "Siège auto",
    explanation:
        "Un siège auto est obligatoire pour la sécurité des enfants en voiture.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact de la vitesse sur la distance d'arrêt ?",
    options: [
      "Pas d'impact",
      "Augmente la distance d'arrêt",
      "Diminue la distance d'arrêt",
    ],
    answer: "Augmente la distance d'arrêt",
    explanation:
        "Une vitesse plus élevée augmente la distance nécessaire pour s'arrêter.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le signe d'un véhicule de secours ?",
    options: [
      "Lumière bleue clignotante",
      "Lumière rouge clignotante",
      "Lumière verte clignotante",
    ],
    answer: "Lumière bleue clignotante",
    explanation:
        "Les véhicules de secours utilisent une lumière bleue clignotante.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie le mot 'avertir' dans le cadre de la conduite ?",
    options: ["Signaler un danger", "Circuler plus vite", "Stationner"],
    answer: "Signaler un danger",
    explanation: "Avertir signifie signaler un danger potentiel sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des ronds-points dans la circulation ?",
    options: [
      "Accélérer le trafic",
      "Ralentir les véhicules",
      "Faciliter les changements de direction",
    ],
    answer: "Faciliter les changements de direction",
    explanation:
        "Les ronds-points facilitent les changements de direction en réduisant les conflits de circulation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet de la fatigue sur la conduite ?",
    options: [
      "Améliore la concentration",
      "Ralentit les réflexes",
      "N'a pas d'effet",
    ],
    answer: "Ralentit les réflexes",
    explanation:
        "La fatigue ralentit les réflexes et peut compromettre la sécurité au volant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la fonction des feux de détresse ?",
    options: [
      "Avertir d'une panne",
      "Indiquer une vitesse excessive",
      "Signaliser une manœuvre",
    ],
    answer: "Avertir d'une panne",
    explanation:
        "Les feux de détresse servent à avertir les autres usagers d'une panne ou d'un danger.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie une ligne discontinue sur la route ?",
    options: [
      "Dépassement autorisé",
      "Dépassement interdit",
      "Zone de stationnement",
    ],
    answer: "Dépassement autorisé",
    explanation:
        "Une ligne discontinue indique qu'un dépassement est autorisé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la durée de validité d'un contrôle technique en France ?",
    options: ["1 an", "2 ans", "3 ans"],
    answer: "2 ans",
    explanation: "La validité d'un contrôle technique est de 2 ans.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but d'un radar automatique ?",
    options: [
      "Vérifier la vitesse",
      "Surveiller le trafic",
      "Compter les véhicules",
    ],
    answer: "Vérifier la vitesse",
    explanation:
        "Les radars automatiques sont installés pour contrôler la vitesse des véhicules.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire lorsque l'on approche d'un passage piéton ?",
    options: [
      "Accélérer",
      "Ralentir et céder le passage",
      "Ignorer le passage",
    ],
    answer: "Ralentir et céder le passage",
    explanation:
        "Il faut ralentir et céder le passage aux piétons qui traversent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif principal du permis à points ?",
    options: [
      "Encourager les infractions",
      "Améliorer la sécurité routière",
      "Éliminer les conducteurs",
    ],
    answer: "Améliorer la sécurité routière",
    explanation:
        "L'objectif principal du permis à points est d'améliorer la sécurité routière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'un feu de croisement ?",
    options: [
      "Un feu qui indique la vitesse",
      "Un feu pour les virages",
      "Un feu pour la circulation nocturne",
    ],
    answer: "Un feu pour la circulation nocturne",
    explanation:
        "Le feu de croisement est utilisé pour la circulation de nuit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment réagir face à un piéton sur un passage clouté ?",
    options: [
      "Accélérer pour le dépasser",
      "S'arrêter si nécessaire",
      "Klaxonner",
    ],
    answer: "S'arrêter si nécessaire",
    explanation:
        "Il faut s'arrêter pour laisser passer le piéton sur un passage clouté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'un gendarme routier ?",
    options: [
      "Contrôler le respect des règles",
      "Vendre des contraventions",
      "Aider à chercher des passagers",
    ],
    answer: "Contrôler le respect des règles",
    explanation:
        "Le gendarme routier contrôle le respect des règles de circulation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que doit contenir un véhicule pour être conforme à la législation ?",
    options: [
      "Un extincteur et une trousse de secours",
      "Des pneus neufs seulement",
      "Un GPS",
    ],
    answer: "Un extincteur et une trousse de secours",
    explanation:
        "Un extincteur et une trousse de secours sont nécessaires pour la conformité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'une ligne d'arrêt ?",
    options: [
      "Indiquer un stop",
      "Signaler une vitesse maximale",
      "Indiquer une zone d'interdiction",
    ],
    answer: "Indiquer un stop",
    explanation: "Une ligne d'arrêt indique un stop ou un cédez le passage.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "En cas de panne, que doit-on faire en premier lieu ?",
    options: [
      "Appeler un dépanneur",
      "Rester dans son véhicule",
      "Chercher une aide",
    ],
    answer: "Rester dans son véhicule",
    explanation:
        "En cas de panne, il est conseillé de rester dans son véhicule pour plus de sécurité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le danger de l'utilisation du téléphone au volant ?",
    options: [
      "Aucun danger",
      "Augmente le risque d'accidents",
      "Améliore la concentration",
    ],
    answer: "Augmente le risque d'accidents",
    explanation:
        "L'utilisation du téléphone au volant augmente considérablement le risque d'accidents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel équipement est prohibé lors de la conduite ?",
    options: ["Un téléphone portable", "Un GPS", "Un système audio"],
    answer: "Un téléphone portable",
    explanation:
        "L'utilisation d'un téléphone portable est prohibée lors de la conduite.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau 'fin de limitation de vitesse' ?",
    options: [
      "Vitesse maximale à respecter",
      "Aucune vitesse maximale",
      "Vitesse minimale",
    ],
    answer: "Aucune vitesse maximale",
    explanation:
        "Ce panneau indique qu'il n'y a plus de limitation de vitesse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle de l'assurance automobile ?",
    options: [
      "Protéger les conducteurs",
      "Couvrir les frais de carburant",
      "Offrir des réductions",
    ],
    answer: "Protéger les conducteurs",
    explanation:
        "L'assurance automobile protège les conducteurs en cas d'accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire lors d'un slalom sur route ?",
    options: ["Rouler vite", "Rester attentif", "Ignorer les obstacles"],
    answer: "Rester attentif",
    explanation:
        "Il est crucial de rester attentif lors d'un slalom sur la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que représente un panneau de danger ?",
    options: [
      "Une restriction de vitesse",
      "Un avertissement de danger",
      "Une indication de direction",
    ],
    answer: "Un avertissement de danger",
    explanation:
        "Un panneau de danger signale un risque ou un danger sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la fonction des zones 30 ?",
    options: [
      "Accélérer le trafic",
      "Ralentir la circulation",
      "Augmenter la pollution",
    ],
    answer: "Ralentir la circulation",
    explanation:
        "Les zones 30 sont mises en place pour ralentir la circulation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la sanction pour avoir conduit sans permis ?",
    options: ["Amende de 100 euros", "Peine de prison", "Amende de 750 euros"],
    answer: "Amende de 750 euros",
    explanation:
        "Conduire sans permis peut entraîner une amende allant jusqu'à 750 euros.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment reconnaître un véhicule à moteur hybride ?",
    options: ["Par son bruit", "Par son aspect", "Par l'étiquette"],
    answer: "Par l'étiquette",
    explanation:
        "Un véhicule à moteur hybride est généralement identifiable par une étiquette spécifique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal but du code de la route ?",
    options: [
      "Protéger les piétons",
      "Réglementer la circulation",
      "Augmenter les contraventions",
    ],
    answer: "Réglementer la circulation",
    explanation:
        "Le code de la route établit des règles pour assurer la sécurité et le bon fonctionnement de la circulation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "À quelle distance minimale doit-on mettre ses feux de détresse lors d’un arrêt sur la voie publique ?",
    options: ["30 mètres", "50 mètres", "100 mètres"],
    answer: "30 mètres",
    explanation:
        "Les feux de détresse doivent être placés à au moins 30 mètres pour avertir les autres usagers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la limite légale d'alcool dans le sang pour les conducteurs en France ?",
    options: ["0,2 g/L", "0,5 g/L", "0,8 g/L"],
    answer: "0,5 g/L",
    explanation:
        "La limite légale d'alcool pour les conducteurs est fixée à 0,5 g/L.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal danger du téléphone au volant ?",
    options: [
      "Il distrait le conducteur",
      "Il fait perdre du temps",
      "Il consomme de la batterie",
    ],
    answer: "Il distrait le conducteur",
    explanation:
        "L'utilisation du téléphone au volant nuit à la concentration et augmente le risque d'accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que signifie un panneau de signalisation avec un triangle rouge ?",
    options: ["Interdiction", "Danger", "Avertissement"],
    answer: "Avertissement",
    explanation:
        "Un triangle rouge indique un danger ou une situation à risque à venir.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle principal des ronds-points ?",
    options: [
      "Faciliter la circulation",
      "Augmenter la vitesse",
      "Réduire le bruit",
    ],
    answer: "Faciliter la circulation",
    explanation:
        "Les ronds-points permettent de fluidifier le trafic et de réduire les arrêts.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment doit-on réagir face à un feu rouge ?",
    options: ["Accélérer pour passer", "S'arrêter", "Ralentir"],
    answer: "S'arrêter",
    explanation: "Un feu rouge indique de manière claire qu'il faut s'arrêter.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel type de ceinture de sécurité est obligatoire pour les passagers arrière ?",
    options: ["Aucune", "Ceinture classique", "Ceinture à trois points"],
    answer: "Ceinture à trois points",
    explanation:
        "Les ceintures à trois points sont obligatoires pour tous les passagers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal effet de l'excès de vitesse ?",
    options: [
      "Augmentation de la consommation de carburant",
      "Diminution du temps de trajet",
      "Risque accru d'accidents",
    ],
    answer: "Risque accru d'accidents",
    explanation:
        "Rouler au-dessus de la limite de vitesse augmente significativement le risque d'accidents.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel équipement est obligatoire pour les motos en France ?",
    options: ["Un klaxon", "Un gilet fluorescent", "Un pare-brise"],
    answer: "Un gilet fluorescent",
    explanation:
        "Les motards doivent porter un gilet fluorescent pour être visibles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qui peut conduire à une suspension de permis ?",
    options: [
      "Un stationnement gênant",
      "Une conduite sous influence",
      "Un non-respect du code de la route",
    ],
    answer: "Une conduite sous influence",
    explanation:
        "Conduire sous l'influence de l'alcool ou de drogues peut entraîner une suspension de permis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert l'alcooltest sur les routes ?",
    options: [
      "Pour contrôler la vitesse",
      "Pour vérifier l'absence de trafic",
      "Pour mesurer le taux d'alcoolémie",
    ],
    answer: "Pour mesurer le taux d'alcoolémie",
    explanation:
        "L'alcooltest permet de contrôler le taux d'alcool dans le sang des conducteurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel document doit-on avoir à bord d'un véhicule ?",
    options: ["Carte grise", "Certificat médical", "Permis de construire"],
    answer: "Carte grise",
    explanation:
        "La carte grise, ou certificat d'immatriculation, est obligatoire dans le véhicule.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la signification d'un panneau avec un cercle rouge et une barre transversale ?",
    options: [
      "Interdiction d'accès",
      "Zone de danger",
      "Limitation de vitesse",
    ],
    answer: "Interdiction d'accès",
    explanation:
        "Ce panneau indique une interdiction d'accès pour tous les véhicules.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire avant de doubler un véhicule ?",
    options: [
      "S'assurer que la voie est libre",
      "Accélérer",
      "Allumer les feux de détresse",
    ],
    answer: "S'assurer que la voie est libre",
    explanation:
        "Il est crucial de vérifier que la voie est dégagée avant de doubler.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet des phares de croisement la nuit ?",
    options: [
      "Éclairer la route",
      "Réduire l'éblouissement",
      "Avertir les piétons",
    ],
    answer: "Éclairer la route",
    explanation:
        "Les phares de croisement sont conçus pour éclairer la route pendant la nuit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'un gilet de sécurité dans un véhicule ?",
    options: [
      "Pour être visible en cas d'accident",
      "Pour se protéger des intempéries",
      "Pour signaler une panne",
    ],
    answer: "Pour être visible en cas d'accident",
    explanation:
        "Le gilet de sécurité est vital pour assurer la visibilité d'un conducteur en panne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'une zone 30 ?",
    options: [
      "Une zone à vitesse réduite",
      "Une zone de stationnement",
      "Une zone piétonne",
    ],
    answer: "Une zone à vitesse réduite",
    explanation:
        "Une zone 30 impose une limitation de vitesse à 30 km/h pour assurer la sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact d'un feu orange au feu tricolore ?",
    options: [
      "S'arrêter immédiatement",
      "Préparer à s'arrêter",
      "Accélérer pour passer",
    ],
    answer: "Préparer à s'arrêter",
    explanation:
        "Un feu orange indique qu'il est temps de ralentir et de se préparer à s'arrêter.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'avantage d'utiliser un GPS en conduisant ?",
    options: [
      "Économiser du carburant",
      "Éviter les accidents",
      "Trouver le chemin le plus rapide",
    ],
    answer: "Trouver le chemin le plus rapide",
    explanation:
        "Un GPS aide à naviguer efficacement pour atteindre la destination rapidement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau de danger avec un triangle jaune ?",
    options: ["Détour", "Avertissement de danger", "Interdiction de tourner"],
    answer: "Avertissement de danger",
    explanation: "Un triangle jaune signale un danger imminent sur la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif des radars de vitesse ?",
    options: [
      "Récupérer des amendes",
      "Contrôler la vitesse des conducteurs",
      "Augmenter la sécurité des piétons",
    ],
    answer: "Contrôler la vitesse des conducteurs",
    explanation:
        "Les radars sont utilisés pour surveiller la vitesse et améliorer la sécurité routière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des panneaux de signalisation ?",
    options: [
      "Créer des itinéraires",
      "Informer et orienter les usagers",
      "Émettre des amendes",
    ],
    answer: "Informer et orienter les usagers",
    explanation:
        "Les panneaux de signalisation fournissent des informations essentielles aux conducteurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal risque associé à la conduite sous l'influence de drogues ?",
    options: [
      "Avoir des hallucinations",
      "Perdre son permis",
      "Diminuer ses reflexes",
    ],
    answer: "Diminuer ses reflexes",
    explanation:
        "Les drogues peuvent altérer la capacité de réaction du conducteur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact de l'utilisation des clignotants ?",
    options: [
      "Indiquer un virage",
      "Avertir les piétons",
      "Accélérer le passage",
    ],
    answer: "Indiquer un virage",
    explanation:
        "Les clignotants permettent d'informer les autres usagers de l’intention de tourner.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le document obligatoire en cas de contrôle de police routière ?",
    options: [
      "Carte d'identité",
      "Permis de conduire",
      "Certificat de naissance",
    ],
    answer: "Permis de conduire",
    explanation:
        "Le permis de conduire doit être présenté lors d'un contrôle routier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet d'une conduite agressive ?",
    options: [
      "Augmentation du stress",
      "Réduction des accidents",
      "Meilleure fluidité du trafic",
    ],
    answer: "Augmentation du stress",
    explanation:
        "La conduite agressive peut provoquer du stress et des comportements imprévisibles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi servent les dispositifs de ralentissement sur la route ?",
    options: [
      "Augmenter la vitesse",
      "Encourager les dépassements",
      "Réduire la vitesse",
    ],
    answer: "Réduire la vitesse",
    explanation:
        "Ils sont installés pour forcer les conducteurs à ralentir et à respecter les limites.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que faire si un animal traverse la route ?",
    options: [
      "Accélérer pour passer",
      "Freiner et klaxonner",
      "Ralentir et s'arrêter si nécessaire",
    ],
    answer: "Ralentir et s'arrêter si nécessaire",
    explanation:
        "Il est crucial de ralentir et de s'arrêter pour éviter une collision avec un animal.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel type d'équipement de sécurité est recommandé pour les cyclistes ?",
    options: ["Vélo sans freins", "Casque", "Gants"],
    answer: "Casque",
    explanation:
        "Le port du casque est recommandé pour protéger la tête en cas d'accident.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire en cas de panne sur l'autoroute ?",
    options: [
      "Descendre du véhicule",
      "Allumer les feux de détresse",
      "Rester à l'intérieur du véhicule",
    ],
    answer: "Allumer les feux de détresse",
    explanation:
        "Les feux de détresse doivent être allumés pour avertir les autres conducteurs d'une panne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal avantage de respecter les limites de vitesse ?",
    options: [
      "Réduire les embouteillages",
      "Améliorer la sécurité",
      "Accélérer les trajets",
    ],
    answer: "Améliorer la sécurité",
    explanation:
        "Respecter les limites de vitesse contribue à la sécurité de tous les usagers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des feux de route ?",
    options: [
      "Éclairer le chemin lors de la nuit",
      "Montrer la direction",
      "Avertir les piétons",
    ],
    answer: "Éclairer le chemin lors de la nuit",
    explanation:
        "Les feux de route sont utilisés pour éclairer la voie pendant la conduite de nuit.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'un panneau de limitation de vitesse ?",
    options: ["Un avertissement", "Une obligation", "Une recommandation"],
    answer: "Une obligation",
    explanation:
        "Un panneau de limitation de vitesse impose une règle à respecter par les conducteurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact d'un mauvais éclairage sur la route ?",
    options: [
      "Amélioration de la visibilité",
      "Risque accru d'accidents",
      "Réduction des embouteillages",
    ],
    answer: "Risque accru d'accidents",
    explanation:
        "Un éclairage insuffisant nuit à la visibilité et augmente le risque d'accidents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que signifie un panneau de signalisation de fin de limitation de vitesse ?",
    options: [
      "Retrouver la vitesse normale",
      "Interdiction de dépasser",
      "Ralentir",
    ],
    answer: "Retrouver la vitesse normale",
    explanation:
        "Ce panneau indique que l'on peut reprendre la vitesse maximale autorisée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel équipement est conseillé pour les enfants à bord ?",
    options: ["Siège auto", "Coussin", "Sangle"],
    answer: "Siège auto",
    explanation:
        "Un siège auto est indispensable pour la sécurité des enfants en voiture.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment réagir face à un piéton sur la route ?",
    options: ["Accélérer", "Freiner et céder le passage", "Le klaxonner"],
    answer: "Freiner et céder le passage",
    explanation:
        "Il est obligatoire de céder le passage aux piétons sur un passage piéton.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que faire si vous êtes en retard à votre rendez-vous ?",
    options: [
      "Accélérer pour arriver plus vite",
      "Respecter les limitations de vitesse",
      "Prendre des raccourcis risqués",
    ],
    answer: "Respecter les limitations de vitesse",
    explanation:
        "Il est important de toujours respecter les limitations de vitesse pour votre sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment identifier un automobiliste fatigué ?",
    options: [
      "En conduisant lentement",
      "En s'endormant au volant",
      "En ayant du mal à se concentrer",
    ],
    answer: "En ayant du mal à se concentrer",
    explanation:
        "Un automobiliste fatigué a souvent des difficultés de concentration, augmentant le risque d'accident.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet de l'usage de drogues sur la conduite ?",
    options: [
      "Améliore la concentration",
      "Sensibilise aux dangers",
      "Altère les capacités motrices",
    ],
    answer: "Altère les capacités motrices",
    explanation:
        "L'usage de drogues affecte la coordination et la réactivité du conducteur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la signification d'un feu vert au feu tricolore ?",
    options: [
      "Arrêt immédiat",
      "Passage autorisé",
      "Avertissement de ralentir",
    ],
    answer: "Passage autorisé",
    explanation: "Un feu vert indique que les véhicules peuvent avancer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but des panneaux de route ?",
    options: [
      "Informer et orienter",
      "Rendre la route plus jolie",
      "Sanctionner les infractions",
    ],
    answer: "Informer et orienter",
    explanation:
        "Les panneaux de signalisation servent à guider les usagers et à leur fournir des informations essentielles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but d'un éthylotest ?",
    options: [
      "Contrôler la vitesse",
      "Mesurer l'alcoolémie",
      "Évaluer l'assurance",
    ],
    answer: "Mesurer l'alcoolémie",
    explanation:
        "L'éthylotest est utilisé pour mesurer le taux d'alcool dans le sang.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact de la conduite avec des lunettes de soleil ?",
    options: [
      "Diminuer l'éblouissement",
      "Augmenter la vitesse",
      "Rendre la conduite risquée",
    ],
    answer: "Diminuer l'éblouissement",
    explanation:
        "Les lunettes de soleil sont conçues pour réduire l'éblouissement pendant la conduite.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel comportement favoriser pour une conduite apaisée ?",
    options: [
      "Accélérer à chaque feu vert",
      "Rester zen et patient",
      "Doubler sans regarder",
    ],
    answer: "Rester zen et patient",
    explanation:
        "La patience au volant contribue à une conduite plus sûre et agréable.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact d'une tendinite sur la conduite ?",
    options: [
      "Aucun impact",
      "Peut gêner le contrôle du volant",
      "Améliore la sécurité",
    ],
    answer: "Peut gêner le contrôle du volant",
    explanation:
        "Une douleur peut diminuer la capacité de contrôle du véhicule et nuire à la sécurité.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le principal signal de circulation utilisé pour indiquer une limitation de vitesse ?",
    options: ["Un panneau rond", "Un panneau carré", "Un feu tricolore"],
    answer: "Un panneau rond",
    explanation:
        "Le panneau rond est utilisé pour indiquer des limitations de vitesse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le taux d'alcoolémie maximal autorisé pour un conducteur en France ?",
    options: ["0.2 g/l", "0.5 g/l", "0.8 g/l"],
    answer: "0.5 g/l",
    explanation: "Le taux d'alcoolémie maximal autorisé est de 0.5 g/l.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'un panneau de circulation triangulaire ?",
    options: [
      "Indication de danger",
      "Information routière",
      "Limitation de vitesse",
    ],
    answer: "Indication de danger",
    explanation: "Un panneau triangulaire indique un danger sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel document est obligatoire pour conduire un véhicule ?",
    options: ["Le permis de conduire", "La carte grise", "L’assurance"],
    answer: "Le permis de conduire",
    explanation:
        "Le permis de conduire est obligatoire pour conduire légalement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que devez-vous faire en cas d'accident corporel ?",
    options: [
      "Partir sans rien dire",
      "Alerter les autorités",
      "Contacter un ami",
    ],
    answer: "Alerter les autorités",
    explanation:
        "Il est essentiel d'alerter les autorités en cas d'accident corporel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'effet d'une vitesse excessive sur la distance de freinage ?",
    options: ["L'augmente", "La diminue", "N'a aucun effet"],
    answer: "L'augmente",
    explanation: "Une vitesse excessive augmente la distance de freinage.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quels sont les feux de position arrière sur un véhicule ?",
    options: ["Rouges", "Verts", "Jaunes"],
    answer: "Rouges",
    explanation: "Les feux de position arrière doivent être rouges.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le signe d'un passage à niveau ?",
    options: ["Une barrière", "Un panneau arrête", "Un feu clignotant"],
    answer: "Une barrière",
    explanation: "La barrière indique la proximité d'un passage à niveau.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment reconnaître un conducteur sous l'emprise de l'alcool ?",
    options: [
      "Il conduit trop lentement",
      "Il zigzague",
      "Il respecte les panneaux",
    ],
    answer: "Il zigzague",
    explanation:
        "Un conducteur sous l'emprise de l'alcool a tendance à zigzaguer.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la signification d'une ligne continue sur la route ?",
    options: ["Doubler interdit", "Doubler autorisé", "Arrêt obligatoire"],
    answer: "Doubler interdit",
    explanation: "Une ligne continue signifie que doubler est interdit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau de signalisation bleu ?",
    options: ["Interdiction", "Information", "Obligation"],
    answer: "Information",
    explanation: "Un panneau bleu indique une information routière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des ceintures de sécurité ?",
    options: [
      "Protéger les passagers",
      "Améliorer le confort",
      "Aider à conduire",
    ],
    answer: "Protéger les passagers",
    explanation:
        "Les ceintures de sécurité protègent les passagers en cas d'accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel comportement est recommandé en cas de pluie ?",
    options: ["Accélérer", "Ralentir", "Doubler plus rapidement"],
    answer: "Ralentir",
    explanation: "En cas de pluie, il est conseillé de ralentir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet d'un angle mort ?",
    options: [
      "Améliorer la visibilité",
      "Réduire la visibilité",
      "Augmenter la sécurité",
    ],
    answer: "Réduire la visibilité",
    explanation: "L'angle mort réduit la visibilité pour le conducteur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit faire un conducteur à un stop ?",
    options: ["S'arrêter", "Ralentir", "Continuer"],
    answer: "S'arrêter",
    explanation: "À un stop, un conducteur doit obligatoirement s'arrêter.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Comment réagir face à un piéton sur un passage protégé ?",
    options: ["Ralentir ou s'arrêter", "Continuer à rouler", "Klaxonner"],
    answer: "Ralentir ou s'arrêter",
    explanation:
        "Le conducteur doit ralentir ou s'arrêter pour laisser passer le piéton.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Pourquoi est-il dangereux d'utiliser un téléphone au volant ?",
    options: [
      "Ça aide à conduire",
      "Ça distrait le conducteur",
      "C'est permis",
    ],
    answer: "Ça distrait le conducteur",
    explanation:
        "Utiliser un téléphone au volant distrait fortement le conducteur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal équipement de sécurité d'une voiture ?",
    options: ["Le klaxon", "Le frein", "Les airbags"],
    answer: "Les airbags",
    explanation:
        "Les airbags sont un équipement de sécurité essentiel en cas d'accident.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but d'un contrôle technique ?",
    options: [
      "Vérifier la vitesse",
      "Vérifier la sécurité du véhicule",
      "Vérifier la propreté",
    ],
    answer: "Vérifier la sécurité du véhicule",
    explanation:
        "Le contrôle technique vise à vérifier la sécurité du véhicule.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le premier geste à faire en cas d'accident ?",
    options: [
      "S'assurer qu'il n'y a pas de blessés",
      "Appeler les secours",
      "Déplacer les véhicules",
    ],
    answer: "S'assurer qu'il n'y a pas de blessés",
    explanation:
        "Il est crucial de vérifier l'état des victimes avant toute action.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signale un panneau de priorité ?",
    options: ["Céder le passage", "Accelerer", "S'arrêter"],
    answer: "Céder le passage",
    explanation:
        "Un panneau de priorité indique de céder le passage aux autres véhicules.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quelle distance doit-on se garer d'un feu rouge ?",
    options: ["À 5 mètres", "À 3 mètres", "À 10 mètres"],
    answer: "À 5 mètres",
    explanation: "Il est conseillé de se garer à 5 mètres d'un feu rouge.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but d'une zone piétonne ?",
    options: [
      "Faciliter le stationnement",
      "Réduire la circulation automobile",
      "Augmenter le bruit",
    ],
    answer: "Réduire la circulation automobile",
    explanation:
        "Une zone piétonne vise à réduire la circulation automobile pour protéger les piétons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal danger des intersections ?",
    options: ["Le manque de lumière", "Les piétons", "Les collisions"],
    answer: "Les collisions",
    explanation:
        "Les intersections sont souvent des lieux de collisions entre véhicules.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit faire un conducteur avant de changer de voie ?",
    options: ["Jeter un coup d'œil", "Klaxonner", "Accélérer"],
    answer: "Jeter un coup d'œil",
    explanation:
        "Un conducteur doit toujours vérifier son angle mort avant de changer de voie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Pourquoi est-il important de respecter les limitations de vitesse ?",
    options: [
      "Pour éviter les amendes",
      "Pour protéger les usagers de la route",
      "Pour gagner du temps",
    ],
    answer: "Pour protéger les usagers de la route",
    explanation:
        "Respecter les limitations de vitesse est crucial pour la sécurité routière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'usage principal d'un klaxon ?",
    options: [
      "Indiquer un danger",
      "Jouer de la musique",
      "Avertir de l'arrivée",
    ],
    answer: "Indiquer un danger",
    explanation:
        "Le klaxon sert principalement à indiquer un danger sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quel moment allume-ton les feux de croisement ?",
    options: ["La nuit", "En plein jour", "Lors d'un orage"],
    answer: "La nuit",
    explanation:
        "Les feux de croisement doivent être allumés la nuit pour voir et être vu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que représente une ligne discontinue sur la route ?",
    options: ["Doubler interdit", "Doubler autorisé", "S'arrêter"],
    answer: "Doubler autorisé",
    explanation: "Une ligne discontinue indique que doubler est autorisé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact de l'alcool sur la conduite ?",
    options: [
      "Il améliore la concentration",
      "Il altère les réflexes",
      "Il augmente la vitesse",
    ],
    answer: "Il altère les réflexes",
    explanation:
        "L'alcool altère les réflexes, rendant la conduite dangereuse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la première chose à vérifier avant de démarrer ?",
    options: ["La vitesse", "Les rétroviseurs", "Le klaxon"],
    answer: "Les rétroviseurs",
    explanation:
        "Il est essentiel de vérifier les rétroviseurs avant de démarrer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel comportement est recommandé lors d'une conduite hivernale ?",
    options: ["Accélérer", "Ralentir", "Doubler rapidement"],
    answer: "Ralentir",
    explanation:
        "Il est conseillé de ralentir lors de la conduite par temps hivernal.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quelle distance devez-vous vous garer d'un passage piéton ?",
    options: ["À 3 mètres", "À 5 mètres", "À 10 mètres"],
    answer: "À 5 mètres",
    explanation: "Il est conseillé de se garer à 5 mètres d'un passage piéton.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau de fin de limitation de vitesse ?",
    options: [
      "Fin de la restriction",
      "Nouvelle limitation",
      "Pas d'interdiction",
    ],
    answer: "Fin de la restriction",
    explanation:
        "Ce panneau indique la fin de la limitation de vitesse précédente.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel type de casque est obligatoire à moto ?",
    options: ["Casque ouvert", "Casque intégral", "Casque de vélo"],
    answer: "Casque intégral",
    explanation:
        "Le casque intégral est obligatoire pour les conducteurs de moto.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la règle de priorité entre un véhicule à droite et un véhicule à gauche ?",
    options: [
      "Priorité à droite",
      "Priorité à gauche",
      "Priorité au véhicule le plus grand",
    ],
    answer: "Priorité à droite",
    explanation:
        "La règle de priorité générale est que le véhicule à droite a la priorité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel document identifie le propriétaire d'un véhicule ?",
    options: ["Le contrôle technique", "La carte grise", "L'assurance"],
    answer: "La carte grise",
    explanation:
        "La carte grise identifie le propriétaire légal d'un véhicule.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet du port de lunettes de soleil au volant ?",
    options: [
      "Réduit les reflets",
      "Augmente la visibilité",
      "Diminue la fatigue",
    ],
    answer: "Réduit les reflets",
    explanation:
        "Les lunettes de soleil aident à réduire l'éblouissement causé par la lumière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire avant de quitter un stationnement ?",
    options: [
      "Klaxonner",
      "Regarder dans les rétroviseurs",
      "Démarrer sans regarder",
    ],
    answer: "Regarder dans les rétroviseurs",
    explanation:
        "Il est indispensable de vérifier les rétroviseurs avant de quitter un stationnement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal but des panneaux de signalisation ?",
    options: [
      "Orner les routes",
      "Informer les conducteurs",
      "Améliorer l'esthétique",
    ],
    answer: "Informer les conducteurs",
    explanation:
        "Les panneaux de signalisation sont là pour informer et sécuriser les conducteurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le but des feux de stop ?",
    options: ["Avertir un piéton", "Indiquer l'arrêt", "Démarrer le moteur"],
    answer: "Indiquer l'arrêt",
    explanation:
        "Les feux de stop servent à indiquer qu'un véhicule est en arrêt.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la première mesure à prendre en cas de panne sur la route ?",
    options: [
      "Rester dans le véhicule",
      "Mettre les feux de détresse",
      "Appeler un ami",
    ],
    answer: "Mettre les feux de détresse",
    explanation: "Il faut allumer les feux de détresse pour signaler la panne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal effet d'une conduite agressive ?",
    options: [
      "Améliorer la circulation",
      "Augmenter le stress",
      "Rendre la conduite agréable",
    ],
    answer: "Augmenter le stress",
    explanation:
        "La conduite agressive augmente le stress et le risque d'accidents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quelle distance doit-on utiliser les feux de croisement ?",
    options: ["À 100 mètres", "À 30 mètres", "À 50 mètres"],
    answer: "À 50 mètres",
    explanation:
        "Les feux de croisement doivent être utilisés à 50 mètres d'un croisement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact de la fatigue sur la conduite ?",
    options: [
      "Améliore la concentration",
      "Diminue l'attention",
      "N'a aucun effet",
    ],
    answer: "Diminue l'attention",
    explanation:
        "La fatigue diminue l'attention et les réflexes du conducteur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'un gilet de sécurité dans un véhicule ?",
    options: [
      "Rendre le véhicule visible",
      "Aider à la conduite",
      "Être confortable",
    ],
    answer: "Rendre le véhicule visible",
    explanation:
        "Le gilet de sécurité permet de rendre le conducteur visible en cas de panne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal risque d'une conduite distraction ?",
    options: [
      "Améliorer la conduite",
      "Augmenter les accidents",
      "Réduire le stress",
    ],
    answer: "Augmenter les accidents",
    explanation:
        "La distraction au volant augmente considérablement le risque d'accidents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Pourquoi les enfants doivent-ils être assis à l'arrière ?",
    options: ["Pour plus de confort", "Pour la sécurité", "Pour être vus"],
    answer: "Pour la sécurité",
    explanation:
        "Les enfants doivent être assis à l'arrière pour leur sécurité en cas d'accident.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie un panneau de signalisation en forme de triangle ?",
    options: [
      "Indication d'un danger",
      "Fin de route",
      "Interdiction de stationner",
    ],
    answer: "Indication d'un danger",
    explanation:
        "Un panneau triangulaire prévient les conducteurs d'un danger imminent sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quelle est la vitesse maximale autorisée en agglomération en France ?",
    options: ["50 km/h", "70 km/h", "90 km/h"],
    answer: "50 km/h",
    explanation:
        "La vitesse maximale autorisée en agglomération est généralement fixée à 50 km/h.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est l'éclairage obligatoire pour les deux-roues motorisés la nuit ?",
    options: [
      "Des feux de croisement",
      "Des feux de position",
      "Des feux de détresse",
    ],
    answer: "Des feux de croisement",
    explanation:
        "Les deux-roues motorisés doivent utiliser des feux de croisement pour être visibles la nuit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert un gilet de sécurité ?",
    options: [
      "À améliorer le confort",
      "À rendre le conducteur visible",
      "À augmenter la vitesse",
    ],
    answer: "À rendre le conducteur visible",
    explanation:
        "Le gilet de sécurité est conçu pour rendre les conducteurs visibles aux autres usagers de la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel dispositif de sécurité est obligatoire pour les enfants en voiture ?",
    options: ["Des ceintures de sécurité", "Des sièges auto", "Des casques"],
    answer: "Des sièges auto",
    explanation:
        "Les enfants doivent être attachés dans des sièges auto adaptés à leur taille et poids.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit faire un conducteur à un feu jaune clignotant ?",
    options: ["Accélérer", "S'arrêter", "Ralentir et céder le passage"],
    answer: "Ralentir et céder le passage",
    explanation:
        "Un feu jaune clignotant indique d'être vigilant et de céder le passage.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'indique une ligne discontinue sur la route ?",
    options: [
      "Interdiction de doubler",
      "Autorisation de doubler",
      "Zone dangereuse",
    ],
    answer: "Autorisation de doubler",
    explanation:
        "Une ligne discontinue permet aux conducteurs de dépasser d'autres véhicules.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel comportement est obligatoire lorsqu'un véhicule de secours approche ?",
    options: [
      "Continuer sa route",
      "Céder le passage",
      "Accélérer pour le dépasser",
    ],
    answer: "Céder le passage",
    explanation:
        "Il est obligatoire de céder le passage aux véhicules de secours.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel équipement est recommandé pour les cyclistes la nuit ?",
    options: ["Un phare avant", "Un klaxon", "Un gilet de bain"],
    answer: "Un phare avant",
    explanation:
        "Les cyclistes doivent avoir un phare avant pour être visibles dans l'obscurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que symbolise une flèche verte sur un feu de circulation ?",
    options: ["Interdiction", "Autorisation de passer", "Ralentir"],
    answer: "Autorisation de passer",
    explanation:
        "Une flèche verte permet aux véhicules de passer sans s'arrêter.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'un alcootest ?",
    options: [
      "Un test d'alcoolémie",
      "Un test de vitesse",
      "Un test de conduite",
    ],
    answer: "Un test d'alcoolémie",
    explanation:
        "L'alcootest mesure le taux d'alcool présent dans le sang d'un conducteur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert le triangle de signalisation ?",
    options: [
      "À indiquer une zone de danger",
      "À décorer la voiture",
      "À fournir des informations touristiques",
    ],
    answer: "À indiquer une zone de danger",
    explanation:
        "Le triangle de signalisation avertit les autres usagers d'un danger sur la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle des points de permis de conduire ?",
    options: [
      "Récompenser les conducteurs",
      "Sanctionner les infractions",
      "Rendre la conduite plus difficile",
    ],
    answer: "Sanctionner les infractions",
    explanation:
        "Les points de permis sont utilisés pour sanctionner les infractions au code de la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que doit faire un conducteur lorsqu'il approche d'un passage piéton ?",
    options: [
      "Accélérer",
      "Ralentir et céder le passage",
      "Ignorer le passage",
    ],
    answer: "Ralentir et céder le passage",
    explanation:
        "Les conducteurs doivent ralentir et céder le passage aux piétons sur les passages piétons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "À quelle distance doit-on placer le triangle de signalisation en cas de panne ?",
    options: ["30 mètres", "50 mètres", "150 mètres"],
    answer: "30 mètres",
    explanation:
        "Le triangle de signalisation doit être placé à 30 mètres de la voiture en panne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la signification d'un panneau rond bleu ?",
    options: ["Interdiction", "Obligation", "Danger"],
    answer: "Obligation",
    explanation:
        "Un panneau rond bleu indique une obligation pour les usagers de la route.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'intérêt d'utiliser des rétroviseurs ?",
    options: [
      "Écouter de la musique",
      "Voir les angles morts",
      "Augmenter la vitesse",
    ],
    answer: "Voir les angles morts",
    explanation:
        "Les rétroviseurs permettent de visualiser les angles morts pour éviter les accidents.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel équipement est essentiel pour les motards ?",
    options: ["Des gants", "Des lunettes de soleil", "Un sac à dos"],
    answer: "Des gants",
    explanation:
        "Les gants protègent les mains en cas de chute et améliorent l'adhérence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire avant de changer de file sur autoroute ?",
    options: [
      "Regarder dans le rétroviseur",
      "Aller plus vite",
      "Augmenter le volume de la musique",
    ],
    answer: "Regarder dans le rétroviseur",
    explanation:
        "Il est crucial de vérifier dans le rétroviseur avant de changer de file.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif du code de la route ?",
    options: [
      "Faciliter les embouteillages",
      "Assurer la sécurité des usagers",
      "Augmenter les revenus de l'État",
    ],
    answer: "Assurer la sécurité des usagers",
    explanation:
        "Le code de la route a pour but d'assurer la sécurité de tous les usagers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Comment reconnaître un conducteur sous l'influence de l'alcool ?",
    options: [
      "En conduisant très vite",
      "En zigzaguant sur la route",
      "En écoutant de la musique forte",
    ],
    answer: "En zigzaguant sur la route",
    explanation:
        "Un conducteur sous l'influence de l'alcool peut avoir un comportement erratique, comme zigzaguer.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le risque principal de l'utilisation du téléphone au volant ?",
    options: [
      "Augmenter la vitesse",
      "Diminuer la concentration",
      "Rendre le voyage plus agréable",
    ],
    answer: "Diminuer la concentration",
    explanation:
        "L'utilisation d'un téléphone au volant réduit la concentration du conducteur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie une ligne pleine sur la route ?",
    options: [
      "Permet de doubler",
      "Interdit de doubler",
      "Fin de zone de dépassement",
    ],
    answer: "Interdit de doubler",
    explanation: "Une ligne pleine indique qu'il est interdit de doubler.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle d'un rond-point ?",
    options: [
      "Accélérer la circulation",
      "Ralentir la circulation",
      "Rassembler les voitures",
    ],
    answer: "Ralentir la circulation",
    explanation:
        "Un rond-point permet de réguler et ralentir la circulation aux intersections.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit faire un conducteur aux feux rouges ?",
    options: ["S'arrêter", "Accélérer", "Continuer sans s'arrêter"],
    answer: "S'arrêter",
    explanation:
        "Les feux rouges signifient que les véhicules doivent s'arrêter.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact de la vitesse sur le temps de réaction ?",
    options: [
      "Diminuer le temps de réaction",
      "Augmenter le temps de réaction",
      "Pas d'impact",
    ],
    answer: "Augmenter le temps de réaction",
    explanation:
        "Augmenter la vitesse réduit le temps disponible pour réagir à un danger.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'une zone 30 ?",
    options: [
      "Une zone à vitesse limitée",
      "Une zone de stationnement",
      "Une zone piétonne",
    ],
    answer: "Une zone à vitesse limitée",
    explanation:
        "Une zone 30 indique que la vitesse maximale autorisée est de 30 km/h.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le principal effet des drogues sur la conduite ?",
    options: [
      "Amélioration de la vigilance",
      "Perturbation des réflexes",
      "Aucune influence",
    ],
    answer: "Perturbation des réflexes",
    explanation:
        "Les drogues perturbent les réflexes et nuisent à la capacité de conduire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Qu'est-ce qu'un piéton doit faire avant de traverser ?",
    options: ["Regarder des deux côtés", "Courir", "Ne rien faire"],
    answer: "Regarder des deux côtés",
    explanation:
        "Avant de traverser, un piéton doit toujours regarder des deux côtés pour sa sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif d'un radar automatique ?",
    options: [
      "Encourager les déplacements",
      "Contrôler la vitesse",
      "Sécuriser les piétons",
    ],
    answer: "Contrôler la vitesse",
    explanation:
        "Les radars automatiques sont utilisés pour contrôler et sanctionner les excès de vitesse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle est la première cause d'accidents de la route ?",
    options: ["L'alcool", "La vitesse", "La fatigue"],
    answer: "La vitesse",
    explanation:
        "La vitesse excessive est la première cause d'accidents de la route.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel dispositif est recommandé pour prévenir les chutes en deux-roues ?",
    options: ["Un casque", "Des lunettes de soleil", "Des gants en cuir"],
    answer: "Un casque",
    explanation:
        "Le casque protège la tête en cas de chute à moto ou en scooter.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "À quoi sert une ceinture de sécurité ?",
    options: [
      "À améliorer le confort",
      "À maintenir les passagers en place",
      "À éviter les amendes",
    ],
    answer: "À maintenir les passagers en place",
    explanation:
        "La ceinture de sécurité est conçue pour maintenir les passagers en sécurité lors d'un accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Que doit faire un conducteur lorsqu'il est confronté à un feu vert clignotant ?",
    options: [
      "Passer sans ralentir",
      "Ralentir et être prudent",
      "S'arrêter immédiatement",
    ],
    answer: "Ralentir et être prudent",
    explanation:
        "Un feu vert clignotant indique de passer avec prudence, en vérifiant d'éventuels dangers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'impact d'une conduite distraite ?",
    options: [
      "Amélioration de la sécurité",
      "Aucune conséquence",
      "Augmentation des risques d'accident",
    ],
    answer: "Augmentation des risques d'accident",
    explanation:
        "La conduite distraite augmente significativement le risque d'accident.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Pourquoi est-il essentiel d'utiliser les feux de croisement la nuit ?",
    options: [
      "Pour voir les panneaux",
      "Pour être mieux vu par les autres",
      "Pour économiser du carburant",
    ],
    answer: "Pour être mieux vu par les autres",
    explanation:
        "Les feux de croisement permettent d'être visible par les autres usagers la nuit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Pourquoi le respect du code de la route est-il crucial ?",
    options: [
      "Pour avoir un beau véhicule",
      "Pour protéger tous les usagers",
      "Pour augmenter le nombre de passagers",
    ],
    answer: "Pour protéger tous les usagers",
    explanation:
        "Le respect du code de la route protège la vie de tous les usagers de la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que signifie une flèche rouge sur un panneau de circulation ?",
    options: [
      "Interdiction de dépasser",
      "Interdiction de tourner",
      "Zone de danger",
    ],
    answer: "Interdiction de tourner",
    explanation:
        "Une flèche rouge indique qu'il est interdit de tourner à cette intersection.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est le rôle principal des feux de circulation ?",
    options: [
      "Ralentir les voitures",
      "Réguler le flux de circulation",
      "Diminuer les embouteillages",
    ],
    answer: "Réguler le flux de circulation",
    explanation:
        "Les feux de circulation servent à réguler le passage des véhicules et piétons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'effet d'une vitesse excessive sur le freinage ?",
    options: [
      "Raccourcit la distance de freinage",
      "Allonge la distance de freinage",
      "N'a aucun effet",
    ],
    answer: "Allonge la distance de freinage",
    explanation:
        "La vitesse excessive allonge la distance nécessaire pour freiner efficacement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit-on faire après un accident de la route ?",
    options: [
      "Éviter de prévenir les secours",
      "Rester sur les lieux",
      "Fuir rapidement",
    ],
    answer: "Rester sur les lieux",
    explanation:
        "Après un accident, il est essentiel de rester sur les lieux et d'informer les forces de l'ordre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Que doit faire un conducteur avant de démarrer ?",
    options: [
      "Vérifier les rétroviseurs",
      "Mettre la radio",
      "Ajuster les sièges",
    ],
    answer: "Vérifier les rétroviseurs",
    explanation:
        "Il est important de vérifier les rétroviseurs avant de démarrer pour assurer la sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Quel est le résultat d'une conduite sous l'influence de la drogue ?",
    options: [
      "Amélioration de la coordination",
      "Perturbation des capacités de conduite",
      "Aucune influence",
    ],
    answer: "Perturbation des capacités de conduite",
    explanation:
        "La drogue perturbe les capacités cognitives, rendant la conduite dangereuse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question:
        "Combien de temps faut-il pour que l'alcool soit éliminé du corps ?",
    options: ["1 heure par verre", "2 heures par verre", "3 heures par verre"],
    answer: "1 heure par verre",
    explanation:
        "En moyenne, l'alcool est éliminé à raison d'une heure par verre consommé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel est l'objectif de la vitesse maximale sur les autoroutes ?",
    options: [
      "Accélérer la circulation",
      "Garantir la sécurité",
      "Augmenter les revenus des péages",
    ],
    answer: "Garantir la sécurité",
    explanation:
        "La vitesse maximale sur autoroute est fixée pour garantir la sécurité de tous les usagers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quel effet a le port de la ceinture de sécurité ?",
    options: [
      "Augmenter la vitesse",
      "Réduire les blessures en cas d'accident",
      "Améliorer le confort",
    ],
    answer: "Réduire les blessures en cas d'accident",
    explanation:
        "La ceinture de sécurité réduit significativement les blessures lors d'un accident.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sécurité routière",
    question: "Quelle sécurité est mise en place pour les zones scolaires ?",
    options: [
      "Aucune sécurité particulière",
      "Des panneaux de limitation de vitesse",
      "Des barrières",
    ],
    answer: "Des panneaux de limitation de vitesse",
    explanation:
        "Les zones scolaires sont signalées par des panneaux limitant la vitesse pour protéger les enfants.",
    difficulty: "Moyenne",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizCultureGeneraleSecuriteRoutiere extends StatefulWidget {
  static const String routeName =
      '/gpx_exam/concours/culture_generale_securite_routiere';
  final String uid;
  final String email;

  const QuizCultureGeneraleSecuriteRoutiere({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCultureGeneraleSecuriteRoutiere> createState() =>
      _QuizCultureGeneraleSecuriteRoutiereState();
}

class _QuizCultureGeneraleSecuriteRoutiereState
    extends State<QuizCultureGeneraleSecuriteRoutiere>
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
        ? questionCultureSecuriteRoutiere
        : questionCultureSecuriteRoutiere
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
            'module_name': 'Culture générale - Sécurité routière',
            'quiz_name': 'Quiz culture générale sécurité routière',
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
      await _sb.from('quiz_culture_generale_securite_routiere_pages').insert({
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
      debugPrint(
        '❌ quiz_culture_generale_securite_routiere_pages insert failed: $e',
      );
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
