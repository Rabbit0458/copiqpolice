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

/// =============================================================
///  QUIZ — CADRE LÉGAL D’USAGE DES ARMES (art. L. 435-1
///  du Code de la sécurité intérieure + lien avec la légitime
///  défense art. 122-5 du Code pénal)
///
///  Remplace ton ancien tableau par celui-ci.
///  (tu peux bien sûr l’enrichir encore si besoin)
/// =============================================================
final List<QuizQuestion> questionsPersonnesFuite = [
  // ===================== NIVEAU FACILE =====================
  QuizQuestion(
    category: "Généralités — Article 74-2 C.P.P.",
    question:
        "Quel est l’objectif principal de la procédure prévue par l’article 74-2 du C.P.P. ?",
    options: [
      "Rechercher les témoins d’une infraction",
      "Rechercher et découvrir une personne en fuite",
      "Contrôler les conditions de garde à vue",
    ],
    answer: "Rechercher et découvrir une personne en fuite",
    explanation:
        "L’article 74-2 crée un cadre juridique spécifique pour rechercher de manière effective une personne en fuite.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Généralités — Article 74-2 C.P.P.",
    question:
        "Sur instructions de quelle autorité la procédure de l’article 74-2 du C.P.P. peut-elle être mise en œuvre ?",
    options: [
      "Sur instructions du préfet",
      "Sur instructions du juge d’instruction",
      "Sur instructions du procureur de la République",
    ],
    answer: "Sur instructions du procureur de la République",
    explanation:
        "Le texte précise que la procédure ne peut être mise en œuvre que « sur instructions du procureur de la République ». L’OPJ n’agit jamais de sa propre initiative.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Généralités — Article 74-2 C.P.P.",
    question:
        "Les actes réalisés dans le cadre de l’article 74-2 du C.P.P. renvoient principalement aux articles :",
    options: [
      "Articles 53 à 55 du C.P.P.",
      "Articles 56 à 62 du C.P.P.",
      "Articles 63 à 65 du C.P.P.",
    ],
    answer: "Articles 56 à 62 du C.P.P.",
    explanation:
        "L’article 74-2 autorise les OPJ, sur instructions du procureur, à user des moyens d’investigation prévus par les articles 56 à 62 du C.P.P. (flagrance).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Conditions d’application — Mandat d’arrêt",
    question:
        "La procédure de l’article 74-2 du C.P.P. est notamment applicable à une personne en fuite qui :",
    options: [
      "Fait uniquement l’objet d’une simple convocation",
      "Fait l’objet d’un mandat d’arrêt",
      "Fait uniquement l’objet d’une plainte simple",
    ],
    answer: "Fait l’objet d’un mandat d’arrêt",
    explanation:
        "L’un des cas d’application vise la personne faisant l’objet d’un mandat d’arrêt, qu’il soit délivré par une juridiction d’instruction ou de jugement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Conditions d’application — Mandat d’arrêt",
    question:
        "Un mandat d’arrêt permettant la mise en œuvre de l’article 74-2 peut être délivré notamment par :",
    options: [
      "Le maire de la commune",
      "Le juge d’instruction ou le président de la cour d’assises",
      "Le directeur d’établissement pénitentiaire",
    ],
    answer: "Le juge d’instruction ou le président de la cour d’assises",
    explanation:
        "Le 1° de l’article 74-2 vise le mandat d’arrêt délivré par le juge d’instruction, le JLD, la chambre de l’instruction ou son président, ou le président de la cour d’assises.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Conditions d’application — Mandat d’arrêt",
    question:
        "La procédure de recherche des personnes en fuite peut s’appliquer à un mandat d’arrêt délivré par :",
    options: [
      "Une juridiction de jugement ou le juge de l’application des peines",
      "Uniquement le tribunal de police",
      "Uniquement la cour de cassation",
    ],
    answer:
        "Une juridiction de jugement ou le juge de l’application des peines",
    explanation:
        "Le 2° de l’article 74-2 vise expressément le mandat d’arrêt délivré par une juridiction de jugement ou par le juge de l’application des peines.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Conditions d’application — Peines",
    question:
        "La procédure 74-2 peut s’appliquer à une personne condamnée à une peine privative de liberté :",
    options: [
      "Inférieure à 6 mois, même non exécutoire",
      "Sans sursis ou avec sursis révoqué, supérieure ou égale à un an",
      "Uniquement si la peine est assortie d’un sursis simple",
    ],
    answer: "Sans sursis ou avec sursis révoqué, supérieure ou égale à un an",
    explanation:
        "Le 3° vise la personne condamnée à une peine privative de liberté sans sursis, ou résultant de la révocation d’un sursis, supérieure ou égale à un an, dès que la condamnation est exécutoire ou passée en force de chose jugée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Conditions d’application — Fichiers nationaux",
    question:
        "Les personnes inscrites au fichier judiciaire national automatisé des auteurs d’infractions terroristes (FIJAIT) sont concernées par l’article 74-2 lorsqu’elles :",
    options: [
      "Sont simplement inscrites au fichier",
      "Ont manqué aux obligations prévues à l’article 706-25-7",
      "Ont purgé leur peine depuis plus de 10 ans",
    ],
    answer: "Ont manqué aux obligations prévues à l’article 706-25-7",
    explanation:
        "Le 4° vise les personnes inscrites au FIJAIT qui ont manqué à leurs obligations prévues à l’article 706-25-7 C.P.P.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Conditions d’application — Fichiers nationaux",
    question:
        "Les personnes inscrites au fichier judiciaire national automatisé des auteurs d’infractions sexuelles ou violentes (FIJAISV) sont concernées si elles :",
    options: [
      "Demandent une réduction de peine",
      "Manquent aux obligations prévues à l’article 706-53-5",
      "Changent de domicile avec autorisation",
    ],
    answer: "Manquent aux obligations prévues à l’article 706-53-5",
    explanation:
        "Le 5° vise expressément les personnes inscrites au fichier des auteurs d’infractions sexuelles ou violentes, en cas de manquement à leurs obligations.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Conditions d’application — Aménagements de peine",
    question:
        "L’article 74-2 peut être appliqué à une personne ayant fait l’objet d’une décision de retrait ou de révocation :",
    options: [
      "D’une amende forfaitaire",
      "D’un aménagement de peine ou d’une libération sous contrainte",
      "D’un simple rappel à la loi",
    ],
    answer: "D’un aménagement de peine ou d’une libération sous contrainte",
    explanation:
        "Le 6° vise les décisions de retrait ou de révocation d’un aménagement de peine ou d’une libération sous contrainte entraînant l’exécution d’un reliquat de peine supérieur à un an.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Conditions d’application — Quantum de peine",
    question:
        "Pour que l’article 74-2 s’applique à une décision de mise à exécution d’un reliquat de peine, la durée d’emprisonnement à exécuter doit être :",
    options: [
      "Supérieure à un an",
      "Supérieure à trois mois",
      "Exactement égale à un an",
    ],
    answer: "Supérieure à un an",
    explanation:
        "La décision doit avoir pour conséquence la mise à exécution d’un quantum ou d’un reliquat de peine d’emprisonnement supérieur à un an.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Autorités habilitées — OPJ/APJ",
    question:
        "Dans le cadre de l’article 74-2, qui peut être assisté d’agents de police judiciaire pour accomplir les actes de l’enquête ?",
    options: [
      "Le maire",
      "L’officier de police judiciaire",
      "Le juge d’instruction",
    ],
    answer: "L’officier de police judiciaire",
    explanation:
        "Les OPJ, assistés le cas échéant des APJ, peuvent accomplir les actes prévus par les articles 56 à 62 pour rechercher la personne en fuite.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Autorités habilitées — OPJ",
    question:
        "Dans le cadre de l’article 74-2, qui peut rédiger les actes de procédure ?",
    options: [
      "Les agents de police judiciaire",
      "Les OPJ uniquement",
      "Les agents de police municipale",
    ],
    answer: "Les OPJ uniquement",
    explanation:
        "Même si les APJ peuvent assister l’OPJ, seuls les officiers de police judiciaire sont habilités à rédiger les actes de procédure.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actes de l’enquête — Garde à vue",
    question:
        "Dans le cadre de la procédure de l’article 74-2, l’OPJ peut-il placer une personne en garde à vue ?",
    options: [
      "Oui, dans tous les cas",
      "Oui, uniquement avec l’accord du JLD",
      "Non, la garde à vue n’est pas possible dans ce cadre",
    ],
    answer: "Non, la garde à vue n’est pas possible dans ce cadre",
    explanation:
        "Le texte précise que dans le cadre de l’article 74-2, l’OPJ ne peut pas prendre de mesure de garde à vue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actes de l’enquête — Flagrance",
    question:
        "Les actes que l’OPJ peut réaliser dans le cadre de l’article 74-2 correspondent à ceux :",
    options: [
      "De l’enquête de flagrance",
      "De l’enquête préliminaire uniquement",
      "De l’instruction uniquement",
    ],
    answer: "De l’enquête de flagrance",
    explanation:
        "L’article 74-2 renvoie aux actes prévus par les articles 56 à 62, c’est-à-dire à ceux de l’enquête de flagrance (perquisitions, auditions, etc.).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Interceptions — Autorisation",
    question:
        "Dans le cadre de l’article 74-2, qui autorise les interceptions téléphoniques ?",
    options: [
      "Le procureur de la République",
      "Le juge des libertés et de la détention",
      "Le juge d’instruction",
    ],
    answer: "Le juge des libertés et de la détention",
    explanation:
        "Les interceptions sont autorisées par le juge des libertés et de la détention du tribunal judiciaire, à la requête du procureur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Interceptions — Durée",
    question:
        "Dans le cadre de l’article 74-2, la durée initiale maximale d’une autorisation d’interception téléphonique est de :",
    options: ["Un mois", "Deux mois", "Six mois"],
    answer: "Deux mois",
    explanation:
        "L’autorisation est délivrée pour une durée maximale de deux mois, renouvelable dans les mêmes conditions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Interceptions — Limite en matière correctionnelle",
    question:
        "En matière correctionnelle, la durée totale des interceptions autorisées dans le cadre de l’article 74-2 est limitée à :",
    options: ["Deux mois", "Quatre mois", "Six mois"],
    answer: "Six mois",
    explanation:
        "En matière correctionnelle, la durée totale ne peut excéder six mois, même en cas de renouvellements.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Techniques spéciales — Rappel",
    question:
        "Les techniques spéciales d’enquête mobilisables via l’article 74-2 renvoient à celles applicables :",
    options: [
      "À la criminalité organisée et aux crimes",
      "Aux contraventions routières",
      "Uniquement aux délits de presse",
    ],
    answer: "À la criminalité organisée et aux crimes",
    explanation:
        "Le texte renvoie aux techniques prévues pour la délinquance et la criminalité organisées (titre XXV).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Extension — Mandat d’arrêt européen et extradition",
    question:
        "Les dispositions de l’article 74-2 du C.P.P. sont également applicables en matière :",
    options: [
      "De simple contravention",
      "De mandat d’arrêt européen et d’extradition",
      "De médiation pénale",
    ],
    answer: "De mandat d’arrêt européen et d’extradition",
    explanation:
        "Le rappel indique que l’article 74-2 est applicable pour l’exécution de MAE (art. 695-36) et d’extradition (art. 696-21).",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  QuizQuestion(
    category: "Conditions d’application — Synthèse",
    question:
        "Parmi les propositions suivantes, laquelle ne correspond PAS à une condition d’application de l’article 74-2 du C.P.P. ?",
    options: [
      "Mandat d’arrêt délivré par une juridiction de jugement",
      "Inscription au fichier des auteurs d’infractions sexuelles ayant manqué à leurs obligations",
      "Personne simplement suspectée sans condamnation, ni mandat, ni fichage",
    ],
    answer:
        "Personne simplement suspectée sans condamnation, ni mandat, ni fichage",
    explanation:
        "L’article 74-2 vise des personnes déjà condamnées, sous mandat ou fichées pour manquement aux obligations, pas de simples suspects.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Conditions d’application — Mandats",
    question:
        "Dans le cadre du 1° de l’article 74-2, le mandat d’arrêt délivré par le juge d’instruction concerne une personne :",
    options: [
      "Mise en examen mais non renvoyée",
      "Renvoyée devant une juridiction de jugement",
      "Simplement entendue comme témoin",
    ],
    answer: "Renvoyée devant une juridiction de jugement",
    explanation:
        "Le texte vise la personne faisant l’objet d’un mandat d’arrêt alors qu’elle est renvoyée devant une juridiction de jugement.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Conditions d’application — Condamnation",
    question:
        "Pour le 3° de l’article 74-2, la condamnation privative de liberté prenant en compte un sursis révoqué doit :",
    options: [
      "Être simplement prononcée, même non exécutoire",
      "Être exécutoire ou passée en force de chose jugée",
      "Toujours être assortie d’un sursis probatoire en cours",
    ],
    answer: "Être exécutoire ou passée en force de chose jugée",
    explanation:
        "Le texte vise les condamnations exécutoires ou passées en force de chose jugée, supérieures ou égales à un an.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Autorités habilitées — Procureur",
    question:
        "Dans le cadre de l’article 74-2, le procureur de la République peut demander aux OPJ :",
    options: [
      "De se limiter à de simples vérifications administratives",
      "D’user des moyens d’investigation prévus pour l’enquête de flagrance",
      "De prononcer eux-mêmes les peines",
    ],
    answer:
        "D’user des moyens d’investigation prévus pour l’enquête de flagrance",
    explanation:
        "Le procureur peut demander aux OPJ d’utiliser les articles 56 à 62 C.P.P. pour rechercher la personne en fuite.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Autorités habilitées — Procureur",
    question:
        "Dans le cadre des interceptions 74-2, les attributions normalement confiées au juge d’instruction par les articles 100-3 à 100-5 C.P.P. sont exercées par :",
    options: [
      "Le président du tribunal correctionnel",
      "Le procureur de la République ou l’OPJ requis par lui",
      "Le juge de l’application des peines",
    ],
    answer: "Le procureur de la République ou l’OPJ requis par lui",
    explanation:
        "L’article 74-2 prévoit que ces attributions sont exercées par le procureur ou l’OPJ requis par lui.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Autorités habilitées — JLD",
    question:
        "Selon l’article 74-2, le juge des libertés et de la détention doit être informé :",
    options: [
      "Uniquement à la fin de l’enquête",
      "Sans délai des actes accomplis dans le cadre des interceptions",
      "Uniquement en cas d’échec des interceptions",
    ],
    answer: "Sans délai des actes accomplis dans le cadre des interceptions",
    explanation:
        "Le texte impose une information sans délai du JLD sur les actes accomplis au titre des interceptions autorisées.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Interceptions — Conditions générales",
    question:
        "Pour autoriser des interceptions dans le cadre de l’article 74-2, la peine encourue pour l’infraction doit être :",
    options: ["D’au moins 1 an", "D’au moins 3 ans", "D’au moins 10 ans"],
    answer: "D’au moins 3 ans",
    explanation:
        "Les articles 100 et suivants, auxquels renvoie l’article 74-2, imposent que la peine encourue soit égale ou supérieure à 3 ans.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Interceptions — Lignes protégées",
    question:
        "À peine de nullité, les lignes dépendant du cabinet ou domicile d’un député, sénateur, avocat ou magistrat ne peuvent être interceptées que :",
    options: [
      "Avec l’accord du préfet",
      "Après avis de leur autorité supérieure",
      "Avec l’accord de la personne elle-même",
    ],
    answer: "Après avis de leur autorité supérieure",
    explanation:
        "Les interceptions concernant ces professions protégées nécessitent un avis préalable de l’autorité supérieure (président d’assemblée, bâtonnier, etc.).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Interceptions — Secret professionnel",
    question:
        "Les correspondances avec un avocat ne peuvent être transcrites dans le cadre des interceptions 74-2 que si :",
    options: [
      "Elles concernent un rendez-vous amical",
      "Elles relèvent de l’exercice des droits de la défense",
      "Elles ne relèvent pas de l’exercice des droits de la défense et ne sont pas couvertes par le secret professionnel, sauf cas prévus par la loi",
    ],
    answer:
        "Elles ne relèvent pas de l’exercice des droits de la défense et ne sont pas couvertes par le secret professionnel, sauf cas prévus par la loi",
    explanation:
        "Les correspondances avocat relevant des droits de la défense et protégées par le secret ne peuvent être transcrites, sauf exceptions textuelles.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Actes de l’enquête — OPJ",
    question:
        "Parmi les actes suivants, lesquels peuvent être accomplis par l’OPJ dans le cadre de l’article 74-2 ?",
    options: [
      "Perquisitions et réquisitions prévues par les articles 56 à 62",
      "Prononcer une peine d’emprisonnement",
      "Placer la personne en détention provisoire",
    ],
    answer: "Perquisitions et réquisitions prévues par les articles 56 à 62",
    explanation:
        "L’OPJ peut réaliser tous les actes de flagrance (auditions, perquisitions, réquisitions, examens techniques et scientifiques).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Actes de l’enquête — PV d’interception",
    question:
        "Que doit faire l’OPJ après les opérations d’interception téléphonique en application de l’article 74-2 ?",
    options: [
      "Notifier immédiatement les résultats à la personne recherchée",
      "Rédiger un procès-verbal précis et placer les enregistrements sous scellés fermés",
      "Détruire les enregistrements après écoute",
    ],
    answer:
        "Rédiger un procès-verbal précis et placer les enregistrements sous scellés fermés",
    explanation:
        "L’OPJ doit décrire précisément les opérations réalisées et placer les enregistrements sous scellés, afin d’assurer la traçabilité et l’intégrité des preuves.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Actes de l’enquête — Interprète",
    question:
        "Si des interceptions portent sur des conversations en langue étrangère, l’OPJ doit :",
    options: [
      "Les ignorer",
      "Les transmettre telles quelles au JLD",
      "Recourir à un interprète pour les transcrire utilement",
    ],
    answer: "Recourir à un interprète pour les transcrire utilement",
    explanation:
        "Le texte impose de recourir à un interprète pour les correspondances en langue étrangère afin d’assurer une transcription fiable.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Techniques spéciales — Liste",
    question:
        "Parmi les techniques suivantes, laquelle fait partie des techniques spéciales d’enquête mobilisables via l’article 74-2 ?",
    options: [
      "La contravention forfaitaire",
      "L’IMSI-catcher",
      "Le rappel à la loi",
    ],
    answer: "L’IMSI-catcher",
    explanation:
        "L’IMSI-catcher (art. 706-95-20 C.P.P.) figure parmi les techniques spéciales mobilisables lorsque les conditions de l’article 74-2 sont réunies.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Techniques spéciales — Accès à distance",
    question:
        "L’accès à distance aux correspondances stockées par la voie des communications électroniques (articles 706-95 à 706-95-3) permet :",
    options: [
      "De contrôler les horaires de travail du mis en cause",
      "De recueillir à distance des messages stockés (boîtes mail, messageries sécurisées)",
      "De vérifier le casier judiciaire en direct",
    ],
    answer:
        "De recueillir à distance des messages stockés (boîtes mail, messageries sécurisées)",
    explanation:
        "Cette technique permet de consulter à distance des correspondances électroniques stockées, utiles pour localiser ou suivre la personne.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Techniques spéciales — Conditions",
    question:
        "Les techniques spéciales d’enquête via l’article 74-2 (surveillance, infiltration, etc.) ne sont applicables que si :",
    options: [
      "La personne est simplement recherchée pour une contravention",
      "La personne a fait l’objet d’une des décisions 1°, 2°, 3° ou 6° pour une infraction 706-73 ou 706-73-1",
      "La personne est seulement témoin dans l’affaire",
    ],
    answer:
        "La personne a fait l’objet d’une des décisions 1°, 2°, 3° ou 6° pour une infraction 706-73 ou 706-73-1",
    explanation:
        "Les sections 1, 2 et 4 à 6 du titre XXV sont applicables si la personne a fait l’objet de l’une des décisions mentionnées aux 1° à 3° et 6° pour une infraction relevant des articles 706-73 ou 706-73-1.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Généralités — Moment d’utilisation",
    question:
        "L’article 74-2 du C.P.P. vise en particulier la recherche d’une personne faisant l’objet d’un mandat d’arrêt :",
    options: [
      "Avant toute mise en examen",
      "Après la clôture de l’information",
      "Uniquement pendant la garde à vue",
    ],
    answer: "Après la clôture de l’information",
    explanation:
        "Le texte précise que ce dispositif permet la recherche effective d’une personne faisant l’objet d’un mandat d’arrêt après la clôture de l’information.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Interceptions — Renouvellement",
    question:
        "Dans le cadre 74-2, le renouvellement de l’autorisation d’interception téléphonique :",
    options: [
      "Est interdit",
      "Est possible dans les mêmes formes et durées que l’autorisation initiale",
      "Peut être décidé oralement par l’OPJ",
    ],
    answer:
        "Est possible dans les mêmes formes et durées que l’autorisation initiale",
    explanation:
        "L’autorisation est renouvelable dans les mêmes conditions de forme et de durée, sous réserve des limites (6 mois en correctionnelle).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Interceptions — Nature de la décision",
    question:
        "La décision du JLD autorisant les interceptions dans le cadre de l’article 74-2 :",
    options: [
      "Est écrite et n’est susceptible d’aucun recours",
      "Doit être orale pour être plus rapide",
      "Doit être validée par la chambre de l’instruction",
    ],
    answer: "Est écrite et n’est susceptible d’aucun recours",
    explanation:
        "Conformément aux articles 100 et suivants, la décision autorisant les interceptions est écrite et non susceptible de recours.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Techniques spéciales — Sonorisation",
    question:
        "La sonorisation et fixation d’images mobilisable via l’article 74-2 correspond à :",
    options: [
      "La simple vidéosurveillance de voie publique",
      "La pose de micros/caméras dans certains lieux ou véhicules autorisés",
      "La captation des conversations des jurés de la cour d’assises",
    ],
    answer:
        "La pose de micros/caméras dans certains lieux ou véhicules autorisés",
    explanation:
        "Les articles 706-96 à 706-100 encadrent la captation de paroles et d’images dans des lieux ou véhicules privés ou publics, sous contrôle judiciaire.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Techniques spéciales — Captation de données",
    question:
        "La captation de données informatiques (706-102-1 à 706-102-5) permet notamment :",
    options: [
      "D’accéder aux données stockées dans un système informatique et de les enregistrer",
      "De perquisitionner un domicile sans autorisation",
      "De contrôler l’identité sur la voie publique",
    ],
    answer:
        "D’accéder aux données stockées dans un système informatique et de les enregistrer",
    explanation:
        "Cette technique permet d’accéder à des données informatiques, de les enregistrer, conserver et transmettre, sans le consentement des intéressés.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  QuizQuestion(
    category: "Conditions d’application — Analyse fine",
    question:
        "Parmi les situations suivantes, laquelle permet de mettre en œuvre à la fois l’article 74-2 et les techniques spéciales d’enquête du titre XXV ?",
    options: [
      "Personne mise en examen pour vol simple sans mandat ni condamnation",
      "Personne renvoyée devant une juridiction pour une infraction 706-73 et faisant l’objet d’un mandat d’arrêt",
      "Personne témoin assisté dans une procédure de contravention",
    ],
    answer:
        "Personne renvoyée devant une juridiction pour une infraction 706-73 et faisant l’objet d’un mandat d’arrêt",
    explanation:
        "Les techniques spéciales ne sont applicables que si la personne a fait l’objet d’une des décisions mentionnées (mandat, condamnation, etc.) pour une infraction entrant dans le champ de 706-73 ou 706-73-1.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Conditions d’application — Fichiers",
    question:
        "Une personne inscrite au FIJAIT ou au fichier des infractions sexuelles/violentes peut être concernée par l’article 74-2 si :",
    options: [
      "Elle est simplement inscrite au fichier, sans manquement",
      "Elle a manqué à ses obligations prévues respectivement par les articles 706-25-7 ou 706-53-5",
      "Elle demande une révision de son procès",
    ],
    answer:
        "Elle a manqué à ses obligations prévues respectivement par les articles 706-25-7 ou 706-53-5",
    explanation:
        "L’article 74-2 vise le manquement aux obligations attachées à ces fichiers, pas la simple inscription.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Autorités habilitées — Répartition des rôles",
    question:
        "Dans le cadre des interceptions autorisées par 74-2, la répartition des rôles est la suivante :",
    options: [
      "Le JLD exécute les interceptions, le procureur se contente de les autoriser",
      "Le JLD autorise, le procureur et l’OPJ exécutent et contrôlent matériellement",
      "L’OPJ autorise et exécute seul les interceptions",
    ],
    answer:
        "Le JLD autorise, le procureur et l’OPJ exécutent et contrôlent matériellement",
    explanation:
        "Le JLD autorise l’interception, tandis que les attributions de mise en œuvre sont exercées par le procureur ou l’OPJ requis.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actes de l’enquête — Limites",
    question:
        "Pourquoi la garde à vue est-elle exclue de la procédure de l’article 74-2 du C.P.P. ?",
    options: [
      "Parce que la garde à vue n’existe plus en droit français",
      "Parce que la finalité de 74-2 est de localiser une personne déjà visée par un titre et non de l’entendre sous contrainte",
      "Parce que seul le préfet peut décider d’une garde à vue",
    ],
    answer:
        "Parce que la finalité de 74-2 est de localiser une personne déjà visée par un titre et non de l’entendre sous contrainte",
    explanation:
        "La procédure vise à rechercher la personne afin d’exécuter un mandat ou une décision, non à reprendre une enquête de garde à vue.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Interceptions — Correctionnel / Criminel",
    question:
        "En matière criminelle, la durée totale des interceptions autorisées dans le cadre de l’article 74-2 est :",
    options: [
      "Limitée à 6 mois comme en correctionnel",
      "Limitée à 1 an maximum",
      "Sans limitation de durée légale tant que les renouvellements sont justifiés",
    ],
    answer:
        "Sans limitation de durée légale tant que les renouvellements sont justifiés",
    explanation:
        "Le texte prévoit une limite de 6 mois en correctionnel, mais aucune limite en matière criminelle, sous réserve de décisions motivées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Interceptions — Lignes d’avocat",
    question:
        "Dans quel cas une ligne dépendant du cabinet ou domicile d’un avocat peut-elle être interceptée dans le cadre 74-2 ?",
    options: [
      "Jamais, quelle que soit la situation",
      "Uniquement s’il existe des raisons plausibles de soupçonner l’avocat d’avoir commis ou tenté de commettre une infraction objet de la procédure ou connexe",
      "Uniquement si l’avocat y consent par écrit",
    ],
    answer:
        "Uniquement s’il existe des raisons plausibles de soupçonner l’avocat d’avoir commis ou tenté de commettre une infraction objet de la procédure ou connexe",
    explanation:
        "Cette exception est prévue par les articles 100 et 100-7, applicables par renvoi de l’article 74-2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Techniques spéciales — Conditions cumulatives",
    question:
        "Pour recourir à l’IMSI-catcher dans le cadre 74-2, il faut notamment :",
    options: [
      "Uniquement que la personne soit recherchée pour une contravention",
      "Que la personne fasse l’objet d’une des décisions 1°, 2°, 3° ou 6° et que l’infraction entre dans le champ de 706-73 ou 706-73-1",
      "Que le préfet donne son autorisation",
    ],
    answer:
        "Que la personne fasse l’objet d’une des décisions 1°, 2°, 3° ou 6° et que l’infraction entre dans le champ de 706-73 ou 706-73-1",
    explanation:
        "Les techniques spéciales du titre XXV sont réservées aux infractions de criminalité organisée ou assimilées, et à certaines décisions relatives à la personne recherchée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Techniques spéciales — Respect des lieux protégés",
    question:
        "Dans le cadre d’une sonorisation via 74-2, quel est l’un des risques majeurs de nullité ?",
    options: [
      "L’absence de présence d’un OPJ sur les lieux",
      "La mise en place du dispositif dans un lieu protégé (cabinet d’avocat, locaux de presse, etc.)",
      "L’absence de signature de l’APJ",
    ],
    answer:
        "La mise en place du dispositif dans un lieu protégé (cabinet d’avocat, locaux de presse, etc.)",
    explanation:
        "Les textes interdisent la mise en place de sonorisations dans certains lieux protégés ; le non-respect de ces règles entraîne la nullité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Articulation — Mandat d’arrêt européen",
    question:
        "Dans le cadre d’un mandat d’arrêt européen, l’utilisation de la procédure 74-2 permet :",
    options: [
      "Uniquement de contrôler la régularité de la décision étrangère",
      "D’utiliser les mêmes moyens de recherche qu’en cas de mandat d’arrêt national, sous réserve des textes spécifiques",
      "De prononcer soi-même la peine étrangère",
    ],
    answer:
        "D’utiliser les mêmes moyens de recherche qu’en cas de mandat d’arrêt national, sous réserve des textes spécifiques",
    explanation:
        "Les dispositions de 74-2 sont déclarées applicables au mandat d’arrêt européen (art. 695-36 C.P.P.).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Articulation — Extradition",
    question: "En matière d’extradition, le recours à l’article 74-2 permet :",
    options: [
      "De remplacer la procédure d’extradition par une procédure simplifiée",
      "De rechercher la personne réclamée sur le territoire national en utilisant les moyens prévus par 74-2",
      "D’obliger l’État étranger à remettre immédiatement la personne",
    ],
    answer:
        "De rechercher la personne réclamée sur le territoire national en utilisant les moyens prévus par 74-2",
    explanation:
        "L’article 696-21 C.P.P. rend applicables les dispositions de 74-2 pour la recherche des personnes visées par une demande d’extradition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Procédure — Information du JLD",
    question:
        "Pourquoi le législateur impose-t-il d’informer sans délai le JLD des actes accomplis dans le cadre des interceptions 74-2 ?",
    options: [
      "Pour lui permettre d’interroger la personne recherchée",
      "Pour garantir un contrôle juridictionnel continu sur la légalité et la proportionnalité des mesures",
      "Pour permettre au JLD de gérer les scellés au commissariat",
    ],
    answer:
        "Pour garantir un contrôle juridictionnel continu sur la légalité et la proportionnalité des mesures",
    explanation:
        "Le JLD exerce un contrôle permanent sur ces mesures très intrusives, d’où l’obligation d’information sans délai.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Procédure — Déclenchement de 74-2",
    question:
        "Quel serait le défaut majeur d’une enquête prétendument menée sur le fondement de l’article 74-2 alors qu’aucune instruction écrite ou orale du procureur n’apparaît en procédure ?",
    options: [
      "Un simple vice de forme sans conséquence",
      "L’absence de base légale du cadre 74-2, pouvant entraîner la nullité des actes",
      "Une simple irrégularité matérielle du procès-verbal",
    ],
    answer:
        "L’absence de base légale du cadre 74-2, pouvant entraîner la nullité des actes",
    explanation:
        "L’article 74-2 exige clairement des instructions du procureur ; à défaut, l’OPJ serait hors cadre légal pour les actes spécifiques à ce dispositif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Techniques spéciales — Proportionnalité",
    question:
        "Dans le cadre de 74-2, le recours à des techniques spéciales très intrusives (sonorisation, captation de données) doit respecter principalement :",
    options: [
      "Un principe de simplicité administrative",
      "Un principe de proportionnalité par rapport à la gravité de l’infraction et à l’objectif de recherche",
      "Un principe de rapidité purement opérationnelle",
    ],
    answer:
        "Un principe de proportionnalité par rapport à la gravité de l’infraction et à l’objectif de recherche",
    explanation:
        "Même autorisées par la loi, ces techniques doivent rester proportionnées, ce qui est apprécié par le JLD ou le magistrat compétent.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizPersonnesFuitePage extends StatefulWidget {
  static const String routeName = '/gpx/generalites/quiz/personnes_fuite';
  final String uid;
  final String email;

  const QuizPersonnesFuitePage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizPersonnesFuitePage> createState() => _QuizPersonnesFuitePageState();
}

class _QuizPersonnesFuitePageState extends State<QuizPersonnesFuitePage>
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
        ? questionsPersonnesFuite
        : questionsPersonnesFuite
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
            'module_name': 'Cadres Juridiques',
            'quiz_name': 'Personnes en fuite',
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
      final int total = _qs.length.clamp(1, 1 << 30);
      final int percent = ((_score / total) * 100).round();

      await _sb
          .from('quiz_history')
          .update({
            'score': percent,
            'correct_count': _score,
            'finished_at': DateTime.now().toUtc().toIso8601String(),
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _historyRowId!)
          .eq('uid', widget.uid);
    } catch (e) {
      debugPrint('❌ quiz_history (finish) update failed: $e');
    }
  }

  Future<void> _saveAnswer({
    required String question,
    required String userAnswer,
    required String correctAnswer,
    required bool isCorrect,
    required String difficulty,
  }) async {
    try {
      await _sb.from('quiz_personnes_fuite').insert({
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
      debugPrint('❌ quiz_personnes_fuite insert failed: $e');
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
      await _updateHistoryOnFinish();
      if (!mounted) return;
      _openResultDialog(_score, _qs.length);
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
      builder: (_, c) {
        final s = c.maxWidth * 0.56;
        final size = s.clamp(140.0, 240.0);
        return SizedBox(
          height: size,
          child: Center(
            // >>> Choisis UNE des 3 lignes ci-dessous <<<
            // child: _FeedbackConfettiBurst(controller: controller, good: good, size: size),
            // child: _FeedbackStrokeDraw(controller: controller, good: good, size: size),
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
        // t normalisé 0..1 (au cas où)
        final t =
            ((controller.value - controller.lowerBound) /
                    (controller.upperBound - controller.lowerBound))
                .clamp(0.0, 1.0);
        final icon = good ? Icons.check_rounded : Icons.close_rounded;
        final iconSize = size * .30;

        const n = 8;
        final maxR = size * .58;
        final kids = <Widget>[];

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

        return Stack(
          alignment: Alignment.center,
          children: [
            ...kids,
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
