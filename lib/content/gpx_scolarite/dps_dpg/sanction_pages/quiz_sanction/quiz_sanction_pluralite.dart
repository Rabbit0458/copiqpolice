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

final List<QuizQuestion> questionGPPluraliteInfractions = [
  //////////////////////////////////////////////////////////////////////////////
  // RÉITÉRATION D’INFRACTIONS — NOTION ET CONDITIONS
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pluralité d’infractions — Réitération d’infractions',
    question: 'La notion de réitération a été consacrée par la loi du :',
    options: ['9 mars 2004', '12 décembre 2005', '23 mars 2019'],
    answer: '12 décembre 2005',
    explanation:
        'La loi du 12 décembre 2005 a consacré la notion de réitération jusque-là jurisprudentielle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question:
        'Un acquittement peut-il constituer le premier terme de la récidive ?',
    options: ['Oui', 'Non', 'Uniquement en matière contraventionnelle'],
    answer: 'Non',
    explanation:
        'Un acquittement ne constitue pas une condamnation et ne peut servir de premier terme.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question:
        'Une mesure de rééducation prononcée à l’encontre d’un mineur peut constituer le premier terme :',
    options: ['Oui', 'Non', 'Uniquement pour les délits'],
    answer: 'Non',
    explanation: 'Les mesures de rééducation ne constituent pas des peines.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : premier terme',
    question:
        'Une condamnation avec sursis non révoqué peut constituer le premier terme :',
    options: ['Oui', 'Non', 'Uniquement pour les crimes'],
    answer: 'Oui',
    explanation:
        'La Cour de cassation admet qu’un sursis non révoqué peut constituer le premier terme.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pluralité d’infractions — Récidive (art. 132-9)',
    question:
        'Quand le second délit est puni de 10 ans d’emprisonnement, le délai de récidive est de :',
    options: ['3 ans', '5 ans', '10 ans'],
    answer: '10 ans',
    explanation:
        'Le cours indique : délai de 10 ans si le second délit est puni de 10 ans.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive (art. 132-8)',
    question:
        'Lorsque la seconde infraction est punissable de 20 ou 30 ans de réclusion criminelle, le maximum encouru devient :',
    options: ['30 ans', '40 ans', 'La réclusion criminelle à perpétuité'],
    answer: 'La réclusion criminelle à perpétuité',
    explanation:
        'L’article 132-8 prévoit la perpétuité lorsque la seconde infraction est punie de 20 ou 30 ans.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive (art. 132-8)',
    question:
        'Si la seconde infraction entraîne une peine de 15 ans de réclusion criminelle, le maximum devient :',
    options: ['20 ans', '30 ans', 'La perpétuité'],
    answer: '30 ans',
    explanation:
        'Le cours précise que le maximum est porté à 30 ans lorsque la seconde infraction est punie de 15 ans.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive personne morale (art. 132-13)',
    question:
        'Dans la récidive prévue à l’article 132-13, la peine d’amende encourue est :',
    options: ['Réduite de moitié', 'Doublée', 'Plafonnée à 100 000 €'],
    answer: 'Doublée',
    explanation: 'L’article 132-13 prévoit un doublement du taux de l’amende.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category:
        'Pluralité d’infractions — Récidive personne morale (art. 132-14)',
    question: 'En récidive art. 132-14, le taux maximum de l’amende est :',
    options: ['Identique', 'Double', 'Triple'],
    answer: 'Double',
    explanation: 'Le taux maximum de l’amende est porté au double.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive : cas pratique',
    question:
        'Un délit puni de 5 ans d’emprisonnement commis en récidive correctionnelle permet au juge de prononcer :',
    options: ['5 ans maximum', '7 ans maximum', '10 ans maximum'],
    answer: '10 ans maximum',
    explanation:
        'Le doublement de la peine maximale est autorisé en récidive correctionnelle.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pluralité d’infractions — Effets de la récidive : cas pratique',
    question:
        'Une contravention de 5e classe en récidive permet de porter l’amende maximale à :',
    options: ['1 500 €', '3 000 €', '6 000 €'],
    answer: '3 000 €',
    explanation: 'Le plafond légal est fixé à 3 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : cas pratiques',
    question:
        'En récidive correctionnelle, les deux infractions doivent être :',
    options: ['Quelconques', 'Identiques ou assimilées', 'Toujours des crimes'],
    answer: 'Identiques ou assimilées',
    explanation:
        'La récidive correctionnelle est spéciale : identité ou assimilation exigée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pluralité d’infractions — Récidive : cas pratiques',
    question:
        'Si la seconde infraction intervient avant que la première condamnation soit définitive, on est :',
    options: ['En récidive', 'En concours réel', 'En réitération'],
    answer: 'En concours réel',
    explanation:
        'La récidive nécessite une condamnation définitive antérieure à la seconde infraction.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category:
        'Pluralité d’infractions — Casier judiciaire : preuve de la récidive',
    question: 'Les mentions de quel bulletin font preuve de la récidive ?',
    options: ['Bulletin n°1', 'Bulletin n°2', 'Bulletin n°3'],
    answer: 'Bulletin n°1',
    explanation:
        'Le cours indique que les mentions du bulletin n°1 font preuve de la récidive.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pluralité d’infractions — Concours réel : art. 132-4',
    question:
        'Toujours selon l’art. 132-4 C.P., la confusion des peines de même nature peut être :',
    options: ['Totale ou partielle', 'Uniquement totale', 'Interdite'],
    answer: 'Totale ou partielle',
    explanation:
        'Le cours précise la possibilité de confusion totale ou partielle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pluralité d’infractions — Confusion des peines : effets',
    question:
        'La confusion enlève aux peines confondues leur existence propre :',
    options: ['Oui', 'Non', 'Uniquement pour les amendes'],
    answer: 'Non',
    explanation:
        'Le cours : les condamnations subsistent, la confusion n’efface pas l’existence propre des peines.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : pièges',
    question:
        'Un extrait délivré uniquement à la personne concernée correspond :',
    options: ['Au bulletin n°1', 'Au bulletin n°2', 'Au bulletin n°3'],
    answer: 'Au bulletin n°3',
    explanation:
        'Le B3 est délivré uniquement à l’intéressé (ou représentant légal dans certains cas).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : pièges',
    question:
        'Une condamnation effacée par amnistie peut-elle encore figurer au B1 ?',
    options: ['Oui, toujours', 'Non', 'Uniquement si l’amende n’est pas payée'],
    answer: 'Non',
    explanation:
        'Le cours : les condamnations effacées par l’amnistie ne peuvent figurer au B1.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : B2 destinataires',
    question:
        'Le bulletin n°2 peut être délivré aux autorités compétentes pour recevoir les déclarations de candidatures à une élection afin de vérifier certaines peines d’inéligibilité :',
    options: ['Oui', 'Non', 'Seulement pour le bulletin n°3'],
    answer: 'Oui',
    explanation:
        'Le cours cite ce cas : vérification des mentions liées à certaines peines (131-26 et suivants).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : comparatif',
    question: 'Quel bulletin est un relevé intégral ?',
    options: ['B1', 'B2', 'B3'],
    answer: 'B1',
    explanation: 'Le B1 est le relevé intégral des fiches.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire : comparatif',
    question: 'Quel bulletin est un relevé avec exclusions ?',
    options: ['B1', 'B2', 'B3'],
    answer: 'B2',
    explanation: 'Le B2 exclut certaines condamnations.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pluralité d’infractions — Casier judiciaire & récidive',
    question:
        'Une condamnation effacée par amnistie peut servir de premier terme de récidive :',
    options: ['Oui', 'Non', 'Uniquement si la peine a été exécutée'],
    answer: 'Non',
    explanation:
        'Le cours : si la condamnation a été effacée (amnistie), elle ne peut plus servir de premier terme.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
class QuizSanctionPluralite extends StatefulWidget {
  static const String routeName =
      '/gpx/sanction/quiz/sanction_pluralite_infractions';
  final String uid;
  final String email;

  const QuizSanctionPluralite({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizSanctionPluralite> createState() => _QuizSanctionPluraliteState();
}

class _QuizSanctionPluraliteState extends State<QuizSanctionPluralite>
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
            'module_name': 'Sanction',
            'quiz_name': 'Pluralité',
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

      final int percent = ((_score / totalForScore) * 100).round();

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
      await _sb.from('quiz_sanction_pluralite').insert({
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
      debugPrint('❌ quiz_sanction_pluralite insert failed: $e');
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
