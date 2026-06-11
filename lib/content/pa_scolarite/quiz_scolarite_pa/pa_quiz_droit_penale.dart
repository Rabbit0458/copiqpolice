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
final List<QuizQuestion> questionsGPXSchoolDroitPenalGeneral = [
  /////////////////////////////////////////////////////////////////////////////
  ///                GÉNÉRALITÉS — LÉGISLATION PÉNALE                        ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Selon la définition de Merle et Vitu, le droit pénal est :',
    options: [
      'L’ensemble des règles qui organisent uniquement la réparation civile',
      'L’ensemble des règles juridiques qui organisent la réaction de l’État face aux infractions et aux délinquants',
      'L’ensemble des règles qui organisent exclusivement l’exécution des peines',
    ],
    answer:
        'L’ensemble des règles juridiques qui organisent la réaction de l’État face aux infractions et aux délinquants',
    explanation:
        'Merle et Vitu définissent le droit pénal comme l’ensemble des règles organisant la réaction de l’État vis-à-vis des infractions et des délinquants.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le droit pénal a notamment pour but :',
    options: [
      'D’assurer et d’organiser la prévention et la répression des actes portant atteinte à la société',
      'De supprimer toute sanction pénale au profit de sanctions civiles',
      'De remplacer les juridictions par des médiations obligatoires',
    ],
    answer:
        'D’assurer et d’organiser la prévention et la répression des actes portant atteinte à la société',
    explanation:
        'Le cours insiste sur la prévention et la répression des actes portant atteinte à la société.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Parmi les branches du droit pénal, on retrouve :',
    options: [
      'Le droit pénal général, le droit pénal spécial, la procédure pénale',
      'Uniquement la procédure civile et le droit du travail',
      'Uniquement le droit administratif et le droit constitutionnel',
    ],
    answer:
        'Le droit pénal général, le droit pénal spécial, la procédure pénale',
    explanation:
        'Le cours distingue droit pénal général, droit pénal spécial et procédure pénale.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le droit pénal général :',
    options: [
      'Étudie uniquement les infractions de circulation',
      'Définit les principes généraux applicables à toutes les infractions',
      'Ne concerne que les contraventions',
    ],
    answer:
        'Définit les principes généraux applicables à toutes les infractions',
    explanation:
        'Le droit pénal général pose les principes généraux communs à toutes les infractions.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le droit pénal spécial :',
    options: [
      'Porte étude des différentes infractions',
      'Organise uniquement l’exécution des peines',
      'Traite exclusivement des voies de recours',
    ],
    answer: 'Porte étude des différentes infractions',
    explanation: 'Le droit pénal spécial étudie les infractions particulières.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'La procédure pénale comporte l’étude :',
    options: [
      'Du déroulement du procès pénal de la commission de l’infraction jusqu’au prononcé de la sanction',
      'Uniquement des contrats et obligations',
      'Uniquement des règles de preuve en matière civile',
    ],
    answer:
        'Du déroulement du procès pénal de la commission de l’infraction jusqu’au prononcé de la sanction',
    explanation:
        'Le cours décrit la procédure pénale comme l’étude du procès pénal dans son déroulement complet.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'La source principale du droit pénal est :',
    options: ['Le Code pénal', 'Le Code civil', 'Le Code du commerce'],
    answer: 'Le Code pénal',
    explanation:
        'Le cours indique que la source principale du droit pénal est le Code pénal (1810, remanié en 1992).',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le Code de procédure pénale traite notamment :',
    options: [
      'De l’action publique, de l’instruction, des juridictions de jugement et de l’enquête policière',
      'Uniquement des peines criminelles',
      'Uniquement des infractions militaires',
    ],
    answer:
        'De l’action publique, de l’instruction, des juridictions de jugement et de l’enquête policière',
    explanation:
        'Le texte indique ces axes principaux du Code de procédure pénale.',
    difficulty: 'Moyenne',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                INFRACTION — DÉFINITION / NOTIONS VOISINES             ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Infraction',
    question: 'Une infraction peut être définie comme :',
    options: [
      'Toute action ou omission contraire à l’ordre social, prévue et réprimée par la loi, exposant son auteur à une peine ou une mesure de sûreté',
      'Tout fait qui choque l’opinion publique, même sans texte',
      'Toute faute morale sans conséquence sociale',
    ],
    answer:
        'Toute action ou omission contraire à l’ordre social, prévue et réprimée par la loi, exposant son auteur à une peine ou une mesure de sûreté',
    explanation:
        'Le cours propose cette définition construite à partir de la lecture des textes.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Infraction',
    question:
        'Le délit civil, au sens du Code civil, est défini à l’article 1240 comme :',
    options: [
      'Un fait quelconque de l’homme qui cause un dommage à autrui et oblige à le réparer',
      'Une infraction punie d’emprisonnement',
      'Une contravention routière',
    ],
    answer:
        'Un fait quelconque de l’homme qui cause un dommage à autrui et oblige à le réparer',
    explanation:
        'Le délit civil vise la responsabilité civile et la réparation (dommages et intérêts).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Infraction',
    question: 'Le délit disciplinaire correspond :',
    options: [
      'À la violation de règles propres à un groupement professionnel ou à un corps légalement constitué',
      'À une infraction de terrorisme',
      'À une infraction forcément criminelle',
    ],
    answer:
        'À la violation de règles propres à un groupement professionnel ou à un corps légalement constitué',
    explanation:
        'Le cours oppose l’infraction pénale à des notions voisines, dont le délit disciplinaire.',
    difficulty: 'Facile',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///         CLASSIFICATION — TRIPARTITE + CONSÉQUENCES                    ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question:
        'Selon l’article 111-1 du Code pénal, les infractions pénales sont classées :',
    options: [
      'Selon leur intention en infractions intentionnelles et non intentionnelles',
      'Selon leur gravité en crimes, délits et contraventions',
      'Selon le lieu en France ou à l’étranger',
    ],
    answer: 'Selon leur gravité en crimes, délits et contraventions',
    explanation:
        'Le texte de l’article 111-1 du Code pénal fonde la classification tripartite sur la gravité.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question:
        'La nomenclature des peines applicables selon la classification tripartite est fixée par :',
    options: [
      'Les articles 131-1 à 131-18 du Code pénal',
      'Les articles 1 à 5 du Code civil',
      'Les articles 66 à 68 de la Constitution',
    ],
    answer: 'Les articles 131-1 à 131-18 du Code pénal',
    explanation:
        'Le cours renvoie à la nomenclature des peines aux articles 131-1 à 131-18 du Code pénal.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'La tentative est :',
    options: [
      'Toujours punissable pour les crimes',
      'Jamais punissable pour les crimes',
      'Toujours punissable pour les contraventions',
    ],
    answer: 'Toujours punissable pour les crimes',
    explanation:
        'Le cours indique que la tentative est toujours punissable en matière de crime.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'En matière de délits, la tentative est punissable :',
    options: [
      'Uniquement lorsque le texte le prévoit',
      'Toujours, sans exception',
      'Jamais',
    ],
    answer: 'Uniquement lorsque le texte le prévoit',
    explanation:
        'La tentative est punissable pour les délits lorsque le texte d’incrimination le prévoit.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'La tentative de contravention est :',
    options: [
      'Toujours punissable',
      'Punissable uniquement si un texte le prévoit',
      'Jamais punissable',
    ],
    answer: 'Jamais punissable',
    explanation:
        'Le cours précise que la tentative n’est jamais punissable pour les contraventions.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'La complicité est :',
    options: [
      'Toujours prévue pour les crimes et délits',
      'Jamais prévue pour les crimes',
      'Toujours prévue pour les contraventions',
    ],
    answer: 'Toujours prévue pour les crimes et délits',
    explanation:
        'Le cours indique que la complicité est toujours prévue en matière de crime et de délit.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'Pour les contraventions, la complicité est punissable :',
    options: [
      'Toujours',
      'Uniquement lorsque des dispositions réglementaires le prévoient expressément',
      'Jamais, dans tous les cas',
    ],
    answer:
        'Uniquement lorsque des dispositions réglementaires le prévoient expressément',
    explanation:
        'Le cours précise que, pour les contraventions, la complicité n’existe que si un texte l’a expressément prévu.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'La prescription de l’action publique est, en principe :',
    options: [
      '20 ans pour les crimes, 6 ans pour les délits, 1 an pour les contraventions',
      '30 ans pour les crimes, 10 ans pour les délits, 5 ans pour les contraventions',
      '10 ans pour les crimes, 6 ans pour les délits, 3 ans pour les contraventions',
    ],
    answer:
        '20 ans pour les crimes, 6 ans pour les délits, 1 an pour les contraventions',
    explanation:
        'Le cours indique ces délais de principe en renvoyant aux articles 7, 8 et 9 du Code de procédure pénale.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'La prescription de la peine est, en principe :',
    options: [
      '20 ans pour les crimes, 6 ans pour les délits, 3 ans pour les contraventions',
      '20 ans pour les crimes, 10 ans pour les délits, 1 an pour les contraventions',
      '10 ans pour les crimes, 6 ans pour les délits, 3 ans pour les contraventions',
    ],
    answer:
        '20 ans pour les crimes, 6 ans pour les délits, 3 ans pour les contraventions',
    explanation:
        'Le cours renvoie aux articles 133-2 à 133-4 du Code pénal pour les délais de prescription de la peine.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'Les contraventions sont jugées par :',
    options: [
      'Le tribunal de police',
      'La cour d’assises',
      'La cour criminelle départementale',
    ],
    answer: 'Le tribunal de police',
    explanation:
        'Le cours rappelle la compétence du tribunal de police pour les contraventions.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'Les délits sont jugés par :',
    options: [
      'La cour d’assises',
      'Le tribunal correctionnel',
      'Le tribunal de police',
    ],
    answer: 'Le tribunal correctionnel',
    explanation:
        'Le cours indique que les délits relèvent du tribunal correctionnel.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'Les crimes sont jugés par :',
    options: [
      'Le tribunal de police',
      'Le tribunal correctionnel',
      'La cour d’assises ou la cour criminelle départementale',
    ],
    answer: 'La cour d’assises ou la cour criminelle départementale',
    explanation:
        'Le cours précise les juridictions compétentes en matière criminelle.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'En matière d’enquête, l’enquête de flagrance est :',
    options: [
      'Possible pour les crimes et délits',
      'Possible uniquement pour les contraventions',
      'Interdite pour tous les faits',
    ],
    answer: 'Possible pour les crimes et délits',
    explanation:
        'Le cours indique que l’enquête de flagrance peut être utilisée pour crimes et délits.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'Pour les contraventions, le cadre d’enquête mentionné est :',
    options: [
      'Uniquement l’enquête préliminaire',
      'Uniquement l’enquête de flagrance',
      'Obligatoirement l’information judiciaire',
    ],
    answer: 'Uniquement l’enquête préliminaire',
    explanation:
        'Le cours précise que pour les contraventions seule l’enquête préliminaire est possible.',
    difficulty: 'Moyenne',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///      CLASSIFICATION — NATURE : POLITIQUE / TERRORISME / MILITAIRE      ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Nature de l’infraction',
    question:
        'Le critère retenu par la jurisprudence pour l’infraction politique est principalement :',
    options: [
      'Le critère objectif (objet de l’infraction)',
      'Le critère subjectif (mobile personnel uniquement)',
      'Le critère économique (profit recherché)',
    ],
    answer: 'Le critère objectif (objet de l’infraction)',
    explanation:
        'Le cours indique que la jurisprudence retient le critère objectif : l’atteinte à l’organisation et au fonctionnement des pouvoirs publics, à l’intérêt de l’État ou à son existence.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Nature de l’infraction',
    question:
        'Selon le critère objectif, une infraction politique est celle qui porte atteinte :',
    options: [
      'À l’organisation et au fonctionnement des pouvoirs publics, à l’intérêt de l’État ou à son existence',
      'Uniquement aux biens privés',
      'Uniquement à la santé publique',
    ],
    answer:
        'À l’organisation et au fonctionnement des pouvoirs publics, à l’intérêt de l’État ou à son existence',
    explanation:
        'C’est la définition doctrinale reprise par la jurisprudence selon le cours.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Nature de l’infraction',
    question:
        'Si une infraction est commise pour des mobiles politiques, elle devient automatiquement une infraction politique :',
    options: ['Vrai', 'Faux', 'Vrai uniquement pour les contraventions'],
    answer: 'Faux',
    explanation:
        'Le cours précise que la jurisprudence retient l’objet de l’infraction, pas les mobiles : une infraction commise pour des mobiles politiques peut rester de droit commun.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Terrorisme',
    question:
        'Le Code pénal énonce une liste d’infractions qualifiées de terrorisme aux articles :',
    options: [
      '421-1 à 421-6 du Code pénal',
      '111-1 à 111-6 du Code pénal',
      '706-16 à 706-26 du Code pénal',
    ],
    answer: '421-1 à 421-6 du Code pénal',
    explanation:
        'Le cours indique que les infractions de terrorisme sont listées aux articles 421-1 à 421-6 du Code pénal.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Terrorisme',
    question:
        'L’article 706-17 du Code de procédure pénale prévoit notamment :',
    options: [
      'Une centralisation possible des procédures de terrorisme à Paris',
      'L’interdiction de poursuivre en matière terroriste',
      'La suppression de la garde à vue',
    ],
    answer: 'Une centralisation possible des procédures de terrorisme à Paris',
    explanation:
        'Le cours précise la possibilité de centralisation des procédures de terrorisme à Paris.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Terrorisme',
    question:
        'Pour le jugement des infractions terroristes, la cour d’assises est composée :',
    options: [
      'Uniquement de magistrats professionnels',
      'Uniquement de jurés populaires',
      'D’un jury mixte obligatoire dans tous les cas',
    ],
    answer: 'Uniquement de magistrats professionnels',
    explanation:
        'Le cours indique une composition uniquement de magistrats professionnels pour le jugement des infractions terroristes (référence aux articles 706-25 et 698-6 du Code de procédure pénale).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Militaire',
    question: 'Une infraction militaire correspond notamment à :',
    options: [
      'Un manquement à la discipline ou aux obligations militaires (rébellion, refus d’obéissance, désertion, insoumission)',
      'Une contravention routière commise par un civil',
      'Un délit de presse',
    ],
    answer:
        'Un manquement à la discipline ou aux obligations militaires (rébellion, refus d’obéissance, désertion, insoumission)',
    explanation:
        'Le cours définit l’infraction militaire par référence à la discipline et aux obligations militaires.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Militaire',
    question:
        'En temps de guerre, les juridictions compétentes pour les faits commis en France peuvent être :',
    options: [
      'Les tribunaux territoriaux des forces armées',
      'Uniquement le tribunal de police',
      'Uniquement le conseil de prud’hommes',
    ],
    answer: 'Les tribunaux territoriaux des forces armées',
    explanation:
        'Le cours indique qu’en temps de guerre, les tribunaux territoriaux des forces armées peuvent être compétents pour des faits commis en France.',
    difficulty: 'Difficile',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///       CLASSIFICATION — MODE DE RÉALISATION / TEMPS / HABITUDE          ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Mode de réalisation',
    question: 'Une infraction de commission consiste :',
    options: [
      'En la réalisation d’un acte prohibé par la loi',
      'Uniquement en une abstention',
      'Uniquement en une intention non matérialisée',
    ],
    answer: 'En la réalisation d’un acte prohibé par la loi',
    explanation:
        'Le cours définit l’infraction de commission comme la réalisation d’un acte interdit.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Mode de réalisation',
    question: 'Une infraction d’omission suppose :',
    options: [
      'Que l’omission soit réprimée en tant que telle',
      'Que le résultat soit toujours la mort',
      'Que l’auteur ait agi par manœuvres frauduleuses',
    ],
    answer: 'Que l’omission soit réprimée en tant que telle',
    explanation:
        'Le cours précise que l’infraction d’omission réprime l’abstention prévue par la loi.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Mode de réalisation',
    question: 'Parmi les exemples d’infractions d’omission cités, on trouve :',
    options: [
      'L’omission de porter secours à personne en péril',
      'Le vol simple',
      'La diffamation',
    ],
    answer: 'L’omission de porter secours à personne en péril',
    explanation:
        'Le cours cite l’omission de porter secours à personne en péril (article 223-6 alinéa 2 du Code pénal) comme exemple.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Mode de réalisation',
    question: 'La commission par omission correspond à une situation où :',
    options: [
      'L’auteur reste volontairement passif et il en résulte un dommage, et l’abstention est assimilée à l’action par la loi',
      'L’auteur agit uniquement par écrit',
      'L’auteur n’a aucune volonté',
    ],
    answer:
        'L’auteur reste volontairement passif et il en résulte un dommage, et l’abstention est assimilée à l’action par la loi',
    explanation:
        'Le cours explique que, exceptionnellement, le législateur assimile l’omission à la commission (exemples : homicide ou blessures par imprudence).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Temps de l’infraction',
    question: 'Une infraction instantanée est :',
    options: [
      'Constituée par un acte qui se réalise en un instant',
      'Toujours une infraction continue',
      'Une infraction dont l’exécution se prolonge dans le temps',
    ],
    answer: 'Constituée par un acte qui se réalise en un instant',
    explanation:
        'Le cours définit l’infraction instantanée comme réalisée en un instant, même si ses effets peuvent durer.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Temps de l’infraction',
    question: 'L’infraction continue est celle :',
    options: [
      'Dont l’exécution se prolonge dans le temps et suppose une réitération de la volonté coupable',
      'Réalisée une seule fois et définitivement terminée',
      'Qui ne peut jamais être poursuivie',
    ],
    answer:
        'Dont l’exécution se prolonge dans le temps et suppose une réitération de la volonté coupable',
    explanation:
        'Le cours souligne la prolongation dans le temps et la réitération de la volonté.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Temps de l’infraction',
    question:
        'En matière de prescription, pour un délit continu, le point de départ est :',
    options: [
      'Le jour où l’acte délictueux a pris fin',
      'Le jour du premier acte préparatoire',
      'Le jour où la victime découvre les faits, dans tous les cas',
    ],
    answer: 'Le jour où l’acte délictueux a pris fin',
    explanation:
        'Le cours précise que, pour l’infraction continue, la prescription court à partir de la fin de l’infraction.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Structure de l’infraction',
    question: 'Une infraction simple consiste :',
    options: [
      'En la réalisation d’un acte unique',
      'En plusieurs actes matériels de type différent',
      'En plusieurs actes semblables qui pris isolément ne sont pas des infractions',
    ],
    answer: 'En la réalisation d’un acte unique',
    explanation:
        'Le cours définit l’infraction simple par un acte unique (exemple : vol).',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Structure de l’infraction',
    question: 'Une infraction complexe suppose :',
    options: [
      'La réalisation de plusieurs actes matériels de type différent',
      'Un seul acte instantané',
      'Une abstention uniquement',
    ],
    answer: 'La réalisation de plusieurs actes matériels de type différent',
    explanation:
        'Le cours cite l’escroquerie comme exemple : manœuvres frauduleuses + remise.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Structure de l’infraction',
    question:
        'Pour le délit d’habitude, la prescription de l’action publique commence :',
    options: [
      'Le jour où a été accompli le dernier acte constitutif de l’habitude',
      'Le jour du premier acte',
      'Le jour de la plainte, uniquement',
    ],
    answer:
        'Le jour où a été accompli le dernier acte constitutif de l’habitude',
    explanation:
        'Le cours précise que le point de départ est le dernier acte constitutif.',
    difficulty: 'Difficile',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                 ÉLÉMENTS CONSTITUTIFS — LES 3 ÉLÉMENTS                ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Éléments constitutifs',
    question: 'Les éléments constitutifs généraux d’une infraction sont :',
    options: [
      'Un élément légal, un élément matériel, un élément moral',
      'Une victime, un mobile, une preuve',
      'Une intention, une peine, une juridiction',
    ],
    answer: 'Un élément légal, un élément matériel, un élément moral',
    explanation:
        'Le cours indique que toutes les infractions reposent sur ces trois éléments.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément légal',
    question: 'Le principe « Sans texte, pas d’infraction » signifie :',
    options: [
      'Un acte peut être puni même sans texte s’il choque la morale',
      'Sans texte légal, il n’y a pas d’infraction, même si l’acte trouble l’ordre public',
      'La coutume suffit toujours à créer une incrimination',
    ],
    answer:
        'Sans texte légal, il n’y a pas d’infraction, même si l’acte trouble l’ordre public',
    explanation:
        'Le cours rappelle le rôle indispensable du texte légal pour caractériser une infraction.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément légal',
    question: 'L’article 111-3 du Code pénal pose le principe :',
    options: [
      'De légalité des délits et des peines',
      'De territorialité uniquement',
      'De rétroactivité de la loi plus sévère',
    ],
    answer: 'De légalité des délits et des peines',
    explanation:
        'Le texte de l’article 111-3 du Code pénal fonde le principe de légalité en matière pénale.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément légal',
    question:
        'Selon l’article 111-3 du Code pénal, les contraventions ont leurs éléments définis par :',
    options: ['La loi', 'Le règlement', 'La jurisprudence uniquement'],
    answer: 'Le règlement',
    explanation:
        'L’article 111-3 du Code pénal distingue : crimes et délits (loi), contraventions (règlement).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources',
    question: 'La norme suprême en droit interne (dans le cours) est :',
    options: ['La Constitution de 1958', 'Le Code pénal', 'Le Code civil'],
    answer: 'La Constitution de 1958',
    explanation:
        'Le cours précise que la norme suprême est la Constitution de 1958.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources',
    question: 'Selon l’article 111-2 du Code pénal, la loi :',
    options: [
      'Détermine les crimes et délits et fixe les peines applicables à leurs auteurs',
      'Détermine uniquement les contraventions',
      'Ne fixe jamais les peines',
    ],
    answer:
        'Détermine les crimes et délits et fixe les peines applicables à leurs auteurs',
    explanation:
        'Le cours cite l’article 111-2 du Code pénal sur le rôle de la loi.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources',
    question:
        'Parmi les actes ayant valeur de loi (selon le cours), on retrouve :',
    options: [
      'Des décisions présidentielles prises en vertu de l’article 16 de la Constitution',
      'Les commentaires de doctrine',
      'Les décisions de simple police municipale',
    ],
    answer:
        'Des décisions présidentielles prises en vertu de l’article 16 de la Constitution',
    explanation:
        'Le cours liste les décisions présidentielles (article 16), ordonnances ratifiées (article 38), et décrets-lois (républiques antérieures).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources',
    question:
        'Selon la Constitution (article 55), les conventions internationales ratifiées et publiées :',
    options: [
      'Ont une valeur supérieure à la loi interne',
      'Ont une valeur inférieure à la loi interne',
      'N’ont aucune valeur en droit français',
    ],
    answer: 'Ont une valeur supérieure à la loi interne',
    explanation:
        'Le cours rappelle la supériorité des conventions internationales sur la loi interne (article 55 de la Constitution).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément matériel',
    question: 'L’élément matériel correspond :',
    options: [
      'À la pensée criminelle non matérialisée',
      'À l’attitude positive ou négative réprimée par la loi, manifestation concrète de la volonté délictueuse',
      'À la seule intention de nuire',
    ],
    answer:
        'À l’attitude positive ou négative réprimée par la loi, manifestation concrète de la volonté délictueuse',
    explanation:
        'Le cours définit l’élément matériel comme la manifestation concrète de la volonté délictueuse.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément matériel',
    question: 'La seule pensée criminelle (sans matérialisation) est :',
    options: [
      'Toujours punissable',
      'Non répréhensible',
      'Punissable seulement si la victime porte plainte',
    ],
    answer: 'Non répréhensible',
    explanation:
        'Le cours explique que la pensée criminelle n’est pas répréhensible sans manifestation extérieure.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question:
        'La tentative (article 121-5 du Code pénal) est constituée lorsque :',
    options: [
      'Il existe un commencement d’exécution et l’échec provient de circonstances indépendantes de la volonté de l’auteur',
      'Il existe une simple idée ou intention',
      'L’auteur commet uniquement des actes préparatoires',
    ],
    answer:
        'Il existe un commencement d’exécution et l’échec provient de circonstances indépendantes de la volonté de l’auteur',
    explanation:
        'Le cours reprend les conditions de l’article 121-5 du Code pénal.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'Pour qu’il y ait tentative, il faut notamment :',
    options: [
      'Un commencement d’exécution et une absence de désistement volontaire',
      'Un mobile politique et un résultat',
      'Une plainte et un aveu',
    ],
    answer:
        'Un commencement d’exécution et une absence de désistement volontaire',
    explanation:
        'Le cours détaille ces deux éléments constitutifs de la tentative.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'Les actes préparatoires sont en principe :',
    options: [
      'Toujours punissables',
      'En principe non punissables',
      'Toujours punissables pour les contraventions',
    ],
    answer: 'En principe non punissables',
    explanation:
        'Le cours rappelle que les actes préparatoires échappent en principe à la répression car ils peuvent être équivoques et l’auteur peut encore se désister.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question:
        'La Cour de cassation exige, pour retenir un commencement d’exécution, notamment :',
    options: [
      'Un acte univoque et une intention irrévocable de réaliser une infraction précise',
      'Une confession filmée',
      'Un dommage obligatoirement grave',
    ],
    answer:
        'Un acte univoque et une intention irrévocable de réaliser une infraction précise',
    explanation:
        'Le cours indique ce double critère jurisprudentiel (acte univoque + intention irrévocable).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question:
        'Dans l’affaire Lacour (chambre criminelle, 5 octobre 1962), a été jugé que :',
    options: [
      'Payer un homme de main et fournir des renseignements dans ce but ne constitue pas un commencement d’exécution',
      'Toute préparation est une tentative',
      'Toute intention exprimée oralement est punissable',
    ],
    answer:
        'Payer un homme de main et fournir des renseignements dans ce but ne constitue pas un commencement d’exécution',
    explanation:
        'Le cours cite cette décision pour distinguer acte préparatoire et commencement d’exécution.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'Le désistement volontaire entraîne en principe :',
    options: [
      'L’impunité de la tentative (pas de tentative punissable)',
      'Une aggravation automatique de la peine',
      'La requalification en crime',
    ],
    answer: 'L’impunité de la tentative (pas de tentative punissable)',
    explanation:
        'Le cours explique que celui qui renonce de lui-même, sans cause extérieure, n’est pas punissable au titre de la tentative.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'Le repentir actif (après consommation) :',
    options: [
      'Supprime la responsabilité pénale',
      'Est sans influence sur la responsabilité pénale une fois l’infraction consommée',
      'Transforme l’infraction en contravention',
    ],
    answer:
        'Est sans influence sur la responsabilité pénale une fois l’infraction consommée',
    explanation:
        'Le cours précise que l’attitude postérieure n’efface pas la responsabilité pénale après consommation.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'L’infraction manquée correspond à :',
    options: [
      'Une exécution complète des éléments qui échoue en raison de circonstances indépendantes de la volonté de l’auteur',
      'Une infraction impossible sans aucun acte',
      'Une simple intention',
    ],
    answer:
        'Une exécution complète des éléments qui échoue en raison de circonstances indépendantes de la volonté de l’auteur',
    explanation:
        'Le cours donne l’exemple du tir manqué : exécution complète, échec indépendant.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'L’infraction impossible est, selon le cours :',
    options: [
      'Toujours punissable même sans texte',
      'Punissable uniquement dans le cadre de la tentative, lorsque la tentative est incriminée',
      'Jamais punissable en matière criminelle',
    ],
    answer:
        'Punissable uniquement dans le cadre de la tentative, lorsque la tentative est incriminée',
    explanation:
        'Le cours précise que l’infraction impossible n’est pas prévue en tant que telle : elle n’est punissable que si la tentative l’est.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Il n’y a pas d’infraction sans élément moral signifie :',
    options: [
      'La responsabilité est automatique',
      'L’acte doit être issu de la volonté de son auteur',
      'Seul le résultat compte',
    ],
    answer: 'L’acte doit être issu de la volonté de son auteur',
    explanation:
        'Le cours rappelle que l’élément moral est indispensable à la constitution de l’infraction.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Le dol général correspond à :',
    options: [
      'La conscience ou la volonté d’accomplir un acte illicite',
      'La faute de négligence uniquement',
      'Le mobile politique',
    ],
    answer: 'La conscience ou la volonté d’accomplir un acte illicite',
    explanation:
        'Le cours définit le dol général comme la conscience ou la volonté d’accomplir un acte illicite.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Le mobile est, en principe, au regard du droit pénal :',
    options: [
      'Indifférent à la qualification, même si le juge peut en tenir compte pour la peine',
      'Toujours un élément constitutif légal',
      'Toujours une circonstance aggravante',
    ],
    answer:
        'Indifférent à la qualification, même si le juge peut en tenir compte pour la peine',
    explanation:
        'Le cours indique que le mobile est indifférent en droit, mais peut influencer la peine en pratique.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'L’article 121-3 du Code pénal énonce que :',
    options: [
      'Il n’y a point de crime ou délit sans intention de le commettre',
      'Toute contravention exige un dol spécial',
      'La loi pénale plus sévère rétroagit',
    ],
    answer: 'Il n’y a point de crime ou délit sans intention de le commettre',
    explanation:
        'Le cours cite l’article 121-3 du Code pénal sur la nécessité d’intention pour crimes et délits (principe).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Le dol spécial correspond à :',
    options: [
      'Une intention particulière d’atteindre un résultat précis exigée par la loi',
      'Une faute contraventionnelle présumée',
      'Une simple imprudence',
    ],
    answer:
        'Une intention particulière d’atteindre un résultat précis exigée par la loi',
    explanation:
        'Le cours explique que certaines infractions exigent une intention spécifique (exemple : intention de tuer pour le meurtre).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'La préméditation est :',
    options: [
      'Une forme aggravée d’intention criminelle',
      'Une faute non intentionnelle',
      'Une cause d’irresponsabilité automatique',
    ],
    answer: 'Une forme aggravée d’intention criminelle',
    explanation:
        'Le cours indique que le dol peut être aggravé, notamment par la préméditation.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Le dol praeter intentionnel correspond à :',
    options: [
      'Un résultat qui dépasse l’intention initiale de l’auteur',
      'L’absence totale d’intention et l’absence de faute',
      'Une simple contravention',
    ],
    answer: 'Un résultat qui dépasse l’intention initiale de l’auteur',
    explanation:
        'Le cours donne l’exemple : frapper pour blesser mais causer la mort (article 222-7 du Code pénal).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Fautes non intentionnelles',
    question:
        'La faute d’imprudence ou de négligence (article 121-3 alinéa 3 du Code pénal) consiste en :',
    options: [
      'Une imprudence, négligence ou manquement à une obligation de prudence ou de sécurité prévue par la loi ou le règlement',
      'Une intention de nuire',
      'Une préméditation',
    ],
    answer:
        'Une imprudence, négligence ou manquement à une obligation de prudence ou de sécurité prévue par la loi ou le règlement',
    explanation:
        'Le cours reprend la définition de l’article 121-3 alinéa 3 du Code pénal.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Fautes non intentionnelles',
    question:
        'Si le lien de causalité est direct, il suffit pour établir la faute :',
    options: [
      'D’une imprudence, négligence ou manquement à une obligation de prudence ou de sécurité',
      'D’une faute caractérisée dans tous les cas',
      'D’un dol spécial',
    ],
    answer:
        'D’une imprudence, négligence ou manquement à une obligation de prudence ou de sécurité',
    explanation:
        'Le cours distingue causalité directe (faute simple suffit) et causalité indirecte (faute caractérisée).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Fautes non intentionnelles',
    question: 'La faute de mise en danger délibérée suppose notamment :',
    options: [
      'Une violation manifestement délibérée d’une législation ou réglementation de sécurité ou de prudence, ou une faute caractérisée exposant autrui à un risque particulièrement grave',
      'Un dol spécial obligatoire',
      'Une plainte préalable obligatoire',
    ],
    answer:
        'Une violation manifestement délibérée d’une législation ou réglementation de sécurité ou de prudence, ou une faute caractérisée exposant autrui à un risque particulièrement grave',
    explanation:
        'Le cours détaille les deux formes : violation manifestement délibérée ou faute caractérisée.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Fautes non intentionnelles',
    question: 'La faute contraventionnelle consiste :',
    options: [
      'En la simple violation d’une prescription légale ou réglementaire, indépendamment de tout dommage',
      'Toujours en une intention de tuer',
      'Uniquement en une escroquerie',
    ],
    answer:
        'En la simple violation d’une prescription légale ou réglementaire, indépendamment de tout dommage',
    explanation:
        'Le cours indique qu’elle est indépendante de la survenance d’un dommage : l’acte interdit suffit.',
    difficulty: 'Moyenne',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                 ÉTENDUE — APPLICATION DANS LE TEMPS                   ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question:
        'Le principe général posé par l’article 112-1 du Code pénal est :',
    options: [
      'La non-rétroactivité de la loi pénale nouvelle',
      'La rétroactivité systématique',
      'L’application uniquement aux étrangers',
    ],
    answer: 'La non-rétroactivité de la loi pénale nouvelle',
    explanation:
        'Le cours rappelle que les faits sont punissables seulement s’ils constituaient une infraction au moment où ils ont été commis.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question:
        'Les lois pénales de fond (infractions et conditions de sanction) :',
    options: [
      'Sont en principe non rétroactives si elles sont plus sévères',
      'Rétroagissent toujours',
      'Ne s’appliquent jamais',
    ],
    answer: 'Sont en principe non rétroactives si elles sont plus sévères',
    explanation:
        'Le cours explique que les lois nouvelles plus sévères ne rétroagissent pas.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question: 'La rétroactivité in mitius signifie :',
    options: [
      'La loi plus douce s’applique aux faits commis avant son entrée en vigueur et non jugés définitivement',
      'La loi plus sévère s’applique toujours',
      'La loi ne s’applique jamais aux faits antérieurs',
    ],
    answer:
        'La loi plus douce s’applique aux faits commis avant son entrée en vigueur et non jugés définitivement',
    explanation:
        'Le cours renvoie à l’article 112-1 alinéa 3 du Code pénal : rétroactivité des lois plus douces.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question: 'Une infraction est jugée définitivement lorsque :',
    options: [
      'Toutes les voies de recours sont épuisées',
      'La garde à vue est terminée',
      'La plainte est déposée',
    ],
    answer: 'Toutes les voies de recours sont épuisées',
    explanation:
        'Le cours donne ce critère pour apprécier la rétroactivité de la loi plus douce.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question: 'Les lois interprétatives :',
    options: [
      'Rétroagissent car elles font corps avec la loi interprétée',
      'Ne rétroagissent jamais',
      'S’appliquent seulement aux contraventions',
    ],
    answer: 'Rétroagissent car elles font corps avec la loi interprétée',
    explanation:
        'Le cours précise que les lois interprétatives précisent le sens d’une loi antérieure et s’appliquent à des faits antérieurs.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question:
        'Les lois pénales de forme, selon l’article 112-2 du Code pénal :',
    options: [
      'S’appliquent immédiatement, même aux faits commis avant leur entrée en vigueur',
      'Ne s’appliquent qu’aux faits futurs',
      'Sont toujours rétroactives sans limite',
    ],
    answer:
        'S’appliquent immédiatement, même aux faits commis avant leur entrée en vigueur',
    explanation:
        'Le cours expose le principe d’application immédiate des lois de forme.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question:
        'Une exception à l’application immédiate d’une loi de forme existe notamment :',
    options: [
      'S’il existe un droit acquis au profit du délinquant',
      'Toujours, sans condition',
      'Uniquement en matière contraventionnelle',
    ],
    answer: 'S’il existe un droit acquis au profit du délinquant',
    explanation: 'Le cours prévoit l’exception des droits acquis.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question:
        'Une loi nouvelle ne peut entraîner la nullité d’actes régulièrement accomplis sous une loi antérieure (selon le cours) :',
    options: ['Vrai', 'Faux', 'Vrai uniquement pour les crimes'],
    answer: 'Vrai',
    explanation:
        'Le cours renvoie à l’article 112-4 du Code pénal : pas de nullité d’actes régulièrement accomplis.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Prescription',
    question:
        'Une loi nouvelle relative à la prescription s’applique immédiatement si :',
    options: [
      'La prescription n’est pas encore acquise',
      'La prescription est déjà acquise',
      'Il s’agit d’une contravention uniquement',
    ],
    answer: 'La prescription n’est pas encore acquise',
    explanation:
        'Le cours précise que l’application immédiate suppose que la prescription ne soit pas acquise.',
    difficulty: 'Difficile',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                 ÉTENDUE — APPLICATION DANS L’ESPACE                   ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question:
        'Le principe de territorialité (article 113-2 du Code pénal) signifie :',
    options: [
      'La loi pénale française est applicable aux infractions commises sur le territoire de la République',
      'La loi pénale française s’applique uniquement aux étrangers',
      'La loi pénale française ne s’applique jamais en France',
    ],
    answer:
        'La loi pénale française est applicable aux infractions commises sur le territoire de la République',
    explanation:
        'Le cours cite l’article 113-2 du Code pénal : application au territoire de la République.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question: 'La notion de territoire inclut notamment :',
    options: [
      'L’espace terrestre (métropole, départements et régions d’outre-mer, collectivités d’outre-mer), l’espace aérien, l’espace maritime',
      'Uniquement la métropole',
      'Uniquement les ambassades françaises à l’étranger',
    ],
    answer:
        'L’espace terrestre (métropole, départements et régions d’outre-mer, collectivités d’outre-mer), l’espace aérien, l’espace maritime',
    explanation: 'Le cours liste ces composantes du territoire au sens pénal.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question:
        'La loi pénale française peut s’appliquer si un des faits constitutifs de l’infraction est commis en France :',
    options: ['Vrai', 'Faux', 'Vrai uniquement si l’auteur est français'],
    answer: 'Vrai',
    explanation:
        'Le cours précise que la loi française s’applique dès lors qu’un des faits constitutifs est commis en France.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Éléments constitutifs',
    question:
        'Pour qu’une infraction pénale soit constituée, les éléments constitutifs doivent être :',
    options: [
      'Réunis cumulativement',
      'Réunis alternativement',
      'Présumés automatiquement',
    ],
    answer: 'Réunis cumulativement',
    explanation:
        'Le cours précise que l’élément légal, matériel et moral doivent être tous réunis pour que l’infraction existe.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément légal',
    question: 'L’absence de texte pénal a pour conséquence :',
    options: [
      'L’absence d’infraction pénale',
      'Une qualification automatique en contravention',
      'Une qualification civile obligatoire',
    ],
    answer: 'L’absence d’infraction pénale',
    explanation:
        'Le principe de légalité impose l’existence d’un texte pour qu’une infraction pénale soit caractérisée.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément légal',
    question: 'Le principe de légalité constitue avant tout :',
    options: [
      'Une garantie des libertés individuelles',
      'Une facilité pour la répression',
      'Une simple règle administrative',
    ],
    answer: 'Une garantie des libertés individuelles',
    explanation:
        'Le principe « la loi doit avertir avant de frapper » protège les citoyens contre l’arbitraire.',
    difficulty: 'Moyenne',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                    SOURCES DU DROIT PÉNAL                             ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Sources',
    question:
        'Les ordonnances prises en application de l’article 38 de la Constitution ont valeur de loi :',
    options: [
      'Uniquement si elles sont ratifiées par le Parlement',
      'Dès leur signature',
      'Jamais',
    ],
    answer: 'Uniquement si elles sont ratifiées par le Parlement',
    explanation:
        'Le cours précise que seules les ordonnances ratifiées ont valeur législative.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources',
    question:
        'Les décrets-lois évoqués dans le cours proviennent principalement :',
    options: [
      'Des IIIᵉ et IVᵉ Républiques',
      'De la Ve République uniquement',
      'De l’Union européenne',
    ],
    answer: 'Des IIIᵉ et IVᵉ Républiques',
    explanation:
        'Les décrets-lois sont cités comme actes assimilés à la loi sous les IIIᵉ et IVᵉ Républiques.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources',
    question: 'Les circulaires administratives sont :',
    options: [
      'Des instructions internes dépourvues de valeur normative pénale',
      'Des sources directes du droit pénal',
      'Toujours opposables aux administrés',
    ],
    answer: 'Des instructions internes dépourvues de valeur normative pénale',
    explanation:
        'Le cours indique que les circulaires ne sont pas une source du droit pénal.',
    difficulty: 'Moyenne',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                        JURISPRUDENCE & DOCTRINE                        ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Jurisprudence',
    question:
        'Le principe d’interprétation restrictive de la loi pénale vise à :',
    options: [
      'Empêcher la jurisprudence de devenir une source de droit pénal',
      'Favoriser la création de nouvelles infractions',
      'Permettre l’analogie en matière pénale',
    ],
    answer: 'Empêcher la jurisprudence de devenir une source de droit pénal',
    explanation:
        'La jurisprudence interprète la loi mais ne doit pas créer d’incriminations nouvelles.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Doctrine',
    question: 'La doctrine pénale :',
    options: [
      'N’a aucune valeur normative',
      'A la même valeur que la loi',
      'Prime sur la jurisprudence',
    ],
    answer: 'N’a aucune valeur normative',
    explanation:
        'La doctrine constitue une source d’inspiration mais n’a pas de force obligatoire.',
    difficulty: 'Facile',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                      ÉLÉMENT MATÉRIEL — DÉTAILS                        ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Élément matériel',
    question: 'L’élément matériel peut consister en :',
    options: [
      'Un acte positif ou une abstention',
      'Une simple intention',
      'Un mobile personnel',
    ],
    answer: 'Un acte positif ou une abstention',
    explanation:
        'Le cours précise que l’élément matériel peut être une action ou une omission.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément matériel',
    question: 'La résolution criminelle correspond :',
    options: [
      'À la décision de commettre une infraction sans passage à l’acte',
      'À une tentative punissable',
      'À une infraction consommée',
    ],
    answer: 'À la décision de commettre une infraction sans passage à l’acte',
    explanation:
        'La résolution criminelle reste au stade de la pure intention et n’est pas punissable.',
    difficulty: 'Moyenne',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                           TENTATIVE — NUANCES                          ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question:
        'Le commencement d’exécution se distingue des actes préparatoires car il :',
    options: [
      'Traduit sans ambiguïté la volonté de commettre l’infraction',
      'Peut encore être équivoque',
      'Ne nécessite aucune intention',
    ],
    answer: 'Traduit sans ambiguïté la volonté de commettre l’infraction',
    explanation:
        'La jurisprudence exige un acte univoque traduisant une volonté criminelle irrévocable.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'Une tentative suspendue par l’intervention de la police est :',
    options: ['Punissable', 'Impunie', 'Assimilée à un désistement volontaire'],
    answer: 'Punissable',
    explanation:
        'L’intervention extérieure rend le désistement involontaire, ce qui rend la tentative punissable.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'La tentative infructueuse suppose que :',
    options: [
      'L’auteur ait tout mis en œuvre sans parvenir au résultat',
      'Aucun acte n’ait été accompli',
      'L’auteur se soit désisté volontairement',
    ],
    answer: 'L’auteur ait tout mis en œuvre sans parvenir au résultat',
    explanation:
        'La tentative infructueuse est caractérisée par un échec indépendant de la volonté de l’auteur.',
    difficulty: 'Moyenne',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                         ÉLÉMENT MORAL — ANALYSE                        ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Une infraction non intentionnelle suppose néanmoins :',
    options: [
      'Une intelligence et une volonté',
      'Une préméditation',
      'Un dol spécial',
    ],
    answer: 'Une intelligence et une volonté',
    explanation:
        'La Cour de cassation rappelle que même les infractions non intentionnelles supposent une volonté consciente.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Le dol déterminé se caractérise par :',
    options: [
      'Un résultat exactement conforme à celui recherché par l’auteur',
      'Un résultat imprévisible',
      'Une absence totale d’intention',
    ],
    answer: 'Un résultat exactement conforme à celui recherché par l’auteur',
    explanation:
        'Le dol déterminé correspond à l’adéquation parfaite entre l’intention et le résultat.',
    difficulty: 'Moyenne',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                   FAUTES NON INTENTIONNELLES                          ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Fautes',
    question: 'La faute d’imprudence se caractérise principalement par :',
    options: [
      'Une absence de prévision du dommage',
      'Une volonté de nuire',
      'Une préméditation',
    ],
    answer: 'Une absence de prévision du dommage',
    explanation: 'L’auteur n’a ni voulu ni prévu le résultat dommageable.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Fautes',
    question:
        'Lorsque la causalité est indirecte, la responsabilité pénale nécessite :',
    options: [
      'Une faute caractérisée',
      'Une simple imprudence',
      'Une contravention automatique',
    ],
    answer: 'Une faute caractérisée',
    explanation: 'Le cours distingue causalité directe et indirecte.',
    difficulty: 'Difficile',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                     APPLICATION DE LA LOI DANS LE TEMPS               ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question:
        'La rétroactivité des lois pénales plus douces est justifiée par :',
    options: [
      'Un principe de justice et d’humanité',
      'Une exigence constitutionnelle absolue',
      'Une règle de procédure',
    ],
    answer: 'Un principe de justice et d’humanité',
    explanation:
        'Le principe in mitius permet d’appliquer la loi la plus favorable.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question: 'Les lois modifiant les voies de recours s’appliquent :',
    options: [
      'Aux décisions rendues après leur entrée en vigueur',
      'À toutes les décisions passées',
      'Uniquement aux crimes',
    ],
    answer: 'Aux décisions rendues après leur entrée en vigueur',
    explanation: 'Le cours renvoie à l’article 112-3 du Code pénal.',
    difficulty: 'Difficile',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                     APPLICATION DE LA LOI DANS L’ESPACE               ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question:
        'La loi pénale française peut s’appliquer à un crime commis à l’étranger par un Français :',
    options: ['Oui', 'Non', 'Uniquement si la victime est française'],
    answer: 'Oui',
    explanation:
        'Les articles 113-6 et suivants du Code pénal prévoient cette compétence.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question:
        'Pour les délits commis à l’étranger par un Français, une condition essentielle est :',
    options: [
      'La double incrimination',
      'La plainte obligatoire du procureur',
      'L’accord de la victime',
    ],
    answer: 'La double incrimination',
    explanation:
        'Le fait doit être incriminé à la fois par la loi française et la loi étrangère.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Selon MERLE et VITU, le droit pénal est :',
    options: [
      'L’ensemble des règles organisant la réaction de l’État face aux infractions et aux délinquants',
      'L’ensemble des règles relatives uniquement aux contrats',
      'L’ensemble des règles civiles relatives au dommage',
    ],
    answer:
        'L’ensemble des règles organisant la réaction de l’État face aux infractions et aux délinquants',
    explanation:
        'La définition citée dans le cours attribue au droit pénal l’organisation de la réaction de l’État vis-à-vis des infractions et des délinquants.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le droit pénal général a pour objet principal :',
    options: [
      'Les principes généraux applicables à toutes les infractions',
      'L’étude détaillée de chaque infraction particulière',
      'Uniquement les règles d’enquête policière',
    ],
    answer: 'Les principes généraux applicables à toutes les infractions',
    explanation:
        'Le cours distingue droit pénal général, droit pénal spécial et procédure pénale.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le droit pénal spécial concerne principalement :',
    options: [
      'L’étude des différentes infractions',
      'Les règles de compétence territoriale',
      'La hiérarchie des juridictions',
    ],
    answer: 'L’étude des différentes infractions',
    explanation:
        'Le cours indique que le droit pénal spécial porte étude des différentes infractions.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'La procédure pénale étudie notamment :',
    options: [
      'Le déroulement du procès pénal de la commission de l’infraction jusqu’à la sanction',
      'Uniquement la rédaction des contrats',
      'Uniquement la responsabilité civile',
    ],
    answer:
        'Le déroulement du procès pénal de la commission de l’infraction jusqu’à la sanction',
    explanation:
        'Le cours précise le périmètre : de la commission de l’infraction jusqu’au prononcé de la sanction.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question:
        'Le code pénal initialement conçu et rédigé en 1810 a été largement remanié par :',
    options: [
      'Les lois de 1992 (entrée en vigueur le 1er mars 1994)',
      'Les lois de 2009',
      'Les lois de 1958',
    ],
    answer: 'Les lois de 1992 (entrée en vigueur le 1er mars 1994)',
    explanation:
        'Le cours mentionne un remaniement majeur par les lois de 1992, entrées en vigueur le 1er mars 1994.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le code pénal comprend :',
    options: [
      'Une partie législative et une partie réglementaire',
      'Uniquement une partie législative',
      'Uniquement une partie réglementaire',
    ],
    answer: 'Une partie législative et une partie réglementaire',
    explanation:
        'Le cours indique : partie législative (7 livres) et partie réglementaire (décrets en Conseil d’État).',
    difficulty: 'Moyenne',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                         NOTION D’INFRACTION                             ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Infraction',
    question: 'Selon le cours, une infraction peut être définie comme :',
    options: [
      'Toute action ou omission contraire à l’ordre social, prévue et réprimée par la loi',
      'Toute action immorale même sans texte',
      'Tout dommage causé à autrui sans condition',
    ],
    answer:
        'Toute action ou omission contraire à l’ordre social, prévue et réprimée par la loi',
    explanation:
        'La définition du cours insiste sur l’action ou l’omission, la prévision par la loi et la répression.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Infraction',
    question:
        'Le code pénal prévoit une définition explicite et générale de l’infraction :',
    options: ['Oui', 'Non', 'Uniquement pour les contraventions'],
    answer: 'Non',
    explanation:
        'Le cours précise que le code pénal ne prévoit pas de définition de l’infraction.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Infraction',
    question:
        'Le délit civil (article 1240 du Code civil) renvoie principalement :',
    options: [
      'À la réparation d’un dommage (dommages et intérêts)',
      'À l’emprisonnement',
      'À l’amende contraventionnelle',
    ],
    answer: 'À la réparation d’un dommage (dommages et intérêts)',
    explanation:
        'Le cours rappelle l’obligation de réparer le dommage causé à autrui.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Infraction',
    question: 'Le délit disciplinaire correspond :',
    options: [
      'À la violation de règles propres à un groupement professionnel ou un corps légalement constitué',
      'À une infraction prévue uniquement par le Code pénal',
      'À un crime contre la Nation',
    ],
    answer:
        'À la violation de règles propres à un groupement professionnel ou un corps légalement constitué',
    explanation:
        'Le cours distingue l’infraction pénale du délit disciplinaire, relevant d’un régime interne.',
    difficulty: 'Moyenne',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///               CLASSIFICATION TRIPARTITE / CONSÉQUENCES                  ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'La classification tripartite repose sur :',
    options: [
      'La gravité de l’infraction',
      'L’âge de l’auteur',
      'Le lieu de commission',
    ],
    answer: 'La gravité de l’infraction',
    explanation:
        'L’article 111-1 du Code pénal classe les infractions selon leur gravité : crimes, délits, contraventions.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'Les infractions pénales sont classées en :',
    options: [
      'Crimes, délits et contraventions',
      'Crimes, fautes et manquements',
      'Contrats, délits et dommages',
    ],
    answer: 'Crimes, délits et contraventions',
    explanation:
        'C’est la classification tripartite mentionnée par l’article 111-1 du Code pénal.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'La tentative est :',
    options: [
      'Toujours punissable pour les crimes',
      'Jamais punissable pour les crimes',
      'Toujours punissable pour les contraventions',
    ],
    answer: 'Toujours punissable pour les crimes',
    explanation:
        'Le cours précise : tentative toujours punissable pour les crimes.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'La tentative de contravention est :',
    options: [
      'Jamais punissable',
      'Toujours punissable',
      'Punissable si un texte le prévoit',
    ],
    answer: 'Jamais punissable',
    explanation:
        'Le cours rappelle que la tentative n’est jamais punissable pour les contraventions.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'La complicité est prévue :',
    options: [
      'Pour les crimes et délits, et pour les contraventions seulement si un texte le prévoit expressément',
      'Uniquement pour les contraventions',
      'Uniquement pour les crimes',
    ],
    answer:
        'Pour les crimes et délits, et pour les contraventions seulement si un texte le prévoit expressément',
    explanation:
        'Le cours distingue la règle générale (crimes/délits) et l’exception (contraventions).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'Les contraventions sont jugées principalement par :',
    options: [
      'Le tribunal de police',
      'Le tribunal correctionnel',
      'La cour d’assises',
    ],
    answer: 'Le tribunal de police',
    explanation: 'Le cours indique : contraventions → tribunal de police.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'Les délits sont jugés principalement par :',
    options: [
      'Le tribunal correctionnel',
      'La cour d’assises',
      'Le tribunal de police',
    ],
    answer: 'Le tribunal correctionnel',
    explanation: 'Le cours indique : délits → tribunal correctionnel.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification',
    question: 'Les crimes sont jugés principalement par :',
    options: [
      'La cour d’assises ou la cour criminelle départementale',
      'Le tribunal correctionnel',
      'Le tribunal de police',
    ],
    answer: 'La cour d’assises ou la cour criminelle départementale',
    explanation:
        'Le cours cite la cour d’assises et la cour criminelle départementale pour les crimes.',
    difficulty: 'Facile',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                 PRESCRIPTION (ACTION PUBLIQUE / PEINE)                  ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Prescription',
    question: 'La prescription de l’action publique correspond :',
    options: [
      'À la date au-delà de laquelle il n’est plus possible de poursuivre l’auteur',
      'À la date au-delà de laquelle il est interdit d’enquêter',
      'À la date au-delà de laquelle la victime ne peut plus témoigner',
    ],
    answer:
        'À la date au-delà de laquelle il n’est plus possible de poursuivre l’auteur',
    explanation:
        'Le cours définit la prescription de l’action publique comme la limite de poursuite.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Prescription',
    question:
        'Le délai de prescription de l’action publique pour un délit est de :',
    options: ['6 ans', '20 ans', '1 an'],
    answer: '6 ans',
    explanation:
        'Le cours mentionne les délais : crimes 20 ans, délits 6 ans, contraventions 1 an (articles 7, 8 et 9 du Code de procédure pénale).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Prescription',
    question:
        'Le délai de prescription de la peine pour une contravention est de :',
    options: ['3 ans', '1 an', '6 ans'],
    answer: '3 ans',
    explanation:
        'Le cours indique : prescription de la peine = 20 ans crimes, 6 ans délits, 3 ans contraventions.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Prescription',
    question: 'La prescription de la peine correspond :',
    options: [
      'À la date au-delà de laquelle une peine prononcée ne peut plus être appliquée',
      'À la date au-delà de laquelle il est interdit de déposer plainte',
      'À la date au-delà de laquelle l’infraction est effacée automatiquement',
    ],
    answer:
        'À la date au-delà de laquelle une peine prononcée ne peut plus être appliquée',
    explanation:
        'Le cours distingue bien l’action publique (poursuivre) et la peine (exécuter).',
    difficulty: 'Facile',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///         CLASSIFICATION PAR NATURE : POLITIQUE / TERRORISME / MILITAIRE  ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Infractions politiques',
    question:
        'Le critère doctrinal retenu par la jurisprudence pour l’infraction politique est :',
    options: [
      'Le critère objectif',
      'Le critère subjectif (mobile)',
      'Le critère économique',
    ],
    answer: 'Le critère objectif',
    explanation:
        'Le cours précise : infraction politique = atteinte à l’organisation/fonctionnement des pouvoirs publics, intérêt ou existence de l’État.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Infractions politiques',
    question:
        'Selon la jurisprudence, le mobile politique suffit à rendre l’infraction politique :',
    options: [
      'Oui, toujours',
      'Non, l’objet de l’infraction prime',
      'Oui, uniquement pour les crimes',
    ],
    answer: 'Non, l’objet de l’infraction prime',
    explanation:
        'Le cours indique que la jurisprudence tient compte du seul objet de l’infraction, pas des mobiles.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Terrorisme',
    question: 'Les infractions de terrorisme sont qualifiées à partir :',
    options: [
      'D’une liste d’infractions et de circonstances/motifs particuliers',
      'Uniquement du mobile politique',
      'Uniquement du lieu de commission',
    ],
    answer: 'D’une liste d’infractions et de circonstances/motifs particuliers',
    explanation:
        'Le cours explique que des infractions listées, commises dans certaines circonstances et pour certains motifs, sont qualifiées de terrorisme.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Terrorisme',
    question:
        'La centralisation possible des procédures de terrorisme peut être effectuée :',
    options: [
      'À Paris',
      'Uniquement au lieu de commission',
      'Uniquement à l’étranger',
    ],
    answer: 'À Paris',
    explanation:
        'Le cours mentionne la possibilité de centralisation à Paris via l’article 706-17 du Code de procédure pénale.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Infractions militaires',
    question: 'Une infraction militaire peut correspondre :',
    options: [
      'À un manquement à la discipline ou aux obligations militaires',
      'Uniquement à un vol simple',
      'Uniquement à une contravention routière',
    ],
    answer: 'À un manquement à la discipline ou aux obligations militaires',
    explanation:
        'Le cours cite rébellion, refus d’obéissance, désertion, insoumission.',
    difficulty: 'Moyenne',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                     ÉLÉMENTS CONSTITUTIFS : LÉGAL                       ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Élément légal',
    question:
        'Le principe selon lequel il n’existe pas d’infraction sans texte exprime :',
    options: [
      'Le principe de légalité',
      'Le principe de territorialité',
      'Le principe de proportionnalité',
    ],
    answer: 'Le principe de légalité',
    explanation: 'Le cours souligne : sans texte légal, pas d’infraction.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément légal',
    question: 'Les contraventions sont définies principalement par :',
    options: ['Le règlement', 'La doctrine', 'La coutume'],
    answer: 'Le règlement',
    explanation:
        'Le cours précise que les éléments des contraventions sont définis par le règlement.',
    difficulty: 'Moyenne',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                    ÉLÉMENTS CONSTITUTIFS : MATÉRIEL                     ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Élément matériel',
    question: 'Les actes préparatoires sont en principe :',
    options: [
      'Non réprimés',
      'Toujours punis comme la tentative',
      'Toujours punis comme l’infraction consommée',
    ],
    answer: 'Non réprimés',
    explanation:
        'Le cours indique que les actes préparatoires échappent à la répression.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément matériel',
    question: 'La seule pensée criminelle est :',
    options: [
      'Non répréhensible tant qu’elle n’est pas matérialisée',
      'Toujours punissable',
      'Punissable uniquement en contravention',
    ],
    answer: 'Non répréhensible tant qu’elle n’est pas matérialisée',
    explanation:
        'Le cours rappelle l’absence de manifestation extérieure : pas de trouble social pénalement réprimable.',
    difficulty: 'Facile',
  ),

  /////////////////////////////////////////////////////////////////////////////
  ///                     ÉLÉMENTS CONSTITUTIFS : MORAL                       ///
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Le dol général correspond :',
    options: [
      'À la conscience ou volonté d’accomplir un acte illicite',
      'À la volonté de réparer un dommage',
      'À une simple maladresse',
    ],
    answer: 'À la conscience ou volonté d’accomplir un acte illicite',
    explanation:
        'Le cours définit le dol général comme la conscience ou la volonté d’accomplir un acte illicite.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le droit pénal est défini par MERLE et VITU comme :',
    options: [
      'L’ensemble des règles juridiques qui organisent la réaction de l’État vis-à-vis des infractions et des délinquants',
      'L’ensemble des règles qui organisent uniquement les contrats civils',
      'L’ensemble des règles relatives uniquement à la responsabilité administrative',
    ],
    answer:
        'L’ensemble des règles juridiques qui organisent la réaction de l’État vis-à-vis des infractions et des délinquants',
    explanation:
        'Le cours cite MERLE et VITU : le droit pénal organise la réaction de l’État face aux infractions et aux délinquants.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le droit pénal a notamment pour but :',
    options: [
      'D’assurer et d’organiser la prévention et la répression des actes portant atteinte à la société',
      'D’organiser uniquement l’indemnisation du dommage civil',
      'De régler exclusivement les litiges entre commerçants',
    ],
    answer:
        'D’assurer et d’organiser la prévention et la répression des actes portant atteinte à la société',
    explanation:
        'Le cours précise que le droit pénal vise la prévention et la répression des atteintes à la société.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le droit pénal se divise notamment en :',
    options: [
      'Droit pénal général, droit pénal spécial et procédure pénale',
      'Droit civil, droit commercial et droit fiscal',
      'Droit constitutionnel, droit européen et droit du travail',
    ],
    answer: 'Droit pénal général, droit pénal spécial et procédure pénale',
    explanation:
        'Le cours distingue ces trois branches : droit pénal général, droit pénal spécial et procédure pénale.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le droit pénal général correspond :',
    options: [
      'Aux principes généraux applicables à toutes les infractions',
      'À l’étude exclusive des infractions terroristes',
      'Aux règles de procédure civile',
    ],
    answer: 'Aux principes généraux applicables à toutes les infractions',
    explanation:
        'Le cours précise que le droit pénal général définit les principes généraux applicables à toutes les infractions.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le droit pénal spécial correspond :',
    options: [
      'À l’étude des différentes infractions',
      'À l’étude des institutions européennes',
      'À l’étude des contrats',
    ],
    answer: 'À l’étude des différentes infractions',
    explanation:
        'Le cours indique que le droit pénal spécial porte sur l’étude des différentes infractions.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'La procédure pénale comporte l’étude :',
    options: [
      'Du déroulement du procès pénal depuis la commission de l’infraction jusqu’au prononcé de la sanction',
      'Uniquement du prononcé des peines d’amende',
      'Uniquement de la classification des contraventions',
    ],
    answer:
        'Du déroulement du procès pénal depuis la commission de l’infraction jusqu’au prononcé de la sanction',
    explanation:
        'Le cours précise que la procédure pénale étudie le procès pénal de la commission de l’infraction jusqu’à la sanction.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'La source principale du droit pénal est :',
    options: ['Le Code pénal', 'Le Code civil', 'Le Code du travail'],
    answer: 'Le Code pénal',
    explanation:
        'Le cours précise que la source principale du droit pénal est le Code pénal.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le Code pénal (rappelé par le cours) a été conçu et rédigé en :',
    options: ['1810', '1958', '1994'],
    answer: '1810',
    explanation:
        'Le cours indique que le Code pénal a été conçu et rédigé en 1810.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le Code pénal a été largement remanié par :',
    options: [
      'Les lois de 1992 (entrée en vigueur le 1er mars 1994)',
      'La loi du 24 novembre 2009',
      'Le Code civil de 1804',
    ],
    answer: 'Les lois de 1992 (entrée en vigueur le 1er mars 1994)',
    explanation:
        'Le cours indique un remaniement par les lois de 1992, avec une entrée en vigueur le 1er mars 1994.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le Code pénal comprend :',
    options: [
      'Une partie législative formée de 7 livres et une partie réglementaire constituée de décrets pris en Conseil d’État',
      'Une partie uniquement réglementaire',
      'Une partie uniquement jurisprudentielle',
    ],
    answer:
        'Une partie législative formée de 7 livres et une partie réglementaire constituée de décrets pris en Conseil d’État',
    explanation:
        'Le cours précise que le Code pénal comprend 7 livres législatifs et une partie réglementaire (décrets en Conseil d’État).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Généralités',
    question: 'Le Code de procédure pénale traite notamment :',
    options: [
      'De l’action publique, de l’instruction, des juridictions de jugement et de l’enquête policière',
      'Uniquement de la responsabilité civile',
      'Uniquement des crimes contre l’humanité',
    ],
    answer:
        'De l’action publique, de l’instruction, des juridictions de jugement et de l’enquête policière',
    explanation:
        'Le cours liste ces domaines comme relevant du Code de procédure pénale.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Droit pénal général — Notion d’infraction / Distinctions
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Classification des infractions',
    question: 'Le Code pénal prévoit une définition générale de l’infraction :',
    options: [
      'Non',
      'Oui, dans l’article 111-1',
      'Oui, uniquement pour les crimes',
    ],
    answer: 'Non',
    explanation:
        'Le cours précise que le Code pénal ne prévoit pas de définition de l’infraction.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification des infractions',
    question: 'Selon le cours, une infraction peut se définir comme :',
    options: [
      'Toute action ou omission contraire à l’ordre social, prévue et réprimée par la loi, exposant à une peine ou une mesure de sûreté',
      'Toute action immorale même sans texte',
      'Tout dommage civil entraînant automatiquement une condamnation pénale',
    ],
    answer:
        'Toute action ou omission contraire à l’ordre social, prévue et réprimée par la loi, exposant à une peine ou une mesure de sûreté',
    explanation:
        'Le cours propose cette définition à partir de la lecture des textes : action/omission, prévue et réprimée, peine ou mesure de sûreté.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification des infractions',
    question: 'Le “délit civil” (article 1240 du Code civil) correspond :',
    options: [
      'À un fait quelconque causant un dommage obligeant à le réparer (dommages et intérêts)',
      'À une peine d’emprisonnement',
      'À une réclusion criminelle',
    ],
    answer:
        'À un fait quelconque causant un dommage obligeant à le réparer (dommages et intérêts)',
    explanation:
        'Le cours rappelle la définition du Code civil (art. 1240) : réparation du dommage par dommages et intérêts.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Classification des infractions',
    question: 'Le “délit disciplinaire” consiste :',
    options: [
      'Dans la violation de règles propres à un groupement professionnel ou à un corps légalement constitué',
      'Dans toute infraction prévue par le Code pénal',
      'Dans une contravention routière uniquement',
    ],
    answer:
        'Dans la violation de règles propres à un groupement professionnel ou à un corps légalement constitué',
    explanation:
        'Le cours distingue l’infraction pénale du délit disciplinaire (règles internes à un groupement).',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Droit pénal général — Éléments constitutifs (légal / matériel / moral)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Éléments constitutifs',
    question: 'Les éléments constitutifs généraux d’une infraction sont :',
    options: [
      'Un élément légal, un élément matériel et un élément moral',
      'Un élément civil, un élément financier et un élément administratif',
      'Un élément fiscal, un élément disciplinaire et un élément moral',
    ],
    answer: 'Un élément légal, un élément matériel et un élément moral',
    explanation:
        'Le cours indique que toutes les infractions comportent trois éléments : légal, matériel et moral.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Éléments constitutifs',
    question: 'Pour que l’infraction existe, il faut :',
    options: [
      'Que les trois éléments (légal, matériel, moral) soient réunis',
      'Uniquement un texte légal',
      'Uniquement une intention coupable',
    ],
    answer: 'Que les trois éléments (légal, matériel, moral) soient réunis',
    explanation:
        'Le cours précise que l’infraction n’existe que si les trois éléments sont réunis.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Droit pénal général — Élément légal / Principe de légalité / Sources
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Sources / Principe de légalité',
    question:
        'Le principe “Sans texte légal, il n’y a pas d’infraction” correspond au :',
    options: [
      'Principe de légalité',
      'Principe de territorialité',
      'Principe de rétroactivité',
    ],
    answer: 'Principe de légalité',
    explanation:
        'Le cours rappelle que sans texte légal, il n’y a pas d’infraction : c’est le principe de légalité.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources / Principe de légalité',
    question: 'Le principe de légalité est posé par :',
    options: [
      'L’article 111-3 du Code pénal',
      'L’article 113-2 du Code pénal',
      'L’article 121-5 du Code pénal',
    ],
    answer: 'L’article 111-3 du Code pénal',
    explanation:
        'Le cours cite l’article 111-3 du Code pénal : nul ne peut être puni si les éléments ne sont pas définis par la loi ou le règlement.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources / Principe de légalité',
    question:
        'Selon l’article 111-3 du Code pénal, les contraventions sont définies par :',
    options: ['Le règlement', 'La loi uniquement', 'La jurisprudence'],
    answer: 'Le règlement',
    explanation:
        'Le cours rappelle que l’article 111-3 vise la loi (crimes/délits) et le règlement (contraventions).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources / Principe de légalité',
    question: 'Selon le cours, les sources essentielles du droit pénal sont :',
    options: [
      'La loi (et textes assimilés) et le règlement',
      'La coutume et la morale',
      'Les circulaires et la doctrine',
    ],
    answer: 'La loi (et textes assimilés) et le règlement',
    explanation:
        'Le cours indique que, sous la Constitution, les sources essentielles sont la loi (et textes assimilés) et le règlement.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources / Principe de légalité',
    question: 'L’article 111-2 du Code pénal dispose que la loi :',
    options: [
      'Détermine les crimes et délits et fixe les peines applicables à leurs auteurs',
      'Détermine les contraventions uniquement',
      'Supprime la notion de tentative',
    ],
    answer:
        'Détermine les crimes et délits et fixe les peines applicables à leurs auteurs',
    explanation:
        'Le cours cite l’article 111-2 du Code pénal : la loi détermine crimes/délits et fixe les peines.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources / Principe de légalité',
    question: 'Parmi les actes ayant valeur de loi, le cours cite :',
    options: [
      'Les décisions présidentielles prises en vertu de l’article 16 de la Constitution',
      'Les circulaires ministérielles',
      'Les avis doctrinaux',
    ],
    answer:
        'Les décisions présidentielles prises en vertu de l’article 16 de la Constitution',
    explanation:
        'Le cours indique que certains actes ont aussi valeur de loi, dont les décisions prises en vertu de l’article 16.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources / Principe de légalité',
    question:
        'Les ordonnances prises sur le fondement de l’article 38 de la Constitution ont valeur de loi lorsqu’elles sont :',
    options: [
      'Ratifiées par le Parlement',
      'Signées uniquement par un maire',
      'Publiées sur un réseau social',
    ],
    answer: 'Ratifiées par le Parlement',
    explanation:
        'Le cours mentionne les ordonnances (art. 38) ratifiées par le Parlement comme ayant valeur de loi.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources / Principe de légalité',
    question:
        'L’article 55 de la Constitution (rappelé par le cours) prévoit que les conventions internationales ratifiées et publiées ont une valeur :',
    options: [
      'Supérieure à la loi interne',
      'Inférieure au règlement',
      'Égale aux circulaires',
    ],
    answer: 'Supérieure à la loi interne',
    explanation:
        'Le cours indique qu’une convention internationale ratifiée et publiée au J.O. a une valeur supérieure à la loi interne (art. 55).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources / Principe de légalité',
    question:
        'Les règlements administratifs émanent du pouvoir exécutif en vertu de :',
    options: [
      'L’article 37 de la Constitution de 1958',
      'L’article 34 du Code pénal',
      'L’article 1240 du Code civil',
    ],
    answer: 'L’article 37 de la Constitution de 1958',
    explanation:
        'Le cours précise que les règlements administratifs relèvent du pouvoir exécutif en vertu de l’article 37.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources / Principe de légalité',
    question: 'Selon l’article 111-2 alinéa 2 du Code pénal, le règlement :',
    options: [
      'Détermine les contraventions et fixe les peines applicables aux contrevenants',
      'Détermine les crimes et délits',
      'Définit la jurisprudence',
    ],
    answer:
        'Détermine les contraventions et fixe les peines applicables aux contrevenants',
    explanation:
        'Le cours cite l’article 111-2 al. 2 : le règlement détermine les contraventions et fixe les peines.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources / Principe de légalité',
    question: 'Les circulaires sont :',
    options: [
      'Des instructions de service écrites adressées par une autorité supérieure à des agents subordonnés',
      'Des lois votées par le Parlement',
      'Des décisions de justice rendues par la Cour de cassation',
    ],
    answer:
        'Des instructions de service écrites adressées par une autorité supérieure à des agents subordonnés',
    explanation:
        'Le cours définit les circulaires comme des instructions de service écrites.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources / Principe de légalité',
    question: 'Selon le cours, les circulaires :',
    options: [
      'Ne sont pas source de droit pénal',
      'Sont la source principale du droit pénal',
      'Ont une valeur supérieure à la loi interne',
    ],
    answer: 'Ne sont pas source de droit pénal',
    explanation:
        'Le cours indique que les circulaires ne constituent pas une source du droit pénal.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources / Principe de légalité',
    question: 'La jurisprudence correspond :',
    options: [
      'À l’ensemble des décisions rendues par les tribunaux, particulièrement par la Cour de cassation',
      'À un texte voté par le Parlement',
      'À un règlement municipal',
    ],
    answer:
        'À l’ensemble des décisions rendues par les tribunaux, particulièrement par la Cour de cassation',
    explanation:
        'Le cours définit la jurisprudence comme l’ensemble des décisions rendues par les tribunaux, surtout la Cour de cassation.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Sources / Principe de légalité',
    question: 'La doctrine correspond :',
    options: [
      'À l’énoncé des positions de juristes éminents, sans valeur normative',
      'À une loi adoptée par référendum',
      'À une ordonnance ratifiée',
    ],
    answer:
        'À l’énoncé des positions de juristes éminents, sans valeur normative',
    explanation:
        'Le cours précise que la doctrine n’a pas de valeur normative et sert de source d’inspiration.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Droit pénal général — Élément matériel / Tentative
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'La seule pensée criminelle est :',
    options: [
      'Non répréhensible si elle n’est pas matérialisée concrètement',
      'Toujours punissable',
      'Punissable comme une contravention',
    ],
    answer: 'Non répréhensible si elle n’est pas matérialisée concrètement',
    explanation:
        'Le cours précise que la pensée criminelle n’est pas répréhensible tant qu’elle n’est pas matérialisée.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'Les actes préparatoires sont en principe :',
    options: [
      'Non punissables',
      'Toujours punissables',
      'Punissables uniquement pour les contraventions',
    ],
    answer: 'Non punissables',
    explanation:
        'Le cours indique que les actes préparatoires échappent à la répression.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'La tentative punissable suppose :',
    options: [
      'Un commencement d’exécution et une absence de désistement volontaire',
      'Une simple intention orale',
      'Un dommage obligatoire',
    ],
    answer:
        'Un commencement d’exécution et une absence de désistement volontaire',
    explanation:
        'Le cours précise que la tentative nécessite ces deux éléments : commencement d’exécution + absence de désistement volontaire.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question:
        'L’article 121-5 du Code pénal définit la tentative comme constituée lorsque :',
    options: [
      'Elle est manifestée par un commencement d’exécution et n’a été suspendue ou n’a manqué son effet qu’en raison de circonstances indépendantes de la volonté de son auteur',
      'L’auteur regrette après coup',
      'La victime refuse de porter plainte',
    ],
    answer:
        'Elle est manifestée par un commencement d’exécution et n’a été suspendue ou n’a manqué son effet qu’en raison de circonstances indépendantes de la volonté de son auteur',
    explanation:
        'Le cours reprend la définition de l’article 121-5 du Code pénal.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question:
        'Le commencement d’exécution se distingue des actes préparatoires car il :',
    options: [
      'Traduit sans ambiguïté la volonté de commettre l’infraction',
      'Correspond à une pensée non matérialisée',
      'Se limite à se renseigner sur une victime',
    ],
    answer: 'Traduit sans ambiguïté la volonté de commettre l’infraction',
    explanation:
        'Le cours indique que le comportement doit traduire sans ambiguïté la volonté de commettre l’infraction.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question:
        'Selon la jurisprudence citée par le cours, le commencement d’exécution suppose notamment :',
    options: [
      'Un acte univoque et une intention irrévocable de réaliser une infraction précise',
      'Une plainte obligatoire de la victime',
      'Un dommage déjà réalisé',
    ],
    answer:
        'Un acte univoque et une intention irrévocable de réaliser une infraction précise',
    explanation:
        'Le cours indique que la Cour de cassation exige un acte univoque et une intention irrévocable pour admettre un commencement d’exécution.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question:
        'Le désistement volontaire (renonciation sans cause extérieure) entraîne :',
    options: [
      'L’impunité',
      'La même peine que l’infraction consommée',
      'Une peine automatique de 3 ans',
    ],
    answer: 'L’impunité',
    explanation:
        'Le cours précise que l’auteur qui renonce de lui-même, sans cause extérieure, n’est pas punissable.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question:
        'Lorsque le désistement est déterminé par une cause extérieure, la tentative est :',
    options: ['Punissable', 'Toujours excusée', 'Jamais retenue'],
    answer: 'Punissable',
    explanation:
        'Le cours précise que si l’interruption provient d’une cause extérieure (police, résistance, obstacle), la tentative est punissable.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'Le repentir actif après consommation de l’infraction :',
    options: [
      'N’a pas d’influence sur la responsabilité pénale',
      'Efface automatiquement l’infraction',
      'Transforme l’infraction en contravention',
    ],
    answer: 'N’a pas d’influence sur la responsabilité pénale',
    explanation:
        'Le cours indique qu’une fois l’infraction consommée, l’attitude postérieure de l’auteur est sans influence sur sa responsabilité pénale.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'En matière de crime, la tentative est :',
    options: [
      'Toujours punissable',
      'Jamais punissable',
      'Punissable uniquement si un texte le prévoit',
    ],
    answer: 'Toujours punissable',
    explanation:
        'Le cours rappelle que la tentative est systématiquement poursuivie en matière de crime.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'En matière délictuelle, la tentative est punissable :',
    options: [
      'Seulement si le texte d’incrimination le spécifie',
      'Toujours',
      'Jamais',
    ],
    answer: 'Seulement si le texte d’incrimination le spécifie',
    explanation:
        'Le cours précise que la tentative n’est punissable en matière de délit que si le texte le prévoit.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'La tentative de contravention est :',
    options: [
      'Jamais punissable',
      'Toujours punissable',
      'Punissable si la victime porte plainte',
    ],
    answer: 'Jamais punissable',
    explanation:
        'Le cours indique que la tentative de contravention n’est jamais punissable.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'L’infraction manquée suppose :',
    options: [
      'Une exécution complète des éléments qui échoue par circonstances indépendantes de la volonté de l’auteur',
      'Une simple intention orale',
      'Un acte préparatoire équivoque',
    ],
    answer:
        'Une exécution complète des éléments qui échoue par circonstances indépendantes de la volonté de l’auteur',
    explanation:
        'Le cours définit l’infraction manquée comme une exécution complète qui échoue en raison de circonstances indépendantes.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'L’infraction impossible correspond :',
    options: [
      'À une impossibilité ignorée de l’auteur (objet absent, moyens inefficaces, etc.)',
      'À une infraction déjà consommée',
      'À une contravention de 1ère classe',
    ],
    answer:
        'À une impossibilité ignorée de l’auteur (objet absent, moyens inefficaces, etc.)',
    explanation:
        'Le cours donne des exemples : poche vide, coup de feu tiré à blanc.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Tentative',
    question: 'Selon le cours, l’infraction impossible est punissable :',
    options: [
      'Dans le cadre de la tentative, lorsque la tentative est incriminée',
      'Toujours, même en contravention',
      'Uniquement par une sanction disciplinaire',
    ],
    answer:
        'Dans le cadre de la tentative, lorsque la tentative est incriminée',
    explanation:
        'Le cours précise que l’infraction impossible n’ayant pas été prévue par la loi, sa répression ne peut se faire que dans le cadre de la tentative.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Droit pénal général — Élément moral
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Le dol général correspond :',
    options: [
      'À la conscience ou volonté d’accomplir un acte illicite',
      'À la volonté de réparer un dommage',
      'À une simple maladresse',
    ],
    answer: 'À la conscience ou volonté d’accomplir un acte illicite',
    explanation:
        'Le cours définit le dol général comme la conscience ou la volonté d’accomplir un acte illicite.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Le mobile de l’auteur en droit pénal est en principe :',
    options: [
      'Indifférent à la qualification',
      'Toujours déterminant',
      'Toujours une cause d’irresponsabilité',
    ],
    answer: 'Indifférent à la qualification',
    explanation:
        'Le cours précise que le mobile importe peu en droit, même si le juge peut en tenir compte pour la peine.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Une faute intentionnelle signifie que l’auteur :',
    options: [
      'A conscience du caractère illicite de l’acte et veut l’accomplir',
      'Agit uniquement par maladresse',
      'N’a aucune volonté dans l’acte',
    ],
    answer: 'A conscience du caractère illicite de l’acte et veut l’accomplir',
    explanation:
        'Le cours précise que l’auteur a conscience du caractère illicite et la volonté d’accomplir l’acte (faute intentionnelle).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Le dol spécial correspond :',
    options: [
      'À l’intention de parvenir à un résultat particulier exigé par la loi',
      'À une imprudence',
      'À une force majeure',
    ],
    answer:
        'À l’intention de parvenir à un résultat particulier exigé par la loi',
    explanation:
        'Le cours précise que le dol spécial renvoie à une intention particulière (ex : intention de tuer).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'La préméditation est :',
    options: [
      'Une forme aggravée d’intention criminelle',
      'Une faute non intentionnelle',
      'Une cause d’irresponsabilité',
    ],
    answer: 'Une forme aggravée d’intention criminelle',
    explanation:
        'Le cours indique que la préméditation constitue une forme aggravée d’intention criminelle.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Le dol praeter intentionnel correspond :',
    options: [
      'Au résultat obtenu qui va au-delà de ce que l’auteur voulait causer (ex : blesser mais tuer)',
      'À un résultat exactement prévu',
      'À l’absence totale de volonté',
    ],
    answer:
        'Au résultat obtenu qui va au-delà de ce que l’auteur voulait causer (ex : blesser mais tuer)',
    explanation:
        'Le cours donne l’exemple : frapper pour blesser et, en fin de compte, tuer (violences ayant entraîné la mort sans intention de la donner).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'La faute d’imprudence ou de négligence consiste :',
    options: [
      'En une imprudence, négligence ou manquement à une obligation de prudence ou de sécurité',
      'En une intention de nuire',
      'En une préméditation',
    ],
    answer:
        'En une imprudence, négligence ou manquement à une obligation de prudence ou de sécurité',
    explanation:
        'Le cours (art. 121-3 al. 3) définit la faute non intentionnelle par l’imprudence, négligence ou manquement.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Si le lien de causalité est direct, pour établir la faute :',
    options: [
      'Toute imprudence, négligence ou manquement suffit',
      'Il faut toujours prouver une faute caractérisée',
      'Il faut toujours prouver un dol spécial',
    ],
    answer: 'Toute imprudence, négligence ou manquement suffit',
    explanation:
        'Le cours précise que si la causalité est directe, toute imprudence ou manquement suffit à établir la faute.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Si la causalité est indirecte, il est nécessaire de prouver :',
    options: [
      'Une faute caractérisée',
      'Une simple maladresse suffit',
      'Une préméditation',
    ],
    answer: 'Une faute caractérisée',
    explanation:
        'Le cours indique que si la causalité est indirecte, la preuve d’une faute caractérisée est nécessaire.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'La faute contraventionnelle consiste :',
    options: [
      'En la simple violation d’une prescription légale ou réglementaire',
      'En une intention spéciale',
      'En une préméditation',
    ],
    answer: 'En la simple violation d’une prescription légale ou réglementaire',
    explanation:
        'Le cours précise que la faute contraventionnelle résulte de la simple violation d’un texte, indépendamment d’un dommage.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Droit pénal général — Application dans le temps
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question: 'L’article 112-1 du Code pénal pose notamment :',
    options: [
      'Le principe de non-rétroactivité de la loi pénale nouvelle',
      'Le principe de territorialité',
      'Le principe d’immunité diplomatique',
    ],
    answer: 'Le principe de non-rétroactivité de la loi pénale nouvelle',
    explanation:
        'Le cours indique que l’article 112-1 fonde la règle de non-rétroactivité de la loi pénale nouvelle.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question: 'Selon l’article 112-1, sont seuls punissables :',
    options: [
      'Les faits constitutifs d’une infraction à la date à laquelle ils ont été commis',
      'Tous les faits jugés immoraux',
      'Les faits commis après le jugement',
    ],
    answer:
        'Les faits constitutifs d’une infraction à la date à laquelle ils ont été commis',
    explanation:
        'Le cours cite la formule de l’article 112-1 : seuls sont punissables les faits constituant une infraction à la date des faits.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question: 'Une loi pénale nouvelle plus sévère :',
    options: [
      'Ne rétroagit pas',
      'Rétroagit toujours',
      'Rétroagit uniquement si la victime est d’accord',
    ],
    answer: 'Ne rétroagit pas',
    explanation:
        'Le cours rappelle la règle : les lois nouvelles plus sévères ne rétroagissent pas.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question:
        'Une loi interprétative peut s’appliquer à des faits antérieurs car :',
    options: [
      'Elle précise le sens d’une loi antérieure et fait corps avec elle',
      'Elle est toujours plus douce',
      'Elle supprime une incrimination',
    ],
    answer: 'Elle précise le sens d’une loi antérieure et fait corps avec elle',
    explanation:
        'Le cours indique que les lois interprétatives précisent une loi antérieure et s’appliquent donc à des faits antérieurs.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question: 'Les lois nouvelles plus douces s’appliquent :',
    options: [
      'Aux faits commis avant leur entrée en vigueur et non encore jugés définitivement',
      'Uniquement aux faits commis après leur entrée en vigueur',
      'Uniquement aux contraventions',
    ],
    answer:
        'Aux faits commis avant leur entrée en vigueur et non encore jugés définitivement',
    explanation:
        'Le cours rappelle la rétroactivité in mitius : les lois plus douces s’appliquent aux faits antérieurs non jugés définitivement.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question: 'Une affaire est réputée jugée définitivement lorsque :',
    options: [
      'Toutes les voies de recours sont épuisées',
      'Le jugement de première instance est rendu',
      'Le procureur a requis',
    ],
    answer: 'Toutes les voies de recours sont épuisées',
    explanation:
        'Le cours précise qu’une infraction est jugée définitivement lorsque toutes les voies de recours sont épuisées.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question: 'Les lois pénales de forme s’appliquent en principe :',
    options: [
      'Immédiatement, même aux faits commis avant leur entrée en vigueur',
      'Uniquement aux faits futurs',
      'Uniquement si elles sont plus douces',
    ],
    answer: 'Immédiatement, même aux faits commis avant leur entrée en vigueur',
    explanation:
        'Le cours indique (art. 112-2) que les lois pénales de forme s’appliquent immédiatement.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question:
        'Une exception au principe d’application immédiate des lois de forme concerne :',
    options: [
      'L’existence d’un droit acquis au profit du délinquant',
      'La nationalité de la victime',
      'Le fait que l’infraction soit une contravention',
    ],
    answer: 'L’existence d’un droit acquis au profit du délinquant',
    explanation:
        'Le cours indique que la loi nouvelle de forme ne s’applique pas immédiatement s’il existe un droit acquis au profit du délinquant.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question:
        'Une loi nouvelle ne peut entraîner la nullité d’actes régulièrement accomplis :',
    options: [
      'Sous l’empire d’une loi antérieure',
      'Sous l’empire d’une loi postérieure',
      'Sous l’empire d’une doctrine',
    ],
    answer: 'Sous l’empire d’une loi antérieure',
    explanation:
        'Le cours cite l’article 112-4 du Code pénal : une loi nouvelle ne peut annuler des actes régulièrement accomplis sous l’ancienne loi.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans le temps',
    question:
        'Une loi nouvelle relative à la prescription s’applique immédiatement si :',
    options: [
      'La prescription n’est pas encore acquise',
      'La prescription est déjà acquise',
      'Il existe une plainte de la victime',
    ],
    answer: 'La prescription n’est pas encore acquise',
    explanation:
        'Le cours précise que la prescription ne doit pas être acquise pour que la loi nouvelle s’applique immédiatement.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Droit pénal général — Application dans l’espace
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question: 'Le principe de territorialité est posé par :',
    options: [
      'L’article 113-2 du Code pénal',
      'L’article 112-1 du Code pénal',
      'L’article 121-5 du Code pénal',
    ],
    answer: 'L’article 113-2 du Code pénal',
    explanation:
        'Le cours précise que l’article 113-2 prévoit l’application de la loi pénale française aux infractions commises sur le territoire de la République.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question: 'La loi pénale française est applicable :',
    options: [
      'Aux infractions commises sur le territoire de la République',
      'À toutes les infractions commises dans le monde sans condition',
      'Uniquement si la victime est française',
    ],
    answer: 'Aux infractions commises sur le territoire de la République',
    explanation:
        'Le cours rappelle le principe de territorialité : application sur le territoire de la République.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question: 'La notion de territoire (selon le cours) comprend notamment :',
    options: [
      'Espace terrestre, espace aérien, espace maritime, navires et aéronefs',
      'Uniquement la métropole',
      'Uniquement les ambassades',
    ],
    answer:
        'Espace terrestre, espace aérien, espace maritime, navires et aéronefs',
    explanation: 'Le cours liste ces composantes dans la notion de territoire.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question: 'La mer territoriale comprend en principe :',
    options: [
      '12 milles marins à partir des côtes',
      '3 milles marins',
      '50 milles marins',
    ],
    answer: '12 milles marins à partir des côtes',
    explanation:
        'Le cours précise que la mer territoriale correspond à 12 milles marins à partir des côtes.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question:
        'La loi pénale française peut s’appliquer aux infractions commises à bord :',
    options: [
      'Des navires battant pavillon français et des aéronefs immatriculés en France, sous conditions',
      'Uniquement des navires étrangers',
      'Uniquement si l’appareil est en escale en France',
    ],
    answer:
        'Des navires battant pavillon français et des aéronefs immatriculés en France, sous conditions',
    explanation:
        'Le cours indique l’applicabilité à bord des navires pavillon français et aéronefs immatriculés en France.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question: 'La loi française s’applique dès lors :',
    options: [
      'Qu’un des faits constitutifs de l’infraction a été commis en France',
      'Que l’auteur est français, peu importe le lieu',
      'Que la victime est française, peu importe le lieu',
    ],
    answer:
        'Qu’un des faits constitutifs de l’infraction a été commis en France',
    explanation:
        'Le cours précise qu’il suffit qu’un fait constitutif de l’infraction soit commis en France.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question:
        'Une exception évoquée par le cours à l’application de la loi française en France concerne :',
    options: [
      'L’immunité pénale des chefs d’État étrangers séjournant en France et des agents diplomatiques accrédités',
      'L’immunité de tous les touristes',
      'L’immunité de toute personne mineure',
    ],
    answer:
        'L’immunité pénale des chefs d’État étrangers séjournant en France et des agents diplomatiques accrédités',
    explanation: 'Le cours mentionne cette exception au principe.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question:
        'Pour punir en France le complice d’un crime ou délit commis à l’étranger, il faut notamment :',
    options: [
      'La double incrimination et une décision définitive rendue par une juridiction étrangère sur le fait principal',
      'Que la victime soit française uniquement',
      'Que la personne soit mineure',
    ],
    answer:
        'La double incrimination et une décision définitive rendue par une juridiction étrangère sur le fait principal',
    explanation:
        'Le cours indique deux conditions : double incrimination + décision définitive étrangère relative au fait principal.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question: 'La règle de la double incrimination signifie :',
    options: [
      'Le fait est puni à la fois par la loi française et la loi étrangère',
      'Le fait est puni deux fois en France',
      'Le fait est puni seulement par la loi française',
    ],
    answer:
        'Le fait est puni à la fois par la loi française et la loi étrangère',
    explanation:
        'Le cours définit la double incrimination comme une punition prévue par la loi française et la loi étrangère.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question:
        'La loi pénale française peut s’appliquer à un crime commis à l’étranger par un Français :',
    options: ['Oui', 'Non', 'Uniquement si la victime est française'],
    answer: 'Oui',
    explanation:
        'Le cours indique que la loi française est applicable à tout crime commis par un Français hors de France (art. 113-6 et suivants).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question:
        'Pour les délits commis à l’étranger par un Français, une condition essentielle est :',
    options: [
      'Que les faits soient incriminés par le pays où ils ont été commis',
      'Que la victime soit française',
      'Que l’auteur soit jugé d’abord à l’étranger',
    ],
    answer: 'Que les faits soient incriminés par le pays où ils ont été commis',
    explanation:
        'Le cours précise la condition de double incrimination pour les délits commis à l’étranger par un Français.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question:
        'Dans certains cas, la poursuite pour des délits commis à l’étranger suppose :',
    options: [
      'Une plainte de la victime/ayants droit ou une dénonciation officielle (selon les cas)',
      'Un aveu obligatoire',
      'Une immunité automatique',
    ],
    answer:
        'Une plainte de la victime/ayants droit ou une dénonciation officielle (selon les cas)',
    explanation:
        'Le cours indique que la poursuite peut être conditionnée par une plainte ou une dénonciation officielle (art. 113-8 et exceptions).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Élément moral',
    question: 'Le mobile de l’auteur en droit pénal est en principe :',
    options: [
      'Indifférent à la qualification',
      'Toujours déterminant',
      'Toujours une cause d’irresponsabilité',
    ],
    answer: 'Indifférent à la qualification',
    explanation:
        'Le cours précise que le mobile importe peu en droit, même si le juge peut en tenir compte pour la peine.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Application dans l’espace',
    question:
        'Une exception évoquée par le cours à l’application de la loi française en France concerne :',
    options: [
      'L’immunité pénale des chefs d’État étrangers séjournant en France et des agents diplomatiques accrédités',
      'L’immunité de tous les touristes',
      'L’immunité de toute personne mineure',
    ],
    answer:
        'L’immunité pénale des chefs d’État étrangers séjournant en France et des agents diplomatiques accrédités',
    explanation: 'Le cours mentionne cette exception au principe.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité transfrontière',
    question:
        'Selon l’article 113-5 du Code pénal, la loi française peut s’appliquer à celui qui est complice en France :',
    options: [
      'D’un crime ou d’un délit commis à l’étranger',
      'Uniquement d’une contravention commise à l’étranger',
      'Uniquement d’un fait non punissable à l’étranger',
    ],
    answer: 'D’un crime ou d’un délit commis à l’étranger',
    explanation:
        'Le cours indique l’application à la complicité en France d’un crime ou d’un délit commis à l’étranger.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité transfrontière',
    question:
        'Pour punir le complice en France d’un fait commis à l’étranger, il faut notamment :',
    options: [
      'La double incrimination (punissable en droit français et en droit étranger) et une décision définitive à l’étranger relative au fait principal',
      'Une plainte systématique du ministre',
      'Une contravention uniquement',
    ],
    answer:
        'La double incrimination (punissable en droit français et en droit étranger) et une décision définitive à l’étranger relative au fait principal',
    explanation:
        'Le cours liste ces conditions (règle de la double incrimination + décision définitive relative au fait principal).',
    difficulty: 'Difficile',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizDroitPenalePagePA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName = '/pa/droit_penal/quiz/droit_penal_general';
  final String uid;
  final String email;

  const QuizDroitPenalePagePA({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizDroitPenalePagePA> createState() => _QuizDroitPenalePagePAState();
}

class _QuizDroitPenalePagePAState extends State<QuizDroitPenalePagePA>
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
  static const _introHiddenKey = 'intro_pa_droit_penale';
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
        ? questionsGPXSchoolDroitPenalGeneral
        : questionsGPXSchoolDroitPenalGeneral
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
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Loi pénale',
            'quiz_name': 'Loi pénale',
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
      await _sb.from('quiz_droit_penale').insert({
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
      debugPrint('❌ quiz_droit_penale insert failed: $e');
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
      'source_file': 'pa_quiz_droit_penale',
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
                            icon: Icons.menu_book_rounded,
                            title: 'Droit pénal',
                            description: 'Approfondis les fondements du droit pénal : principes généraux, éléments constitutifs des infractions, classification et application de la loi pénale.',
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
