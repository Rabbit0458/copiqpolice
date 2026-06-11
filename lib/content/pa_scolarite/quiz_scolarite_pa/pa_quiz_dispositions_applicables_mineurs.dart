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
final List<QuizQuestion> questionsCJPM = [
  // =====================================================
  // NIVEAU 1 — FACILE
  // =====================================================

  // PRINCIPES GÉNÉRAUX
  const QuizQuestion(
    category: 'CJPM — Principes généraux',
    question:
        'Le code de la justice pénale des mineurs (CJPM) fixe notamment comme principe :',
    options: [
      'La primauté de la réponse éducative sur la réponse répressive',
      'La primauté de la réponse répressive sur la réponse éducative',
      'L’absence de toute réponse pénale pour les mineurs',
    ],
    answer: 'La primauté de la réponse éducative sur la réponse répressive',
    explanation:
        'Parmi les trois principes fondamentaux, le CJPM consacre la primauté de la réponse éducative.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'CJPM — Principes généraux',
    question:
        'Parmi ces principes, lequel fait partie des fondements de la justice pénale des mineurs ?',
    options: [
      'Le jugement par une juridiction spécialisée',
      'Le jugement exclusivement par les juridictions de majeurs',
      'Le jugement par un jury populaire uniquement',
    ],
    answer: 'Le jugement par une juridiction spécialisée',
    explanation:
        'Le CJPM prévoit que les mineurs sont jugés par des juridictions et chambres spécialisées.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'CJPM — Principes généraux',
    question:
        'Le CJPM rappelle en liminaire que l’intérêt supérieur de l’enfant :',
    options: [
      'Est accessoire par rapport à l’ordre public',
      'Doit être pris en compte comme principe directeur de toute la procédure',
      'Ne s’applique qu’aux enfants de moins de 10 ans',
    ],
    answer:
        'Doit être pris en compte comme principe directeur de toute la procédure',
    explanation:
        'L’intérêt supérieur de l’enfant, issu de la CIDE, est érigé en principe directeur de la procédure pénale des mineurs.',
    difficulty: 'Facile',
  ),

  // PRÉSOMPTION DE DISCERNEMENT
  const QuizQuestion(
    category: 'CJPM — Discernement',
    question:
        'Le seuil d’âge de la capacité de discernement, et donc de la responsabilité pénale, est fixé à :',
    options: ['10 ans', '13 ans', '16 ans'],
    answer: '13 ans',
    explanation:
        'Le CJPM reprend le principe de l’article 122-8 du Code pénal : le seuil de discernement est fixé à 13 ans.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'CJPM — Discernement',
    question: 'Pour les mineurs de moins de 13 ans, la présomption est :',
    options: [
      'Une présomption de discernement',
      'Une présomption de non discernement',
      'Une présomption de culpabilité',
    ],
    answer: 'Une présomption de non discernement',
    explanation:
        'Le texte prévoit une présomption de non discernement pour les moins de 13 ans.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'CJPM — Discernement',
    question: 'Pour les mineurs de plus de 13 ans, la présomption est :',
    options: [
      'Une présomption de discernement',
      'Une présomption d’innocence supprimée',
      'Une présomption de dangerosité',
    ],
    answer: 'Une présomption de discernement',
    explanation:
        'Au-delà de 13 ans, il existe une présomption de discernement, donc de responsabilité pénale possible.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'CJPM — Discernement',
    question:
        'La capacité de discernement d’un mineur se définit notamment par :',
    options: [
      'La capacité à comprendre et vouloir l’acte et à comprendre le sens de la procédure',
      'Sa taille et son niveau scolaire',
      'Le fait d’être déjà connu des services de police',
    ],
    answer:
        'La capacité à comprendre et vouloir l’acte et à comprendre le sens de la procédure',
    explanation:
        'Le CJPM donne cette définition fonctionnelle du discernement.',
    difficulty: 'Facile',
  ),

  // MINEUR < 13 / ≥ 13
  const QuizQuestion(
    category: 'CJPM — Responsabilité pénale',
    question: 'Pour un mineur de moins de 13 ans, en principe :',
    options: [
      'Des peines peuvent être prononcées comme pour un majeur',
      'Aucune peine ne peut être encourue, seules des mesures éducatives sont possibles en cas de discernement',
      'Il ne peut faire l’objet d’aucune mesure',
    ],
    answer:
        'Aucune peine ne peut être encourue, seules des mesures éducatives sont possibles en cas de discernement',
    explanation:
        'Le CJPM interdit le prononcé de peines avant 13 ans, mais autorise des mesures éducatives si le discernement est établi.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'CJPM — Responsabilité pénale',
    question: 'Pour un mineur âgé d’au moins 13 ans :',
    options: [
      'Seules des peines sont possibles',
      'Seules des mesures éducatives sont possibles',
      'Des mesures éducatives et/ou des peines peuvent être prononcées',
    ],
    answer: 'Des mesures éducatives et/ou des peines peuvent être prononcées',
    explanation:
        'Après 13 ans, la palette va de la mesure éducative à la peine, en tenant compte de l’atténuation de responsabilité.',
    difficulty: 'Facile',
  ),

  // SPÉCIALISATION DES ACTEURS
  const QuizQuestion(
    category: 'CJPM — Juridictions spécialisées',
    question:
        'Quel juge est spécialement compétent pour les affaires pénales concernant les mineurs ?',
    options: [
      'Le juge des enfants',
      'Le juge de l’application des peines des majeurs',
      'Le juge administratif',
    ],
    answer: 'Le juge des enfants',
    explanation:
        'Le juge des enfants est l’un des acteurs spécialisés de la justice pénale des mineurs.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'CJPM — Juridictions spécialisées',
    question: 'Les crimes reprochés à un mineur sont jugés par :',
    options: [
      'La cour d’assises des mineurs',
      'La cour d’assises de droit commun sans adaptation',
      'Le conseil municipal',
    ],
    answer: 'La cour d’assises des mineurs',
    explanation:
        'La cour d’assises des mineurs est composée avec des assesseurs juges des enfants.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'CJPM — Juridictions spécialisées',
    question:
        'Les fonctions du ministère public en matière de crimes, délits et contraventions de 5ᵉ classe reprochés à un mineur sont remplies par :',
    options: [
      'Un policier spécialement désigné',
      'Le procureur général ou un magistrat du ministère public spécialement chargé des affaires de mineurs',
      'Le maire',
    ],
    answer:
        'Le procureur général ou un magistrat du ministère public spécialement chargé des affaires de mineurs',
    explanation:
        'Le CJPM consacre la spécialisation du parquet pour les affaires de mineurs.',
    difficulty: 'Facile',
  ),

  // DROITS SPÉCIFIQUES
  const QuizQuestion(
    category: 'CJPM — Droits spécifiques',
    question: 'En principe, le mineur poursuivi pénalement est assisté :',
    options: [
      'D’un avocat',
      'Uniquement de ses parents',
      'Uniquement d’un éducateur PJJ',
    ],
    answer: 'D’un avocat',
    explanation:
        'L’assistance par un avocat est un principe général de la procédure applicable aux mineurs.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'CJPM — Droits spécifiques',
    question: 'La publicité des audiences concernant un mineur est :',
    options: [
      'Intégrale comme pour les majeurs',
      'Restreinte afin de protéger l’identité du mineur',
      'Obligatoirement retransmise à la télévision',
    ],
    answer: 'Restreinte afin de protéger l’identité du mineur',
    explanation:
        'L’article L. 13-3 CJPM pose le principe de la publicité restreinte et l’interdiction d’identifier le mineur.',
    difficulty: 'Facile',
  ),

  // INSTRUCTION — JUGE D’INSTRUCTION
  const QuizQuestion(
    category: 'CJPM — Instruction',
    question: 'Les crimes et délits reprochés à un mineur sont instruits par :',
    options: [
      'Un juge d’instruction spécialement chargé des affaires de mineurs',
      'N’importe quel juge d’instruction sans spécialisation',
      'Le juge administratif',
    ],
    answer: 'Un juge d’instruction spécialement chargé des affaires de mineurs',
    explanation:
        'Le CJPM prévoit un juge d’instruction désigné spécialement par le premier président de la cour d’appel.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'CJPM — Ouverture d’information',
    question:
        'En matière criminelle, pour les mineurs, l’information préalable :',
    options: ['Est obligatoire', 'Est facultative', 'N’existe pas'],
    answer: 'Est obligatoire',
    explanation:
        'L’article L. 423-3 CJPM rend l’information obligatoire en matière criminelle.',
    difficulty: 'Facile',
  ),

  // RÉTENTION ET MANDATS — GROS PRINCIPES
  const QuizQuestion(
    category: 'CJPM — Rétention (mandats)',
    question: 'Un mineur peut être placé en rétention dans le cadre :',
    options: [
      'D’un mandat d’amener ou d’arrêt, ou d’un mandat d’arrêt européen',
      'Uniquement d’une perquisition',
      'Uniquement d’une simple convocation',
    ],
    answer: 'D’un mandat d’amener ou d’arrêt, ou d’un mandat d’arrêt européen',
    explanation:
        'La rétention peut intervenir lors de l’exécution de ces mandats.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'CJPM — Rétention (droits)',
    question:
        'Lorsqu’un mineur est placé en rétention dans le cadre d’un mandat, l’enregistrement audiovisuel de ses auditions :',
    options: [
      'Est obligatoire',
      'Est interdit',
      'Est laissé à la libre appréciation de l’OPJ',
    ],
    answer: 'Est obligatoire',
    explanation:
        'Le renvoi aux articles sur la retenue/garde à vue rend obligatoire l’enregistrement audiovisuel des auditions de mineurs.',
    difficulty: 'Facile',
  ),

  // =====================================================
  // NIVEAU 2 — MOYEN
  // =====================================================

  // DISCERNEMENT — APPRÉCIATION
  const QuizQuestion(
    category: 'CJPM — Discernement (Moyen)',
    question:
        'La capacité ou l’absence de discernement d’un mineur peut être établie à partir :',
    options: [
      'Uniquement d’un examen psychiatrique',
      'Des déclarations du mineur et de son entourage, des éléments d’enquête, des circonstances des faits, des antécédents et des expertises éventuelles',
      'Uniquement de son casier judiciaire',
    ],
    answer:
        'Des déclarations du mineur et de son entourage, des éléments d’enquête, des circonstances des faits, des antécédents et des expertises éventuelles',
    explanation:
        'L’article R. 11-1 CJPM cite plusieurs sources pour apprécier le discernement.',
    difficulty: 'Moyen',
  ),

  // SPÉCIALISATION DES ACTEURS
  const QuizQuestion(
    category: 'CJPM — Juridictions spécialisées (Moyen)',
    question:
        'Parmi ces juridictions, laquelle n’intervient PAS comme juridiction spécialisée pour les mineurs ?',
    options: [
      'Le tribunal pour enfants',
      'La chambre spéciale des mineurs',
      'La cour d’assises de droit commun sans composition spéciale',
    ],
    answer: 'La cour d’assises de droit commun sans composition spéciale',
    explanation:
        'Les crimes de mineurs relèvent de la cour d’assises des mineurs, où siègent des juges des enfants comme assesseurs.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'CJPM — PJJ',
    question:
        'La mise en œuvre des décisions prises en application du CJPM est confiée principalement :',
    options: [
      'Aux services et établissements de la Protection judiciaire de la jeunesse (PJJ)',
      'Aux services municipaux',
      'À la police municipale',
    ],
    answer:
        'Aux services et établissements de la Protection judiciaire de la jeunesse (PJJ)',
    explanation:
        'La PJJ est l’acteur central de la mise en œuvre des mesures éducatives et de suivi.',
    difficulty: 'Moyen',
  ),

  // DROITS SPÉCIFIQUES — AVOCAT / INFO
  const QuizQuestion(
    category: 'CJPM — Avocat (Moyen)',
    question: 'S’agissant de l’avocat du mineur, le CJPM prévoit que :',
    options: [
      'Un avocat différent doit intervenir à chaque étape',
      'Le même avocat doit, dans la mesure du possible, suivre le mineur à chaque étape de la procédure',
      'L’avocat n’intervient qu’en audience',
    ],
    answer:
        'Le même avocat doit, dans la mesure du possible, suivre le mineur à chaque étape de la procédure',
    explanation:
        'Cette continuité permet une meilleure compréhension de la situation du mineur et une défense plus cohérente.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'CJPM — Information',
    question: 'La notification des droits au mineur doit être faite :',
    options: [
      'Dans un langage juridique complexe',
      'Dans des termes simples et accessibles',
      'Uniquement à l’avocat',
    ],
    answer: 'Dans des termes simples et accessibles',
    explanation:
        'L’article D. 12-2 CJPM impose une information adaptée au niveau de compréhension du mineur.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'CJPM — Représentants légaux',
    question: 'Le CJPM impose que les représentants légaux :',
    options: [
      'Ne reçoivent aucune information pour préserver le secret',
      'Reçoivent les mêmes informations que celles communiquées au mineur',
      'Ne soient informés qu’en cas de condamnation',
    ],
    answer:
        'Reçoivent les mêmes informations que celles communiquées au mineur',
    explanation:
        'L’article L. 12-5 CJPM consacre ce principe d’information parallèle.',
    difficulty: 'Moyen',
  ),

  // INSTRUCTION — OUVERTURE & COMPÉTENCE
  const QuizQuestion(
    category: 'CJPM — Ouverture d’information (Moyen)',
    question:
        'Pour un délit reproché à un mineur, l’ouverture d’une information :',
    options: ['Est obligatoire', 'Est facultative', 'Est interdite'],
    answer: 'Est facultative',
    explanation:
        'L’article L. 423-2 CJPM précise le caractère facultatif en matière délictuelle et contraventions de 5ᵉ classe.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'CJPM — Compétence territoriale',
    question:
        'L’information est ouverte auprès du tribunal judiciaire siège d’un tribunal pour enfants compétent notamment en fonction :',
    options: [
      'Uniquement du lieu de l’infraction',
      'Du lieu de résidence du mineur ou de ses représentants, du lieu de placement, du lieu de l’infraction ou du lieu où le mineur a été trouvé',
      'Uniquement du lieu de naissance du mineur',
    ],
    answer:
        'Du lieu de résidence du mineur ou de ses représentants, du lieu de placement, du lieu de l’infraction ou du lieu où le mineur a été trouvé',
    explanation: 'L’article L. 231-1 CJPM énumère ces critères de compétence.',
    difficulty: 'Moyen',
  ),

  // ENQUÊTE DE PERSONNALITÉ & MJIE / MEJP
  const QuizQuestion(
    category: 'CJPM — Enquête de personnalité',
    question:
        'L’enquête de personnalité ordonnée par le procureur de la République est réalisée :',
    options: [
      'Par la PJJ, qui recueille des renseignements socio-éducatifs',
      'Par la police municipale',
      'Par un expert comptable',
    ],
    answer: 'Par la PJJ, qui recueille des renseignements socio-éducatifs',
    explanation:
        'Elle vise une évaluation synthétique de la personnalité et de la situation du mineur (art. L. 322-3).',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'CJPM — MJIE',
    question:
        'Le juge d’instruction, lorsqu’il est saisi d’une affaire concernant un mineur, doit :',
    options: [
      'Toujours placer le mineur en détention',
      'Ordonner une mesure judiciaire d’investigation éducative (MJIE)',
      'Renoncer à toute mesure d’investigation',
    ],
    answer: 'Ordonner une mesure judiciaire d’investigation éducative (MJIE)',
    explanation:
        'La MJIE est obligatoire et vise une évaluation approfondie et interdisciplinaire.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'CJPM — MEJP',
    question:
        'La mesure éducative judiciaire provisoire (MEJP) peut comprendre :',
    options: [
      'Uniquement un placement',
      'Quatre modules (insertion, réparation, santé, placement) et diverses obligations et interdictions',
      'Uniquement une amende',
    ],
    answer:
        'Quatre modules (insertion, réparation, santé, placement) et diverses obligations et interdictions',
    explanation:
        'Elle peut combiner plusieurs modules et obligations prévues par l’article L. 112-2 CJPM.',
    difficulty: 'Moyen',
  ),

  // CONTRÔLE JUDICIAIRE — CONDITIONS
  const QuizQuestion(
    category: 'CJPM — Contrôle judiciaire (conditions)',
    question:
        'Un mineur de moins de 13 ans peut-il être placé sous contrôle judiciaire ?',
    options: [
      'Oui, dans tous les cas',
      'Non, jamais',
      'Oui, uniquement pour les crimes',
    ],
    answer: 'Non, jamais',
    explanation:
        'Le CJPM interdit le contrôle judiciaire pour les mineurs de moins de 13 ans.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'CJPM — Contrôle judiciaire (conditions)',
    question:
        'Un mineur de moins de 16 ans peut être placé sous contrôle judiciaire notamment s’il :',
    options: [
      'Encourt une peine criminelle ou une peine d’emprisonnement ≥ 7 ans',
      'Encourt seulement une contravention',
      'Encourt une peine d’amende uniquement',
    ],
    answer:
        'Encourt une peine criminelle ou une peine d’emprisonnement ≥ 7 ans',
    explanation:
        'Le texte détaille plusieurs hypothèses, dont l’encours criminel ou une peine ≥ 7 ans.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'CJPM — Contrôle judiciaire (16-18 ans)',
    question:
        'Un mineur d’au moins 16 ans peut être placé sous contrôle judiciaire :',
    options: [
      'Uniquement s’il encourt une peine criminelle',
      'S’il encourt une peine criminelle ou toute peine d’emprisonnement',
      'Uniquement pour les contraventions',
    ],
    answer: 'S’il encourt une peine criminelle ou toute peine d’emprisonnement',
    explanation: 'Les conditions sont plus larges pour les 16-18 ans.',
    difficulty: 'Moyen',
  ),

  // CONTRÔLE JUDICIAIRE — OBLIGATIONS & RÉTENTION
  const QuizQuestion(
    category: 'CJPM — Contrôle judiciaire (obligations)',
    question: 'Les obligations du contrôle judiciaire des mineurs sont :',
    options: [
      'Fixées au cas par cas sans texte',
      'Exhaustivement prévues par l’article L. 331-2 CJPM',
      'Fixées par la mairie',
    ],
    answer: 'Exhaustivement prévues par l’article L. 331-2 CJPM',
    explanation:
        'L’article énumère les obligations et interdictions possibles (limites territoriales, scolarité, etc.).',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'CJPM — Contrôle judiciaire (rétention)',
    question:
        'En cas de soupçon de non-respect des obligations du contrôle judiciaire, le mineur peut :',
    options: [
      'Être placé en rétention sur décision d’un OPJ',
      'Être immédiatement condamné',
      'Être interdit de scolarité',
    ],
    answer: 'Être placé en rétention sur décision d’un OPJ',
    explanation:
        'L’article L. 331-7 CJPM prévoit cette rétention, avec des droits spécifiques.',
    difficulty: 'Moyen',
  ),

  // DÉTENTION PROVISOIRE — PRINCIPES
  const QuizQuestion(
    category: 'CJPM — Détention provisoire',
    question:
        'Un mineur de moins de 13 ans peut-il être placé en détention provisoire ?',
    options: [
      'Oui, en matière criminelle',
      'Oui, en cas de récidive',
      'Non, jamais',
    ],
    answer: 'Non, jamais',
    explanation:
        'Le CJPM interdit totalement la détention provisoire pour les moins de 13 ans.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'CJPM — Détention provisoire',
    question:
        'En matière criminelle, pour un mineur de moins de 16 ans, la détention provisoire peut être prononcée pour :',
    options: [
      '6 mois renouvelable une fois',
      'Un an renouvelable deux fois',
      '15 jours non renouvelables',
    ],
    answer: '6 mois renouvelable une fois',
    explanation:
        'Le texte fixe des durées différentes selon l’âge et la nature de l’infraction.',
    difficulty: 'Moyen',
  ),

  // CLÔTURE DE L’INSTRUCTION
  const QuizQuestion(
    category: 'CJPM — Clôture de l’instruction',
    question:
        'À l’issue de l’instruction, le juge peut renvoyer devant le tribunal pour enfants :',
    options: [
      'Un mineur d’au moins 13 ans pour un délit ou une contravention de 5ᵉ classe',
      'Uniquement les majeurs',
      'Uniquement pour des contraventions des quatre premières classes',
    ],
    answer:
        'Un mineur d’au moins 13 ans pour un délit ou une contravention de 5ᵉ classe',
    explanation:
        'Le tribunal pour enfants est compétent notamment pour les délits des mineurs de 13 ans et plus.',
    difficulty: 'Moyen',
  ),

  // RÉTENTION — DROITS SPÉCIFIQUES
  const QuizQuestion(
    category: 'CJPM — Rétention (droits)',
    question:
        'En rétention, l’OPJ doit informer les représentants légaux du mineur :',
    options: [
      'Uniquement en fin de mesure',
      'Dès le début de la rétention',
      'Seulement s’il le souhaite',
    ],
    answer: 'Dès le début de la rétention',
    explanation:
        'L’avis aux représentants légaux est une diligence spécifique obligatoire.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'CJPM — Examen médical',
    question: 'Pour un mineur de moins de 16 ans placé en rétention :',
    options: [
      'L’examen médical est facultatif',
      'Un médecin est désigné d’office pour l’examiner',
      'Seul l’avocat peut demander un examen',
    ],
    answer: 'Un médecin est désigné d’office pour l’examiner',
    explanation:
        'Le procureur ou le juge d’instruction désigne un médecin dès le début de la mesure.',
    difficulty: 'Moyen',
  ),

  // ACCOMPAGNEMENT / ADULTE APPROPRIÉ
  const QuizQuestion(
    category: 'CJPM — Accompagnement',
    question:
        'En principe, le mineur a le droit d’être accompagné lors de ses auditions :',
    options: [
      'Par ses représentants légaux si cela est conforme à son intérêt et ne nuit pas à la procédure',
      'Par n’importe quel ami de son âge',
      'Par un journaliste',
    ],
    answer:
        'Par ses représentants légaux si cela est conforme à son intérêt et ne nuit pas à la procédure',
    explanation:
        'Ce droit est prévu à l’article L. 311-1 CJPM, sous réserve de certaines exceptions.',
    difficulty: 'Moyen',
  ),

  // =====================================================
  // NIVEAU 3 — DIFFICILE
  // =====================================================

  // CONTRÔLE JUDICIAIRE — RÉVOCATION
  const QuizQuestion(
    category: 'CJPM — Contrôle judiciaire (Difficile)',
    question:
        'La révocation du contrôle judiciaire d’un mineur de 16 à 18 ans n’est possible que si :',
    options: [
      'La violation des obligations est répétée ou d’une particulière gravité ET le simple rappel ou l’aggravation des obligations ne suffit pas à atteindre les objectifs de l’article 144 CPP',
      'Il y a une seule violation mineure',
      'Le juge en décide sans condition',
    ],
    answer:
        'La violation des obligations est répétée ou d’une particulière gravité ET le simple rappel ou l’aggravation des obligations ne suffit pas à atteindre les objectifs de l’article 144 CPP',
    explanation:
        'L’article L. 334-5 CJPM pose ces deux conditions cumulatives.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'CJPM — Contrôle judiciaire (modification)',
    question:
        'La modification ou la mainlevée du contrôle judiciaire d’un mineur peut être décidée :',
    options: [
      'Uniquement à la demande du procureur',
      'Par le juge des enfants ou le juge d’instruction, d’office ou à la demande du mineur, de ses représentants légaux, de la personne en ayant la garde ou du procureur',
      'Uniquement par la cour d’assises des mineurs',
    ],
    answer:
        'Par le juge des enfants ou le juge d’instruction, d’office ou à la demande du mineur, de ses représentants légaux, de la personne en ayant la garde ou du procureur',
    explanation:
        'L’article L. 331-5 détaille les différentes personnes pouvant solliciter la modification ou la mainlevée.',
    difficulty: 'Difficile',
  ),

  // ARSE MINEURS
  const QuizQuestion(
    category: 'CJPM — ARSE mineurs',
    question:
        'L’assignation à résidence sous surveillance électronique (ARSE) dans le CJPM :',
    options: [
      'Est possible pour tout mineur',
      'N’est applicable qu’au mineur de plus de 16 ans encourant une peine d’emprisonnement ≥ 3 ans',
      'Ne concerne que les contraventions',
    ],
    answer:
        'N’est applicable qu’au mineur de plus de 16 ans encourant une peine d’emprisonnement ≥ 3 ans',
    explanation:
        'L’article L. 333-1 CJPM renvoie ensuite au régime de l’ARSE des majeurs.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'CJPM — ARSE mineurs',
    question:
        'La vérification de la faisabilité technique de l’ARSE pour un mineur est confiée :',
    options: [
      'À la PJJ',
      'Aux services pénitentiaires d’insertion et de probation (SPIP)',
      'À la mairie',
    ],
    answer: 'À la PJJ',
    explanation:
        'L’article D. 333-3 CJPM confie cette mission au service de la PJJ.',
    difficulty: 'Difficile',
  ),

  // DÉTENTION PROVISOIRE — DURÉES COMPLEXES
  const QuizQuestion(
    category: 'CJPM — Détention provisoire (Difficile)',
    question:
        'En matière correctionnelle, pour un mineur de 16 à 18 ans encourant une peine d’emprisonnement supérieure à 7 ans, la détention provisoire peut être prononcée :',
    options: [
      'Pour une durée d’un mois renouvelable une fois',
      'Pour une durée de quatre mois renouvelable deux fois',
      'Uniquement 15 jours non renouvelables',
    ],
    answer: 'Pour une durée de quatre mois renouvelable deux fois',
    explanation:
        'Le CJPM prévoit cette durée maximale, pouvant aller jusqu’à deux ans en matière de terrorisme.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'CJPM — Détention provisoire (terrorisme)',
    question:
        'En matière criminelle de terrorisme, la détention provisoire d’un mineur de 16 à 18 ans peut atteindre :',
    options: ['Un an maximum', 'Deux ans maximum', 'Trois ans maximum'],
    answer: 'Trois ans maximum',
    explanation:
        'Le texte mentionne que la durée peut aller jusqu’à trois ans pour les mineurs de 16 à 18 ans en matière de terrorisme.',
    difficulty: 'Difficile',
  ),

  // CLÔTURE INSTRUCTION — ORIENTATIONS COMPLEXES
  const QuizQuestion(
    category: 'CJPM — Clôture instruction (Difficile)',
    question:
        'En cas de crime reproché à un mineur d’au moins 16 ans, le juge d’instruction :',
    options: [
      'Rend une ordonnance de renvoi devant le tribunal pour enfants',
      'Rend une ordonnance de mise en accusation devant la cour d’assises des mineurs',
      'Doit prononcer un non-lieu automatique',
    ],
    answer:
        'Rend une ordonnance de mise en accusation devant la cour d’assises des mineurs',
    explanation:
        'C’est la juridiction compétente pour juger les crimes de mineurs de 16 ans et plus.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'CJPM — Clôture instruction (connexité)',
    question:
        'La cour d’assises des mineurs peut être saisie, en raison de la connexité, de crimes commis par un mineur :',
    options: [
      'Uniquement après sa majorité',
      'Avant ses 16 ans, lorsqu’ils sont connexes à un crime reproché au même mineur après 16 ans',
      'Uniquement pour des faits commis à l’étranger',
    ],
    answer:
        'Avant ses 16 ans, lorsqu’ils sont connexes à un crime reproché au même mineur après 16 ans',
    explanation:
        'Le texte vise la connexité et l’indivisibilité avec un crime reproché au mineur âgé d’au moins 16 ans.',
    difficulty: 'Difficile',
  ),

  // RÉTENTION — AVIS, AVOCAT, MÉDECIN
  const QuizQuestion(
    category: 'CJPM — Rétention (Difficile)',
    question:
        'Lorsqu’un mineur de plus de 16 ans est placé en rétention, qui peut demander un examen médical ?',
    options: [
      'Uniquement le mineur',
      'Le mineur lui-même, ses représentants légaux, l’adulte approprié éventuellement prévenu ou son avocat',
      'Uniquement le procureur de la République',
    ],
    answer:
        'Le mineur lui-même, ses représentants légaux, l’adulte approprié éventuellement prévenu ou son avocat',
    explanation:
        'Le CJPM prévoit un large cercle de personnes pouvant solliciter l’examen médical.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'CJPM — Assistance avocat (rétention)',
    question:
        'Si le mineur ou ses représentants légaux n’ont pas désigné d’avocat pour la rétention :',
    options: [
      'La mesure se déroule sans avocat',
      'Le procureur, le juge d’instruction ou l’OPJ saisit le bâtonnier pour qu’il en soit commis un d’office dès le début de la rétention',
      'Le mineur doit se défendre seul',
    ],
    answer:
        'Le procureur, le juge d’instruction ou l’OPJ saisit le bâtonnier pour qu’il en soit commis un d’office dès le début de la rétention',
    explanation:
        'L’assistance par avocat est obligatoire ; un avocat commis d’office doit être désigné si nécessaire.',
    difficulty: 'Difficile',
  ),

  // ACCOMPAGNEMENT — ADULTE APPROPRIÉ / EXCEPTIONS
  const QuizQuestion(
    category: 'CJPM — Exceptions accompagnement',
    question:
        'Les représentants légaux peuvent être écartés de l’information et de l’accompagnement du mineur lorsque :',
    options: [
      'L’autorité le décide sans motif',
      'Cela serait contraire à l’intérêt du mineur, impossible malgré des efforts raisonnables, ou de nature à compromettre la procédure (parents impliqués, par exemple)',
      'Le mineur a plus de 14 ans',
    ],
    answer:
        'Cela serait contraire à l’intérêt du mineur, impossible malgré des efforts raisonnables, ou de nature à compromettre la procédure (parents impliqués, par exemple)',
    explanation:
        'L’article L. 311-2 et suivants encadrent strictement ces exceptions.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'CJPM — Adulte approprié',
    question: 'L’adulte approprié désigné pour accompagner le mineur :',
    options: [
      'Dispose de tous les droits des titulaires de l’autorité parentale',
      'Ne dispose pas de l’ensemble de ces droits et ne peut notamment pas choisir l’avocat du mineur',
      'Peut décider seul de la peine',
    ],
    answer:
        'Ne dispose pas de l’ensemble de ces droits et ne peut notamment pas choisir l’avocat du mineur',
    explanation:
        'Son rôle est d’accompagner et d’être informé, mais il n’a pas les prérogatives complètes d’un titulaire de l’autorité parentale.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'CJPM — Administrateur ad hoc',
    question:
        'Si aucun adulte approprié ne peut être désigné parmi les proches du mineur, le procureur, le juge des enfants ou le juge d’instruction :',
    options: [
      'Renonce à tout accompagnement',
      'Désigne un administrateur ad hoc inscrit sur une liste spécifique',
      'Confie cette fonction à un policier',
    ],
    answer: 'Désigne un administrateur ad hoc inscrit sur une liste spécifique',
    explanation:
        'Cette désignation intervient en application des textes renvoyant notamment à l’article 706-51 CPP.',
    difficulty: 'Difficile',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizDispositionsApplicablesMineursPA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName =
      '/pa/procedure_penale/quiz/dispositions_applicables_mineurs';
  final String uid;
  final String email;

  const QuizDispositionsApplicablesMineursPA({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizDispositionsApplicablesMineursPA> createState() => _QuizDispositionsApplicablesMineursPAState();
}

class _QuizDispositionsApplicablesMineursPAState extends State<QuizDispositionsApplicablesMineursPA>
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
  static const _introHiddenKey = 'intro_pa_dispositions_applicables_mineurs';
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
        ? questionsCJPM
        : questionsCJPM
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
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Procédure Pénale',
            'quiz_name': 'Dispositions applicables aux mineurs',
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
      await _sb.from('quiz_dispositions_applicables_mineurs').insert({
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
      debugPrint('❌ quiz_dispositions_applicables_mineurs insert failed: $e');
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
      'source_file': 'pa_quiz_dispositions_applicables_mineurs',
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
                            icon: Icons.child_care_rounded,
                            title: 'Dispositions pour mineurs',
                            description: 'Maîtrise les règles spécifiques aux mineurs auteurs ou victimes : ordonnance de 1945, CJPM, retenue et garde à vue des mineurs.',
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
