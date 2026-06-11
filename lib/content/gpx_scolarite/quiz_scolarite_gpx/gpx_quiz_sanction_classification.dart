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
final List<QuizQuestion> questionGPXSchoolSanctionClassification = [
  //////////////////////////////////////////////////////////////////////////////
  // CLASSIFICATION LÉGALE DES PEINES — GÉNÉRALITÉS
  //////////////////////////////////////////////////////////////////////////////
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
];

// ============================================================================
// PAGE
// ============================================================================
class QuizSanctionClassificationGPX extends StatefulWidget {
  static const String grade = 'gpx';
  static const String routeName =
      '/gpx/sanction/quiz/sanction_classification_peine';
  final String uid;
  final String email;

  const QuizSanctionClassificationGPX({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizSanctionClassificationGPX> createState() => _QuizSanctionClassificationGPXState();
}

class _QuizSanctionClassificationGPXState extends State<QuizSanctionClassificationGPX>
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
  static const _introHiddenKey = 'intro_gpx_sanction_classification';
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
        ? questionGPXSchoolSanctionClassification
        : questionGPXSchoolSanctionClassification
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
            'quiz_name': 'Sanction classification des peines',
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
      await _sb.from('quiz_sanction_classification_peine').insert({
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
      debugPrint('❌ quiz_sanction_classification_peine insert failed: $e');
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
      'source_file': 'gpx_quiz_sanction_classification',
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
                            icon: Icons.sort_rounded,
                            title: 'Classification des sanctions',
                            description: 'Distingue les catégories de peines : emprisonnement, amende, travaux d’intérêt général et sursis avec leur régime juridique.',
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
