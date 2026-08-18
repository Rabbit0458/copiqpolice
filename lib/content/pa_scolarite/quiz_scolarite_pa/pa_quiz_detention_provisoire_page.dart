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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:copiqpolice/core/widgets/quiz_report_dialog.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart'
    show AppNotifier, AppSettingsController;
import 'package:copiqpolice/core/services/user_context_service.dart';

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

/// =============================================================
///  QUIZ — CADRE LÉGAL D’USAGE DES ARMES (art. L. 435-1
///  du Code de la sécurité intérieure + lien avec la légitime
///  défense art. 122-5 du Code pénal)
///
///  Remplace ton ancien tableau par celui-ci.
///  (tu peux bien sûr l’enrichir encore si besoin)
/// =============================================================
final List<QuizQuestion> questionsDetentionProvisoire = [
  // NOTIONS GÉNÉRALES
  const QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question: "La détention provisoire est une mesure de :",
    options: [
      "Peine d’emprisonnement définitive",
      "Incarcération dans une maison d’arrêt avant tout jugement",
      "Surveillance électronique au domicile",
    ],
    answer: "Incarcération dans une maison d’arrêt avant tout jugement",
    explanation:
        "La détention provisoire est une mesure d’incarcération avant jugement, exécutée en maison d’arrêt pour une personne mise en examen.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "À l’égard de quelle catégorie de personnes la détention provisoire peut-elle être prononcée ?",
    options: [
      "Toute personne simplement suspectée",
      "Toute personne condamnée en appel",
      "Uniquement la personne mise en examen",
    ],
    answer: "Uniquement la personne mise en examen",
    explanation:
        "Le texte précise que seule la personne mise en examen peut faire l’objet d’une détention provisoire : le simple suspect ou le témoin assisté n’y sont pas soumis.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "La détention provisoire est-elle la règle ou l’exception selon l’article 137 du C.P.P. ?",
    options: [
      "La règle pour les crimes et délits graves",
      "Une mesure exceptionnelle",
      "Une mesure automatique en cas de crime",
    ],
    answer: "Une mesure exceptionnelle",
    explanation:
        "L’article 137 du C.P.P. rappelle que la détention provisoire doit rester exceptionnelle et strictement encadrée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "Pourquoi la détention provisoire est-elle difficilement compatible avec la présomption d’innocence ?",
    options: [
      "Parce qu’elle suppose déjà la culpabilité",
      "Parce qu’elle cause un préjudice grave et est perçue comme une culpabilité par l’opinion publique",
      "Parce qu’elle ne peut concerner que les récidivistes",
    ],
    answer:
        "Parce qu’elle cause un préjudice grave et est perçue comme une culpabilité par l’opinion publique",
    explanation:
        "Être incarcéré avant jugement fait supporter à la personne mise en examen le choc de l’emprisonnement et la réprobation publique, souvent assimilée à une présomption de culpabilité.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "Quels articles du C.P.P. encadrent principalement la détention provisoire ?",
    options: [
      "Articles 100 à 120 du C.P.P.",
      "Articles 137 à 137-4 et 143-1 à 150 du C.P.P.",
      "Articles 221 à 230 du C.P.P.",
    ],
    answer: "Articles 137 à 137-4 et 143-1 à 150 du C.P.P.",
    explanation:
        "Le support indique que la détention provisoire est régie par les articles 137 à 137-4 et 143-1 à 150 du Code de procédure pénale.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question: "La détention provisoire peut-elle être assimilée à une peine ?",
    options: [
      "Oui, car elle se déroule en maison d’arrêt",
      "Non, c’est une mesure de sûreté ou d’instruction",
      "Oui, pour les délits mais pas pour les crimes",
    ],
    answer: "Non, c’est une mesure de sûreté ou d’instruction",
    explanation:
        "La détention provisoire n’est pas une peine mais une mesure de sûreté, décidée pour les besoins de l’instruction ou pour prévenir certains risques.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "Quel principe doit toujours guider le choix entre contrôle judiciaire, assignation à résidence avec bracelet électronique et détention provisoire ?",
    options: [
      "Le principe de proportionnalité et de nécessité",
      "Le principe du contradictoire",
      "Le principe de publicité des débats",
    ],
    answer: "Le principe de proportionnalité et de nécessité",
    explanation:
        "La détention provisoire doit être l’ultime recours, lorsque les obligations du contrôle judiciaire ou de l’assignation à résidence avec surveillance électronique sont insuffisantes.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "Parmi les propositions suivantes, quelle affirmation est exacte concernant la détention provisoire ?",
    options: [
      "Elle peut être décidée pour une simple contravention",
      "Elle n’est possible que si la personne a été mise en examen",
      "Elle peut s’appliquer à un témoin assisté",
    ],
    answer: "Elle n’est possible que si la personne a été mise en examen",
    explanation:
        "Le texte rappelle clairement que seule une personne mise en examen peut être placée en détention provisoire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "La détention provisoire peut-elle avoir pour seule finalité de faire pression sur la personne mise en examen pour qu’elle avoue ?",
    options: [
      "Oui, si les preuves sont faibles",
      "Non, ce serait contraire aux textes et aux droits de la défense",
      "Oui, uniquement sur décision du procureur",
    ],
    answer: "Non, ce serait contraire aux textes et aux droits de la défense",
    explanation:
        "La détention provisoire ne peut servir à obtenir des aveux ; ses finalités sont strictement encadrées par l’article 144 du C.P.P.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "L’opinion publique peut-elle justifier à elle seule le placement en détention provisoire ?",
    options: [
      "Oui, si l’affaire est très médiatisée",
      "Non, l’indignation médiatique ne suffit jamais seule",
      "Oui, dès lors que la victime le demande",
    ],
    answer: "Non, l’indignation médiatique ne suffit jamais seule",
    explanation:
        "Même si le trouble à l’ordre public est pris en compte, l’émotion médiatique ne peut justifier à elle seule la détention provisoire.",
    difficulty: "Difficile",
  ),

  // CONDITIONS DU PLACEMENT — PERSONNE ET NATURE DE L’INFRACTION
  const QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question: "Qui ne peut jamais faire l’objet d’une détention provisoire ?",
    options: [
      "La personne simplement placée en garde à vue",
      "La personne mise en examen",
      "La personne condamnée en appel",
    ],
    answer: "La personne simplement placée en garde à vue",
    explanation:
        "La détention provisoire ne concerne que la personne mise en examen et suppose la saisine du juge d’instruction puis du juge des libertés et de la détention.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "Selon les conditions tenant à la nature de l’infraction, la détention provisoire est possible :",
    options: [
      "En cas de crime ou délit puni d’au moins 3 ans d’emprisonnement",
      "En cas de simple contravention",
      "Uniquement pour les crimes",
    ],
    answer: "En cas de crime ou délit puni d’au moins 3 ans d’emprisonnement",
    explanation:
        "Le document précise que la détention provisoire peut être décidée en cas de crime ou de délit puni d’au moins 3 ans d’emprisonnement.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "La détention provisoire peut aussi être décidée lorsque la personne mise en examen :",
    options: [
      "Refuse d’être entendue par les enquêteurs",
      "Se soustrait volontairement aux obligations du contrôle judiciaire ou de l’assignation à résidence avec surveillance électronique",
      "N’a pas payé l’amende de composition pénale",
    ],
    answer:
        "Se soustrait volontairement aux obligations du contrôle judiciaire ou de l’assignation à résidence avec surveillance électronique",
    explanation:
        "En cas de non-respect volontaire de ces obligations, la détention provisoire peut être ordonnée pour assurer l’efficacité du contrôle.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "La détention provisoire ne peut être ordonnée ou prolongée que si elle constitue :",
    options: [
      "L’unique moyen d’atteindre certains objectifs légalement prévus",
      "Une mesure de confort pour l’enquête",
      "Un moyen de faire pression sur la famille de la personne mise en examen",
    ],
    answer: "L’unique moyen d’atteindre certains objectifs légalement prévus",
    explanation:
        "L’article 144 du C.P.P. prévoit que la détention provisoire ne peut être décidée que si elle constitue le seul moyen d’atteindre un des objectifs énumérés par la loi.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "Lequel des objectifs suivants figure parmi ceux permettant de justifier la détention provisoire selon l’art. 144 C.P.P. ?",
    options: [
      "Assurer le paiement des dommages et intérêts à la victime",
      "Conserver les preuves ou les indices matériels nécessaires à la manifestation de la vérité",
      "Assurer l’exécution de la future peine d’emprisonnement",
    ],
    answer:
        "Conserver les preuves ou les indices matériels nécessaires à la manifestation de la vérité",
    explanation:
        "L’un des objectifs légaux de la détention provisoire est de garantir la conservation des preuves ou indices matériels.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "Empêcher une pression sur les témoins ou les victimes ainsi que sur leur famille est :",
    options: [
      "Un objectif légal possible de la détention provisoire",
      "Un objectif interdit par la loi",
      "Une conséquence uniquement de la peine définitive",
    ],
    answer: "Un objectif légal possible de la détention provisoire",
    explanation:
        "L’article 144 C.P.P. mentionne expressément la nécessité d’empêcher les pressions sur témoins ou victimes comme raison possible d’ordonner la détention provisoire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "Quel objectif concerne spécifiquement la protection de la personne mise en examen ?",
    options: [
      "Empêcher la concertation frauduleuse",
      "Protéger le mis en examen, notamment en cas de crime odieux",
      "Éviter la récidive après condamnation",
    ],
    answer: "Protéger le mis en examen, notamment en cas de crime odieux",
    explanation:
        "L’article 144 4° C.P.P. permet la détention pour protéger la personne mise en examen, par exemple contre des mouvements populaires dangereux en cas de crime odieux.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "La détention provisoire peut être ordonnée pour garantir la mise à disposition de la justice de la personne mise en examen :",
    options: [
      "Uniquement si elle n’a pas de domicile fixe ou risque de s’enfuir",
      "Dans tous les cas, même lorsqu’elle a des attaches stables",
      "Seulement si la victime s’y oppose",
    ],
    answer: "Uniquement si elle n’a pas de domicile fixe ou risque de s’enfuir",
    explanation:
        "Le texte précise que cet objectif concerne notamment les personnes sans domicile ou celles dont on peut craindre la fuite.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "Mettre fin à une infraction ou éviter son renouvellement constitue :",
    options: [
      "Un des objectifs prévus à l’article 144 C.P.P.",
      "Une conséquence de la peine seulement",
      "Un motif purement disciplinaire",
    ],
    answer: "Un des objectifs prévus à l’article 144 C.P.P.",
    explanation:
        "L’article 144 permet la détention pour mettre fin à une infraction en cours ou éviter qu’elle se renouvelle.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "Le trouble exceptionnel et persistant à l’ordre public causé par l’infraction peut-il justifier une détention provisoire ?",
    options: [
      "Oui, à condition qu’il soit d’une gravité particulière et apprécié strictement",
      "Non, il est toujours sans incidence",
      "Oui, mais uniquement en matière contraventionnelle",
    ],
    answer:
        "Oui, à condition qu’il soit d’une gravité particulière et apprécié strictement",
    explanation:
        "L’article 144 7° C.P.P. prévoit que le trouble à l’ordre public résultant de l’infraction peut justifier la détention, mais seulement en matière criminelle et sous conditions strictes.",
    difficulty: "Difficile",
  ),

  // JUGE DES LIBERTÉS ET DE LA DÉTENTION — PLACEMENT
  const QuizQuestion(
    category: "Détention provisoire — Juge des libertés et de la détention",
    question:
        "Quel magistrat est compétent pour décider du placement en détention provisoire ?",
    options: [
      "Le procureur de la République",
      "Le juge des libertés et de la détention",
      "Le juge de proximité",
    ],
    answer: "Le juge des libertés et de la détention",
    explanation:
        "La décision de placement en détention provisoire revient au juge des libertés et de la détention (J.L.D.), saisi par le juge d’instruction.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Juge des libertés et de la détention",
    question:
        "Le J.L.D. peut-il se saisir d’office pour décider d’une détention provisoire ?",
    options: [
      "Oui, en cas d’urgence",
      "Non, il est toujours saisi par le juge d’instruction ou le procureur de la République",
      "Oui, s’il estime le contrôle judiciaire insuffisant",
    ],
    answer:
        "Non, il est toujours saisi par le juge d’instruction ou le procureur de la République",
    explanation:
        "Le document précise que le J.L.D. ne dispose d’aucune possibilité de se saisir d’office : il est toujours saisi par le juge d’instruction ou le procureur.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Juge des libertés et de la détention",
    question:
        "Dans quelles hypothèses le juge d’instruction peut-il saisir le J.L.D. pour un placement en détention ?",
    options: [
      "Uniquement lors du premier interrogatoire de première comparution",
      "Lors du placement initial ou lors de la prolongation de la détention",
      "Seulement à la demande de la victime",
    ],
    answer:
        "Lors du placement initial ou lors de la prolongation de la détention",
    explanation:
        "Le J.L.D. intervient lors du placement initial ou pour prolonger la détention à la demande du juge d’instruction ou du procureur.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Juge des libertés et de la détention",
    question: "À peine de nullité, le J.L.D. ne peut pas :",
    options: [
      "Rendre une ordonnance écrite",
      "Participer au jugement des affaires dont il a connu au stade de la détention provisoire",
      "Entendre la personne mise en examen en audience publique",
    ],
    answer:
        "Participer au jugement des affaires dont il a connu au stade de la détention provisoire",
    explanation:
        "Pour garantir l’impartialité, le J.L.D. ne peut pas ensuite siéger dans la formation de jugement des mêmes faits.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Juge des libertés et de la détention",
    question:
        "La saisine du J.L.D. pour un placement en détention provisoire en matière criminelle se fait :",
    options: [
      "Par ordonnance motivée du juge d’instruction accompagnée des réquisitions du procureur de la République",
      "Par simple demande orale de la victime",
      "Par procès-verbal de l’officier de police judiciaire",
    ],
    answer:
        "Par ordonnance motivée du juge d’instruction accompagnée des réquisitions du procureur de la République",
    explanation:
        "L’article 137-1 C.P.P. prévoit cette procédure formalisée pour garantir les droits de la défense.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Juge des libertés et de la détention",
    question:
        "En matière délictuelle, pour les délits punis de moins de 10 ans d’emprisonnement, le procureur de la République peut-il saisir directement le J.L.D. ?",
    options: [
      "Oui, malgré le refus de transmission du juge d’instruction",
      "Non, seule la victime le peut",
      "Non, uniquement le juge d’instruction peut saisir le J.L.D.",
    ],
    answer: "Oui, malgré le refus de transmission du juge d’instruction",
    explanation:
        "Le texte prévoit cette possibilité en cas de désaccord avec le juge d’instruction, afin que le J.L.D. statue.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Juge des libertés et de la détention",
    question:
        "Que doit contenir l’ordonnance de placement en détention provisoire rendue par le J.L.D. ?",
    options: [
      "Uniquement l’identité de la personne mise en examen",
      "L’énoncé des conditions de droit et de fait justifiant la détention et l’indication du caractère insuffisant des autres mesures",
      "Uniquement la durée prévue de détention",
    ],
    answer:
        "L’énoncé des conditions de droit et de fait justifiant la détention et l’indication du caractère insuffisant des autres mesures",
    explanation:
        "L’article 137-3 C.P.P. impose une motivation précise, notamment sur l’insuffisance du contrôle judiciaire ou de l’assignation à résidence.",
    difficulty: "Difficile",
  ),

  // CHAMBRE DE L’INSTRUCTION — PLACEMENT
  const QuizQuestion(
    category: "Détention provisoire — Chambre de l’instruction",
    question:
        "La chambre de l’instruction peut-elle ordonner un placement en détention provisoire ?",
    options: [
      "Oui, elle peut placer ou maintenir la personne sous contrôle judiciaire uniquement",
      "Oui, elle peut ordonner la détention ou le contrôle judiciaire de la personne mise en examen",
      "Non, elle ne statue que sur les appels",
    ],
    answer:
        "Oui, elle peut ordonner la détention ou le contrôle judiciaire de la personne mise en examen",
    explanation:
        "L’article 201 C.P.P. permet à la chambre de l’instruction d’ordonner un acte utile, dont le placement en détention ou sous contrôle judiciaire.",
    difficulty: "Moyenne",
  ),

  // DURÉE DE LA DÉTENTION PROVISOIRE — RÈGLES GÉNÉRALES
  const QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "Selon l’article 144-1 du C.P.P., la détention provisoire ne peut excéder une durée raisonnable appréciée :",
    options: [
      "Uniquement en fonction de la personnalité du mis en examen",
      "Au regard de la gravité des faits reprochés, de la complexité des investigations et du délai nécessaire à la manifestation de la vérité",
      "Uniquement en fonction de la surcharge des juridictions",
    ],
    answer:
        "Au regard de la gravité des faits reprochés, de la complexité des investigations et du délai nécessaire à la manifestation de la vérité",
    explanation:
        "Le magistrat doit apprécier la durée à partir de ces critères cumulatifs pour garantir une détention raisonnable.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "En matière correctionnelle, la durée initiale maximale de la détention provisoire est en principe de :",
    options: ["2 mois", "4 mois", "1 an"],
    answer: "4 mois",
    explanation:
        "Le tableau et l’article 145-1 C.P.P. indiquent que, sauf exceptions, la durée initiale de la détention en matière correctionnelle est de 4 mois.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "Toujours en matière correctionnelle, la durée maximale de la détention provisoire, après prolongations possibles, ne peut excéder :",
    options: ["4 mois", "6 mois", "2 ans"],
    answer: "6 mois",
    explanation:
        "En droit commun, en matière correctionnelle, la détention provisoire ne peut excéder 6 mois (article 145-1 C.P.P.), sauf hypothèses spécifiques (bandes organisées, etc.).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "En matière criminelle, hors régimes spéciaux, la durée initiale maximale de détention provisoire est de :",
    options: ["4 mois", "6 mois", "1 an"],
    answer: "1 an",
    explanation:
        "Le tableau « crimes » indique une durée initiale d’un an, avec possibilité de prolongations dans les limites prévues par l’article 145-2 C.P.P.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "Pour un crime de droit commun, la durée maximale totale de détention provisoire (initiale + prolongations) est en principe de :",
    options: ["2 ans", "3 ans", "4 ans"],
    answer: "2 ans",
    explanation:
        "Le tableau sur les crimes prévoit, pour certains crimes de droit commun, une durée totale maximale de 2 ans, sous réserve des régimes aggravés.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "La détention provisoire peut-elle dépasser 4 ans en matière criminelle ?",
    options: [
      "Non, jamais",
      "Oui, jusqu’à 4 ans et 8 mois dans certains cas prévus de criminalité organisée",
      "Oui, sans limite si l’enquête est complexe",
    ],
    answer:
        "Oui, jusqu’à 4 ans et 8 mois dans certains cas prévus de criminalité organisée",
    explanation:
        "Le tableau mentionne que, dans certains cas (criminalité organisée, atteintes graves), les durées peuvent être prolongées exceptionnellement jusqu’à 4 ans et 8 mois.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "Pour les délits commis en bande organisée punis d’au moins 10 ans d’emprisonnement (trafic de stupéfiants, proxénétisme aggravé, etc.), la durée de détention correctionnelle peut atteindre :",
    options: ["6 mois au maximum", "1 an au maximum", "2 ans au maximum"],
    answer: "2 ans au maximum",
    explanation:
        "Pour ces délits spécifiques, l’article 145-1-1 C.P.P. permet de porter la détention provisoire jusqu’à 2 ans.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "Lorsque la chambre de l’instruction est saisie pour une procédure de « mise en état » (art. 221-3 C.P.P.), l’un de ses pouvoirs est notamment :",
    options: [
      "Prononcer la nullité d’un ou plusieurs actes",
      "Modifier la peine déjà prononcée",
      "Valider les perquisitions domiciliaires sans débat",
    ],
    answer: "Prononcer la nullité d’un ou plusieurs actes",
    explanation:
        "Le texte mentionne que la chambre de l’instruction peut, par exemple, prononcer la nullité d’actes de procédure ou ordonner le règlement de l’affaire.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "Le dépassement des délais pour statuer sur une demande de mise en liberté entraîne :",
    options: [
      "La prolongation automatique de la détention",
      "La mise en liberté de plein droit",
      "L’irrecevabilité de la demande suivante",
    ],
    answer: "La mise en liberté de plein droit",
    explanation:
        "Le texte indique que l’inobservation des délais pour statuer sur les demandes de mise en liberté entraîne une mise en liberté automatique (de plein droit).",
    difficulty: "Moyenne",
  ),

  // PROLONGATION DE LA DÉTENTION PROVISOIRE
  const QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "De qui relève la décision de prolonger la détention provisoire ?",
    options: [
      "Du procureur de la République",
      "Du juge des libertés et de la détention, saisi par le juge d’instruction",
      "Du chef d’établissement pénitentiaire",
    ],
    answer:
        "Du juge des libertés et de la détention, saisi par le juge d’instruction",
    explanation:
        "La prolongation est décidée par ordonnance motivée du J.L.D., saisi par le juge d’instruction, qui transmet le dossier accompagné des réquisitions du parquet.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "Toute prolongation de détention provisoire doit se faire après :",
    options: [
      "Une audience contradictoire devant le J.L.D. ou la chambre de l’instruction",
      "Une simple note de service du juge d’instruction",
      "Une demande écrite de la victime",
    ],
    answer:
        "Une audience contradictoire devant le J.L.D. ou la chambre de l’instruction",
    explanation:
        "Le principe du contradictoire impose qu’une prolongation de détention soit décidée après débat entre les parties.",
    difficulty: "Moyenne",
  ),

  // FIN DE LA DÉTENTION PROVISOIRE — RÈGLEMENT DE LA PROCÉDURE
  const QuizQuestion(
    category: "Détention provisoire — Fin de la détention provisoire",
    question: "La détention provisoire prend fin automatiquement en cas :",
    options: [
      "De non-lieu ou de requalification des faits en contravention ne relevant plus de l’article 144 C.P.P.",
      "De désaccord entre le juge d’instruction et le parquet",
      "De condamnation en première instance",
    ],
    answer:
        "De non-lieu ou de requalification des faits en contravention ne relevant plus de l’article 144 C.P.P.",
    explanation:
        "Le chapitre 3 rappelle que la détention provisoire cesse lorsque la procédure aboutit à un non-lieu ou que les faits ne justifient plus une telle mesure.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Fin de la détention provisoire",
    question:
        "En cas de renvoi devant le tribunal correctionnel, l’ordonnance de renvoi :",
    options: [
      "Met obligatoirement fin à la détention provisoire",
      "Peut maintenir la détention jusqu’à la comparution devant le tribunal par ordonnance spécialement motivée",
      "Doit toujours transformer la détention en contrôle judiciaire",
    ],
    answer:
        "Peut maintenir la détention jusqu’à la comparution devant le tribunal par ordonnance spécialement motivée",
    explanation:
        "L’article 179 C.P.P. précise que le juge de l’instruction peut maintenir l’intéressé en détention jusqu’à l’audience, si sa décision est spécialement motivée.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Fin de la détention provisoire",
    question:
        "En cas de renvoi devant la cour d’assises, la détention provisoire :",
    options: [
      "Prend fin dès l’ordonnance de mise en accusation",
      "Peut être maintenue jusqu’à la comparution devant la cour, sur décision de la chambre de l’instruction",
      "Doit être transformée en assignation à résidence",
    ],
    answer:
        "Peut être maintenue jusqu’à la comparution devant la cour, sur décision de la chambre de l’instruction",
    explanation:
        "L’article 181 C.P.P. prévoit que la chambre de l’instruction peut ordonner le maintien en détention jusqu’à l’audience d’assises.",
    difficulty: "Difficile",
  ),

  // DEMANDES DE MISE EN LIBERTÉ — RÈGLES GÉNÉRALES
  const QuizQuestion(
    category: "Détention provisoire — Demandes de mise en liberté",
    question:
        "Selon l’article 148 C.P.P., qui peut demander à tout moment la mise en liberté de la personne détenue ?",
    options: [
      "Uniquement le procureur de la République",
      "La personne mise en examen ou son avocat",
      "Seulement la victime ou la partie civile",
    ],
    answer: "La personne mise en examen ou son avocat",
    explanation:
        "La mise en liberté peut être demandée à tout moment par l’intéressé ou par son conseil.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Demandes de mise en liberté",
    question:
        "Après renvoi devant une juridiction de jugement, l’intéressé peut demander sa mise en liberté :",
    options: [
      "Uniquement pendant l’audience",
      "À tout moment de la procédure devant la juridiction de jugement",
      "Uniquement par l’intermédiaire du parquet",
    ],
    answer: "À tout moment de la procédure devant la juridiction de jugement",
    explanation:
        "L’article 148-2 C.P.P. prévoit que, après renvoi, la demande de mise en liberté est portée devant la juridiction de jugement compétente.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Demandes de mise en liberté",
    question:
        "Lorsque le juge d’instruction reçoit une demande de mise en liberté, il doit :",
    options: [
      "La transmettre immédiatement au procureur de la République pour réquisitions",
      "La rejeter systématiquement",
      "La renvoyer au J.L.D. sans avis",
    ],
    answer:
        "La transmettre immédiatement au procureur de la République pour réquisitions",
    explanation:
        "Le magistrat instructeur recueille l’avis du parquet avant de statuer ou de transmettre au juge des libertés et de la détention.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Demandes de mise en liberté",
    question: "Si le juge d’instruction refuse la mise en liberté, il doit :",
    options: [
      "Rendre une ordonnance motivée susceptible d’appel",
      "Simplement informer le chef d’établissement pénitentiaire",
      "Renvoyer d’office l’affaire devant la cour d’assises",
    ],
    answer: "Rendre une ordonnance motivée susceptible d’appel",
    explanation:
        "En cas de rejet, sa décision doit être motivée et peut être déférée à la chambre de l’instruction.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Demandes de mise en liberté",
    question:
        "Quand la chambre de l’instruction est saisie d’une demande de mise en liberté, elle doit statuer :",
    options: [
      "Dans un délai de 30 jours à compter de la réception de la demande",
      "Dans un délai de 24 heures",
      "Sans aucun délai légal",
    ],
    answer: "Dans un délai de 30 jours à compter de la réception de la demande",
    explanation:
        "Le texte précise que la chambre de l’instruction dispose de 30 jours pour statuer, sous peine de mise en liberté de plein droit en cas de dépassement des délais.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Demandes de mise en liberté",
    question:
        "En cas de carence du juge des libertés et de la détention qui n’a pas statué dans les 5 jours ouvrables, la demande de mise en liberté est portée :",
    options: [
      "Devant la chambre de l’instruction",
      "Devant le juge de proximité",
      "Devant le tribunal de police",
    ],
    answer: "Devant la chambre de l’instruction",
    explanation:
        "L’article 148-4 C.P.P. prévoit un mécanisme de « dessaisissement » automatique au profit de la chambre de l’instruction.",
    difficulty: "Difficile",
  ),

  // MISE EN LIBERTÉ DE PLEIN DROIT / D’OFFICE
  const QuizQuestion(
    category: "Détention provisoire — Mise en liberté de plein droit",
    question:
        "À l’expiration de la durée légale de détention provisoire, prolongations comprises, la mise en liberté :",
    options: [
      "Est laissée à l’appréciation du juge",
      "Est automatique (de plein droit)",
      "N’est possible qu’à la demande de la victime",
    ],
    answer: "Est automatique (de plein droit)",
    explanation:
        "L’article 148-1-1 C.P.P. prévoit que la fin de la durée maximale entraîne la libération de plein droit de la personne détenue.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Mise en liberté de plein droit",
    question:
        "Quelle conséquence entraîne l’inobservation des délais pour statuer sur une demande de mise en liberté ?",
    options: [
      "La nullité de la demande",
      "La mise en liberté de plein droit",
      "La prolongation de 4 mois de la détention",
    ],
    answer: "La mise en liberté de plein droit",
    explanation:
        "Le non-respect des délais est sanctionné par une libération automatique, sans nouvelle décision de détention.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Mise en liberté d’office",
    question: "La mise en liberté d’office peut être décidée :",
    options: [
      "Par le juge d’instruction ou la chambre de l’instruction, même sans demande de l’intéressé",
      "Uniquement à la demande du mis en examen",
      "Uniquement par le procureur général",
    ],
    answer:
        "Par le juge d’instruction ou la chambre de l’instruction, même sans demande de l’intéressé",
    explanation:
        "Le texte évoque une mise en liberté décidée d’office lorsque la détention n’apparaît plus nécessaire à la bonne marche de l’information.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Mise en liberté d’office",
    question:
        "Avant d’ordonner une mise en liberté d’office, le juge d’instruction doit :",
    options: [
      "Obtenir l’accord de la victime",
      "Demander obligatoirement l’avis du procureur de la République",
      "Saisir le Conseil supérieur de la magistrature",
    ],
    answer: "Demander obligatoirement l’avis du procureur de la République",
    explanation:
        "La loi impose au juge d’instruction de recueillir l’avis du parquet avant de décider la mise en liberté d’office.",
    difficulty: "Difficile",
  ),

  // MISE EN LIBERTÉ POUR RAISONS DE SANTÉ
  const QuizQuestion(
    category: "Détention provisoire — Mise en liberté pour raison de santé",
    question:
        "La mise en liberté pour raison de santé peut être ordonnée lorsqu’une expertise médicale établit que :",
    options: [
      "La personne refuse de se soigner",
      "La personne est atteinte d’une pathologie engageant le pronostic vital ou que son état de santé est incompatible avec la détention",
      "La personne est simplement fatiguée par la détention",
    ],
    answer:
        "La personne est atteinte d’une pathologie engageant le pronostic vital ou que son état de santé est incompatible avec la détention",
    explanation:
        "L’article 147-1 C.P.P. prévoit la mise en liberté lorsque l’état de santé physique ou mentale est incompatible avec la détention provisoire.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Mise en liberté pour raison de santé",
    question:
        "La mise en liberté pour raison de santé peut-elle être refusée en cas de risque grave de renouvellement de l’infraction ?",
    options: [
      "Non, la santé prime toujours sur la sécurité publique",
      "Oui, si le risque de récidive est grave et établi",
      "Non, dès l’instant où l’expert conclut à l’incompatibilité",
    ],
    answer: "Oui, si le risque de récidive est grave et établi",
    explanation:
        "Le texte prévoit une exception à la mise en liberté sanitaire en cas de risque grave de renouvellement de l’infraction.",
    difficulty: "Difficile",
  ),

  // RÉPARATION D’UNE DÉTENTION PROVISOIRE INJUSTIFIÉE
  const QuizQuestion(
    category: "Détention provisoire — Réparation",
    question:
        "Selon l’article 149 C.P.P., qui peut prétendre à une réparation pour détention provisoire injustifiée ?",
    options: [
      "La personne ayant bénéficié d’un non-lieu, d’une relaxe ou d’un acquittement définitif",
      "Uniquement la victime de l’infraction",
      "Toute personne ayant été condamnée à une peine inférieure au temps de détention provisoire",
    ],
    answer:
        "La personne ayant bénéficié d’un non-lieu, d’une relaxe ou d’un acquittement définitif",
    explanation:
        "Le dispositif d’indemnisation vise la personne injustement détenue qui est finalement mise hors de cause.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Réparation",
    question:
        "L’indemnisation pour détention provisoire injustifiée est accordée :",
    options: [
      "Par le premier président de la cour d’appel",
      "Par le juge d’instruction",
      "Par le J.L.D.",
    ],
    answer: "Par le premier président de la cour d’appel",
    explanation:
        "C’est le premier président de la cour d’appel qui statue sur la demande d’indemnisation présentée par l’ancien détenu.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Réparation",
    question: "La réparation d’une détention provisoire injustifiée couvre :",
    options: [
      "Uniquement le préjudice matériel",
      "Uniquement le préjudice moral",
      "Le préjudice matériel et le préjudice moral",
    ],
    answer: "Le préjudice matériel et le préjudice moral",
    explanation:
        "L’article 149 C.P.P. vise l’indemnisation du préjudice matériel et moral causé par la détention injustifiée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Réparation",
    question:
        "Certaines personnes sont exclues du droit à indemnisation pour détention provisoire injustifiée, notamment :",
    options: [
      "Le dénonciateur de mauvaise foi et le faux témoin ayant provoqué la détention",
      "Les personnes sans domicile fixe",
      "Les personnes condamnées pour d’autres infractions",
    ],
    answer:
        "Le dénonciateur de mauvaise foi et le faux témoin ayant provoqué la détention",
    explanation:
        "Le texte précise que quelques cas sont exclus, notamment lorsque la détention est la conséquence d’une fraude ou d’une faute grave imputable au demandeur.",
    difficulty: "Difficile",
  ),

  // TABLEAU DÉLITS — APPLICATION CHIFFRÉE (CAS PRATIQUES)
  const QuizQuestion(
    category: "Détention provisoire — Tableaux délits",
    question:
        "Un mis en examen pour un délit puni de 3 ans d’emprisonnement encourt au maximum, en matière correctionnelle de droit commun, une détention provisoire de :",
    options: ["4 mois", "6 mois", "1 an"],
    answer: "6 mois",
    explanation:
        "Pour les délits punis de 3 ans, le régime de droit commun s’applique : 4 mois initiaux, éventuellement prolongés, dans la limite totale de 6 mois.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Tableaux délits",
    question:
        "Pour un délit puni de 7 ans d’emprisonnement mais ne relevant pas de la criminalité organisée, la durée initiale de détention provisoire est de :",
    options: ["4 mois", "6 mois", "1 an"],
    answer: "4 mois",
    explanation:
        "Le tableau « délits » fixe une durée initiale de 4 mois en matière correctionnelle, quelle que soit la peine encourue, sauf régimes spéciaux.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Tableaux délits",
    question:
        "Pour un délit de trafic de stupéfiants commis en bande organisée, puni de 10 ans, la durée maximale de détention provisoire peut atteindre :",
    options: ["6 mois", "1 an", "2 ans"],
    answer: "2 ans",
    explanation:
        "Les délits commis en bande organisée punis d’au moins 10 ans relèvent du régime aggravé de l’article 145-1-1 C.P.P., permettant 2 ans de détention.",
    difficulty: "Difficile",
  ),

  // TABLEAU CRIMES — APPLICATION CHIFFRÉE
  const QuizQuestion(
    category: "Détention provisoire — Tableaux crimes",
    question:
        "Pour un crime puni de 20 ans de réclusion criminelle, la durée initiale de détention provisoire est de :",
    options: ["4 mois", "6 mois", "1 an"],
    answer: "1 an",
    explanation:
        "Le tableau « crimes » indique une durée initiale d’un an, quelle que soit la peine encourue, avec des prolongations ensuite encadrées.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Tableaux crimes",
    question:
        "Pour certains crimes graves, la durée totale maximale de détention provisoire peut atteindre 3 ans. Cela suppose :",
    options: [
      "Plusieurs prolongations successives décidées par la chambre de l’instruction",
      "Une simple ordonnance du procureur",
      "Une demande écrite de la victime",
    ],
    answer:
        "Plusieurs prolongations successives décidées par la chambre de l’instruction",
    explanation:
        "Le tableau prévoit des durées maximales (2 ans, 3 ans, 4 ans) atteintes par des prolongations successives, toujours motivées et décidées après débat.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Tableaux crimes",
    question:
        "Dans les hypothèses les plus graves prévues par le C.P.P. (criminalité organisée, terrorisme…), la durée totale de détention provisoire peut aller jusqu’à :",
    options: ["2 ans", "3 ans", "4 ans et 8 mois"],
    answer: "4 ans et 8 mois",
    explanation:
        "Le tableau des crimes mentionne cette durée maximale exceptionnelle pour certaines infractions particulièrement graves.",
    difficulty: "Difficile",
  ),

  // CAS PRATIQUES — MISE EN SITUATION
  const QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Un individu est mis en examen pour un délit puni de 2 ans d’emprisonnement. Peut-il être placé en détention provisoire ?",
    options: [
      "Oui, car toute peine d’emprisonnement autorise la détention",
      "Non, car le délit n’est pas puni d’au moins 3 ans d’emprisonnement",
      "Oui, uniquement si la victime est d’accord",
    ],
    answer:
        "Non, car le délit n’est pas puni d’au moins 3 ans d’emprisonnement",
    explanation:
        "La condition légale impose un crime ou un délit puni d’au moins 3 ans d’emprisonnement.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Une personne mise en examen respecte toutes les obligations de son contrôle judiciaire, mais l’affaire est très médiatisée. Le seul motif avancé est l’apaisement du trouble à l’ordre public. La détention provisoire est-elle possible en matière délictuelle ?",
    options: [
      "Oui, le trouble à l’ordre public suffit",
      "Non, le trouble à l’ordre public n’est pris en compte que dans certains cas, notamment en matière criminelle",
      "Oui, si la victime le demande",
    ],
    answer:
        "Non, le trouble à l’ordre public n’est pris en compte que dans certains cas, notamment en matière criminelle",
    explanation:
        "Le trouble exceptionnel et persistant à l’ordre public est un motif principalement admis en matière criminelle et apprécié strictement.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Un mis en examen est sans domicile fixe et n’a pas de attaches stables. Quel objectif de l’article 144 peut justifier sa détention provisoire ?",
    options: [
      "Protéger les témoins",
      "Garantir sa mise à disposition de la justice et prévenir le risque de fuite",
      "Assurer la réparation du préjudice civil",
    ],
    answer:
        "Garantir sa mise à disposition de la justice et prévenir le risque de fuite",
    explanation:
        "L’absence d’attaches peut rendre nécessaire la détention pour garantir la présence de la personne aux actes de procédure.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Une personne mise en examen pour un crime est détenue depuis 8 mois. L’enquête est peu complexe et les principaux témoins ont déjà été entendus. Le juge souhaite prolonger la détention par simple crainte d’un émoi médiatique. Cette prolongation est-elle conforme aux principes de la détention provisoire ?",
    options: [
      "Oui, la durée reste inférieure à 1 an",
      "Non, car la détention doit rester raisonnable et répondre à un des objectifs strictement énumérés",
      "Oui, si le J.L.D. accepte",
    ],
    answer:
        "Non, car la détention doit rester raisonnable et répondre à un des objectifs strictement énumérés",
    explanation:
        "La simple crainte médiatique ne suffit pas et la durée doit être justifiée par les nécessités de l’instruction.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Un détenu dépose une demande de mise en liberté. Le juge des libertés et de la détention ne statue pas dans le délai de 5 jours ouvrables. Quelle est la conséquence ?",
    options: [
      "La demande est considérée comme rejetée",
      "L’affaire est portée devant la chambre de l’instruction",
      "La détention est automatiquement prolongée de 4 mois",
    ],
    answer: "L’affaire est portée devant la chambre de l’instruction",
    explanation:
        "Le mécanisme de dessaisissement prévoit la saisine de la chambre de l’instruction en cas de carence du J.L.D.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Un mis en examen détenu pour un délit punissable de 5 ans est toujours incarcéré après 7 mois de détention, sans régime aggravé applicable. Quelle est la situation ?",
    options: [
      "La détention est conforme, la durée maximale est de 2 ans",
      "La détention est irrégulière, la durée maximale était de 6 mois",
      "La durée maximale est de 1 an",
    ],
    answer: "La détention est irrégulière, la durée maximale était de 6 mois",
    explanation:
        "En matière correctionnelle de droit commun, la durée totale ne peut excéder 6 mois : il doit être remis en liberté de plein droit.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Une personne a bénéficié d’un non-lieu après 9 mois de détention provisoire. Elle souhaite obtenir réparation. Vers quelle autorité doit-elle se tourner ?",
    options: [
      "Le juge d’instruction",
      "Le premier président de la cour d’appel",
      "Le J.L.D.",
    ],
    answer: "Le premier président de la cour d’appel",
    explanation:
        "C’est lui qui est compétent pour statuer sur les demandes d’indemnisation pour détention injustifiée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Une expertise médicale conclut à l’incompatibilité de l’état psychique d’un détenu avec la détention, sans risque particulier de récidive. Quelle mesure doit être privilégiée ?",
    options: [
      "Le maintien en détention avec suivi médical",
      "La mise en liberté pour raison de santé",
      "La prolongation de la détention jusqu’au jugement",
    ],
    answer: "La mise en liberté pour raison de santé",
    explanation:
        "L’article 147-1 C.P.P. prévoit la mise en liberté lorsque la détention est incompatible avec l’état de santé, en l’absence de risque grave de renouvellement de l’infraction.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Une personne détenue voit sa demande de mise en liberté rejetée par le juge d’instruction. Quel recours peut-elle exercer ?",
    options: [
      "Un appel devant la chambre de l’instruction",
      "Un simple recours gracieux devant le même juge",
      "Aucun, la décision est définitive",
    ],
    answer: "Un appel devant la chambre de l’instruction",
    explanation:
        "Les ordonnances du juge d’instruction statuant sur la détention sont susceptibles d’appel devant la chambre de l’instruction.",
    difficulty: "Facile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizDetentionProvisoirePagePA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName =
      '/pa/procedure_penale/quiz/detention_provisoire';
  final String uid;
  final String email;

  const QuizDetentionProvisoirePagePA({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizDetentionProvisoirePagePA> createState() =>
      _QuizDetentionProvisoirePagePAState();
}

class _QuizDetentionProvisoirePagePAState
    extends State<QuizDetentionProvisoirePagePA>
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
  bool _showIntro = false;
  bool _hideIntroForever = false;
  static const _introHiddenKey = 'intro_pa_detention_provisoire';
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
    unawaited(_loadIntroPreference());
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
  // INTRO PREFERENCE
  // ==================================================================
  Future<void> _loadIntroPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _hideIntroForever = prefs.getBool(_introHiddenKey) ?? false);
  }

  Future<void> _saveIntroPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_introHiddenKey, value);
    if (mounted) setState(() => _hideIntroForever = value);
  }

  // ==================================================================
  // HELPERS
  // ==================================================================
  void _seedAndShuffle() {
    final useAll = _mixMode || _selectedDifficulty == null;

    // ⚠️ Liste à définir dans tes données quiz
    final pool = useAll
        ? questionsDetentionProvisoire
        : questionsDetentionProvisoire
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

            'grade': UserContextService.I.trackOrDefault,
            'track': UserContextService.I.trackOrDefault,
            'mode': UserContextService.I.modeOrDefault,
            'module_name': 'Procédure Pénale',
            'quiz_name': 'Détention Provisoire',
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

      final int percent = (_score * 100 ~/ totalForScore).clamp(0, 100);

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

  /// Garde de réentrance des sorties : deux dialogues de confirmation ne peuvent
  /// pas se superposer (croix tapée deux fois, ou croix pendant un geste retour).
  bool _sortieEnCours = false;

  /// Ferme le quiz après confirmation. Chemin unique de la croix et, quand il
  /// existe, du geste retour système — sans quoi celui-ci contournerait la
  /// confirmation.
  Future<void> _fermerQuiz() async {
    // La croix et « Mettre fin » partagent strictement la même clôture :
    // confirmation, sauvegarde Supabase, calcul du score et écran de résultat.
    if (!_hasQuiz) {
      if (mounted) _quitterEcran();
      return;
    }
    await _endQuizNow();
  }

  /// Sortie effective de l'écran.
  ///
  /// **`pop()` et non `maybePop()`.** `maybePop` consulte les `PopScope` de la
  /// route avant de dépiler : sous un `PopScope` qui bloque la sortie pendant un
  /// quiz, il se ferait refuser et rappellerait la confirmation en boucle — gel
  /// de l'interface. `pop()` dépile directement, ce qui est exactement ce qu'on
  /// veut une fois la décision confirmée.
  void _quitterEcran() {
    final nav = Navigator.of(context);
    if (nav.canPop()) nav.pop();
  }

  /// Dialogue commun à « Mettre fin » et à la fermeture.
  Future<bool> _confirmerSortie({
    required String titre,
    required String actionLabel,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // On reprend la mise en scène de la carte de résultat — flou d'arrière-plan,
    // fondu, léger agrandissement — au lieu de l'`AlertDialog` par défaut.
    final reponse = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirmation',
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (ctx, __, ___) => Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: const SizedBox.expand(),
            ),
          ),
          Center(
            child: _ConfirmCard(
              isDark: isDark,
              titre: titre,
              message:
                  'Tes réponses déjà validées sont enregistrées, et ton '
                  'score sera calculé sur cette base.',
              actionLabel: actionLabel,
              onConfirmer: () => Navigator.of(ctx).pop(true),
              onAnnuler: () => Navigator.of(ctx).pop(false),
            ),
          ),
        ],
      ),
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
        child: ScaleTransition(
          scale: Tween(
            begin: .96,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeOutBack)).animate(anim),
          child: child,
        ),
      ),
    );
    return reponse ?? false;
  }

  Future<void> _endQuizNow() async {
    if (!_hasQuiz) return;

    final confirme = await _confirmerSortie(
      titre: 'Mettre fin au quiz ?',
      actionLabel: 'Mettre fin',
    );
    if (!confirme || !mounted) return;

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
      await _sb.from('quiz_detention_provisoire').insert({
        'user_uid': widget.uid,
        'email': widget.email,

        'grade': UserContextService.I.trackOrDefault,
        'question': question,
        'user_answer': userAnswer,
        'correct_answer': correctAnswer,
        'is_correct': isCorrect,
        'score': _score,
        'difficulty': difficulty,
      });
    } catch (e) {
      debugPrint('❌ quiz_detention_provisoire insert failed: $e');
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

    if (_hideIntroForever) {
      await _doStartQuiz();
    } else {
      setState(() {
        _showIntro = true;
        _showSplash = false;
      });
    }
  }

  Future<void> _doStartQuiz() async {
    _seedAndShuffle();
    setState(() {
      _index = 0;
      _score = 0;
      _validated = false;
      _isCorrect = false;
      _currentChoice = null;
      _showSplash = false;
      _showIntro = false;
    });
    await _createHistoryOnStart();
  }

  void _select(String v) {
    if (_validated) return;
    HapticFeedback.selectionClick();
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

  // ===========================================================================
  // REPORT (signalement question)
  // ===========================================================================

  QuizQuestion? get _currentQuestion =>
      (!_showSplash && _hasQuiz && _index < _qs.length) ? _qs[_index] : null;

  Future<void> _insertReport({
    required QuizQuestion q,
    required String reportType,
    required String message,
  }) async {
    await _sb.from('report_question').insert(<String, dynamic>{
      'created_at': DateTime.now().toUtc().toIso8601String(),
      'user_uid': widget.uid,
      'email': widget.email,
      'question_text': q.question,
      'source_file': 'pa_quiz_detention_provisoire_page',
      'question_category': q.category,
      'question_difficulty': q.difficulty,
      'question_answer': q.answer,
      'report_type': reportType,
      'report_message': message,
      'status': 'new',
    });
  }

  Future<void> _openReportDialog({required bool isDark}) async {
    final q = _currentQuestion;
    if (q == null) {
      if (!mounted) return;
      AppNotifier.warning(
        context,
        title: 'Question indisponible',
        message: 'Question indisponible pour le moment.',
      );
      return;
    }
    await showQuizReportDialog(
      context: context,
      isDark: isDark,
      onInsert: ({required String reportType, required String message}) =>
          _insertReport(q: q, reportType: reportType, message: message),
    );
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
        final bg = isDark ? const Color(0xFF000B36) : _Brand.bgLight;
        final textCol = isDark ? Colors.white : _Brand.textDark;
        final base = isDark ? ThemeData.dark() : ThemeData.light();

        const double kButtonHeight = 56;
        const double kButtonVPad = 16;
        const double bottomBarReserved = kButtonHeight + kButtonVPad + 8;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value:
              (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
                  .copyWith(
                    systemNavigationBarColor: Colors.transparent,
                    systemNavigationBarDividerColor: Colors.transparent,
                  ),
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
            child: Stack(
              children: [
                Positioned.fill(child: _QuizBackdrop(isDark: isDark)),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  extendBody: true,
                  extendBodyBehindAppBar: _showSplash,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.close_rounded, color: textCol),
                      onPressed: _fermerQuiz,
                      tooltip: 'Fermer',
                    ),
                    actions: [
                      IconButton(
                        tooltip: 'Signaler',
                        onPressed: (!_showSplash && _hasQuiz)
                            ? () => _openReportDialog(isDark: isDark)
                            : null,
                        icon: Icon(
                          Icons.flag_outlined,
                          color: (!_showSplash && _hasQuiz)
                              ? textCol
                              : _opa(textCol, .35),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),
                  body: SafeArea(
                    top: false,
                    child: LayoutBuilder(
                      builder: (context, _) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Masquée à la source plutôt que recouverte : on ne
                            // construit pas une interface pour la dissimuler.
                            if (!_showSplash)
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      0,
                                      20,
                                      8,
                                    ),
                                    child: _TopProgressBar(
                                      index: _qsSafeLength == 0 ? 0 : _index,
                                      total: _qsSafeLength == 0
                                          ? 1
                                          : _qs.length,
                                      accent: isDark
                                          ? _Brand.white
                                          : _Brand.accent,
                                    ),
                                  ),
                                  Expanded(
                                    child: PageView.builder(
                                      controller: _page,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _qsSafeLength == 0
                                          ? 1
                                          : _qs.length,
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

                                        // La réserve ajoutait jusqu'à 240 px de vide sous la carte pour
                                        // loger la croix flottante. Le feedback vivant désormais dans le
                                        // bandeau, seule la barre de boutons est à compenser.
                                        final double bottomInsetForThisPage =
                                            bottomBarReserved;

                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            20,
                                            8,
                                            20,
                                            0,
                                          ),
                                          child: KeyedSubtree(
                                            key: ValueKey('page_$i'),
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
                                              estActive: i == _index,
                                              pulse: _pulseCtrl,
                                              bottomSafeInset:
                                                  bottomInsetForThisPage,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SafeArea(
                                    top: false,
                                    minimum: const EdgeInsets.fromLTRB(
                                      20,
                                      8,
                                      20,
                                      16,
                                    ),
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
                                                        ? (_currentChoice ==
                                                                  null
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

                            // L'overlay de feedback a été retiré : il se superposait au bandeau
                            // d'explication dès que l'énoncé était long. L'animation vit
                            // maintenant dans `_OutcomeIcon`, bornée par le bandeau.
                            if (_showIntro)
                              _IntroSplash(
                                isDark: isDark,
                                hideForever: _hideIntroForever,
                                onChangedHideForever: _saveIntroPreference,
                                onStart: () async {
                                  await _doStartQuiz();
                                },
                                icon: Icons.lock_rounded,
                                title: 'Détention provisoire',
                                description:
                                    'Comprends la détention provisoire : conditions, durée maximale, droits de la personne détenue et rôle du juge des libertés.',
                                timerText: '30 secondes par question',
                                historyText:
                                    'Tes résultats sont sauvegardés pour suivre ta progression',
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
              ],
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
      barrierColor: Colors.black.withValues(alpha: 0.25),
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
                  // Ferme la carte de résultat, puis l'écran. `pop()` et non
                  // `maybePop()` : sous un `PopScope`, `maybePop` relancerait
                  // la confirmation de sortie en boucle.
                  Navigator.of(context).pop();
                  _quitterEcran();
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
          'Question ${index + 1} / $totalSafe',
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
          backgroundColor: _opa(_Brand.bad, .10),
          foregroundColor: isEnabled ? _Brand.bad : _opa(_Brand.bad, .35),
          side: BorderSide(
            color: _opa(isEnabled ? _Brand.bad : _opa(_Brand.bad, .35), .55),
            width: 1.4,
          ),
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

class _QuestionCard extends StatefulWidget {
  final QuizQuestion question;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;
  final bool locked;
  final bool showOutcome;
  final bool isCorrect;

  /// Marge basse à ajouter dans le scroll pour éviter toute coupe
  /// `true` quand cette page est celle que l'utilisateur regarde.
  ///
  /// Indispensable : `PageView.builder` construit aussi les pages voisines
  /// à l'avance. Sans ce garde-fou, la cascade de la question suivante se
  /// jouerait hors écran et serait déjà terminée à l'arrivée.
  final bool estActive;

  /// Contrôleur du feedback, relancé à chaque validation par `_validate`.
  final AnimationController pulse;

  final double bottomSafeInset;

  const _QuestionCard({
    required this.question,
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.locked,
    required this.showOutcome,
    required this.isCorrect,
    required this.estActive,
    required this.pulse,
    this.bottomSafeInset = 0,
  });

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard>
    with SingleTickerProviderStateMixin {
  // ─── Cascade d'apparition ────────────────────────────────────────────────
  //
  // Un seul `AnimationController` pilote la séquence ; chaque élément lit une
  // fenêtre différente de sa progression via un `Interval`. L'alternative — un
  // contrôleur et un `Timer` par élément — multiplierait les tickers par le
  // nombre d'options, sur chaque page vivante du `PageView`.
  static const int _msElement = 420;
  static const int _msDecalage = 130;

  int get _nbElements =>
      1 + (_afficheSousTitre ? 1 : 0) + widget.options.length;

  /// Le sous-titre compte comme un élément de la séquence quand il est affiché.
  bool get _afficheSousTitre =>
      (widget.question.sub?.trim().isNotEmpty ?? false);

  int get _msTotal => _msDecalage * (_nbElements - 1) + _msElement;

  late final AnimationController _cascade = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _msTotal),
  );

  /// Contrôleur de la colonne, pour amener le bandeau de correction dans le champ
  /// de vision : sur un énoncé long, l'explication naissait sous le pli.
  final ScrollController _colonne = ScrollController();

  /// Ancre posée sur le bandeau, cible du défilement.
  final GlobalKey _ancreBandeau = GlobalKey();

  bool get _mouvementReduit => WidgetsBinding
      .instance
      .platformDispatcher
      .accessibilityFeatures
      .disableAnimations;

  @override
  void initState() {
    super.initState();
    // Accessibilité : on saute à l'état final, jamais à un état invisible.
    if (_mouvementReduit) {
      _cascade.value = 1;
    } else if (widget.estActive) {
      _cascade.forward();
    }
  }

  @override
  void didUpdateWidget(_QuestionCard old) {
    super.didUpdateWidget(old);

    final duree = Duration(milliseconds: _msTotal);
    if (_cascade.duration != duree) _cascade.duration = duree;

    if (_mouvementReduit) {
      _cascade.value = 1;
      return;
    }

    // La page vient de devenir celle qu'on regarde : la cascade démarre en même
    // temps que le glissement du `PageView`, `_index` étant mis à jour avant
    // l'appel à `nextPage`.
    if (!old.estActive && widget.estActive) {
      _cascade
        ..reset()
        ..forward();
    }

    if (!old.showOutcome && widget.showOutcome && widget.estActive) {
      _revelerBandeau();
    }
  }

  @override
  void dispose() {
    _cascade.dispose();
    _colonne.dispose();
    super.dispose();
  }

  void _revelerBandeau() {
    // Après la frame qui insère le bandeau : avant, sa position n'existe pas.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _ancreBandeau.currentContext;
      if (ctx == null || !_colonne.hasClients) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        // 0.9 plutôt que 1.0 : le bandeau se cale vers le bas de la zone visible
        // en gardant les options au-dessus dans le champ.
        alignment: 0.9,
      );
    });
  }

  /// Fenêtre d'animation du n-ième élément de la séquence.
  Animation<double> _fenetre(int rang) {
    final total = _msTotal;
    final debut = (_msDecalage * rang) / total;
    final fin = (_msDecalage * rang + _msElement) / total;
    return CurvedAnimation(
      parent: _cascade,
      curve: Interval(
        debut.clamp(0.0, 1.0),
        fin.clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  /// Énoncé nettoyé de l'énumération des options.
  ///
  /// Beaucoup de questions répètent les réponses dans leur libellé, puis les
  /// mêmes options s'affichent juste en dessous : le titre double de hauteur et
  /// la question perd sa force. La coupe est conservatrice — il faut un `:` suivi
  /// de texte, **toutes** les options retrouvées après lui, une partie conservée
  /// d'au moins 15 caractères, et aucune option de moins de 4 caractères, qui se
  /// retrouverait par hasard dans n'importe quelle phrase.
  String get _enonceAffiche {
    final brut = widget.question.question.trim();
    final coupe = brut.lastIndexOf(':');
    if (coupe <= 0 || coupe >= brut.length - 1) return brut;

    final avant = brut.substring(0, coupe).trim();
    final apres = brut.substring(coupe + 1).toLowerCase();
    if (avant.length < 15) return brut;

    for (final o in widget.options) {
      final option = o.trim();
      if (option.length < 4) return brut;
      if (!apres.contains(option.toLowerCase())) return brut;
    }
    return avant.endsWith('?') ? avant : '$avant ?';
  }

  /// Taille du titre, réduite par palier quand l'énoncé s'allonge : à 28 px fixes
  /// et avec un réglage de texte système élevé, les options passaient sous le pli.
  double _tailleTitre(String enonce) {
    if (enonce.length > 150) return 21;
    if (enonce.length > 110) return 23;
    if (enonce.length > 75) return 25;
    return 28;
  }

  @override
  Widget build(BuildContext context) {
    // Rang dans la cascade : le titre ouvre, le sous-titre suit s'il
    // existe, puis les options dans l'ordre d'affichage.
    var rangCascade = 0;
    final enonce = _enonceAffiche;
    final textCol = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : _Brand.textDark;

    return SingleChildScrollView(
      controller: _colonne,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: 8,
        // marge bas normale + réserve (animation + bouton)
        bottom: 12 + widget.bottomSafeInset,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ElementCascade(
            animation: _fenetre(rangCascade++),
            child: Text(
              enonce,
              style: _Brand.h1(
                context,
              ).copyWith(color: textCol, fontSize: _tailleTitre(enonce)),
            ),
          ),
          if (widget.question.sub != null) ...[
            const SizedBox(height: 6),
            _ElementCascade(
              animation: _fenetre(rangCascade++),
              child: Text(
                widget.question.sub!,
                style: TextStyle(
                  color: textCol.withAlpha(180),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Options
          ...widget.options.map((o) {
            final isSel = widget.selected == o;
            final correctShown =
                widget.showOutcome && o == widget.question.answer;
            final wrongShown =
                widget.showOutcome && isSel && o != widget.question.answer;

            return _ElementCascade(
              animation: _fenetre(rangCascade++),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _OptionTile(
                  label: o,
                  selected: isSel,
                  locked: widget.locked,
                  correct: correctShown,
                  wrong: wrongShown,
                  onTap: () => widget.onSelect(o),
                ),
              ),
            );
          }),

          // Explication
          AnimatedSwitcher(
            key: _ancreBandeau,
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            layoutBuilder: (currentChild, previousChildren) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (currentChild != null) currentChild,
                ...previousChildren,
              ],
            ),
            child: widget.showOutcome
                ? _OutcomeCard(
                    key: ValueKey<bool>(widget.isCorrect),
                    good: widget.isCorrect,
                    explanation: widget.question.explanation,
                    pulse: widget.pulse,
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

  /// Animation du feedback, partagée avec la page : elle doit partir au
  /// moment exact de la validation, pas à la construction du bandeau.
  final AnimationController pulse;
  const _OutcomeCard({
    super.key,
    required this.good,
    required this.explanation,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    final color = good ? _Brand.good : _Brand.bad;
    final icon = good ? Icons.check_circle_rounded : Icons.cancel_rounded;

    // Dimensionnement adaptatif, sur deux axes : la largeur d'écran — 28 px
    // fixes paraissaient gros sur un petit téléphone et perdus sur une tablette
    // — et le réglage de taille de texte du système, l'icône devant grandir avec
    // l'explication qu'elle accompagne.
    final largeur = MediaQuery.sizeOf(context).width;
    final scaler = MediaQuery.textScalerOf(context);
    final double tailleIcone = scaler
        .scale((largeur / 13.5).clamp(24.0, 34.0))
        .clamp(24.0, 52.0);

    // Zone carrée un peu plus large que l'icône : les étincelles s'y déploient
    // sans empiéter sur le texte, puisqu'elles sont bornées ici et non posées en
    // overlay au-dessus de la page.
    final zone = tailleIcone * 1.7;

    // Alignement optique : l'icône est centrée dans `zone`, son centre est donc
    // à `zone / 2`. La première ligne du texte s'y cale, moins sa demi-hauteur.
    const double tailleTexte = 14.0;
    const double hauteurLigne = 1.32;
    final double demiLigne = scaler.scale(tailleTexte) * hauteurLigne / 2;
    final double decalageTexte = (zone / 2 - demiLigne).clamp(0.0, 24.0);

    // Une seule boîte peinte : bord et fond partagent la même `BoxDecoration`,
    // et la marge est passée à l'extérieur du widget bordé.
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _opa(color, .10),
          // 22 comme les options : le bandeau est collé sous la dernière, à
          // largeur identique — une rupture de rayon se verrait.
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _opa(color, .55), width: 1.2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: zone,
              height: zone,
              child: _OutcomeIcon(
                controller: pulse,
                icon: icon,
                color: color,
                tailleIcone: tailleIcone,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: decalageTexte),
                child: Text(
                  explanation,
                  softWrap: true,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : _Brand.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: tailleTexte,
                    height: hauteurLigne,
                    decoration: TextDecoration.none,
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

// `_FeedbackStrip` et `_FeedbackSparkles` supprimés : l'animation de résultat
// vit désormais dans `_OutcomeIcon`, à l'intérieur du bandeau d'explication.
// `_Star` est conservé, il sert aux étincelles.

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
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
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
    with SingleTickerProviderStateMixin {
  // ─── Cascade d'ouverture ─────────────────────────────────────────────────
  //
  // Même mécanique et même widget (`_ElementCascade`) que l'arrivée d'une
  // question : un seul contrôleur, chaque élément lisant une fenêtre différente
  // de sa progression via un `Interval`. Les deux écrans partagent donc le même
  // geste — fondu plus montée de 10 px.
  //
  // Rangs explicites plutôt qu'un compteur incrémenté pendant le build : le
  // `LayoutBuilder` des cartes peut être rappelé à chaque relayout, et un
  // compteur mutable y dériverait à chaque passe.
  static const int _msElement = 380;
  static const int _msDecalage = 90;
  static const int _rangTitre = 0;
  static const int _rangSousTitre = 1;
  static const int _rangFacile = 2;
  static const int _rangMoyen = 3;
  static const int _rangDifficile = 4;
  static const int _rangCommencer = 5;
  static const int _rangMelanger = 6;
  static const int _nbElements = 7;

  late final AnimationController _entree = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: _msDecalage * (_nbElements - 1) + _msElement,
    ),
  );

  @override
  void initState() {
    super.initState();
    final reduit = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    // On saute à l'état final, jamais à un écran vide.
    if (reduit) {
      _entree.value = 1;
    } else {
      _entree.forward();
    }
  }

  @override
  void dispose() {
    _entree.dispose();
    super.dispose();
  }

  Animation<double> _fenetre(int rang) {
    const total = _msDecalage * (_nbElements - 1) + _msElement;
    final debut = (_msDecalage * rang) / total;
    final fin = (_msDecalage * rang + _msElement) / total;
    return CurvedAnimation(
      parent: _entree,
      curve: Interval(
        debut.clamp(0.0, 1.0),
        fin.clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
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
            // Aucun fond propre : le splash laisse voir le `_QuizBackdrop` de la
            // page. Il empilait auparavant son dégradé et ses halos par-dessus
            // celui du quiz — deux systèmes d'animation superposés, et une
            // rupture de teinte au démarrage. Un voile suffit à détacher le
            // contenu du fond.
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: isDark ? .28 : .04),
                ),
              ),
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
                        _ElementCascade(
                          animation: _fenetre(_rangTitre),
                          child: Text(
                            'Sélectionne le niveau de difficulté',
                            textAlign: TextAlign.center,
                            style: _Brand.h1(
                              context,
                            ).copyWith(color: textMain, fontSize: 24),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _ElementCascade(
                          animation: _fenetre(_rangSousTitre),
                          child: Text(
                            'Nouvelles questions à chaque partie.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: sub,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Trois cartes
                        LayoutBuilder(
                          builder: (ctx, c) {
                            final wide = c.maxWidth >= 420;
                            const spacing = 12.0;
                            final itemW = wide
                                ? (c.maxWidth - spacing * 2) / 3
                                : c.maxWidth;
                            final children = [
                              _ElementCascade(
                                animation: _fenetre(_rangFacile),
                                child: _LevelCard(
                                  label: 'Facile',
                                  icon: Icons.eco_rounded,
                                  tint: const Color(0xFF22C55E),
                                  active: widget.selected == 'Facile',
                                  onTap: () => widget.onSelect('Facile'),
                                  isDark: isDark,
                                ),
                              ),
                              _LevelCard(
                                label: 'Moyenne',
                                icon: Icons.military_tech_rounded,
                                tint: const Color(0xFFF59E0B),
                                active: widget.selected == 'Moyenne',
                                onTap: () => widget.onSelect('Moyenne'),
                                isDark: isDark,
                              ),
                              _ElementCascade(
                                animation: _fenetre(_rangDifficile),
                                child: _LevelCard(
                                  label: 'Difficile',
                                  icon: Icons.emoji_events_rounded,
                                  tint: const Color(0xFFEF4444),
                                  active: widget.selected == 'Difficile',
                                  onTap: () => widget.onSelect('Difficile'),
                                  isDark: isDark,
                                ),
                              ),
                            ];

                            if (wide) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: itemW, child: children[0]),
                                  const SizedBox(width: spacing),
                                  SizedBox(width: itemW, child: children[1]),
                                  const SizedBox(width: spacing),
                                  SizedBox(width: itemW, child: children[2]),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  children[0],
                                  const SizedBox(height: spacing),
                                  children[1],
                                  const SizedBox(height: spacing),
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
                            child: Text(
                              widget.selected == null
                                  ? 'Choisis un niveau'
                                  : 'Commencer',
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Bouton Aléatoire (mix 3 niveaux)
                        _ElementCascade(
                          animation: _fenetre(_rangMelanger),
                          child: SizedBox(
                            height: 56,
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: widget.onStartRandom,
                              icon: const Icon(Icons.shuffle_rounded, size: 20),
                              label: const Text('Mélanger les 3 niveaux'),
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
                                  borderRadius: BorderRadius.circular(28),
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

// `_AnimatedBackground` supprimé : dégradé propre au splash, remplacé par le
// `_QuizBackdrop` de la page. Un seul fond pour tout l'écran.

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

  /// Icône du niveau. Remplace un emoji, dont le dessin dépend de la police
  /// système et dont la couleur n'est pas contrôlable.
  final IconData icon;
  final Color tint;
  final bool active;
  final bool isDark;
  final VoidCallback onTap;

  const _LevelCard({
    required this.label,
    required this.icon,
    required this.tint,
    required this.active,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final track = _Brand.radioTrack(context);

    // Carte fixe. Le `AnimatedBuilder` + `Transform.translate` qui la
    // faisait osciller de ±2 px a été retiré : sur trois cartes à
    // comparer, ce balancement désalignait les bords en permanence.
    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      scale: active ? 1.02 : 1.0,
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
            color: _opa(
              tint,
              isDark ? (active ? .22 : .13) : (active ? .18 : .10),
            ),
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
                  color: _opa(tint, isDark ? .22 : .18),
                  border: Border.all(color: active ? tint : _opa(tint, .45)),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 24,
                    color: isDark ? tint : _assombrir(tint, .22),
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
                  border: Border.all(color: active ? tint : track, width: 2),
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
    );
  }
}

// ===========================================================================
// INTRO SPLASH
// ===========================================================================
class _IntroSplash extends StatelessWidget {
  final bool isDark;
  final bool hideForever;
  final ValueChanged<bool> onChangedHideForever;
  final VoidCallback onStart;
  final IconData icon;
  final String title;
  final String description;
  final String timerText;
  final String historyText;

  const _IntroSplash({
    required this.isDark,
    required this.hideForever,
    required this.onChangedHideForever,
    required this.onStart,
    required this.icon,
    required this.title,
    required this.description,
    required this.timerText,
    required this.historyText,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF6C63FF);
    const good = Color(0xFF27C93F);
    final bg = isDark ? const Color(0xFF08111D) : const Color(0xFFF4F7FB);
    final cardBg = isDark ? const Color(0xFF101826) : Colors.white;
    final border = isDark ? const Color(0xFF253247) : const Color(0xFFE3EAF5);
    final txtMain = isDark ? Colors.white : const Color(0xFF212529);
    final txtSub = isDark
        ? Colors.white.withAlpha(210)
        : const Color(0xFF212529).withAlpha(210);

    return Positioned.fill(
      child: Container(
        color: bg,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? .22 : .08,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 48, color: accent),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          height: 1.25,
                          color: txtMain,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: txtSub,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            color: accent,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              timerText,
                              style: TextStyle(
                                color: txtMain,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_graph_rounded,
                            color: good,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              historyText,
                              style: TextStyle(
                                color: txtMain,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: hideForever,
                        onChanged: (v) => onChangedHideForever(v ?? false),
                        title: Text(
                          'Ne plus afficher cet \u00e9cran',
                          style: TextStyle(
                            color: txtMain,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onStart,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: isDark
                                ? Colors.white
                                : const Color(0xFF212529),
                            foregroundColor: isDark
                                ? Colors.black
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'Commencer le quiz',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
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
        ),
      ),
    );
  }
}

/// Assombrit une teinte pour qu'elle reste lisible sur fond clair.
///
/// Les teintes de niveau sont vives (#22C55E, #F59E0B, #EF4444) : parfaites sur
/// fond sombre, trop claires en thème clair. On les rabat vers le noir plutôt
/// que d'entretenir une seconde palette en parallèle.
Color _assombrir(Color c, [double facteur = .45]) =>
    Color.lerp(c, Colors.black, facteur)!;

/// Fond du quiz, dans les deux thèmes.
///
/// Remplace un aplat (noir pur ou gris #2C2C2E) par la matière du module Cas
/// pratiques : dégradé navy, halo de lumière derrière la question, masses
/// colorées dérivantes, vignette. Le thème clair a la même construction en
/// lumineux — ce n'est pas un fond au rabais.
///
/// Trois précautions, ce fond vivant sous un `PageView` :
///  * `RepaintBoundary` isole la couche du reste de l'écran ;
///  * un seul contrôleur de 26 s pour les trois halos ;
///  * aucun flou, coûteux sur mobile d'entrée de gamme — les halos sont des
///    `RadialGradient`, déjà diffus.
class _QuizBackdrop extends StatefulWidget {
  const _QuizBackdrop({required this.isDark});
  final bool isDark;
  @override
  State<_QuizBackdrop> createState() => _QuizBackdropState();
}

class _QuizBackdropState extends State<_QuizBackdrop>
    with SingleTickerProviderStateMixin {
  static const Color _navyTop = Color(0xFF000B36);
  static const Color _navyMid = Color(0xFF000A33);
  static const Color _navyBot = Color(0xFF00082D);

  static const Color _clairTop = Color(0xFFF8FAFF);
  static const Color _clairMid = Color(0xFFEFF3FD);
  static const Color _clairBot = Color(0xFFE6ECFB);

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 26),
  );

  @override
  void initState() {
    super.initState();
    final reduit = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    if (!reduit) _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sombre = widget.isDark;
    final degrade = sombre
        ? const [_navyTop, _navyMid, _navyBot]
        : const [_clairTop, _clairMid, _clairBot];
    // Un halo blanc serait invisible sur un fond clair : la lumière vient alors
    // du bleu brand, en très faible densité.
    final halo = sombre ? Colors.white : _Brand.accent;
    final haloFort = sombre ? 0.10 : 0.07;
    final haloFaible = sombre ? 0.035 : 0.025;
    // Du noir salirait le thème clair : on referme au bleu dilué.
    final vignette = sombre
        ? Colors.black.withValues(alpha: 0.42)
        : _Brand.accent.withValues(alpha: 0.10);

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: degrade,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.72),
                radius: 1.15,
                colors: [
                  halo.withValues(alpha: haloFort),
                  halo.withValues(alpha: haloFaible),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
          _Halo(
            color: _Brand.accent,
            size: 300,
            dx: -130,
            dy: -180,
            ctrl: _ctrl,
            strength: sombre ? 0.16 : 0.09,
          ),
          _Halo(
            color: const Color(0xFF1A55E6),
            size: 260,
            dx: 140,
            dy: 200,
            ctrl: _ctrl,
            strength: sombre ? 0.14 : 0.08,
          ),
          _Halo(
            color: _Brand.good,
            size: 200,
            dx: 30,
            dy: 420,
            ctrl: _ctrl,
            strength: sombre ? 0.08 : 0.05,
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.15),
                  radius: 1.10,
                  colors: [Colors.transparent, vignette],
                  stops: const [0.55, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Un élément d'une cascade d'apparition : fondu et montée de 10 px.
///
/// `FadeTransition` gère l'opacité sans rien reconstruire, et l'enfant est passé
/// à `AnimatedBuilder` via `child:` — seul le `Transform` est rebâti à chaque
/// frame, jamais le contenu.
///
/// Le décalage est en pixels et non en fraction de hauteur (ce que ferait un
/// `SlideTransition`) : un titre et une option n'ont pas la même hauteur, et une
/// fraction commune donnerait des amplitudes différentes.
class _ElementCascade extends StatelessWidget {
  const _ElementCascade({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  static const double _monteeDepart = 10.0;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (_, enfant) => Transform.translate(
          offset: Offset(0, _monteeDepart * (1 - animation.value)),
          child: enfant,
        ),
      ),
    );
  }
}

/// Icône de résultat animée : rebond à l'apparition, puis étincelles qui
/// s'écartent et s'effacent.
///
/// Remplace une croix flottante de 240 px posée en overlay au-dessus de la page,
/// qui chevauchait l'explication dès que l'énoncé était long. Bornée par le
/// `SizedBox` du bandeau, elle ne peut plus rien recouvrir.
class _OutcomeIcon extends StatelessWidget {
  const _OutcomeIcon({
    required this.controller,
    required this.icon,
    required this.color,
    required this.tailleIcone,
  });

  final AnimationController controller;
  final IconData icon;
  final Color color;
  final double tailleIcone;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final t = controller.value.clamp(0.0, 1.0);

          const n = 6;
          final rayonMax = tailleIcone * 0.72;
          final etincelles = <Widget>[];

          // Une fois l'animation finie, on ne peint plus que l'icône : aucune
          // couche inutile ne subsiste dans l'arbre de rendu.
          if (t < 0.999) {
            for (var i = 0; i < n; i++) {
              final angle = (i / n) * 2 * math.pi;
              final r = rayonMax * t;
              etincelles.add(
                Transform.translate(
                  offset: Offset(r * math.cos(angle), r * math.sin(angle)),
                  child: Transform.scale(
                    scale: 0.3 + t * 0.7,
                    child: Opacity(
                      opacity: (1 - t).clamp(0.0, 1.0),
                      child: _Star(color: color, size: tailleIcone * 0.22),
                    ),
                  ),
                ),
              );
            }
          }

          // `Curves.elasticOut` serait trop remuant à côté d'un texte qu'on veut
          // lire : un simple dépassement suffit.
          final echelle = 0.7 + Curves.easeOutBack.transform(t) * 0.3;

          return Stack(
            alignment: Alignment.center,
            children: [
              ...etincelles,
              Transform.scale(
                scale: echelle,
                child: Icon(icon, color: color, size: tailleIcone),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Carte de confirmation avant une sortie de quiz.
///
/// Sert la croix comme le bouton « Mettre fin » : même mise en page, seuls le
/// titre et le libellé de l'action changent. Remplace un `AlertDialog` Material,
/// qui détonnait avec le reste de l'écran.
///
/// Hiérarchie assumée — l'action sûre est en bas, pleine et dans l'accent de
/// l'app : la plus atteignable au pouce et la plus visible. L'action destructive
/// est au-dessus, en contour rouge : identifiable, jamais tentante.
class _ConfirmCard extends StatelessWidget {
  const _ConfirmCard({
    required this.isDark,
    required this.titre,
    required this.message,
    required this.actionLabel,
    required this.onConfirmer,
    required this.onAnnuler,
  });

  final bool isDark;
  final String titre;
  final String message;
  final String actionLabel;
  final VoidCallback onConfirmer;
  final VoidCallback onAnnuler;

  @override
  Widget build(BuildContext context) {
    final fond = isDark ? const Color(0xFF11131A) : Colors.white;
    final texte = isDark ? Colors.white : _Brand.textDark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
            decoration: BoxDecoration(
              color: fond,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? _opa(Colors.white, .10)
                    : _opa(Colors.black, .06),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? .45 : .12),
                  blurRadius: 34,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pastille d'avertissement : donne un point d'entrée au regard et
                // annonce la nature de l'action avant même la lecture.
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _opa(_Brand.bad, .12),
                    border: Border.all(color: _opa(_Brand.bad, .30)),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: _Brand.bad,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  titre,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: texte,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    height: 1.2,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: _opa(texte, .70),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.45,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: onConfirmer,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _opa(_Brand.bad, .10),
                      foregroundColor: _Brand.bad,
                      side: BorderSide(
                        color: _opa(_Brand.bad, .55),
                        width: 1.4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    child: Text(actionLabel),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: onAnnuler,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: _Brand.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    child: const Text('Continuer le quiz'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
