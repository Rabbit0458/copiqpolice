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

/// =============================================================
///  QUIZ — CADRE LÉGAL D’USAGE DES ARMES (art. L. 435-1
///  du Code de la sécurité intérieure + lien avec la légitime
///  défense art. 122-5 du Code pénal)
///
///  Remplace ton ancien tableau par celui-ci.
///  (tu peux bien sûr l’enrichir encore si besoin)
/// =============================================================
final List<QuizQuestion> questionsDisparition = [
  // ===================== NIVEAU FACILE =====================
  QuizQuestion(
    category: "Généralités — Disparitions inquiétantes",
    question:
        "Quel est l’objectif principal du cadre de l’article 74-1 du C.P.P. ?",
    options: [
      "Rechercher les causes d’un crime déjà constaté",
      "Découvrir la personne disparue",
      "Organiser la garde à vue des proches de la personne disparue",
    ],
    answer: "Découvrir la personne disparue",
    explanation:
        "L’article 74-1 C.P.P. instaure un cadre d’enquête spécifique dont la finalité première est la découverte de la personne disparue, avant même de caractériser une infraction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Généralités — Disparitions inquiétantes",
    question:
        "Sur quel type de personnes l’article 74-1 du C.P.P. s’applique-t-il à l’origine ?",
    options: [
      "Uniquement aux majeurs non protégés",
      "Uniquement aux personnes âgées de plus de 70 ans",
      "Aux mineurs et aux majeurs protégés",
    ],
    answer: "Aux mineurs et aux majeurs protégés",
    explanation:
        "Le texte vise d’abord la disparition d’un mineur ou d’un majeur protégé ; il est ensuite étendu aux majeurs présentant un caractère inquiétant ou suspect.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Conditions — Disparition flagrante",
    question:
        "Quelle condition de temporalité est exigée par l’article 74-1 pour la disparition ?",
    options: [
      "Qu’elle ait eu lieu il y a plus d’un mois",
      "Qu’elle vienne d’intervenir ou d’être constatée",
      "Qu’elle soit déclarée depuis au moins 48 heures",
    ],
    answer: "Qu’elle vienne d’intervenir ou d’être constatée",
    explanation:
        "Le texte exige le caractère « flagrant » de la disparition : elle doit venir d’intervenir ou d’être constatée pour justifier ce cadre spécifique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Conditions — Caractère inquiétant",
    question:
        "Quelles sont les deux conditions générales pour appliquer les articles 74-1 et 80-4 du C.P.P. ?",
    options: [
      "Une disparition ancienne et une plainte de la famille",
      "Une disparition flagrante et un caractère inquiétant",
      "Une disparition volontaire et une fugue avérée",
    ],
    answer: "Une disparition flagrante et un caractère inquiétant",
    explanation:
        "Le fascicule précise que deux conditions doivent être réunies : la disparition doit être flagrante et présenter un caractère inquiétant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Conditions — Disparitions obligatoirement inquiétantes",
    question:
        "Parmi les propositions suivantes, laquelle correspond à une disparition obligatoirement inquiétante ?",
    options: [
      "Tout majeur non protégé de plus de 30 ans",
      "Toute disparition de mineur",
      "Toute personne ayant déjà fugué plusieurs fois",
    ],
    answer: "Toute disparition de mineur",
    explanation:
        "Les disparitions de mineurs et de majeurs protégés sont toujours considérées comme inquiétantes, même en cas de fugue habituelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Conditions — Disparitions obligatoirement inquiétantes",
    question:
        "La disparition de quel type de personne est automatiquement considérée comme inquiétante au sens de l’article 74-1 ?",
    options: [
      "Toute personne sans domicile fixe",
      "Tout majeur protégé (tutelle, curatelle, sauvegarde de justice)",
      "Toute personne bénéficiant du RSA",
    ],
    answer: "Tout majeur protégé (tutelle, curatelle, sauvegarde de justice)",
    explanation:
        "Les majeurs protégés placés sous sauvegarde de justice, tutelle ou curatelle font partie des disparitions obligatoirement inquiétantes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Conditions — Disparitions inquiétantes par circonstances",
    question:
        "La disparition d’un adulte non protégé peut être jugée inquiétante lorsqu’elle fait craindre :",
    options: [
      "Un simple changement d’emploi",
      "Un projet de déménagement à l’étranger",
      "Un danger pour la personne, lié à son âge, sa santé ou les circonstances",
    ],
    answer:
        "Un danger pour la personne, lié à son âge, sa santé ou les circonstances",
    explanation:
        "Les disparitions inquiétantes en raison des circonstances reposent sur un risque pour la personne disparue (âge, santé, contexte de la disparition).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Acteurs — Procureur de la République",
    question:
        "Qui doit obligatoirement être avisé lorsque les enquêteurs souhaitent utiliser le cadre de l’article 74-1 du C.P.P. ?",
    options: [
      "Le maire de la commune",
      "Le procureur de la République",
      "Le préfet de département",
    ],
    answer: "Le procureur de la République",
    explanation:
        "Ce cadre spécifique ne peut être mis en œuvre que sur instructions du procureur de la République, qui doit donc être immédiatement avisé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Acteurs — Procureur de la République",
    question:
        "Quel choix n’appartient PAS au procureur de la République lorsqu’il est avisé d’une disparition inquiétante ?",
    options: [
      "Décider une procédure administrative de recherche",
      "Ordonner des investigations dans le cadre de l’article 74-1",
      "Prononcer une peine d’emprisonnement contre les proches",
    ],
    answer: "Prononcer une peine d’emprisonnement contre les proches",
    explanation:
        "Le procureur dirige l’enquête, mais ne prononce pas de peine : seul un juge de jugement peut condamner pénalement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Acteurs — OPJ / APJ",
    question:
        "Sous l’empire de l’article 74-1, qui peut accomplir les actes des articles 56 à 62 du C.P.P. ?",
    options: [
      "Les seuls agents de police judiciaire, sans contrôle",
      "Les OPJ et, sous leur contrôle, les APJ",
      "Uniquement les gendarmes gradés",
    ],
    answer: "Les OPJ et, sous leur contrôle, les APJ",
    explanation:
        "Comme en flagrance, ce sont les OPJ qui dirigent les actes, assistés le cas échéant par les APJ agissant sous leur contrôle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actes — Garde à vue",
    question:
        "Une garde à vue peut-elle être décidée sur le seul fondement de l’article 74-1 C.P.P. ?",
    options: [
      "Oui, dès le début de l’enquête",
      "Oui, uniquement pour les proches du disparu",
      "Non, aucune suspicion de crime ou délit n’est encore caractérisée",
    ],
    answer: "Non, aucune suspicion de crime ou délit n’est encore caractérisée",
    explanation:
        "Le texte précise que le cadre 74-1 ne permet pas de placer en garde à vue, faute de suspicion d’infraction déterminée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Sanctions — Non-signalement",
    question:
        "Quelle est la peine encourue pour une personne qui, connaissant la disparition d’un mineur de moins de 15 ans, n’en informe pas les autorités pour retarder les recherches (art. 434-4-1 C.P.) ?",
    options: [
      "Deux ans d’emprisonnement et 30 000 € d’amende",
      "Six mois d’emprisonnement et 7 500 € d’amende",
      "Cinq ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "Deux ans d’emprisonnement et 30 000 € d’amende",
    explanation:
        "Le rappel du fascicule précise que le non-signalement volontaire d’une telle disparition est puni de 2 ans d’emprisonnement et 30 000 € d’amende.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Suites — Personne retrouvée",
    question:
        "Lorsque la personne disparue (mineur ou majeur protégé) est retrouvée et que les causes ne sont ni criminelles ni délictuelles, l’adresse peut être communiquée aux proches :",
    options: [
      "Uniquement avec l’accord du juge des enfants ou du juge des tutelles",
      "Libre­ment, à toute personne qui en fait la demande",
      "Uniquement au maire de la commune",
    ],
    answer:
        "Uniquement avec l’accord du juge des enfants ou du juge des tutelles",
    explanation:
        "Le texte protège la vie privée du mineur ou du majeur protégé : l’adresse ne peut être révélée sans l’accord du juge compétent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Suites — Personne retrouvée",
    question:
        "Lorsque la personne disparue est majeure non protégée et retrouvée, à quelle condition son adresse peut-elle être communiquée ?",
    options: [
      "Avec l’accord du maire",
      "Avec l’accord de l’intéressé",
      "Sans aucune condition",
    ],
    answer: "Avec l’accord de l’intéressé",
    explanation:
        "Pour les majeurs non protégés, la communication de l’adresse nécessite leur accord, afin de respecter leur vie privée.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  QuizQuestion(
    category: "Généralités — Nature du cadre 74-1",
    question:
        "Pourquoi dit-on que le cadre de l’article 74-1 du C.P.P. est « spécifique » ?",
    options: [
      "Parce qu’il ne peut être utilisé qu’en matière de terrorisme",
      "Parce qu’il repose sur une disparition inquiétante sans constatation préalable d’infraction",
      "Parce qu’il est réservé à la gendarmerie nationale",
    ],
    answer:
        "Parce qu’il repose sur une disparition inquiétante sans constatation préalable d’infraction",
    explanation:
        "Le cadre est spécifique car il permet des investigations poussées alors qu’aucun crime ou délit n’est encore caractérisé, la base étant la disparition inquiétante.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Généralités — Nature transitoire",
    question:
        "En quoi le cadre de l’article 74-1 du C.P.P. est-il qualifié de « transitoire » ?",
    options: [
      "Il cesse automatiquement après 24 heures",
      "Il doit obligatoirement être remplacé par une enquête administrative",
      "Il prend fin dès que la disparition est élucidée ou qu’un cadre de droit commun s’impose",
    ],
    answer:
        "Il prend fin dès que la disparition est élucidée ou qu’un cadre de droit commun s’impose",
    explanation:
        "Ce cadre est provisoire : il s’arrête soit lorsque la disparition est résolue (volontaire, non inquiétante), soit lorsque des indices de crime ou délit imposent flagrance, préliminaire ou instruction classique.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Conditions — Disparitions inquiétantes par circonstances",
    question:
        "La disparition d’un adulte non protégé traité pour une grave dépression, disparu subitement sans explication, doit être appréciée comme :",
    options: [
      "Une disparition banale relevant du simple choix de vie",
      "Une disparition inquiétante en raison des circonstances et de l’état de santé",
      "Une disparition qui exclut le recours à l’article 74-1",
    ],
    answer:
        "Une disparition inquiétante en raison des circonstances et de l’état de santé",
    explanation:
        "L’état de santé (dépression, tendances suicidaires) et le caractère subit de la disparition font entrer dans la catégorie des disparitions inquiétantes par circonstances.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Acteurs — Procureur de la République",
    question:
        "Le procureur de la République, avisé d’une disparition inquiétante, ne peut PAS :",
    options: [
      "Décider une enquête selon l’article 74-1",
      "Lancer une enquête préliminaire classique",
      "Refuser toute investigation et classer sans suite d’office sans examen",
    ],
    answer:
        "Refuser toute investigation et classer sans suite d’office sans examen",
    explanation:
        "Chaque signalement doit être examiné attentivement ; le procureur peut privilégier la voie administrative, judiciaire 74-1, préliminaire ou information, mais pas ignorer la situation sans appréciation.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Acteurs — Procureur de la République",
    question:
        "Dans quel cas le procureur peut-il déclencher le plan « Alerte enlèvement » ?",
    options: [
      "Lors de toute disparition de majeur",
      "En cas d’enlèvement avéré d’un mineur",
      "Uniquement à la demande expresse de la famille",
    ],
    answer: "En cas d’enlèvement avéré d’un mineur",
    explanation:
        "La circulaire rappelle que, lors de l’enlèvement avéré d’un mineur, le procureur territorialement compétent apprécie l’opportunité de déclencher le plan « Alerte enlèvement ». ",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Acteurs — Juge d’instruction",
    question:
        "Lorsque le procureur requiert l’ouverture d’une information sur le fondement de l’article 80-4 du C.P.P., le juge d’instruction est saisi pour :",
    options: [
      "Rechercher les causes de la disparition",
      "Poursuivre immédiatement le ou les auteurs mis en cause",
      "Statuer sur la culpabilité de la personne disparue",
    ],
    answer: "Rechercher les causes de la disparition",
    explanation:
        "L’information ouverte sur le fondement des articles 74-1 et 80-4 a pour seul objet la recherche des causes de la disparition, sans saisine globale des faits.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Acteurs — Juge d’instruction",
    question:
        "L’information ouverte sur le fondement des articles 74-1 et 80-4 du C.P.P. a pour particularité :",
    options: [
      "De mettre automatiquement en mouvement l’action publique",
      "De ne pas mettre en mouvement l’action publique",
      "D’interdire toute constitution de partie civile",
    ],
    answer: "De ne pas mettre en mouvement l’action publique",
    explanation:
        "Cette information est exorbitante du droit commun : elle vise uniquement à rechercher les causes de la disparition et ne déclenche pas ipso facto l’action publique.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Acteurs — Famille / partie civile",
    question:
        "Dans le cadre de l’article 80-4 du C.P.P., comment la famille de la personne disparue peut-elle intervenir dans la procédure ?",
    options: [
      "En provoquant directement l’ouverture de l’information en recherche des causes",
      "En se constituant partie civile à titre incident dans l’information ouverte par le parquet",
      "En imposant au parquet l’ouverture d’une information par simple courrier",
    ],
    answer:
        "En se constituant partie civile à titre incident dans l’information ouverte par le parquet",
    explanation:
        "La famille ne peut pas provoquer elle-même l’ouverture de l’information « recherches des causes de la disparition », mais peut se constituer partie civile une fois celle-ci ouverte.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Acteurs — OPJ / APJ",
    question:
        "Que doit faire l’OPJ ou l’APJ lorsqu’une disparition lui est signalée et qu’il la juge inquiétante ?",
    options: [
      "Attendre 24 heures avant de saisir le parquet",
      "Prévenir immédiatement le procureur de la République pour décider du cadre des recherches",
      "Décider seul d’ouvrir une information judiciaire",
    ],
    answer:
        "Prévenir immédiatement le procureur de la République pour décider du cadre des recherches",
    explanation:
        "L’OPJ ou l’APJ apprécie le caractère inquiétant, puis en avise sans délai le procureur, seul compétent pour choisir le cadre (administratif, 74-1, préliminaire ou information).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Actes — Pouvoirs de l’OPJ (art. 56 à 62)",
    question:
        "Dans le cadre de l’article 74-1, quels types d’actes l’OPJ peut-il accomplir sur instructions du procureur de la République ?",
    options: [
      "Uniquement entendre les proches de la victime",
      "Tous les actes prévus aux articles 56 à 62 du C.P.P. (perquisitions, saisies, réquisitions, convocations…) sans garde à vue",
      "Uniquement des contrôles d’identité",
    ],
    answer:
        "Tous les actes prévus aux articles 56 à 62 du C.P.P. (perquisitions, saisies, réquisitions, convocations…) sans garde à vue",
    explanation:
        "Le fascicule précise que l’OPJ peut user de l’ensemble des pouvoirs de l’enquête de flagrance prévus aux articles 56 à 62, à l’exception de la garde à vue.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Actes — Durée du cadre 74-1",
    question:
        "Combien de temps les investigations peuvent-elles être menées sous le régime de l’article 74-1 avant de basculer éventuellement vers un autre cadre ?",
    options: [
      "48 heures",
      "Huit jours à compter des instructions du procureur",
      "Un mois renouvelable",
    ],
    answer: "Huit jours à compter des instructions du procureur",
    explanation:
        "À l’issue d’un délai de 8 jours, les recherches peuvent se poursuivre dans les formes de l’enquête préliminaire, sauf ouverture d’une information.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Actes — Suite après 8 jours",
    question:
        "À l’issue des huit jours d’enquête sous article 74-1, si la disparition demeure inquiétante, le procureur peut :",
    options: [
      "Imposer la clôture de toute investigation",
      "Poursuivre les recherches en enquête préliminaire ou requérir l’ouverture d’une information",
      "Prononcer lui-même une peine contre la famille",
    ],
    answer:
        "Poursuivre les recherches en enquête préliminaire ou requérir l’ouverture d’une information",
    explanation:
        "Le texte prévoit explicitement la poursuite sous forme d’enquête préliminaire ou l’ouverture d’une information de recherche des causes.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Actes — Information 80-4",
    question:
        "Dans le cadre d’une information « recherche des causes de la disparition », quelle est la durée maximale des interceptions téléphoniques possibles ?",
    options: [
      "Deux mois renouvelables",
      "Un mois non renouvelable",
      "Six mois non renouvelables",
    ],
    answer: "Deux mois renouvelables",
    explanation:
        "Le texte précise que les interceptions dans ce cadre ne peuvent excéder deux mois, renouvelables une fois, sous contrôle du juge d’instruction.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Suites — Personne non retrouvée",
    question:
        "Si la personne disparue n’est pas retrouvée, quelle option ne figure PAS parmi les suites possibles mentionnées par le texte ?",
    options: [
      "Requérir une information pour recherche des causes de la disparition",
      "Poursuivre l’information déjà ouverte",
      "Clore définitivement le dossier sans suite obligatoire",
    ],
    answer: "Clore définitivement le dossier sans suite obligatoire",
    explanation:
        "Le texte prévoit soit l’ouverture, soit la poursuite d’une information, soit la poursuite des investigations en préliminaire, mais pas une clôture automatique sans suite.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Suites — Caractère criminel ou délictuel",
    question:
        "Lorsque l’enquête diligentée au titre de l’article 74-1 permet d’établir l’existence d’une infraction à l’origine de la disparition, le procureur peut :",
    options: [
      "Revenir au cadre administratif de recherche de personnes",
      "Poursuivre en flagrant délit ou en enquête préliminaire, ou ouvrir une information classique",
      "Clore l’enquête car le cadre 74-1 est alors épuisé",
    ],
    answer:
        "Poursuivre en flagrant délit ou en enquête préliminaire, ou ouvrir une information classique",
    explanation:
        "Dès qu’un crime ou un délit est caractérisé, on bascule vers les cadres de droit commun : flagrance, préliminaire ou instruction pénale.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Exemples pratiques — Cas de mineur fugueur",
    question:
        "Un mineur placé en foyer, connu pour des fugues répétées, ne rentre pas à l’heure et reste introuvable. Comment doit être qualifiée cette disparition ?",
    options: [
      "Elle n’est pas inquiétante puisqu’il fugue souvent",
      "Elle est obligatoirement inquiétante au sens de l’article 74-1",
      "Elle relève seulement d’une procédure administrative de fugue",
    ],
    answer: "Elle est obligatoirement inquiétante au sens de l’article 74-1",
    explanation:
        "Le texte précise que toute disparition de mineur est inquiétante, même si l’intéressé a l’habitude de fuguer.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Exemples pratiques — Adulte en bonne santé",
    question:
        "Un adulte de 30 ans, sans antécédent médical ni difficulté particulière, quitte son domicile après une dispute et ne donne plus de nouvelles depuis 3 heures. Sans élément supplémentaire, comment apprécier cette situation ?",
    options: [
      "Comme automatiquement inquiétante au sens du texte",
      "Comme relevant d’abord d’une appréciation prudente, pouvant ne pas justifier immédiatement le recours à l’article 74-1",
      "Comme un enlèvement certain",
    ],
    answer:
        "Comme relevant d’abord d’une appréciation prudente, pouvant ne pas justifier immédiatement le recours à l’article 74-1",
    explanation:
        "L’article 74-1 repose sur un caractère inquiétant : en l’absence d’éléments sur l’âge, la santé ou les circonstances, le parquet peut privilégier d’abord une appréciation moins intrusive.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Exemples pratiques — Personne malade",
    question:
        "Une personne âgée souffrant de la maladie d’Alzheimer quitte son domicile sans prévenir et ne revient pas. Cette disparition doit être :",
    options: [
      "Considérée comme inquiétante en raison de l’âge et de l’état de santé",
      "Considérée comme une disparition volontaire sans danger",
      "Traitée uniquement par la famille, sans intervention judiciaire",
    ],
    answer:
        "Considérée comme inquiétante en raison de l’âge et de l’état de santé",
    explanation:
        "L’état de santé et la vulnérabilité de la personne justifient le recours au cadre des disparitions inquiétantes.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  QuizQuestion(
    category: "Analyse juridique — Articulation 74-1 / préliminaire",
    question:
        "Dans quel cas le procureur peut-il décider de ne pas appliquer l’article 74-1, mais de recourir directement à l’enquête préliminaire ?",
    options: [
      "Lorsque la disparition n’est ni flagrante ni inquiétante mais nécessite des vérifications",
      "Lorsque la disparition concerne automatiquement un mineur",
      "Lorsque la famille exige expressément l’application de l’article 74-1",
    ],
    answer:
        "Lorsque la disparition n’est ni flagrante ni inquiétante mais nécessite des vérifications",
    explanation:
        "Le parquet conserve la possibilité d’ordonner une enquête préliminaire classique lorsque les conditions spécifiques de l’article 74-1 ne sont pas réunies.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Analyse juridique — Nature de l’information 80-4",
    question:
        "Pourquoi l’information ouverte sur le fondement de l’article 80-4 du C.P.P. est-elle qualifiée d’« exorbitante du droit commun » ?",
    options: [
      "Parce qu’elle permet de condamner sans jugement",
      "Parce que le juge d’instruction n’est pas saisi de l’intégralité des faits et n’a pour objet que la recherche des causes de la disparition",
      "Parce qu’elle suspend les droits de la défense",
    ],
    answer:
        "Parce que le juge d’instruction n’est pas saisi de l’intégralité des faits et n’a pour objet que la recherche des causes de la disparition",
    explanation:
        "Contrairement à une information classique, le juge n’est saisi que d’une mission limitée : comprendre les causes de la disparition, sans mise en mouvement automatique de l’action publique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Analyse juridique — Garde à vue et découverte d’infraction",
    question:
        "Dans le cadre d’une information ouverte pour recherche des causes de la disparition, une garde à vue peut être décidée :",
    options: [
      "Envers toute personne proche de la victime, par précaution",
      "Uniquement s’il existe une ou plusieurs raisons plausibles de soupçonner une personne d’avoir commis une infraction révélée par l’enquête",
      "Jamais, car la garde à vue est exclue de ce cadre",
    ],
    answer:
        "Uniquement s’il existe une ou plusieurs raisons plausibles de soupçonner une personne d’avoir commis une infraction révélée par l’enquête",
    explanation:
        "Le texte précise que la garde à vue devient possible lorsque, au cours des investigations sur les causes de la disparition, des éléments laissent soupçonner la commission d’une infraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Techniques spéciales — Réquisitions et informatique",
    question:
        "Dans le cadre d’une information pour recherche des causes de la disparition, quelles opérations informatiques l’OPJ commis par le juge peut-il réaliser ?",
    options: [
      "Uniquement consulter les réseaux sociaux de la victime sans formalités",
      "Accéder, au cours d’une perquisition, à des données informatiques stockées sur des serveurs distants et requérir toute personne pour obtenir les moyens de protection",
      "Installer librement des logiciels espions sans autorisation judiciaire",
    ],
    answer:
        "Accéder, au cours d’une perquisition, à des données informatiques stockées sur des serveurs distants et requérir toute personne pour obtenir les moyens de protection",
    explanation:
        "Le fascicule rappelle les pouvoirs prévus aux articles 97-1 et 57-1 C.P.P. : accès aux données distantes, réquisition de toute personne connaissant les mesures de protection, dans le cadre des perquisitions autorisées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Techniques spéciales — Réquisitions opérateurs",
    question:
        "Quel est l’objet principal des réquisitions aux opérateurs de télécommunications mentionnées dans le cadre des disparitions inquiétantes ?",
    options: [
      "Demander aux opérateurs de couper la ligne de la personne disparue",
      "Assurer la préservation du contenu des informations consultées et la mise en place éventuelle d’un dispositif d’interception",
      "Obtenir les relevés bancaires de la personne disparue",
    ],
    answer:
        "Assurer la préservation du contenu des informations consultées et la mise en place éventuelle d’un dispositif d’interception",
    explanation:
        "Les articles 99-4, 60-2 et 100-3 à 100-5 C.P.P. visent la préservation des données, l’installation d’interceptions et la transcription des correspondances utiles à la manifestation de la vérité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Interceptions — Juges compétents",
    question:
        "Dans le cadre de l’article 74-1 (sans information), qui autorise les interceptions de correspondances par la voie des télécommunications ?",
    options: [
      "Le procureur de la République seul",
      "Le juge d’instruction saisi d’office",
      "Le juge des libertés et de la détention, à la demande du procureur",
    ],
    answer:
        "Le juge des libertés et de la détention, à la demande du procureur",
    explanation:
        "Le dispositif renvoie aux articles 100 et suivants : c’est le JLD qui autorise, sur requête du procureur, les interceptions et fixe leur durée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Interceptions — Lignes protégées",
    question:
        "Sous peine de nullité, quelles lignes téléphoniques ne peuvent être interceptées qu’après avis de leur autorité supérieure ?",
    options: [
      "Celles des fonctionnaires de police",
      "Celles des députés, sénateurs, avocats et magistrats",
      "Celles des délégués syndicaux",
    ],
    answer: "Celles des députés, sénateurs, avocats et magistrats",
    explanation:
        "Le rappel du fascicule vise les règles générales : les lignes dépendant des cabinets ou domiciles de parlementaires, avocats ou magistrats sont protégées et nécessitent un avis préalable.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Suites — Communication du dossier",
    question:
        "Pourquoi le droit à la communication du dossier prévu à l’article 114 du C.P.P. est-il restreint lorsque la personne disparue (mineur ou majeur protégé) est retrouvée ?",
    options: [
      "Parce que la procédure devient secrète à vie",
      "Parce que la communication ne peut se faire qu’en respectant les limitations destinées à protéger la vie privée ou la sécurité de la personne",
      "Parce que le dossier est automatiquement détruit",
    ],
    answer:
        "Parce que la communication ne peut se faire qu’en respectant les limitations destinées à protéger la vie privée ou la sécurité de la personne",
    explanation:
        "Le texte prévoit expressément que le droit de communication du dossier s’exerce sous réserve des restrictions visant à protéger la vie privée ou la sécurité du mineur ou du majeur protégé retrouvé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Comparaison — Article 74-1 vs recherche administrative",
    question:
        "En quoi le recours à l’article 74-1 du C.P.P. permet-il des investigations plus poussées que la simple procédure administrative de recherche de personnes ?",
    options: [
      "Il permet uniquement de diffuser une affiche de recherche",
      "Il autorise les actes d’enquête de flagrance (perquisitions, saisies, réquisitions, auditions forcées…) sous contrôle du procureur",
      "Il permet de condamner directement la personne disparue pour fugue",
    ],
    answer:
        "Il autorise les actes d’enquête de flagrance (perquisitions, saisies, réquisitions, auditions forcées…) sous contrôle du procureur",
    explanation:
        "La procédure administrative prévue par la loi du 21/01/1995 est moins intrusive ; l’article 74-1 ouvre la voie à de véritables actes d’enquête judiciaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Cas pratique — Disparition volontaire révélée",
    question:
        "Une enquête 74-1 est ouverte pour un majeur protégé. Deux jours plus tard, il est retrouvé sain et sauf, ayant quitté volontairement son domicile pour rejoindre un proche. Quelle conséquence procédurale en découle ?",
    options: [
      "Le cadre 74-1 prend fin, la disparition n’ayant plus de caractère inquiétant",
      "L’enquête doit se poursuivre obligatoirement 8 jours",
      "Le parquet doit ouvrir une information pénale",
    ],
    answer:
        "Le cadre 74-1 prend fin, la disparition n’ayant plus de caractère inquiétant",
    explanation:
        "Le caractère transitoire du cadre fait qu’il cesse dès que la disparition est élucidée et ne présente plus de risque pour la personne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Cas pratique — Suspicion de crime",
    question:
        "Au cours d’une enquête 74-1, les indices convergent vers un possible homicide commis sur la personne disparue. Quelle est la réaction juridiquement adaptée du parquet ?",
    options: [
      "Maintenir le cadre 74-1 jusqu’au terme des 8 jours",
      "Basculer vers une enquête de flagrance ou préliminaire pour homicide, ou ouvrir une information pénale classique",
      "Clore la procédure et laisser la famille agir seule",
    ],
    answer:
        "Basculer vers une enquête de flagrance ou préliminaire pour homicide, ou ouvrir une information pénale classique",
    explanation:
        "Dès qu’un crime est suspecté, le cadre spécifique 74-1 doit céder la place aux procédures de droit commun adaptées (flagrance, préliminaire, instruction).",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizDisparitionPage extends StatefulWidget {
  static const String routeName =
      '/gpx/generalites/quiz/disparitions_inquietantes';
  final String uid;
  final String email;

  const QuizDisparitionPage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizDisparitionPage> createState() => _QuizDisparitionPageState();
}

class _QuizDisparitionPageState extends State<QuizDisparitionPage>
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
        ? questionsDisparition
        : questionsDisparition
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
            'quiz_name': 'Disparitions Inquiétantes',
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
      await _sb.from('quiz_disparitions_inquietantes').insert({
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
      debugPrint('❌ quiz_disparitions_inquietantes insert failed: $e');
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
