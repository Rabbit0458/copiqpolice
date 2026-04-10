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

final List<QuizQuestion> questionCulturePolice = [
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal objectif de la police nationale en France ?",
    options: [
      "Assurer la sécurité publique",
      "Réaliser des opérations militaires",
      "Gérer les impôts",
    ],
    answer: "Assurer la sécurité publique",
    explanation:
        "La police nationale a pour mission principale de garantir la sécurité des citoyens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le grade le plus élevé dans la police nationale française ?",
    options: ["Inspecteur général", "Commissaire", "Officier"],
    answer: "Inspecteur général",
    explanation:
        "L'inspecteur général est le grade le plus élevé dans la hiérarchie de la police nationale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "En France, quel est le rôle principal de la police judiciaire ?",
    options: [
      "Surveiller le trafic routier",
      "Enquêter sur les crimes",
      "Organiser des événements publics",
    ],
    answer: "Enquêter sur les crimes",
    explanation:
        "La police judiciaire est chargée d'enquêter sur les infractions pénales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le code de déontologie des policiers en France ?",
    options: [
      "Code de l'éthique",
      "Code de déontologie",
      "Code du service public",
    ],
    answer: "Code de déontologie",
    explanation:
        "Le code de déontologie régit la conduite des policiers dans l'exercice de leurs fonctions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "En quelle année a été créé le service de police nationale en France ?",
    options: ["1966", "1791", "1945"],
    answer: "1966",
    explanation:
        "La police nationale a été formée en tant qu'entité distincte en 1966.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le symbole de la police nationale française ?",
    options: ["Le tricolore", "Le lion", "La Marianne"],
    answer: "La Marianne",
    explanation:
        "La Marianne est souvent utilisée comme symbole de la République, incluant la police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel corps de police est principalement chargé de la sécurité en milieu urbain ?",
    options: ["Police nationale", "Gendarmerie", "Police municipale"],
    answer: "Police nationale",
    explanation:
        "La police nationale est principalement responsable de la sécurité dans les grandes villes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de la BAC ?",
    options: [
      "Surveillance des quartiers sensibles",
      "Intervention rapide",
      "Gestion des affaires judiciaires",
    ],
    answer: "Intervention rapide",
    explanation:
        "La BAC (Brigade Anti-Criminalité) est spécialisée dans les interventions rapides sur le terrain.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la durée de formation initiale d'un policier en France ?",
    options: ["6 mois", "12 mois", "24 mois"],
    answer: "12 mois",
    explanation:
        "La formation initiale d'un policier dure généralement 12 mois.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal document d'identité délivré par la police ?",
    options: ["Passeport", "Carte nationale d'identité", "Permis de conduire"],
    answer: "Carte nationale d'identité",
    explanation:
        "La carte nationale d'identité est un document officiel d'identification délivré par la police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'âge minimum pour devenir policier en France ?",
    options: ["18 ans", "21 ans", "25 ans"],
    answer: "18 ans",
    explanation:
        "Pour entrer dans la police nationale, il faut avoir au moins 18 ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des agents de police aux frontières ?",
    options: [
      "Contrôle de la circulation routière",
      "Surveillance des événements publics",
      "Contrôle des frontières nationales",
    ],
    answer: "Contrôle des frontières nationales",
    explanation:
        "Les agents de police aux frontières sont responsables du contrôle des entrées et sorties du territoire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du fichier national des personnes recherchées par la police ?",
    options: [
      "Fichier des délinquants",
      "Fichier des personnes recherchées",
      "Fichier des fugitifs",
    ],
    answer: "Fichier des personnes recherchées",
    explanation:
        "Ce fichier recense les individus faisant l'objet d'un mandat d'arrêt.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel service est chargé de la lutte contre le trafic de stupéfiants ?",
    options: [
      "Drogue et toxicomanie",
      "Renseignements généraux",
      "Brigade des stupéfiants",
    ],
    answer: "Brigade des stupéfiants",
    explanation:
        "Cette brigade se spécialise dans la lutte contre le trafic de drogues.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la couleur du véhicule de la police nationale en France ?",
    options: ["Bleu", "Rouge", "Vert"],
    answer: "Bleu",
    explanation:
        "Les véhicules de la police nationale sont généralement de couleur bleue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de la direction centrale de la police judiciaire ?",
    options: ["DCPJ", "DPJ", "DCPJ-FR"],
    answer: "DCPJ",
    explanation: "DCPJ signifie Direction Centrale de la Police Judiciaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type de délit la police traite-t-elle principalement ?",
    options: ["Délits mineurs", "Crimes graves", "Infractions administratives"],
    answer: "Crimes graves",
    explanation:
        "La police traite principalement des crimes et délits, particulièrement les crimes graves.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme utilisé pour désigner les interventions de la police lors de situations critiques ?",
    options: [
      "Interventions de crise",
      "Missions spéciales",
      "Opérations d'urgence",
    ],
    answer: "Interventions de crise",
    explanation:
        "Les interventions de crise sont des actions menées lors de situations dangereuses.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme pour désigner les enquêtes menées par la police sur le terrain ?",
    options: ["Enquête de proximité", "Enquête de terrain", "Enquête publique"],
    answer: "Enquête de terrain",
    explanation:
        "Les enquêtes de terrain sont cruciales pour la résolution des affaires criminelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du service chargé de la police de l'air et des frontières ?",
    options: ["PAF", "BAF", "SAF"],
    answer: "PAF",
    explanation: "La PAF signifie Police de l'Air et des Frontières.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type d’armement est généralement utilisé par la police nationale française ?",
    options: ["Armes blanches", "Armes de poing", "Armes lourdes"],
    answer: "Armes de poing",
    explanation:
        "La police nationale utilise principalement des armes de poing dans l'exercice de ses fonctions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif de la prévention de la délinquance ?",
    options: [
      "Éduquer les jeunes",
      "Réduire les actes délinquants",
      "Augmenter les arrestations",
    ],
    answer: "Réduire les actes délinquants",
    explanation:
        "La prévention vise à diminuer la criminalité en agissant en amont.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme pour désigner le soutien psychologique aux victimes de crimes ?",
    options: [
      "Aide aux victimes",
      "Soutien psychologique",
      "Assistance judiciaire",
    ],
    answer: "Aide aux victimes",
    explanation:
        "L'aide aux victimes est un service essentiel pour accompagner les personnes touchées par la criminalité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui est en charge de l'encadrement des policiers en France ?",
    options: [
      "Ministre de l'Intérieur",
      "Premier ministre",
      "Président de la République",
    ],
    answer: "Ministre de l'Intérieur",
    explanation:
        "Le ministre de l'Intérieur est responsable de l'organisation et de la direction de la police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel organisme a été créé pour lutter contre le terrorisme en France ?",
    options: ["DGSI", "DCRI", "DGGN"],
    answer: "DGSI",
    explanation:
        "La DGSI est la Direction Générale de la Sécurité Intérieure, chargée de la lutte contre le terrorisme.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de la police scientifique ?",
    options: [
      "Collecter des preuves",
      "Surveiller les réseaux sociaux",
      "Rédiger des rapports juridiques",
    ],
    answer: "Collecter des preuves",
    explanation:
        "La police scientifique intervient pour analyser et collecter des preuves dans les enquêtes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le véhicule emblématique de la police nationale ?",
    options: ["Peugeot 308", "Renault Clio", "Citroën C4"],
    answer: "Peugeot 308",
    explanation:
        "La Peugeot 308 est souvent utilisée comme véhicule de service par la police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal service d'investigation pour les atteintes aux personnes ?",
    options: [
      "Brigade criminelle",
      "Brigade des mineurs",
      "Brigade des moeurs",
    ],
    answer: "Brigade criminelle",
    explanation:
        "La brigade criminelle s'occupe des enquêtes relatives aux atteintes aux personnes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal objectif de la lutte contre la criminalité organisée ?",
    options: [
      "Réduire la violence",
      "Augmenter les arrestations",
      "Recueillir des témoignages",
    ],
    answer: "Réduire la violence",
    explanation:
        "Lutter contre la criminalité organisée vise à diminuer la violence et l'impact sur la société.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type d'enquête se concentre sur les affaires de moeurs ?",
    options: ["Enquête criminelle", "Enquête de mœurs", "Enquête sociale"],
    answer: "Enquête de mœurs",
    explanation:
        "Les enquêtes de mœurs traitent des infractions liées à la moralité publique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle principal des équipes cynophiles ?",
    options: [
      "Assister lors des enquêtes",
      "Fournir un soutien logistique",
      "Utiliser des chiens pour la détection",
    ],
    answer: "Utiliser des chiens pour la détection",
    explanation:
        "Les équipes cynophiles utilisent des chiens pour détecter des substances ou des personnes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le terme pour désigner une arrestation sans mandat ?",
    options: [
      "Arrestation légale",
      "Arrestation administrative",
      "Arrestation judiciaire",
    ],
    answer: "Arrestation administrative",
    explanation:
        "Une arrestation administrative peut être réalisée sans mandat en cas de trouble à l'ordre public.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel dispositif de sécurité est souvent utilisé lors d'événements publics ?",
    options: [
      "Contrôle d'accès",
      "Surveillance par drones",
      "Patrouilles à cheval",
    ],
    answer: "Contrôle d'accès",
    explanation:
        "Le contrôle d'accès est essentiel pour garantir la sécurité des événements publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle principal de la gendarmerie nationale ?",
    options: [
      "Lutte contre le terrorisme",
      "Surveillance des routes",
      "Police militaire",
    ],
    answer: "Surveillance des routes",
    explanation:
        "La gendarmerie nationale assure principalement la sécurité routière et la surveillance régionale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le pourcentage de la population française employée par la police nationale ?",
    options: ["1%", "0,2%", "0,5%"],
    answer: "0,5%",
    explanation:
        "Environ 0,5% de la population active est employée par la police nationale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal outil utilisé par la police pour recueillir des preuves ?",
    options: ["Caméras de surveillance", "Interviews", "Analyses ADN"],
    answer: "Analyses ADN",
    explanation:
        "Les analyses ADN sont un outil clé pour l'identification et la preuve dans les enquêtes criminelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle unité est spécialisée dans les interventions à haut risque ?",
    options: ["RAID", "GIGN", "BRI"],
    answer: "RAID",
    explanation:
        "Le RAID est une unité d'élite spécialisée dans les interventions les plus dangereuses.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle loi encadre les pouvoirs de la police en France ?",
    options: ["Loi de 1959", "Loi de 1993", "Loi de 1983"],
    answer: "Loi de 1983",
    explanation:
        "La loi de 1983 définit les droits et obligations des policiers en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal moyen de communication utilisé par la police sur le terrain ?",
    options: ["Radio", "Téléphone mobile", "SMS"],
    answer: "Radio",
    explanation:
        "Les radios permettent une communication instantanée et sécurisée durant les opérations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal objectif des patrouilles de police ?",
    options: ["Dissuasion", "Enquêtes", "Contrôle des frontières"],
    answer: "Dissuasion",
    explanation:
        "Les patrouilles de police visent à dissuader les comportements criminels.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des unités de police canine ?",
    options: [
      "Contrôler la circulation",
      "Faire des enquêtes sociales",
      "Assister dans les missions de détection",
    ],
    answer: "Assister dans les missions de détection",
    explanation:
        "Les unités de police canine sont souvent utilisées pour la détection de drogues ou d'explosifs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Dans quel type d'infraction la police intervient-elle le plus souvent ?",
    options: ["Vols", "Fraudes", "Violation de la trêve"],
    answer: "Vols",
    explanation:
        "Les vols constituent une part importante des interventions de la police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du service d'assistance aux victimes de la police ?",
    options: ["SAV", "AVF", "SASV"],
    answer: "AVF",
    explanation:
        "L'AVF signifie Aide aux Victimes de la France, un service de soutien.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme pour désigner une recherche d'informations sur un suspect ?",
    options: [
      "Fouille de renseignement",
      "Enquête de renseignement",
      "Vérification de renseignement",
    ],
    answer: "Enquête de renseignement",
    explanation:
        "Une enquête de renseignement consiste à recueillir des informations sur un suspect.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle du procureur dans une enquête policière ?",
    options: [
      "Diriger les enquêteurs",
      "Apporter une assistance juridique",
      "Contrôler les preuves",
    ],
    answer: "Diriger les enquêteurs",
    explanation:
        "Le procureur dirige les enquêtes criminelles et supervise l'action publique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle des services de renseignement en matière de sécurité ?",
    options: [
      "Surveillance des citoyens",
      "Collecte d'informations stratégiques",
      "Contrôle des frontières",
    ],
    answer: "Collecte d'informations stratégiques",
    explanation:
        "Les services de renseignement collectent des informations pour prévenir les menaces.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme pour désigner l'ensemble des forces de sécurité intérieure en France ?",
    options: ["Police nationale", "Gendarmerie", "Sécurité intérieure"],
    answer: "Sécurité intérieure",
    explanation:
        "La sécurité intérieure regroupe toutes les forces de sécurité, y compris la police et la gendarmerie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le nom de l'organisation européenne de police ?",
    options: ["Europol", "Interpol", "Europol-Int"],
    answer: "Europol",
    explanation:
        "Europol est l'agence européenne de police qui facilite le partage d'informations entre pays.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des brigades de protection de la famille ?",
    options: [
      "Protection des mineurs",
      "Assistance des femmes victimes",
      "Enquêtes criminelles",
    ],
    answer: "Assistance des femmes victimes",
    explanation:
        "Ces brigades assistent spécifiquement les femmes victimes de violences.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme pour désigner l'ensemble des lois régissant la police ?",
    options: [
      "Droit policier",
      "Réglementation policière",
      "Droit de la sécurité",
    ],
    answer: "Droit policier",
    explanation:
        "Le droit policier englobe l'ensemble des lois qui régissent les activités de la police.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle principal de la Police nationale en France ?",
    options: [
      "Protéger les citoyens",
      "Gérer les équipements publics",
      "Organiser des événements culturels",
    ],
    answer: "Protéger les citoyens",
    explanation:
        "La mission principale de la Police nationale est la protection des citoyens et le maintien de l'ordre public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle loi régit l'organisation de la Police nationale en France ?",
    options: ["Loi de 1986", "Loi de 1995", "Loi de 1984"],
    answer: "Loi de 1984",
    explanation:
        "La loi de 1984 encadre l'organisation et le fonctionnement de la Police nationale en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'organe de direction de la Police nationale ?",
    options: ["La DGPN", "Le ministère de la Défense", "L'Assemblée nationale"],
    answer: "La DGPN",
    explanation:
        "La Direction Générale de la Police Nationale (DGPN) supervise les activités de la Police nationale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le grade le plus élevé dans la Police nationale ?",
    options: ["Commissaire", "Inspecteur", "Agent"],
    answer: "Commissaire",
    explanation:
        "Le poste de commissaire est le plus haut grade opérationnel au sein de la Police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de la Brigade des stups ?",
    options: [
      "Lutter contre le trafic de stupéfiants",
      "Gérer les contentieux administratifs",
      "Protéger les témoins",
    ],
    answer: "Lutter contre le trafic de stupéfiants",
    explanation:
        "La Brigade des stups est spécialisée dans la lutte contre les drogues et stupéfiants.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui peut saisir la Police nationale en cas de délit ?",
    options: [
      "Tout citoyen",
      "Uniquement les magistrats",
      "Les agents de sécurité",
    ],
    answer: "Tout citoyen",
    explanation:
        "Tout citoyen a le droit de signaler un délit à la Police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'acronyme de l'institution centrale de la Police nationale ?",
    options: ["DGPN", "IGPN", "CRS"],
    answer: "DGPN",
    explanation: "DGPN signifie Direction Générale de la Police Nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal document vérifié par les policiers lors d'un contrôle ?",
    options: ["Le passeport", "La carte d'identité", "Le permis de conduire"],
    answer: "La carte d'identité",
    explanation:
        "La carte d'identité est le document principal utilisé pour vérifier l'identité d'une personne lors des contrôles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des CRS ?",
    options: [
      "Assurer l'ordre public lors des manifestations",
      "Faire de la prévention",
      "Gérer le trafic routier",
    ],
    answer: "Assurer l'ordre public lors des manifestations",
    explanation:
        "Les Compagnies Républicaines de Sécurité (CRS) sont chargées du maintien de l'ordre lors des événements publics.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la couleur emblématique de l'uniforme de la Police nationale ?",
    options: ["Bleu", "Rouge", "Vert"],
    answer: "Bleu",
    explanation:
        "L'uniforme de la Police nationale est traditionnellement de couleur bleue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif principal d'une enquête criminelle ?",
    options: [
      "Identifier les victimes",
      "Résoudre le crime",
      "Évaluer les dommages",
    ],
    answer: "Résoudre le crime",
    explanation:
        "L'objectif d'une enquête criminelle est de rassembler des preuves pour résoudre un crime.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce qu'un procès-verbal ?",
    options: [
      "Un document d'enquête",
      "Une décision de justice",
      "Une attestation de présence",
    ],
    answer: "Un document d'enquête",
    explanation:
        "Le procès-verbal est un document officiel rédigé par des agents de police lors d'une constatation ou d'une enquête.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui est le garant de l'ordre public en France ?",
    options: ["Le préfet", "Le maire", "Le président de la République"],
    answer: "Le préfet",
    explanation:
        "Le préfet est responsable de l'ordre public au niveau départemental, en lien avec les forces de Police.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle unité est spécialisée dans la lutte contre le terrorisme ?",
    options: ["RAID", "GIGN", "BAC"],
    answer: "GIGN",
    explanation:
        "Le GIGN (Groupe d'Intervention de la Gendarmerie Nationale) est spécialisé dans des interventions anti-terroristes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelles sont les missions de la Police aux frontières ?",
    options: [
      "Contrôler les frontières",
      "Lutter contre le crime organisé",
      "Assurer la sécurité routière",
    ],
    answer: "Contrôler les frontières",
    explanation:
        "La Police aux frontières a pour mission principale de contrôler l'accès aux frontières nationales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type d'infraction est un délit ?",
    options: [
      "Une infraction grave",
      "Une infraction moins grave qu'un crime",
      "Une infraction sans sanction",
    ],
    answer: "Une infraction moins grave qu'un crime",
    explanation:
        "En droit pénal, un délit est une infraction moins grave qu'un crime, mais plus grave qu'une contravention.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif de la Police de la route ?",
    options: [
      "Prévenir les accidents",
      "Gérer le stationnement",
      "Répondre aux urgences",
    ],
    answer: "Prévenir les accidents",
    explanation:
        "La Police de la route a pour mission principale la prévention des accidents sur les routes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce qu'une plainte ?",
    options: [
      "Un rapport de police",
      "Un document légal pour signaler un crime",
      "Un formulaire administratif",
    ],
    answer: "Un document légal pour signaler un crime",
    explanation:
        "Une plainte est un document par lequel une personne signale un crime ou un délit aux autorités.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un enquêteur ?",
    options: [
      "Rassembler des preuves",
      "Rédiger des lois",
      "Contrôler les frontières",
    ],
    answer: "Rassembler des preuves",
    explanation:
        "L'enquêteur a pour mission de collecter des éléments de preuve pour résoudre des affaires criminelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la principale force d'action de la Police nationale ?",
    options: [
      "Les agents de sécurité",
      "Les brigades anti-criminalité",
      "Les enquêteurs",
    ],
    answer: "Les brigades anti-criminalité",
    explanation:
        "Les brigades anti-criminalité sont les principales unités d'intervention de la Police nationale sur le terrain.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type de crime est le vol ?",
    options: [
      "Un crime contre les personnes",
      "Un crime contre les biens",
      "Un crime économique",
    ],
    answer: "Un crime contre les biens",
    explanation:
        "Le vol est classé comme un crime contre les biens, car il implique le prélèvement illégal de possessions d'autrui.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de l'OCBC ?",
    options: [
      "Lutter contre la cybercriminalité",
      "Gérer les enquêtes judiciaires",
      "Contrôler la circulation",
    ],
    answer: "Lutter contre la cybercriminalité",
    explanation:
        "L'OCBC (Office central de lutte contre la cybercriminalité) est spécialisé dans la lutte contre les crimes liés à Internet.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Comment appelle-t-on un membre de la Police nationale ?",
    options: ["Policier", "Gendarme", "Agent de la paix"],
    answer: "Policier",
    explanation:
        "Le terme 'policier' désigne un membre de la Police nationale, tandis que 'gendarme' fait référence à la Gendarmerie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle autorité supervise les opérations de police judiciaire ?",
    options: ["Le procureur", "Le juge", "Le préfet"],
    answer: "Le procureur",
    explanation:
        "Le procureur supervise les enquêtes de police judiciaire et assure le bon déroulement des poursuites.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la principale mission de la Police scientifique ?",
    options: [
      "Analyser les preuves",
      "Surveiller les prisons",
      "Interroger les suspects",
    ],
    answer: "Analyser les preuves",
    explanation:
        "La Police scientifique se concentre sur l'analyse des preuves matérielles dans les enquêtes criminelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la différence entre Police nationale et Gendarmerie ?",
    options: [
      "La Police nationale est civile, la Gendarmerie est militaire",
      "La Police nationale est armée, la Gendarmerie ne l'est pas",
      "Il n'y a pas de différence",
    ],
    answer: "La Police nationale est civile, la Gendarmerie est militaire",
    explanation:
        "La Police nationale est une force civile, tandis que la Gendarmerie dépend de l'armée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme employé pour désigner une arrestation sans mandat ?",
    options: [
      "Arrestation illégale",
      "Garde à vue",
      "Arrestation administrative",
    ],
    answer: "Arrestation administrative",
    explanation:
        "Une arrestation administrative est effectuée sans mandat par les forces de l'ordre dans des situations exceptionnelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but des patrouilles de police ?",
    options: [
      "Rendre visite aux citoyens",
      "Assurer la visibilité policière",
      "Organiser des événements",
    ],
    answer: "Assurer la visibilité policière",
    explanation:
        "Les patrouilles de police visent à renforcer la présence et la sécurité des forces de l'ordre dans les espaces publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Que signifie l'acronyme BAC ?",
    options: [
      "Brigade Anti-Criminalité",
      "Brigade des Actions Communales",
      "Brigade de l'Air et de la Circulation",
    ],
    answer: "Brigade Anti-Criminalité",
    explanation:
        "La BAC (Brigade Anti-Criminalité) est une unité de la Police nationale spécialisée dans la lutte contre la délinquance urbaine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principe de la légitime défense ?",
    options: [
      "Se défendre sans limite",
      "Se défendre en cas d'agression",
      "Agir en représailles",
    ],
    answer: "Se défendre en cas d'agression",
    explanation:
        "La légitime défense permet d'agir pour se protéger en cas d'agression immédiate.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel document est nécessaire pour conduire un véhicule en France ?",
    options: ["Carte grise", "Permis de conduire", "Assurance"],
    answer: "Permis de conduire",
    explanation:
        "Le permis de conduire est le document légal requis pour conduire un véhicule en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de la Police municipale ?",
    options: [
      "Assurer la sécurité dans une commune",
      "Contrôler le trafic interurbain",
      "Lutter contre le terrorisme",
    ],
    answer: "Assurer la sécurité dans une commune",
    explanation:
        "La Police municipale a pour mission de maintenir l'ordre et la sécurité au sein de la commune.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'organe de contrôle de la Police nationale ?",
    options: ["IGPN", "CRS", "BPA"],
    answer: "IGPN",
    explanation:
        "L'IGPN (Inspection Générale de la Police Nationale) est chargé de contrôler les actions des forces de police.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type d'infraction est une contravention ?",
    options: [
      "Une infraction très grave",
      "Une infraction peu grave",
      "Une infraction sans conséquence",
    ],
    answer: "Une infraction peu grave",
    explanation:
        "Une contravention est une infraction considérée comme moins grave qu'un délit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des services de renseignement ?",
    options: [
      "Collecter des informations",
      "Rédiger des décrets",
      "Contrôler les frontières",
    ],
    answer: "Collecter des informations",
    explanation:
        "Les services de renseignement ont pour mission de collecter et analyser des informations pour assurer la sécurité nationale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui peut être témoin lors d'une enquête ?",
    options: ["Tout citoyen", "Uniquement les policiers", "Les avocats"],
    answer: "Tout citoyen",
    explanation:
        "Tout citoyen peut être appelé à témoigner lors d'une enquête policière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but d'un contrôle d'identité ?",
    options: [
      "Vérifier l'identité d'une personne",
      "Surveiller les lieux publics",
      "Emettre des contraventions",
    ],
    answer: "Vérifier l'identité d'une personne",
    explanation:
        "Le contrôle d'identité a pour objectif de confirmer l'identité d'un individu à la demande de la Police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'effet d'un mandat d'arrêt ?",
    options: [
      "Arrestation d'un suspect",
      "Convocation d'un témoin",
      "Libération d'un détenu",
    ],
    answer: "Arrestation d'un suspect",
    explanation:
        "Un mandat d'arrêt permet l'arrestation d'une personne soupçonnée d'une infraction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Comment se nomme l'organe qui enquête sur les plaintes contre la Police ?",
    options: ["IGPN", "CJR", "CPR"],
    answer: "IGPN",
    explanation:
        "L'IGPN examine et traite les plaintes déposées contre des agents de la Police nationale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la première étape d'une enquête criminelle ?",
    options: [
      "Recueillir des témoignages",
      "Rassembler des preuves",
      "Déposer une plainte",
    ],
    answer: "Déposer une plainte",
    explanation:
        "La première étape d'une enquête criminelle est le dépôt d'une plainte par la victime ou un témoin.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'importance de la coopération internationale pour la Police ?",
    options: [
      "Lutter contre la délinquance transnationale",
      "Organiser des compétitions",
      "Former des agents",
    ],
    answer: "Lutter contre la délinquance transnationale",
    explanation:
        "La coopération internationale est essentielle pour faire face à la criminalité qui traverse les frontières.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'instrument principal pour établir une identité lors d'une enquête ?",
    options: ["Photographie", "Empreintes digitales", "Dossier médical"],
    answer: "Empreintes digitales",
    explanation:
        "Les empreintes digitales sont un moyen fondamental d'identifier une personne dans une enquête criminelle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'impact des réseaux sociaux sur la Police ?",
    options: [
      "Augmenter le nombre de délits",
      "Améliorer la communication",
      "Diminuer la criminalité",
    ],
    answer: "Améliorer la communication",
    explanation:
        "Les réseaux sociaux aident la Police à communiquer efficacement avec le public et à partager des informations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des médiateurs dans les conflits ?",
    options: [
      "Prendre des décisions",
      "Faciliter la communication",
      "Rédiger des rapports",
    ],
    answer: "Faciliter la communication",
    explanation:
        "Les médiateurs cherchent à établir un dialogue entre les parties en conflit pour trouver une solution pacifique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de la prévention en matière de sécurité ?",
    options: [
      "Réduire les risques",
      "Augmenter les contraventions",
      "Améliorer les infrastructures",
    ],
    answer: "Réduire les risques",
    explanation:
        "La prévention vise à diminuer les risques d'infractions et à assurer la sécurité des citoyens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la fonction principale de la Police technique et scientifique ?",
    options: [
      "Collecter des preuves",
      "Formuler des accusations",
      "Assurer la sécurité routière",
    ],
    answer: "Collecter des preuves",
    explanation:
        "La Police technique et scientifique est chargée de l'analyse de preuves matérielles dans les enquêtes criminelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal enjeu de la Police face à la cybercriminalité ?",
    options: [
      "Éduquer le public",
      "Développer des lois",
      "Surveiller les réseaux sociaux",
    ],
    answer: "Éduquer le public",
    explanation:
        "Éduquer le public sur les risques de la cybercriminalité est essentiel pour renforcer la sécurité numérique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quels sont les droits des victimes d'infractions ?",
    options: [
      "Accéder à des soins médicaux",
      "Recevoir une indemnisation",
      "Avoir accès à la justice et à des informations",
    ],
    answer: "Avoir accès à la justice et à des informations",
    explanation:
        "Les victimes d'infractions ont droit à l'accès à la justice et à des informations sur leurs droits.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principe de la présomption d'innocence ?",
    options: [
      "Tout accusé est déclaré coupable",
      "Tout accusé est présumé innocent jusqu'à preuve du contraire",
      "Tout accusé doit prouver son innocence",
    ],
    answer: "Tout accusé est présumé innocent jusqu'à preuve du contraire",
    explanation:
        "La présomption d'innocence garantit que personne n'est considéré coupable tant que sa culpabilité n'a pas été établie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la durée maximale d'une garde à vue ?",
    options: ["24 heures", "48 heures", "72 heures"],
    answer: "48 heures",
    explanation:
        "La garde à vue peut durer jusqu'à 48 heures, renouvelable par un juge sous certaines conditions.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle principal de la police nationale en France ?",
    options: [
      "Gérer la sécurité routière",
      "Assurer l'ordre public",
      "Collecter des impôts",
    ],
    answer: "Assurer l'ordre public",
    explanation:
        "La police nationale a pour mission principale de maintenir l'ordre public dans la société.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est l'unité spécialisée dans la lutte contre le terrorisme au sein de la police nationale française ?",
    options: ["RAID", "BAC", "BRI"],
    answer: "RAID",
    explanation:
        "Le RAID (Recherche, Assistance, Intervention, Dissuasion) est une unité spécialisée dans les interventions contre le terrorisme.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le grade le plus élevé dans la hiérarchie de la police nationale française ?",
    options: ["Commissaire", "Gendarme", "Contrôleur"],
    answer: "Commissaire",
    explanation:
        "Le commissaire est le grade le plus élevé dans la police nationale, responsable de la direction d'un service.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel document permet de contrôler l'identité d'une personne en France ?",
    options: ["Carte de paiement", "Passeport", "Facture"],
    answer: "Passeport",
    explanation:
        "Le passeport est un document officiel servant à prouver l'identité d'une personne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la couleur des véhicules de police en France ?",
    options: ["Rouge", "Bleu", "Vert"],
    answer: "Bleu",
    explanation:
        "Les véhicules de police sont majoritairement de couleur bleue pour les distinguer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel âge faut-il avoir pour rejoindre la police nationale en France ?",
    options: ["18 ans", "21 ans", "25 ans"],
    answer: "18 ans",
    explanation:
        "Il est requis d'avoir au moins 18 ans pour postuler à la police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif de la police de proximité ?",
    options: [
      "Lutter contre le trafic de drogue",
      "Renforcer la relation avec la population",
      "Contrôler les frontières",
    ],
    answer: "Renforcer la relation avec la population",
    explanation:
        "La police de proximité vise à améliorer les relations entre les forces de l'ordre et les citoyens.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce qu'une intervention policière ?",
    options: [
      "Une arrestation",
      "Un contrôle routier",
      "Une opération de secours",
    ],
    answer: "Une arrestation",
    explanation:
        "Une intervention policière comprend souvent des opérations d'arrestation de suspects.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un enquêteur criminel ?",
    options: [
      "Rédiger des contraventions",
      "Rechercher des preuves",
      "Surveiller la circulation",
    ],
    answer: "Rechercher des preuves",
    explanation:
        "L'enquêteur criminel est chargé de recueillir des preuves pour élucider des crimes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la première étape d'une enquête criminelle ?",
    options: [
      "Interroger les témoins",
      "Bâtir un dossier",
      "Analyser la scène de crime",
    ],
    answer: "Analyser la scène de crime",
    explanation:
        "L'analyse de la scène de crime est cruciale pour rassembler des indices et preuves initiales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l'institut de formation des policiers en France ?",
    options: [
      "Institut national de police",
      "École nationale de la police",
      "Centre de formation de la police",
    ],
    answer: "École nationale de la police",
    explanation:
        "L'École nationale de la police forme les futurs agents de la police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des policiers en patrouille ?",
    options: [
      "Contrôler le trafic",
      "Récupérer des témoins",
      "Apporter des premiers secours",
    ],
    answer: "Contrôler le trafic",
    explanation:
        "Les policiers en patrouille assurent le contrôle du trafic pour garantir la sécurité routière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la principale loi régissant les actions de la police en France ?",
    options: ["Code pénal", "Code de la route", "Code civil"],
    answer: "Code pénal",
    explanation:
        "Le Code pénal définit les infractions et les mesures judiciaires que peuvent prendre les policiers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du téléphone d'alerte utilisé par les forces de l'ordre ?",
    options: ["Télémètre", "Alteur", "Talkie-walkie"],
    answer: "Talkie-walkie",
    explanation:
        "Le talkie-walkie est un dispositif de communication essentiel pour les interventions des policiers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la durée d'une garde à vue en France ?",
    options: ["24 heures", "48 heures", "72 heures"],
    answer: "48 heures",
    explanation:
        "En France, la garde à vue peut durer jusqu'à 48 heures sous certaines conditions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l'unité de police spécialisée dans les violences urbaines ?",
    options: ["BRI", "BAC", "DCRF"],
    answer: "BAC",
    explanation:
        "La BAC (Brigade Anti-Criminalité) est spécialisée dans la lutte contre les violences urbaines.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des experts judiciaires ?",
    options: [
      "Dresser des contraventions",
      "Assurer la sécurité lors d'événements",
      "Analyser des preuves",
    ],
    answer: "Analyser des preuves",
    explanation:
        "Les experts judiciaires sont chargés de l'analyse technique des preuves dans les enquêtes criminelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le symbole de la police nationale ?",
    options: ["Le glaive", "La balance", "Le bouclier"],
    answer: "Le glaive",
    explanation:
        "Le glaive symbolise l'autorité et la force de la loi, représentant la police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce qu'une fouille de sécurité ?",
    options: [
      "Un contrôle d'identité",
      "Une inspection corporelle",
      "Un contrôle de véhicules",
    ],
    answer: "Une inspection corporelle",
    explanation:
        "La fouille de sécurité consiste à inspecter le corps d'une personne pour vérifier la présence d'objets prohibés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'organe de contrôle des forces de police en France ?",
    options: [
      "Ministère de l'Intérieur",
      "Commission des droits de l'homme",
      "Inspection générale de la police",
    ],
    answer: "Inspection générale de la police",
    explanation:
        "L'Inspection générale de la police contrôle les agissements de la police nationale et de la gendarmerie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la procédure à suivre en cas de constatation d'un délit ?",
    options: ["Rester sur place", "Appeler les pompiers", "Prévenir la police"],
    answer: "Prévenir la police",
    explanation:
        "Il est crucial de prévenir la police pour signaler un délit et permettre une intervention appropriée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui dirige une enquête criminelle au sein de la police ?",
    options: ["Le chef d'équipe", "L'enquêteur principal", "Le procureur"],
    answer: "L'enquêteur principal",
    explanation:
        "L'enquêteur principal est responsable de la direction des investigations dans une affaire criminelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la mission des brigades anti-criminalité (BAC) ?",
    options: [
      "Surveiller les écoles",
      "Lutter contre le vol",
      "Contrôler les frontières",
    ],
    answer: "Lutter contre le vol",
    explanation:
        "Les BAC interviennent principalement pour prévenir et réagir aux actes de délinquance, comme le vol.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'équipement standard d'un policier en intervention ?",
    options: ["Taser", "Garde-robe", "Bâton"],
    answer: "Taser",
    explanation:
        "Le Taser est un outil non létal utilisé par les policiers pour immobiliser un individu dangereux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la fonction d'un greffier au sein de la police ?",
    options: [
      "Enregistrer des plaintes",
      "Rédiger des contraventions",
      "Assister les enquêteurs",
    ],
    answer: "Enregistrer des plaintes",
    explanation:
        "Le greffier est chargé d'enregistrer officiellement les plaintes déposées auprès de la police.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel corps de la police nationale est responsable de l'identification criminelle ?",
    options: ["SCPN", "SIRPA", "DCPJ"],
    answer: "DCPJ",
    explanation:
        "La Direction Centrale de la Police Judiciaire (DCPJ) est spécialisée dans l'identification criminelle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'acronyme de la police judiciaire en France ?",
    options: ["PJ", "CDP", "SGDSN"],
    answer: "PJ",
    explanation:
        "L'acronyme 'PJ' représente la police judiciaire, responsable des enquêtes criminelles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type de délit est un acte de violence physique ?",
    options: ["Délit de fuite", "Agression", "Vol"],
    answer: "Agression",
    explanation:
        "L'agression est un délit qui désigne toute forme de violence physique infligée à autrui.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'organe légal qui accuse une personne devant un tribunal ?",
    options: ["Le procureur", "L'avocat", "Le juge"],
    answer: "Le procureur",
    explanation:
        "Le procureur est l'organe de l'État qui engage des poursuites contre une personne soupçonnée d'un délit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui peut délivrer un permis de conduire ?",
    options: ["La préfecture", "La police", "Le conseil municipal"],
    answer: "La préfecture",
    explanation:
        "La préfecture est l'administration responsable de la délivrance de permis de conduire en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle du service de renseignement de la police ?",
    options: [
      "Contrôler les frontières",
      "Prévenir les actes criminels",
      "Fournir des transports policiers",
    ],
    answer: "Prévenir les actes criminels",
    explanation:
        "Le service de renseignement collecte et analyse des informations pour prévenir la criminalité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du fichier national permettant de recenser les personnes recherchées ?",
    options: [
      "FPR",
      "Fichier des personnes recherchées",
      "Système d'alerte national",
    ],
    answer: "Fichier des personnes recherchées",
    explanation:
        "Le fichier national permet de centraliser les informations sur les personnes en situation de recherche.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la principale mission des CRS (Compagnies Républicaines de Sécurité) ?",
    options: [
      "Lutte contre le terrorisme",
      "Gestion des manifestations",
      "Interventions en milieu rural",
    ],
    answer: "Gestion des manifestations",
    explanation:
        "Les CRS sont principalement mobilisées pour la gestion et le maintien de l'ordre lors des manifestations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quels sont les moyens principaux utilisés par la police pour lutter contre le trafic de drogue ?",
    options: ["Infiltration", "Patrouilles", "Contrôle de l'aviation"],
    answer: "Infiltration",
    explanation:
        "L'infiltration est une méthode stratégique pour démanteler les réseaux de trafic de drogue.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type d'infractions est le vol à l'étalage ?",
    options: ["Contravention", "Délit", "Crime"],
    answer: "Délit",
    explanation:
        "Le vol à l'étalage est une infraction classée comme délit dans le code pénal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but de l'interpellation judiciaire ?",
    options: ["Réunir des preuves", "Entraver un délit", "Arrêter un suspect"],
    answer: "Arrêter un suspect",
    explanation:
        "L'interpellation judiciaire a pour but d'arrêter une personne soupçonnée d'avoir commis une infraction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le ventre de la police en charge de la sécurité lors des évènements de grande ampleur ?",
    options: ["DOPC", "DGGN", "DRCPN"],
    answer: "DOPC",
    explanation:
        "Le DOPC (Département des opérations de sécurité publique) est chargé d'organiser la sécurité lors des événements majeurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le terme pour décrire une enquête secrète ?",
    options: [
      "Enquête ouverte",
      "Enquête administrative",
      "Enquête sous couverture",
    ],
    answer: "Enquête sous couverture",
    explanation:
        "Une enquête sous couverture est menée discrètement pour recueillir des informations sensibles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un agent de police aux frontières ?",
    options: [
      "Contrôler les passeports",
      "Assurer le service d'ambulance",
      "Former les policiers",
    ],
    answer: "Contrôler les passeports",
    explanation:
        "Les agents de police aux frontières vérifient les documents des voyageurs entrant et sortant du pays.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la peine encourue pour un délit de fuite ?",
    options: ["Peine de prison", "Amende", "Travaux d'intérêt général"],
    answer: "Peine de prison",
    explanation:
        "Le délit de fuite peut entraîner une peine de prison selon la gravité de l'incident.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type de renseignement traite le service de police nationale ?",
    options: [
      "Renseignements économiques",
      "Renseignements criminels",
      "Renseignements médicaux",
    ],
    answer: "Renseignements criminels",
    explanation:
        "Le service de police nationale collecte des renseignements pour enquêter sur des activités criminelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'objectif principal de la prévention de la délinquance ?",
    options: [
      "Récupérer les objets volés",
      "Éloigner les jeunes de la criminalité",
      "Former des policiers",
    ],
    answer: "Éloigner les jeunes de la criminalité",
    explanation:
        "La prévention de la délinquance vise à empêcher les jeunes de s'engager dans des comportements criminels.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la fonction d'un policier de la route ?",
    options: [
      "Contrôler la vitesse",
      "Récupérer des objets perdus",
      "Aider à la recherche de témoins",
    ],
    answer: "Contrôler la vitesse",
    explanation:
        "Les policiers de la route sont responsables de veiller au respect des règles de circulation, notamment la vitesse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'événement marquant de la création de la police en France ?",
    options: [
      "La Révolution française",
      "La Seconde Guerre mondiale",
      "La création de l'ENA",
    ],
    answer: "La Révolution française",
    explanation:
        "La Révolution française a conduit à la création d'une force de police structurée en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'objectif d'une patrouille de police dans une zone sensible ?",
    options: [
      "Surveiller les comportements suspects",
      "Promouvoir le tourisme",
      "Vérifier les horaires des commerces",
    ],
    answer: "Surveiller les comportements suspects",
    explanation:
        "La patrouille vise à détecter les comportements suspects pour prévenir la criminalité dans les zones sensibles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'élément clé du délit d'escroquerie ?",
    options: ["Une promesse", "Un mensonge", "Une plainte"],
    answer: "Un mensonge",
    explanation:
        "Le mensonge est l'élément central du délit d'escroquerie, car il implique une tromperie intentionnelle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la conséquence d'une contravention non payée ?",
    options: ["Annulation de permis", "Prison", "Majorations de l'amende"],
    answer: "Majorations de l'amende",
    explanation:
        "Une contravention non payée entraîne des majorations sur le montant de l'amende initiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le but de la vidéo surveillance dans les lieux publics ?",
    options: [
      "Vérifier l'hygiène",
      "Prévenir les accidents",
      "Assurer la sécurité",
    ],
    answer: "Assurer la sécurité",
    explanation:
        "La vidéo surveillance a pour but principal d'assurer la sécurité des lieux publics en détectant des comportements suspects.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Qui est responsable de la sécurité dans les transports en commun ?",
    options: ["La gare", "La police ferroviaire", "Les conducteurs"],
    answer: "La police ferroviaire",
    explanation:
        "La police ferroviaire est chargée de garantir la sécurité dans les réseaux de transports en commun.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un agent de liaison ?",
    options: [
      "Coordonner les opérations",
      "Entraîner les agents",
      "Édifier les rapports",
    ],
    answer: "Coordonner les opérations",
    explanation:
        "L'agent de liaison est responsable de la coordination entre différentes unités de police.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle loi a été instaurée en 2011 pour renforcer la lutte contre le terrorisme en France ?",
    options: [
      "Loi sur le renseignement",
      "Loi de sécurité intérieure",
      "Loi de programmation militaire",
    ],
    answer: "Loi sur le renseignement",
    explanation:
        "Cette loi vise à améliorer les capacités de renseignement des forces de sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle principal des policiers municipaux ?",
    options: [
      "Contrôler le trafic routier",
      "Assurer la sécurité des personnes et des biens",
      "Mener des enquêtes criminelles",
    ],
    answer: "Assurer la sécurité des personnes et des biens",
    explanation:
        "Les policiers municipaux sont chargés de la sécurité publique au niveau local.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'organe de coordination de la police nationale en France ?",
    options: [
      "La Direction générale de la police nationale",
      "Le ministère de l'Intérieur",
      "La Préfecture de police",
    ],
    answer: "La Direction générale de la police nationale",
    explanation:
        "Cet organe supervise et coordonne les actions de la police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme désignant une enquête sur des délits commis par des agents de l'État ?",
    options: [
      "Enquête administrative",
      "Enquête criminelle",
      "Enquête juridictionnelle",
    ],
    answer: "Enquête administrative",
    explanation:
        "Ces enquêtes visent à vérifier le comportement des agents publics.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le délai maximal pour un garde à vue en France ?",
    options: ["24 heures", "48 heures", "72 heures"],
    answer: "48 heures",
    explanation:
        "En général, une garde à vue peut durer jusqu'à 48 heures, prorogeable dans certains cas.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'acronyme de l'organisme chargé de la formation des policiers en France ?",
    options: ["ENSP", "CRF", "CSP"],
    answer: "ENSP",
    explanation:
        "L'École nationale supérieure de la police forme les futurs policiers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel document permet à un policier d'interpeller un individu ?",
    options: ["Un mandat", "Un procès-verbal", "Un ordre de mission"],
    answer: "Un mandat",
    explanation:
        "Le mandat d'arrêt est un document légal permettant l'interpellation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel dispositif permet de surveiller des individus suspectés de terrorisme ?",
    options: [
      "Les écoutes téléphoniques",
      "Le contrôle judiciaire",
      "La garde à vue",
    ],
    answer: "Les écoutes téléphoniques",
    explanation:
        "Les écoutes sont utilisées pour recueillir des informations sur des suspects.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif principal de la police de proximité ?",
    options: [
      "Renforcer les effectifs policiers",
      "Favoriser le contact entre citoyens et policiers",
      "Augmenter le nombre d'arrestations",
    ],
    answer: "Favoriser le contact entre citoyens et policiers",
    explanation:
        "La police de proximité vise à établir une relation de confiance avec la population.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle infraction est souvent sanctionnée par un retrait de permis de conduire ?",
    options: [
      "Vitesse excessive",
      "Stationnement gênant",
      "Non-respect d'un feu rouge",
    ],
    answer: "Vitesse excessive",
    explanation:
        "Le non-respect des limitations de vitesse peut entraîner un retrait de permis.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le nom de la police qui opère principalement à Paris ?",
    options: [
      "La police nationale",
      "La gendarmerie nationale",
      "La Préfecture de police",
    ],
    answer: "La Préfecture de police",
    explanation:
        "La Préfecture de police est responsable de la sécurité à Paris.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le but principal de l'intervention des équipes de déminage ?",
    options: [
      "Démanteler des réseaux criminels",
      "Neutraliser des explosifs",
      "Assurer la sécurité lors d'événements",
    ],
    answer: "Neutraliser des explosifs",
    explanation:
        "Les équipes de déminage travaillent pour éliminer les menaces explosives.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la première étape d'une enquête criminelle ?",
    options: [
      "L'interrogatoire des témoins",
      "Le constat des lieux",
      "La rédaction d'un rapport",
    ],
    answer: "Le constat des lieux",
    explanation:
        "Le constat des lieux est crucial pour recueillir des preuves.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'échelon supérieur à un commissaire de police ?",
    options: ["Inspecteur", "Directeur", "Commissaire divisionnaire"],
    answer: "Commissaire divisionnaire",
    explanation:
        "Le commissaire divisionnaire supervise plusieurs commissariats.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'un des principaux outils de la lutte contre le trafic de drogue ?",
    options: [
      "Les drones de surveillance",
      "Les caméras de sécurité",
      "Les chiens de détection",
    ],
    answer: "Les chiens de détection",
    explanation:
        "Ces chiens sont spécialement entraînés pour détecter les drogues.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'organe de décision qui valide les lois relatives à la sécurité publique ?",
    options: [
      "Le Sénat",
      "L'Assemblée nationale",
      "Le Conseil constitutionnel",
    ],
    answer: "L'Assemblée nationale",
    explanation:
        "L'Assemblée nationale a le pouvoir de voter les lois en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l’acte qui permet de faire appel d’une décision judiciaire ?",
    options: ["Le pourvoi", "L'opposition", "L'appel"],
    answer: "L'appel",
    explanation:
        "L'appel est une procédure permettant de contester une décision de justice.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est l’unité d’élite de la police nationale française ?",
    options: ["RAID", "BAC", "GIGN"],
    answer: "RAID",
    explanation:
        "Le RAID est une unité d'intervention spécialisée dans les situations de crise.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la principale fonction des gendarmes ?",
    options: [
      "Contrôler le respect des lois",
      "Assurer la sécurité routière",
      "Surveiller les aéroports",
    ],
    answer: "Contrôler le respect des lois",
    explanation:
        "Les gendarmes sont responsables de l'application des lois en milieu rural.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal critère pour qualifier un vol de vol à main armée ?",
    options: [
      "La présence d'une arme",
      "La violence physique",
      "Le montant du butin",
    ],
    answer: "La présence d'une arme",
    explanation:
        "Le vol à main armée implique l'utilisation d'une arme pour menacer la victime.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de la police judiciaire ?",
    options: [
      "Appliquer les lois",
      "Enquêter sur les crimes",
      "Protéger les témoins",
    ],
    answer: "Enquêter sur les crimes",
    explanation:
        "La police judiciaire est chargée de mener des enquêtes criminelles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel mouvement a fait évoluer la formation des policiers en France depuis les années 2000 ?",
    options: [
      "La réforme de la police",
      "Le plan Vigipirate",
      "La police de proximité",
    ],
    answer: "La réforme de la police",
    explanation:
        "Cette réforme a entraîné une modernisation et une professionnalisation des agents.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "À quoi sert une perquisition ?",
    options: [
      "Collecter des preuves",
      "Interroger des témoins",
      "Arrêter un suspect",
    ],
    answer: "Collecter des preuves",
    explanation:
        "La perquisition est utilisée pour trouver des éléments de preuve dans une enquête.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la caractéristique principale d'une infraction de flagrant délit ?",
    options: [
      "Elle est punie par la prison",
      "Elle est constatée à l'instant de sa commission",
      "Elle nécessite une plainte préalable",
    ],
    answer: "Elle est constatée à l'instant de sa commission",
    explanation:
        "Le flagrant délit permet l'interpellation immédiate de l'auteur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du fichier des personnes recherchées par la police ?",
    options: ["FPR", "Fichier STIC", "Fichier AVS"],
    answer: "Fichier STIC",
    explanation:
        "Le STIC rassemble les informations sur les personnes recherchées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'impact principal de la vidéosurveillance sur la sécurité publique ?",
    options: [
      "Augmenter la répression",
      "Dissuader les délits",
      "Améliorer la résilience",
    ],
    answer: "Dissuader les délits",
    explanation:
        "La présence de caméras peut dissuader les comportements criminels.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le nom de la police dédiée aux automobilistes ?",
    options: ["La gendarmerie", "La police routière", "La police nationale"],
    answer: "La police routière",
    explanation:
        "La police routière est spécialisée dans les infractions liées à la circulation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type d'infraction est le blanchiment d'argent ?",
    options: ["Un délit", "Une contravention", "Un crime"],
    answer: "Un délit",
    explanation:
        "Le blanchiment d'argent est classé comme un délit en droit pénal.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif principal des opérations de sécurité ?",
    options: [
      "Renforcer les effectifs",
      "Prévenir la délinquance",
      "Augmenter les arrestations",
    ],
    answer: "Prévenir la délinquance",
    explanation:
        "Les opérations de sécurité visent à réduire la criminalité par la présence policière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel organisme est responsable de la sécurité publique en France ?",
    options: [
      "La police nationale",
      "La gendarmerie nationale",
      "Le ministère de l'Intérieur",
    ],
    answer: "Le ministère de l'Intérieur",
    explanation:
        "Le ministère de l'Intérieur supervise les forces de sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la séparation entre la police et la gendarmerie basée sur ?",
    options: [
      "Le milieu urbain et rural",
      "Le type de délits",
      "Les moyens techniques",
    ],
    answer: "Le milieu urbain et rural",
    explanation:
        "La police opère principalement en milieu urbain tandis que la gendarmerie se concentre sur les zones rurales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du document qui officialise une enquête criminelle ?",
    options: ["Procès-verbal", "Rapport d'enquête", "Plainte"],
    answer: "Procès-verbal",
    explanation:
        "Le procès-verbal est le document officiel attestant de l'enquête.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle du juge d'instruction ?",
    options: [
      "Rendre des décisions",
      "Enquêter sur les crimes",
      "Diriger les audiences",
    ],
    answer: "Enquêter sur les crimes",
    explanation:
        "Le juge d'instruction mène des enquêtes sur des affaires criminelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le but de la loi sur la liberté de la presse en France ?",
    options: [
      "Protéger les journalistes",
      "Garantir la liberté d'expression",
      "Réguler le contenu des médias",
    ],
    answer: "Garantir la liberté d'expression",
    explanation:
        "Cette loi protège le droit des journalistes à informer le public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'organe central de la gendarmerie nationale ?",
    options: [
      "Le général de gendarmerie",
      "La direction générale",
      "La brigade nationale",
    ],
    answer: "La direction générale",
    explanation:
        "La direction générale supervise l'ensemble des opérations de la gendarmerie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle action peut être entreprise lors d'une arrestation ?",
    options: [
      "L'amende",
      "La détention provisoire",
      "La mise en liberté conditionnelle",
    ],
    answer: "La détention provisoire",
    explanation: "La détention provisoire peut être ordonnée avant le procès.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'impact des lois antiterroristes sur la vie quotidienne des citoyens ?",
    options: [
      "Aucune incidence",
      "Renforcement de la sécurité",
      "Restrictions des libertés",
    ],
    answer: "Restrictions des libertés",
    explanation:
        "Ces lois peuvent limiter certaines libertés individuelles au nom de la sécurité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la prérogative des forces de l'ordre durant un coup d'État ?",
    options: [
      "Assurer la sécurité des citoyens",
      "Protéger les institutions",
      "Maintenir l'ordre public",
    ],
    answer: "Protéger les institutions",
    explanation:
        "Les forces de l'ordre doivent défendre l'État et ses institutions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un OPJ (officier de police judiciaire) ?",
    options: [
      "Diriger les enquêtes",
      "Prendre des décisions judiciaires",
      "Mener des investigations",
    ],
    answer: "Mener des investigations",
    explanation:
        "L'OPJ est habilité à mener des enquêtes et à rassembler des preuves.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du fichier permettant de rechercher des personnes disparues ?",
    options: [
      "Fichier des personnes disparues",
      "Fichier de recherche",
      "Fichier des personnes recherchées",
    ],
    answer: "Fichier des personnes recherchées",
    explanation:
        "Ce fichier regroupe les informations sur les personnes disparues.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la principale fonction du Service de la sécurité intérieure (SSI) ?",
    options: [
      "Protéger les personnalités",
      "Prévenir le terrorisme",
      "Lutter contre la cybercriminalité",
    ],
    answer: "Prévenir le terrorisme",
    explanation:
        "Le SSI est spécialisé dans la prévention des actes terroristes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle de l'Inspection générale de la police nationale ?",
    options: [
      "Évaluer la performance des policiers",
      "Contrôler les opérations policières",
      "Assurer la formation des agents",
    ],
    answer: "Évaluer la performance des policiers",
    explanation:
        "L'IGPN s'assure que les policiers respectent la légalité et les normes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but du contrôle judiciaire ?",
    options: [
      "Assurer la sécurité du prévenu",
      "Surveiller les comportements à risque",
      "Alléger la charge pénale",
    ],
    answer: "Surveiller les comportements à risque",
    explanation:
        "Le contrôle judiciaire vise à s'assurer que le prévenu ne commet pas de nouvelles infractions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'effet des campagnes de sensibilisation à la sécurité routière ?",
    options: [
      "Augmenter le nombre d'accidents",
      "Réduire le nombre d'accidents",
      "Encourager la conduite dangereuse",
    ],
    answer: "Réduire le nombre d'accidents",
    explanation:
        "Ces campagnes visent à éduquer les conducteurs pour prévenir les accidents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de la loi qui a instauré la vidéosurveillance dans les lieux publics ?",
    options: [
      "Loi sur la sécurité intérieure",
      "Loi relative à la prévention de la délinquance",
      "Loi sur la surveillance des espaces publics",
    ],
    answer: "Loi relative à la prévention de la délinquance",
    explanation:
        "Cette loi a permis d'étendre l'utilisation de la vidéosurveillance en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal but des patrouilles de police ?",
    options: [
      "Disperser les foules",
      "Prévenir les infractions",
      "Augmenter les arrestations",
    ],
    answer: "Prévenir les infractions",
    explanation:
        "Les patrouilles visent à dissuader les criminels et à assurer la sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un témoin dans une enquête criminelle ?",
    options: [
      "Fournir des preuves",
      "Assister aux interrogatoires",
      "Remplacer l'accusé",
    ],
    answer: "Fournir des preuves",
    explanation:
        "Les témoins jouent un rôle clé en apportant des éléments de preuve.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'impact du harcèlement sur les victimes ?",
    options: [
      "Aucun",
      "Amélioration de la santé mentale",
      "Détérioration de la santé mentale",
    ],
    answer: "Détérioration de la santé mentale",
    explanation:
        "Le harcèlement peut avoir des conséquences graves sur la santé mentale des victimes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la procédure à suivre pour porter plainte ?",
    options: [
      "S'adresser directement au juge",
      "Déposer une plainte auprès de la police",
      "Contacter un avocat",
    ],
    answer: "Déposer une plainte auprès de la police",
    explanation: "La plainte doit être formulée auprès des forces de police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel élément essentiel doit être respecté lors d'une arrestation ?",
    options: [
      "Le droit à un avocat",
      "Le droit à un téléphone",
      "Le droit à un procès",
    ],
    answer: "Le droit à un avocat",
    explanation:
        "Toute personne arrêtée a le droit d'être assistée par un avocat.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle principal de la police nationale en France ?",
    options: [
      "Maintenir l'ordre public",
      "Préparer les élections",
      "Gérer les affaires étrangères",
    ],
    answer: "Maintenir l'ordre public",
    explanation:
        "La police nationale a pour mission principale de garantir la sécurité et le maintien de l'ordre public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le grade le plus élevé dans la police nationale ?",
    options: ["Contrôleur général", "Commissaire de police", "Brigadier"],
    answer: "Contrôleur général",
    explanation:
        "Le grade de contrôleur général est le plus élevé dans la hiérarchie de la police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'objectif principal de la prévention de la délinquance ?",
    options: [
      "Augmenter le nombre d'arrestations",
      "Éviter que des crimes ne soient commis",
      "Promouvoir des événements communautaires",
    ],
    answer: "Éviter que des crimes ne soient commis",
    explanation:
        "La prévention de la délinquance vise à réduire les occasions de criminalité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel document doit être présenté lors d'un contrôle d'identité ?",
    options: ["La carte vitale", "Le passeport", "Le permis de conduire"],
    answer: "Le passeport",
    explanation:
        "Le passeport est un document d'identité valable lors des contrôles d'identité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nombre de policiers dans la police nationale française environ ?",
    options: ["150 000", "80 000", "300 000"],
    answer: "150 000",
    explanation:
        "Environ 150 000 agents composent les rangs de la police nationale en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la principale juridiction où la police nationale intervient ?",
    options: [
      "Les tribunaux administratifs",
      "Les tribunaux de grande instance",
      "Les tribunaux militaires",
    ],
    answer: "Les tribunaux de grande instance",
    explanation:
        "La police nationale intervient principalement devant les tribunaux de grande instance pour les affaires pénales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'emblème de la police nationale en France ?",
    options: ["Un aigle", "Un lion", "Un phénix"],
    answer: "Un aigle",
    explanation:
        "L'aigle est l'emblème symbolique de la police nationale française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type de crime la police nationale est-elle la plus souvent appelée à traiter ?",
    options: [
      "Les crimes économiques",
      "Les crimes violents",
      "Les crimes environnementaux",
    ],
    answer: "Les crimes violents",
    explanation:
        "La police nationale traite le plus souvent des crimes violents comme les homicides ou les agressions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des brigades anti-criminalité ?",
    options: [
      "Surveiller les frontières",
      "Intervenir en cas de troubles",
      "Effectuer des contrôles routiers",
    ],
    answer: "Intervenir en cas de troubles",
    explanation:
        "Les brigades anti-criminalité sont spécialisées dans l'intervention rapide face à des situations de troubles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui est responsable de la police nationale en France ?",
    options: [
      "Le ministre de la Justice",
      "Le ministre de l'Intérieur",
      "Le Premier ministre",
    ],
    answer: "Le ministre de l'Intérieur",
    explanation:
        "Le ministre de l'Intérieur est responsable de la police nationale en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la priorité des opérations de police en matière de sécurité routière ?",
    options: [
      "Contrôler la vitesse",
      "Lutter contre l'alcool au volant",
      "Éduquer les conducteurs",
    ],
    answer: "Lutter contre l'alcool au volant",
    explanation:
        "La lutte contre l'alcool au volant est primordiale pour améliorer la sécurité routière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme utilisé pour désigner une enquête criminelle ?",
    options: ["Procédure judiciaire", "Instruction", "Enquête préliminaire"],
    answer: "Instruction",
    explanation:
        "L'instruction est une phase clé de l'enquête criminelle pour rassembler les preuves.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but d'un contrôle routier ?",
    options: [
      "Vérifier les équipements",
      "S'assurer du respect du code de la route",
      "Appliquer des amendes uniquement",
    ],
    answer: "S'assurer du respect du code de la route",
    explanation:
        "Le contrôle routier vise avant tout à s'assurer que le code de la route est respecté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'un des outils de la police pour lutter contre la cybercriminalité ?",
    options: [
      "Le téléphone portable",
      "Les réseaux sociaux",
      "Les ordinateurs",
    ],
    answer: "Les ordinateurs",
    explanation:
        "Les ordinateurs sont des outils essentiels pour la police dans la lutte contre la cybercriminalité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Comment appellent-on un policier en uniforme ?",
    options: ["Agent de police", "Gendarme", "Inspecteur"],
    answer: "Agent de police",
    explanation:
        "Un policier en uniforme est couramment désigné comme un agent de police.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal moyen de communication de la police nationale ?",
    options: ["Le téléphone", "L'Internet", "La radio"],
    answer: "La radio",
    explanation:
        "La radio est un outil crucial pour la communication rapide entre les agents sur le terrain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est l'un des droits fondamentaux d'un citoyen lors d'un contrôle de police ?",
    options: [
      "Être informé de ses droits",
      "Être interrogé sans témoin",
      "Être détenu sans motif",
    ],
    answer: "Être informé de ses droits",
    explanation:
        "Chaque citoyen a le droit d'être informé de ses droits lors d'un contrôle de police.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le nom du service de secours d'urgence en France ?",
    options: ["SAMU", "SAPEURS-POMPIERS", "Gendarmerie"],
    answer: "SAMU",
    explanation:
        "Le SAMU est le service de secours d'urgence, souvent en coopération avec la police.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui peut effectuer une arrestation en France ?",
    options: ["Tout citoyen", "Un agent de police", "Un juge"],
    answer: "Un agent de police",
    explanation:
        "Seul un agent de police a le pouvoir d'effectuer une arrestation en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'objectif des patrouilles de police dans les quartiers ?",
    options: [
      "Dissuader la criminalité",
      "Collecter des impôts",
      "Distribuer des prospectus",
    ],
    answer: "Dissuader la criminalité",
    explanation:
        "Les patrouilles de police visent à dissuader les actes criminels par une présence visible.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal but d'un rapport de police ?",
    options: [
      "Divertir le public",
      "Documenter les événements criminels",
      "Obliger les gens à payer des amendes",
    ],
    answer: "Documenter les événements criminels",
    explanation:
        "Le rapport de police sert à documenter formellement les événements criminels.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est un des principaux enjeux de la police nationale aujourd'hui ?",
    options: [
      "La preuve de l'innocence",
      "La lutte contre le terrorisme",
      "L'augmentation du personnel",
    ],
    answer: "La lutte contre le terrorisme",
    explanation:
        "La lutte contre le terrorisme est actuellement un enjeu majeur pour la police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but de la police de proximité ?",
    options: [
      "Renforcer les relations avec la communauté",
      "Accroître le nombre d'arrestations",
      "Gérer les opérations de police",
    ],
    answer: "Renforcer les relations avec la communauté",
    explanation:
        "La police de proximité vise à établir de meilleures relations avec les citoyens.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type de délit est puni par des amendes ?",
    options: [
      "Les délits mineurs",
      "Les crimes graves",
      "Les infractions militaires",
    ],
    answer: "Les délits mineurs",
    explanation: "Les délits mineurs sont généralement punis par des amendes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal objectif d'un renseignement de police ?",
    options: [
      "Recueillir des informations utiles",
      "Surveiller les citoyens",
      "Établir des frais",
    ],
    answer: "Recueillir des informations utiles",
    explanation:
        "L'objectif des renseignements de police est de recueillir des informations pour prévenir la criminalité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel était le principal objectif de la police nationale lors de sa création ?",
    options: [
      "Maintenir l'ordre",
      "Contrôler les frontières",
      "Surveiller les campagnes",
    ],
    answer: "Maintenir l'ordre",
    explanation:
        "La police nationale a été créée principalement pour maintenir l'ordre public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle du procureur dans une affaire criminelle ?",
    options: ["Défendre l'accusé", "Jugement final", "Représenter la société"],
    answer: "Représenter la société",
    explanation:
        "Le procureur représente les intérêts de la société et veille à l'application de la loi.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la formation de base pour devenir policier en France ?",
    options: [
      "Prépa criminologie",
      "École nationale de police",
      "Université de droit",
    ],
    answer: "École nationale de police",
    explanation:
        "La formation de base pour devenir policier se fait à l'École nationale de police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est un des droits des policiers en service ?",
    options: [
      "Porter une arme",
      "Voyager à l'étranger",
      "Obtenir des congés illimités",
    ],
    answer: "Porter une arme",
    explanation:
        "Les policiers en service ont le droit de porter une arme pour assurer leur protection.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'organe de contrôle de l'action de la police nationale ?",
    options: ["La cour des comptes", "L'IGPN", "Le conseil municipal"],
    answer: "L'IGPN",
    explanation:
        "L'IGPN est l'organe chargé de contrôler le bon fonctionnement et l'éthique de la police nationale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif d'une enquête de police ?",
    options: [
      "Collecter des preuves",
      "Rendre une décision",
      "Rédiger un rapport",
    ],
    answer: "Collecter des preuves",
    explanation:
        "L'objectif principal d'une enquête de police est de collecter des preuves pour élucider un crime.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel département est principalement chargé de la sécurité publique en France ?",
    options: [
      "Le ministère de la Culture",
      "Le ministère de l'Intérieur",
      "Le ministère des Affaires étrangères",
    ],
    answer: "Le ministère de l'Intérieur",
    explanation:
        "Le ministère de l'Intérieur est en charge de la sécurité publique en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la principale mission du GIGN ?",
    options: [
      "Intervention lors de situations de crise",
      "Surveillance des frontières",
      "Prévention des délits mineurs",
    ],
    answer: "Intervention lors de situations de crise",
    explanation:
        "La principale mission du GIGN est d'intervenir lors des situations de crise, comme les prises d'otages.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un agent de police judiciaire ?",
    options: [
      "Enquêter sur les crimes",
      "Rédiger les décrets",
      "Assurer le service de sécurité",
    ],
    answer: "Enquêter sur les crimes",
    explanation:
        "L'agent de police judiciaire est spécialement habilité pour enquêter sur les crimes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Dans quelle situation un individu peut-il être placé en garde à vue ?",
    options: [
      "Lorsque la personne est suspectée d'un crime",
      "Lorsqu'une personne est en vacances",
      "Lorsque quelqu'un fait du bénévolat",
    ],
    answer: "Lorsque la personne est suspectée d'un crime",
    explanation:
        "Un individu peut être placé en garde à vue lorsqu'il est suspecté d'avoir commis un crime.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est un des frais associés à une interpellation ?",
    options: [
      "Les frais de justice",
      "Les frais d'immatriculation",
      "Les frais de transport",
    ],
    answer: "Les frais de justice",
    explanation:
        "Les frais de justice sont souvent associés aux procédures après une interpellation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif d'un plan de sécurité publique ?",
    options: [
      "Établir des priorités et des actions",
      "Augmenter le nombre de policiers",
      "Réduire les salaires",
    ],
    answer: "Établir des priorités et des actions",
    explanation:
        "Le plan de sécurité publique vise à établir des priorités claires et des actions appropriées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le type de matériel utilisé pour la surveillance en temps réel ?",
    options: [
      "Les caméras de sécurité",
      "Les livres de comptes",
      "Les ordinateurs de bureau",
    ],
    answer: "Les caméras de sécurité",
    explanation:
        "Les caméras de sécurité sont un outil crucial pour la surveillance en temps réel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un expert judiciaire dans une enquête ?",
    options: [
      "Réunir des témoins",
      "Analyser des preuves",
      "Écrire le procès-verbal",
    ],
    answer: "Analyser des preuves",
    explanation:
        "Un expert judiciaire est chargé d'analyser des preuves lors d'une enquête.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme utilisé pour désigner un comportement criminel ?",
    options: ["Infraction", "Sursis", "Responsabilité"],
    answer: "Infraction",
    explanation: "Une infraction désigne tout acte qui enfreint la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'une patrouille canine ?",
    options: [
      "Dissuader les habitants",
      "Rechercher des drogues",
      "Aider à la circulation",
    ],
    answer: "Rechercher des drogues",
    explanation:
        "Les patrouilles canines sont souvent utilisées pour rechercher des drogues dans les opérations de police.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est un des objectifs des agents de sécurité dans les grandes manifestations ؟",
    options: [
      "Encadrer le public",
      "S'assurer qu'il pleuve",
      "Distribuer des dépliants",
    ],
    answer: "Encadrer le public",
    explanation:
        "Les agents de sécurité sont là pour encadrer le public lors des grandes manifestations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'acronyme utilisé pour désigner la police nationale française ?",
    options: ["PNF", "GIGN", "DCPJ"],
    answer: "DCPJ",
    explanation:
        "DCPJ signifie Direction Centrale de la Police Judiciaire, qui fait partie de la police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est l'un des outils technologiques utilisés par la police pour enquêter ?",
    options: ["Les drones", "Les tablettes", "Les caméras de sécurité"],
    answer: "Les drones",
    explanation:
        "Les drones sont de plus en plus utilisés par la police pour surveiller des zones difficiles d'accès.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Pourquoi la police procède-t-elle à des contrôles d'alcoolémie ?",
    options: [
      "Pour amuser le public",
      "Pour sensibiliser à la sécurité",
      "Pour sanctionner les conducteurs",
    ],
    answer: "Pour sensibiliser à la sécurité",
    explanation:
        "Les contrôles d'alcoolémie visent à sensibiliser les conducteurs à la sécurité routière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le premier réflexe d'un policier face à un délit en cours ?",
    options: ["Interroger les témoins", "Intervenir", "Appeler un supérieur"],
    answer: "Intervenir",
    explanation:
        "Le premier réflexe d'un policier doit être d'intervenir pour mettre fin au délit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'un des objectifs de la police nationale en matière de sécurité publique ?",
    options: [
      "Augmenter le nombre de révoltes",
      "Réduire les crimes",
      "Augmenter la criminalité",
    ],
    answer: "Réduire les crimes",
    explanation:
        "Un des principaux objectifs de la police nationale est de réduire les crimes dans la société.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un policier lors d'une enquête criminelle ?",
    options: [
      "Mettre à jour les réseaux sociaux",
      "Prendre des notes sur le terrain",
      "Défendre l'accusé",
    ],
    answer: "Prendre des notes sur le terrain",
    explanation:
        "Un policier doit prendre des notes sur le terrain pour garder une trace des faits et des témoins.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal sujet de la formation des policiers ?",
    options: [
      "Les langues étrangères",
      "La loi et le droit",
      "Les mathématiques",
    ],
    answer: "La loi et le droit",
    explanation:
        "La formation des policiers est centrée sur la loi et le droit pour assurer leur compétence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'objectif principal des interventions des forces de l'ordre lors d'événements publics ?",
    options: [
      "Assurer la sécurité des participants",
      "Distribuer des tracts",
      "Faire des contrôles de vitesse",
    ],
    answer: "Assurer la sécurité des participants",
    explanation:
        "Les forces de l'ordre interviennent principalement pour garantir la sécurité lors d'événements publics.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la mission principale de la Police nationale en France ?",
    options: [
      "Assurer la sécurité des citoyens",
      "Collecter des impôts",
      "Gérer les affaires étrangères",
    ],
    answer: "Assurer la sécurité des citoyens",
    explanation:
        "La Police nationale est responsable de la sécurité publique en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le grade le plus élevé dans la Police nationale française ?",
    options: ["Commissaire", "Brigadier", "Sous-brigadier"],
    answer: "Commissaire",
    explanation:
        "Le commissaire est le grade le plus élevé dans la hiérarchie de la Police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la formation initiale requise pour devenir policier en France ?",
    options: ["Un baccalauréat", "Un diplôme universitaire", "Un CAP"],
    answer:
        "Un baccalauréat pour Gardien de la paix, un diplôme universitaire pour Officier de police",
    explanation:
        "Le baccalauréat est le minimum requis pour entrer dans la Police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Comment appelle-t-on les agents de police en patrouille ?",
    options: ["Les policiers", "Les gendarmes", "Les enquêteurs"],
    answer: "Les policiers",
    explanation:
        "Les policiers en patrouille sont communément appelés des policiers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel service est chargé de la lutte contre le trafic de stupéfiants en France ?",
    options: ["La BAC", "La PJ", "La CRS"],
    answer: "La PJ",
    explanation:
        "La police judiciaire (PJ) est responsable des enquêtes sur le trafic de stupéfiants.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle loi encadre les pouvoirs de la Police nationale ?",
    options: [
      "Le Code pénal",
      "Le Code de la route",
      "Le Code de la sécurité intérieure",
    ],
    answer: "Le Code de la sécurité intérieure",
    explanation:
        "Le Code de la sécurité intérieure définit les missions et les pouvoirs de la Police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui est responsable de la direction de la Police nationale ?",
    options: [
      "Le ministre de l'Intérieur",
      "Le président de la République",
      "Le préfet",
    ],
    answer: "Le ministre de l'Intérieur",
    explanation:
        "Le ministre de l'Intérieur est chargé de la direction de la Police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme utilisé pour désigner une opération de surveillance discrète ?",
    options: ["Filature", "Intervention", "Contrôle"],
    answer: "Filature",
    explanation:
        "Une filature consiste à suivre une personne dans le cadre d'une enquête.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'objectif principal de l'Office central de lutte contre le crime organisé (OCCO) ?",
    options: [
      "Contrôler le trafic d'armes",
      "Lutter contre le terrorisme",
      "Lutter contre la criminalité organisée",
    ],
    answer: "Lutter contre la criminalité organisée",
    explanation:
        "L'OCCO est dédié à la lutte contre la criminalité organisée en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du corps d'intervention de la Police nationale française ?",
    options: ["RAID", "GIGN", "BAC"],
    answer: "RAID",
    explanation:
        "Le RAID est le Groupe d'Intervention de la Police nationale, spécialisé dans les situations d'urgence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'acronyme du Bureau de la lutte contre la criminalité organisée en France ?",
    options: ["BCR", "OCCO", "BRIC"],
    answer: "OCCO",
    explanation:
        "OCCO signifie Office Central de Lutte contre le Crime Organisé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la prérogative des agents de la police nationale ?",
    options: [
      "Faire des arrestations",
      "Rédiger des lois",
      "Organiser des élections",
    ],
    answer: "Faire des arrestations",
    explanation:
        "Les agents de la police nationale ont le pouvoir d'arrêter des personnes en flagrant délit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de la brigade anti-criminalité (BAC) ?",
    options: [
      "Surveiller la circulation",
      "Lutter contre le vol et l'agression",
      "Assurer la sécurité des bâtiments",
    ],
    answer: "Lutter contre le vol et l'agression",
    explanation:
        "La BAC intervient principalement lors d'interventions liées à la délinquance.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal document d'identité français ?",
    options: ["La carte d'identité", "Le passeport", "Le permis de conduire"],
    answer: "La carte d'identité",
    explanation:
        "La carte nationale d'identité est le principal document d'identité en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de la police de l'air et des frontières ?",
    options: [
      "Contrôler les transports en commun",
      "Surveiller les frontières",
      "Maintenir l'ordre public",
    ],
    answer: "Surveiller les frontières",
    explanation:
        "La police de l'air et des frontières est chargée de la surveillance des frontières françaises.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel organisme gère la sécurité routière en France ?",
    options: [
      "La CRS",
      "La gendarmerie",
      "La Direction de la Sécurité routière",
    ],
    answer: "La Direction de la Sécurité routière",
    explanation:
        "La sécurité routière est gérée par la Direction de la Sécurité routière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle des brigades canines dans la Police nationale ?",
    options: [
      "Détecter des explosifs",
      "Surveiller des manifestations",
      "Contrôler la circulation",
    ],
    answer: "Détecter des explosifs",
    explanation:
        "Les brigades canines sont formées pour détecter des substances dangereuses telles que les explosifs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du document officiel récapitulant les droits d'un individu en garde à vue ?",
    options: [
      "Les droits du citoyen",
      "Les droits de la défense",
      "Les droits en garde à vue",
    ],
    answer: "Les droits en garde à vue",
    explanation:
        "Ce document informe les personnes de leurs droits lorsqu'elles sont placées en garde à vue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est l'agence internationale qui collabore avec les forces de police pour lutter contre la criminalité organisée ?",
    options: ["Europol", "INTERPOL", "FBI"],
    answer: "INTERPOL",
    explanation:
        "INTERPOL facilite la coopération entre les forces de police pour lutter contre la criminalité transnationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des unités de sécurité publique ?",
    options: [
      "Intervenir lors de troubles",
      "Rédiger des rapports",
      "Assurer les enquêtes",
    ],
    answer: "Intervenir lors de troubles",
    explanation:
        "Les unités de sécurité publique sont appelées à intervenir en cas de troubles à l'ordre public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l'institution qui forme les futurs policiers en France ?",
    options: [
      "ENSP",
      "Institut de police",
      "Centre de formation des policiers",
    ],
    answer: "ENSP",
    explanation:
        "L'École Nationale Supérieure de Police (ENSP) forme les futurs policiers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type de crime concerne la cybercriminalité ?",
    options: [
      "Vol physique",
      "Fraude en ligne",
      "Escroquerie à la carte bancaire",
    ],
    answer: "Fraude en ligne",
    explanation:
        "La cybercriminalité inclut des activités illégales telles que la fraude en ligne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la compétence de la gendarmerie nationale en France ?",
    options: [
      "Assurer la sécurité maritime",
      "Assurer la sécurité en milieu urbain",
      "Assurer la sécurité en milieu rural",
    ],
    answer: "Assurer la sécurité en milieu rural",
    explanation:
        "La gendarmerie nationale est principalement responsable des zones rurales et périurbaines.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce que le fichier TES ?",
    options: [
      "Un fichier des infractions",
      "Un fichier des personnes recherchées",
      "Un fichier des empreintes digitales",
    ],
    answer: "Un fichier des empreintes digitales",
    explanation:
        "Le fichier TES recense les empreintes digitales des individus en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des médiateurs dans la police ?",
    options: [
      "Traiter les conflits",
      "Protéger les témoins",
      "Rédiger des contraventions",
    ],
    answer: "Traiter les conflits",
    explanation:
        "Les médiateurs aident à résoudre les conflits sans recourir à des mesures coercitives.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nombre de policiers dans la Police nationale française ?",
    options: ["Environ 145 000", "Environ 100 000", "Environ 200 000"],
    answer: "Environ 145 000",
    explanation:
        "La Police nationale compte environ 145 000 policiers en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but de la démarche citoyenne de la police ?",
    options: [
      "Améliorer l'image de la police",
      "Renforcer la confiance du public",
      "Augmenter le nombre d'agents",
    ],
    answer: "Renforcer la confiance du public",
    explanation:
        "La démarche citoyenne vise à créer un lien de confiance entre la police et les citoyens.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel secteur de laPolice internationale traite des problèmes liés à la drogue ?",
    options: ["L'ONUDC", "L'INTERPOL", "Le FBI"],
    answer: "L'ONUDC",
    explanation:
        "L'Office des Nations unies contre la drogue et le crime (ONUDC) traite spécifiquement des problèmes liés à la drogue.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme pour désigner la protection accordée aux témoins ?",
    options: [
      "Protection des témoins",
      "Assistance judiciaire",
      "Sécurité des témoins",
    ],
    answer: "Protection des témoins",
    explanation:
        "La protection des témoins est une mesure prise pour assurer leur sécurité en cas de témoignage.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la fonction de la police aux frontières ?",
    options: [
      "Contrôler les aéroports",
      "Ensurer la sécurité des prisons",
      "Surveiller les points de passage frontalier",
    ],
    answer: "Surveiller les points de passage frontalier",
    explanation:
        "La police aux frontières est chargée de surveiller les entrées et sorties du territoire français.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel dispositif est utilisé pour les interventions d'urgence ?",
    options: [
      "Véhicules de secours",
      "Équipes d'intervention",
      "Appels d'urgence",
    ],
    answer: "Équipes d'intervention",
    explanation:
        "Les équipes d'intervention sont spécialement formées pour répondre aux situations d'urgence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle principal du service des renseignements ?",
    options: [
      "Collecter des informations",
      "Préparer des opérations",
      "Faire des arrestations",
    ],
    answer: "Collecter des informations",
    explanation:
        "Le service des renseignements est chargé de collecter et d'analyser des informations pertinentes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal acteur de la lutte contre le terrorisme en France ?",
    options: ["La DGSI", "La gendarmerie", "La police municipale"],
    answer: "La DGSI",
    explanation:
        "La Direction Générale de la Sécurité Intérieure (DGSI) est responsable de la lutte contre le terrorisme.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'acronyme du Groupement d'Intervention de la Gendarmerie Nationale ?",
    options: ["GIPN", "GIGN", "GIGNR"],
    answer: "GIGN",
    explanation:
        "Le GIGN est le Groupement d'Intervention de la Gendarmerie Nationale, spécialisé dans les opérations d'urgence.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de la loi qui régit l'usage de la force par les forces de l'ordre en France ?",
    options: [
      "Loi de la sécurité intérieure",
      "Loi sur la légitime défense",
      "Loi sur l'usage de la force",
    ],
    answer: "Loi sur l'usage de la force",
    explanation:
        "Cette loi détermine les conditions dans lesquelles les forces de l'ordre peuvent utiliser la force.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de la déontologie dans la Police nationale ?",
    options: [
      "Encadrer les comportements",
      "Améliorer les relations publiques",
      "Promouvoir les agents",
    ],
    answer: "Encadrer les comportements",
    explanation:
        "La déontologie vise à définir les principes moraux et éthiques des agents de police.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme pour désigner le processus d'enquête dans lequel le corps de la victime est examiné ?",
    options: ["L'autopsie", "La criminologie", "L'analyse judiciaire"],
    answer: "L'autopsie",
    explanation:
        "L'autopsie est effectuée pour déterminer la cause du décès lors d'une enquête criminelle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du fichier regroupant les informations sur les malfaiteurs en France ?",
    options: [
      "Le fichier judiciaire",
      "Le casier judiciaire",
      "Le fichier des infractions",
    ],
    answer: "Le casier judiciaire",
    explanation:
        "Le casier judiciaire contient les mentions des condamnations et des infractions des individus.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des enquêtes criminelles ?",
    options: [
      "Prévenir les crimes",
      "Résoudre les affaires criminelles",
      "Collecter des preuves",
    ],
    answer: "Résoudre les affaires criminelles",
    explanation:
        "Les enquêtes criminelles visent à élucider des affaires pénales en rassemblant des preuves.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la principale mission du ministère de l'Intérieur ?",
    options: [
      "Gérer les affaires étrangères",
      "Assurer la sécurité intérieure",
      "Réguler l'économie",
    ],
    answer: "Assurer la sécurité intérieure",
    explanation:
        "Le ministère de l'Intérieur est chargé de maintenir l'ordre public et la sécurité en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la fonction de l'unité de recherche des disparus ?",
    options: [
      "Réaliser des enquêtes sur les crimes",
      "Trouver des personnes disparues",
      "Surveiller les criminels",
    ],
    answer: "Trouver des personnes disparues",
    explanation:
        "L'unité de recherche des disparus se spécialise dans la localisation des personnes portées disparues.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'acronyme du Service de Police de la Sécurité Routière ?",
    options: ["SPSR", "SRR", "PSR"],
    answer: "SPSR",
    explanation:
        "Le Service de Police de la Sécurité Routière (SPSR) s'occupe de la sécurité routière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type de délit concerne les infractions sur internet ?",
    options: [
      "Cybercriminalité",
      "Délits informatiques",
      "Fraudes électroniques",
    ],
    answer: "Cybercriminalité",
    explanation:
        "La cybercriminalité englobe toutes les infractions commises via internet.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but de la prévention de la délinquance ?",
    options: [
      "Informaiton du public",
      "Réduction de la criminalité",
      "Augmentation du nombre de policiers",
    ],
    answer: "Réduction de la criminalité",
    explanation:
        "La prévention de la délinquance vise à diminuer les actes criminels dans la société.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est l'unité spécialisée dans le traitement des violences sexuelles ?",
    options: [
      "La brigade des mineurs",
      "La brigade de protection des mineurs",
      "La police criminelle",
    ],
    answer: "La brigade de protection des mineurs",
    explanation:
        "Cette brigade est formée pour traiter des cas de violences sexuelles sur mineurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce qui peut entraîner une mise en garde à vue ?",
    options: [
      "Une simple interpellation",
      "Un délit flagrant",
      "Un trouble à l'ordre public",
    ],
    answer: "Un délit flagrant",
    explanation:
        "La mise en garde à vue est souvent justifiée par un délit commis sur le moment.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif du contrôle judiciaire ?",
    options: [
      "Surveiller les victimes",
      "Prévenir la fuite des suspects",
      "Assurer la sécurité des agents",
    ],
    answer: "Prévenir la fuite des suspects",
    explanation:
        "Le contrôle judiciaire vise à éviter que les suspects ne fuient la justice.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'objectif principal de la police nationale en France ?",
    options: [
      "Prévenir la criminalité",
      "Promouvoir la culture",
      "Assurer le trafic routier",
    ],
    answer: "Prévenir la criminalité",
    explanation:
        "La police nationale a pour mission principale de maintenir l'ordre public et de prévenir la criminalité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le grade le plus élevé dans la hiérarchie de la police nationale ?",
    options: ["Commissaire", "Inspecteur", "Gendarme"],
    answer: "Commissaire",
    explanation:
        "Le commissaire est le plus haut grade de la police nationale française.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle principal des Brigades Anti-Criminalité (BAC) ?",
    options: [
      "Lutte contre le terrorisme",
      "Intervention rapide",
      "Surveillance des frontières",
    ],
    answer: "Intervention rapide",
    explanation:
        "Les BAC sont spécialisées dans l'intervention rapide sur des situations de délinquance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le sigle de la police en France ?",
    options: ["GIGN", "PN", "DGPN"],
    answer: "DGPN",
    explanation:
        "La Direction Générale de la Police Nationale (DGPN) supervise les activités de la police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type de crimes traite principalement la police judiciaire ?",
    options: [
      "Crimes environnementaux",
      "Crimes économiques",
      "Crimes de sang",
    ],
    answer: "Crimes de sang",
    explanation:
        "La police judiciaire est principalement chargée d'enquêter sur les crimes de sang et les délits graves.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but de la vidéo surveillance dans les villes ?",
    options: [
      "Collecter des données",
      "Prévenir les délits",
      "Réduire le trafic",
    ],
    answer: "Prévenir les délits",
    explanation:
        "La vidéo surveillance est utilisée pour dissuader et prévenir les actes délictueux dans les espaces publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du service spécialisé dans les enquêtes sur les stupéfiants ?",
    options: ["BAC", "GAJ", "OFAST"],
    answer: "OFAST",
    explanation:
        "L'Office Anti-Stupéfiants (OFAST) est chargé des enquêtes sur les drogues et stupéfiants.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui peut donner l'ordre d'une perquisition en France ?",
    options: ["Le juge d'instruction", "Le procureur", "Le préfet"],
    answer: "Le juge d'instruction",
    explanation:
        "Seul un juge d'instruction peut ordonner une perquisition dans le cadre d'une enquête judiciaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le code de la route qui régit la circulation en France ?",
    options: ["Code pénal", "Code de la route", "Code civil"],
    answer: "Code de la route",
    explanation:
        "Le Code de la route comprend les règles de circulation routière en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'effectif approximatif de la police nationale en France ?",
    options: ["150,000 agents", "290,000 agents", "80,000 agents"],
    answer: "150,000 agents",
    explanation:
        "Environ 150,000 agents composent la police nationale française.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel service est chargé de la protection des personnalités en France ?",
    options: ["DCPAF", "CSP", "GPIS"],
    answer: "DCPAF",
    explanation:
        "La Direction Centrale de la Police Aux Frontières (DCPAF) est responsable de cette mission de protection.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des enquêteurs de police ?",
    options: [
      "Surveiller les prisons",
      "Enquêter sur les crimes",
      "Former les nouveaux agents",
    ],
    answer: "Enquêter sur les crimes",
    explanation:
        "Les enquêteurs de police sont chargés de mener les enquêtes sur les infractions pénales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel véhicule est emblématique de la police nationale française ?",
    options: ["Peugeot 207", "Renault Scénic", "Citroën C4"],
    answer: "Peugeot 207",
    explanation:
        "La Peugeot 207 est un modèle de voiture fréquemment utilisé par la police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal devoir des policiers en matière de droit ?",
    options: ["Appliquer la loi", "Écrire des lois", "Interpréter la loi"],
    answer: "Appliquer la loi",
    explanation:
        "Le devoir principal des policiers est d'appliquer la législation en vigueur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l'unité d'élite intervenant en cas de prise d'otage ?",
    options: ["GIGN", "RAID", "BAC"],
    answer: "GIGN",
    explanation:
        "Le GIGN (Groupe d'Intervention de la Gendarmerie Nationale) est spécialisé dans les interventions à risques, comme les prises d'otages.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type de contravention est le plus fréquent en France ?",
    options: ["Stationnement", "Vitesse", "Alcoolémie"],
    answer: "Stationnement",
    explanation:
        "Les contraventions liées au stationnement sont les plus communes en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui supervise les activités de la police nationale en France ?",
    options: [
      "Le ministre de l'Intérieur",
      "Le président de la République",
      "Le maire",
    ],
    answer: "Le ministre de l'Intérieur",
    explanation:
        "Le ministre de l'Intérieur est responsable de la sécurité intérieure, y compris la police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le but des contrôles routiers effectués par la police ?",
    options: [
      "Vérifier les assurances",
      "Vérifier les identités",
      "Prévenir les accidents",
    ],
    answer: "Prévenir les accidents",
    explanation:
        "Les contrôles routiers visent à assurer la sécurité et à prévenir les accidents de la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce que la gendarmerie nationale ?",
    options: ["Une force militaire", "Un service civil", "Une police urbaine"],
    answer: "Une force militaire",
    explanation:
        "La gendarmerie nationale est une force militaire à statut particulier, en charge de la sécurité publique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel corps de police est engagé dans des missions de sécurité publique ?",
    options: ["Police nationale", "Gendarmerie", "Douanes"],
    answer: "Police nationale",
    explanation:
        "La police nationale est principalement dédiée aux missions de sécurité sur le territoire français.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l'examen pour rejoindre la police nationale en France ?",
    options: [
      "Concours de police",
      "Examen d'agent de police",
      "Sélection nationale",
    ],
    answer: "Concours de police",
    explanation:
        "Le concours de police est l'épreuve à passer pour intégrer la police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quels sont les critères de recrutement pour devenir policier ?",
    options: [
      "Âge et nationalité",
      "Diplôme et expérience",
      "Condition physique et moralité",
    ],
    answer: "Condition physique et moralité",
    explanation:
        "Les candidats doivent satisfaire à des critères de condition physique et de moralité pour intégrer la police.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but de la formation des policiers ?",
    options: [
      "Acquérir des compétences",
      "Rester à jour",
      "Obtenir des diplômes",
    ],
    answer: "Acquérir des compétences",
    explanation:
        "La formation vise à doter les policiers des compétences nécessaires pour leur métier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de la police aux frontières ?",
    options: [
      "Surveiller les prisons",
      "Contrôler les entrées et sorties",
      "Rédiger des rapports",
    ],
    answer: "Contrôler les entrées et sorties",
    explanation:
        "La police aux frontières a pour mission de contrôler les mouvements aux frontières nationales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type d'enquête mène la police scientifique ?",
    options: [
      "Enquête judiciaire",
      "Enquête sur les mœurs",
      "Enquête administrative",
    ],
    answer: "Enquête judiciaire",
    explanation:
        "La police scientifique est chargée de mener des enquêtes judiciaires basées sur des preuves matérielles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'acronyme utilisé pour désigner la police nationale en France ?",
    options: ["PN", "GN", "CSP"],
    answer: "PN",
    explanation:
        "L'acronyme PN désigne directement la police nationale française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la durée de la formation initiale des policiers ?",
    options: ["12 mois", "24 mois", "36 mois"],
    answer: "24 mois",
    explanation:
        "La formation initiale des policiers dure généralement 24 mois dans une école de police.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type d'armes utilise généralement la police nationale ?",
    options: ["Armes blanches", "Armes à feu", "Armes chimiques"],
    answer: "Armes à feu",
    explanation:
        "La police nationale est équipée d'armes à feu pour assurer sa mission de sécurité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le service de la police responsable de la lutte contre les violences faites aux femmes ?",
    options: ["DCPJ", "DGSN", "DGPN"],
    answer: "DCPJ",
    explanation:
        "La Direction Centrale de la Police Judiciaire (DCPJ) s'occupe des enquêtes sur les violences faites aux femmes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal moyen de communication des policiers en intervention ?",
    options: ["Radio", "Téléphone", "SMS"],
    answer: "Radio",
    explanation:
        "La radio est le principal outil de communication utilisé par les policiers en situation d'intervention.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif des patrouilles de police ?",
    options: [
      "Émettre des amendes",
      "Dissuader la criminalité",
      "Former les agents",
    ],
    answer: "Dissuader la criminalité",
    explanation:
        "Les patrouilles de police visent à dissuader la criminalité par leur présence visible.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des services de renseignement de la police ?",
    options: [
      "Surveiller les citoyens",
      "Collecter des informations",
      "Contrôler les frontières",
    ],
    answer: "Collecter des informations",
    explanation:
        "Les services de renseignement collectent des informations pour prévenir les menaces à la sécurité publique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal document retenu lors d'un contrôle d'identité ?",
    options: ["Carte d'identité", "Permis de conduire", "Passeport"],
    answer: "Carte d'identité",
    explanation:
        "La carte d'identité est le principal document demandé lors d'un contrôle d'identité par la police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce que l'OPJ ?",
    options: [
      "Officier de police judiciaire",
      "Organisme de police judiciaire",
      "Opérateur de police judiciaire",
    ],
    answer: "Officier de police judiciaire",
    explanation:
        "L'OPJ est un policier habilité à mener des enquêtes judiciaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal procès-verbal rédigé par la police ?",
    options: ["PV d'intervention", "PV d'infraction", "PV d'audition"],
    answer: "PV d'infraction",
    explanation:
        "Le procès-verbal d'infraction est le document principal pour consigner les infractions constatées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un agent de police municipal ?",
    options: [
      "Surveiller les écoles",
      "Intervenir dans les affaires criminelles",
      "Gérer le trafic",
    ],
    answer: "Gérer le trafic",
    explanation:
        "Les agents de police municipale gèrent souvent la circulation et le trafic dans les villes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la nature des interventions du RAID ?",
    options: [
      "Interventions antidrogue",
      "Interventions d'urgence",
      "Interventions de contrôle",
    ],
    answer: "Interventions d'urgence",
    explanation:
        "Le RAID intervient principalement lors des situations d'urgence, comme les prises d'otage.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Comment s'appelle le code qui régit les procédures pénales en France ?",
    options: ["Code civil", "Code de procédure pénale", "Code pénal"],
    answer: "Code de procédure pénale",
    explanation:
        "Le Code de procédure pénale définit les règles relatives aux enquêtes et aux poursuites pénales en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la couleur des voitures de police en France ?",
    options: ["Rouge", "Bleue", "Vert"],
    answer: "Bleue",
    explanation:
        "Les voitures de police en France sont généralement de couleur bleue, souvent avec des marquages lumineux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal objectif de la police des frontières ?",
    options: [
      "Surveiller les clandestins",
      "Contrôler les passeports",
      "Lutter contre le trafic de drogues",
    ],
    answer: "Contrôler les passeports",
    explanation:
        "La police des frontières est responsable de la vérification des documents d'identité aux frontières.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de l'adjoint de sécurité ?",
    options: [
      "Encadrer les policiers",
      "Effectuer des missions d'assistance",
      "Remplacer les officiers",
    ],
    answer: "Effectuer des missions d'assistance",
    explanation:
        "L'adjoint de sécurité aide les policiers dans leurs missions sans avoir le même statut.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Que signifie le terme 'interpellation' en matière policière ?",
    options: [
      "Récupérer un objet volé",
      "Arrêter une personne",
      "Émettre une amende",
    ],
    answer: "Arrêter une personne",
    explanation:
        "L'interpellation désigne le fait pour la police d'arrêter une personne suspectée d'une infraction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le nom du syndicat national des policiers ?",
    options: ["SNP", "SNES", "UNSA Police"],
    answer: "UNSA Police",
    explanation:
        "L'UNSA Police est un des principaux syndicats représentant les policiers en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle des forces de l'ordre lors des manifestations ?",
    options: [
      "Encadrer les manifestants",
      "Dissuader les violences",
      "Rédiger des rapports",
    ],
    answer: "Dissuader les violences",
    explanation:
        "Les forces de l'ordre ont pour rôle de maintenir l'ordre et de prévenir les débordements lors des manifestations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle principal de la police municipale ?",
    options: [
      "Surveillance de la ville",
      "Lutte contre le terrorisme",
      "Enquêtes criminelles",
    ],
    answer: "Surveillance de la ville",
    explanation:
        "La police municipale est chargée de la surveillance et du maintien de la sécurité dans les collectivités locales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel degré de force peut utiliser un policier lors d'une intervention ?",
    options: ["Force létale", "Force nécessaire", "Force raisonnable"],
    answer: "Force raisonnable",
    explanation:
        "Les policiers doivent utiliser une force raisonnable proportionnelle à la menace rencontrée lors d'une intervention.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel document peut un policier demander lors d'un contrôle routier ?",
    options: [
      "Certificat d'immatriculation",
      "Facture d'achat",
      "Contrat d'assurance",
    ],
    answer: "Certificat d'immatriculation",
    explanation:
        "Le certificat d'immatriculation doit être présenté lors d'un contrôle routier par le conducteur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'âge minimum requis pour devenir policier en France ?",
    options: ["18 ans", "21 ans", "25 ans"],
    answer: "18 ans",
    explanation:
        "L'âge minimum pour postuler à la police nationale est de 18 ans en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel métier peut exercer un ancien policier à la retraite ?",
    options: ["Agent de sécurité", "Professeur d'arts martiaux", "Journaliste"],
    answer: "Agent de sécurité",
    explanation:
        "Un ancien policier peut exercer comme agent de sécurité après sa carrière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type d'infractions traite principalement la CRS ?",
    options: [
      "Infractions routières",
      "Infractions de la paix publique",
      "Infractions économiques",
    ],
    answer: "Infractions de la paix publique",
    explanation:
        "Les Compagnies Républicaines de Sécurité (CRS) traitent majoritairement des infractions à la paix publique.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal objectif de la police nationale en France ?",
    options: [
      "Assurer la sécurité des citoyens",
      "Collecter des impôts",
      "Surveiller les écoles",
    ],
    answer: "Assurer la sécurité des citoyens",
    explanation:
        "La police nationale a pour mission prioritaire de garantir la sécurité publique et de protéger les citoyens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la durée minimale d'une formation pour devenir policier ?",
    options: ["6 mois", "12 mois", "24 mois"],
    answer: "12 mois",
    explanation:
        "La formation initiale des policiers dure généralement 12 mois au sein d'une école de police.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel code régit le fonctionnement de la police française ?",
    options: [
      "Code de la route",
      "Code pénal",
      "Code de la sécurité intérieure",
    ],
    answer: "Code de la sécurité intérieure",
    explanation:
        "Le Code de la sécurité intérieure encadre les missions et les compétences des forces de sécurité en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle principal de la police judiciaire ?",
    options: [
      "Prévenir les manifestations",
      "Enquêter sur les crimes",
      "Gérer le trafic routier",
    ],
    answer: "Enquêter sur les crimes",
    explanation:
        "La police judiciaire est principalement chargée d'enquêter sur les infractions pénales et de rassembler des preuves.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'acronyme de l'unité de police chargée des interventions de maintien de l'ordre en France ?",
    options: ["RAID", "GIGN", "BAC"],
    answer: "GIGN",
    explanation:
        "Le GIGN est le Groupe d'Intervention de la Gendarmerie Nationale, spécialisé dans les interventions à risque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal moyen de communication utilisé par les policiers sur le terrain ?",
    options: ["Téléphone fixe", "Radio", "SMS"],
    answer: "Radio",
    explanation:
        "Les policiers utilisent des radios pour communiquer efficacement et en temps réel lors de leurs interventions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle des brigades de prévention de la délinquance juvénile ?",
    options: [
      "Intervenir après des crimes",
      "Surveiller les écoles",
      "Prévenir la délinquance chez les jeunes",
    ],
    answer: "Prévenir la délinquance chez les jeunes",
    explanation:
        "Ces brigades œuvrent principalement à la prévention de la délinquance auprès des jeunes populations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est l'un des principes fondamentaux de la police républicaine ?",
    options: ["La dissuasion", "L'impartialité", "La répression"],
    answer: "L'impartialité",
    explanation:
        "L'impartialité est essentielle pour maintenir la confiance du public envers les forces de l'ordre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel document officiel doit obligatoirement être présenté lors d'un contrôle d'identité ?",
    options: ["Carte bancaire", "Carte d'identité", "Attestation d'assurance"],
    answer: "Carte d'identité",
    explanation:
        "La carte d'identité est le document requis pour prouver son identité lors d'un contrôle par la police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l’objectif de la lutte anti-drogue menée par la police ?",
    options: [
      "Réduire les accidents",
      "Répondre aux plaintes",
      "Lutter contre le trafic de stupéfiants",
    ],
    answer: "Lutter contre le trafic de stupéfiants",
    explanation:
        "La lutte anti-drogue vise à contrer la production et la distribution illégale de drogues.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de la célèbre unité de police chargée des opérations de lutte contre le terrorisme ?",
    options: ["RAID", "GSP", "BAC"],
    answer: "RAID",
    explanation:
        "Le RAID est spécialisé dans les interventions de lutte contre le terrorisme et les prises d'otages.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Comment appelle-t-on le document par lequel la police peut procéder à une arrestation ?",
    options: ["Ordonnance", "Mandat", "Citation"],
    answer: "Mandat",
    explanation:
        "Un mandat permet à la police de procéder légalement à une arrestation d'un individu.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la mission des équipes cynophiles au sein de la police ?",
    options: [
      "Surveiller les prisons",
      "Détecter des explosifs",
      "Former des agents",
    ],
    answer: "Détecter des explosifs",
    explanation:
        "Les équipes cynophiles utilisent des chiens pour détecter des explosifs et d'autres substances illicites.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'objectif principal des patrouilles de police en ville ?",
    options: [
      "Disperser les foules",
      "Répondre aux appels d'urgence",
      "Prévenir la criminalité",
    ],
    answer: "Prévenir la criminalité",
    explanation:
        "Les patrouilles visent à dissuader et prévenir la criminalité dans les zones urbaines.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce que la déontologie policière ?",
    options: [
      "Le droit de porter une arme",
      "Les règles de conduite des policiers",
      "Les lois sur le trafic",
    ],
    answer: "Les règles de conduite des policiers",
    explanation:
        "La déontologie policière définit les règles et l'éthique à respecter dans l'exercice des fonctions policières.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est l'un des principaux types de délits que la police traite ?",
    options: ["Vol", "Économie", "Arts"],
    answer: "Vol",
    explanation:
        "Le vol est un délit courant que la police nationale traite régulièrement dans le cadre de ses missions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le nom du document qui formalise une plainte ?",
    options: ["Procès-verbal", "Rapport", "Formulaire"],
    answer: "Procès-verbal",
    explanation:
        "Le procès-verbal est le document officiel qui enregistre les plaintes et les incidents signalés à la police.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de la police des frontières ?",
    options: [
      "Dissuader les manifestants",
      "Contrôler l'immigration",
      "Surveiller les prisons",
    ],
    answer: "Contrôler l'immigration",
    explanation:
        "La police des frontières est chargée de contrôler les personnes aux frontières et de gérer l'immigration.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du processus par lequel un suspect peut être interrogé ?",
    options: ["Mise en examen", "Garde à vue", "Contrôle judiciaire"],
    answer: "Garde à vue",
    explanation:
        "La garde à vue est le processus légal par lequel un suspect peut être retenu et interrogé par la police.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des enquêtes criminelles ?",
    options: [
      "Collecter des amendes",
      "Chasser des fugitifs",
      "Résoudre des affaires criminelles",
    ],
    answer: "Résoudre des affaires criminelles",
    explanation:
        "Les enquêtes criminelles visent à recueillir des preuves et à résoudre des affaires liées à des crimes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la première étape lors de l’arrivée sur les lieux d’un crime ?",
    options: [
      "Protéger la scène",
      "Interroger des témoins",
      "Prendre des photos",
    ],
    answer: "Protéger la scène",
    explanation:
        "Protéger la scène de crime est essentiel pour préserver les preuves avant leur analyse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel véhicule est généralement utilisé par la police pour des interventions rapides ?",
    options: ["Véhicule léger", "Moto", "Fourgon"],
    answer: "Moto",
    explanation:
        "Les motos permettent à la police d'intervenir rapidement en milieu urbain grâce à leur maniabilité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'organe qui contrôle les activités de la police nationale en France ?",
    options: ["Le Parlement", "Le CNAPS", "Le Gouvernement"],
    answer: "Le CNAPS",
    explanation:
        "Le CNAPS (Conseil national des activités privées de sécurité) veille à la régulation des activités de sécurité, y compris la police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "En cas d'arrestation, quel est le droit fondamental d'un suspect ?",
    options: ["Droit à l'avocat", "Droit à la propriété", "Droit à l'asile"],
    answer: "Droit à l'avocat",
    explanation:
        "Tout suspect a le droit d'être assisté par un avocat lors de son interrogatoire par la police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est un des risques majeurs auxquels font face les policiers sur le terrain ?",
    options: ["Fatigue", "Conflits", "Violence"],
    answer: "Violence",
    explanation:
        "Les policiers sont souvent exposés à des situations potentiellement violentes lors de leurs interventions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type de formation continue est proposée aux policiers ?",
    options: [
      "Formation sportive",
      "Formation à la communication",
      "Formation à l’enquête criminelle",
    ],
    answer: "Formation à l’enquête criminelle",
    explanation:
        "La formation continue est essentielle pour mettre à jour les compétences des policiers, notamment en matière d'enquête criminelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'impact des réseaux sociaux sur le travail de la police ?",
    options: [
      "Aucun impact",
      "Augmentation des plaintes",
      "Accélération des interventions",
    ],
    answer: "Accélération des interventions",
    explanation:
        "Les réseaux sociaux permettent à la police de recevoir rapidement des informations et de réagir plus efficacement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est l'un des critères d'une intervention policière en cas de manifestants ?",
    options: [
      "La couleur des drapeaux",
      "Le nombre de manifestants",
      "Le type de manifestation",
    ],
    answer: "Le type de manifestation",
    explanation:
        "Le type de manifestation guide la police dans sa manière d'intervenir pour garantir la sécurité de tous.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif d'un contrôle de police ?",
    options: [
      "Vérifier l'état d'un véhicule",
      "Dissuader le vol",
      "Contrôler l'identité",
    ],
    answer: "Contrôler l'identité",
    explanation:
        "Le contrôle de police vise principalement à vérifier l'identité des personnes et leur situation légale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est l'une des missions de la police nationale en matière de sécurité routière ?",
    options: [
      "Vérifier les couvertures d'assurance",
      "Organiser des courses automobiles",
      "Surveiller les piétons",
    ],
    answer: "Vérifier les couvertures d'assurance",
    explanation:
        "La police nationale veille à la sécurité routière en s'assurant que les conducteurs sont en règle, notamment concernant l'assurance.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Comment s'appelle le document utilisé pour consigner une infraction constatée par la police ?",
    options: ["Déclaration", "Procès-verbal", "Signalement"],
    answer: "Procès-verbal",
    explanation:
        "Le procès-verbal est le document officiel qui consigne les infractions constatées par les agents de police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel terme désigne l'ensemble des forces de police en France ?",
    options: ["Sécurité publique", "Forces de l’ordre", "Protection civile"],
    answer: "Forces de l’ordre",
    explanation:
        "Les forces de l'ordre regroupent l'ensemble des unités de police et de gendarmerie en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la mission des équipes d'intervention spécialisées, comme le GIGN ?",
    options: [
      "Assurer la sécurité des écoles",
      "Intervenir lors d'événements publics",
      "Gérer des situations de crise ou de danger imminent",
    ],
    answer: "Gérer des situations de crise ou de danger imminent",
    explanation:
        "Les équipes comme le GIGN sont formées pour intervenir en cas de crises graves telles que les prises d'otages.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel acteur est souvent impliqué dans le processus judiciaire après une arrestation par la police ?",
    options: ["Le procureur", "Le maire", "Le médecin"],
    answer: "Le procureur",
    explanation:
        "Le procureur est impliqué dans le processus judiciaire et prend des décisions sur les poursuites à engager après une arrestation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel élément est essentiel pour une enquête policière efficace ?",
    options: ["La vitesse", "L'expérience", "La collaboration avec le public"],
    answer: "La collaboration avec le public",
    explanation:
        "La collaboration avec le public est cruciale pour obtenir des informations et résoudre des affaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la principale fonction des centres d'appel d'urgence pour la police ?",
    options: [
      "Assurer la logistique",
      "Répondre aux appels de détresse",
      "Former des agents",
    ],
    answer: "Répondre aux appels de détresse",
    explanation:
        "Les centres d'appel d'urgence sont destinés à recevoir et à traiter les appels de détresse du public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type de surveillance utilise la police pour prévenir les actes criminels dans certains quartiers ?",
    options: [
      "Surveillance vidéo",
      "Surveillance aérienne",
      "Surveillance par drones",
    ],
    answer: "Surveillance vidéo",
    explanation:
        "La surveillance vidéo est utilisée pour monitorer des lieux publics afin de prévenir le crime.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle des services de renseignement au sein de la police ?",
    options: [
      "Former des agents",
      "Recueillir des informations",
      "Patrouiller dans les rues",
    ],
    answer: "Recueillir des informations",
    explanation:
        "Les services de renseignement se concentrent sur la collecte d'informations pour prévenir la criminalité et le terrorisme.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal type de criminalité que la police traite lors des grands événements comme les concerts ?",
    options: ["Délits de droit d'auteur", "Vols", "Violences sexuelles"],
    answer: "Vols",
    explanation:
        "Les vols sont une préoccupation majeure lors de grands événements où la foule peut créer des opportunités pour les voleurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel rôle joue la médecine légale dans les enquêtes policières ?",
    options: [
      "Analyser les accidents de voiture",
      "Examiner les preuves physiques",
      "Former des policiers",
    ],
    answer: "Examiner les preuves physiques",
    explanation:
        "La médecine légale analyse les preuves physiques pour aider à résoudre des affaires criminelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le but d'une patrouille de police dans un quartier sensible ?",
    options: [
      "Faire des blagues",
      "Effrayer les habitants",
      "Rétablir un sentiment de sécurité",
    ],
    answer: "Rétablir un sentiment de sécurité",
    explanation:
        "Les patrouilles dans des quartiers sensibles visent à rassurer les habitants et à dissuader la criminalité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel document peut être délivré par la police après un contrôle ?",
    options: [
      "Ceinture de sécurité",
      "Certificat de non-contravention",
      "Contravention",
    ],
    answer: "Contravention",
    explanation:
        "La contravention est un document émis par la police lors d'une infraction au code de la route ou à la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'un des principaux défis rencontrés par les policiers lors d'interventions ?",
    options: [
      "Accord des autorités",
      "Gestion de la foule",
      "Préparation des équipements",
    ],
    answer: "Gestion de la foule",
    explanation:
        "La gestion de la foule est un défi majeur pour les policiers lors d'interventions en raison des comportements imprévisibles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du service qui s'occupe des violences intrafamiliales en France ?",
    options: ["DVI", "UPJ", "UDD"],
    answer: "DVI",
    explanation:
        "DVI signifie 'délégation de violences intrafamiliales', un service spécifique de la police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'impact de la vidéo surveillance sur la criminalité ?",
    options: [
      "Augmente la criminalité",
      "Dissuade les criminels",
      "N'a pas d'impact",
    ],
    answer: "Dissuade les criminels",
    explanation:
        "La vidéo surveillance est connue pour dissuader de nombreux criminels en raison du risque d'être filmé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle de la police dans la sécurité de l'espace public ?",
    options: [
      "Organiser des événements",
      "Surveiller les magasins",
      "Assurer la sécurité des lieux publics",
    ],
    answer: "Assurer la sécurité des lieux publics",
    explanation:
        "La police veille à la sécurité de tous dans les espaces publics pour prévenir toute forme de délinquance.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type de communication est souvent utilisé par les policiers pour signaler un incident ?",
    options: ["Parole", "Code radio", "SMS"],
    answer: "Code radio",
    explanation:
        "Le code radio est un moyen de communication rapide et efficace utilisé par la police pour signaler des incidents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle de l'Observatoire national de la délinquance et des réponses pénales ?",
    options: [
      "Mesurer la criminalité",
      "Former des agents",
      "Surveiller les écoles",
    ],
    answer: "Mesurer la criminalité",
    explanation:
        "Cette instance a pour mission principale d'analyser et de mesurer la criminalité en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la principale préoccupation de la police en matière de sécurité publique ?",
    options: [
      "Assurer l'ordre public",
      "Aider les entreprises",
      "Surveiller les médias",
    ],
    answer: "Assurer l'ordre public",
    explanation:
        "Assurer l'ordre public est au cœur des missions de la police nationale dans toutes ses interventions.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle principal de la Police nationale en France ?",
    options: [
      "Assurer la sécurité publique",
      "Émettre des lois",
      "Gérer les prisons",
    ],
    answer: "Assurer la sécurité publique",
    explanation:
        "Le rôle principal de la Police nationale est de garantir la sécurité et l'ordre public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le sigle du renseignement intérieur en France ?",
    options: ["DGSI", "DCRI", "RSE"],
    answer: "DGSI",
    explanation:
        "Le sigle DGSI signifie Direction Générale de la Sécurité Intérieure.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel document est nécessaire pour un contrôle d'identité en France ?",
    options: ["Passeport", "Permis de conduire", "Carte d'identité"],
    answer: "Carte d'identité",
    explanation:
        "La carte d'identité est le document le plus couramment demandé lors d'un contrôle d'identité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Laquelle des missions suivantes est une prérogative de la Police nationale ?",
    options: [
      "Rédiger des lois",
      "Assurer le secours d'urgence",
      "Effectuer des enquêtes criminelles",
    ],
    answer: "Effectuer des enquêtes criminelles",
    explanation:
        "La Police nationale a pour mission d'enquêter sur les crimes et délits.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l'unité spéciale de la Police nationale française formée pour faire face aux situations de crise ?",
    options: ["RAID", "BRI", "GIGN"],
    answer: "RAID",
    explanation:
        "Le RAID (Recherche, Assistance, Intervention, Dissuasion) est une unité d'élite de la Police nationale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le symbole de la Police nationale en France ?",
    options: ["Une étoile", "Un aigle", "Une balance"],
    answer: "Une étoile",
    explanation:
        "Le symbole de la Police nationale est une étoile à cinq branches.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce qu'un PV en matière de police ?",
    options: ["Procès-verbal", "Protocole verbal", "Preuve verbale"],
    answer: "Procès-verbal",
    explanation:
        "Un PV est un document officiel établi par les forces de l'ordre pour consignation d'un fait.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le pouvoir de décision d'un policier lors d'un contrôle ?",
    options: [
      "Avertir la justice",
      "Rédiger des amendes",
      "Arrêter une personne",
    ],
    answer: "Arrêter une personne",
    explanation:
        "Un policier a le pouvoir d'arrêter une personne en cas de flagrant délit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la durée maximale de garde à vue en France pour un délit ?",
    options: ["24 heures", "48 heures", "72 heures"],
    answer: "48 heures",
    explanation:
        "La durée maximale de garde à vue pour un délit est de 48 heures, sous certaines conditions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la couleur des uniformes de la Police nationale en France ?",
    options: ["Noir", "Bleu", "Vert"],
    answer: "Bleu",
    explanation:
        "Les uniformes de la Police nationale sont principalement de couleur bleue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle du procureur dans le système judiciaire français ?",
    options: [
      "Assister au procès",
      "Diriger les enquêtes",
      "Exécuter les sentences",
    ],
    answer: "Diriger les enquêtes",
    explanation:
        "Le procureur dirige et supervise les enquêtes menées par la Police.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif principal des patrouilles de police ?",
    options: [
      "Dissuader les délits",
      "Collecter des preuves",
      "Rédiger des rapports",
    ],
    answer: "Dissuader les délits",
    explanation:
        "Les patrouilles de police visent à dissuader la criminalité par leur présence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la principale force de la police judiciaire en France ?",
    options: [
      "Les brigades de voie publique",
      "Les enquêtes criminelles",
      "Les unités spécialisées",
    ],
    answer: "Les enquêtes criminelles",
    explanation:
        "La police judiciaire se concentre principalement sur les enquêtes concernant des crimes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le nom donné à la procédure de flagrant délit ?",
    options: [
      "Intervention immédiate",
      "Arrestation rapide",
      "Constatation immédiate",
    ],
    answer: "Constatation immédiate",
    explanation:
        "La constatation immédiate est la procédure utilisée lors d'un flagrant délit.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui peut effectuer une perquisition en France ?",
    options: ["Le maire", "Un juge d'instruction", "Le président"],
    answer: "Un juge d'instruction",
    explanation:
        "Seul un juge d'instruction peut ordonner une perquisition dans le cadre d'une enquête.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la compétence principale des gardiens de la paix ?",
    options: [
      "Gérer le trafic",
      "Surveiller les lieux publics",
      "Rédiger des lois",
    ],
    answer: "Surveiller les lieux publics",
    explanation:
        "Les gardiens de la paix ont pour mission de surveiller et de maintenir l'ordre public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la différence entre la Police nationale et la Gendarmerie ?",
    options: [
      "La Police nationale opère en milieu urbain",
      "La Gendarmerie est militaire",
      "Les deux sont identiques",
    ],
    answer: "La Police nationale opère en milieu urbain",
    explanation:
        "La Police nationale est principalement chargée des zones urbaines, tandis que la Gendarmerie intervient dans les zones rurales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'organe décisionnel de la Police nationale ?",
    options: [
      "Le ministère de la Justice",
      "Le ministère de l'Intérieur",
      "Le conseil municipal",
    ],
    answer: "Le ministère de l'Intérieur",
    explanation:
        "Le ministère de l'Intérieur supervise et dirige la Police nationale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce qu'une opération de maintien de l'ordre ?",
    options: [
      "Une intervention policière",
      "Une enquête criminelle",
      "Une formation des agents",
    ],
    answer: "Une intervention policière",
    explanation:
        "Une opération de maintien de l'ordre consiste à contrôler une situation pour éviter des troubles à l'ordre public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des enquêteurs de la Police nationale ?",
    options: [
      "Surveiller le trafic",
      "Mener des investigations",
      "Rédiger des lois",
    ],
    answer: "Mener des investigations",
    explanation:
        "Les enquêteurs de la Police nationale mènent des investigations pour résoudre des affaires criminelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'objectif principal de la prévention de la délinquance ?",
    options: [
      "Dissuader les crimes",
      "Augmenter le personnel",
      "Améliorer les lois",
    ],
    answer: "Dissuader les crimes",
    explanation:
        "La prévention de la délinquance vise à réduire le risque de criminalité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un commissariat de police ?",
    options: [
      "Rendre des jugements",
      "Effectuer des arrests",
      "Accueillir le public",
    ],
    answer: "Accueillir le public",
    explanation:
        "Le commissariat de police est un lieu d'accueil pour les citoyens en demande d'aide ou d'informations.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'effet du mariage pour les policiers en France ?",
    options: [
      "Une promotion automatique",
      "Aucune incidence",
      "Un avantage en termes de congés",
    ],
    answer: "Aucune incidence",
    explanation:
        "Le mariage n'affecte pas directement le statut professionnel des policiers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui est le supérieur hiérarchique des policiers ?",
    options: ["Le préfet", "Le ministre de l'Intérieur", "Le maire"],
    answer: "Le ministre de l'Intérieur",
    explanation:
        "Le ministre de l'Intérieur supervise la hiérarchie de la Police nationale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type de délit est considéré comme le plus grave par la Police nationale ?",
    options: ["Vol simple", "Meurtre", "Escroquerie"],
    answer: "Meurtre",
    explanation:
        "Le meurtre est l'un des délits les plus graves et est traité avec la plus haute priorité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel organisme est responsable du contrôle des forces de l'ordre en France ?",
    options: [
      "Le Sénat",
      "La Cour des Comptes",
      "L'Inspection générale de la Police nationale",
    ],
    answer: "L'Inspection générale de la Police nationale",
    explanation:
        "L'Inspection générale de la Police nationale contrôle les activités des forces de l'ordre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des brigades anti-criminalité (BAC) ?",
    options: [
      "Lutter contre la violence",
      "Favoriser le dialogue",
      "Surveiller les frontières",
    ],
    answer: "Lutter contre la violence",
    explanation:
        "Les brigades anti-criminalité (BAC) sont spécialisées dans la lutte contre les violences urbaines.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la durée maximale d'un permis de conduire en France avant renovación ?",
    options: ["5 ans", "10 ans", "15 ans"],
    answer: "15 ans",
    explanation:
        "Le permis de conduire doit être renouvelé tous les 15 ans en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme utilisé pour désigner les actes de délinquance juvénile ?",
    options: [
      "Criminalité des mineurs",
      "Délinquance juvénile",
      "Petite criminalité",
    ],
    answer: "Délinquance juvénile",
    explanation:
        "La délinquance juvénile fait référence aux actes criminels commis par des mineurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but d'une enquête préliminaire ?",
    options: ["Punir un suspect", "Rassembler des preuves", "Établir des lois"],
    answer: "Rassembler des preuves",
    explanation:
        "L'enquête préliminaire a pour but de rassembler des éléments de preuve avant d'engager des poursuites.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le premier réflexe d'un policier face à un incident ?",
    options: [
      "Intervenir immédiatement",
      "Contacter un supérieur",
      "Évaluer la situation",
    ],
    answer: "Évaluer la situation",
    explanation:
        "Un policier doit d'abord évaluer la situation afin de prendre la meilleure décision.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de la sécurité publique ?",
    options: [
      "Organiser des événements",
      "Maintenir l'ordre public",
      "Surveiller le trafic",
    ],
    answer: "Maintenir l'ordre public",
    explanation:
        "La sécurité publique vise à maintenir l'ordre et la sécurité au sein de la communauté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le plus haut grade dans la Police nationale française ?",
    options: ["Commissaire", "Directeur général", "Géant de la paix"],
    answer: "Directeur général",
    explanation:
        "Le Directeur général de la Police nationale est le plus haut responsable de cette institution.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l’objectif principal de la police technique et scientifique ?",
    options: [
      "Rassembler des preuves",
      "Surveiller les criminels",
      "Élaborer des lois",
    ],
    answer: "Rassembler des preuves",
    explanation:
        "La police technique et scientifique vise à analyser des éléments de preuve pour résoudre des affaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type de délit est dénoncé par la Loi du 29 juillet 1881 ?",
    options: ["Vol", "Diffamation", "Meurtre"],
    answer: "Diffamation",
    explanation:
        "La Loi du 29 juillet 1881 traite spécifiquement des offenses en matière de presse et de diffamation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des agents de la sécurité publique ?",
    options: [
      "Rédiger des rapports",
      "Effectuer des enquêtes",
      "Assurer la sécurité dans les espaces publics",
    ],
    answer: "Assurer la sécurité dans les espaces publics",
    explanation:
        "Les agents de la sécurité publique garantissent la sécurité et l'ordre dans les lieux publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la plus haute instance judiciaire en France ?",
    options: ["La Cour de cassation", "Le Conseil d'État", "La Cour d'appel"],
    answer: "La Cour de cassation",
    explanation:
        "La Cour de cassation est la plus haute juridiction de l'ordre judiciaire en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Comment s'appelle la loi qui régit les interventions policières en France ?",
    options: ["Loi de 1981", "Code de la sécurité intérieure", "Loi de 2011"],
    answer: "Code de la sécurité intérieure",
    explanation:
        "Le Code de la sécurité intérieure régit les interventions et les missions de la Police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'objectif des stages de formation pour les policiers ?",
    options: [
      "Accroître leurs compétences",
      "Obliger à la discipline",
      "Réduire le nombre de policiers",
    ],
    answer: "Accroître leurs compétences",
    explanation:
        "Les stages de formation visent à améliorer les compétences et la professionnalisation des agents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui peut interdire une manifestation en France ?",
    options: ["Le maire", "Le préfet", "Le président de la République"],
    answer: "Le préfet",
    explanation:
        "Le préfet a le pouvoir d'interdire une manifestation s'il y a des risques de troubles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Dans quel domaine la Police nationale a-t-elle un rôle prépondérant ?",
    options: [
      "L'éducation",
      "La sécurité routière",
      "L'administration publique",
    ],
    answer: "La sécurité routière",
    explanation:
        "La Police nationale joue un rôle clé dans l'application des règles de sécurité routière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle principal du service d'ordre public ?",
    options: [
      "Organiser des événements",
      "Maintenir l'ordre lors des manifestations",
      "Rédiger des rapports",
    ],
    answer: "Maintenir l'ordre lors des manifestations",
    explanation:
        "Le service d'ordre public est chargé de veiller à la sécurité et à la tranquillité lors des rassemblements.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le but d'un contrôle de routine effectué par la police ?",
    options: [
      "Prévenir le crime",
      "Éduquer le public",
      "Formaliser un rapport",
    ],
    answer: "Prévenir le crime",
    explanation:
        "Les contrôles de routine visent à dissuader la criminalité par leur présence visible.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui est chargé de l'application des lois en France ?",
    options: ["La gendarmerie", "La police nationale", "Le gouvernement"],
    answer: "La police nationale",
    explanation:
        "La Police nationale est responsable de l'application des lois sur le territoire français.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type de soutien l’État apporte-t-il aux forces de l’ordre ?",
    options: ["Financier", "Moral", "Politique"],
    answer: "Financier",
    explanation:
        "L'État fournit un soutien financier pour les opérations et le fonctionnement des forces de police.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce que l'Armée de terre en France ?",
    options: [
      "Une branche de l'armée",
      "Un service de police",
      "Un service de secours",
    ],
    answer: "Une branche de l'armée",
    explanation:
        "L'Armée de terre est l'une des branches des forces armées françaises.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme utilisé pour décrire la coopération entre la police et la communauté ?",
    options: [
      "Police citoyenne",
      "Partenariat policier",
      "Sécurité communautaire",
    ],
    answer: "Sécurité communautaire",
    explanation:
        "La sécurité communautaire désigne la coopération entre la police et les citoyens pour assurer l'ordre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but des opérations de sécurité routière ?",
    options: [
      "Réduire les accidents de la route",
      "Augmenter les amendes",
      "Surveiller les conducteurs",
    ],
    answer: "Réduire les accidents de la route",
    explanation:
        "Les opérations de sécurité routière visent principalement à diminuer le nombre d'accidents.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal rôle de la police nationale française ?",
    options: [
      "Protéger les citoyens",
      "Émettre des lois",
      "Gérer les affaires judiciaires",
    ],
    answer: "Protéger les citoyens",
    explanation:
        "La police nationale a pour mission principale d'assurer la sécurité des citoyens et de maintenir l'ordre public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quels types de crimes la police nationale n'est-elle pas responsable de traiter ?",
    options: ["Crimes organisés", "Infractions routières", "Crimes militaires"],
    answer: "Crimes militaires",
    explanation:
        "La police nationale n'intervient pas dans les affaires militaires qui relèvent de la juridiction militaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'objectif principal de la Brigade de recherche et d'intervention (BRI) ?",
    options: [
      "Lutte contre le terrorisme",
      "Lutte contre le trafic de stupéfiants",
      "Lutte contre les crimes financiers",
    ],
    answer: "Lutte contre le terrorisme",
    explanation:
        "La BRI est spécialisée dans la lutte contre le terrorisme et les interventions à risque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un commissaire de police ?",
    options: [
      "Diriger un commissariat",
      "Assister des agents",
      "Effectuer des enquêtes criminelles",
    ],
    answer: "Diriger un commissariat",
    explanation:
        "Le commissaire de police est responsable de la direction et de l'organisation d'un commissariat.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la fonction des policiers de la police aux frontières (PAF) ?",
    options: [
      "Surveiller les routes",
      "Contrôler les frontières",
      "Intervenir dans les villes",
    ],
    answer: "Contrôler les frontières",
    explanation:
        "La PAF est chargée de contrôler les entrées et sorties sur le territoire national.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du document officiel récapitulant les infractions constatées par la police ?",
    options: ["Procès-verbal", "Rapport d'activité", "Alerte de sécurité"],
    answer: "Procès-verbal",
    explanation:
        "Le procès-verbal est un document légal qui consigne les faits constatés par les forces de l'ordre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le chiffre d'affaires annuel estimé du trafic de stupéfiants en France ?",
    options: [
      "2 milliards d'euros",
      "10 milliards d'euros",
      "4 milliards d'euros",
    ],
    answer: "10 milliards d'euros",
    explanation:
        "Le trafic de stupéfiants en France représente un chiffre d'affaires annuel estimé à environ 10 milliards d'euros.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle loi encadre spécifiquement l'usage des armes par la police en France ?",
    options: ["Loi de 1995", "Loi du 15 avril 2000", "Loi du 21 février 2017"],
    answer: "Loi du 21 février 2017",
    explanation:
        "Cette loi précise les conditions d'usage des armes par les forces de l'ordre en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom donné au système de vidéosurveillance en France ?",
    options: [
      "Système Vidéopolis",
      "Système Vigipirate",
      "Système Alerte Vidéo",
    ],
    answer: "Système Vigipirate",
    explanation:
        "Vigipirate est le plan de sécurité et de vigilance en France, qui inclut des dispositifs de vidéosurveillance.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel service de police s'occupe des enquêtes sur les crimes graves ?",
    options: [
      "Police judiciaire",
      "Police de proximité",
      "Police de l'air et des frontières",
    ],
    answer: "Police judiciaire",
    explanation:
        "La police judiciaire est spécialisée dans les enquêtes sur les crimes et délits graves.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la durée de formation initiale pour devenir policier en France ?",
    options: ["12 mois", "18 mois", "24 mois"],
    answer: "12 mois",
    explanation:
        "La formation initiale pour devenir policier comprend généralement 12 mois de formation théorique et pratique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal partenaire de la police nationale pour la lutte contre le crime organisé ?",
    options: ["Le GIGN", "La gendarmerie", "La douane"],
    answer: "La douane",
    explanation:
        "La douane collabore avec la police nationale pour lutter contre le trafic et le crime organisé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le nom de l'unité d'élite de la police nationale ?",
    options: ["Le RAID", "Le CRS", "Le GIGN"],
    answer: "Le RAID",
    explanation:
        "Le RAID est une unité d'élite de la police nationale spécialisée dans les interventions à haut risque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la compétence principale des agents de la police municipale ?",
    options: [
      "Trafic de drogue",
      "Sécurité publique",
      "Régulation de la circulation",
    ],
    answer: "Régulation de la circulation",
    explanation:
        "La police municipale est principalement responsable de la régulation de la circulation et de la sécurité dans les communes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal moyen de communication utilisé par les forces de police sur le terrain ?",
    options: ["Radio", "Téléphone portable", "SMS"],
    answer: "Radio",
    explanation:
        "La radio est le principal moyen de communication sécurisé utilisé par les forces de police sur le terrain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est l'une des missions de la police scientifique ?",
    options: [
      "Prendre des déclarations",
      "Analyser des preuves",
      "Émettre des contraventions",
    ],
    answer: "Analyser des preuves",
    explanation:
        "La police scientifique est chargée de l'analyse des preuves matérielles dans le cadre d'enquêtes criminelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel document est requis pour porter une arme en France ?",
    options: [
      "Permis de port d'arme",
      "Carte d'identité",
      "Certificat médical",
    ],
    answer: "Permis de port d'arme",
    explanation:
        "Le permis de port d'arme est un document légal requis pour pouvoir porter une arme en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'organe de direction de la police nationale en France ?",
    options: [
      "Le département de la police",
      "La direction générale de la police nationale",
      "Le ministère de la sécurité intérieure",
    ],
    answer: "La direction générale de la police nationale",
    explanation:
        "La direction générale de la police nationale supervise l'ensemble des opérations de la police en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "En France, quel est le rôle des agents de police en matière de sécurité publique ?",
    options: [
      "Surveiller les locaux",
      "Effectuer des patrouilles",
      "Faire des enquêtes",
    ],
    answer: "Effectuer des patrouilles",
    explanation:
        "Les agents de police assurent la sécurité publique en effectuant des patrouilles régulières dans les zones sensibles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'acronyme de l'unité spécialisée dans la lutte anti-drogue en France ?",
    options: ["SDAT", "CRS", "RAID"],
    answer: "SDAT",
    explanation:
        "La SDAT est la Section de détection et d'analyse des trafics, spécialisée dans la lutte contre le trafic de stupéfiants.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la principale différence entre la police nationale et la gendarmerie ?",
    options: [
      "La gendarmerie est militaire",
      "La police nationale est civile",
      "Les deux sont identiques",
    ],
    answer: "La gendarmerie est militaire",
    explanation:
        "La gendarmerie est une force militaire, tandis que la police nationale est une force civile.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'indice de confiance des citoyens envers la police en France ?",
    options: ["Faible", "Moyen", "Fort"],
    answer: "Moyen",
    explanation:
        "L'indice de confiance des citoyens envers la police est souvent considéré comme moyen selon diverses études sociologiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel organisme est chargé de veiller à la déontologie des policiers en France ?",
    options: ["La CNDS", "La police des polices", "Le CNIL"],
    answer: "La police des polices",
    explanation:
        "La police des polices est chargée de vérifier la légalité des actes des policiers et de garantir leurs droits.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'acronyme de l'unité de gestion de crise de la police nationale ?",
    options: ["GIGN", "CROSS", "SIRPA"],
    answer: "SIRPA",
    explanation:
        "Le SIRPA est le service d'information et de relations publiques de la police nationale, notamment en gestion de crise.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal objectif des interventions de police lors de manifestations ?",
    options: [
      "Protéger les manifestants",
      "Maintenir l'ordre",
      "Créer des barrages",
    ],
    answer: "Maintenir l'ordre",
    explanation:
        "Les interventions de police lors de manifestations visent principalement à maintenir l'ordre public et à prévenir les débordements.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l'opération de sécurité mise en place lors des événements sportifs majeurs en France ?",
    options: [
      "Opération coup de poing",
      "Opération sécurité",
      "Opération tranquillité",
    ],
    answer: "Opération tranquillité",
    explanation:
        "L'opération tranquillité est mise en place pour assurer la sécurité des événements sportifs et des rassemblements de foule.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des brigades anti-criminalité (BAC) ?",
    options: [
      "Faire des contrôles routiers",
      "Intervenir sur des crimes en cours",
      "Établir des constats",
    ],
    answer: "Intervenir sur des crimes en cours",
    explanation:
        "Les brigades anti-criminalité (BAC) sont spécialisées dans l'intervention rapide sur des situations criminelles en cours.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la principale raison d'une garde à vue ?",
    options: [
      "Contrôler une identité",
      "Prévenir un crime",
      "Rassembler des preuves",
    ],
    answer: "Rassembler des preuves",
    explanation:
        "La garde à vue est utilisée pour rassembler des preuves et interroger des suspects dans le cadre d'une enquête.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle de l'Inspection générale de la police nationale (IGPN) ?",
    options: [
      "Surveiller les actes des policiers",
      "Enquêter sur les infractions",
      "Assurer la sécurité des commissariats",
    ],
    answer: "Surveiller les actes des policiers",
    explanation:
        "L'IGPN est chargée de surveiller et d'enquêter sur les actes des policiers pour garantir la déontologie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du journal officiel qui publie les décisions administratives de la police ?",
    options: [
      "Journal officiel de la République française",
      "Bulletin municipal",
      "Gazette des communes",
    ],
    answer: "Journal officiel de la République française",
    explanation:
        "Le Journal officiel publie les textes législatifs et réglementaires, y compris ceux concernant la police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type d'infraction est le harcèlement ?",
    options: [
      "Infraction pénale",
      "Infraction civile",
      "Infraction administrative",
    ],
    answer: "Infraction pénale",
    explanation:
        "Le harcèlement est considéré comme une infraction pénale en France, punie par la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l'escadron de gendarmerie intervenant lors des situations de crise ?",
    options: [
      "GIGN",
      "Gendarmerie d'intervention",
      "Groupe d'intervention de la gendarmerie nationale",
    ],
    answer: "GIGN",
    explanation:
        "Le GIGN est un escadron d'élite de la gendarmerie spécialisé dans les interventions de crise.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la différence entre une contravention et un délit ?",
    options: [
      "Montant de l'amende",
      "Nature de l'infraction",
      "Durée de la peine",
    ],
    answer: "Nature de l'infraction",
    explanation:
        "La principale différence réside dans la gravité ; une contravention est moins grave qu'un délit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le nom du fichier sur les personnes condamnées ?",
    options: [
      "Fichier des condamnés",
      "Fichier Judicaire",
      "Fichier des antécédents judiciaires",
    ],
    answer: "Fichier des antécédents judiciaires",
    explanation:
        "Le fichier des antécédents judiciaires recense les condamnations pénales des individus en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle principal des CRS en France ?",
    options: [
      "Assurer la sécurité routière",
      "Intervenir lors de manifestations",
      "Surveiller les frontières",
    ],
    answer: "Intervenir lors de manifestations",
    explanation:
        "Les CRS sont principalement utilisés pour maintenir l'ordre lors de manifestations et d'événements publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but d'une patrouille de police en milieu urbain ?",
    options: [
      "Réduire la criminalité",
      "Faire des amendes",
      "Contrôler les véhicules",
    ],
    answer: "Réduire la criminalité",
    explanation:
        "Les patrouilles de police en milieu urbain visent à prévenir et à réduire la criminalité dans les quartiers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du service chargé de la protection des personnalités en France ?",
    options: [
      "Service de protection",
      "Sécurité publique",
      "Service de protection des personnalités",
    ],
    answer: "Service de protection",
    explanation:
        "Le service de protection est chargé d'assurer la sécurité des personnalités publiques menacées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal cadre légal régissant les fouilles par la police ?",
    options: [
      "Code de procédure pénale",
      "Code civil",
      "Code de sécurité intérieure",
    ],
    answer: "Code de procédure pénale",
    explanation:
        "Le Code de procédure pénale fixe les conditions dans lesquelles la police peut procéder à des fouilles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal outil technologique pour l'analyse de la criminalité ?",
    options: [
      "Système d'information criminelle",
      "Système de surveillance",
      "Système de prévention",
    ],
    answer: "Système d'information criminelle",
    explanation:
        "Le système d'information criminelle est utilisé pour analyser et traiter des données criminelles à des fins d'enquête.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des unités cynophiles dans la police ?",
    options: [
      "Détecter les stupéfiants",
      "Assurer la sécurité",
      "Contrôler les foules",
    ],
    answer: "Détecter les stupéfiants",
    explanation:
        "Les unités cynophiles utilisent des chiens pour détecter les stupéfiants et d'autres substances illicites.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type de délits sont généralement traités par la police des transports ?",
    options: [
      "Vol à main armée",
      "Infractions liées aux transports",
      "Infractions financières",
    ],
    answer: "Infractions liées aux transports",
    explanation:
        "La police des transports est spécialisée dans les infractions liées aux réseaux de transport, comme le ferroviaire ou l'aérien.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle principal de l'Office central de lutte contre la criminalité organisée (OCLCO) ?",
    options: [
      "Lutter contre le terrorisme",
      "Lutter contre le racisme",
      "Lutter contre la criminalité organisée",
    ],
    answer: "Lutter contre la criminalité organisée",
    explanation:
        "L'OCLCO est spécialisé dans la lutte contre le crime organisé sur le territoire français.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l'indicateur mesurant la délinquance en France ?",
    options: [
      "Indice de sécurité",
      "Statistiques criminelles",
      "Observatoire de la délinquance",
    ],
    answer: "Observatoire de la délinquance",
    explanation:
        "L'Observatoire de la délinquance fournit des données et analyses sur la délinquance en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type de crime est principalement combattu par le ministère de l'Intérieur ?",
    options: [
      "Crimes financiers",
      "Crimes environnementaux",
      "Crimes de droit commun",
    ],
    answer: "Crimes de droit commun",
    explanation:
        "Le ministère de l'Intérieur se concentre principalement sur la lutte contre les crimes de droit commun.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but d'une enquête judiciaire ?",
    options: [
      "Résoudre un crime",
      "Émettre des sanctions",
      "Informatiser les données",
    ],
    answer: "Résoudre un crime",
    explanation:
        "Le but d'une enquête judiciaire est de collecter des preuves pour résoudre un crime.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des agents de la police de la route ?",
    options: [
      "Contrôler la vitesse",
      "Surveiller les voies ferrées",
      "Faire des enquêtes criminelles",
    ],
    answer: "Contrôler la vitesse",
    explanation:
        "Les agents de la police de la route sont chargés de contrôler la vitesse et la sécurité routière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'organe de contrôle des forces de l'ordre en France ?",
    options: ["L'IGPN", "La cour des comptes", "Le ministère de la justice"],
    answer: "L'IGPN",
    explanation:
        "L'IGPN (Inspection générale de la police nationale) est chargée de contrôler les forces de l'ordre en France.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la principale mission de la Police nationale en France ?",
    options: [
      "Assurer la sécurité publique",
      "Contrôler les frontières",
      "Lutter contre le terrorisme",
    ],
    answer: "Assurer la sécurité publique",
    explanation:
        "La Police nationale a pour mission principale d'assurer la sécurité des citoyens sur le territoire français.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le corps d'élite de la Police nationale française ?",
    options: ["RAID", "DCPJ", "BAC"],
    answer: "RAID",
    explanation:
        "Le RAID est un groupe d'intervention spécialisé dans les situations de crise et les interventions à haut risque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Que signifie le terme 'FDO' utilisé en police ?",
    options: [
      "Forces de Défense Opérationnelle",
      "Forces de Dissuasion Ordinaire",
      "Forces de l'Ordre",
    ],
    answer: "Forces de l'Ordre",
    explanation:
        "FDO est un acronyme couramment utilisé pour désigner les Forces de l'Ordre en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal document officiel des policiers en France ?",
    options: [
      "Le Code de la Route",
      "Le Code pénal",
      "Le Code de la Sécurité intérieure",
    ],
    answer: "Le Code de la Sécurité intérieure",
    explanation:
        "Le Code de la Sécurité intérieure régit les missions et l'organisation des forces de sécurité en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la couleur des uniformes de la Police nationale française ?",
    options: ["Rouge", "Bleu", "Vert"],
    answer: "Bleu",
    explanation:
        "Les uniformes de la Police nationale sont principalement de couleur bleue, symbolisant l'autorité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle principal des enquêteurs de la Police judiciaire ?",
    options: [
      "Assurer la circulation routière",
      "Mener des enquêtes criminelles",
      "Préparer des rapports administratifs",
    ],
    answer: "Mener des enquêtes criminelles",
    explanation:
        "Les enquêteurs de la Police judiciaire sont chargés de résoudre des affaires criminelles complexes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le nom du ministère supervisant la Police nationale ?",
    options: [
      "Ministère de l'Intérieur",
      "Ministère de la Justice",
      "Ministère de la Défense",
    ],
    answer: "Ministère de l'Intérieur",
    explanation:
        "Le Ministère de l'Intérieur est responsable de la gestion et de l'organisation de la Police nationale en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme utilisé pour désigner un agent de police en civil ?",
    options: ["Officier de police", "Policier secret", "Policier en mission"],
    answer: "Policier secret",
    explanation:
        "Un policier en civil est souvent appelé policier secret, travaillant sans uniforme pour des missions spécifiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle unité est spécifiquement chargée des interventions en milieu urbain ?",
    options: [
      "Brigade Anti-Criminelle",
      "Brigade des Mineurs",
      "Brigade de Sécurité Urbaine",
    ],
    answer: "Brigade Anti-Criminelle",
    explanation:
        "La Brigade Anti-Criminelle se concentre sur la lutte contre la criminalité dans les zones urbaines.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'élément crucial dans une enquête criminelle ?",
    options: ["Le témoignage", "Le rapport de police", "L'analyse ADN"],
    answer: "Le témoignage",
    explanation:
        "Le témoignage des témoins joue un rôle clé dans la reconstitution des faits d'une enquête criminelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de la base de données utilisée pour les empreintes digitales en France ?",
    options: [
      "Fichier national des empreintes digitales",
      "Fichier national automatisé des empreintes génétiques",
      "Fichier des empreintes judiciaires",
    ],
    answer: "Fichier national des empreintes digitales",
    explanation:
        "Cette base de données centralise toutes les empreintes digitales des personnes identifiées par la police.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la sanction maximale pour une infraction au code de la route en France ?",
    options: [
      "Amende de 750 euros",
      "Peine d'emprisonnement de 6 mois",
      "Retrait de points",
    ],
    answer: "Amende de 750 euros",
    explanation:
        "Les infractions au code de la route peuvent entraîner des amendes allant jusqu'à 750 euros pour certaines violations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la fonction principale d'un commissaire de police ?",
    options: [
      "Diriger les opérations de police",
      "Enquêter sur des meurtres",
      "Gérer une brigade spécifique",
    ],
    answer: "Diriger les opérations de police",
    explanation:
        "Le commissaire de police est responsable de la coordination et de la direction des opérations au sein d'un commissariat.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type de crime est la contrefaçon ?",
    options: [
      "Crime contre la propriété intellectuelle",
      "Crime économique",
      "Crime de violence",
    ],
    answer: "Crime contre la propriété intellectuelle",
    explanation:
        "La contrefaçon constitue une violation des droits de propriété intellectuelle et est punie par la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'outil principal utilisé par la police pour mesurer la vitesse des véhicules ?",
    options: ["Radar", "Chronomètre", "Caméra"],
    answer: "Radar",
    explanation:
        "Les radars sont utilisés par la police pour contrôler la vitesse des véhicules sur la route de manière précise.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but d'une garde à vue ?",
    options: [
      "Vérifier l'identité d'une personne",
      "Interroger un suspect",
      "Évaluer un témoin",
    ],
    answer: "Interroger un suspect",
    explanation:
        "La garde à vue permet à la police d'interroger un suspect sur des faits le concernant.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle unité est spécialisée dans la lutte anti-terroriste ?",
    options: [
      "Brigade de Recherche et d'Intervention",
      "Brigade de Sécurité Intérieure",
      "Brigade Anti-Drogue",
    ],
    answer: "Brigade de Recherche et d'Intervention",
    explanation:
        "Cette brigade, souvent appelée RAID, est entraînée pour intervenir lors de menaces terroristes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui peut porter une arme à feu dans la Police nationale ?",
    options: [
      "Tous les policiers",
      "Les agents en service uniquement",
      "Les officiers supérieurs uniquement",
    ],
    answer: "Les agents en service uniquement",
    explanation:
        "Seuls les agents de police en service ont le droit de porter une arme à feu dans le cadre de leurs fonctions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel délit concerne l'usage de faux documents ?",
    options: ["Faux et usage de faux", "Vol", "Escroquerie"],
    answer: "Faux et usage de faux",
    explanation:
        "L'usage de faux documents est essentiellement qualifié comme un délit de faux et usage de faux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'acronyme de la Police aux Frontières ?",
    options: ["PAF", "PG", "PN"],
    answer: "PAF",
    explanation:
        "Le terme PAF désigne la Police aux Frontières, responsable de la surveillance des frontières françaises.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des CRS en France ?",
    options: [
      "Établir un service d'urgence",
      "Intervenir lors d'émeutes",
      "Patrouiller dans les quartiers sensibles",
    ],
    answer: "Intervenir lors d'émeutes",
    explanation:
        "Les Compagnies Républicaines de Sécurité (CRS) sont principalement mobilisées pour maintenir l'ordre public lors d'émeutes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le nom de la police des transports en commun à Paris ?",
    options: ["RATP", "SNCF", "TCRP"],
    answer: "RATP",
    explanation:
        "La RATP est responsable de la sécurité dans les transports en commun parisiens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'organe de contrôle interne de la Police nationale ?",
    options: ["IGPN", "CRS", "DCPJ"],
    answer: "IGPN",
    explanation:
        "L'IGPN, Inspection Générale de la Police Nationale, est chargée de veiller à la déontologie et à la discipline au sein de la police.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la première étape lors d'une enquête criminelle ?",
    options: [
      "Collecte de preuves",
      "Interrogatoires des suspects",
      "Identification de la victime",
    ],
    answer: "Collecte de preuves",
    explanation:
        "La collecte de preuves est cruciale pour établir les faits et construire un dossier solide dans une enquête criminelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif principal d'un procès criminel ?",
    options: [
      "Punir les délinquants",
      "Déterminer la culpabilité",
      "Restaurer l'ordre public",
    ],
    answer: "Déterminer la culpabilité",
    explanation:
        "Le but d'un procès criminel est de déterminer la culpabilité ou l'innocence d'un accusé devant un tribunal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est l'autorité qui délivre le permis de conduire en France ?",
    options: ["La Police nationale", "La Préfecture", "La Mairie"],
    answer: "La Préfecture",
    explanation:
        "Les préfectures sont responsables de la délivrance des permis de conduire en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme pour désigner une enquête en cours dans le cadre de la police judiciaire ?",
    options: ["Instruction", "Saisie", "Enquête préliminaire"],
    answer: "Enquête préliminaire",
    explanation:
        "Une enquête préliminaire est la première phase d'une enquête judiciaire permettant de rassembler des éléments de preuve.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui peut être entendu en tant que témoin lors d'un procès ?",
    options: [
      "Toute personne ayant connaissance des faits",
      "Uniquement les policiers",
      "Les membres de la famille de l'accusé",
    ],
    answer: "Toute personne ayant connaissance des faits",
    explanation:
        "Tout individu disposant d'informations pertinentes peut être convoqué comme témoin lors d'un procès.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'un des principaux outils d'enquête de la Police nationale ?",
    options: [
      "Le témoignage",
      "Les rapports de police",
      "L'écoute téléphonique",
    ],
    answer: "L'écoute téléphonique",
    explanation:
        "L'écoute téléphonique est souvent utilisée comme méthode d'enquête pour recueillir des preuves dans des affaires criminelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal objectif des patrouilles de police ?",
    options: [
      "Prévenir la criminalité",
      "Collecter des preuves",
      "Arrêter des suspects",
    ],
    answer: "Prévenir la criminalité",
    explanation:
        "Les patrouilles de police visent principalement à dissuader la criminalité en étant visibles sur le terrain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la nature de la responsabilité pénale d'un policier en France ?",
    options: [
      "Il est exempt de responsabilité",
      "Il peut être poursuivi comme tout citoyen",
      "Il a une responsabilité limitée",
    ],
    answer: "Il peut être poursuivi comme tout citoyen",
    explanation:
        "Les policiers, comme tout citoyen, peuvent être tenus responsables de leurs actes en cas d'infraction à la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel outil est utilisé pour la identification des personnes par les empreintes digitales ?",
    options: ["Dactyloscopie", "Photographie", "ADN"],
    answer: "Dactyloscopie",
    explanation:
        "La dactyloscopie permet d'analyser et de comparer les empreintes digitales pour identifier des individus.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la mission des Gendarmes ?",
    options: [
      "Maintenir l'ordre dans les zones rurales",
      "Traiter les affaires criminelles",
      "Surveiller les routes nationales",
    ],
    answer: "Maintenir l'ordre dans les zones rurales",
    explanation:
        "La Gendarmerie nationale est principalement chargée de la sécurité en milieu rural et périurbain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle entité s'occupe de la prévention de la délinquance chez les jeunes ?",
    options: [
      "Les services sociaux",
      "La Police nationale",
      "Les éducateurs spécialisés",
    ],
    answer: "La Police nationale",
    explanation:
        "La Police nationale intervient directement dans la prévention de la délinquance chez les jeunes par divers programmes et initiatives.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel terme désigne l'intégration de nouvelles technologies dans les enquêtes policières ?",
    options: ["Criminalistique", "Technologie judiciaire", "Enquête numérique"],
    answer: "Criminalistique",
    explanation:
        "La criminalistique englobe l'ensemble des méthodes scientifiques et techniques utilisées dans les enquêtes policières.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est l'une des principales compétences requises pour un policier ?",
    options: [
      "Capacité à rédiger des rapports",
      "Connaissance des langues étrangères",
      "Compétences en informatique",
    ],
    answer: "Capacité à rédiger des rapports",
    explanation:
        "La rédaction de rapports est essentielle pour documenter les interventions et les enquêtes policières.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'organe chargé de contrôler les activités de la Police nationale ?",
    options: ["L'IGPN", "Le Sénat", "Le ministère de la Justice"],
    answer: "L'IGPN",
    explanation:
        "L'IGPN est responsable de contrôler la déontologie au sein de la Police nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'impact principal des caméras de surveillance sur la criminalité ?",
    options: [
      "Augmenter le taux d'arrestations",
      "Dissuader les criminels",
      "Faciliter les enquêtes",
    ],
    answer: "Dissuader les criminels",
    explanation:
        "La présence de caméras de surveillance a un effet dissuasif sur les actes criminels en raison de la peur d'être filmé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de l'agent de sécurité ?",
    options: [
      "Protéger les biens et les personnes",
      "Gérer un commissariat",
      "Enquêter sur des crimes",
    ],
    answer: "Protéger les biens et les personnes",
    explanation:
        "L'agent de sécurité est principalement chargé de la protection et de la sécurité dans un lieu donné.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Comment la Police nationale appelle-t-elle les opérations de contrôle des identités ?",
    options: ["Contrôles de sécurité", "Vérifications d'identité", "OPJ"],
    answer: "Contrôles de sécurité",
    explanation:
        "Les opérations de contrôle des identités sont désignées par le terme 'contrôles de sécurité' dans le langage policier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but des patrouilles à vélo de la Police nationale ?",
    options: [
      "Accéder à des zones difficiles",
      "Maximiser la rapidité",
      "Assurer la sécurité des événements",
    ],
    answer: "Assurer la sécurité des événements",
    explanation:
        "Les patrouilles à vélo sont généralement mobilisées pour garantir la sécurité lors de grands événements.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un éducateur de la Police nationale ?",
    options: [
      "Former des policiers",
      "Encadrer des jeunes",
      "Mener des enquêtes",
    ],
    answer: "Encadrer des jeunes",
    explanation:
        "Les éducateurs de la Police nationale travaillent sur le terrain avec les jeunes pour prévenir la délinquance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la méthode d'intervention des équipes d'élite de la Police ?",
    options: [
      "Intervention rapide",
      "Arrestation silencieuse",
      "Contrôle de foule",
    ],
    answer: "Intervention rapide",
    explanation:
        "Les équipes d'élite, comme le RAID, sont formées pour intervenir rapidement lors de situations critiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type de crime est considéré comme un délit ?",
    options: ["Vol avec violence", "Escroquerie", "Braquage"],
    answer: "Escroquerie",
    explanation:
        "L'escroquerie est classée comme un délit, tandis que certains autres actes peuvent être classés comme crimes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la première étape d'une intervention policière ?",
    options: [
      "Évaluer la situation",
      "Appeler des renforts",
      "Arrêter les suspects",
    ],
    answer: "Évaluer la situation",
    explanation:
        "Avant toute intervention, il est crucial d'évaluer la situation pour agir de manière appropriée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l'outil utilisé pour traquer les communications téléphoniques ?",
    options: ["Interpol", "L'écoute électronique", "Le réseau d'alerte"],
    answer: "L'écoute électronique",
    explanation:
        "L'écoute électronique est utilisée pour intercepter des communications dans le cadre d'enquêtes criminelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la responsabilité d'un agent de police en cas d'accident de la route ?",
    options: [
      "Dresser un constat",
      "Interroger les témoins",
      "Fermer la route",
    ],
    answer: "Dresser un constat",
    explanation:
        "L'agent de police a pour tâche de rédiger un constat lors d'un accident de la route pour documenter les faits.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal but des contrôles routiers ?",
    options: [
      "Vérifier les papiers des conducteurs",
      "Dissuader les conducteurs de commettre des infractions",
      "Évaluer la vitesse des véhicules",
    ],
    answer: "Dissuader les conducteurs de commettre des infractions",
    explanation:
        "Les contrôles routiers sont principalement mis en place pour prévenir les infractions et garantir la sécurité sur les routes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme utilisé pour désigner une procédure judiciaire initiée par un procureur ?",
    options: [
      "Instruction judiciaire",
      "Dossier pénal",
      "Enquête préliminaire",
    ],
    answer: "Instruction judiciaire",
    explanation:
        "L'instruction judiciaire désigne le processus par lequel un procureur mène une enquête sur des délits ou crimes.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la couleur de l'uniforme classique des policiers en France ?",
    options: ["Noir", "Bleu", "Vert"],
    answer: "Bleu",
    explanation:
        "L'uniforme des forces de police nationale est traditionnellement bleu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'organe suprême qui supervise la Police Nationale en France ?",
    options: [
      "Le Ministère de l'Intérieur",
      "Le Président de la République",
      "Le Parlement",
    ],
    answer: "Le Ministère de l'Intérieur",
    explanation:
        "Le Ministère de l'Intérieur est responsable de la Police Nationale et de ses activités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "En quelle année a été créé le Corps de la Police Nationale ?",
    options: ["1945", "1966", "1984"],
    answer: "1966",
    explanation:
        "Le Corps de la Police Nationale a été officiellement créé en 1966 en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal document d'identité en France ?",
    options: ["Passeport", "Carte d'identité", "Permis de conduire"],
    answer: "Carte d'identité",
    explanation:
        "La carte d'identité est le document officiel d'identité le plus couramment utilisé en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l'état-major de la Police Nationale en France ?",
    options: ["DGPN", "CRS", "BRF"],
    answer: "DGPN",
    explanation:
        "La Direction Générale de la Police Nationale (DGPN) est l'état-major de la police en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal objectif de la police judiciaire ?",
    options: [
      "Prévenir les crimes",
      "Enquêter sur les infractions",
      "Rendre des comptes",
    ],
    answer: "Enquêter sur les infractions",
    explanation:
        "La police judiciaire a pour mission d'enquêter sur les infractions pénales afin de faire toute la lumière sur les affaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le nom de la police d’intervention en France ?",
    options: ["GIPN", "BAC", "BRAV"],
    answer: "GIPN",
    explanation:
        "Le Groupe d'Intervention de la Police Nationale (GIPN) est une unité d'intervention spécialisée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Qui est responsable de la régulation des forces de police en France ?",
    options: [
      "Le Sénat",
      "Le Ministère de l'Intérieur",
      "La Cour de Cassation",
    ],
    answer: "Le Ministère de l'Intérieur",
    explanation:
        "Le Ministère de l'Intérieur assure la régulation et la supervision des forces de police en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le nom de l'escadron de gendarmerie mobile ?",
    options: ["GIGN", "Gendarmerie Départementale", "Gendarmerie Maritime"],
    answer: "GIGN",
    explanation:
        "Le GIGN (Groupe d'Intervention de la Gendarmerie Nationale) est une unité d'élite de la gendarmerie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type de police intervient principalement dans les manifestations ?",
    options: ["Police Nationale", "Gendarmerie", "Police Municipale"],
    answer: "Police Nationale",
    explanation:
        "La Police Nationale est souvent déployée pour maintenir l'ordre lors des manifestations publiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de la cellule de renseignement en matière de terrorisme en France ?",
    options: ["SRA", "TAT", "CTTS"],
    answer: "SRA",
    explanation:
        "Le Service de la Renseignement et de l'Analyse (SRA) est dédié à la lutte contre le terrorisme.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel événement marquant a eu lieu en 2015, touchant la sécurité en France ?",
    options: [
      "Attentats de Paris",
      "Les Jeux Olympiques",
      "L'élection présidentielle",
    ],
    answer: "Attentats de Paris",
    explanation:
        "Les attentats de Paris en novembre 2015 ont eu un impact majeur sur la sécurité nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but principal des patrouilles de police ?",
    options: [
      "Surveiller le territoire",
      "Émettre des contraventions",
      "Rendre des comptes",
    ],
    answer: "Surveiller le territoire",
    explanation:
        "Les patrouilles de police ont pour mission principale de surveiller et assurer la sécurité sur le terrain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de la police communale dans les grandes villes françaises ?",
    options: ["Police Municipale", "Gendarmerie", "CRS"],
    answer: "Police Municipale",
    explanation:
        "La Police Municipale est responsable de la sécurité au niveau local dans les communes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel organisme est chargé de la formation des policiers en France ?",
    options: ["ENP", "ENA", "CNRS"],
    answer: "ENP",
    explanation:
        "L'École Nationale de Police (ENP) forme les futurs agents de la Police Nationale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel terme désigne les soldats de la gendarmerie en France ?",
    options: ["Gendarmes", "Policiers", "Surveillants"],
    answer: "Gendarmes",
    explanation:
        "Les membres de la gendarmerie sont appelés gendarmes, une force militaire de sécurité publique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la mission principale de la CRS ?",
    options: [
      "Assurer la sécurité routière",
      "Maintenir l'ordre public",
      "Effectuer des recherches criminelles",
    ],
    answer: "Maintenir l'ordre public",
    explanation:
        "Les Compagnies Républicaines de Sécurité (CRS) sont chargées de maintenir l'ordre public, surtout lors d'événements.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le sigle de l’organisme français dédié à la lutte contre la délinquance économique ?",
    options: ["DGC", "DRE", "DDSP"],
    answer: "DGC",
    explanation:
        "La Direction Générale de la Concurrence est impliquée dans la lutte contre la délinquance économique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type de contrôle est pratiqué par la police sur la route ?",
    options: [
      "Contrôle d'identité",
      "Contrôle de sécurité",
      "Contrôle routier",
    ],
    answer: "Contrôle routier",
    explanation:
        "Les contrôles routiers sont effectués pour vérifier la conformité des véhicules et des conducteurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le souhait d'un policier vis-à-vis de la population ?",
    options: [
      "Rétablir l'ordre",
      "Aider les citoyens",
      "Punir les délinquants",
    ],
    answer: "Aider les citoyens",
    explanation:
        "Le rôle des policiers inclut d'être un soutien pour la population.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme utilisé pour désigner l'ensemble des agents de l'État en uniforme ?",
    options: ["Fonctionnaires", "Militaires", "Forces de l'ordre"],
    answer: "Forces de l'ordre",
    explanation:
        "Les forces de l'ordre regroupent tous les agents de l'État chargés de maintenir la paix et la sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la responsabilité des officiers de police judiciaire ?",
    options: [
      "Enquêter sur les crimes",
      "Arrêter les suspects",
      "Surveiller le territoire",
    ],
    answer: "Enquêter sur les crimes",
    explanation:
        "Les officiers de police judiciaire sont spécifiquement formés pour enquêter sur les infractions pénales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'un des dangers majeurs auxquels les policiers font face ?",
    options: ["Le stress", "Les embouteillages", "La bureaucratie"],
    answer: "Le stress",
    explanation:
        "Les policiers travaillent souvent sous pression, ce qui peut engendrer un stress important.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel appareil est souvent utilisé par la police pour filmer les interventions ?",
    options: ["Caméra de surveillance", "Dron", "Appareil photo"],
    answer: "Caméra de surveillance",
    explanation:
        "Les caméras de surveillance sont couramment utilisées pour enregistrer les interventions policières.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le code de la route utilisé par les policiers lors des contrôles ?",
    options: ["Code de sécurité", "Code des transports", "Code de la route"],
    answer: "Code de la route",
    explanation:
        "Le Code de la route est un ensemble de règles régissant la circulation des véhicules et des piétons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Dans quel cas une fouille peut-elle être effectuée par un policier ?",
    options: [
      "Sur demande",
      "Lors d'une suspicion de crime",
      "Aucune raison nécessaire",
    ],
    answer: "Lors d'une suspicion de crime",
    explanation:
        "Une fouille peut être effectuée par un policier en cas de suspicion d'infraction ou de crime.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la durée maximale de garde à vue en France ?",
    options: ["24 heures", "48 heures", "72 heures"],
    answer: "48 heures",
    explanation:
        "La garde à vue peut durer jusqu'à 48 heures avant de devoir être présentée à un juge.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce qu'un procès-verbal ?",
    options: [
      "Un document officiel",
      "Un article de loi",
      "Un rapport d'enquête",
    ],
    answer: "Un document officiel",
    explanation:
        "Le procès-verbal est un document officiel rédigé par un policier pour consigner des faits constatés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Qui est l'autorité compétente pour délivrer une autorisation de port d'arme en France ?",
    options: ["Le Maire", "Le Préfet", "Le Ministre de la Défense"],
    answer: "Le Préfet",
    explanation:
        "Le Préfet est l'autorité responsable de la délivrance d'autorisations de port d'arme en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de la police spécialisée dans les crimes économiques et financiers ?",
    options: ["BRDE", "DGSE", "BCE"],
    answer: "BRDE",
    explanation:
        "La Brigade de Répression de la Délinquance Économique (BRDE) s'occupe des crimes économiques et financiers.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de l'IGPN ?",
    options: [
      "Contrôler les policiers",
      "Former les agents",
      "Assurer la sécurité nationale",
    ],
    answer: "Contrôler les policiers",
    explanation:
        "L'Inspection Générale de la Police Nationale (IGPN) contrôle et évalue le respect de la déontologie policière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la première règle de déontologie policière ?",
    options: ["Respect de la loi", "Devoir de réserve", "Neutralité politique"],
    answer: "Respect de la loi",
    explanation:
        "Le respect de la loi est la première règle que doivent suivre tous les policiers dans l'exercice de leurs fonctions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du système d'information européen pour les données criminelles ?",
    options: ["SIVEP", "Europol", "SIS II"],
    answer: "SIS II",
    explanation:
        "Le Système d'Information Schengen II (SIS II) permet l'échange de données sur les personnes recherchées en Europe.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal moyen de communication des policiers sur le terrain ?",
    options: ["Téléphone portable", "Radio", "Messager"],
    answer: "Radio",
    explanation:
        "Les agents de police utilisent principalement des radios pour communiquer sur le terrain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l'unité de police spécialisée dans la lutte contre la violence urbaine ?",
    options: ["BAC", "CRS", "GIPN"],
    answer: "BAC",
    explanation:
        "La Brigade Anti-Criminalité (BAC) est spécialisée dans la lutte contre la délinquance urbaine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel document atteste de l'identité d'une personne en cas de contrôle ?",
    options: ["Certificat de naissance", "Carte d'identité", "Passeport"],
    answer: "Carte d'identité",
    explanation:
        "La carte d'identité est le document officiel généralement demandé lors des contrôles policiers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle du Procureur dans le système judiciaire ?",
    options: [
      "Représenter l'État",
      "Défendre les accusés",
      "Contrôler la police",
    ],
    answer: "Représenter l'État",
    explanation:
        "Le Procureur représente l'État et dirige les enquêtes criminelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la première intervention d'un policier sur le terrain en cas d'accident ?",
    options: [
      "Évaluer la situation",
      "Appeler les secours",
      "Interroger les témoins",
    ],
    answer: "Évaluer la situation",
    explanation:
        "La première étape consiste à évaluer la situation pour agir de manière appropriée et sécurisée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des affaires internes dans la police ?",
    options: [
      "Former les policiers",
      "Enquêter sur les dysfonctionnements",
      "Émettre des contraventions",
    ],
    answer: "Enquêter sur les dysfonctionnements",
    explanation:
        "Les affaires internes sont chargées d'enquêter sur les comportements inappropriés au sein de la police.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel processus suit un policier pour être promu ?",
    options: [
      "Évaluation de ses performances",
      "Formation continue",
      "Examen écrit",
    ],
    answer: "Évaluation de ses performances",
    explanation:
        "L'évaluation des performances est un critère clé pour une promotion au sein des forces de police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l'outil de sélection utilisé lors des enquêtes criminelles ?",
    options: [
      "Fiches de renseignements",
      "Dossier de police",
      "Base de données criminelles",
    ],
    answer: "Base de données criminelles",
    explanation:
        "Les bases de données criminelles sont un moyen essentiel pour les enquêteurs de rassembler et d'analyser des informations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un commissaire de police ?",
    options: [
      "Diriger un service",
      "Patrouiller dans la rue",
      "Former les nouveaux agents",
    ],
    answer: "Diriger un service",
    explanation:
        "Le commissaire de police est responsable de la direction d'un service au sein de la Police Nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but d'une enquête criminelle ?",
    options: [
      "Trouver des preuves",
      "Sanctionner les coupables",
      "Faire un rapport",
    ],
    answer: "Trouver des preuves",
    explanation:
        "L'objectif principal d'une enquête criminelle est de rassembler des preuves pour résoudre une affaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle de la police dans la prévention de la délinquance ?",
    options: [
      "Surveiller les quartiers",
      "Démanteler les réseaux criminels",
      "Sensibiliser la population",
    ],
    answer: "Sensibiliser la population",
    explanation:
        "La prévention de la délinquance passe aussi par l'information et la sensibilisation des citoyens.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la fonction des unités cynophiles ?",
    options: [
      "Lutter contre le trafic",
      "Surveiller les immeubles",
      "Intervenir lors de manifestations",
    ],
    answer: "Lutter contre le trafic",
    explanation:
        "Les unités cynophiles utilisent des chiens pour détecter des substances illégales comme les drogues.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'organe judiciaire qui peut statuer sur les décisions policières ?",
    options: ["La Cour d'Appel", "Le Tribunal administratif", "Le Parquet"],
    answer: "La Cour d'Appel",
    explanation:
        "La Cour d'Appel peut juger des décisions prises par la police en matière judiciaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le devoir d’un policier concernant les droits de l’homme ?",
    options: ["Les violer si nécessaire", "Les respecter", "Les ignorer"],
    answer: "Les respecter",
    explanation:
        "Les policiers ont l'obligation de respecter et de protéger les droits de l'homme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel ajout a été fait en matière de sécurité en France après les attentats de 2015 ?",
    options: [
      "Création de nouvelles forces",
      "Augmentation des budgets",
      "Renforcement de la législation",
    ],
    answer: "Renforcement de la législation",
    explanation:
        "Après les attentats de 2015, la législation en matière de sécurité a été renforcée en France.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif principal de la police nationale ?",
    options: [
      "Maintenir l'ordre public",
      "Collecter des impôts",
      "Promouvoir le tourisme",
    ],
    answer: "Maintenir l'ordre public",
    explanation:
        "La police nationale a pour mission principale de garantir la sécurité des citoyens et de maintenir l'ordre public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des enquêteurs de la police judiciaire ?",
    options: [
      "Gérer les finances de l'État",
      "Mener des enquêtes criminelles",
      "Former les nouveaux agents",
    ],
    answer: "Mener des enquêtes criminelles",
    explanation:
        "Les enquêteurs de la police judiciaire sont responsables de l'investigation des crimes et délits.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le code de la route en France ?",
    options: ["Code pénal", "Code civil", "Code de la route"],
    answer: "Code de la route",
    explanation:
        "Le code de la route établit les règles de circulation routière en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui peut intercepter un véhicule en infraction ?",
    options: [
      "Les agents de sécurité privés",
      "Les policiers",
      "Les gendarmes",
    ],
    answer: "Les policiers",
    explanation:
        "Seuls les policiers sont habilités à intercepter des véhicules en infraction sur le domaine public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal service de renseignement intérieur en France ?",
    options: ["DGSE", "Renseignements Généraux", "DGSI"],
    answer: "DGSI",
    explanation:
        "La DGSI est chargée de la sécurité intérieure et du renseignement en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel document est nécessaire pour conduire un véhicule en France ?",
    options: [
      "L'attestation d'assurance",
      "Le livre de bord",
      "Le permis de conduire",
    ],
    answer: "Le permis de conduire",
    explanation:
        "Le permis de conduire est obligatoire pour conduire légalement un véhicule en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle du procureur dans une enquête criminelle ?",
    options: [
      "Arrestation des suspects",
      "Mener l'enquête",
      "Diriger l'action publique",
    ],
    answer: "Diriger l'action publique",
    explanation: "Le procureur supervise et dirige les enquêtes judiciaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le délai maximal de garde à vue en France ?",
    options: ["24 heures", "48 heures", "72 heures"],
    answer: "48 heures",
    explanation:
        "La garde à vue peut durer jusqu'à 48 heures, avec une éventuelle prolongation dans certains cas.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type d'infraction est un vol à main armée ?",
    options: [
      "Infraction criminelle",
      "Infraction contraventionnelle",
      "Infraction délictuelle",
    ],
    answer: "Infraction criminelle",
    explanation:
        "Le vol à main armée est classé comme une infraction criminelle en droit pénal.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'organe de contrôle administratif des policiers en France ?",
    options: ["La CNIL", "L'IGPN", "Le Conseil d'État"],
    answer: "L'IGPN",
    explanation:
        "L'IGPN est chargé de contrôler la déontologie et les actes des policiers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce qu'un flagrant délit ?",
    options: [
      "Un délit commis en pleine rue",
      "Un délit constaté par un policier au moment de sa commission",
      "Un délit connu après une enquête",
    ],
    answer: "Un délit constaté par un policier au moment de sa commission",
    explanation:
        "Un flagrant délit est une infraction observée directement par les forces de l'ordre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but de la prévention de la délinquance ?",
    options: [
      "Réduire les effectifs policiers",
      "Sensibiliser le public aux risques",
      "Promouvoir la criminalité",
    ],
    answer: "Sensibiliser le public aux risques",
    explanation:
        "La prévention de la délinquance vise à informer et à protéger le public contre la criminalité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel âge minimum faut-il avoir pour devenir policier en France ?",
    options: ["18 ans", "21 ans", "25 ans"],
    answer: "18 ans",
    explanation:
        "Il faut avoir au moins 18 ans pour postuler à un poste de policier en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce qu'une perquisition ?",
    options: [
      "Une recherche de preuves",
      "Une arrestation",
      "Une enquête administrative",
    ],
    answer: "Une recherche de preuves",
    explanation:
        "Une perquisition est l'action de rechercher des preuves dans un lieu donné.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal risque du tabagisme passif ?",
    options: [
      "Accidents de la route",
      "Maladies respiratoires",
      "Problèmes financiers",
    ],
    answer: "Maladies respiratoires",
    explanation:
        "Le tabagisme passif augmente le risque de maladies respiratoires chez les non-fumeurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des équipes cynophiles ?",
    options: [
      "Former des policiers",
      "Dénoncer des crimes",
      "Détecter des drogues",
    ],
    answer: "Détecter des drogues",
    explanation:
        "Les équipes cynophiles utilisent des chiens pour détecter des substances illicites.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'acronyme de la Direction Générale de la Sécurité Intérieure ?",
    options: ["DGSI", "DGSE", "DGSN"],
    answer: "DGSI",
    explanation:
        "La DGSI est l'organisme responsable de la sécurité intérieure en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle d'un agent de police technique et scientifique ?",
    options: [
      "Interroger les témoins",
      "Analyser des preuves",
      "Contrôler le trafic",
    ],
    answer: "Analyser des preuves",
    explanation:
        "L'agent de police technique et scientifique se spécialise dans l'analyse et la collecte de preuves.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui est le supérieur hiérarchique d'un policier ?",
    options: ["Le maire", "Le préfet", "Le ministre de l'Intérieur"],
    answer: "Le ministre de l'Intérieur",
    explanation:
        "Le ministre de l'Intérieur est responsable des forces de police en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "À quoi sert le fichier judiciaire automatisé des auteurs d'infractions ?",
    options: [
      "À contrôler le trafic des voitures",
      "À effectuer des relevés de santé",
      "À recenser les criminels",
    ],
    answer: "À recenser les criminels",
    explanation:
        "Ce fichier permet de suivre les auteurs d'infractions et de faciliter les enquêtes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le département en charge des affaires criminelles au sein de la police ?",
    options: [
      "La direction centrale de la police judiciaire",
      "La brigade des mineurs",
      "Le service d'ordre public",
    ],
    answer: "La direction centrale de la police judiciaire",
    explanation:
        "Cette direction est chargée de l'investigation des affaires criminelles en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce qu'une contravention ?",
    options: ["Un délit léger", "Un crime grave", "Un acte d'incivisme"],
    answer: "Un délit léger",
    explanation:
        "La contravention est une infraction mineure au code de la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nombre maximum de participants lors d'une manifestation pacifique en France ?",
    options: ["500 personnes", "1000 personnes", "Aucun maximum"],
    answer: "Aucun maximum",
    explanation:
        "Il n'existe pas de limite maximum pour les participants d'une manifestation pacifique en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du document officiel lorsqu'une perquisition est effectuée ?",
    options: ["Procès-verbal", "Ordre de mission", "Rapport d'enquête"],
    answer: "Procès-verbal",
    explanation:
        "Le procès-verbal est le document qui consigne les détails d'une perquisition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif des brigades de nuit ?",
    options: [
      "Faire des contrôles administratifs",
      "Maintenir l'ordre nocturne",
      "Fournir des renseignements",
    ],
    answer: "Maintenir l'ordre nocturne",
    explanation:
        "Les brigades de nuit travaillent pour assurer la sécurité et l'ordre durant les heures nocturnes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la mission de la police de la route ?",
    options: [
      "Gérer le trafic aérien",
      "Réaliser des contrôles routiers",
      "Détecter des crimes",
    ],
    answer: "Réaliser des contrôles routiers",
    explanation:
        "La police de la route est chargée de contrôler le respect des règles de circulation sur les routes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel document doit être présenté lors d'un contrôle routier ?",
    options: [
      "Le certificat de travail",
      "Le permis de conduire",
      "La carte d'identité",
    ],
    answer: "Le permis de conduire",
    explanation:
        "Le permis de conduire est obligatoire à présenter lors d'un contrôle routier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'organe de contrôle des excès de la police ?",
    options: ["La CNIL", "L'IGPN", "Le Conseil constitutionnel"],
    answer: "L'IGPN",
    explanation:
        "L'IGPN a pour rôle de contrôler les abus et les déontologies des forces de police.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle du service de l'accueil au commissariat ?",
    options: [
      "Accueillir le public",
      "Rédiger des rapports",
      "Interroger les suspects",
    ],
    answer: "Accueillir le public",
    explanation:
        "Le service d'accueil au commissariat est chargé de recevoir et d'orienter le public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type de crime est le trafic de drogue ?",
    options: [
      "Criminalité organisationnelle",
      "Crime de sang",
      "Crime économique",
    ],
    answer: "Criminalité organisationnelle",
    explanation:
        "Le trafic de drogue est classé comme une forme de criminalité organisée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Comment s'appelle le niveau de classification des infractions en France ?",
    options: [
      "Contraventions, Délits et Crimes",
      "Infractions, Faute et Erreurs",
      "Actes, Délits et Crimes",
    ],
    answer: "Contraventions, Délits et Crimes",
    explanation:
        "Les infractions en France sont classées en trois catégories : contraventions, délits et crimes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'organe de sécurité chargé de la sécurité routière en France ?",
    options: ["SNCF", "CRS", "Gendarmerie"],
    answer: "Gendarmerie",
    explanation:
        "La gendarmerie a un rôle important dans la sécurité routière, particulièrement dans les zones rurales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de la police française d'active à l'international ?",
    options: ["DGSI", "INTERPOL", "FBI"],
    answer: "INTERPOL",
    explanation:
        "INTERPOL est une organisation internationale qui facilite la coopération entre les polices de différents pays.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la première étape d'une enquête policière ?",
    options: [
      "Collecter des preuves",
      "Interroger des témoins",
      "Analyser les indices",
    ],
    answer: "Interroger des témoins",
    explanation:
        "L'interrogation des témoins est souvent la première étape cruciale dans le déroulement d'une enquête.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la fonction d'une patrouille de police ?",
    options: [
      "Contrôler les papiers d'identité",
      "Rendre visite aux habitants",
      "Surveiller le quartier",
    ],
    answer: "Surveiller le quartier",
    explanation:
        "La patrouille de police est chargée de surveiller et d'assurer la sécurité d'un secteur géographique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui valide les enquêtes préliminaires ?",
    options: ["Le juge", "Le procureur", "Le commissaire de police"],
    answer: "Le procureur",
    explanation:
        "Le procureur valide et supervise les enquêtes préliminaires menées par la police.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce qu'un témoin sous protection ?",
    options: [
      "Un témoin ayant donné des informations",
      "Un témoin ayant commis un crime",
      "Un témoin en danger",
    ],
    answer: "Un témoin en danger",
    explanation:
        "Un témoin sous protection est une personne dont la sécurité est menacée en raison de ses déclarations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de la police des frontières ?",
    options: [
      "Protéger le territoire",
      "Contrôler le commerce",
      "Surveiller la population",
    ],
    answer: "Protéger le territoire",
    explanation:
        "La police des frontières est chargée de contrôler les entrées et sorties du territoire national.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle loi a été instaurée pour réguler les manifestations en France ?",
    options: [
      "Loi sur l'état d'urgence",
      "Loi sur la sécurité intérieure",
      "Loi sur les débits de boissons",
    ],
    answer: "Loi sur la sécurité intérieure",
    explanation:
        "Cette loi encadre les conditions de tenue des manifestations sur le territoire français.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la principale fonction de l'Observatoire national de la délinquance ?",
    options: [
      "Dresser un bilan de la délinquance",
      "Former des agents de police",
      "Contrôler les prisons",
    ],
    answer: "Dresser un bilan de la délinquance",
    explanation:
        "L'Observatoire national de la délinquance analyse les tendances criminelles en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la fonction principale du renseignement territorial ?",
    options: [
      "Surveiller le phénomène social",
      "Prévenir les actes de délinquance",
      "Gérer les flux migratoires",
    ],
    answer: "Prévenir les actes de délinquance",
    explanation:
        "Le renseignement territorial vise à anticiper et prévenir les infractions et actes de délinquance.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle mesure peut être prise en cas de trouble à l'ordre public ?",
    options: [
      "Évacuation du lieu",
      "Fermeture des commerces",
      "Interdiction de sortie",
    ],
    answer: "Évacuation du lieu",
    explanation:
        "En cas de trouble à l'ordre public, les autorités peuvent ordonner l'évacuation des lieux concernés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but principal des amendes forfaitaires ?",
    options: [
      "Punir les infractions administratives",
      "Récupérer des coûts de police",
      "Simplifier le système judiciaire",
    ],
    answer: "Simplifier le système judiciaire",
    explanation:
        "Les amendes forfaitaires visent à simplifier la gestion des petites infractions sans passer par le tribunal.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle du service des affaires internes ?",
    options: [
      "Surveiller les activités policières",
      "Recevoir les plaintes des citoyens",
      "Organiser des événements publics",
    ],
    answer: "Surveiller les activités policières",
    explanation:
        "Le service des affaires internes est chargé de surveiller et d'enquêter sur les comportements des policiers.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal défi des forces de police aujourd'hui ?",
    options: [
      "La lutte contre le terrorisme",
      "La gestion des transports publics",
      "La préservation de la biodiversité",
    ],
    answer: "La lutte contre le terrorisme",
    explanation:
        "La lutte contre le terrorisme est actuellement l'un des principaux défis auxquels sont confrontées les forces de police.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel droit est protégé lors d'une arrestation ?",
    options: [
      "Le droit de vote",
      "Le droit à un avocat",
      "Le droit à la santé",
    ],
    answer: "Le droit à un avocat",
    explanation:
        "Lors d'une arrestation, le suspect a le droit d'être assisté par un avocat.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "En cas de désobéissance, quelle disposition peut prendre un agent de police ?",
    options: [
      "Recours à la force",
      "Avertir les supérieurs",
      "Émettre une amende",
    ],
    answer: "Recours à la force",
    explanation:
        "Lorsqu'un agent de police fait face à une désobéissance, il peut avoir recours à des mesures de force appropriées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif des contrôles d'identité par la police ?",
    options: [
      "Prévenir les délits",
      "Collecter des impôts",
      "Récupérer des armes",
    ],
    answer: "Prévenir les délits",
    explanation:
        "Les contrôles d'identité visent à prévenir la commission de délits par une surveillance active.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est l'importance de la présomption d'innocence ?",
    options: [
      "Elle protège les accusés",
      "Elle favorise les victimes",
      "Elle encadre les enquêtes",
    ],
    answer: "Elle protège les accusés",
    explanation:
        "La présomption d'innocence garantit que toute personne est considérée comme innocente jusqu'à preuve du contraire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le principal rôle de la police nationale en France ?",
    options: [
      "Maintenir l'ordre public",
      "Réaliser des enquêtes criminelles",
      "Fournir des services d'urgence",
    ],
    answer: "Maintenir l'ordre public",
    explanation:
        "La police nationale a pour mission principale de maintenir l'ordre public et de protéger les citoyens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la différence entre la gendarmerie et la police nationale ?",
    options: [
      "La gendarmerie est militaire, la police est civile",
      "La gendarmerie agit uniquement en milieu rural",
      "La police nationale n'intervient jamais sur les routes",
    ],
    answer: "La gendarmerie est militaire, la police est civile",
    explanation:
        "La gendarmerie a un statut militaire tandis que la police nationale a un statut civil.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type de police intervient principalement lors des manifestations ?",
    options: ["Police de la route", "Force d'intervention", "Police secours"],
    answer: "Force d'intervention",
    explanation:
        "La force d'intervention est spécialement formée pour maintenir l'ordre lors des manifestations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel document officiel contient les règles de procédures en matière de police judiciaire ?",
    options: ["Code pénal", "Code de procédure pénale", "Code civil"],
    answer: "Code de procédure pénale",
    explanation:
        "Le Code de procédure pénale régule les opérations de police judiciaire en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle du procureur de la République dans une enquête policière ?",
    options: [
      "Diriger les forces de police",
      "Encadrer les enquêtes criminelles",
      "Représenter l'État devant le tribunal",
    ],
    answer: "Représenter l'État devant le tribunal",
    explanation:
        "Le procureur de la République représente l'État et décide des poursuites à engager.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de l'unité spécialisée de la police nationale pour la lutte contre le terrorisme ?",
    options: ["RAID", "BAC", "SRPJ"],
    answer: "RAID",
    explanation:
        "Le RAID est une unité d'élite de la police nationale spécialisée dans les opérations anti-terroristes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'organe de contrôle interne de la police nationale en France ?",
    options: [
      "Inspection générale de la police nationale (IGPN)",
      "Conseil de la police",
      "Syndicat des policiers",
    ],
    answer: "Inspection générale de la police nationale (IGPN)",
    explanation:
        "L'IGPN contrôle les activités des policiers et enquête sur les comportements déviants.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal type de délit poursuivi par la police nationale ?",
    options: [
      "Délits économiques",
      "Infractions routières",
      "Crimes contre les personnes",
    ],
    answer: "Crimes contre les personnes",
    explanation:
        "Les crimes contre les personnes englobent les homicides, les agressions, et autres violations graves.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de la police scientifique ?",
    options: [
      "Enquêter sur le terrain",
      "Analyser les preuves",
      "Interroger les suspects",
    ],
    answer: "Analyser les preuves",
    explanation:
        "La police scientifique est spécialisée dans l'analyse des éléments matériels de l'enquête.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but principal de la police de proximité ?",
    options: [
      "Renforcer la présence policière",
      "Favoriser le contact avec les citoyens",
      "Contrôler les routes",
    ],
    answer: "Favoriser le contact avec les citoyens",
    explanation:
        "La police de proximité vise à créer un lien de confiance entre la police et la population.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle des agents de surveillance de la voie publique (ASVP) ?",
    options: [
      "Réaliser des enquêtes criminelles",
      "Verbaliser les infractions aux règles de stationnement",
      "Intervenir lors de manifestations",
    ],
    answer: "Verbaliser les infractions aux règles de stationnement",
    explanation:
        "Les ASVP sont chargés de la surveillance du stationnement et des infractions de la voie publique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom de la police qui dépend du ministère de la Justice ?",
    options: ["Police nationale", "Police municipale", "Gendarmerie nationale"],
    answer: "Police nationale",
    explanation:
        "La police nationale est sous l'autorité du ministère de l'Intérieur, tandis que la gendarmerie respecte le ministère de la Justice.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle principal de la police des frontières ?",
    options: [
      "Surveiller les voies maritimes",
      "Contrôler les entrées et sorties du territoire",
      "Prévenir les actes de violence",
    ],
    answer: "Contrôler les entrées et sorties du territoire",
    explanation:
        "La police des frontières veille à la régulation des flux migratoires et à la sécurité des frontières.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la mission d'une brigade anticriminalité (BAC) ?",
    options: [
      "Intervenir lors d'accidents de la route",
      "Lutter contre la délinquance",
      "Gérer des événements sportifs",
    ],
    answer: "Lutter contre la délinquance",
    explanation:
        "La BAC est spécialisée dans la lutte contre la délinquance de voie publique et les actes violents.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le terme utilisé pour désigner la répression des comportements criminels ?",
    options: ["Coercition", "Prévention", "Répression"],
    answer: "Répression",
    explanation:
        "La répression vise à punir les comportements criminels pour dissuader leur répétition.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'effet principal que cherche à atteindre la police quand elle intervient ?",
    options: [
      "Réparer les préjudices",
      "Rétablir l'ordre",
      "Constituer des preuves",
    ],
    answer: "Rétablir l'ordre",
    explanation:
        "L'objectif majeur de la police est de rétablir l'ordre et la sécurité sur le terrain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Dans quelles situations la police peut-elle procéder à une arrestation ?",
    options: [
      "Quant elle le souhaite",
      "Lorsqu'elle a un doute",
      "Lorsqu'il existe des indices sérieux",
    ],
    answer: "Lorsqu'il existe des indices sérieux",
    explanation:
        "La police ne peut arrêter qu'en cas de soupçons fondés et justifiés par des éléments de preuve.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'élément fondamental dans la protection des données personnelles par la police ?",
    options: [
      "Le secret de l'enquête",
      "Le respect de la vie privée",
      "La transparence des actions",
    ],
    answer: "Le respect de la vie privée",
    explanation:
        "Le respect de la vie privée est crucial dans le cadre légal de la protection des données personnelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'organe judiciaire qui supervise les enquêtes policières ?",
    options: ["Le tribunal", "Le juge d'instruction", "La cour d'appel"],
    answer: "Le juge d'instruction",
    explanation:
        "Le juge d'instruction supervise les enquêtes criminelles pour garantir leur conformité légale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel type de conflit est la police habilitée à gérer ?",
    options: [
      "Conflits familiaux",
      "Violences conjugales",
      "Conflits d'affaires",
    ],
    answer: "Violences conjugales",
    explanation:
        "La police est formée pour intervenir et protéger les victimes de violences conjugales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel événement majeur a entraîné la création de la police nationale en France ?",
    options: [
      "La Révolution française",
      "La Seconde Guerre mondiale",
      "Mai 68",
    ],
    answer: "La Révolution française",
    explanation:
        "La création de la police nationale a été formalisée après la Révolution française pour assurer l'ordre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la principale fonction de la police municipale ?",
    options: [
      "Lutter contre le terrorisme",
      "Gérer les festivals",
      "Assurer la sécurité des espaces publics",
    ],
    answer: "Assurer la sécurité des espaces publics",
    explanation:
        "La police municipale veille à la sécurité et à la tranquillité des espaces publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel organisme est chargé de la formation initiale des policiers en France ?",
    options: [
      "École nationale de la police",
      "Syndicat des policiers",
      "Inspection générale de la police nationale (IGPN)",
    ],
    answer: "École nationale de la police",
    explanation:
        "L'École nationale de la police forme les futurs policiers dans divers domaines de la sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est l'un des principaux outils de la police pour assurer la sécurité routière ?",
    options: [
      "Les radars automatiques",
      "Les patrouilles motorisées",
      "Les vidéos surveillance",
    ],
    answer: "Les radars automatiques",
    explanation:
        "Les radars automatiques sont utilisés pour contrôler la vitesse et dissuader les comportements dangereux sur la route.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qu'est-ce qui caractérise le métier de policier ?",
    options: [
      "Travail de bureau",
      "Intervention sur le terrain",
      "Rédaction de rapports",
    ],
    answer: "Intervention sur le terrain",
    explanation:
        "Le métier de policier est principalement axé sur l'intervention sur le terrain pour assurer la sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la plateforme qui permet aux citoyens de signaler des incidents à la police ?",
    options: [
      "Numéro d'urgence",
      "Application mobile",
      "Site internet officiel",
    ],
    answer: "Numéro d'urgence",
    explanation:
        "Le numéro d'urgence permet aux citoyens de contacter rapidement les forces de l'ordre en cas d'urgence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le critère principal pour une intervention policière ?",
    options: [
      "La rapidité d'action",
      "Le niveau de dangerosité",
      "La légalité de l'intervention",
    ],
    answer: "Le niveau de dangerosité",
    explanation:
        "La police évalue le niveau de dangerosité de la situation pour déterminer la nature de l'intervention.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle principal de la police technique et scientifique ?",
    options: [
      "S'assurer de la sécurité publique",
      "Collecter des preuves matérielles",
      "Déterminer les peines",
    ],
    answer: "Collecter des preuves matérielles",
    explanation:
        "La police technique et scientifique se concentre sur la collecte et l'analyse de preuves pour les enquêtes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'élément central de la déontologie policière ?",
    options: [
      "Le respect des droits de l'homme",
      "La protection des biens",
      "La répression des infractions",
    ],
    answer: "Le respect des droits de l'homme",
    explanation:
        "La déontologie policière repose sur le respect des droits de l'homme dans toutes les actions menées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type d'infraction est prioritairement traité par la police nationale ?",
    options: [
      "Les crimes environnementaux",
      "Les atteintes aux personnes",
      "Les fraudes financières",
    ],
    answer: "Les atteintes aux personnes",
    explanation:
        "Les atteintes aux personnes, telles que les agressions, sont une priorité pour la police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'organe de direction de la police nationale en France ?",
    options: [
      "Direction Générale de la Police Nationale (DGPN)",
      "Ministère de l'Intérieur",
      "Inspection Générale de la Police Nationale (IGPN)",
    ],
    answer: "Direction Générale de la Police Nationale (DGPN)",
    explanation:
        "La DGPN est responsable de l'organisation et du fonctionnement de la police nationale en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l’objectif principal de la lutte contre les stupéfiants par la police ?",
    options: [
      "Réduire la consommation",
      "Arrêter les trafiquants",
      "Confisquer les biens",
    ],
    answer: "Arrêter les trafiquants",
    explanation:
        "L'objectif principal est d'arrêter les trafiquants pour démanteler les réseaux de trafic de drogue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type de profil peut être établi par la police lors d'une enquête criminelle ?",
    options: [
      "Profil psychologique",
      "Profil économique",
      "Profil démographique",
    ],
    answer: "Profil psychologique",
    explanation:
        "Un profil psychologique peut aider à comprendre le comportement de suspects dans des enquêtes criminelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Dans quel cas la police peut-elle effectuer une perquisition sans autorisation préalable ?",
    options: [
      "En cas de flagrant délit",
      "À tout moment",
      "Sur simple suspicion",
    ],
    answer: "En cas de flagrant délit",
    explanation:
        "La police peut perquisitionner sans autorisation en cas de flagrant délit pour agir rapidement contre le crime.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la responsabilité principale d'un policier lors d'une intervention ?",
    options: [
      "Faire des arrestations",
      "Assurer la sécurité de tous",
      "Établir des rapports",
    ],
    answer: "Assurer la sécurité de tous",
    explanation:
        "La sécurité de tous les individus présents est la priorité sur le terrain lors d'une intervention policière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel outil est souvent utilisé pour la surveillance en milieu urbain ?",
    options: [
      "Caméras de vidéosurveillance",
      "Drones",
      "Agents de sécurité privés",
    ],
    answer: "Caméras de vidéosurveillance",
    explanation:
        "Les caméras de vidéosurveillance sont couramment utilisées pour surveiller les espaces publics et prévenir la criminalité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel phénomène a conduit à une évolution des techniques policières ?",
    options: [
      "L'augmentation de la population",
      "Le développement technologique",
      "L'évolution des lois",
    ],
    answer: "Le développement technologique",
    explanation:
        "Le développement technologique a permis d'améliorer les techniques et outils utilisés par la police.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle des policiers lors de l'organisation d'événements publics ?",
    options: [
      "Gérer les sponsors",
      "Assurer la sécurité",
      "Vendre des billets",
    ],
    answer: "Assurer la sécurité",
    explanation:
        "Les policiers assurent la sécurité lors d'événements publics pour garantir le bon déroulement de ceux-ci.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'impact des réseaux sociaux sur le travail policier ?",
    options: [
      "Ils compliquent les enquêtes",
      "Ils facilitent la communication",
      "Ils augmentent les tensions",
    ],
    answer: "Ils facilitent la communication",
    explanation:
        "Les réseaux sociaux peuvent faciliter la communication entre la police et la communauté, renforçant la confiance.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'impact de la formation continue sur les policiers ?",
    options: [
      "Renforce leur expertise",
      "Augmente leur charge de travail",
      "Réduit leur stress",
    ],
    answer: "Renforce leur expertise",
    explanation:
        "La formation continue permet aux policiers de mettre à jour leurs compétences et d'améliorer leur expertise professionnelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le rôle de la police dans la prévention de la criminalité ?",
    options: [
      "Sensibiliser le public",
      "Arrêter les criminels",
      "Appliquer la loi",
    ],
    answer: "Sensibiliser le public",
    explanation:
        "La prévention de la criminalité implique de sensibiliser le public aux comportements à risque et aux dangers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif d'une enquête de voisinage ?",
    options: [
      "Établir des liens avec la communauté",
      "Identifier des témoins",
      "Trouver des suspects",
    ],
    answer: "Identifier des témoins",
    explanation:
        "Une enquête de voisinage vise à identifier les témoins potentiels d'un événement criminel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est l'impact de la technologie sur les enquêtes criminelles ?",
    options: [
      "Réduit les ressources nécessaires",
      "Accélère le processus",
      "Rend tout plus complexe",
    ],
    answer: "Accélère le processus",
    explanation:
        "La technologie permet d'accélérer les enquêtes en facilitant l'analyse des données et des preuves.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle d'un témoin lors d'une enquête policière ?",
    options: [
      "Fournir des informations",
      "Évaluer la situation",
      "Établir un rapport",
    ],
    answer: "Fournir des informations",
    explanation:
        "Les témoins apportent des informations cruciales pour aider à résoudre une enquête criminelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le droit fondamental dont disposent les citoyens face à la police ?",
    options: [
      "Le droit à un avocat",
      "Le droit au silence",
      "Le droit de contestation",
    ],
    answer: "Le droit au silence",
    explanation:
        "Le droit au silence permet aux citoyens de ne pas s'auto-incriminer lors des interrogatoires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le lien entre la police et les municipalités ?",
    options: [
      "Aucune relation",
      "Coopération pour la sécurité",
      "Gestion des impôts locaux",
    ],
    answer: "Coopération pour la sécurité",
    explanation:
        "La police collabore avec les municipalités pour assurer la sécurité publique dans les territoires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la principale autorité de la police nationale en matière de sécurité intérieure ?",
    options: [
      "Ministère de l'Intérieur",
      "Président de la République",
      "Conseil des ministres",
    ],
    answer: "Ministère de l'Intérieur",
    explanation:
        "Le ministère de l'Intérieur est responsable de la sécurité intérieure et de l'organisation de la police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'élément essentiel d'une enquête criminelle ?",
    options: [
      "La rapidité",
      "La collecte de preuves",
      "Le nombre d'agents impliqués",
    ],
    answer: "La collecte de preuves",
    explanation:
        "La collecte de preuves est cruciale pour établir la vérité et mener à bien une enquête criminelle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but d'un rapport d'enquête ?",
    options: [
      "Fournir des détails aux médias",
      "Établir un historique des faits",
      "Justifier des arrestations",
    ],
    answer: "Établir un historique des faits",
    explanation:
        "Le rapport d'enquête documente les événements et les actions menées pour référence future.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "En quelle année a été créée la police nationale française ?",
    options: ["1966", "1941", "1972"],
    answer: "1966",
    explanation:
        "La police nationale a été fondée en 1966, unifiant plusieurs corps de police préexistants.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le nom du ministère responsable de la police nationale ?",
    options: [
      "Ministère de l'Intérieur",
      "Ministère de la Justice",
      "Ministère de l'Administration publique",
    ],
    answer: "Ministère de l'Intérieur",
    explanation:
        "Le ministère de l'Intérieur est chargé des affaires de sécurité intérieure, notamment de la police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le budget annuel approximatif de la police nationale en France ?",
    options: [
      "10 milliards d'euros",
      "20 milliards d'euros",
      "30 milliards d'euros",
    ],
    answer: "10 milliards d'euros",
    explanation:
        "Le budget annuel de la police nationale est aux environs de 10 milliards d'euros.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le grade le plus élevé dans la police nationale ?",
    options: ["Commissaire", "Inspecteur principal", "Directeur général"],
    answer: "Directeur général",
    explanation:
        "Le Directeur général de la police nationale est le grade le plus élevé dans la hiérarchie policière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif principal d'un contrôleur de police ?",
    options: [
      "Gérer les finances",
      "Diriger les opérations",
      "Surveiller l'application des lois",
    ],
    answer: "Surveiller l'application des lois",
    explanation:
        "Le contrôleur de police veille principalement à l'application des lois et règlements en vigueur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Qui peut être un agent de la police nationale ?",
    options: [
      "Tout citoyen français",
      "Uniquement des diplômés en droit",
      "Tout citoyen de l'Union européenne",
    ],
    answer: "Tout citoyen français",
    explanation:
        "Pour devenir agent de la police nationale, il faut être citoyen français.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal objectif des enquêtes criminelles menées par la police ?",
    options: [
      "Démanteler les gangs",
      "Résoudre les affaires criminelles",
      "Prévenir la délinquance",
    ],
    answer: "Résoudre les affaires criminelles",
    explanation:
        "L'objectif principal est de résoudre les affaires criminelles en identifiant et en appréhendant les coupables.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des BRAV-M dans la police nationale ?",
    options: [
      "Surveiller les manifestations",
      "Gérer les petits délits",
      "Intervenir dans les écoles",
    ],
    answer: "Surveiller les manifestations",
    explanation:
        "Les BRAV-M sont des brigades mobiles de la police chargées de surveiller et de sécuriser les manifestations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le code de déontologie de la police nationale ?",
    options: [
      "Un ensemble de règles éthiques",
      "Une liste de lois pénales",
      "Un manuel de procédure judiciaire",
    ],
    answer: "Un ensemble de règles éthiques",
    explanation:
        "Le code de déontologie établit les principes éthiques et déontologiques pour les policiers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'acronyme de la police technique et scientifique ?",
    options: ["PTS", "PTS-Police", "Poltech"],
    answer: "PTS",
    explanation:
        "PTS signifie Police Technique et Scientifique, spécialisée dans les analyses criminelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but des opérations de police de proximité ?",
    options: [
      "Rapprocher la police des citoyens",
      "Améliorer les relations internationales",
      "Renforcer la lutte contre le terrorisme",
    ],
    answer: "Rapprocher la police des citoyens",
    explanation:
        "Les opérations de police de proximité visent à établir un lien plus étroit entre la police et la communauté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal outil d'identification criminelle utilisé par les enquêteurs ?",
    options: ["La photographie", "Les empreintes digitales", "Les témoignages"],
    answer: "Les empreintes digitales",
    explanation:
        "Les empreintes digitales sont un outil clé pour identifier les suspects dans les enquêtes criminelles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle de l'IGPN ?",
    options: [
      "Surveiller les actions de la gendarmerie",
      "Enquêter sur les fautes des policiers",
      "Former les nouveaux agents",
    ],
    answer: "Enquêter sur les fautes des policiers",
    explanation:
        "L'IGPN est l'Inspection Générale de la Police Nationale, chargée d'enquêter sur les fautes et manquements des policiers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Qui supervise le fonctionnement des forces de police en France ?",
    options: [
      "Le Président de la République",
      "Le ministre de l'Intérieur",
      "Le Premier ministre",
    ],
    answer: "Le ministre de l'Intérieur",
    explanation:
        "Le ministre de l'Intérieur est responsable de la supervision et de la coordination des forces de police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le service de la police nationale responsable de la lutte contre le terrorisme ?",
    options: ["DCPJ", "SGDSN", "BRI"],
    answer: "DCPJ",
    explanation:
        "La Direction Centrale de la Police Judiciaire (DCPJ) est responsable de la lutte contre le terrorisme.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel élément est essentiel dans un rapport d'intervention policière ?",
    options: [
      "Avis des témoins",
      "Détails de l'intervention",
      "État d'âme des policiers",
    ],
    answer: "Détails de l'intervention",
    explanation:
        "Les détails de l'intervention sont cruciaux pour rendre compte de la situation objectivement et légalement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le nom du fichier national des personnes recherchées ?",
    options: ["FPR", "Fichier judiciaire", "Fichier des personnes recherchées"],
    answer: "Fichier des personnes recherchées",
    explanation:
        "Le Fichier des Personnes Recherchées, regroupe les personnes en fuite ou recherchées par la justice.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la mission des unités d'élite comme le RAID ?",
    options: [
      "Lutter contre le trafic de drogue",
      "Intervenir lors de situations d'urgence",
      "Mener des enquêtes criminelles approfondies",
    ],
    answer: "Intervenir lors de situations d'urgence",
    explanation:
        "Le RAID est une unité d'élite chargée d'intervenir dans des situations d'urgence comme les prises d'otages.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel événement incite souvent à des mesures de sécurité accrues à Paris ?",
    options: [
      "Les élections municipales",
      "Les Jeux Olympiques",
      "Les manifestations culturelles",
    ],
    answer: "Les Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques provoquent un renforcement des mesures de sécurité pour protéger les participants et le public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le rôle des policiers de la sécurité publique ?",
    options: [
      "Effectuer des enquêtes criminelles",
      "Garantir la sécurité des événements",
      "Intervenir auprès des victimes",
    ],
    answer: "Garantir la sécurité des événements",
    explanation:
        "Les policiers de la sécurité publique veillent à la sécurité des événements et à l'ordre public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la principale caractéristique de l'Ordre Public ?",
    options: [
      "Respect des lois et règlements",
      "Liberté d'expression",
      "Protection de l'environnement",
    ],
    answer: "Respect des lois et règlements",
    explanation:
        "L'Ordre Public repose sur le respect des lois et règlements afin de maintenir la paix et la sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal moyen de communication de la police avec le public ?",
    options: [
      "Les réseaux sociaux",
      "Les communiqués de presse",
      "Les affiches publiques",
    ],
    answer: "Les communiqués de presse",
    explanation:
        "Les communiqués de presse sont utilisés pour informer le public des actions et des événements importants de la police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel document permet de signaliser un crime à la police ?",
    options: ["Le procès-verbal", "La plainte", "L'attestation"],
    answer: "La plainte",
    explanation:
        "La plainte est le document officiel par lequel une personne signale un crime à la police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type de délit est le plus souvent traité par la police nationale ?",
    options: [
      "Les crimes de violence",
      "Les délits économiques",
      "Les infractions au code de la route",
    ],
    answer: "Les infractions au code de la route",
    explanation:
        "Les infractions au code de la route constituent une grande partie des délits traités par la police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Comment s'appelle le groupe d'intervention de la gendarmerie nationale ?",
    options: ["GIGN", "RAID", "BRI"],
    answer: "GIGN",
    explanation:
        "Le GIGN est le Groupe d'Intervention de la Gendarmerie Nationale, spécialisé dans les interventions à risque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est l'une des compétences clés des policiers en matière d'enquête ?",
    options: [
      "Rédaction de rapports",
      "Maîtrise des langues",
      "Compétences en informatique",
    ],
    answer: "Rédaction de rapports",
    explanation:
        "La rédaction de rapports clairs et précis est essentielle pour documenter les enquêtes policières.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le but des patrouilles de police de nuit ?",
    options: [
      "Dissuader le crime",
      "Contrôler la circulation",
      "Fournir une aide sociale",
    ],
    answer: "Dissuader le crime",
    explanation:
        "Les patrouilles de nuit servent principalement à dissuader la criminalité en montrant une présence policière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel phénomène la police nationale essaie-t-elle de réduire par ses actions ?",
    options: ["Le chômage", "La délinquance", "L'urbanisation"],
    answer: "La délinquance",
    explanation:
        "La police nationale s'engage à réduire la délinquance pour assurer la sécurité publique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel critère est souvent utilisé pour recruter des policiers ?",
    options: [
      "L'âge minimum",
      "Le niveau d'études",
      "L'expérience professionnelle",
    ],
    answer: "Le niveau d'études",
    explanation:
        "Un certain niveau d'études est requis pour être recruté dans la police nationale, en fonction des postes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel organe décide des promotions au sein de la police nationale ?",
    options: [
      "La préfecture",
      "Le ministre de l'Intérieur",
      "Le conseil de discipline",
    ],
    answer: "Le ministre de l'Intérieur",
    explanation:
        "Le ministre de l'Intérieur a un rôle clé dans les décisions de promotion au sein de la police nationale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type de formation est requis pour intégrer la police nationale ?",
    options: [
      "Une formation militaire",
      "Une formation juridique",
      "Une formation spécialisée en police",
    ],
    answer: "Une formation spécialisée en police",
    explanation:
        "La formation spécialisée en police est essentielle pour acquérir les compétences nécessaires à un agent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal mode de transport utilisé par la police pour intervenir ?",
    options: ["Les voitures de patrouille", "Les motos", "Les vélos"],
    answer: "Les voitures de patrouille",
    explanation:
        "Les voitures de patrouille sont principalement utilisées par la police pour mener des interventions rapides.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quelle est la principale fonction des agents de circulation ?",
    options: [
      "Réguler le trafic",
      "Appliquer les lois pénales",
      "Surveiller les comportements des piétons",
    ],
    answer: "Réguler le trafic",
    explanation:
        "Les agents de circulation ont pour mission de réguler le trafic routier et de veiller à la sécurité des usagers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal défi auquel la police est confrontée aujourd'hui ?",
    options: [
      "La cybersécurité",
      "La lutte contre le terrorisme",
      "La violence domestique",
    ],
    answer: "La lutte contre le terrorisme",
    explanation:
        "La lutte contre le terrorisme reste l'un des défis majeurs pour la police nationale aujourd'hui.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel type d'appareil est souvent utilisé pour surveiller des lieux publics ?",
    options: ["Les drones", "Les caméras de surveillance", "Les alarmes"],
    answer: "Les caméras de surveillance",
    explanation:
        "Les caméras de surveillance sont des outils couramment utilisés par la police pour monitorer des espaces publics.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle compétence est essentielle pour un policier lors des interventions ?",
    options: ["Négociation", "Langues étrangères", "Géographie"],
    answer: "Négociation",
    explanation:
        "La négociation est une compétence clé permettant de gérer des situations de crise de manière pacifique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Comment la police collecte-t-elle des témoignages lors d'un crime ?",
    options: [
      "Par des entretiens",
      "Par des enquêtes par téléphone",
      "Par des mails",
    ],
    answer: "Par des entretiens",
    explanation:
        "La collecte de témoignages se fait principalement par des entretiens directs avec les témoins.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel est le principal but des interventions policières en cas de manifestation ?",
    options: [
      "Protéger les biens",
      "Faciliter le dialogue",
      "Dissuader les comportements violents",
    ],
    answer: "Dissuader les comportements violents",
    explanation:
        "L'objectif principal est de maintenir l'ordre et de dissuader toute forme de violence durant les manifestations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel équipement est couramment porté par les policiers en intervention ?",
    options: ["Gilet pare-balles", "Lunettes de soleil", "Brassard lumineux"],
    answer: "Gilet pare-balles",
    explanation:
        "Le gilet pare-balles est un équipement essentiel pour la protection des policiers en intervention.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel droit est souvent mis en avant lors des enquêtes policières ?",
    options: [
      "Droit à l'information",
      "Droit à l'assistance d'un avocat",
      "Droit à la vie privée",
    ],
    answer: "Droit à l'assistance d'un avocat",
    explanation:
        "Le droit à l'assistance d'un avocat est un droit fondamental lors des enquêtes policières.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle autorité est responsable d'enquêter sur les violences commises par des policiers ?",
    options: [
      "Le procureur de la République",
      "Le ministre de l'Intérieur",
      "L'IGPN",
    ],
    answer: "L'IGPN",
    explanation:
        "L'IGPN (Inspection Générale de la Police Nationale) est chargée d'enquêter sur les violences policières.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'objectif d'une perquisition policière ?",
    options: [
      "Saisir des preuves",
      "Évaluer les dégâts",
      "Interroger des témoins",
    ],
    answer: "Saisir des preuves",
    explanation:
        "L'objectif principal d'une perquisition est de saisir des éléments de preuve liés à une enquête criminelle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la principale méthode de prévention de la criminalité ?",
    options: [
      "La sensibilisation du public",
      "L'augmentation des patrouilles",
      "La mise en place de caméras de surveillance",
    ],
    answer: "La sensibilisation du public",
    explanation:
        "La sensibilisation du public est une méthode proactive visant à prévenir la criminalité par l'information et l'éducation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est le lien entre la police et la justice ?",
    options: [
      "La police enquête pendant que la justice juge",
      "La police exécute les sentences judiciaires",
      "La police est indépendante de la justice",
    ],
    answer: "La police enquête pendant que la justice juge",
    explanation:
        "La police a pour rôle d'enquêter sur les crimes, tandis que la justice est responsable de juger les affaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est l'une des principales missions des brigades spécialisées, comme la BRI ?",
    options: [
      "Intervenir lors de fuites de gaz",
      "Traquer les fugitifs",
      "Gérer les situations de crise",
    ],
    answer: "Gérer les situations de crise",
    explanation:
        "Les brigades spécialisées comme la BRI sont formées pour gérer des situations de crise à haut risque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question: "Quel est l'impact de la vidéosurveillance sur la criminalité ?",
    options: ["Elle l'augmente", "Elle la réduit", "Elle n'a aucun impact"],
    answer: "Elle la réduit",
    explanation:
        "La vidéosurveillance est souvent associée à une réduction de la criminalité en dissuadant les individus de commettre des infractions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quelle est la durée moyenne d'une formation initiale pour devenir policier ?",
    options: ["6 mois", "1 an", "2 ans"],
    answer: "1 an",
    explanation:
        "La formation initiale pour devenir policier dure en moyenne 1 an pour acquérir les compétences nécessaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Police (culture pro)",
    question:
        "Quel rôle joue la police dans la prévention des accidents de la route ?",
    options: [
      "Éducation des conducteurs",
      "Contrôles de sobriété",
      "Surveillance des routes",
    ],
    answer: "Contrôles de sobriété",
    explanation:
        "La police effectue des contrôles de sobriété pour prévenir les accidents de la route liés à l'alcool ou aux drogues.",
    difficulty: "Moyenne",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizCultureGeneralePolice extends StatefulWidget {
  static const String routeName =
      '/gpx_exam/concours/culture_generale_police_securite';
  final String uid;
  final String email;

  const QuizCultureGeneralePolice({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCultureGeneralePolice> createState() =>
      _QuizCultureGeneralePoliceState();
}

class _QuizCultureGeneralePoliceState extends State<QuizCultureGeneralePolice>
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
        ? questionCulturePolice
        : questionCulturePolice
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
            'module_name': 'Culture générale - Police',
            'quiz_name': 'Quiz culture générale police',
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
      await _sb.from('quiz_culture_generale_police_pages').insert({
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
      debugPrint('❌ quiz_culture_generale_police_pages insert failed: $e');
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
