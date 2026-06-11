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

final List<QuizQuestion> questionArmesMunitions = [
  // =========================
  // THÈME 1 — Classification (R.311-2 CSI) : Catégorie A (A1/A2)
  // =========================
  const QuizQuestion(
    category: "Classification — Catégorie A1 (1°)",
    question: "Relève de la catégorie A1 (1°) :",
    options: [
      "Une arme à feu camouflée sous la forme d'un autre objet",
      "Une arme d'alarme et de signalisation",
      "Un générateur lacrymogène de 50 ml",
    ],
    answer: "Une arme à feu camouflée sous la forme d'un autre objet",
    explanation: "R.311-2 CSI, Cat. A1 1° : armes à feu camouflées.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A1 (2°)",
    question:
        "Une arme de poing permettant de tirer plus de 21 munitions sans réapprovisionnement (chargeur > 20) est :",
    options: ["Catégorie A1", "Catégorie B", "Catégorie C"],
    answer: "Catégorie A1",
    explanation:
        "R.311-2 CSI, Cat. A1 2° : arme de poing + système d'alimentation > 20 cartouches.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A1",
    question:
        "Une arme à feu camouflée sous l'apparence d'un autre objet est classée :",
    options: ["Catégorie A1", "Catégorie B", "Catégorie D"],
    answer: "Catégorie A1",
    explanation:
        "Article R.311-2 CSI : les armes à feu camouflées relèvent de la catégorie A1.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1",
    question:
        "Une arme de poing capable de tirer plus de 21 munitions sans réapprovisionnement est classée :",
    options: ["Catégorie A1", "Catégorie B", "Catégorie C"],
    answer: "Catégorie A1",
    explanation:
        "R.311-2 CSI A1 2° : arme de poing avec système d’alimentation supérieur à 20 cartouches.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1",
    question:
        "Une arme d’épaule semi-automatique à percussion centrale tirant plus de 11 coups sans recharger est :",
    options: ["Catégorie A1", "Catégorie B", "Catégorie C"],
    answer: "Catégorie A1",
    explanation:
        "Catégorie A1 3° bis : semi-automatique à percussion centrale avec chargeur > 10 coups.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1",
    question:
        "Les armes d’épaule semi-automatiques alimentées par bande sont classées :",
    options: [
      "Catégorie A1 quelle que soit la capacité",
      "Catégorie B si bande inférieure à 10 coups",
      "Catégorie C si bande limitée",
    ],
    answer: "Catégorie A1 quelle que soit la capacité",
    explanation:
        "R.311-2 CSI A1 3° ter : toute alimentation par bande relève de la catégorie A1.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A2",
    question:
        "Les armes à feu automatiques et dispositifs permettant le tir en rafale sont classés :",
    options: ["Catégorie A2", "Catégorie A1", "Catégorie B"],
    answer: "Catégorie A2",
    explanation:
        "R.311-2 CSI A2 1° : armes automatiques et dispositifs assimilables au tir en rafale.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A2",
    question:
        "Les munitions à projectiles perforants, explosifs ou incendiaires relèvent de :",
    options: ["Catégorie A2", "Catégorie B", "Catégorie D"],
    answer: "Catégorie A2",
    explanation:
        "Catégorie A2 2° : munitions perforantes, explosives ou incendiaires.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B",
    question: "Une arme à feu de poing non classée ailleurs relève de :",
    options: ["Catégorie B", "Catégorie C", "Catégorie D"],
    answer: "Catégorie B",
    explanation: "R.311-2 CSI B 1° : armes de poing.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B",
    question:
        "Une arme d’épaule semi-automatique à percussion centrale avec une capacité supérieure à 3 coups est :",
    options: ["Catégorie B", "Catégorie C", "Catégorie A1"],
    answer: "Catégorie B",
    explanation:
        "Catégorie B 2° a : semi-automatique à percussion centrale > 3 coups et ≤ 11 coups.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B",
    question: "Une arme chambrant le calibre 5,56x45 est classée :",
    options: ["Catégorie B", "Catégorie C", "Catégorie A1"],
    answer: "Catégorie B",
    explanation: "R.311-2 CSI B 4° : calibres listés dont 5,56x45.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie C",
    question:
        "Une arme d’épaule semi-automatique avec chargeur inamovible limité à 3 coups est :",
    options: ["Catégorie C", "Catégorie B", "Catégorie D"],
    answer: "Catégorie C",
    explanation:
        "R.311-2 CSI C 1° a : semi-automatique avec alimentation inamovible ≤ 3 coups.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie C",
    question:
        "Une arme non pyrotechnique développant une énergie à la bouche de 25 joules est classée :",
    options: ["Catégorie C", "Catégorie D", "Non classée"],
    answer: "Catégorie C",
    explanation: "Catégorie C 4° : énergie ≥ 20 joules.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie D",
    question: "Un générateur d’aérosol lacrymogène de 75 ml est classé :",
    options: ["Catégorie D", "Catégorie B", "Catégorie C"],
    answer: "Catégorie D",
    explanation: "Catégorie D b : aérosols ≤ 100 ml.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Code pénal",
    question: "Selon l’article 132-75 du Code pénal, une arme par nature est :",
    options: [
      "Un objet conçu pour tuer ou blesser",
      "Un objet utilisé pour se défendre",
      "Un objet dissimulable",
    ],
    answer: "Un objet conçu pour tuer ou blesser",
    explanation: "CP art. 132-75 al.1 : arme par nature.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Code pénal",
    question: "Un objet devient une arme par destination lorsqu’il est :",
    options: [
      "Utilisé ou destiné à tuer, blesser ou menacer",
      "Transporté sans motif légitime",
      "Métallique",
    ],
    answer: "Utilisé ou destiné à tuer, blesser ou menacer",
    explanation: "CP art. 132-75 al.2 : arme par usage ou destination.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Code de la sécurité intérieure",
    question: "Une arme à répétition semi-automatique est une arme qui :",
    options: [
      "Se recharge automatiquement et tire un seul coup par pression",
      "Tire une rafale par pression",
      "Doit être rechargée manuellement",
    ],
    answer: "Se recharge automatiquement et tire un seul coup par pression",
    explanation: "R.311-1 CSI 8° : définition de l’arme semi-automatique.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Port et transport — Définition",
    question: "Le port d’arme correspond au fait de :",
    options: [
      "Avoir une arme sur soi utilisable immédiatement",
      "Transporter une arme déchargée dans un coffre",
      "Détenir une arme à domicile",
    ],
    answer: "Avoir une arme sur soi utilisable immédiatement",
    explanation: "R.311-1 CSI : définition du port d’arme.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Port et transport — Définition",
    question: "Le transport d’arme correspond au fait de :",
    options: [
      "Déplacer une arme inutilisable immédiatement",
      "Avoir une arme chargée sur soi",
      "Conserver une arme chez soi",
    ],
    answer: "Déplacer une arme inutilisable immédiatement",
    explanation: "R.311-1 CSI : définition du transport.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — Acquisition et détention",
    question:
        "L’acquisition ou la détention sans autorisation d’une arme de catégorie B constitue :",
    options: ["Un délit", "Une contravention", "Une infraction administrative"],
    answer: "Un délit",
    explanation: "Article 222-52 du Code pénal.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — Répression",
    question:
        "La peine encourue pour détention illégale d’une arme de catégorie A ou B est de :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "1 an d’emprisonnement et 15 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Article 222-52 al.1 du Code pénal.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Infractions — Port et transport",
    question: "Porter sans motif légitime une arme de catégorie C constitue :",
    options: ["Un délit", "Une contravention", "Un fait non réprimé"],
    answer: "Un délit",
    explanation: "Article L.317-8 du Code de la sécurité intérieure.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Mineurs — Règle générale",
    question:
        "Le principe pour les mineurs concernant la détention d’armes est :",
    options: [
      "L’interdiction avec exceptions prévues par la loi",
      "La liberté en catégorie D",
      "L’autorisation parentale suffit toujours",
    ],
    answer: "L’interdiction avec exceptions prévues par la loi",
    explanation: "Article L.312-1 CSI : interdiction de principe.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A1 (2°)",
    question:
        "Une arme de poing devient A1 lorsqu’elle permet le tir de plus de 21 munitions sans réapprovisionnement si :",
    options: [
      "Un système d’alimentation > 20 cartouches fait partie intégrante de l’arme ou a été inséré",
      "L’arme est en calibre inférieur à 20 mm",
      "L’arme est utilisée uniquement au stand",
    ],
    answer:
        "Un système d’alimentation > 20 cartouches fait partie intégrante de l’arme ou a été inséré",
    explanation:
        "R.311-2 CSI, A1 2° : critère = capacité > 20 du système d’alimentation (intégré ou inséré).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1 (3°)",
    question:
        "Une arme d’épaule semi-automatique à percussion annulaire est classée A1 si elle permet de tirer :",
    options: [
      "Plus de 31 munitions sans réapprovisionnement avec un chargeur > 30 intégré ou inséré",
      "Plus de 11 munitions sans réapprovisionnement quel que soit le chargeur",
      "Plus de 3 munitions sans réapprovisionnement avec chargeur inamovible",
    ],
    answer:
        "Plus de 31 munitions sans réapprovisionnement avec un chargeur > 30 intégré ou inséré",
    explanation:
        "R.311-2 CSI, A1 3° : annulaire semi-auto + > 31 si chargeur > 30 (intégré/inséré).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1 (3° bis)",
    question:
        "Une arme d’épaule semi-automatique à percussion centrale bascule en A1 si :",
    options: [
      "Un chargeur > 10 fait partie intégrante de l’arme ou a été inséré",
      "Elle a une capacité maximale de 3 coups",
      "Elle est à un coup par canon",
    ],
    answer: "Un chargeur > 10 fait partie intégrante de l’arme ou a été inséré",
    explanation: "R.311-2 CSI, A1 3° bis : centrale semi-auto + chargeur > 10.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1 (3° ter)",
    question: "Une arme d’épaule semi-automatique alimentée par bande est :",
    options: [
      "Toujours classée A1, quelle que soit la capacité",
      "Classée B si la bande est limitée à 10",
      "Classée C si elle est déclarée",
    ],
    answer: "Toujours classée A1, quelle que soit la capacité",
    explanation:
        "R.311-2 CSI, A1 3° ter : alimentation par bande = A1 sans condition de capacité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1 (3° quater)",
    question:
        "Une arme d’épaule à répétition manuelle peut être classée A1 lorsqu’elle :",
    options: [
      "Permet le tir de plus de 31 munitions avec chargeur > 30 intégré ou inséré",
      "Est limitée à 11 munitions",
      "Est à canon lisse ≤ 60 cm",
    ],
    answer:
        "Permet le tir de plus de 31 munitions avec chargeur > 30 intégré ou inséré",
    explanation:
        "R.311-2 CSI, A1 3° quater : répétition manuelle + > 31 si chargeur > 30.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1 (4°)",
    question: "Relève en principe de la catégorie A1 :",
    options: [
      "Une arme à feu à canon rayé dont le projectile a un diamètre ≥ 20 mm (sauf exception non métallique)",
      "Une arme non pyrotechnique de 18 joules",
      "Une arme d’alarme et de signalisation",
    ],
    answer:
        "Une arme à feu à canon rayé dont le projectile a un diamètre ≥ 20 mm (sauf exception non métallique)",
    explanation:
        "R.311-2 CSI, A1 4° : diamètre projectile ≥ 20 mm, exception si uniquement projectiles non métalliques.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1 (5°)",
    question: "Relève en principe de la catégorie A1 :",
    options: [
      "Une arme à feu à canon lisse et ses munitions d’un calibre supérieur au calibre 8 (hors exclusions)",
      "Un aérosol lacrymogène de 100 ml",
      "Une arme factice < 2 joules",
    ],
    answer:
        "Une arme à feu à canon lisse et ses munitions d’un calibre supérieur au calibre 8 (hors exclusions)",
    explanation:
        "R.311-2 CSI, A1 5° : canon lisse > calibre 8, sauf armes classées C/D par arrêté conjoint.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1 (6°)",
    question: "Les munitions dont le projectile est ≥ 20 mm sont classées :",
    options: [
      "A1, à l’exception de celles utilisées par des armes classées en catégorie C",
      "Toujours B",
      "Toujours D",
    ],
    answer:
        "A1, à l’exception de celles utilisées par des armes classées en catégorie C",
    explanation:
        "R.311-2 CSI, A1 6° : projectile ≥ 20 mm, exception munitions d’armes de catégorie C.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1 (8°)",
    question: "Quel système d’alimentation relève de la catégorie A1 ?",
    options: [
      "Un chargeur d’arme de poing contenant plus de 20 munitions",
      "Un chargeur d’arme de poing contenant 17 munitions",
      "Un chargeur d’épaule annulaire contenant 25 munitions",
    ],
    answer: "Un chargeur d’arme de poing contenant plus de 20 munitions",
    explanation:
        "R.311-2 CSI, A1 8° : système d’alimentation d’arme de poing > 20 munitions.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1 (9°)",
    question: "Quel système d’alimentation relève de la catégorie A1 (9°) ?",
    options: [
      "Un chargeur d’arme d’épaule à percussion annulaire contenant plus de 30 munitions",
      "Un chargeur d’épaule à percussion annulaire contenant 10 munitions",
      "Un réservoir de paintball",
    ],
    answer:
        "Un chargeur d’arme d’épaule à percussion annulaire contenant plus de 30 munitions",
    explanation: "R.311-2 CSI, A1 9° : annulaire épaule > 30.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1 (9° bis)",
    question:
        "Quel système d’alimentation relève de la catégorie A1 (9° bis) ?",
    options: [
      "Un chargeur d’arme d’épaule semi-automatique à percussion centrale contenant plus de 10 munitions",
      "Un chargeur d’arme d’épaule à répétition manuelle contenant 8 munitions",
      "Un chargeur d’arme de poing contenant 10 munitions",
    ],
    answer:
        "Un chargeur d’arme d’épaule semi-automatique à percussion centrale contenant plus de 10 munitions",
    explanation:
        "R.311-2 CSI, A1 9° bis : épaule semi-auto percussion centrale > 10.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1 (11°)",
    question:
        "Une arme à répétition automatique transformée en semi-automatique, manuelle ou à un coup est :",
    options: [
      "Classée A1",
      "Reclassée automatiquement en B",
      "Reclassée automatiquement en C",
    ],
    answer: "Classée A1",
    explanation:
        "R.311-2 CSI, A1 11° : les armes automatiques transformées restent classées A1.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1 (12°)",
    question:
        "Une arme d’épaule semi-automatique dont la longueur peut être réduite à moins de 60 cm (crosse repliable/télescopique/démontable sans outil) est :",
    options: ["Catégorie A1", "Catégorie B", "Catégorie C"],
    answer: "Catégorie A1",
    explanation:
        "R.311-2 CSI, A1 12° : réduction < 60 cm sans perte de fonctionnalité.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A2 (1°)",
    question: "Relève de la catégorie A2 :",
    options: [
      "Une arme automatique et tout dispositif additionnel permettant le tir en rafale",
      "Une arme à un coup",
      "Une arme d’alarme non transformable",
    ],
    answer:
        "Une arme automatique et tout dispositif additionnel permettant le tir en rafale",
    explanation:
        "R.311-2 CSI, A2 1° : armes automatiques + dispositifs assimilables au tir en rafale.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A2 (2°)",
    question: "Relèvent de la catégorie A2 :",
    options: [
      "Les munitions à projectiles perforants, explosifs ou incendiaires",
      "Les munitions de signalisation",
      "Les douilles amorcées",
    ],
    answer: "Les munitions à projectiles perforants, explosifs ou incendiaires",
    explanation:
        "R.311-2 CSI, A2 2° : munitions perforantes/explosives/incendiaires.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B (2° c)",
    question: "Une arme d’épaule est classée en catégorie B si :",
    options: [
      "Sa longueur totale minimale est ≤ 80 cm ou sa longueur de canon ≤ 45 cm",
      "Elle est à un coup par canon",
      "Elle développe 18 joules",
    ],
    answer:
        "Sa longueur totale minimale est ≤ 80 cm ou sa longueur de canon ≤ 45 cm",
    explanation: "R.311-2 CSI, B 2° c : critères de longueur totale/canon.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B (6°)",
    question:
        "Une arme à impulsion électrique permettant de provoquer un choc électrique à distance est classée :",
    options: ["Catégorie B", "Catégorie D", "Catégorie C"],
    answer: "Catégorie B",
    explanation:
        "R.311-2 CSI, B 6° : armes à impulsion électrique à distance + munitions.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B (8°)",
    question:
        "Un générateur d’aérosol lacrymogène d’une capacité de 150 ml est classé :",
    options: ["Catégorie B", "Catégorie D", "Non classé"],
    answer: "Catégorie B",
    explanation:
        "R.311-2 CSI, B 8° : aérosols incapacitants/lacrymogènes > 100 ml.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie C (1° b)",
    question:
        "Une arme d’épaule à répétition manuelle (diamètre projectile < 20 mm) avec un système d’alimentation permettant le tir de 11 munitions au plus est :",
    options: ["Catégorie C", "Catégorie B", "Catégorie A1"],
    answer: "Catégorie C",
    explanation: "R.311-2 CSI, C 1° b : répétition manuelle ≤ 11 coups.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie D (h)",
    question:
        "Une arme propulsant un projectile de manière non pyrotechnique avec une énergie de 10 joules est :",
    options: ["Catégorie D", "Catégorie C", "Catégorie B"],
    answer: "Catégorie D",
    explanation: "R.311-2 CSI, D h : énergie entre 2 et 20 joules.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (arme camouflée)",
    question: "Une arme camouflée est :",
    options: [
      "Une arme dissimulée sous la forme d’un autre objet, y compris d’un autre type d’arme",
      "Une arme portée sous les vêtements",
      "Une arme démontée en pièces détachées",
    ],
    answer:
        "Une arme dissimulée sous la forme d’un autre objet, y compris d’un autre type d’arme",
    explanation: "R.311-1 CSI 11° : définition de l’arme camouflée.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (arme à un coup)",
    question: "Une arme à un coup est :",
    options: [
      "Une arme sans système d’alimentation chargée avant chaque coup par introduction manuelle de la munition",
      "Une arme semi-automatique limitée à 1 munition",
      "Une arme à pompe",
    ],
    answer:
        "Une arme sans système d’alimentation chargée avant chaque coup par introduction manuelle de la munition",
    explanation: "R.311-1 CSI 9° : définition de l’arme à un coup.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (élément de munition)",
    question: "Constitue un élément de munition au sens du CSI :",
    options: [
      "Le projectile, l’amorce ou la douille",
      "Uniquement la poudre",
      "Uniquement l’étui vide non amorcé",
    ],
    answer: "Le projectile, l’amorce ou la douille",
    explanation:
        "R.311-1 CSI 21° : éléments essentiels d’une munition (projectile, amorce, douille…).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (munition perforante)",
    question: "Une munition à projectile perforant peut être :",
    options: [
      "Une munition avec noyau dur (acier trempé/carbure de tungstène) ou projectile conçu pour perforer un gilet pare-balles souple",
      "Une munition à pointe creuse uniquement",
      "Une munition de signalisation",
    ],
    answer:
        "Une munition avec noyau dur (acier trempé/carbure de tungstène) ou projectile conçu pour perforer un gilet pare-balles souple",
    explanation:
        "R.311-1 CSI 25° : définitions a/b/c des projectiles perforants.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (munition expansif)",
    question:
        "Une munition à projectile expansif est une munition dont le projectile :",
    options: [
      "Est façonné pour foisonner/champignonner à l’impact (ex : pointe creuse)",
      "Contient une charge qui explose à l’impact",
      "S’enflamme au contact de l’air",
    ],
    answer:
        "Est façonné pour foisonner/champignonner à l’impact (ex : pointe creuse)",
    explanation:
        "R.311-1 CSI 22° : projectile expansif (pointe creuse notamment).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (munition explosif)",
    question: "Une munition à projectile explosif est :",
    options: [
      "Une munition dont le projectile contient une charge explosant lors de l’impact",
      "Une munition dont l’étui est métallique",
      "Une munition de calibre supérieur à 8",
    ],
    answer:
        "Une munition dont le projectile contient une charge explosant lors de l’impact",
    explanation: "R.311-1 CSI 23° : projectile contenant charge explosive.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Port/Transport — Interdiction (A/B)",
    question: "Pour les catégories A et B, la règle générale est :",
    options: [
      "Interdiction du port et du transport sans motif légitime (sauf exceptions légales)",
      "Port libre si arme non chargée",
      "Transport libre dès lors que l’arme est déclarée",
    ],
    answer:
        "Interdiction du port et du transport sans motif légitime (sauf exceptions légales)",
    explanation:
        "Règles CSI : A/B = interdiction du port, transport seulement avec motif légitime ou exceptions (L.315-1/L.315-2).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Port/Transport — Motif légitime (exemples)",
    question:
        "Parmi ces situations, laquelle correspond à un motif légitime de transport (exemple type) ?",
    options: [
      "Trajet domicile → armurerie pour réparation, arme inutilisable immédiatement",
      "Arme chargée dans la boîte à gants",
      "Arme portée à la ceinture pour se rassurer",
    ],
    answer:
        "Trajet domicile → armurerie pour réparation, arme inutilisable immédiatement",
    explanation:
        "Le motif légitime peut être : déménagement, armurerie, compétition/entraînement, chasse, reconstitution historique.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — 222-54 CP (A/B)",
    question:
        "Le port ou transport sans motif légitime d’une arme de catégorie A ou B hors du domicile est :",
    options: [
      "Un délit (même si détenteur régulier)",
      "Une contravention",
      "Non réprimé si arme déchargée",
    ],
    answer: "Un délit (même si détenteur régulier)",
    explanation:
        "Article 222-54 CP : port/transport A ou B sans motif légitime, même en détention régulière.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Infractions — L.317-8 CSI (C/D)",
    question:
        "Le port sans autorisation ou le transport sans motif légitime d’armes de catégorie C ou D listées constitue :",
    options: [
      "Un délit",
      "Une contravention de 4e classe",
      "Un simple manquement administratif",
    ],
    answer: "Un délit",
    explanation:
        "L.317-8 CSI : incrimination du port/transport sans motif légitime pour C et D (liste).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Mineurs — Exceptions (plus de 9 ans)",
    question: "Un mineur de plus de 9 ans peut détenir :",
    options: [
      "Des armes de catégorie D (h) et (h bis) s’il est titulaire d’une licence de tir en cours",
      "Des armes de catégorie B avec autorisation parentale",
      "Des armes de catégorie A s’il est encadré",
    ],
    answer:
        "Des armes de catégorie D (h) et (h bis) s’il est titulaire d’une licence de tir en cours",
    explanation: "R.312-52 CSI : > 9 ans = D(h) et D(h bis) sous conditions.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie B (2° a)",
    question:
        "Une arme d’épaule semi-automatique à percussion centrale (diamètre < 20 mm) équipée d’un système d’alimentation amovible et n’excédant pas 11 coups relève de :",
    options: ["Catégorie B", "Catégorie C", "Catégorie A1"],
    answer: "Catégorie B",
    explanation:
        "R.311-2 CSI, B 2° a) : semi-auto centrale > 3 coups ou alimentation amovible, et ≤ 11 coups.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B (2° a bis)",
    question:
        "Une arme d’épaule semi-automatique à percussion annulaire (diamètre < 20 mm) avec alimentation amovible et n’excédant pas 31 coups relève de :",
    options: ["Catégorie B", "Catégorie C", "Catégorie A1"],
    answer: "Catégorie B",
    explanation:
        "R.311-2 CSI, B 2° a bis) : annulaire semi-auto > 3 coups ou alimentation amovible, et ≤ 31 coups.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B (2° b)",
    question:
        "Une arme d’épaule à répétition manuelle (diamètre < 20 mm) d’une capacité supérieure à 11 coups mais n’excédant pas 31 coups relève de :",
    options: ["Catégorie B", "Catégorie C", "Catégorie D"],
    answer: "Catégorie B",
    explanation: "R.311-2 CSI, B 2° b) : répétition manuelle > 11 et ≤ 31.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B (2° d)",
    question:
        "Une arme à canon lisse à répétition/semi-auto dont la longueur totale minimale ≤ 80 cm ou canon ≤ 60 cm est :",
    options: ["Catégorie B", "Catégorie C", "Catégorie D"],
    answer: "Catégorie B",
    explanation:
        "R.311-2 CSI, B 2° d) : canon lisse répétition/semi-auto avec seuils 80/60 cm.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B (2° e)",
    question:
        "Une arme à répétition semi-automatique ayant l’apparence d’une arme automatique est :",
    options: ["Catégorie B", "Catégorie A2", "Catégorie C"],
    answer: "Catégorie B",
    explanation:
        "R.311-2 CSI, B 2° e) : semi-auto ayant l’apparence d’une automatique.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B (2° f)",
    question:
        "Les armes à répétition manuelle munies d’un dispositif de rechargement à pompe (selon cas) peuvent relever de :",
    options: ["Catégorie B", "Catégorie D", "Toujours Catégorie C"],
    answer: "Catégorie B",
    explanation:
        "R.311-2 CSI, B 2° f) : certaines armes à pompe (canon lisse / canon rayé hors exceptions C).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B (4° calibres)",
    question: "Lequel des calibres suivants fait partie de la liste B 4° ?",
    options: [
      "7,62x39",
      "9x19 (non mentionné dans ton extrait)",
      "12/70 (calibre de chasse)",
    ],
    answer: "7,62x39",
    explanation: "R.311-2 CSI, B 4° a) : 7,62x39 est explicitement listé.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B (4° calibres)",
    question: "Le calibre 14,5 x 114 est classé :",
    options: ["Catégorie B (4°)", "Catégorie C (4°)", "Catégorie D (e)"],
    answer: "Catégorie B (4°)",
    explanation: "R.311-2 CSI, B 4° e) : 14,5 x 114 listé.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B (10°)",
    question:
        "Les munitions à percussion centrale conçues pour les armes de poing (B 1°) relèvent en principe :",
    options: [
      "De la catégorie B (sauf classement en C par arrêté)",
      "De la catégorie D",
      "Toujours de la catégorie C",
    ],
    answer: "De la catégorie B (sauf classement en C par arrêté)",
    explanation:
        "R.311-2 CSI, B 10° : munitions à percussion centrale pour armes de poing, sauf exceptions classées en C.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie C (1° c)",
    question: "Une arme d’épaule à un coup par canon relève de :",
    options: ["Catégorie C", "Catégorie B", "Catégorie A1"],
    answer: "Catégorie C",
    explanation: "R.311-2 CSI, C 1° c) : armes à un coup par canon.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie C (9°)",
    question:
        "Une arme des catégories A, B ou C neutralisée selon les modalités définies par arrêté est classée :",
    options: ["Catégorie C", "Catégorie D", "Catégorie A1"],
    answer: "Catégorie C",
    explanation:
        "R.311-2 CSI, C 9° : armes A/B/C neutralisées selon modalités.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie C (12°)",
    question: "Les armes d’alarme et de signalisation sont classées :",
    options: ["Catégorie C", "Catégorie D", "Catégorie B"],
    answer: "Catégorie C",
    explanation: "R.311-2 CSI, C 12° : armes d’alarme et de signalisation.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie D (a)",
    question:
        "Parmi ces objets, lequel entre dans la catégorie D (a) 'objets susceptibles de constituer une arme dangereuse' ?",
    options: [
      "Poignard / couteau-poignard / matraque (selon liste)",
      "Chargeur de 30 cartouches",
      "Douille amorcée",
    ],
    answer: "Poignard / couteau-poignard / matraque (selon liste)",
    explanation:
        "R.311-2 CSI, D a) : inclut notamment poignards, couteaux-poignards, matraques (selon arrêté).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (arme blanche)",
    question:
        "Une arme blanche est une arme dont l’action tranchante/perforante/brisante est due :",
    options: [
      "À la force humaine ou un mécanisme auquel elle a été transmise, sans explosion",
      "À une combustion propulsive",
      "À une émission électrique à distance",
    ],
    answer:
        "À la force humaine ou un mécanisme auquel elle a été transmise, sans explosion",
    explanation: "R.311-1 CSI 10° : définition de l’arme blanche.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (arme neutralisée)",
    question: "Une arme neutralisée est une arme rendue :",
    options: [
      "Définitivement impropre au tir de toute munition par procédés techniques",
      "Temporairement inutilisable par démontage simple",
      "Inutilisable seulement si elle est déchargée",
    ],
    answer:
        "Définitivement impropre au tir de toute munition par procédés techniques",
    explanation:
        "R.311-1 CSI 16° : neutralisation = définitive + éléments rendus inutilisables/immuables.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (élément d'arme neutralisé)",
    question: "Un élément d’arme neutralisé correspond à :",
    options: [
      "Une partie essentielle rendue définitivement impropre à son usage par procédés techniques",
      "Une pièce d’esthétique (crosse) rayée",
      "Un accessoire amovible",
    ],
    answer:
        "Une partie essentielle rendue définitivement impropre à son usage par procédés techniques",
    explanation:
        "R.311-1 CSI 20° : élément essentiel neutralisé selon procédés définis.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (douille amorcée)",
    question: "Une douille amorcée est :",
    options: [
      "Une douille qui comporte une amorce sans autre charge de poudre",
      "Une douille contenant uniquement de la poudre",
      "Une munition complète prête au tir",
    ],
    answer: "Une douille qui comporte une amorce sans autre charge de poudre",
    explanation: "R.311-1 CSI 17° : douille amorcée = amorce sans poudre.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (douille chargée)",
    question: "Une douille chargée est :",
    options: [
      "Une douille qui comporte une charge de poudre",
      "Une douille avec une amorce percutée",
      "Une munition inerte",
    ],
    answer: "Une douille qui comporte une charge de poudre",
    explanation: "R.311-1 CSI 18° : douille chargée = poudre présente.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (système d'alimentation)",
    question:
        "Au sens du CSI, les systèmes d’alimentation comprennent notamment :",
    options: [
      "Chargeurs, bandes, magasins intégrés, réservoirs",
      "Uniquement les chargeurs amovibles",
      "Uniquement les bandes",
    ],
    answer: "Chargeurs, bandes, magasins intégrés, réservoirs",
    explanation:
        "R.311-1 CSI 27° : magasins intégrés/tubulaires + magasins indépendants (chargeurs/bandes…).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Définitions — Autres armes (arme factice)",
    question:
        "Une arme factice (CSI) est un objet ayant l’apparence d’une arme à feu pouvant expulser un projectile non métallique avec une énergie :",
    options: [
      "Inférieure à 2 joules",
      "Entre 2 et 20 joules",
      "Supérieure à 20 joules",
    ],
    answer: "Inférieure à 2 joules",
    explanation: "R.311-1 CSI : arme factice = énergie < 2 J.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Définitions — Ne sont pas des armes (CSI)",
    question: "Au sens du CSI, ne sont pas des armes :",
    options: [
      "Les objets projetant un projectile ou des gaz avec énergie < 2 joules",
      "Les armes d’alarme et de signalisation",
      "Les armes neutralisées",
    ],
    answer:
        "Les objets projetant un projectile ou des gaz avec énergie < 2 joules",
    explanation:
        "R.311-1 IV CSI : énergie < 2 joules = pas une arme (au sens du texte).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Ne sont pas des armes (CSI)",
    question: "Au sens du CSI, les réducteurs de son sont considérés comme :",
    options: [
      "Des pièces additionnelles ne modifiant pas le fonctionnement (donc pas des armes au sens R.311-1 IV)",
      "Des éléments essentiels de l’arme",
      "Des munitions",
    ],
    answer:
        "Des pièces additionnelles ne modifiant pas le fonctionnement (donc pas des armes au sens R.311-1 IV)",
    explanation:
        "R.311-1 IV CSI : réducteurs de son = pas des armes (au sens de cette définition).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Activités — Intermédiation",
    question:
        "Une activité d’intermédiation en relation avec les armes consiste notamment à :",
    options: [
      "Rapprocher acheteur/vendeur ou organiser des transferts entre États",
      "Fabriquer une arme à feu",
      "Neutraliser une arme",
    ],
    answer:
        "Rapprocher acheteur/vendeur ou organiser des transferts entre États",
    explanation:
        "Définitions : activité d’intermédiation = courtage/mandat/commission + organisation de transferts.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Activités — Armurier",
    question:
        "Un armurier est une personne dont l’activité consiste (en tout ou partie) dans :",
    options: [
      "Fabrication, commerce, échange, location, prêt, réparation ou transformation d’armes/munitions",
      "Uniquement la vente d’armes de chasse",
      "Uniquement la reconstitution historique",
    ],
    answer:
        "Fabrication, commerce, échange, location, prêt, réparation ou transformation d’armes/munitions",
    explanation:
        "Définition 'Armurier' : champ très large (armes, éléments, munitions, éléments).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Activités — Dépôt d'armes",
    question: "Le dépôt d’armes correspond à :",
    options: [
      "La détention illicite au-delà du nombre maximum légalement autorisé, dans un ou plusieurs lieux",
      "Le stockage d’une arme chez soi avec autorisation",
      "Le transport d’une arme vers l’armurerie",
    ],
    answer:
        "La détention illicite au-delà du nombre maximum légalement autorisé, dans un ou plusieurs lieux",
    explanation:
        "Définition : dépôt d’armes = détention illicite au-delà du nombre maximum.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Activités — Fabrication illicite",
    question: "Constitue une fabrication illicite (définition) :",
    options: [
      "Assembler/modifier une arme sans autorisation ou sans marquage d’identification (hors rechargement privé licite)",
      "Recharger des cartouches en privé avec des éléments obtenus licitement",
      "Acheter une arme chez un armurier",
    ],
    answer:
        "Assembler/modifier une arme sans autorisation ou sans marquage d’identification (hors rechargement privé licite)",
    explanation:
        "Définition : fabrication illicite = fabrication/transformation sans autorisation ou sans marquage requis.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Marquage — Contenu",
    question: "Le marquage d’une arme à feu comprend notamment :",
    options: [
      "Fabricant, pays/lieu, année, modèle, calibre, numéro de série",
      "Nom du propriétaire uniquement",
      "Couleur de la crosse",
    ],
    answer: "Fabricant, pays/lieu, année, modèle, calibre, numéro de série",
    explanation:
        "Définition 'Marquage' : informations d’identification obligatoires, visibles sans démontage.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Traçabilité — Définition",
    question: "La traçabilité correspond à :",
    options: [
      "L’enregistrement des détenteurs successifs d’une arme de la fabrication à la possession finale",
      "Le contrôle du bruit d’une arme",
      "La déclaration de perte d’une arme uniquement",
    ],
    answer:
        "L’enregistrement des détenteurs successifs d’une arme de la fabrication à la possession finale",
    explanation:
        "Définition : traçabilité = obligation d’enregistrement des détenteurs successifs.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Trafic illicite — Définition",
    question: "Le trafic illicite inclut notamment :",
    options: [
      "Import/export/transfert/vente/transport sans autorisations nécessaires ou sans marquage conforme",
      "La vente à un particulier autorisé",
      "Le dépôt temporaire chez un armurier",
    ],
    answer:
        "Import/export/transfert/vente/transport sans autorisations nécessaires ou sans marquage conforme",
    explanation:
        "Définition 'Trafic illicite' : opérations sans autorisations ou portant sur armes non marquées conformément.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Port/Transport — Domicile (notion)",
    question:
        "Dans ton cours, la notion de domicile pour l’infraction de port/transport s’entend aussi comme :",
    options: [
      "Un lieu normalement clos assimilé au domicile (prolongement immédiat)",
      "Tout lieu public",
      "Uniquement l’adresse sur la carte d’identité",
    ],
    answer:
        "Un lieu normalement clos assimilé au domicile (prolongement immédiat)",
    explanation:
        "Cours : la jurisprudence assimile certains lieux clos/prolongements immédiats au domicile.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Infractions — L.317-8 CSI (éléments d'arme)",
    question:
        "Pourquoi l’infraction L.317-8 inclut-elle aussi les éléments d’armes ?",
    options: [
      "Pour éviter le transport d’une arme en pièces détachées en toute impunité",
      "Parce qu’un élément est toujours dangereux seul",
      "Parce que les éléments sont tous en catégorie A2",
    ],
    answer:
        "Pour éviter le transport d’une arme en pièces détachées en toute impunité",
    explanation:
        "Cours : inclusion des éléments afin d’éviter contournement (transport démonté puis remontage).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Règles d’acquisition — Catégorie C",
    question:
        "Pour acquérir une arme de catégorie C, une personne majeure doit notamment présenter :",
    options: [
      "Un certificat médical de moins d’un mois + (permis de chasser validé / licence de tir / carte de collectionneur)",
      "Uniquement une pièce d’identité",
      "Une autorisation ministérielle",
    ],
    answer:
        "Un certificat médical de moins d’un mois + (permis de chasser validé / licence de tir / carte de collectionneur)",
    explanation:
        "Cours : L.312-4-1 CSI (présentation des justificatifs) + certificat médical < 1 mois.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Règles d’acquisition — Catégorie D",
    question:
        "Les personnes majeures peuvent acquérir et détenir les armes et éléments de catégorie D :",
    options: [
      "Librement",
      "Uniquement avec une licence de tir",
      "Uniquement avec un permis de chasser",
    ],
    answer: "Librement",
    explanation:
        "Cours : acquisition/détention libre pour D (sous réserve de classements spécifiques).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Dessaisissement — Pouvoir du préfet",
    question:
        "Pour des raisons d’ordre public ou de sécurité des personnes, le préfet peut :",
    options: [
      "Ordonner le dessaisissement d’armes/munitions de toute catégorie",
      "Uniquement retirer les armes de catégorie D",
      "Uniquement contrôler les stands de tir",
    ],
    answer: "Ordonner le dessaisissement d’armes/munitions de toute catégorie",
    explanation:
        "Cours : L.312-11 CSI : dessaisissement possible pour toute catégorie (procédure contradictoire sauf urgence).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Mise en possession — Refus de conservation",
    question:
        "Une personne qui hérite d’une arme de catégorie A ou B et ne souhaite pas la conserver peut :",
    options: [
      "S’en dessaisir sans la déclarer préalablement via le compte individualisé (modalité prévue)",
      "La vendre librement à n’importe qui",
      "La conserver sans formalités",
    ],
    answer:
        "S’en dessaisir sans la déclarer préalablement via le compte individualisé (modalité prévue)",
    explanation:
        "Cours : R.312-51-1 CSI (A/B) : possibilité de dessaisissement sans déclaration préalable si non conservation.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Mise en possession — Dépôt chez un professionnel",
    question:
        "Après une mise en possession A/B (trouvée/succession) en vue de conservation, l’arme doit être :",
    options: [
      "Déposée chez un professionnel autorisé (inscription au livre de police dématérialisé dans les délais)",
      "Gardée chez soi jusqu’à régularisation",
      "Transportée librement pour la montrer à la famille",
    ],
    answer:
        "Déposée chez un professionnel autorisé (inscription au livre de police dématérialisé dans les délais)",
    explanation:
        "Cours : dépôt auprès d’un pro autorisé durant le délai de mise en conformité.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Autorisation — Catégorie B (caducité)",
    question:
        "Si une autorisation de catégorie B est notifiée et que l’arme n’est pas acquise dans le délai, elle devient :",
    options: [
      "Caduque après 6 mois",
      "Valable jusqu’à 5 ans sans acquisition",
      "Transformée automatiquement en déclaration",
    ],
    answer: "Caduque après 6 mois",
    explanation:
        "R.312-12 CSI : après notification, 6 mois pour acquérir sinon caducité.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1 (3°)",
    question:
        "Une arme d'épaule semi-automatique à percussion annulaire avec chargeur > 30 cartouches inséré relève de :",
    options: ["Catégorie A1", "Catégorie B (2° a bis)", "Catégorie C (1° a)"],
    answer: "Catégorie A1",
    explanation:
        "R.311-2 CSI, Cat. A1 3° : annulaire semi-auto + > 31 munitions si chargeur > 30 intégré ou inséré.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A1 (3° bis)",
    question:
        "Une arme d'épaule semi-automatique à percussion centrale tirant plus de 11 coups sans recharger (chargeur > 10) est :",
    options: ["Catégorie A1", "Catégorie B (2° a)", "Catégorie C (1° b)"],
    answer: "Catégorie A1",
    explanation:
        "R.311-2 CSI, Cat. A1 3° bis : centrale semi-auto + > 11 coups si chargeur > 10 intégré ou inséré.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A1 (3° ter)",
    question:
        "Les armes d'épaule semi-automatiques alimentées par bande sont :",
    options: [
      "Catégorie A1, quelle qu'en soit la capacité",
      "Catégorie B si bande ≤ 10",
      "Catégorie C si bande ≤ 3",
    ],
    answer: "Catégorie A1, quelle qu'en soit la capacité",
    explanation: "R.311-2 CSI, Cat. A1 3° ter : alimentation par bande = A1.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A1 (3° quater)",
    question:
        "Une arme d'épaule à répétition manuelle tirant plus de 31 munitions sans réapprovisionnement (chargeur > 30) est :",
    options: ["Catégorie A1", "Catégorie B (2° b)", "Catégorie C (1° b)"],
    answer: "Catégorie A1",
    explanation:
        "R.311-2 CSI, Cat. A1 3° quater : manuelle + > 31 si chargeur > 30 intégré/inséré.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A1 (4°)",
    question:
        "Les armes à canons rayés dont le projectile a un diamètre ≥ 20 mm sont en principe :",
    options: [
      "Catégorie A1 (sauf projectiles non métalliques exclusivement)",
      "Catégorie B",
      "Catégorie C",
    ],
    answer: "Catégorie A1 (sauf projectiles non métalliques exclusivement)",
    explanation:
        "R.311-2 CSI, Cat. A1 4° : ≥ 20 mm, exception si conçues pour projectiles non métalliques.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A1 (5°)",
    question:
        "Les armes à feu à canon lisse d'un calibre supérieur au calibre 8 relèvent en principe de :",
    options: [
      "Catégorie A1 (sauf exclusions prévues)",
      "Catégorie D",
      "Catégorie C automatiquement",
    ],
    answer: "Catégorie A1 (sauf exclusions prévues)",
    explanation:
        "R.311-2 CSI, Cat. A1 5° : canon lisse > calibre 8, sauf exceptions (armes C/D classées par arrêté).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A1 (6°)",
    question: "Les munitions dont le projectile est ≥ 20 mm sont :",
    options: [
      "Catégorie A1, sauf celles utilisées par les armes de catégorie C",
      "Toujours catégorie C",
      "Toujours catégorie D",
    ],
    answer: "Catégorie A1, sauf celles utilisées par les armes de catégorie C",
    explanation:
        "R.311-2 CSI, Cat. A1 6° : projectile ≥ 20 mm, exception pour certaines munitions d'armes classées en C.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A1 (8°/9°/9° bis)",
    question: "Quel système d'alimentation relève de la catégorie A1 ?",
    options: [
      "Chargeur d'arme de poing contenant plus de 20 munitions",
      "Chargeur d'arme de poing contenant 15 munitions",
      "Tube magasin limitant l'arme à 3 coups",
    ],
    answer: "Chargeur d'arme de poing contenant plus de 20 munitions",
    explanation:
        "R.311-2 CSI, Cat. A1 8° : systèmes d'alimentation d'armes de poing > 20.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A1 (11°)",
    question:
        "Une arme automatique transformée en semi-automatique (ou manuelle / un coup) est classée :",
    options: ["Catégorie A1", "Catégorie B", "Catégorie C"],
    answer: "Catégorie A1",
    explanation:
        "R.311-2 CSI, Cat. A1 11° : armes auto transformées restent A1.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A1 (12°)",
    question:
        "Une arme d'épaule semi-auto dont la longueur peut être réduite à moins de 60 cm (crosse repliable/télescopique) est :",
    options: ["Catégorie A1", "Catégorie B", "Catégorie D"],
    answer: "Catégorie A1",
    explanation:
        "R.311-2 CSI, Cat. A1 12° : réduction < 60 cm sans perte de fonctionnalité.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A2 (1°)",
    question: "Relève de la catégorie A2 (1°) :",
    options: [
      "Armes automatiques et dispositifs additionnels permettant le tir en rafale",
      "Armes à un coup par canon",
      "Armes d'alarme non transformables",
    ],
    answer:
        "Armes automatiques et dispositifs additionnels permettant le tir en rafale",
    explanation:
        "R.311-2 CSI, Cat. A2 1° : armes auto + dispositifs assimilables au tir en rafale.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A2 (2°)",
    question:
        "Les munitions à projectiles perforants, explosifs ou incendiaires relèvent de :",
    options: ["Catégorie A2", "Catégorie B (10°)", "Catégorie D (i)"],
    answer: "Catégorie A2",
    explanation: "R.311-2 CSI, Cat. A2 2° : perforants/explosifs/incendiaires.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A2 (4°/5°)",
    question:
        "Canons, obusiers, mortiers, lance-roquettes et leurs munitions relèvent de :",
    options: ["Catégorie A2", "Catégorie A1", "Catégorie C"],
    answer: "Catégorie A2",
    explanation:
        "R.311-2 CSI, Cat. A2 4° et 5° : matériels lourds + munitions associées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A2 (6°)",
    question:
        "Bombes, torpilles, mines, missiles, grenades (chargés ou non) sont :",
    options: ["Catégorie A2", "Catégorie B", "Catégorie D"],
    answer: "Catégorie A2",
    explanation:
        "R.311-2 CSI, Cat. A2 6° : engins et équipements de lancement/largage.",
    difficulty: "Facile",
  ),

  // =========================
  // THÈME 2 — Classification : Catégories B / C / D (R.311-2)
  // =========================
  const QuizQuestion(
    category: "Classification — Catégorie B (1°)",
    question: "Relève de la catégorie B (1°) :",
    options: [
      "Les armes à feu de poing (non classées ailleurs)",
      "Les armes historiques modèle antérieur à 1900",
      "Les objets projetant < 2 joules",
    ],
    answer: "Les armes à feu de poing (non classées ailleurs)",
    explanation: "R.311-2 CSI, Cat. B 1° : armes de poing.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie B (2° a)",
    question:
        "Une arme d'épaule semi-auto à percussion centrale (diamètre < 20 mm) d'une capacité supérieure à 3 coups relève de :",
    options: ["Catégorie B", "Catégorie C", "Catégorie D"],
    answer: "Catégorie B",
    explanation:
        "R.311-2 CSI, Cat. B 2° a) : centrale semi-auto > 3 coups (ou système amovible) et n'excédant pas 11 coups.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie B (2° a bis)",
    question:
        "Une arme d'épaule semi-auto à percussion annulaire (diamètre < 20 mm) d'une capacité supérieure à 3 coups relève de :",
    options: ["Catégorie B", "Catégorie A1", "Catégorie D"],
    answer: "Catégorie B",
    explanation:
        "R.311-2 CSI, Cat. B 2° a bis) : annulaire semi-auto > 3 coups et n'excédant pas 31 coups.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie B (2° c)",
    question:
        "Une arme d'épaule dont la longueur totale minimale est ≤ 80 cm est :",
    options: ["Catégorie B", "Catégorie C", "Toujours catégorie D"],
    answer: "Catégorie B",
    explanation:
        "R.311-2 CSI, Cat. B 2° c) : longueur totale minimale ≤ 80 cm.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie B (4° calibres)",
    question:
        "Les armes chambrant le calibre 5,56x45 (et leurs munitions/douilles) sont en :",
    options: ["Catégorie B (4°)", "Catégorie C (8°)", "Catégorie D (j bis)"],
    answer: "Catégorie B (4°)",
    explanation: "R.311-2 CSI, Cat. B 4° b) : 5,56x45 listé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie B (6°)",
    question:
        "Une arme à impulsion électrique provoquant un choc à distance est :",
    options: ["Catégorie B", "Catégorie D", "Catégorie C"],
    answer: "Catégorie B",
    explanation:
        "R.311-2 CSI, Cat. B 6° : impulsion électrique à distance + munitions.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie B (8°)",
    question:
        "Un générateur d'aérosol lacrymogène d'une capacité supérieure à 100 ml est :",
    options: ["Catégorie B", "Catégorie D", "Hors classification"],
    answer: "Catégorie B",
    explanation:
        "R.311-2 CSI, Cat. B 8° : aérosols incapacitants/lacrymogènes > 100 ml.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie C (1° a)",
    question:
        "Une arme d'épaule semi-auto (diamètre < 20 mm) avec alimentation inamovible limitée à 3 munitions max est :",
    options: ["Catégorie C", "Catégorie B", "Catégorie A1"],
    answer: "Catégorie C",
    explanation: "R.311-2 CSI, Cat. C 1° a) : semi-auto + inamovible ≤ 3.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie C (1° b)",
    question:
        "Une arme d'épaule à répétition manuelle (diamètre < 20 mm) limitée à 11 munitions max est :",
    options: ["Catégorie C", "Catégorie B", "Catégorie D"],
    answer: "Catégorie C",
    explanation: "R.311-2 CSI, Cat. C 1° b) : manuelle ≤ 11.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie C (4°)",
    question:
        "Une arme ou lanceur non pyrotechnique avec énergie à la bouche ≥ 20 joules est :",
    options: ["Catégorie C", "Catégorie D", "Catégorie B"],
    answer: "Catégorie C",
    explanation: "R.311-2 CSI, Cat. C 4° : ≥ 20 J.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie D (b)",
    question: "Un aérosol lacrymogène de capacité ≤ 100 ml est en principe :",
    options: ["Catégorie D", "Catégorie B", "Catégorie A2"],
    answer: "Catégorie D",
    explanation:
        "R.311-2 CSI, Cat. D b) : ≤ 100 ml (sauf classement différent par arrêté).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie D (h)",
    question:
        "Une arme/lanceur non pyrotechnique avec énergie comprise entre 2 et 20 joules est :",
    options: ["Catégorie D", "Catégorie C", "Non classé"],
    answer: "Catégorie D",
    explanation: "R.311-2 CSI, Cat. D h) : 2 à 20 J.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie D (e)",
    question:
        "Les armes historiques et de collection dont le modèle est antérieur au 1er janvier 1900 relèvent :",
    options: [
      "Catégorie D (sauf classement différent pour dangerosité)",
      "Catégorie C automatiquement",
      "Catégorie B automatiquement",
    ],
    answer: "Catégorie D (sauf classement différent pour dangerosité)",
    explanation:
        "R.311-2 CSI, Cat. D e) : modèle antérieur à 1900, avec exceptions par arrêté.",
    difficulty: "Moyenne",
  ),

  // =========================
  // THÈME 3 — Définitions (Code pénal 132-75 / CSI R.311-1)
  // =========================
  const QuizQuestion(
    category: "Définitions — Arme par nature (CP)",
    question: "Selon l'article 132-75 al.1 du Code pénal, une arme est :",
    options: [
      "Tout objet conçu pour tuer ou blesser",
      "Tout objet métallique",
      "Tout objet servant à se défendre",
    ],
    answer: "Tout objet conçu pour tuer ou blesser",
    explanation: "CP art. 132-75 al.1 : arme par nature.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Définitions — Arme par destination (CP)",
    question:
        "Un objet non conçu comme arme devient une arme par destination si :",
    options: [
      "Il est utilisé ou destiné à tuer, blesser ou menacer",
      "Il est transporté dans un véhicule",
      "Il est acheté récemment",
    ],
    answer: "Il est utilisé ou destiné à tuer, blesser ou menacer",
    explanation:
        "CP art. 132-75 al.2 : assimilation dès usage/destination pour tuer/blesser/menacer.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Définitions — Objet ressemblant à une arme (CP)",
    question:
        "Un objet ressemblant à une arme est assimilé à une arme lorsqu'il est :",
    options: [
      "Utilisé ou destiné à menacer de tuer ou blesser",
      "Détenu à domicile",
      "Fabriqué en plastique",
    ],
    answer: "Utilisé ou destiné à menacer de tuer ou blesser",
    explanation:
        "CP art. 132-75 al.3 : ressemblance créant confusion + menace.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Définitions — Animal (CP)",
    question: "L'utilisation d'un animal pour tuer, blesser ou menacer est :",
    options: [
      "Assimilée à l'usage d'une arme",
      "Toujours une contravention",
      "Hors du champ pénal",
    ],
    answer: "Assimilée à l'usage d'une arme",
    explanation:
        "CP art. 132-75 al.4 : animal assimilé à l'arme en cas d'usage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Définitions — Arme (CSI R.311-1 2°)",
    question: "Au sens du CSI, une arme est :",
    options: [
      "Tout objet/dispositif conçu ou destiné à tuer, blesser, frapper, neutraliser ou provoquer une incapacité",
      "Uniquement une arme à feu",
      "Uniquement une arme blanche",
    ],
    answer:
        "Tout objet/dispositif conçu ou destiné à tuer, blesser, frapper, neutraliser ou provoquer une incapacité",
    explanation: "CSI R.311-1 2° : définition large.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Définitions — Canon lisse (CSI R.311-1 3°)",
    question: "Une arme à canon lisse se caractérise par :",
    options: [
      "Une âme de section circulaire ne donnant pas de rotation au projectile",
      "Des rayures polygonales",
      "Un canon toujours inférieur à 45 cm",
    ],
    answer:
        "Une âme de section circulaire ne donnant pas de rotation au projectile",
    explanation: "CSI R.311-1 3° : canon lisse.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Définitions — Canon rayé (CSI R.311-1 4°)",
    question: "Une arme à canon rayé a :",
    options: [
      "Des rayures destinées à donner une rotation au projectile",
      "Une âme forcément circulaire sans rayures",
      "Un canon obligatoirement lisse",
    ],
    answer: "Des rayures destinées à donner une rotation au projectile",
    explanation:
        "CSI R.311-1 4° : rayures conventionnelles/polygonales pour rotation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Définitions — Arme à feu (CSI R.311-1 5°)",
    question: "Une arme à feu est :",
    options: [
      "Une arme tirant par combustion d'une charge propulsive ou transformable aisément à cette fin",
      "Toute arme à projectile non pyrotechnique",
      "Toute arme de collection",
    ],
    answer:
        "Une arme tirant par combustion d'une charge propulsive ou transformable aisément à cette fin",
    explanation: "CSI R.311-1 5° : combustion ou transformation aisée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Définitions — Répétition automatique (CSI R.311-1 6°)",
    question: "Une arme à répétition automatique est celle qui :",
    options: [
      "Se recharge automatiquement et peut tirer une rafale par une seule pression",
      "Se recharge manuellement après chaque tir",
      "Ne peut tirer qu'un seul coup par pression",
    ],
    answer:
        "Se recharge automatiquement et peut tirer une rafale par une seule pression",
    explanation: "CSI R.311-1 6° : rafale possible sur une pression.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Définitions — Répétition semi-automatique (CSI R.311-1 8°)",
    question: "Une arme semi-automatique :",
    options: [
      "Se recharge automatiquement mais ne tire qu'un coup par pression",
      "Tire en rafale par une seule pression",
      "Est toujours à canon lisse",
    ],
    answer: "Se recharge automatiquement mais ne tire qu'un coup par pression",
    explanation: "CSI R.311-1 8° : un seul coup par pression sur détente.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Définitions — Arme de poing (CSI R.311-1 13°)",
    question: "Une arme de poing est :",
    options: [
      "Une arme tenue par une poignée d'une seule main, non destinée à être épaulée",
      "Une arme qui s'épaule pour tirer",
      "Toute arme à canon rayé",
    ],
    answer:
        "Une arme tenue par une poignée d'une seule main, non destinée à être épaulée",
    explanation: "CSI R.311-1 13° : définition + longueur hors tout.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Définitions — Arme d'épaule (CSI R.311-1 12°)",
    question: "Une arme d'épaule est :",
    options: [
      "Une arme que l'on épaule pour tirer",
      "Une arme tenue à une main uniquement",
      "Une arme forcément semi-automatique",
    ],
    answer: "Une arme que l'on épaule pour tirer",
    explanation: "CSI R.311-1 12° : définition (règles de mesure longueur).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Définitions — Élément d'arme (CSI R.311-1 19°)",
    question: "Un élément d'arme est :",
    options: [
      "Une partie essentielle au fonctionnement (canon, carcasse, culasse, barillet...)",
      "Uniquement un accessoire",
      "Uniquement une poignée",
    ],
    answer:
        "Une partie essentielle au fonctionnement (canon, carcasse, culasse, barillet...)",
    explanation: "CSI R.311-1 19° : liste d'éléments essentiels.",
    difficulty: "Moyenne",
  ),

  // =========================
  // THÈME 4 — Port / Transport / Motif légitime (CSI)
  // =========================
  const QuizQuestion(
    category: "Port/Transport — Définition du port (CSI)",
    question: "Le port d'arme correspond à :",
    options: [
      "Avoir une arme sur soi utilisable immédiatement",
      "Déplacer une arme dans le coffre verrouillé",
      "Détenir une arme à domicile",
    ],
    answer: "Avoir une arme sur soi utilisable immédiatement",
    explanation:
        "CSI R.311-1 (définitions) : port = sur soi + utilisable immédiatement.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Port/Transport — Définition du transport (CSI)",
    question: "Le transport d'arme correspond à :",
    options: [
      "Déplacer une arme auprès de soi, inutilisable immédiatement",
      "Avoir l'arme chargée à la ceinture",
      "Exposer une arme dans un musée",
    ],
    answer: "Déplacer une arme auprès de soi, inutilisable immédiatement",
    explanation:
        "CSI R.311-1 (définitions) : transport = auprès de soi + non immédiatement utilisable.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Port/Transport — Règle générale A/B",
    question: "Pour les catégories A et B, la règle générale est :",
    options: [
      "Interdiction du port et transport sans motif légitime (hors exceptions)",
      "Port libre si détention régulière",
      "Transport libre pour tous les particuliers",
    ],
    answer:
        "Interdiction du port et transport sans motif légitime (hors exceptions)",
    explanation:
        "CSI : interdiction stricte, exceptions légales (L.315-1, L.315-2...).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Port/Transport — Règle générale C/D",
    question: "Pour les catégories C et D, la règle générale est :",
    options: [
      "Interdiction du port et du transport sans motif légitime",
      "Liberté totale hors domicile",
      "Interdiction uniquement en zone urbaine",
    ],
    answer: "Interdiction du port et du transport sans motif légitime",
    explanation: "CSI : C/D = pas de port/transport hors motif légitime.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Port/Transport — Motif légitime (exemples)",
    question:
        "Parmi les situations suivantes, laquelle illustre un motif légitime de transport ?",
    options: [
      "Se rendre à un entraînement/compétition de tir avec l'arme non immédiatement utilisable",
      "Se promener avec l'arme chargée en poche",
      "Conserver l'arme sous le siège conducteur",
    ],
    answer:
        "Se rendre à un entraînement/compétition de tir avec l'arme non immédiatement utilisable",
    explanation:
        "Exemples cités : domicile→armurerie, compétition, chasse, reconstitution historique…",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Port/Transport — Chasse (titre)",
    question:
        "Le permis de chasser (avec validation de l'année en cours) vaut :",
    options: [
      "Titre de port légitime pour les armes C et certaines D en action de chasse/activités liées",
      "Autorisation d'acquérir une arme de catégorie A",
      "Titre de port libre pour toutes armes",
    ],
    answer:
        "Titre de port légitime pour les armes C et certaines D en action de chasse/activités liées",
    explanation:
        "Règles CSI : permis de chasser + validation = port légitime pour C et D(a) en action de chasse.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Port/Transport — Tir sportif (titre)",
    question: "La licence de tir en cours de validité vaut :",
    options: [
      "Titre de transport légitime pour armes/éléments/munitions A, B, C et D liés à la pratique",
      "Autorisation automatique de port en public",
      "Dispense de règles de sécurité au stand",
    ],
    answer:
        "Titre de transport légitime pour armes/éléments/munitions A, B, C et D liés à la pratique",
    explanation:
        "CSI : licence = transport légitime dans le cadre du sport concerné.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Port/Transport — Collectionneur (titre)",
    question: "La carte de collectionneur vaut :",
    options: [
      "Titre de transport légitime des armes de catégorie C pour activités liées à exposition/étude",
      "Autorisation de port dissimulé",
      "Autorisation d'acquérir de la catégorie A2",
    ],
    answer:
        "Titre de transport légitime des armes de catégorie C pour activités liées à exposition/étude",
    explanation:
        "CSI : collectionneur = transport légitime pour C dans le cadre exposition/étude/conservation.",
    difficulty: "Moyenne",
  ),

  // =========================
  // THÈME 5 — Infractions : acquisition/détention/cession (CP 222-52) + port/transport (CP 222-54 / CSI L.317-8)
  // =========================
  const QuizQuestion(
    category: "Infractions — Acquisition/Détention/Cession A ou B (222-52 CP)",
    question:
        "L'acquisition, la détention ou la cession sans autorisation d'armes/munitions de catégories A ou B constitue :",
    options: ["Un délit", "Une contravention", "Un crime systématique"],
    answer: "Un délit",
    explanation: "CP art. 222-52 : incrimination (A/B sans autorisation).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Infractions — Élément matériel (222-52 CP)",
    question: "Dans 222-52 CP, l'élément matériel peut être :",
    options: [
      "Acquisition, détention ou cession",
      "Seulement le port d'arme",
      "Seulement la fabrication",
    ],
    answer: "Acquisition, détention ou cession",
    explanation:
        "CP 222-52 : vise acquisition/détention/cession sans autorisation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Infractions — Détention (notion)",
    question: "La détention d'une arme s'entend comme :",
    options: [
      "Toute maîtrise de fait (mainmise matérielle), même sans être propriétaire",
      "Uniquement la propriété juridique",
      "Uniquement le port sur soi",
    ],
    answer:
        "Toute maîtrise de fait (mainmise matérielle), même sans être propriétaire",
    explanation:
        "Définition fonctionnelle : maîtrise matérielle, conservation au domicile ou lieu assimilé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Infractions — Autorisation (principe)",
    question: "Concernant A/B pour les particuliers, l'autorisation est :",
    options: [
      "Une dérogation : le principe est l'interdiction",
      "Un droit automatique",
      "Inutile si l'arme est stockée à domicile",
    ],
    answer: "Une dérogation : le principe est l'interdiction",
    explanation: "Régime A/B : interdit sauf autorisation expresse (CSI).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Infractions — Répression (222-52 CP simple)",
    question:
        "La peine principale encourue (personne physique) pour 222-52 al.1 CP est :",
    options: [
      "5 ans d'emprisonnement et 75 000 € d'amende",
      "2 ans d'emprisonnement et 30 000 € d'amende",
      "1 an d'emprisonnement et 15 000 € d'amende",
    ],
    answer: "5 ans d'emprisonnement et 75 000 € d'amende",
    explanation: "CP 222-52 al.1 : 5 ans + 75 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Infractions — Circonstances aggravantes (222-52 CP)",
    question: "Constitue une circonstance aggravante prévue par 222-52 CP :",
    options: [
      "Commission par au moins deux personnes agissant comme auteur/complice",
      "Fait commis de nuit uniquement",
      "Fait commis en milieu rural",
    ],
    answer:
        "Commission par au moins deux personnes agissant comme auteur/complice",
    explanation: "CP 222-52 al.3 : pluralité de personnes (auteur/complice).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Infractions — Tentative (222-52/222-60 CP)",
    question:
        "La tentative d'acquisition/détention/cession A ou B sans autorisation est :",
    options: [
      "Punissable (prévue par 222-60 CP)",
      "Non punissable",
      "Punissable uniquement pour la catégorie C",
    ],
    answer: "Punissable (prévue par 222-60 CP)",
    explanation:
        "CP 222-60 : tentative spécialement prévue pour ces infractions.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Infractions — Exemption/Réduction (222-67-1 CP)",
    question: "L'exemption de peine peut s'appliquer si la personne :",
    options: [
      "A averti l'autorité administrative/judiciaire et permis d'éviter la réalisation",
      "A simplement détruit l'arme sans prévenir",
      "A remboursé l'armurier",
    ],
    answer:
        "A averti l'autorité administrative/judiciaire et permis d'éviter la réalisation",
    explanation:
        "CP 222-67-1 al.1 : avertissement + prévention de la réalisation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Infractions — Port/Transport A ou B (222-54 CP)",
    question:
        "Porter ou transporter hors domicile, sans motif légitime, une arme de catégorie A ou B constitue :",
    options: [
      "Un délit",
      "Une simple contravention",
      "Un fait non réprimé si détention régulière",
    ],
    answer: "Un délit",
    explanation:
        "CP art. 222-54 : port/transport A/B sans motif légitime (même si détenteur régulier).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Infractions — Tentative (222-54 CP)",
    question:
        "La tentative pour l'infraction de port/transport A ou B sans motif légitime (222-54 CP) est :",
    options: [
      "Non (tentative : non)",
      "Oui, toujours",
      "Oui uniquement en bande organisée",
    ],
    answer: "Non (tentative : non)",
    explanation: "Dans ton cours : tentative indiquée NON pour 222-54.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Infractions — Port/Transport C ou D (L.317-8 CSI)",
    question:
        "Porter ou transporter sans motif légitime une arme de catégorie C (ou D listée), même détenue régulièrement, constitue :",
    options: ["Un délit", "Une contravention", "Un simple avertissement"],
    answer: "Un délit",
    explanation:
        "CSI L.317-8 : port/transport C ou D (liste) sans motif légitime.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Infractions — Peine C (L.317-8 2° CSI)",
    question:
        "La peine principale (simple) pour port/transport sans motif légitime d'armes de catégorie C est :",
    options: [
      "2 ans d'emprisonnement et 30 000 € d'amende",
      "5 ans d'emprisonnement et 75 000 € d'amende",
      "1 an d'emprisonnement et 15 000 € d'amende",
    ],
    answer: "2 ans d'emprisonnement et 30 000 € d'amende",
    explanation: "Tableau cours : L.317-8 2° (C) = 2 ans + 30 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Infractions — Peine D (L.317-8 3° CSI)",
    question:
        "La peine principale (simple) pour port/transport sans motif légitime d'armes de catégorie D (listées) est :",
    options: [
      "1 an d'emprisonnement et 15 000 € d'amende",
      "2 ans d'emprisonnement et 30 000 € d'amende",
      "7 ans d'emprisonnement et 100 000 € d'amende",
    ],
    answer: "1 an d'emprisonnement et 15 000 € d'amende",
    explanation: "Tableau cours : L.317-8 3° (D) = 1 an + 15 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Infractions — Aggravation (L.317-9 CSI)",
    question:
        "Une circonstance aggravante (L.317-9 CSI) pour port/transport d'armes est :",
    options: [
      "Transport par au moins deux personnes ou deux personnes trouvées porteuses",
      "Arme transportée dans une housse",
      "Arme transportée de jour",
    ],
    answer:
        "Transport par au moins deux personnes ou deux personnes trouvées porteuses",
    explanation:
        "CSI L.317-9 : aggravation si pluralité de personnes (selon cas).",
    difficulty: "Moyenne",
  ),

  // =========================
  // THÈME 6 — Autorisations / refus / mineurs / dessaisissement (CSI)
  // =========================
  const QuizQuestion(
    category: "Autorisation — Catégorie B (durée)",
    question:
        "L'autorisation d'acquisition et de détention d'une arme de catégorie B est accordée pour :",
    options: [
      "5 ans renouvelable",
      "1 an renouvelable",
      "10 ans non renouvelable",
    ],
    answer: "5 ans renouvelable",
    explanation: "CSI (R.312-13) : durée 5 ans renouvelable.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Autorisation — Catégorie B (délai acquisition)",
    question:
        "Après notification de l'autorisation B, le bénéficiaire dispose de :",
    options: [
      "6 mois pour acquérir l'arme, sinon autorisation caduque",
      "15 jours pour acquérir l'arme",
      "12 mois pour acquérir l'arme",
    ],
    answer: "6 mois pour acquérir l'arme, sinon autorisation caduque",
    explanation: "CSI (R.312-12) : délai de 6 mois après notification.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Autorisation — Renouvellement (B)",
    question:
        "La demande de renouvellement d'une autorisation B doit être déposée :",
    options: [
      "3 mois au plus tard avant expiration",
      "Le jour même de l'expiration",
      "Après expiration uniquement",
    ],
    answer: "3 mois au plus tard avant expiration",
    explanation: "CSI (R.312-14) : dépôt avant expiration, récépissé délivré.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Autorisation — Silence de l'administration",
    question:
        "Le silence gardé pendant 3 mois sur une demande d'autorisation vaut :",
    options: ["Rejet", "Acceptation", "Prolongation automatique"],
    answer: "Rejet",
    explanation: "CSI (R.312-10-1) : silence 3 mois = décision de rejet.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Refus — FINIADA",
    question: "Une autorisation A/B n'est pas accordée si le demandeur :",
    options: [
      "Est inscrit au FINIADA",
      "Possède une licence de tir",
      "A un coffre-fort homologué",
    ],
    answer: "Est inscrit au FINIADA",
    explanation:
        "CSI (R.312-21) : refus notamment en cas d'inscription FINIADA (L.312-16).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Refus — Condamnations",
    question: "L'autorisation A/B peut être refusée si le demandeur :",
    options: [
      "A été condamné pour certaines infractions figurant au B2",
      "A déjà déménagé 2 fois",
      "A eu un contrôle routier",
    ],
    answer: "A été condamné pour certaines infractions figurant au B2",
    explanation: "CSI (R.312-21) : condamnations (références L.312-3).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Refus — Comportement incompatible",
    question: "L'autorisation peut être refusée lorsque :",
    options: [
      "Le comportement est jugé incompatible par l'enquête préfectorale",
      "Le demandeur n'a pas de permis B",
      "Le demandeur refuse un entretien",
    ],
    answer: "Le comportement est jugé incompatible par l'enquête préfectorale",
    explanation:
        "CSI (R.312-21) : comportement incompatible révélé par enquête.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Mineurs — Principe",
    question:
        "Le principe pour les mineurs concernant acquisition/détention d'armes (toute catégorie) est :",
    options: [
      "Interdiction (avec exceptions prévues)",
      "Liberté en catégorie D",
      "Autorisation automatique à 16 ans",
    ],
    answer: "Interdiction (avec exceptions prévues)",
    explanation:
        "CSI (L.312-1) : interdiction de principe pour mineurs, exceptions R.312-52.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Mineurs — Plus de 9 ans",
    question:
        "Pour les mineurs de plus de 9 ans, la détention autorisée concerne :",
    options: [
      "Catégorie D (h) et (h bis) avec licence de tir en cours",
      "Catégorie B (1°) avec autorisation parentale",
      "Catégorie A2 (4°) pour reconstitution",
    ],
    answer: "Catégorie D (h) et (h bis) avec licence de tir en cours",
    explanation: "CSI (R.312-52) : > 9 ans = D(h)/(h bis) + licence.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Mineurs — Plus de 12 ans",
    question:
        "Pour les mineurs de plus de 12 ans, ils peuvent détenir des armes :",
    options: [
      "De catégorie C s'ils ont une licence de tir en cours",
      "De catégorie A sans conditions",
      "Uniquement des armes de poing",
    ],
    answer: "De catégorie C s'ils ont une licence de tir en cours",
    explanation: "CSI (R.312-52) : > 12 ans = C avec licence.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Mineurs — Plus de 16 ans",
    question:
        "Pour les mineurs de plus de 16 ans, la détention d'armes C est possible s'ils :",
    options: [
      "Sont titulaires du permis de chasser",
      "Ont une carte d'identité",
      "Ont un justificatif de domicile",
    ],
    answer: "Sont titulaires du permis de chasser",
    explanation:
        "CSI (R.312-52) : > 16 ans = C possible avec permis de chasser.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Dessaisissement — Cas général",
    question:
        "En cas d'autorisation expirée non renouvelée, le détenteur doit en principe :",
    options: [
      "Se dessaisir/neutraliser dans un délai de 3 mois",
      "Conserver l'arme jusqu'au prochain contrôle",
      "La vendre librement sans formalité",
    ],
    answer: "Se dessaisir/neutraliser dans un délai de 3 mois",
    explanation:
        "CSI (R.312-17) : dessaisissement/neutralisation dans les cas prévus, délai 3 mois.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Dessaisissement — Moyens (R.312-74)",
    question:
        "Parmi les moyens suivants, lequel fait partie des modalités de dessaisissement ?",
    options: [
      "Vente à un armurier ou à un particulier autorisé",
      "Don à n'importe quel majeur",
      "Abandon sur la voie publique",
    ],
    answer: "Vente à un armurier ou à un particulier autorisé",
    explanation:
        "CSI (R.312-74) : vente à armurier/particulier autorisé, destruction, remise à l'État, dépôt…",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Mise en possession — Arme A/B trouvée ou héritée",
    question:
        "Une personne qui trouve (ou hérite) une arme A/B et veut la conserver doit :",
    options: [
      "Déclarer sans délai via le compte individualisé (R.312-91)",
      "La garder et attendre un contrôle",
      "La vendre immédiatement sans formalité",
    ],
    answer: "Déclarer sans délai via le compte individualisé (R.312-91)",
    explanation:
        "CSI (R.312-51) : déclaration sans délai si conservation souhaitée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Mise en possession — Délai de mise en conformité A/B",
    question:
        "Après déclaration de mise en possession A/B (trouvée/succession), le délai pour remplir les conditions est :",
    options: ["12 mois", "6 mois", "3 mois"],
    answer: "12 mois",
    explanation:
        "CSI (R.312-51) : 12 mois pour remplir conditions/quotas, dépôt chez pro.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Mise en possession — Arme C trouvée/héritée",
    question:
        "Pour conserver une arme de catégorie C trouvée ou héritée, il faut notamment :",
    options: [
      "Déclarer sans délai + joindre un certificat médical de moins d'un mois",
      "Avoir une autorisation ministérielle",
      "La neutraliser obligatoirement",
    ],
    answer:
        "Déclarer sans délai + joindre un certificat médical de moins d'un mois",
    explanation:
        "CSI (R.312-55) : déclaration mise en possession + certificat médical < 1 mois.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Définitions — CSI (arme à feu)",
    question: "Au sens du CSI, une arme à feu est une arme qui :",
    options: [
      "Tire un projectile par combustion d’une charge propulsive ou peut être aisément transformée à cette fin",
      "Propulse toujours un projectile non métallique",
      "Ne fonctionne que par air comprimé",
    ],
    answer:
        "Tire un projectile par combustion d’une charge propulsive ou peut être aisément transformée à cette fin",
    explanation:
        "R.311-1 CSI 5° : arme à feu = combustion d’une charge propulsive ou transformation aisée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (canon lisse)",
    question: "Une arme à canon lisse est une arme dont :",
    options: [
      "L’âme du canon est circulaire et ne donne pas de rotation au projectile",
      "Le canon comporte des rayures polygonales",
      "Le canon est toujours inférieur à 45 cm",
    ],
    answer:
        "L’âme du canon est circulaire et ne donne pas de rotation au projectile",
    explanation:
        "R.311-1 CSI 3° : canon lisse = section circulaire, pas de rotation au projectile unique/multiple.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (canon rayé)",
    question: "Une arme à canon rayé se caractérise par :",
    options: [
      "Une ou plusieurs rayures destinées à donner une rotation au projectile",
      "Un canon obligatoirement lisse",
      "Un canon exclusivement pour munitions à blanc",
    ],
    answer:
        "Une ou plusieurs rayures destinées à donner une rotation au projectile",
    explanation:
        "R.311-1 CSI 4° : rayures conventionnelles/polygonales donnant la rotation au projectile.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (répétition automatique)",
    question: "Une arme à répétition automatique est une arme qui :",
    options: [
      "Se recharge automatiquement et peut lâcher une rafale par une seule pression sur la détente",
      "Se recharge manuellement après chaque coup",
      "Ne tire qu’un seul coup par pression",
    ],
    answer:
        "Se recharge automatiquement et peut lâcher une rafale par une seule pression sur la détente",
    explanation:
        "R.311-1 CSI 6° : auto = rechargement auto + rafale possible sur une pression.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (répétition manuelle)",
    question:
        "Une arme à répétition manuelle est une arme qui, après chaque coup :",
    options: [
      "Est rechargée manuellement par la seule action du tireur sur un mécanisme",
      "Se recharge automatiquement",
      "Tire uniquement à blanc",
    ],
    answer:
        "Est rechargée manuellement par la seule action du tireur sur un mécanisme",
    explanation:
        "R.311-1 CSI 7° : répétition manuelle = recharge manuelle via mécanisme actionné par tireur.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (arme d'épaule)",
    question: "Une arme d’épaule est une arme :",
    options: [
      "Que l’on épaule pour tirer",
      "Qui se tient d’une seule main",
      "Dont la longueur hors tout est toujours inférieure à 60 cm",
    ],
    answer: "Que l’on épaule pour tirer",
    explanation: "R.311-1 CSI 12° : arme que l’on épaule pour tirer.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (arme de poing)",
    question: "Une arme de poing est une arme :",
    options: [
      "Tenue par une poignée à l’aide d’une seule main et non destinée à être épaulée",
      "Qui se tient obligatoirement à deux mains",
      "Qui est toujours en catégorie D",
    ],
    answer:
        "Tenue par une poignée à l’aide d’une seule main et non destinée à être épaulée",
    explanation:
        "R.311-1 CSI 13° : arme de poing = tenue d’une main, non destinée à être épaulée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (longueur arme d'épaule)",
    question:
        "La longueur hors-tout d’une arme d’épaule à crosse amovible ou repliable se mesure :",
    options: [
      "Sans la crosse ou crosse repliée",
      "Crosse déployée uniquement",
      "Canon démonté uniquement",
    ],
    answer: "Sans la crosse ou crosse repliée",
    explanation:
        "R.311-1 CSI 12° : mesure hors-tout sans crosse ou crosse repliée.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (élément d'arme)",
    question:
        "Parmi ces propositions, laquelle correspond à un 'élément d’arme' (essentiel) ?",
    options: [
      "Canon / carcasse / boîte de culasse / culasse / barillet",
      "Bretelle / holster / lunette",
      "Peinture de l’arme",
    ],
    answer: "Canon / carcasse / boîte de culasse / culasse / barillet",
    explanation:
        "R.311-1 CSI 19° : éléments essentiels (canon, carcasse, boîte de culasse, culasse, barillet, systèmes de fermeture, conversion…).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (munition neutralisée)",
    question:
        "Une munition neutralisée (CSI) est une munition (diamètre < 20 mm) dont :",
    options: [
      "La chambre à poudre présente un orifice latéral ≥ 2 mm, sans poudre, amorce percutée",
      "L’étui est en plastique",
      "Le projectile est expansif",
    ],
    answer:
        "La chambre à poudre présente un orifice latéral ≥ 2 mm, sans poudre, amorce percutée",
    explanation:
        "R.311-1 CSI 26° : critères de neutralisation d’une munition (orifice ≥ 2 mm, plus de poudre, amorce percutée).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Définitions — CSI (munition neutralisée — limite)",
    question:
        "Concernant les munitions explosives ou incendiaires, même si elles sont 'neutralisées' :",
    options: [
      "Elles restent réputées fonctionnelles",
      "Elles deviennent automatiquement de catégorie D",
      "Elles sont assimilées à des munitions inertes",
    ],
    answer: "Elles restent réputées fonctionnelles",
    explanation:
        "R.311-1 CSI 26° : les munitions à chargement particulier, explosives/incendiaires restent réputées fonctionnelles.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Autres armes — Arme d'alarme (définition)",
    question:
        "Une arme d’alarme et de signalisation est un dispositif conçu uniquement pour tirer :",
    options: [
      "Munitions à blanc / substances actives / cartouches de signalisation, et non aisément transformable",
      "Projectiles métalliques de guerre",
      "Projectiles perforants",
    ],
    answer:
        "Munitions à blanc / substances actives / cartouches de signalisation, et non aisément transformable",
    explanation:
        "Définition CSI (arme d’alarme) : alimentation dédiée + non transformation aisée pour propulser un projectile par charge propulsive.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Autres armes — Arme de spectacle",
    question:
        "Une arme de spectacle est une arme à feu transformée pour tirer à blanc, et :",
    options: [
      "Reste classée dans sa catégorie originelle avant transformation",
      "Devient toujours catégorie D",
      "Devient automatiquement non classée",
    ],
    answer: "Reste classée dans sa catégorie originelle avant transformation",
    explanation:
        "Définition CSI : arme de spectacle reste dans sa catégorie d’origine.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Autres armes — Munition inerte",
    question: "Une munition inerte est :",
    options: [
      "Une munition factice qui ne peut être transformée en munition active",
      "Une munition neutralisée (avec poudre retirée) mais transformable",
      "Une douille chargée",
    ],
    answer:
        "Une munition factice qui ne peut être transformée en munition active",
    explanation:
        "Définition CSI : munition inerte = factice non transformable en active.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autres armes — Lanceur de paintball",
    question: "Un lanceur de paintball est défini comme :",
    options: [
      "Un système propulsant non pyrotechniquement un projectile laissant une trace d’impact",
      "Une arme à feu à canon lisse",
      "Un dispositif explosif",
    ],
    answer:
        "Un système propulsant non pyrotechniquement un projectile laissant une trace d’impact",
    explanation:
        "Définition CSI : lanceur de paintball = propulsion non pyrotechnique, trace visualisant l’impact.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Port/Transport — Notion clé",
    question: "Quelle phrase résume le mieux la différence port / transport ?",
    options: [
      "Port = utilisable immédiatement sur soi ; Transport = auprès de soi mais inutilisable immédiatement",
      "Port = dans un coffre ; Transport = à la ceinture",
      "Port = à domicile ; Transport = hors domicile",
    ],
    answer:
        "Port = utilisable immédiatement sur soi ; Transport = auprès de soi mais inutilisable immédiatement",
    explanation: "R.311-1 CSI : définitions du port et du transport.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — 222-52 CP (matériel)",
    question: "L’infraction 222-52 CP vise notamment :",
    options: [
      "L’acquisition, la détention ou la cession sans autorisation d’armes/munitions des catégories A ou B",
      "Le simple transport d’une arme de catégorie D ≤ 100 ml",
      "La détention d’un objet < 2 joules",
    ],
    answer:
        "L’acquisition, la détention ou la cession sans autorisation d’armes/munitions des catégories A ou B",
    explanation: "Article 222-52 CP : incrimination A/B sans autorisation.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Infractions — 222-52 CP (circonstance aggravante)",
    question: "Une circonstance aggravante prévue au 222-52 CP est notamment :",
    options: [
      "Commission par au moins deux personnes agissant en qualité d’auteur ou complice",
      "Le fait d’avoir un permis de chasser",
      "Le fait que l’arme soit neutralisée",
    ],
    answer:
        "Commission par au moins deux personnes agissant en qualité d’auteur ou complice",
    explanation:
        "222-52 CP al.3 : aggravation lorsque commis par au moins deux personnes.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Infractions — 222-52 CP (récidive spéciale)",
    question:
        "Au titre du 222-52 CP, une aggravation est prévue lorsque l’auteur a été condamné auparavant pour certaines infractions à :",
    options: [
      "Une peine ≥ 1 an d’emprisonnement ferme (infractions listées CPP 706-73/706-73-1)",
      "Une amende uniquement",
      "Une peine de sursis simple, quelle que soit la durée",
    ],
    answer:
        "Une peine ≥ 1 an d’emprisonnement ferme (infractions listées CPP 706-73/706-73-1)",
    explanation:
        "222-52 CP al.2 : aggravation en cas de condamnation antérieure (liste CPP) avec ≥ 1 an ferme.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Infractions — 222-52 CP (tentative)",
    question:
        "La tentative d’acquisition/détention/cession illégale d’armes A ou B est :",
    options: [
      "Punissable (prévue spécialement)",
      "Impossible juridiquement",
      "Punissable uniquement en récidive",
    ],
    answer: "Punissable (prévue spécialement)",
    explanation:
        "Cours : tentative prévue par l’article 222-60 CP pour ces infractions.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Infractions — 222-54 CP (tentative)",
    question:
        "La tentative de port/transport sans motif légitime d’armes A ou B (222-54 CP) est :",
    options: [
      "Non (tentative : non)",
      "Oui, toujours",
      "Oui, seulement en bande organisée",
    ],
    answer: "Non (tentative : non)",
    explanation: "Cours : 222-54 CP, tentative : NON (contrairement à 222-52).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Infractions — L.317-8 CSI (peines C)",
    question:
        "La peine principale encourue pour le port/transport sans motif légitime d’une arme de catégorie C (simple) est :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "1 an d’emprisonnement et 15 000 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation:
        "Cours : tableau répressif L.317-8 CSI (catégorie C simple) = 2 ans + 30 000 €.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Infractions — L.317-8 CSI (peines D)",
    question:
        "La peine principale encourue pour le port/transport sans motif légitime d’une arme de catégorie D (simple) est :",
    options: [
      "1 an d’emprisonnement et 15 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "1 an d’emprisonnement et 15 000 € d’amende",
    explanation: "Cours : tableau répressif pour D simple = 1 an + 15 000 €.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Infractions — L.317-9 CSI (aggravation C)",
    question:
        "En cas de circonstance aggravante (au moins deux personnes) pour catégorie C, la peine devient :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "10 ans d’emprisonnement et 500 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Cours : L.317-9 CSI (C aggravée) = 5 ans + 75 000 €.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Port/Transport — Chasse",
    question:
        "Le permis de chasser + validation de l’année en cours vaut titre de port légitime pour :",
    options: [
      "Les armes/éléments/munitions de catégorie C et les armes du a de D, en action de chasse ou activité liée",
      "Toutes armes de catégorie B",
      "Uniquement les armes de poing",
    ],
    answer:
        "Les armes/éléments/munitions de catégorie C et les armes du a de D, en action de chasse ou activité liée",
    explanation:
        "Cours : règle 'Chasse' : permis validé = titre de port légitime C + D(a) pour action de chasse/activité liée.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Port/Transport — Tir sportif",
    question:
        "La licence de tir en cours de validité vaut titre de transport légitime pour :",
    options: [
      "Les armes/éléments/systèmes d’alimentation/munitions des catégories A, B, C et D utilisés dans la pratique",
      "Uniquement la catégorie C",
      "Uniquement les armes d’alarme",
    ],
    answer:
        "Les armes/éléments/systèmes d’alimentation/munitions des catégories A, B, C et D utilisés dans la pratique",
    explanation:
        "Cours : règle 'Tir sportif' : licence = transport légitime (A/B/C + D liés à la pratique).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Autorisation — Catégorie B (durée)",
    question:
        "Une autorisation d’acquisition et de détention d’une arme de catégorie B est accordée pour une durée de :",
    options: [
      "5 ans renouvelable",
      "1 an renouvelable",
      "10 ans non renouvelable",
    ],
    answer: "5 ans renouvelable",
    explanation:
        "Cours : R.312-13 CSI : autorisation B valable 5 ans, renouvelable.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorisation — Catégorie B (renouvellement)",
    question:
        "Le détenteur d’une autorisation B doit déposer sa demande de renouvellement :",
    options: [
      "Au plus tard 3 mois avant l’expiration",
      "Au plus tard 15 jours avant l’expiration",
      "Uniquement après l’expiration",
    ],
    answer: "Au plus tard 3 mois avant l’expiration",
    explanation:
        "Cours : R.312-14 CSI : demande de renouvellement 3 mois au plus tard avant expiration.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Autorisation — Rejet implicite",
    question:
        "Pour une demande d’autorisation (A/B), le silence de l’administration pendant 3 mois vaut :",
    options: [
      "Décision de rejet",
      "Décision d’acceptation",
      "Décision de prolongation automatique",
    ],
    answer: "Décision de rejet",
    explanation: "Cours : R.312-10-1 CSI : silence 3 mois = rejet.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Refus d'autorisation — FINIADA",
    question:
        "L’autorisation d’acquisition/détention (A/B) n’est pas accordée si le demandeur :",
    options: [
      "Est inscrit au FINIADA",
      "A une licence de tir en cours",
      "Possède un coffre-fort",
    ],
    answer: "Est inscrit au FINIADA",
    explanation:
        "Cours : R.312-21 CSI : refus si situation L.312-16 (inscription FINIADA).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus d'autorisation — Condamnations",
    question:
        "L’autorisation A/B peut être refusée si le demandeur a été condamné pour certaines infractions figurant :",
    options: [
      "Au bulletin n°2 du casier judiciaire",
      "Uniquement au bulletin n°3",
      "Uniquement au TAJ",
    ],
    answer: "Au bulletin n°2 du casier judiciaire",
    explanation:
        "Cours : R.312-21 CSI : condamnations mentionnées au B2 (ou doc équivalent UE/EEE).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Refus d'autorisation — Comportement",
    question: "L’autorisation A/B peut être refusée si le demandeur présente :",
    options: [
      "Un comportement incompatible révélé par l’enquête préfectorale",
      "Une adresse en résidence secondaire",
      "Un permis de chasser non validé",
    ],
    answer: "Un comportement incompatible révélé par l’enquête préfectorale",
    explanation:
        "Cours : R.312-21 CSI : enquête diligentée par le préfet, comportement incompatible.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Refus d'autorisation — Santé",
    question: "L’autorisation A/B peut être refusée si le demandeur :",
    options: [
      "A été admis en soins psychiatriques sans consentement (sauf exception avec certificat conforme)",
      "A peur des armes",
      "Est en formation en armurerie",
    ],
    answer:
        "A été admis en soins psychiatriques sans consentement (sauf exception avec certificat conforme)",
    explanation:
        "Cours : R.312-21 CSI : soins psy sans consentement / état incompatible ; possible exception avec certificat R.312-6.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Interdiction administrative — L.312-3-1",
    question:
        "L’autorité administrative peut interdire l’acquisition et la détention des armes A/B/C si :",
    options: [
      "Le comportement laisse craindre une utilisation dangereuse pour soi ou autrui",
      "La personne est tireur sportif",
      "La personne a un coffre homologué",
    ],
    answer:
        "Le comportement laisse craindre une utilisation dangereuse pour soi ou autrui",
    explanation:
        "Cours : L.312-3-1 CSI : interdiction administrative en cas de risque d’utilisation dangereuse.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Interdiction — Ordonnance de protection",
    question:
        "Sont interdites d’acquisition et de détention d’armes de toutes catégories, les personnes faisant l’objet :",
    options: [
      "D’une interdiction dans le cadre d’une ordonnance de protection",
      "D’un simple contrôle routier",
      "D’une contravention de stationnement",
    ],
    answer: "D’une interdiction dans le cadre d’une ordonnance de protection",
    explanation:
        "Cours : L.312-3-2 CSI : interdiction toutes catégories dans le cadre d’une ordonnance de protection.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Catégorie A — Principe",
    question:
        "Le principe concernant l’acquisition et la détention des armes de catégorie A est :",
    options: [
      "Interdiction, sauf autorisations dérogatoires",
      "Libre pour les majeurs",
      "Déclaration simple",
    ],
    answer: "Interdiction, sauf autorisations dérogatoires",
    explanation:
        "Cours : L.312-2 CSI : catégorie A interdite, autorisations possibles à titre dérogatoire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Catégorie A — Agents publics",
    question:
        "Le ministère de l’Intérieur, les douanes et l’administration pénitentiaire peuvent acquérir/détenir des armes de toute catégorie :",
    options: [
      "Pour remise à leurs agents pour l’exercice des fonctions",
      "Pour les vendre au public",
      "Uniquement pour exposition en musée",
    ],
    answer: "Pour remise à leurs agents pour l’exercice des fonctions",
    explanation:
        "Cours : R.312-23 CSI : acquisition/détention toutes catégories pour remise aux agents dans l’exercice des fonctions.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Catégorie A — Spectacles",
    question:
        "Les entreprises louant des armes à des productions de films/spectacles peuvent être autorisées à détenir :",
    options: [
      "Des armes de spectacle des catégories A (et B) selon conditions",
      "Uniquement des armes de catégorie D",
      "Uniquement des armes neutralisées catégorie C",
    ],
    answer: "Des armes de spectacle des catégories A (et B) selon conditions",
    explanation:
        "Cours : R.312-26 CSI : location d’armes pour films/spectacles, autorisations possibles + munitions inertes/à blanc.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Catégorie A — Musées/collections",
    question:
        "Le préfet peut autoriser l’acquisition/détention pour exposition dans un musée ouvert au public :",
    options: [
      "D’armes et munitions de toutes catégories (selon réserves)",
      "Uniquement d’armes de catégorie D",
      "Uniquement d’armes de catégorie B",
    ],
    answer: "D’armes et munitions de toutes catégories (selon réserves)",
    explanation:
        "Cours : R.312-27 CSI : musées ouverts au public (armes/munitions de toutes catégories) sous réserves.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Catégorie A — Experts judiciaires",
    question:
        "Les experts agréés en armes et munitions peuvent être autorisés à détenir :",
    options: [
      "Certaines armes/munitions/éléments de catégorie A1 et A2 1° (selon besoins exclusifs)",
      "Toutes armes A2 sans limite",
      "Uniquement des armes de catégorie D",
    ],
    answer:
        "Certaines armes/munitions/éléments de catégorie A1 et A2 1° (selon besoins exclusifs)",
    explanation:
        "Cours : R.312-31 CSI : experts agréés peuvent être autorisés (A1 et A2 1°) en nombre nécessaire, besoins exclusifs.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Catégorie A — Limite (experts)",
    question:
        "Pour un expert judiciaire, l’autorisation de détention ne peut porter que sur :",
    options: [
      "Un seul exemplaire défini (marque, modèle, calibre, mode de tir)",
      "Autant d’armes qu’il veut",
      "Uniquement des munitions",
    ],
    answer: "Un seul exemplaire défini (marque, modèle, calibre, mode de tir)",
    explanation:
        "Cours : R.312-31 CSI : autorisation limitée à un seul exemplaire précisément défini.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Catégorie B — Décision préfectorale",
    question:
        "La décision d’autorisation B (acquisition/détention) est notifiée au demandeur dans un délai de :",
    options: ["15 jours", "48 heures", "2 mois"],
    answer: "15 jours",
    explanation:
        "Cours : décision prise par le préfet et notifiée dans un délai de 15 jours (extrait fourni).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Catégorie B — Délai d’acquisition",
    question:
        "Après notification de l’autorisation B, le bénéficiaire dispose de :",
    options: [
      "6 mois pour acquérir l’arme (sinon autorisation caduque)",
      "1 mois pour acquérir l’arme",
      "12 mois pour acquérir l’arme",
    ],
    answer: "6 mois pour acquérir l’arme (sinon autorisation caduque)",
    explanation:
        "Cours : R.312-12 CSI : 6 mois à compter de la notification, sinon caducité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Port/Transport — Dérogations",
    question: "Le port ou transport d’armes peut être autorisé si :",
    options: [
      "Un texte légal le prévoit (L.315-1 et L.315-2 CSI)",
      "La personne a une déclaration catégorie C",
      "La personne a un casier vierge",
    ],
    answer: "Un texte légal le prévoit (L.315-1 et L.315-2 CSI)",
    explanation:
        "Cours : dérogations = autorisation expresse prévue par les textes (L.315-1/L.315-2).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Port/Transport — Autorisation vs détention",
    question:
        "Une autorisation de détention d’arme (A/B) permet-elle automatiquement de la porter/transport hors domicile ?",
    options: [
      "Non, port/transport nécessitent motif légitime ou texte spécifique",
      "Oui, toujours",
      "Oui, uniquement si l’arme est déchargée",
    ],
    answer:
        "Non, port/transport nécessitent motif légitime ou texte spécifique",
    explanation:
        "Cours : détention ≠ port/transport ; hors domicile = infraction si pas de motif légitime/texte.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Port/Transport — Motif légitime (liste)",
    question:
        "Parmi ces exemples, lequel est un motif légitime de transport cité dans ton cours ?",
    options: [
      "Se rendre à une compétition ou un entraînement",
      "Aller faire des courses avec l’arme dans la poche",
      "Conserver l’arme en voiture pour se protéger",
    ],
    answer: "Se rendre à une compétition ou un entraînement",
    explanation:
        "Cours : motif légitime = déménagement, armurerie, compétition/entraînement, chasse, reconstitution historique.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Port/Transport — ERP (police/gendarmerie)",
    question:
        "Un fonctionnaire de police nationale (actif) ou un gendarme d’active peut accéder hors service à un ERP en étant porteur de son arme si :",
    options: [
      "L’arme est portée de façon non visible et il respecte les conditions prévues",
      "L’arme est visible pour dissuader",
      "Il laisse l’arme dans un sac sans surveillance",
    ],
    answer:
        "L’arme est portée de façon non visible et il respecte les conditions prévues",
    explanation:
        "Cours : R.315-11 CSI + conditions (formation à jour, ne pas se séparer, présentation carte + brassard avant point de contrôle, arme non visible).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Port/Transport — ERP (conditions)",
    question:
        "Parmi ces obligations hors service en ERP (police/gendarmerie), laquelle est correcte ?",
    options: [
      "Ne jamais se séparer de son arme",
      "Confier l’arme à un collègue à l’entrée",
      "Laisser l’arme dans un véhicule stationné",
    ],
    answer: "Ne jamais se séparer de son arme",
    explanation: "Cours : obligations ERP : ne jamais se séparer de l’arme.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Port/Transport — ERP (contrôle)",
    question:
        "Avant de franchir un point de contrôle d’accès à un ERP, le fonctionnaire hors service doit établir sa qualité par :",
    options: [
      "Présentation de la carte professionnelle et du brassard d’identification",
      "Présentation d’un justificatif de domicile",
      "Présentation d’une licence de tir",
    ],
    answer:
        "Présentation de la carte professionnelle et du brassard d’identification",
    explanation:
        "Cours : ERP : carte professionnelle + brassard d’identification avant point de contrôle.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Dessaisissement — Délai",
    question:
        "En cas de dessaisissement ordonné (dispositions générales), le détenteur dispose en principe d’un délai de :",
    options: ["3 mois", "15 jours", "12 mois"],
    answer: "3 mois",
    explanation:
        "Cours : R.312-17 / R.312-74 CSI : délai de 3 mois suivant notification (selon cas) pour se dessaisir.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Dessaisissement — Moyens",
    question:
        "Parmi ces modalités, laquelle est un moyen de dessaisissement prévu ?",
    options: [
      "Vente à un armurier ou à un particulier autorisé",
      "Don libre à un ami",
      "Abandon dans un lieu public",
    ],
    answer: "Vente à un armurier ou à un particulier autorisé",
    explanation:
        "Cours : R.312-74 CSI : vente à armurier ou particulier autorisé, destruction par armurier, remise à l’État, dépôt chez armurier désigné.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Dessaisissement — Destruction",
    question:
        "La destruction d’une arme dans le cadre du dessaisissement peut être réalisée :",
    options: [
      "Par un armurier",
      "Par n’importe quel particulier",
      "Uniquement par le détenteur lui-même à domicile",
    ],
    answer: "Par un armurier",
    explanation:
        "Cours : R.312-74 CSI : destruction par un armurier (modalité).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Mise en possession — A/B (délai de régularisation)",
    question:
        "Après déclaration d’une mise en possession d’une arme A/B (trouvée/succession) en vue de conservation, la personne dispose de :",
    options: [
      "12 mois pour remplir les conditions d’autorisation ou se mettre en conformité avec les quotas",
      "6 mois pour tout régulariser",
      "3 mois pour demander une licence de tir",
    ],
    answer:
        "12 mois pour remplir les conditions d’autorisation ou se mettre en conformité avec les quotas",
    explanation:
        "Cours : R.312-51 CSI : délai de 12 mois après déclaration pour remplir conditions/quotas, arme déposée chez pro.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Mise en possession — Catégorie C (certificat)",
    question:
        "En cas de mise en possession d’une arme de catégorie C (trouvée/succession) en vue de conservation, la personne doit notamment joindre :",
    options: [
      "Un certificat médical de moins d’un mois",
      "Un permis poids lourd",
      "Une attestation d’assurance habitation",
    ],
    answer: "Un certificat médical de moins d’un mois",
    explanation:
        "Cours : R.312-55 CSI : déclaration de mise en possession + certificat médical < 1 mois.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Infractions — L.317-8 CSI (amende forfaitaire)",
    question:
        "La procédure d’amende forfaitaire délictuelle est possible pour :",
    options: [
      "Le délit de port/transport sans motif légitime d’armes de catégorie D (sauf armes à feu)",
      "Le port/transport d’armes de catégorie A",
      "La détention illégale d’armes de catégorie B",
    ],
    answer:
        "Le délit de port/transport sans motif légitime d’armes de catégorie D (sauf armes à feu)",
    explanation:
        "Cours : dernier alinéa L.317-8 CSI : AFD possible pour D (sauf armes à feu).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Stockage — Catégorie B (obligations)",
    question: "Les armes de catégorie B doivent être conservées :",
    options: [
      "Dans un coffre-fort ou une armoire forte adaptés au type et au nombre d’armes",
      "Dans un placard fermé à clé",
      "Sous le lit, démontées",
    ],
    answer:
        "Dans un coffre-fort ou une armoire forte adaptés au type et au nombre d’armes",
    explanation:
        "Cours : R.314-2 CSI — obligation de conservation sécurisée pour la catégorie B.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Stockage — Catégorie B (munitions)",
    question: "Les munitions de catégorie B doivent être conservées :",
    options: [
      "Séparément des armes, dans des conditions empêchant l’accès libre",
      "Dans le chargeur engagé dans l’arme",
      "Obligatoirement chez un armurier",
    ],
    answer: "Séparément des armes, dans des conditions empêchant l’accès libre",
    explanation: "Cours : R.314-2 CSI — stockage distinct des munitions.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Stockage — Catégorie C",
    question: "Les armes de catégorie C doivent être conservées de manière à :",
    options: [
      "Empêcher l’accès libre, par démontage d’une pièce essentielle ou dispositif empêchant l’enlèvement",
      "Être visibles pour dissuasion",
      "Être stockées uniquement chez un armurier",
    ],
    answer:
        "Empêcher l’accès libre, par démontage d’une pièce essentielle ou dispositif empêchant l’enlèvement",
    explanation: "Cours : R.314-3 CSI — règles de conservation catégorie C.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Stockage — Catégorie D",
    question: "Les armes de catégorie D doivent être conservées :",
    options: [
      "De manière à empêcher l’accès des mineurs",
      "Sans aucune précaution",
      "Obligatoirement démontées",
    ],
    answer: "De manière à empêcher l’accès des mineurs",
    explanation: "Cours : R.314-4 CSI — obligation minimale pour catégorie D.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Transport — Sécurité",
    question: "Lors d’un transport légitime, une arme doit être :",
    options: [
      "Déchargée et rendue immédiatement inutilisable",
      "Chargée mais sous étui",
      "Portée à la ceinture",
    ],
    answer: "Déchargée et rendue immédiatement inutilisable",
    explanation:
        "Cours : principes généraux du transport légitime (arme inutilisable immédiatement).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Transport — Moyen de neutralisation",
    question:
        "Quel moyen rend une arme 'inutilisable immédiatement' lors du transport ?",
    options: [
      "Démontage d’une pièce essentielle ou verrouillage par dispositif adapté",
      "Retrait du chargeur uniquement",
      "Sécurité enclenchée",
    ],
    answer:
        "Démontage d’une pièce essentielle ou verrouillage par dispositif adapté",
    explanation:
        "Cours : sécurité transport — retrait élément essentiel ou dispositif de verrouillage.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Perte/Vol — Obligation",
    question:
        "En cas de perte ou de vol d’une arme ou de munitions, le détenteur doit :",
    options: [
      "Effectuer une déclaration sans délai aux forces de l’ordre",
      "Attendre 48 heures",
      "Informer uniquement son assurance",
    ],
    answer: "Effectuer une déclaration sans délai aux forces de l’ordre",
    explanation:
        "Cours : obligation de déclaration immédiate en cas de perte/vol.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Perte/Vol — Suite administrative",
    question: "Après déclaration de perte ou de vol, l’administration peut :",
    options: [
      "Prononcer un dessaisissement ou une interdiction administrative",
      "Accorder automatiquement une nouvelle autorisation",
      "Clore le dossier sans suite",
    ],
    answer: "Prononcer un dessaisissement ou une interdiction administrative",
    explanation: "Cours : pouvoirs du préfet en matière de sécurité publique.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cession — Catégorie C",
    question:
        "La cession d’une arme de catégorie C entre particuliers nécessite :",
    options: [
      "Le recours à un armurier ou une déclaration via le SIA",
      "Un accord verbal",
      "Une simple facture manuscrite",
    ],
    answer: "Le recours à un armurier ou une déclaration via le SIA",
    explanation:
        "Cours : cession C — traçabilité via armurier/SIA obligatoire.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cession — Catégorie B",
    question: "La cession d’une arme de catégorie B est possible uniquement :",
    options: [
      "À une personne titulaire d’une autorisation préfectorale valide",
      "À toute personne majeure",
      "À un collectionneur sans formalité",
    ],
    answer: "À une personne titulaire d’une autorisation préfectorale valide",
    explanation:
        "Cours : B — autorisation individuelle obligatoire pour l’acquéreur.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "SIA — Compte détenteur",
    question: "Le Système d’Information sur les Armes (SIA) permet notamment :",
    options: [
      "La gestion dématérialisée des armes détenues par un particulier",
      "La vente directe d’armes sans contrôle",
      "Le port d’arme dérogatoire",
    ],
    answer: "La gestion dématérialisée des armes détenues par un particulier",
    explanation:
        "Cours : SIA = traçabilité et gestion administrative des détenteurs.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "SIA — Obligation",
    question: "Tout détenteur légal d’armes doit :",
    options: [
      "Créer et maintenir à jour son compte SIA",
      "Se présenter chaque année en préfecture",
      "Déclarer uniquement les armes B",
    ],
    answer: "Créer et maintenir à jour son compte SIA",
    explanation: "Cours : obligation générale SIA pour détenteurs.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Contrôle — Forces de l’ordre",
    question:
        "Les forces de l’ordre peuvent contrôler la détention et la conservation des armes :",
    options: [
      "Dans les conditions prévues par la loi, notamment pour la sécurité publique",
      "Uniquement sur commission rogatoire",
      "Uniquement avec l’accord du détenteur",
    ],
    answer:
        "Dans les conditions prévues par la loi, notamment pour la sécurité publique",
    explanation: "Cours : pouvoirs de contrôle administrative/judiciaire.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Sanction — Non-respect stockage",
    question:
        "Le non-respect des règles de conservation des armes peut entraîner :",
    options: [
      "Des sanctions pénales et/ou administratives",
      "Aucune conséquence",
      "Uniquement un avertissement oral",
    ],
    answer: "Des sanctions pénales et/ou administratives",
    explanation: "Cours : infractions et mesures administratives possibles.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Sanction — Confiscation",
    question: "La confiscation d’armes peut être prononcée :",
    options: [
      "À titre de peine complémentaire",
      "Uniquement en cas de crime",
      "Uniquement pour la catégorie A",
    ],
    answer: "À titre de peine complémentaire",
    explanation: "Cours : confiscation possible comme peine complémentaire.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Responsabilité — Prêt d’arme",
    question: "Le prêt d’une arme est autorisé :",
    options: [
      "Uniquement dans les cas et conditions strictement prévus par la loi",
      "Libre entre particuliers majeurs",
      "S’il est de courte durée",
    ],
    answer:
        "Uniquement dans les cas et conditions strictement prévus par la loi",
    explanation:
        "Cours : prêt d’arme strictement encadré (traçabilité, autorisations).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Responsabilité — Usage",
    question: "Le détenteur légal d’une arme est responsable :",
    options: [
      "De son usage et de sa conservation",
      "Uniquement de son acquisition",
      "Uniquement si l’arme est utilisée",
    ],
    answer: "De son usage et de sa conservation",
    explanation: "Cours : responsabilité civile et pénale du détenteur.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Neutralisation — Effet juridique",
    question: "Une arme neutralisée conformément aux normes en vigueur :",
    options: [
      "Change de régime juridique selon son classement",
      "Devient toujours libre",
      "N’est plus soumise à aucune règle",
    ],
    answer: "Change de régime juridique selon son classement",
    explanation:
        "Cours : neutralisation entraîne un reclassement (souvent C/D selon cas).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Rappel — Principe général",
    question: "Quel est le principe fondamental du droit des armes en France ?",
    options: [
      "Interdiction de principe, autorisation à titre dérogatoire",
      "Liberté encadrée",
      "Autorisation générale",
    ],
    answer: "Interdiction de principe, autorisation à titre dérogatoire",
    explanation: "Cours : principe cardinal du CSI en matière d’armes.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Définitions — Arme à feu",
    question: "Une arme à feu est définie comme une arme qui :",
    options: [
      "Tire un projectile par combustion d’une charge propulsive",
      "Projette un projectile par air comprimé uniquement",
      "Utilise exclusivement une énergie mécanique",
    ],
    answer: "Tire un projectile par combustion d’une charge propulsive",
    explanation: "Article R.311-1 CSI : définition de l’arme à feu.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Arme blanche",
    question: "Une arme blanche est caractérisée par :",
    options: [
      "Une action perforante, tranchante ou brisante due à la force humaine",
      "Une action par explosion",
      "Une action par énergie électrique",
    ],
    answer:
        "Une action perforante, tranchante ou brisante due à la force humaine",
    explanation: "Article R.311-1 CSI : définition de l’arme blanche.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Arme camouflée",
    question: "Une arme camouflée est une arme :",
    options: [
      "Dissimulée sous l’apparence d’un autre objet",
      "Démontée pour le transport",
      "Neutralisée définitivement",
    ],
    answer: "Dissimulée sous l’apparence d’un autre objet",
    explanation:
        "R.311-1 CSI : arme dissimulée sous la forme d’un autre objet.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Arme d’épaule",
    question: "Une arme d’épaule est une arme :",
    options: [
      "Destinée à être épaulée pour tirer",
      "Utilisable uniquement à une main",
      "Toujours à canon lisse",
    ],
    answer: "Destinée à être épaulée pour tirer",
    explanation: "R.311-1 CSI : définition de l’arme d’épaule.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Arme de poing",
    question: "Une arme de poing se définit comme une arme :",
    options: [
      "Tenue à une main et non destinée à être épaulée",
      "Toujours semi-automatique",
      "À canon rayé uniquement",
    ],
    answer: "Tenue à une main et non destinée à être épaulée",
    explanation: "R.311-1 CSI : définition de l’arme de poing.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Élément d’arme",
    question: "Lequel est considéré comme un élément essentiel d’arme ?",
    options: ["Le canon", "La bretelle", "La crosse en bois"],
    answer: "Le canon",
    explanation:
        "R.311-1 CSI : éléments essentiels (canon, culasse, carcasse…).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Munition",
    question: "Une munition à projectile expansif est une munition :",
    options: [
      "Conçue pour champignonner à l’impact",
      "Conçue pour perforer un blindage",
      "À charge explosive",
    ],
    answer: "Conçue pour champignonner à l’impact",
    explanation: "R.311-1 CSI : munition à projectile expansif.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Munition perforante",
    question: "Une munition perforante est caractérisée notamment par :",
    options: [
      "Un noyau dur en acier ou carbure de tungstène",
      "Une enveloppe plastique",
      "Une charge incendiaire",
    ],
    answer: "Un noyau dur en acier ou carbure de tungstène",
    explanation: "R.311-1 CSI : définition des munitions perforantes.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Neutralisation — Définition",
    question: "Une arme neutralisée est une arme :",
    options: [
      "Rendue définitivement impropre au tir",
      "Simplement démontée",
      "Dont les munitions ont été retirées",
    ],
    answer: "Rendue définitivement impropre au tir",
    explanation:
        "R.311-1 CSI : neutralisation définitive selon procédés techniques.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Port et transport — Principe",
    question: "Pour un particulier, le port d’arme est en principe :",
    options: [
      "Interdit sauf exceptions légales",
      "Libre pour les catégories C et D",
      "Autorisé avec une simple déclaration",
    ],
    answer: "Interdit sauf exceptions légales",
    explanation:
        "CSI : principe d’interdiction du port d’arme pour les particuliers.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Transport — Motif légitime",
    question: "Constitue un motif légitime de transport d’arme :",
    options: [
      "Se rendre à un stand de tir",
      "Se promener en centre-ville",
      "Aller faire des courses",
    ],
    answer: "Se rendre à un stand de tir",
    explanation:
        "CSI : transport légitime pour tir sportif, chasse, réparation.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Transport — Appréciation",
    question: "L’existence d’un motif légitime de transport est appréciée :",
    options: [
      "Par les forces de l’ordre selon les circonstances",
      "Uniquement par le détenteur",
      "Uniquement par le juge",
    ],
    answer: "Par les forces de l’ordre selon les circonstances",
    explanation: "Cours : appréciation concrète du motif légitime.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Infractions — Élément moral",
    question: "Le port ou transport illégal d’arme est une infraction :",
    options: [
      "Intentionnelle",
      "Non intentionnelle",
      "Purement administrative",
    ],
    answer: "Intentionnelle",
    explanation: "L’auteur a conscience de violer la loi.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — Circonstance aggravante",
    question:
        "Le port d’arme illégal commis par plusieurs personnes constitue :",
    options: [
      "Une circonstance aggravante",
      "Une cause d’exonération",
      "Une simple contravention",
    ],
    answer: "Une circonstance aggravante",
    explanation:
        "CSI : aggravation lorsque plusieurs personnes sont impliquées.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Autorisation — Principe",
    question: "L’autorisation de détention d’arme est juridiquement :",
    options: [
      "Une dérogation à un principe d’interdiction",
      "Un droit fondamental",
      "Automatique pour les majeurs",
    ],
    answer: "Une dérogation à un principe d’interdiction",
    explanation:
        "Cours : interdiction de principe, autorisation exceptionnelle.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorisation — Durée",
    question:
        "Une autorisation de détention d’arme de catégorie B est valable :",
    options: ["5 ans renouvelables", "1 an non renouvelable", "10 ans"],
    answer: "5 ans renouvelables",
    explanation: "R.312-13 CSI : durée de validité des autorisations B.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorisation — Silence administratif",
    question:
        "Le silence de l’administration pendant 3 mois sur une demande d’autorisation vaut :",
    options: ["Décision de rejet", "Acceptation tacite", "Suspension du délai"],
    answer: "Décision de rejet",
    explanation: "R.312-10-1 CSI : silence = rejet.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Dessaisissement — Principe",
    question:
        "Lorsqu’une autorisation arrive à expiration sans renouvellement, le détenteur doit :",
    options: [
      "Se dessaisir de l’arme dans un délai légal",
      "Conserver l’arme sans formalité",
      "La prêter à un tiers",
    ],
    answer: "Se dessaisir de l’arme dans un délai légal",
    explanation: "R.312-17 CSI : obligation de dessaisissement.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Dessaisissement — Modalités",
    question: "Parmi les moyens légaux de dessaisissement figure :",
    options: [
      "La remise à l’État pour destruction",
      "L’abandon dans un lieu public",
      "La revente libre",
    ],
    answer: "La remise à l’État pour destruction",
    explanation: "R.312-74 CSI : modalités légales de dessaisissement.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Principe général — Sécurité publique",
    question: "La réglementation des armes vise principalement à :",
    options: [
      "Garantir l’ordre et la sécurité publics",
      "Favoriser la collection privée",
      "Encourager la détention d’armes",
    ],
    answer: "Garantir l’ordre et la sécurité publics",
    explanation: "Finalité essentielle de la loi sur les armes.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Classification — Catégorie A",
    question:
        "Quel est le principe juridique applicable aux armes de catégorie A ?",
    options: [
      "Interdiction d’acquisition et de détention sauf dérogation",
      "Autorisation préfectorale simple",
      "Déclaration obligatoire",
    ],
    answer: "Interdiction d’acquisition et de détention sauf dérogation",
    explanation: "Article L.312-2 CSI : catégorie A interdite par principe.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1",
    question:
        "Une arme d’épaule semi-automatique dont la longueur peut être réduite à moins de 60 cm est classée :",
    options: ["Catégorie A1", "Catégorie B", "Catégorie C"],
    answer: "Catégorie A1",
    explanation: "R.311-2 CSI A1 12° : longueur réduite < 60 cm.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A2",
    question:
        "Les véhicules de combat équipés pour le montage d’armes relèvent de :",
    options: ["Catégorie A2", "Catégorie A1", "Catégorie B"],
    answer: "Catégorie A2",
    explanation: "R.311-2 CSI A2 8° : véhicules de combat armés.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B",
    question:
        "Une arme à impulsion électrique permettant un tir à distance est classée :",
    options: ["Catégorie B", "Catégorie D", "Catégorie C"],
    answer: "Catégorie B",
    explanation: "R.311-2 CSI B 6° : armes à impulsion électrique à distance.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B",
    question:
        "Les générateurs d’aérosols incapacitants de plus de 100 ml sont classés :",
    options: ["Catégorie B", "Catégorie D", "Catégorie C"],
    answer: "Catégorie B",
    explanation: "R.311-2 CSI B 8°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie C",
    question:
        "Une arme d’épaule à répétition manuelle d’une capacité maximale de 11 coups est :",
    options: ["Catégorie C", "Catégorie B", "Catégorie D"],
    answer: "Catégorie C",
    explanation: "R.311-2 CSI C 1° b.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie C",
    question: "Une arme neutralisée selon les normes officielles relève de :",
    options: ["Catégorie C", "Catégorie A", "Aucune catégorie"],
    answer: "Catégorie C",
    explanation: "R.311-2 CSI C 9°.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie D",
    question: "Les couteaux et poignards sont classés :",
    options: ["Catégorie D", "Catégorie C", "Catégorie B"],
    answer: "Catégorie D",
    explanation: "R.311-2 CSI IV a.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Munition",
    question: "Une douille amorcée est une douille :",
    options: [
      "Contenant une amorce sans poudre",
      "Contenant une charge de poudre",
      "Totalement vide",
    ],
    answer: "Contenant une amorce sans poudre",
    explanation: "R.311-1 CSI 17°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Munition",
    question: "Une munition neutralisée doit obligatoirement :",
    options: [
      "Avoir l’amorce percutée et un orifice latéral",
      "Être peinte en rouge",
      "Être coupée en deux",
    ],
    answer: "Avoir l’amorce percutée et un orifice latéral",
    explanation: "R.311-1 CSI 26°.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Port et transport — Principe",
    question: "Le transport d’une arme sans motif légitime constitue :",
    options: [
      "Un délit",
      "Une contravention",
      "Une simple infraction administrative",
    ],
    answer: "Un délit",
    explanation: "Articles L.317-8 et 222-54 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Port et transport — Domicile",
    question: "Le domicile inclut également :",
    options: [
      "Les dépendances normalement closes",
      "Les lieux publics",
      "Les véhicules en circulation",
    ],
    answer: "Les dépendances normalement closes",
    explanation: "Notion jurisprudentielle du domicile.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Port et transport — Catégories A et B",
    question:
        "Pour les catégories A et B, le transport est autorisé uniquement :",
    options: ["Avec motif légitime", "Avec une déclaration", "Libre"],
    answer: "Avec motif légitime",
    explanation: "Article 222-54 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — Élément matériel",
    question: "La détention d’arme suppose :",
    options: [
      "Une maîtrise de fait de l’arme",
      "La propriété juridique",
      "L’usage effectif",
    ],
    answer: "Une maîtrise de fait de l’arme",
    explanation: "Définition pénale de la détention.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Infractions — Élément moral",
    question: "L’auteur doit avoir conscience :",
    options: [
      "De ne pas être autorisé",
      "Du calibre exact",
      "Du numéro de série",
    ],
    answer: "De ne pas être autorisé",
    explanation: "Élément intentionnel requis.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — Circonstance aggravante",
    question: "La récidive légale entraîne :",
    options: [
      "Une aggravation des peines",
      "Une amende forfaitaire",
      "Une relaxe",
    ],
    answer: "Une aggravation des peines",
    explanation: "Article 222-52 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Peines — Tentative",
    question: "La tentative de détention illégale d’arme est :",
    options: ["Punissable", "Non punissable", "Une contravention"],
    answer: "Punissable",
    explanation: "Article 222-60 CP.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Peines — Exemption",
    question: "Une personne peut être exemptée de peine si elle :",
    options: [
      "A permis d’éviter l’infraction",
      "Est primo-délinquante",
      "Est mineure",
    ],
    answer: "A permis d’éviter l’infraction",
    explanation: "Article 222-67-1 CP.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Autorisation — Acquisition",
    question:
        "Après notification, le délai pour acquérir une arme de catégorie B est de :",
    options: ["6 mois", "3 mois", "1 an"],
    answer: "6 mois",
    explanation: "R.312-12 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorisation — Renouvellement",
    question: "La demande de renouvellement doit être déposée :",
    options: ["3 mois avant expiration", "À expiration", "Après expiration"],
    answer: "3 mois avant expiration",
    explanation: "R.312-14 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Mineurs — Principe",
    question: "L’acquisition d’armes par un mineur est :",
    options: [
      "Interdite sauf exceptions légales",
      "Libre en catégorie D",
      "Autorisé avec accord parental",
    ],
    answer: "Interdite sauf exceptions légales",
    explanation: "Article L.312-1 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Mineurs — Catégorie D",
    question:
        "Un mineur de plus de 9 ans peut détenir certaines armes de catégorie D s’il possède :",
    options: [
      "Une licence de tir",
      "Un permis de chasser",
      "Une carte de collectionneur",
    ],
    answer: "Une licence de tir",
    explanation: "R.312-52 CSI.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Mineurs — Catégorie C",
    question:
        "À partir de quel âge un mineur peut-il détenir une arme de catégorie C avec licence ?",
    options: ["12 ans", "9 ans", "16 ans"],
    answer: "12 ans",
    explanation: "R.312-52 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Dessaisissement — Délai",
    question: "Le délai général pour se dessaisir d’une arme est de :",
    options: ["3 mois", "1 mois", "6 mois"],
    answer: "3 mois",
    explanation: "R.312-74 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Dessaisissement — Modalité",
    question: "La destruction d’une arme doit être effectuée par :",
    options: ["Un armurier", "Le détenteur", "La mairie"],
    answer: "Un armurier",
    explanation: "R.312-74 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Traçabilité",
    question: "La traçabilité vise à :",
    options: [
      "Identifier les détenteurs successifs",
      "Autoriser le port",
      "Faciliter la vente",
    ],
    answer: "Identifier les détenteurs successifs",
    explanation: "R.311-1 CSI 11°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Activités — Armurier",
    question:
        "Est considéré comme armurier toute personne dont l’activité consiste à :",
    options: [
      "Fabriquer, réparer ou vendre des armes",
      "Porter une arme",
      "Collectionner des armes",
    ],
    answer: "Fabriquer, réparer ou vendre des armes",
    explanation: "R.311-1 CSI 3°.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Définitions — Système d’alimentation",
    question: "Un chargeur amovible est juridiquement considéré comme :",
    options: [
      "Un système d’alimentation",
      "Un accessoire non réglementé",
      "Une munition",
    ],
    answer: "Un système d’alimentation",
    explanation: "R.311-1 CSI 27° : chargeurs = systèmes d’alimentation.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Élément de munition",
    question:
        "Parmi les éléments suivants, lequel est un élément de munition ?",
    options: ["L’amorce", "La détente", "La crosse"],
    answer: "L’amorce",
    explanation: "R.311-1 CSI 21°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Munition incendiaire",
    question: "Une munition incendiaire se caractérise par :",
    options: [
      "Un mélange chimique s’enflammant à l’impact ou au contact de l’air",
      "Un noyau en acier",
      "Une charge pyrotechnique neutre",
    ],
    answer:
        "Un mélange chimique s’enflammant à l’impact ou au contact de l’air",
    explanation: "R.311-1 CSI 24°.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Définitions — Munition explosive",
    question: "Une munition explosive contient :",
    options: [
      "Une charge explosant lors de l’impact",
      "Une charge de poudre classique",
      "Un noyau perforant",
    ],
    answer: "Une charge explosant lors de l’impact",
    explanation: "R.311-1 CSI 23°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1",
    question: "Les éléments d’armes relevant de la catégorie A1 sont :",
    options: [
      "Classés eux-mêmes en catégorie A1",
      "Libres",
      "Classés en catégorie C",
    ],
    answer: "Classés eux-mêmes en catégorie A1",
    explanation: "R.311-2 CSI A1 7°.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1",
    question:
        "Un chargeur d’arme de poing contenant plus de 20 munitions est classé :",
    options: ["Catégorie A1", "Catégorie B", "Catégorie C"],
    answer: "Catégorie A1",
    explanation: "R.311-2 CSI A1 8°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A1",
    question:
        "Un chargeur d’arme d’épaule à percussion centrale contenant 15 coups est :",
    options: ["Catégorie A1", "Catégorie B", "Catégorie C"],
    answer: "Catégorie A1",
    explanation: "R.311-2 CSI A1 9° bis : >10 coups.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie A2",
    question:
        "Les matériels de cryptologie conçus pour l’usage militaire sont classés :",
    options: ["Catégorie A2", "Catégorie A1", "Catégorie B"],
    answer: "Catégorie A2",
    explanation: "R.311-2 CSI A2 13°.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B",
    question:
        "Une arme d’épaule à répétition manuelle d’une capacité de 20 coups est :",
    options: ["Catégorie B", "Catégorie C", "Catégorie A1"],
    answer: "Catégorie B",
    explanation: "R.311-2 CSI B 2° b : >11 coups.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie B",
    question:
        "Une arme à répétition manuelle à canon lisse avec pompe est classée :",
    options: ["Catégorie B", "Catégorie C", "Catégorie D"],
    answer: "Catégorie B",
    explanation: "R.311-2 CSI B 2° f.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie C",
    question: "Une arme à un coup par canon relève de :",
    options: ["Catégorie C", "Catégorie D", "Catégorie B"],
    answer: "Catégorie C",
    explanation: "R.311-2 CSI C 1° c.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie C",
    question:
        "Les systèmes d’alimentation des armes de catégorie C sont classés :",
    options: ["Catégorie C", "Catégorie D", "Catégorie B"],
    answer: "Catégorie C",
    explanation: "R.311-2 CSI C 10°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie D",
    question: "Une arme à impulsion électrique de contact est classée :",
    options: [
      "Catégorie D sauf classement contraire",
      "Catégorie B automatiquement",
      "Catégorie C",
    ],
    answer: "Catégorie D sauf classement contraire",
    explanation: "R.311-2 CSI IV c.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — Catégorie D",
    question: "Une arme factice développe une énergie à la bouche :",
    options: [
      "Inférieure à 2 joules",
      "Entre 2 et 20 joules",
      "Supérieure à 20 joules",
    ],
    answer: "Inférieure à 2 joules",
    explanation: "R.311-1 CSI 5°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Port et transport — Notion",
    question: "Le port d’arme se distingue du transport car l’arme est :",
    options: ["Utilisable immédiatement", "Déchargée", "Placée dans un étui"],
    answer: "Utilisable immédiatement",
    explanation: "R.311-1 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Port et transport — Lieu",
    question: "Le port d’arme est interdit :",
    options: [
      "Hors du domicile",
      "Uniquement sur la voie publique",
      "Uniquement en centre-ville",
    ],
    answer: "Hors du domicile",
    explanation: "Principe général CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Port et transport — Autorisation",
    question: "Une autorisation de détention permet-elle le port d’arme ?",
    options: ["Non", "Oui automatiquement", "Oui avec déclaration"],
    answer: "Non",
    explanation: "Détention ≠ port ou transport.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — Détention",
    question: "La détention d’arme est caractérisée même si :",
    options: [
      "La personne n’est pas propriétaire",
      "L’arme est inutilisée",
      "L’arme est démontée",
    ],
    answer: "La personne n’est pas propriétaire",
    explanation: "Maîtrise de fait suffisante.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Infractions — Tentative",
    question: "La tentative d’acquisition illégale d’arme est :",
    options: ["Punissable", "Non punissable", "Une contravention"],
    answer: "Punissable",
    explanation: "Article 222-60 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — Complicité",
    question: "La complicité en matière d’infraction sur les armes est :",
    options: ["Punissable", "Exclue", "Limitée aux professionnels"],
    answer: "Punissable",
    explanation: "Règles générales du Code pénal.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Peines — Aggravation",
    question: "L’infraction est aggravée lorsqu’elle est commise :",
    options: ["Par plusieurs personnes", "Par un majeur", "De nuit"],
    answer: "Par plusieurs personnes",
    explanation: "Articles 222-52 et 222-54 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Peines — Personnes morales",
    question: "Les personnes morales peuvent être pénalement responsables :",
    options: ["Oui", "Non", "Uniquement en matière administrative"],
    answer: "Oui",
    explanation: "Article 222-61 CP.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Autorisation — Nature juridique",
    question: "L’autorisation préfectorale est :",
    options: ["Révocable", "Définitive", "Un droit acquis"],
    answer: "Révocable",
    explanation: "Articles L.312-7 et L.312-11 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorisation — Retrait",
    question: "Une autorisation peut être retirée pour :",
    options: [
      "Raison d’ordre public",
      "Simple changement d’adresse",
      "Demande du voisinage",
    ],
    answer: "Raison d’ordre public",
    explanation: "L.312-11 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "FINIADA",
    question: "L’inscription au FINIADA entraîne :",
    options: [
      "Interdiction d’acquisition et de détention",
      "Simple surveillance",
      "Restriction partielle",
    ],
    answer: "Interdiction d’acquisition et de détention",
    explanation: "L.312-16 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "FINIADA",
    question: "Le FINIADA est un fichier :",
    options: ["Administratif", "Judiciaire uniquement", "Privé"],
    answer: "Administratif",
    explanation: "Gestion préfectorale.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Saisie administrative",
    question: "Toutes les catégories d’armes peuvent faire l’objet :",
    options: [
      "D’une saisie administrative",
      "D’une saisie judiciaire uniquement",
      "D’aucune saisie",
    ],
    answer: "D’une saisie administrative",
    explanation: "Évolution de la loi de 2012.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Dessaisissement — Obligation",
    question: "Le dessaisissement peut être ordonné par :",
    options: ["Le préfet", "Le maire", "L’armurier"],
    answer: "Le préfet",
    explanation: "L.312-11 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Dessaisissement — Urgence",
    question: "En cas d’urgence, la procédure de dessaisissement est :",
    options: ["Non contradictoire", "Toujours contradictoire", "Suspendue"],
    answer: "Non contradictoire",
    explanation: "L.312-11 CSI.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Mise en possession",
    question: "Une arme trouvée doit être :",
    options: [
      "Déclarée sans délai",
      "Conservée temporairement",
      "Remise à un tiers",
    ],
    answer: "Déclarée sans délai",
    explanation: "R.312-51 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Mise en possession",
    question:
        "Le délai maximal pour se mettre en conformité après découverte est de :",
    options: ["12 mois", "6 mois", "3 mois"],
    answer: "12 mois",
    explanation: "R.312-51 CSI.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Définitions — Arme à répétition automatique",
    question: "Une arme à répétition automatique se caractérise par :",
    options: [
      "Le tir en rafale par une seule pression sur la détente",
      "Un tir coup par coup uniquement",
      "Un rechargement manuel après chaque tir",
    ],
    answer: "Le tir en rafale par une seule pression sur la détente",
    explanation: "R.311-1 CSI 6°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Arme à un coup",
    question: "Une arme à un coup est une arme :",
    options: [
      "Sans système d’alimentation",
      "À chargeur amovible",
      "Semi-automatique",
    ],
    answer: "Sans système d’alimentation",
    explanation: "R.311-1 CSI 9°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Canon lisse",
    question: "Un canon lisse est un canon :",
    options: ["Sans rayures internes", "Polygonal", "À rotation du projectile"],
    answer: "Sans rayures internes",
    explanation: "R.311-1 CSI 3°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Définitions — Canon rayé",
    question: "Le rôle principal des rayures d’un canon est :",
    options: [
      "Donner une rotation au projectile",
      "Augmenter la puissance explosive",
      "Réduire le bruit",
    ],
    answer: "Donner une rotation au projectile",
    explanation: "R.311-1 CSI 4°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — A1",
    question:
        "Une arme automatique transformée en semi-automatique reste classée :",
    options: ["Catégorie A1", "Catégorie B", "Catégorie C"],
    answer: "Catégorie A1",
    explanation: "R.311-2 CSI A1 11°.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — A1",
    question:
        "Un chargeur d’arme d’épaule à percussion annulaire de 35 coups est :",
    options: ["Catégorie A1", "Catégorie B", "Catégorie C"],
    answer: "Catégorie A1",
    explanation: "R.311-2 CSI A1 9°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — A2",
    question: "Les grenades, chargées ou non, relèvent de :",
    options: ["Catégorie A2", "Catégorie A1", "Catégorie B"],
    answer: "Catégorie A2",
    explanation: "R.311-2 CSI A2 6°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — A2",
    question:
        "Les matériels de vision nocturne exclusivement militaires sont classés :",
    options: ["Catégorie A2", "Catégorie B", "Catégorie D"],
    answer: "Catégorie A2",
    explanation: "R.311-2 CSI A2 14°.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Classification — B",
    question:
        "Une arme d’épaule dont la longueur totale est inférieure à 80 cm est :",
    options: ["Catégorie B", "Catégorie C", "Catégorie A1"],
    answer: "Catégorie B",
    explanation: "R.311-2 CSI B 2° c.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Classification — B",
    question:
        "Une arme semi-automatique ayant l’apparence d’une arme automatique est :",
    options: ["Catégorie B", "Catégorie A1", "Catégorie C"],
    answer: "Catégorie B",
    explanation: "R.311-2 CSI B 2° e.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — C",
    question:
        "Une arme à répétition manuelle à pompe répondant aux critères légaux est :",
    options: ["Catégorie C", "Catégorie B", "Catégorie D"],
    answer: "Catégorie C",
    explanation: "R.311-2 CSI C 1° d.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Classification — D",
    question:
        "Une arme développant une énergie comprise entre 2 et 20 joules est :",
    options: ["Catégorie D", "Catégorie C", "Non classée"],
    answer: "Catégorie D",
    explanation: "R.311-2 CSI IV h.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Port et transport — Domicile",
    question: "Un véhicule peut être assimilé au domicile lorsque :",
    options: [
      "Il constitue le lieu de vie habituel",
      "Il est stationné",
      "Il est verrouillé",
    ],
    answer: "Il constitue le lieu de vie habituel",
    explanation: "Notion jurisprudentielle du domicile.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Port et transport — Cas pratique",
    question:
        "Un tireur sportif transporte son arme chargée dans un sac fermé. Il est :",
    options: [
      "En infraction",
      "En situation régulière",
      "Sous simple avertissement",
    ],
    answer: "En infraction",
    explanation: "Arme utilisable immédiatement = port dissimulé.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Port et transport — Cas pratique",
    question:
        "Un chasseur transporte son arme démontée dans le coffre. Il est :",
    options: [
      "En transport légitime",
      "En port illégal",
      "En détention illicite",
    ],
    answer: "En transport légitime",
    explanation: "Transport inutilisable immédiatement + motif légitime.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — Élément légal",
    question:
        "Le fondement légal du port sans autorisation d’arme de catégorie B est :",
    options: ["Article 222-54 CP", "Article L.317-8 CSI", "Article 222-52 CP"],
    answer: "Article 222-54 CP",
    explanation: "Port et transport A/B.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Infractions — Élément matériel",
    question: "Le port d’arme suppose que l’arme soit :",
    options: ["Utilisable immédiatement", "Chargée", "Visible"],
    answer: "Utilisable immédiatement",
    explanation: "Définition légale du port.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — Élément moral",
    question: "L’infraction de port d’arme sans autorisation est :",
    options: ["Intentionnelle", "Non intentionnelle", "Matérielle"],
    answer: "Intentionnelle",
    explanation: "Conscience de violer la loi.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Peines — Catégorie C",
    question:
        "Le port sans motif légitime d’une arme de catégorie C est puni de :",
    options: [
      "2 ans d’emprisonnement et 30 000 €",
      "5 ans et 75 000 €",
      "1 an et 15 000 €",
    ],
    answer: "2 ans d’emprisonnement et 30 000 €",
    explanation: "Article L.317-8 CSI.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Peines — Catégorie D",
    question:
        "Le port sans motif légitime d’une arme de catégorie D est puni de :",
    options: [
      "1 an d’emprisonnement et 15 000 €",
      "2 ans et 30 000 €",
      "5 ans et 75 000 €",
    ],
    answer: "1 an d’emprisonnement et 15 000 €",
    explanation: "Article L.317-8 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Peines — Aggravation",
    question:
        "Le transport d’armes effectué par plusieurs personnes entraîne :",
    options: [
      "Une circonstance aggravante",
      "Une nullité",
      "Une contravention",
    ],
    answer: "Une circonstance aggravante",
    explanation: "L.317-9 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorisation — Refus",
    question: "Une autorisation peut être refusée en cas de :",
    options: ["Comportement incompatible", "Absence d’arme", "Domicile fixe"],
    answer: "Comportement incompatible",
    explanation: "R.312-21 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorisation — Psychiatrique",
    question:
        "Une personne ayant fait l’objet de soins psychiatriques sans consentement :",
    options: [
      "Peut se voir refuser une autorisation",
      "Est automatiquement autorisée",
      "N’est jamais concernée",
    ],
    answer: "Peut se voir refuser une autorisation",
    explanation: "R.312-21 CSI.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Dessaisissement — Succession",
    question: "Une arme héritée sans autorisation doit être :",
    options: [
      "Déclarée puis déposée chez un professionnel",
      "Conservée librement",
      "Vendues immédiatement",
    ],
    answer: "Déclarée puis déposée chez un professionnel",
    explanation: "R.312-51 CSI.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Dessaisissement — Non-respect",
    question: "À défaut de mise en conformité, le préfet peut :",
    options: [
      "Ordonner le dessaisissement",
      "Classer sans suite",
      "Accorder un délai illimité",
    ],
    answer: "Ordonner le dessaisissement",
    explanation: "R.312-51 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Traçabilité",
    question: "Le marquage d’une arme permet :",
    options: [
      "Son identification et sa traçabilité",
      "Son autorisation de port",
      "Sa neutralisation",
    ],
    answer: "Son identification et sa traçabilité",
    explanation: "R.311-5 CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Trafic illicite",
    question: "Le transport d’armes sans marquage constitue :",
    options: [
      "Un trafic illicite",
      "Une contravention",
      "Un simple manquement",
    ],
    answer: "Un trafic illicite",
    explanation: "R.311-1 CSI 12°.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Principe général",
    question: "La loi de 2012 sur les armes vise notamment à :",
    options: [
      "Renforcer la sécurité publique",
      "Libéraliser la détention",
      "Supprimer les contrôles",
    ],
    answer: "Renforcer la sécurité publique",
    explanation: "Loi n°2012-304.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Principe général",
    question: "Le régime des armes repose sur une logique de :",
    options: [
      "Prévention des risques",
      "Libéralisation",
      "Autonomie individuelle",
    ],
    answer: "Prévention des risques",
    explanation: "Finalité du CSI.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Activités — Trafic",
    question: "Le trafic illicite d’armes suppose :",
    options: [
      "L’absence d’autorisations légales",
      "Un transport légitime",
      "Une simple négligence",
    ],
    answer: "L’absence d’autorisations légales",
    explanation: "R.311-1 CSI 12°.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Principe fondamental",
    question: "Le droit des armes repose sur une logique de :",
    options: [
      "Prévention et sécurité",
      "Liberté individuelle",
      "Autonomie privée",
    ],
    answer: "Prévention et sécurité",
    explanation: "Finalité du dispositif législatif.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Port/Transport — Collectionneur",
    question:
        "La carte de collectionneur vaut titre de transport légitime pour :",
    options: [
      "Les armes de catégorie C pour activités liées à exposition/conservation/étude",
      "Les armes de catégorie A2 non neutralisées",
      "Toutes armes de catégorie D",
    ],
    answer:
        "Les armes de catégorie C pour activités liées à exposition/conservation/étude",
    explanation:
        "Cours : 'Collectionneurs' : carte = transport légitime des armes de catégorie C pour activités liées.",
    difficulty: "Moyenne",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizArmesMunitionsPA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName =
      '/pa/armes_munitions_pages/quiz/pa_quiz_armes_munitions_pages';
  final String uid;
  final String email;

  const QuizArmesMunitionsPA({super.key, required this.uid, required this.email});

  @override
  State<QuizArmesMunitionsPA> createState() => _QuizArmesMunitionsPAState();
}

class _QuizArmesMunitionsPAState extends State<QuizArmesMunitionsPA>
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
  static const _introHiddenKey = 'intro_pa_armes_munitions';
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
        ? questionArmesMunitions
        : questionArmesMunitions
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
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Classification des armes et des munitions',
            'quiz_name': 'Quiz classification des armes et des munitions',
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
      await _sb.from('quiz_armes_munitions_pages').insert({
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
      debugPrint('❌ quiz_armes_munitions_pages insert failed: $e');
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
      'source_file': 'pa_quiz_armes_munitions_pages',
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

                        if (_showIntro)
                          _IntroSplash(
                            isDark: isDark,
                            hideForever: _hideIntroForever,
                            onChangedHideForever: _saveIntroPreference,
                            onStart: () async { await _doStartQuiz(); },
                            icon: Icons.security_rounded,
                            title: 'Armes et munitions',
                            description: 'Maîtrise la réglementation sur les armes : classification, autorisations, infractions liées à la détention et au port d’armes en France.',
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
