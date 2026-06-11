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

final List<QuizQuestion> questionAutoriteParentale = [
  // =========================================================
  // NON-REPRÉSENTATION D’ENFANT MINEUR — FONDEMENTS (227-5)
  // =========================================================
  const QuizQuestion(
    category: 'Non-représentation d’enfant mineur — Fondement',
    question:
        'La non-représentation d’enfant mineur est définie et réprimée par :',
    options: [
      'L’article 227-5 du Code pénal',
      'L’article 227-6 du Code pénal',
      'L’article 227-8 du Code pénal',
    ],
    answer: 'L’article 227-5 du Code pénal',
    explanation: 'L’élément légal est fixé par l’article 227-5 du Code pénal.',
    difficulty: 'Facile',
  ),
  // =========================================================
  // AJOUT ENORME — AUTORITÉ PARENTALE (227-5 / 227-6 / 227-7 / 227-8 / 227-9 / 227-10 / 227-11)
  // (à coller directement dans ta liste existante)
  // =========================================================

  // ---------------------------------------------------------
  // 227-5 — NON-REPRÉSENTATION D’ENFANT : BASES
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Non-représentation — 227-5',
    question: 'La non-représentation d’enfant mineur est prévue par :',
    options: [
      'L’article 227-5 du Code pénal',
      'L’article 227-7 du Code pénal',
      'L’article 227-6 du Code pénal',
    ],
    answer: 'L’article 227-5 du Code pénal',
    explanation:
        'L’article 227-5 définit et réprime la non-représentation d’enfant mineur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — 227-5',
    question: 'Le délit de non-représentation d’enfant consiste à :',
    options: [
      'Refuser indûment de représenter un enfant mineur à la personne qui a le droit de le réclamer',
      'Déplacer un mineur sans fraude ni violence par un tiers',
      'Ne pas notifier un transfert de domicile dans le mois',
    ],
    answer:
        'Refuser indûment de représenter un enfant mineur à la personne qui a le droit de le réclamer',
    explanation:
        'Élément matériel : refus indû de représenter le mineur à celui qui a droit de le réclamer.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Définition du mineur',
    question: 'Selon l’article 388 du code civil, est mineure toute personne :',
    options: [
      'Âgée de moins de 18 ans',
      'Âgée de moins de 16 ans',
      'Âgée de moins de 21 ans',
    ],
    answer: 'Âgée de moins de 18 ans',
    explanation:
        'L’article 388 du code civil fixe la minorité à moins de 18 ans.',
    difficulty: 'Facile',
  ),

  // ---------------------------------------------------------
  // 227-5 — DROIT DE RÉCLAMER : ORIGINE ET CONDITIONS
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Non-représentation — Droit de réclamer',
    question: 'Le droit de réclamer le mineur provient le plus souvent :',
    options: [
      'D’une décision de justice, d’une convention homologuée ou d’une convention 229-1 du code civil',
      'D’un simple accord oral',
      'D’un contrat privé non homologué',
    ],
    answer:
        'D’une décision de justice, d’une convention homologuée ou d’une convention 229-1 du code civil',
    explanation:
        'Le support précise que l’origine est généralement judiciaire ou conventionnelle (homologuée/229-1).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Droit de réclamer',
    question:
        'Pour que le droit de réclamer soit opposable pénalement, la jurisprudence exige notamment que la décision :',
    options: [
      'Soit exécutoire et portée légalement à la connaissance de l’auteur du refus',
      'Soit seulement déposée au greffe',
      'Soit connue de l’école',
    ],
    answer:
        'Soit exécutoire et portée légalement à la connaissance de l’auteur du refus',
    explanation:
        'Décision exécutoire + connaissance légale de l’auteur du refus.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Droit de réclamer',
    question: 'Le droit de réclamer l’enfant est aussi reconnu par la loi à :',
    options: [
      'Toute personne investie de l’autorité parentale',
      'Toute personne ayant un lien affectif',
      'Toute personne domiciliée avec le mineur',
    ],
    answer: 'Toute personne investie de l’autorité parentale',
    explanation:
        'Le support mentionne la reconnaissance légale à toute personne investie de l’autorité parentale.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Droit de réclamer',
    question:
        'À défaut d’une décision délimitant les droits, le délit ne peut être constitué si le conflit oppose :',
    options: [
      'Deux personnes ayant des droits égaux concernant le mineur',
      'Un parent et un grand-parent',
      'Un parent et l’école',
    ],
    answer: 'Deux personnes ayant des droits égaux concernant le mineur',
    explanation:
        'Sans décision fixant les droits, si droits égaux (ex : parents séparés de fait), pas de délit.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // 227-5 — REFUS : ACTIF DIRECT / ACTIF INDIRECT / PASSIF
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Non-représentation — Refus (formes)',
    question: 'Le refus de représenter le mineur peut résulter :',
    options: [
      'D’un comportement actif direct, actif indirect ou passif',
      'Uniquement d’un comportement violent',
      'Uniquement d’un écrit',
    ],
    answer: 'D’un comportement actif direct, actif indirect ou passif',
    explanation: 'Le support distingue actif direct, actif indirect et passif.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Refus actif direct',
    question: 'La dissimulation du mineur est un exemple de :',
    options: [
      'Comportement actif direct',
      'Comportement actif indirect',
      'Comportement passif',
    ],
    answer: 'Comportement actif direct',
    explanation:
        'Le support cite la dissimulation du mineur comme actif direct.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Refus actif direct',
    question:
        'Le fait d’être volontairement absent du domicile quand l’autre parent vient exercer son droit est un :',
    options: [
      'Comportement actif direct',
      'Comportement passif',
      'Fait justificatif automatique',
    ],
    answer: 'Comportement actif direct',
    explanation:
        'Le support cite l’absence du domicile comme exemple d’actif direct.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Refus actif indirect',
    question:
        'Manipuler le mineur pour l’inciter à refuser la visite/hébergement constitue :',
    options: [
      'Un comportement actif indirect',
      'Un comportement passif',
      'Un fait justificatif',
    ],
    answer: 'Un comportement actif indirect',
    explanation:
        'Le support cite la manipulation du mineur comme actif indirect.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Refus passif',
    question: 'Le refus peut être passif lorsque le parent gardien :',
    options: [
      'S’abstient d’intervenir alors que le mineur refuse spontanément le droit de visite/hébergement',
      'Prépare l’enfant et encourage la visite',
      'Saisit le juge avant la date',
    ],
    answer:
        'S’abstient d’intervenir alors que le mineur refuse spontanément le droit de visite/hébergement',
    explanation: 'Le support décrit cette hypothèse de comportement passif.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Jurisprudence',
    question: 'Selon la jurisprudence rappelée, la résistance du mineur :',
    options: [
      'Ne constitue pas une excuse légale ni un fait justificatif',
      'Constitue toujours une excuse légale',
      'Supprime automatiquement l’élément moral',
    ],
    answer: 'Ne constitue pas une excuse légale ni un fait justificatif',
    explanation:
        'Le support indique que la résistance du mineur n’est pas une excuse légale/justificatif.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // 227-5 — ÉLÉMENT MORAL / JUSTIFICATION
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Non-représentation — Élément moral',
    question: 'Le terme « refus » implique :',
    options: [
      'Une attitude consciente et volontaire',
      'Une simple négligence',
      'Un oubli involontaire',
    ],
    answer: 'Une attitude consciente et volontaire',
    explanation:
        'Le support précise que « refus » indique une attitude consciente et volontaire.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément moral',
    question: 'L’adverbe « indûment » souligne :',
    options: [
      'La mauvaise foi de l’auteur',
      'La minorité de l’enfant',
      'Le caractère civil du litige',
    ],
    answer: 'La mauvaise foi de l’auteur',
    explanation:
        'Le support indique que « indûment » souligne la mauvaise foi.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément moral',
    question: 'L’élément intentionnel suppose que l’auteur ait agi :',
    options: [
      'En pleine connaissance des droits qu’il empêche de s’exercer',
      'Sans connaître les droits de l’autre parent',
      'Par simple négligence',
    ],
    answer: 'En pleine connaissance des droits qu’il empêche de s’exercer',
    explanation: 'Le support précise la connaissance des droits empêchés.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Cass. crim. 08/09/1999',
    question:
        'Selon Cass. crim., 08 septembre 1999, l’élément intentionnel est caractérisé par :',
    options: [
      'Le refus délibéré ou indû de remettre l’enfant, quel que soit le mobile, en l’absence de danger actuel ou imminent',
      'Le seul désaccord parental',
      'Le seul fait que l’enfant pleure',
    ],
    answer:
        'Le refus délibéré ou indû de remettre l’enfant, quel que soit le mobile, en l’absence de danger actuel ou imminent',
    explanation: 'Le support cite cette formule de la Cour de cassation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Justification',
    question:
        'La justification admise par la jurisprudence pour non-représentation suppose :',
    options: [
      'Un danger actuel et imminent menaçant l’enfant',
      'Un danger hypothétique',
      'Une simple fatigue du parent',
    ],
    answer: 'Un danger actuel et imminent menaçant l’enfant',
    explanation:
        'Le support indique la justification en cas de danger actuel et imminent.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // 227-5 — AGGRAVATIONS 227-9 / 227-10 + PEINES + PROCÉDURE
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Non-représentation — 227-9',
    question:
        'La circonstance aggravante (227-9) est constituée si l’enfant est retenu au-delà de cinq jours :',
    options: [
      'Sans que ceux qui ont droit de le réclamer sachent où il se trouve',
      'Même si son adresse est connue',
      'Uniquement si l’enfant est malade',
    ],
    answer:
        'Sans que ceux qui ont droit de le réclamer sachent où il se trouve',
    explanation:
        'Le support mentionne la rétention > 5 jours avec lieu inconnu.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — 227-9',
    question:
        'La circonstance aggravante (227-9) est aussi constituée si l’enfant est retenu indûment :',
    options: [
      'Hors du territoire de la République',
      'Dans le même département',
      'Chez un ami',
    ],
    answer: 'Hors du territoire de la République',
    explanation:
        'Le support indique l’aggravation en cas de rétention hors du territoire.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — 227-10',
    question:
        'La circonstance aggravante (227-10) est constituée si l’auteur :',
    options: [
      'A été déchu de l’autorité parentale ou fait l’objet d’un retrait de l’exercice de cette autorité',
      'A déménagé sans prévenir',
      'A un casier judiciaire',
    ],
    answer:
        'A été déchu de l’autorité parentale ou fait l’objet d’un retrait de l’exercice de cette autorité',
    explanation:
        'Le support vise la déchéance ou le retrait de l’exercice de l’autorité parentale.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Peines',
    question: 'La peine encourue (forme simple) pour 227-5 est :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le support indique : 1 an + 15 000 € (forme simple).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Peines',
    question: 'En cas d’aggravation (227-9 ou 227-10), la peine encourue est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le support indique : 3 ans + 45 000 € en aggravé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Tentative / complicité',
    question: 'Pour 227-5, la tentative est :',
    options: ['Non', 'Oui', 'Oui si l’enfant est à l’étranger'],
    answer: 'Non',
    explanation: 'Le support indique : tentative non prévue.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Tentative / complicité',
    question: 'Pour 227-5, la complicité est :',
    options: [
      'Oui (article 121-7 du Code pénal)',
      'Non',
      'Oui uniquement si le complice est ascendant',
    ],
    answer: 'Oui (article 121-7 du Code pénal)',
    explanation: 'Le support indique : complicité applicable selon 121-7 CP.',
    difficulty: 'Moyenne',
  ),

  // ---------------------------------------------------------
  // 227-6 — DÉFAUT DE NOTIFICATION DE TRANSFERT DE DOMICILE : BASES
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Transfert domicile — 227-6',
    question:
        'Le défaut de notification de transfert de domicile est prévu par :',
    options: [
      'L’article 227-6 du Code pénal',
      'L’article 227-4-3 du Code pénal',
      'L’article 227-5 du Code pénal',
    ],
    answer: 'L’article 227-6 du Code pénal',
    explanation:
        'L’article 227-6 définit et réprime le défaut de notification de transfert de domicile.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Transfert domicile — 227-6',
    question:
        'L’infraction 227-6 vise le cas où un parent transfère son domicile alors que :',
    options: [
      'Ses enfants résident habituellement chez lui',
      'L’enfant réside chez l’autre parent',
      'L’enfant est majeur',
    ],
    answer: 'Ses enfants résident habituellement chez lui',
    explanation:
        'Condition : enfants résident habituellement au domicile de l’auteur.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Transfert domicile — 227-6',
    question: 'Le délai légal de notification (227-6) est :',
    options: ['Un mois', 'Cinq jours', 'Six jours'],
    answer: 'Un mois',
    explanation: 'Le support prévoit un délai d’un mois.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Transfert domicile — 227-6',
    question:
        'La notification du transfert de domicile (227-6) doit être adressée :',
    options: [
      'À ceux qui peuvent exercer un droit de visite ou d’hébergement',
      'Uniquement au juge',
      'Uniquement au procureur',
    ],
    answer: 'À ceux qui peuvent exercer un droit de visite ou d’hébergement',
    explanation:
        'Le support vise les titulaires du droit de visite/hébergement (autre parent ou tiers).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Transfert domicile — 227-6',
    question:
        'La décision fondant le droit de visite/hébergement (227-6) doit être :',
    options: [
      'Exécutoire et notifiée à l’auteur',
      'Seulement signée',
      'Seulement connue oralement',
    ],
    answer: 'Exécutoire et notifiée à l’auteur',
    explanation: 'Le support précise : exécutoire et notifiée à l’auteur.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Transfert domicile — 227-6',
    question: 'Concernant la forme de la notification (227-6) :',
    options: [
      'Aucune exigence de forme n’est prévue',
      'LRAR obligatoire',
      'Acte de commissaire de justice obligatoire',
    ],
    answer: 'Aucune exigence de forme n’est prévue',
    explanation: 'Le support indique : aucune exigence sur la forme.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Transfert domicile — 227-6',
    question: 'L’élément moral de 227-6 est caractérisé par :',
    options: [
      'La volonté de faire échec au droit de visite ou d’hébergement',
      'Une simple négligence',
      'Une erreur sans importance',
    ],
    answer: 'La volonté de faire échec au droit de visite ou d’hébergement',
    explanation:
        'Le support précise l’intention et exclut la simple négligence.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Transfert domicile — 227-6',
    question: 'La simple négligence est punissable pour 227-6 :',
    options: ['Non', 'Oui', 'Oui seulement si déménagement loin'],
    answer: 'Non',
    explanation:
        'Le support précise que la simple négligence n’est pas punissable.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Transfert domicile — Répression',
    question: 'La peine encourue (personne physique) pour 227-6 est :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation: 'Le support indique : 6 mois + 7 500 €.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Transfert domicile — Tentative / complicité',
    question: 'Pour 227-6, la tentative est :',
    options: ['Non', 'Oui', 'Oui si l’enfant est déplacé'],
    answer: 'Non',
    explanation: 'Le support indique : tentative non prévue.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Transfert domicile — Tentative / complicité',
    question: 'Pour 227-6, la complicité est :',
    options: [
      'Oui (article 121-7 du Code pénal)',
      'Non',
      'Oui uniquement si le complice est un parent',
    ],
    answer: 'Oui (article 121-7 du Code pénal)',
    explanation: 'Le support indique : complicité applicable selon 121-7 CP.',
    difficulty: 'Moyenne',
  ),

  // ---------------------------------------------------------
  // 227-7 — SOUSTRACTION PAR ASCENDANT : POINTS CLÉS
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Soustraction par ascendant — 227-7',
    question: 'La soustraction d’enfant mineur par ascendant est prévue par :',
    options: [
      'L’article 227-7 du Code pénal',
      'L’article 227-8 du Code pénal',
      'L’article 227-5 du Code pénal',
    ],
    answer: 'L’article 227-7 du Code pénal',
    explanation:
        'L’article 227-7 définit la soustraction d’enfant mineur par ascendant.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — 227-7',
    question: 'Pour 227-7, l’auteur doit avoir :',
    options: [
      'La qualité d’ascendant du mineur',
      'La qualité de tiers',
      'La qualité de juge',
    ],
    answer: 'La qualité d’ascendant du mineur',
    explanation: 'Le support précise : tout ascendant peut être auteur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — 227-7',
    question: 'La soustraction implique :',
    options: [
      'Un acte positif de déplacement (ou obtenir le déplacement) du mineur',
      'Une simple omission',
      'Un simple refus de payer',
    ],
    answer:
        'Un acte positif de déplacement (ou obtenir le déplacement) du mineur',
    explanation:
        'Le support définit la soustraction par un acte positif de déplacement.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Jurisprudence',
    question:
        'Selon la jurisprudence citée, un déplacement de quelques heures :',
    options: [
      'Ne suffit pas à constituer une soustraction',
      'Suffit toujours',
      'Suffit seulement si l’enfant est petit',
    ],
    answer: 'Ne suffit pas à constituer une soustraction',
    explanation: 'Le support cite Cass. crim., 23 décembre 1968.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Élément moral',
    question: 'L’infraction 227-7 est intentionnelle : l’auteur agit en :',
    options: [
      'Connaissance de son absence de droit',
      'Ignorance totale du droit',
      'Simple négligence',
    ],
    answer: 'Connaissance de son absence de droit',
    explanation:
        'Le support précise : connaissance de l’absence de droit + déplacement durable.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Peines',
    question: 'La peine encourue (forme simple) pour 227-7 est :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le support indique : 1 an + 15 000 € (forme simple).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Tentative',
    question: 'La tentative de soustraction par ascendant est :',
    options: [
      'Oui, expressément prévue par l’article 227-11 du Code pénal',
      'Non',
      'Oui uniquement si violence',
    ],
    answer: 'Oui, expressément prévue par l’article 227-11 du Code pénal',
    explanation: 'Le support indique : tentative prévue par 227-11 CP.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // 227-8 — SOUSTRACTION PAR TIERS SANS FRAUDE NI VIOLENCE
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Soustraction par tiers — 227-8',
    question:
        'La soustraction d’enfant mineur sans fraude ni violence par un non-ascendant est prévue par :',
    options: [
      'L’article 227-8 du Code pénal',
      'L’article 227-7 du Code pénal',
      'L’article 227-6 du Code pénal',
    ],
    answer: 'L’article 227-8 du Code pénal',
    explanation:
        'L’article 227-8 définit la soustraction sans fraude ni violence par un non-ascendant.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — 227-8',
    question: 'Pour 227-8, l’auteur doit être :',
    options: [
      'Une personne autre qu’un ascendant du mineur',
      'Un ascendant',
      'Un tuteur uniquement',
    ],
    answer: 'Une personne autre qu’un ascendant du mineur',
    explanation:
        'Condition : auteur non ascendant (tiers ou famille non ascendant).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — 227-8',
    question: 'Le support rappelle que 227-8 exige une soustraction :',
    options: ['Sans fraude ni violence', 'Avec violence', 'Avec fraude'],
    answer: 'Sans fraude ni violence',
    explanation: 'Le texte impose l’absence de fraude et de violence.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Répression',
    question: 'La peine encourue (forme simple) pour 227-8 est :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Le support indique : 5 ans + 75 000 €.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Tentative',
    question: 'La tentative de soustraction par tiers (227-8) est :',
    options: [
      'Oui, expressément prévue par l’article 227-11 du Code pénal',
      'Non',
      'Oui uniquement si l’enfant est retenu 5 jours',
    ],
    answer: 'Oui, expressément prévue par l’article 227-11 du Code pénal',
    explanation: 'Le support indique : tentative prévue par 227-11 CP.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Erreur sur l’âge',
    question:
        'Le support admet qu’il n’y a pas de délit si l’auteur a pu raisonnablement :',
    options: [
      'Se tromper sur l’âge et croire la personne majeure',
      'Se tromper sur le prénom',
      'Se tromper sur la commune',
    ],
    answer: 'Se tromper sur l’âge et croire la personne majeure',
    explanation: 'Le support mentionne l’erreur raisonnable sur l’âge.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Jurisprudence',
    question:
        'Selon Cass. crim., 3 sept. 2014 (cité), le délit est constitué si un tiers recueillant un mineur en fugue :',
    options: [
      'Ne prévient pas les parents',
      'Prévient immédiatement les parents',
      'Le remet à l’école',
    ],
    answer: 'Ne prévient pas les parents',
    explanation:
        'Le support cite cette jurisprudence : absence de démarche pour prévenir les parents.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // 227-9 / 227-10 — AGGRAVATIONS COMMUNES (UTILISABLES SUR 227-5 ET 227-7)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Aggravations — 227-9',
    question:
        'La circonstance aggravante 227-9 est constituée si l’enfant est retenu au-delà de cinq jours :',
    options: [
      'Sans que ceux qui ont droit de le réclamer sachent où il se trouve',
      'Même si tout le monde sait où il est',
      'Uniquement si l’enfant a moins de 6 ans',
    ],
    answer:
        'Sans que ceux qui ont droit de le réclamer sachent où il se trouve',
    explanation:
        '227-9 : > 5 jours + lieu inconnu pour les titulaires du droit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Aggravations — 227-9',
    question:
        'La circonstance aggravante 227-9 est aussi constituée si l’enfant est retenu indûment :',
    options: [
      'Hors du territoire de la République',
      'Chez un voisin',
      'Dans la même résidence',
    ],
    answer: 'Hors du territoire de la République',
    explanation: '227-9 : rétention indue hors du territoire.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Aggravations — 227-10',
    question: 'La circonstance aggravante 227-10 vise le cas où l’auteur :',
    options: [
      'A été déchu de l’autorité parentale ou a fait l’objet d’un retrait de l’exercice de cette autorité',
      'A seulement déménagé',
      'A seulement contesté la décision',
    ],
    answer:
        'A été déchu de l’autorité parentale ou a fait l’objet d’un retrait de l’exercice de cette autorité',
    explanation:
        '227-10 : déchéance ou retrait de l’exercice de l’autorité parentale.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // 227-11 — TENTATIVE (POINT COMMUN)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Tentative — 227-11',
    question: 'La tentative est expressément prévue par 227-11 pour :',
    options: [
      'La soustraction par ascendant (227-7) et la soustraction par tiers (227-8)',
      'La non-représentation (227-5) uniquement',
      'Le défaut de notification (227-6) uniquement',
    ],
    answer:
        'La soustraction par ascendant (227-7) et la soustraction par tiers (227-8)',
    explanation:
        'Le support indique : tentative OUI pour 227-7 et 227-8, prévue par 227-11.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // CAS PRATIQUES (QCM) — SUPER EFFICACES
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Cas pratique — 227-5',
    question:
        'Un parent gardien refuse de remettre l’enfant à l’autre parent pendant le week-end prévu par une décision exécutoire portée à sa connaissance. Qualification la plus adaptée :',
    options: [
      'Non-représentation d’enfant mineur (227-5)',
      'Défaut de notification de transfert de domicile (227-6)',
      'Soustraction par tiers (227-8)',
    ],
    answer: 'Non-représentation d’enfant mineur (227-5)',
    explanation:
        'Refus indû de représenter l’enfant à celui qui a le droit de le réclamer : 227-5.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Cas pratique — 227-6',
    question:
        'Un parent gardien déménage avec les enfants et n’informe pas l’autre parent titulaire d’un droit de visite dans le mois. Qualification la plus adaptée :',
    options: [
      'Défaut de notification de transfert de domicile (227-6)',
      'Non-représentation d’enfant (227-5)',
      'Soustraction par ascendant (227-7)',
    ],
    answer: 'Défaut de notification de transfert de domicile (227-6)',
    explanation:
        'Changement de domicile du parent gardien + absence de notification dans le mois : 227-6.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Cas pratique — 227-7',
    question:
        'Un grand-parent emmène durablement l’enfant du domicile habituel sans droit et le garde plusieurs jours. Qualification la plus adaptée :',
    options: [
      'Soustraction d’enfant mineur par ascendant (227-7)',
      'Soustraction par tiers (227-8)',
      'Défaut de notification (227-6)',
    ],
    answer: 'Soustraction d’enfant mineur par ascendant (227-7)',
    explanation: 'Le grand-parent est un ascendant : 227-7.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Cas pratique — 227-8',
    question:
        'Une tante héberge un mineur en fugue et ne prévient pas les parents. Qualification la plus adaptée selon le support :',
    options: [
      'Soustraction d’enfant mineur sans fraude ni violence par non-ascendant (227-8)',
      'Soustraction par ascendant (227-7)',
      'Non-représentation (227-5)',
    ],
    answer:
        'Soustraction d’enfant mineur sans fraude ni violence par non-ascendant (227-8)',
    explanation:
        'La tante n’est pas un ascendant : 227-8 ; la jurisprudence citée vise l’absence d’information des parents.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Non-représentation d’enfant mineur — Fondement',
    question:
        'La non-représentation d’enfant mineur consiste principalement à :',
    options: [
      'Refuser indûment de représenter un enfant mineur à la personne qui a le droit de le réclamer',
      'Déplacer un mineur sans fraude ni violence par un tiers',
      'Ne pas notifier un transfert de domicile dans un délai d’un mois',
    ],
    answer:
        'Refuser indûment de représenter un enfant mineur à la personne qui a le droit de le réclamer',
    explanation:
        'Le délit est le refus indû de représenter le mineur à celui qui a le droit de le réclamer.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-représentation d’enfant mineur — Fondement',
    question:
        'Au sens de l’article 388 du code civil, est mineure toute personne :',
    options: [
      'Âgée de moins de 18 ans',
      'Âgée de moins de 16 ans',
      'Âgée de moins de 21 ans',
    ],
    answer: 'Âgée de moins de 18 ans',
    explanation:
        'L’article 388 du code civil précise que le mineur a moins de 18 ans.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // NON-REPRÉSENTATION — DROIT DE RÉCLAMER LE MINEUR (SOURCE)
  // =========================================================
  const QuizQuestion(
    category: 'Non-représentation — Droit de réclamer',
    question: 'Le droit de réclamer le mineur a en général pour origine :',
    options: [
      'Une décision judiciaire ou une convention judiciairement homologuée ou une convention prévue à l’article 229-1 du code civil',
      'Une simple promesse orale entre parents',
      'Un accord écrit non signé',
    ],
    answer:
        'Une décision judiciaire ou une convention judiciairement homologuée ou une convention prévue à l’article 229-1 du code civil',
    explanation:
        'Le support indique que le droit provient généralement d’une décision de justice, d’une convention homologuée ou d’une convention 229-1 C. civ.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Droit de réclamer',
    question:
        'Le droit de garde, de visite ou d’hébergement peut être attribué :',
    options: [
      'À titre provisoire ou définitif',
      'Uniquement à titre définitif',
      'Uniquement à titre provisoire',
    ],
    answer: 'À titre provisoire ou définitif',
    explanation:
        'Le support précise que ces droits peuvent être provisoires ou définitifs.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Droit de réclamer',
    question:
        'La jurisprudence exige que la décision fondant le droit de réclamer soit :',
    options: [
      'Exécutoire et portée dans les formes légales à la connaissance de celui qui refuse',
      'Signée uniquement par l’avocat',
      'Rédigée en présence d’un officier de police judiciaire',
    ],
    answer:
        'Exécutoire et portée dans les formes légales à la connaissance de celui qui refuse',
    explanation:
        'Le support indique que la décision doit être exécutoire et portée légalement à la connaissance de l’auteur du refus.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Droit de réclamer',
    question: 'Le droit de réclamer l’enfant est aussi reconnu par la loi à :',
    options: [
      'Toute personne investie de l’autorité parentale',
      'Tout membre de la famille',
      'Toute personne vivant au même domicile',
    ],
    answer: 'Toute personne investie de l’autorité parentale',
    explanation:
        'Le support précise que le droit est aussi reconnu à toute personne investie de l’autorité parentale (père, mère, tuteur).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Droit de réclamer',
    question:
        'En règle générale, les personnes investies de l’autorité parentale sont :',
    options: [
      'Le père, la mère ou le tuteur du mineur',
      'Le grand frère ou la grande sœur',
      'Le voisin désigné',
    ],
    answer: 'Le père, la mère ou le tuteur du mineur',
    explanation: 'Le support cite : père, mère ou tuteur du mineur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Droit de réclamer',
    question:
        'À défaut d’une décision délimitant les droits de chacun, le délit ne peut pas être constitué lorsque le conflit oppose :',
    options: [
      'Deux personnes ayant des droits égaux concernant le mineur',
      'Un parent et un tiers',
      'Un tuteur et un ascendant',
    ],
    answer: 'Deux personnes ayant des droits égaux concernant le mineur',
    explanation:
        'Le support indique qu’en l’absence de décision délimitant les droits, le délit n’est pas constitué si les droits sont égaux (ex : parents séparés de fait).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Droit de réclamer',
    question:
        'Le cas typique où le délit ne peut être constitué faute de décision délimitant les droits est :',
    options: [
      'Les parents séparés de fait ayant des droits égaux',
      'Un parent déchu de l’autorité parentale',
      'Un ascendant ayant enlevé l’enfant',
    ],
    answer: 'Les parents séparés de fait ayant des droits égaux',
    explanation: 'Le support cite expressément les parents séparés de fait.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NON-REPRÉSENTATION — REFUS DE REPRÉSENTER : SCÉNARIOS
  // =========================================================
  const QuizQuestion(
    category: 'Non-représentation — Élément matériel',
    question: 'Le refus de représenter le mineur peut être le fait :',
    options: [
      'Du parent gardien qui refuse le droit de visite de l’autre parent',
      'Uniquement d’un tiers sans lien familial',
      'Uniquement du mineur',
    ],
    answer: 'Du parent gardien qui refuse le droit de visite de l’autre parent',
    explanation:
        'Le support indique que le refus est souvent le fait du parent ayant la garde refusant le droit de visite/hébergement.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément matériel',
    question: 'Le refus peut aussi être commis par :',
    options: [
      'Le parent bénéficiaire d’un hébergement qui ne remet pas l’enfant à la fin de la période',
      'Le juge aux affaires familiales',
      'L’avocat du parent',
    ],
    answer:
        'Le parent bénéficiaire d’un hébergement qui ne remet pas l’enfant à la fin de la période',
    explanation:
        'Le support vise aussi le parent qui ne remet pas l’enfant à l’issue de la période d’hébergement.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément matériel',
    question: 'Le refus de représenter le mineur peut résulter :',
    options: [
      'D’un comportement actif direct',
      'Uniquement d’un écrit',
      'Uniquement d’une violence physique',
    ],
    answer: 'D’un comportement actif direct',
    explanation:
        'Le support mentionne le comportement actif direct (refus pur et simple, etc.).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément matériel',
    question: 'Parmi les exemples de comportement actif direct, on trouve :',
    options: [
      'La dissimulation du mineur',
      'Le paiement d’une pension',
      'La signature d’une convention',
    ],
    answer: 'La dissimulation du mineur',
    explanation: 'Le support cite la dissimulation du mineur comme exemple.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément matériel',
    question:
        'Parmi les exemples de comportement actif direct, on trouve également :',
    options: [
      'L’absence du domicile lorsque l’autre parent se présente pour exercer son droit',
      'Le dépôt d’un dossier CAF',
      'La présence à l’heure convenue',
    ],
    answer:
        'L’absence du domicile lorsque l’autre parent se présente pour exercer son droit',
    explanation:
        'Le support cite l’absence du domicile lors de la présentation du titulaire du droit.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément matériel',
    question: 'Le refus de représenter le mineur peut aussi résulter :',
    options: [
      'D’un comportement actif indirect',
      'Uniquement d’un acte notarié',
      'Uniquement d’un SMS',
    ],
    answer: 'D’un comportement actif indirect',
    explanation:
        'Le support mentionne le comportement actif indirect (manipulation du mineur).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément matériel',
    question: 'Un exemple de comportement actif indirect est :',
    options: [
      'Manipuler le mineur pour l’inciter à refuser la visite ou l’hébergement',
      'Informer l’autre parent du retard',
      'Présenter l’enfant au lieu convenu',
    ],
    answer:
        'Manipuler le mineur pour l’inciter à refuser la visite ou l’hébergement',
    explanation: 'Le support cite la manipulation du mineur.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément matériel',
    question:
        'Le refus de représenter peut résulter d’un comportement passif lorsque :',
    options: [
      'Le parent gardien s’abstient d’intervenir alors que le mineur refuse spontanément',
      'Le parent informe l’autre parent à l’avance',
      'Le parent demande une médiation',
    ],
    answer:
        'Le parent gardien s’abstient d’intervenir alors que le mineur refuse spontanément',
    explanation: 'Le support décrit l’hypothèse du comportement passif.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément matériel',
    question:
        'Selon la jurisprudence rappelée par le support, la résistance du mineur :',
    options: [
      'Ne constitue pas une excuse légale ni un fait justificatif',
      'Constitue automatiquement un fait justificatif',
      'Supprime toujours l’intention',
    ],
    answer: 'Ne constitue pas une excuse légale ni un fait justificatif',
    explanation:
        'Le support indique que la résistance du mineur n’est pas une excuse légale.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NON-REPRÉSENTATION — ÉLÉMENT MORAL (INTENTION / MAUVAISE FOI)
  // =========================================================
  const QuizQuestion(
    category: 'Non-représentation — Élément moral',
    question: 'La non-représentation d’enfant mineur est une infraction :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Contraventionnelle'],
    answer: 'Intentionnelle',
    explanation: 'Le support précise que l’infraction est intentionnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément moral',
    question: 'Le terme « refus » indique :',
    options: [
      'Une attitude consciente et volontaire de l’auteur',
      'Un simple oubli involontaire',
      'Une erreur matérielle',
    ],
    answer: 'Une attitude consciente et volontaire de l’auteur',
    explanation:
        'Le support précise que « refus » traduit une attitude consciente et volontaire.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément moral',
    question: 'L’adverbe « indûment » souligne :',
    options: [
      'La mauvaise foi de l’auteur',
      'L’absence de lien de filiation',
      'Un droit automatique de garde',
    ],
    answer: 'La mauvaise foi de l’auteur',
    explanation:
        'Le support indique que « indûment » souligne la mauvaise foi.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément moral',
    question:
        'Pour caractériser l’intention, une décision de justice préalable doit avoir été :',
    options: [
      'Signifiée ou portée à la connaissance de l’auteur du refus',
      'Publiée au Journal officiel',
      'Transmise uniquement à l’école',
    ],
    answer: 'Signifiée ou portée à la connaissance de l’auteur du refus',
    explanation: 'Le support insiste sur la connaissance des droits empêchés.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément moral',
    question:
        'Selon la Cour de cassation (08/09/1999), l’élément intentionnel est caractérisé par :',
    options: [
      'Le refus délibéré ou indû de remettre l’enfant à la personne qui a le droit de le réclamer',
      'Le simple retard d’une heure',
      'La seule contestation de la décision',
    ],
    answer:
        'Le refus délibéré ou indû de remettre l’enfant à la personne qui a le droit de le réclamer',
    explanation:
        'Le support cite Cass. crim., 08 septembre 1999 sur le refus délibéré/indû.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément moral',
    question: 'D’après Cass. crim., 08/09/1999, le mobile de l’auteur :',
    options: [
      'Importe peu',
      'Est déterminant pour l’infraction',
      'Supprime toujours l’intention',
    ],
    answer: 'Importe peu',
    explanation: 'Le support précise que le mobile importe peu.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Élément moral',
    question: 'La non-représentation peut être justifiée si est démontrée :',
    options: [
      'L’existence d’un danger actuel et imminent',
      'Une simple crainte générale',
      'Une mésentente entre parents',
    ],
    answer: 'L’existence d’un danger actuel et imminent',
    explanation:
        'Le support admet la justification en cas de danger actuel et imminent.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NON-REPRÉSENTATION — CIRCONSTANCES AGGRAVANTES (227-9 / 227-10)
  // =========================================================
  const QuizQuestion(
    category: 'Non-représentation — Circonstances aggravantes',
    question:
        'Les circonstances aggravantes de non-représentation d’enfant sont prévues par :',
    options: [
      'Les articles 227-9 et 227-10 du Code pénal',
      'L’article 227-11 du Code pénal uniquement',
      'L’article 388 du code civil',
    ],
    answer: 'Les articles 227-9 et 227-10 du Code pénal',
    explanation: 'Le support mentionne 227-9 CP et 227-10 CP.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — 227-9',
    question:
        'Selon 227-9 CP, il y a aggravation si l’enfant est retenu au-delà de cinq jours :',
    options: [
      'Sans que ceux qui ont droit de le réclamer sachent où il se trouve',
      'Même si l’adresse est connue',
      'Uniquement si l’enfant a moins de 10 ans',
    ],
    answer:
        'Sans que ceux qui ont droit de le réclamer sachent où il se trouve',
    explanation: 'Le support cite l’aggravation : > 5 jours + lieu inconnu.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — 227-9',
    question:
        'Selon 227-9 CP, il y a aggravation si l’enfant est retenu indûment :',
    options: [
      'Hors du territoire de la République',
      'Dans sa commune de résidence',
      'Chez un autre parent déclaré',
    ],
    answer: 'Hors du territoire de la République',
    explanation:
        'Le support mentionne l’aggravation en cas de rétention hors du territoire.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — 227-10',
    question:
        'Selon 227-10 CP, il y a aggravation si la personne coupable a été :',
    options: [
      'Déchue de l’autorité parentale ou a fait l’objet d’une décision de retrait de l’exercice de cette autorité',
      'Simplement en désaccord avec l’autre parent',
      'Sans emploi',
    ],
    answer:
        'Déchue de l’autorité parentale ou a fait l’objet d’une décision de retrait de l’exercice de cette autorité',
    explanation:
        'Le support vise la déchéance/retrait de l’exercice de l’autorité parentale.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NON-REPRÉSENTATION — RÉPRESSION (227-5 simple / aggravée)
  // =========================================================
  const QuizQuestion(
    category: 'Non-représentation — Répression',
    question:
        'La peine encourue (forme simple) pour la non-représentation (227-5) est :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le support indique : 1 an + 15 000 € pour la forme simple.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Répression',
    question:
        'En cas de circonstances aggravantes (227-9 ou 227-10), la peine encourue est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le support indique : 3 ans + 45 000 € en aggravé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Tentative / complicité',
    question: 'Pour la non-représentation d’enfant (227-5), la tentative est :',
    options: ['Non', 'Oui', 'Oui uniquement en aggravé'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-représentation — Tentative / complicité',
    question:
        'Pour la non-représentation d’enfant (227-5), la complicité est :',
    options: [
      'Oui (article 121-7 du Code pénal)',
      'Non',
      'Oui uniquement si l’auteur est un tiers',
    ],
    answer: 'Oui (article 121-7 du Code pénal)',
    explanation: 'Le support indique : COMPLICITÉ : OUI, article 121-7 CP.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // DÉFAUT DE NOTIFICATION DE TRANSFERT DE DOMICILE — FONDEMENTS (227-6)
  // =========================================================
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Fondement',
    question:
        'Le défaut de notification de transfert de domicile est prévu par :',
    options: [
      'L’article 227-6 du Code pénal',
      'L’article 227-5 du Code pénal',
      'L’article 227-4-3 du Code pénal',
    ],
    answer: 'L’article 227-6 du Code pénal',
    explanation: 'L’élément légal est fixé par l’article 227-6 du Code pénal.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Fondement',
    question: 'L’infraction 227-6 vise le cas où :',
    options: [
      'Un parent transfère son domicile alors que les enfants résident habituellement chez lui',
      'Un tiers héberge un mineur en fugue',
      'Un ascendant déplace l’enfant de quelques minutes',
    ],
    answer:
        'Un parent transfère son domicile alors que les enfants résident habituellement chez lui',
    explanation:
        'Le support précise : parent qui change de domicile avec des enfants résidant habituellement chez lui.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Fondement',
    question:
        '227-6 impose de notifier le changement de domicile dans un délai de :',
    options: ['Un mois', 'Cinq jours', 'Six jours'],
    answer: 'Un mois',
    explanation: 'Le support fixe un délai d’un mois à compter du changement.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // 227-6 — ÉLÉMENT MATÉRIEL : TRANSFERT + ABSENCE DE NOTIFICATION
  // =========================================================
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Élément matériel',
    question:
        'Le transfert de domicile visé par 227-6 concerne principalement :',
    options: [
      'Le parent à qui la garde des mineurs a été confiée',
      'Un tuteur professionnel uniquement',
      'Un ascendant autre que les parents',
    ],
    answer: 'Le parent à qui la garde des mineurs a été confiée',
    explanation:
        'Le support précise : parent gardien chez qui l’enfant réside habituellement.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Élément matériel',
    question: 'Le support précise que sont visés par 227-6 :',
    options: [
      'Les parents légitimes, naturels ou adoptifs',
      'Uniquement les parents mariés',
      'Uniquement les parents adoptifs',
    ],
    answer: 'Les parents légitimes, naturels ou adoptifs',
    explanation: 'Le support indique que tous ces parents sont visés.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Élément matériel',
    question: 'Pour caractériser 227-6, l’auteur doit :',
    options: [
      'Changer de domicile et emmener le ou les enfants avec lui',
      'Changer de travail',
      'Changer d’école uniquement',
    ],
    answer: 'Changer de domicile et emmener le ou les enfants avec lui',
    explanation:
        'Le support décrit l’idée d’emmener l’enfant avec le parent qui déménage.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Élément matériel',
    question:
        'Le droit de visite ou d’hébergement du bénéficiaire doit être prévu par :',
    options: [
      'Un jugement, une convention homologuée ou une convention 229-1 du code civil',
      'Un accord oral',
      'Une lettre simple',
    ],
    answer:
        'Un jugement, une convention homologuée ou une convention 229-1 du code civil',
    explanation: 'Le support renvoie à ces trois sources.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Élément matériel',
    question: 'La décision fondant le droit de visite/hébergement doit être :',
    options: [
      'Exécutoire et notifiée à l’auteur des faits',
      'Simplement demandée au greffe',
      'Seulement connue de la famille',
    ],
    answer: 'Exécutoire et notifiée à l’auteur des faits',
    explanation: 'Le support insiste sur l’exécutivité et la notification.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Élément matériel',
    question:
        'Concernant la forme de la notification du changement de domicile (227-6), le support indique :',
    options: [
      'Aucune exigence de forme',
      'Obligation d’une LRAR',
      'Obligation d’un acte de commissaire de justice',
    ],
    answer: 'Aucune exigence de forme',
    explanation: 'Le support précise : aucune exigence quant à la forme.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 227-6 — ÉLÉMENT MORAL
  // =========================================================
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Élément moral',
    question:
        'Le défaut de notification de transfert de domicile (227-6) est une infraction :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Contraventionnelle'],
    answer: 'Intentionnelle',
    explanation:
        'Le support précise l’intention : volonté de faire échec au droit de visite/hébergement.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Élément moral',
    question: 'Selon le support, l’intention dans 227-6 suppose :',
    options: [
      'La volonté de faire échec au droit de visite ou d’hébergement',
      'Un simple oubli',
      'Une erreur sur le code civil',
    ],
    answer: 'La volonté de faire échec au droit de visite ou d’hébergement',
    explanation:
        'Le support indique que l’intention vise à empêcher l’exercice du droit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Élément moral',
    question: 'Pour 227-6, la simple négligence est punissable :',
    options: ['Non', 'Oui', 'Oui si le déménagement est loin'],
    answer: 'Non',
    explanation:
        'Le support précise : la simple négligence n’est pas punissable.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 227-6 — CIRCONSTANCES / RÉPRESSION / TENTATIVE / COMPLICITÉ
  // =========================================================
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Circonstances',
    question: 'Pour 227-6, les circonstances aggravantes prévues sont :',
    options: [
      'Aucune',
      'Celles de 227-9 automatiquement',
      'Celles de 227-10 automatiquement',
    ],
    answer: 'Aucune',
    explanation: 'Le support indique : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Répression',
    question: 'La peine encourue pour 227-6 (personne physique) est :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation: 'Le support fixe : 6 mois + 7 500 €.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Tentative / complicité',
    question: 'Pour 227-6, la tentative est :',
    options: ['Non', 'Oui', 'Oui uniquement si l’enfant est à l’étranger'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Défaut notification transfert domicile — Tentative / complicité',
    question: 'Pour 227-6, la complicité est :',
    options: [
      'Oui (article 121-7 du Code pénal)',
      'Non',
      'Oui uniquement en aggravé',
    ],
    answer: 'Oui (article 121-7 du Code pénal)',
    explanation: 'Le support indique : COMPLICITÉ : OUI, article 121-7 CP.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // SOUSTRACTION D’ENFANT MINEUR PAR ASCENDANT — FONDEMENTS (227-7)
  // =========================================================
  const QuizQuestion(
    category: 'Soustraction par ascendant — Fondement',
    question: 'La soustraction d’enfant mineur par ascendant est prévue par :',
    options: [
      'L’article 227-7 du Code pénal',
      'L’article 227-8 du Code pénal',
      'L’article 227-5 du Code pénal',
    ],
    answer: 'L’article 227-7 du Code pénal',
    explanation: 'L’élément légal est fixé par l’article 227-7 du Code pénal.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Élément matériel',
    question: 'Pour 227-7, l’auteur doit être :',
    options: [
      'Un ascendant du mineur',
      'Un tiers sans lien familial',
      'Uniquement un tuteur professionnel',
    ],
    answer: 'Un ascendant du mineur',
    explanation: 'Le support précise que tout ascendant peut être auteur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Élément matériel',
    question: 'Sont notamment des ascendants au sens du support :',
    options: [
      'Père, mère, grands-parents, arrière-grands-parents',
      'Oncle, tante, cousin',
      'Frère, sœur',
    ],
    answer: 'Père, mère, grands-parents, arrière-grands-parents',
    explanation: 'Le support cite ces exemples d’ascendants.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Élément matériel',
    question: 'Pour 227-7, il doit exister entre l’auteur et le mineur :',
    options: [
      'Un lien de filiation',
      'Un lien d’alliance uniquement',
      'Un simple lien d’amitié',
    ],
    answer: 'Un lien de filiation',
    explanation:
        'Le support exige un lien de filiation entre l’agent et le mineur.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Élément matériel',
    question:
        'Les personnes des mains desquelles le mineur est soustrait sont :',
    options: [
      'Ceux qui exercent l’autorité parentale, ou ceux à qui il a été confié, ou chez qui il réside habituellement',
      'Uniquement les parents biologiques',
      'Uniquement l’école',
    ],
    answer:
        'Ceux qui exercent l’autorité parentale, ou ceux à qui il a été confié, ou chez qui il réside habituellement',
    explanation: 'Le support reprend la formule du texte.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Élément matériel',
    question: 'L’acte de soustraction implique :',
    options: [
      'Un acte positif consistant à déplacer ou à obtenir le déplacement du mineur',
      'Une simple omission',
      'Un simple retard',
    ],
    answer:
        'Un acte positif consistant à déplacer ou à obtenir le déplacement du mineur',
    explanation:
        'Le support définit la soustraction par un acte positif de déplacement.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Élément matériel',
    question:
        'Le support précise que l’infraction ne peut être retenue contre :',
    options: [
      'Une personne à qui l’enfant a été confié volontairement',
      'Un parent gardien',
      'Un ascendant',
    ],
    answer: 'Une personne à qui l’enfant a été confié volontairement',
    explanation:
        'Le support indique qu’on ne retient pas l’infraction si l’enfant a été confié volontairement.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Élément matériel',
    question: 'La soustraction peut consister aussi à :',
    options: [
      'Accepter d’héberger l’enfant ayant fui de sa propre volonté',
      'Notifier un déménagement',
      'Faire homologuer une convention',
    ],
    answer: 'Accepter d’héberger l’enfant ayant fui de sa propre volonté',
    explanation: 'Le support mentionne cette hypothèse.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Élément matériel',
    question:
        'Selon la jurisprudence citée, un déplacement de quelques heures :',
    options: [
      'Ne suffit pas à caractériser la soustraction',
      'Suffit toujours',
      'Suffit uniquement si l’enfant a moins de 10 ans',
    ],
    answer: 'Ne suffit pas à caractériser la soustraction',
    explanation: 'Le support cite Cass. crim., 23 décembre 1968.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Éléments spéciaux',
    question:
        'Le support indique que 227-7 ne limite pas la soustraction “sans fraude ni violence”, ce qui signifie :',
    options: [
      'Qu’une soustraction avec fraude/violence peut aussi relever de 227-7, même si d’autres qualifications plus sévères peuvent s’appliquer',
      'Que la fraude/violence est impossible',
      'Que 227-7 est une contravention',
    ],
    answer:
        'Qu’une soustraction avec fraude/violence peut aussi relever de 227-7, même si d’autres qualifications plus sévères peuvent s’appliquer',
    explanation:
        'Le support explique que 227-7 ne contient pas la limitation “sans fraude ni violence”, mais qu’en cas de violence/fraude, les infractions 224-1 et s. peuvent s’appliquer.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 227-7 — ÉLÉMENT MORAL / CIRCONSTANCES / RÉPRESSION
  // =========================================================
  const QuizQuestion(
    category: 'Soustraction par ascendant — Élément moral',
    question:
        'La soustraction d’enfant mineur par ascendant (227-7) est une infraction :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Purement civile'],
    answer: 'Intentionnelle',
    explanation: 'Le support précise que l’infraction est intentionnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Élément moral',
    question: 'L’intention, selon le support, suppose que l’auteur agisse :',
    options: [
      'En connaissance de son absence de droit',
      'En croyant toujours être dans son droit',
      'Sans comprendre ce qu’il fait',
    ],
    answer: 'En connaissance de son absence de droit',
    explanation: 'Le support indique : connaissance de son absence de droit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Répression',
    question: 'La peine encourue (forme simple) pour 227-7 est :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le support indique : 1 an + 15 000 € pour la forme simple.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Circonstances aggravantes',
    question:
        'Les circonstances aggravantes applicables à 227-7 sont prévues par :',
    options: [
      'Les articles 227-9 et 227-10 du Code pénal',
      'L’article 227-6 du Code pénal',
      'L’article 227-11 du Code pénal uniquement',
    ],
    answer: 'Les articles 227-9 et 227-10 du Code pénal',
    explanation: 'Le support indique 227-9 et 227-10 comme aggravations.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Répression aggravée',
    question:
        'En cas de circonstances 227-9 ou 227-10, la peine encourue pour 227-7 est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le support indique : 3 ans + 45 000 € en aggravé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Tentative / complicité',
    question: 'Pour 227-7, la tentative est :',
    options: [
      'Oui (prévue par 227-11 du Code pénal)',
      'Non',
      'Oui seulement en cas d’étranger',
    ],
    answer: 'Oui (prévue par 227-11 du Code pénal)',
    explanation:
        'Le support indique : tentative expressément prévue par 227-11 CP.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction par ascendant — Tentative / complicité',
    question: 'Pour 227-7, la complicité est :',
    options: [
      'Oui (article 121-7 du Code pénal)',
      'Non',
      'Oui uniquement si l’auteur est un tiers',
    ],
    answer: 'Oui (article 121-7 du Code pénal)',
    explanation: 'Le support indique : complicité applicable selon 121-7 CP.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // SOUSTRACTION SANS FRAUDE NI VIOLENCE (TIERS) — FONDEMENTS (227-8)
  // =========================================================
  const QuizQuestion(
    category: 'Soustraction par tiers — Fondement',
    question:
        'La soustraction d’enfant mineur sans fraude ni violence par une personne autre qu’un ascendant est prévue par :',
    options: [
      'L’article 227-8 du Code pénal',
      'L’article 227-7 du Code pénal',
      'L’article 227-6 du Code pénal',
    ],
    answer: 'L’article 227-8 du Code pénal',
    explanation: 'L’élément légal est fixé par l’article 227-8 du Code pénal.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Élément matériel',
    question: 'Pour 227-8, l’auteur doit être :',
    options: [
      'Une personne autre qu’un ascendant',
      'Un ascendant',
      'Un tuteur uniquement',
    ],
    answer: 'Une personne autre qu’un ascendant',
    explanation:
        'Le support précise : auteur non ascendant (tiers ou membre de famille non ascendant).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Élément matériel',
    question: 'Peut être auteur au sens de 227-8 :',
    options: [
      'Un tiers ou un membre de la famille non ascendant (ex : frère, sœur, tante, oncle)',
      'Uniquement un inconnu',
      'Uniquement un professionnel de l’enfance',
    ],
    answer:
        'Un tiers ou un membre de la famille non ascendant (ex : frère, sœur, tante, oncle)',
    explanation: 'Le support donne ces exemples.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Élément matériel',
    question: 'Le texte 227-8 exige que la soustraction soit commise :',
    options: [
      'Sans fraude ni violence',
      'Avec violence',
      'Avec fraude obligatoire',
    ],
    answer: 'Sans fraude ni violence',
    explanation: 'Le support indique la condition “sans fraude ni violence”.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Jurisprudence',
    question:
        'Selon la jurisprudence citée (Cass. crim., 3 sept. 2014), le délit peut être constitué si le tiers qui recueille un mineur en fugue :',
    options: [
      'Ne prévient pas les parents',
      'Informe immédiatement les parents',
      'Contacte un avocat',
    ],
    answer: 'Ne prévient pas les parents',
    explanation: 'Le support cite Cass. crim., 3 sept. 2014.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Élément matériel',
    question: 'La soustraction, selon le support, implique :',
    options: [
      'Un acte positif consistant à déplacer ou à obtenir le déplacement du mineur',
      'Un simple silence',
      'Une simple présence au domicile',
    ],
    answer:
        'Un acte positif consistant à déplacer ou à obtenir le déplacement du mineur',
    explanation:
        'Même définition générale de la soustraction par acte positif de déplacement.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Élément matériel',
    question:
        'Le support rappelle que la fraude ou la violence orientent plutôt vers :',
    options: [
      'Les infractions d’enlèvement et de séquestration (224-1 et s.)',
      'Le seul 227-8',
      'Une contravention',
    ],
    answer: 'Les infractions d’enlèvement et de séquestration (224-1 et s.)',
    explanation:
        'Le support indique que fraude/violence renvoient aux infractions plus sévères 224-1 et suivants.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 227-8 — ÉLÉMENT MORAL / CIRCONSTANCES / RÉPRESSION / TENTATIVE / COMPLICITÉ
  // =========================================================
  const QuizQuestion(
    category: 'Soustraction par tiers — Élément moral',
    question:
        'La soustraction sans fraude ni violence (227-8) est une infraction :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Purement civile'],
    answer: 'Intentionnelle',
    explanation:
        'Le support précise l’intention : connaissance de son absence de droit.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Élément moral',
    question:
        'Le support admet qu’il n’y a pas délit si l’auteur a pu raisonnablement :',
    options: [
      'Se tromper sur l’âge et croire la personne majeure',
      'Se tromper sur le lieu',
      'Oublier le prénom du mineur',
    ],
    answer: 'Se tromper sur l’âge et croire la personne majeure',
    explanation: 'Le support mentionne l’erreur raisonnable sur l’âge.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Circonstances aggravantes',
    question: 'Pour 227-8, les circonstances aggravantes prévues sont :',
    options: [
      'Aucune',
      'Celles de 227-9 automatiquement',
      'Celles de 227-10 automatiquement',
    ],
    answer: 'Aucune',
    explanation: 'Le support indique : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Répression',
    question: 'La peine encourue (personne physique) pour 227-8 est :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Le support fixe : 5 ans + 75 000 €.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Tentative / complicité',
    question: 'Pour 227-8, la tentative est :',
    options: [
      'Oui (prévue expressément par 227-11 du Code pénal)',
      'Non',
      'Oui seulement si l’enfant est à l’étranger',
    ],
    answer: 'Oui (prévue expressément par 227-11 du Code pénal)',
    explanation: 'Le support indique : tentative prévue par 227-11 CP.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction par tiers — Tentative / complicité',
    question: 'Pour 227-8, la complicité est :',
    options: [
      'Oui (article 121-7 du Code pénal)',
      'Non',
      'Oui uniquement en cas de violence',
    ],
    answer: 'Oui (article 121-7 du Code pénal)',
    explanation: 'Le support indique : complicité applicable selon 121-7 CP.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // QUESTIONS COMPARATIVES ULTRA RENTABLES (227-5 / 227-6 / 227-7 / 227-8)
  // =========================================================
  const QuizQuestion(
    category: 'Comparatif — Autorité parentale',
    question:
        'Quel article vise le refus indû de représenter un enfant mineur ?',
    options: ['227-5', '227-6', '227-8'],
    answer: '227-5',
    explanation: '227-5 = non-représentation d’enfant mineur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Comparatif — Autorité parentale',
    question:
        'Quel article vise le défaut de notification de transfert de domicile du parent gardien ?',
    options: ['227-6', '227-5', '227-7'],
    answer: '227-6',
    explanation: '227-6 = défaut de notification de transfert de domicile.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Comparatif — Autorité parentale',
    question:
        'Quel article vise la soustraction d’enfant mineur commise par un ascendant ?',
    options: ['227-7', '227-8', '227-6'],
    answer: '227-7',
    explanation: '227-7 = soustraction par ascendant.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Comparatif — Autorité parentale',
    question:
        'Quel article vise la soustraction d’enfant mineur sans fraude ni violence par un tiers ?',
    options: ['227-8', '227-7', '227-5'],
    answer: '227-8',
    explanation:
        '227-8 = soustraction par personne autre qu’un ascendant, sans fraude ni violence.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Comparatif — Peines',
    question:
        'Quelle infraction est la plus sévèrement punie en forme simple selon le support ?',
    options: [
      '227-8 (5 ans, 75 000 €)',
      '227-5 (1 an, 15 000 €)',
      '227-6 (6 mois, 7 500 €)',
    ],
    answer: '227-8 (5 ans, 75 000 €)',
    explanation: 'Le support fixe 227-8 à 5 ans et 75 000 € (forme simple).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Comparatif — Tentative',
    question: 'Selon le support, la tentative est prévue pour :',
    options: [
      '227-7 et 227-8 (par 227-11)',
      '227-5 uniquement',
      '227-6 uniquement',
    ],
    answer: '227-7 et 227-8 (par 227-11)',
    explanation:
        'Le support indique tentative OUI pour 227-7 et 227-8, prévue par 227-11.',
    difficulty: 'Difficile',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizAutoriteParentaleGPX extends StatefulWidget {
  static const String grade = 'gpx';
  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/autorite_parentale/quiz_autorite_parentale';
  final String uid;
  final String email;

  const QuizAutoriteParentaleGPX({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizAutoriteParentaleGPX> createState() => _QuizAutoriteParentaleGPXState();
}

class _QuizAutoriteParentaleGPXState extends State<QuizAutoriteParentaleGPX>
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
  static const _introHiddenKey = 'intro_gpx_autorite_parentale';
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
        ? questionAutoriteParentale
        : questionAutoriteParentale
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
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Atteintes aux mineurs & à la famille',
            'quiz_name': 'Autorité parentale',
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
      await _sb.from('quiz_autorite_parentale').insert({
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
      debugPrint('❌ quiz_autorite_parentale insert failed: $e');
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
      'source_file': 'gpx_quiz_autorite_parentale',
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
                            icon: Icons.supervisor_account_rounded,
                            title: 'Autorité parentale',
                            description: 'Comprends le cadre juridique de l’autorité parentale : droits et devoirs des parents, conflits et rôle de la protection judiciaire.',
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
