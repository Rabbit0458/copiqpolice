// ignore_for_file: use_build_context_synchronously

// ============================================================================
//  Quiz UsageArmes – version refondue
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
final List<QuizQuestion> questionsUsageArmes = [
  // ===================== NIVEAU FACILE =====================
  QuizQuestion(
    category: "Cadre général",
    question:
        "Le cadre légal spécifique d’usage des armes par les policiers et gendarmes est prévu par :",
    options: [
      "L’article 122-5 du Code pénal",
      "L’article L. 435-1 du Code de la sécurité intérieure",
      "L’article L. 211-9 du Code de la sécurité intérieure",
    ],
    answer: "L’article L. 435-1 du Code de la sécurité intérieure",
    explanation:
        "Le document précise que le cadre commun aux agents de la police et de la gendarmerie nationales est fixé par l’article L. 435-1 du Code de la sécurité intérieure.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cadre général",
    question:
        "L’article L. 435-1 du Code de la sécurité intérieure s’applique aux policiers lorsqu’ils :",
    options: [
      "Font usage de leur arme dans l’exercice de leurs fonctions",
      "Portent une arme en dehors de tout service et de toute mission",
      "Partent en vacances à l’étranger",
    ],
    answer: "Font usage de leur arme dans l’exercice de leurs fonctions",
    explanation:
        "L’article vise les policiers et gendarmes régulièrement armés qui font usage de leur arme dans l’exercice de leurs fonctions.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Conditions préalables",
    question:
        "Combien de conditions préalables l’article L. 435-1 du Code de la sécurité intérieure impose-t-il avant tout usage d’une arme par un policier ?",
    options: ["Deux conditions", "Trois conditions", "Cinq conditions"],
    answer: "Trois conditions",
    explanation:
        "Le texte indique que l’article L. 435-1 du Code de la sécurité intérieure impose trois conditions préalables à l’usage d’une arme : l’exercice des fonctions, le port de l’uniforme ou d’insignes apparents, et l’absolue nécessité avec proportionnalité.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Conditions préalables",
    question:
        "La première condition préalable à l’usage d’une arme par un policier est :",
    options: [
      "Être en repos hebdomadaire",
      "Agir dans l’exercice de ses fonctions",
      "Être en tenue civile discrète",
    ],
    answer: "Agir dans l’exercice de ses fonctions",
    explanation:
        "Le policier doit agir dans l’exercice de ses fonctions, soit pendant son temps de service, soit hors service lorsqu’il agit au titre des obligations d’assistance aux personnes en danger.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Conditions préalables",
    question:
        "La deuxième condition préalable à l’usage d’une arme par un policier est :",
    options: [
      "Être seul sur l’intervention",
      "Être revêtu de son uniforme ou d’insignes extérieurs et apparents de sa qualité",
      "Être affecté en unité spécialisée",
    ],
    answer:
        "Être revêtu de son uniforme ou d’insignes extérieurs et apparents de sa qualité",
    explanation:
        "Le texte impose que le policier soit en uniforme ou porte des insignes extérieurs et apparents de sa qualité (par exemple le brassard police).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Conditions préalables",
    question:
        "La troisième condition préalable exige que l’usage de l’arme soit :",
    options: [
      "Moralement acceptable",
      "Absolument nécessaire et strictement proportionné",
      "Autorisé par un supérieur hiérarchique",
    ],
    answer: "Absolument nécessaire et strictement proportionné",
    explanation:
        "L’article L. 435-1 du Code de la sécurité intérieure impose une absolue nécessité et une stricte proportionnalité entre la menace et la riposte armée.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Policiers adjoints",
    question:
        "Les policiers adjoints peuvent-ils conserver leur arme individuelle en dehors des heures de service ?",
    options: [
      "Oui, comme les fonctionnaires actifs de la Police nationale",
      "Non, ils ne sont pas autorisés à conserver leur arme en dehors du service",
      "Oui, mais uniquement au domicile familial",
    ],
    answer:
        "Non, ils ne sont pas autorisés à conserver leur arme en dehors du service",
    explanation:
        "Le document précise que, contrairement aux fonctionnaires actifs, les policiers adjoints ne peuvent concevoir l’usage de leur arme hors service car ils ne sont pas autorisés à la conserver en dehors des heures de service.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Situations — Vue d’ensemble",
    question:
        "Lorsque les trois conditions préalables sont remplies, l’article L. 435-1 du Code de la sécurité intérieure autorise l’usage de l’arme dans :",
    options: ["Trois situations", "Cinq situations", "Dix situations"],
    answer: "Cinq situations",
    explanation:
        "Le cadre juridique spécifique prévoit cinq situations limitativement énumérées dans lesquelles l’usage de l’arme peut intervenir.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Situations — Somations",
    question:
        "Dans plusieurs situations prévues par l’article L. 435-1 (défense de lieux, fuite d’un individu dangereux, véhicule dangereux), les sommations :",
    options: [
      "Sont facultatives",
      "Sont obligatoires sauf impossibilité",
      "Sont interdites pour ne pas se dévoiler",
    ],
    answer: "Sont obligatoires sauf impossibilité",
    explanation:
        "Le texte parle de sommations obligatoires faites à haute voix, sauf impossibilité pratique liée à l’urgence ou à la nature de la menace.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Lien avec la légitime défense",
    question:
        "En dehors des cinq situations prévues à l’article L. 435-1 du Code de la sécurité intérieure (et hors dispersion d’attroupement), quel régime de droit commun reste applicable pour justifier l’usage des armes ?",
    options: [
      "L’article 122-5 du Code pénal sur la légitime défense",
      "L’article 122-1 du Code pénal sur l’irresponsabilité pénale pour trouble mental",
      "L’article 121-3 du Code pénal sur la faute d’imprudence",
    ],
    answer: "L’article 122-5 du Code pénal sur la légitime défense",
    explanation:
        "Lorsque le cadre spécial n’est pas applicable, l’usage de l’arme peut être apprécié au regard du régime général de la légitime défense prévu à l’article 122-5 du Code pénal.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU MOYEN =====================
  QuizQuestion(
    category: "Situation 1 — Atteintes à la vie",
    question:
        "La première situation de l’article L. 435-1 du Code de la sécurité intérieure permet l’usage des armes lorsque :",
    options: [
      "Des atteintes à la vie ou à l’intégrité physique sont portées contre le policier ou un tiers",
      "Un simple outrage est proféré contre un policier",
      "Une contravention routière est constatée",
    ],
    answer:
        "Des atteintes à la vie ou à l’intégrité physique sont portées contre le policier ou un tiers",
    explanation:
        "La situation 1 vise les atteintes à la vie ou à l’intégrité physique du policier ou d’un tiers, ou la menace d’une telle atteinte par des personnes armées.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Situation 1 — Atteintes à la vie",
    question:
        "Dans la situation 1 (atteintes à la vie ou à l’intégrité physique), le texte indique qu’il n’est pas prévu de procéder à des sommations car :",
    options: [
      "La loi les interdit absolument",
      "L’atteinte à la vie ou à l’intégrité physique est imminente",
      "Le policier n’a jamais le temps de parler",
    ],
    answer: "L’atteinte à la vie ou à l’intégrité physique est imminente",
    explanation:
        "Compte tenu de l’imminence de l’atteinte à la vie ou à l’intégrité physique, la réalisation de sommations peut être incompatible avec la sauvegarde des personnes.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Situation 2 — Lieux occupés",
    question:
        "La deuxième situation de l’article L. 435-1 concerne la défense des lieux occupés par les policiers ou des personnes qui leur sont confiées. L’usage des armes est possible :",
    options: [
      "Après avoir procédé à deux sommations à haute voix, sauf impossibilité",
      "Sans aucune sommation",
      "Seulement après autorisation écrite du procureur de la République",
    ],
    answer:
        "Après avoir procédé à deux sommations à haute voix, sauf impossibilité",
    explanation:
        "Le texte prévoit des sommations obligatoires à haute voix avant l’usage des armes pour défendre des lieux ou des personnes confiées, sauf impossibilité matérielle.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Situation 2 — Lieux occupés",
    question:
        "La défense des lieux occupés à titre permanent par les policiers peut viser par exemple :",
    options: [
      "Un poste de police ou un centre de rétention administrative",
      "Le domicile personnel d’un policier en repos",
      "Un commerce privé voisin du commissariat",
    ],
    answer: "Un poste de police ou un centre de rétention administrative",
    explanation:
        "Le document cite comme exemples un poste de police ou un centre de rétention administrative provisoire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Situation 3 — Fuite individu dangereux",
    question:
        "Dans la troisième situation (fuite d’un individu dangereux placé sous leur garde), l’usage des armes est possible après sommations lorsque :",
    options: [
      "Une personne cherche à s’échapper à leur garde au cours d’investigations",
      "Une personne refuse simplement de répondre aux questions",
      "Un témoin ne se présente pas à une audition",
    ],
    answer:
        "Une personne cherche à s’échapper à leur garde au cours d’investigations",
    explanation:
        "Le texte vise la personne placée sous garde à vue ou sous escorte qui tente de s’échapper alors qu’elle est sous la garde des policiers.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Situation 3 — Individu dangereux",
    question:
        "Dans la troisième situation, l’usage des armes n’est légitime que si les policiers disposent :",
    options: [
      "D’un simple doute sur la dangerosité",
      "De raisons réelles et objectives de penser que la personne représente une menace grave pour la vie ou l’intégrité physique",
      "D’une intuition personnelle",
    ],
    answer:
        "De raisons réelles et objectives de penser que la personne représente une menace grave pour la vie ou l’intégrité physique",
    explanation:
        "Le texte exige des raisons réelles et objectives de penser que l’individu, au moment de sa fuite, peut porter atteinte à la vie ou à l’intégrité physique des policiers ou d’autrui.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Situation 4 — Véhicule dangereux",
    question:
        "Dans la quatrième situation, les policiers peuvent faire usage de leur arme pour immobiliser un véhicule lorsque :",
    options: [
      "Le conducteur n’a pas obtempéré immédiatement à l’ordre d’arrêt et le véhicule est susceptible de porter atteinte à la vie ou à l’intégrité physique",
      "Le conducteur refuse un contrôle de documents",
      "Le véhicule est en stationnement gênant",
    ],
    answer:
        "Le conducteur n’a pas obtempéré immédiatement à l’ordre d’arrêt et le véhicule est susceptible de porter atteinte à la vie ou à l’intégrité physique",
    explanation:
        "L’article vise le refus d’obtempérer à un ordre d’arrêt accompagné de raisons réelles et objectives de penser que le véhicule ou ses occupants sont dangereux.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Situation 4 — Véhicule dangereux",
    question: "L’ordre d’arrêt, dans la quatrième situation, doit être :",
    options: [
      "Ambigu pour laisser une marge d’interprétation",
      "Équivoque et difficilement compréhensible",
      "Clair, explicite et constituer une injonction manifeste de s’arrêter",
    ],
    answer:
        "Clair, explicite et constituer une injonction manifeste de s’arrêter",
    explanation:
        "Le texte précise que l’ordre d’arrêt doit être dépourvu d’ambiguïté et clairement entendu par le conducteur.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Situation 4 — Limites",
    question:
        "Selon l’article L. 435-1, il ne peut être fait usage des armes pour immobiliser un véhicule dans le seul but :",
    options: [
      "D’empêcher une fuite lorsque le véhicule est manifestement dangereux",
      "De contraindre un véhicule à s’arrêter alors qu’il ne présente aucune dangerosité pour ses occupants",
      "De protéger la vie d’autrui face à un véhicule-bélier",
    ],
    answer:
        "De contraindre un véhicule à s’arrêter alors qu’il ne présente aucune dangerosité pour ses occupants",
    explanation:
        "Le texte rappelle que l’on ne peut pas utiliser l’arme pour contraindre un véhicule à s’arrêter lorsque ce véhicule n’est pas dangereux pour ses occupants ou pour autrui.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Situation 5 — Périple meurtrier",
    question:
        "Dans la cinquième situation, le périple meurtrier, les policiers peuvent faire usage de leur arme contre un individu lorsque la première condition suivante est remplie :",
    options: [
      "L’individu vient de commettre ou de tenter de commettre un ou plusieurs meurtres",
      "L’individu est simplement connu défavorablement de la police",
      "L’individu se trouve dans un quartier sensible",
    ],
    answer:
        "L’individu vient de commettre ou de tenter de commettre un ou plusieurs meurtres",
    explanation:
        "Le périple meurtrier concerne un individu qui vient de commettre ou de tenter de commettre un ou plusieurs meurtres.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Situation 5 — Périple meurtrier",
    question:
        "Toujours dans la cinquième situation, les policiers doivent avoir des raisons réelles et objectives de penser que :",
    options: [
      "L’individu va se rendre de lui-même",
      "Une réitération de ces crimes est probable dans un temps rapproché",
      "L’individu veut simplement fuir le pays",
    ],
    answer:
        "Une réitération de ces crimes est probable dans un temps rapproché",
    explanation:
        "Le texte exige que le policier ait des raisons réelles et objectives de penser qu’une réitération des meurtres est probable et proche dans le temps.",
    difficulty: "Moyenne",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  QuizQuestion(
    category: "Conditions préalables — Exercice des fonctions",
    question:
        "Un policier hors service, en tenue civile, assiste à une agression mortelle et intervient en utilisant son arme sans porter d’insigne extérieur. Pour apprécier la légalité de son geste, on pourra :",
    options: [
      "Écarter automatiquement toute justification",
      "Constater que la condition d’insignes extérieurs de l’article L. 435-1 n’est pas remplie et examiner subsidiairement la légitime défense au sens de l’article 122-5 du Code pénal",
      "Appliquer automatiquement la présomption de légitime défense",
    ],
    answer:
        "Constater que la condition d’insignes extérieurs de l’article L. 435-1 n’est pas remplie et examiner subsidiairement la légitime défense au sens de l’article 122-5 du Code pénal",
    explanation:
        "Le cadre spécial ne peut s’appliquer faute d’insignes apparents, mais le policier peut encore invoquer la légitime défense de droit commun s’il en remplit les conditions.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Somations — Appréciation",
    question:
        "Dans une situation de fuite d’un individu dangereux placé sous garde, les sommations ne sont pas matériellement possibles (tir immédiat nécessaire pour protéger une victime menacée d’un couteau). Juridiquement :",
    options: [
      "L’absence de sommations rend l’usage des armes illégal en toute hypothèse",
      "L’exigence de sommations peut être écartée si leur réalisation mettrait gravement en péril la vie des personnes",
      "Les sommations doivent toujours être effectuées, même si cela met en danger les victimes",
    ],
    answer:
        "L’exigence de sommations peut être écartée si leur réalisation mettrait gravement en péril la vie des personnes",
    explanation:
        "Le texte prévoit les sommations « sauf impossibilité », ce qui permet de les écarter en cas de danger immédiat pour la vie ou l’intégrité physique.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Situation 3 — Individu dangereux",
    question:
        "Un individu placé en garde à vue pour un délit mineur s’enfuit en courant, sans antécédent violent connu. Le policier, après deux sommations, fait usage de son arme pour l’empêcher de fuir. Quel critère fait le plus défaut ?",
    options: [
      "La fuite de l’individu",
      "Les raisons réelles et objectives de le considérer comme dangereux pour la vie ou l’intégrité physique",
      "La réalisation des sommations",
    ],
    answer:
        "Les raisons réelles et objectives de le considérer comme dangereux pour la vie ou l’intégrité physique",
    explanation:
        "La seule fuite ne suffit pas : il faut en plus des raisons réelles et objectives de penser que l’individu représente une menace grave pour la vie ou l’intégrité physique.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Situation 4 — Véhicule",
    question:
        "Lors d’un simple refus d’obtempérer à un contrôle routier, un véhicule prend la fuite à faible vitesse sur une route déserte. Aucun élément ne laisse penser que le conducteur est armé ou dangereux. Le tir sur le véhicule pour le contraindre à s’arrêter :",
    options: [
      "Entre dans la quatrième situation car il y a refus d’obtempérer",
      "N’est pas justifié car le véhicule ne présente pas de dangerosité particulière pour ses occupants ou pour autrui",
      "Est automatiquement couvert par la notion de fuite",
    ],
    answer:
        "N’est pas justifié car le véhicule ne présente pas de dangerosité particulière pour ses occupants ou pour autrui",
    explanation:
        "Le texte interdit d’utiliser les armes pour contraindre un véhicule à s’arrêter en l’absence de dangerosité réelle de ce véhicule ou de ses occupants.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Situation 5 — Périple meurtrier",
    question:
        "Dans la situation de périple meurtrier, l’usage des armes par les policiers suppose notamment que :",
    options: [
      "L’individu ait menacé verbalement de recommencer un jour",
      "L’individu soit susceptible de réitérer immédiatement les meurtres et que l’usage des armes soit le seul moyen d’empêcher cette réitération",
      "L’individu soit simplement en fuite après un vol simple",
    ],
    answer:
        "L’individu soit susceptible de réitérer immédiatement les meurtres et que l’usage des armes soit le seul moyen d’empêcher cette réitération",
    explanation:
        "Les conditions cumulatives sont la commission ou tentative de meurtre, la probabilité d’une réitération dans un temps rapproché et le caractère exclusif du recours aux armes pour l’empêcher.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Lien avec la légitime défense",
    question:
        "Un policier en uniforme, dans l’exercice de ses fonctions, fait usage de son arme dans une situation qui n’entre dans aucune des cinq hypothèses de l’article L. 435-1. Pour apprécier sa responsabilité, il conviendra :",
    options: [
      "De considérer que tout usage de l’arme est illégal en dehors des cinq situations",
      "D’examiner si les conditions de la légitime défense prévues par l’article 122-5 du Code pénal sont réunies",
      "De considérer l’usage comme automatiquement légitime",
    ],
    answer:
        "D’examiner si les conditions de la légitime défense prévues par l’article 122-5 du Code pénal sont réunies",
    explanation:
        "Le régime spécial n’exclut pas le recours au régime général de la légitime défense lorsque les conditions de ce dernier sont remplies.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Attroupement — Lien L. 211-9",
    question: "L’article L. 211-9 du Code de la sécurité intérieure traite :",
    options: [
      "Du périple meurtrier",
      "De l’usage des armes pour la dispersion d’un attroupement",
      "Du refus d’obtempérer à un ordre d’arrêt",
    ],
    answer: "De l’usage des armes pour la dispersion d’un attroupement",
    explanation:
        "Le document rappelle que la dispersion d’un attroupement relève d’un régime spécifique prévu à l’article L. 211-9 du Code de la sécurité intérieure.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Appréciation in concreto",
    question:
        "Pour apprécier la condition d’« absolue nécessité » posée par l’article L. 435-1, le juge tient compte notamment :",
    options: [
      "Uniquement du ressenti subjectif du policier",
      "Des circonstances concrètes (nombre d’assaillants, armes utilisées, lieu, heure, présence de tiers, possibilité de repli)",
      "Uniquement de la gravité médiatique de l’affaire",
    ],
    answer:
        "Des circonstances concrètes (nombre d’assaillants, armes utilisées, lieu, heure, présence de tiers, possibilité de repli)",
    explanation:
        "Comme pour la légitime défense, la nécessité et la proportionnalité sont appréciées in concreto à partir de tous les éléments de la situation.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Policier adjoint — Hors service",
    question:
        "Un policier adjoint conserve illégalement son arme à son domicile et s’en sert pour intervenir dans une agression de rue en dehors de tout service. Même si les critères de la légitime défense sont par ailleurs remplis, sur le terrain de l’article L. 435-1 :",
    options: [
      "Le cadre spécial ne peut s’appliquer car le policier adjoint ne peut concevoir l’usage de son arme hors service",
      "L’usage est automatiquement légitime car il a sauvé une vie",
      "La question du service ou du hors service est indifférente",
    ],
    answer:
        "Le cadre spécial ne peut s’appliquer car le policier adjoint ne peut concevoir l’usage de son arme hors service",
    explanation:
        "Le texte rappelle expressément que les policiers adjoints ne sont pas autorisés à conserver leur arme individuelle en dehors des heures de service.",
    difficulty: "Difficile",
  ),

  // ===================== NIVEAU EXPERT =====================
  QuizQuestion(
    category: "Articulation régimes spéciaux / droit commun",
    question:
        "Lorsque l’usage des armes par un policier ne remplit pas une des conditions préalables de l’article L. 435-1 du Code de la sécurité intérieure mais que la situation correspond à une agression mortelle en cours, la juridiction pénale pourra :",
    options: [
      "Écarter toute justification et condamner automatiquement",
      "Examiner l’affaire à la lumière de la légitime défense de droit commun de l’article 122-5 du Code pénal",
      "Se prononcer uniquement sur la responsabilité disciplinaire",
    ],
    answer:
        "Examiner l’affaire à la lumière de la légitime défense de droit commun de l’article 122-5 du Code pénal",
    explanation:
        "Le cadre spécial n’exclut pas l’application subsidiaire du régime général de la légitime défense dès lors que ses conditions sont réunies.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Périple meurtrier — Exclusivité du moyen",
    question:
        "Dans la situation de périple meurtrier, l’exclusivité du moyen signifie que :",
    options: [
      "Les policiers doivent toujours tenter une négociation avant toute autre chose",
      "L’usage des armes est le seul moyen d’empêcher la réitération des crimes dans un temps rapproché",
      "Les policiers ne peuvent jamais utiliser d’autres armes que l’arme de service",
    ],
    answer:
        "L’usage des armes est le seul moyen d’empêcher la réitération des crimes dans un temps rapproché",
    explanation:
        "La loi exige que l’usage de l’arme ait pour but exclusif d’empêcher la réitération des meurtres lorsqu’aucun autre moyen n’est réellement disponible.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Véhicule dangereux — Analyse fine",
    question:
        "Un véhicule vient de forcer un barrage, a tenté de percuter des piétons et continue sa course à grande vitesse vers une zone très fréquentée. Les policiers, après sommations à la radio et gestes réglementaires, ouvrent le feu sur le conducteur. L’analyse juridique au regard de l’article L. 435-1 se fonde principalement sur :",
    options: [
      "La simple infraction de refus d’obtempérer",
      "Les raisons réelles et objectives de considérer le véhicule comme un moyen d’atteinte grave à la vie ou à l’intégrité physique des personnes",
      "La seule absence de permis de conduire",
    ],
    answer:
        "Les raisons réelles et objectives de considérer le véhicule comme un moyen d’atteinte grave à la vie ou à l’intégrité physique des personnes",
    explanation:
        "Le véhicule-bélier rend la menace grave et actuelle, ce qui permet d’entrer dans la quatrième situation si les autres conditions sont remplies.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Somations — Formule",
    question:
        "Les sommations en matière d’usage des armes doivent être faites à haute voix avec des formules explicites telles que :",
    options: [
      "« Police, veuillez ralentir » une seule fois",
      "« Halte police » puis, en cas d’inobservation, « Halte ou je fais feu »",
      "Une phrase libre choisie par chaque policier",
    ],
    answer:
        "« Halte police » puis, en cas d’inobservation, « Halte ou je fais feu »",
    explanation:
        "Le document reprend l’exemple classique de sommations successives « Halte police » puis « Halte ou je fais feu », qui doivent se succéder dans un temps court.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Appréciation judiciaire",
    question:
        "En pratique, lors d’un contentieux pénal sur l’usage des armes, les juges vont confronter la version du policier :",
    options: [
      "Uniquement avec les instructions de sa hiérarchie",
      "Avec les éléments objectifs du dossier (témoignages, vidéos, traces balistiques, horaires, expertises, etc.) pour vérifier nécessité et proportionnalité",
      "Avec l’opinion publique relayée dans les médias",
    ],
    answer:
        "Avec les éléments objectifs du dossier (témoignages, vidéos, traces balistiques, horaires, expertises, etc.) pour vérifier nécessité et proportionnalité",
    explanation:
        "L’examen porte sur la réalité de la menace et l’adéquation de la riposte, à partir de tous les éléments de preuve disponibles.",
    difficulty: "Expert",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizUsageArmesPage extends StatefulWidget {
  static const String routeName = '/gpx/generalites/quiz/usagearmes';
  final String uid;
  final String email;

  const QuizUsageArmesPage({super.key, required this.uid, required this.email});

  @override
  State<QuizUsageArmesPage> createState() => _QuizUsageArmesPageState();
}

class _QuizUsageArmesPageState extends State<QuizUsageArmesPage>
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
    duration: const Duration(milliseconds: 700), // tu peux ajuster
  );

  // Historique
  int? _historyRowId; // id (int) retour insert quiz_history
  SupabaseClient get _sb => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _page = PageController(initialPage: 0);
    _rng = math.Random(DateTime.now().millisecondsSinceEpoch);

    // --- Audio ---
    _goodSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    _badSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

    // Pré-charge pour éviter le délai au premier play
    // (chemins relatifs au dossier déclaré dans pubspec: assets/sfx/)
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

  // ==========================================================================
  // HELPERS
  // ==========================================================================
  void _seedAndShuffle() {
    final useAll = _mixMode || _selectedDifficulty == null;
    final pool = useAll
        ? questionsUsageArmes
        : questionsUsageArmes
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

  // ==========================================================================
  // SUPABASE
  // ==========================================================================
  Future<void> _createHistoryOnStart() async {
    try {
      final res = await _sb
          .from('quiz_history')
          .insert({
            'uid': widget.uid,
            'email': widget.email,
            'module_name': 'Généralités',
            'quiz_name': 'L\'Usage des Armes',
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
            'score': percent, // pourcentage final
            'correct_count': _score, // nb de bonnes réponses
            'finished_at': DateTime.now().toUtc().toIso8601String(),
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _historyRowId!)
          .eq('uid', widget.uid); // important pour la RLS
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
      await _sb.from('quiz_usagearmes').insert({
        'user_uid': widget.uid,
        'email': widget.email,
        'question': question,
        'user_answer': userAnswer,
        'correct_answer': correctAnswer,
        'is_correct': isCorrect,
        'score': _score, // score cumulé au moment T
        'difficulty': difficulty,
      });
    } catch (e) {
      debugPrint('❌ quiz_usagearmes insert failed: $e');
    }
  }

  // ==========================================================================
  // AUDIO UTIL
  // ==========================================================================
  Future<void> _playAnswerSfx(bool good) async {
    try {
      // petite vibration sympa
      HapticFeedback.mediumImpact();

      final AudioPlayer p = good ? _goodSfx : _badSfx;
      // on s’assure de repartir du début
      await p.stop();
      await p.setSource(
        AssetSource(good ? 'sfx/correct_answer.mp3' : 'sfx/wrong_answer.mp3'),
      );
      await p.resume();
    } catch (_) {
      // on ignore les erreurs audio
    }
  }

  // ==========================================================================
  // ACTIONS
  // ==========================================================================
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

    // Lance l'animation
    _pulseCtrl
      ..reset()
      ..forward();

    // 🔊 Lecture du son en même temps que l’animation
    unawaited(_playAnswerSfx(ok));

    // Sauvegarde asynchrone
    // Sauvegarde asynchrone
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

  // ==========================================================================
  // UI (réécrit)
  // ==========================================================================
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

        // hauteur “structurelle” du bas (bouton + marges)
        const double kButtonHeight = 56;
        const double kButtonVPad = 16; // safe area min bottom padding = 16
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
                    // Taille cible de l’animation (en fonction de la largeur)
                    final double animSize = (viewport.maxWidth * 0.56).clamp(
                      140.0,
                      240.0,
                    );

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // =======================
                        // COLONNE CONTENU (scroll)
                        // =======================
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

                                  // >>> padding bas à appliquer à la page courante :
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
                            // Barre de boutons
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

                        // =======================
                        // OVERLAY ANIMATION GLOBAL
                        // =======================
                        if (_validated)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: bottomBarReserved, // au-dessus du bouton
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

                        // =======================
                        // SPLASH DIFFICULTÉ
                        // =======================
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

  // ==========================================================================
  // RESULT DIALOG
  // ==========================================================================
  void _openResultDialog(int score, int total) {
    final pct = (score / total * 100).round();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Résultat',
      // On garde un léger assombrissement, le flou sera appliqué par-dessus.
      barrierColor: Colors.black.withOpacity(0.25),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            // ⬇️ Flou gaussien PLEIN ÉCRAN sur l’arrière-plan
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: const SizedBox.expand(),
              ),
            ),
            // ⬇️ La carte de résultat au centre
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
          message: 'Tu maîtrises l\'usage des armes 💪',
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
          message: 'Reprends les cours',
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

// Carte d'explication + couleur résultat
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

// Bandeau qui calcule automatiquement la taille idéale de l'animation
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

// Carte résultat avec anneau qui tourne infiniment
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

// ---------- widgets internes du splash ----------
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
