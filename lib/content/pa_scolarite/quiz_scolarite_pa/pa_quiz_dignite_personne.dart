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

final List<QuizQuestion> questionDignitePersonnePart1 = [
  // =========================================================
  // DISSIMULATION FORCÉE DU VISAGE — FACILE
  // =========================================================
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Fondement',
    question: 'L’infraction de dissimulation forcée du visage est prévue par :',
    options: [
      'L’article 225-4-10 du Code pénal',
      'L’article 222-14-2 du Code pénal',
      'L’article 431-1 du Code pénal',
    ],
    answer: 'L’article 225-4-10 du Code pénal',
    explanation:
        'La dissimulation forcée du visage est expressément prévue et réprimée par l’article 225-4-10 du Code pénal.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violation/profanation de sépultures — Fondement',
    question:
        'La violation ou la profanation de tombeaux, sépultures, urnes cinéraires ou monuments à la mémoire des morts est prévue par :',
    options: [
      'L’article 225-17 alinéa 2 du Code pénal',
      'L’article 225-17 alinéa 1 du Code pénal',
      'L’article 225-18-1 du Code pénal',
    ],
    answer: 'L’article 225-17 alinéa 2 du Code pénal',
    explanation:
        'Le cours indique que l’article 225-17 al.2 du C.P. prévoit et réprime la violation/profanation de ces lieux/objets.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Atteinte à l’intégrité du cadavre — Fondement',
    question: 'L’atteinte à l’intégrité du cadavre est prévue par :',
    options: [
      'L’article 225-17 alinéa 1 du Code pénal',
      'L’article 225-17 alinéa 2 du Code pénal',
      'L’article 225-13 du Code pénal',
    ],
    answer: 'L’article 225-17 alinéa 1 du Code pénal',
    explanation:
        'Le cours précise : l’article 225-17 al.1 du C.P. réprime l’atteinte à l’intégrité du cadavre.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violation/profanation — Objets protégés',
    question:
        'Parmi les éléments suivants, lequel est protégé par l’article 225-17 al.2 du C.P. ?',
    options: [
      'Une urne cinéraire',
      'Un véhicule funéraire',
      'Un simple objet personnel du défunt',
    ],
    answer: 'Une urne cinéraire',
    explanation:
        'Le cours liste explicitement : tombeaux, sépultures, urnes cinéraires, monuments édifiés à la mémoire des morts.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violation/profanation — Acte matériel',
    question: 'L’acte de violation ou de profanation suppose :',
    options: [
      'Une action physique ou une voie de fait',
      'Une simple pensée hostile',
      'Une omission involontaire',
    ],
    answer: 'Une action physique ou une voie de fait',
    explanation:
        'Le cours précise que l’acte doit être matérialisé par une action (dégradation, ouverture de caveau, inscriptions, etc.).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Atteinte au cadavre — Moment',
    question:
        'Pour caractériser l’atteinte à l’intégrité du cadavre, il est nécessaire qu’il y ait eu inhumation :',
    options: ['Non', 'Oui, toujours', 'Oui, sauf crémation'],
    answer: 'Non',
    explanation:
        'Le cours indique que l’inhumation n’est pas nécessaire : l’atteinte peut être constatée sur les lieux du décès, à la morgue, etc.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violation/profanation — Circonstance aggravante',
    question:
        'La violation/profanation (225-17 al.2) est aggravée lorsqu’elle est accompagnée :',
    options: [
      'D’une atteinte à l’intégrité du cadavre',
      'D’un simple outrage verbal',
      'D’un refus de payer une concession',
    ],
    answer: 'D’une atteinte à l’intégrité du cadavre',
    explanation:
        'Le cours précise : art. 225-17 al.3 = aggravation si atteinte à l’intégrité du cadavre.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violation/profanation — Peine (simple)',
    question:
        'La violation/profanation de tombeaux, sépultures, urnes ou monuments (225-17 al.2) est punie de :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 225-17 al.2 = 1 an et 15 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violation/profanation — Peine (aggravée)',
    question: 'La violation/profanation aggravée (225-17 al.3) est punie de :',
    options: [
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 30 000 € d’amende',
    explanation:
        'Le cours indique : 225-17 al.3 (avec atteinte à l’intégrité du cadavre) = 2 ans et 30 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteinte au cadavre — Peine',
    question:
        'L’atteinte à l’intégrité du cadavre (225-17 al.1) est punie de :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '7 ans d’emprisonnement et 200 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 225-17 al.1 = 1 an et 15 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violation/profanation — Responsabilité des personnes morales',
    question:
        'La responsabilité des personnes morales pour ces infractions est prévue par :',
    options: [
      'L’article 225-18-1 du Code pénal',
      'L’article 225-18 du Code pénal',
      'L’article 225-17 du Code pénal',
    ],
    answer: 'L’article 225-18-1 du Code pénal',
    explanation:
        'Le cours précise que la responsabilité des personnes morales est prévue expressément par l’article 225-18-1 du C.P.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteinte au cadavre — Fait justificatif',
    question:
        'Le cours précise que l’infraction ne peut pas être retenue contre un médecin pratiquant une autopsie car :',
    options: [
      'L’acte est prescrit ou autorisé par la loi (article 122-4 du C.P.)',
      'Le mobile médical excuse toujours',
      'La victime est décédée donc aucune infraction',
    ],
    answer:
        'L’acte est prescrit ou autorisé par la loi (article 122-4 du C.P.)',
    explanation:
        'Le cours cite l’article 122-4 du C.P. : n’est pas pénalement responsable la personne accomplissant un acte prescrit/autorisé.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte au cadavre — Actes concernés',
    question:
        'Parmi les exemples suivants, lequel peut constituer une atteinte à l’intégrité du cadavre selon le cours ?',
    options: [
      'Dépeçage ou coups entraînant une lésion sur le corps',
      'Poser des fleurs sur une tombe',
      'Assister à des obsèques',
    ],
    answer: 'Dépeçage ou coups entraînant une lésion sur le corps',
    explanation:
        'Le cours cite : dépeçage, coups de feu/couteau/bâton, morsures, exhumation illicite, prélèvements hors cadre légal, etc.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violation/profanation — Tombeau',
    question: 'Selon le cours, un “tombeau” est :',
    options: [
      'Un monument élevé sur les restes d’un mort',
      'Uniquement une plaque commémorative',
      'Uniquement un cercueil avant inhumation',
    ],
    answer: 'Un monument élevé sur les restes d’un mort',
    explanation:
        'Le cours définit le tombeau comme un monument élevé sur les restes d’un mort.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violation/profanation — Sépulture',
    question: 'Selon le cours, la “sépulture” peut désigner :',
    options: [
      'Le lieu d’inhumation et aussi le cercueil/drap mortuaire avant inhumation',
      'Uniquement un caveau familial',
      'Uniquement une urne cinéraire',
    ],
    answer:
        'Le lieu d’inhumation et aussi le cercueil/drap mortuaire avant inhumation',
    explanation:
        'Le cours précise : la sépulture = lieu où le défunt est enterré, mais aussi drap mortuaire ou cercueil avant l’inhumation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violation/profanation — Monuments à la mémoire des morts',
    question:
        'Selon le cours, un monument édifié à la mémoire des morts peut être :',
    options: [
      'Une plaque commémorative ou un monument collectif sans sépulture',
      'Un simple objet de décoration',
      'Uniquement une tombe individuelle',
    ],
    answer: 'Une plaque commémorative ou un monument collectif sans sépulture',
    explanation:
        'Le cours cite : monuments collectifs en mémoire des morts, plaques commémoratives, lieux où un soldat/résistant a été tué, etc.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violation/profanation — Élément moral',
    question:
        'L’élément moral de la violation/profanation repose principalement sur :',
    options: [
      'La conscience d’accomplir un acte portant atteinte au respect dû aux morts',
      'L’intention de voler obligatoirement',
      'La nécessité d’un mobile religieux',
    ],
    answer:
        'La conscience d’accomplir un acte portant atteinte au respect dû aux morts',
    explanation:
        'Le cours précise : l’auteur agit en connaissance de cause ; le mobile est indifférent.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte au cadavre — Élément moral',
    question:
        'Pour l’atteinte à l’intégrité du cadavre, le mobile (raison) de l’auteur :',
    options: [
      'Importe peu',
      'Doit être obligatoirement lucratif',
      'Doit être une vengeance',
    ],
    answer: 'Importe peu',
    explanation:
        'Le cours précise : l’auteur a conscience de porter atteinte au respect dû aux morts ; le mobile importe peu.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violation/profanation — Tentative',
    question: 'La tentative de violation/profanation de sépultures est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable uniquement si bande organisée',
    ],
    answer: 'Non punissable',
    explanation:
        'Le cours indique : TENTATIVE : NON pour l’infraction de 225-17 (violation/profanation).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteinte au cadavre — Tentative',
    question: 'La tentative d’atteinte à l’intégrité du cadavre est :',
    options: ['Non punissable', 'Punissable', 'Toujours un crime'],
    answer: 'Non punissable',
    explanation:
        'Le cours mentionne : TENTATIVE : NON pour l’atteinte à l’intégrité du cadavre.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Fondement',
    question:
        'L’infraction de dissimulation forcée du visage (imposée en raison du sexe) est prévue par :',
    options: [
      'L’article 225-4-10 du Code pénal',
      'L’article 225-13 du Code pénal',
      'L’article 225-14 du Code pénal',
    ],
    answer: 'L’article 225-4-10 du Code pénal',
    explanation:
        'Le cours indique : l’infraction est prévue et réprimée à l’article 225-4-10 du C.P.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Moyens',
    question:
        'Quels moyens peuvent caractériser la dissimulation forcée du visage selon l’article 225-4-10 ?',
    options: [
      'Menace, violence, contrainte, abus d’autorité ou abus de pouvoir',
      'Uniquement la violence physique',
      'Uniquement la menace d’une arme',
    ],
    answer: 'Menace, violence, contrainte, abus d’autorité ou abus de pouvoir',
    explanation:
        'Le cours liste 5 moyens : menace, violence, contrainte, abus d’autorité, abus de pouvoir.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Condition',
    question:
        'Pour que l’infraction de dissimulation forcée du visage soit constituée, la dissimulation doit être imposée :',
    options: [
      'En raison du sexe de la victime',
      'Uniquement dans un espace public',
      'Uniquement par un conjoint',
    ],
    answer: 'En raison du sexe de la victime',
    explanation:
        'Le cours précise : la dissimulation doit être imposée sur le fondement du sexe de la victime.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Élément moral',
    question:
        'L’élément moral de la dissimulation forcée du visage repose sur :',
    options: [
      'La conscience d’exercer une pression et la volonté d’imposer la dissimulation',
      'La seule négligence',
      'Le seul mobile religieux',
    ],
    answer:
        'La conscience d’exercer une pression et la volonté d’imposer la dissimulation',
    explanation:
        'Le cours mentionne : conscience d’exercer une pression + volonté d’imposer à autrui de dissimuler son visage.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Menace',
    question: 'Dans le cadre de 225-4-10, la menace se définit comme :',
    options: [
      'Un acte d’intimidation inspirant la crainte d’un mal',
      'Un acte de violence nécessitant toujours un contact physique',
      'Un simple désaccord verbal sans intimidation',
    ],
    answer: 'Un acte d’intimidation inspirant la crainte d’un mal',
    explanation:
        'Le cours précise : menace = acte d’intimidation inspirant la crainte d’un mal (atteinte à l’intégrité morale).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Violence',
    question:
        'Selon le cours, la violence au sens de 225-4-10 peut être retenue :',
    options: [
      'Même sans contact physique si le comportement provoque un choc émotif',
      'Uniquement en cas de coups ou blessures',
      'Uniquement si une arme est utilisée',
    ],
    answer:
        'Même sans contact physique si le comportement provoque un choc émotif',
    explanation:
        'Le cours indique que la violence peut exister sans contact physique si elle impressionne fortement la victime (choc émotif).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Contrainte',
    question: 'Selon le cours, la contrainte doit être appréciée :',
    options: [
      'En fonction de la capacité de résistance de la victime',
      'Uniquement selon l’âge de la victime',
      'Uniquement selon la taille de l’auteur',
    ],
    answer: 'En fonction de la capacité de résistance de la victime',
    explanation:
        'Le cours précise : la contrainte s’apprécie concrètement selon la capacité de résistance de la victime (référence jurisprudentielle).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Abus d’autorité/pouvoir',
    question: 'L’abus d’autorité ou de pouvoir peut résulter :',
    options: [
      'D’une autorité légale, d’une autorité d’employeur ou d’une autorité de fait',
      'Uniquement d’une autorité policière',
      'Uniquement d’un mandat électif',
    ],
    answer:
        'D’une autorité légale, d’une autorité d’employeur ou d’une autorité de fait',
    explanation:
        'Le cours précise : autorité = légale (ex : parentale), employeur, ou autorité de fait (ascendant).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Fait justificatif (contrainte)',
    question:
        'La victime contrainte à dissimuler son visage peut invoquer une exonération sur le fondement de :',
    options: [
      'L’article 122-2 du Code pénal',
      'L’article 121-7 du Code pénal',
      'L’article 225-4-10 du Code pénal',
    ],
    answer: 'L’article 122-2 du Code pénal',
    explanation:
        'Le cours rappelle l’article 122-2 : pas responsable la personne ayant agi sous une force/contrainte irrésistible.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Aggravation',
    question:
        'La dissimulation forcée du visage est aggravée lorsque les faits sont commis :',
    options: ['Au préjudice d’un mineur', 'Dans un lieu public', 'La nuit'],
    answer: 'Au préjudice d’un mineur',
    explanation:
        'Le cours indique : art. 225-4-10 al.2 = aggravation lorsque la victime est mineure.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Peines (simple)',
    question:
        'Les peines encourues pour la dissimulation forcée du visage (simple) sont :',
    options: [
      '1 an d’emprisonnement et 30 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 30 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 225-4-10 al.1 = 1 an et 30 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Peines (aggravée)',
    question:
        'Les peines encourues pour la dissimulation forcée du visage aggravée (victime mineure) sont :',
    options: [
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 30 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 60 000 € d’amende',
    explanation: 'Le cours précise : 225-4-10 al.2 = 2 ans et 60 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Tentative',
    question: 'La tentative de dissimulation forcée du visage est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable uniquement si la victime est mineure',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Complicité',
    question: 'La complicité de dissimulation forcée du visage est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable seulement en cas de violence physique',
    ],
    answer: 'Punissable',
    explanation:
        'Le cours indique : COMPLICITÉ : OUI (articles 121-6 et 121-7 du C.P.).',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — Fondement',
    question:
        'La rétribution inexistante ou insuffisante du travail d’une personne vulnérable ou dépendante est prévue par :',
    options: [
      'L’article 225-13 du Code pénal',
      'L’article 225-14 du Code pénal',
      'L’article 225-15-1 du Code pénal',
    ],
    answer: 'L’article 225-13 du Code pénal',
    explanation:
        'Le cours précise : l’article 225-13 du C.P. définit et réprime la rétribution inexistante/insuffisante.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — Nature des faits',
    question: 'L’article 225-13 vise principalement :',
    options: [
      'L’obtention de la fourniture de services non rétribués ou très sous-rétribués',
      'La remise d’un bien ou d’une somme d’argent par fraude',
      'Le non-paiement des heures supplémentaires uniquement',
    ],
    answer:
        'L’obtention de la fourniture de services non rétribués ou très sous-rétribués',
    explanation:
        'Le cours indique : il s’agit d’obtenir des services ; la remise de biens/sommes relève plutôt de l’abus frauduleux (223-15-2).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — “Services” au pluriel',
    question: 'Selon le cours, l’article 225-13 exige :',
    options: [
      'Une fourniture de services au pluriel, pas une prestation isolée',
      'Une seule prestation suffit toujours',
      'Uniquement un contrat de travail écrit',
    ],
    answer: 'Une fourniture de services au pluriel, pas une prestation isolée',
    explanation:
        'Le cours précise : la loi exige une fourniture de services au pluriel, et non une simple prestation isolée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — Absence totale',
    question: 'L’absence totale de rémunération au sens de 225-13 s’entend :',
    options: [
      'Strictement : aucune contrepartie, même en nature',
      'Comme l’absence de salaire mais le logement/nourriture comptent',
      'Comme le seul non-respect du SMIC',
    ],
    answer: 'Strictement : aucune contrepartie, même en nature',
    explanation:
        'Le cours précise : absence totale = aucune contrepartie, y compris en nature (logement, nourriture, etc.).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — Insuffisance',
    question: 'Pour entrer dans le champ de 225-13, il faut établir :',
    options: [
      'Une disproportion manifeste entre rémunération et travail accompli',
      'Un simple non-paiement d’heures supplémentaires',
      'Un retard de paiement de quelques jours',
    ],
    answer:
        'Une disproportion manifeste entre rémunération et travail accompli',
    explanation:
        'Le cours indique : le non-respect du SMIC ou des heures supp. ne suffit pas ; il faut une disproportion manifeste.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — Victime',
    question:
        'Pour 225-13, la vulnérabilité ou la dépendance de la victime doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Forcément médicalement constatée',
      'Uniquement liée à l’âge',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation:
        'Le cours insiste : la vulnérabilité/dépendance doit être apparente ou connue de l’auteur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Rémunération inexistante/insuffisante — Vulnérabilité (exemples)',
    question: 'Selon le cours, une vulnérabilité peut être liée notamment :',
    options: [
      'À l’état physique/mental ou à l’environnement économique/social/culturel',
      'Uniquement à une maladie grave',
      'Uniquement à la minorité',
    ],
    answer:
        'À l’état physique/mental ou à l’environnement économique/social/culturel',
    explanation:
        'Le cours cite : grossesse, âge, maladie, handicap… mais aussi environnement économique/social/culturel (immigrés, chômeurs, sans-abri…).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — Dépendance',
    question: 'La dépendance au sens du cours peut être :',
    options: [
      'Économique ou morale',
      'Uniquement économique',
      'Uniquement liée à un contrat de travail',
    ],
    answer: 'Économique ou morale',
    explanation:
        'Le cours précise : dépendance économique (précarité) ou morale (domination : maître/domestique, parents/enfants, etc.).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — Élément moral',
    question: 'L’élément moral de 225-13 suppose notamment :',
    options: [
      'Conscience de la vulnérabilité/dépendance + conscience d’exiger des services non/insuffisamment rétribués',
      'Une simple imprudence',
      'Un profit obligatoire en numéraire',
    ],
    answer:
        'Conscience de la vulnérabilité/dépendance + conscience d’exiger des services non/insuffisamment rétribués',
    explanation:
        'Le cours mentionne la double conscience : état de la victime + exploitation de cet état pour obtenir les services.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — 1er degré aggravation',
    question:
        'Parmi les propositions suivantes, laquelle correspond à un premier degré d’aggravation prévu par le cours ?',
    options: [
      'Faits commis à l’égard de plusieurs personnes',
      'Faits commis de nuit',
      'Faits commis sur un lieu public',
    ],
    answer: 'Faits commis à l’égard de plusieurs personnes',
    explanation:
        'Le cours indique : art. 225-15 I 1° = à l’égard de plusieurs personnes (1er degré).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — Aggravation mineur',
    question: 'L’aggravation liée au mineur est prévue par :',
    options: [
      'L’article 225-15 II 1° du Code pénal',
      'L’article 225-15 I 1° du Code pénal',
      'L’article 225-15 III 1° du Code pénal',
    ],
    answer: 'L’article 225-15 II 1° du Code pénal',
    explanation:
        'Le cours précise : 225-15 II 1° = lorsqu’elle est commise à l’égard d’un mineur (1er degré).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — 2nd degré aggravation',
    question: 'Le second degré d’aggravation (225-15 III 1°) vise :',
    options: [
      'Plusieurs personnes parmi lesquelles figurent un ou plusieurs mineurs',
      'Une seule victime majeure',
      'Uniquement la récidive',
    ],
    answer:
        'Plusieurs personnes parmi lesquelles figurent un ou plusieurs mineurs',
    explanation:
        'Le cours indique : 225-15 III 1° = plusieurs personnes dont un ou plusieurs mineurs (2nd degré).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — Peines (simple)',
    question: 'Les peines encourues pour 225-13 (simple) sont :',
    options: [
      '5 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans d’emprisonnement et 200 000 € d’amende',
      '10 ans d’emprisonnement et 300 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 150 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 225-13 al.1 = 5 ans et 150 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Rémunération inexistante/insuffisante — Peines (aggravée 1er degré)',
    question: 'Les peines encourues pour 225-13 aggravée (1er degré) sont :',
    options: [
      '7 ans d’emprisonnement et 200 000 € d’amende',
      '5 ans d’emprisonnement et 150 000 € d’amende',
      '10 ans d’emprisonnement et 300 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 200 000 € d’amende',
    explanation:
        'Le cours indique : aggravation 1er degré = 7 ans et 200 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Rémunération inexistante/insuffisante — Peines (aggravée 2nd degré)',
    question: 'Les peines encourues pour 225-13 aggravée (2nd degré) sont :',
    options: [
      '10 ans d’emprisonnement et 300 000 € d’amende',
      '7 ans d’emprisonnement et 200 000 € d’amende',
      '15 ans de réclusion criminelle et 400 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 300 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 2nd degré (225-15 III 1°) = 10 ans et 300 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — Tentative',
    question: 'La tentative de l’infraction 225-13 est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable uniquement si mineur',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours précise : TENTATIVE : NON pour 225-13.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — Personnes morales',
    question:
        'La responsabilité des personnes morales pour 225-13 est prévue par :',
    options: [
      'L’article 225-16 du Code pénal',
      'L’article 121-2 du Code pénal uniquement',
      'L’article 225-15-1 du Code pénal',
    ],
    answer: 'L’article 225-16 du Code pénal',
    explanation:
        'Le cours indique : responsabilité des personnes morales prévue expressément par 225-16 du C.P.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soumission à des conditions indignes — Fondement',
    question:
        'La soumission d’une personne vulnérable ou dépendante à des conditions de travail ou d’hébergement incompatibles avec la dignité humaine est prévue par :',
    options: [
      'L’article 225-14 du Code pénal',
      'L’article 225-13 du Code pénal',
      'L’article 225-17 du Code pénal',
    ],
    answer: 'L’article 225-14 du Code pénal',
    explanation:
        'Le cours précise : l’article 225-14 du C.P. définit et réprime cette infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soumission à des conditions indignes — Notion de dignité',
    question:
        'La notion de dignité humaine, utilisée à l’article 225-14, est :',
    options: [
      'Appréciée souverainement par les juges du fond',
      'Définie précisément par le Code pénal',
      'Limitée aux atteintes physiques',
    ],
    answer: 'Appréciée souverainement par les juges du fond',
    explanation:
        'Le cours indique que le Code pénal ne définit pas la dignité humaine : il appartient aux juges d’en fixer les contours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soumission à des conditions indignes — Travail',
    question: 'Contrairement à l’article 225-13, l’article 225-14 :',
    options: [
      'N’exige pas l’absence ou l’insuffisance de rémunération',
      'Exige une absence totale de rémunération',
      'Ne concerne pas le travail',
    ],
    answer: 'N’exige pas l’absence ou l’insuffisance de rémunération',
    explanation:
        'Le cours précise : 225-14 suppose un travail, mais pas nécessairement une rémunération inexistante ou insuffisante.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soumission à des conditions indignes — Exemples',
    question:
        'Peuvent caractériser des conditions de travail incompatibles avec la dignité humaine :',
    options: [
      'Cadences intolérables, durée excessive, insultes et brimades',
      'Un simple désaccord hiérarchique',
      'Un retard ponctuel de salaire',
    ],
    answer: 'Cadences intolérables, durée excessive, insultes et brimades',
    explanation:
        'Le cours cite notamment l’insalubrité, les cadences intolérables et les violences morales.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soumission à des conditions indignes — Hébergement',
    question: 'Pour être retenu au titre de 225-14, l’hébergement doit :',
    options: [
      'Faire l’objet d’une contrepartie et se prolonger dans le temps',
      'Être gratuit et ponctuel',
      'Concerner uniquement un logement collectif',
    ],
    answer: 'Faire l’objet d’une contrepartie et se prolonger dans le temps',
    explanation:
        'Le cours précise : contrepartie + hébergement destiné à fournir un logement pour y vivre.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soumission à des conditions indignes — Victime',
    question:
        'La vulnérabilité ou la dépendance exigée par l’article 225-14 doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Constatée par expertise médicale',
      'Uniquement économique',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation:
        'Comme pour 225-13, le cours insiste sur le caractère apparent ou connu.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soumission à des conditions indignes — Élément moral',
    question: 'L’élément moral de 225-14 suppose notamment :',
    options: [
      'La conscience de la vulnérabilité et de l’indignité des conditions imposées',
      'Une simple imprudence',
      'Un profit financier obligatoire',
    ],
    answer:
        'La conscience de la vulnérabilité et de l’indignité des conditions imposées',
    explanation: 'Le cours précise la double conscience exigée chez l’auteur.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soumission à des conditions indignes — Peines (simple)',
    question: 'Les peines encourues pour 225-14 (simple) sont :',
    options: [
      '7 ans d’emprisonnement et 200 000 € d’amende',
      '5 ans d’emprisonnement et 150 000 € d’amende',
      '10 ans d’emprisonnement et 300 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 200 000 € d’amende',
    explanation: 'Le tableau du cours indique : 225-14 = 7 ans et 200 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soumission à des conditions indignes — Aggravation mineur',
    question:
        'Lorsque les faits sont commis à l’égard d’un mineur, la qualification devient :',
    options: [
      'Délit aggravé (1er degré)',
      'Crime automatiquement',
      'Simple contravention',
    ],
    answer: 'Délit aggravé (1er degré)',
    explanation:
        'Le cours indique : art. 225-15 I 2° et II 2° = aggravation liée au mineur.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soumission à des conditions indignes — Crime',
    question:
        'La soumission à des conditions indignes devient un crime lorsque :',
    options: [
      'Elle concerne plusieurs personnes parmi lesquelles figurent des mineurs',
      'Elle est commise de nuit',
      'Elle est commise par un employeur',
    ],
    answer:
        'Elle concerne plusieurs personnes parmi lesquelles figurent des mineurs',
    explanation:
        'Le cours précise : 225-15 III 2° = crime (15 ans de réclusion).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Atteinte à l’intégrité du cadavre — Fondement',
    question: 'L’atteinte à l’intégrité du cadavre est prévue par :',
    options: [
      'L’article 225-17 alinéa 1 du Code pénal',
      'L’article 225-18 du Code pénal',
      'L’article 222-14 du Code pénal',
    ],
    answer: 'L’article 225-17 alinéa 1 du Code pénal',
    explanation:
        'Le cours indique : 225-17 al.1 réprime l’atteinte à l’intégrité du cadavre.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Atteinte à l’intégrité du cadavre — Objet',
    question: 'L’infraction d’atteinte à l’intégrité du cadavre protège :',
    options: [
      'La dépouille mortelle humaine, même avant inhumation',
      'Uniquement les corps inhumés',
      'Uniquement les restes incinérés',
    ],
    answer: 'La dépouille mortelle humaine, même avant inhumation',
    explanation:
        'Le cours précise : l’infraction peut être réalisée indépendamment de l’inhumation.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Atteinte à l’intégrité du cadavre — Exemples',
    question: 'Peuvent constituer une atteinte à l’intégrité du cadavre :',
    options: [
      'Dépeçage, prélèvements illégaux, nécrophilie',
      'Une autopsie judiciaire',
      'Une exhumation légale',
    ],
    answer: 'Dépeçage, prélèvements illégaux, nécrophilie',
    explanation:
        'Le cours liste de nombreux exemples, hors actes légalement autorisés.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Atteinte à l’intégrité du cadavre — Élément moral',
    question:
        'L’élément moral de l’atteinte à l’intégrité du cadavre repose sur :',
    options: [
      'La conscience de porter atteinte au respect dû aux morts',
      'Un mobile religieux',
      'Une intention de profit',
    ],
    answer: 'La conscience de porter atteinte au respect dû aux morts',
    explanation:
        'Le cours précise : le mobile importe peu, seule compte la conscience de l’atteinte.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteinte à l’intégrité du cadavre — Peines',
    question:
        'Les peines encourues pour atteinte à l’intégrité du cadavre sont :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le cours indique : 225-17 al.1 = 1 an et 15 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Violation ou profanation de sépulture — Fondement',
    question:
        'La violation ou la profanation de tombeaux, sépultures ou urnes cinéraires est prévue par :',
    options: [
      'L’article 225-17 alinéa 2 du Code pénal',
      'L’article 225-17 alinéa 1 du Code pénal',
      'L’article 225-18 du Code pénal',
    ],
    answer: 'L’article 225-17 alinéa 2 du Code pénal',
    explanation:
        'Le cours précise : 225-17 al.2 vise la violation ou la profanation.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violation ou profanation — Actes',
    question: 'Constituent des actes de violation ou de profanation :',
    options: [
      'Dégradations, inscriptions, ouverture de caveau',
      'Une visite familiale au cimetière',
      'Une exhumation légale',
    ],
    answer: 'Dégradations, inscriptions, ouverture de caveau',
    explanation:
        'Le cours cite : bris de pierre tombale, inscriptions, retrait de cercueil, etc.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violation ou profanation — Aggravation',
    question: 'La violation ou profanation est aggravée lorsque :',
    options: [
      'Elle est accompagnée d’une atteinte à l’intégrité du cadavre',
      'Elle est commise de nuit',
      'Elle est commise en réunion',
    ],
    answer: 'Elle est accompagnée d’une atteinte à l’intégrité du cadavre',
    explanation:
        'Le cours indique : art. 225-17 al.3 = circonstance aggravante.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Traite — Fondement',
    question:
        'L’infraction de traite des êtres humains est définie et réprimée par :',
    options: [
      'L’article 225-4-1 du Code pénal',
      'L’article 225-5 du Code pénal',
      'L’article 225-14 du Code pénal',
    ],
    answer: 'L’article 225-4-1 du Code pénal',
    explanation:
        'Le cours précise que l’article 225-4-1 C.P. définit la traite des êtres humains.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Traite — Actes matériels',
    question:
        'Parmi les actes suivants, lequel peut constituer un acte matériel de traite ?',
    options: [
      'Recruter, transporter, transférer, héberger ou accueillir',
      'Menacer uniquement',
      'Héberger sans objectif particulier',
    ],
    answer: 'Recruter, transporter, transférer, héberger ou accueillir',
    explanation:
        'Le texte vise expressément ces actes positifs à l’encontre de la victime.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Traite — Mise à disposition',
    question: 'La traite des êtres humains est constituée même si :',
    options: [
      'La victime n’a pas été effectivement exploitée',
      'La victime a finalement refusé',
      'L’auteur n’a tiré aucun avantage',
    ],
    answer: 'La victime n’a pas été effectivement exploitée',
    explanation:
        'Il suffit que la mise à disposition soit poursuivie dans un objectif criminel.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Traite — Mineur',
    question:
        'Concernant un mineur, la traite des êtres humains est constituée :',
    options: [
      'Même sans les circonstances des 1° à 4°',
      'Uniquement en cas de violence',
      'Seulement avec rémunération',
    ],
    answer: 'Même sans les circonstances des 1° à 4°',
    explanation:
        'Le cours précise : pour un mineur, aucune circonstance de commission n’est exigée.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Traite — Consentement',
    question: 'Le consentement de la victime en matière de traite :',
    options: [
      'Est juridiquement indifférent',
      'Exclut l’infraction',
      'Atténue automatiquement la peine',
    ],
    answer: 'Est juridiquement indifférent',
    explanation:
        'La traite ne repose pas sur la notion de consentement de la victime.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Traite — Objectif criminel',
    question:
        'L’un des objectifs criminels expressément visés par la traite est :',
    options: [
      'La réduction en esclavage',
      'Le simple travail dissimulé',
      'La contravention',
    ],
    answer: 'La réduction en esclavage',
    explanation:
        'Le texte énumère limitativement les infractions constituant l’exploitation.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Traite — Bande organisée',
    question: 'La traite commise en bande organisée entraîne :',
    options: [
      'La réclusion criminelle à perpétuité',
      '10 ans d’emprisonnement',
      '7 ans d’emprisonnement',
    ],
    answer: 'La réclusion criminelle à perpétuité',
    explanation:
        'L’article 225-4-3 prévoit la réclusion criminelle à perpétuité.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Traite — Tentative',
    question: 'La tentative de traite des êtres humains est :',
    options: ['Punissable', 'Non punissable', 'Une contravention'],
    answer: 'Punissable',
    explanation: 'L’article 225-4-7 prévoit expressément la tentative.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Traite — Exemption de peine',
    question: 'L’exemption de peine en matière de traite suppose que :',
    options: [
      'L’auteur avertisse l’autorité avant la réalisation',
      'L’auteur indemnise la victime',
      'L’auteur soit mineur',
    ],
    answer: 'L’auteur avertisse l’autorité avant la réalisation',
    explanation:
        'L’article 225-4-9 al.1 vise l’intervention au stade de la tentative.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Proxénétisme — Définition',
    question: 'Le proxénétisme consiste notamment à :',
    options: [
      'Aider ou tirer profit de la prostitution d’autrui',
      'Se livrer soi-même à la prostitution',
      'Refuser une relation sexuelle',
    ],
    answer: 'Aider ou tirer profit de la prostitution d’autrui',
    explanation:
        'Le droit français n’incrimine pas la prostitution mais le proxénétisme.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Proxénétisme — Aide',
    question: 'L’aide à la prostitution d’autrui suppose :',
    options: [
      'Un acte positif',
      'Une simple tolérance',
      'Une intention lucrative obligatoire',
    ],
    answer: 'Un acte positif',
    explanation: 'La jurisprudence exclut la simple abstention ou tolérance.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Proxénétisme — Profit',
    question: 'Partager les produits de la prostitution signifie :',
    options: [
      'Bénéficier d’avantages issus de la prostitution',
      'Vivre avec une personne prostituée',
      'Être client régulier',
    ],
    answer: 'Bénéficier d’avantages issus de la prostitution',
    explanation:
        'Le partage peut prendre des formes diverses : argent, biens, prestations.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Proxénétisme — Incitation',
    question: 'L’incitation à la prostitution est constituée même si :',
    options: [
      'La personne ne s’est pas prostituée',
      'Il n’y a aucun profit',
      'La victime a refusé',
    ],
    answer: 'La personne ne s’est pas prostituée',
    explanation: 'L’infraction est consommée dès l’acte d’incitation.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Proxénétisme — Aggravation',
    question: 'Le proxénétisme est aggravé lorsqu’il est commis :',
    options: [
      'À l’égard d’un mineur',
      'À l’égard d’un client',
      'Sans rémunération',
    ],
    answer: 'À l’égard d’un mineur',
    explanation: 'Le mineur constitue une circonstance aggravante majeure.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Proxénétisme — Bande organisée',
    question: 'Le proxénétisme commis en bande organisée est puni de :',
    options: [
      '20 ans de réclusion criminelle',
      '10 ans d’emprisonnement',
      '15 ans de réclusion',
    ],
    answer: '20 ans de réclusion criminelle',
    explanation: 'L’article 225-8 prévoit cette qualification criminelle.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Discrimination — Fondement',
    question: 'La définition générale de la discrimination figure à :',
    options: [
      'L’article 225-1 du Code pénal',
      'L’article 225-2 du Code pénal',
      'L’article 432-7 du Code pénal',
    ],
    answer: 'L’article 225-1 du Code pénal',
    explanation: 'L’article 225-1 définit les critères discriminatoires.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Discrimination — Situations incriminées',
    question: 'Parmi les situations suivantes, laquelle est visée par 225-2 ?',
    options: [
      'Refuser l’embauche pour un motif discriminatoire',
      'Exprimer une opinion personnelle',
      'Tenir des propos privés',
    ],
    answer: 'Refuser l’embauche pour un motif discriminatoire',
    explanation:
        'L’article 225-2 liste limitativement les situations incriminées.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Discrimination — Élément moral',
    question: 'L’élément moral du délit de discrimination suppose :',
    options: [
      'La conscience de l’agissement discriminatoire',
      'Une intention haineuse',
      'Un préjudice effectif',
    ],
    answer: 'La conscience de l’agissement discriminatoire',
    explanation:
        'Peu importe l’hostilité personnelle, seule compte la conscience.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Discrimination — Test',
    question: 'Les tests de discrimination sont :',
    options: [
      'Admis par la jurisprudence',
      'Interdits',
      'Réservés aux autorités judiciaires',
    ],
    answer: 'Admis par la jurisprudence',
    explanation: 'L’article 225-3-1 et la jurisprudence admettent ces tests.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Discrimination — Critères',
    question:
        'Parmi les critères suivants, lequel est expressément visé par l’article 225-1 du Code pénal ?',
    options: [
      'L’orientation sexuelle',
      'Le niveau de diplôme',
      'La situation matrimoniale',
    ],
    answer: 'L’orientation sexuelle',
    explanation:
        'L’article 225-1 énumère limitativement les critères prohibés, dont l’orientation sexuelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Discrimination — Liste des critères',
    question:
        'La liste des critères de discrimination prévue à l’article 225-1 est :',
    options: ['Limitative', 'Indicative', 'Fixée par décret'],
    answer: 'Limitative',
    explanation:
        'Seuls les critères expressément mentionnés par la loi peuvent être retenus.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Discrimination — Distinction licite',
    question:
        'Une différence de traitement n’est pas constitutive de discrimination lorsqu’elle :',
    options: [
      'Repose sur une exigence professionnelle essentielle et déterminante',
      'Est perçue comme injuste',
      'Crée un déséquilibre économique',
    ],
    answer:
        'Repose sur une exigence professionnelle essentielle et déterminante',
    explanation: 'L’article 225-3 prévoit des cas de justification objective.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Discrimination — Refus de bien ou service',
    question:
        'Refuser l’accès à un bien ou à un service pour un motif discriminatoire constitue :',
    options: ['Un délit', 'Une contravention', 'Un simple manquement civil'],
    answer: 'Un délit',
    explanation:
        'Le refus discriminatoire est expressément incriminé par l’article 225-2.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Discrimination — Personne morale',
    question:
        'Les personnes morales peuvent être pénalement responsables du délit de discrimination :',
    options: ['Oui', 'Non', 'Uniquement en cas de récidive'],
    answer: 'Oui',
    explanation:
        'La responsabilité pénale des personnes morales est prévue par l’article 225-4.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Discrimination — Tentative',
    question: 'La tentative de discrimination est :',
    options: ['Punissable', 'Non punissable', 'Une contravention'],
    answer: 'Punissable',
    explanation: 'L’article 225-3-1 prévoit expressément la tentative.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Discrimination — Test situationnel',
    question: 'Le test de discrimination permet principalement de :',
    options: [
      'Établir l’élément matériel de l’infraction',
      'Remplacer l’enquête judiciaire',
      'Exonérer automatiquement l’auteur',
    ],
    answer: 'Établir l’élément matériel de l’infraction',
    explanation:
        'Le test vise à démontrer objectivement une différence de traitement.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Fondement',
    question: 'L’infraction de harcèlement sexuel est prévue par :',
    options: [
      'L’article 222-33-2-2 du Code pénal',
      'L’article 222-16 du Code pénal',
      'L’article 225-16 du Code pénal',
    ],
    answer: 'L’article 222-33-2-2 du Code pénal',
    explanation:
        'Le harcèlement sexuel est spécifiquement réprimé par l’article 222-33-2-2.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Harcèlement sexuel — Formes',
    question: 'Le harcèlement sexuel peut résulter :',
    options: [
      'De propos ou comportements à connotation sexuelle',
      'Uniquement d’un contact physique',
      'Uniquement d’un abus d’autorité',
    ],
    answer: 'De propos ou comportements à connotation sexuelle',
    explanation: 'Le texte vise aussi bien les propos que les comportements.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Harcèlement sexuel — Répétition',
    question: 'Le harcèlement sexuel est constitué en cas de faits :',
    options: [
      'Répétés ou non selon la forme',
      'Uniquement répétés',
      'Uniquement isolés',
    ],
    answer: 'Répétés ou non selon la forme',
    explanation:
        'Un acte unique peut suffire lorsqu’il est assimilable à un chantage sexuel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Harcèlement sexuel — Chantage',
    question:
        'Le fait d’imposer un acte unique en échange d’un avantage constitue :',
    options: [
      'Une forme autonome de harcèlement sexuel',
      'Un viol',
      'Une contravention',
    ],
    answer: 'Une forme autonome de harcèlement sexuel',
    explanation: 'Le texte prévoit expressément cette hypothèse.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Harcèlement sexuel — Élément moral',
    question: 'L’élément moral du harcèlement sexuel suppose :',
    options: [
      'La conscience d’imposer un comportement à connotation sexuelle',
      'Une intention de nuire',
      'Un profit financier',
    ],
    answer: 'La conscience d’imposer un comportement à connotation sexuelle',
    explanation:
        'Le mobile importe peu : seule la conscience des faits est exigée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Harcèlement sexuel — Aggravation',
    question: 'Le harcèlement sexuel est aggravé lorsqu’il est commis :',
    options: [
      'Par une personne abusant de l’autorité que lui confèrent ses fonctions',
      'Dans un lieu public',
      'En présence d’un témoin',
    ],
    answer:
        'Par une personne abusant de l’autorité que lui confèrent ses fonctions',
    explanation: 'L’abus d’autorité constitue une circonstance aggravante.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Harcèlement sexuel — Peines',
    question: 'Les peines encourues pour harcèlement sexuel simple sont :',
    options: [
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 30 000 € d’amende',
    explanation:
        'Le cours indique : peine de droit commun prévue par l’article 222-33-2-2.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Harcèlement sexuel — Tentative',
    question: 'La tentative de harcèlement sexuel est :',
    options: ['Non punissable', 'Punissable', 'Une contravention'],
    answer: 'Non punissable',
    explanation: 'Aucune disposition ne prévoit la tentative.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Discrimination — Peines',
    question: 'La peine encourue pour discrimination simple est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau du cours précise les peines prévues à l’article 225-2.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Violation ou profanation — Peines aggravées',
    question: 'Les peines encourues en cas de profanation aggravée sont :',
    options: [
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 30 000 € d’amende',
    explanation:
        'Le tableau du cours indique : aggravation = 2 ans et 30 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Rémunération inexistante/insuffisante — Complicité',
    question: 'La complicité de 225-13 est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable seulement si l’auteur est employeur',
    ],
    answer: 'Punissable',
    explanation:
        'Le cours indique : COMPLICITÉ : OUI (articles 121-6 et 121-7 du C.P.).',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Violation/profanation — Complicité',
    question:
        'La complicité de violation/profanation (tombeaux/sépultures/urnes/monuments) est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable seulement si l’auteur principal est condamné à une peine de prison',
    ],
    answer: 'Punissable',
    explanation:
        'Le cours indique : COMPLICITÉ : OUI, conformément aux articles 121-6 et 121-7 du C.P.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Définition',
    question: 'La dissimulation forcée du visage constitue :',
    options: [
      'Une forme de violence à l’encontre de la victime',
      'Une simple contravention',
      'Un manquement administratif',
    ],
    answer: 'Une forme de violence à l’encontre de la victime',
    explanation:
        'Le texte qualifie la dissimulation imposée comme une forme de violence exercée contre la victime.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Victime',
    question: 'Cette infraction peut viser :',
    options: [
      'Une ou plusieurs personnes',
      'Uniquement une femme majeure',
      'Uniquement un mineur',
    ],
    answer: 'Une ou plusieurs personnes',
    explanation:
        'L’article 225-4-10 vise l’imposition à une ou plusieurs personnes.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Sexe',
    question: 'La dissimulation doit être imposée :',
    options: [
      'En raison du sexe de la victime',
      'Pour des raisons religieuses uniquement',
      'Dans un espace public exclusivement',
    ],
    answer: 'En raison du sexe de la victime',
    explanation:
        'L’infraction suppose que la dissimulation soit imposée en raison du sexe de la victime.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // DISSIMULATION FORCÉE DU VISAGE — MOYENNE
  // =========================================================
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Moyens',
    question:
        'Lequel des moyens suivants n’est PAS prévu par l’article 225-4-10 CP ?',
    options: ['La ruse', 'La menace', 'La contrainte'],
    answer: 'La ruse',
    explanation:
        'Les moyens énumérés sont : menace, violence, contrainte, abus d’autorité ou de pouvoir.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Menace',
    question: 'La menace se caractérise juridiquement par :',
    options: [
      'Un acte d’intimidation inspirant la crainte d’un mal',
      'Un contact physique obligatoire',
      'Une infraction consommée',
    ],
    answer: 'Un acte d’intimidation inspirant la crainte d’un mal',
    explanation:
        'La menace constitue une atteinte à l’intégrité morale (Cass. crim., 11 juin 1937).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Violence',
    question: 'La violence peut être caractérisée :',
    options: [
      'Même sans contact physique',
      'Uniquement par des coups',
      'Uniquement par des blessures',
    ],
    answer: 'Même sans contact physique',
    explanation:
        'La jurisprudence admet la violence sans contact physique si elle provoque un choc émotif.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Contrainte',
    question: 'La contrainte s’apprécie principalement :',
    options: [
      'Au regard de la capacité de résistance de la victime',
      'Selon l’intention de l’auteur',
      'Selon le lieu des faits',
    ],
    answer: 'Au regard de la capacité de résistance de la victime',
    explanation:
        'Cass. crim., 8 juin 1994 : la contrainte dépend de la résistance possible de la victime.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // DISSIMULATION FORCÉE DU VISAGE — DIFFICILE
  // =========================================================
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Fait justificatif',
    question:
        'La victime contrainte de dissimuler son visage peut être exonérée pénalement sur le fondement :',
    options: [
      'De l’article 122-2 du Code pénal',
      'De l’erreur de droit',
      'De la légitime défense',
    ],
    answer: 'De l’article 122-2 du Code pénal',
    explanation:
        'La contrainte irrésistible constitue un fait justificatif (art. 122-2 CP).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Dissimulation forcée du visage — Aggravation',
    question:
        'La circonstance aggravante est constituée lorsque les faits sont commis :',
    options: ['Au préjudice d’un mineur', 'En réunion', 'Dans un lieu public'],
    answer: 'Au préjudice d’un mineur',
    explanation:
        'L’article 225-4-10 alinéa 2 prévoit une aggravation lorsque la victime est mineure.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // RÉTRIBUTION INSUFFISANTE — FACILE
  // =========================================================
  const QuizQuestion(
    category: 'Travail non ou insuffisamment rémunéré — Fondement',
    question: 'La rétribution inexistante ou insuffisante est prévue par :',
    options: [
      'L’article 225-13 du Code pénal',
      'L’article 225-14 du Code pénal',
      'L’article 223-15-2 du Code pénal',
    ],
    answer: 'L’article 225-13 du Code pénal',
    explanation: 'L’article 225-13 définit et réprime cette infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Travail non ou insuffisamment rémunéré — Objet',
    question: 'Cette infraction vise :',
    options: [
      'La fourniture de services',
      'La remise d’un bien',
      'Le prêt d’argent',
    ],
    answer: 'La fourniture de services',
    explanation:
        'Le texte vise la fourniture de services, non la remise de biens ou d’argent.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // RÉTRIBUTION INSUFFISANTE — MOYENNE
  // =========================================================
  const QuizQuestion(
    category: 'Travail non ou insuffisamment rémunéré — Rémunération',
    question: 'L’absence totale de rémunération suppose :',
    options: [
      'Aucune contrepartie, même en nature',
      'Une faible rémunération',
      'Un salaire inférieur au SMIC',
    ],
    answer: 'Aucune contrepartie, même en nature',
    explanation:
        'Aucune contrepartie ne doit exister, y compris logement ou nourriture.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Travail non ou insuffisamment rémunéré — Vulnérabilité',
    question: 'La vulnérabilité doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Médicalement constatée',
      'Déclarée par la victime',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation:
        'La vulnérabilité ou dépendance doit être apparente ou connue de l’auteur.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Conditions de travail/hébergement indignes — Fondement',
    question:
        'La soumission d’une personne vulnérable ou dépendante à des conditions de travail ou d’hébergement incompatibles avec la dignité humaine est prévue par :',
    options: [
      'L’article 225-14 du Code pénal',
      'L’article 225-13 du Code pénal',
      'L’article 225-4-1 du Code pénal',
    ],
    answer: 'L’article 225-14 du Code pénal',
    explanation:
        'L’article 225-14 du C.P. définit et réprime la soumission à des conditions de travail ou d’hébergement incompatibles avec la dignité humaine.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Victime',
    question: 'Pour l’article 225-14 CP, la victime doit être :',
    options: [
      'Vulnérable ou en état de dépendance',
      'Uniquement mineure',
      'Uniquement étrangère',
    ],
    answer: 'Vulnérable ou en état de dépendance',
    explanation:
        'L’infraction vise une personne dont la vulnérabilité ou l’état de dépendance est apparent ou connu.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Champs',
    question: 'L’article 225-14 CP vise :',
    options: [
      'Des conditions de travail OU d’hébergement',
      'Uniquement des conditions de travail',
      'Uniquement des conditions d’hébergement',
    ],
    answer: 'Des conditions de travail OU d’hébergement',
    explanation:
        'Le texte vise la soumission à des conditions de travail ou d’hébergement incompatibles avec la dignité humaine.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Tentative',
    question:
        'La tentative de l’infraction prévue par l’article 225-14 CP est :',
    options: ['Non punissable', 'Punissable', 'Une contravention'],
    answer: 'Non punissable',
    explanation: 'Le cours indique : TENTATIVE : NON.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Complicité',
    question:
        'La complicité de l’infraction prévue à l’article 225-14 CP est :',
    options: [
      'Punissable',
      'Non punissable',
      'Uniquement pour les personnes morales',
    ],
    answer: 'Punissable',
    explanation:
        'La complicité est punissable conformément aux articles 121-6 et 121-7 du Code pénal.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // 225-14 — CONDITIONS INDIGNES — MOYENNE
  // =========================================================
  const QuizQuestion(
    category: 'Conditions indignes — Dignité humaine',
    question:
        'Selon le cours, la notion de dignité humaine en droit français est affirmée comme principe à valeur constitutionnelle par :',
    options: [
      'Le Conseil constitutionnel (27 juillet 1994)',
      'La Cour de cassation (1996)',
      'Le Conseil d’État (2001)',
    ],
    answer: 'Le Conseil constitutionnel (27 juillet 1994)',
    explanation:
        'Le cours cite : Cons. const., 27 juillet 1994 : principe à valeur constitutionnelle de sauvegarde de la dignité humaine.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Dignité humaine',
    question: 'Est incompatible avec la dignité humaine ce qui :',
    options: [
      'Abaisse ou avilit l’être humain dont les droits essentiels sont bafoués',
      'Réduit simplement la rémunération sous le SMIC',
      'Empêche l’accès à un service public',
    ],
    answer:
        'Abaisse ou avilit l’être humain dont les droits essentiels sont bafoués',
    explanation:
        'Le cours indique que l’incompatibilité avec la dignité humaine correspond à ce qui abaisse/avilit l’être humain.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Travail',
    question: 'Contrairement à l’article 225-13 CP, l’article 225-14 CP :',
    options: [
      'N’exige pas l’absence ou l’insuffisance de rémunération',
      'Exige une rémunération manifestement insuffisante',
      'Ne vise pas les relations de travail',
    ],
    answer: 'N’exige pas l’absence ou l’insuffisance de rémunération',
    explanation:
        '225-14 vise les conditions indignes, indépendamment de la rémunération.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Travail',
    question:
        'Parmi les éléments suivants, lequel peut caractériser des conditions de travail incompatibles avec la dignité humaine ?',
    options: [
      'Insalubrité des locaux, cadences intolérables, durée excessive',
      'Uniquement le non-paiement des heures supplémentaires',
      'Uniquement le retard de salaire',
    ],
    answer: 'Insalubrité des locaux, cadences intolérables, durée excessive',
    explanation:
        'Le cours cite : insalubrité, manque d’aération, cadences intolérables, durée excessive.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Travail',
    question:
        'Les relations de travail (insultes, brimades, comportements vexatoires) peuvent être retenues au titre :',
    options: [
      'De violences morales caractérisant l’atteinte à la dignité',
      'D’un simple conflit social sans portée pénale',
      'Uniquement d’un harcèlement sexuel',
    ],
    answer: 'De violences morales caractérisant l’atteinte à la dignité',
    explanation:
        'Le cours précise que l’atteinte peut résulter d’insultes/brimades assimilables à des violences morales.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Hébergement',
    question:
        'Pour être qualifié d’« hébergement » au sens de l’article 225-14 CP, il faut notamment :',
    options: [
      'Une contrepartie ET une certaine durée',
      'Uniquement que le logement soit petit',
      'Uniquement l’absence de chauffage',
    ],
    answer: 'Une contrepartie ET une certaine durée',
    explanation:
        'Le cours exige : contrepartie (loyer/avantage) et hébergement sur un certain temps (logement pour y vivre).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Hébergement',
    question:
        'La contrepartie de l’hébergement au sens de l’article 225-14 CP peut être :',
    options: [
      'Un loyer ou des avantages en nature (travail, mise en valeur des lieux, etc.)',
      'Uniquement un paiement en espèces',
      'Uniquement un contrat écrit',
    ],
    answer:
        'Un loyer ou des avantages en nature (travail, mise en valeur des lieux, etc.)',
    explanation:
        'Le cours précise que la contrepartie peut être un loyer ou des avantages en nature.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Vulnérabilité',
    question:
        'La vulnérabilité/dépendance au sens de l’article 225-14 CP doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Reconnue par un médecin',
      'Déclarée par la préfecture',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation:
        'Condition centrale : vulnérabilité/dépendance apparente ou connue de l’auteur.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Vulnérabilité',
    question: 'La vulnérabilité peut résulter :',
    options: [
      'D’un état physique/mental OU de l’environnement économique/social/culturel',
      'Uniquement d’une maladie',
      'Uniquement de l’âge',
    ],
    answer:
        'D’un état physique/mental OU de l’environnement économique/social/culturel',
    explanation:
        'Le cours vise : grossesse, âge, maladie, handicap mais aussi immigrés, chômeurs, sans-abri, etc.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Dépendance',
    question: 'La dépendance au sens du cours peut être :',
    options: [
      'Économique ou morale',
      'Uniquement juridique',
      'Uniquement médicale',
    ],
    answer: 'Économique ou morale',
    explanation:
        'Le cours cite : dépendance économique (précarité) ou morale (domination).',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 225-14 — CONDITIONS INDIGNES — DIFFICILE
  // =========================================================
  const QuizQuestion(
    category: 'Conditions indignes — Élément moral',
    question: 'L’élément moral de l’article 225-14 CP suppose notamment :',
    options: [
      'La conscience de la vulnérabilité/dépendance ET la conscience du caractère indigne des conditions',
      'La seule intention de faire travailler la victime',
      'La preuve d’un mobile lucratif obligatoire',
    ],
    answer:
        'La conscience de la vulnérabilité/dépendance ET la conscience du caractère indigne des conditions',
    explanation:
        'Le cours exige : connaissance de la vulnérabilité/dépendance et connaissance de l’incompatibilité avec la dignité humaine.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Travail forcé',
    question:
        'Le cours indique que le travail forcé est en soi incompatible avec la dignité humaine et renvoie notamment à :',
    options: [
      'La définition de l’OIT (Convention du 28 juin 1930)',
      'La définition de l’ONU (2000)',
      'La définition de l’UE (2016)',
    ],
    answer: 'La définition de l’OIT (Convention du 28 juin 1930)',
    explanation:
        'Le cours cite la Convention OIT du 28 juin 1930 : travail exigé sous menace d’une peine et non offert de plein gré.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Travail forcé',
    question: 'Dans le cours, la notion de travail forcé implique :',
    options: [
      'Un travail exigé sous menace d’une peine et sans offre de plein gré',
      'Un travail long mais payé',
      'Un contrat de travail illégal',
    ],
    answer:
        'Un travail exigé sous menace d’une peine et sans offre de plein gré',
    explanation:
        'C’est la définition reprise du texte OIT mentionnée dans le cours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Hébergement',
    question:
        'Le cours précise que des conditions d’hébergement indignes peuvent être caractérisées notamment par :',
    options: [
      'Absence d’hygiène minimale, absence de chauffage/éclairage, inadéquation au nombre d’occupants',
      'Le fait de vivre en colocation',
      'Le fait de ne pas avoir Internet',
    ],
    answer:
        'Absence d’hygiène minimale, absence de chauffage/éclairage, inadéquation au nombre d’occupants',
    explanation:
        'Le cours liste ces exemples comme causes possibles d’hébergement contraire à la dignité humaine.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Cumul',
    question:
        'Selon la note du cours, les délits de l’article 225-14 CP peuvent :',
    options: [
      'Être caractérisés en même temps (travail et hébergement) et se cumuler avec d’autres infractions',
      'Jamais être retenus simultanément',
      'Remplacer automatiquement toutes les autres infractions',
    ],
    answer:
        'Être caractérisés en même temps (travail et hébergement) et se cumuler avec d’autres infractions',
    explanation:
        'Le cours précise que les deux délits peuvent être caractérisés simultanément et retenus avec d’autres infractions.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Répression',
    question: 'La qualification « simple » de l’article 225-14 CP est :',
    options: ['Un délit', 'Une contravention', 'Un crime'],
    answer: 'Un délit',
    explanation:
        'L’article 225-14 CP constitue un délit en qualification simple.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Peines (simple)',
    question:
        'Les peines principales encourues pour la qualification simple (225-14) sont :',
    options: [
      '7 ans d’emprisonnement et 200 000 € d’amende',
      '5 ans d’emprisonnement et 150 000 € d’amende',
      '10 ans d’emprisonnement et 300 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 200 000 € d’amende',
    explanation:
        'Le tableau de répression du cours indique : 7 ans et 200 000 €.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 225-15 — CIRCONSTANCES AGGRAVANTES (1er degré) — MOYENNE
  // =========================================================
  const QuizQuestion(
    category: 'Conditions indignes — Aggravation (1er degré)',
    question:
        'Pour l’article 225-14 CP, le premier degré d’aggravation vise notamment :',
    options: [
      'Plusieurs victimes OU une victime mineure',
      'Un acte commis en récidive uniquement',
      'Un acte commis la nuit uniquement',
    ],
    answer: 'Plusieurs victimes OU une victime mineure',
    explanation:
        'Le cours indique : 225-15 I 2° (plusieurs personnes) et 225-15 II 2° (mineur).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Aggravation (1er degré)',
    question:
        'Le premier degré d’aggravation de l’article 225-14 CP est prévu par :',
    options: [
      'L’article 225-15 I 2° et II 2° du Code pénal',
      'L’article 225-12-2 du Code pénal',
      'L’article 225-4-2 du Code pénal',
    ],
    answer: 'L’article 225-15 I 2° et II 2° du Code pénal',
    explanation:
        'Le cours renvoie au 225-15 I 2° (plusieurs personnes) et II 2° (mineur).',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 225-15 — AGGRAVATION (2nd degré) — DIFFICILE
  // =========================================================
  const QuizQuestion(
    category: 'Conditions indignes — Aggravation (2nd degré)',
    question:
        'Le second degré d’aggravation (crime) pour 225-14 CP est prévu par :',
    options: [
      'L’article 225-15 III 2° du Code pénal',
      'L’article 225-15 II 2° du Code pénal',
      'L’article 225-16 du Code pénal',
    ],
    answer: 'L’article 225-15 III 2° du Code pénal',
    explanation: 'Le cours mentionne : second degré = 225-15 III 2°.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Aggravation (2nd degré)',
    question: 'Le second degré d’aggravation suppose notamment :',
    options: [
      'Plusieurs victimes parmi lesquelles un ou plusieurs mineurs',
      'Une seule victime majeure',
      'Une situation de précarité économique uniquement',
    ],
    answer: 'Plusieurs victimes parmi lesquelles un ou plusieurs mineurs',
    explanation:
        'Le cours précise : 225-15 III 2° : plusieurs personnes dont au moins un mineur.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Peines (1er degré)',
    question:
        'Les peines principales prévues en 1er degré d’aggravation (225-15 I/II) pour 225-14 sont :',
    options: [
      '10 ans d’emprisonnement et 300 000 € d’amende',
      '7 ans d’emprisonnement et 200 000 € d’amende',
      '15 ans de réclusion criminelle et 400 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 300 000 € d’amende',
    explanation:
        'Le tableau de répression indique 10 ans et 300 000 € pour le 1er degré d’aggravation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Peines (2nd degré)',
    question:
        'Les peines principales prévues en 2nd degré d’aggravation (crime) pour 225-14 sont :',
    options: [
      '15 ans de réclusion criminelle et 400 000 € d’amende',
      '20 ans de réclusion criminelle et 3 000 000 € d’amende',
      '7 ans d’emprisonnement et 200 000 € d’amende',
    ],
    answer: '15 ans de réclusion criminelle et 400 000 € d’amende',
    explanation:
        'Le tableau indique : 15 ans de réclusion criminelle et 400 000 € d’amende.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 225-16 — PERSONNES MORALES — MOYENNE / DIFFICILE
  // =========================================================
  const QuizQuestion(
    category: 'Conditions indignes — Personnes morales',
    question:
        'La responsabilité des personnes morales pour les infractions 225-14 / 225-15 est prévue :',
    options: [
      'Expressément par l’article 225-16 du Code pénal',
      'Uniquement par le Code du travail',
      'Uniquement en matière contraventionnelle',
    ],
    answer: 'Expressément par l’article 225-16 du Code pénal',
    explanation:
        'Le cours précise : responsabilité des personnes morales prévue expressément par l’article 225-16.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Personnes morales',
    question:
        'Parmi les peines complémentaires possibles pour les personnes morales (cours), on trouve notamment :',
    options: [
      'Dissolution et interdiction d’exercer',
      'Uniquement une mise à l’épreuve',
      'Uniquement un avertissement',
    ],
    answer: 'Dissolution et interdiction d’exercer',
    explanation:
        'Le cours renvoie aux peines de l’article 131-39 : dissolution, interdiction d’exercer, etc.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Fondement',
    question: 'La traite des êtres humains est définie et réprimée par :',
    options: [
      'L’article 225-4-1 du Code pénal',
      'L’article 225-14 du Code pénal',
      'L’article 225-10 du Code pénal',
    ],
    answer: 'L’article 225-4-1 du Code pénal',
    explanation:
        'Le cours précise que l’article 225-4-1 du C.P. définit et réprime la traite des êtres humains.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Actes matériels',
    question: 'La traite des êtres humains suppose notamment un acte tel que :',
    options: [
      'Recruter, transporter, transférer, héberger ou accueillir',
      'Diffuser des images',
      'Refuser une embauche',
    ],
    answer: 'Recruter, transporter, transférer, héberger ou accueillir',
    explanation:
        'Le texte vise le recrutement, le transport, le transfert, l’hébergement ou l’accueil à des fins d’exploitation.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Exploitation',
    question: 'L’exploitation au sens de la traite consiste notamment à :',
    options: [
      'Mettre la victime à disposition (de l’auteur ou d’un tiers) afin de permettre certaines infractions',
      'Simplement héberger une personne gratuitement',
      'Refuser une vente',
    ],
    answer:
        'Mettre la victime à disposition (de l’auteur ou d’un tiers) afin de permettre certaines infractions',
    explanation:
        'Le cours définit l’exploitation comme la mise à disposition de la victime pour permettre certaines infractions listées.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Mineur',
    question:
        'La traite des êtres humains à l’égard d’un mineur est constituée :',
    options: [
      'Même sans les circonstances 1° à 4° du I',
      'Uniquement si une menace est prouvée',
      'Uniquement si une rémunération est versée',
    ],
    answer: 'Même sans les circonstances 1° à 4° du I',
    explanation:
        'Le cours indique : pour un mineur, la traite est constituée même si aucune circonstance 1° à 4° n’est caractérisée.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Tentative',
    question: 'La tentative de la traite des êtres humains est :',
    options: ['Punissable', 'Non punissable', 'Une simple contravention'],
    answer: 'Punissable',
    explanation:
        'Le cours précise : TENTATIVE : OUI, prévue expressément à l’article 225-4-7 du C.P.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Tentative',
    question: 'La tentative de traite des êtres humains est prévue par :',
    options: [
      'L’article 225-4-7 du Code pénal',
      'L’article 225-4-6 du Code pénal',
      'L’article 225-4-9 du Code pénal',
    ],
    answer: 'L’article 225-4-7 du Code pénal',
    explanation:
        'Le cours indique que la tentative est prévue expressément par l’article 225-4-7 du C.P.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Complicité',
    question: 'La complicité en matière de traite des êtres humains est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable seulement pour les crimes',
    ],
    answer: 'Punissable',
    explanation:
        'Le cours rappelle que la complicité est punissable conformément aux articles 121-6 et 121-7 du C.P.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // TRAITE — MOYENNE (circonstances 1° à 4°, notions clés)
  // =========================================================
  const QuizQuestion(
    category: 'Traite des êtres humains — Circonstances',
    question:
        'Pour un majeur, la traite est constituée si l’acte est commis dans :',
    options: [
      'Au moins une des circonstances 1° à 4°',
      'Uniquement la circonstance 1°',
      'Aucune circonstance n’est nécessaire',
    ],
    answer: 'Au moins une des circonstances 1° à 4°',
    explanation:
        'Le cours précise : à l’égard d’un majeur, la traite suppose au moins une des circonstances 1° à 4°.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Circonstance 1°',
    question: 'La circonstance 1° de l’article 225-4-1 I vise notamment :',
    options: [
      'Menace, contrainte, violence ou manœuvre dolosive',
      'Rémunération uniquement',
      'Bande organisée',
    ],
    answer: 'Menace, contrainte, violence ou manœuvre dolosive',
    explanation:
        'Le cours liste : menace/contrainte/violence/manœuvre dolosive visant la victime, sa famille ou une personne en relation habituelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Manœuvre dolosive',
    question: 'Dans le cours, la manœuvre dolosive correspond à :',
    options: [
      'Des agissements trompeurs qui amènent par la ruse une personne à être abusée',
      'Une violence physique directe',
      'Une simple négligence',
    ],
    answer:
        'Des agissements trompeurs qui amènent par la ruse une personne à être abusée',
    explanation:
        'Le cours définit la manœuvre dolosive comme des agissements trompeurs (ruse) conduisant la victime à être abusée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Circonstance 2°',
    question: 'La circonstance 2° de l’article 225-4-1 I vise :',
    options: [
      'Ascendant ou personne ayant autorité / abusant de l’autorité de ses fonctions',
      'Harcèlement sexuel',
      'Non-assistance à personne en péril',
    ],
    answer:
        'Ascendant ou personne ayant autorité / abusant de l’autorité de ses fonctions',
    explanation:
        'Le cours vise l’ascendant (légitime/naturel/adoptif) ou une personne ayant autorité ou abusant de l’autorité que lui confèrent ses fonctions.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Autorité',
    question: 'Selon le cours, l’autorité visée peut être :',
    options: [
      'De droit, de fait, ou conférée par des fonctions publiques/privées',
      'Uniquement de droit',
      'Uniquement publique',
    ],
    answer:
        'De droit, de fait, ou conférée par des fonctions publiques/privées',
    explanation:
        'Le cours cite : autorité de droit (tuteur), de fait (concubin), ou conférée par les fonctions (professeur, médecin).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Circonstance 3°',
    question: 'La circonstance 3° de l’article 225-4-1 I correspond à :',
    options: [
      'Abus d’une situation de vulnérabilité (âge, maladie, infirmité, déficience, grossesse)',
      'Abus de biens sociaux',
      'Abus de confiance',
    ],
    answer:
        'Abus d’une situation de vulnérabilité (âge, maladie, infirmité, déficience, grossesse)',
    explanation:
        'Le cours précise que la vulnérabilité doit être due à des causes limitatives (âge, maladie, infirmité, déficience physique/psychique, grossesse) et être apparente ou connue.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Circonstance 4°',
    question: 'La circonstance 4° de l’article 225-4-1 I vise :',
    options: [
      'Échange / octroi d’une rémunération ou d’un avantage (ou promesse)',
      'Violence uniquement',
      'Absence de rémunération',
    ],
    answer:
        'Échange / octroi d’une rémunération ou d’un avantage (ou promesse)',
    explanation:
        'Le cours indique que la traite peut être constituée en échange d’une rémunération/avantage (ou promesse) convenu initialement.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Rémunération',
    question:
        'Selon le cours, si l’opération est réalisée à titre gratuit (sans échange) :',
    options: [
      'La circonstance 4° n’est pas constituée',
      'La circonstance 4° est toujours constituée',
      'Cela devient automatiquement une tentative',
    ],
    answer: 'La circonstance 4° n’est pas constituée',
    explanation:
        'Le cours précise : l’échange est nécessaire ; à titre gratuit, la circonstance 4° n’est pas remplie.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Mise à disposition',
    question:
        'Concernant la « mise à disposition », le cours précise qu’elle peut être :',
    options: [
      'Au profit de l’auteur lui-même ou d’un tiers, même non identifié',
      'Uniquement au profit d’un tiers identifié',
      'Uniquement au profit de l’État',
    ],
    answer: 'Au profit de l’auteur lui-même ou d’un tiers, même non identifié',
    explanation:
        'Le cours indique que la mise à disposition peut être pour l’auteur (ajout de « à sa disposition ») ou pour un tiers non identifié.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Objectif criminel',
    question:
        'Selon le cours, la traite n’est constituée que si l’objectif vise :',
    options: [
      'Une infraction expressément énumérée par le texte',
      'N’importe quelle contravention',
      'Uniquement une infraction économique',
    ],
    answer: 'Une infraction expressément énumérée par le texte',
    explanation:
        'Le cours rappelle l’interprétation stricte : l’objectif doit entrer dans la liste limitative du texte.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // TRAITE — DIFFICILE (liste exploitation, aggravations, peines, exemption/réduction)
  // =========================================================
  const QuizQuestion(
    category: 'Traite des êtres humains — Exploitation (liste)',
    question:
        'Parmi les éléments suivants, lequel fait partie de la liste d’exploitation visée par le cours ?',
    options: ['Exploitation de la mendicité', 'Simple recel', 'Diffamation'],
    answer: 'Exploitation de la mendicité',
    explanation:
        'Le cours cite expressément l’exploitation de la mendicité parmi les objectifs criminels listés.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Exploitation (liste)',
    question:
        'La traite peut viser la mise à disposition de la victime afin de permettre :',
    options: [
      'Le prélèvement de l’un de ses organes',
      'Une contravention de 1ère classe',
      'Une simple injure non publique',
    ],
    answer: 'Le prélèvement de l’un de ses organes',
    explanation:
        'Le cours inclut le prélèvement d’organe dans la liste limitative des exploitations.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Exploitation (liste)',
    question: 'Selon le cours, la liste d’exploitation inclut notamment :',
    options: [
      'Réduction en esclavage, travail/services forcés, réduction en servitude',
      'Vol simple, recel, escroquerie',
      'Recel, abus de confiance, faux',
    ],
    answer:
        'Réduction en esclavage, travail/services forcés, réduction en servitude',
    explanation:
        'Le cours liste ces objectifs criminels parmi ceux visés par la traite.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Exploitation',
    question:
        'Pour que la traite des êtres humains soit constituée, il est nécessaire que les infractions visées soient effectivement commises :',
    options: ['Non', 'Oui', 'Oui, sauf pour les mineurs'],
    answer: 'Non',
    explanation:
        'Le cours précise qu’il n’est pas nécessaire que les infractions visées soient commises : la mise à disposition à cette fin suffit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Contraindre à commettre',
    question:
        'Lorsque la traite vise le fait de contraindre la victime à commettre un crime ou un délit, le texte ne vise pas :',
    options: ['Les contraventions', 'Les délits', 'Les crimes'],
    answer: 'Les contraventions',
    explanation:
        'Le cours indique que « tout crime ou délit » n’a pas vocation à s’appliquer aux contraventions.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Élément moral',
    question: 'L’élément moral exige notamment :',
    options: [
      'La conscience par l’auteur du devenir de la victime (destination criminelle)',
      'Un mobile exclusivement financier',
      'La preuve du consentement de la victime',
    ],
    answer:
        'La conscience par l’auteur du devenir de la victime (destination criminelle)',
    explanation:
        'Le cours insiste : infraction intentionnelle = l’auteur sait à quoi la victime est destinée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite des êtres humains — Consentement',
    question:
        'Selon le cours, l’incrimination de traite repose sur la notion de consentement de la victime :',
    options: [
      'Non, le consentement est indifférent',
      'Oui, il faut prouver l’absence de consentement',
      'Oui, il faut prouver le consentement',
    ],
    answer: 'Non, le consentement est indifférent',
    explanation:
        'Le cours précise : l’existence ou l’absence de consentement n’a pas à être démontrée.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // AGGRAVATIONS — 225-4-2 / 225-4-3 / 225-4-4 — MOYENNE
  // =========================================================
  const QuizQuestion(
    category: 'Traite — Aggravation délictuelle',
    question:
        'La traite des êtres humains aggravée délictuelle (mineur sans autre circonstance) est prévue par :',
    options: [
      'L’article 225-4-1 II du Code pénal',
      'L’article 225-4-3 du Code pénal',
      'L’article 225-4-4 du Code pénal',
    ],
    answer: 'L’article 225-4-1 II du Code pénal',
    explanation:
        'Le cours mentionne : traite aggravée délictuelle (mineur même sans circonstances 1° à 4°) = 225-4-1 II.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Traite — Aggravation',
    question:
        'La traite aggravée délictuelle peut être caractérisée lorsqu’elle est commise :',
    options: [
      'Dans deux des circonstances 1° à 4° de 225-4-1 I',
      'Uniquement en récidive',
      'Uniquement avec arme',
    ],
    answer: 'Dans deux des circonstances 1° à 4° de 225-4-1 I',
    explanation:
        'Le cours vise : 225-4-2 I lorsque la traite est commise dans deux des circonstances 1° à 4°.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Traite — Aggravation',
    question: 'La traite aggravée criminelle est notamment prévue par :',
    options: [
      'L’article 225-4-2 II du Code pénal',
      'L’article 225-4-2 I du Code pénal',
      'L’article 225-4-7 du Code pénal',
    ],
    answer: 'L’article 225-4-2 II du Code pénal',
    explanation:
        'Le cours distingue la traite aggravée criminelle à l’article 225-4-2 II.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // AGGRAVATIONS — DIFFICILE (BO, tortures, liste 225-4-2 I)
  // =========================================================
  const QuizQuestion(
    category: 'Traite — Aggravation',
    question:
        'La traite des êtres humains commise en bande organisée est prévue par :',
    options: [
      'L’article 225-4-3 du Code pénal',
      'L’article 225-4-4 du Code pénal',
      'L’article 225-4-2 I du Code pénal',
    ],
    answer: 'L’article 225-4-3 du Code pénal',
    explanation: 'Le cours cite : 225-4-3 = traite commise en bande organisée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite — Aggravation',
    question:
        'La traite des êtres humains commise en recourant à des tortures ou actes de barbarie est prévue par :',
    options: [
      'L’article 225-4-4 du Code pénal',
      'L’article 225-4-3 du Code pénal',
      'L’article 225-4-1 du Code pénal',
    ],
    answer: 'L’article 225-4-4 du Code pénal',
    explanation:
        'Le cours précise : 225-4-4 = traite commise en recourant à des tortures ou actes de barbarie.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite — Aggravation (225-4-2 I)',
    question:
        'Parmi les circonstances supplémentaires de l’article 225-4-2 I, on trouve notamment :',
    options: [
      'Mise en contact via un réseau de communication électronique',
      'Un simple conflit familial',
      'Une erreur d’identité',
    ],
    answer: 'Mise en contact via un réseau de communication électronique',
    explanation:
        'Le cours mentionne l’utilisation d’un réseau de communication électronique pour diffuser des messages à un public non déterminé.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite — Aggravation (225-4-2 I)',
    question:
        'Selon le cours, une circonstance aggravante peut être retenue lorsque les faits exposent directement la victime :',
    options: [
      'À un risque immédiat de mort ou de blessures entraînant mutilation/infirmité permanente',
      'À un risque de contravention',
      'À un risque financier uniquement',
    ],
    answer:
        'À un risque immédiat de mort ou de blessures entraînant mutilation/infirmité permanente',
    explanation: 'Le cours cite explicitement cette circonstance aggravante.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite — Aggravation (225-4-2 I)',
    question:
        'Selon le cours, la traite peut être aggravée lorsqu’elle est commise :',
    options: [
      'Par une personne appelée à participer, par ses fonctions, à la lutte contre la traite ou au maintien de l’ordre public',
      'Uniquement par un particulier',
      'Uniquement par une personne morale',
    ],
    answer:
        'Par une personne appelée à participer, par ses fonctions, à la lutte contre la traite ou au maintien de l’ordre public',
    explanation:
        'Le cours liste cette circonstance aggravante liée aux fonctions.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite — Aggravation (225-4-2 I)',
    question:
        'Le cours mentionne une aggravation lorsque les violences ont causé :',
    options: [
      'Une ITT de plus de huit jours',
      'Une ITT de moins de 24h',
      'Une incapacité permanente obligatoire',
    ],
    answer: 'Une ITT de plus de huit jours',
    explanation:
        'Le cours cite : violences ayant causé une ITT de plus de 8 jours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite — Aggravation (225-4-2 I)',
    question: 'Selon le cours, la traite peut être aggravée lorsque :',
    options: [
      'L’infraction a placé la victime dans une situation matérielle ou psychologique grave',
      'La victime a changé de numéro',
      'Il y a un simple préjudice moral',
    ],
    answer:
        'L’infraction a placé la victime dans une situation matérielle ou psychologique grave',
    explanation: 'Le cours cite explicitement cette circonstance aggravante.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // RÉPRESSION — PEINES — MOYENNE / DIFFICILE
  // =========================================================
  const QuizQuestion(
    category: 'Traite — Peines (simple)',
    question: 'La traite des êtres humains « simple » (225-4-1) est punie de :',
    options: [
      '7 ans d’emprisonnement et 150 000 € d’amende',
      '5 ans d’emprisonnement et 150 000 € d’amende',
      '10 ans d’emprisonnement et 1 500 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 150 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 225-4-1 (simple) = 7 ans et 150 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Traite — Peines (aggravée délictuelle)',
    question: 'La traite aggravée délictuelle (mineur) est punie de :',
    options: [
      '10 ans d’emprisonnement et 1 500 000 € d’amende',
      '7 ans d’emprisonnement et 150 000 € d’amende',
      '15 ans de réclusion et 1 500 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 1 500 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 225-4-1 II = 10 ans et 1 500 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite — Peines (aggravée criminelle)',
    question: 'La traite aggravée criminelle (225-4-2 II) est punie de :',
    options: [
      '15 ans de réclusion et 1 500 000 € d’amende',
      '20 ans de réclusion et 3 000 000 € d’amende',
      'Réclusion à perpétuité et 4 500 000 € d’amende',
    ],
    answer: '15 ans de réclusion et 1 500 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 225-4-2 II = 15 ans de réclusion et 1 500 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite — Peines (bande organisée)',
    question: 'La traite commise en bande organisée (225-4-3) est punie de :',
    options: [
      '20 ans de réclusion et 3 000 000 € d’amende',
      '15 ans de réclusion et 1 500 000 € d’amende',
      '10 ans d’emprisonnement et 1 500 000 € d’amende',
    ],
    answer: '20 ans de réclusion et 3 000 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 225-4-3 = 20 ans et 3 000 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite — Peines (tortures / barbarie)',
    question:
        'La traite commise en recourant à des tortures ou actes de barbarie (225-4-4) est punie de :',
    options: [
      'Réclusion à perpétuité et 4 500 000 € d’amende',
      '20 ans de réclusion et 3 000 000 € d’amende',
      '15 ans de réclusion et 1 500 000 € d’amende',
    ],
    answer: 'Réclusion à perpétuité et 4 500 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 225-4-4 = réclusion à perpétuité et 4 500 000 €.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 225-4-5 — PEINES PLUS ÉLEVÉES SI CRIME/DELIT SOUS-JACENT + GRAVE — DIFFICILE
  // =========================================================
  const QuizQuestion(
    category: 'Traite — Règle spéciale de peine',
    question:
        'Selon l’article 225-4-5, si le crime/délit commis (ou devant être commis) contre la victime est puni d’une peine supérieure :',
    options: [
      'La traite est punie des peines attachées à ce crime/délit (dont l’auteur avait connaissance)',
      'La traite est automatiquement dépénalisée',
      'La peine est divisée par deux',
    ],
    answer:
        'La traite est punie des peines attachées à ce crime/délit (dont l’auteur avait connaissance)',
    explanation:
        'Le cours précise la règle de l’article 225-4-5 : application des peines attachées au crime/délit plus grave connu de l’auteur.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // PERSONNES MORALES — 225-4-6 — MOYENNE
  // =========================================================
  const QuizQuestion(
    category: 'Traite — Personnes morales',
    question:
        'La responsabilité des personnes morales en matière de traite est prévue par :',
    options: [
      'L’article 225-4-6 du Code pénal',
      'L’article 225-4-7 du Code pénal',
      'L’article 225-4-9 du Code pénal',
    ],
    answer: 'L’article 225-4-6 du Code pénal',
    explanation:
        'Le cours cite : l’article 225-4-6 prévoit la responsabilité des personnes morales.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // EXEMPTION / RÉDUCTION DE PEINE — 225-4-9 — DIFFICILE
  // =========================================================
  const QuizQuestion(
    category: 'Traite — Exemption de peine',
    question: 'L’exemption de peine en matière de traite est prévue par :',
    options: [
      'L’article 225-4-9 alinéa 1 du Code pénal',
      'L’article 225-4-9 alinéa 2 du Code pénal',
      'L’article 225-4-7 du Code pénal',
    ],
    answer: 'L’article 225-4-9 alinéa 1 du Code pénal',
    explanation: 'Le cours indique : exemption de peine = 225-4-9 al.1.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite — Exemption de peine',
    question: 'Pour bénéficier de l’exemption de peine, il faut notamment :',
    options: [
      'Avoir tenté de commettre l’infraction, avertir l’autorité et permettre d’éviter la réalisation',
      'Avoir commis l’infraction et garder le silence',
      'Avoir versé une caution',
    ],
    answer:
        'Avoir tenté de commettre l’infraction, avertir l’autorité et permettre d’éviter la réalisation',
    explanation:
        'Le cours résume : exemption au stade de la tentative + avertissement de l’autorité + éviter la réalisation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite — Réduction de peine',
    question: 'La réduction de peine en matière de traite est prévue par :',
    options: [
      'L’article 225-4-9 alinéa 2 du Code pénal',
      'L’article 225-4-9 alinéa 1 du Code pénal',
      'L’article 225-4-5 du Code pénal',
    ],
    answer: 'L’article 225-4-9 alinéa 2 du Code pénal',
    explanation: 'Le cours indique : réduction de peine = 225-4-9 al.2.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite — Réduction de peine',
    question:
        'Selon le cours, la réduction de peine est accordée si l’auteur/complice :',
    options: [
      'Avertit l’autorité et permet de faire cesser l’infraction ou d’éviter un préjudice irréversible ou d’identifier d’autres auteurs/complices',
      'Déménage à l’étranger',
      'Rembourse uniquement la victime',
    ],
    answer:
        'Avertit l’autorité et permet de faire cesser l’infraction ou d’éviter un préjudice irréversible ou d’identifier d’autres auteurs/complices',
    explanation:
        'Le cours décrit les conditions : faire cesser / éviter mort ou infirmité permanente / identifier autres auteurs ou complices.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Traite — Réduction de peine',
    question:
        'Quand la peine encourue est la réclusion criminelle à perpétuité, la réduction prévue par 225-4-9 al.2 la ramène à :',
    options: [
      '20 ans de réclusion criminelle',
      '15 ans de réclusion criminelle',
      '10 ans d’emprisonnement',
    ],
    answer: '20 ans de réclusion criminelle',
    explanation: 'Le cours précise : si perpétuité, elle est ramenée à 20 ans.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Conditions indignes — Personnes morales',
    question: 'Le cours précise une peine spécifique possible :',
    options: [
      'Confiscation du fonds de commerce destiné à l’hébergement ayant servi à commettre l’infraction',
      'Interdiction automatique de territoire',
      'Annulation automatique de tous contrats',
    ],
    answer:
        'Confiscation du fonds de commerce destiné à l’hébergement ayant servi à commettre l’infraction',
    explanation:
        'Le cours mentionne la confiscation du fonds de commerce destiné à l’hébergement et ayant servi à commettre l’infraction.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Travail non ou insuffisamment rémunéré — Qualification',
    question:
        'Le non-respect du SMIC suffit-il à caractériser l’article 225-13 CP ?',
    options: ['Non', 'Oui', 'Uniquement en cas de récidive'],
    answer: 'Non',
    explanation:
        'Le non-respect du SMIC ne suffit pas : il faut une disproportion manifeste.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Travail non ou insuffisamment rémunéré — Tentative',
    question: 'La tentative de l’infraction prévue à l’article 225-13 CP est :',
    options: ['Non punissable', 'Punissable', 'Une contravention'],
    answer: 'Non punissable',
    explanation: 'La tentative n’est pas prévue par le texte.',
    difficulty: 'Difficile',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizDiginitePersonnePA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName = '/pa/crimes_personne/quiz/dignite_personne';
  final String uid;
  final String email;

  const QuizDiginitePersonnePA({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizDiginitePersonnePA> createState() => _QuizDiginitePersonnePAState();
}

class _QuizDiginitePersonnePAState extends State<QuizDiginitePersonnePA>
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
  static const _introHiddenKey = 'intro_pa_dignite_personne';
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
        ? questionDignitePersonnePart1
        : questionDignitePersonnePart1
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
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Crimes & délits contre la personne',
            'quiz_name': 'Atteinte à la dignité',
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
      await _sb.from('quiz_dignite_personne').insert({
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
      debugPrint('❌ quiz_dignite_personne insert failed: $e');
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
      'source_file': 'pa_quiz_dignite_personne',
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
                            icon: Icons.sentiment_satisfied_rounded,
                            title: 'Dignité de la personne',
                            description: 'Étudie les infractions portant atteinte à la dignité humaine : traite des êtres humains, proxénétisme, conditions de travail indignes.',
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
