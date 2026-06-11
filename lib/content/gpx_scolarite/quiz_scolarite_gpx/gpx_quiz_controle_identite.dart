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
import 'package:copiqpolice/core/widgets/app_notifier.dart' show AppNotifier, AppSettingsController;
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
final List<QuizQuestion> questionsControleIdentite = [
  // ===================== NIVEAU FACILE =====================
  // ==== CADRE GÉNÉRAL & PRINCIPES ====
  const QuizQuestion(
    category: "Généralités — Contrôle d'identité",
    question:
        "Quel est l'objectif principal des contrôles, relevés et vérifications d'identité ?",
    options: [
      "Limiter la liberté d'aller et venir des personnes",
      "Établir l'identité dans un équilibre entre libertés individuelles et maintien de l'ordre public",
      "Permettre de sanctionner immédiatement toute infraction",
    ],
    answer:
        "Établir l'identité dans un équilibre entre libertés individuelles et maintien de l'ordre public",
    explanation:
        "Les contrôles d'identité visent à établir l'identité d'une personne tout en respectant les libertés individuelles, sous le contrôle de l'autorité judiciaire, et en permettant la recherche des infractions et la prévention des atteintes à l'ordre public.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Textes applicables",
    question:
        "Quels articles du code de procédure pénale encadrent les contrôles, relevés et vérifications d'identité ?",
    options: [
      "Articles 56 à 65 du CPP",
      "Articles 78-1 à 78-7 du CPP",
      "Articles 121-1 à 121-7 du CPP",
    ],
    answer: "Articles 78-1 à 78-7 du CPP",
    explanation:
        "Les opérations d'établissement de l'identité (contrôle, relevé et vérification) sont encadrées par les articles 78-1 à 78-7 du code de procédure pénale.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — CESEDA",
    question:
        "En complément du CPP, quel code fixe les obligations de présentation de documents pour les étrangers lors d'un contrôle d'identité ?",
    options: [
      "Le Code du travail",
      "Le Code civil",
      "Le Code de l'entrée et du séjour des étrangers et du droit d'asile (CESEDA)",
    ],
    answer:
        "Le Code de l'entrée et du séjour des étrangers et du droit d'asile (CESEDA)",
    explanation:
        "Le CESEDA fixe l’obligation, pour les étrangers, de présenter les pièces ou documents sous le couvert desquels ils sont autorisés à circuler ou séjourner en France.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Champ d'application",
    question:
        "Selon l'article 78-1 du CPP, sur qui peut s'exercer un contrôle d'identité ?",
    options: [
      "Uniquement sur les ressortissants français",
      "Sur toute personne se trouvant sur le territoire national",
      "Uniquement sur les personnes déjà connues des services de police",
    ],
    answer: "Sur toute personne se trouvant sur le territoire national",
    explanation:
        "L’article 78-1 du CPP précise que le contrôle d’identité vise toute personne se trouvant sur le territoire national, Français comme étrangers.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Distinction",
    question:
        "Quelle est la différence principale entre contrôle d'identité et vérification d'identité ?",
    options: [
      "Il n'y a aucune différence, ce sont des synonymes",
      "Le contrôle est la première invitation à justifier de son identité, la vérification est une phase coercitive encadrée par un formalisme spécifique",
      "La vérification se fait uniquement sur la voie publique",
    ],
    answer:
        "Le contrôle est la première invitation à justifier de son identité, la vérification est une phase coercitive encadrée par un formalisme spécifique",
    explanation:
        "Le contrôle d’identité est l’invitation à justifier de son identité sur place. La vérification d’identité intervient ensuite, avec rétention possible, lorsque la personne ne peut ou ne veut pas justifier de son identité.",
    difficulty: "Facile",
  ),

  // ==== PERSONNES HABILITÉES ====
  const QuizQuestion(
    category: "Autorités habilitées — Contrôle d'identité",
    question:
        "Quels personnels sont habilités à procéder à un contrôle d'identité selon l'article 78-2 du CPP ?",
    options: [
      "Uniquement les agents de police municipale",
      "Seuls les OPJ et, sur leur ordre et sous leur responsabilité, les APJ et certains APJA",
      "Tous les fonctionnaires de la fonction publique d'État",
    ],
    answer:
        "Seuls les OPJ et, sur leur ordre et sous leur responsabilité, les APJ et certains APJA",
    explanation:
        "Les contrôles d'identité sont réservés aux OPJ et, sur leur ordre et sous leur responsabilité, aux APJ et à certains APJA mentionnés par l’article 21 du CPP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités habilitées — Exclusions",
    question:
        "Parmi les personnels suivants, lesquels ne peuvent PAS procéder eux-mêmes à un contrôle d'identité ?",
    options: ["Les OPJ", "Les agents de police municipale", "Les APJ"],
    answer: "Les agents de police municipale",
    explanation:
        "Les agents de police municipale peuvent relever l'identité des contrevenants dans certains cas, mais ils ne sont pas habilités à mettre en œuvre un contrôle d’identité au sens de l’article 78-2 du CPP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités habilitées — Formule légale",
    question:
        "Que signifie la formule « sur ordre et sous la responsabilité » de l’OPJ concernant l’action des APJ et APJA ?",
    options: [
      "Qu'ils doivent obligatoirement demander une autorisation préalable pour chaque contrôle",
      "Qu'ils agissent dans le cadre de leur mission de secondement de l’OPJ, sous son autorité, sans nécessiter une autorisation préalable à chaque fois",
      "Qu'ils ne peuvent agir qu'en présence physique de l’OPJ",
    ],
    answer:
        "Qu'ils agissent dans le cadre de leur mission de secondement de l’OPJ, sous son autorité, sans nécessiter une autorisation préalable à chaque fois",
    explanation:
        "La formule rappelle simplement que les APJ et APJA agissent pour seconder les OPJ, sous leur autorité. Il n’est pas nécessaire d’obtenir une autorisation préalable pour chaque contrôle, mais la mention doit figurer sur les PV.",
    difficulty: "Intermédiaire",
  ),

  // ==== CONTROLES RELEVANT DE LA POLICE JUDICIAIRE (INITIATIVE POLICIERS) ====
  const QuizQuestion(
    category: "Police judiciaire — Article 78-2",
    question:
        "Dans le cadre de la police judiciaire, sur quelle base un policier peut-il décider de procéder à un contrôle d'identité de sa propre initiative ?",
    options: [
      "Sur la seule intuition personnelle de l'agent",
      "Sur la base de raisons plausibles de soupçonner que la personne est dans l'un des cas prévus par l'article 78-2",
      "Uniquement si la personne refuse un déféré au parquet",
    ],
    answer:
        "Sur la base de raisons plausibles de soupçonner que la personne est dans l'un des cas prévus par l'article 78-2",
    explanation:
        "Le contrôle de police judiciaire à l’initiative des policiers suppose des raisons plausibles de soupçonner la personne d’être dans l’un des cinq cas énumérés par l’article 78-2.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Cinq cas de l'article 78-2",
    question:
        "Parmi les propositions suivantes, laquelle fait partie des cinq cas permettant un contrôle d'identité à l'initiative des policiers (police judiciaire) ?",
    options: [
      "La personne a violé une simple règle de politesse",
      "La personne se prépare à commettre un crime ou un délit",
      "La personne circule la nuit dans une ville touristique",
    ],
    answer: "La personne se prépare à commettre un crime ou un délit",
    explanation:
        "L'article 78-2 prévoit notamment le cas où la personne se prépare à commettre un crime ou un délit comme fondement d’un contrôle d’identité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Personne auteur",
    question:
        "Dans quel cas un contrôle d'identité peut-il être réalisé lorsque la personne est soupçonnée d'être l'auteur d'une infraction ?",
    options: [
      "Uniquement pour un crime",
      "Uniquement pour un délit",
      "Pour un crime, un délit ou une contravention",
    ],
    answer: "Pour un crime, un délit ou une contravention",
    explanation:
        "Le contrôle d’identité peut être pratiqué lorsqu'il existe des raisons plausibles de soupçonner que la personne a commis ou tenté de commettre un crime, un délit ou une contravention.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Renseignements utiles",
    question:
        "Dans quel cas un contrôle d'identité peut-il viser une personne qui n'est pas suspecte mais peut aider l'enquête ?",
    options: [
      "Uniquement si elle est témoin direct d'un crime",
      "Si elle est susceptible de fournir des renseignements utiles en cas de crime ou de délit",
      "Uniquement si elle se présente spontanément au commissariat",
    ],
    answer:
        "Si elle est susceptible de fournir des renseignements utiles en cas de crime ou de délit",
    explanation:
        "L’article 78-2 alinéa 4 permet de contrôler l’identité des personnes susceptibles de fournir des renseignements utiles en cas de crime ou de délit.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Contrôle judiciaire",
    question:
        "Quel cas prévu à l'article 78-2 permet de contrôler une personne déjà soumise à une mesure judiciaire ?",
    options: [
      "Lorsqu'elle ne répond pas au téléphone",
      "Lorsqu'elle viole les obligations d'un contrôle judiciaire ou d'une mesure d’assignation à résidence avec surveillance électronique",
      "Lorsqu'elle change de domicile",
    ],
    answer:
        "Lorsqu'elle viole les obligations d'un contrôle judiciaire ou d'une mesure d’assignation à résidence avec surveillance électronique",
    explanation:
        "L’article 78-2 alinéa 5 vise les personnes qui ne respectent pas les obligations auxquelles elles sont soumises dans le cadre d’un contrôle judiciaire, d’une ARSE ou d’une mesure suivie par le JAP.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Personne recherchée",
    question:
        "Que prévoit l’article 78-2 pour une personne qui fait l’objet de recherches ordonnées par une autorité judiciaire ?",
    options: [
      "Qu'elle ne peut être contrôlée que sur convocation",
      "Qu'elle peut faire l’objet d’un contrôle d’identité",
      "Qu’elle ne peut être contrôlée qu’en flagrance",
    ],
    answer: "Qu'elle peut faire l’objet d’un contrôle d’identité",
    explanation:
        "L’alinéa 6 de l’article 78-2 permet le contrôle d’identité des personnes faisant l’objet de recherches ordonnées par une autorité judiciaire (mandats, décisions du parquet, du JAP, etc.).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Raisons plausibles",
    question:
        "Qu'est-ce qui caractérise les « raisons plausibles » justifiant un contrôle d'identité en police judiciaire ?",
    options: [
      "Une simple impression subjective du policier",
      "Des éléments concrets liés au comportement et au contexte",
      "Une rumeur dans le quartier",
    ],
    answer: "Des éléments concrets liés au comportement et au contexte",
    explanation:
        "Les raisons plausibles doivent être matérialisées par les agissements de la personne dans un contexte donné (fuite, rôder de nuit, dissimulation d’un sac, etc.), et non par une simple intuition.",
    difficulty: "Intermédiaire",
  ),

  // ==== CONTROLES SUR RÉQUISITIONS DU PROCUREUR ====
  const QuizQuestion(
    category: "Réquisitions du procureur — Forme",
    question:
        "Sous quelle forme le procureur de la République doit-il donner ses réquisitions pour des contrôles d'identité généralisés ?",
    options: [
      "Verbalement, devant les agents",
      "Par un simple appel téléphonique non consigné",
      "Par des réquisitions écrites",
    ],
    answer: "Par des réquisitions écrites",
    explanation:
        "Les contrôles sur réquisitions du procureur doivent être fondés sur des réquisitions écrites précisant notamment les infractions recherchées.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions du procureur — Infractions visées",
    question:
        "Lors de contrôles d'identité sur réquisitions, que doivent obligatoirement préciser les réquisitions du procureur de la République ?",
    options: [
      "La couleur des uniformes portés par les agents",
      "Les infractions à rechercher",
      "Le nombre maximum de personnes contrôlées",
    ],
    answer: "Les infractions à rechercher",
    explanation:
        "Les réquisitions doivent préciser les infractions ciblées afin d’éviter des contrôles déclenchés de façon purement aléatoire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions du procureur — Durée",
    question:
        "En pratique, quelle durée les opérations de contrôles d'identité sur réquisitions ne doivent-elles pas dépasser ?",
    options: ["Une demi-journée", "24 heures", "48 heures"],
    answer: "Une demi-journée",
    explanation:
        "Ces opérations doivent se dérouler dans un temps relativement court, n'excédant pas, en pratique, une demi-journée, pour éviter les contrôles généralisés et permanents.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions du procureur — Lieux et temps",
    question:
        "Que doivent préciser les réquisitions du parquet concernant les contrôles d'identité ?",
    options: [
      "Uniquement le nombre d’agents engagés",
      "Le périmètre exact et la période de temps des opérations",
      "Uniquement la nature de la population visée",
    ],
    answer: "Le périmètre exact et la période de temps des opérations",
    explanation:
        "Les réquisitions délimitent les lieux et la période des contrôles pour garantir un dispositif ciblé, légal et non généralisé.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions du procureur — Toute personne",
    question:
        "Lors d'un contrôle d'identité sur réquisitions du procureur, qui peut être contrôlé ?",
    options: [
      "Uniquement les personnes déjà connues défavorablement",
      "Uniquement les personnes à l’apparence suspecte",
      "Toute personne se trouvant dans les lieux et créneaux horaires visés",
    ],
    answer:
        "Toute personne se trouvant dans les lieux et créneaux horaires visés",
    explanation:
        "Le contrôle peut viser toute personne se trouvant dans le périmètre et sur la période définis par les réquisitions, même si en pratique tous ne peuvent pas être contrôlés.",
    difficulty: "Facile",
  ),

  // ==== CONTROLES PRÉVENTIFS (POLICE ADMINISTRATIVE) ====
  const QuizQuestion(
    category: "Préventif — Finalité",
    question:
        "Quel est l’objectif principal des contrôles d'identité préventifs prévus à l’alinéa 8 de l’article 78-2 du CPP ?",
    options: [
      "Vérifier la régularité des contrats de travail",
      "Prévenir une atteinte à l'ordre public, notamment à la sécurité des personnes et des biens",
      "Contrôler la fiscalité des commerçants",
    ],
    answer:
        "Prévenir une atteinte à l'ordre public, notamment à la sécurité des personnes et des biens",
    explanation:
        "Les contrôles préventifs sont des contrôles de police administrative destinés à prévenir une atteinte à l’ordre public.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Préventif — Comportement",
    question:
        "Dans le cadre d'un contrôle préventif (alinéa 8 de l'article 78-2 CPP), le comportement de la personne est-il une condition de régularité du contrôle ?",
    options: [
      "Oui, il doit être anormal ou suspect",
      "Non, la loi précise que le contrôle n'est pas lié au comportement de la personne",
      "Oui, seulement la nuit",
    ],
    answer:
        "Non, la loi précise que le contrôle n'est pas lié au comportement de la personne",
    explanation:
        "Le texte indique expressément que le contrôle préventif n’est pas conditionné au comportement individuel de la personne contrôlée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Préventif — Lieux",
    question:
        "Dans quels types de lieux peuvent être mis en œuvre les contrôles d'identité préventifs ?",
    options: [
      "Uniquement à domicile",
      "Dans des lieux publics ou ouverts au public (gares, salles de spectacle, galeries marchandes…)",
      "Uniquement dans les commissariats de police",
    ],
    answer:
        "Dans des lieux publics ou ouverts au public (gares, salles de spectacle, galeries marchandes…)",
    explanation:
        "La circulaire et le texte précisent que les contrôles préventifs ne peuvent avoir lieu que dans les lieux publics ou ouverts au public.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Préventif — Motivation",
    question:
        "Que rappelle le Conseil constitutionnel concernant les contrôles généralisés et discrétionnaires ?",
    options: [
      "Qu’ils sont parfaitement admis pour lutter contre la délinquance",
      "Qu’ils sont compatibles avec la liberté individuelle",
      "Qu’ils sont incompatibles avec le respect de la liberté individuelle",
    ],
    answer:
        "Qu’ils sont incompatibles avec le respect de la liberté individuelle",
    explanation:
        "Dans sa décision n° 93-323 du 5 août 1993, le Conseil constitutionnel indique que les contrôles généralisés et discrétionnaires sont incompatibles avec la liberté individuelle.",
    difficulty: "Difficile",
  ),

  // ==== CONTROLES EN ZONE FRONTIÈRE ====
  const QuizQuestion(
    category: "Zone frontière — Finalité",
    question:
        "À quoi sont principalement destinés les contrôles d'identité en zone frontière prévus par l’article 78-2 alinéas 9 à 17 ?",
    options: [
      "À rétablir les contrôles permanents aux frontières intérieures",
      "À prévenir et rechercher les infractions liées à la criminalité transfrontalière",
      "Uniquement à vérifier le paiement des péages autoroutiers",
    ],
    answer:
        "À prévenir et rechercher les infractions liées à la criminalité transfrontalière",
    explanation:
        "Après la suppression des contrôles aux frontières intérieures, ces dispositions visent surtout la criminalité transfrontalière et le respect de certaines obligations documentaires.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Zone frontière — Bande des 20 km",
    question:
        "Dans quelle zone peut-on effectuer des contrôles d'identité fondés sur l’article 78-2 en lien avec la frontière terrestre Schengen ?",
    options: [
      "Dans toute la France",
      "Dans une zone située à moins de 20 km de la frontière terrestre avec les États parties à Schengen",
      "Uniquement dans les aéroports internationaux",
    ],
    answer:
        "Dans une zone située à moins de 20 km de la frontière terrestre avec les États parties à Schengen",
    explanation:
        "L’article 78-2 prévoit des contrôles dans une zone de 20 km en deçà de la frontière terrestre Schengen, sous conditions de fréquence et de finalité (criminalité transfrontalière).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Zone frontière — Durée contrôles ports/aéroports",
    question:
        "Quelle est la durée maximale d'une opération de contrôles d'identité autour des ports et aéroports constituant des points de passage frontaliers ?",
    options: [
      "6 heures dans un même lieu",
      "12 heures dans un même lieu",
      "24 heures dans un même lieu",
    ],
    answer: "12 heures dans un même lieu",
    explanation:
        "La loi prévoit que la durée maximale de ces contrôles ne peut être supérieure à 12 heures dans un même lieu, sans caractère systématique.",
    difficulty: "Intermédiaire",
  ),

  // ==== CONTROLES DANS LES LOCAUX PROFESSIONNELS ====
  const QuizQuestion(
    category: "Locaux professionnels — Réquisitions",
    question:
        "Quelle condition est nécessaire pour que les policiers puissent pénétrer dans des locaux professionnels afin de vérifier l'absence de travail dissimulé ?",
    options: [
      "L’accord oral du chef d’entreprise",
      "Des réquisitions écrites du procureur de la République",
      "L’autorisation du maire",
    ],
    answer: "Des réquisitions écrites du procureur de la République",
    explanation:
        "L’article 78-2-1 du CPP impose des réquisitions écrites du procureur de la République pour pénétrer dans les locaux professionnels en vue de rechercher du travail dissimulé.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Locaux professionnels — Lieux visés",
    question:
        "Quels lieux peuvent être visés par les réquisitions pour contrôle dans les locaux professionnels ?",
    options: [
      "Uniquement les domiciles des salariés",
      "Les lieux à usage exclusivement professionnel et leurs annexes",
      "Tous les lieux, y compris les domiciles familiaux",
    ],
    answer: "Les lieux à usage exclusivement professionnel et leurs annexes",
    explanation:
        "Les réquisitions ne peuvent viser que des locaux à usage exclusivement professionnel, leurs annexes et dépendances, à l’exclusion notamment des domiciles.",
    difficulty: "Intermédiaire",
  ),

  // ==== VISITES DE VÉHICULES / BAGAGES / NAVIRES (RÉQUISITIONS) ====
  const QuizQuestion(
    category: "Visites véhicules — Réquisitions",
    question:
        "Selon l’article 78-2-2 CPP, pour quelles infractions les visites de véhicules sur réquisitions du procureur peuvent-elles être ordonnées ?",
    options: [
      "Uniquement pour les infractions routières",
      "Pour certaines infractions graves comme le terrorisme, les armes, les explosifs, les vols, le recel, le trafic de stupéfiants",
      "Pour tout type d'infraction sans restriction",
    ],
    answer:
        "Pour certaines infractions graves comme le terrorisme, les armes, les explosifs, les vols, le recel, le trafic de stupéfiants",
    explanation:
        "L’article 78-2-2 liste des catégories d’infractions graves (terrorisme, armes, explosifs, vols, recel, stupéfiants, etc.) justifiant visites de véhicules, navires et fouilles de bagages sur réquisitions.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Visites véhicules — Présence",
    question:
        "Lors d'une visite de véhicule à l'arrêt ou en stationnement sur réquisitions du procureur, en présence de qui la visite doit-elle avoir lieu ?",
    options: [
      "Toujours en l’absence de toute personne",
      "En présence du conducteur ou du propriétaire, ou à défaut d’une personne ne relevant pas de l’autorité administrative des agents",
      "Uniquement en présence d’un avocat",
    ],
    answer:
        "En présence du conducteur ou du propriétaire, ou à défaut d’une personne ne relevant pas de l’autorité administrative des agents",
    explanation:
        "Pour les véhicules à l’arrêt, la visite doit se faire en présence du conducteur ou du propriétaire. À défaut, l’OPJ ou l’APJ requiert une personne extérieure à son autorité, sauf risque grave pour la sécurité.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Visites véhicules — Durée réquisitions",
    question:
        "Quelle est la durée maximale d'une opération de visites de véhicules sur réquisitions du procureur selon l'article 78-2-2 ?",
    options: [
      "12 heures, non renouvelables",
      "24 heures, renouvelables sur décision expresse et motivée",
      "48 heures, sans renouvellement possible",
    ],
    answer: "24 heures, renouvelables sur décision expresse et motivée",
    explanation:
        "Le procureur fixe la durée, qui ne peut excéder 24 heures, avec possibilité de renouvellement par décision expresse et motivée.",
    difficulty: "Difficile",
  ),

  // ==== DISTINCTION CONTROLE D'IDENTITÉ / CONTROLE DE RÉGLEMENTATION ====
  const QuizQuestion(
    category: "Contrôle d'identité vs réglementation",
    question:
        "Qu'est-ce qui caractérise un contrôle de réglementation par rapport au contrôle d'identité de l’article 78-2 CPP ?",
    options: [
      "Il vise des obligations spécifiques liées à une activité ou un statut (chasseurs, automobilistes, commerçants ambulants, etc.)",
      "Il est toujours effectué en garde à vue",
      "Il ne peut jamais avoir lieu sur la voie publique",
    ],
    answer:
        "Il vise des obligations spécifiques liées à une activité ou un statut (chasseurs, automobilistes, commerçants ambulants, etc.)",
    explanation:
        "Le contrôle de réglementation porte sur la présentation de titres ou documents obligatoires liés à une activité ou un statut spécifique, distinctement du cadre du contrôle d’identité général.",
    difficulty: "Intermédiaire",
  ),

  // ==== CONTRÔLE DES ÉTRANGERS / CESEDA ====
  const QuizQuestion(
    category: "Étrangers — CESEDA",
    question:
        "Selon l’article L. 812-2 du CESEDA, à quel moment un étranger doit-il être en mesure de présenter les documents l’autorisant à séjourner ou circuler en France ?",
    options: [
      "À tout moment, même sans contrôle préalable",
      "Uniquement lors d’un contrôle routier pour excès de vitesse",
      "À la suite d’un contrôle d’identité effectué dans les conditions du CPP",
    ],
    answer:
        "À la suite d’un contrôle d’identité effectué dans les conditions du CPP",
    explanation:
        "L’article L. 812-2 prévoit que ce contrôle des documents intervient à la suite d’un contrôle d’identité mené dans le cadre des articles 78-1 à 78-2-2 CPP.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Étrangers — Critères objectifs",
    question:
        "Le contrôle de la situation administrative d’un étranger peut-il être fondé sur la couleur de peau ou le nom de famille ?",
    options: [
      "Oui, ces éléments suffisent",
      "Non, il doit reposer sur des éléments objectifs extérieurs à la personne (ex : véhicule immatriculé à l’étranger, banderoles, tracts…) ",
      "Oui, si la personne parle une langue étrangère",
    ],
    answer:
        "Non, il doit reposer sur des éléments objectifs extérieurs à la personne (ex : véhicule immatriculé à l’étranger, banderoles, tracts…) ",
    explanation:
        "Les critères doivent être objectifs et extérieurs à la personne, afin d’exclure toute discrimination fondée sur la couleur de peau, le nom, la langue, etc.",
    difficulty: "Difficile",
  ),

  // ==== MOYENS DE PREUVE DE L’IDENTITÉ ====
  const QuizQuestion(
    category: "Preuve identité — Tout moyen",
    question:
        "Que prévoit l’article 78-2 CPP concernant les moyens de justifier de son identité lors d’un contrôle ?",
    options: [
      "La personne ne peut justifier que par sa carte nationale d'identité",
      "La personne peut justifier de son identité par tout moyen",
      "La personne doit être conduite au poste systématiquement",
    ],
    answer: "La personne peut justifier de son identité par tout moyen",
    explanation:
        "Le texte est volontairement large et dispose que toute personne peut justifier de son identité par tout moyen.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Preuve identité — Documents probants",
    question:
        "Parmi les documents suivants, lequel est considéré comme probant et officiel pour établir l'identité ?",
    options: [
      "Une carte de fidélité de magasin",
      "Un permis de conduire",
      "Un ticket de caisse",
    ],
    answer: "Un permis de conduire",
    explanation:
        "Les documents officiels avec photographie (CNI, passeport, permis de conduire) sont probants pour l’identité, sous réserve de leur authenticité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Preuve identité — Documents non probants",
    question:
        "Un livret de famille présenté lors d’un contrôle d’identité constitue :",
    options: [
      "Une preuve irréfutable de l'identité",
      "Un commencement de preuve pouvant être pris en compte selon les circonstances",
      "Un document sans aucune valeur",
    ],
    answer:
        "Un commencement de preuve pouvant être pris en compte selon les circonstances",
    explanation:
        "Les documents sans photo ou sans procédure d’identification stricte ne sont qu’un commencement de preuve, à apprécier par les fonctionnaires.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Preuve identité — Témoignages",
    question:
        "Dans quelles conditions les témoignages peuvent-ils être utilisés pour confirmer l'identité lors d’un contrôle ?",
    options: [
      "Ils peuvent être recueillis plusieurs jours après le contrôle",
      "Ils doivent être concomitants et recueillis dans l'immédiate action de contrôle",
      "Ils doivent obligatoirement être recueillis par un magistrat",
    ],
    answer:
        "Ils doivent être concomitants et recueillis dans l'immédiate action de contrôle",
    explanation:
        "Les témoignages doivent être simultanés au contrôle pour être utilisables dans la confirmation de l’identité.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  // ==== RELEVÉ D’IDENTITÉ ====
  const QuizQuestion(
    category: "Relevé d'identité — Personnels habilités",
    question:
        "Quels agents peuvent procéder à un relevé d’identité pour dresser procès-verbal de certaines contraventions selon l'article 78-6 CPP ?",
    options: [
      "Uniquement les OPJ",
      "Les volontaires de la réserve, les policiers adjoints, certains agents de la Ville de Paris et les agents de police municipale",
      "Uniquement les gendarmes d’active",
    ],
    answer:
        "Les volontaires de la réserve, les policiers adjoints, certains agents de la Ville de Paris et les agents de police municipale",
    explanation:
        "L’article 78-6 énumère ces catégories (volontaires gendarmerie, réservistes, policiers adjoints, ASP, APM, etc.) comme pouvant relever l’identité des contrevenants.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Relevé d'identité — Nature",
    question:
        "De quelle nature est l'opération de relevé d'identité prévue à l'article 78-6 du CPP ?",
    options: [
      "Une opération de police administrative",
      "Une opération de nature judiciaire, nécessitant qu'une infraction ait été préalablement commise",
      "Une simple démarche administrative sans lien avec une infraction",
    ],
    answer:
        "Une opération de nature judiciaire, nécessitant qu'une infraction ait été préalablement commise",
    explanation:
        "Le relevé d’identité est une opération judiciaire : une contravention doit avoir été commise pour pouvoir y recourir.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Relevé d'identité — Refus du contrevenant",
    question:
        "En cas de refus du contrevenant de justifier de son identité lors d’un relevé, que doit faire l’APJA ?",
    options: [
      "Laisser partir le contrevenant",
      "Le conduire immédiatement en garde à vue",
      "Rendre compte à l’OPJ territorialement compétent pour instructions",
    ],
    answer:
        "Rendre compte à l’OPJ territorialement compétent pour instructions",
    explanation:
        "En cas de refus, l’APJA doit aviser l’OPJ, qui peut ordonner une présentation immédiate pour vérification d’identité ou rétention en attendant.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Relevé d'identité — Coercition",
    question:
        "L’agent de police judiciaire adjoint peut-il user de la coercition pour maintenir sur place un contrevenant le temps d’aviser l’OPJ ?",
    options: [
      "Non, il ne dispose d'aucun pouvoir coercitif",
      "Oui, il peut le faire et le refus d'obtempérer est pénalement sanctionné",
      "Oui, mais uniquement s'il s'agit d'un crime",
    ],
    answer:
        "Oui, il peut le faire et le refus d'obtempérer est pénalement sanctionné",
    explanation:
        "L’APJA peut maintenir le contrevenant sur place en attendant la décision de l’OPJ. Le refus est puni de 2 mois d’emprisonnement et 7 500 € d’amende.",
    difficulty: "Difficile",
  ),

  // ==== VÉRIFICATION D’IDENTITÉ & RÉTENTION ====
  const QuizQuestion(
    category: "Vérification d'identité — Définition",
    question:
        "Comment peut-on définir la vérification d'identité au sens de l'article 78-3 CPP ?",
    options: [
      "Une simple confirmation orale de l'identité",
      "La recherche coercitive de l'identité d'une personne qui n'a pas voulu ou pu justifier de son identité à la suite d'un contrôle ou d'un relevé",
      "Une audition libre au commissariat",
    ],
    answer:
        "La recherche coercitive de l'identité d'une personne qui n'a pas voulu ou pu justifier de son identité à la suite d'un contrôle ou d'un relevé",
    explanation:
        "La vérification d’identité permet, de manière coercitive, de rechercher l’identité d’une personne après échec du contrôle ou du relevé.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vérification d'identité — Rétention",
    question:
        "Quelle est la durée maximale de la rétention d’une personne pour vérification d'identité sur le territoire métropolitain (hors régimes particuliers) ?",
    options: ["2 heures", "4 heures", "8 heures"],
    answer: "4 heures",
    explanation:
        "La mesure de rétention ne peut excéder 4 heures à compter du début du contrôle, sauf régime spécifique (Mayotte, Guyane : 8 heures).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vérification d'identité — Début du délai",
    question:
        "À partir de quand commence à courir le délai maximal de 4 heures de rétention pour vérification d’identité ?",
    options: [
      "À l’arrivée de la personne au commissariat",
      "Au moment où l'O.P.J. signe le procès-verbal",
      "Au moment où le policier constate que la personne ne peut ou ne veut pas justifier de son identité",
    ],
    answer:
        "Au moment où le policier constate que la personne ne peut ou ne veut pas justifier de son identité",
    explanation:
        "La rétention débute dès le constat de l’impossibilité ou du refus de justifier de son identité, même sur la voie publique.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Vérification d'identité — Sort de la personne",
    question:
        "À l'issue de la durée maximale de rétention pour vérification d'identité, que doit-il se passer si l'identité n'est toujours pas établie et qu'il n’y a pas de placement en garde à vue ?",
    options: [
      "La personne doit être relâchée",
      "La rétention peut être prolongée sans limite",
      "La personne doit être présentée immédiatement devant un juge d’instruction",
    ],
    answer: "La personne doit être relâchée",
    explanation:
        "Au terme des 4 heures, la personne doit être remise en liberté, sauf placement en garde à vue si les conditions en sont réunies.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification d'identité — Garde à vue",
    question:
        "Si une garde à vue fait suite à une vérification d'identité, comment se calcule la durée totale de privation de liberté ?",
    options: [
      "La durée de la rétention s'ajoute à celle de la garde à vue",
      "La durée de la rétention s'impute sur celle de la garde à vue",
      "La garde à vue recommence un nouveau délai sans tenir compte de la rétention",
    ],
    answer: "La durée de la rétention s'impute sur celle de la garde à vue",
    explanation:
        "L’article 78-4 CPP prévoit que la durée de la rétention s’impute sur la durée de la garde à vue.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification d'identité — Prise d’empreintes",
    question:
        "Dans quelles conditions l’O.P.J. peut-il recourir à la prise d’empreintes ou de photographies pour établir l’identité ?",
    options: [
      "Dès le début du contrôle d'identité, sans condition",
      "Uniquement si c’est le moyen le plus simple, même si la personne présente un document fiable",
      "Si la personne maintient son refus ou donne des éléments manifestement inexacts et si ces opérations sont l’unique moyen d’établir l’identité, après autorisation d’un magistrat",
    ],
    answer:
        "Si la personne maintient son refus ou donne des éléments manifestement inexacts et si ces opérations sont l’unique moyen d’établir l’identité, après autorisation d’un magistrat",
    explanation:
        "L’article 78-3 impose un double critère (refus/identité inexacte + unique moyen) et une autorisation préalable du procureur ou du juge d’instruction.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Vérification d'identité — Droit d'aviser",
    question:
        "Lors d'une vérification d'identité, de quel droit la personne doit-elle être informée immédiatement ?",
    options: [
      "Du droit au silence",
      "Du droit de faire aviser le procureur de la République et de prévenir sa famille ou une personne de son choix",
      "Du droit automatique à un avocat commis d’office",
    ],
    answer:
        "Du droit de faire aviser le procureur de la République et de prévenir sa famille ou une personne de son choix",
    explanation:
        "L’article 78-3 prévoit l’information de la personne sur son droit d’aviser le procureur et de prévenir un proche.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification d'identité — Délit de refus",
    question:
        "Quel risque pénal encourt la personne qui refuse de se prêter aux prises d’empreintes ou photographies dûment autorisées par le magistrat ?",
    options: [
      "Aucun risque, c’est un droit absolu",
      "Une simple amende contraventionnelle",
      "Un délit passible de 3 mois d’emprisonnement et 3 750 € d’amende",
    ],
    answer: "Un délit passible de 3 mois d’emprisonnement et 3 750 € d’amende",
    explanation:
        "L’article 78-5 CPP sanctionne le refus de se soumettre aux mesures d’identité judiciaire autorisées.",
    difficulty: "Difficile",
  ),

  // ==== PROCÈS-VERBAL DE VÉRIFICATION ====
  const QuizQuestion(
    category: "PV de vérification — Mentions obligatoires",
    question:
        "Parmi les éléments suivants, lequel doit obligatoirement figurer dans le procès-verbal de vérification d’identité ?",
    options: [
      "Le numéro de badge du préfet",
      "Les motifs justifiant le contrôle et la vérification, ainsi que les heures de début et de fin de la rétention",
      "La profession des parents de la personne contrôlée",
    ],
    answer:
        "Les motifs justifiant le contrôle et la vérification, ainsi que les heures de début et de fin de la rétention",
    explanation:
        "Le PV doit permettre un contrôle sérieux de la légalité (motifs, déroulement, heures, recours à l’identité judiciaire, etc.).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "PV de vérification — Signature",
    question:
        "Que doit faire l’O.P.J. si la personne refuse de signer le procès-verbal de vérification d’identité ?",
    options: [
      "Annuler la procédure",
      "Le mentionner expressément ainsi que les motifs de ce refus",
      "Obliger la personne à signer par la force",
    ],
    answer: "Le mentionner expressément ainsi que les motifs de ce refus",
    explanation:
        "Le refus de signature et ses motifs sont portés sur le PV, qui reste valable dès lors que les mentions légales sont respectées.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "PV de vérification — Conservation données",
    question:
        "Si la vérification d’identité n’est suivie d’aucune enquête ou mesure d’exécution, que devient le procès-verbal et les éléments d’identification ?",
    options: [
      "Ils sont conservés indéfiniment dans un fichier central",
      "Ils doivent être détruits dans un délai de six mois",
      "Ils sont conservés dix ans",
    ],
    answer: "Ils doivent être détruits dans un délai de six mois",
    explanation:
        "L’article 78-3 prévoit l’interdiction de mise en mémoire et la destruction dans les six mois, afin d’éviter un fichage détourné.",
    difficulty: "Difficile",
  ),

  // ===================== NOUVELLE SÉRIE GÉANTE — NIVEAU FACILE =====================

  // ==== Contenu général ====
  const QuizQuestion(
    category: "Généralités — Objectifs",
    question: "Les opérations de contrôle d'identité visent principalement à :",
    options: [
      "Limiter les déplacements de la population",
      "Établir l’identité des personnes et prévenir les atteintes à l’ordre public",
      "Identifier les personnes pour des campagnes fiscales",
    ],
    answer:
        "Établir l’identité des personnes et prévenir les atteintes à l’ordre public",
    explanation:
        "Les articles 78-1 à 78-7 CPP encadrent ces opérations visant à concilier libertés et sécurité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Article 78-1 CPP",
    question:
        "Selon l’article 78-1 CPP, qui peut être soumis à un contrôle d’identité ?",
    options: [
      "Uniquement les Français âgés de plus de 18 ans",
      "Toute personne présente sur le territoire national",
      "Uniquement les touristes étrangers",
    ],
    answer: "Toute personne présente sur le territoire national",
    explanation:
        "Le CPP ne distingue ni nationalité ni âge : toute personne peut être contrôlée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Début d'un contrôle",
    question: "Quand commence légalement un contrôle d’identité ?",
    options: [
      "Lorsque l’agent décide verbalement de contrôler la personne",
      "Lorsque la personne est invitée à justifier de son identité",
      "Uniquement lorsque la personne est amenée au commissariat",
    ],
    answer: "Lorsque la personne est invitée à justifier de son identité",
    explanation:
        "Le contrôle débute dès l’invitation à confirmer son identité, même sans contact physique.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Documents acceptés",
    question: "Quel document permet de prouver son identité ?",
    options: [
      "Un permis de conduire",
      "Un ticket de métro",
      "Un badge d’entreprise",
    ],
    answer: "Un permis de conduire",
    explanation:
        "Tout document officiel avec photo est un moyen probant de justifier son identité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Absence de papiers",
    question:
        "Si une personne n’a aucun document sur elle lors d’un contrôle d’identité :",
    options: [
      "Elle est automatiquement placée en garde à vue",
      "Elle peut justifier son identité par tout moyen, y compris témoignages",
      "Le contrôle doit être annulé immédiatement",
    ],
    answer:
        "Elle peut justifier son identité par tout moyen, y compris témoignages",
    explanation:
        "Le CPP permet la preuve de l’identité par tous moyens raisonnables et immédiats.",
    difficulty: "Facile",
  ),

  // ==== Agents habilités ====
  const QuizQuestion(
    category: "Autorités habilitées — Distinction",
    question: "Quels agents NE PEUVENT PAS procéder à un contrôle d’identité ?",
    options: ["Les agents de police municipale", "Les OPJ", "Les APJ"],
    answer: "Les agents de police municipale",
    explanation:
        "Les APM peuvent relever une identité, pas effectuer un contrôle d’identité au sens 78-2.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités habilitées — APJ",
    question:
        "Un APJ peut-il procéder à un contrôle d’identité sans ordre préalable de l’OPJ ?",
    options: [
      "Oui, mais toujours sous la responsabilité d’un OPJ",
      "Oui, totalement indépendamment",
      "Non, jamais",
    ],
    answer: "Oui, mais toujours sous la responsabilité d’un OPJ",
    explanation:
        "La mention « sur ordre et sous responsabilité » rappelle la hiérarchie, pas un ordre préalable obligatoire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités habilitées — Nullité",
    question:
        "Quelle mention doit obligatoirement figurer dans un PV de contrôle sous peine de nullité ?",
    options: [
      "La température extérieure",
      "La formule : « sur ordre et sous la responsabilité de l’OPJ »",
      "Le numéro de matricule de la mairie",
    ],
    answer: "La formule : « sur ordre et sous la responsabilité de l’OPJ »",
    explanation:
        "L’absence de cette mention peut entraîner la nullité du contrôle.",
    difficulty: "Facile",
  ),

  // ==== Contrôles Police Judiciaire — Raisons plausibles ====
  const QuizQuestion(
    category: "Police judiciaire — Cas 1",
    question:
        "Un contrôle d’identité pour police judiciaire peut avoir lieu si la personne :",
    options: [
      "A commis ou tenté de commettre une infraction",
      "A refusé de répondre à une question banale",
      "Marche rapidement dans la rue",
    ],
    answer: "A commis ou tenté de commettre une infraction",
    explanation:
        "C’est l’un des cinq cas de 78-2 permettant le contrôle d’identité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Cas 2",
    question:
        "Quel exemple correspond à une raison plausible de soupçonner un acte préparatoire ?",
    options: [
      "Une personne qui prend une photo d’un bâtiment",
      "Un individu escaladant un mur la nuit",
      "Un joggeur traversant un parc",
    ],
    answer: "Un individu escaladant un mur la nuit",
    explanation: "Cela peut constituer un acte préparatoire à un cambriolage.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Renseignement",
    question:
        "Une personne peut être contrôlée si elle est susceptible de fournir :",
    options: [
      "Des renseignements utiles à un crime ou un délit",
      "Un avis politique",
      "Un commentaire sur la météo",
    ],
    answer: "Des renseignements utiles à un crime ou un délit",
    explanation: "78-2 alinéa 4 : la personne peut ne pas être suspecte.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Personne recherchée",
    question: "Une personne peut être contrôlée si elle fait l’objet :",
    options: [
      "D’une convocation au collège",
      "De recherches ordonnées par une autorité judiciaire",
      "D'un rappel à l’ordre municipal",
    ],
    answer: "De recherches ordonnées par une autorité judiciaire",
    explanation: "Un mandat judiciaire est un fondement légal de contrôle.",
    difficulty: "Facile",
  ),

  // ==== Contrôle sur réquisitions du procureur ====
  const QuizQuestion(
    category: "Réquisitions — Écrit",
    question:
        "Les réquisitions du procureur pour un contrôle d’identité doivent être :",
    options: [
      "Orales et improvisées",
      "Écrites et motivées",
      "Publiées au Journal Officiel",
    ],
    answer: "Écrites et motivées",
    explanation:
        "78-2 : les réquisitions doivent être obligatoirement écrites.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Périmètre",
    question: "Que doit obligatoirement indiquer la réquisition du procureur ?",
    options: [
      "Le nom du chef de patrouille",
      "Les lieux et la période des contrôles",
      "La couleur des véhicules engagés",
    ],
    answer: "Les lieux et la période des contrôles",
    explanation:
        "Les réquisitions doivent être limitées dans le temps et l’espace.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Population visée",
    question:
        "Lors d’un contrôle sur réquisitions, quelles personnes peuvent être contrôlées ?",
    options: [
      "Uniquement les personnes suspectes",
      "Toute personne se trouvant dans le périmètre défini",
      "Uniquement les automobilistes",
    ],
    answer: "Toute personne se trouvant dans le périmètre défini",
    explanation:
        "Les réquisitions visent toute personne, non une catégorie ciblée.",
    difficulty: "Facile",
  ),

  // ==== Contrôles préventifs (Police administrative) ====
  const QuizQuestion(
    category: "Préventif — Objectif",
    question:
        "Les contrôles préventifs prévus par l’alinéa 8 de 78-2 servent à :",
    options: [
      "Prévenir une atteinte à l’ordre public",
      "Punir immédiatement la délinquance",
      "Sanctionner les infractions routières",
    ],
    answer: "Prévenir une atteinte à l’ordre public",
    explanation:
        "Contrôle de police administrative sans lien avec une infraction.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Préventif — Comportement",
    question: "Dans un contrôle préventif, le comportement de la personne :",
    options: [
      "Est déterminant",
      "N’est pas une condition de régularité",
      "Doit être agressif pour justifier le contrôle",
    ],
    answer: "N’est pas une condition de régularité",
    explanation: "Le contrôle vise « toute personne » sur les lieux concernés.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Préventif — Lieux",
    question: "Les contrôles préventifs peuvent être réalisés dans :",
    options: [
      "Les domiciles privés",
      "Les lieux publics et ouverts au public",
      "Uniquement dans les commissariats",
    ],
    answer: "Les lieux publics et ouverts au public",
    explanation:
        "Un contrôle dans un domicile serait assimilé à une perquisition.",
    difficulty: "Facile",
  ),

  // ==== Contrôles zone frontière ====
  const QuizQuestion(
    category: "Frontière — Bande des 20km",
    question: "Les contrôles dans la bande des 20 km visent principalement :",
    options: [
      "À remplacer les anciens contrôles aux frontières intérieures",
      "À lutter contre la criminalité transfrontalière",
      "À contrôler le permis de pêche",
    ],
    answer: "À lutter contre la criminalité transfrontalière",
    explanation: "Finalité précisée dans la loi du 14 mars 2011.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Frontière — Durée",
    question:
        "La durée maximale d’un contrôle autour d’un port ou aéroport ne peut dépasser :",
    options: ["4 heures", "8 heures", "12 heures"],
    answer: "12 heures",
    explanation:
        "78-2 al. 10 : durée maximale 12h, sans caractère systématique.",
    difficulty: "Facile",
  ),

  // ==== Moyens de preuve de l’identité ====
  const QuizQuestion(
    category: "Preuve — Photographie",
    question: "Un document probant d’identité doit de préférence comporter :",
    options: [
      "Une photographie",
      "Une adresse e-mail",
      "Une empreinte digitale",
    ],
    answer: "Une photographie",
    explanation: "La photo permet d’associer le porteur au document.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Preuve — Témoins",
    question:
        "Les témoignages permettant de confirmer l'identité doivent être :",
    options: [
      "Donnés plusieurs jours plus tard",
      "Concomitants et immédiats",
      "Envoyés par courrier recommandé",
    ],
    answer: "Concomitants et immédiats",
    explanation: "Les témoignages doivent être obtenus pendant le contrôle.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================

  // ==== Relevé d’identité ====
  const QuizQuestion(
    category: "Relevé d'identité — Nature juridique",
    question: "Le relevé d’identité prévu par 78-6 CPP est :",
    options: [
      "Une opération de police administrative",
      "Une opération de police judiciaire",
      "Une formalité civile",
    ],
    answer: "Une opération de police judiciaire",
    explanation: "Il suppose qu’une infraction ait été commise préalablement.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Relevé d'identité — Refus",
    question:
        "En cas de refus de justifier de son identité lors d’un relevé, l’agent peut :",
    options: [
      "Laisser partir immédiatement la personne",
      "Utiliser la coercition pour la maintenir sur place en attendant l’OPJ",
      "Appeler systématiquement le maire",
    ],
    answer:
        "Utiliser la coercition pour la maintenir sur place en attendant l’OPJ",
    explanation: "Le refus est même sanctionné par 2 mois d’emprisonnement.",
    difficulty: "Intermédiaire",
  ),

  // ==== Vérification d’identité & rétention ====
  const QuizQuestion(
    category: "Vérification — Compétence",
    question: "Qui est compétent pour ordonner une vérification d’identité ?",
    options: ["L’APJ", "L’OPJ exclusivement", "Le préfet"],
    answer: "L’OPJ exclusivement",
    explanation: "L’APJ peut constater le refus, mais seul l’OPJ décide.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification — Début du délai",
    question:
        "Quand commence le délai légal de la rétention pour vérification d’identité ?",
    options: [
      "À l’arrivée au commissariat",
      "Au moment du constat du refus/impossibilité de justifier",
      "À la première audition",
    ],
    answer: "Au moment du constat du refus/impossibilité de justifier",
    explanation:
        "Le CPP prévoit que la rétention débute dès le constat sur place.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification — Droit d’aviser",
    question:
        "La personne retenue peut demander d’aviser une personne de son choix :",
    options: ["Uniquement si elle est mineure", "À tout moment", "Jamais"],
    answer: "À tout moment",
    explanation: "78-3 CPP : droit d’aviser famille ou personne choisie.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification — OPJ",
    question: "Pendant la rétention, le procureur de la République peut :",
    options: [
      "Mettre fin à la rétention à tout moment",
      "Allonger le délai à 10 heures",
      "Remplacer l’OPJ par un APJA",
    ],
    answer: "Mettre fin à la rétention à tout moment",
    explanation: "Il exerce un contrôle permanent de la mesure.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification — Garde à vue",
    question:
        "Si une garde à vue est décidée après une vérification d’identité :",
    options: [
      "La rétention ne compte pas",
      "La rétention s’impute sur la garde à vue",
      "Une nouvelle durée de 24h recommence intégralement",
    ],
    answer: "La rétention s’impute sur la garde à vue",
    explanation:
        "La durée totale de privation de liberté est calculée globalement.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification — OPJ",
    question:
        "Que doit contenir la motivation de la demande d’empreintes/photographies ?",
    options: [
      "Une appréciation générale de la personnalité",
      "La preuve que ces opérations sont l’unique moyen d’établir l’identité",
      "L’accord préalable du maire",
    ],
    answer:
        "La preuve que ces opérations sont l’unique moyen d’établir l’identité",
    explanation: "Condition essentielle pour recourir à l’identité judiciaire.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU DIFFICILE =====================

  // ==== Jurisprudence, cas pratiques ====
  const QuizQuestion(
    category: "Jurisprudence — Fouille",
    question:
        "Selon la jurisprudence (Cass. crim 23 mars 2016), une palpation de sécurité lors d’un contrôle d’identité :",
    options: [
      "Autorise automatiquement la fouille du sac",
      "N’autorise pas la fouille du sac sans assentiment ou indice d’infraction",
      "Oblige à placer la personne en garde à vue",
    ],
    answer:
        "N’autorise pas la fouille du sac sans assentiment ou indice d’infraction",
    explanation:
        "La fouille nécessite consentement ou élément objectif d’infraction flagrante.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Étranger",
    question:
        "Un étranger peut être contrôlé sur sa situation administrative si :",
    options: [
      "Son apparence laisse penser qu’il n’est pas français",
      "Des éléments objectifs extérieurs indiquent une possible extranéité",
      "Il parle une autre langue",
    ],
    answer:
        "Des éléments objectifs extérieurs indiquent une possible extranéité",
    explanation:
        "Les critères doivent être neutres et objectifs (immatriculation étrangère, tracts...).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Document douteux",
    question: "Si un document d’identité présenté paraît falsifié :",
    options: [
      "L’agent doit immédiatement arrêter la personne",
      "Le contrôle peut se transformer en enquête judiciaire si suspicion raisonnable",
      "Le document doit être accepté",
    ],
    answer:
        "Le contrôle peut se transformer en enquête judiciaire si suspicion raisonnable",
    explanation:
        "La découverte d’un faux document peut fonder une procédure incidente.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Refus de décliner l'identité",
    question: "Une personne refuse de donner son identité lors du contrôle :",
    options: [
      "Elle doit être relâchée immédiatement",
      "Cela justifie une rétention pour vérification d’identité",
      "Elle doit être placée en garde à vue sans condition",
    ],
    answer: "Cela justifie une rétention pour vérification d’identité",
    explanation:
        "Le refus est explicitement prévu comme motif de rétention (78-3).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Témoins",
    question:
        "Une personne affirme que deux passants peuvent attester de son identité, mais ceux-ci sont déjà partis :",
    options: [
      "Les policiers doivent la laisser les rechercher",
      "La vérification d'identité peut être engagée",
      "La personne doit être relâchée",
    ],
    answer: "La vérification d'identité peut être engagée",
    explanation: "Les témoignages doivent être concomitants et immédiats.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Jeune mineur",
    question:
        "Lors d’une vérification d’identité d’un mineur supposé, l’agent doit :",
    options: [
      "Obligatoirement contacter ses parents avant tout",
      "Apprécier l’âge apparent et informer immédiatement le procureur",
      "Arrêter l’opération car un mineur ne peut être vérifié",
    ],
    answer: "Apprécier l’âge apparent et informer immédiatement le procureur",
    explanation: "78-3 : avis obligatoire au procureur pour les mineurs.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Contrôle professionnel",
    question: "Une visite dans des locaux professionnels peut être effectuée :",
    options: [
      "Sans réquisition du procureur si l’employeur est présent",
      "Uniquement avec des réquisitions écrites du procureur",
      "Uniquement avec l’accord oral du gérant",
    ],
    answer: "Uniquement avec des réquisitions écrites du procureur",
    explanation:
        "78-2-1 impose des réquisitions écrites pour entrer dans les locaux professionnels.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Refus empreintes",
    question:
        "Une personne retenue refuse de donner ses empreintes malgré l’autorisation du procureur :",
    options: [
      "Elle peut être relâchée",
      "Elle commet un délit passible de 3 mois d’emprisonnement",
      "On doit abandonner la procédure",
    ],
    answer: "Elle commet un délit passible de 3 mois d’emprisonnement",
    explanation: "78-5 CPP sanctionne ce refus.",
    difficulty: "Difficile",
  ),

  // ===================== NOUVELLE FOURNÉE DE QUESTIONS SUPPLÉMENTAIRES =====================

  // ==== Cadre général & principes ====
  const QuizQuestion(
    category: "Généralités — Libertés individuelles",
    question:
        "Qui est gardienne des libertés individuelles dans le cadre des contrôles d’identité ?",
    options: [
      "L’autorité administrative",
      "L’autorité judiciaire",
      "Le maire de la commune",
    ],
    answer: "L’autorité judiciaire",
    explanation:
        "Les contrôles d’identité s’inscrivent dans un équilibre entre sécurité et libertés, dont l’autorité judiciaire est la gardienne.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Nature des opérations",
    question:
        "Les contrôles, relevés et vérifications d’identité sont principalement :",
    options: [
      "Des opérations tendant à établir l’identité d’une personne",
      "Des moyens de sanction immédiate",
      "Des formes de punition collective",
    ],
    answer: "Des opérations tendant à établir l’identité d’une personne",
    explanation:
        "Ce sont des opérations centrées sur l’établissement de l’identité, non sur la sanction.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Distinction phases",
    question:
        "Quelle affirmation est exacte concernant les différentes phases d’identification ?",
    options: [
      "Contrôle, relevé et vérification d’identité sont strictement identiques",
      "Le contrôle est la première phase, la vérification est coercitive, le relevé est une opération spécifique pour les contraventions",
      "Seule la vérification d’identité existe en droit",
    ],
    answer:
        "Le contrôle est la première phase, la vérification est coercitive, le relevé est une opération spécifique pour les contraventions",
    explanation: "Chaque phase a un cadre juridique et des acteurs différents.",
    difficulty: "Intermédiaire",
  ),

  // ==== Contrôle d’identité — Fondements supplémentaires ====
  const QuizQuestion(
    category: "Police judiciaire — Cas 3 (contrôle judiciaire)",
    question:
        "Quel exemple illustre une personne pouvant être contrôlée car elle viole les obligations d’un contrôle judiciaire ?",
    options: [
      "Une personne qui traverse hors passage piéton",
      "Une personne assignée à résidence avec bracelet qui n’est pas à son domicile aux heures imposées",
      "Un conducteur qui roule à 49 km/h au lieu de 50",
    ],
    answer:
        "Une personne assignée à résidence avec bracelet qui n’est pas à son domicile aux heures imposées",
    explanation:
        "Elle viole une obligation imposée par l’autorité judiciaire (78-2 al. 5).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Cas 4 (renseignements)",
    question:
        "Un contrôle peut viser une personne simplement témoin de faits si :",
    options: [
      "Elle possède un casier judiciaire vierge",
      "Elle est susceptible de fournir des renseignements utiles en cas de crime ou délit",
      "Elle refuse de répondre à un sondage",
    ],
    answer:
        "Elle est susceptible de fournir des renseignements utiles en cas de crime ou délit",
    explanation:
        "Le texte vise les personnes pouvant aider à la manifestation de la vérité, même sans être suspectes.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Initiatives OPJ",
    question:
        "Qui peut prendre l’initiative d’un contrôle d’identité dans un cadre purement judiciaire, sans réquisition du parquet ?",
    options: ["Le préfet", "L’OPJ et, sous son contrôle, l’APJ", "Le maire"],
    answer: "L’OPJ et, sous son contrôle, l’APJ",
    explanation:
        "78-2 al. 1 : l’initiative appartient aux policiers, sous réserve de raisons plausibles.",
    difficulty: "Facile",
  ),

  // ==== Contrôles préventifs — Conditions plus fines ====
  const QuizQuestion(
    category: "Préventif — Menace à l’ordre public",
    question: "Pour mettre en place un contrôle préventif, il faut :",
    options: [
      "Des éléments objectifs faisant présumer une menace à l’ordre public",
      "Une simple impression d’insécurité",
      "Une décision du maire",
    ],
    answer:
        "Des éléments objectifs faisant présumer une menace à l’ordre public",
    explanation:
        "Les contrôles préventifs doivent reposer sur des circonstances précises : risques d’atteinte aux personnes ou aux biens.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Préventif — Justification a posteriori",
    question:
        "En cas de contestation, que devront démontrer les policiers à propos du contrôle préventif ?",
    options: [
      "Qu’ils ont contrôlé tout le monde",
      "Qu’ils ont bien identifié un lieu et un contexte présentant un risque particulier pour la sécurité",
      "Qu’ils ont fouillé chaque personne présentée",
    ],
    answer:
        "Qu’ils ont bien identifié un lieu et un contexte présentant un risque particulier pour la sécurité",
    explanation:
        "La menace à l’ordre public doit être caractérisée et justifiable devant le juge.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Préventif — Lieu privé",
    question:
        "Un contrôle préventif au domicile d’une personne peut-il être effectué ?",
    options: [
      "Oui, à tout moment si la personne accepte verbalement",
      "Oui, mais uniquement la nuit",
      "Non, il serait requalifié en perquisition et doit respecter un autre cadre juridique",
    ],
    answer:
        "Non, il serait requalifié en perquisition et doit respecter un autre cadre juridique",
    explanation:
        "Les contrôles préventifs se limitent aux lieux publics ou ouverts au public.",
    difficulty: "Difficile",
  ),

  // ==== Contrôles en zone frontière — Variantes ====
  const QuizQuestion(
    category: "Frontière — Section autoroutière",
    question:
        "Un contrôle en zone frontière sur autoroute peut se poursuivre au-delà des 20 km si :",
    options: [
      "L’OPJ le décide",
      "Le premier péage autoroutier est au-delà de cette limite",
      "La météo est défavorable",
    ],
    answer: "Le premier péage autoroutier est au-delà de cette limite",
    explanation:
        "La loi permet le contrôle jusqu’au premier péage même au-delà de la bande des 20 km.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Frontière — Points de passage frontaliers",
    question:
        "Dans un rayon de 10 km autour d’un aéroport désigné comme point de passage frontalier, on peut :",
    options: [
      "Procéder à des contrôles d’identité permanents et systématiques",
      "Procéder à des contrôles d’identité non permanents et non systématiques",
      "Uniquement contrôler les cartes d’embarquement",
    ],
    answer:
        "Procéder à des contrôles d’identité non permanents et non systématiques",
    explanation:
        "La loi impose le caractère non permanent et non systématique pour respecter les libertés.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Frontière — Territoires ultras-marins",
    question:
        "Quelle particularité concerne la Guyane en matière de contrôles d’identité en zone frontière ?",
    options: [
      "Aucune zone spécifique",
      "Une zone entre la frontière ou le littoral et une ligne à 20 km en deçà, plus une bande de 5 km de part et d’autre de certains axes",
      "Uniquement dans les aéroports",
    ],
    answer:
        "Une zone entre la frontière ou le littoral et une ligne à 20 km en deçà, plus une bande de 5 km de part et d’autre de certains axes",
    explanation:
        "Le texte prévoit une configuration spéciale pour la Guyane en raison de la pression migratoire.",
    difficulty: "Difficile",
  ),

  // ==== Contrôle de réglementation vs contrôle d’identité ====
  const QuizQuestion(
    category: "Réglementation — Différence",
    question:
        "Un contrôle du permis de conduire d’un automobiliste en circulation est :",
    options: [
      "Un contrôle d’identité au sens de 78-2",
      "Un contrôle de réglementation routière",
      "Une vérification d’identité",
    ],
    answer: "Un contrôle de réglementation routière",
    explanation:
        "Le contrôle de documents liés à une activité (conduite, chasse…) est un contrôle de réglementation, pas un contrôle d’identité.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réglementation — Caractère autonome",
    question:
        "Un contrôle de réglementation (ex : permis de chasse) peut-il être effectué sans contrôle d’identité préalable ?",
    options: [
      "Non, il suppose toujours un contrôle d’identité",
      "Oui, car il repose sur l’apparence objective de l’activité exercée",
      "Uniquement si la personne est connue défavorablement",
    ],
    answer:
        "Oui, car il repose sur l’apparence objective de l’activité exercée",
    explanation:
        "La situation est visible : chasseur armé, conducteur, forain, etc.",
    difficulty: "Intermédiaire",
  ),

  // ==== Étrangers & CESEDA — Approfondissement ====
  const QuizQuestion(
    category: "Étrangers — Durée contrôle situation",
    question:
        "Le contrôle de situation administrative prévu à l’article L. 812-2 CESEDA ne peut excéder :",
    options: ["2 heures", "4 heures", "6 heures dans un même lieu"],
    answer: "6 heures dans un même lieu",
    explanation:
        "La durée est plafonnée à 6 heures, sans contrôle systématique.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Étrangers — Contrôle systématique",
    question:
        "Le contrôle de situation administrative des étrangers peut-il être systématique dans une zone donnée ?",
    options: [
      "Oui, s’il est limité dans le temps",
      "Non, la loi exclut explicitement un contrôle systématique",
      "Oui, si le maire en fait la demande",
    ],
    answer: "Non, la loi exclut explicitement un contrôle systématique",
    explanation:
        "Les textes précisent qu’il ne peut s’agir d’un contrôle systématique.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Étrangers — Critères objectifs",
    question:
        "Parmi les éléments suivants, lequel peut constituer un critère objectif d’extranéité ?",
    options: [
      "La couleur de peau",
      "La plaque d’immatriculation étrangère du véhicule",
      "Le prénom à consonance étrangère",
    ],
    answer: "La plaque d’immatriculation étrangère du véhicule",
    explanation:
        "Les critères doivent être objectifs et extérieurs à la personne (véhicule, banderoles…).",
    difficulty: "Difficile",
  ),

  // ==== Moyens de preuve de l’identité — Approfondissement ====
  const QuizQuestion(
    category: "Preuve — Document privé",
    question:
        "Une carte de membre d’un club sportif avec photo peut-elle être prise en compte ?",
    options: [
      "Non, jamais",
      "Oui, comme élément de preuve à apprécier par les policiers",
      "Oui, avec la même valeur qu’une CNI",
    ],
    answer: "Oui, comme élément de preuve à apprécier par les policiers",
    explanation:
        "Tout document même privé peut constituer un commencement de preuve s’il semble crédible.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Preuve — Absence totale de document",
    question:
        "Si la personne ne présente aucun document et aucun témoin n’est disponible :",
    options: [
      "Elle doit être relâchée",
      "Une vérification d’identité avec rétention peut être engagée",
      "Les policiers doivent l’ignorer",
    ],
    answer: "Une vérification d’identité avec rétention peut être engagée",
    explanation:
        "Refus ou impossibilité matérialisée justifient la rétention pour vérification.",
    difficulty: "Intermédiaire",
  ),

  // ==== Relevé d’identité — Approfondissement ====
  const QuizQuestion(
    category: "Relevé d'identité — Contraventions visées",
    question: "Le relevé d’identité par les APJA selon 78-6 peut viser :",
    options: [
      "Les crimes uniquement",
      "Les contraventions à certains arrêtés municipaux et au code de la route",
      "Uniquement les délits",
    ],
    answer:
        "Les contraventions à certains arrêtés municipaux et au code de la route",
    explanation:
        "Le texte vise principalement les contraventions à la police de la circulation et à des arrêtés.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Relevé d'identité — Recueil simple",
    question:
        "Quelle différence entre recueil d’identité et relevé d’identité ?",
    options: [
      "Aucune, ce sont des synonymes",
      "Le recueil repose sur la bonne foi sans exiger de document, le relevé permet d’exiger une pièce d’identité",
      "Le recueil se fait uniquement en garde à vue",
    ],
    answer:
        "Le recueil repose sur la bonne foi sans exiger de document, le relevé permet d’exiger une pièce d’identité",
    explanation: "Le relevé ajoute un pouvoir d’exiger un justificatif.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Relevé d'identité — Durée maintien sur place",
    question:
        "La rétention sur la voie publique par un APJA dans l’attente des instructions de l’OPJ doit durer :",
    options: [
      "Le temps strictement nécessaire pour joindre l’OPJ",
      "Au minimum quatre heures",
      "Jusqu’à la fin de la journée de service",
    ],
    answer: "Le temps strictement nécessaire pour joindre l’OPJ",
    explanation: "Le maintien sur place doit être proportionné et limité.",
    difficulty: "Intermédiaire",
  ),

  // ==== Vérification d’identité — Détails procéduraux ====
  const QuizQuestion(
    category: "Vérification — Lieu d’exécution",
    question: "La rétention pour vérification d’identité peut avoir lieu :",
    options: [
      "Uniquement dans un local de police",
      "Sur place ou dans un local de police",
      "Uniquement dans un véhicule de patrouille",
    ],
    answer: "Sur place ou dans un local de police",
    explanation:
        "78-3 : l’intéressé peut être retenu sur place ou conduit dans un local.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vérification — Information des droits",
    question:
        "À quel moment la personne doit-elle être informée de son droit de faire aviser le procureur de la République ?",
    options: [
      "Uniquement en fin de rétention",
      "Dès sa présentation à l’OPJ",
      "Après la rédaction du PV",
    ],
    answer: "Dès sa présentation à l’OPJ",
    explanation: "L’information doit être immédiate et mentionnée au PV.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification — PV",
    question:
        "Si la vérification d’identité n’est suivie d’aucune enquête, une copie du procès-verbal :",
    options: [
      "N’est jamais remise à l’intéressé",
      "Doit être remise à l’intéressé",
      "Est envoyée au maire",
    ],
    answer: "Doit être remise à l’intéressé",
    explanation:
        "L’original part au parquet, l’intéressé reçoit une copie si aucune procédure ne suit.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification — Heures à mentionner",
    question: "Le procès-verbal de vérification d’identité doit mentionner :",
    options: [
      "Uniquement l’heure de fin de rétention",
      "Les heures de début du contrôle ou relevé d’identité, et de début/fin de rétention",
      "Uniquement la date du jour",
    ],
    answer:
        "Les heures de début du contrôle ou relevé d’identité, et de début/fin de rétention",
    explanation:
        "Ces mentions permettent de contrôler la durée maximale légale.",
    difficulty: "Difficile",
  ),

  // ==== Visites de véhicules / bagages (identité et sécurité) ====
  const QuizQuestion(
    category: "Véhicules — Présence OPJ",
    question:
        "Lors d’une visite de véhicule sur réquisitions du procureur (78-2-2), la visite doit être faite :",
    options: [
      "Par n’importe quel agent, sans OPJ",
      "Par un OPJ, éventuellement assisté d’APJ/APJA",
      "Uniquement par la police municipale",
    ],
    answer: "Par un OPJ, éventuellement assisté d’APJ/APJA",
    explanation: "La visite impose la présence effective d’un OPJ.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Bagages — Inspection visuelle",
    question:
        "Lors d’une inspection visuelle des bagages sur réquisitions, le propriétaire :",
    options: [
      "Ne doit jamais être présent",
      "Doit être présent et ne peut être retenu que le temps nécessaire à la fouille",
      "Peut être retenu automatiquement 4 heures",
    ],
    answer:
        "Doit être présent et ne peut être retenu que le temps nécessaire à la fouille",
    explanation:
        "La loi impose la présence du propriétaire et un temps limité.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Véhicules — Prévention atteinte grave",
    question:
        "Pour prévenir une atteinte grave à la sécurité (78-2-4), la visite de véhicule peut être réalisée :",
    options: [
      "Avec l’accord du conducteur ou à défaut sur instruction du procureur",
      "Uniquement avec l’accord écrit du maire",
      "Sans base légale particulière",
    ],
    answer:
        "Avec l’accord du conducteur ou à défaut sur instruction du procureur",
    explanation:
        "Le texte prévoit l’accord ou, à défaut, une instruction du parquet.",
    difficulty: "Difficile",
  ),

  // ==== Manifestations & armes (78-2-5) ====
  const QuizQuestion(
    category: "Manifestation — Contrôles possibles",
    question:
        "Sur les lieux d’une manifestation sur la voie publique, que permet l’article 78-2-5 ?",
    options: [
      "Contrôle d’identité systématique de tous les manifestants",
      "Inspection visuelle/fouille des bagages et visite des véhicules pour rechercher les armes",
      "Perquisition des domiciles des organisateurs",
    ],
    answer:
        "Inspection visuelle/fouille des bagages et visite des véhicules pour rechercher les armes",
    explanation:
        "Les contrôles d’identité sont exclus dans ce dispositif spécifique.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Manifestation — Limites",
    question: "Dans le cadre de l’article 78-2-5, les contrôles d’identité :",
    options: [
      "Sont autorisés",
      "Sont expressément exclus",
      "Sont obligatoires pour chaque personne fouillée",
    ],
    answer: "Sont expressément exclus",
    explanation: "Le texte vise seulement les armes, via bagages et véhicules.",
    difficulty: "Difficile",
  ),

  // ==== Nullités & contrôles du procureur ====
  const QuizQuestion(
    category: "Nullité — Mentions manquantes",
    question:
        "L’absence de mention de la durée de rétention dans le PV de vérification d’identité peut entraîner :",
    options: [
      "Aucune conséquence",
      "La nullité de la procédure",
      "La simple annulation du PV sans effet sur le reste",
    ],
    answer: "La nullité de la procédure",
    explanation: "Les formalités de 78-3 sont imposées à peine de nullité.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Contrôle parquet — Pendant la rétention",
    question:
        "Pendant la vérification d’identité, le procureur de la République peut :",
    options: [
      "Se rendre sur place, ordonner un examen médical ou mettre fin à la rétention",
      "Modifier rétroactivement l’heure de début de rétention",
      "Supprimer l’obligation de PV",
    ],
    answer:
        "Se rendre sur place, ordonner un examen médical ou mettre fin à la rétention",
    explanation: "Le parquet exerce un contrôle concret sur la mesure.",
    difficulty: "Intermédiaire",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizControleIdentitePageGPX extends StatefulWidget {
  static const String grade = 'gpx';
  static const String routeName = '/gpx/generalites/quiz/controle_identite';
  final String uid;
  final String email;

  const QuizControleIdentitePageGPX({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizControleIdentitePageGPX> createState() => _QuizControleIdentitePageGPXState();
}

class _QuizControleIdentitePageGPXState extends State<QuizControleIdentitePageGPX>
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
  static const _introHiddenKey = 'intro_gpx_controle_identite';
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
        ? questionsControleIdentite
        : questionsControleIdentite
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
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Cadres Juridiques',
            'quiz_name': 'Contrôle Identité',
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
      await _sb.from('quiz_controle_identite').insert({
        'user_uid': widget.uid,
        'email': widget.email,
        
            'grade': UserContextService.I.trackOrDefault,'question': question,
        'user_answer': userAnswer,
        'correct_answer': correctAnswer,
        'is_correct': isCorrect,
        'score': _score,
        'difficulty': difficulty,
      });
    } catch (e) {
      debugPrint('❌ quiz_controle_identite insert failed: $e');
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
      setState(() { _showIntro = true; _showSplash = false; });
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
      'source_file': 'gpx_quiz_controle_identite',
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
        final bg = isDark ? const Color(0xFF2C2C2E) : _Brand.bgLight;
        final textCol = isDark ? Colors.white : _Brand.textDark;
        final base = isDark ? ThemeData.dark() : ThemeData.light();

        const double kButtonHeight = 56;
        const double kButtonVPad = 16;
        const double bottomBarReserved = kButtonHeight + kButtonVPad + 8;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: (isDark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark)
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
            child: Scaffold(
              backgroundColor: bg,
              extendBody: true,
              extendBodyBehindAppBar: _showSplash,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.close_rounded, color: textCol),
                  onPressed: () => Navigator.maybePop(context),
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

                        if (_showIntro)
                          _IntroSplash(
                            isDark: isDark,
                            hideForever: _hideIntroForever,
                            onChangedHideForever: _saveIntroPreference,
                            onStart: () async { await _doStartQuiz(); },
                            icon: Icons.badge_rounded,
                            title: 'Contrôle d’identité',
                            description: 'Maîtrise les différents types de contrôle d’identité : judiciaire, administratif, préventif. Conditions, procédures et droits des personnes.',
                            timerText: '30 secondes par question',
                            historyText: 'Tes résultats sont sauvegardés pour suivre ta progression',
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
                            const spacing = 12.0;
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
                                label: 'Moyenne',
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
    const good   = Color(0xFF27C93F);
    final bg      = isDark ? const Color(0xFF08111D) : const Color(0xFFF4F7FB);
    final cardBg  = isDark ? const Color(0xFF101826) : Colors.white;
    final border  = isDark ? const Color(0xFF253247) : const Color(0xFFE3EAF5);
    final txtMain = isDark ? Colors.white : const Color(0xFF212529);
    final txtSub  = isDark ? Colors.white.withAlpha(210) : const Color(0xFF212529).withAlpha(210);

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
                        color: Colors.black.withValues(alpha: isDark ? .22 : .08),
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
                      Row(children: [
                        const Icon(Icons.timer_outlined, color: accent, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(timerText, style: TextStyle(color: txtMain, fontWeight: FontWeight.w700, decoration: TextDecoration.none))),
                      ]),
                      const SizedBox(height: 10),
                      Row(children: [
                        const Icon(Icons.auto_graph_rounded, color: good, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(historyText, style: TextStyle(color: txtMain, fontWeight: FontWeight.w700, decoration: TextDecoration.none))),
                      ]),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: hideForever,
                        onChanged: (v) => onChangedHideForever(v ?? false),
                        title: Text('Ne plus afficher cet \u00e9cran', style: TextStyle(color: txtMain, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onStart,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: isDark ? Colors.white : const Color(0xFF212529),
                            foregroundColor: isDark ? Colors.black : Colors.white,
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
