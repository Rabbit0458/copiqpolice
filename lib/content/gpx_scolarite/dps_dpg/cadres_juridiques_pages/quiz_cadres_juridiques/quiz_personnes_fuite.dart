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
  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
    category: "Interceptions — Durée",
    question:
        "Dans le cadre de l’article 74-2, la durée initiale maximale d’une autorisation d’interception téléphonique est de :",
    options: ["Un mois", "Deux mois", "Six mois"],
    answer: "Deux mois",
    explanation:
        "L’autorisation est délivrée pour une durée maximale de deux mois, renouvelable dans les mêmes conditions.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Interceptions — Limite en matière correctionnelle",
    question:
        "En matière correctionnelle, la durée totale des interceptions autorisées dans le cadre de l’article 74-2 est limitée à :",
    options: ["Deux mois", "Quatre mois", "Six mois"],
    answer: "Six mois",
    explanation:
        "En matière correctionnelle, la durée totale ne peut excéder six mois, même en cas de renouvellements.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
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

  const QuizQuestion(
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
  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
    category: "Interceptions — Conditions générales",
    question:
        "Pour autoriser des interceptions dans le cadre de l’article 74-2, la peine encourue pour l’infraction doit être :",
    options: ["D’au moins 1 an", "D’au moins 3 ans", "D’au moins 10 ans"],
    answer: "D’au moins 3 ans",
    explanation:
        "Les articles 100 et suivants, auxquels renvoie l’article 74-2, imposent que la peine encourue soit égale ou supérieure à 3 ans.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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
  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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
  static const String routeName = '/gpx/dps/generalites/quiz/personnes_fuite';
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
        final bg = isDark ? const Color(0xFF000B36) : _Brand.bgLight;
        final textCol = isDark ? Colors.white : _Brand.textDark;
        final base = isDark ? ThemeData.dark() : ThemeData.light();

        const double kButtonHeight = 56;
        const double kButtonVPad = 16;
        const double bottomBarReserved = kButtonHeight + kButtonVPad + 8;

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
            child: Stack(
              children: [
                Positioned.fill(child: _QuizBackdrop(isDark: isDark)),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.close_rounded, color: textCol),
                      onPressed: _fermerQuiz,
                      tooltip: 'Fermer',
                    ),
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
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          height: kButtonHeight,
                                          child: OutlinedButton.icon(
                                            onPressed: _endQuizNow,
                                            icon: const Icon(
                                              Icons.stop_circle_outlined,
                                              size: 18,
                                            ),
                                            label: const Text('Mettre fin'),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: const Color(
                                                0xFFE03131,
                                              ),
                                              side: const BorderSide(
                                                color: Color(0xFFE03131),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            // L'overlay de feedback a été retiré : il se superposait au bandeau
                            // d'explication dès que l'énoncé était long. L'animation vit
                            // maintenant dans `_OutcomeIcon`, bornée par le bandeau.
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
  /// Garde de réentrance des sorties : deux dialogues de confirmation ne peuvent
  /// pas se superposer (croix tapée deux fois, ou croix pendant un geste retour).
  bool _sortieEnCours = false;

  /// Ferme le quiz après confirmation. Chemin unique de la croix et, quand il
  /// existe, du geste retour système — sans quoi celui-ci contournerait la
  /// confirmation.
  Future<void> _fermerQuiz() async {
    // Avant le démarrage, la croix quitte directement. Pendant un quiz, elle
    // exécute exactement la même clôture que le bouton « Mettre fin ».
    if (!_hasQuiz) {
      if (mounted) _quitterEcran();
      return;
    }
    await _endQuizNow();
  }

  Future<void> _endQuizNow() async {
    if (!_hasQuiz || _sortieEnCours) return;
    _sortieEnCours = true;
    try {
      final confirme = await _confirmerSortie(
        titre: 'Mettre fin au quiz ?',
        actionLabel: 'Mettre fin',
      );
      if (!confirme || !mounted) return;
      final answered = _answers.where((answer) => answer != null).length;
      await _updateHistoryOnFinish();
      if (!mounted) return;
      _openResultDialog(_score, answered.clamp(1, 1 << 30));
    } finally {
      _sortieEnCours = false;
    }
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
                              _ElementCascade(
                                animation: _fenetre(_rangMoyen),
                                child: _LevelCard(
                                  label: 'Moyen',
                                  icon: Icons.military_tech_rounded,
                                  tint: const Color(0xFFF59E0B),
                                  active: widget.selected == 'Moyenne',
                                  onTap: () => widget.onSelect('Moyenne'),
                                  isDark: isDark,
                                ),
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
