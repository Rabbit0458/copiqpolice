import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:copiqpolice/ui/app_notifier.dart'
    show AppNotifier, AppSettingsController;

Color _opa(Color c, double a) => c.withValues(alpha: a);

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

class QuizOption {
  final String label; // texte affiché + valeur comparée
  final String? assetImage; // ex: "assets/images/major.png"
  final String? networkImage; // si un jour tu veux du réseau

  const QuizOption({required this.label, this.assetImage, this.networkImage});
}

class QuizQuestion {
  final String category;
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;
  final String difficulty;
  final String? sub;

  // ✅ nouveau
  final String? questionImageAsset; // ex: "assets/images/dgpn.png"

  const QuizQuestion({
    required this.category,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.difficulty,
    this.sub,
    this.questionImageAsset,
  });
}

final List<QuizQuestion> questionOrganisationPN = [
  QuizQuestion(
    category: "Organisation PN — Vue d’ensemble",
    question: "La Police nationale comporte principalement :",
    options: [
      "Trois grandes entités : DGPN, DGSI et Préfecture de police",
      "Deux grandes entités : DGPN et Gendarmerie",
      "Quatre entités : DGPN, DGSI, PP et Police municipale",
    ],
    answer: "Trois grandes entités : DGPN, DGSI et Préfecture de police",
    explanation: "Les trois blocs courants : DGPN, DGSI, et PP (Paris).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: [
      "Directeur général de la Police nationale (DGPN)",
      "Directeur des services actifs (DSA)",
      "Inspecteur général",
    ],
    answer: "Directeur général de la Police nationale (DGPN)",
    explanation:
        "Insigne correspondant au Directeur général de la Police nationale (DGPN).",
    difficulty: "Facile",
    questionImageAsset: "assets/images/dgpn.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: [
      "Directeur des services actifs (DSA)",
      "Directeur général de la Police nationale (DGPN)",
      "Contrôleur général",
    ],
    answer: "Directeur des services actifs (DSA)",
    explanation:
        "Insigne correspondant au Directeur des services actifs (DSA).",
    difficulty: "Facile",
    questionImageAsset: "assets/images/dsa.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: [
      "Inspecteur général",
      "Contrôleur général",
      "Commissaire général de police",
    ],
    answer: "Inspecteur général",
    explanation: "Insigne correspondant à l’Inspecteur général.",
    difficulty: "Facile",
    questionImageAsset: "assets/images/inspecteur_general.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: [
      "Contrôleur général",
      "Inspecteur général",
      "Commissaire divisionnaire",
    ],
    answer: "Contrôleur général",
    explanation: "Insigne correspondant au Contrôleur général.",
    difficulty: "Facile",
    questionImageAsset: "assets/images/controleur_general.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: [
      "Commissaire général de police",
      "Commissaire divisionnaire",
      "Commissaire de police",
    ],
    answer: "Commissaire général de police",
    explanation: "Insigne correspondant au Commissaire général de police.",
    difficulty: "Facile",
    questionImageAsset: "assets/images/commisaire_general_police.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: [
      "Commissaire divisionnaire",
      "Commissaire de police",
      "Élève commissaire",
    ],
    answer: "Commissaire divisionnaire",
    explanation: "Insigne correspondant au Commissaire divisionnaire.",
    difficulty: "Facile",
    questionImageAsset: "assets/images/commisaire_divisionnaire.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: [
      "Commissaire de police",
      "Élève commissaire",
      "Commissaire divisionnaire",
    ],
    answer: "Commissaire de police",
    explanation: "Insigne correspondant au Commissaire de police.",
    difficulty: "Facile",
    questionImageAsset: "assets/images/commissaire_police.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: ["Élève commissaire", "Commissaire de police", "Capitaine"],
    answer: "Élève commissaire",
    explanation: "Insigne correspondant à l’Élève commissaire.",
    difficulty: "Facile",
    questionImageAsset: "assets/images/eleve_commissaire.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: [
      "Commandant divisionnaire fonctionnel de police",
      "Commandant divisionnaire",
      "Commandant de police",
    ],
    answer: "Commandant divisionnaire fonctionnel de police",
    explanation:
        "Insigne correspondant au Commandant divisionnaire fonctionnel de police.",
    difficulty: "Moyenne",
    questionImageAsset:
        "assets/images/commandant_divisionnaire_fonctionnel_police.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: ["Commandant divisionnaire", "Commandant de police", "Capitaine"],
    answer: "Commandant divisionnaire",
    explanation: "Insigne correspondant au Commandant divisionnaire.",
    difficulty: "Facile",
    questionImageAsset: "assets/images/commandant_divisionnaire.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: ["Commandant de police", "Capitaine", "Commissaire de police"],
    answer: "Commandant de police",
    explanation: "Insigne correspondant au Commandant de police.",
    difficulty: "Facile",
    questionImageAsset: "assets/images/commandant_police.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: ["Capitaine", "Commandant de police", "Brigadier-chef"],
    answer: "Capitaine",
    explanation: "Insigne correspondant au grade de Capitaine.",
    difficulty: "Facile",
    questionImageAsset: "assets/images/capitaine.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question:
        "Quel est ce grade (appellation Lieutenant — 6 premiers mois de scolarité) ?",
    options: [
      "Capitaine (appellation Lieutenant — 6 premiers mois)",
      "Capitaine (appellation Lieutenant — stagiaire)",
      "Capitaine (appellation Lieutenant — 4 ans après titularisation)",
    ],
    answer: "Capitaine (appellation Lieutenant — 6 premiers mois)",
    explanation:
        "C’est la version “Lieutenant” pendant les 6 premiers mois de scolarité.",
    difficulty: "Difficile",
    questionImageAsset: "assets/images/lieutenant_six_mois_scolarite.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question:
        "Quel est ce grade (appellation Lieutenant — stagiaire jusqu’à la fin de la scolarité) ?",
    options: [
      "Capitaine (appellation Lieutenant — stagiaire)",
      "Capitaine (appellation Lieutenant — 6 premiers mois)",
      "Capitaine (appellation Lieutenant — 4 ans après titularisation)",
    ],
    answer: "Capitaine (appellation Lieutenant — stagiaire)",
    explanation:
        "C’est la version “Lieutenant” en tant que stagiaire jusqu’à la fin de la scolarité.",
    difficulty: "Difficile",
    questionImageAsset: "assets/images/capitaine_lieutenant_stagiaire.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question:
        "Quel est ce grade (Capitaine — appellation Lieutenant pendant 4 ans après titularisation) ?",
    options: [
      "Capitaine (appellation Lieutenant — 4 ans après titularisation)",
      "Capitaine (appellation Lieutenant — stagiaire)",
      "Capitaine (appellation Lieutenant — 6 premiers mois)",
    ],
    answer: "Capitaine (appellation Lieutenant — 4 ans après titularisation)",
    explanation:
        "Après titularisation, l’appellation “Lieutenant” dure 4 ans (dans ton découpage).",
    difficulty: "Difficile",
    questionImageAsset: "assets/images/capitaine_police_quatres_an.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: ["Brigadier-chef", "Major de police", "Sous-brigadier (GPX)"],
    answer: "Brigadier-chef",
    explanation: "Insigne correspondant au Brigadier-chef.",
    difficulty: "Facile",
    questionImageAsset: "assets/images/brigadier_chef.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: ["Major de police", "Major exceptionnel", "Major RULP"],
    answer: "Major de police",
    explanation: "Insigne correspondant au Major de police.",
    difficulty: "Facile",
    questionImageAsset: "assets/images/major_police.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: ["Major exceptionnel", "Major de police", "Major RULP"],
    answer: "Major exceptionnel",
    explanation: "Insigne correspondant au Major exceptionnel.",
    difficulty: "Moyenne",
    questionImageAsset: "assets/images/major_exceptionnel.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: ["Major RULP", "Major exceptionnel", "Brigadier-chef"],
    answer: "Major RULP",
    explanation: "Insigne correspondant au Major RULP.",
    difficulty: "Moyenne",
    questionImageAsset: "assets/images/major_rulp.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: [
      "Sous-brigadier (GPX)",
      "Gardien de la paix",
      "Gardien de la paix stagiaire",
    ],
    answer: "Sous-brigadier (GPX)",
    explanation: "Insigne correspondant au sous-brigadier (GPX).",
    difficulty: "Facile",
    questionImageAsset: "assets/images/sous_brigadier_gpx.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: [
      "Gardien de la paix",
      "Gardien de la paix stagiaire",
      "Policier adjoint",
    ],
    answer: "Gardien de la paix",
    explanation: "Insigne correspondant au Gardien de la paix.",
    difficulty: "Facile",
    questionImageAsset: "assets/images/gpx.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: [
      "Gardien de la paix stagiaire",
      "Gardien de la paix",
      "Policier adjoint",
    ],
    answer: "Gardien de la paix stagiaire",
    explanation: "Insigne correspondant au Gardien de la paix stagiaire.",
    difficulty: "Facile",
    questionImageAsset: "assets/images/gpxs.png",
  ),

  QuizQuestion(
    category: "Grades PN — Reconnaissance",
    question: "Quel est ce grade ?",
    options: [
      "Policier adjoint",
      "Gardien de la paix stagiaire",
      "Gardien de la paix",
    ],
    answer: "Policier adjoint",
    explanation: "Insigne correspondant au Policier adjoint.",
    difficulty: "Facile",
    questionImageAsset: "assets/images/pa.png",
  ),

  QuizQuestion(
    category: "Organisation PN — DGPN",
    question: "La DGPN signifie :",
    options: [
      "Direction générale de la Police nationale",
      "Direction générale de la Protection nationale",
      "Direction de gestion de la Police nationale",
    ],
    answer: "Direction générale de la Police nationale",
    explanation: "DGPN = Direction générale de la Police nationale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGSI",
    question: "La DGSI signifie :",
    options: [
      "Direction générale de la Sécurité intérieure",
      "Direction générale de la Sécurité internationale",
      "Direction de gestion des Services d’intervention",
    ],
    answer: "Direction générale de la Sécurité intérieure",
    explanation: "DGSI = Direction générale de la Sécurité intérieure.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "La Préfecture de police (PP) concerne principalement :",
    options: [
      "Paris et la petite couronne (92/93/94) selon les compétences",
      "Toute la France métropolitaine",
      "Uniquement l’outre-mer",
    ],
    answer: "Paris et la petite couronne (92/93/94) selon les compétences",
    explanation:
        "PP : Paris + compétences étendues incluant 92/93/94 sur certains volets.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question: "La DGPN est :",
    options: [
      "La Direction générale de la Police nationale",
      "La Direction générale de la Protection nationale",
      "La Direction de gestion de la Police nationale",
    ],
    answer: "La Direction générale de la Police nationale",
    explanation: "DGPN = Direction générale de la Police nationale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question: "Le directeur général de la Police nationale est :",
    options: [
      "Assisté d’un directeur général adjoint",
      "Assisté d’un préfet maritime",
      "Assisté d’un procureur général",
    ],
    answer: "Assisté d’un directeur général adjoint",
    explanation: "DGPN : DG + DG adjoint pour diriger et coordonner.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Vue d’ensemble",
    question: "La Police nationale comporte principalement :",
    options: [
      "DGPN, DGSI et Préfecture de police",
      "DGPN, Police municipale et Douanes",
      "DGSI, Gendarmerie et Justice",
    ],
    answer: "DGPN, DGSI et Préfecture de police",
    explanation: "Organisation d’ensemble : DGPN + DGSI + PP.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGSI",
    question: "La DGSI signifie :",
    options: [
      "Direction générale de la Sécurité intérieure",
      "Direction générale de la Sécurité internationale",
      "Direction de gestion des Services d’intervention",
    ],
    answer: "Direction générale de la Sécurité intérieure",
    explanation: "DGSI = Direction générale de la Sécurité intérieure.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "La Préfecture de police (PP) concerne principalement :",
    options: [
      "Paris et la petite couronne (92/93/94) selon les compétences",
      "Toute la France métropolitaine",
      "Uniquement l’outre-mer",
    ],
    answer: "Paris et la petite couronne (92/93/94) selon les compétences",
    explanation:
        "PP : Paris + compétences étendues incluant 92/93/94 sur certains volets.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Parmi ces structures, laquelle fait partie des directions/services rattachés à la DGPN ?",
    options: ["RAID", "DGSI", "PP"],
    answer: "RAID",
    explanation:
        "Dans ton organisation, le RAID est listé parmi les directions/services rattachés à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Parmi ces structures, laquelle fait partie des services mutualisés (avec la Gendarmerie nationale) ?",
    options: ["DCIS", "IGPN", "SDLP"],
    answer: "DCIS",
    explanation:
        "DCIS est indiquée comme service mutualisé Police/Gendarmerie.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Parmi ces structures, laquelle fait partie des services mutualisés (avec la Gendarmerie nationale) ?",
    options: ["ANFSI", "DCCRS", "DNRT"],
    answer: "ANFSI",
    explanation:
        "ANFSI (numérique FSI) est indiquée comme mutualisée Police/Gendarmerie.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Parmi ces structures, laquelle fait partie des services mutualisés (avec la Gendarmerie nationale) ?",
    options: ["SSMSI", "SNPS", "DNPJ"],
    answer: "SSMSI",
    explanation:
        "SSMSI est listé comme service mutualisé avec la Gendarmerie nationale.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Parmi ces structures, laquelle est présentée comme un service national rattaché à la DGPN ?",
    options: ["SNEAS", "DGSI", "PP"],
    answer: "SNEAS",
    explanation:
        "SNEAS est listé dans les services nationaux rattachés à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Parmi ces structures, laquelle est présentée comme un service national rattaché à la DGPN ?",
    options: ["SNEAV", "DGSI", "PP"],
    answer: "SNEAV",
    explanation:
        "SNEAV est listé dans les services nationaux rattachés à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Quel ensemble correspond à la “direction de gestion et de soutien” dans ton schéma DGPN ?",
    options: ["DRHFS", "DNPJ", "DCCRS"],
    answer: "DRHFS",
    explanation:
        "Dans ta page Organisation, la DRHFS est rangée dans la direction de gestion et de soutien.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Quel ensemble correspond à une direction/service “actif” rattaché à la DGPN ?",
    options: ["DNSP", "SSMSI", "SNEAV"],
    answer: "DNSP",
    explanation:
        "DNSP est listée parmi les directions/services actifs rattachés à la DGPN.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Quel ensemble correspond à une direction/service “actif” rattaché à la DGPN ?",
    options: ["DNPAF", "SNEAS", "SSMSI"],
    answer: "DNPAF",
    explanation:
        "DNPAF est listée parmi les directions/services actifs rattachés à la DGPN.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Quel ensemble correspond à une direction/service “actif” rattaché à la DGPN ?",
    options: ["DNPJ", "ANFSI", "SNEAV"],
    answer: "DNPJ",
    explanation:
        "DNPJ est une direction active (filière PJ) rattachée à la DGPN.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Quel ensemble correspond à une direction/service “actif” rattaché à la DGPN ?",
    options: ["DCCRS", "SSMSI", "SNEAS"],
    answer: "DCCRS",
    explanation:
        "DCCRS (CRS) est listée parmi les directions/services actifs rattachés à la DGPN.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Quel ensemble correspond à une direction/service “actif” rattaché à la DGPN ?",
    options: ["DNRT", "SSMSI", "SNEAV"],
    answer: "DNRT",
    explanation:
        "DNRT (Renseignement territorial) est listée parmi les directions/services actifs rattachés à la DGPN.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Quel ensemble correspond à une direction/service “actif” rattaché à la DGPN ?",
    options: ["ADP", "SSMSI", "SNEAV"],
    answer: "ADP",
    explanation:
        "ADP (Académie de Police) est listée parmi les directions/services actifs rattachés à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Quel ensemble correspond à une direction/service “actif” rattaché à la DGPN ?",
    options: ["SDLP", "SSMSI", "SNEAS"],
    answer: "SDLP",
    explanation:
        "SDLP (Service de la protection) est listé parmi les directions/services actifs rattachés à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Quel ensemble correspond à une direction/service “actif” rattaché à la DGPN ?",
    options: ["SNPS", "SSMSI", "SNEAV"],
    answer: "SNPS",
    explanation:
        "SNPS (Police scientifique) est listé parmi les directions/services actifs rattachés à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Quel service est explicitement mentionné comme “service spécialisé rattaché” à la DGPN ?",
    options: ["SICoP", "DNPAF", "IGPN"],
    answer: "SICoP",
    explanation: "SICoP figure dans ton NOTA “services spécialisés rattachés”.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Quel service est explicitement mentionné comme “service spécialisé rattaché” à la DGPN ?",
    options: ["DAV", "DNRT", "SSMSI"],
    answer: "DAV",
    explanation:
        "DAV (Délégation aux victimes) figure dans ton NOTA “services spécialisés rattachés”.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Quel service est explicitement mentionné comme “service spécialisé rattaché” à la DGPN ?",
    options: ["SHPN", "SDLP", "SNPS"],
    answer: "SHPN",
    explanation:
        "SHPN (Service historique de la Police nationale) figure dans ton NOTA “services spécialisés rattachés”.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question:
        "Quel service est explicitement mentionné comme “service spécialisé rattaché” à la DGPN ?",
    options: ["ANDV", "ANFSI", "DCIS"],
    answer: "ANDV",
    explanation: "ANDV figure dans ton NOTA “services spécialisés rattachés”.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — DRHFS",
    question: "La DRHFS prépare notamment :",
    options: [
      "Les textes législatifs et réglementaires intéressant les différentes catégories de personnels",
      "Les décisions de justice pénales",
      "Les arrêtés municipaux de circulation",
    ],
    answer:
        "Les textes législatifs et réglementaires intéressant les différentes catégories de personnels",
    explanation:
        "Dans ton texte DRHFS : préparation des textes concernant les personnels.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DRHFS",
    question: "La DRHFS est associée au suivi de :",
    options: [
      "La protection fonctionnelle au profit des agents",
      "La politique de délivrance des visas",
      "La doctrine de maintien de l’ordre",
    ],
    answer: "La protection fonctionnelle au profit des agents",
    explanation: "Ton texte DRHFS cite la protection fonctionnelle.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DRHFS",
    question: "La DRHFS participe notamment au suivi :",
    options: [
      "Des affaires juridiques et des contentieux concernant la Police nationale",
      "Des décisions du Conseil constitutionnel",
      "Des procédures disciplinaires des élèves",
    ],
    answer:
        "Des affaires juridiques et des contentieux concernant la Police nationale",
    explanation:
        "Ton texte DRHFS mentionne le suivi des affaires juridiques/contentieux.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — IGPN",
    question: "L’IGPN peut conduire :",
    options: [
      "Des audits internes",
      "Des éloignements d’étrangers",
      "Des délivrances de titres administratifs",
    ],
    answer: "Des audits internes",
    explanation: "Ton texte IGPN : inspections, évaluations, audits internes.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — IGPN",
    question: "Parmi les missions de l’IGPN, on retrouve :",
    options: [
      "Maîtrise des risques",
      "Gestion des CRA",
      "Pilotage des frontières",
    ],
    answer: "Maîtrise des risques",
    explanation:
        "IGPN : analyse, conseil et maîtrise des risques (ton contenu).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPJ",
    question: "La DNPJ définit des objectifs et anime l’action :",
    options: [
      "Des services de police exerçant une mission de PJ relevant de sa filière",
      "Des services de délivrance de titres à Paris",
      "Des services statistiques européens",
    ],
    answer:
        "Des services de police exerçant une mission de PJ relevant de sa filière",
    explanation:
        "Ton texte DNPJ : objectifs + animation des services PJ de sa filière.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DNSP",
    question: "La DNSP favorise :",
    options: [
      "Le lien entre la police et la population",
      "La coopération policière internationale bilatérale",
      "La gestion des titres de séjour",
    ],
    answer: "Le lien entre la police et la population",
    explanation: "Ton texte DNSP : favoriser le lien police-population.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNSP",
    question: "La DNSP contribue notamment :",
    options: [
      "À la protection des personnes, des biens et des institutions",
      "Au recrutement des contractuels DGSI",
      "À la gestion des CRA",
    ],
    answer: "À la protection des personnes, des biens et des institutions",
    explanation:
        "Ton texte DNSP cite explicitement protection personnes/biens/institutions.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPAF",
    question: "La DNPAF organise et coordonne :",
    options: [
      "Le recrutement et le déploiement du contingent français mis à disposition de l’agence européenne de garde-frontières et garde-côtes",
      "La formation initiale des commissaires",
      "Les audits internes des services",
    ],
    answer:
        "Le recrutement et le déploiement du contingent français mis à disposition de l’agence européenne de garde-frontières et garde-côtes",
    explanation:
        "Ton texte DNPAF : point de contact national + contingent pour l’agence européenne.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPAF",
    question: "La DNPAF participe à l’élaboration des normes relatives :",
    options: [
      "À la sûreté des moyens et infrastructures de transports internationaux",
      "Aux concours d’accès à l’ENSP",
      "Aux procédures disciplinaires internes",
    ],
    answer:
        "À la sûreté des moyens et infrastructures de transports internationaux",
    explanation:
        "Ton texte DNPAF : sûreté des moyens/infrastructures de transport internationaux.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPAF",
    question: "La DNPAF assure la coordination :",
    options: [
      "Des moyens aériens et maritimes de la Police nationale",
      "Des moyens statistiques ministériels",
      "Des moyens de protection rapprochée",
    ],
    answer: "Des moyens aériens et maritimes de la Police nationale",
    explanation:
        "Ton texte DNPAF : doctrine + coordination moyens aériens/maritimes PN.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNRT",
    question: "Le renseignement territorial couvre notamment des domaines :",
    options: [
      "Institutionnel, économique et social",
      "Uniquement judiciaire",
      "Uniquement maritime",
    ],
    answer: "Institutionnel, économique et social",
    explanation:
        "Ton texte DNRT : institutionnel, économique, social + ordre public.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DCCRS",
    question: "La DCCRS est spécialisée :",
    options: [
      "Dans le maintien et le rétablissement de l’ordre public sur l’ensemble du territoire",
      "Dans les enquêtes administratives de sécurité",
      "Dans la production de statistiques publiques",
    ],
    answer:
        "Dans le maintien et le rétablissement de l’ordre public sur l’ensemble du territoire",
    explanation: "Ton texte DCCRS : maintien/rétablissement de l’ordre public.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — SDLP",
    question: "Le SDLP assure :",
    options: [
      "Des missions de protection rapprochée et d’accompagnement de sécurité",
      "La politique nationale de police scientifique",
      "Le contrôle et la surveillance des frontières",
    ],
    answer:
        "Des missions de protection rapprochée et d’accompagnement de sécurité",
    explanation: "SDLP : protection rapprochée (ton texte).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — SNPS",
    question: "Le SNPS peut contribuer à :",
    options: [
      "La représentation de la Police nationale en police scientifique",
      "La délivrance des titres administratifs",
      "La coordination des unités CRS",
    ],
    answer: "La représentation de la Police nationale en police scientifique",
    explanation:
        "Ton texte SNPS : développe/promeut méthodes et assure représentation de la PN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — RAID",
    question: "Le RAID peut être sollicité :",
    options: [
      "Lors de troubles graves à l’ordre public nécessitant des techniques et moyens spécifiques",
      "Pour gérer les carrières des fonctionnaires",
      "Pour produire des statistiques publiques",
    ],
    answer:
        "Lors de troubles graves à l’ordre public nécessitant des techniques et moyens spécifiques",
    explanation:
        "Ton texte RAID : troubles graves à l’OP nécessitant techniques/moyens spécifiques.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — RAID",
    question: "Le RAID peut prêter assistance :",
    options: [
      "Aux services de police",
      "Uniquement aux mairies",
      "Uniquement aux tribunaux",
    ],
    answer: "Aux services de police",
    explanation: "Ton texte : RAID prête assistance aux services de police.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — ANFSI",
    question: "L’ANFSI pilote notamment :",
    options: [
      "Les infrastructures, terminaux et équipements périphériques pour les forces de sécurité",
      "Les CRA au niveau national",
      "Les unités mobiles d’ordre public",
    ],
    answer:
        "Les infrastructures, terminaux et équipements périphériques pour les forces de sécurité",
    explanation: "Ton texte ANFSI : infrastructures + terminaux + équipements.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — ANFSI",
    question: "L’ANFSI assure, lorsque pertinent :",
    options: [
      "La convergence des outils numériques Police/Gendarmerie",
      "La fusion des juridictions administratives",
      "La gestion des titres administratifs à Paris",
    ],
    answer: "La convergence des outils numériques Police/Gendarmerie",
    explanation:
        "Ton texte : convergence des outils numériques des deux forces.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — DCIS",
    question: "La DCIS contribue à :",
    options: [
      "La continuité entre sécurité intérieure et sécurité extérieure",
      "La gestion opérationnelle des CRA",
      "Le maintien de l’ordre par unités mobiles",
    ],
    answer: "La continuité entre sécurité intérieure et sécurité extérieure",
    explanation: "Ton texte DCIS : continuité sécurité intérieure/extérieure.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DCIS",
    question: "La DCIS dirige :",
    options: [
      "Le réseau des attachés de sécurité intérieure",
      "Le réseau des commissariats municipaux",
      "Le réseau des centres de rétention administrative",
    ],
    answer: "Le réseau des attachés de sécurité intérieure",
    explanation: "Ton texte DCIS : dirige le réseau des ASI (attachés).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — SSMSI",
    question: "Le SSMSI contribue :",
    options: [
      "À l’étude des évolutions statistiques de l’ensemble du processus pénal",
      "À la protection rapprochée",
      "Au contrôle des frontières",
    ],
    answer:
        "À l’étude des évolutions statistiques de l’ensemble du processus pénal",
    explanation:
        "Ton texte SSMSI : faits constatés, décisions, exécution, sanctions, récidive.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — SSMSI",
    question: "Le SSMSI est aussi :",
    options: [
      "L’autorité nationale pour la production des statistiques européennes dans les domaines de la sécurité intérieure",
      "Le service national des enquêtes administratives",
      "La direction des unités mobiles",
    ],
    answer:
        "L’autorité nationale pour la production des statistiques européennes dans les domaines de la sécurité intérieure",
    explanation:
        "Ton texte SSMSI : autorité nationale pour la production des statistiques européennes.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "Dans l’organisation de la PP, la DOPC correspond à :",
    options: [
      "La Direction de l’Ordre public et de la Circulation",
      "La Direction des Opérations de Police Centrale",
      "La Direction de l’Organisation des Procédures Civiles",
    ],
    answer: "La Direction de l’Ordre public et de la Circulation",
    explanation:
        "Dans ta page PP : DOPC = Direction de l’Ordre public et de la Circulation.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "Parmi les services administratifs de la PP, on peut trouver :",
    options: [
      "Direction des usagers et des polices administratives",
      "Direction nationale de la Police judiciaire",
      "Direction nationale de la Police aux frontières",
    ],
    answer: "Direction des usagers et des polices administratives",
    explanation:
        "Ta page PP liste cette direction comme service administratif.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "Parmi les services actifs de la PP, on peut trouver :",
    options: [
      "Direction de la police judiciaire",
      "Service national de Police scientifique",
      "Service statistique ministériel",
    ],
    answer: "Direction de la police judiciaire",
    explanation: "Ta page PP : direction PJ fait partie des services actifs.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "Parmi les services actifs de la PP, on peut trouver :",
    options: [
      "Direction du renseignement",
      "Direction des ressources humaines, des finances et des soutiens",
      "Académie de Police",
    ],
    answer: "Direction du renseignement",
    explanation:
        "Ta page PP : direction du renseignement fait partie des services actifs.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question:
        "Parmi les services rattachés au cabinet du préfet de police, on retrouve :",
    options: ["Le laboratoire central", "La DNPAF", "La DNRT"],
    answer: "Le laboratoire central",
    explanation: "Ta page PP : laboratoire central rattaché au cabinet.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question:
        "Parmi les services rattachés au cabinet du préfet de police, on retrouve :",
    options: ["Le laboratoire de toxicologie", "La DNPJ", "L’IGPN"],
    answer: "Le laboratoire de toxicologie",
    explanation: "Ta page PP : laboratoire de toxicologie rattaché au cabinet.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "La Brigade des sapeurs-pompiers de Paris est :",
    options: [
      "Une unité militaire à la disposition du préfet de police",
      "Une unité civile sous l’autorité du maire",
      "Une unité privée sous contrat",
    ],
    answer: "Une unité militaire à la disposition du préfet de police",
    explanation:
        "Ta page PP : BSPP = unité militaire à disposition du préfet de police.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Organisation PN — DGPN",
    question: "La DGPN a pour rôle principal de :",
    options: [
      "Diriger et coordonner les directions et services rattachés",
      "Délivrer des titres administratifs à Paris",
      "Contrôler les frontières aériennes",
    ],
    answer: "Diriger et coordonner les directions et services rattachés",
    explanation:
        "La DGPN pilote les directions et services de la Police nationale relevant de son périmètre.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGSI",
    question: "La mission centrale de la DGSI est de :",
    options: [
      "Rechercher, centraliser et exploiter le renseignement intéressant la sécurité nationale",
      "Assurer l’ordre public par unités mobiles",
      "Produire la statistique publique de sécurité intérieure",
    ],
    answer:
        "Rechercher, centraliser et exploiter le renseignement intéressant la sécurité nationale",
    explanation:
        "DGSI : renseignement lié à la sécurité nationale / intérêts fondamentaux.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGSI",
    question: "La DGSI peut concourir :",
    options: [
      "Aux missions de police judiciaire dans ses domaines de compétence",
      "Uniquement aux missions de circulation",
      "Uniquement à la gestion des carrières",
    ],
    answer: "Aux missions de police judiciaire dans ses domaines de compétence",
    explanation:
        "DGSI : concourt à la PJ sur l’ensemble du territoire, dans ses domaines.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGSI",
    question: "La DGSI assure notamment :",
    options: [
      "La prévention et la répression de toute forme d’ingérence étrangère",
      "La gestion des CRA",
      "La direction des CRS",
    ],
    answer:
        "La prévention et la répression de toute forme d’ingérence étrangère",
    explanation:
        "L’ingérence étrangère fait partie des missions citées pour la DGSI.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGSI",
    question: "L’organisation de la DGSI comprend notamment :",
    options: [
      "Direction du renseignement et des opérations, direction technique, administration générale, inspection",
      "DNSP, DNPAF, DNPJ, DCCRS",
      "SSMSI, DCIS, ANFSI, SNEAV",
    ],
    answer:
        "Direction du renseignement et des opérations, direction technique, administration générale, inspection",
    explanation:
        "Ta page DGSI liste ces blocs comme structure de direction et services.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGSI",
    question: "La DGSI contribue à la surveillance des communications :",
    options: [
      "Électroniques et radioélectriques, pour les besoins de ses missions",
      "Uniquement postales",
      "Uniquement administratives",
    ],
    answer:
        "Électroniques et radioélectriques, pour les besoins de ses missions",
    explanation:
        "Surveillance technique : communications électroniques et radioélectriques.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "À Paris, le préfet de police est :",
    options: [
      "Un haut fonctionnaire nommé en Conseil des ministres",
      "Un magistrat élu par les fonctionnaires",
      "Un commandant de police élu par la population",
    ],
    answer: "Un haut fonctionnaire nommé en Conseil des ministres",
    explanation:
        "La PP est dirigée par un préfet de police nommé en Conseil des ministres.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "Parmi les attributions de la PP, on retrouve :",
    options: [
      "Assurer la sécurité des personnes et des biens",
      "Diriger la police aux frontières au niveau national",
      "Conduire l’audit interne des services DGPN",
    ],
    answer: "Assurer la sécurité des personnes et des biens",
    explanation:
        "La PP assure des missions de sécurité et d’ordre public dans son ressort.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "Parmi les attributions de la PP, on retrouve :",
    options: [
      "Assurer la sécurité civile",
      "Centraliser les flux migratoires nationaux",
      "Définir la politique nationale PTS",
    ],
    answer: "Assurer la sécurité civile",
    explanation: "La PP exerce également des missions de sécurité civile.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "Parmi les attributions de la PP, on retrouve :",
    options: [
      "Assurer la circulation",
      "Assurer la coopération internationale de sécurité",
      "Assurer la formation initiale de tous les élèves",
    ],
    answer: "Assurer la circulation",
    explanation:
        "La PP a des compétences fortes en circulation (notamment via la DOPC).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "Parmi les attributions de la PP, on retrouve :",
    options: [
      "Délivrer des titres administratifs",
      "Commander les unités CRS",
      "Réaliser les expertises scientifiques nationales",
    ],
    answer: "Délivrer des titres administratifs",
    explanation: "La PP délivre des titres administratifs dans son périmètre.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN — Directions",
    question: "La DRHFS signifie :",
    options: [
      "Direction des ressources humaines, des finances et des soutiens",
      "Direction du renseignement, de l’hébergement et de la formation",
      "Direction des relations humaines et des forces spéciales",
    ],
    answer: "Direction des ressources humaines, des finances et des soutiens",
    explanation:
        "DRHFS : RH + finances + soutiens de la Police nationale (dans ton contenu).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DRHFS",
    question: "La DRHFS assure notamment :",
    options: [
      "L’organisation des carrières et le développement des parcours",
      "Le contrôle des frontières",
      "La statistique publique",
    ],
    answer: "L’organisation des carrières et le développement des parcours",
    explanation: "DRHFS : gestion RH et carrières.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DRHFS",
    question: "La DRHFS participe :",
    options: [
      "À l’élaboration et à l’exécution du budget concernant la Police nationale",
      "À la gestion opérationnelle des CRA",
      "À la direction de la PJ parisienne",
    ],
    answer:
        "À l’élaboration et à l’exécution du budget concernant la Police nationale",
    explanation:
        "DRHFS : budget, répartition des moyens, suivi de l’utilisation.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DRHFS",
    question: "Concernant les contractuels, la DRHFS :",
    options: [
      "Recrute pour les services PN, sauf DGSI qui recrute pour son propre compte",
      "Recrute uniquement pour la DGSI",
      "Ne recrute pas de contractuels",
    ],
    answer:
        "Recrute pour les services PN, sauf DGSI qui recrute pour son propre compte",
    explanation:
        "Exception explicitée dans ton contenu : DGSI recrute ses contractuels pour son compte propre.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — DRHFS",
    question: "La DRHFS conduit notamment :",
    options: [
      "La politique ministérielle d’action sociale du logement et de l’enfance",
      "La lutte contre l’immigration irrégulière",
      "La protection rapprochée",
    ],
    answer:
        "La politique ministérielle d’action sociale du logement et de l’enfance",
    explanation: "Action sociale : logement + enfance (ministère).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DRHFS",
    question: "La DRHFS est chargée :",
    options: [
      "De la réglementation liée au temps de travail",
      "De la surveillance technique des communications",
      "Du maintien de l’ordre via CRS",
    ],
    answer: "De la réglementation liée au temps de travail",
    explanation:
        "Temps de travail : élément de réglementation cité dans ton texte.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — IGPN",
    question: "L’IGPN signifie :",
    options: [
      "Inspection générale de la Police nationale",
      "Inspection générale de la Protection nationale",
      "Inspection générale des Procédures nationales",
    ],
    answer: "Inspection générale de la Police nationale",
    explanation: "IGPN = Inspection générale de la Police nationale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — IGPN",
    question: "L’IGPN a une compétence :",
    options: [
      "Nationale",
      "Uniquement parisienne",
      "Uniquement départementale",
    ],
    answer: "Nationale",
    explanation: "Dans ton contenu : l’IGPN a une compétence nationale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — IGPN",
    question: "L’IGPN exerce notamment :",
    options: [
      "Des missions de contrôle, d’enquête, d’audit et d’évaluation",
      "Le contrôle des frontières",
      "La formation initiale des élèves",
    ],
    answer: "Des missions de contrôle, d’enquête, d’audit et d’évaluation",
    explanation:
        "IGPN : contrôle + enquêtes (admin/jud) + audit/évaluation/risques.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — IGPN",
    question: "L’IGPN peut exercer une mission de contrôle sur :",
    options: [
      "La DGPN, la PP et la DGSI",
      "Uniquement la DGPN",
      "Uniquement la DGSI",
    ],
    answer: "La DGPN, la PP et la DGSI",
    explanation: "Ton texte indique un périmètre large (DGPN, PP, DGSI).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPJ",
    question: "La DNPJ signifie :",
    options: [
      "Direction nationale de la Police judiciaire",
      "Direction nationale de la Police de jeunesse",
      "Direction nationale de la Protection judiciaire",
    ],
    answer: "Direction nationale de la Police judiciaire",
    explanation: "DNPJ = Direction nationale de la Police judiciaire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPJ",
    question: "La DNPJ concourt principalement :",
    options: [
      "Aux missions de police judiciaire sur l’ensemble du territoire national",
      "Aux missions de circulation à Paris",
      "À la statistique publique nationale",
    ],
    answer:
        "Aux missions de police judiciaire sur l’ensemble du territoire national",
    explanation: "DNPJ : PJ sur tout le territoire national.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPJ",
    question: "La DNPJ contribue à la prévention et la répression :",
    options: [
      "De la criminalité et de la délinquance, y compris organisée/transnationale",
      "Uniquement des contraventions routières",
      "Uniquement des nuisances sonores",
    ],
    answer:
        "De la criminalité et de la délinquance, y compris organisée/transnationale",
    explanation:
        "Ton contenu mentionne explicitement la criminalité organisée et transnationale.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DNSP",
    question: "La DNSP signifie :",
    options: [
      "Direction nationale de la Sécurité publique",
      "Direction nationale de la Sécurité privée",
      "Direction nationale du Service pénitentiaire",
    ],
    answer: "Direction nationale de la Sécurité publique",
    explanation: "DNSP = Direction nationale de la Sécurité publique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNSP",
    question: "La DNSP anime l’action des services de police :",
    options: [
      "Dans les communes où la police est étatisée, en matière de sécurité et d’ordre publics",
      "Uniquement dans les communes rurales",
      "Uniquement aux frontières",
    ],
    answer:
        "Dans les communes où la police est étatisée, en matière de sécurité et d’ordre publics",
    explanation:
        "DNSP : sécurité/ordre public dans les communes à police étatisée (selon ton texte).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DNSP",
    question: "La DNSP veille particulièrement :",
    options: [
      "À la police-secours et à l’accueil du public et des victimes",
      "Au commandement des CRS",
      "À l’organisation des expulsions",
    ],
    answer: "À la police-secours et à l’accueil du public et des victimes",
    explanation:
        "Dans ton contenu : police-secours + accueil public/victimes + lien population.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNSP",
    question:
        "Au titre de la protection de l’espace public, la DNSP est en charge :",
    options: [
      "De la sécurité routière et participe à la sécurisation des transports en commun",
      "De la police scientifique nationale",
      "De la coopération internationale",
    ],
    answer:
        "De la sécurité routière et participe à la sécurisation des transports en commun",
    explanation: "DNSP : sécurité routière + transports (dans ton texte).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPAF",
    question: "La DNPAF signifie :",
    options: [
      "Direction nationale de la Police aux frontières",
      "Direction nationale de la Protection des Agents de France",
      "Direction nationale de la Police des affaires financières",
    ],
    answer: "Direction nationale de la Police aux frontières",
    explanation: "DNPAF = Direction nationale de la Police aux frontières.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPAF",
    question: "La DNPAF définit les objectifs et anime l’action :",
    options: [
      "Des services chargés du contrôle et de la surveillance des frontières",
      "Des services de police scientifique",
      "Des services d’audit interne",
    ],
    answer:
        "Des services chargés du contrôle et de la surveillance des frontières",
    explanation:
        "PAF : contrôle/surveillance frontières terrestres, maritimes et aériennes.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPAF",
    question: "La DNPAF est chef de file (PN) en matière :",
    options: [
      "De traitement procédural des étrangers en situation irrégulière",
      "D’enquêtes administratives de sécurité",
      "De contrôle interne des services",
    ],
    answer: "De traitement procédural des étrangers en situation irrégulière",
    explanation:
        "Ton texte : chef de file pour la PN en matière de traitement procédural ESI.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPAF",
    question: "La DNPAF centralise les informations relatives :",
    options: [
      "Aux flux et risques migratoires",
      "Aux carrières des fonctionnaires",
      "Aux plaintes déontologiques",
    ],
    answer: "Aux flux et risques migratoires",
    explanation: "PAF : centralisation/analyse des flux/risques migratoires.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPAF",
    question: "La DNPAF assure notamment :",
    options: [
      "La mise en œuvre et le suivi de la chaîne de traitement de l’éloignement et la gestion des CRA",
      "La production des statistiques européennes",
      "La formation initiale des commissaires",
    ],
    answer:
        "La mise en œuvre et le suivi de la chaîne de traitement de l’éloignement et la gestion des CRA",
    explanation:
        "PAF : éloignement + gestion opérationnelle des centres de rétention administrative.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNRT",
    question: "La DNRT signifie :",
    options: [
      "Direction nationale du Renseignement territorial",
      "Direction nationale de la Recherche technique",
      "Direction nationale des Renseignements transnationaux",
    ],
    answer: "Direction nationale du Renseignement territorial",
    explanation: "DNRT = Direction nationale du Renseignement territorial.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNRT",
    question: "Le renseignement territorial a pour finalité principale :",
    options: [
      "Informer le Gouvernement et les représentants de l’État",
      "Délivrer des titres administratifs",
      "Assurer la protection rapprochée",
    ],
    answer: "Informer le Gouvernement et les représentants de l’État",
    explanation:
        "RT : renseignement destiné à informer l’État (institutionnel, économique, social, ordre public).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DNRT",
    question: "La DNRT contribue à la prévention du terrorisme :",
    options: [
      "En lien avec les services compétents",
      "Uniquement en assurant la circulation",
      "Uniquement via la police scientifique",
    ],
    answer: "En lien avec les services compétents",
    explanation:
        "Ton texte : prévention du terrorisme en coordination avec les services compétents.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DCCRS",
    question: "La DCCRS signifie :",
    options: [
      "Direction centrale des Compagnies républicaines de sécurité",
      "Direction centrale de la Criminalité routière et sociale",
      "Direction centrale du Contrôle de la sécurité",
    ],
    answer: "Direction centrale des Compagnies républicaines de sécurité",
    explanation: "DCCRS : direction centrale des CRS.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — CRS",
    question: "Les CRS sont des unités mobiles spécialisées :",
    options: [
      "Dans le maintien et le rétablissement de l’ordre public",
      "Dans la délivrance des titres administratifs",
      "Dans la statistique publique",
    ],
    answer: "Dans le maintien et le rétablissement de l’ordre public",
    explanation: "CRS : unités mobiles dédiées au MO/ROP.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — CRS",
    question: "Les CRS peuvent être engagées :",
    options: [
      "Pour porter aide et assistance aux populations en cas de sinistre grave",
      "Pour recruter les contractuels de la DGSI",
      "Pour traiter les flux migratoires",
    ],
    answer:
        "Pour porter aide et assistance aux populations en cas de sinistre grave",
    explanation:
        "Ton contenu : assistance aux populations en cas de sinistre/calamité.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — CRS",
    question: "Les CRS peuvent être employées à des gardes statiques :",
    options: [
      "Sur ordre du ministre chargé de l’Intérieur, et jamais de façon permanente",
      "Sur ordre du maire, de façon permanente",
      "Sur ordre du procureur, de façon permanente",
    ],
    answer:
        "Sur ordre du ministre chargé de l’Intérieur, et jamais de façon permanente",
    explanation:
        "Principe rappelé dans ton texte : garde statique seulement sur ordre ministériel et non permanente.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — ADP",
    question: "L’ADP correspond à :",
    options: [
      "L’Académie de Police",
      "L’Agence des Dépenses Publiques",
      "L’Autorité de Discipline Policière",
    ],
    answer: "L’Académie de Police",
    explanation: "ADP : direction chargée du recrutement et de la formation.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — ADP",
    question: "L’Académie de Police est responsable :",
    options: [
      "De la formation professionnelle initiale et tout au long de la vie",
      "Du contrôle des frontières maritimes",
      "Des enquêtes administratives de sécurité",
    ],
    answer:
        "De la formation professionnelle initiale et tout au long de la vie",
    explanation:
        "Ton texte : formation initiale + formation tout au long de la vie.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — ADP",
    question: "L’Académie de Police est également chargée :",
    options: [
      "Des études et de la recherche de la Police nationale",
      "De la gestion des CRA",
      "Du commandement des CRS",
    ],
    answer: "Des études et de la recherche de la Police nationale",
    explanation: "Ton contenu le mentionne explicitement.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — SDLP",
    question: "Le SDLP est :",
    options: [
      "Le Service de la protection",
      "Le Service du renseignement territorial",
      "Le Service statistique",
    ],
    answer: "Le Service de la protection",
    explanation:
        "SDLP : protection rapprochée, sécurisation d’événements, etc.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — SDLP",
    question: "Le SDLP met en œuvre des mesures de sécurité notamment pour :",
    options: [
      "Les hautes personnalités et certains événements",
      "Le traitement procédural des étrangers",
      "La statistique publique",
    ],
    answer: "Les hautes personnalités et certains événements",
    explanation:
        "Ton texte : sécurité des visites de hautes personnalités et événements.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — SNPS",
    question: "Le SNPS signifie :",
    options: [
      "Service national de Police scientifique",
      "Service national de Protection sociale",
      "Service national de Police sportive",
    ],
    answer: "Service national de Police scientifique",
    explanation: "SNPS : Police scientifique (politique et coordination).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — SNPS",
    question: "Le SNPS a pour mission de :",
    options: [
      "Définir et coordonner la politique de police scientifique sur le territoire national",
      "Définir la doctrine MO des CRS",
      "Gérer la délivrance des titres administratifs",
    ],
    answer:
        "Définir et coordonner la politique de police scientifique sur le territoire national",
    explanation: "SNPS : coordination nationale de la police scientifique.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — SNPS",
    question: "Le SNPS peut réaliser :",
    options: [
      "Des examens, constatations, expertises et analyses demandés par l’autorité judiciaire",
      "Des décisions de justice",
      "Des sanctions disciplinaires",
    ],
    answer:
        "Des examens, constatations, expertises et analyses demandés par l’autorité judiciaire",
    explanation:
        "Ton texte : examens/constatations/expertises/analyses à la demande judiciaire ou des enquêteurs.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — RAID",
    question: "RAID signifie :",
    options: [
      "Recherche, Assistance, Intervention et Dissuasion",
      "Renseignement, Action, Intervention et Défense",
      "Réaction, Appui, Investigation et Droit",
    ],
    answer: "Recherche, Assistance, Intervention et Dissuasion",
    explanation: "RAID : unité d’intervention nationale (sigle).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — RAID",
    question: "Le RAID intervient notamment :",
    options: [
      "Dans la prévention et la répression de la criminalité organisée et du terrorisme",
      "Dans la délivrance des titres administratifs",
      "Dans l’action sociale logement/enfance",
    ],
    answer:
        "Dans la prévention et la répression de la criminalité organisée et du terrorisme",
    explanation:
        "Ton contenu : intervention sur criminalité organisée + terrorisme.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — ANFSI",
    question: "L’ANFSI signifie :",
    options: [
      "Agence du numérique des forces de sécurité intérieure",
      "Agence nationale de formation en sécurité intérieure",
      "Autorité nationale des fichiers de sécurité intérieure",
    ],
    answer: "Agence du numérique des forces de sécurité intérieure",
    explanation: "ANFSI : numérique / SI / équipements / sécurité.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — ANFSI",
    question: "L’ANFSI est chargée :",
    options: [
      "Du développement, de la mise en œuvre et de la sécurité des systèmes d’information",
      "De la gestion des CRA",
      "De l’audit interne IGPN",
    ],
    answer:
        "Du développement, de la mise en œuvre et de la sécurité des systèmes d’information",
    explanation:
        "Ton texte : SI, équipements numériques et sécurité des outils au profit des FSI.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DCIS",
    question: "La DCIS signifie :",
    options: [
      "Direction de la coopération internationale de sécurité",
      "Direction centrale des interventions de sécurité",
      "Direction du contrôle interne de sécurité",
    ],
    answer: "Direction de la coopération internationale de sécurité",
    explanation: "DCIS : coopération internationale Police/Gendarmerie.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DCIS",
    question: "La DCIS a notamment pour rôle :",
    options: [
      "De coordonner et faciliter les coopérations opérationnelles et institutionnelles",
      "De produire la statistique publique",
      "D’assurer l’éloignement et la gestion des CRA",
    ],
    answer:
        "De coordonner et faciliter les coopérations opérationnelles et institutionnelles",
    explanation:
        "Ton contenu : coordination coopérations Police/Gendarmerie (opérationnelles/techniques/institutionnelles).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — SSMSI",
    question: "Le SSMSI est :",
    options: [
      "Le Service statistique ministériel de la sécurité intérieure",
      "Le Service spécialisé de maintien de la sécurité intérieure",
      "Le Service social ministériel de sécurité intérieure",
    ],
    answer: "Le Service statistique ministériel de la sécurité intérieure",
    explanation: "SSMSI : statistique publique en sécurité intérieure.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — SSMSI",
    question: "Le SSMSI produit :",
    options: [
      "La statistique publique dans les domaines de la sécurité intérieure",
      "La doctrine nationale PAF",
      "La formation des personnels PTS",
    ],
    answer:
        "La statistique publique dans les domaines de la sécurité intérieure",
    explanation:
        "Ton texte : SSMSI élabore/diffuse/publie l’information statistique en sécurité intérieure.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — SNEAS",
    question: "Le SNEAS signifie :",
    options: [
      "Service national des enquêtes administratives de sécurité",
      "Service national des enquêtes anti-stupéfiants",
      "Service national des enquêtes d’assistance sociale",
    ],
    answer: "Service national des enquêtes administratives de sécurité",
    explanation:
        "SNEAS : enquêtes administratives de sécurité (compatibilité comportement/autorisation).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — SNEAV",
    question: "Le SNEAV signifie :",
    options: [
      "Service national des enquêtes d’autorisation de voyage",
      "Service national des enquêtes d’autorisation de voie publique",
      "Service national des enquêtes anti-vol",
    ],
    answer: "Service national des enquêtes d’autorisation de voyage",
    explanation:
        "SNEAV : examine certaines demandes d’autorisation de voyage selon ton contenu.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Distinctions",
    question:
        "Quelle structure est la plus directement liée au renseignement de sécurité nationale ?",
    options: ["DGSI", "DNSP", "SNPS"],
    answer: "DGSI",
    explanation:
        "DGSI : renseignement sécurité nationale / intérêts fondamentaux.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Distinctions",
    question: "Quelle direction est la plus directement liée aux frontières ?",
    options: ["DNPAF", "DNPJ", "IGPN"],
    answer: "DNPAF",
    explanation:
        "DNPAF : contrôle/surveillance des frontières et immigration irrégulière.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Distinctions",
    question:
        "Quelle direction est la plus directement liée au maintien de l’ordre via unités mobiles ?",
    options: ["DCCRS", "DRHFS", "SSMSI"],
    answer: "DCCRS",
    explanation: "CRS : maintien et rétablissement de l’ordre public.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Distinctions",
    question:
        "Quelle structure est la plus directement liée au contrôle/audit interne des services ?",
    options: ["IGPN", "DNRT", "SDLP"],
    answer: "IGPN",
    explanation:
        "IGPN : contrôle, enquêtes, audit, évaluation, maîtrise des risques.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Distinctions",
    question:
        "Quelle structure produit la statistique publique en sécurité intérieure ?",
    options: ["SSMSI", "SNPS", "DNPAF"],
    answer: "SSMSI",
    explanation: "SSMSI : statistique publique (données, études, enquêtes).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Organigrammes",
    question: "Sur un tableau d’organigramme, la lecture complète nécessite :",
    options: [
      "Un glissement horizontal et vertical",
      "Un double-tap sur le titre",
      "Un zoom uniquement vertical",
    ],
    answer: "Un glissement horizontal et vertical",
    explanation: "Ton aide de lecture indique swipe horizontal + vertical.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Organigrammes",
    question:
        "Sur l’organigramme au format tableau, chaque colonne représente :",
    options: [
      "Un grand bloc de l’organigramme",
      "Une sanction disciplinaire",
      "Un grade de la hiérarchie",
    ],
    answer: "Un grand bloc de l’organigramme",
    explanation: "Colonne = grand bloc (selon ton texte d’aide).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Hiérarchie",
    question: "Les 3 grands corps des services actifs sont :",
    options: [
      "Conception et direction / Commandement / Encadrement et application",
      "Administratifs / Scientifiques / Municipaux",
      "Judiciaires / Civils / Militaires",
    ],
    answer:
        "Conception et direction / Commandement / Encadrement et application",
    explanation: "CCD, CC, CEA : les 3 grands corps des services actifs.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Hiérarchie",
    question:
        "Le corps de conception et de direction concerne principalement :",
    options: [
      "Les commissaires",
      "Les gardiens de la paix",
      "Les adjoints administratifs",
    ],
    answer: "Les commissaires",
    explanation: "CCD : grades de commissaires.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Hiérarchie",
    question: "Le corps de commandement concerne principalement :",
    options: [
      "Les officiers",
      "Les agents spécialisés PTS",
      "Les réservistes citoyens",
    ],
    answer: "Les officiers",
    explanation:
        "Corps de commandement : officiers (capitaine/commandant/commandant divisionnaire).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Sigles",
    question: "Quel sigle correspond au Service de la protection ?",
    options: ["SDLP", "SNPS", "DNRT"],
    answer: "SDLP",
    explanation: "SDLP = Service de la protection.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Sigles",
    question: "Quel sigle correspond à la Police scientifique ?",
    options: ["SNPS", "SSMSI", "DNPAF"],
    answer: "SNPS",
    explanation: "SNPS = Service national de Police scientifique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Sigles",
    question: "Quel sigle correspond au Renseignement territorial ?",
    options: ["DNRT", "DCCRS", "DRHFS"],
    answer: "DNRT",
    explanation: "DNRT = Direction nationale du Renseignement territorial.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Sigles",
    question:
        "Quel sigle correspond aux Ressources humaines/finances/soutiens ?",
    options: ["DRHFS", "DGSI", "PP"],
    answer: "DRHFS",
    explanation: "DRHFS : ressources humaines, finances et soutiens.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question: "Parmi ces structures, laquelle est rattachée à la DGPN ?",
    options: ["DNPJ", "DGSI", "PP"],
    answer: "DNPJ",
    explanation:
        "DNPJ fait partie des directions et services rattachés à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question: "Parmi ces structures, laquelle est rattachée à la DGPN ?",
    options: ["DNSP", "DGSI", "PP"],
    answer: "DNSP",
    explanation:
        "DNSP fait partie des directions et services rattachés à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question: "Parmi ces structures, laquelle est rattachée à la DGPN ?",
    options: ["DNPAF", "DGSI", "PP"],
    answer: "DNPAF",
    explanation:
        "DNPAF fait partie des directions et services rattachés à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question: "Parmi ces structures, laquelle est rattachée à la DGPN ?",
    options: ["DCCRS", "DGSI", "PP"],
    answer: "DCCRS",
    explanation: "DCCRS (CRS) est rattachée à la DGPN dans ton contenu.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question: "Parmi ces structures, laquelle est rattachée à la DGPN ?",
    options: ["DNRT", "DGSI", "PP"],
    answer: "DNRT",
    explanation: "DNRT est rattachée à la DGPN (renseignement territorial).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question: "Parmi ces structures, laquelle est rattachée à la DGPN ?",
    options: ["ADP", "DGSI", "PP"],
    answer: "ADP",
    explanation: "ADP (Académie de Police) est rattachée à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question: "Parmi ces structures, laquelle est rattachée à la DGPN ?",
    options: ["SDLP", "DGSI", "PP"],
    answer: "SDLP",
    explanation: "SDLP est un service rattaché à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question: "Parmi ces structures, laquelle est rattachée à la DGPN ?",
    options: ["SNPS", "DGSI", "PP"],
    answer: "SNPS",
    explanation: "SNPS est un service rattaché à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question: "Parmi ces structures, laquelle est rattachée à la DGPN ?",
    options: ["IGPN", "DGSI", "PP"],
    answer: "IGPN",
    explanation:
        "IGPN fait partie des directions/services rattachés à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question: "Parmi ces structures, laquelle est rattachée à la DGPN ?",
    options: ["DRHFS", "DGSI", "PP"],
    answer: "DRHFS",
    explanation:
        "DRHFS fait partie des directions/services rattachés à la DGPN.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Organisation PN — DGPN",
    question: "La DGPN signifie :",
    options: [
      "Direction générale de la Police nationale",
      "Direction générale de la Protection nationale",
      "Direction de gestion de la Police nationale",
    ],
    answer: "Direction générale de la Police nationale",
    explanation: "DGPN = Direction générale de la Police nationale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question: "Le directeur général de la Police nationale est :",
    options: [
      "Assisté d’un directeur général adjoint",
      "Assisté d’un préfet maritime",
      "Assisté d’un procureur général",
    ],
    answer: "Assisté d’un directeur général adjoint",
    explanation: "DGPN : DG + DG adjoint pour diriger et coordonner.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Vue d’ensemble",
    question: "La Police nationale comporte principalement :",
    options: [
      "DGPN, DGSI et Préfecture de police",
      "DGPN et Police municipale",
      "DGSI et Gendarmerie nationale",
    ],
    answer: "DGPN, DGSI et Préfecture de police",
    explanation: "Organisation d’ensemble : DGPN + DGSI + PP.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question: "La DGPN coordonne :",
    options: [
      "Les directions et services rattachés à la Police nationale",
      "Uniquement la police municipale",
      "Uniquement les tribunaux",
    ],
    answer: "Les directions et services rattachés à la Police nationale",
    explanation:
        "La DGPN dirige/coordonne les directions et services rattachés.",
    difficulty: "Facile",
  ),

  // =========================================================
  // DGSI — BASIQUES / MISSIONS / ORGANISATION
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — DGSI",
    question: "La DGSI signifie :",
    options: [
      "Direction générale de la Sécurité intérieure",
      "Direction générale de la Sécurité internationale",
      "Direction de gestion des Services d’intervention",
    ],
    answer: "Direction générale de la Sécurité intérieure",
    explanation: "DGSI = Direction générale de la Sécurité intérieure.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGSI",
    question: "La DGSI est chargée, sur le territoire national, de :",
    options: [
      "Rechercher, centraliser et exploiter le renseignement intéressant la sécurité nationale",
      "Délivrer les titres de séjour",
      "Assurer la gestion budgétaire des communes",
    ],
    answer:
        "Rechercher, centraliser et exploiter le renseignement intéressant la sécurité nationale",
    explanation:
        "Mission centrale DGSI : renseignement lié à la sécurité nationale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGSI",
    question: "Parmi les missions de la DGSI, on retrouve :",
    options: [
      "Concourir à l’exercice des missions de police judiciaire dans ses domaines",
      "Assurer la police municipale",
      "Gérer les centres de rétention administrative",
    ],
    answer:
        "Concourir à l’exercice des missions de police judiciaire dans ses domaines",
    explanation:
        "La DGSI concourt à la PJ sur l’ensemble du territoire, dans ses domaines.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGSI",
    question: "La DGSI assure notamment :",
    options: [
      "La prévention et la répression de toute forme d’ingérence étrangère",
      "La gestion des permis de conduire",
      "Le commandement des CRS",
    ],
    answer:
        "La prévention et la répression de toute forme d’ingérence étrangère",
    explanation:
        "Ingérence étrangère : mission explicitement mentionnée pour la DGSI.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGSI",
    question: "La DGSI participe à la surveillance :",
    options: [
      "Des individus et groupes radicalisés susceptibles de recourir à la violence",
      "Des uniquement infractions routières",
      "Des uniquement délits financiers locaux",
    ],
    answer:
        "Des individus et groupes radicalisés susceptibles de recourir à la violence",
    explanation: "DGSI : surveillance des menaces radicales violentes.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGSI",
    question: "L’organisation interne de la DGSI comprend notamment :",
    options: [
      "Direction du renseignement et des opérations, Direction technique, Administration générale, Inspection générale",
      "DNPJ, DNSP, DNPAF, DCCRS",
      "SSMSI, DCIS, ANFSI, SNEAV",
    ],
    answer:
        "Direction du renseignement et des opérations, Direction technique, Administration générale, Inspection générale",
    explanation:
        "Ce sont des composantes internes typiques listées sur ta page DGSI.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DGSI",
    question: "La DGSI contribue à la surveillance des communications :",
    options: [
      "Électroniques et radioélectriques, pour les seuls besoins de ses missions",
      "Uniquement postales",
      "Uniquement administratives locales",
    ],
    answer:
        "Électroniques et radioélectriques, pour les seuls besoins de ses missions",
    explanation:
        "Surveillance technique : communications électroniques et radioélectriques.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // PRÉFECTURE DE POLICE — BASIQUES / RÔLE / ORGANISATION
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "La Préfecture de police (PP) concerne principalement :",
    options: [
      "Paris et la petite couronne (92/93/94) selon les compétences",
      "Toute la France métropolitaine",
      "Uniquement l’outre-mer",
    ],
    answer: "Paris et la petite couronne (92/93/94) selon les compétences",
    explanation:
        "PP : Paris + compétences étendues incluant 92/93/94 sur certains volets.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "À Paris, le préfet de police est :",
    options: [
      "Un haut fonctionnaire nommé en Conseil des ministres",
      "Un fonctionnaire élu par les policiers",
      "Un magistrat du siège",
    ],
    answer: "Un haut fonctionnaire nommé en Conseil des ministres",
    explanation: "Le préfet de police est nommé (Conseil des ministres).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "Parmi les attributions de la PP, on retrouve :",
    options: [
      "Assurer la sécurité des personnes et des biens",
      "Organiser les concours de la fonction publique",
      "Assurer la gestion des douanes",
    ],
    answer: "Assurer la sécurité des personnes et des biens",
    explanation: "La PP a des missions de sécurité (personnes et biens).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "Parmi les attributions de la PP, on retrouve :",
    options: [
      "Assurer la sécurité civile",
      "Diriger la DCCRS",
      "Diriger le SSMSI",
    ],
    answer: "Assurer la sécurité civile",
    explanation: "La PP exerce aussi des missions de sécurité civile.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "Parmi les attributions de la PP, on retrouve :",
    options: [
      "Assurer la circulation",
      "Assurer la coopération internationale de sécurité",
      "Assurer la direction de la Police aux frontières au niveau national",
    ],
    answer: "Assurer la circulation",
    explanation:
        "La PP a une forte compétence en matière de circulation à Paris.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "Parmi les attributions de la PP, on retrouve :",
    options: [
      "Délivrer des titres administratifs",
      "Répartir les budgets des collectivités territoriales",
      "Contrôler les frontières maritimes nationales",
    ],
    answer: "Délivrer des titres administratifs",
    explanation: "La PP délivre divers titres administratifs.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "Le préfet de police est notamment :",
    options: [
      "Préfet de la zone de défense de Paris (Île-de-France)",
      "Préfet maritime de Méditerranée",
      "Préfet coordonnateur des stations de ski",
    ],
    answer: "Préfet de la zone de défense de Paris (Île-de-France)",
    explanation: "Rôle : zone de défense de Paris.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — Préfecture de police",
    question: "Parmi les services actifs de la PP, on retrouve :",
    options: [
      "DOPC, direction PJ, direction du renseignement",
      "DRHFS, SSMSI, ANFSI",
      "SNEAV, SNEAS, DCIS",
    ],
    answer: "DOPC, direction PJ, direction du renseignement",
    explanation:
        "PP : directions actives (ordre public/circulation, PJ, renseignement...).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // DRHFS — RÔLES / COMPÉTENCES
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — DRHFS",
    question: "La DRHFS signifie :",
    options: [
      "Direction des ressources humaines, des finances et des soutiens",
      "Direction du renseignement, de l’hébergement et de la formation des stagiaires",
      "Direction des relations humaines et des forces de sécurité",
    ],
    answer: "Direction des ressources humaines, des finances et des soutiens",
    explanation: "DRHFS = RH + finances + soutiens (Police nationale).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DRHFS",
    question: "La DRHFS assure notamment :",
    options: [
      "L’organisation des carrières et le développement des parcours individualisés",
      "Le maintien de l’ordre via unités mobiles",
      "Le contrôle des frontières",
    ],
    answer:
        "L’organisation des carrières et le développement des parcours individualisés",
    explanation: "DRHFS : carrière, parcours, gestion RH.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DRHFS",
    question: "Concernant les contractuels, la DRHFS :",
    options: [
      "Recrute pour la PN, sauf la DGSI qui recrute pour son propre compte",
      "Recrute uniquement pour la DGSI",
      "Ne recrute jamais de contractuels",
    ],
    answer:
        "Recrute pour la PN, sauf la DGSI qui recrute pour son propre compte",
    explanation: "Exception prévue : DGSI recrute pour elle-même.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — DRHFS",
    question: "La DRHFS conduit notamment :",
    options: [
      "La politique ministérielle d’action sociale du logement et de l’enfance",
      "La coopération policière internationale",
      "Le renseignement territorial",
    ],
    answer:
        "La politique ministérielle d’action sociale du logement et de l’enfance",
    explanation: "Action sociale : logement + enfance (ministère).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DRHFS",
    question: "La DRHFS participe :",
    options: [
      "À l’élaboration et à l’exécution du budget concernant la Police nationale",
      "À la gestion opérationnelle des CRA",
      "À la direction de la police judiciaire à Paris",
    ],
    answer:
        "À l’élaboration et à l’exécution du budget concernant la Police nationale",
    explanation: "DRHFS : budget + répartition des moyens financiers.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DRHFS",
    question: "La DRHFS est chargée :",
    options: [
      "De la réglementation liée au temps de travail",
      "De la délivrance des visas",
      "Du commandement des CRS",
    ],
    answer: "De la réglementation liée au temps de travail",
    explanation: "Temps de travail : volet support DRHFS.",
    difficulty: "Moyen",
  ),

  // =========================================================
  // IGPN — COMPÉTENCE / MISSIONS
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — IGPN",
    question: "L’IGPN signifie :",
    options: [
      "Inspection générale de la Police nationale",
      "Inspection générale de la Protection nationale",
      "Inspection générale des Procédures nationales",
    ],
    answer: "Inspection générale de la Police nationale",
    explanation: "IGPN = Inspection générale de la Police nationale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — IGPN",
    question: "L’IGPN exerce notamment :",
    options: [
      "Une mission de contrôle et des enquêtes (administratives/judiciaires)",
      "Le contrôle des frontières",
      "La formation initiale des commissaires",
    ],
    answer:
        "Une mission de contrôle et des enquêtes (administratives/judiciaires)",
    explanation: "IGPN : contrôle + enquêtes + audit/évaluation/conseil.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — IGPN",
    question: "L’IGPN peut contrôler :",
    options: [
      "DGPN, Préfecture de police et DGSI",
      "Uniquement la DGPN",
      "Uniquement les mairies",
    ],
    answer: "DGPN, Préfecture de police et DGSI",
    explanation: "Dans ton contenu : IGPN a un périmètre large (DGPN/PP/DGSI).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — IGPN",
    question: "La compétence de l’IGPN est :",
    options: ["Nationale", "Communale", "Limitée à Paris"],
    answer: "Nationale",
    explanation: "IGPN : compétence nationale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — IGPN",
    question: "Parmi les missions de l’IGPN, on trouve :",
    options: [
      "Audit interne, évaluation, analyse, conseil et maîtrise des risques",
      "Gestion des CRA",
      "Protection rapprochée des personnalités",
    ],
    answer:
        "Audit interne, évaluation, analyse, conseil et maîtrise des risques",
    explanation: "IGPN : audit/inspection/maîtrise des risques.",
    difficulty: "Moyen",
  ),

  // =========================================================
  // DNPJ — MISSIONS / CHAMP
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — DNPJ",
    question: "La DNPJ signifie :",
    options: [
      "Direction nationale de la Police judiciaire",
      "Direction nationale de la Police de jeunesse",
      "Direction nationale de la Protection judiciaire",
    ],
    answer: "Direction nationale de la Police judiciaire",
    explanation: "DNPJ = Direction nationale de la Police judiciaire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPJ",
    question: "La DNPJ concourt principalement :",
    options: [
      "Aux missions de police judiciaire sur l’ensemble du territoire national",
      "Au contrôle des frontières",
      "À la protection rapprochée",
    ],
    answer:
        "Aux missions de police judiciaire sur l’ensemble du territoire national",
    explanation: "DNPJ : PJ sur l’ensemble du territoire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPJ",
    question: "La DNPJ contribue à la lutte :",
    options: [
      "Contre la criminalité et la délinquance, y compris organisée/transnationale",
      "Uniquement contre les infractions routières",
      "Uniquement contre les incivilités",
    ],
    answer:
        "Contre la criminalité et la délinquance, y compris organisée/transnationale",
    explanation: "DNPJ : criminalité organisée et transnationale incluse.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPJ",
    question: "La DNPJ :",
    options: [
      "Anime l’action des services PJ relevant de sa filière",
      "Dirige la sécurité publique des communes étatisées",
      "Produit la statistique publique de sécurité intérieure",
    ],
    answer: "Anime l’action des services PJ relevant de sa filière",
    explanation: "Filière PJ : objectifs et animation nationale.",
    difficulty: "Moyen",
  ),

  // =========================================================
  // DNSP — MISSIONS / COMMUNES ÉTATISÉES
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — DNSP",
    question: "La DNSP signifie :",
    options: [
      "Direction nationale de la Sécurité publique",
      "Direction nationale de la Sécurité privée",
      "Direction nationale du Service pénitentiaire",
    ],
    answer: "Direction nationale de la Sécurité publique",
    explanation: "DNSP = Direction nationale de la Sécurité publique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNSP",
    question: "La DNSP agit principalement dans :",
    options: [
      "Les communes où la police est étatisée (sécurité et ordre publics)",
      "Uniquement les zones frontalières",
      "Uniquement Paris",
    ],
    answer:
        "Les communes où la police est étatisée (sécurité et ordre publics)",
    explanation:
        "DNSP : sécurité/ordre public dans les communes à police étatisée.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DNSP",
    question: "Parmi les priorités DNSP, on retrouve :",
    options: [
      "Police-secours et accueil du public/victimes",
      "Protection rapprochée VIP",
      "Contrôle des frontières maritimes",
    ],
    answer: "Police-secours et accueil du public/victimes",
    explanation: "DNSP : police-secours et accueil au cœur des missions.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNSP",
    question:
        "Au titre de la protection de l’espace public, la DNSP est en charge :",
    options: [
      "De la sécurité routière et participe à la sécurisation des transports en commun",
      "Des centres de rétention administrative",
      "Du renseignement extérieur",
    ],
    answer:
        "De la sécurité routière et participe à la sécurisation des transports en commun",
    explanation: "DNSP : sécurité routière + transports en commun.",
    difficulty: "Moyen",
  ),

  // =========================================================
  // DNPAF — FRONTIÈRES / IMMIGRATION
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — DNPAF",
    question: "La DNPAF signifie :",
    options: [
      "Direction nationale de la Police aux frontières",
      "Direction nationale de la Protection des Agents de France",
      "Direction nationale de la Police des affaires financières",
    ],
    answer: "Direction nationale de la Police aux frontières",
    explanation: "DNPAF = Direction nationale de la Police aux frontières.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPAF",
    question: "La DNPAF veille au respect des normes encadrant :",
    options: [
      "Le contrôle et la surveillance des frontières terrestres, maritimes et aériennes",
      "La formation des commissaires",
      "La discipline interne des services",
    ],
    answer:
        "Le contrôle et la surveillance des frontières terrestres, maritimes et aériennes",
    explanation: "PAF : frontières sur tous milieux (terre/mer/air).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPAF",
    question: "La DNPAF est chef de file (PN) en matière :",
    options: [
      "De traitement procédural des étrangers en situation irrégulière",
      "D’audit interne",
      "De statistiques publiques",
    ],
    answer: "De traitement procédural des étrangers en situation irrégulière",
    explanation: "PAF : chef de file sur le traitement procédural ESI.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPAF",
    question: "La DNPAF centralise et analyse :",
    options: [
      "Les informations relatives aux flux et risques migratoires",
      "Les statistiques de délinquance pour publication",
      "Les demandes d’affectation des élèves",
    ],
    answer: "Les informations relatives aux flux et risques migratoires",
    explanation: "PAF : analyse des flux/risques migratoires.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DNPAF",
    question: "La DNPAF assure notamment :",
    options: [
      "Le suivi de la chaîne de traitement de l’éloignement et la gestion opérationnelle des CRA",
      "Le maintien et le rétablissement de l’ordre public via unités mobiles",
      "La protection rapprochée des hautes personnalités",
    ],
    answer:
        "Le suivi de la chaîne de traitement de l’éloignement et la gestion opérationnelle des CRA",
    explanation:
        "PAF : éloignement + centres de rétention administrative (CRA).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // DNRT — RENSEIGNEMENT TERRITORIAL
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — DNRT",
    question: "La DNRT signifie :",
    options: [
      "Direction nationale du Renseignement territorial",
      "Direction nationale de la Recherche technique",
      "Direction nationale de la Rétention territoriale",
    ],
    answer: "Direction nationale du Renseignement territorial",
    explanation: "DNRT = Direction nationale du Renseignement territorial.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DNRT",
    question: "Le renseignement territorial vise à :",
    options: [
      "Rechercher, centraliser et analyser des renseignements destinés à informer l’État",
      "Délivrer des titres administratifs",
      "Assurer la gestion budgétaire des services",
    ],
    answer:
        "Rechercher, centraliser et analyser des renseignements destinés à informer l’État",
    explanation:
        "RT : collecte/centralisation/analyse au profit des autorités.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — DNRT",
    question: "La DNRT contribue :",
    options: [
      "À la prévention du terrorisme en lien avec les services compétents",
      "À la gestion des CRA",
      "Au commandement des CRS",
    ],
    answer:
        "À la prévention du terrorisme en lien avec les services compétents",
    explanation: "RT : contribution prévention terrorisme (coordination).",
    difficulty: "Moyen",
  ),

  // =========================================================
  // DCCRS / CRS — ORDRE PUBLIC
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — DCCRS",
    question: "La DCCRS signifie :",
    options: [
      "Direction centrale des Compagnies républicaines de sécurité",
      "Direction centrale de la Criminalité routière et sociale",
      "Direction centrale du Commandement régional de sécurité",
    ],
    answer: "Direction centrale des Compagnies républicaines de sécurité",
    explanation: "DCCRS = direction centrale des CRS.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — CRS",
    question: "Les CRS sont spécialisées notamment dans :",
    options: [
      "Le maintien et le rétablissement de l’ordre public",
      "Le contrôle des frontières",
      "La statistique publique",
    ],
    answer: "Le maintien et le rétablissement de l’ordre public",
    explanation: "CRS : unités mobiles dédiées à l’ordre public.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — CRS",
    question: "Les CRS peuvent porter assistance aux populations :",
    options: [
      "En cas de sinistre grave ou de calamité publique",
      "Uniquement sur décision du maire",
      "Uniquement en outre-mer",
    ],
    answer: "En cas de sinistre grave ou de calamité publique",
    explanation: "CRS : assistance possible lors de catastrophes.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — CRS",
    question: "Les gardes statiques par CRS :",
    options: [
      "Uniquement sur ordre du ministre et jamais permanentes",
      "Toujours possibles sur ordre du commissaire local",
      "Obligatoires chaque semaine",
    ],
    answer: "Uniquement sur ordre du ministre et jamais permanentes",
    explanation: "Principe : pas de gardes statiques permanentes.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // ADP — FORMATION / RECRUTEMENT
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — ADP",
    question: "L’ADP correspond à :",
    options: [
      "L’Académie de Police",
      "L’Agence des Dépenses Publiques",
      "L’Autorité de Discipline Policière",
    ],
    answer: "L’Académie de Police",
    explanation: "ADP = Académie de Police.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — ADP",
    question: "L’Académie de Police est chargée :",
    options: [
      "Du recrutement et de la formation de la Police nationale",
      "Du contrôle des frontières",
      "De la statistique publique",
    ],
    answer: "Du recrutement et de la formation de la Police nationale",
    explanation: "ADP : recrutement + formation initiale/continue.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — ADP",
    question: "L’ADP est aussi chargée :",
    options: [
      "Des études et de la recherche de la Police nationale",
      "De l’éloignement des étrangers",
      "De la protection rapprochée",
    ],
    answer: "Des études et de la recherche de la Police nationale",
    explanation: "ADP : études/recherche (en plus de la formation).",
    difficulty: "Moyen",
  ),

  // =========================================================
  // SDLP — PROTECTION
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — SDLP",
    question: "Le SDLP signifie :",
    options: [
      "Service de la protection",
      "Service de la Police",
      "Service de Lutte contre le Piratage",
    ],
    answer: "Service de la protection",
    explanation: "SDLP = Service de la protection.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — SDLP",
    question: "Le SDLP assure principalement :",
    options: [
      "Des missions de protection rapprochée et d’accompagnement de sécurité",
      "La police judiciaire nationale",
      "Le contrôle des frontières",
    ],
    answer:
        "Des missions de protection rapprochée et d’accompagnement de sécurité",
    explanation: "Protection rapprochée : mission cœur SDLP.",
    difficulty: "Facile",
  ),

  // =========================================================
  // SNPS — POLICE SCIENTIFIQUE
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — SNPS",
    question: "Le SNPS signifie :",
    options: [
      "Service national de Police scientifique",
      "Service national de Protection sociale",
      "Service national de Police sportive",
    ],
    answer: "Service national de Police scientifique",
    explanation: "SNPS = Service national de Police scientifique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — SNPS",
    question: "Le SNPS a pour mission :",
    options: [
      "De définir et coordonner la politique de police scientifique sur le territoire",
      "De gérer les CRA",
      "De diriger la DNSP",
    ],
    answer:
        "De définir et coordonner la politique de police scientifique sur le territoire",
    explanation: "SNPS : coordination de la police scientifique.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — SNPS",
    question: "Le SNPS peut réaliser :",
    options: [
      "Des examens, constatations, expertises et analyses demandés par l’autorité judiciaire",
      "Des décisions de justice",
      "Des sanctions disciplinaires",
    ],
    answer:
        "Des examens, constatations, expertises et analyses demandés par l’autorité judiciaire",
    explanation: "Police scientifique : analyses/expertises à la demande.",
    difficulty: "Moyen",
  ),

  // =========================================================
  // RAID — INTERVENTION
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — RAID",
    question: "RAID signifie :",
    options: [
      "Recherche, Assistance, Intervention et Dissuasion",
      "Renseignement, Action, Intervention et Défense",
      "Réaction, Appui, Investigation et Droit",
    ],
    answer: "Recherche, Assistance, Intervention et Dissuasion",
    explanation: "RAID : unité d’intervention nationale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — RAID",
    question: "Le RAID intervient notamment :",
    options: [
      "Dans la criminalité organisée et le terrorisme",
      "Dans la gestion budgétaire nationale",
      "Dans la délivrance des titres administratifs",
    ],
    answer: "Dans la criminalité organisée et le terrorisme",
    explanation:
        "RAID : intervention spécialisée (criminalité organisée/terrorisme).",
    difficulty: "Facile",
  ),

  // =========================================================
  // SERVICES NATIONAUX RATTACHÉS (SNEAS / SNEAV) + MUTUALISÉS (ANFSI / DCIS / SSMSI)
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — SNEAS",
    question: "Le SNEAS signifie :",
    options: [
      "Service national des enquêtes administratives de sécurité",
      "Service national des enquêtes d’assistance sociale",
      "Service national des enquêtes anti-stupéfiants",
    ],
    answer: "Service national des enquêtes administratives de sécurité",
    explanation: "SNEAS : enquêtes administratives de sécurité.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — SNEAS",
    question: "Le SNEAS réalise :",
    options: [
      "Des enquêtes administratives de sécurité",
      "Des expertises scientifiques",
      "Des opérations de maintien de l’ordre",
    ],
    answer: "Des enquêtes administratives de sécurité",
    explanation:
        "SNEAS : enquêtes administratives liées à autorisations/risques.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — SNEAV",
    question: "Le SNEAV signifie :",
    options: [
      "Service national des enquêtes d’autorisation de voyage",
      "Service national des enquêtes d’autorisation de voie publique",
      "Service national des enquêtes anti-vol",
    ],
    answer: "Service national des enquêtes d’autorisation de voyage",
    explanation: "SNEAV : autorisations de voyage (traitements spécifiques).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — ANFSI",
    question: "L’ANFSI signifie :",
    options: [
      "Agence du numérique des forces de sécurité intérieure",
      "Agence nationale de formation en sécurité intérieure",
      "Autorité nationale des fichiers de sécurité intérieure",
    ],
    answer: "Agence du numérique des forces de sécurité intérieure",
    explanation: "ANFSI : numérique / SI / sécurité des outils FSI.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DCIS",
    question: "La DCIS signifie :",
    options: [
      "Direction de la coopération internationale de sécurité",
      "Direction centrale des investigations spécialisées",
      "Direction de contrôle interne de sécurité",
    ],
    answer: "Direction de la coopération internationale de sécurité",
    explanation: "DCIS : coopération internationale Police/Gendarmerie.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — SSMSI",
    question: "Le SSMSI signifie :",
    options: [
      "Service statistique ministériel de la sécurité intérieure",
      "Service spécialisé de maintien de la sécurité intérieure",
      "Service social ministériel de sécurité intérieure",
    ],
    answer: "Service statistique ministériel de la sécurité intérieure",
    explanation: "SSMSI : statistique publique de sécurité intérieure.",
    difficulty: "Moyen",
  ),

  // =========================================================
  // DTPN — OUTRE-MER (DIRECTIONS TERRITORIALES)
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — DTPN",
    question: "Dans certains territoires ultramarins, les DTPN :",
    options: [
      "Se substituent aux directions de la PN et exercent une direction de police unique",
      "Remplacent la gendarmerie nationale",
      "Sont uniquement des écoles de police",
    ],
    answer:
        "Se substituent aux directions de la PN et exercent une direction de police unique",
    explanation:
        "DTPN : direction unique regroupant plusieurs missions dans le ressort.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — DTPN",
    question: "Une DTPN peut regrouper plusieurs filières, notamment :",
    options: [
      "PJ, PAF, Sécurité publique, Renseignement territorial",
      "Uniquement les CRS",
      "Uniquement la police scientifique",
    ],
    answer: "PJ, PAF, Sécurité publique, Renseignement territorial",
    explanation: "DTPN : logique intégrée multi-filières.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // ORGANIGRAMMES — UTILISATION (tes pages)
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — Organigrammes",
    question: "Sur la page “Organigramme MI”, pour lire tout le tableau :",
    options: [
      "On glisse horizontalement et verticalement",
      "On appuie 3 secondes sur le titre",
      "On fait uniquement un scroll vertical",
    ],
    answer: "On glisse horizontalement et verticalement",
    explanation: "Ton aide de lecture indique swipe horizontal + vertical.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Organigrammes",
    question:
        "Sur l’organigramme au format tableau, chaque colonne correspond :",
    options: [
      "À un grand bloc de l’organigramme",
      "À un article de loi",
      "À un grade de la PN",
    ],
    answer: "À un grand bloc de l’organigramme",
    explanation: "Colonne = grand bloc pour simplifier la lecture.",
    difficulty: "Facile",
  ),

  // =========================================================
  // HIÉRARCHIE — CORPS (rappels organisationnels)
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — Hiérarchie",
    question: "Les 3 grands corps des services actifs sont :",
    options: [
      "Conception & direction / Commandement / Encadrement & application",
      "Administratifs / Municipaux / Douaniers",
      "Judiciaires / Civils / Militaires",
    ],
    answer: "Conception & direction / Commandement / Encadrement & application",
    explanation: "CCD, CC, CEA : les 3 grands corps des actifs.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Hiérarchie",
    question:
        "Le corps de conception et de direction correspond principalement :",
    options: [
      "Aux commissaires",
      "Aux gardiens de la paix",
      "Aux adjoints administratifs",
    ],
    answer: "Aux commissaires",
    explanation: "CCD : grades de commissaires.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Hiérarchie",
    question: "Le corps de commandement correspond principalement :",
    options: [
      "Aux officiers",
      "Aux ingénieurs SIC",
      "Aux réservistes citoyens",
    ],
    answer: "Aux officiers",
    explanation: "Corps de commandement : officiers.",
    difficulty: "Facile",
  ),

  // =========================================================
  // QUESTIONS “DISTINCTION” (pièges de compréhension)
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — Distinctions",
    question:
        "Quelle structure est orientée “renseignement sécurité nationale” ?",
    options: ["DGSI", "DNSP", "SNPS"],
    answer: "DGSI",
    explanation: "DGSI : renseignement sécurité nationale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Distinctions",
    question:
        "Quelle structure est orientée “frontières / immigration irrégulière” ?",
    options: ["DNPAF", "DCCRS", "DRHFS"],
    answer: "DNPAF",
    explanation: "DNPAF : frontières et lutte contre immigration irrégulière.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Distinctions",
    question: "Quelle structure est orientée “ordre public / unités mobiles” ?",
    options: ["DCCRS", "DNPJ", "SSMSI"],
    answer: "DCCRS",
    explanation: "DCCRS : CRS et maintien/rétablissement de l’ordre public.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Distinctions",
    question:
        "Quelle structure produit la “statistique publique” en sécurité intérieure ?",
    options: ["SSMSI", "SDLP", "IGPN"],
    answer: "SSMSI",
    explanation: "SSMSI : statistique publique sécurité intérieure.",
    difficulty: "Moyen",
  ),

  // =========================================================
  // RÉVISION RAPIDE — SIGLES (pack dense)
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — Sigles",
    question: "Quel sigle correspond à la Police scientifique ?",
    options: ["SNPS", "SDLP", "DNRT"],
    answer: "SNPS",
    explanation: "SNPS = Service national de Police scientifique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Sigles",
    question: "Quel sigle correspond au Service de la protection ?",
    options: ["SDLP", "SSMSI", "DNPAF"],
    answer: "SDLP",
    explanation: "SDLP = Service de la protection.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Sigles",
    question: "Quel sigle correspond au Renseignement territorial ?",
    options: ["DNRT", "DNPJ", "DCCRS"],
    answer: "DNRT",
    explanation: "DNRT = Direction nationale du Renseignement territorial.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Sigles",
    question:
        "Quel sigle correspond aux Ressources humaines/finances/soutiens ?",
    options: ["DRHFS", "DGSI", "SNPS"],
    answer: "DRHFS",
    explanation: "DRHFS : RH + finances + soutiens de la PN.",
    difficulty: "Facile",
  ),

  // =========================================================
  // PACK “RATTACHEMENTS” (DGPN -> directions/services)
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question:
        "Parmi ces structures, laquelle est une direction rattachée à la DGPN ?",
    options: ["DNPJ", "PP", "DGSI"],
    answer: "DNPJ",
    explanation:
        "DNPJ fait partie des directions/services rattachés à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question:
        "Parmi ces structures, laquelle est une direction rattachée à la DGPN ?",
    options: ["DNSP", "PP", "DGSI"],
    answer: "DNSP",
    explanation:
        "DNSP fait partie des directions/services rattachés à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question:
        "Parmi ces structures, laquelle est une direction rattachée à la DGPN ?",
    options: ["DNPAF", "PP", "DGSI"],
    answer: "DNPAF",
    explanation:
        "DNPAF fait partie des directions/services rattachés à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question:
        "Parmi ces structures, laquelle est un service rattaché à la DGPN ?",
    options: ["SDLP", "DGSI", "PP"],
    answer: "SDLP",
    explanation: "Le SDLP est un service rattaché à la DGPN.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Rattachements",
    question:
        "Parmi ces structures, laquelle est un service rattaché à la DGPN ?",
    options: ["SNPS", "DGSI", "PP"],
    answer: "SNPS",
    explanation: "Le SNPS est un service rattaché à la DGPN.",
    difficulty: "Moyen",
  ),

  // =========================================================
  // PACK “MISSIONS” — QCM formulations variées (pour volume)
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — Missions",
    question:
        "Quel service est le plus directement associé à la protection rapprochée ?",
    options: ["SDLP", "SNPS", "SSMSI"],
    answer: "SDLP",
    explanation: "SDLP = Service de la protection (protection rapprochée).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Missions",
    question:
        "Quel service est le plus directement associé aux expertises scientifiques ?",
    options: ["SNPS", "SDLP", "DCIS"],
    answer: "SNPS",
    explanation: "SNPS : politique et expertise de police scientifique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Missions",
    question:
        "Quelle direction est la plus directement associée aux enquêtes PJ au niveau national ?",
    options: ["DNPJ", "DNPAF", "DCCRS"],
    answer: "DNPJ",
    explanation: "DNPJ : direction nationale de la Police judiciaire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Missions",
    question:
        "Quelle direction est la plus directement associée à la sécurité du quotidien ?",
    options: ["DNSP", "DNPJ", "SSMSI"],
    answer: "DNSP",
    explanation: "DNSP : sécurité publique / SDQ / accueil / police-secours.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Missions",
    question:
        "Quelle direction est la plus directement associée aux flux migratoires ?",
    options: ["DNPAF", "DNPJ", "IGPN"],
    answer: "DNPAF",
    explanation: "DNPAF : flux et risques migratoires.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Missions",
    question:
        "Quelle structure est principalement associée au contrôle/audit interne des services ?",
    options: ["IGPN", "SNPS", "DNRT"],
    answer: "IGPN",
    explanation: "IGPN : contrôle, enquêtes, audit, évaluation, risques.",
    difficulty: "Moyen",
  ),

  // =========================================================
  // MINI-PACK “ORGANIGRAMMES PN” (tes pages OrganigrammesPnPage)
  // =========================================================
  QuizQuestion(
    category: "Organisation PN — Organigrammes PN",
    question: "Sur tes pages d’organigrammes, appuyer sur l’image permet :",
    options: [
      "D’ouvrir l’image en grand et zoomer",
      "De supprimer la carte",
      "De lancer une impression",
    ],
    answer: "D’ouvrir l’image en grand et zoomer",
    explanation: "Ton UI indique : appuie pour ouvrir et zoomer (pincement).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Organigrammes PN",
    question: "Un organigramme “vue d’ensemble” sert surtout à :",
    options: [
      "Visualiser l’organisation globale et les principales directions/services",
      "Remplacer le Code pénal",
      "Indiquer les sanctions disciplinaires",
    ],
    answer:
        "Visualiser l’organisation globale et les principales directions/services",
    explanation: "Vue d’ensemble : structure générale + directions/services.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — DGPN",
    question: "Le directeur général de la Police nationale est :",
    options: [
      "Assisté d’un directeur général adjoint",
      "Assisté d’un préfet maritime",
      "Assisté d’un procureur général",
    ],
    answer: "Assisté d’un directeur général adjoint",
    explanation: "DGPN : DG + DG adjoint pour diriger et coordonner.",
    difficulty: "Facile",
  ),

  // =========================
  // DIRECTIONS / SERVICES RATTACHÉS (LISTES)
  // =========================
  QuizQuestion(
    category: "Organisation PN — Directions rattachées",
    question: "La DRHFS est :",
    options: [
      "La direction de gestion et de soutien (RH, finances, soutiens)",
      "La direction du renseignement territorial",
      "La direction de la police scientifique",
    ],
    answer: "La direction de gestion et de soutien (RH, finances, soutiens)",
    explanation: "DRHFS : ressources humaines, finances et soutiens de la PN.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Directions rattachées",
    question: "La DNPJ est :",
    options: [
      "La Direction nationale de la Police judiciaire",
      "La Direction nationale de la Police de jeunesse",
      "La Direction nationale de la Protection judiciaire",
    ],
    answer: "La Direction nationale de la Police judiciaire",
    explanation: "DNPJ : filière police judiciaire au niveau national.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Directions rattachées",
    question: "La DNSP est :",
    options: [
      "La Direction nationale de la Sécurité publique",
      "La Direction nationale du Service pénitentiaire",
      "La Direction nationale de la Sécurité privée",
    ],
    answer: "La Direction nationale de la Sécurité publique",
    explanation:
        "DNSP : sécurité publique (police du quotidien, police-secours, etc.).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Directions rattachées",
    question: "La DNPAF est :",
    options: [
      "La Direction nationale de la Police aux frontières",
      "La Direction nationale des Parquets et Affaires familiales",
      "La Direction nationale de la Protection des Agents",
    ],
    answer: "La Direction nationale de la Police aux frontières",
    explanation:
        "DNPAF : contrôle/surveillance frontières + immigration irrégulière.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Directions rattachées",
    question: "La DNRT est :",
    options: [
      "La Direction nationale du Renseignement territorial",
      "La Direction nationale de la Recherche technique",
      "La Direction nationale de la Rétention",
    ],
    answer: "La Direction nationale du Renseignement territorial",
    explanation:
        "DNRT : renseignement territorial (hors Paris/petite couronne selon organisation).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Directions rattachées",
    question: "La DCCRS est :",
    options: [
      "La Direction centrale des Compagnies républicaines de sécurité",
      "La Direction centrale de la Criminalité routière et sociale",
      "La Direction centrale du Commandement régional de sécurité",
    ],
    answer: "La Direction centrale des Compagnies républicaines de sécurité",
    explanation: "DCCRS : organisation/contrôle/emploi des CRS.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Directions rattachées",
    question: "L’ADP correspond à :",
    options: [
      "L’Académie de Police",
      "L’Agence des Dépenses Publiques",
      "L’Autorité de Discipline Policière",
    ],
    answer: "L’Académie de Police",
    explanation: "ADP : recrutement + formation initiale/continue.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Directions rattachées",
    question: "Le SDLP est :",
    options: [
      "Le Service de la protection",
      "Le Service de la Police",
      "Le Service de Lutte contre le Piratage",
    ],
    answer: "Le Service de la protection",
    explanation:
        "SDLP : protection rapprochée, sûreté de certaines personnalités/événements.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Directions rattachées",
    question: "Le SNPS est :",
    options: [
      "Le Service national de Police scientifique",
      "Le Service national de Protection sociale",
      "Le Service national de Police sportive",
    ],
    answer: "Le Service national de Police scientifique",
    explanation: "SNPS : politique et coordination de police scientifique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Unités spécialisées",
    question: "RAID signifie :",
    options: [
      "Recherche, Assistance, Intervention, Dissuasion",
      "Renseignement, Action, Intervention, Défense",
      "Réaction, Appui, Investigation, Droit",
    ],
    answer: "Recherche, Assistance, Intervention, Dissuasion",
    explanation: "RAID : unité d’intervention nationale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Mutualisation",
    question: "L’ANFSI est :",
    options: [
      "L’Agence du numérique des forces de sécurité intérieure",
      "L’Agence nationale de formation en sécurité intérieure",
      "L’Autorité nationale des fichiers de sécurité intérieure",
    ],
    answer: "L’Agence du numérique des forces de sécurité intérieure",
    explanation:
        "ANFSI : SI, équipements numériques, convergence, sécurité des outils.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Mutualisation",
    question: "La DCIS correspond à :",
    options: [
      "La Direction de la coopération internationale de sécurité",
      "La Direction centrale des investigations spécialisées",
      "La Direction de contrôle interne de sécurité",
    ],
    answer: "La Direction de la coopération internationale de sécurité",
    explanation: "DCIS : coopération internationale Police/Gendarmerie.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Statistiques",
    question: "Le SSMSI est :",
    options: [
      "Le Service statistique ministériel de la sécurité intérieure",
      "Le Service de soutien médico-social interne",
      "Le Service spécialisé de maintien de la sécurité intérieure",
    ],
    answer: "Le Service statistique ministériel de la sécurité intérieure",
    explanation:
        "SSMSI : statistique publique sécurité intérieure (données/études).",
    difficulty: "Facile",
  ),

  // =========================
  // IGPN
  // =========================
  QuizQuestion(
    category: "IGPN — Rôle et compétence",
    question: "L’IGPN exerce principalement :",
    options: [
      "Une mission de contrôle, d’enquêtes, d’audit, d’évaluation et de conseil",
      "La formation initiale des commissaires",
      "Le contrôle des frontières",
    ],
    answer:
        "Une mission de contrôle, d’enquêtes, d’audit, d’évaluation et de conseil",
    explanation:
        "IGPN : contrôle + enquêtes admin/judiciaires + audit/risques.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "IGPN — Périmètre",
    question: "L’IGPN peut contrôler :",
    options: [
      "Les directions/services de la DGPN, de la PP et de la DGSI",
      "Uniquement la DGPN",
      "Uniquement la PP",
    ],
    answer: "Les directions/services de la DGPN, de la PP et de la DGSI",
    explanation: "IGPN : mission de contrôle large (DGPN, PP, DGSI).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "IGPN — Compétence",
    question: "La compétence de l’IGPN est :",
    options: ["Nationale", "Communale", "Limitée à l’Île-de-France"],
    answer: "Nationale",
    explanation: "IGPN : compétence nationale.",
    difficulty: "Facile",
  ),

  // =========================
  // DNPJ
  // =========================
  QuizQuestion(
    category: "DNPJ — Missions",
    question: "La DNPJ concourt principalement :",
    options: [
      "Aux missions de police judiciaire sur l’ensemble du territoire national",
      "À la police municipale",
      "Uniquement au maintien de l’ordre (MO)",
    ],
    answer:
        "Aux missions de police judiciaire sur l’ensemble du territoire national",
    explanation:
        "DNPJ : prévention/répression criminalité et délinquance, dont formes organisées/transnationales.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "DNPJ — Champ",
    question: "La DNPJ contribue à lutter :",
    options: [
      "Contre la criminalité et la délinquance, y compris spécialisée/organisée/transnationale",
      "Uniquement contre les infractions routières",
      "Uniquement contre les incivilités",
    ],
    answer:
        "Contre la criminalité et la délinquance, y compris spécialisée/organisée/transnationale",
    explanation: "PJ : champ large, y compris la criminalité organisée.",
    difficulty: "Moyen",
  ),

  // =========================
  // DNSP
  // =========================
  QuizQuestion(
    category: "DNSP — Missions",
    question: "La DNSP anime l’action des services de police :",
    options: [
      "En matière de sécurité et d’ordre publics dans les communes où la police est étatisée",
      "Uniquement dans les communes rurales",
      "Uniquement dans les communes non étatisées",
    ],
    answer:
        "En matière de sécurité et d’ordre publics dans les communes où la police est étatisée",
    explanation:
        "DNSP : périmètre des communes à police étatisée (sous réserve des règles spécifiques).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "DNSP — Priorités",
    question: "La DNSP veille particulièrement :",
    options: [
      "À la police-secours, à l’accueil du public et des victimes, au lien police/population",
      "Uniquement à la police scientifique",
      "Uniquement à la coopération internationale",
    ],
    answer:
        "À la police-secours, à l’accueil du public et des victimes, au lien police/population",
    explanation: "Sécurité publique : proximité, SDQ, accueil, police-secours.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "DNSP — Espace public",
    question:
        "Au titre de la protection de l’espace public, la DNSP est en charge :",
    options: [
      "De la sécurité routière et de la sécurisation des transports en commun (coordination nationale)",
      "Uniquement des titres de séjour",
      "Uniquement de la police des jeux",
    ],
    answer:
        "De la sécurité routière et de la sécurisation des transports en commun (coordination nationale)",
    explanation: "DNSP : sécurité routière + transports en commun.",
    difficulty: "Moyen",
  ),

  // =========================
  // DNPAF
  // =========================
  QuizQuestion(
    category: "DNPAF — Frontières",
    question: "La DNPAF veille principalement :",
    options: [
      "Au respect des normes encadrant le contrôle et la surveillance des frontières",
      "À la formation des commissaires",
      "À la discipline interne des services",
    ],
    answer:
        "Au respect des normes encadrant le contrôle et la surveillance des frontières",
    explanation: "PAF : frontières terrestres/maritimes/aériennes.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "DNPAF — Immigration",
    question: "La DNPAF est chef de file (pour la PN) en matière :",
    options: [
      "De traitement procédural des étrangers en situation irrégulière",
      "De maintien de l’ordre (MO)",
      "D’enquêtes IGPN",
    ],
    answer: "De traitement procédural des étrangers en situation irrégulière",
    explanation: "PAF : rôle chef de file sur la chaîne procédurale ESI.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "DNPAF — Éloignement",
    question: "La DNPAF assure notamment :",
    options: [
      "Le suivi de la chaîne de traitement de l’éloignement et la gestion opérationnelle des CRA",
      "La direction des CRS",
      "La direction de la police scientifique",
    ],
    answer:
        "Le suivi de la chaîne de traitement de l’éloignement et la gestion opérationnelle des CRA",
    explanation: "PAF : éloignement + CRA.",
    difficulty: "Moyen",
  ),

  // =========================
  // DNRT
  // =========================
  QuizQuestion(
    category: "DNRT — Missions",
    question: "Le renseignement territorial vise à :",
    options: [
      "Rechercher, centraliser et analyser des renseignements pour informer l’État (institutionnel, éco, social, ordre public)",
      "Gérer le budget de la police",
      "Contrôler les frontières",
    ],
    answer:
        "Rechercher, centraliser et analyser des renseignements pour informer l’État (institutionnel, éco, social, ordre public)",
    explanation:
        "RT : information au profit des autorités (ordre public, phénomènes violents…).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "DNRT — Prévention",
    question: "Le renseignement territorial contribue :",
    options: [
      "À la prévention du terrorisme, en lien avec les services compétents",
      "À la délivrance des permis de conduire",
      "À la gestion des CRA",
    ],
    answer:
        "À la prévention du terrorisme, en lien avec les services compétents",
    explanation: "RT : prévention, coordination avec autres services.",
    difficulty: "Moyen",
  ),

  // =========================
  // DCCRS / CRS
  // =========================
  QuizQuestion(
    category: "CRS — Organisation",
    question: "La DCCRS a notamment pour mission :",
    options: [
      "D’organiser, contrôler, former et employer les CRS selon les missions",
      "De délivrer des titres administratifs",
      "De conduire les enquêtes administratives SNEAS",
    ],
    answer:
        "D’organiser, contrôler, former et employer les CRS selon les missions",
    explanation: "DCCRS : autorité sur CRS + emploi en fonction des missions.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CRS — Spécialité",
    question: "Les CRS sont des unités mobiles spécialisées notamment dans :",
    options: [
      "Le maintien et le rétablissement de l’ordre public",
      "La police aux frontières",
      "La police judiciaire spécialisée cyber",
    ],
    answer: "Le maintien et le rétablissement de l’ordre public",
    explanation: "CRS : MO + renfort + voies de communication, etc.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CRS — Emploi",
    question: "Les CRS peuvent être employées à des gardes statiques :",
    options: [
      "Sur ordre du ministre chargé de l’Intérieur, et jamais de façon permanente",
      "Uniquement sur ordre du maire",
      "Uniquement sur décision du procureur",
    ],
    answer:
        "Sur ordre du ministre chargé de l’Intérieur, et jamais de façon permanente",
    explanation: "Principe : pas de gardes statiques permanentes.",
    difficulty: "Difficile",
  ),

  // =========================
  // ADP (FORMATION)
  // =========================
  QuizQuestion(
    category: "Académie de Police — Formation",
    question: "L’Académie de Police est chargée :",
    options: [
      "Du recrutement et de la formation de la Police nationale",
      "Du contrôle des frontières",
      "De la production des statistiques publiques",
    ],
    answer: "Du recrutement et de la formation de la Police nationale",
    explanation: "ADP : recrutement + formation initiale et continue.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Académie de Police — Recherche",
    question: "L’Académie de Police est également chargée :",
    options: [
      "Des études et de la recherche de la Police nationale",
      "De la direction des CRS",
      "De la gestion des CRA",
    ],
    answer: "Des études et de la recherche de la Police nationale",
    explanation: "ADP : études/recherche + stratégie de formation.",
    difficulty: "Moyen",
  ),

  // =========================
  // SDLP
  // =========================
  QuizQuestion(
    category: "SDLP — Protection",
    question: "Le SDLP assure principalement :",
    options: [
      "Des missions de protection rapprochée et d’accompagnement de sécurité",
      "La police judiciaire",
      "Le renseignement territorial",
    ],
    answer:
        "Des missions de protection rapprochée et d’accompagnement de sécurité",
    explanation: "SDLP : protection de personnes et dispositifs de sûreté.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "SDLP — Événements",
    question: "Le SDLP contribue notamment à la sécurité :",
    options: [
      "Des hautes personnalités, événements et manifestations de grande ampleur",
      "Des titres de séjour",
      "Des CRA",
    ],
    answer:
        "Des hautes personnalités, événements et manifestations de grande ampleur",
    explanation: "Protection et sécurisation des déplacements/événements.",
    difficulty: "Moyen",
  ),

  // =========================
  // SNPS
  // =========================
  QuizQuestion(
    category: "SNPS — Missions",
    question: "Le SNPS a pour mission :",
    options: [
      "De définir et coordonner la politique de police scientifique sur le territoire national",
      "De coordonner les expulsions",
      "De diriger les CRS",
    ],
    answer:
        "De définir et coordonner la politique de police scientifique sur le territoire national",
    explanation: "SNPS : doctrine/coordination PTS + représentation.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "SNPS — Expertise",
    question: "Le SNPS peut réaliser :",
    options: [
      "Des examens, constatations, expertises et analyses scientifiques demandés par l’autorité judiciaire ou les enquêteurs",
      "Des décisions de justice",
      "Des mesures disciplinaires IGPN",
    ],
    answer:
        "Des examens, constatations, expertises et analyses scientifiques demandés par l’autorité judiciaire ou les enquêteurs",
    explanation:
        "La police scientifique intervient sur réquisitions/demandes judiciaires.",
    difficulty: "Moyen",
  ),

  // =========================
  // RAID
  // =========================
  QuizQuestion(
    category: "RAID — Missions",
    question: "Le RAID intervient notamment :",
    options: [
      "Dans la prévention/répression de la criminalité organisée et du terrorisme",
      "Dans la délivrance des passeports",
      "Dans la gestion budgétaire de la PN",
    ],
    answer:
        "Dans la prévention/répression de la criminalité organisée et du terrorisme",
    explanation: "RAID : intervention spécialisée.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "RAID — Appui",
    question: "Le RAID peut prêter assistance :",
    options: [
      "Aux services de police (appui opérationnel et techniques spécifiques)",
      "Uniquement aux services municipaux",
      "Uniquement aux douanes",
    ],
    answer:
        "Aux services de police (appui opérationnel et techniques spécifiques)",
    explanation:
        "RAID : assistance aux services, matériels spécialisés, formation.",
    difficulty: "Moyen",
  ),

  // =========================
  // ANFSI / NUMÉRIQUE
  // =========================
  QuizQuestion(
    category: "ANFSI — Numérique",
    question: "L’ANFSI est chargée :",
    options: [
      "Du développement, de la mise en œuvre et de la sécurité des systèmes d’information des FSI",
      "Du contrôle de l’immigration",
      "De la discipline interne des services",
    ],
    answer:
        "Du développement, de la mise en œuvre et de la sécurité des systèmes d’information des FSI",
    explanation:
        "ANFSI : SI, équipements, sécurité, convergence Police/Gendarmerie si pertinent.",
    difficulty: "Moyen",
  ),

  // =========================
  // SNEAS / SNEAV
  // =========================
  QuizQuestion(
    category: "SNEAS — Enquêtes administratives",
    question: "Le SNEAS réalise :",
    options: [
      "Des enquêtes administratives de sécurité (compatibilité comportement / autorisations sensibles)",
      "Des expertises balistiques",
      "Des enquêtes de maintien de l’ordre",
    ],
    answer:
        "Des enquêtes administratives de sécurité (compatibilité comportement / autorisations sensibles)",
    explanation:
        "SNEAS : prévention terrorisme + atteintes sécurité/ordre public/sûreté de l’État.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "SNEAV — Autorisation de voyage",
    question: "Le SNEAV intervient :",
    options: [
      "Dans l’examen des demandes d’autorisation de voyage lorsque le traitement manuel est engagé",
      "Dans la formation des gardiens de la paix",
      "Dans les enquêtes IGPN",
    ],
    answer:
        "Dans l’examen des demandes d’autorisation de voyage lorsque le traitement manuel est engagé",
    explanation:
        "SNEAV : traitement et décision sur certaines demandes après contrôle.",
    difficulty: "Moyen",
  ),

  // =========================
  // DCIS / COOP
  // =========================
  QuizQuestion(
    category: "DCIS — Coopération",
    question: "La DCIS :",
    options: [
      "Dirige le réseau des attachés de sécurité intérieure",
      "Dirige les CRS",
      "Dirige les CRA",
    ],
    answer: "Dirige le réseau des attachés de sécurité intérieure",
    explanation:
        "DCIS : réseau ASI + coordination coopérations Police/Gendarmerie.",
    difficulty: "Moyen",
  ),

  // =========================
  // SSMSI
  // =========================
  QuizQuestion(
    category: "SSMSI — Statistique publique",
    question: "Le SSMSI :",
    options: [
      "Produit et diffuse la statistique publique en matière de sécurité intérieure",
      "Assure la protection rapprochée",
      "Conduit les opérations d’intervention",
    ],
    answer:
        "Produit et diffuse la statistique publique en matière de sécurité intérieure",
    explanation:
        "SSMSI : données, études, enquêtes, pilotage des politiques de sécurité.",
    difficulty: "Moyen",
  ),

  // =========================
  // DRHFS (gros bloc RH / finances / soutiens)
  // =========================
  QuizQuestion(
    category: "DRHFS — Missions",
    question: "La DRHFS définit notamment :",
    options: [
      "Les principes de gestion des personnels et l’organisation des carrières",
      "La politique de contrôle des frontières",
      "La stratégie d’intervention RAID",
    ],
    answer:
        "Les principes de gestion des personnels et l’organisation des carrières",
    explanation: "DRHFS : gestion RH, textes, carrières, parcours.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "DRHFS — Recrutement",
    question: "Concernant le recrutement des personnels contractuels :",
    options: [
      "La DRHFS recrute pour la PN, sauf la DGSI qui recrute pour son propre compte",
      "La DRHFS recrute uniquement pour la DGSI",
      "La DRHFS ne recrute jamais de contractuels",
    ],
    answer:
        "La DRHFS recrute pour la PN, sauf la DGSI qui recrute pour son propre compte",
    explanation: "Exception : DGSI gère son recrutement contractuel.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "DRHFS — Action sociale",
    question: "La DRHFS conduit notamment :",
    options: [
      "La politique ministérielle d’action sociale du logement et de l’enfance",
      "La coopération internationale",
      "Les enquêtes judiciaires PJ",
    ],
    answer:
        "La politique ministérielle d’action sociale du logement et de l’enfance",
    explanation: "DRHFS : prévention, accompagnement et action sociale.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "DRHFS — Budget",
    question: "La DRHFS :",
    options: [
      "Participe à l’élaboration et à l’exécution du budget concernant la PN",
      "Valide les décisions de justice",
      "Dirige l’IGPN",
    ],
    answer:
        "Participe à l’élaboration et à l’exécution du budget concernant la PN",
    explanation: "Répartition des moyens financiers et suivi de l’utilisation.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "DRHFS — Temps de travail",
    question: "La DRHFS est notamment chargée :",
    options: [
      "De définir et mettre en œuvre la réglementation liée au temps de travail",
      "De délivrer les visas",
      "De coordonner l’ETIAS européen",
    ],
    answer:
        "De définir et mettre en œuvre la réglementation liée au temps de travail",
    explanation: "Temps de travail : volet support/RH.",
    difficulty: "Moyen",
  ),

  // =========================
  // DGSI (structure + missions)
  // =========================
  QuizQuestion(
    category: "DGSI — Définition",
    question: "La DGSI est chargée :",
    options: [
      "De rechercher, centraliser et exploiter le renseignement intéressant la sécurité nationale",
      "De contrôler les frontières (mission principale)",
      "De réaliser les statistiques de sécurité intérieure",
    ],
    answer:
        "De rechercher, centraliser et exploiter le renseignement intéressant la sécurité nationale",
    explanation:
        "DGSI : renseignement sécurité nationale / intérêts fondamentaux.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "DGSI — Organisation",
    question: "Parmi les composantes de la DGSI, on retrouve notamment :",
    options: [
      "Direction du renseignement et des opérations, Direction technique, Administration générale, Inspection générale",
      "DCCRS, DNPAF, SSMSI, DCIS",
      "ENSP, CRA, OPJ, APJA",
    ],
    answer:
        "Direction du renseignement et des opérations, Direction technique, Administration générale, Inspection générale",
    explanation:
        "Structuration interne DGSI (direction/tech/admin/inspection).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "DGSI — Police judiciaire",
    question: "La DGSI peut concourir :",
    options: [
      "À l’exercice des missions de police judiciaire dans ses domaines de compétence",
      "Uniquement à la sécurité routière",
      "Uniquement à la gestion des ressources humaines",
    ],
    answer:
        "À l’exercice des missions de police judiciaire dans ses domaines de compétence",
    explanation:
        "DGSI : PJ possible dans ses champs (terrorisme, ingérence, etc.).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "DGSI — Ingérence",
    question: "La DGSI assure notamment :",
    options: [
      "La prévention et la répression de toute forme d’ingérence étrangère",
      "La gestion des centres de rétention",
      "La formation des CRS",
    ],
    answer:
        "La prévention et la répression de toute forme d’ingérence étrangère",
    explanation: "Ingérence : un pilier DGSI.",
    difficulty: "Moyen",
  ),

  // =========================
  // PP (Préfecture de Police) — rôle/organisation
  // =========================
  QuizQuestion(
    category: "PP — Rôle",
    question: "À Paris, le préfet de police est :",
    options: [
      "Un haut fonctionnaire nommé en Conseil des ministres",
      "Un magistrat élu par les policiers",
      "Un officier général des armées",
    ],
    answer: "Un haut fonctionnaire nommé en Conseil des ministres",
    explanation: "PP : préfet de police nommé en Conseil des ministres.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "PP — Missions",
    question: "Parmi les attributions de la PP :",
    options: [
      "Sécurité des personnes et des biens, sécurité civile, circulation, titres administratifs",
      "Uniquement la PJ spécialisée",
      "Uniquement le renseignement territorial",
    ],
    answer:
        "Sécurité des personnes et des biens, sécurité civile, circulation, titres administratifs",
    explanation: "PP : bloc large (ordre public, titres, circulation, etc.).",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "PP — Organisation",
    question: "Parmi les services actifs de la PP, on retrouve notamment :",
    options: [
      "DOPC, direction PJ, direction du renseignement, sécurité de proximité",
      "DRHFS, SSMSI, ANFSI",
      "SNEAV, SNEAS, DCIS",
    ],
    answer:
        "DOPC, direction PJ, direction du renseignement, sécurité de proximité",
    explanation:
        "PP : directions actives (ordre public/circulation, PJ, renseignement...).",
    difficulty: "Difficile",
  ),

  // =========================
  // DTPN (Outre-mer) — spécifique
  // =========================
  QuizQuestion(
    category: "Organisation PN — Outre-mer (DTPN)",
    question: "Dans certains territoires ultramarins, les DTPN :",
    options: [
      "Se substituent aux directions de la PN et assurent une direction de police unique",
      "Remplacent la gendarmerie",
      "Sont uniquement des centres de formation",
    ],
    answer:
        "Se substituent aux directions de la PN et assurent une direction de police unique",
    explanation:
        "DTPN : direction unique regroupant plusieurs missions sur un territoire.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Organisation PN — Outre-mer (DTPN)",
    question: "Une DTPN peut regrouper (selon ressort) :",
    options: [
      "PJ, PAF, SP, RT, recrutement/formation et parfois une antenne RAID",
      "Uniquement la police municipale",
      "Uniquement les CRS",
    ],
    answer:
        "PJ, PAF, SP, RT, recrutement/formation et parfois une antenne RAID",
    explanation: "DTPN = organisation intégrée multi-filières.",
    difficulty: "Difficile",
  ),

  // =========================
  // ORGANIGRAMMES / LECTURE
  // =========================
  QuizQuestion(
    category: "Organigrammes — Lecture",
    question:
        "Sur ta page “Organigramme MI (tableau)”, chaque colonne correspond :",
    options: [
      "À un grand bloc de l’organigramme",
      "À un article de loi",
      "À une région administrative",
    ],
    answer: "À un grand bloc de l’organigramme",
    explanation: "Aide à la lecture : colonnes = grands blocs.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organigrammes — Manipulation",
    question: "Pour lire tout le tableau de l’organigramme, il faut :",
    options: [
      "Glisser horizontalement et verticalement",
      "Faire uniquement un scroll vertical",
      "Appuyer longuement sur le titre",
    ],
    answer: "Glisser horizontalement et verticalement",
    explanation: "Ton UI indique swipe horizontal + vertical.",
    difficulty: "Facile",
  ),

  // =========================
  // HIÉRARCHIE / CORPS (rappels)
  // =========================
  QuizQuestion(
    category: "Hiérarchie PN — Corps actifs",
    question: "Quels sont les 3 grands corps des services actifs ?",
    options: [
      "Conception & direction / Commandement / Encadrement & application",
      "Administratifs / Scientifiques / Municipaux",
      "Douanes / Armée / Justice",
    ],
    answer: "Conception & direction / Commandement / Encadrement & application",
    explanation: "Les 3 grands corps des actifs : CCD, CC, CEA.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Hiérarchie PN — Commissaires",
    question: "Le corps de conception et de direction comprend notamment :",
    options: [
      "Commissaire général, commissaire divisionnaire, commissaire",
      "Capitaine, commandant, commandant divisionnaire",
      "Major, brigadier-chef, gardien",
    ],
    answer: "Commissaire général, commissaire divisionnaire, commissaire",
    explanation: "CCD : grades commissaires.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Hiérarchie PN — Officiers",
    question: "Le corps de commandement comprend notamment :",
    options: [
      "Commandant divisionnaire, commandant, capitaine",
      "Commissaire général, commissaire, commissaire divisionnaire",
      "Major, brigadier-chef, gardien",
    ],
    answer: "Commandant divisionnaire, commandant, capitaine",
    explanation: "CC : grades officiers.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Hiérarchie PN — CEA",
    question:
        "Dans le CEA, l’encadrement des gardiens/PA/réserve est assuré notamment par :",
    options: [
      "Les majors et brigadiers-chefs",
      "Les attachés d’administration",
      "Les ingénieurs SIC",
    ],
    answer: "Les majors et brigadiers-chefs",
    explanation: "CEA : encadrement de proximité par gradés.",
    difficulty: "Moyen",
  ),

  // =========================
  // SERVICES SPÉCIALISÉS (NOTA 1)
  // =========================
  QuizQuestion(
    category: "Organisation PN — Services spécialisés (NOTA)",
    question:
        "Parmi les services spécialisés rattachés à la DGPN, on retrouve notamment :",
    options: [
      "SICoP, DAV, SHPN, ANDV",
      "DNPAF, DCCRS, DNSP, DNPJ",
      "SNEAS, SNEAV, SSMSI, DCIS",
    ],
    answer: "SICoP, DAV, SHPN, ANDV",
    explanation:
        "NOTA : services spécialisés directement rattachés (dans ton contenu).",
    difficulty: "Difficile",
  ),

  // =========================
  // QUESTIONS “PIÈGES” / DISTINCTIONS
  // =========================
  QuizQuestion(
    category: "Organisation PN — Distinctions",
    question:
        "Quelle structure est principalement orientée “renseignement sécurité nationale” ?",
    options: ["DGSI", "DNSP", "DCCRS"],
    answer: "DGSI",
    explanation:
        "DGSI : renseignement sécurité nationale / intérêts fondamentaux.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Distinctions",
    question:
        "Quelle direction est le plus directement orientée “frontières / immigration irrégulière” ?",
    options: ["DNPAF", "DNPJ", "SSMSI"],
    answer: "DNPAF",
    explanation: "PAF : frontières + lutte immigration irrégulière.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Distinctions",
    question:
        "Quelle direction est spécialisée “ordre public” via unités mobiles ?",
    options: ["DCCRS", "DNPJ", "DRHFS"],
    answer: "DCCRS",
    explanation: "CRS = maintien/rétablissement de l’ordre public.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation PN — Distinctions",
    question:
        "Quel service est orienté “statistique publique” en sécurité intérieure ?",
    options: ["SSMSI", "SDLP", "SNPS"],
    answer: "SSMSI",
    explanation:
        "SSMSI : produit les statistiques publiques de sécurité intérieure.",
    difficulty: "Facile",
  ),

  // =========================
  // LOT “RÉVISION RAPIDE” (QCM courts)
  // =========================
  QuizQuestion(
    category: "Révision rapide — Sigles",
    question: "Quel sigle correspond à la Police scientifique ?",
    options: ["SNPS", "SDLP", "SNEAV"],
    answer: "SNPS",
    explanation: "SNPS = Service national de Police scientifique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Révision rapide — Sigles",
    question: "Quel sigle correspond au Service de la protection ?",
    options: ["SDLP", "SSMSI", "DNRT"],
    answer: "SDLP",
    explanation: "SDLP = Service de la protection.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Révision rapide — Sigles",
    question: "Quel sigle correspond au Renseignement territorial ?",
    options: ["DNRT", "DNPJ", "DNPAF"],
    answer: "DNRT",
    explanation: "DNRT = Direction nationale du Renseignement territorial.",
    difficulty: "Facile",
  ),

  // =========================
  // BONUS — QUESTIONS “STRUCTURE DGSI” (ciblées page DGSI)
  // =========================
  QuizQuestion(
    category: "DGSI — Organisation interne",
    question: "La DGSI comporte notamment :",
    options: [
      "Une direction technique",
      "Une direction des visas",
      "Une direction des CRA",
    ],
    answer: "Une direction technique",
    explanation: "Dans ton contenu : direction technique = un des blocs DGSI.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "DGSI — Coordination",
    question: "La DGSI est “chef de file” surtout dans :",
    options: [
      "La lutte contre les menaces terroristes visant le territoire national",
      "La sécurité routière nationale",
      "La production statistique publique",
    ],
    answer:
        "La lutte contre les menaces terroristes visant le territoire national",
    explanation:
        "Chef de file anti-terroriste sur le territoire national (dans ton texte).",
    difficulty: "Moyen",
  ),

  // =========================
  // DERNIER LOT — “MÉGA” (tu peux en dupliquer facilement)
  // =========================
  QuizQuestion(
    category: "Organisation PN — Chaînes",
    question:
        "Qui “définit les objectifs et anime l’action” des services PJ de sa filière ?",
    options: ["La DNPJ", "La DRHFS", "Le SSMSI"],
    answer: "La DNPJ",
    explanation:
        "Dans ton contenu : la DNPJ anime l’action des services PJ relevant de sa filière.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Chaînes",
    question:
        "Qui “définit les objectifs et anime l’action” en sécurité/ordre public dans les communes étatisées ?",
    options: ["La DNSP", "La DNPAF", "La DCIS"],
    answer: "La DNSP",
    explanation: "Sécurité publique : communes à police étatisée.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Organisation PN — Chaînes",
    question:
        "Qui organise et coordonne les moyens aériens et maritimes de la PN (frontières) ?",
    options: ["La DNPAF", "La DCCRS", "La DNPJ"],
    answer: "La DNPAF",
    explanation:
        "DNPAF : doctrines/réglementation et coordination moyens aériens/maritimes (dans ton texte).",
    difficulty: "Difficile",
  ),
];

