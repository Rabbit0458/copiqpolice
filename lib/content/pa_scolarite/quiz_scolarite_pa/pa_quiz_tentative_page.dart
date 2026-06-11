// ignore_for_file: use_build_context_synchronously

// ============================================================================
//  Quiz Tentative – version refondue
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

// ---------------------------------------------------------------
// BANQUE DES QUESTIONS : colle exactement ce que tu avais déjà.
// (tronqué ici pour la réponse ; garde ta liste complète existante)
// ---------------------------------------------------------------

final List<QuizQuestion> questionsTentative = [
  // =========================
  // ======== FACILE =========
  // =========================

  // — ÉLÉMENT LÉGAL (Facile)
  const QuizQuestion(
    category: 'Élément légal',
    difficulty: 'Facile',
    question: 'Quel article du Code pénal définit la tentative punissable ?',
    options: [
      'Article 121-3 du Code pénal',
      'Article 121-4 du Code pénal',
      'Article 121-5 du Code pénal',
    ],
    answer: 'Article 121-5 du Code pénal',
    explanation:
        'L’article 121-5 définit la tentative comme le fait de commencer l’exécution d’un crime ou d’un délit et de ne pas la mener à son terme pour une cause indépendante de la volonté de l’auteur.',
  ),
  const QuizQuestion(
    category: 'Élément légal',
    difficulty: 'Facile',
    question:
        'Selon l’article 121-4 du Code pénal, quand la tentative est-elle punissable ?',
    options: [
      'Uniquement pour les crimes',
      'Pour les crimes et pour les délits lorsque la loi le prévoit',
      'Pour les crimes, les délits et les contraventions',
    ],
    answer: 'Pour les crimes et pour les délits lorsque la loi le prévoit',
    explanation:
        'La tentative est toujours punissable pour les crimes et punissable pour les délits uniquement si un texte l’énonce. Elle n’est pas applicable aux contraventions.',
  ),
  const QuizQuestion(
    category: 'Élément légal',
    difficulty: 'Facile',
    question:
        'La tentative est-elle réprimée pour les contraventions en droit pénal français ?',
    options: [
      'Oui, toujours',
      'Non, jamais',
      'Uniquement si la loi le prévoit',
    ],
    answer: 'Non, jamais',
    explanation:
        'Le régime des contraventions ne réprime pas la tentative : seules les infractions consommées sont sanctionnées.',
  ),

  // — ÉLÉMENT MATÉRIEL (Facile)
  const QuizQuestion(
    category: 'Élément matériel',
    difficulty: 'Facile',
    question:
        'Qu’appelle-t-on « commencement d’exécution » en matière de tentative ?',
    options: [
      'Un simple projet criminel',
      'Un acte tendant directement et immédiatement à la réalisation de l’infraction',
      'La consommation intégrale de l’infraction',
    ],
    answer:
        'Un acte tendant directement et immédiatement à la réalisation de l’infraction',
    explanation:
        'Le commencement d’exécution suppose un acte qui manifeste la volonté de commettre l’infraction et qui tend directement à sa consommation.',
  ),
  const QuizQuestion(
    category: 'Élément matériel',
    difficulty: 'Facile',
    question:
        'Quel exemple correspond à un acte préparatoire (donc non punissable) ?',
    options: [
      'Achat d’un pied-de-biche',
      'Forcer une serrure',
      'Introduire une fausse clé dans une serrure',
    ],
    answer: 'Achat d’un pied-de-biche',
    explanation:
        'Un acte préparatoire précède le commencement d’exécution et n’est pas réprimé, sauf texte spécial.',
  ),

  // — ÉLÉMENT MORAL (Facile)
  const QuizQuestion(
    category: 'Élément moral',
    difficulty: 'Facile',
    question:
        'Quelle condition psychologique distingue la tentative punissable de l’acte non répréhensible ?',
    options: [
      'La préméditation',
      'L’absence de désistement volontaire',
      'La présence d’un mobile financier',
    ],
    answer: 'L’absence de désistement volontaire',
    explanation:
        'La tentative est punissable si l’échec provient d’une cause extérieure indépendante de la volonté de l’auteur. S’il renonce librement avant la consommation, il s’agit d’un désistement volontaire, non réprimé.',
  ),
  const QuizQuestion(
    category: 'Élément moral',
    difficulty: 'Facile',
    question: 'Le désistement volontaire intervient lorsque l’auteur…',
    options: [
      'Renonce librement avant la consommation',
      'Est arrêté par la police',
      'Est trompé par la victime',
    ],
    answer: 'Renonce librement avant la consommation',
    explanation:
        'Le désistement volontaire suppose une décision spontanée de cesser l’exécution avant la consommation, sans contrainte extérieure.',
  ),

  // — TYPOLOGIE (Facile)
  const QuizQuestion(
    category: 'Typologie',
    difficulty: 'Facile',
    question:
        'Comment s’appelle la tentative où l’exécution est complète mais le résultat ne se produit pas ?',
    options: [
      'Tentative manquée',
      'Tentative interrompue',
      'Tentative impossible',
    ],
    answer: 'Tentative manquée',
    explanation:
        'La tentative manquée correspond à une exécution complète dont le résultat n’advient pas (ex. tir qui manque la victime).',
  ),
  const QuizQuestion(
    category: 'Typologie',
    difficulty: 'Facile',
    question:
        'Comment s’appelle la tentative stoppée par une cause extérieure avant la consommation ?',
    options: [
      'Tentative interrompue',
      'Tentative impossible',
      'Désistement volontaire',
    ],
    answer: 'Tentative interrompue',
    explanation:
        'La tentative interrompue est due à l’intervention d’un tiers ou d’un événement extérieur. Elle demeure punissable.',
  ),

  // — JURISPRUDENCE (Facile)
  const QuizQuestion(
    category: 'Jurisprudence',
    difficulty: 'Facile',
    question: 'Quel arrêt admet la tentative impossible comme punissable ?',
    options: [
      'Arrêt Lacour (1962)',
      'Arrêt Perdereau (1986)',
      'Arrêt Lamothe (1990)',
    ],
    answer: 'Arrêt Perdereau (1986)',
    explanation:
        'Perdereau admet la tentative d’homicide sur une personne déjà décédée : impossibilité de fait ou de droit n’exclut pas la tentative.',
  ),
  const QuizQuestion(
    category: 'Jurisprudence',
    difficulty: 'Facile',
    question:
        'Quel arrêt précise la notion de commencement d’exécution par la tendance directe et immédiate ?',
    options: [
      'Arrêt Lacour (1962)',
      'Arrêt Perdereau (1986)',
      'Arrêt Laboube (1956)',
    ],
    answer: 'Arrêt Lacour (1962)',
    explanation:
        'Lacour retient le critère de l’acte tendant directement et immédiatement à la consommation.',
  ),

  // — RÉPRESSION (Facile)
  const QuizQuestion(
    category: 'Répression',
    difficulty: 'Facile',
    question: 'Principe de peine applicable à la tentative pour les crimes :',
    options: [
      'Peine plus élevée que pour l’infraction consommée',
      'Peine identique à celle de l’infraction consommée',
      'Peine symbolique',
    ],
    answer: 'Peine identique à celle de l’infraction consommée',
    explanation:
        'Principe d’équivalence : la tentative est punie comme l’infraction consommée pour les crimes.',
  ),
  const QuizQuestion(
    category: 'Répression',
    difficulty: 'Facile',
    question:
        'Quel article fonde la personnalisation de la peine (y compris en matière de tentative) ?',
    options: [
      'Article 132-1 du Code pénal',
      'Article 121-7 du Code pénal',
      'Article 111-4 du Code pénal',
    ],
    answer: 'Article 132-1 du Code pénal',
    explanation:
        'L’article 132-1 autorise le juge à adapter la peine à la gravité des faits et à la personnalité de l’auteur.',
  ),

  // — CAS PRATIQUES (Facile)
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Facile',
    question:
        'Lucas repère une bijouterie et achète un pied-de-biche puis rentre chez lui. A-t-il débuté un commencement d’exécution ?',
    options: [
      'Oui, commencement d’exécution',
      'Non, actes préparatoires',
      'Oui, car intention certaine',
    ],
    answer: 'Non, actes préparatoires',
    explanation:
        'Le repérage et l’achat du matériel restent préparatoires : pas d’acte tendant directement et immédiatement au vol.',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Facile',
    question:
        'Noah écrit sur un réseau social qu’il volera un scooter demain mais n’agit pas. Qualification ?',
    options: ['Tentative punissable', 'Acte préparatoire', 'Aucune tentative'],
    answer: 'Aucune tentative',
    explanation:
        'La déclaration d’intention sans acte d’exécution ne fonde aucune tentative.',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Facile',
    question:
        'Emma commence à crocheter une serrure puis s’arrête par peur sans intervention extérieure. Qualification ?',
    options: [
      'Tentative interrompue',
      'Désistement volontaire',
      'Tentative manquée',
    ],
    answer: 'Désistement volontaire',
    explanation:
        'Renoncement spontané avant la consommation : la tentative n’est pas punissable.',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Facile',
    question:
        'Rayan est interrompu par la police alors qu’il forçait une porte. Qualification ?',
    options: [
      'Tentative interrompue punissable',
      'Désistement volontaire',
      'Aucune tentative',
    ],
    answer: 'Tentative interrompue punissable',
    explanation:
        'Intervention extérieure alors qu’un acte d’exécution a commencé : tentative punissable.',
  ),

  // =========================
  // ======== MOYENNE ========
  // =========================

  // — ÉLÉMENT LÉGAL (Moyenne)
  const QuizQuestion(
    category: 'Élément légal',
    difficulty: 'Moyenne',
    question:
        'Pourquoi la tentative n’est-elle pas réprimée pour les contraventions ?',
    options: [
      'Parce que les contraventions ne supposent jamais d’intention',
      'Parce qu’elles sanctionnent essentiellement un fait matériel consommé',
      'Parce que le juge n’a pas compétence',
    ],
    answer:
        'Parce qu’elles sanctionnent essentiellement un fait matériel consommé',
    explanation:
        'Le droit contraventionnel vise la matérialité des faits consommés ; la tentative n’y est pas réprimée.',
  ),
  const QuizQuestion(
    category: 'Élément légal',
    difficulty: 'Moyenne',
    question: 'La tentative est-elle punissable pour tous les délits ?',
    options: ['Oui', 'Non, seulement si la loi le prévoit', 'Jamais'],
    answer: 'Non, seulement si la loi le prévoit',
    explanation:
        'Pour les délits, la tentative n’est réprimée que lorsqu’un texte le précise.',
  ),

  // — ÉLÉMENT MATÉRIEL (Moyenne)
  const QuizQuestion(
    category: 'Élément matériel',
    difficulty: 'Moyenne',
    question:
        'Peut-on caractériser un commencement d’exécution lorsque l’auteur se rend armé sur les lieux mais n’agit pas encore ?',
    options: [
      'Oui, systématiquement',
      'Non, cela peut rester préparatoire',
      'Oui, si l’arme est chargée',
    ],
    answer: 'Non, cela peut rester préparatoire',
    explanation:
        'La seule présence sur les lieux avec un moyen ne suffit pas si aucun acte direct vers la consommation n’est commencé.',
  ),
  const QuizQuestion(
    category: 'Élément matériel',
    difficulty: 'Moyenne',
    question: 'Le critère subjectif du commencement d’exécution renvoie à…',
    options: [
      'La non-équivocité de l’intention délictueuse',
      'La distance entre l’auteur et la victime',
      'La valeur du bien visé',
    ],
    answer: 'La non-équivocité de l’intention délictueuse',
    explanation:
        'Outre le critère objectif (tendance directe et immédiate), la jurisprudence retient l’intention clairement révélée.',
  ),

  // — ÉLÉMENT MORAL (Moyenne)
  const QuizQuestion(
    category: 'Élément moral',
    difficulty: 'Moyenne',
    question:
        'Le repentir actif après consommation de l’infraction supprime-t-il la tentative ?',
    options: ['Oui', 'Non', 'Oui, si la victime est indemnisée'],
    answer: 'Non',
    explanation:
        'Le repentir actif intervient après la consommation ; il n’efface pas la responsabilité pénale sauf texte spécial.',
  ),
  const QuizQuestion(
    category: 'Élément moral',
    difficulty: 'Moyenne',
    question:
        'Un renoncement provoqué par la crainte d’être surpris est-il un désistement volontaire ?',
    options: ['Oui', 'Non', 'Uniquement pour les délits'],
    answer: 'Non',
    explanation:
        'La crainte d’une cause extérieure (surprise, alarme, voisin) retire le caractère volontaire du renoncement.',
  ),

  // — TYPOLOGIE (Moyenne)
  const QuizQuestion(
    category: 'Typologie',
    difficulty: 'Moyenne',
    question:
        'Un individu tire sur une victime et la manque : de quelle tentative s’agit-il ?',
    options: [
      'Tentative manquée',
      'Tentative interrompue',
      'Tentative impossible',
    ],
    answer: 'Tentative manquée',
    explanation:
        'Exécution complète, résultat non atteint pour une cause indépendante : tentative manquée.',
  ),
  const QuizQuestion(
    category: 'Typologie',
    difficulty: 'Moyenne',
    question:
        'Un individu commence à découper un antivol mais s’enfuit à cause d’une sirène. Qualification ?',
    options: [
      'Tentative interrompue',
      'Désistement volontaire',
      'Aucune tentative',
    ],
    answer: 'Tentative interrompue',
    explanation:
        'Cause extérieure ayant stoppé l’exécution commencée : tentative punissable.',
  ),
  const QuizQuestion(
    category: 'Typologie',
    difficulty: 'Moyenne',
    question:
        'Un pickpocket plonge la main dans la poche d’un manteau vide. Qualification ?',
    options: [
      'Aucune tentative',
      'Tentative impossible punissable',
      'Acte préparatoire',
    ],
    answer: 'Tentative impossible punissable',
    explanation:
        'Moyen inapte (poche vide) mais acte direct et intention coupable : tentative impossible punissable.',
  ),

  // — JURISPRUDENCE (Moyenne)
  const QuizQuestion(
    category: 'Jurisprudence',
    difficulty: 'Moyenne',
    question:
        'L’arrêt Lacour (1962) combine deux critères pour le commencement d’exécution. Lesquels ?',
    options: [
      'Critère de la préméditation et de la gravité',
      'Critères objectif (tendance directe) et subjectif (intention non équivoque)',
      'Critères de temps et de lieu',
    ],
    answer:
        'Critères objectif (tendance directe) et subjectif (intention non équivoque)',
    explanation:
        'La Cour de cassation articule un acte matériel direct et une intention clairement révélée.',
  ),
  const QuizQuestion(
    category: 'Jurisprudence',
    difficulty: 'Moyenne',
    question: 'Perdereau (1986) concerne principalement…',
    options: [
      'Le désistement volontaire',
      'La tentative impossible d’homicide',
      'La complicité par instigation',
    ],
    answer: 'La tentative impossible d’homicide',
    explanation:
        'L’arrêt valide la tentation d’homicide sur une personne déjà morte.',
  ),

  // — RÉPRESSION (Moyenne)
  const QuizQuestion(
    category: 'Répression',
    difficulty: 'Moyenne',
    question: 'Pour les délits, la tentative est punissable…',
    options: ['Toujours', 'Uniquement si la loi le prévoit', 'Jamais'],
    answer: 'Uniquement si la loi le prévoit',
    explanation:
        'La loi doit viser explicitement la tentative pour les délits.',
  ),
  const QuizQuestion(
    category: 'Répression',
    difficulty: 'Moyenne',
    question:
        'La tentative entraîne-t-elle automatiquement une atténuation de peine ?',
    options: ['Oui', 'Non', 'Uniquement si la victime n’a pas subi de dommage'],
    answer: 'Non',
    explanation:
        'Principe : équivalence des peines. L’atténuation relève de la personnalisation par le juge (art. 132-1).',
  ),

  // — CAS PRATIQUES (Moyenne)
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Moyenne',
    question:
        'Mélanie tire sur une victime avec un pistolet qu’elle croit chargé ; l’arme est vide. Qualification ?',
    options: [
      'Acte préparatoire',
      'Tentative impossible punissable',
      'Aucune tentative',
    ],
    answer: 'Tentative impossible punissable',
    explanation:
        'Moyen inapte mais acte direct et intention homicide : tentative punissable.',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Moyenne',
    question:
        'Julien commence à forcer un coffre mais s’arrête parce qu’il entend du bruit dans le couloir. Qualification ?',
    options: [
      'Désistement volontaire',
      'Désistement involontaire donc tentative punissable',
      'Aucune tentative',
    ],
    answer: 'Désistement involontaire donc tentative punissable',
    explanation:
        'La peur causée par un fait extérieur ôte le caractère volontaire de l’arrêt.',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Moyenne',
    question:
        'Camille place un pied-de-biche dans une porte et commence à appuyer lorsque des voisins arrivent. Qualification ?',
    options: [
      'Tentative interrompue punissable',
      'Aucune tentative',
      'Acte préparatoire',
    ],
    answer: 'Tentative interrompue punissable',
    explanation: 'L’intrusion d’un tiers interrompt l’exécution commencée.',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Moyenne',
    question:
        'Hugo prépare une seringue pour injecter un poison mais renonce avant tout geste vers la victime. Qualification ?',
    options: [
      'Acte préparatoire',
      'Tentative manquée',
      'Tentative interrompue',
    ],
    answer: 'Acte préparatoire',
    explanation:
        'Aucun acte direct et immédiat vers la victime : la préparation reste non punissable.',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Moyenne',
    question:
        'Léa envoie un faux e-mail à son assureur pour obtenir une indemnisation frauduleuse. Qualification ?',
    options: [
      'Acte préparatoire',
      'Commencement d’exécution d’une escroquerie',
      'Aucune tentative',
    ],
    answer: 'Commencement d’exécution d’une escroquerie',
    explanation:
        'La fausse déclaration à la compagnie d’assurance constitue un acte direct vers la consommation de l’escroquerie.',
  ),

  // =========================
  // ======= DIFFICILE =======
  // =========================

  // — ÉLÉMENT LÉGAL (Difficile)
  const QuizQuestion(
    category: 'Élément légal',
    difficulty: 'Difficile',
    question:
        'La tentative est-elle possible en matière d’infractions non intentionnelles (imprudence, négligence) ?',
    options: ['Oui', 'Non', 'Uniquement pour les crimes'],
    answer: 'Non',
    explanation:
        'La tentative suppose une intention coupable, ce qui est incompatible avec les infractions purement non intentionnelles.',
  ),
  const QuizQuestion(
    category: 'Élément légal',
    difficulty: 'Difficile',
    question:
        'Dans les infractions dites « obstacles » (ex. port d’arme prohibé), peut-on raisonner en tentative ?',
    options: [
      'Oui, toujours',
      'Non, la structure réprime déjà l’anticipation',
      'Uniquement si la victime est identifiée',
    ],
    answer: 'Non, la structure réprime déjà l’anticipation',
    explanation:
        'Ces incriminations visent précisément l’anticipation du risque ; la tentative s’y confondrait avec la consommation.',
  ),

  // — ÉLÉMENT MATÉRIEL (Difficile)
  const QuizQuestion(
    category: 'Élément matériel',
    difficulty: 'Difficile',
    question:
        'Un individu place un explosif factice qu’il croit réel dans un hall d’immeuble. Qualification ?',
    options: [
      'Tentative impossible punissable',
      'Acte préparatoire',
      'Aucune infraction',
    ],
    answer: 'Tentative impossible punissable',
    explanation:
        'Moyen inapte mais acte direct et intention criminelle caractérisée.',
  ),
  const QuizQuestion(
    category: 'Élément matériel',
    difficulty: 'Difficile',
    question:
        'Peut-il y avoir tentative lorsque l’acte est interrompu par une panne du matériel utilisé (ex. arme enrayée) ?',
    options: ['Oui', 'Non', 'Uniquement pour les crimes'],
    answer: 'Oui',
    explanation:
        'La panne constitue une cause indépendante de la volonté ; la tentative reste punissable si l’exécution avait commencé.',
  ),

  // — ÉLÉMENT MORAL (Difficile)
  const QuizQuestion(
    category: 'Élément moral',
    difficulty: 'Difficile',
    question:
        'Un auteur renonce car il aperçoit une caméra factice qu’il croit réelle. S’agit-il d’un désistement volontaire ?',
    options: ['Oui', 'Non', 'Uniquement si la caméra est active'],
    answer: 'Non',
    explanation:
        'La crainte d’un dispositif extérieur—even fictif mais perçu comme réel—ôte le caractère volontaire du renoncement.',
  ),
  const QuizQuestion(
    category: 'Élément moral',
    difficulty: 'Difficile',
    question:
        'La tentative suppose-t-elle une intention déterminée quant au résultat précis (ex. valeur du bien) ?',
    options: ['Oui', 'Non', 'Uniquement pour les crimes'],
    answer: 'Non',
    explanation:
        'L’intention porte sur la commission de l’infraction, non sur tous ses paramètres accessoires.',
  ),

  // — TYPOLOGIE (Difficile)
  const QuizQuestion(
    category: 'Typologie',
    difficulty: 'Difficile',
    question:
        'Un individu administre un produit inoffensif qu’il croit mortel. Qualification ?',
    options: [
      'Tentative impossible d’empoisonnement punissable',
      'Acte préparatoire',
      'Aucune tentative',
    ],
    answer: 'Tentative impossible d’empoisonnement punissable',
    explanation:
        'Moyen inapte mais intention homicide et acte direct : punissable.',
  ),
  const QuizQuestion(
    category: 'Typologie',
    difficulty: 'Difficile',
    question:
        'Un individu programme une bombe pour exploser, mais le minuteur se bloque avant déclenchement. Qualification ?',
    options: [
      'Tentative manquée',
      'Tentative interrompue',
      'Désistement volontaire',
    ],
    answer: 'Tentative manquée',
    explanation:
        'Exécution complète du processus criminel ; résultat non atteint pour une cause indépendante.',
  ),

  // — JURISPRUDENCE (Difficile)
  const QuizQuestion(
    category: 'Jurisprudence',
    difficulty: 'Difficile',
    question:
        'Dans Perdereau (1986), quel raisonnement justifie la punissabilité ?',
    options: [
      'Assimilation à une infraction formelle',
      'Conservation du couple intention + commencement d’exécution malgré impossibilité',
      'Présomption de résultat',
    ],
    answer:
        'Conservation du couple intention + commencement d’exécution malgré impossibilité',
    explanation:
        'La Cour retient que l’impossibilité n’efface ni l’intention ni l’acte direct vers la consommation.',
  ),
  const QuizQuestion(
    category: 'Jurisprudence',
    difficulty: 'Difficile',
    question:
        'Quel enseignement majeur de Lacour (1962) évite de confondre actes préparatoires et commencement d’exécution ?',
    options: [
      'La prise en compte de la personnalité de l’auteur',
      'La nécessité d’un acte à tendance directe et immédiate vers l’infraction',
      'L’exigence d’un résultat partiel',
    ],
    answer:
        'La nécessité d’un acte à tendance directe et immédiate vers l’infraction',
    explanation:
        'Ce critère objectif trace la frontière avec la simple préparation.',
  ),

  // — RÉPRESSION (Difficile)
  const QuizQuestion(
    category: 'Répression',
    difficulty: 'Difficile',
    question:
        'Le juge peut-il infliger une peine inférieure à celle prévue pour l’infraction consommée en cas de tentative ?',
    options: [
      'Jamais',
      'Oui, par personnalisation de la peine',
      'Uniquement si la victime l’accepte',
    ],
    answer: 'Oui, par personnalisation de la peine',
    explanation:
        'L’article 132-1 autorise une modulation, même si le principe d’équivalence demeure.',
  ),
  const QuizQuestion(
    category: 'Répression',
    difficulty: 'Difficile',
    question:
        'La tentative entraîne-t-elle des effets sur la récidive légale identiques à l’infraction consommée ?',
    options: ['Oui', 'Non', 'Uniquement pour les crimes'],
    answer: 'Oui',
    explanation:
        'La condamnation pour tentative peut constituer le premier terme de la récidive lorsque les textes le prévoient.',
  ),

  // — CAS PRATIQUES (Difficile)
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Difficile',
    question:
        'Clara frappe violemment une personne déjà décédée qu’elle croit vivante. Qualification ?',
    options: [
      'Tentative impossible punissable',
      'Aucune tentative',
      'Violences volontaires simples',
    ],
    answer: 'Tentative impossible punissable',
    explanation:
        'Application de Perdereau : impossibilité de droit ou de fait n’exclut pas la tentative.',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Difficile',
    question:
        'Antoine empoisonne une bouteille destinée à Zoé, mais c’est Victor qui boit sans mourir grâce à une dose trop faible. Qualification ?',
    options: [
      'Tentative manquée d’empoisonnement',
      'Désistement volontaire',
      'Acte préparatoire',
    ],
    answer: 'Tentative manquée d’empoisonnement',
    explanation:
        'L’acte d’administration est réalisé ; le résultat n’advient pas pour une cause indépendante (dose insuffisante).',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Difficile',
    question:
        'Sofia programme un rançongiciel et lance l’exécution, mais un pare-feu coupe l’attaque avant chiffrement. Qualification ?',
    options: [
      'Tentative interrompue punissable',
      'Désistement volontaire',
      'Aucune tentative',
    ],
    answer: 'Tentative interrompue punissable',
    explanation:
        'Cause extérieure (protection informatique) stoppant l’exécution commencée : tentative punissable.',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Difficile',
    question:
        'Karim tire à bout portant ; la balle ricoche et ne touche pas la victime. Qualification ?',
    options: ['Tentative manquée', 'Tentative interrompue', 'Aucune tentative'],
    answer: 'Tentative manquée',
    explanation:
        'Exécution complète, résultat non atteint pour une circonstance indépendante (ricochet).',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Difficile',
    question:
        'Julie dépose une bombe artisanale qui n’explose pas à cause d’une erreur de montage. Qualification ?',
    options: [
      'Tentative manquée',
      'Acte préparatoire',
      'Désistement volontaire',
    ],
    answer: 'Tentative manquée',
    explanation:
        'L’exécution est achevée mais le résultat ne se produit pas en raison d’un dysfonctionnement.',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Difficile',
    question:
        'Maxime lance un cocktail Molotov sur une vitrine ; la mèche s’éteint en vol. Qualification ?',
    options: ['Tentative manquée', 'Tentative interrompue', 'Aucune tentative'],
    answer: 'Tentative manquée',
    explanation:
        'Acte d’exécution accompli ; le résultat n’advient pas pour une cause indépendante (mèche éteinte).',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Difficile',
    question:
        'Aïcha place une carte bancaire volée dans un terminal pour retirer de l’argent mais la transaction échoue faute de fonds. Qualification ?',
    options: [
      'Tentative manquée d’escroquerie',
      'Aucune tentative',
      'Acte préparatoire',
    ],
    answer: 'Tentative manquée d’escroquerie',
    explanation:
        'L’acte direct vers l’obtention frauduleuse est accompli ; échec pour cause indépendante (absence de provision).',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Difficile',
    question:
        'Paul déclenche à distance un dispositif incendiaire mais les pompiers interviennent immédiatement et empêchent l’embrasement. Qualification ?',
    options: [
      'Tentative interrompue punissable',
      'Désistement volontaire',
      'Aucune tentative',
    ],
    answer: 'Tentative interrompue punissable',
    explanation:
        'Intervention extérieure stoppant un acte déjà commencé : tentative punissable.',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Difficile',
    question:
        'Manon prépare un mail de phishing, entre l’adresse de la victime et clique sur “envoyer”, mais le serveur rejette l’envoi. Qualification ?',
    options: [
      'Tentative manquée d’escroquerie',
      'Acte préparatoire',
      'Aucune tentative',
    ],
    answer: 'Tentative manquée d’escroquerie',
    explanation:
        'L’acte est accompli ; le résultat échoue pour une cause technique indépendante.',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Difficile',
    question:
        'Yanis braque une arme factice sur un caissier qui croit à une vraie arme ; il est maîtrisé par un client. Qualification ?',
    options: [
      'Tentative interrompue de vol avec violence',
      'Acte préparatoire',
      'Aucune tentative',
    ],
    answer: 'Tentative interrompue de vol avec violence',
    explanation:
        'Acte direct vers la soustraction sous menace ; intervention extérieure : tentative punissable.',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Difficile',
    question:
        'Elisa met du sucre qu’elle croit être un toxique dans le café de Nathan ; aucune conséquence. Qualification ?',
    options: [
      'Tentative impossible d’empoisonnement',
      'Acte préparatoire',
      'Aucune tentative',
    ],
    answer: 'Tentative impossible d’empoisonnement',
    explanation:
        'Moyen inapte mais acte direct d’administration et intention homicide.',
  ),
  const QuizQuestion(
    category: 'Cas pratique',
    difficulty: 'Difficile',
    question:
        'Maëlys force une fenêtre, entre dans la maison mais repart aussitôt en entendant une sirène provenant d’un chantier voisin. Qualification ?',
    options: [
      'Désistement involontaire donc tentative punissable',
      'Désistement volontaire',
      'Aucune tentative',
    ],
    answer: 'Désistement involontaire donc tentative punissable',
    explanation:
        'La peur causée par un fait extérieur retire le caractère volontaire du renoncement.',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizTentativePagePA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName = '/pa/generalites/quiz/tentative';
  final String uid;
  final String email;

  const QuizTentativePagePA({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizTentativePagePA> createState() => _QuizTentativePagePAState();
}

class _QuizTentativePagePAState extends State<QuizTentativePagePA>
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
  static const _introHiddenKey = 'intro_pa_tentative';
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

  // ==========================================================================
  // HELPERS
  // ==========================================================================

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

  void _seedAndShuffle() {
    final useAll = _mixMode || _selectedDifficulty == null;
    final pool = useAll
        ? questionsTentative
        : questionsTentative
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

            'grade': UserContextService.I.trackOrDefault,
            'track': UserContextService.I.trackOrDefault,
            'mode': UserContextService.I.modeOrDefault,
            'module_name': 'Généralités',
            'quiz_name': 'La tentative punissable',
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
      final int answered = _answers.where((a) => a != null).length;
      final int totalForScore = answered <= 0 ? 1 : answered;
      final int percent = (_score * 100 ~/ totalForScore).clamp(0, 100);

      await _sb
          .from('quiz_history')
          .update({
            'score': percent, // pourcentage
            'correct_count': _score, // nb bonnes réponses
            'finished_at': DateTime.now().toUtc().toIso8601String(),
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _historyRowId!)
          .eq('uid', widget.uid); // ⬅️ important pour passer la policy
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
    required String difficulty, // <= difficulté réelle de la question
  }) async {
    try {
      await _sb.from('quiz_tentative').insert({
        'user_uid': widget.uid,
        'email': widget.email,

        'grade': UserContextService.I.trackOrDefault, 'question': question,
        'user_answer': userAnswer,
        'correct_answer': correctAnswer,
        'is_correct': isCorrect,
        'score': _score, // score cumulé au moment T (ok)
        'difficulty': difficulty, // <= plus de "Mix" ici
      });
    } catch (e) {
      debugPrint('❌ quiz_tentative insert failed: $e');
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
        difficulty: q.difficulty, // <= IMPORTANT
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
      'source_file': 'pa_quiz_tentative_page',
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
        final bg = isDark ? const Color(0xFF2C2C2E) : _Brand.bgLight;
        final textCol = isDark ? Colors.white : _Brand.textDark;
        final base = isDark ? ThemeData.dark() : ThemeData.light();

        // hauteur “structurelle” du bas (bouton + marges)
        const double kButtonHeight = 56;
        const double kButtonVPad = 16; // safe area min bottom padding = 16
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
                        if (_showIntro)
                          _IntroSplash(
                            isDark: isDark,
                            hideForever: _hideIntroForever,
                            onChangedHideForever: _saveIntroPreference,
                            onStart: () async { await _doStartQuiz(); },
                            icon: Icons.trending_flat_rounded,
                            title: 'Tentative',
                            description: 'Comprends la tentative punissable : commencement d’exécution, désistement volontaire, infraction impossible et leur régime juridique.',
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
      barrierColor: Colors.black.withValues(alpha: 0.25),
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
          message: 'Tu maîtrises la tentative 💪',
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
          message: 'Reprends 121-5 C. pén. 🔁',
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
