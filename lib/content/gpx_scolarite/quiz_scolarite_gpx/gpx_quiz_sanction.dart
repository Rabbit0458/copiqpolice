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

final List<QuizQuestion> questionGPPluraliteInfractions = [
  const QuizQuestion(
    category: 'Pluralité d’infractions — Réitération d’infractions',
    question: 'La réitération d’infractions est définie comme :',
    options: [
      'La commission d’une infraction après une condamnation non définitive',
      'La commission d’une nouvelle infraction après une condamnation définitive ne répondant pas aux conditions de la récidive légale',
      'La commission simultanée de plusieurs infractions',
    ],
    answer:
        'La commission d’une nouvelle infraction après une condamnation définitive ne répondant pas aux conditions de la récidive légale',
    explanation:
        'L’article 132-16-7 al. 1 du code pénal définit la réitération comme la commission d’une nouvelle infraction après une condamnation définitive, sans remplir les conditions de la récidive légale.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Classification légale des peines (généralités)',
    question:
        'La classification tripartite des infractions (crimes, délits, contraventions) est commandée par :',
    options: [
      'Le montant du préjudice civil',
      'L’échelle des peines fixée par le code pénal',
      'La personnalité de la victime',
    ],
    answer: 'L’échelle des peines fixée par le code pénal',
    explanation:
        'Le cours : le code pénal établit une échelle des peines qui commande la classification tripartite des infractions.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Classification légale des peines (généralités)',
    question: 'L’échelle des peines figure notamment :',
    options: [
      'Aux articles 131-1 à 131-18 et 131-37 à 131-44-1 du code pénal',
      'Uniquement dans le code de procédure pénale',
      'Uniquement dans le code de la sécurité intérieure',
    ],
    answer: 'Aux articles 131-1 à 131-18 et 131-37 à 131-44-1 du code pénal',
    explanation:
        'Le cours cite expressément ces ensembles d’articles du code pénal.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Classification légale des peines (généralités)',
    question:
        'La classification légale des peines sert principalement à déterminer :',
    options: [
      'La compétence des juridictions et la nature de l’infraction (crime/délit/contravention)',
      'La nationalité de l’auteur',
      'Le montant des dommages-intérêts civils',
    ],
    answer:
        'La compétence des juridictions et la nature de l’infraction (crime/délit/contravention)',
    explanation:
        'En droit pénal, la nature de la peine renvoie à la nature de l’infraction, ce qui structure tout le régime répressif.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PERSONNES PHYSIQUES — PEINES CRIMINELLES
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines criminelles)',
    question: 'Une peine criminelle principale peut être :',
    options: [
      'La réclusion criminelle ou la détention criminelle',
      'Le travail d’intérêt général',
      'La détention à domicile sous surveillance électronique (DDSE)',
    ],
    answer: 'La réclusion criminelle ou la détention criminelle',
    explanation:
        'Le cours : en matière criminelle, les peines principales sont la réclusion ou la détention criminelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines criminelles)',
    question: 'Les peines principales en matière criminelle comprennent :',
    options: [
      'La réclusion/détention criminelle à perpétuité',
      'L’amende minimum de 3 750 €',
      'Le jour-amende',
    ],
    answer: 'La réclusion/détention criminelle à perpétuité',
    explanation:
        'Le cours liste la perpétuité comme peine principale criminelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines criminelles)',
    question:
        'Le maximum de réclusion/détention criminelle temporaire listé est :',
    options: ['30 ans au plus', '25 ans au plus', '10 ans au plus'],
    answer: '30 ans au plus',
    explanation: 'Le cours : 30 ans au plus (puis 20, puis 15).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines criminelles)',
    question: 'La réclusion criminelle est applicable :',
    options: [
      'Aux crimes de droit commun',
      'Aux crimes politiques uniquement',
      'Aux contraventions de 5e classe',
    ],
    answer: 'Aux crimes de droit commun',
    explanation:
        'Le cours : la réclusion s’applique aux crimes de droit commun.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines criminelles)',
    question: 'La détention criminelle est applicable :',
    options: [
      'Aux crimes politiques',
      'Aux délits routiers',
      'Aux contraventions',
    ],
    answer: 'Aux crimes politiques',
    explanation: 'Le cours : la détention s’applique aux crimes politiques.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines criminelles)',
    question:
        'Le juge peut prononcer une durée inférieure à celles mentionnées à l’art. 131-1 C.P., mais la durée doit être au moins :',
    options: ['10 ans', '5 ans', '2 ans'],
    answer: '10 ans',
    explanation:
        'Le cours précise : la durée de la réclusion ou de la détention doit être de 10 ans au moins.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines criminelles)',
    question: 'Une peine d’amende en matière criminelle est possible :',
    options: [
      'Uniquement si le texte réprimant le crime le prévoit expressément',
      'Toujours, en plus de la réclusion',
      'Jamais, par principe',
    ],
    answer: 'Uniquement si le texte réprimant le crime le prévoit expressément',
    explanation:
        'Le cours : l’amende peut s’ajouter uniquement si le texte la prévoit expressément.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines criminelles)',
    question: 'Les peines complémentaires en matière criminelle :',
    options: [
      'Peuvent s’ajouter aux peines principales si le texte les prévoit',
      'Remplacent toujours la peine principale',
      'Sont uniquement civiles',
    ],
    answer: 'Peuvent s’ajouter aux peines principales si le texte les prévoit',
    explanation:
        'Le cours : peines complémentaires prévues à l’art. 131-10 C.P., spécialement prévues par le texte réprimant l’infraction.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines criminelles)',
    question:
        'Les peines complémentaires applicables aux personnes physiques sont prévues notamment à :',
    options: [
      'L’article 131-10 du code pénal',
      'L’article 131-40 du code pénal',
      'L’article 138 du code de procédure pénale',
    ],
    answer: 'L’article 131-10 du code pénal',
    explanation:
        'Le cours : peines complémentaires prévues à l’article 131-10 du C.P.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PERSONNES PHYSIQUES — PEINES CORRECTIONNELLES
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines correctionnelles)',
    question: 'Les peines correctionnelles sont énumérées à :',
    options: [
      'L’article 131-3 du code pénal',
      'L’article 131-12 du code pénal',
      'L’article 131-37 du code pénal',
    ],
    answer: 'L’article 131-3 du code pénal',
    explanation:
        'Le cours : les peines correctionnelles sont énumérées à l’article 131-3 du C.P.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines correctionnelles)',
    question: 'La peine principale correctionnelle peut être :',
    options: [
      'L’emprisonnement',
      'La réclusion criminelle',
      'La détention criminelle à perpétuité',
    ],
    answer: 'L’emprisonnement',
    explanation:
        'Le cours : en matière correctionnelle, la peine principale est notamment l’emprisonnement.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines correctionnelles)',
    question:
        'L’échelle de l’emprisonnement correctionnel comporte, selon le cours :',
    options: ['8 degrés', '3 degrés', '5 degrés'],
    answer: '8 degrés',
    explanation:
        'Le cours : l’emprisonnement comporte une échelle comprenant 8 degrés.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines correctionnelles)',
    question:
        'Parmi ces durées, laquelle figure dans l’échelle des 8 degrés de l’emprisonnement correctionnel ?',
    options: ['Au plus 7 ans', 'Au plus 25 ans', 'Au plus 12 ans'],
    answer: 'Au plus 7 ans',
    explanation:
        'Le cours cite : 10, 7, 5, 3, 2, 1 an, 6 mois, 2 mois (au plus).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines correctionnelles)',
    question: 'L’emprisonnement correctionnel peut faire l’objet :',
    options: [
      'D’un sursis, d’un sursis probatoire ou d’un aménagement',
      'Uniquement d’une remise gracieuse',
      'Uniquement d’une grâce présidentielle',
    ],
    answer: 'D’un sursis, d’un sursis probatoire ou d’un aménagement',
    explanation: 'Le cours précise ces possibilités.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines correctionnelles)',
    question: 'Le montant minimum de l’amende correctionnelle est :',
    options: ['3 750 €', '1 500 €', '38 €'],
    answer: '3 750 €',
    explanation: 'Le cours : amende dont le montant minimum est de 3 750 €.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PERSONNES PHYSIQUES — PEINES ALTERNATIVES (DÉLITS)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines alternatives)',
    question:
        'La détention à domicile sous surveillance électronique (DDSE) est prévue par :',
    options: [
      'L’article 131-4-1 du code pénal',
      'L’article 131-12 du code pénal',
      'L’article 131-40 du code pénal',
    ],
    answer: 'L’article 131-4-1 du code pénal',
    explanation: 'Le cours : DDSE (15 jours à 6 mois) — art. 131-4-1 C.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines alternatives)',
    question:
        'La DDSE (détention à domicile sous surveillance électronique) doit durer :',
    options: [
      'Entre 15 jours et 6 mois',
      'Entre 6 mois et 2 ans',
      'Toujours 1 an',
    ],
    answer: 'Entre 15 jours et 6 mois',
    explanation: 'Le cours : durée comprise entre 15 jours et 6 mois.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines alternatives)',
    question: 'La DDSE ne peut pas excéder :',
    options: [
      'L’emprisonnement encouru',
      'Le maximum de l’amende',
      'La durée de la contrainte pénale',
    ],
    answer: 'L’emprisonnement encouru',
    explanation:
        'Le cours : la DDSE s’exécute sans excéder l’emprisonnement encouru.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines alternatives)',
    question: 'La peine de jour-amende est prévue à :',
    options: [
      'L’article 131-5 du code pénal',
      'L’article 131-8 du code pénal',
      'L’article 131-15-1 du code pénal',
    ],
    answer: 'L’article 131-5 du code pénal',
    explanation:
        'Le cours : jour-amende à la place de l’amende si le délit est puni d’emprisonnement (art. 131-5 C.P.).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines alternatives)',
    question:
        'Les peines privatives ou restrictives de droits (délits) sont prévues à :',
    options: [
      'L’article 131-6 du code pénal',
      'L’article 131-37 du code pénal',
      'L’article 723-29 du code de procédure pénale',
    ],
    answer: 'L’article 131-6 du code pénal',
    explanation:
        'Le cours : peines privatives ou restrictives de droits prévues à l’art. 131-6 C.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines alternatives)',
    question: 'Le travail d’intérêt général (TIG) peut être prononcé :',
    options: [
      'À la place de l’emprisonnement',
      'Uniquement à la place de l’amende',
      'Uniquement en matière criminelle',
    ],
    answer: 'À la place de l’emprisonnement',
    explanation:
        'Le cours : TIG à la place de la peine d’emprisonnement (art. 131-8 C.P.).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines alternatives)',
    question: 'Le TIG peut durer, selon le cours :',
    options: [
      'De 20 à 400 heures',
      'De 1 à 10 heures',
      'De 500 à 1 000 heures',
    ],
    answer: 'De 20 à 400 heures',
    explanation: 'Le cours : TIG pour une durée de 20 à 400 heures.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines alternatives)',
    question:
        'Les peines alternatives (délits) figurent dans le texte réprimant l’infraction :',
    options: [
      'Oui, toujours',
      'Non, elles sont prévues par des dispositions générales',
      'Oui, uniquement pour les crimes',
    ],
    answer: 'Non, elles sont prévues par des dispositions générales',
    explanation:
        'Le cours : elles ne figurent pas dans le texte d’incrimination, elles sont prévues par des dispositions générales.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (peines alternatives)',
    question: 'Le juge peut décider de substituer des peines alternatives :',
    options: [
      'À une ou plusieurs peines principales',
      'Uniquement à la peine complémentaire',
      'Uniquement après la prescription',
    ],
    answer: 'À une ou plusieurs peines principales',
    explanation:
        'Le cours : le juge peut les substituer à une ou plusieurs peines principales.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PERSONNES PHYSIQUES — STAGE & SANCTION-RÉPARATION
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (stage / sanction-réparation)',
    question: 'La peine de stage est prévue à :',
    options: [
      'L’article 131-5-1 du code pénal',
      'L’article 131-15-1 du code pénal',
      'L’article 131-38 du code pénal',
    ],
    answer: 'L’article 131-5-1 du code pénal',
    explanation: 'Le cours : peine de stage (art. 131-5-1 C.P.).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (stage / sanction-réparation)',
    question: 'La peine de stage consiste principalement :',
    options: [
      'En l’obligation d’accomplir un stage dont la nature et le contenu sont précisés par la juridiction',
      'En une interdiction de séjour automatique',
      'En une confiscation obligatoire',
    ],
    answer:
        'En l’obligation d’accomplir un stage dont la nature et le contenu sont précisés par la juridiction',
    explanation:
        'Le cours définit la peine de stage : obligation d’accomplir un stage (≤ 1 mois) dont les modalités sont fixées par la juridiction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (stage / sanction-réparation)',
    question: 'La durée maximale d’un stage est :',
    options: ['Un mois', 'Six mois', 'Un an'],
    answer: 'Un mois',
    explanation: 'Le cours : durée ne pouvant excéder un mois.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (stage / sanction-réparation)',
    question: 'La peine de sanction-réparation est prévue à :',
    options: [
      'L’article 131-8-1 du code pénal',
      'L’article 131-8 du code pénal',
      'L’article 131-4-1 du code pénal',
    ],
    answer: 'L’article 131-8-1 du code pénal',
    explanation: 'Le cours : sanction-réparation (art. 131-8-1 C.P.).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (stage / sanction-réparation)',
    question: 'La sanction-réparation consiste :',
    options: [
      'À indemniser le préjudice de la victime dans les modalités fixées par la juridiction',
      'À remplacer toute peine par une simple admonestation',
      'À imposer une détention à domicile',
    ],
    answer:
        'À indemniser le préjudice de la victime dans les modalités fixées par la juridiction',
    explanation:
        'Le cours : obligation de procéder à l’indemnisation du préjudice de la victime dans le délai et selon les modalités fixées.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (stage / sanction-réparation)',
    question: 'Le stage et la sanction-réparation peuvent être prononcés :',
    options: [
      'Comme peine alternative et/ou comme peine complémentaire',
      'Uniquement comme peine principale en matière criminelle',
      'Uniquement en contravention de 1ère classe',
    ],
    answer: 'Comme peine alternative et/ou comme peine complémentaire',
    explanation:
        'Le cours : ces peines peuvent être alternatives (à la place) ou complémentaires (s’ajoutant à la peine prononcée).',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PERSONNES PHYSIQUES — PEINES CONTRAVENTIONNELLES
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (contraventions)',
    question: 'Les peines contraventionnelles sont prévues à :',
    options: [
      'L’article 131-12 du code pénal',
      'L’article 131-3 du code pénal',
      'L’article 131-37 du code pénal',
    ],
    answer: 'L’article 131-12 du code pénal',
    explanation:
        'Le cours : peines contraventionnelles prévues à l’article 131-12 C.P.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (contraventions)',
    question:
        'Constituent des contraventions les infractions punies d’une amende n’excédant pas :',
    options: ['3 000 €', '7 500 €', '1 000 000 €'],
    answer: '3 000 €',
    explanation: 'Le cours : art. 131-13 C.P. — amende n’excédant pas 3 000 €.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (contraventions)',
    question:
        'Le plafond de l’amende pour une contravention de 1ère classe est :',
    options: ['38 €', '150 €', '450 €'],
    answer: '38 €',
    explanation:
        'Le cours : 38 € au plus pour les contraventions de 1ère classe.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (contraventions)',
    question:
        'Le plafond de l’amende pour une contravention de 2ème classe est :',
    options: ['150 €', '750 €', '1 500 €'],
    answer: '150 €',
    explanation:
        'Le cours : 150 € au plus pour les contraventions de 2ème classe.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (contraventions)',
    question:
        'Le plafond de l’amende pour une contravention de 3ème classe est :',
    options: ['450 €', '38 €', '3 000 €'],
    answer: '450 €',
    explanation:
        'Le cours : 450 € au plus pour les contraventions de 3ème classe.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (contraventions)',
    question:
        'Le plafond de l’amende pour une contravention de 4ème classe est :',
    options: ['750 €', '1 500 €', '150 €'],
    answer: '750 €',
    explanation:
        'Le cours : 750 € au plus pour les contraventions de 4ème classe.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (contraventions)',
    question:
        'Le plafond de l’amende pour une contravention de 5ème classe est :',
    options: [
      '1 500 € (pouvant être porté à 3 000 € en cas de récidive)',
      '3 750 € minimum',
      '38 € maximum',
    ],
    answer: '1 500 € (pouvant être porté à 3 000 € en cas de récidive)',
    explanation:
        'Le cours : 1 500 € au plus pour la 5ème classe, porté à 3 000 € en cas de récidive.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (contraventions)',
    question:
        'Les peines alternatives en matière contraventionnelle (personnes physiques) sont prévues :',
    options: [
      'Uniquement pour les contraventions de 5ème classe',
      'Pour toutes les contraventions',
      'Uniquement pour les contraventions de 1ère classe',
    ],
    answer: 'Uniquement pour les contraventions de 5ème classe',
    explanation:
        'Le cours : peines alternatives uniquement pour la 5ème classe.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (contraventions)',
    question:
        'Les peines alternatives pour contraventions de 5ème classe consistent en :',
    options: [
      'Des peines privatives ou restrictives de droits',
      'La réclusion criminelle',
      'La détention criminelle',
    ],
    answer: 'Des peines privatives ou restrictives de droits',
    explanation:
        'Le cours : peines privatives ou restrictives de droits prévues à l’art. 131-14 C.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (contraventions)',
    question:
        'Les peines complémentaires contraventionnelles (personnes physiques) sont listées notamment aux :',
    options: [
      'Articles 131-16 et 131-17 du code pénal',
      'Articles 131-37 à 131-49 du code pénal',
      'Articles 131-1 à 131-3 du code pénal',
    ],
    answer: 'Articles 131-16 et 131-17 du code pénal',
    explanation:
        'Le cours : peines complémentaires listées aux art. 131-16 et 131-17 C.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (contraventions)',
    question:
        'Le juge peut prononcer les peines complémentaires contraventionnelles :',
    options: [
      'En plus de l’amende ou à la place de l’amende',
      'Uniquement en plus de l’amende',
      'Uniquement à la place d’un emprisonnement',
    ],
    answer: 'En plus de l’amende ou à la place de l’amende',
    explanation:
        'Le cours : le juge peut les prononcer soit en plus, soit à titre principal à la place de l’amende.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (contraventions)',
    question:
        'La sanction-réparation en contravention (personnes physiques) est prévue :',
    options: [
      'Uniquement pour les contraventions de 5ème classe',
      'Pour toutes les contraventions',
      'Uniquement pour la 1ère classe',
    ],
    answer: 'Uniquement pour les contraventions de 5ème classe',
    explanation:
        'Le cours : sanction-réparation uniquement pour la 5ème classe.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (contraventions)',
    question:
        'La sanction-réparation contraventionnelle (5ème classe) peut être prononcée :',
    options: [
      'À la place ou en même temps que l’amende',
      'Uniquement à la place de l’emprisonnement',
      'Uniquement en plus d’une réclusion',
    ],
    answer: 'À la place ou en même temps que l’amende',
    explanation:
        'Le cours : elle peut être prononcée à la place ou en même temps que l’amende.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes physiques (contraventions)',
    question: 'La sanction-réparation contraventionnelle est prévue à :',
    options: [
      'L’article 131-15-1 du code pénal',
      'L’article 131-8-1 du code pénal',
      'L’article 131-5-1 du code pénal',
    ],
    answer: 'L’article 131-15-1 du code pénal',
    explanation:
        'Le cours : sanction-réparation en 5ème classe (art. 131-15-1 C.P.).',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PERSONNES MORALES — PEINES (GÉNÉRAL)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Personnes morales (généralités)',
    question:
        'La répression applicable aux personnes morales figure aux articles :',
    options: [
      '131-37 à 131-49 du code pénal',
      '131-1 à 131-18 du code pénal',
      '122-1 à 122-7 du code pénal',
    ],
    answer: '131-37 à 131-49 du code pénal',
    explanation:
        'Le cours : la répression des personnes morales figure aux art. 131-37 à 131-49 C.P.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes morales (généralités)',
    question:
        'Les peines criminelles et correctionnelles encourues par les personnes morales figurent à :',
    options: [
      'L’article 131-37 du code pénal',
      'L’article 131-12 du code pénal',
      'L’article 131-3 du code pénal',
    ],
    answer: 'L’article 131-37 du code pénal',
    explanation: 'Le cours : elles figurent à l’article 131-37 C.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category:
        'La sanction — Personnes morales (peines criminelles/correctionnelles)',
    question:
        'En matière criminelle et correctionnelle, les personnes morales encourent notamment :',
    options: [
      'L’amende et, dans les cas prévus, des peines prévues par la loi',
      'Uniquement l’emprisonnement',
      'Uniquement le TIG',
    ],
    answer: 'L’amende et, dans les cas prévus, des peines prévues par la loi',
    explanation:
        'Le cours : amende + (si la loi le prévoit) peines de l’art. 131-39 et 131-39-2, et en correctionnel la sanction-réparation (131-39-1).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category:
        'La sanction — Personnes morales (peines criminelles/correctionnelles)',
    question:
        'En matière correctionnelle, la personne morale peut encourir aussi :',
    options: [
      'La sanction-réparation',
      'La réclusion criminelle',
      'La détention criminelle',
    ],
    answer: 'La sanction-réparation',
    explanation:
        'Le cours : en matière correctionnelle, la personne morale encourt la sanction-réparation prévue à l’art. 131-39-1 C.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes morales (amende)',
    question: 'Le taux maximum de l’amende des personnes morales est :',
    options: [
      'Égal au quintuple de celui prévu pour les personnes physiques',
      'Égal au double de celui prévu pour les personnes physiques',
      'Identique à celui prévu pour les personnes physiques',
    ],
    answer: 'Égal au quintuple de celui prévu pour les personnes physiques',
    explanation:
        'Le cours : art. 131-38 C.P. — maximum = quintuple du maximum prévu pour les personnes physiques.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes morales (amende)',
    question:
        'Pour déterminer le maximum d’amende encouru par une personne morale, il faut :',
    options: [
      'Multiplier par 5 le maximum prévu pour la personne physique',
      'Diviser par 5 le maximum prévu pour la personne physique',
      'Ajouter 3 750 € au maximum prévu pour la personne physique',
    ],
    answer: 'Multiplier par 5 le maximum prévu pour la personne physique',
    explanation:
        'Le cours : on multiplie par cinq le maximum prévu pour la personne physique.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes morales (amende)',
    question:
        'Si un crime ne prévoit aucune amende pour les personnes physiques, l’amende encourue par la personne morale est :',
    options: ['1 000 000 €', '3 000 €', '75 000 €'],
    answer: '1 000 000 €',
    explanation:
        'Le cours : en présence d’un crime sans amende pour les personnes physiques, amende pour la personne morale = 1 000 000 €.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes morales (contraventions)',
    question:
        'Les peines contraventionnelles encourues par les personnes morales sont énoncées à :',
    options: [
      'L’article 131-40 du code pénal',
      'L’article 131-10 du code pénal',
      'L’article 131-1 du code pénal',
    ],
    answer: 'L’article 131-40 du code pénal',
    explanation:
        'Le cours : peines contraventionnelles des personnes morales — art. 131-40 C.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes morales (contraventions)',
    question:
        'Pour les contraventions de 5ème classe, les personnes morales peuvent encourir :',
    options: [
      'Des peines privatives ou restrictives de droits + sanction-réparation',
      'La réclusion criminelle',
      'La détention criminelle',
    ],
    answer:
        'Des peines privatives ou restrictives de droits + sanction-réparation',
    explanation:
        'Le cours : art. 131-42 (droits) + art. 131-44-1 (sanction-réparation).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes morales (contraventions)',
    question:
        'Les peines complémentaires des personnes morales en matière contraventionnelle figurent à :',
    options: [
      'L’article 131-43 du code pénal',
      'L’article 131-14 du code pénal',
      'L’article 131-15-1 du code pénal',
    ],
    answer: 'L’article 131-43 du code pénal',
    explanation:
        'Le cours : peines complémentaires des personnes morales (contraventions) — art. 131-43 C.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Personnes morales (contraventions)',
    question:
        'Les peines complémentaires des personnes morales peuvent être prononcées :',
    options: [
      'En complément d’une peine principale ou seules à titre de peine principale',
      'Uniquement en complément d’une peine principale',
      'Uniquement en matière criminelle',
    ],
    answer:
        'En complément d’une peine principale ou seules à titre de peine principale',
    explanation:
        'Le cours : elles peuvent être prises en complément mais aussi seules à titre de peine principale.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // CLASSIFICATION DES MESURES DE SÛRETÉ — GÉNÉRALITÉS
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (généralités)',
    question: 'Le but principal d’une mesure de sûreté est :',
    options: [
      'Préventif : éviter la survenance d’infractions',
      'Répressif : punir plus sévèrement l’auteur',
      'Civile : indemniser la victime',
    ],
    answer: 'Préventif : éviter la survenance d’infractions',
    explanation:
        'Le cours : but préventif en neutralisant, surveillant ou traitant les individus dangereux.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (généralités)',
    question: 'Les mesures de sûreté visent notamment à :',
    options: [
      'Neutraliser, surveiller ou traiter des individus susceptibles d’être dangereux',
      'Annuler automatiquement la peine prononcée',
      'Remplacer toute sanction pénale',
    ],
    answer:
        'Neutraliser, surveiller ou traiter des individus susceptibles d’être dangereux',
    explanation: 'Le cours : neutralisation / surveillance / traitement.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (généralités)',
    question:
        'Les mesures de sûreté font l’objet d’un titre unique et complet dans le code pénal :',
    options: [
      'Oui',
      'Non, elles sont éparses',
      'Oui, uniquement pour les mineurs',
    ],
    answer: 'Non, elles sont éparses',
    explanation:
        'Le cours : pas de titre dédié, dispositions éparses, inventaire difficile.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // MESURES DE SÛRETÉ CURATIVES
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (curatives)',
    question: 'Les mesures de sûreté curatives concernent essentiellement :',
    options: [
      'Les alcooliques et toxicomanes',
      'Les auteurs de contraventions de stationnement',
      'Les victimes uniquement',
    ],
    answer: 'Les alcooliques et toxicomanes',
    explanation: 'Le cours : mesures curatives = alcooliques et toxicomanes.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (curatives)',
    question:
        'Dans le cadre du contrôle judiciaire, l’obligation de se soumettre à des soins est prévue par :',
    options: [
      'L’article 138 10° du code de procédure pénale',
      'L’article 131-10 du code pénal',
      'L’article 131-37 du code pénal',
    ],
    answer: 'L’article 138 10° du code de procédure pénale',
    explanation:
        'Le cours : seul l’art. 138 10° C.P.P. prévoit cette obligation (traitement/soins, désintoxication).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (curatives)',
    question:
        'L’obligation de soins dans le contrôle judiciaire vise notamment :',
    options: [
      'La désintoxication',
      'Le paiement de dommages-intérêts',
      'La confiscation des biens',
    ],
    answer: 'La désintoxication',
    explanation:
        'Le cours : mesures de traitement/soins, notamment aux fins de désintoxication.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (curatives)',
    question:
        'Le législateur a mis en place un système donnant la priorité aux :',
    options: [
      'Mesures thérapeutiques sur les sanctions pénales',
      'Sanctions pénales sur les soins',
      'Sanctions civiles sur les sanctions pénales',
    ],
    answer: 'Mesures thérapeutiques sur les sanctions pénales',
    explanation:
        'Le cours : priorité aux mesures thérapeutiques ; injonction thérapeutique prévue.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // MESURES DE SURVEILLANCE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (surveillance)',
    question: 'Le suivi socio-judiciaire est prévu aux articles :',
    options: [
      '131-36-1 à 131-36-8 du code pénal',
      '131-1 à 131-3 du code pénal',
      '138 du code de procédure pénale',
    ],
    answer: '131-36-1 à 131-36-8 du code pénal',
    explanation:
        'Le cours : suivi socio-judiciaire — art. 131-36-1 à 131-36-8 C.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (surveillance)',
    question: 'Le suivi socio-judiciaire oblige le condamné à se soumettre :',
    options: [
      'À des mesures de surveillance et d’assistance sous contrôle du JAP',
      'À une réclusion automatique',
      'À une amende minimum de 3 750 €',
    ],
    answer:
        'À des mesures de surveillance et d’assistance sous contrôle du JAP',
    explanation:
        'Le cours : sous le contrôle du juge de l’application des peines, surveillance et assistance pendant une durée fixée.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (surveillance)',
    question: 'Le suivi socio-judiciaire concerne notamment des infractions :',
    options: [
      'De nature sexuelle ou des violences',
      'Uniquement des contraventions routières',
      'Uniquement des délits de presse',
    ],
    answer: 'De nature sexuelle ou des violences',
    explanation: 'Le cours : infractions de nature sexuelle ou des violences.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (surveillance)',
    question: 'Le suivi socio-judiciaire peut être assorti :',
    options: [
      'D’une injonction de soins si bénéfique',
      'D’une dissolution de personne morale',
      'D’une amnistie automatique',
    ],
    answer: 'D’une injonction de soins si bénéfique',
    explanation:
        'Le cours : injonction de soins possible si bénéfique au condamné.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (surveillance)',
    question:
        'Le suivi socio-judiciaire peut être assorti d’un placement sous surveillance électronique mobile :',
    options: [
      'Oui, décidé par la juridiction de jugement ou ultérieurement par le JAP',
      'Non, jamais',
      'Oui, uniquement pour les contraventions',
    ],
    answer:
        'Oui, décidé par la juridiction de jugement ou ultérieurement par le JAP',
    explanation:
        'Le cours : PSEM mobile possible, décidé par la juridiction ou ultérieurement par le JAP.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (surveillance)',
    question:
        'La surveillance judiciaire des personnes dangereuses est prévue à :',
    options: [
      'L’article 723-29 du code de procédure pénale',
      'L’article 131-10 du code pénal',
      'L’article 131-15-1 du code pénal',
    ],
    answer: 'L’article 723-29 du code de procédure pénale',
    explanation: 'Le cours : surveillance judiciaire — art. 723-29 C.P.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (surveillance)',
    question:
        'La surveillance judiciaire des personnes dangereuses a pour finalité :',
    options: [
      'Prévenir la récidive dont le risque paraît avéré',
      'Punir plus sévèrement que la peine maximale',
      'Transformer un délit en crime',
    ],
    answer: 'Prévenir la récidive dont le risque paraît avéré',
    explanation:
        'Le cours : uniquement envisageable aux fins de prévenir la récidive au risque avéré.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (surveillance)',
    question:
        'La surveillance judiciaire peut viser les auteurs condamnés à une peine privative de liberté d’une durée :',
    options: [
      'Égale ou supérieure à 7 ans (si SSJ encouru mais non prononcé)',
      'Uniquement inférieure à 1 an',
      'Uniquement égale à 2 mois',
    ],
    answer: 'Égale ou supérieure à 7 ans (si SSJ encouru mais non prononcé)',
    explanation:
        'Le cours : >=7 ans si le suivi socio-judiciaire était encouru mais n’a pas été prononcé.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (surveillance)',
    question:
        'La surveillance judiciaire peut aussi viser une peine privative de liberté :',
    options: [
      'Égale ou supérieure à 5 ans pour crime/délit commis à nouveau en récidive légale',
      'Égale ou supérieure à 15 ans pour toute contravention',
      'Égale ou supérieure à 3 mois pour tout délit',
    ],
    answer:
        'Égale ou supérieure à 5 ans pour crime/délit commis à nouveau en récidive légale',
    explanation:
        'Le cours : >=5 ans si crime/délit commis une nouvelle fois en état de récidive légale.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (surveillance)',
    question: 'Dans son contenu, la surveillance judiciaire ressemble :',
    options: [
      'Au suivi socio-judiciaire',
      'À une amnistie',
      'À une dissolution',
    ],
    answer: 'Au suivi socio-judiciaire',
    explanation: 'Le cours le précise expressément.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // MESURES PORTANT ATTEINTE À LA LIBERTÉ — MINEURS
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (liberté / mineurs)',
    question: 'En matière de mineurs, le principe fondamental affirmé est :',
    options: [
      'La primauté de la réponse éducative sur la réponse répressive',
      'La primauté de la réclusion criminelle',
      'La suppression des mesures éducatives',
    ],
    answer: 'La primauté de la réponse éducative sur la réponse répressive',
    explanation: 'Le cours : le CJPM érige ce principe en fondamental.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (liberté / mineurs)',
    question:
        'La mesure éducative judiciaire provisoire (M.E.J.P.) est prévue aux articles :',
    options: [
      'L323-1 à L323-3 du C.J.P.M.',
      '131-36-1 à 131-36-8 du C.P.',
      '723-29 du C.P.P.',
    ],
    answer: 'L323-1 à L323-3 du C.J.P.M.',
    explanation: 'Le cours : MEJP — art. L323-1 à L323-3 CJPM.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (liberté / mineurs)',
    question: 'La M.E.J.P. peut être prise :',
    options: [
      'À tout moment au cours de la procédure, avant le prononcé de la sanction',
      'Uniquement après condamnation définitive',
      'Uniquement en cas de contravention',
    ],
    answer:
        'À tout moment au cours de la procédure, avant le prononcé de la sanction',
    explanation:
        'Le cours : elle peut être prise à tout moment avant la sanction.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (liberté / mineurs)',
    question: 'La durée de la M.E.J.P. est :',
    options: [
      'Un an renouvelable',
      'Six mois non renouvelable',
      'Trois ans renouvelable',
    ],
    answer: 'Un an renouvelable',
    explanation: 'Le cours : durée d’un an renouvelable (art. L432-2 CJPM).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (liberté / mineurs)',
    question: 'La M.E.J.P. est modulable :',
    options: [
      'Oui, selon les besoins et l’évolution du mineur',
      'Non, elle est fixe et identique pour tous',
      'Uniquement si le mineur est majeur',
    ],
    answer: 'Oui, selon les besoins et l’évolution du mineur',
    explanation: 'Le cours : modulable selon besoins/évolution.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (liberté / mineurs)',
    question: 'La M.E.J.P. peut s’accompagner d’une M.J.I.E., qui est :',
    options: [
      'Une évaluation approfondie et interdisciplinaire de la personnalité et de la situation du mineur',
      'Une peine d’emprisonnement automatique',
      'Une amende forfaitaire',
    ],
    answer:
        'Une évaluation approfondie et interdisciplinaire de la personnalité et de la situation du mineur',
    explanation:
        'Le cours : MJIE = évaluation approfondie (éducation, santé, scolarité, famille…).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (liberté / mineurs)',
    question:
        'Avant jugement, un mineur peut, sous conditions, faire l’objet :',
    options: [
      'D’une assignation à résidence avec surveillance électronique ou d’une détention provisoire',
      'D’une réclusion criminelle à perpétuité',
      'D’une dissolution',
    ],
    answer:
        'D’une assignation à résidence avec surveillance électronique ou d’une détention provisoire',
    explanation:
        'Le cours : possibilité d’ARSE ou placement en détention provisoire sous conditions.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (liberté / mineurs)',
    question: 'La loi du 25 février 2008 :',
    options: [
      'N’exclut pas les mineurs du dispositif de protection contre les criminels dangereux',
      'Exclut systématiquement les mineurs',
      'Supprime la surveillance de sûreté',
    ],
    answer:
        'N’exclut pas les mineurs du dispositif de protection contre les criminels dangereux',
    explanation: 'Le cours : elle n’exclut pas les mineurs.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // MESURES PORTANT ATTEINTE À LA LIBERTÉ — MAJEURS
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (liberté / majeurs)',
    question: 'L’interdiction de séjour :',
    options: [
      'Interdit de paraître dans certains lieux, avec surveillance/assistance',
      'Oblige à accomplir un TIG',
      'Est une amende automatique',
    ],
    answer:
        'Interdit de paraître dans certains lieux, avec surveillance/assistance',
    explanation:
        'Le cours : interdiction de séjour = défense de paraître + surveillance/assistance (art. 131-31 C.P.).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (liberté / majeurs)',
    question: 'L’interdiction de séjour est prévue à :',
    options: [
      'L’article 131-31 du code pénal',
      'L’article 131-32-1 du code pénal',
      'L’article 723-29 du code de procédure pénale',
    ],
    answer: 'L’article 131-31 du code pénal',
    explanation: 'Le cours : interdiction de séjour — art. 131-31 C.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (liberté / majeurs)',
    question: 'L’interdiction de manifester :',
    options: [
      'Interdit de manifester sur la voie publique dans certains lieux',
      'Interdit de conduire certains véhicules uniquement',
      'Oblige à une hospitalisation complète',
    ],
    answer: 'Interdit de manifester sur la voie publique dans certains lieux',
    explanation:
        'Le cours : défense de manifester sur la voie publique dans certains lieux (art. 131-32-1 C.P.).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (liberté / majeurs)',
    question:
        'La durée maximale de l’interdiction de manifester (selon le cours) est :',
    options: ['3 ans', '5 ans', '10 ans'],
    answer: '3 ans',
    explanation: 'Le cours : durée ne pouvant excéder trois ans.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (liberté / majeurs)',
    question: 'L’interdiction de manifester est prévue à :',
    options: [
      'L’article 131-32-1 du code pénal',
      'L’article 131-31 du code pénal',
      'L’article 131-6 du code pénal',
    ],
    answer: 'L’article 131-32-1 du code pénal',
    explanation: 'Le cours : art. 131-32-1 C.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (étrangers)',
    question:
        'Parmi ces mesures, laquelle concerne explicitement les étrangers (selon le cours) ?',
    options: ['L’interdiction du territoire', 'Le TIG', 'Le jour-amende'],
    answer: 'L’interdiction du territoire',
    explanation:
        'Le cours : mesures concernant les étrangers : interdiction du territoire, expulsion, assignation à résidence, OQTF, rétention administrative…',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (étrangers)',
    question: 'Parmi les mesures concernant les étrangers, on trouve :',
    options: [
      'L’expulsion',
      'La réclusion criminelle',
      'La détention criminelle',
    ],
    answer: 'L’expulsion',
    explanation:
        'Le cours cite l’expulsion parmi les mesures concernant les étrangers.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (étrangers)',
    question: 'L’obligation de quitter le territoire (OQTF) est :',
    options: [
      'Une mesure concernant les étrangers',
      'Une peine criminelle principale',
      'Une peine alternative de délit',
    ],
    answer: 'Une mesure concernant les étrangers',
    explanation:
        'Le cours : OQTF est listée dans les mesures concernant les étrangers.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // MESURES DE SÛRETÉ — STAGES / INTERDICTIONS / RESTRICTIONS
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (stages)',
    question: 'L’obligation d’accomplir un stage est prévue à :',
    options: [
      'L’article 131-5-1 du code pénal',
      'L’article 131-8-1 du code pénal',
      'L’article 131-15-1 du code pénal',
    ],
    answer: 'L’article 131-5-1 du code pénal',
    explanation:
        'Le cours : obligation d’accomplir un stage (art. 131-5-1 C.P.).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (stages)',
    question: 'Le but du stage (art. 131-5-1 C.P.) est :',
    options: [
      'Prévenir la réitération de comportements dangereux ou inciviques',
      'Augmenter automatiquement la peine d’emprisonnement',
      'Remplacer la contravention par un crime',
    ],
    answer: 'Prévenir la réitération de comportements dangereux ou inciviques',
    explanation: 'Le cours : prévention de la réitération.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (stages)',
    question: 'Parmi ces stages, lequel figure dans la liste du cours ?',
    options: [
      'Stage de citoyenneté',
      'Stage de conduite moto obligatoire',
      'Stage de langue étrangère',
    ],
    answer: 'Stage de citoyenneté',
    explanation:
        'Le cours : stage de citoyenneté fait partie des stages possibles.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (stages)',
    question: 'Parmi ces stages, lequel figure dans la liste du cours ?',
    options: [
      'Stage de sensibilisation à la sécurité routière',
      'Stage de pêche maritime',
      'Stage de secourisme obligatoire',
    ],
    answer: 'Stage de sensibilisation à la sécurité routière',
    explanation: 'Le cours le cite expressément.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (stages)',
    question: 'Parmi ces stages, lequel figure dans la liste du cours ?',
    options: [
      'Stage de sensibilisation aux dangers de l’usage de produits stupéfiants',
      'Stage de gestion financière',
      'Stage d’arts martiaux',
    ],
    answer:
        'Stage de sensibilisation aux dangers de l’usage de produits stupéfiants',
    explanation: 'Le cours le cite expressément.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (stages)',
    question: 'Parmi ces stages, lequel figure dans la liste du cours ?',
    options: [
      'Stage de responsabilisation pour la prévention et la lutte contre les violences au sein du couple et sexistes',
      'Stage de communication institutionnelle',
      'Stage de tourisme',
    ],
    answer:
        'Stage de responsabilisation pour la prévention et la lutte contre les violences au sein du couple et sexistes',
    explanation: 'Le cours le cite dans la liste.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (stages)',
    question: 'Parmi ces stages, lequel figure dans la liste du cours ?',
    options: [
      'Stage de sensibilisation à la lutte contre l’achat d’actes sexuels',
      'Stage de cuisine',
      'Stage de management',
    ],
    answer:
        'Stage de sensibilisation à la lutte contre l’achat d’actes sexuels',
    explanation: 'Le cours le cite dans la liste.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (stages)',
    question: 'Parmi ces stages, lequel figure dans la liste du cours ?',
    options: [
      'Stage de responsabilité parentale',
      'Stage de lecture rapide',
      'Stage de sport collectif',
    ],
    answer: 'Stage de responsabilité parentale',
    explanation: 'Le cours : stage de responsabilité parentale.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (stages)',
    question: 'Parmi ces stages, lequel figure dans la liste du cours ?',
    options: [
      'Stage de lutte contre le sexisme et de sensibilisation à l’égalité entre les femmes et les hommes',
      'Stage de bricolage',
      'Stage de commerce',
    ],
    answer:
        'Stage de lutte contre le sexisme et de sensibilisation à l’égalité entre les femmes et les hommes',
    explanation: 'Le cours le cite expressément.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (stages)',
    question: 'Parmi ces stages, lequel figure dans la liste du cours ?',
    options: [
      'Stage de sensibilisation à la prévention et à la lutte contre la maltraitance animale',
      'Stage de jardinage',
      'Stage de langue',
    ],
    answer:
        'Stage de sensibilisation à la prévention et à la lutte contre la maltraitance animale',
    explanation: 'Le cours le cite expressément.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (stages)',
    question: 'Parmi ces stages, lequel figure dans la liste du cours ?',
    options: [
      'Stage de sensibilisation au respect des personnes dans l’espace numérique et à la prévention des infractions en ligne (dont cyberharcèlement)',
      'Stage de prise de parole en public',
      'Stage de secourisme',
    ],
    answer:
        'Stage de sensibilisation au respect des personnes dans l’espace numérique et à la prévention des infractions en ligne (dont cyberharcèlement)',
    explanation: 'Le cours mentionne ce stage explicitement.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // MESURES DE SÛRETÉ — INTERDICTIONS & RESTRICTIONS (ART. 131-6 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (interdictions / restrictions)',
    question: 'Les interdictions et restrictions sont prévues à :',
    options: [
      'L’article 131-6 du code pénal',
      'L’article 131-5 du code pénal',
      'L’article 131-12 du code pénal',
    ],
    answer: 'L’article 131-6 du code pénal',
    explanation: 'Le cours : interdictions et restrictions — art. 131-6 C.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (interdictions / restrictions)',
    question:
        'Parmi ces mesures, laquelle figure dans la liste associée à l’art. 131-6 C.P. ?',
    options: [
      'Suspension ou annulation du permis de conduire',
      'Réclusion criminelle',
      'Détention criminelle',
    ],
    answer: 'Suspension ou annulation du permis de conduire',
    explanation:
        'Le cours : suspension/annulation du permis de conduire est listée.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (interdictions / restrictions)',
    question:
        'Parmi ces mesures, laquelle figure dans la liste associée à l’art. 131-6 C.P. ?',
    options: [
      'Interdiction de conduire certains véhicules',
      'Amende minimum 3 750 €',
      'Jour-amende',
    ],
    answer: 'Interdiction de conduire certains véhicules',
    explanation: 'Le cours le cite explicitement.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (interdictions / restrictions)',
    question:
        'Parmi ces mesures, laquelle figure dans la liste associée à l’art. 131-6 C.P. ?',
    options: [
      'Confiscation ou immobilisation de véhicules',
      'Placement sous surveillance électronique mobile (PSEM) automatiquement',
      'Dissolution',
    ],
    answer: 'Confiscation ou immobilisation de véhicules',
    explanation: 'Le cours : confiscation/immobilisation de véhicules.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (interdictions / restrictions)',
    question:
        'Parmi ces mesures, laquelle figure dans la liste associée à l’art. 131-6 C.P. ?',
    options: [
      'Confiscation ou interdiction de port/détention d’armes',
      'Réclusion criminelle de 30 ans',
      'Emprisonnement de 10 ans',
    ],
    answer: 'Confiscation ou interdiction de port/détention d’armes',
    explanation: 'Le cours cite cette interdiction/confiscation.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (interdictions / restrictions)',
    question:
        'Parmi ces mesures, laquelle figure dans la liste associée à l’art. 131-6 C.P. ?',
    options: ['Retrait du permis de chasser', 'Stage de citoyenneté', 'DDSE'],
    answer: 'Retrait du permis de chasser',
    explanation: 'Le cours : retrait du permis de chasser est listé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (interdictions / restrictions)',
    question:
        'Parmi ces mesures, laquelle figure dans la liste associée à l’art. 131-6 C.P. ?',
    options: [
      'Interdiction de paraître en certains lieux',
      'Réclusion à perpétuité',
      'Amende maximale 3 000 €',
    ],
    answer: 'Interdiction de paraître en certains lieux',
    explanation: 'Le cours cite cette interdiction parmi les restrictions.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (interdictions / restrictions)',
    question:
        'Parmi ces mesures, laquelle figure dans la liste associée à l’art. 131-6 C.P. ?',
    options: [
      'Interdiction de fréquenter ou d’entrer en relation avec certaines personnes',
      'Exclusion des marchés publics',
      'Dissolution',
    ],
    answer:
        'Interdiction de fréquenter ou d’entrer en relation avec certaines personnes',
    explanation: 'Le cours cite cette interdiction.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // HOSPITALISATION COMPLÈTE (TROUBLE MENTAL)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (trouble mental)',
    question:
        'Après une décision d’irresponsabilité pénale pour cause de trouble mental, une juridiction peut prononcer :',
    options: [
      'Une admission en soins psychiatriques sous forme d’hospitalisation complète',
      'Une réclusion criminelle automatique',
      'Une amnistie automatique',
    ],
    answer:
        'Une admission en soins psychiatriques sous forme d’hospitalisation complète',
    explanation:
        'Le cours : hospitalisation complète possible par ordonnance motivée.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (trouble mental)',
    question:
        'L’hospitalisation complète en soins psychiatriques (dans ce cadre) est prévue à :',
    options: [
      'L’article 706-135 du code de procédure pénale',
      'L’article 723-29 du code de procédure pénale',
      'L’article 131-40 du code pénal',
    ],
    answer: 'L’article 706-135 du code de procédure pénale',
    explanation:
        'Le cours : art. 706-135 C.P.P. (admission en soins psychiatriques en hospitalisation complète).',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // RÉTENTION & SURVEILLANCE DE SÛRETÉ
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (rétention / surveillance)',
    question:
        'La rétention et la surveillance de sûreté sont prévues aux articles :',
    options: [
      '706-53-13 à 706-53-22 du code de procédure pénale',
      '131-36-1 à 131-36-8 du code pénal',
      '131-16 à 131-17 du code pénal',
    ],
    answer: '706-53-13 à 706-53-22 du code de procédure pénale',
    explanation:
        'Le cours : rétention/surveillance de sûreté — art. 706-53-13 à 706-53-22 C.P.P.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (rétention / surveillance)',
    question: 'La rétention consiste :',
    options: [
      'En un placement dans un centre socio-médico-judiciaire de sûreté où des soins sont proposés',
      'En une amende forfaitaire',
      'En un TIG obligatoire',
    ],
    answer:
        'En un placement dans un centre socio-médico-judiciaire de sûreté où des soins sont proposés',
    explanation: 'Le cours définit la rétention de sûreté ainsi.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (rétention / surveillance)',
    question:
        'La rétention de sûreté s’applique seulement si la peine prononcée est :',
    options: [
      'Égale ou supérieure à 15 ans de réclusion criminelle',
      'Inférieure à 2 ans',
      'Toujours une contravention',
    ],
    answer: 'Égale ou supérieure à 15 ans de réclusion criminelle',
    explanation: 'Le cours : condition n°1 = peine >= 15 ans.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (rétention / surveillance)',
    question: 'Une condition de la rétention de sûreté est que :',
    options: [
      'La condamnation porte sur des crimes précis',
      'La personne est mineure',
      'La victime est étrangère',
    ],
    answer: 'La condamnation porte sur des crimes précis',
    explanation: 'Le cours : condition n°2 = crimes précis.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (rétention / surveillance)',
    question:
        'Une condition de la rétention de sûreté est que le condamné présente :',
    options: [
      'Une dangerosité caractérisée par une probabilité très élevée de récidive',
      'Une absence totale de discernement',
      'Un simple risque hypothétique',
    ],
    answer:
        'Une dangerosité caractérisée par une probabilité très élevée de récidive',
    explanation:
        'Le cours : condition n°3 = dangerosité + probabilité très élevée de récidive.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (rétention / surveillance)',
    question:
        'À l’issue de la rétention de sûreté, la personne peut faire l’objet :',
    options: [
      'D’une surveillance de sûreté renouvelable',
      'D’une amnistie automatique',
      'D’une dissolution',
    ],
    answer: 'D’une surveillance de sûreté renouvelable',
    explanation:
        'Le cours : surveillance de sûreté possible après la rétention.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (rétention / surveillance)',
    question: 'La surveillance de sûreté peut être renouvelée pour une durée :',
    options: ['De deux ans', 'De cinq ans', 'D’un mois'],
    answer: 'De deux ans',
    explanation: 'Le cours : durée renouvelable de deux ans.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PLACEMENT SOUS SURVEILLANCE ÉLECTRONIQUE (763-10 à 763-14 C.P.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (surveillance électronique)',
    question:
        'Le placement sous surveillance électronique (bracelet GPS) est prévu aux articles :',
    options: [
      '763-10 à 763-14 du code de procédure pénale',
      '131-4-1 du code pénal',
      '131-14 du code pénal',
    ],
    answer: '763-10 à 763-14 du code de procédure pénale',
    explanation:
        'Le cours : placement sous surveillance électronique — art. 763-10 à 763-14 C.P.P.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (surveillance électronique)',
    question: 'Le but du bracelet GPS après libération est principalement :',
    options: [
      'Renforcer la prévention de la récidive des infractions les plus graves',
      'Remplacer l’amende minimum',
      'Transformer la peine en contravention',
    ],
    answer:
        'Renforcer la prévention de la récidive des infractions les plus graves',
    explanation:
        'Le cours : renforcer la prévention de la récidive des infractions les plus graves.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (surveillance électronique)',
    question: 'Le bracelet GPS permet notamment :',
    options: [
      'De connaître les déplacements et la localisation du condamné',
      'D’effacer la condamnation',
      'D’annuler la procédure',
    ],
    answer: 'De connaître les déplacements et la localisation du condamné',
    explanation: 'Le cours : connaître déplacements/localisation.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'La sanction — Mesures de sûreté (surveillance électronique)',
    question: 'Le placement sous surveillance électronique peut être :',
    options: [
      'Une obligation du suivi socio-judiciaire ou être prononcé dans la libération conditionnelle',
      'Uniquement une peine criminelle',
      'Uniquement une contravention',
    ],
    answer:
        'Une obligation du suivi socio-judiciaire ou être prononcé dans la libération conditionnelle',
    explanation:
        'Le cours : nouvelle obligation du SSJ, peut aussi être prononcé en libération conditionnelle ou dans la surveillance des personnes dangereuses.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ivre ou sous l’emprise de stupéfiants',
    question:
        'La circonstance aggravante “par une personne agissant en état d’ivresse manifeste ou sous l’emprise manifeste de produits stupéfiants” est :',
    options: [
      'Une circonstance aggravante personnelle',
      'Une circonstance aggravante réelle',
      'Une cause légale d’exemption de peine',
    ],
    answer: 'Une circonstance aggravante réelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante réelle dont les effets s’étendent à tous les auteurs, coauteurs et complices.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LA PRÉMÉDITATION (art. 132-72 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation est définie comme :',
    options: [
      'Le fait d’agir sous le coup d’une pulsion',
      'Le dessein formé avant l’action de commettre un crime ou un délit déterminé',
      'Le fait d’agir en groupe, sans préparation',
    ],
    answer:
        'Le dessein formé avant l’action de commettre un crime ou un délit déterminé',
    explanation:
        'Le cours reprend la définition légale : la préméditation est un dessein formé avant l’action.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation est définie par :',
    options: [
      'L’article 132-72 du code pénal',
      'L’article 132-80 du code pénal',
      'L’article 132-75 du code pénal',
    ],
    answer: 'L’article 132-72 du code pénal',
    explanation:
        'Le cours indique que l’article 132-72 du code pénal définit la préméditation.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Selon le cours, la préméditation traduit principalement :',
    options: [
      'Une volonté mûre et réfléchie d’atteindre un but fixé',
      'Une réaction immédiate et spontanée',
      'Une absence de résolution d’agir',
    ],
    answer: 'Une volonté mûre et réfléchie d’atteindre un but fixé',
    explanation:
        'Le cours parle d’une résolution d’agir marquant une volonté mûre et réfléchie.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question:
        'Pour matérialiser la préméditation, il faut notamment une antériorité de la résolution :',
    options: [
      'Après l’acte',
      'Avant l’acte',
      'Uniquement au moment du jugement',
    ],
    answer: 'Avant l’acte',
    explanation:
        'Le cours précise que l’antériorité à l’acte est nécessaire pour matérialiser la préméditation (Cass. crim., 9 janv. 1990).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'L’intervalle de temps lié à la préméditation se situe entre :',
    options: [
      'La plainte et le jugement',
      'La résolution de commettre l’acte et son exécution',
      'La commission des faits et l’enquête',
    ],
    answer: 'La résolution de commettre l’acte et son exécution',
    explanation:
        'Le cours situe l’intervalle entre la décision de commettre l’acte et son exécution.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Un acte prémédité est un acte :',
    options: [
      'Spontané, pouvant faire suite à une pulsion',
      'Médité et préparé, donc non spontané',
      'Imprévisible et sans plan',
    ],
    answer: 'Médité et préparé, donc non spontané',
    explanation:
        'Le cours indique que l’acte prémédité est médité et préparé et ne peut pas faire suite à une pulsion.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Selon le cours, la préméditation vise indifféremment :',
    options: [
      'Uniquement les crimes consommés',
      'Une infraction commise ou tentée',
      'Uniquement les délits',
    ],
    answer: 'Une infraction commise ou tentée',
    explanation:
        'Le cours précise que cette circonstance vise indifféremment une infraction commise ou tentée.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question:
        'D’après la jurisprudence citée, la préméditation doit être recherchée :',
    options: [
      'Uniquement dans les aveux de l’auteur',
      'Dans les faits qui ont accompagné l’acte de l’auteur principal',
      'Uniquement dans le passé judiciaire de l’auteur',
    ],
    answer: 'Dans les faits qui ont accompagné l’acte de l’auteur principal',
    explanation:
        'Le cours cite : “Elle doit être recherchée dans les faits qui ont accompagné l’acte de l’auteur principal” (Cass. crim., 4 sept. 1976).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question:
        'Parmi les éléments suivants, lequel peut illustrer la préméditation selon le cours ?',
    options: [
      'Des actes préparatoires ou des menaces avant les faits',
      'Une simple émotion ressentie après les faits',
      'Une erreur de procédure',
    ],
    answer: 'Des actes préparatoires ou des menaces avant les faits',
    explanation:
        'Le cours donne des exemples : actes préparatoires, menaces, confidences, nature complexe de l’acte, etc.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question:
        'Dans le champ d’application, le meurtre commis avec préméditation est qualifié :',
    options: [
      'D’homicide involontaire',
      'D’assassinat',
      'De violences volontaires simples',
    ],
    answer: 'D’assassinat',
    explanation:
        'Le cours précise que le meurtre avec préméditation (art. 221-3 al. 1 C.P.) est qualifié d’assassinat.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE CONJOINT / CONCUBIN / PARTENAIRE PACS (art. 132-80 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question:
        'La circonstance aggravante liée à la qualité de conjoint/concubin/partenaire PACS est définie par :',
    options: [
      'L’article 132-80 du code pénal',
      'L’article 132-72 du code pénal',
      'L’article 132-79 du code pénal',
    ],
    answer: 'L’article 132-80 du code pénal',
    explanation:
        'Le cours indique que l’article 132-80 du code pénal définit cette circonstance.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question: 'Cette circonstance aggravante est, selon le cours :',
    options: [
      'Réelle (elle s’étend à tous)',
      'Personnelle (elle ne s’étend pas aux coauteurs)',
      'Mixte et toujours étendue aux complices',
    ],
    answer: 'Personnelle (elle ne s’étend pas aux coauteurs)',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante personnelle dont les effets ne s’étendent pas aux coauteurs.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question:
        'Le but de cette circonstance aggravante est principalement de réprimer plus sévèrement :',
    options: [
      'Les infractions commises au sein du couple (“infractions conjugales”)',
      'Les infractions commises en bande organisée',
      'Les infractions commises sur internet',
    ],
    answer:
        'Les infractions commises au sein du couple (“infractions conjugales”)',
    explanation:
        'Le cours indique que cette circonstance vise à réprimer plus sévèrement les infractions commises au sein du couple.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question:
        'Cette circonstance peut être retenue même si l’auteur et la victime :',
    options: [
      'Ne cohabitent pas',
      'Sont inconnus l’un de l’autre',
      'Ont uniquement un lien professionnel',
    ],
    answer: 'Ne cohabitent pas',
    explanation:
        'Le texte vise expressément la circonstance “y compris lorsqu’ils ne cohabitent pas”.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question:
        'La circonstance est également constituée lorsque les faits sont commis par :',
    options: [
      'Un ancien conjoint / ancien concubin / ancien partenaire PACS',
      'Un voisin',
      'Un témoin',
    ],
    answer: 'Un ancien conjoint / ancien concubin / ancien partenaire PACS',
    explanation:
        'Le cours reprend le second alinéa : elle vaut aussi pour l’ancien conjoint/concubin/partenaire PACS.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question:
        'Lorsque le lien est rompu, la circonstance n’est retenue que si l’infraction est commise :',
    options: [
      'En raison des relations ayant existé entre l’auteur et la victime',
      'Quel que soit le motif, automatiquement',
      'Uniquement si la victime porte plainte immédiatement',
    ],
    answer: 'En raison des relations ayant existé entre l’auteur et la victime',
    explanation:
        'Le cours précise que, pour l’ancien conjoint/concubin/partenaire, il faut que l’infraction soit commise en raison des relations passées : c’est le mobile.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question: 'La définition du concubinage (art. 515-8 C. civ.) renvoie à :',
    options: [
      'Une union de fait avec vie commune stable et continue',
      'Un contrat signé en mairie',
      'Une simple relation ponctuelle',
    ],
    answer: 'Une union de fait avec vie commune stable et continue',
    explanation:
        'Le cours cite l’art. 515-8 du code civil : union de fait, vie commune, stabilité et continuité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question:
        'Selon le cours, l’existence d’un concubinage est établie dès lors qu’il est prouvé :',
    options: [
      'Qu’il y a communauté de vie',
      'Qu’il y a un compte bancaire commun',
      'Qu’il y a un enfant commun',
    ],
    answer: 'Qu’il y a communauté de vie',
    explanation:
        'Le cours indique que l’état de concubinage est établi dès lors qu’il est prouvé qu’il y a communauté de vie.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question: 'Le pacte civil de solidarité (art. 515-1 C. civ.) est :',
    options: [
      'Un contrat conclu par deux personnes majeures pour organiser leur vie commune',
      'Une simple promesse verbale',
      'Une obligation réservée aux couples mariés',
    ],
    answer:
        'Un contrat conclu par deux personnes majeures pour organiser leur vie commune',
    explanation:
        'Le cours cite l’art. 515-1 du code civil : un contrat conclu par deux personnes physiques majeures pour organiser leur vie commune.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // CARACTÈRE HOMOPHOBE / SEXISTE / TRANSPHOBE (art. 132-77 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe / sexiste / transphobe',
    question:
        'Le caractère homophobe ou sexiste d’une infraction est défini par :',
    options: [
      'L’article 132-77 du code pénal',
      'L’article 132-76 du code pénal',
      'L’article 132-80 du code pénal',
    ],
    answer: 'L’article 132-77 du code pénal',
    explanation:
        'Le cours indique que l’article 132-77 du code pénal définit le caractère homophobe ou sexiste.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe / sexiste / transphobe',
    question: 'Cette circonstance aggravante est, selon le cours :',
    options: ['Personnelle', 'Réelle', 'Toujours mixte'],
    answer: 'Réelle',
    explanation:
        'Le cours précise que cette circonstance est réelle et s’étend à tous les auteurs, coauteurs et complices.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe / sexiste / transphobe',
    question:
        'La circonstance est constituée si le crime/délit est précédé, accompagné ou suivi de :',
    options: [
      'Propos, écrits, images, objets ou actes de toute nature',
      'Uniquement une plainte de la victime',
      'Uniquement un casier judiciaire chargé',
    ],
    answer: 'Propos, écrits, images, objets ou actes de toute nature',
    explanation:
        'Le cours énumère ces éléments comme modes de matérialisation du mobile.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe / sexiste / transphobe',
    question: 'Cette circonstance vise notamment les personnes :',
    options: [
      'Homosexuelles, mais aussi transsexuelles/transgenres/travesties',
      'Uniquement homosexuelles',
      'Uniquement hétérosexuelles',
    ],
    answer: 'Homosexuelles, mais aussi transsexuelles/transgenres/travesties',
    explanation:
        'Le cours précise que la circonstance vise aussi les personnes transsexuelles, transgenres ou travesties.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe / sexiste / transphobe',
    question:
        'La circonstance peut être retenue même si la victime n’est pas réellement concernée, dès lors que l’auteur :',
    options: [
      'Croyait que la victime l’était (orientation/identité vraie ou supposée)',
      'A agi par erreur de droit',
      'A agi uniquement pour un motif financier',
    ],
    answer:
        'Croyait que la victime l’était (orientation/identité vraie ou supposée)',
    explanation:
        'Le cours indique que l’aggravation peut jouer si l’auteur croyait la victime homosexuelle/transgenre/transsexuelle alors qu’elle ne l’était pas.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // CARACTÈRE RACISTE / XÉNOPHOBE / ANTISÉMITE (art. 132-76 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'Le caractère raciste d’une infraction est défini par :',
    options: [
      'L’article 132-76 du code pénal',
      'L’article 132-77 du code pénal',
      'L’article 132-75 du code pénal',
    ],
    answer: 'L’article 132-76 du code pénal',
    explanation:
        'Le cours indique que l’article 132-76 du code pénal définit le caractère raciste.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'Selon le cours, cette circonstance aggravante est :',
    options: [
      'Réelle et s’étend à tous les auteurs, coauteurs et complices',
      'Personnelle et ne vise que l’auteur',
      'Applicable uniquement aux contraventions',
    ],
    answer: 'Réelle et s’étend à tous les auteurs, coauteurs et complices',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante réelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question:
        'Le crime ou délit est aggravé notamment s’il est précédé, accompagné ou suivi de :',
    options: [
      'Propos, écrits, images, objets ou actes de toute nature',
      'Une médiation pénale',
      'Un témoignage anonyme uniquement',
    ],
    answer: 'Propos, écrits, images, objets ou actes de toute nature',
    explanation:
        'Le cours reprend cette liste d’éléments objectifs permettant de caractériser l’aggravation.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question:
        'L’article 132-76 vise notamment l’appartenance (vraie ou supposée) à :',
    options: [
      'Une prétendue race, une ethnie, une nation ou une religion déterminée',
      'Un parti politique',
      'Une catégorie professionnelle',
    ],
    answer:
        'Une prétendue race, une ethnie, une nation ou une religion déterminée',
    explanation:
        'Le cours liste ces quatre catégories (prétendue race, ethnie, nation, religion).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question:
        'Peu importe que l’appartenance soit vraie : la circonstance peut jouer si elle est :',
    options: [
      'Vraie ou supposée',
      'Uniquement prouvée par un acte d’état civil',
      'Uniquement reconnue par la victime',
    ],
    answer: 'Vraie ou supposée',
    explanation:
        'Le cours précise que l’auteur peut agir à tort : l’appartenance/non-appartenance peut être vraie ou supposée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question:
        'Dans l’exemple de la circulaire du 20 avril 2017 cité par le cours, l’aggravation peut s’appliquer même sans propos injurieux si :',
    options: [
      'Des éléments établissent l’intention discriminatoire (choix des victimes pour leur origine/religion, etc.)',
      'La victime est inconnue',
      'Il n’y a aucun élément objectif au dossier',
    ],
    answer:
        'Des éléments établissent l’intention discriminatoire (choix des victimes pour leur origine/religion, etc.)',
    explanation:
        'Le cours indique que l’aggravation est possible si des éléments démontrent l’intention discriminatoire, même sans atteinte directe à l’honneur/considération.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LE GUET-APENS (art. 132-71-1 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens consiste dans le fait :',
    options: [
      'De suivre quelqu’un par hasard',
      'D’attendre un certain temps une ou plusieurs personnes dans un lieu déterminé pour commettre une ou plusieurs infractions',
      'D’agir sans victime déterminée',
    ],
    answer:
        'D’attendre un certain temps une ou plusieurs personnes dans un lieu déterminé pour commettre une ou plusieurs infractions',
    explanation:
        'Le cours reprend la définition légale du guet-apens (art. 132-71-1 C.P.).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est, selon le cours :',
    options: [
      'Une circonstance aggravante réelle',
      'Une circonstance aggravante personnelle',
      'Une infraction autonome identique à l’embuscade',
    ],
    answer: 'Une circonstance aggravante réelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante réelle, étendue à tous les participants.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question:
        'Le cours précise que le guet-apens est proche de l’embuscade, mais que l’embuscade :',
    options: [
      'Est une infraction autonome, même au stade préparatoire',
      'N’existe que si l’infraction est consommée',
      'Est une simple réunion fortuite',
    ],
    answer: 'Est une infraction autonome, même au stade préparatoire',
    explanation:
        'Le cours indique que l’embuscade (art. 222-15-1 C.P.) est une infraction autonome, alors que le guet-apens est une circonstance aggravante.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question:
        'Concernant l’attente (durée, nature du lieu), le cours indique que le législateur :',
    options: [
      'A fixé une durée minimale précise',
      'N’a apporté aucune précision : notion très large',
      'A limité l’attente aux lieux publics',
    ],
    answer: 'N’a apporté aucune précision : notion très large',
    explanation:
        'Le cours précise que l’article ne fixe ni durée minimale ni nature du lieu : notion large non précisée.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PORT OU USAGE D’UNE ARME (art. 132-75 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Une arme (au sens de l’art. 132-75 C.P.) est :',
    options: [
      'Uniquement une arme à feu',
      'Tout objet conçu pour tuer ou blesser',
      'Uniquement un couteau de cuisine',
    ],
    answer: 'Tout objet conçu pour tuer ou blesser',
    explanation:
        'Le cours reprend l’alinéa 1 : “est une arme tout objet conçu pour tuer ou blesser”.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question:
        'Un objet non conçu pour tuer/blesser peut être assimilé à une arme s’il est :',
    options: [
      'Utilisé ou destiné à tuer, blesser ou menacer',
      'Simplement porté dans un sac, sans intention',
      'Cassé et inutilisable',
    ],
    answer: 'Utilisé ou destiné à tuer, blesser ou menacer',
    explanation:
        'Le cours vise les armes “par destination” : objets dangereux assimilés s’ils sont utilisés/destinés à tuer, blesser ou menacer.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Une arme factice est assimilée à une arme si elle :',
    options: [
      'Ressemble suffisamment à une arme réelle et est utilisée/destinée à menacer',
      'Est un jouet sans ressemblance',
      'Est uniquement montrée dans une vitrine',
    ],
    answer:
        'Ressemble suffisamment à une arme réelle et est utilisée/destinée à menacer',
    explanation:
        'Le cours précise qu’il faut une ressemblance créant confusion et une utilisation/destination de menace de tuer ou blesser.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'L’utilisation d’un animal pour tuer, blesser ou menacer est :',
    options: [
      'Sans effet en droit pénal',
      'Assimilée à l’usage d’une arme',
      'Assimilée uniquement à une infraction de chasse',
    ],
    answer: 'Assimilée à l’usage d’une arme',
    explanation:
        'Le cours indique expressément que l’utilisation d’un animal est assimilée à l’usage d’une arme.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question:
        'Pour l’“usage et menace d’une arme”, il ne suffit pas que l’auteur soit porteur : il faut qu’il l’ait utilisée pour :',
    options: [
      'Tuer, blesser ou menacer',
      'Se défendre uniquement',
      'La collectionner',
    ],
    answer: 'Tuer, blesser ou menacer',
    explanation:
        'Le cours précise que le port ne suffit pas : il faut une utilisation/menace pour tuer, blesser ou menacer.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question:
        'Le “port d’une arme” comme circonstance aggravante est caractérisé si l’auteur était porteur :',
    options: [
      'D’une arme apparente ou cachée au moment des faits',
      'Uniquement d’une arme visible',
      'Uniquement d’une arme déclarée',
    ],
    answer: 'D’une arme apparente ou cachée au moment des faits',
    explanation:
        'Le cours précise que le port suffit si l’arme est apparente ou cachée au moment des faits.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question:
        'Parmi les infractions suivantes, laquelle est citée dans le cours comme aggravée par l’usage ou la menace d’une arme ?',
    options: [
      'Le viol (art. 222-24, 7° C.P.)',
      'La diffamation (loi de 1881)',
      'Le tapage nocturne',
    ],
    answer: 'Le viol (art. 222-24, 7° C.P.)',
    explanation:
        'Le cours liste le viol parmi les infractions aggravées par l’usage/menace d’une arme.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // L’ESCALADE (art. 132-74 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade est :',
    options: [
      'Le fait de forcer une serrure',
      'Le fait de s’introduire par-dessus une clôture ou par une ouverture non destinée à servir d’entrée',
      'Le fait d’entrer par une porte ouverte au public',
    ],
    answer:
        'Le fait de s’introduire par-dessus une clôture ou par une ouverture non destinée à servir d’entrée',
    explanation:
        'Le cours reprend la définition légale de l’escalade (art. 132-74 C.P.).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade est, selon le cours :',
    options: [
      'Une circonstance aggravante réelle',
      'Une circonstance aggravante personnelle',
      'Une excuse absolutoire',
    ],
    answer: 'Une circonstance aggravante réelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante réelle, étendue à tous les participants.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question:
        'Pour caractériser l’escalade, il faut un endroit clos dont l’accès est normalement interdit par :',
    options: [
      'Une clôture (haie, mur, porte, portail, toiture, etc.)',
      'Un simple panneau publicitaire',
      'Un marquage au sol uniquement',
    ],
    answer: 'Une clôture (haie, mur, porte, portail, toiture, etc.)',
    explanation:
        'Le cours précise qu’il s’agit d’un lieu clos interdit aux tiers par une clôture.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question:
        'Le moyen utilisé pour l’escalade (échelle, corde, échafaudage, etc.) :',
    options: [
      'Doit obligatoirement être prémédité',
      'Importe peu : il peut être prévu, trouvé par hasard ou improvisé',
      'Doit être une échelle uniquement',
    ],
    answer: 'Importe peu : il peut être prévu, trouvé par hasard ou improvisé',
    explanation:
        'Le cours indique que le moyen utilisé importe peu (prévu, improvisé, trouvé par hasard).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Selon le cours, l’escalade ne peut être réalisée que :',
    options: [
      'De l’intérieur vers l’extérieur',
      'De l’extérieur vers l’intérieur',
      'Dans les deux sens, sans condition',
    ],
    answer: 'De l’extérieur vers l’intérieur',
    explanation:
        'Le cours précise que l’escalade ne peut être réalisée que de l’extérieur vers l’intérieur (“s’introduire”).',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // INCAPACITÉ TOTALE DE TRAVAIL (I.T.T.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Incapacité totale de travail (I.T.T.)',
    question: 'L’I.T.T. (au sens pénal) mesure principalement :',
    options: [
      'La gravité des atteintes corporelles ou psychiques subies par la victime',
      'Uniquement la perte de salaire',
      'Uniquement le nombre de jours d’hospitalisation',
    ],
    answer:
        'La gravité des atteintes corporelles ou psychiques subies par la victime',
    explanation:
        'Le cours indique que l’I.T.T. mesure la gravité des atteintes corporelles ou psychiques.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Incapacité totale de travail (I.T.T.)',
    question: 'L’I.T.T. ne doit pas être confondue avec :',
    options: [
      'L’arrêt de travail du droit social',
      'La garde à vue',
      'La mise en examen',
    ],
    answer: 'L’arrêt de travail du droit social',
    explanation:
        'Le cours précise que l’I.T.T. pénale est différente de l’arrêt de travail en droit social.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Incapacité totale de travail (I.T.T.)',
    question:
        'Une victime sans activité professionnelle (enfant, retraité…) peut recevoir une I.T.T. :',
    options: ['Oui', 'Non', 'Uniquement si elle travaille au noir'],
    answer: 'Oui',
    explanation:
        'Le cours précise qu’une victime sans activité professionnelle peut se voir prescrire une I.T.T.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Incapacité totale de travail (I.T.T.)',
    question:
        'Pour constituer la circonstance aggravante, l’I.T.T. doit être :',
    options: ['Partielle', 'Totale', 'Symbolique'],
    answer: 'Totale',
    explanation:
        'Le cours indique que l’I.T.T. doit être totale pour constituer la circonstance.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Incapacité totale de travail (I.T.T.)',
    question: 'Selon le cours, l’I.T.T. s’étend :',
    options: [
      'Uniquement à l’activité professionnelle',
      'À toute l’activité courante et aux efforts physiques nécessaires à la vie quotidienne',
      'Uniquement aux activités sportives',
    ],
    answer:
        'À toute l’activité courante et aux efforts physiques nécessaires à la vie quotidienne',
    explanation:
        'Le cours précise que l’I.T.T. ne concerne pas seulement le travail mais toute l’activité courante.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Incapacité totale de travail (I.T.T.)',
    question:
        'La durée de l’I.T.T. est prise en compte par paliers, notamment :',
    options: [
      'Uniquement 1 jour / 2 jours',
      '≤ 8 jours ou > 8 jours (selon l’infraction)',
      'Uniquement > 30 jours',
    ],
    answer: '≤ 8 jours ou > 8 jours (selon l’infraction)',
    explanation:
        'Le cours présente des paliers de durée, dont inférieur/égal à 8 jours et supérieur à 8 jours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Incapacité totale de travail (I.T.T.)',
    question: 'Concernant la preuve de l’I.T.T., le juge :',
    options: [
      'Doit obligatoirement suivre le certificat médical sans discussion',
      'A un pouvoir d’appréciation et peut se baser sur certificats médicaux ou expertises',
      'Ne peut jamais utiliser d’expertise',
    ],
    answer:
        'A un pouvoir d’appréciation et peut se baser sur certificats médicaux ou expertises',
    explanation:
        'Le cours indique que le juge apprécie et peut s’appuyer sur certificats et rapports d’experts.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // UTILISATION D’UN MOYEN DE CRYPTOLOGIE (art. 132-79 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Moyen de cryptologie',
    question: 'L’utilisation d’un moyen de cryptologie est définie par :',
    options: [
      'L’article 132-79 du code pénal',
      'L’article 132-74 du code pénal',
      'L’article 132-80 du code pénal',
    ],
    answer: 'L’article 132-79 du code pénal',
    explanation:
        'Le cours indique que l’article 132-79 du code pénal définit cette circonstance aggravante.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Moyen de cryptologie',
    question: 'Cette circonstance aggravante est, selon le cours :',
    options: [
      'Réelle',
      'Personnelle',
      'Uniquement applicable aux contraventions',
    ],
    answer: 'Réelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante réelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Moyen de cryptologie',
    question: 'Un moyen de cryptologie sert principalement à assurer :',
    options: [
      'La confidentialité (et notamment la sécurité du stockage ou de la transmission des données)',
      'La vitesse de frappe au clavier',
      'La géolocalisation obligatoire',
    ],
    answer:
        'La confidentialité (et notamment la sécurité du stockage ou de la transmission des données)',
    explanation:
        'Le cours explique que la cryptologie vise surtout la confidentialité, l’authentification ou l’intégrité des données.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Moyen de cryptologie',
    question: 'Selon le cours, l’article 132-79 est de portée :',
    options: [
      'Limitée à une liste d’infractions',
      'Générale (tous crimes et délits, commis ou tentés)',
      'Réservée aux seules infractions routières',
    ],
    answer: 'Générale (tous crimes et délits, commis ou tentés)',
    explanation:
        'Le cours précise que l’article 132-79 s’applique à tous les crimes et délits, commis ou tentés.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Moyen de cryptologie',
    question:
        'L’aggravation de l’article 132-79 ne s’applique pas à l’auteur/complice qui, à la demande des autorités, a :',
    options: [
      'Refusé de répondre',
      'Remis la version en clair des messages chiffrés et les conventions secrètes nécessaires',
      'Changé de téléphone',
    ],
    answer:
        'Remis la version en clair des messages chiffrés et les conventions secrètes nécessaires',
    explanation:
        'Le cours précise l’exception : remise de la version en clair et des conventions secrètes nécessaires au déchiffrement.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Moyen de cryptologie',
    question:
        'Selon la jurisprudence citée (11 octobre 2020), le code de déverrouillage d’un téléphone peut constituer :',
    options: [
      'Une clé de déchiffrement, si le téléphone est équipé d’un moyen de cryptologie',
      'Une preuve d’innocence automatique',
      'Un simple identifiant sans lien avec la cryptologie',
    ],
    answer:
        'Une clé de déchiffrement, si le téléphone est équipé d’un moyen de cryptologie',
    explanation:
        'Le cours cite que le code de déverrouillage peut être une clé de déchiffrement si le téléphone embarque un moyen de cryptologie.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ivre ou sous l’emprise de stupéfiants',
    question:
        'Concernant l’ivresse, la jurisprudence majoritaire considère que l’ivresse :',
    options: [
      'Constitue en principe une cause légale d’exemption de peine',
      'Ne constitue pas une cause légale d’exemption de peine',
      'Supprime toujours l’intention et donc la responsabilité',
    ],
    answer: 'Ne constitue pas une cause légale d’exemption de peine',
    explanation:
        'Le cours indique que la grande majorité des décisions refusent de voir dans l’ivresse une cause légale d’exemption de peine.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ivre ou sous l’emprise de stupéfiants',
    question:
        'Pour l’usage volontaire de stupéfiants, la logique du cours est que cette solution s’applique :',
    options: [
      'Moins sévèrement que pour l’alcool, car c’est médical',
      'A fortiori, car l’usage de stupéfiants est illicite en tant que tel',
      'Uniquement si l’auteur a été contraint de consommer',
    ],
    answer:
        'A fortiori, car l’usage de stupéfiants est illicite en tant que tel',
    explanation:
        'Le cours souligne que l’usage volontaire de stupéfiants est illicite, contrairement à la consommation d’alcool, ce qui renforce l’approche.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ivre ou sous l’emprise de stupéfiants',
    question:
        'Quel texte est cité pour imposer, lors de la constatation de certains faits, des vérifications destinées à établir la présence d’alcool ?',
    options: [
      'Article L. 3354-1 du Code de la santé publique',
      'Article 450-1 du Code pénal',
      'Article 132-71 du Code pénal',
    ],
    answer: 'Article L. 3354-1 du Code de la santé publique',
    explanation:
        'Le cours renvoie à l’article L. 3354-1 du CSP qui impose aux OPJ/APJ de faire procéder à des vérifications en cas de crime, délit ou accident.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ivre ou sous l’emprise de stupéfiants',
    question:
        'Selon le cours, les vérifications liées à l’alcool sont obligatoires notamment :',
    options: [
      'Uniquement pour les contraventions',
      'Dans tous les cas de crimes, délits ou accidents suivis de mort',
      'Seulement si la victime le demande',
    ],
    answer: 'Dans tous les cas de crimes, délits ou accidents suivis de mort',
    explanation:
        'Le texte cité précise que ces vérifications sont obligatoires dans tous les cas suivis de mort.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ivre ou sous l’emprise de stupéfiants',
    question:
        'Le cours indique qu’aucune disposition spéciale ne prévoit une telle procédure en matière :',
    options: ['De stupéfiants', 'De vols simples', 'De recel'],
    answer: 'De stupéfiants',
    explanation:
        'Le cours précise qu’il n’existe pas, dans ce passage, de procédure spéciale équivalente à celle de l’alcool pour les stupéfiants.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ivre ou sous l’emprise de stupéfiants',
    question:
        'Pour affiner la preuve de consommation de stupéfiants (niveau et date), le cours mentionne la conjugaison de :',
    options: [
      'Analyses d’urine, de sang et des cheveux',
      'Une simple déclaration de l’auteur',
      'Un test respiratoire uniquement',
    ],
    answer: 'Analyses d’urine, de sang et des cheveux',
    explanation:
        'Selon les représentants de l’ordre des médecins cités, ces trois dépistages permettent de préciser niveau de consommation et date.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // AVEC UTILISATION D’UN RÉSEAU DE COMMUNICATION ÉLECTRONIQUE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question:
        'Cette circonstance aggravante vise l’utilisation d’un réseau pour la diffusion de messages :',
    options: [
      'À destination d’un public non déterminé',
      'À destination d’une personne unique identifiée',
      'Uniquement à destination d’un public déterminé et fermé',
    ],
    answer: 'À destination d’un public non déterminé',
    explanation:
        'Le cours retient expressément la diffusion de messages à destination d’un public non déterminé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'La formule “public non déterminé” exclut :',
    options: [
      'La publication sur un réseau social public',
      'La diffusion sur un forum accessible à tous',
      'L’envoi d’un courriel identique à plusieurs personnes identifiées',
    ],
    answer: 'L’envoi d’un courriel identique à plusieurs personnes identifiées',
    explanation:
        'Le cours précise que cette formule exclut l’envoi d’un courrier électronique identique à plusieurs personnes identifiées.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question:
        'Selon le cours, un “réseau de communication électronique” vise notamment :',
    options: [
      'Le réseau Internet et le réseau téléphonique',
      'Uniquement le courrier postal',
      'Uniquement les communications en face à face',
    ],
    answer: 'Le réseau Internet et le réseau téléphonique',
    explanation:
        'Le cours indique expressément Internet et le réseau téléphonique.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question:
        'Cette circonstance aggravante est qualifiée par le cours comme :',
    options: [
      'Réelle, s’étendant aux auteurs, coauteurs et complices',
      'Personnelle, ne visant que l’auteur principal',
      'Une immunité pénale automatique',
    ],
    answer: 'Réelle, s’étendant aux auteurs, coauteurs et complices',
    explanation:
        'Le cours rappelle qu’il s’agit d’une circonstance aggravante réelle, dont les effets s’étendent à tous les participants.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question:
        'Dans le champ d’application cité par le cours, figure notamment :',
    options: [
      'Le viol (article 222-24 du code pénal)',
      'La diffamation publique (loi de 1881 uniquement)',
      'Le stationnement gênant',
    ],
    answer: 'Le viol (article 222-24 du code pénal)',
    explanation:
        'Le cours mentionne explicitement le viol (article 222-24) parmi les infractions aggravées par l’utilisation d’un réseau.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // DANS UN ÉTABLISSEMENT D’ENSEIGNEMENT / LOCAUX DE L’ADMINISTRATION
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Établissement d’enseignement / locaux de l’administration',
    question:
        'Cette circonstance aggravante vise à réprimer plus sévèrement certaines infractions commises :',
    options: [
      'En milieu scolaire et dans les locaux de l’administration',
      'Uniquement en zone rurale',
      'Uniquement dans un véhicule',
    ],
    answer: 'En milieu scolaire et dans les locaux de l’administration',
    explanation:
        'Le cours explique qu’elle vise notamment le milieu scolaire, mais aussi les locaux de l’administration visés par le texte.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Établissement d’enseignement / locaux de l’administration',
    question:
        'Concernant les “locaux de l’administration”, un arrêt du 14 octobre 2020 précise que cette notion :',
    options: [
      'Peut viser n’importe quelle administration, sans limite',
      'Ne saurait être étendue à des locaux pouvant dépendre d’autres administrations',
      'Vise uniquement les locaux privés',
    ],
    answer:
        'Ne saurait être étendue à des locaux pouvant dépendre d’autres administrations',
    explanation:
        'Le cours cite un arrêt de la chambre criminelle du 14 octobre 2020 limitant l’extension de la notion.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Établissement d’enseignement / locaux de l’administration',
    question: 'Les faits peuvent être commis “dans” l’établissement :',
    options: [
      'Uniquement dans une salle de classe',
      'Dans toute partie de l’établissement (bureau, salle, escalier, cour, etc.)',
      'Uniquement à l’entrée, jamais ailleurs',
    ],
    answer:
        'Dans toute partie de l’établissement (bureau, salle, escalier, cour, etc.)',
    explanation:
        'Le cours précise que les faits peuvent être commis dans n’importe quelle partie de l’établissement.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Établissement d’enseignement / locaux de l’administration',
    question: 'Pour les abords, les faits doivent être commis :',
    options: [
      'À n’importe quelle heure, sans condition',
      'Lors des entrées/sorties ou dans un temps très voisin de celles-ci',
      'Uniquement la nuit',
    ],
    answer:
        'Lors des entrées/sorties ou dans un temps très voisin de celles-ci',
    explanation:
        'Le cours impose, pour les abords, le moment des entrées et sorties ou un temps très voisin.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Établissement d’enseignement / locaux de l’administration',
    question: 'Cette circonstance aggravante est :',
    options: [
      'Personnelle et ne s’applique qu’au mineur',
      'Réelle et s’étend aux auteurs, coauteurs et complices',
      'Une excuse absolutoire',
    ],
    answer: 'Réelle et s’étend aux auteurs, coauteurs et complices',
    explanation:
        'Le cours qualifie explicitement cette circonstance de réelle, avec extension à tous les participants.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LA BANDE ORGANISÉE (ARTICLE 132-71 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'Selon l’article 132-71 du code pénal, la bande organisée est :',
    options: [
      'Toute réunion fortuite de deux personnes',
      'Tout groupement ou entente en vue de la préparation caractérisée par des faits matériels d’une ou plusieurs infractions',
      'Toute infraction commise sans préparation',
    ],
    answer:
        'Tout groupement ou entente en vue de la préparation caractérisée par des faits matériels d’une ou plusieurs infractions',
    explanation:
        'C’est la définition légale reprise dans le cours (article 132-71 C.P.).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée est qualifiée par le cours comme :',
    options: [
      'Une circonstance aggravante personnelle',
      'Une circonstance aggravante réelle',
      'Une immunité pénale',
    ],
    answer: 'Une circonstance aggravante réelle',
    explanation:
        'Le cours indique que c’est une circonstance aggravante réelle, s’étendant aux auteurs, coauteurs et complices.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question:
        'La bande organisée se distingue de l’association de malfaiteurs car l’association de malfaiteurs :',
    options: [
      'Est une infraction autonome, caractérisée même au stade préparatoire',
      'N’existe que si l’infraction a été consommée',
      'N’existe que pour les contraventions',
    ],
    answer:
        'Est une infraction autonome, caractérisée même au stade préparatoire',
    explanation:
        'Le cours rappelle que l’association de malfaiteurs (450-1 C.P.) est autonome et peut être constituée au stade des actes préparatoires.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La “réunion” (au sens du cours) se caractérise plutôt par :',
    options: [
      'Un caractère fortuit et occasionnel',
      'Une organisation structurée et hiérarchisée existant depuis longtemps',
      'Une direction et une hiérarchisation systématiques',
    ],
    answer: 'Un caractère fortuit et occasionnel',
    explanation:
        'Le cours oppose la réunion (fortuite/occasionnelle) à la bande organisée (plan concerté, organisation).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'Selon le cours, la bande organisée suppose :',
    options: [
      'Un plan concerté (préméditation)',
      'L’absence totale de contacts préliminaires',
      'Une décision prise après les faits',
    ],
    answer: 'Un plan concerté (préméditation)',
    explanation:
        'Le cours cite la jurisprudence : la bande organisée suppose un plan concerté et des contacts préliminaires.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée suppose une certaine organisation avec :',
    options: [
      'Aucune répartition des rôles',
      'Direction, hiérarchisation et distribution des rôles',
      'Un seul auteur isolé',
    ],
    answer: 'Direction, hiérarchisation et distribution des rôles',
    explanation:
        'Le cours évoque une organisation structurée et hiérarchisée avec répartition des rôles.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question:
        'D’après la jurisprudence citée (8 juillet 2015), la seule constitution d’une équipe de malfaiteurs ne suffit pas si :',
    options: [
      'Il manque le critère de structure existant depuis un certain temps',
      'Il y a plus de trois personnes',
      'L’infraction est un délit',
    ],
    answer:
        'Il manque le critère de structure existant depuis un certain temps',
    explanation:
        'Le cours mentionne que l’équipe ne suffit pas si elle ne répond pas au critère supplémentaire de structure existant depuis un certain temps.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LA MINORITÉ DE QUINZE ANS
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'La circonstance aggravante “sur un mineur de 15 ans” vise :',
    options: [
      'Uniquement les victimes âgées de 15 ans révolus',
      'L’âge de 15 ans accompli, donc toute victime en dessous de 15 ans',
      'Uniquement les victimes âgées de 14 ans',
    ],
    answer: 'L’âge de 15 ans accompli, donc toute victime en dessous de 15 ans',
    explanation:
        'Le cours précise que la limite retenue est 15 ans accompli : quel que soit l’âge en dessous de 15 ans, l’aggravation peut jouer.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'Pour déterminer l’âge, on retient :',
    options: [
      'L’âge de la victime au moment du jugement',
      'L’âge de la victime au moment des faits',
      'L’âge apparent de la victime',
    ],
    answer: 'L’âge de la victime au moment des faits',
    explanation:
        'Le cours indique que c’est l’âge au moment des faits qui doit être pris en considération (jurisprudence citée).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question:
        'Le calcul de l’âge “au moment des faits” se fait, selon le cours :',
    options: ['Au jour près uniquement', 'D’heure à heure', 'Au mois près'],
    answer: 'D’heure à heure',
    explanation:
        'Le cours cite une jurisprudence indiquant que l’âge se calcule d’heure à heure.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question:
        'Concernant la minorité de quinze ans, le législateur exige que cet âge soit :',
    options: [
      'Apparent ou connu de l’auteur',
      'Apparent uniquement',
      'Ni apparent ni connu : ce n’est pas exigé',
    ],
    answer: 'Ni apparent ni connu : ce n’est pas exigé',
    explanation:
        'Le cours précise que, contrairement à d’autres circonstances, la minorité de 15 ans n’a pas à être apparente ou connue.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LA MORT (AYANT ENTRAÎNÉ LA MORT SANS INTENTION DE LA DONNER)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Mort sans intention de la donner',
    question:
        'La circonstance aggravante “ayant entraîné la mort sans intention de la donner” suppose que :',
    options: [
      'L’auteur a voulu tuer volontairement',
      'La mort est survenue, mais l’auteur n’a jamais voulu donner la mort',
      'La mort est présumée, sans lien avec les faits',
    ],
    answer:
        'La mort est survenue, mais l’auteur n’a jamais voulu donner la mort',
    explanation:
        'Le cours précise que l’infraction a entraîné la mort, sans intention homicide de l’auteur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Mort sans intention de la donner',
    question: 'Pour retenir cette circonstance, il faut :',
    options: [
      'Une relation de cause à effet entre l’acte délictueux et le décès',
      'Une confession obligatoire',
      'Une plainte déposée dans l’heure',
    ],
    answer: 'Une relation de cause à effet entre l’acte délictueux et le décès',
    explanation:
        'Le cours mentionne la nécessité d’un lien de causalité entre l’acte et le décès.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Mort sans intention de la donner',
    question:
        'L’état de santé préexistant de la victime (même s’il a concouru au décès) rend la circonstance :',
    options: [
      'Inapplicable',
      'Applicable : il est indifférent',
      'Applicable uniquement si la victime était en parfaite santé',
    ],
    answer: 'Applicable : il est indifférent',
    explanation:
        'Le cours précise que la circonstance peut être retenue quel que soit l’état préexistant de la victime.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Mort sans intention de la donner',
    question: 'Cette circonstance aggravante est :',
    options: [
      'Réelle (effets étendus aux auteurs, coauteurs, complices)',
      'Strictement personnelle (uniquement l’auteur principal)',
      'Une cause d’excuse légale',
    ],
    answer: 'Réelle (effets étendus aux auteurs, coauteurs, complices)',
    explanation:
        'Le cours indique qu’il s’agit d’une circonstance aggravante réelle.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LA MUTILATION OU L’INFIRMITÉ PERMANENTE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'Selon le cours, la mutilation correspond plutôt à :',
    options: [
      'Une simple douleur passagère',
      'La perte ou l’ablation d’un membre/partie externe entraînant une atteinte irréversible',
      'Une fatigue temporaire',
    ],
    answer:
        'La perte ou l’ablation d’un membre/partie externe entraînant une atteinte irréversible',
    explanation:
        'Le cours reprend l’idée d’une atteinte irréversible à l’intégrité physique liée à la perte/ablation d’un membre ou partie externe.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'L’infirmité permanente peut être :',
    options: [
      'Uniquement esthétique',
      'Uniquement physique',
      'Physique ou affecter les facultés mentales/intellectuelles',
    ],
    answer: 'Physique ou affecter les facultés mentales/intellectuelles',
    explanation:
        'Le cours précise que l’infirmité peut être physique mais aussi toucher les facultés mentales ou intellectuelles.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'Pour l’infirmité, le critère central est son caractère :',
    options: ['Réversible', 'Irréversible / définitif', 'Hypothétique'],
    answer: 'Irréversible / définitif',
    explanation:
        'Le cours exige une infirmité irréversible ou définitive (jurisprudences citées).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question:
        'La preuve de la mutilation/infirmité permanente peut être rapportée notamment par :',
    options: [
      'Certificats médicaux ou expertises médicales',
      'Un simple avis oral d’un témoin',
      'Une rumeur publique',
    ],
    answer: 'Certificats médicaux ou expertises médicales',
    explanation:
        'Le cours indique que la partie poursuivante peut rapporter la preuve par tout moyen, notamment certificats médicaux/expertises.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LA PARTICULIÈRE VULNÉRABILITÉ DE LA VICTIME
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Particulière vulnérabilité de la victime',
    question: 'La particulière vulnérabilité doit être due à des causes :',
    options: [
      'Illimitées, au choix du juge',
      'Limitatives et préexistantes aux faits',
      'Uniquement causées par l’infraction elle-même',
    ],
    answer: 'Limitatives et préexistantes aux faits',
    explanation:
        'Le cours précise que les causes sont limitatives et doivent résulter d’un état préexistant, non de la conséquence des faits.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Particulière vulnérabilité de la victime',
    question: 'Pour être retenue, la vulnérabilité doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Toujours présumée',
      'Constatée uniquement après le procès',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation:
        'Le cours exige que la cause de vulnérabilité soit apparente (visible) ou connue (révélée) de l’auteur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Particulière vulnérabilité de la victime',
    question: 'S’agissant de l’âge, le cours précise que :',
    options: [
      'La minorité de 15 ans entre dans cette circonstance',
      'L’âge n’est pas déterminé précisément et la minorité de 15 ans est traitée à part',
      'La vulnérabilité est automatique dès 18 ans',
    ],
    answer:
        'L’âge n’est pas déterminé précisément et la minorité de 15 ans est traitée à part',
    explanation:
        'Le cours indique que la minorité de 15 ans ne relève pas de cette vulnérabilité car elle fait l’objet d’une aggravation spécifique.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Particulière vulnérabilité de la victime',
    question:
        'Le seul “grand âge” suffit à caractériser automatiquement la particulière vulnérabilité :',
    options: [
      'Oui, toujours',
      'Non, il faut des éléments complémentaires prouvant une vulnérabilité particulière',
      'Oui, si la victime a plus de 60 ans',
    ],
    answer:
        'Non, il faut des éléments complémentaires prouvant une vulnérabilité particulière',
    explanation:
        'Le cours indique que l’âge seul ne suffit pas : il faut établir une vulnérabilité particulière.',
    difficulty: 'Difficile',
  ),
  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ D’AUTEUR ABUSANT DE SON AUTORITÉ
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question:
        'La circonstance aggravante « par une personne qui abuse de l’autorité que lui confèrent ses fonctions » est :',
    options: [
      'Une circonstance aggravante réelle',
      'Une circonstance aggravante personnelle',
      'Une cause légale d’irresponsabilité pénale',
    ],
    answer: 'Une circonstance aggravante personnelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante personnelle dont les effets ne s’étendent pas aux coauteurs.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question:
        'Cette circonstance vise les personnes disposant principalement :',
    options: [
      'D’une autorité générale liée à leurs fonctions',
      'D’un simple lien familial',
      'D’une autorité occasionnelle sans fonction',
    ],
    answer: 'D’une autorité générale liée à leurs fonctions',
    explanation:
        'Le cours indique qu’elle concerne les personnes ayant une autorité générale due aux fonctions exercées.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question:
        'Les personnes concernées par cette circonstance sont notamment :',
    options: [
      'Les professeurs, médecins, prêtres, marabouts',
      'Uniquement les ascendants familiaux',
      'Uniquement les élus politiques',
    ],
    answer: 'Les professeurs, médecins, prêtres, marabouts',
    explanation:
        'Le cours cite explicitement ces exemples de personnes ayant autorité sur la victime.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Les fonctions exercées par l’auteur peuvent être :',
    options: [
      'Uniquement publiques',
      'Uniquement privées',
      'Publiques ou privées',
    ],
    answer: 'Publiques ou privées',
    explanation:
        'Le cours précise que les fonctions exercées peuvent être publiques ou privées.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'L’aggravation est retenue lorsque l’auteur :',
    options: [
      'A simplement une fonction reconnue',
      'A abusé de l’autorité conférée par ses fonctions pour commettre l’infraction',
      'Est connu de la victime',
    ],
    answer:
        'A abusé de l’autorité conférée par ses fonctions pour commettre l’infraction',
    explanation:
        'Le cours indique que l’abus de l’autorité est la condition déterminante de l’aggravation.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ D’AUTEUR ASCENDANT OU AYANT AUTORITÉ SUR LA VICTIME
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou ayant autorité sur la victime',
    question:
        'La qualité d’auteur ascendant ou ayant autorité sur la victime constitue :',
    options: [
      'Une circonstance aggravante réelle',
      'Une circonstance aggravante personnelle',
      'Une infraction autonome',
    ],
    answer: 'Une circonstance aggravante personnelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante personnelle dont les effets ne s’étendent pas aux coauteurs.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou ayant autorité sur la victime',
    question: 'Sont considérés comme ascendants de la victime :',
    options: [
      'Les parents, aïeux et aïeules',
      'Les cousins et cousines uniquement',
      'Tous les membres de la famille',
    ],
    answer: 'Les parents, aïeux et aïeules',
    explanation:
        'Le cours vise les père, mère et autres ascendants directs, légitimes, naturels ou adoptifs.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou ayant autorité sur la victime',
    question:
        'Les parents et alliés en ligne collatérale (oncle, tante, cousin) sont :',
    options: [
      'Toujours exclus',
      'Visés uniquement s’ils ont une autorité de fait',
      'Toujours assimilés aux ascendants',
    ],
    answer: 'Visés uniquement s’ils ont une autorité de fait',
    explanation:
        'Le cours précise que la circonstance peut s’appliquer s’ils exercent une autorité de fait sur la victime.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou ayant autorité sur la victime',
    question: 'L’autorité sur la victime peut être :',
    options: [
      'Uniquement de droit',
      'Uniquement de fait',
      'De droit ou de fait, permanente ou discontinue',
    ],
    answer: 'De droit ou de fait, permanente ou discontinue',
    explanation:
        'Le cours mentionne une autorité de droit (tuteur) ou de fait, permanente ou discontinue.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ D’AUTEUR DÉPOSITAIRE DE L’AUTORITÉ PUBLIQUE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire de l’autorité publique',
    question:
        'La qualité d’auteur dépositaire de l’autorité publique constitue :',
    options: [
      'Une circonstance aggravante réelle',
      'Une circonstance aggravante personnelle',
      'Une cause d’exemption de peine',
    ],
    answer: 'Une circonstance aggravante personnelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante personnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire de l’autorité publique',
    question: 'Est dépositaire de l’autorité publique celui qui :',
    options: [
      'Exerce un simple emploi public',
      'Dispose d’un pouvoir de décision fondé sur une parcelle de l’autorité publique',
      'Travaille pour une entreprise privée',
    ],
    answer:
        'Dispose d’un pouvoir de décision fondé sur une parcelle de l’autorité publique',
    explanation:
        'Le cours reprend la définition jurisprudentielle de la qualité de dépositaire de l’autorité publique.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire de l’autorité publique',
    question: 'Font notamment partie des dépositaires de l’autorité publique :',
    options: [
      'Les policiers, gendarmes, magistrats',
      'Uniquement les élus locaux',
      'Uniquement les agents contractuels',
    ],
    answer: 'Les policiers, gendarmes, magistrats',
    explanation: 'Le cours cite explicitement ces professions.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire de l’autorité publique',
    question: 'La circonstance est retenue si les faits sont commis :',
    options: [
      'Dans l’exercice ou à l’occasion de l’exercice des fonctions',
      'Uniquement pendant les heures de travail',
      'Uniquement sur le lieu de travail',
    ],
    answer: 'Dans l’exercice ou à l’occasion de l’exercice des fonctions',
    explanation:
        'Le cours précise que l’infraction peut être commise dans l’exercice ou du fait des fonctions.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE LA VICTIME ASCENDANT DE L’AUTEUR
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Victime ascendant de l’auteur',
    question:
        'La qualité de victime ascendant de l’auteur est une circonstance aggravante :',
    options: ['Réelle', 'Personnelle', 'Mixte'],
    answer: 'Personnelle',
    explanation:
        'Le cours indique que cette circonstance est de nature personnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Victime ascendant de l’auteur',
    question: 'Cette circonstance a été réintroduite après la suppression de :',
    options: [
      'L’incrimination de parricide',
      'L’excuse de minorité',
      'La récidive légale',
    ],
    answer: 'L’incrimination de parricide',
    explanation:
        'Le cours précise que cette circonstance a été réintroduite après la suppression du parricide.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Victime ascendant de l’auteur',
    question: 'La filiation naturelle doit être :',
    options: ['Supposée', 'Légalement établie', 'Reconnaissable moralement'],
    answer: 'Légalement établie',
    explanation:
        'Le cours précise que la filiation naturelle doit être légalement établie.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE LA VICTIME CHARGÉE D’UNE MISSION DE SERVICE PUBLIC
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime chargée d’une mission de service public',
    question: 'Cette circonstance aggravante est :',
    options: ['Personnelle', 'Réelle', 'Limitée à l’auteur principal'],
    answer: 'Réelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante réelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime chargée d’une mission de service public',
    question: 'Elle vise à protéger principalement :',
    options: [
      'Les personnes exposées en raison de leur mission',
      'Uniquement les fonctionnaires',
      'Uniquement les élus',
    ],
    answer: 'Les personnes exposées en raison de leur mission',
    explanation:
        'Le cours indique que cette circonstance accroît la protection due aux personnes exposées en raison de leur mission.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime chargée d’une mission de service public',
    question: 'La qualité de la victime doit être :',
    options: [
      'Inconnue de l’auteur',
      'Apparente ou connue de l’auteur',
      'Déclarée après les faits',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation:
        'Le cours précise que l’auteur doit agir en raison de la qualité apparente ou connue de la victime.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE LA VICTIME DÉPOSITAIRE DE L’AUTORITÉ PUBLIQUE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire de l’autorité publique',
    question: 'Cette circonstance protège :',
    options: [
      'Uniquement la personne',
      'La personne et la fonction exercée',
      'Uniquement l’institution',
    ],
    answer: 'La personne et la fonction exercée',
    explanation:
        'Le cours précise que la protection concerne la personne et, à travers elle, la fonction.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire de l’autorité publique',
    question: 'Pour retenir cette circonstance, l’infraction doit être :',
    options: [
      'Sans lien avec la fonction',
      'En rapport direct avec la fonction',
      'Postérieure à la cessation des fonctions uniquement',
    ],
    answer: 'En rapport direct avec la fonction',
    explanation:
        'Le cours indique que l’infraction doit être en lien direct avec la fonction exercée.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE LA VICTIME SE LIVRANT À LA PROSTITUTION
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Cette circonstance aggravante a été créée par la loi du :',
    options: ['13 avril 2016', '21 juin 2004', '29 juillet 1881'],
    answer: '13 avril 2016',
    explanation:
        'Le cours précise que cette circonstance a été créée par la loi n°2016-444 du 13 avril 2016.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'La prostitution peut être retenue :',
    options: [
      'Uniquement si elle est habituelle',
      'Y compris de façon occasionnelle',
      'Uniquement si elle est déclarée',
    ],
    answer: 'Y compris de façon occasionnelle',
    explanation:
        'Le cours précise qu’un acte unique de prostitution peut suffire.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Les faits doivent avoir été commis :',
    options: [
      'Dans l’exercice de l’activité prostitutionnelle',
      'À n’importe quel moment',
      'Après la cessation de l’activité',
    ],
    answer: 'Dans l’exercice de l’activité prostitutionnelle',
    explanation:
        'Le cours exclut les faits sans lien avec l’activité prostitutionnelle.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE TÉMOIN, VICTIME OU PARTIE CIVILE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Témoin, victime ou partie civile',
    question: 'Cette circonstance vise principalement à protéger :',
    options: [
      'Le bon fonctionnement de la justice',
      'La liberté d’expression',
      'La sécurité routière',
    ],
    answer: 'Le bon fonctionnement de la justice',
    explanation:
        'Le cours précise que cette circonstance vise à préserver l’administration de la justice.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Témoin, victime ou partie civile',
    question:
        'L’auteur peut agir avec une intention dite « préventive » pour :',
    options: [
      'Empêcher la dénonciation ou le dépôt de plainte',
      'Se défendre juridiquement',
      'Accélérer la procédure',
    ],
    answer: 'Empêcher la dénonciation ou le dépôt de plainte',
    explanation:
        'Le cours indique que l’intention préventive vise à empêcher plainte, dénonciation ou témoignage.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Témoin, victime ou partie civile',
    question:
        'Lorsque l’auteur agit par vengeance après une plainte ou une déposition, l’intention est dite :',
    options: ['Préventive', 'Répressive', 'Accidentelle'],
    answer: 'Répressive',
    explanation: 'Le cours qualifie cette intention de répressive.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE VICTIME PARENTE D’UNE PERSONNE DÉPOSITAIRE DE L’AUTORITÉ PUBLIQUE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime parente d’un dépositaire de l’autorité publique',
    question: 'Cette circonstance aggravante est :',
    options: ['Personnelle', 'Réelle', 'Limitée à l’auteur principal'],
    answer: 'Réelle',
    explanation:
        'Le cours précise que cette circonstance est réelle et s’étend à tous les participants.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime parente d’un dépositaire de l’autorité publique',
    question: 'Sont notamment protégés :',
    options: [
      'Le conjoint, les ascendants, les descendants ou les personnes vivant au domicile',
      'Uniquement les enfants mineurs',
      'Uniquement les conjoints mariés',
    ],
    answer:
        'Le conjoint, les ascendants, les descendants ou les personnes vivant au domicile',
    explanation: 'Le cours énumère précisément ces catégories de proches.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime parente d’un dépositaire de l’autorité publique',
    question: 'L’infraction doit avoir été commise :',
    options: [
      'Par hasard',
      'En raison des fonctions exercées par le proche',
      'Pour un motif strictement personnel',
    ],
    answer: 'En raison des fonctions exercées par le proche',
    explanation:
        'Le cours précise que l’auteur doit avoir agi en raison des fonctions exercées par le proche, connues de lui.',
    difficulty: 'Difficile',
  ),
  //////////////////////////////////////////////////////////////////////////////
  // GÉNÉRALITÉS — CIRCONSTANCES AGGRAVANTES (rappels)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance n’est aggravante que lorsque :',
    options: [
      'Le juge le décide librement',
      'La loi le décide expressément',
      'La victime le demande',
    ],
    answer: 'La loi le décide expressément',
    explanation:
        'Le cours précise qu’une circonstance n’est aggravante que lorsque la loi le décide expressément.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Les circonstances aggravantes sont énumérées par la loi :',
    options: [
      'De manière limitative',
      'De manière indicative',
      'Uniquement par circulaire',
    ],
    answer: 'De manière limitative',
    explanation:
        'Le cours indique que la loi les énumère de manière limitative.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance aggravante peut :',
    options: [
      'Modifier la nature de la peine et donc la nature de l’infraction',
      'Supprimer automatiquement l’infraction',
      'Transformer un crime en contravention',
    ],
    answer: 'Modifier la nature de la peine et donc la nature de l’infraction',
    explanation:
        'Le cours précise qu’elle peut modifier la nature de la peine et, par conséquence, la nature de l’infraction.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Les circonstances aggravantes “réelles” :',
    options: [
      'Ne s’étendent jamais aux complices',
      'S’attachent à la matérialité du fait et valent pour tous les participants',
      'Sont uniquement liées à la personnalité',
    ],
    answer:
        'S’attachent à la matérialité du fait et valent pour tous les participants',
    explanation: 'Le cours oppose les réelles (matérialité) aux personnelles.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance “personnelle” :',
    options: [
      'S’attache à la matérialité du fait',
      'Augmente la culpabilité de celui qui agit car liée à sa personnalité',
      'S’applique automatiquement à tous les coauteurs',
    ],
    answer:
        'Augmente la culpabilité de celui qui agit car liée à sa personnalité',
    explanation:
        'Le cours : personnelles = liées à la personnalité/qualité de l’auteur.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Selon Cass. crim. 7 février 2007, une même circonstance peut :',
    options: [
      'Aggraver des crimes distincts',
      'Aggraver seulement un crime et jamais deux',
      'Être interdite si elle est objective',
    ],
    answer: 'Aggraver des crimes distincts',
    explanation:
        'Le cours cite que rien ne s’oppose à ce qu’une même circonstance aggrave des crimes distincts.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Les circonstances aggravantes dites “spéciales” :',
    options: [
      'S’appliquent à toutes les infractions sans exception',
      'Ne s’appliquent qu’aux infractions pour lesquelles la loi les prévoit',
      'Dépendent uniquement d’un décret',
    ],
    answer:
        'Ne s’appliquent qu’aux infractions pour lesquelles la loi les prévoit',
    explanation:
        'Le cours précise qu’elles ne valent que pour les infractions visées.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'La doctrine ajoute parfois une 3e catégorie :',
    options: [
      'Les circonstances mixtes',
      'Les circonstances administratives',
      'Les circonstances morales',
    ],
    answer: 'Les circonstances mixtes',
    explanation:
        'Le cours mentionne la doctrine : mixtes (qualité + criminalité de l’acte).',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PRÉMÉDITATION (art. 132-72 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation est :',
    options: [
      'Le dessein formé avant l’action de commettre un crime ou un délit déterminé',
      'Le fait d’agir en groupe',
      'Le fait d’être armé',
    ],
    answer:
        'Le dessein formé avant l’action de commettre un crime ou un délit déterminé',
    explanation: 'Définition légale reprise au cours (art. 132-72 C.P.).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation est définie par :',
    options: [
      'L’article 132-72 C.P.',
      'L’article 132-75 C.P.',
      'L’article 132-80 C.P.',
    ],
    answer: 'L’article 132-72 C.P.',
    explanation: 'Référence donnée par le cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Elle traduit une volonté :',
    options: [
      'Mûre et réfléchie',
      'Spontanée et impulsive',
      'Toujours accidentelle',
    ],
    answer: 'Mûre et réfléchie',
    explanation: 'Le cours : résolution d’agir, volonté mûre et réfléchie.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Condition essentielle : la résolution doit être :',
    options: [
      'Postérieure à l’acte',
      'Antérieure à l’acte',
      'Indifférente dans le temps',
    ],
    answer: 'Antérieure à l’acte',
    explanation: 'Antériorité nécessaire (Cass. crim., 9 janv. 1990).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'L’intervalle de temps se situe entre :',
    options: [
      'La résolution et l’exécution',
      'L’enquête et le procès',
      'La plainte et la condamnation',
    ],
    answer: 'La résolution et l’exécution',
    explanation: 'Le cours : entre décision et exécution.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Un acte prémédité est :',
    options: [
      'Médité et préparé',
      'Toujours une pulsion',
      'Toujours une réaction immédiate',
    ],
    answer: 'Médité et préparé',
    explanation: 'Non spontané, pas une pulsion.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation vise :',
    options: [
      'Une infraction commise ou tentée',
      'Uniquement une infraction consommée',
      'Uniquement les contraventions',
    ],
    answer: 'Une infraction commise ou tentée',
    explanation: 'Le cours : indifféremment commise ou tentée.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Elle se matérialise par des faits situés :',
    options: [
      'Avant l’acte, dans l’intervalle qui précède',
      'Uniquement après l’acte',
      'Uniquement au procès',
    ],
    answer: 'Avant l’acte, dans l’intervalle qui précède',
    explanation:
        'Le cours insiste sur les faits/circonstances précédant l’acte.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Exemple de matérialisation :',
    options: [
      'Actes préparatoires / menaces / confidences',
      'Simple maladresse',
      'Absence totale de préparation',
    ],
    answer: 'Actes préparatoires / menaces / confidences',
    explanation: 'Exemples cités par le cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La jurisprudence qualifie parfois la préméditation :',
    options: [
      'Toujours réelle',
      'Tantôt réelle, tantôt personnelle',
      'Toujours mixte au sens légal',
    ],
    answer: 'Tantôt réelle, tantôt personnelle',
    explanation: 'Le cours mentionne cette hésitation jurisprudentielle.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Le meurtre avec préméditation devient :',
    options: ['Un assassinat', 'Un homicide involontaire', 'Une contravention'],
    answer: 'Un assassinat',
    explanation: 'Art. 221-3 al.1 : meurtre qualifié d’assassinat.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Le champ d’application inclut notamment :',
    options: [
      'Le meurtre, l’empoisonnement, certaines violences',
      'Le stationnement gênant',
      'Le recel simple uniquement',
    ],
    answer: 'Le meurtre, l’empoisonnement, certaines violences',
    explanation: 'Liste donnée dans le cours.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // GUET-APENS (art. 132-71-1 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens consiste à :',
    options: [
      'Attendre un certain temps une ou plusieurs personnes dans un lieu déterminé pour commettre une ou plusieurs infractions',
      'Agir sous contrainte d’un tiers',
      'Commettre une infraction sans victime',
    ],
    answer:
        'Attendre un certain temps une ou plusieurs personnes dans un lieu déterminé pour commettre une ou plusieurs infractions',
    explanation: 'Définition de l’art. 132-71-1 reprise au cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est une circonstance :',
    options: ['Réelle', 'Personnelle', 'Purement disciplinaire'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue à tous les participants.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est une forme particulière de :',
    options: ['Préméditation', 'Récidive', 'Tentative'],
    answer: 'Préméditation',
    explanation: 'Le cours : forme particulière de préméditation.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Concernant la durée minimale de l’attente, le texte :',
    options: [
      'La fixe précisément',
      'Ne la précise pas',
      'Exige au moins 24 heures',
    ],
    answer: 'Ne la précise pas',
    explanation: 'Le cours : notion large, pas de durée minimum.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'La qualité de la victime est :',
    options: [
      'Indifférente (toute personne)',
      'Limitée aux mineurs',
      'Limitée aux dépositaires d’autorité',
    ],
    answer: 'Indifférente (toute personne)',
    explanation: 'Le cours : “toute personne quelle que soit sa qualité”.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le but poursuivi est caractérisé par :',
    options: [
      'Des actes préparatoires liés à l’infraction visée',
      'Une simple négligence',
      'Un hasard complet',
    ],
    answer: 'Des actes préparatoires liés à l’infraction visée',
    explanation:
        'Le cours : actes préparatoires en relation avec l’infraction.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens se distingue de l’embuscade car l’embuscade :',
    options: [
      'Est une infraction autonome',
      'N’existe jamais en droit',
      'Est une contravention',
    ],
    answer: 'Est une infraction autonome',
    explanation:
        'Le cours : embuscade = infraction autonome (même au stade préparatoire).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Champ d’application : guet-apens peut aggraver :',
    options: [
      'Meurtre, empoisonnement, tortures, violences (liste du cours)',
      'Uniquement des contraventions',
      'Uniquement le recel',
    ],
    answer: 'Meurtre, empoisonnement, tortures, violences (liste du cours)',
    explanation: 'Liste donnée dans le cours.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PORT / USAGE / MENACE D’UNE ARME (art. 132-75 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Selon l’art. 132-75, une arme est :',
    options: [
      'Tout objet conçu pour tuer ou blesser',
      'Tout objet métallique',
      'Tout objet lourd',
    ],
    answer: 'Tout objet conçu pour tuer ou blesser',
    explanation: 'Arme par nature (alinéa 1).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Un objet du quotidien devient arme “par destination” s’il est :',
    options: [
      'Utilisé/destiné à tuer, blesser ou menacer',
      'Simplement acheté',
      'Transporté dans un carton',
    ],
    answer: 'Utilisé/destiné à tuer, blesser ou menacer',
    explanation: 'Alinéa 2 : assimilation par destination.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Une arme factice est assimilée si elle :',
    options: [
      'Crée une confusion par ressemblance et sert à menacer',
      'Est cassée',
      'N’a aucune ressemblance',
    ],
    answer: 'Crée une confusion par ressemblance et sert à menacer',
    explanation: 'Alinéa 3 : ressemblance + menace/destination.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'L’utilisation d’un animal pour menacer est :',
    options: [
      'Assimilée à l’usage d’une arme',
      'Sans conséquence',
      'Toujours une contravention',
    ],
    answer: 'Assimilée à l’usage d’une arme',
    explanation: 'Alinéa 4 : animal assimilé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'La circonstance “arme” est :',
    options: ['Réelle', 'Personnelle', 'Uniquement mixte'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue à tous les participants.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Pour l’usage/menace, il faut que l’arme serve à :',
    options: ['Tuer, blesser ou menacer', 'Décorer', 'Travailler uniquement'],
    answer: 'Tuer, blesser ou menacer',
    explanation:
        'Le cours : pas seulement porteur, usage pour tuer/blesser/menacer.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Pour le “port”, il suffit que l’arme soit :',
    options: [
      'Apparente ou cachée',
      'Visible uniquement',
      'Déclarée en préfecture',
    ],
    answer: 'Apparente ou cachée',
    explanation: 'Le cours : port apparente ou cachée au moment des faits.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Une arme factice peut être considérée comme :',
    options: [
      'Une arme apparente ou cachée',
      'Jamais une arme',
      'Une arme uniquement si chargée',
    ],
    answer: 'Une arme apparente ou cachée',
    explanation:
        'Cass. crim. 05/08/1992 citée : arme factice = apparente ou cachée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Exemple d’arme par nature :',
    options: [
      'Grenade / arme à feu',
      'Batte de baseball utilisée pour jouer',
      'Stylo',
    ],
    answer: 'Grenade / arme à feu',
    explanation: 'Le cours cite armes à feu/engins explosifs/incendiaires.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Exemple d’arme par destination :',
    options: [
      'Marteau / véhicule / bouteille utilisés pour blesser',
      'Livre',
      'Oreiller',
    ],
    answer: 'Marteau / véhicule / bouteille utilisés pour blesser',
    explanation:
        'Objets du quotidien assimilés s’ils sont utilisés pour tuer/blesser/menacer.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Champ d’application : l’usage/menace d’arme peut aggraver :',
    options: [
      'Le viol (art. 222-24, 7°)',
      'Le divorce',
      'La contravention de 1re classe',
    ],
    answer: 'Le viol (art. 222-24, 7°)',
    explanation: 'Liste du cours : viol aggravé par arme.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // ESCALADE (art. 132-74 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade est :',
    options: [
      'S’introduire par-dessus une clôture ou par une ouverture non destinée à servir d’entrée',
      'Forcer une serrure',
      'Entrer par la porte principale',
    ],
    answer:
        'S’introduire par-dessus une clôture ou par une ouverture non destinée à servir d’entrée',
    explanation: 'Définition légale (art. 132-74).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade est une circonstance :',
    options: ['Réelle', 'Personnelle', 'Disciplinaire'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Elle suppose un endroit :',
    options: ['Clos', 'Public sans clôture', 'Virtuel uniquement'],
    answer: 'Clos',
    explanation: 'Lieu clos dont l’accès est interdit par une clôture.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Le moyen utilisé :',
    options: [
      'Importe peu (prévu, improvisé, trouvé)',
      'Doit être une échelle',
      'Doit être un grappin',
    ],
    answer: 'Importe peu (prévu, improvisé, trouvé)',
    explanation: 'Le cours : échelle, corde, échafaudage… peu importe.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade ne peut être réalisée que :',
    options: [
      'De l’extérieur vers l’intérieur',
      'De l’intérieur vers l’extérieur',
      'Dans les deux sens sans condition',
    ],
    answer: 'De l’extérieur vers l’intérieur',
    explanation: 'Le texte : “s’introduire…”.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Intrusion par une issue non destinée à servir d’entrée :',
    options: [
      'Peut caractériser l’escalade (fenêtre, soupirail, tunnel)',
      'Ne compte jamais',
      'Est uniquement une effraction',
    ],
    answer: 'Peut caractériser l’escalade (fenêtre, soupirail, tunnel)',
    explanation: 'Le cours cite ces exemples.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Champ d’application : l’escalade aggrave notamment :',
    options: [
      'Le vol (art. 311-5, 3°)',
      'Le harcèlement moral',
      'La diffamation',
    ],
    answer: 'Le vol (art. 311-5, 3°)',
    explanation: 'Liste du cours.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // INCAPACITÉ TOTALE DE TRAVAIL (I.T.T.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'L’I.T.T. pénale mesure :',
    options: [
      'La gravité des atteintes corporelles ou psychiques',
      'Le salaire perdu',
      'Le préjudice moral uniquement',
    ],
    answer: 'La gravité des atteintes corporelles ou psychiques',
    explanation: 'Définition au cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'L’I.T.T. pénale ne se confond pas avec :',
    options: [
      'L’arrêt de travail du droit social',
      'La garde à vue',
      'La mise en examen',
    ],
    answer: 'L’arrêt de travail du droit social',
    explanation: 'Le cours insiste sur la différence.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'Une personne sans emploi peut avoir une I.T.T. :',
    options: ['Oui', 'Non', 'Uniquement si elle est salariée'],
    answer: 'Oui',
    explanation: 'Enfant/retraité… possible.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'Pour la circonstance aggravante, l’incapacité doit être :',
    options: ['Totale', 'Partielle', 'Symbolique'],
    answer: 'Totale',
    explanation: 'Le cours : caractère total.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'L’I.T.T. s’étend :',
    options: [
      'À toute l’activité courante',
      'Uniquement au travail salarié',
      'Uniquement au sport',
    ],
    answer: 'À toute l’activité courante',
    explanation: 'Cass. crim. 7 mars 1967 citée : vie quotidienne.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'La durée se mesure par paliers, dont :',
    options: [
      '≤ 8 jours / > 8 jours',
      '≤ 2 jours / > 2 jours',
      '≤ 1 an uniquement',
    ],
    answer: '≤ 8 jours / > 8 jours',
    explanation: 'Paliers mentionnés au cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'Le juge :',
    options: [
      'A un pouvoir d’appréciation',
      'Doit suivre le certificat sans discussion',
      'Ne peut jamais ordonner d’expertise',
    ],
    answer: 'A un pouvoir d’appréciation',
    explanation: 'Le cours : appréciation, certificats + experts.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'La preuve est rapportée par :',
    options: [
      'La partie poursuivante',
      'La victime uniquement',
      'Le voisinage',
    ],
    answer: 'La partie poursuivante',
    explanation: 'Le cours : preuve par la partie poursuivante.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'Un effort ménager possible n’exclut pas l’I.T.T. totale :',
    options: ['Vrai', 'Faux', 'Uniquement si l’auteur avoue'],
    answer: 'Vrai',
    explanation:
        'Cass. crim. 22 nov. 1982 : tâches ménagères possibles ≠ exclure ITT.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // CRYPTOLOGIE (art. 132-79 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'L’utilisation d’un moyen de cryptologie est prévue par :',
    options: ['Art. 132-79 C.P.', 'Art. 132-72 C.P.', 'Art. 132-74 C.P.'],
    answer: 'Art. 132-79 C.P.',
    explanation: 'Référence du cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Cette circonstance aggravante est :',
    options: ['Réelle', 'Personnelle', 'Uniquement disciplinaire'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Le moyen de cryptologie sert à assurer :',
    options: [
      'La confidentialité / authentification / intégrité des données',
      'La vitesse du réseau',
      'La publicité des échanges',
    ],
    answer: 'La confidentialité / authentification / intégrité des données',
    explanation: 'Définition issue de la loi du 21 juin 2004 (art. 29) citée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Art. 132-79 s’applique :',
    options: [
      'À tous crimes et délits (commis ou tentés)',
      'Uniquement aux infractions sexuelles',
      'Uniquement aux contraventions',
    ],
    answer: 'À tous crimes et délits (commis ou tentés)',
    explanation: 'Portée générale selon le cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'L’exception d’application vaut si l’auteur/complice a remis :',
    options: [
      'La version en clair + conventions secrètes nécessaires',
      'Un téléphone neuf',
      'Un procès-verbal',
    ],
    answer: 'La version en clair + conventions secrètes nécessaires',
    explanation: 'Exception du texte : remise aux autorités.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question:
        'Selon Cass. crim. 11 oct. 2020, le code de déverrouillage peut être :',
    options: [
      'Une clé de déchiffrement si le téléphone a un moyen de cryptologie',
      'Toujours sans lien avec la cryptologie',
      'Un élément constitutif de l’escroquerie',
    ],
    answer:
        'Une clé de déchiffrement si le téléphone a un moyen de cryptologie',
    explanation: 'Jurisprudence citée dans le cours.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // AUTEUR ABUSANT DE SON AUTORITÉ
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Cette circonstance est :',
    options: ['Personnelle', 'Réelle', 'Une excuse de provocation'],
    answer: 'Personnelle',
    explanation: 'Le cours : personnelle, non étendue aux coauteurs.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Elle vise une autorité :',
    options: [
      'Générale due aux fonctions',
      'Familiale uniquement',
      'Résultant d’un hasard',
    ],
    answer: 'Générale due aux fonctions',
    explanation:
        'Le cours : autorité générale à l’égard d’un certain nombre de personnes.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Exemple de personnes concernées :',
    options: [
      'Professeurs / médecins / prêtres / marabouts',
      'Uniquement ascendants',
      'Uniquement policiers',
    ],
    answer: 'Professeurs / médecins / prêtres / marabouts',
    explanation: 'Exemples donnés au cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Les fonctions peuvent être :',
    options: [
      'Publiques ou privées',
      'Uniquement publiques',
      'Uniquement privées',
    ],
    answer: 'Publiques ou privées',
    explanation: 'Condition 2.2 du cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'L’aggravation suppose :',
    options: [
      'Un abus de l’autorité pour commettre l’acte',
      'Une simple connaissance de la victime',
      'Un dommage matériel uniquement',
    ],
    answer: 'Un abus de l’autorité pour commettre l’acte',
    explanation: 'Condition 2.3 : abus de l’autorité.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Champ d’application : figure notamment :',
    options: [
      'Viol (222-24, 5°) / agressions sexuelles (222-28, 3°)',
      'Vol simple',
      'Recel simple',
    ],
    answer: 'Viol (222-24, 5°) / agressions sexuelles (222-28, 3°)',
    explanation: 'Infractions listées au cours.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // AUTEUR ASCENDANT OU AYANT AUTORITÉ SUR LA VICTIME
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'Cette circonstance est :',
    options: ['Personnelle', 'Réelle', 'Toujours mixte'],
    answer: 'Personnelle',
    explanation: 'Le cours : personnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'Ascendants visés :',
    options: [
      'Père, mère, aïeux/aïeules (légitimes, naturels, adoptifs)',
      'Cousins uniquement',
      'Voisins',
    ],
    answer: 'Père, mère, aïeux/aïeules (légitimes, naturels, adoptifs)',
    explanation: 'Le cours précise la liste des ascendants directs.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'Les collatéraux (oncle/tante/cousin) :',
    options: [
      'Ne sont pas visés comme ascendants',
      'Sont toujours visés',
      'Sont visés seulement si mariage',
    ],
    answer: 'Ne sont pas visés comme ascendants',
    explanation:
        'Le cours : parents/alliés collatéraux non visés comme ascendants.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'Mais un collatéral peut entrer si :',
    options: [
      'Autorité de fait sur la victime',
      'Autorité publique uniquement',
      'Victime majeure uniquement',
    ],
    answer: 'Autorité de fait sur la victime',
    explanation:
        'Le cours : si oncle/tante/cousin ont autorité de fait, la circonstance peut jouer.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'L’autorité sur la victime peut être :',
    options: [
      'De droit ou de fait',
      'Uniquement de droit',
      'Uniquement de fait',
    ],
    answer: 'De droit ou de fait',
    explanation: 'Le cours distingue tuteur (droit) et autorité de fait.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'Exemple d’autorité de fait :',
    options: [
      'Concubin de la mère / cohabitation / chef scout',
      'Employé de banque',
      'Client d’un magasin',
    ],
    answer: 'Concubin de la mère / cohabitation / chef scout',
    explanation: 'Exemples donnés au cours.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // AUTEUR DÉPOSITAIRE DE L’AUTORITÉ PUBLIQUE / MISSION SERVICE PUBLIC (auteur)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique',
    question: 'Cette circonstance (auteur dépositaire) est :',
    options: ['Personnelle', 'Réelle', 'Une cause d’atténuation'],
    answer: 'Personnelle',
    explanation: 'Le cours : personnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique',
    question: 'Dépositaire de l’autorité publique = personne avec :',
    options: [
      'Pouvoir de décision fondé sur une parcelle d’autorité publique',
      'Simple mission privée',
      'Aucune prérogative',
    ],
    answer: 'Pouvoir de décision fondé sur une parcelle d’autorité publique',
    explanation: 'Définition citée au cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique',
    question: 'Exemples :',
    options: [
      'Policiers / gendarmes / douaniers / huissiers',
      'Uniquement enseignants',
      'Uniquement médecins',
    ],
    answer: 'Policiers / gendarmes / douaniers / huissiers',
    explanation: 'Exemples listés au cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique',
    question:
        'Personne chargée d’une mission de service public = personne qui :',
    options: [
      'Accomplit un service quelconque temporaire ou permanent, sans parcelle d’autorité publique',
      'A toujours un pouvoir de décision',
      'N’agit jamais sur réquisition',
    ],
    answer:
        'Accomplit un service quelconque temporaire ou permanent, sans parcelle d’autorité publique',
    explanation: 'Définition issue de la circulaire du 14 mai 1993 citée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique',
    question: 'Les faits doivent être commis :',
    options: [
      'Dans l’exercice ou à l’occasion de l’exercice des fonctions',
      'Uniquement hors service',
      'Uniquement à domicile',
    ],
    answer: 'Dans l’exercice ou à l’occasion de l’exercice des fonctions',
    explanation: 'Condition du cours : en service ou du fait de ses fonctions.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // VICTIME DÉPOSITAIRE DE L’AUTORITÉ PUBLIQUE (victime)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire autorité publique',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Toujours mixte'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue à tous les participants.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire autorité publique',
    question: 'Elle protège :',
    options: [
      'La personne et, à travers elle, la fonction',
      'Uniquement la personne',
      'Uniquement l’administration',
    ],
    answer: 'La personne et, à travers elle, la fonction',
    explanation: 'Le cours insiste sur la protection de la fonction.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire autorité publique',
    question: 'Condition : la qualité doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Toujours inconnue',
      'Sans importance',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation: 'Condition du cours : apparente ou connue.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire autorité publique',
    question: 'La victime doit être atteinte :',
    options: [
      'Dans l’exercice ou du fait de ses fonctions',
      'Uniquement en dehors de ses fonctions',
      'Uniquement de nuit',
    ],
    answer: 'Dans l’exercice ou du fait de ses fonctions',
    explanation: 'Condition 2.2 du cours.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // VICTIME CHARGÉE D’UNE MISSION DE SERVICE PUBLIC (victime)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission service public',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Une excuse de minorité'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission service public',
    question: 'Elle vise notamment :',
    options: [
      'Enseignants/personnels scolaires, agents transport public, professionnels de santé',
      'Uniquement magistrats',
      'Uniquement militaires',
    ],
    answer:
        'Enseignants/personnels scolaires, agents transport public, professionnels de santé',
    explanation: 'Liste détaillée dans le cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission service public',
    question: 'Condition temporelle : la victime doit être :',
    options: [
      'Dans l’exercice de ses fonctions',
      'Uniquement en congé',
      'Toujours hors service',
    ],
    answer: 'Dans l’exercice de ses fonctions',
    explanation: 'Le cours : en service / acte entrant dans ses attributions.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission service public',
    question: 'Condition de connaissance : qualité :',
    options: ['Apparente ou connue', 'Toujours ignorée', 'Jamais exigée'],
    answer: 'Apparente ou connue',
    explanation:
        'Le cours : même condition que vulnérabilité (apparente/connue).',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // VICTIME SE LIVRANT À LA PROSTITUTION
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Uniquement disciplinaire'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Condition : la personne doit se livrer à la prostitution =',
    options: [
      'Rapports sexuels contre rémunération',
      'Simple flirt',
      'Simple relation affective',
    ],
    answer: 'Rapports sexuels contre rémunération',
    explanation: 'Définition donnée au cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'La prostitution peut être :',
    options: ['Occasionnelle', 'Uniquement habituelle', 'Uniquement déclarée'],
    answer: 'Occasionnelle',
    explanation: 'Le cours : un acte unique peut suffire.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Les faits doivent être commis :',
    options: [
      'Dans l’exercice de cette activité',
      'Sans aucun lien avec l’activité',
      'Uniquement après la fin de l’activité',
    ],
    answer: 'Dans l’exercice de cette activité',
    explanation: 'Le cours exclut les contentieux sans lien avec l’activité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Texte créateur : loi du :',
    options: ['13 avril 2016', '21 juin 2004', '14 mai 1993'],
    answer: '13 avril 2016',
    explanation: 'Loi n°2016-444 citée au cours.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE TÉMOIN / VICTIME / PARTIE CIVILE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Cette circonstance est de nature :',
    options: ['Personnelle', 'Réelle', 'Toujours mixte'],
    answer: 'Personnelle',
    explanation: 'Le cours : dépend de l’intention et du but poursuivi.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Elle vise à protéger :',
    options: [
      'Le bon fonctionnement de la justice',
      'La circulation routière',
      'La propriété intellectuelle',
    ],
    answer: 'Le bon fonctionnement de la justice',
    explanation:
        'Le cours : pressions menacent l’administration de la justice.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Elle suppose qu’une infraction :',
    options: [
      'A été préalablement commise',
      'N’a jamais existé',
      'Est uniquement imaginaire',
    ],
    answer: 'A été préalablement commise',
    explanation:
        'Le cours : une nouvelle infraction vise à éviter/vengeance/dissuader.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Intention “préventive” =',
    options: [
      'Empêcher dénoncer/porter plainte/déposer',
      'Venger une déposition',
      'Réparer un dommage',
    ],
    answer: 'Empêcher dénoncer/porter plainte/déposer',
    explanation: 'Le cours : retirer plainte, influencer déclarations, etc.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Intention “répressive” =',
    options: [
      'Vengeance après plainte/dénonciation/déposition',
      'Empêcher avant plainte',
      'Accident pur',
    ],
    answer: 'Vengeance après plainte/dénonciation/déposition',
    explanation: 'Le cours : volonté de vengeance.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // VICTIME PARENTE D’UN DÉPOSITAIRE / PERSONNE PROTÉGÉE (proches)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Une cause d’excuse'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Sont protégés notamment :',
    options: [
      'Conjoint, ascendants, descendants en ligne directe',
      'Uniquement les frères/sœurs',
      'Uniquement les amis',
    ],
    answer: 'Conjoint, ascendants, descendants en ligne directe',
    explanation: 'Liste du cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Est aussi visée :',
    options: [
      'Toute personne vivant habituellement au domicile',
      'Toute personne croisée dans la rue',
      'Toute personne travaillant au même endroit',
    ],
    answer: 'Toute personne vivant habituellement au domicile',
    explanation: 'Le cours : personne hébergée, quel que soit lien.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Condition essentielle : faits commis :',
    options: [
      'En raison des fonctions exercées par le proche',
      'Au hasard',
      'Pour un motif sans lien',
    ],
    answer: 'En raison des fonctions exercées par le proche',
    explanation: 'Le cours : lien avec fonctions du proche.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Cela implique que l’auteur :',
    options: [
      'Connaissait la qualité du proche',
      'Ignorait totalement la qualité',
      'N’avait aucune intention',
    ],
    answer: 'Connaissait la qualité du proche',
    explanation: 'Le cours : condition de connaissance.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // CARACTÈRE RACISTE (art. 132-76)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'Le caractère raciste est défini par :',
    options: ['Art. 132-76 C.P.', 'Art. 132-77 C.P.', 'Art. 132-80 C.P.'],
    answer: 'Art. 132-76 C.P.',
    explanation: 'Référence du cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Toujours mixte'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'Elle vise l’appartenance (vraie ou supposée) à :',
    options: [
      'Prétendue race / ethnie / nation / religion',
      'Profession / diplôme',
      'Équipe sportive',
    ],
    answer: 'Prétendue race / ethnie / nation / religion',
    explanation: '4 catégories du cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'La matérialisation peut venir de :',
    options: [
      'Propos/écrits/images/objets/actes',
      'Uniquement un casier',
      'Uniquement un aveu',
    ],
    answer: 'Propos/écrits/images/objets/actes',
    explanation: 'Éléments objectifs listés.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'L’appartenance peut être :',
    options: [
      'Vraie ou supposée',
      'Uniquement vraie',
      'Uniquement prouvée par certificat',
    ],
    answer: 'Vraie ou supposée',
    explanation: 'Le cours : peu importe l’erreur de l’auteur.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // CARACTÈRE HOMOPHOBE / SEXISTE / TRANSPHOBE (art. 132-77)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe/sexiste/transphobe',
    question: 'Le caractère homophobe/sexiste est défini par :',
    options: ['Art. 132-77 C.P.', 'Art. 132-76 C.P.', 'Art. 132-79 C.P.'],
    answer: 'Art. 132-77 C.P.',
    explanation: 'Référence du cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe/sexiste/transphobe',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Uniquement mixte'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe/sexiste/transphobe',
    question: 'Elle peut être établie par :',
    options: [
      'Propos/écrits/images/objets/actes portant atteinte ou prouvant le mobile',
      'Uniquement une expertise',
      'Uniquement une plainte',
    ],
    answer:
        'Propos/écrits/images/objets/actes portant atteinte ou prouvant le mobile',
    explanation:
        'Le cours donne les 2 branches : atteinte ou preuve du mobile.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe/sexiste/transphobe',
    question: 'Elle vise notamment :',
    options: [
      'Homosexuels et personnes transsexuelles/transgenres/travesties',
      'Uniquement homosexuels',
      'Uniquement hétérosexuels',
    ],
    answer: 'Homosexuels et personnes transsexuelles/transgenres/travesties',
    explanation: 'Le cours l’indique expressément.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe/sexiste/transphobe',
    question: 'L’identité/orientation peut être :',
    options: ['Vraie ou supposée', 'Uniquement vraie', 'Toujours déclarée'],
    answer: 'Vraie ou supposée',
    explanation: 'Le cours : même si l’auteur se trompe.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // ------------------------------------------------------------
  // IMPORTANT : Tu as demandé +200 questions.
  // Dans un seul message, je suis limité par la taille max de réponse.
  // Ci-dessous je t’en donne déjà une GROSSE base (≈100+ items) +
  // un “PACK” de questions supplémentaires ultra denses pour arriver
  // au plus près de ta demande dans ce même format.
  // ------------------------------------------------------------
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // PACK DENSE — (questions courtes, même template) :
  // Thèmes : préméditation / guet-apens / arme / escalade / ITT / cryptologie /
  // autorité / victimes protégées / témoin-victime-PC / racisme / homophobie.
  // (Chaque item = 1 QuizQuestion)
  // => Tu peux copier-coller tel quel.
  //////////////////////////////////////////////////////////////////////////////

  // --- PRÉMÉDITATION (pack) ---
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation suppose une résolution :',
    options: ['Instantanée', 'Mûre et réfléchie', 'Toujours involontaire'],
    answer: 'Mûre et réfléchie',
    explanation: 'Volonté persistante et plan tracé à l’avance.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'L’intervalle de temps requis est :',
    options: ['Fixé à 48h', 'Non déterminé (plus ou moins long)', 'Fixé à 1h'],
    answer: 'Non déterminé (plus ou moins long)',
    explanation: 'Le cours : durée non déterminée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Une pulsion immédiate exclut en principe :',
    options: ['La réunion', 'La préméditation', 'La tentative'],
    answer: 'La préméditation',
    explanation: 'Acte prémédité ≠ spontané.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation doit être recherchée dans :',
    options: ['Les faits accompagnant l’acte', 'Le seul casier', 'La rumeur'],
    answer: 'Les faits accompagnant l’acte',
    explanation: 'Cass. crim. 4 sept. 1976 citée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Menaces avant les faits peuvent :',
    options: [
      'Matérialiser la préméditation',
      'L’exclure',
      'La remplacer par escalade',
    ],
    answer: 'Matérialiser la préméditation',
    explanation: 'Exemple du cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Achat de matériel pour commettre l’acte :',
    options: [
      'Indice de préméditation',
      'Indice de contravention',
      'Sans lien possible',
    ],
    answer: 'Indice de préméditation',
    explanation: 'Acte préparatoire typique.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation peut aggraver :',
    options: [
      'Uniquement délits',
      'Meurtre/empoisonnement/violences (selon loi)',
      'Uniquement contraventions',
    ],
    answer: 'Meurtre/empoisonnement/violences (selon loi)',
    explanation: 'Champ d’application du cours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Cass. crim. 9 janvier 1990 : exigence d’ :',
    options: ['Antériorité', 'Cohabitation', 'Récidive'],
    answer: 'Antériorité',
    explanation: 'Résolution antérieure à l’acte.',
    difficulty: 'Difficile',
  ),

  // --- GUET-APENS (pack) ---
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Guet-apens : “attendre” implique :',
    options: [
      'Aucune attente',
      'Une attente, durée non précisée',
      'Obligatoirement 2h',
    ],
    answer: 'Une attente, durée non précisée',
    explanation: 'Notion large non précisée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le lieu doit être :',
    options: ['Déterminé', 'Toujours public', 'Toujours privé'],
    answer: 'Déterminé',
    explanation: 'Définition : lieu déterminé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Guet-apens s’applique si la loi a :',
    options: [
      'Visé l’infraction',
      'Oublié l’infraction',
      'Interdit l’aggravation',
    ],
    answer: 'Visé l’infraction',
    explanation: 'La loi doit l’avoir expressément prévu.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est :',
    options: ['Personnel', 'Réel', 'Une immunité'],
    answer: 'Réel',
    explanation: 'Étendu aux auteurs/coauteurs/complices.',
    difficulty: 'Facile',
  ),

  // --- ARME (pack) ---
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Arme par nature = objet :',
    options: [
      'Conçu pour tuer/blesser',
      'Conçu pour cuisiner',
      'Conçu pour écrire',
    ],
    answer: 'Conçu pour tuer/blesser',
    explanation: 'Art. 132-75 al.1.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Arme par destination :',
    options: [
      'Objet du quotidien utilisé pour menacer',
      'Objet décoratif uniquement',
      'Objet interdit par principe',
    ],
    answer: 'Objet du quotidien utilisé pour menacer',
    explanation: 'Assimilation si utilisé/destiné à tuer/blesser/menacer.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Chaîne à vélo utilisée pour frapper =',
    options: ['Arme par nature', 'Arme par destination', 'Jamais une arme'],
    answer: 'Arme par destination',
    explanation: 'Objet du quotidien détourné.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Port d’arme =',
    options: [
      'Usage obligatoire',
      'Arme apparente ou cachée suffit',
      'Arme doit blesser',
    ],
    answer: 'Arme apparente ou cachée suffit',
    explanation: 'Port caractérisé sans usage.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Menacer avec une imitation réaliste :',
    options: [
      'Arme factice assimilée',
      'Aucun effet',
      'Toujours une contravention',
    ],
    answer: 'Arme factice assimilée',
    explanation: 'Ressemblance + menace.',
    difficulty: 'Moyenne',
  ),

  // --- ESCALADE (pack) ---
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Escalade = franchir :',
    options: [
      'Clôture / ouverture non prévue',
      'Une porte ouverte',
      'Un passage public',
    ],
    answer: 'Clôture / ouverture non prévue',
    explanation: 'Définition légale.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Une fenêtre peut caractériser :',
    options: ['L’escalade', 'La préméditation', 'La cryptologie'],
    answer: 'L’escalade',
    explanation: 'Ouverture non destinée à servir d’entrée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Lieu clos = accès interdit par :',
    options: ['Clôture', 'Téléphone', 'Facture'],
    answer: 'Clôture',
    explanation: 'Haie, mur, porte, portail, toiture…',
    difficulty: 'Facile',
  ),

  // --- ITT (pack) ---
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'I.T.T. =',
    options: ['Gravité atteintes', 'Salaire perdu', 'Nombre de PV'],
    answer: 'Gravité atteintes',
    explanation: 'Atteintes corporelles/psychiques.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'I.T.T. totale n’exige pas :',
    options: [
      'Aucune tâche possible',
      'Incapacité totale au sens pénal',
      'Une hospitalisation',
    ],
    answer: 'Aucune tâche possible',
    explanation: 'Tâches ménagères possibles ≠ exclure ITT.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'Preuve I.T.T. :',
    options: ['Certificats/expertises', 'Réseaux sociaux', 'Rumeur'],
    answer: 'Certificats/expertises',
    explanation: 'Le cours : certificats médicaux + experts.',
    difficulty: 'Moyenne',
  ),

  // --- CRYPTOLOGIE (pack) ---
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Cryptologie = moyen pour :',
    options: ['Confidentialité', 'Publicité', 'Aucune transformation'],
    answer: 'Confidentialité',
    explanation: 'Sécurité des communications/données.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: '132-79 : maximum de peine est :',
    options: ['Réduit', 'Relevé', 'Supprimé'],
    answer: 'Relevé',
    explanation: 'Le texte : “maximum … est relevé”.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Exception 132-79 si remise aux autorités :',
    options: [
      'Version en clair + conventions',
      'Uniquement le téléphone',
      'Uniquement le code PIN sans contexte',
    ],
    answer: 'Version en clair + conventions',
    explanation: 'Condition textuelle.',
    difficulty: 'Difficile',
  ),

  // --- AUTEUR ABUSANT DE SON AUTORITÉ (pack) ---
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Cette circonstance ne concerne pas :',
    options: [
      'Les ascendants (cadre différent)',
      'Les professeurs',
      'Les médecins',
    ],
    answer: 'Les ascendants (cadre différent)',
    explanation:
        'Le cours : ces personnes ne rentrent pas dans le cadre des ascendants.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Effets sur coauteurs :',
    options: ['S’étend', 'Ne s’étend pas', 'S’étend si complice'],
    answer: 'Ne s’étend pas',
    explanation: 'Personnelle : pas d’extension aux coauteurs.',
    difficulty: 'Moyenne',
  ),

  // --- AUTEUR ASCENDANT/AUTORITÉ (pack) ---
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'Ascendant =',
    options: ['Parent/aïeul (direct)', 'Cousin', 'Ami'],
    answer: 'Parent/aïeul (direct)',
    explanation: 'Ascendants directs uniquement.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'Tuteur d’un mineur = autorité :',
    options: ['De droit', 'De hasard', 'Impossible'],
    answer: 'De droit',
    explanation: 'Exemple du cours.',
    difficulty: 'Facile',
  ),

  // --- VICTIME PROSTITUTION (pack) ---
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Acte unique de prostitution :',
    options: [
      'Peut suffire',
      'Ne suffit jamais',
      'Suffit seulement si déclaré',
    ],
    answer: 'Peut suffire',
    explanation: 'Occasionnelle admise.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Sans lien avec activité : circonstance :',
    options: ['Écartée', 'Toujours retenue', 'Retenue si auteur mineur'],
    answer: 'Écartée',
    explanation: 'Doit être dans l’exercice de l’activité.',
    difficulty: 'Moyenne',
  ),

  // --- TÉMOIN/VICTIME/PARTIE CIVILE (pack) ---
  const QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Catégories visées :',
    options: [
      'Témoin/victime/partie civile',
      'Tout citoyen',
      'Uniquement avocat',
    ],
    answer: 'Témoin/victime/partie civile',
    explanation: 'Le cours : exclusivement ces personnes.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'But : influencer déclarations = intention :',
    options: ['Préventive', 'Répressive', 'Involontaire'],
    answer: 'Préventive',
    explanation: 'Empêcher/contraindre/retirer plainte.',
    difficulty: 'Moyenne',
  ),
  //////////////////////////////////////////////////////////////////////////////
  // Q001–Q020 — GÉNÉRALITÉS (circonstances aggravantes, réelles/personnelles)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance n’est aggravante que lorsque :',
    options: [
      'Le juge le décide librement',
      'La loi le décide expressément',
      'La victime le demande',
    ],
    answer: 'La loi le décide expressément',
    explanation:
        'Le cours précise qu’une circonstance n’est aggravante que lorsque la loi le décide expressément.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Les circonstances aggravantes sont énumérées par la loi :',
    options: [
      'De manière limitative',
      'De manière indicative',
      'Uniquement par circulaire',
    ],
    answer: 'De manière limitative',
    explanation:
        'Le cours indique que la loi les énumère de manière limitative.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance aggravante peut :',
    options: [
      'Modifier la nature de la peine encourue',
      'Supprimer l’infraction',
      'Empêcher toute poursuite',
    ],
    answer: 'Modifier la nature de la peine encourue',
    explanation:
        'Le cours précise qu’elle peut modifier la nature de la peine encourue.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance aggravante peut aussi :',
    options: [
      'Modifier la nature de l’infraction',
      'Transformer un crime en contravention',
      'Rendre l’acte licite',
    ],
    answer: 'Modifier la nature de l’infraction',
    explanation:
        'Le cours indique qu’en modifiant la peine, elle peut modifier la nature de l’infraction.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Les circonstances aggravantes dites “spéciales” :',
    options: [
      'S’appliquent à toutes les infractions',
      'Ne s’appliquent qu’aux infractions visées',
      'S’appliquent seulement aux crimes',
    ],
    answer: 'Ne s’appliquent qu’aux infractions visées',
    explanation:
        'Le cours précise qu’elles ne s’appliquent qu’aux infractions pour lesquelles la loi les prévoit.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance aggravante “réelle” :',
    options: [
      'S’attache à la matérialité du fait',
      'Ne vaut que pour l’auteur principal',
      'Dépend du casier judiciaire',
    ],
    answer: 'S’attache à la matérialité du fait',
    explanation:
        'Le cours : les circonstances réelles s’attachent à la matérialité du fait poursuivi.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance aggravante “réelle” vaut :',
    options: [
      'Pour tous les participants',
      'Uniquement pour le complice',
      'Uniquement pour la victime',
    ],
    answer: 'Pour tous les participants',
    explanation:
        'Le cours : elle ne peut exister pour l’un sans exister pour les autres (auteurs/coauteurs/complices).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance aggravante “personnelle” :',
    options: [
      'Augmente uniquement la culpabilité de celui qui agit',
      'S’attache à l’arme utilisée',
      'S’étend toujours aux coauteurs',
    ],
    answer: 'Augmente uniquement la culpabilité de celui qui agit',
    explanation:
        'Le cours : les circonstances personnelles sont liées à la personnalité/qualité de l’auteur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question:
        'Exemple typique de circonstance “purement” personnelle (cours) :',
    options: ['La récidive', 'L’escalade', 'Le guet-apens'],
    answer: 'La récidive',
    explanation:
        'Le cours cite la récidive comme circonstance “purement” personnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question:
        'Selon la jurisprudence citée, certaines circonstances personnelles liées à la qualité :',
    options: [
      'Peuvent être applicables au complice',
      'Sont toujours inapplicables au complice',
      'Rendent l’acte non punissable',
    ],
    answer: 'Peuvent être applicables au complice',
    explanation:
        'Le cours cite Cass. crim., 7 septembre 2005 : circonstances liées à la qualité de l’auteur principal applicables au complice.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Le “principe de l’emprunt de criminalité” signifie (cours) :',
    options: [
      'Le complice répond des circonstances qualifiant l’acte',
      'Le complice n’est jamais punissable',
      'Le complice est jugé uniquement civilement',
    ],
    answer: 'Le complice répond des circonstances qualifiant l’acte',
    explanation:
        'Le cours indique que le complice encourt la responsabilité des circonstances qualifiant l’acte poursuivi.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une même circonstance peut aggraver :',
    options: [
      'Des crimes distincts',
      'Un seul crime maximum',
      'Uniquement des délits',
    ],
    answer: 'Des crimes distincts',
    explanation:
        'Le cours cite Cass. crim., 7 février 2007 sur l’aggravation possible de crimes distincts.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Les circonstances aggravantes peuvent tenir :',
    options: [
      'Aux conséquences, à la victime, à l’auteur, aux moyens, au lieu',
      'Uniquement au lieu',
      'Uniquement à la victime',
    ],
    answer: 'Aux conséquences, à la victime, à l’auteur, aux moyens, au lieu',
    explanation:
        'Le cours donne ces grandes familles de circonstances aggravantes.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Le cours traite notamment des circonstances des articles :',
    options: [
      '132-71 à 132-80 C.P.',
      '111-1 à 111-5 C.P.',
      '223-1 à 223-3 C.P.',
    ],
    answer: '132-71 à 132-80 C.P.',
    explanation:
        'Le cours annonce le périmètre : articles 132-71 à 132-80 du code pénal (et communes).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Les circonstances “mixtes” (doctrine) tiennent :',
    options: [
      'À la fois à la qualité de l’auteur et à la criminalité de l’acte',
      'Uniquement à l’âge de la victime',
      'Uniquement au lieu',
    ],
    answer: 'À la fois à la qualité de l’auteur et à la criminalité de l’acte',
    explanation: 'Le cours mentionne cette catégorie doctrinale “mixte”.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question:
        'Une circonstance aggravante peut exister sans que le complice l’ait connue (cours) :',
    options: [
      'Oui, pour les circonstances qualifiant l’acte',
      'Non, jamais',
      'Uniquement pour les contraventions',
    ],
    answer: 'Oui, pour les circonstances qualifiant l’acte',
    explanation:
        'Le cours cite Cass. crim., 21 mai 1996 : pas nécessaire qu’elles aient été connues du complice.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance aggravante réelle :',
    options: [
      'Ne peut pas être séparée du fait poursuivi',
      'Dépend uniquement du mobile',
      'Dépend du lien conjugal',
    ],
    answer: 'Ne peut pas être séparée du fait poursuivi',
    explanation:
        'Le cours : elle s’attache à la matérialité du fait dont elle ne peut être séparée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance personnelle s’étend aux coauteurs :',
    options: [
      'Toujours',
      'Jamais, par principe',
      'Uniquement si la loi le prévoit expressément',
    ],
    answer: 'Jamais, par principe',
    explanation:
        'Le cours : personnelle = augmente la culpabilité de celui qui agit, sans extension aux coauteurs (principe).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'La loi détermine, pour chaque circonstance, l’aggravation :',
    options: ['De manière précise', 'Au choix de l’auteur', 'Sans encadrement'],
    answer: 'De manière précise',
    explanation:
        'Le cours : la loi détermine pour chaque cas l’aggravation de la peine encourue.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance ne peut pas :',
    options: [
      'Être ajoutée par analogie',
      'Être prévue par la loi',
      'Aggraver une peine',
    ],
    answer: 'Être ajoutée par analogie',
    explanation:
        'Le cours insiste sur l’énumération limitative et le principe de légalité : pas d’extension par analogie.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q021–Q040 — PRÉMÉDITATION (art. 132-72 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation est :',
    options: [
      'Le dessein formé avant l’action',
      'L’acte commis par surprise',
      'Le fait d’être armé',
    ],
    answer: 'Le dessein formé avant l’action',
    explanation: 'Définition de l’art. 132-72 C.P. reprise au cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation vise :',
    options: [
      'Un crime ou un délit déterminé',
      'Toute contravention',
      'Toute faute civile',
    ],
    answer: 'Un crime ou un délit déterminé',
    explanation: 'Le cours : crime ou délit déterminé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation traduit une volonté :',
    options: ['Mûre et réfléchie', 'Spontanée', 'Purement accidentelle'],
    answer: 'Mûre et réfléchie',
    explanation: 'Le cours : résolution d’agir, volonté mûre et réfléchie.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'L’antériorité de la résolution à l’acte est :',
    options: ['Nécessaire', 'Indifférente', 'Interdite'],
    answer: 'Nécessaire',
    explanation:
        'Le cours cite Cass. crim., 9 janvier 1990 : antériorité nécessaire.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'L’intervalle de temps entre résolution et exécution est :',
    options: [
      'Fixé par la loi',
      'Plus ou moins long, non déterminé',
      'Toujours 24 heures',
    ],
    answer: 'Plus ou moins long, non déterminé',
    explanation: 'Le cours indique que cet intervalle n’est pas déterminé.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Un acte prémédité est :',
    options: [
      'Médité et préparé',
      'Toujours impulsif',
      'Toujours involontaire',
    ],
    answer: 'Médité et préparé',
    explanation: 'Le cours : non spontané, pas une pulsion.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation peut viser :',
    options: [
      'Une infraction commise ou tentée',
      'Uniquement une infraction consommée',
      'Uniquement un crime',
    ],
    answer: 'Une infraction commise ou tentée',
    explanation: 'Le cours : indifféremment commise ou tentée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation se matérialise par :',
    options: [
      'Des faits/circonstances précédant l’acte',
      'Uniquement l’aveu',
      'Uniquement le casier',
    ],
    answer: 'Des faits/circonstances précédant l’acte',
    explanation:
        'Le cours : elle se recherche dans l’intervalle précédant l’acte.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Exemples de matérialisation (cours) :',
    options: [
      'Actes préparatoires, menaces, confidences',
      'Simple maladresse',
      'Oubli involontaire',
    ],
    answer: 'Actes préparatoires, menaces, confidences',
    explanation: 'Exemples cités dans le cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La jurisprudence qualifie parfois la préméditation :',
    options: [
      'Tantôt réelle, tantôt personnelle',
      'Toujours réelle',
      'Toujours personnelle',
    ],
    answer: 'Tantôt réelle, tantôt personnelle',
    explanation: 'Le cours signale des hésitations jurisprudentielles.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Le meurtre avec préméditation est qualifié :',
    options: ['D’assassinat', 'D’homicide involontaire', 'De contravention'],
    answer: 'D’assassinat',
    explanation:
        'Le cours : meurtre + préméditation = assassinat (art. 221-3).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation est une forme de :',
    options: ['Résolution d’agir', 'Force majeure', 'Erreur de droit'],
    answer: 'Résolution d’agir',
    explanation: 'Le cours : elle se traduit par une résolution d’agir.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation exclut en principe :',
    options: ['La spontanéité', 'La préparation', 'La persistance'],
    answer: 'La spontanéité',
    explanation: 'Le cours : l’acte prémédité n’est pas spontané.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Une préparation visant une seule infraction peut suffire :',
    options: [
      'Oui',
      'Non, il faut plusieurs infractions',
      'Seulement pour les contraventions',
    ],
    answer: 'Oui',
    explanation:
        'Le cours : elle vise une infraction commise ou tentée, même unique.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation peut aggraver (cours) :',
    options: ['Le meurtre', 'La diffamation', 'Le recel'],
    answer: 'Le meurtre',
    explanation: 'Champ d’application : meurtre (assassinat).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation peut aussi aggraver :',
    options: ['L’empoisonnement', 'Le stationnement gênant', 'La mendicité'],
    answer: 'L’empoisonnement',
    explanation: 'Le cours : empoisonnement (art. 221-5 al. 3).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation peut être déduite :',
    options: [
      'De la nature complexe de l’acte',
      'Du seul silence de l’auteur',
      'De la tenue vestimentaire',
    ],
    answer: 'De la nature complexe de l’acte',
    explanation:
        'Le cours cite la complexité traduisant une nécessaire préparation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Une confidence préalable sur l’intention de commettre l’acte :',
    options: [
      'Peut contribuer à caractériser la préméditation',
      'L’exclut automatiquement',
      'Ne peut jamais être prise en compte',
    ],
    answer: 'Peut contribuer à caractériser la préméditation',
    explanation: 'Le cours cite les confidences parmi les indices.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation doit être appréciée :',
    options: [
      'Dans l’intervalle précédant l’acte',
      'Uniquement après l’acte',
      'Uniquement au jugement',
    ],
    answer: 'Dans l’intervalle précédant l’acte',
    explanation:
        'Le cours : elle se recherche dans les faits qui précèdent/accompagnent l’acte.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q041–Q060 — GUET-APENS (art. 132-71-1 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens consiste à :',
    options: [
      'Attendre une ou plusieurs personnes dans un lieu déterminé pour commettre une ou plusieurs infractions',
      'Agir sous ivresse',
      'Entrer par effraction',
    ],
    answer:
        'Attendre une ou plusieurs personnes dans un lieu déterminé pour commettre une ou plusieurs infractions',
    explanation: 'Définition de l’art. 132-71-1 C.P. reprise au cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est une circonstance aggravante :',
    options: ['Réelle', 'Personnelle', 'Disciplinaire'],
    answer: 'Réelle',
    explanation:
        'Le cours : circonstance aggravante réelle, étendue à tous les participants.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est proche de :',
    options: ['L’embuscade', 'La récidive', 'La contrainte'],
    answer: 'L’embuscade',
    explanation: 'Le cours compare guet-apens et embuscade.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Différence principale avec l’embuscade : l’embuscade est :',
    options: [
      'Une infraction autonome',
      'Une simple circonstance aggravante',
      'Une excuse légale',
    ],
    answer: 'Une infraction autonome',
    explanation:
        'Le cours : embuscade = infraction autonome même au stade des actes préparatoires.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'L’article qui définit le guet-apens est :',
    options: ['132-71-1 C.P.', '132-72 C.P.', '132-75 C.P.'],
    answer: '132-71-1 C.P.',
    explanation: 'Référence donnée dans le cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le texte précise une durée minimale d’attente :',
    options: [
      'Oui, 10 minutes',
      'Non, aucune durée minimale n’est précisée',
      'Oui, 24 heures',
    ],
    answer: 'Non, aucune durée minimale n’est précisée',
    explanation: 'Le cours : notion très large, pas de durée minimum fixée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le texte précise la nature du lieu (public/privé) :',
    options: [
      'Oui, uniquement public',
      'Non, il ne précise pas',
      'Oui, uniquement privé',
    ],
    answer: 'Non, il ne précise pas',
    explanation: 'Le cours : pas de précision sur la nature du lieu.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'La qualité de la victime (profession/âge) est :',
    options: ['Indifférente', 'Limitée aux mineurs', 'Limitée aux policiers'],
    answer: 'Indifférente',
    explanation: 'Le cours : “toute personne quelle que soit sa qualité”.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est une forme particulière de :',
    options: ['Préméditation', 'Vulnérabilité', 'Récidive'],
    answer: 'Préméditation',
    explanation: 'Le cours : forme particulière de préméditation.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le but poursuivi est caractérisé par :',
    options: [
      'Des actes préparatoires en relation avec l’infraction',
      'Un accident de parcours',
      'Un simple regret',
    ],
    answer: 'Des actes préparatoires en relation avec l’infraction',
    explanation:
        'Le cours : actes préparatoires déterminent le caractère délibéré du “piège”.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le nombre de victimes possibles est :',
    options: ['Une ou plusieurs', 'Uniquement une', 'Uniquement deux'],
    answer: 'Une ou plusieurs',
    explanation: 'Le cours : “une ou plusieurs personnes”.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens peut aggraver des infractions :',
    options: [
      'Comprises dans une liste prévue par la loi',
      'Toutes infractions sans texte',
      'Uniquement les contraventions',
    ],
    answer: 'Comprises dans une liste prévue par la loi',
    explanation:
        'Le cours : application si la loi a expressément visé les infractions.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens peut aggraver :',
    options: ['Le meurtre', 'Le vol simple sans texte', 'La diffamation'],
    answer: 'Le meurtre',
    explanation: 'Le cours : champ d’application inclut le meurtre.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens peut aussi aggraver :',
    options: [
      'Les tortures ou actes de barbarie',
      'Le non-respect d’un feu rouge',
      'Le tapage nocturne',
    ],
    answer: 'Les tortures ou actes de barbarie',
    explanation:
        'Le cours : champ d’application inclut tortures/actes de barbarie.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens peut également aggraver :',
    options: [
      'Certaines violences',
      'Les infractions de presse',
      'Le droit du travail',
    ],
    answer: 'Certaines violences',
    explanation:
        'Le cours : champ d’application inclut violences (articles listés).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens peut aggraver l’empoisonnement :',
    options: ['Oui', 'Non', 'Uniquement si la victime est mineure'],
    answer: 'Oui',
    explanation: 'Le cours : champ d’application inclut l’empoisonnement.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est apprécié :',
    options: [
      'Après commission ou tentative d’infractions visées',
      'Avant toute infraction',
      'Uniquement au stade civil',
    ],
    answer: 'Après commission ou tentative d’infractions visées',
    explanation:
        'Le cours : la question se pose après commission ou tentative de certaines infractions.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens suppose un “lieu déterminé” :',
    options: ['Oui', 'Non', 'Seulement en milieu scolaire'],
    answer: 'Oui',
    explanation: 'Définition : attente dans un lieu déterminé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens s’étend aux complices car il est :',
    options: ['Réel', 'Personnel', 'Mixte au sens légal obligatoire'],
    answer: 'Réel',
    explanation:
        'Le cours : circonstance réelle → effets sur auteurs/coauteurs/complices.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q061–Q080 — BANDE ORGANISÉE (art. 132-71 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée est définie par :',
    options: [
      'L’article 132-71 C.P.',
      'L’article 132-72 C.P.',
      'L’article 132-75 C.P.',
    ],
    answer: 'L’article 132-71 C.P.',
    explanation:
        'Le cours indique que l’article 132-71 du code pénal définit la bande organisée.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'Constitue une bande organisée :',
    options: [
      'Tout groupement/entente en vue de préparer une ou plusieurs infractions, caractérisée par des faits matériels',
      'Toute réunion fortuite',
      'Toute dispute',
    ],
    answer:
        'Tout groupement/entente en vue de préparer une ou plusieurs infractions, caractérisée par des faits matériels',
    explanation: 'Définition légale reprise au cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée est une circonstance :',
    options: ['Réelle', 'Personnelle', 'Uniquement civile'],
    answer: 'Réelle',
    explanation:
        'Le cours : circonstance aggravante réelle, étendue à tous les participants.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée est proche de :',
    options: [
      'L’association de malfaiteurs',
      'La légitime défense',
      'La tentative',
    ],
    answer: 'L’association de malfaiteurs',
    explanation: 'Le cours rapproche les deux notions.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'Différence majeure : l’association de malfaiteurs est :',
    options: [
      'Une infraction autonome',
      'Une simple circonstance aggravante',
      'Une contravention',
    ],
    answer: 'Une infraction autonome',
    explanation:
        'Le cours : association de malfaiteurs = infraction autonome même au stade préparatoire.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée se pose :',
    options: [
      'Après commission ou tentative de certaines infractions',
      'Avant tout acte',
      'Uniquement en matière civile',
    ],
    answer: 'Après commission ou tentative de certaines infractions',
    explanation:
        'Le cours précise que la question se pose après commission ou tentative.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée est une forme particulière de :',
    options: ['Préméditation', 'Vulnérabilité', 'Récidive'],
    answer: 'Préméditation',
    explanation: 'Le cours : forme particulière de préméditation.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'À la différence de la réunion, la bande organisée suppose :',
    options: [
      'Une préparation par des moyens matériels',
      'Un hasard complet',
      'Une absence de concertation',
    ],
    answer: 'Une préparation par des moyens matériels',
    explanation:
        'Le cours cite Cass. crim., 14 mai 1993 : moyens matériels impliquant organisation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La réunion a un caractère :',
    options: [
      'Fortuit et occasionnel',
      'Toujours planifié',
      'Toujours hiérarchisé',
    ],
    answer: 'Fortuit et occasionnel',
    explanation: 'Le cours : réunion = concertation simple sans préméditation.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'Condition : il faut une résolution d’agir en commun :',
    options: [
      'Antérieure à l’action',
      'Postérieure à l’action',
      'Sans importance',
    ],
    answer: 'Antérieure à l’action',
    explanation:
        'Le cours : résolution d’agir en commun antérieure à l’action.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée implique :',
    options: ['Un plan concerté', 'Une impulsion', 'Une erreur'],
    answer: 'Un plan concerté',
    explanation:
        'Le cours cite Cass. crim., 30 novembre 2005 : “plan concerté”.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question:
        'Une organisation “structurée et hiérarchisée” est un indice de :',
    options: ['Bande organisée', 'Réunion', 'Contravention'],
    answer: 'Bande organisée',
    explanation:
        'Le cours cite la nécessité d’une organisation structurée et hiérarchisée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question:
        'La bande organisée nécessite de démontrer une participation continuelle :',
    options: ['Non', 'Oui toujours', 'Oui uniquement pour les crimes'],
    answer: 'Non',
    explanation:
        'Le cours : pas nécessaire de démontrer une participation continuelle à l’organisation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question:
        'Le nombre de personnes nécessaire est fixé par la jurisprudence :',
    options: [
      'Oui, exactement 5',
      'Non, pas de nombre fixé',
      'Oui, exactement 2',
    ],
    answer: 'Non, pas de nombre fixé',
    explanation:
        'Le cours : la jurisprudence ne se prononce pas sur un nombre précis.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question:
        'Selon le cours, pour constituer une bande organisée, il est nécessaire d’être :',
    options: ['Plus de deux', 'Seul', 'Exactement deux'],
    answer: 'Plus de deux',
    explanation: 'Le cours précise qu’il est nécessaire d’être plus de deux.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La Convention ONU évoquée parle d’un groupe de :',
    options: ['Trois personnes ou plus', 'Deux personnes', 'Une personne'],
    answer: 'Trois personnes ou plus',
    explanation:
        'Le cours cite la définition ONU : groupe structuré de trois personnes ou plus.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La seule constitution d’une équipe peut être insuffisante si :',
    options: [
      'Absence de structure existant depuis un certain temps',
      'Présence d’un chef',
      'Présence d’un véhicule',
    ],
    answer: 'Absence de structure existant depuis un certain temps',
    explanation:
        'Le cours cite Cass. crim., 8 juillet 2015 : critère de structure dans le temps.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'Les actes préparatoires peuvent être :',
    options: [
      'Acquisition de matériel / recrutement / plan d’exécution',
      'Uniquement un aveu',
      'Uniquement une plainte',
    ],
    answer: 'Acquisition de matériel / recrutement / plan d’exécution',
    explanation: 'Le cours donne ces exemples d’actes préparatoires.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée peut aggraver (exemple du cours) :',
    options: [
      'Le vol',
      'Le divorce',
      'Le non-respect d’une limitation de vitesse',
    ],
    answer: 'Le vol',
    explanation:
        'Le cours liste le vol (art. 311-9) parmi les infractions aggravées.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée peut aussi aggraver :',
    options: ['L’escroquerie', 'La diffamation', 'Le tapage'],
    answer: 'L’escroquerie',
    explanation: 'Le cours : escroquerie (art. 313-2) dans la liste.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q081–Q100 — ARME + ESCALADE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Selon l’art. 132-75, est une arme :',
    options: [
      'Tout objet conçu pour tuer ou blesser',
      'Tout objet métallique',
      'Tout objet volumineux',
    ],
    answer: 'Tout objet conçu pour tuer ou blesser',
    explanation: 'Le cours : arme par nature (alinéa 1).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Les armes par nature comprennent notamment :',
    options: [
      'Armes à feu et engins explosifs/incendiaires',
      'Uniquement des outils',
      'Uniquement des véhicules',
    ],
    answer: 'Armes à feu et engins explosifs/incendiaires',
    explanation:
        'Le cours cite armes à feu, engins explosifs/incendiaires, gaz toxiques.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Les armes blanches (cours) incluent :',
    options: [
      'Poignards, matraques',
      'Téléphones, ordinateurs',
      'Clés USB, cartes bancaires',
    ],
    answer: 'Poignards, matraques',
    explanation:
        'Le cours cite des exemples d’armes blanches tranchantes/perçantes/contondantes.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Une arme par destination est :',
    options: [
      'Un objet du quotidien utilisé pour tuer/blesser/menacer',
      'Un objet conçu pour tuer',
      'Un objet purement décoratif',
    ],
    answer: 'Un objet du quotidien utilisé pour tuer/blesser/menacer',
    explanation:
        'Le cours : assimilation si objet susceptible de danger est utilisé/destiné à tuer/blesser/menacer.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Un véhicule automobile utilisé pour blesser peut être :',
    options: [
      'Une arme par destination',
      'Jamais une arme',
      'Uniquement une arme factice',
    ],
    answer: 'Une arme par destination',
    explanation:
        'Le cours cite le véhicule automobile comme exemple d’arme par destination.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Une arme factice est assimilée si elle :',
    options: [
      'Crée une confusion par ressemblance et sert à menacer',
      'Est seulement en plastique',
      'Est cachée chez soi',
    ],
    answer: 'Crée une confusion par ressemblance et sert à menacer',
    explanation:
        'Le cours : ressemblance de nature à créer confusion + usage/destination pour menacer.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'L’utilisation d’un animal pour menacer est :',
    options: [
      'Assimilée à l’usage d’une arme',
      'Sans effet',
      'Une circonstance personnelle',
    ],
    answer: 'Assimilée à l’usage d’une arme',
    explanation:
        'Le cours : l’utilisation d’un animal pour tuer/blesser/menacer est assimilée à une arme.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'La circonstance “arme” est :',
    options: ['Réelle', 'Personnelle', 'Une excuse légale'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Pour l’usage/menace d’arme, il faut :',
    options: [
      'Que l’arme soit utilisée pour tuer/blesser/menacer',
      'Seulement posséder l’arme',
      'Seulement l’avoir achetée',
    ],
    answer: 'Que l’arme soit utilisée pour tuer/blesser/menacer',
    explanation:
        'Le cours : être porteur ne suffit pas, il faut usage pour tuer/blesser/menacer.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Pour le port d’arme, il suffit :',
    options: [
      'D’être porteur d’une arme apparente ou cachée',
      'D’avoir menacé avec l’arme',
      'D’avoir blessé avec l’arme',
    ],
    answer: 'D’être porteur d’une arme apparente ou cachée',
    explanation: 'Le cours : port apparente ou cachée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Le port illégal d’arme est :',
    options: [
      'Une infraction autonome possible',
      'Toujours une circonstance aggravante',
      'Toujours dépénalisé',
    ],
    answer: 'Une infraction autonome possible',
    explanation:
        'Le cours : l’arme peut aussi constituer l’élément matériel d’infractions autonomes (ex. port illégal).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade est :',
    options: [
      'S’introduire par-dessus une clôture ou par une ouverture non destinée à servir d’entrée',
      'Forcer une serrure',
      'Entrer avec autorisation',
    ],
    answer:
        'S’introduire par-dessus une clôture ou par une ouverture non destinée à servir d’entrée',
    explanation: 'Définition de l’art. 132-74 reprise au cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade est une circonstance :',
    options: ['Réelle', 'Personnelle', 'Exclusivement civile'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Elle suppose un endroit :',
    options: ['Clos', 'Toujours ouvert', 'Virtuel uniquement'],
    answer: 'Clos',
    explanation:
        'Le cours : endroit clos dont l’accès est interdit aux tiers par une clôture.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Le moyen utilisé (échelle, corde…) :',
    options: ['Importe peu', 'Doit être une échelle', 'Doit être un grappin'],
    answer: 'Importe peu',
    explanation: 'Le cours : moyen prévu, improvisé ou trouvé par hasard.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Entrer par une fenêtre peut relever de :',
    options: ['L’escalade', 'La cryptologie', 'La vulnérabilité'],
    answer: 'L’escalade',
    explanation:
        'Le cours : issue non destinée à servir d’entrée (fenêtre, soupirail…).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'La circonstance d’escalade se réalise :',
    options: [
      'De l’extérieur vers l’intérieur',
      'De l’intérieur vers l’extérieur',
      'Dans les deux sens indifféremment',
    ],
    answer: 'De l’extérieur vers l’intérieur',
    explanation:
        'Le cours : “s’introduire…”, donc de l’extérieur vers l’intérieur.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Comme l’effraction, l’escalade implique :',
    options: [
      'Un moyen illicite pour pénétrer dans un lieu clos',
      'Une autorisation de la victime',
      'Un mandat',
    ],
    answer: 'Un moyen illicite pour pénétrer dans un lieu clos',
    explanation:
        'Le cours compare escalade et effraction : moyen illicite pour pénétrer.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade peut aggraver :',
    options: ['Le vol', 'Le mariage', 'La grève'],
    answer: 'Le vol',
    explanation: 'Le cours : vol (art. 311-5 3°).',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q101–Q120 — ITT + MORT + MUTILATION/INFIRMITÉ
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'L’I.T.T. pénale mesure :',
    options: [
      'La gravité des atteintes corporelles ou psychiques',
      'Le salaire perdu',
      'Le nombre de jours d’hospitalisation uniquement',
    ],
    answer: 'La gravité des atteintes corporelles ou psychiques',
    explanation: 'Le cours : l’I.T.T. mesure la gravité des atteintes subies.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'L’I.T.T. pénale ne doit pas être confondue avec :',
    options: [
      'L’arrêt de travail du droit social',
      'La détention provisoire',
      'La prescription',
    ],
    answer: 'L’arrêt de travail du droit social',
    explanation: 'Le cours distingue I.T.T. pénale et arrêt de travail social.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question:
        'Une victime sans activité professionnelle peut avoir une I.T.T. :',
    options: ['Oui', 'Non', 'Uniquement si mineure'],
    answer: 'Oui',
    explanation:
        'Le cours : enfant/retraité… peut se voir prescrire une I.T.T.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'Pour constituer la circonstance, l’incapacité doit être :',
    options: ['Totale', 'Partielle', 'Mentale uniquement'],
    answer: 'Totale',
    explanation:
        'Le cours : l’I.T.T. doit être totale pour constituer la circonstance.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'L’I.T.T. s’étend :',
    options: [
      'À l’activité courante et aux efforts de la vie quotidienne',
      'Uniquement au travail salarié',
      'Uniquement au sport',
    ],
    answer: 'À l’activité courante et aux efforts de la vie quotidienne',
    explanation:
        'Le cours (jurisprudence) : s’étend à toute l’activité courante.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'La durée de l’I.T.T. est prise en compte par :',
    options: ['Paliers', 'Pourcentage fixe', 'Appréciation libre sans seuil'],
    answer: 'Paliers',
    explanation: 'Le cours : paliers (≤8j, >8j, ≤3 mois, >3 mois).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'La preuve de l’I.T.T. est rapportée :',
    options: ['Par la partie poursuivante', 'Par l’auteur', 'Par la presse'],
    answer: 'Par la partie poursuivante',
    explanation:
        'Le cours : la preuve doit être rapportée par la partie poursuivante.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'Le juge peut se baser sur :',
    options: [
      'Certificats médicaux et rapports d’experts',
      'Uniquement l’aveu',
      'Uniquement la plainte',
    ],
    answer: 'Certificats médicaux et rapports d’experts',
    explanation:
        'Le cours : certificats et expertises, avec pouvoir d’appréciation du juge.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — La mort',
    question:
        'La circonstance “ayant entraîné la mort sans intention de la donner” suppose :',
    options: [
      'Absence d’intention homicide',
      'Intention de tuer',
      'Préméditation obligatoire',
    ],
    answer: 'Absence d’intention homicide',
    explanation:
        'Le cours : l’auteur n’a jamais voulu donner volontairement la mort.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — La mort',
    question: 'La circonstance “mort” est :',
    options: ['Réelle', 'Personnelle', 'Toujours mixte'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — La mort',
    question: 'Condition essentielle : il faut une relation :',
    options: [
      'De cause à effet entre l’acte et le décès',
      'De parenté',
      'De voisinage',
    ],
    answer: 'De cause à effet entre l’acte et le décès',
    explanation:
        'Le cours cite Cass. crim., 17 janvier 1991 : relation de cause à effet.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — La mort',
    question: 'L’état préexistant de la victime (santé fragile) est :',
    options: ['Indifférent', 'Excluant la circonstance', 'Toujours atténuant'],
    answer: 'Indifférent',
    explanation:
        'Le cours : circonstance retenue même si l’état a concouru au décès.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — La mort',
    question: 'Cette circonstance peut aggraver :',
    options: [
      'Certaines violences',
      'Uniquement le vol',
      'Uniquement la diffamation',
    ],
    answer: 'Certaines violences',
    explanation: 'Le cours liste des violences ayant entraîné la mort.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'La mutilation correspond à :',
    options: [
      'Perte/ablation d’un membre ou partie externe avec atteinte irréversible',
      'Une douleur passagère',
      'Une simple peur',
    ],
    answer:
        'Perte/ablation d’un membre ou partie externe avec atteinte irréversible',
    explanation:
        'Le cours reprend la définition (Robert) : atteinte irréversible à l’intégrité physique.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'L’infirmité permanente est :',
    options: [
      'Une atteinte majeure et irréversible d’un membre ou d’une fonction',
      'Une ITT de 2 jours',
      'Un simple stress',
    ],
    answer:
        'Une atteinte majeure et irréversible d’un membre ou d’une fonction',
    explanation:
        'Le cours cite Cass. crim., 24 nov. 2021 : atteinte majeure et irréversible.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'L’infirmité peut être :',
    options: [
      'Physique ou mentale/intellectuelle',
      'Uniquement physique',
      'Uniquement professionnelle',
    ],
    answer: 'Physique ou mentale/intellectuelle',
    explanation:
        'Le cours : l’infirmité peut affecter aussi les facultés mentales/intellectuelles.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'Le caractère permanent de l’infirmité signifie :',
    options: ['Irréversible/définitif', 'Temporaire', 'Réversible'],
    answer: 'Irréversible/définitif',
    explanation:
        'Le cours : infirmité doit être irréversible ou définitive (jurisprudence citée).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'La preuve est rapportée par :',
    options: [
      'Tout moyen (certificats/expertises)',
      'Uniquement vidéosurveillance',
      'Uniquement confession',
    ],
    answer: 'Tout moyen (certificats/expertises)',
    explanation: 'Le cours : preuve par certificats médicaux ou expertises.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Exclusivement administrative'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q121–Q140 — VULNÉRABILITÉ + MINORITÉ 15 ANS + PROSTITUTION
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'La vulnérabilité particulière vise :',
    options: [
      'La protection des victimes hors d’état de se protéger',
      'Uniquement les mineurs',
      'Uniquement les policiers',
    ],
    answer: 'La protection des victimes hors d’état de se protéger',
    explanation:
        'Le cours : elle protège les victimes en situation de faiblesse.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'Les causes de vulnérabilité sont :',
    options: ['Limitatives', 'Illimitées', 'Au choix du juge sans texte'],
    answer: 'Limitatives',
    explanation:
        'Le cours précise qu’elles sont limitatives (au nombre de sept).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'La vulnérabilité doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Ignorée de l’auteur',
      'Toujours supposée',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation:
        'Le cours : condition d’apparence ou de connaissance par l’auteur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'La vulnérabilité doit résulter :',
    options: [
      'D’un état préexistant aux faits',
      'Uniquement des blessures causées',
      'D’une plainte tardive',
    ],
    answer: 'D’un état préexistant aux faits',
    explanation:
        'Le cours (jurisprudence) : vulnérabilité préexistante, pas conséquence des faits.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'Concernant l’âge, le cours précise que :',
    options: [
      'La minorité de 15 ans est une aggravation spécifique distincte',
      'Tout mineur est automatiquement vulnérable',
      'L’âge ne compte jamais',
    ],
    answer: 'La minorité de 15 ans est une aggravation spécifique distincte',
    explanation:
        'Le cours : la minorité de 15 ans ne rentre pas dans ce champ car aggravation spécifique.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'Le seul grand âge suffit à caractériser la vulnérabilité :',
    options: [
      'Non, il faut prouver une vulnérabilité particulière',
      'Oui, toujours',
      'Oui, si l’auteur est mineur',
    ],
    answer: 'Non, il faut prouver une vulnérabilité particulière',
    explanation:
        'Le cours cite la jurisprudence : l’âge ne suffit pas sans autres constatations.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'La maladie/infirmité/déficience concerne :',
    options: [
      'Dysfonctionnements corporels/mentaux innés ou acquis',
      'Uniquement fractures',
      'Uniquement maladies contagieuses',
    ],
    answer: 'Dysfonctionnements corporels/mentaux innés ou acquis',
    explanation:
        'Le cours : dysfonctionnements corporels, physiques ou mentaux, innés ou acquis.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'L’état de grossesse peut entraîner une vulnérabilité :',
    options: [
      'Pendant et aussi après l’accouchement',
      'Uniquement avant 3 mois',
      'Jamais',
    ],
    answer: 'Pendant et aussi après l’accouchement',
    explanation:
        'Le cours : vulnérabilité possible pendant la grossesse et après l’accouchement.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'La précarité économique/sociale se définit comme :',
    options: [
      'Absence d’une ou plusieurs sécurités (notamment emploi) fragilisant la situation',
      'Simple choix de vie',
      'Un niveau d’études faible',
    ],
    answer:
        'Absence d’une ou plusieurs sécurités (notamment emploi) fragilisant la situation',
    explanation:
        'Le cours donne une définition inspirée : absence de sécurités, notamment emploi.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'La vulnérabilité est une circonstance :',
    options: ['Réelle', 'Personnelle', 'Toujours mixte'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'La “minorité de quinze ans” vise :',
    options: [
      'Un mineur de 15 ans (âge accompli)',
      'Un mineur de 18 ans',
      'Un mineur de 13 ans seulement',
    ],
    answer: 'Un mineur de 15 ans (âge accompli)',
    explanation: 'Le cours : c’est l’âge de 15 ans accompli qui est la limite.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'L’âge pris en compte est celui :',
    options: [
      'Au moment des faits',
      'Au moment du jugement',
      'Au moment de la plainte',
    ],
    answer: 'Au moment des faits',
    explanation:
        'Le cours cite Cass. crim., 21 mars 1957 : âge au moment des faits.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'Le calcul de l’âge se fait :',
    options: ['D’heure à heure', 'Par année civile', 'Par trimestre'],
    answer: 'D’heure à heure',
    explanation:
        'Le cours cite Cass. crim., 3 septembre 1985 : calcul d’heure à heure.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'À défaut d’acte probant, la preuve de l’âge se fait :',
    options: [
      'Par tout moyen',
      'Uniquement par passeport',
      'Uniquement par témoignage',
    ],
    answer: 'Par tout moyen',
    explanation:
        'Le cours cite Cass. crim., 17 juillet 1991 : preuve par tout moyen.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'La minorité de 15 ans doit être apparente/connue de l’auteur :',
    options: [
      'Non, ce n’est pas exigé',
      'Oui, toujours',
      'Oui, uniquement pour les délits',
    ],
    answer: 'Non, ce n’est pas exigé',
    explanation:
        'Le cours : pas d’exigence d’apparence ou de connaissance pour cette circonstance.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'La minorité de 15 ans est une circonstance :',
    options: ['Réelle', 'Personnelle', 'Exclusivement civile'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Une excuse légale'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: '“Se livrer à la prostitution” implique :',
    options: [
      'Rapports sexuels contre rémunération',
      'Simple relation affective',
      'Simple cohabitation',
    ],
    answer: 'Rapports sexuels contre rémunération',
    explanation:
        'Le cours : existence de rapports sexuels contre rémunération.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'La prostitution peut être :',
    options: ['Occasionnelle', 'Uniquement habituelle', 'Uniquement déclarée'],
    answer: 'Occasionnelle',
    explanation: 'Le cours : un acte unique peut suffire.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Les faits doivent être commis :',
    options: [
      'Dans l’exercice de cette activité',
      'Sans lien avec l’activité',
      'Uniquement après l’activité',
    ],
    answer: 'Dans l’exercice de cette activité',
    explanation:
        'Le cours : exclus les faits sans lien avec l’activité prostitutionnelle.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q141–Q160 — RÉSEAU DE COMMUNICATION ÉLECTRONIQUE + CRYPTOLOGIE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Cette circonstance vise l’utilisation :',
    options: [
      'D’un réseau pour diffuser des messages à un public non déterminé',
      'D’un courrier papier',
      'D’un appel à une personne identifiée uniquement',
    ],
    answer: 'D’un réseau pour diffuser des messages à un public non déterminé',
    explanation:
        'Le cours : diffusion de messages à destination d’un public non déterminé via réseau électronique.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Elle est une circonstance :',
    options: ['Réelle', 'Personnelle', 'Exclusivement civile'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'La formule “public non déterminé” exclut :',
    options: [
      'L’envoi d’un même email à plusieurs personnes identifiées',
      'La publication sur Internet',
      'La diffusion sur un forum public',
    ],
    answer: 'L’envoi d’un même email à plusieurs personnes identifiées',
    explanation:
        'Le cours précise que cette formule exclut cet envoi ciblé à personnes identifiées.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Le réseau de communication électronique visé est :',
    options: [
      'Internet et le réseau téléphonique',
      'Uniquement la radio',
      'Uniquement la télévision',
    ],
    answer: 'Internet et le réseau téléphonique',
    explanation: 'Le cours : internet + réseau téléphonique.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Cette circonstance vise :',
    options: [
      'Mineurs et majeurs',
      'Uniquement les mineurs',
      'Uniquement les majeurs',
    ],
    answer: 'Mineurs et majeurs',
    explanation: 'Le cours : vise mineurs et majeurs.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Le développement d’Internet a rendu certaines infractions :',
    options: [
      'Plus faciles à commettre et plus difficiles à sanctionner',
      'Toujours impossibles',
      'Toujours locales et simples',
    ],
    answer: 'Plus faciles à commettre et plus difficiles à sanctionner',
    explanation:
        'Le cours souligne la facilité de contact massif et la difficulté d’identification.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Ces procédés peuvent induire :',
    options: [
      'Une internationalisation des délits',
      'Une disparition des preuves',
      'Une dépénalisation automatique',
    ],
    answer: 'Une internationalisation des délits',
    explanation: 'Le cours mentionne l’internationalisation des délits.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Cette circonstance peut aggraver (cours) :',
    options: ['Le harcèlement moral', 'Le stationnement', 'La chasse'],
    answer: 'Le harcèlement moral',
    explanation:
        'Le cours : harcèlement moral (art. 222-33-2-2, 4°) figure dans la liste.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Cette circonstance peut aussi aggraver :',
    options: [
      'La corruption de mineurs',
      'Le tapage',
      'La contravention de 1re classe',
    ],
    answer: 'La corruption de mineurs',
    explanation:
        'Le cours : corruption de mineurs (art. 227-22) figure dans la liste.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Elle peut également aggraver :',
    options: [
      'La diffusion/fixation d’images pornographiques de mineur',
      'Le divorce',
      'La vente d’alcool',
    ],
    answer: 'La diffusion/fixation d’images pornographiques de mineur',
    explanation: 'Le cours : art. 227-23 figure dans la liste.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'L’utilisation d’un moyen de cryptologie est prévue par :',
    options: ['Art. 132-79 C.P.', 'Art. 132-77 C.P.', 'Art. 132-74 C.P.'],
    answer: 'Art. 132-79 C.P.',
    explanation: 'Le cours : article 132-79 du code pénal.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Disciplinaire'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Le moyen de cryptologie sert principalement à garantir :',
    options: [
      'La confidentialité des communications/données',
      'La publicité des données',
      'La suppression des données',
    ],
    answer: 'La confidentialité des communications/données',
    explanation: 'Le cours : confidentialité, authentification, intégrité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'L’article 132-79 a une portée :',
    options: [
      'Générale (tous crimes et délits, commis ou tentés)',
      'Limitée aux infractions sexuelles',
      'Limitée aux crimes',
    ],
    answer: 'Générale (tous crimes et délits, commis ou tentés)',
    explanation:
        'Le cours : portée générale, s’applique à tous crimes et délits.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Cette circonstance ne s’applique pas si l’auteur/complice :',
    options: [
      'Remet la version en clair et les conventions secrètes nécessaires',
      'Détruit son téléphone',
      'Explique oralement les faits',
    ],
    answer: 'Remet la version en clair et les conventions secrètes nécessaires',
    explanation:
        'Le cours : exception si remise aux autorités de la version en clair + conventions.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question:
        'Un téléphone équipé d’un moyen de cryptologie + code de déverrouillage :',
    options: [
      'Peut constituer une clé de déchiffrement',
      'N’a jamais de lien',
      'Transforme l’infraction en contravention',
    ],
    answer: 'Peut constituer une clé de déchiffrement',
    explanation: 'Le cours cite Cass. crim., 11 octobre 2020.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question:
        'L’objectif de cette aggravation est de réprimer plus sévèrement :',
    options: [
      'L’usage de moyens assurant la confidentialité pour préparer/faciliter/commettre',
      'Le simple achat d’un téléphone',
      'Le simple silence en audition',
    ],
    answer:
        'L’usage de moyens assurant la confidentialité pour préparer/faciliter/commettre',
    explanation:
        'Le cours : réprimer l’usage de moyens techniques de confidentialité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Un “moyen de cryptologie” peut être :',
    options: [
      'Matériel ou logiciel conçu/modifié pour transformer des données via conventions secrètes',
      'Uniquement une clé physique',
      'Uniquement une signature manuscrite',
    ],
    answer:
        'Matériel ou logiciel conçu/modifié pour transformer des données via conventions secrètes',
    explanation:
        'Le cours reprend la définition de l’art. 29 de la loi du 21 juin 2004.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'La cryptologie vise notamment :',
    options: [
      'Stockage ou transmission des données (confidentialité/authentification/intégrité)',
      'Uniquement la vitesse internet',
      'Uniquement le graphisme',
    ],
    answer:
        'Stockage ou transmission des données (confidentialité/authentification/intégrité)',
    explanation:
        'Le cours : sécurité du stockage/transmission, confidentialité/authentification/intégrité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Conjoint/concubin/PACS (auteur)',
    question: 'Cette circonstance est définie par :',
    options: ['Art. 132-80 C.P.', 'Art. 132-75 C.P.', 'Art. 132-72 C.P.'],
    answer: 'Art. 132-80 C.P.',
    explanation: 'Le cours : article 132-80 du code pénal.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Conjoint/concubin/PACS (auteur)',
    question: 'Elle est une circonstance aggravante :',
    options: ['Personnelle', 'Réelle', 'Disciplinaire'],
    answer: 'Personnelle',
    explanation:
        'Le cours : circonstance aggravante personnelle, non étendue aux coauteurs.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Conjoint/concubin/PACS (auteur)',
    question: 'Elle s’applique même si les personnes :',
    options: [
      'Ne cohabitent pas',
      'Cohabitent obligatoirement',
      'Sont seulement voisines',
    ],
    answer: 'Ne cohabitent pas',
    explanation: 'Le cours : y compris lorsqu’ils ne cohabitent pas.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Conjoint/concubin/PACS (auteur)',
    question: 'Elle peut aussi être constituée par :',
    options: [
      'L’ancien conjoint/concubin/partenaire',
      'Uniquement le conjoint actuel',
      'Uniquement les fiancés',
    ],
    answer: 'L’ancien conjoint/concubin/partenaire',
    explanation:
        'Le cours : le texte vise aussi l’ancien conjoint/concubin/partenaire.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Conjoint/concubin/PACS (auteur)',
    question:
        'Pour l’ancien conjoint/concubin/partenaire, il faut que l’infraction soit commise :',
    options: [
      'En raison des relations ayant existé',
      'Par hasard',
      'Uniquement en état d’ivresse',
    ],
    answer: 'En raison des relations ayant existé',
    explanation:
        'Le cours : condition du mobile (lien avec la relation passée).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Conjoint/concubin/PACS (auteur)',
    question: 'Le concubinage est défini par le code civil comme :',
    options: [
      'Union de fait avec vie commune stable et continue',
      'Mariage religieux',
      'Colocation temporaire',
    ],
    answer: 'Union de fait avec vie commune stable et continue',
    explanation: 'Le cours reprend l’art. 515-8 du code civil.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Conjoint/concubin/PACS (auteur)',
    question: 'Le PACS est :',
    options: [
      'Un contrat pour organiser la vie commune',
      'Un simple engagement moral',
      'Un mariage',
    ],
    answer: 'Un contrat pour organiser la vie commune',
    explanation: 'Le cours reprend l’art. 515-1 du code civil.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur la victime',
    question: 'Cette circonstance est :',
    options: ['Personnelle', 'Réelle', 'Toujours mixte'],
    answer: 'Personnelle',
    explanation:
        'Le cours : circonstance aggravante personnelle, non étendue aux coauteurs.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur la victime',
    question: 'Ascendants visés :',
    options: [
      'Père, mère, aïeux/aïeules (légitimes/naturels/adoptifs)',
      'Frères et sœurs',
      'Cousins uniquement',
    ],
    answer: 'Père, mère, aïeux/aïeules (légitimes/naturels/adoptifs)',
    explanation:
        'Le cours : ascendants directs, légitimes, naturels ou adoptifs.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur la victime',
    question: 'L’autorité peut être :',
    options: [
      'De droit ou de fait',
      'Uniquement de droit',
      'Uniquement de fait',
    ],
    answer: 'De droit ou de fait',
    explanation:
        'Le cours : tuteur (droit) ou autorité de fait permanente/discontinue.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur la victime',
    question: 'Exemple d’autorité de fait (cours) :',
    options: [
      'Concubin de la mère/second mari/cohabitation',
      'Boulanger du quartier',
      'Passant',
    ],
    answer: 'Concubin de la mère/second mari/cohabitation',
    explanation: 'Le cours cite ces exemples d’autorité de fait.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: '“Abusant de l’autorité que lui confèrent ses fonctions” est :',
    options: ['Personnelle', 'Réelle', 'Une cause d’exemption'],
    answer: 'Personnelle',
    explanation: 'Le cours : circonstance aggravante personnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Les fonctions exercées peuvent être :',
    options: [
      'Publiques ou privées',
      'Uniquement publiques',
      'Uniquement privées',
    ],
    answer: 'Publiques ou privées',
    explanation: 'Le cours : fonctions publiques ou privées.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Exemples de personnes concernées (cours) :',
    options: [
      'Professeurs, médecins, prêtres, marabouts',
      'Uniquement ascendants',
      'Uniquement policiers',
    ],
    answer: 'Professeurs, médecins, prêtres, marabouts',
    explanation: 'Le cours donne ces exemples.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'La condition centrale est :',
    options: [
      'L’abus de l’autorité pour commettre l’acte',
      'Le simple fait d’avoir une fonction',
      'La présence d’une arme',
    ],
    answer: 'L’abus de l’autorité pour commettre l’acte',
    explanation:
        'Le cours : aggravation encourue lorsque l’auteur abuse de l’autorité.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique/mission service public',
    question: 'Cette circonstance (auteur DAP/MSP) est :',
    options: ['Personnelle', 'Réelle', 'Une excuse légale'],
    answer: 'Personnelle',
    explanation:
        'Le cours : circonstance aggravante personnelle, non étendue aux coauteurs.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique/mission service public',
    question: 'Dépositaire de l’autorité publique =',
    options: [
      'Pouvoir de décision fondé sur une parcelle d’autorité publique',
      'Simple emploi privé',
      'Simple notoriété',
    ],
    answer: 'Pouvoir de décision fondé sur une parcelle d’autorité publique',
    explanation:
        'Le cours donne cette définition (policiers, gendarmes, douaniers, huissiers…).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique/mission service public',
    question: '“Dans l’exercice ou à l’occasion de l’exercice” signifie :',
    options: [
      'En service ou du fait des fonctions',
      'Uniquement en dehors du service',
      'Uniquement dans un tribunal',
    ],
    answer: 'En service ou du fait des fonctions',
    explanation:
        'Le cours : dans l’exercice (en service) ou à l’occasion/du fait des fonctions.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique/mission service public',
    question: 'La “mission de service public” (cours) vise :',
    options: [
      'Un service quelconque, temporaire ou permanent, sans parcelle d’autorité publique',
      'Uniquement les policiers',
      'Uniquement les élus',
    ],
    answer:
        'Un service quelconque, temporaire ou permanent, sans parcelle d’autorité publique',
    explanation:
        'Le cours reprend la définition de la circulaire du 14 mai 1993.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q181–Q200 — VICTIMES PROTÉGÉES (DAP/MSP) + PROCHES + TÉMOIN/VICTIME/PC + IVRESSE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire de l’autorité publique',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Disciplinaire'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire de l’autorité publique',
    question: 'Pour la retenir, il faut un lien :',
    options: [
      'Direct avec la fonction',
      'Avec la nationalité',
      'Avec le domicile',
    ],
    answer: 'Direct avec la fonction',
    explanation:
        'Le cours : l’infraction doit être en rapport direct avec la fonction.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire de l’autorité publique',
    question: 'La qualité de la victime doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Toujours ignorée',
      'Sans importance',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation: 'Le cours : condition d’apparence/connaissance.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission de service public',
    question: 'Cette circonstance (victime MSP) est :',
    options: ['Réelle', 'Personnelle', 'Une excuse légale'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission de service public',
    question: 'Elle protège notamment :',
    options: [
      'Enseignants/personnels scolaires, agents transport public, professionnels de santé',
      'Uniquement magistrats',
      'Uniquement militaires',
    ],
    answer:
        'Enseignants/personnels scolaires, agents transport public, professionnels de santé',
    explanation: 'Le cours détaille ces catégories.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission de service public',
    question: 'La victime doit être atteinte :',
    options: [
      'Dans l’exercice de ses fonctions',
      'Uniquement en congé',
      'Uniquement à domicile',
    ],
    answer: 'Dans l’exercice de ses fonctions',
    explanation:
        'Le cours : victime en service ou effectuant un acte entrant dans ses attributions.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission de service public',
    question: 'La qualité doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Toujours inconnue',
      'Jamais exigée',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation: 'Le cours : condition identique (apparente/connue).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Cette circonstance (proches) est :',
    options: ['Réelle', 'Personnelle', 'Disciplinaire'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Sont visés notamment :',
    options: [
      'Conjoint, ascendants, descendants, ou personne vivant habituellement au domicile',
      'Uniquement les enfants',
      'Uniquement les parents',
    ],
    answer:
        'Conjoint, ascendants, descendants, ou personne vivant habituellement au domicile',
    explanation:
        'Le cours énumère ces liens et la personne vivant habituellement au domicile.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Condition essentielle : faits commis :',
    options: [
      'En raison des fonctions exercées par le proche',
      'Par hasard',
      'Uniquement la nuit',
    ],
    answer: 'En raison des fonctions exercées par le proche',
    explanation:
        'Le cours : l’infraction principale doit être commise en raison des fonctions du proche.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Cela implique que l’auteur :',
    options: [
      'Connaissait la qualité du proche',
      'Ignorait la qualité du proche',
      'N’avait aucun mobile',
    ],
    answer: 'Connaissait la qualité du proche',
    explanation:
        'Le cours : condition de connaissance de la qualité du proche.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Cette circonstance est de nature :',
    options: ['Personnelle', 'Réelle', 'Toujours mixte'],
    answer: 'Personnelle',
    explanation:
        'Le cours : dépend de l’intention de l’auteur et du but poursuivi.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Elle vise à préserver :',
    options: [
      'Le bon fonctionnement de la justice',
      'La liberté contractuelle',
      'Le secret médical',
    ],
    answer: 'Le bon fonctionnement de la justice',
    explanation:
        'Le cours : pressions sur témoins/parties menacent l’administration de la justice.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Intention “préventive” :',
    options: [
      'Empêcher de dénoncer/porter plainte/déposer',
      'Se venger après déposition',
      'Réparer un dommage',
    ],
    answer: 'Empêcher de dénoncer/porter plainte/déposer',
    explanation:
        'Le cours : empêcher, contraindre à retirer plainte, influencer déclarations.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Intention “répressive” :',
    options: [
      'Vengeance en raison d’une dénonciation/plainte/déposition',
      'Empêcher avant plainte',
      'Erreur matérielle',
    ],
    answer: 'Vengeance en raison d’une dénonciation/plainte/déposition',
    explanation: 'Le cours : intention répressive = volonté de vengeance.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur ivre ou sous stupéfiants',
    question:
        'La circonstance “ivresse manifeste ou emprise manifeste de stupéfiants” est :',
    options: ['Personnelle', 'Réelle', 'Une cause d’exemption de peine'],
    answer: 'Réelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante réelle, étendue à tous les participants.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur ivre ou sous stupéfiants',
    question:
        'Concernant l’ivresse, la jurisprudence majoritaire considère que l’ivresse :',
    options: [
      'Constitue une cause légale d’exemption',
      'Ne constitue pas une cause légale d’exemption',
      'Supprime toujours la responsabilité',
    ],
    answer: 'Ne constitue pas une cause légale d’exemption',
    explanation:
        'Le cours : la majorité des décisions refusent d’y voir une cause légale d’exemption de peine.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur ivre ou sous stupéfiants',
    question: 'L’usage volontaire de stupéfiants est, par nature :',
    options: [
      'Illicite',
      'Licite comme l’alcool',
      'Toujours prescrit médicalement',
    ],
    answer: 'Illicite',
    explanation:
        'Le cours souligne que l’usage de stupéfiants est illicite, contrairement à la consommation d’alcool.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances aggravantes — Auteur ivre ou sous stupéfiants',
    question: 'La preuve de l’état manifeste peut être délicate car :',
    options: [
      'Plainte tardive + persistance des traces (stupéfiants)',
      'Elle est toujours automatique',
      'La loi fixe une preuve unique obligatoire',
    ],
    answer: 'Plainte tardive + persistance des traces (stupéfiants)',
    explanation:
        'Le cours évoque la difficulté : plainte tardive pour alcool et présence prolongée des stupéfiants.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'Catégories 132-76 :',
    options: ['Ethnie/nation/race/religion', 'Âge/sexe', 'Profession/salaire'],
    answer: 'Ethnie/nation/race/religion',
    explanation: 'Liste du cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe/sexiste/transphobe',
    question: 'Peut viser identité de genre :',
    options: ['Vraie ou supposée', 'Uniquement vraie', 'Jamais'],
    answer: 'Vraie ou supposée',
    explanation: 'Le cours : erreur possible de l’auteur.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Circonstances aggravantes — Particulière vulnérabilité de la victime',
    question:
        'Parmi les causes citées, la précarité économique ou sociale renvoie notamment à :',
    options: [
      'L’absence d’une ou plusieurs sécurités (notamment l’emploi) plaçant la personne en dépendance',
      'Une simple préférence de consommation',
      'Le fait d’être étudiant',
    ],
    answer:
        'L’absence d’une ou plusieurs sécurités (notamment l’emploi) plaçant la personne en dépendance',
    explanation:
        'Le cours définit la précarité comme l’absence de sécurités (dont l’emploi) pouvant placer la victime en dépendance.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Réitération d’infractions',
    question: 'La notion de réitération a été consacrée par la loi du :',
    options: ['9 mars 2004', '12 décembre 2005', '23 mars 2019'],
    answer: '12 décembre 2005',
    explanation:
        'La loi du 12 décembre 2005 a consacré la notion de réitération jusque-là jurisprudentielle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Réitération d’infractions',
    question: 'La réitération suppose nécessairement :',
    options: [
      'Une condamnation définitive préalable',
      'Une infraction identique',
      'Un délai maximal de 5 ans',
    ],
    answer: 'Une condamnation définitive préalable',
    explanation:
        'La réitération suppose que la nouvelle infraction soit commise après une condamnation devenue définitive.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Réitération d’infractions',
    question: 'La réitération se distingue de la récidive légale car :',
    options: [
      'Elle permet un doublement automatique des peines',
      'Elle ne répond pas aux conditions légales de la récidive',
      'Elle concerne uniquement les contraventions',
    ],
    answer: 'Elle ne répond pas aux conditions légales de la récidive',
    explanation:
        'La réitération concerne les situations qui ne remplissent pas les conditions strictes de la récidive légale.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Réitération d’infractions',
    question:
        'Une infraction commise après une condamnation pour un délit puni de moins de 10 ans peut relever :',
    options: [
      'De la récidive criminelle',
      'De la réitération',
      'Du concours réel',
    ],
    answer: 'De la réitération',
    explanation:
        'Lorsque la première infraction est punie d’une peine inférieure à 10 ans et que les conditions de la récidive ne sont pas réunies, la nouvelle infraction relève de la réitération.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Réitération d’infractions',
    question: 'Les infractions commises en réitération sont traitées :',
    options: [
      'Comme des infractions uniques',
      'Comme des infractions en concours réel',
      'Comme des infractions récidivantes',
    ],
    answer: 'Comme des infractions uniques',
    explanation:
        'Le cours précise que les infractions commises en réitération sont juridiquement traitées comme des infractions uniques.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Réitération d’infractions',
    question: 'En matière de réitération, les peines prononcées :',
    options: [
      'Peuvent faire l’objet d’une confusion',
      'Se cumulent sans limitation de quantum',
      'Sont automatiquement réduites',
    ],
    answer: 'Se cumulent sans limitation de quantum',
    explanation:
        'L’article 132-16-7 al. 2 du code pénal prévoit un cumul intégral des peines sans limitation.',
    difficulty: 'Moyenne',
  ),
  //////////////////////////////////////////////////////////////////////////////
  // RÉCIDIVE — NOTIONS GÉNÉRALES
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive',
    question: 'La récidive est juridiquement définie comme :',
    options: [
      'La commission simultanée de plusieurs infractions',
      'La commission d’une infraction après une condamnation définitive pour une infraction antérieure',
      'La répétition d’une infraction avant tout jugement',
    ],
    answer:
        'La commission d’une infraction après une condamnation définitive pour une infraction antérieure',
    explanation:
        'La récidive suppose une condamnation définitive constituant le premier terme et une nouvelle infraction constituant le second terme.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive',
    question: 'La récidive permet au juge :',
    options: [
      'De réduire automatiquement la peine',
      'De dépasser le maximum légal normal de la peine',
      'D’écarter toute peine d’emprisonnement',
    ],
    answer: 'De dépasser le maximum légal normal de la peine',
    explanation:
        'La récidive est la principale cause légale permettant le dépassement du maximum normal de la peine.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive',
    question: 'La récidive suppose obligatoirement :',
    options: [
      'Une condamnation non définitive',
      'Une condamnation définitive passée en force de chose jugée',
      'Une simple poursuite pénale',
    ],
    answer: 'Une condamnation définitive passée en force de chose jugée',
    explanation:
        'La condamnation doit être définitive avant la commission de la seconde infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive',
    question:
        'Lorsque la seconde infraction est commise avant que la première condamnation soit définitive, il s’agit :',
    options: [
      'D’une récidive',
      'D’une réitération',
      'D’un concours réel d’infractions',
    ],
    answer: 'D’un concours réel d’infractions',
    explanation:
        'L’absence de condamnation définitive au moment de la seconde infraction exclut la récidive.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // RÉCIDIVE — PREMIER TERME : CONDAMNATION
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question: 'Le premier terme de la récidive doit être :',
    options: [
      'Une simple sanction administrative',
      'Une mesure de sûreté',
      'Une condamnation ayant le caractère d’une peine',
    ],
    answer: 'Une condamnation ayant le caractère d’une peine',
    explanation:
        'Les sanctions administratives et mesures de sûreté ne peuvent constituer le premier terme de la récidive.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question:
        'Un acquittement peut-il constituer le premier terme de la récidive ?',
    options: ['Oui', 'Non', 'Uniquement en matière contraventionnelle'],
    answer: 'Non',
    explanation:
        'Un acquittement ne constitue pas une condamnation et ne peut servir de premier terme.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question:
        'Une mesure de rééducation prononcée à l’encontre d’un mineur peut constituer le premier terme :',
    options: ['Oui', 'Non', 'Uniquement pour les délits'],
    answer: 'Non',
    explanation: 'Les mesures de rééducation ne constituent pas des peines.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question: 'Pour apprécier la récidive, sont prises en compte :',
    options: [
      'Les peines effectivement prononcées',
      'Les peines encourues pour l’infraction',
      'Uniquement les peines exécutées',
    ],
    answer: 'Les peines encourues pour l’infraction',
    explanation:
        'Le code pénal retient les peines encourues et non les peines prononcées.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // RÉCIDIVE — ORIGINE DE LA CONDAMNATION
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question:
        'La condamnation constituant le premier terme peut être prononcée :',
    options: [
      'Uniquement par une juridiction française',
      'Par une juridiction française ou d’un État membre de l’Union européenne',
      'Par toute juridiction étrangère',
    ],
    answer:
        'Par une juridiction française ou d’un État membre de l’Union européenne',
    explanation:
        'Les condamnations prononcées par un État membre de l’Union européenne sont prises en compte.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question: 'Les condamnations prononcées hors Union européenne :',
    options: [
      'Sont toujours prises en compte',
      'Ne sont pas prises en compte pour la récidive',
      'Sont assimilées automatiquement',
    ],
    answer: 'Ne sont pas prises en compte pour la récidive',
    explanation:
        'Elles peuvent révéler la dangerosité mais ne constituent pas le premier terme légal.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question:
        'Lorsque la condamnation a été prononcée dans l’UE, la qualification des faits se fait :',
    options: [
      'Selon le droit étranger',
      'Selon la loi française',
      'Selon la jurisprudence européenne',
    ],
    answer: 'Selon la loi française',
    explanation:
        'La qualification est déterminée par référence aux incriminations françaises.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // RÉCIDIVE — CARACTÈRE DÉFINITIF
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question: 'Une condamnation devient définitive :',
    options: [
      'Dès son prononcé',
      'Après expiration des délais de recours',
      'Après exécution de la peine',
    ],
    answer: 'Après expiration des délais de recours',
    explanation: 'La condamnation doit être passée en force de chose jugée.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question: 'Le délai d’appel du procureur général est de :',
    options: ['10 jours', '15 jours', '20 jours'],
    answer: '20 jours',
    explanation:
        'L’article 505 du code de procédure pénale prévoit un délai de 20 jours.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // RÉCIDIVE — SUR SIS, AMNISTIE, GRÂCE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question:
        'Une condamnation avec sursis non révoqué peut constituer le premier terme :',
    options: ['Oui', 'Non', 'Uniquement pour les crimes'],
    answer: 'Oui',
    explanation:
        'La Cour de cassation admet qu’un sursis non révoqué peut constituer le premier terme.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question:
        'Une condamnation effacée par une amnistie peut servir de premier terme :',
    options: ['Oui', 'Non', 'Uniquement en matière contraventionnelle'],
    answer: 'Non',
    explanation:
        'L’amnistie efface la condamnation qui ne peut plus servir de fondement à la récidive.',
    difficulty: 'Facile',
  ),
  //////////////////////////////////////////////////////////////////////////////
  // RÉCIDIVE — SECOND TERME : PRINCIPES
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : second terme',
    question: 'Le second terme de la récidive correspond :',
    options: [
      'À la première condamnation définitive',
      'À l’infraction ultérieure commise après la première condamnation définitive',
      'À la peine effectivement exécutée',
    ],
    answer:
        'À l’infraction ultérieure commise après la première condamnation définitive',
    explanation:
        'Le second terme est l’infraction nouvelle commise après une condamnation devenue définitive.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : second terme',
    question:
        'Le code pénal prévoit, en droit commun, combien de cas de récidive ?',
    options: ['2', '4', '6'],
    answer: '4',
    explanation:
        'Le cours indique quatre cas : articles 132-8 à 132-11 du code pénal.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // RÉCIDIVE — ART. 132-8 : CRIME OU DÉLIT PUNI DE 10 ANS → CRIME
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive (art. 132-8)',
    question:
        'Selon l’article 132-8 du code pénal, la récidive est constituée lorsque :',
    options: [
      'Une personne condamnée pour une contravention commet un nouveau délit',
      'Une personne condamnée pour un crime ou un délit puni de 10 ans commet ultérieurement un autre crime',
      'Une personne condamnée pour un délit commet ultérieurement une contravention',
    ],
    answer:
        'Une personne condamnée pour un crime ou un délit puni de 10 ans commet ultérieurement un autre crime',
    explanation:
        'L’article 132-8 vise le cas “crime ou délit puni de 10 ans” suivi d’un crime.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive (art. 132-8)',
    question:
        'Dans la récidive de l’article 132-8, le second terme doit être :',
    options: [
      'Un crime',
      'Un délit puni d’au moins 1 an',
      'Une contravention de 5e classe',
    ],
    answer: 'Un crime',
    explanation:
        'L’article 132-8 exige que l’infraction ultérieure soit un crime.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive (art. 132-8)',
    question: 'La récidive de l’article 132-8 est :',
    options: [
      'Spéciale et temporaire',
      'Générale et perpétuelle',
      'Spéciale et perpétuelle',
    ],
    answer: 'Générale et perpétuelle',
    explanation:
        'Elle est générale (pas besoin de similarité) et perpétuelle (pas de délai tant que la condamnation n’est pas effacée).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive (art. 132-8)',
    question:
        'En matière d’article 132-8, le temps écoulé entre les deux infractions :',
    options: [
      'Doit être inférieur à 5 ans',
      'Doit être inférieur à 10 ans',
      'Est indifférent (récidive perpétuelle)',
    ],
    answer: 'Est indifférent (récidive perpétuelle)',
    explanation: 'Le cours précise que cette récidive est perpétuelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive (art. 132-8)',
    question: 'Dans l’article 132-8, sont assimilés aux crimes :',
    options: [
      'Les délits punis de 10 ans d’emprisonnement',
      'Tous les délits punis d’amende',
      'Toutes les contraventions',
    ],
    answer: 'Les délits punis de 10 ans d’emprisonnement',
    explanation:
        'Le cours indique que les délits punis de 10 ans sont assimilés aux crimes pour ce mécanisme.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // RÉCIDIVE — ART. 132-9 : CRIME OU DÉLIT PUNI DE 10 ANS → DÉLIT
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive (art. 132-9)',
    question:
        'Selon l’article 132-9 du code pénal, la récidive est constituée lorsque :',
    options: [
      'Une personne condamnée pour un crime commet un nouveau crime uniquement',
      'Une personne condamnée pour un crime ou un délit puni de 10 ans commet ultérieurement un nouveau délit',
      'Une personne condamnée pour une contravention commet un crime',
    ],
    answer:
        'Une personne condamnée pour un crime ou un délit puni de 10 ans commet ultérieurement un nouveau délit',
    explanation:
        'L’article 132-9 vise le cas “crime ou délit puni de 10 ans” suivi d’un délit.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive (art. 132-9)',
    question: 'Dans l’article 132-9, le second terme doit être :',
    options: [
      'Un délit puni d’un emprisonnement supérieur à un an',
      'N’importe quel délit, même sans emprisonnement',
      'Uniquement un crime',
    ],
    answer: 'Un délit puni d’un emprisonnement supérieur à un an',
    explanation:
        'Le cours précise que le second terme est un délit dont la peine encourue est supérieure à un an.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive (art. 132-9)',
    question: 'La récidive de l’article 132-9 est :',
    options: [
      'Générale et temporaire',
      'Spéciale et perpétuelle',
      'Spéciale et temporaire',
    ],
    answer: 'Générale et temporaire',
    explanation:
        'Générale (pas d’exigence d’identité) mais temporaire (délai à respecter).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive (art. 132-9)',
    question:
        'Quand le second délit est puni de 10 ans d’emprisonnement, le délai de récidive est de :',
    options: ['3 ans', '5 ans', '10 ans'],
    answer: '10 ans',
    explanation:
        'Le cours indique : délai de 10 ans si le second délit est puni de 10 ans.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive (art. 132-9)',
    question:
        'Quand le second délit est puni d’une peine inférieure à 10 ans, le délai de récidive est de :',
    options: ['1 an', '5 ans', '10 ans'],
    answer: '5 ans',
    explanation:
        'Le cours précise : délai de 5 ans si le second délit est puni d’une peine inférieure à 10 ans.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // RÉCIDIVE — ART. 132-10 : RÉCIDIVE CORRECTIONNELLE (SPÉCIALE + TEMPORAIRE)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive correctionnelle (art. 132-10)',
    question: 'La récidive correctionnelle (art. 132-10) suppose :',
    options: [
      'Deux crimes successifs',
      'Deux délits identiques ou assimilés commis dans un délai de 5 ans',
      'Deux contraventions de 5e classe commises dans l’année',
    ],
    answer: 'Deux délits identiques ou assimilés commis dans un délai de 5 ans',
    explanation:
        'Le cours précise que la récidive correctionnelle est spéciale (identité/assimilation) et temporaire (5 ans).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive correctionnelle (art. 132-10)',
    question:
        'Dans la récidive correctionnelle, le délai de 5 ans court à compter :',
    options: [
      'Du jugement de première instance',
      'De l’expiration ou de la prescription de la peine précédente',
      'De l’arrestation de l’auteur',
    ],
    answer: 'De l’expiration ou de la prescription de la peine précédente',
    explanation:
        'Le point de départ retenu par le cours est l’expiration ou la prescription de la peine.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive correctionnelle (art. 132-10)',
    question: 'Le premier terme de la récidive correctionnelle est constitué :',
    options: [
      'D’un délit puni d’une peine inférieure à 10 ans',
      'D’un crime uniquement',
      'D’une contravention uniquement',
    ],
    answer: 'D’un délit puni d’une peine inférieure à 10 ans',
    explanation:
        'Le cours indique que la récidive correctionnelle porte sur un délit puni de moins de 10 ans.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive correctionnelle (art. 132-10)',
    question:
        'Pour le second terme de la récidive correctionnelle, il est exigé :',
    options: [
      'Un délit (même si la peine encourue n’est pas un emprisonnement)',
      'Un crime',
      'Une contravention de 5e classe',
    ],
    answer: 'Un délit (même si la peine encourue n’est pas un emprisonnement)',
    explanation:
        'Le cours précise que le second terme doit être un délit ; l’emprisonnement n’est pas forcément requis.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive correctionnelle (art. 132-10)',
    question: 'La récidive correctionnelle est qualifiée de :',
    options: [
      'Générale et perpétuelle',
      'Spéciale et temporaire',
      'Générale et temporaire',
    ],
    answer: 'Spéciale et temporaire',
    explanation:
        'Spéciale : délits identiques ou assimilés ; temporaire : délai de 5 ans.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // ASSIMILATIONS DE DÉLITS (ART. 132-16 ET SUIVANTS + 321-5)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive correctionnelle : assimilations',
    question:
        'Sont assimilés pour l’application de la récidive (art. 132-16 C.P.) :',
    options: [
      'Vol, extorsion, chantage, escroquerie et abus de confiance',
      'Meurtre et violences involontaires',
      'Toutes les contraventions et tous les délits',
    ],
    answer: 'Vol, extorsion, chantage, escroquerie et abus de confiance',
    explanation:
        'Le cours cite explicitement ces délits comme assimilés pour la récidive.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive correctionnelle : assimilations',
    question:
        'Les agressions sexuelles et les atteintes sexuelles sont assimilées pour la récidive par :',
    options: [
      'L’article 132-16-1 du code pénal',
      'L’article 132-11 du code pénal',
      'L’article 314-1 du code pénal',
    ],
    answer: 'L’article 132-16-1 du code pénal',
    explanation:
        'Le cours renvoie à l’article 132-16-1 pour l’assimilation agressions sexuelles / atteintes sexuelles.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive correctionnelle : assimilations',
    question:
        'Les délits de traite des êtres humains et de proxénétisme sont assimilés pour la récidive par :',
    options: [
      'L’article 132-16-3 du code pénal',
      'L’article 132-8 du code pénal',
      'L’article 132-74 du code pénal',
    ],
    answer: 'L’article 132-16-3 du code pénal',
    explanation:
        'Le cours cite l’article 132-16-3 pour l’assimilation traite des êtres humains / proxénétisme.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive correctionnelle : assimilations',
    question:
        'Les délits de violences volontaires et tout délit commis avec la circonstance aggravante de violences sont assimilés par :',
    options: [
      'L’article 132-16-4 du code pénal',
      'L’article 132-10 du code pénal',
      'L’article 132-9 du code pénal',
    ],
    answer: 'L’article 132-16-4 du code pénal',
    explanation:
        'Le cours vise l’article 132-16-4 pour l’assimilation des violences volontaires et délits commis avec violences.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive correctionnelle : assimilations',
    question:
        'Le recel et le délit qui a procuré les choses recelées sont assimilés par :',
    options: [
      'L’article 321-5 du code pénal',
      'L’article 132-16-2 du code pénal',
      'L’article 132-23-1 du code pénal',
    ],
    answer: 'L’article 321-5 du code pénal',
    explanation:
        'Le cours indique l’assimilation recel / infraction d’origine par l’article 321-5.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // RÉCIDIVE CONTRAVENTIONNELLE — ART. 132-11
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive contraventionnelle (art. 132-11)',
    question: 'La récidive contraventionnelle concerne :',
    options: [
      'Toutes les contraventions',
      'Uniquement les contraventions de 5e classe',
      'Uniquement les contraventions de 1re classe',
    ],
    answer: 'Uniquement les contraventions de 5e classe',
    explanation:
        'Le cours précise que la récidive contraventionnelle est prévue pour les contraventions de 5e classe.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive contraventionnelle (art. 132-11)',
    question:
        'Pour qu’il y ait récidive contraventionnelle, le règlement doit :',
    options: [
      'Toujours la prévoir expressément',
      'La prévoir uniquement pour les crimes',
      'Être silencieux',
    ],
    answer: 'Toujours la prévoir expressément',
    explanation:
        'Le cours indique : le règlement doit prévoir expressément la récidive.',
    difficulty: 'Moyenne',
  ),
  //////////////////////////////////////////////////////////////////////////////
  // EFFETS DE LA RÉCIDIVE — PRINCIPES GÉNÉRAUX
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive',
    question: 'La récidive a principalement pour effet :',
    options: [
      'De supprimer toute peine d’amende',
      'D’aggraver la peine encourue',
      'D’entraîner une confusion obligatoire des peines',
    ],
    answer: 'D’aggraver la peine encourue',
    explanation:
        'Le cours précise que la récidive permet une aggravation des peines prévues par la loi.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive',
    question: 'En matière de récidive, le juge peut :',
    options: [
      'Dépasser le maximum légal normal',
      'Uniquement prononcer une peine minimale',
      'Écarter toute peine privative de liberté',
    ],
    answer: 'Dépasser le maximum légal normal',
    explanation:
        'La récidive est la principale cause permettant de dépasser le maximum normal de la peine.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PERSONNES PHYSIQUES — ART. 132-8
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive (art. 132-8)',
    question:
        'Lorsque la seconde infraction est punissable de 20 ou 30 ans de réclusion criminelle, le maximum encouru devient :',
    options: ['30 ans', '40 ans', 'La réclusion criminelle à perpétuité'],
    answer: 'La réclusion criminelle à perpétuité',
    explanation:
        'L’article 132-8 prévoit la perpétuité lorsque la seconde infraction est punie de 20 ou 30 ans.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive (art. 132-8)',
    question:
        'Si la seconde infraction entraîne une peine de 15 ans de réclusion criminelle, le maximum devient :',
    options: ['20 ans', '30 ans', 'La perpétuité'],
    answer: '30 ans',
    explanation:
        'Le cours précise que le maximum est porté à 30 ans lorsque la seconde infraction est punie de 15 ans.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive (art. 132-8)',
    question:
        'La récidive a-t-elle un effet sur la période de sûreté maximale de 22 ans ?',
    options: [
      'Oui, elle la double',
      'Oui, elle la supprime',
      'Non, elle ne l’affecte pas',
    ],
    answer: 'Non, elle ne l’affecte pas',
    explanation:
        'Le cours précise que la récidive n’affecte pas la période de sûreté maximale.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PERSONNES PHYSIQUES — ART. 132-9
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive (art. 132-9)',
    question: 'Dans la récidive prévue à l’article 132-9, le juge peut :',
    options: [
      'Doubler la peine maximale encourue',
      'Uniquement ajouter une amende',
      'Prononcer la perpétuité automatiquement',
    ],
    answer: 'Doubler la peine maximale encourue',
    explanation:
        'L’article 132-9 permet le doublement de la peine maximale prévue pour le second délit.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive (art. 132-9)',
    question: 'Le doublement prévu par l’article 132-9 peut s’appliquer :',
    options: [
      'Uniquement à l’emprisonnement',
      'Uniquement à l’amende',
      'À l’emprisonnement et à l’amende',
    ],
    answer: 'À l’emprisonnement et à l’amende',
    explanation:
        'Le cours précise que le doublement peut concerner l’emprisonnement et l’amende.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PERSONNES PHYSIQUES — RÉCIDIVE CORRECTIONNELLE (ART. 132-10)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive correctionnelle',
    question: 'En récidive correctionnelle, le juge peut :',
    options: [
      'Doubler les peines d’emprisonnement ou d’amende',
      'Prononcer la perpétuité',
      'Supprimer toute peine complémentaire',
    ],
    answer: 'Doubler les peines d’emprisonnement ou d’amende',
    explanation: 'L’article 132-10 permet le doublement des peines encourues.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive correctionnelle',
    question: 'La récidive correctionnelle concerne principalement :',
    options: ['Les crimes', 'Les délits', 'Les contraventions'],
    answer: 'Les délits',
    explanation:
        'Par définition, la récidive correctionnelle concerne des délits.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PERSONNES PHYSIQUES — RÉCIDIVE CONTRAVENTIONNELLE (ART. 132-11)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Effets de la récidive contraventionnelle',
    question:
        'En récidive contraventionnelle de 5e classe, le maximum de l’amende est porté à :',
    options: ['1 500 €', '2 000 €', '3 000 €'],
    answer: '3 000 €',
    explanation:
        'L’article 132-11 prévoit un plafond de 3 000 € en cas de récidive contraventionnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Effets de la récidive contraventionnelle',
    question:
        'Lorsque la loi prévoit que la récidive d’une contravention constitue un délit :',
    options: [
      'L’amende reste contraventionnelle',
      'Des peines délictuelles sont applicables',
      'La peine est annulée',
    ],
    answer: 'Des peines délictuelles sont applicables',
    explanation:
        'Le cours précise que la récidive peut transformer la contravention en délit.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PERSONNES MORALES — PRINCIPES
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive des personnes morales',
    question: 'Le code pénal prévoit la récidive pour :',
    options: [
      'Uniquement les personnes physiques',
      'Uniquement les personnes morales',
      'Les personnes physiques et morales',
    ],
    answer: 'Les personnes physiques et morales',
    explanation:
        'Le cours consacre un chapitre spécifique à la récidive des personnes morales.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PERSONNES MORALES — ART. 132-12
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive personne morale (art. 132-12)',
    question:
        'Selon l’article 132-12, la récidive est constituée lorsque la personne morale condamnée pour un crime ou délit puni de 100 000 € commet ultérieurement :',
    options: ['Un crime', 'Une contravention', 'Une infraction disciplinaire'],
    answer: 'Un crime',
    explanation:
        'L’article 132-12 vise le cas crime (ou délit assimilé) suivi d’un crime.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive personne morale (art. 132-12)',
    question: 'La récidive prévue à l’article 132-12 est :',
    options: [
      'Spéciale et temporaire',
      'Générale et perpétuelle',
      'Spéciale et perpétuelle',
    ],
    answer: 'Générale et perpétuelle',
    explanation:
        'Le cours précise que cette récidive est générale et perpétuelle.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PERSONNES MORALES — ART. 132-13
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive personne morale (art. 132-13)',
    question:
        'Dans la récidive prévue à l’article 132-13, la peine d’amende encourue est :',
    options: ['Réduite de moitié', 'Doublée', 'Plafonnée à 100 000 €'],
    answer: 'Doublée',
    explanation: 'L’article 132-13 prévoit un doublement du taux de l’amende.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive personne morale (art. 132-13)',
    question:
        'Si le second délit est puni de 100 000 € d’amende, le délai de récidive est de :',
    options: ['3 ans', '5 ans', '10 ans'],
    answer: '10 ans',
    explanation:
        'Le cours précise un délai de 10 ans lorsque le second délit est puni de 100 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive personne morale (art. 132-13)',
    question:
        'Si le second délit est puni d’une amende comprise entre 15 000 € et 100 000 €, le délai est de :',
    options: ['1 an', '3 ans', '5 ans'],
    answer: '5 ans',
    explanation: 'Le cours indique un délai de 5 ans dans ce cas.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PERSONNES MORALES — ART. 132-14 ET 132-15
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive personne morale (art. 132-14)',
    question: 'La récidive de délit à délit pour les personnes morales est :',
    options: [
      'Générale et perpétuelle',
      'Spéciale et temporaire',
      'Générale et temporaire',
    ],
    answer: 'Spéciale et temporaire',
    explanation:
        'L’article 132-14 prévoit une récidive spéciale et temporaire.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive personne morale (art. 132-14)',
    question: 'En récidive art. 132-14, le taux maximum de l’amende est :',
    options: ['Identique', 'Double', 'Triple'],
    answer: 'Double',
    explanation: 'Le taux maximum de l’amende est porté au double.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive personne morale (art. 132-15)',
    question:
        'En matière contraventionnelle, la récidive pour les personnes morales entraîne une amende :',
    options: ['Doublée', 'Triplée', 'Multipliée par dix'],
    answer: 'Multipliée par dix',
    explanation: 'L’article 132-15 prévoit un taux d’amende multiplié par dix.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUESTIONS TABLEAU & CAS PRATIQUES
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive : cas pratique',
    question:
        'Un délit puni de 5 ans d’emprisonnement commis en récidive correctionnelle permet au juge de prononcer :',
    options: ['5 ans maximum', '7 ans maximum', '10 ans maximum'],
    answer: '10 ans maximum',
    explanation:
        'Le doublement de la peine maximale est autorisé en récidive correctionnelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive : cas pratique',
    question:
        'Une contravention de 5e classe en récidive permet de porter l’amende maximale à :',
    options: ['1 500 €', '3 000 €', '6 000 €'],
    answer: '3 000 €',
    explanation: 'Le plafond légal est fixé à 3 000 €.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive : cas pratique',
    question:
        'La récidive d’une personne morale pour un délit puni de 100 000 € d’amende entraîne :',
    options: [
      'Une amende plafonnée à 100 000 €',
      'Une amende doublée',
      'Une interdiction automatique d’exercer',
    ],
    answer: 'Une amende doublée',
    explanation: 'Le cours précise le doublement du taux de l’amende.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive contraventionnelle (art. 132-11)',
    question: 'La récidive contraventionnelle est :',
    options: [
      'Générale et perpétuelle',
      'Spéciale et temporaire',
      'Générale et temporaire',
    ],
    answer: 'Spéciale et temporaire',
    explanation:
        'Elle est spéciale (même contravention) et temporaire (délai d’un an).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive contraventionnelle (art. 132-11)',
    question:
        'Le délai de récidive contraventionnelle de droit commun est de :',
    options: ['6 mois', '12 mois', '5 ans'],
    answer: '12 mois',
    explanation:
        'Le cours prévoit un délai de 12 mois suivant l’expiration ou la prescription de la peine.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive contraventionnelle (art. 132-11)',
    question:
        'La récidive contraventionnelle exige que la seconde infraction soit :',
    options: ['Une contravention identique', 'Un délit assimilé', 'Un crime'],
    answer: 'Une contravention identique',
    explanation:
        'Le cours précise qu’elle est spéciale : même contravention que le premier terme.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive contraventionnelle (art. 132-11)',
    question:
        'Quand la loi prévoit que la récidive d’une contravention de 5e classe constitue un délit, la récidive est constituée si les faits sont commis dans :',
    options: ['1 an', '3 ans', '5 ans'],
    answer: '3 ans',
    explanation:
        'Le cours précise : délai de 3 ans quand la loi érige la récidive de 5e classe en délit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : cas pratiques',
    question:
        'Une personne condamnée pour un crime commet un autre crime 15 ans après, la condamnation n’est pas effacée. Le régime applicable est :',
    options: [
      'Pas de récidive car délai dépassé',
      'Récidive art. 132-8 (perpétuelle)',
      'Réitération uniquement',
    ],
    answer: 'Récidive art. 132-8 (perpétuelle)',
    explanation:
        'Pour l’article 132-8, la récidive est perpétuelle tant que la condamnation n’est pas effacée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : cas pratiques',
    question:
        'Une personne condamnée définitivement pour un délit puni de 10 ans commet un délit puni de 5 ans 8 ans après expiration de la peine. On retient :',
    options: [
      'Récidive art. 132-9 car délai de 10 ans',
      'Récidive art. 132-9 mais délai de 5 ans, donc non',
      'Récidive art. 132-8',
    ],
    answer: 'Récidive art. 132-9 mais délai de 5 ans, donc non',
    explanation:
        'Si le second délit est puni d’une peine inférieure à 10 ans, le délai est de 5 ans : 8 ans => hors délai.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : cas pratiques',
    question:
        'En récidive correctionnelle, les deux infractions doivent être :',
    options: ['Quelconques', 'Identiques ou assimilées', 'Toujours des crimes'],
    answer: 'Identiques ou assimilées',
    explanation:
        'La récidive correctionnelle est spéciale : identité ou assimilation exigée.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : cas pratiques',
    question:
        'Si la seconde infraction intervient avant que la première condamnation soit définitive, on est :',
    options: ['En récidive', 'En concours réel', 'En réitération'],
    answer: 'En concours réel',
    explanation:
        'La récidive nécessite une condamnation définitive antérieure à la seconde infraction.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question: 'Une condamnation ayant bénéficié d’une grâce :',
    options: [
      'Ne peut jamais servir de premier terme',
      'Peut servir de premier terme',
      'Est assimilée à une amnistie',
    ],
    answer: 'Peut servir de premier terme',
    explanation:
        'La grâce dispense d’exécuter la peine mais n’efface pas la condamnation.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Pluralité d’infractions — Réitération d’infractions',
    question: 'En cas de réitération, la confusion des peines est :',
    options: ['Obligatoire', 'Facultative', 'Exclue'],
    answer: 'Exclue',
    explanation:
        'La loi exclut toute possibilité de confusion des peines en cas de réitération.',
    difficulty: 'Facile',
  ),
  //////////////////////////////////////////////////////////////////////////////
  // CASIER JUDICIAIRE — BASE LÉGALE / DÉFINITION
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : notions',
    question:
        'L’organisation et le fonctionnement du casier judiciaire sont prévus par :',
    options: [
      'Les articles 768 et suivants du code de procédure pénale',
      'Les articles 132-8 à 132-11 du code pénal',
      'Le code de la route uniquement',
    ],
    answer: 'Les articles 768 et suivants du code de procédure pénale',
    explanation:
        'Le cours indique que le casier judiciaire est organisé par les articles 768 et suivants du CPP.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : notions',
    question: 'Le casier judiciaire national est :',
    options: [
      'Un fichier tenu uniquement par les préfectures',
      'Un casier judiciaire national automatisé, pouvant comporter un ou plusieurs centres de traitement',
      'Un registre tenu par chaque tribunal sans coordination',
    ],
    answer:
        'Un casier judiciaire national automatisé, pouvant comporter un ou plusieurs centres de traitement',
    explanation: 'Le cours évoque un “casier judiciaire national automatisé”.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : notions',
    question: 'Le casier judiciaire national automatisé dépend de l’autorité :',
    options: [
      'Du ministre de la Justice',
      'Du ministre de l’Intérieur',
      'Du préfet de département',
    ],
    answer: 'Du ministre de la Justice',
    explanation:
        'Le cours précise que le casier judiciaire national automatisé dépend de l’autorité du ministre de la Justice.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // BULLETIN N°1 — CONTENU / DESTINATAIRES / RETRAIT
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°1',
    question: 'Le bulletin n°1 correspond :',
    options: [
      'À un extrait expurgé',
      'À un relevé intégral des fiches concernant une personne',
      'À un relevé limité aux peines d’amende',
    ],
    answer: 'À un relevé intégral des fiches concernant une personne',
    explanation:
        'Le cours précise que le B1 est un relevé intégral contenant toutes les condamnations.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°1',
    question: 'Le bulletin n°1 contient :',
    options: [
      'Uniquement les condamnations les plus graves',
      'Toutes les condamnations (relevé intégral)',
      'Uniquement les décisions disciplinaires',
    ],
    answer: 'Toutes les condamnations (relevé intégral)',
    explanation: 'Le cours indique qu’il contient toutes les condamnations.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°1',
    question: 'Le bulletin n°1 ne peut être délivré qu’à :',
    options: [
      'La personne concernée',
      'Les autorités judiciaires',
      'Tout employeur qui le demande',
    ],
    answer: 'Les autorités judiciaires',
    explanation:
        'Le cours : le B1 est délivré uniquement aux autorités judiciaires (art. 774 CPP).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°1',
    question: 'Pour les personnes morales, le bulletin n°1 :',
    options: [
      'N’existe pas',
      'Comprend le relevé intégral des fiches applicables à la personne morale',
      'Est identique au bulletin n°3',
    ],
    answer:
        'Comprend le relevé intégral des fiches applicables à la personne morale',
    explanation:
        'Le cours indique un B1 spécifique pour les personnes morales (art. 774-1 CPP).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°1',
    question: 'Ne peuvent figurer au bulletin n°1 :',
    options: [
      'Les condamnations effacées par l’amnistie et celles ayant donné lieu à réhabilitation',
      'Toutes les condamnations correctionnelles',
      'Les condamnations prononcées en France',
    ],
    answer:
        'Les condamnations effacées par l’amnistie et celles ayant donné lieu à réhabilitation',
    explanation:
        'Le cours renvoie aux règles de retrait (art. 769, 769-1 et 770 CPP).',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // BULLETIN N°2 — CONTENU / DÉLIVRANCE / EXCLUSIONS
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°2',
    question: 'Le bulletin n°2 est :',
    options: [
      'Un relevé intégral',
      'Un relevé des fiches avec exclusion de certaines condamnations',
      'Un extrait délivré uniquement au condamné',
    ],
    answer: 'Un relevé des fiches avec exclusion de certaines condamnations',
    explanation: 'Le cours : B2 = relevé avec exclusions.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°2',
    question:
        'Le bulletin n°2 (personne physique) peut être délivré notamment :',
    options: [
      'Aux préfets et administrateurs publics pour certaines candidatures / emplois publics / distinctions',
      'À tout voisin de la personne concernée',
      'Uniquement à la personne concernée',
    ],
    answer:
        'Aux préfets et administrateurs publics pour certaines candidatures / emplois publics / distinctions',
    explanation:
        'Le cours liste les autorités pouvant obtenir le B2 (art. 775 et s. CPP).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°2',
    question: 'Le bulletin n°2 peut être délivré :',
    options: [
      'Aux autorités militaires et autorités compétentes en cas de contestation sur les droits électoraux',
      'À n’importe quelle entreprise privée sans condition',
      'Uniquement aux avocats',
    ],
    answer:
        'Aux autorités militaires et autorités compétentes en cas de contestation sur les droits électoraux',
    explanation: 'Le cours cite ces destinataires du B2 (art. 776 CPP).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°2',
    question:
        'Le bulletin n°2 peut être délivré aux présidents de tribunaux de commerce et juges commis :',
    options: [
      'Pour surveiller le registre du commerce',
      'Pour organiser des jurys d’assises',
      'Pour délivrer des permis de conduire',
    ],
    answer: 'Pour surveiller le registre du commerce',
    explanation:
        'Le cours cite ces autorités comme destinataires possibles du B2.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°2',
    question:
        'Le bulletin n°2 peut être demandé par les présidents de conseils départementaux :',
    options: [
      'Pour une demande d’agrément en vue d’adoption',
      'Pour une demande de naturalisation',
      'Pour une inscription au permis bateau',
    ],
    answer: 'Pour une demande d’agrément en vue d’adoption',
    explanation: 'Le cours liste ce cas dans les délivrances du B2.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°2',
    question:
        'Concernant le B2, le tribunal qui prononce une condamnation peut :',
    options: [
      'Interdire toute mention au casier définitivement',
      'Décider d’exclure la mention de la condamnation',
      'Annuler la condamnation automatiquement',
    ],
    answer: 'Décider d’exclure la mention de la condamnation',
    explanation:
        'Le cours précise que le tribunal peut exclure la mention au B2.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°2',
    question:
        'Lorsque la mention d’une décision est exclue du bulletin n°2, cela entraîne :',
    options: [
      'Le relèvement de toutes les interdictions, déchéances ou incapacités résultant de la condamnation',
      'La suppression de toutes les peines complémentaires',
      'La réhabilitation automatique',
    ],
    answer:
        'Le relèvement de toutes les interdictions, déchéances ou incapacités résultant de la condamnation',
    explanation:
        'Le cours indique cet effet, tout en précisant des exceptions.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°2',
    question:
        'Même si la mention est exclue du bulletin n°2, demeurent notamment :',
    options: [
      'Les peines complémentaires (ex : suspension du permis, interdiction de séjour)',
      'L’annulation de la peine d’amende',
      'L’effacement du jugement du B1',
    ],
    answer:
        'Les peines complémentaires (ex : suspension du permis, interdiction de séjour)',
    explanation:
        'Le cours précise que certaines peines complémentaires demeurent malgré l’exclusion de mention.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // BULLETIN N°2 — PERSONNES MORALES : DESTINATAIRES
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Casier judiciaire : B2 personne morale',
    question:
        'Le bulletin n°2 d’une personne morale peut être délivré notamment :',
    options: [
      'Aux préfets / administrations / collectivités locales pour adjudications ou marchés publics',
      'À toute personne physique sans justification',
      'Uniquement à la personne morale concernée',
    ],
    answer:
        'Aux préfets / administrations / collectivités locales pour adjudications ou marchés publics',
    explanation:
        'Le cours cite les destinataires du B2 des personnes morales (art. 776-1 CPP).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Casier judiciaire : B2 personne morale',
    question:
        'Le B2 d’une personne morale peut être délivré à l’Autorité des marchés financiers :',
    options: [
      'Pour les personnes morales demandant l’admission de leurs titres aux négociations sur un marché réglementé',
      'Pour délivrer un casier judiciaire à un salarié',
      'Pour un contrôle routier',
    ],
    answer:
        'Pour les personnes morales demandant l’admission de leurs titres aux négociations sur un marché réglementé',
    explanation: 'Le cours cite cette hypothèse.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // BULLETIN N°3 — DESTINATAIRES / PHILOSOPHIE / CONTENU
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°3',
    question: 'Le bulletin n°3 concerne :',
    options: [
      'Les personnes physiques uniquement',
      'Les personnes morales uniquement',
      'Les personnes physiques et morales',
    ],
    answer: 'Les personnes physiques uniquement',
    explanation:
        'Le cours précise que le B3 concerne exclusivement les personnes physiques.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°3',
    question: 'Le bulletin n°3 est :',
    options: [
      'Un relevé intégral',
      'Un extrait expurgé',
      'Une copie du bulletin n°1',
    ],
    answer: 'Un extrait expurgé',
    explanation: 'Le cours : B3 = extrait expurgé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°3',
    question: 'Le bulletin n°3 est délivré :',
    options: [
      'À toute administration',
      'Uniquement à la personne concernée (ou son représentant légal dans certains cas)',
      'Uniquement au procureur général',
    ],
    answer:
        'Uniquement à la personne concernée (ou son représentant légal dans certains cas)',
    explanation:
        'Le cours : délivré à la personne ou représentant légal (mineur / majeur sous tutelle).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : bulletin n°3',
    question:
        'Le législateur a limité le contenu du bulletin n°3 principalement pour :',
    options: [
      'Favoriser le reclassement du condamné',
      'Augmenter la publicité des condamnations',
      'Faciliter le cumul des peines',
    ],
    answer: 'Favoriser le reclassement du condamné',
    explanation:
        'Le cours indique que le B3 privilégie le reclassement en ne mentionnant que les infractions les plus graves.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // COMMUNICATION DES BULLETINS — DEMANDES (PERSONNES PHYSIQUES / MORALES)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : communication',
    question:
        'Pour obtenir communication du relevé intégral, la personne doit adresser sa demande :',
    options: [
      'Au maire',
      'Au procureur de la République du lieu de résidence',
      'Au tribunal administratif',
    ],
    answer: 'Au procureur de la République du lieu de résidence',
    explanation:
        'Le cours précise la demande au procureur de la République du lieu de résidence.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : communication',
    question: 'Pour obtenir communication, la personne doit :',
    options: [
      'Justifier de son identité',
      'Payer obligatoirement une amende',
      'Présenter un permis de conduire uniquement',
    ],
    answer: 'Justifier de son identité',
    explanation: 'Le cours précise que l’identité doit être justifiée.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : communication',
    question: 'Une personne morale doit adresser sa demande de communication :',
    options: [
      'Au procureur de la République du lieu du siège, via son représentant légal',
      'À la préfecture uniquement',
      'Au greffe du tribunal administratif',
    ],
    answer:
        'Au procureur de la République du lieu du siège, via son représentant légal',
    explanation: 'Le cours précise la procédure pour les personnes morales.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // UTILISATION PAR LE JUGE — PREUVE DE LA RÉCIDIVE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Casier judiciaire : preuve de la récidive',
    question:
        'Pour apporter la preuve de la récidive, le juge se base essentiellement sur :',
    options: [
      'Le casier judiciaire',
      'Les réseaux sociaux',
      'Le témoignage du voisinage uniquement',
    ],
    answer: 'Le casier judiciaire',
    explanation:
        'Le cours indique que le juge se base essentiellement sur le casier judiciaire pour prouver la récidive.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Casier judiciaire : preuve de la récidive',
    question: 'Les mentions de quel bulletin font preuve de la récidive ?',
    options: ['Bulletin n°1', 'Bulletin n°2', 'Bulletin n°3'],
    answer: 'Bulletin n°1',
    explanation:
        'Le cours indique que les mentions du bulletin n°1 font preuve de la récidive.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Casier judiciaire : preuve de la récidive',
    question:
        'Si l’intéressé conteste les mentions du casier, le ministère public doit :',
    options: [
      'Classer l’affaire sans suite',
      'Demander aux greffes des tribunaux copie des décisions de condamnation',
      'Se contenter du bulletin n°3',
    ],
    answer:
        'Demander aux greffes des tribunaux copie des décisions de condamnation',
    explanation: 'Le cours prévoit cette démarche en cas de contestation.',
    difficulty: 'Difficile',
  ),
  //////////////////////////////////////////////////////////////////////////////
  // BLOC 6 — CONCOURS RÉEL D’INFRACTIONS : NOTION (ART. 132-2 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Concours réel : notion',
    question:
        'Selon l’article 132-2 du code pénal, il y a concours d’infractions lorsque :',
    options: [
      'Plusieurs infractions sont commises après une condamnation définitive',
      'Une infraction est commise avant une condamnation définitive pour une autre infraction',
      'Deux infractions sont identiques et commises à 5 ans d’intervalle',
    ],
    answer:
        'Une infraction est commise avant une condamnation définitive pour une autre infraction',
    explanation:
        'Le cours cite l’art. 132-2 C.P. : concours si une infraction est commise avant condamnation définitive pour une autre.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Concours réel : notion',
    question: 'Le concours réel correspond à la situation dans laquelle :',
    options: [
      'Un individu commet plusieurs infractions non séparées par une condamnation définitive',
      'Un individu commet une seule infraction avec plusieurs victimes',
      'Une contravention est commise en récidive',
    ],
    answer:
        'Un individu commet plusieurs infractions non séparées par une condamnation définitive',
    explanation:
        'Définition du cours : plusieurs infractions sans condamnation définitive entre elles.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Concours réel : hypothèses',
    question:
        'Un individu commet un vol, est jugé mais le jugement n’est pas définitif, puis commet un nouveau vol. Il s’agit :',
    options: [
      'D’une réitération',
      'D’un concours réel',
      'D’une récidive légale',
    ],
    answer: 'D’un concours réel',
    explanation:
        'La 1re condamnation n’est pas définitive : on est en concours réel (art. 132-2 C.P.).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Concours réel : hypothèses',
    question:
        'Un individu outrage un gardien de la paix, se rebelle, puis commet des violences lors de la même intervention :',
    options: [
      'Infractions en concours réel (quasi concomitantes)',
      'Une seule infraction',
      'Récidive contraventionnelle',
    ],
    answer: 'Infractions en concours réel (quasi concomitantes)',
    explanation:
        'Le cours donne l’exemple d’infractions quasi concomitantes (outrage, rébellion, violences).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Concours réel : vocabulaire',
    question: 'Le terme “concours idéal” est utilisé lorsque :',
    options: [
      'Les mêmes faits peuvent recevoir plusieurs qualifications',
      'Deux infractions sont commises à 10 ans d’intervalle',
      'Une infraction est commise après une condamnation définitive',
    ],
    answer: 'Les mêmes faits peuvent recevoir plusieurs qualifications',
    explanation: 'Le cours : conflit de qualifications = “concours idéal”.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // BLOC 7 — SOLUTION LÉGALE : ART. 132-3 / 132-4 + PRINCIPES
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Concours réel : solution légale',
    question:
        'Sous l’ancien code pénal (art. 5), le principe en cas de plusieurs crimes ou délits était :',
    options: [
      'Le cumul illimité des peines',
      'La confusion : seule la peine la plus forte était prononcée',
      'La suppression des amendes',
    ],
    answer: 'La confusion : seule la peine la plus forte était prononcée',
    explanation:
        'Le cours rappelle l’art. 5 ancien : seule la peine la plus forte était prononcée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Concours réel : art. 132-3',
    question:
        'En cas de concours de plusieurs infractions poursuivies dans une même procédure (art. 132-3 C.P.), le juge peut :',
    options: [
      'Prononcer chacune des peines encourues',
      'Prononcer uniquement la peine la plus forte',
      'Prononcer uniquement des peines complémentaires',
    ],
    answer: 'Prononcer chacune des peines encourues',
    explanation:
        'Art. 132-3 : chacune des peines encourues peut être prononcée (avec limites pour peines de même nature).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Concours réel : art. 132-3',
    question:
        'Quand plusieurs peines de même nature sont encourues en poursuite unique (art. 132-3 C.P.), il est prononcé :',
    options: [
      'Une peine unique dans la limite du maximum légal le plus élevé',
      'Autant de peines que d’infractions, sans plafond',
      'Une peine unique dans la limite du minimum légal le plus élevé',
    ],
    answer: 'Une peine unique dans la limite du maximum légal le plus élevé',
    explanation:
        'Le cours : une seule peine de même nature, plafonnée au maximum légal le plus élevé.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Concours réel : art. 132-4',
    question:
        'En cas de concours poursuivi à l’occasion de procédures distinctes (art. 132-4 C.P.), les peines :',
    options: [
      'S’exécutent cumulativement dans la limite du maximum légal le plus élevé',
      'Se confondent automatiquement sans plafond',
      'Sont annulées si elles concernent des délits',
    ],
    answer:
        'S’exécutent cumulativement dans la limite du maximum légal le plus élevé',
    explanation:
        'Art. 132-4 : exécution cumulative plafonnée, avec possibilité de confusion.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Concours réel : art. 132-4',
    question:
        'Toujours selon l’art. 132-4 C.P., la confusion des peines de même nature peut être :',
    options: ['Totale ou partielle', 'Uniquement totale', 'Interdite'],
    answer: 'Totale ou partielle',
    explanation:
        'Le cours précise la possibilité de confusion totale ou partielle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Concours réel : philosophie',
    question: 'Le cours indique que le principe général en concours réel est :',
    options: [
      'Le non-cumul, mais atténué',
      'Le cumul illimité systématique',
      'La confusion obligatoire systématique',
    ],
    answer: 'Le non-cumul, mais atténué',
    explanation: 'Formule du cours : principe général du non-cumul, atténué.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // BLOC 8 — CONFLITS DE QUALIFICATIONS : NON BIS IN IDEM / INCOMPATIBLES / ABSORBANTES
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Conflits de qualifications',
    question: 'Le conflit de qualifications apparaît lorsque :',
    options: [
      'Les faits peuvent constituer des infractions distinctes réprimées par des textes différents',
      'Deux infractions sont commises après 5 ans',
      'Il existe une condamnation définitive antérieure',
    ],
    answer:
        'Les faits peuvent constituer des infractions distinctes réprimées par des textes différents',
    explanation:
        'Le cours : conflit de qualifications si mêmes faits susceptibles de plusieurs infractions.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Conflits de qualifications',
    question: 'Le principe est :',
    options: [
      'Interdiction du cumul de qualifications pour des mêmes faits',
      'Obligation de retenir toutes les qualifications possibles',
      'Possibilité de retenir toutes les qualifications même incompatibles',
    ],
    answer: 'Interdiction du cumul de qualifications pour des mêmes faits',
    explanation:
        'Le cours : interdiction du cumul de qualifications si les faits sont identiques.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Conflits de qualifications : incompatibles',
    question: 'Les qualifications sont dites incompatibles lorsque :',
    options: [
      'La caractérisation de l’une exclut la caractérisation de l’autre',
      'Elles visent des faits différents',
      'Elles relèvent de juridictions différentes',
    ],
    answer: 'La caractérisation de l’une exclut la caractérisation de l’autre',
    explanation:
        'Le cours : qualifications incompatibles/exclusives, impossibilité de retenir les deux.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Conflits de qualifications : exemples',
    question:
        'Selon le cours, est un exemple de qualifications incompatibles :',
    options: [
      'Le meurtre et l’homicide involontaire',
      'Le vol et l’escroquerie',
      'Le faux et l’escroquerie',
    ],
    answer: 'Le meurtre et l’homicide involontaire',
    explanation:
        'Le cours cite meurtre / homicide involontaire comme incompatibles.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Conflits de qualifications : exemples',
    question:
        'Selon le cours, est un exemple de qualifications incompatibles :',
    options: [
      'Le recel et l’infraction d’origine',
      'L’outrage et la rébellion',
      'L’escroquerie et l’abus de confiance',
    ],
    answer: 'Le recel et l’infraction d’origine',
    explanation:
        'Le cours cite recel et infraction d’origine comme incompatibles.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Non bis in idem',
    question: 'La règle “non bis in idem” signifie :',
    options: [
      'Pas deux fois pour la même chose',
      'Toujours doubler la peine',
      'Confusion obligatoire des peines',
    ],
    answer: 'Pas deux fois pour la même chose',
    explanation:
        'Le cours : non bis in idem = pas de double déclaration de culpabilité pour un même fait autrement qualifié.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Non bis in idem : formulation',
    question: 'Selon le cours, la Cour de cassation énonce que :',
    options: [
      'Un même fait autrement qualifié ne peut donner lieu à plusieurs déclarations de culpabilité',
      'Toute qualification doit être cumulée',
      'Le juge doit prononcer toutes les peines sans plafond',
    ],
    answer:
        'Un même fait autrement qualifié ne peut donner lieu à plusieurs déclarations de culpabilité',
    explanation: 'Formule du cours relative à la règle non bis in idem.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Qualifications absorbantes',
    question: 'Il y a “qualification absorbante” lorsque :',
    options: [
      'Une qualification correspond à un élément constitutif ou une circonstance aggravante de l’autre',
      'Les faits sont distincts et séparés',
      'Les infractions sont commises dans deux pays différents',
    ],
    answer:
        'Une qualification correspond à un élément constitutif ou une circonstance aggravante de l’autre',
    explanation:
        'Le cours décrit les qualifications absorbantes de cette façon.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Qualifications générales/spéciales',
    question:
        'Le conflit “qualification générale / qualification spéciale” signifie que :',
    options: [
      'La qualification spéciale incrimine une modalité particulière de l’action réprimée par la générale',
      'La qualification générale est toujours retenue en plus',
      'Les deux qualifications doivent toujours être cumulées',
    ],
    answer:
        'La qualification spéciale incrimine une modalité particulière de l’action réprimée par la générale',
    explanation: 'Le cours : spéciale = modalité particulière de la générale.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // BLOC 9 — DOMAINES D’APPLICATION + ATTÉNUATIONS/EXCLUSIONS + EXCEPTIONS SPÉCIALES
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Non-cumul : portée',
    question: 'La règle du non-cumul des peines en concours réel a :',
    options: [
      'Une vocation générale',
      'Une vocation limitée aux crimes',
      'Une vocation limitée aux contraventions',
    ],
    answer: 'Une vocation générale',
    explanation: 'Le cours : principe d’application générale.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Atténuations : contraventions',
    question: 'Selon l’article 132-7 C.P., en matière de contraventions :',
    options: [
      'Les amendes se confondent automatiquement',
      'Les amendes pour contraventions se cumulent entre elles',
      'Le plafond est toujours le maximum légal le plus élevé',
    ],
    answer: 'Les amendes pour contraventions se cumulent entre elles',
    explanation: 'Art. 132-7 : cumul des amendes contraventionnelles.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Atténuations : sanctions non pénales',
    question:
        'La jurisprudence exclut la règle du non-cumul lorsque sont en concours :',
    options: [
      'Une peine et une sanction disciplinaire',
      'Deux délits',
      'Un crime et un délit',
    ],
    answer: 'Une peine et une sanction disciplinaire',
    explanation:
        'Le cours : non-cumul écarté en concours peine + sanction disciplinaire.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Atténuations : fiscal',
    question: 'Selon le cours, les amendes fiscales :',
    options: [
      'Se confondent avec les peines de droit commun',
      'Se cumulent avec les peines de droit commun',
      'Annulent la peine pénale',
    ],
    answer: 'Se cumulent avec les peines de droit commun',
    explanation:
        'Le cours précise que les amendes fiscales se cumulent avec les peines de droit commun.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Exclusion : nature des peines',
    question:
        'Selon l’article 132-5 C.P., les peines privatives de liberté sont :',
    options: [
      'De même nature',
      'Toujours de nature différente',
      'Incompatibles avec les amendes',
    ],
    answer: 'De même nature',
    explanation: 'Le cours : art. 132-5, privatives de liberté = même nature.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Exclusion : nature des peines',
    question:
        'Conséquence (art. 132-5) : des peines privatives de liberté ne peuvent se cumuler que :',
    options: [
      'Sans plafond',
      'Dans la limite du maximum de la peine la plus forte',
      'Dans la limite du minimum le plus élevé',
    ],
    answer: 'Dans la limite du maximum de la peine la plus forte',
    explanation:
        'Le cours : cumul plafonné au maximum de la peine la plus forte pour peines de même nature.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Peines complémentaires',
    question: 'En concours réel, les peines complémentaires :',
    options: [
      'Peuvent se cumuler',
      'Sont toujours confondues automatiquement',
      'Sont interdites',
    ],
    answer: 'Peuvent se cumuler',
    explanation:
        'Le cours : les peines complémentaires peuvent se cumuler en concours réel.',
    difficulty: 'Facile',
  ),

  // EXCEPTIONS SPÉCIALES (cumul imposé)
  const QuizQuestion(
    category: 'Pluralité d’infractions — Exceptions : évasion',
    question:
        'Selon l’article 434-31 C.P., les peines prononcées pour l’évasion :',
    options: [
      'Se confondent avec celles déjà subies',
      'Se cumulent avec celles subies ou prononcées ultérieurement',
      'Sont remplacées par une amende',
    ],
    answer: 'Se cumulent avec celles subies ou prononcées ultérieurement',
    explanation: 'Le cours : art. 434-31, cumul des peines d’évasion.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Exceptions : rébellion de prisonniers',
    question:
        'Selon l’article 433-9 C.P., la peine pour rébellion (de prisonniers) :',
    options: [
      'Se cumule avec celle que l’intéressé subissait',
      'Se confond toujours',
      'Est automatiquement réduite',
    ],
    answer: 'Se cumule avec celle que l’intéressé subissait',
    explanation: 'Le cours : art. 433-9, cumul avec la peine en cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Exceptions : usurpation d’identité',
    question:
        'Selon l’article 434-23 C.P., les peines pour usurpation d’identité :',
    options: [
      'Se cumulent avec celles réprimant l’infraction à l’occasion de laquelle l’usurpation a été commise',
      'Se confondent automatiquement',
      'Sont exclues en concours',
    ],
    answer:
        'Se cumulent avec celles réprimant l’infraction à l’occasion de laquelle l’usurpation a été commise',
    explanation: 'Le cours cite l’exception de cumul de l’art. 434-23.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Exceptions : insolvabilité',
    question:
        'Selon l’article 314-8 al. 2 C.P., en matière d’organisation frauduleuse d’insolvabilité, le tribunal peut décider :',
    options: [
      'La confusion obligatoire',
      'L’absence de confusion avec la peine précédemment prononcée',
      'L’effacement du casier',
    ],
    answer: 'L’absence de confusion avec la peine précédemment prononcée',
    explanation:
        'Le cours : art. 314-8 al. 2, le tribunal peut décider de ne pas confondre.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Exceptions : refus d’obtempérer',
    question:
        'Selon l’article L.233-1/II du code de la route, les peines pour refus d’obtempérer :',
    options: [
      'Se cumulent avec celles des autres infractions commises à l’occasion de la conduite',
      'Se confondent toujours',
      'Ne peuvent jamais être prononcées en concours',
    ],
    answer:
        'Se cumulent avec celles des autres infractions commises à l’occasion de la conduite',
    explanation:
        'Le cours cite l’exception de cumul en matière de refus d’obtempérer.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Exceptions : CDO en détention',
    question:
        'Selon l’article 132-6-1 C.P., lorsqu’une infraction (706-73 / 706-73-1 CPP) est commise pendant la détention :',
    options: [
      'Les peines se cumulent sans possibilité de confusion avec celles liées à la détention',
      'Les peines se confondent automatiquement',
      'Aucune peine ne peut être prononcée',
    ],
    answer:
        'Les peines se cumulent sans possibilité de confusion avec celles liées à la détention',
    explanation: 'Le cours : art. 132-6-1, cumul sans confusion en principe.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Exceptions : CDO en détention',
    question:
        'Toujours selon l’article 132-6-1 C.P., la dernière juridiction peut décider de ne pas appliquer ces dispositions :',
    options: [
      'Oui, par décision spécialement motivée',
      'Non, jamais',
      'Oui, sans motivation',
    ],
    answer: 'Oui, par décision spécialement motivée',
    explanation:
        'Le cours : la dernière juridiction peut écarter, par décision spécialement motivée.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // BLOC 10 — MISE EN ŒUVRE : POURSUITE UNIQUE vs PLURALITÉ DE POURSUITES + CONFUSION
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Mise en œuvre : poursuite unique',
    question: 'En poursuite unique, les infractions en concours :',
    options: [
      'Donnent lieu à des poursuites devant une juridiction unique',
      'Sont obligatoirement disjointes',
      'Ne peuvent pas être jugées ensemble',
    ],
    answer: 'Donnent lieu à des poursuites devant une juridiction unique',
    explanation:
        'Le cours : poursuite unique = juridiction unique examinant chaque infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Mise en œuvre : poursuite unique',
    question:
        'En poursuite unique, le cumul des peines de nature différente est :',
    options: [
      'Autorisé (art. 132-3 C.P.)',
      'Interdit',
      'Automatiquement confondu',
    ],
    answer: 'Autorisé (art. 132-3 C.P.)',
    explanation:
        'Le cours : art. 132-3 autorise le prononcé cumulatif de peines de nature différente.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Mise en œuvre : poursuite unique',
    question: 'En poursuite unique, le cumul a un caractère :',
    options: [
      'Obligatoire',
      'Facultatif : le juge peut ne prononcer que certaines peines',
      'Interdit sauf contraventions',
    ],
    answer: 'Facultatif : le juge peut ne prononcer que certaines peines',
    explanation:
        'Le cours : cumul autorisé mais pas obligatoire, le juge peut ne prononcer que certaines peines.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Mise en œuvre : peine la plus forte',
    question:
        'Pour déterminer la peine la plus forte encourue, le cours précise qu’il faut tenir compte :',
    options: [
      'Uniquement du maximum légal abstrait',
      'Des causes de diminution (minorité) et d’aggravation (récidive)',
      'Uniquement des amendes',
    ],
    answer: 'Des causes de diminution (minorité) et d’aggravation (récidive)',
    explanation:
        'Le cours : maximum le plus élevé en tenant compte des causes de diminution/aggravation.',
    difficulty: 'Difficile',
  ),

  // Cas pratique “vol + escroquerie”
  const QuizQuestion(
    category: 'Pluralité d’infractions — Poursuite unique : cas pratique',
    question:
        'Vol + escroquerie en concours réel (poursuite unique) : la peine d’emprisonnement prononcée ne peut dépasser :',
    options: [
      'La somme des maximums',
      'Le maximum légal le plus élevé',
      'Le minimum légal le plus élevé',
    ],
    answer: 'Le maximum légal le plus élevé',
    explanation:
        'En poursuite unique, peine unique de même nature plafonnée au maximum légal le plus élevé.',
    difficulty: 'Moyenne',
  ),

  // Pluralité de poursuites
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Mise en œuvre : pluralité de poursuites',
    question: 'La pluralité de poursuites correspond notamment au cas où :',
    options: [
      'Les infractions relèvent de tribunaux différents ou n’ont pas été découvertes en même temps',
      'Le parquet choisit la CRPC',
      'La victime retire plainte',
    ],
    answer:
        'Les infractions relèvent de tribunaux différents ou n’ont pas été découvertes en même temps',
    explanation:
        'Le cours : pluralité de poursuites si compétences différentes ou découverte séparée.',
    difficulty: 'Moyenne',
  ),

  // Confusion : principe
  const QuizQuestion(
    category: 'Pluralité d’infractions — Confusion des peines : principe',
    question:
        'En pluralité de poursuites, lorsque les peines de même nature cumulées dépassent le maximum légal :',
    options: [
      'La confusion est obligatoire',
      'La confusion est interdite',
      'Le juge doit doubler la peine',
    ],
    answer: 'La confusion est obligatoire',
    explanation: 'Le cours : si cumul > maximum légal, confusion obligatoire.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Confusion des peines : principe',
    question:
        'Lorsque le cumul aboutit à une peine au-dessous du maximum légal :',
    options: [
      'La confusion est une possibilité laissée au juge',
      'La confusion est obligatoire',
      'Aucune confusion n’est possible',
    ],
    answer: 'La confusion est une possibilité laissée au juge',
    explanation:
        'Le cours : si cumul < maximum, confusion possible mais non obligatoire.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Confusion des peines : portée',
    question: 'La confusion des peines peut être :',
    options: [
      'Totale ou partielle',
      'Uniquement partielle',
      'Uniquement totale',
    ],
    answer: 'Totale ou partielle',
    explanation: 'Le cours : confusion totale ou partielle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Confusion des peines : peines complémentaires',
    question: 'La confusion peut s’appliquer :',
    options: [
      'Aux peines complémentaires de même nature',
      'Uniquement aux amendes',
      'Uniquement aux peines perpétuelles',
    ],
    answer: 'Aux peines complémentaires de même nature',
    explanation:
        'Le cours : confusion possible pour peines complémentaires de même nature.',
    difficulty: 'Moyenne',
  ),

  // Peines perpétuelles
  const QuizQuestion(
    category: 'Pluralité d’infractions — Confusion : perpétuité',
    question: 'Le cours indique que les peines perpétuelles :',
    options: [
      'Se cumulent entre elles',
      'Se confondent entre elles',
      'Sont remplacées par 30 ans',
    ],
    answer: 'Se confondent entre elles',
    explanation:
        'Le cours : les peines perpétuelles se confondent entre elles.',
    difficulty: 'Moyenne',
  ),

  // Effets de la confusion
  const QuizQuestion(
    category: 'Pluralité d’infractions — Confusion des peines : effets',
    question:
        'La confusion enlève aux peines confondues leur existence propre :',
    options: ['Oui', 'Non', 'Uniquement pour les amendes'],
    answer: 'Non',
    explanation:
        'Le cours : les condamnations subsistent, la confusion n’efface pas l’existence propre des peines.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Confusion des peines : effets',
    question:
        'Selon le cours, l’exécution de la peine la plus forte entraîne :',
    options: [
      'L’exécution “en même temps” des peines plus faibles (censées s’exécuter simultanément)',
      'L’annulation des peines plus faibles',
      'La transformation en amende',
    ],
    answer:
        'L’exécution “en même temps” des peines plus faibles (censées s’exécuter simultanément)',
    explanation:
        'Le cours : l’exécution de la plus forte entraîne celle des plus faibles, censées s’exécuter en même temps.',
    difficulty: 'Moyenne',
  ),

  // Procédure de la confusion : art. 132-4 CP et 710-1 CPP
  const QuizQuestion(
    category: 'Pluralité d’infractions — Confusion des peines : procédure',
    question: 'La procédure de confusion des peines est prévue notamment par :',
    options: [
      'Les articles 132-4 C.P. et 710-1 C.P.P.',
      'Les articles 132-8 à 132-11 C.P.',
      'L’article 222-33 C.P.',
    ],
    answer: 'Les articles 132-4 C.P. et 710-1 C.P.P.',
    explanation: 'Le cours cite expressément 132-4 C.P. et 710-1 C.P.P.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Confusion des peines : procédure',
    question:
        'La juridiction saisie de la 2e infraction, si elle connaît le passé judiciaire, peut :',
    options: [
      'Prononcer la confusion des peines',
      'Annuler la 1re condamnation',
      'Interdire toute peine complémentaire',
    ],
    answer: 'Prononcer la confusion des peines',
    explanation:
        'Le cours : la juridiction de la 2e infraction peut prononcer la confusion.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Confusion des peines : requête',
    question:
        'Si la juridiction ne s’est pas prononcée sur la confusion, une requête peut être adressée au procureur de la République par :',
    options: [
      'Le condamné ou le surveillant-chef de l’établissement',
      'Uniquement la victime',
      'Uniquement le préfet',
    ],
    answer: 'Le condamné ou le surveillant-chef de l’établissement',
    explanation: 'Le cours cite ces deux possibilités.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Confusion des peines : compétence',
    question:
        'Après définitivité, la demande de confusion de peines du condamné est portée devant :',
    options: [
      'Le tribunal correctionnel',
      'La cour d’assises',
      'Le tribunal administratif',
    ],
    answer: 'Le tribunal correctionnel',
    explanation:
        'Le cours : demande portée devant le tribunal correctionnel (décision susceptible d’appel).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Confusion des peines : appel',
    question:
        'La décision du tribunal correctionnel sur la confusion peut faire l’objet :',
    options: [
      'D’un appel devant la chambre des appels correctionnels',
      'Uniquement d’un pourvoi direct en cassation sans appel',
      'D’aucun recours',
    ],
    answer: 'D’un appel devant la chambre des appels correctionnels',
    explanation: 'Le cours mentionne la possibilité d’appel.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Confusion des peines : tribunaux compétents',
    question: 'Sont compétents pour statuer sur la confusion :',
    options: [
      'Le ou les tribunaux ayant prononcé les peines, ou celui du siège d’une des juridictions',
      'Uniquement le tribunal du domicile de la victime',
      'Uniquement la cour d’assises',
    ],
    answer:
        'Le ou les tribunaux ayant prononcé les peines, ou celui du siège d’une des juridictions',
    explanation: 'Le cours liste ces compétences.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Pluralité d’infractions — Confusion des peines : lieu de détention',
    question:
        'Le cours précise aussi que la juridiction compétente peut être :',
    options: [
      'La juridiction du lieu de détention',
      'Uniquement celle du lieu de commission des faits',
      'Uniquement celle du siège social',
    ],
    answer: 'La juridiction du lieu de détention',
    explanation:
        'Le cours indique que la juridiction du lieu de détention est compétente.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // BLOC 6→10 — PACK CAS PRATIQUES / QCM PIÈGES (RENFORCEMENT)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Cas pratique : non bis in idem',
    question:
        'Un même fait est qualifié à la fois de “viol commis par violence” et de “violences volontaires” sur les mêmes faits. Le cours indique qu’on est dans :',
    options: [
      'Un cumul obligatoire de qualifications',
      'Une hypothèse de qualification absorbante (non bis in idem)',
      'Un concours réel automatique',
    ],
    answer: 'Une hypothèse de qualification absorbante (non bis in idem)',
    explanation:
        'Le cours : une qualification peut absorber l’autre si elle constitue un élément/circonstance de l’autre.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Cas pratique : cumul possible',
    question:
        'Un accident cause un décès et une autre victime blessée avec I.T.T. ≤ 3 mois :',
    options: [
      'Cumul possible (homicide involontaire + atteintes involontaires)',
      'Qualifications incompatibles',
      'Non bis in idem interdit tout cumul',
    ],
    answer: 'Cumul possible (homicide involontaire + atteintes involontaires)',
    explanation:
        'Le cours donne cet exemple de cumul possible : victimes différentes et éléments distincts.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Cas pratique : faux & escroquerie',
    question:
        'Production de fausses attestations et tromperie pour obtenir la vente : le cours indique que l’auteur peut être poursuivi cumulativement pour :',
    options: [
      'Faux/usage de faux + escroquerie',
      'Recel + infraction d’origine',
      'Meurtre + homicide involontaire',
    ],
    answer: 'Faux/usage de faux + escroquerie',
    explanation:
        'Le cours : faux/usage de faux et escroquerie ne sont pas incompatibles et ne s’absorbent pas nécessairement.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Piège : faits distincts',
    question:
        'Si les faits incriminés sont distincts, le cumul de qualifications est :',
    options: [
      'Possible, même si l’intention est unique',
      'Toujours interdit',
      'Toujours absorbé par la qualification la plus grave',
    ],
    answer: 'Possible, même si l’intention est unique',
    explanation:
        'Le cours : si faits distincts, le cumul de qualifications n’est pas interdit même s’ils sont indissociables.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : pièges',
    question:
        'Un extrait délivré uniquement à la personne concernée correspond :',
    options: ['Au bulletin n°1', 'Au bulletin n°2', 'Au bulletin n°3'],
    answer: 'Au bulletin n°3',
    explanation:
        'Le B3 est délivré uniquement à l’intéressé (ou représentant légal dans certains cas).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : pièges',
    question:
        'Une condamnation effacée par amnistie peut-elle encore figurer au B1 ?',
    options: ['Oui, toujours', 'Non', 'Uniquement si l’amende n’est pas payée'],
    answer: 'Non',
    explanation:
        'Le cours : les condamnations effacées par l’amnistie ne peuvent figurer au B1.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : pièges',
    question: 'Le B2 peut être utilisé pour :',
    options: [
      'Un recrutement en emploi public (dans les cas prévus)',
      'N’importe quel recrutement privé sans base légale',
      'Prouver directement la récidive en audience',
    ],
    answer: 'Un recrutement en emploi public (dans les cas prévus)',
    explanation:
        'Le cours liste des cas de délivrance (emplois publics, distinctions, etc.).',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // SÉRIES “QUI PEUT L’OBTENIR ?” — BULLETIN N°2 (ENTRAINEMENT)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : B2 destinataires',
    question:
        'Le bulletin n°2 peut être délivré aux autorités compétentes pour recevoir les déclarations de candidatures à une élection afin de vérifier certaines peines d’inéligibilité :',
    options: ['Oui', 'Non', 'Seulement pour le bulletin n°3'],
    answer: 'Oui',
    explanation:
        'Le cours cite ce cas : vérification des mentions liées à certaines peines (131-26 et suivants).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : B2 destinataires',
    question:
        'Le bulletin n°2 peut être délivré à des dirigeants de personnes morales exerçant auprès des mineurs, pour le recrutement, sous condition que :',
    options: [
      'Le bulletin ne porte la mention d’aucune condamnation',
      'Le candidat soit majeur',
      'Le candidat ait déjà un casier',
    ],
    answer: 'Le bulletin ne porte la mention d’aucune condamnation',
    explanation:
        'Le cours mentionne cette délivrance spécifique et conditionnée.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PACK “DIFFÉRENCES” — B1 / B2 / B3
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : comparatif',
    question: 'Quel bulletin est un relevé intégral ?',
    options: ['B1', 'B2', 'B3'],
    answer: 'B1',
    explanation: 'Le B1 est le relevé intégral des fiches.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : comparatif',
    question: 'Quel bulletin est un relevé avec exclusions ?',
    options: ['B1', 'B2', 'B3'],
    answer: 'B2',
    explanation: 'Le B2 exclut certaines condamnations.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : comparatif',
    question:
        'Quel bulletin est un extrait expurgé délivré au seul intéressé ?',
    options: ['B1', 'B2', 'B3'],
    answer: 'B3',
    explanation: 'Le B3 est l’extrait expurgé remis à la personne concernée.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUESTIONS “CASIER & RÉCIDIVE” — LIENS DIRECTS
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire & récidive',
    question:
        'Pour que la récidive puisse être retenue, la condamnation antérieure doit être :',
    options: [
      'N’importe quelle sanction administrative',
      'Inscrite au casier judiciaire au moment des faits',
      'Effacée par amnistie',
    ],
    answer: 'Inscrite au casier judiciaire au moment des faits',
    explanation:
        'Le cours indique que la condamnation doit encore être inscrite au casier au moment de la seconde infraction.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire & récidive',
    question:
        'Une condamnation effacée par amnistie peut servir de premier terme de récidive :',
    options: ['Oui', 'Non', 'Uniquement si la peine a été exécutée'],
    answer: 'Non',
    explanation:
        'Le cours : si la condamnation a été effacée (amnistie), elle ne peut plus servir de premier terme.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : contestation',
    question:
        'Si l’intéressé conteste le contenu utilisé pour établir la récidive, la preuve peut nécessiter :',
    options: [
      'Uniquement un témoignage',
      'Des copies des décisions de condamnation auprès des greffes',
      'Une expertise psychiatrique obligatoire',
    ],
    answer: 'Des copies des décisions de condamnation auprès des greffes',
    explanation:
        'Le cours indique que le ministère public doit demander copie des décisions aux greffes.',
    difficulty: 'Moyenne',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizSanctionGPX extends StatefulWidget {
  static const String grade = 'gpx';
  static const String routeName = '/gpx/sanction/quiz/sanction_page';
  final String uid;
  final String email;

  const QuizSanctionGPX({super.key, required this.uid, required this.email});

  @override
  State<QuizSanctionGPX> createState() => _QuizSanctionGPXState();
}

class _QuizSanctionGPXState extends State<QuizSanctionGPX>
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
  static const _introHiddenKey = 'intro_gpx_sanction';
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
        ? questionGPPluraliteInfractions
        : questionGPPluraliteInfractions
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
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Sanction',
            'quiz_name': 'Sanction Page',
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
            'score': percent,
            'correct_count': _score,
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
      await _sb.from('quiz_sanction_page').insert({
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
      debugPrint('❌ quiz_sanction_page insert failed: $e');
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
      'source_file': 'gpx_quiz_sanction',
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
                            icon: Icons.gavel_rounded,
                            title: 'Sanctions',
                            description: 'Maîtrise les différentes sanctions pénales : peines principales, complémentaires, alternatives et le régime d’application des peines.',
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