class QuizOrganisationPnGPX extends StatefulWidget {
  static const String routeName = '/gpx/institution/organisation_pn/quiz';
  final String uid;
  final String email;

  const QuizOrganisationPnGPX({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizOrganisationPnGPX> createState() => _QuizOrganisationPnGPXState();
}

class _QuizOrganisationPnGPXState extends State<QuizOrganisationPnGPX>
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

    final pool = useAll
        ? questionOrganisationPN
        : questionOrganisationPN
              .where((q) => q.difficulty == _selectedDifficulty)
              .toList();

    _qs = List<QuizQuestion>.from(pool);
    _qs.shuffle(_rng);

    // ✅ Options = List<String>
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
            'module_name': 'Organisation de la Police Nationale',
            'quiz_name': 'Quiz- Organisation de la Police Nationale',
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
      await _sb.from('quiz_organisation_pn').insert({
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
      debugPrint('❌ quiz_organisation_pn insert failed: $e');
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? Colors.white : _Brand.textDark;

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

          // ✅ Image de la question (galon / grade)
          if (question.questionImageAsset != null &&
              question.questionImageAsset!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                height: 160,
                padding: const EdgeInsets.all(12),
                color: isDark
                    ? Colors.white.withAlpha(18)
                    : const Color(0xFFF2F3F6),
                child: Image.asset(
                  question.questionImageAsset!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ✅ Options (String)
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

  // ✅ nouveau : image optionnelle
  final String? assetImage;

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
    this.assetImage,
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

    Widget? thumb() {
      if (assetImage == null || assetImage!.isEmpty) return null;

      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 54,
          height: 54,
          padding: const EdgeInsets.all(6),
          color: isDark ? Colors.white.withAlpha(18) : const Color(0xFFF2F3F6),
          child: Image.asset(assetImage!, fit: BoxFit.contain),
        ),
      );
    }

    final t = thumb();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              dot(selected || correct || wrong),
              const SizedBox(width: 14),

              if (t != null) ...[t, const SizedBox(width: 12)],

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
