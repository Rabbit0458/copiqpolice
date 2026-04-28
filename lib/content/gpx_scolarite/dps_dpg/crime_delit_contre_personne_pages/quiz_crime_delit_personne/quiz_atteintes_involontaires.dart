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

final List<QuizQuestion> questionAtteinteInvolontaire = [
  QuizQuestion(
    category: 'Groupement violent — Fondement',
    question:
        'La participation à un groupement violent est définie et réprimée par :',
    options: [
      'L’article 222-14-2 du Code pénal',
      'L’article 222-14-1 du Code pénal',
      'L’article 450-1 du Code pénal',
    ],
    answer: 'L’article 222-14-2 du Code pénal',
    explanation:
        'Le cours précise que l’article 222-14-2 CP définit et réprime la participation à un groupement violent.',
    difficulty: 'Facile',
  ),
  // =========================================================
  // ATTEINTES INVOLONTAIRES — CONTRAVENTIONS — ITT ≤ 3 MOIS
  // =========================================================
  QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Fondement',
    question:
        'Les atteintes involontaires avec ITT ≤ 3 mois, hors délits, sont prévues par :',
    options: [
      'Les articles R. 625-2, R. 625-3 et R. 622-1 du Code pénal',
      'L’article 222-20-1 du Code pénal',
      'L’article 221-6 du Code pénal',
    ],
    answer: 'Les articles R. 625-2, R. 625-3 et R. 622-1 du Code pénal',
    explanation:
        'Le cours précise que les atteintes involontaires contraventionnelles relèvent des articles R. 625-2, R. 625-3 et R. 622-1 CP.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Faute',
    question: 'En matière contraventionnelle, la faute exigée est :',
    options: [
      'Une faute d’imprudence simple',
      'Une faute intentionnelle',
      'Une faute lourde uniquement',
    ],
    answer: 'Une faute d’imprudence simple',
    explanation:
        'Les contraventions reposent sur une faute simple d’imprudence ou de négligence.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteintes involontaires — Contravention — ITT',
    question: 'Pour l’article R. 625-2 du CP, la victime doit avoir subi :',
    options: ['Une ITT ≤ 3 mois', 'Une ITT > 3 mois', 'Aucune atteinte'],
    answer: 'Une ITT ≤ 3 mois',
    explanation:
        'L’article R. 625-2 CP vise une ITT inférieure ou égale à trois mois.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Violation délibérée',
    question: 'L’article R. 625-3 CP réprime :',
    options: [
      'La violation manifestement délibérée d’une obligation de sécurité sans ITT',
      'Toute imprudence simple',
      'Les violences volontaires',
    ],
    answer:
        'La violation manifestement délibérée d’une obligation de sécurité sans ITT',
    explanation:
        'R. 625-3 CP vise l’atteinte sans ITT en cas de violation manifestement délibérée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Tentative',
    question: 'La tentative d’atteinte involontaire contraventionnelle est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable uniquement en récidive',
    ],
    answer: 'Non punissable',
    explanation:
        'La tentative n’est jamais punissable en matière contraventionnelle.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // ATTEINTES INVOLONTAIRES — ITT > 3 MOIS — art. 222-19 CP
  // =========================================================
  QuizQuestion(
    category: 'Atteintes involontaires — ITT > 3 mois — Fondement',
    question:
        'Les atteintes involontaires avec ITT > 3 mois sont prévues par :',
    options: [
      'L’article 222-19 alinéa 1 du Code pénal',
      'L’article 222-20-1 du Code pénal',
      'L’article R. 625-2 du Code pénal',
    ],
    answer: 'L’article 222-19 alinéa 1 du Code pénal',
    explanation:
        'L’article 222-19 CP définit les blessures involontaires avec ITT supérieure à trois mois.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteintes involontaires — ITT > 3 mois — Élément matériel',
    question: 'L’élément matériel repose sur :',
    options: [
      'Une faute non intentionnelle',
      'Une volonté de blesser',
      'Une préméditation',
    ],
    answer: 'Une faute non intentionnelle',
    explanation:
        'Il s’agit d’une infraction non intentionnelle fondée sur une faute.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteintes involontaires — ITT > 3 mois — Causalité indirecte',
    question: 'En cas de causalité indirecte, la responsabilité exige :',
    options: [
      'Une faute caractérisée ou délibérée',
      'Une faute quelconque',
      'Aucune faute',
    ],
    answer: 'Une faute caractérisée ou délibérée',
    explanation:
        'L’article 121-3 CP impose une faute caractérisée ou délibérée en causalité indirecte.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteintes involontaires — ITT > 3 mois — Complicité',
    question: 'La complicité en matière d’atteintes involontaires est :',
    options: [
      'Exclue par la jurisprudence',
      'Toujours punissable',
      'Punissable uniquement pour les personnes morales',
    ],
    answer: 'Exclue par la jurisprudence',
    explanation:
        'La jurisprudence exclut la complicité en matière d’infractions non intentionnelles.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // VIOLATION MANIFESTEMENT DÉLIBÉRÉE — art. 222-20 CP
  // =========================================================
  QuizQuestion(
    category: 'Violation délibérée — Fondement',
    question:
        'La violation manifestement délibérée d’une obligation de sécurité est prévue par :',
    options: [
      'L’article 222-20 du Code pénal',
      'L’article 222-19 du Code pénal',
      'L’article R. 625-2 du Code pénal',
    ],
    answer: 'L’article 222-20 du Code pénal',
    explanation:
        'L’article 222-20 CP vise les blessures involontaires par violation délibérée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation délibérée — Élément moral',
    question: 'La violation délibérée suppose :',
    options: [
      'La connaissance de l’obligation et la volonté de la transgresser',
      'Une simple négligence',
      'Une ignorance totale',
    ],
    answer: 'La connaissance de l’obligation et la volonté de la transgresser',
    explanation:
        'L’auteur doit connaître l’obligation et choisir délibérément de ne pas la respecter.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation délibérée — Tentative',
    question: 'La tentative de violation délibérée est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable uniquement en cas de récidive',
    ],
    answer: 'Non punissable',
    explanation:
        'Le résultat dommageable étant involontaire, la tentative n’est pas retenue.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // VIOLENCES VOLONTAIRES — art. 222-7 et s.
  // =========================================================
  QuizQuestion(
    category: 'Violences volontaires — Définition',
    question: 'Les violences volontaires sont :',
    options: [
      'Des atteintes intentionnelles à l’intégrité physique ou psychique',
      'Des fautes d’imprudence',
      'Des omissions involontaires',
    ],
    answer: 'Des atteintes intentionnelles à l’intégrité physique ou psychique',
    explanation:
        'Les violences supposent un acte volontaire affectant l’intégrité d’autrui.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Acte matériel',
    question: 'L’acte matériel des violences suppose :',
    options: ['Un acte positif', 'Une simple abstention', 'Un accident'],
    answer: 'Un acte positif',
    explanation: 'Les violences nécessitent une action positive de l’auteur.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Violence psychologique',
    question: 'Les violences psychologiques sont :',
    options: [
      'Pénalement réprimées',
      'Exclues du Code pénal',
      'Uniquement civiles',
    ],
    answer: 'Pénalement réprimées',
    explanation:
        'L’article 222-14-3 CP reconnaît les violences psychologiques.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Tentative',
    question: 'La tentative de violences volontaires est :',
    options: [
      'En principe non retenue',
      'Toujours punissable',
      'Punissable uniquement en contravention',
    ],
    answer: 'En principe non retenue',
    explanation:
        'Les textes relatifs aux violences délictuelles ne visent pas la tentative.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // HOMICIDE INVOLONTAIRE — art. 221-6 CP
  // =========================================================
  QuizQuestion(
    category: 'Homicide involontaire — Fondement',
    question: 'L’homicide involontaire est prévu par :',
    options: [
      'L’article 221-6 du Code pénal',
      'L’article 222-19 du Code pénal',
      'L’article 221-1 du Code pénal',
    ],
    answer: 'L’article 221-6 du Code pénal',
    explanation:
        'L’article 221-6 CP définit et réprime l’homicide involontaire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Élément matériel',
    question: 'L’homicide involontaire suppose :',
    options: ['La mort d’autrui', 'Une ITT', 'Une mutilation'],
    answer: 'La mort d’autrui',
    explanation: 'Le résultat exigé est le décès de la victime.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Tentative',
    question: 'La tentative d’homicide involontaire est :',
    options: [
      'Impossible et non punissable',
      'Punissable',
      'Punissable uniquement en récidive',
    ],
    answer: 'Impossible et non punissable',
    explanation:
        'Le résultat n’étant pas voulu, la tentative n’est pas concevable.',
    difficulty: 'Facile',
  ),
  // =========================================================
  // NIVEAU CONCOURS — CONTRAVENTIONS ITT ≤ 3 MOIS (R. 622-1 / R. 625-2 / R. 625-3)
  // =========================================================
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — Distinction',
    question: 'L’article R. 622-1 du CP réprime principalement :',
    options: [
      'Une atteinte involontaire sans ITT (ou ITT non caractérisée)',
      'Une atteinte involontaire avec ITT > 3 mois',
      'Une violence volontaire avec ITT > 8 jours',
    ],
    answer: 'Une atteinte involontaire sans ITT (ou ITT non caractérisée)',
    explanation:
        'Le cours rattache R. 622-1 aux atteintes involontaires sans ITT (contravention de 2e classe).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — Classe',
    question:
        'L’infraction prévue à l’article R. 622-1 du CP est une contravention de :',
    options: ['2ème classe', '4ème classe', '5ème classe'],
    answer: '2ème classe',
    explanation: 'Le cours indique : R. 622-1 = contravention de 2e classe.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — ITT consécutive',
    question: 'Selon le cours, l’ITT ≤ 3 mois (R. 625-2) s’apprécie :',
    options: [
      'Sur une ITT consécutive (pas par addition de périodes)',
      'Par addition de périodes discontinues',
      'Uniquement sur la douleur déclarée',
    ],
    answer: 'Sur une ITT consécutive (pas par addition de périodes)',
    explanation:
        'Le cours précise que l’ITT doit être consécutive et non une addition de périodes.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — Faute listée',
    question:
        'Pour retenir R. 625-2 (ou R. 625-3), les juges doivent caractériser :',
    options: [
      'Un des comportements fautifs limitativement énumérés',
      'Une intention de nuire',
      'Une préméditation',
    ],
    answer: 'Un des comportements fautifs limitativement énumérés',
    explanation:
        'Le cours insiste : la liste des fautes (maladresse, imprudence, inattention, négligence, manquement) est limitative.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — Manquement',
    question:
        'Le “manquement à une obligation de sécurité ou de prudence” suppose :',
    options: [
      'La violation d’une obligation prévue par la loi ou le règlement',
      'La violation d’une simple recommandation morale',
      'La violation d’une coutume locale',
    ],
    answer: 'La violation d’une obligation prévue par la loi ou le règlement',
    explanation:
        'Le cours précise que l’obligation doit être imposée par la loi ou le règlement (actes administratifs généraux et impersonnels).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — Élément moral',
    question:
        'En matière contraventionnelle d’atteintes involontaires, l’élément moral est :',
    options: [
      'Non exigé',
      'Toujours exigé',
      'Exigé uniquement en causalité directe',
    ],
    answer: 'Non exigé',
    explanation:
        'Le cours précise : l’élément moral n’est pas requis en matière contraventionnelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — Aggravation',
    question: 'R. 625-3 constitue :',
    options: [
      'L’aggravation de R. 622-1 en cas de violation manifestement délibérée',
      'L’aggravation de 222-19',
      'Une circonstance aggravante des violences volontaires',
    ],
    answer:
        'L’aggravation de R. 622-1 en cas de violation manifestement délibérée',
    explanation:
        'Le cours indique que R. 625-3 (5e classe) aggrave R. 622-1 (2e classe) en cas de violation manifestement délibérée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — Responsabilité personnes morales',
    question:
        'La responsabilité pénale des personnes morales pour ces contraventions est prévue par :',
    options: [
      'Les articles R. 625-5 et R. 622-1 al. 3',
      'L’article 222-21 uniquement',
      'Elle est exclue en contravention',
    ],
    answer: 'Les articles R. 625-5 et R. 622-1 al. 3',
    explanation:
        'Le cours mentionne expressément R. 625-5 et R. 622-1 al. 3 pour les personnes morales.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — Complicité',
    question:
        'La complicité d’atteintes involontaires contraventionnelles est :',
    options: [
      'Non retenue',
      'Toujours retenue',
      'Retenue seulement par provocation',
    ],
    answer: 'Non retenue',
    explanation:
        'Le cours précise : “COMPLICITÉ : NON” pour les contraventions d’atteintes involontaires.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NIVEAU CONCOURS — ITT > 3 MOIS (222-19) + AGGRAVATIONS (222-19-1 / 222-19-2 / 434-10)
  // =========================================================
  QuizQuestion(
    category: 'ITT > 3 mois — Seuil',
    question: 'Le délit de l’article 222-19 al.1 suppose une ITT :',
    options: [
      'Strictement supérieure à trois mois',
      'Inférieure ou égale à trois mois',
      'Inférieure à huit jours',
    ],
    answer: 'Strictement supérieure à trois mois',
    explanation:
        'Le cours vise explicitement l’ITT “pendant plus de trois mois” pour 222-19 al.1.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'ITT > 3 mois — Circonstance aggravante (222-19 al.2)',
    question: 'L’article 222-19 al.2 aggrave lorsque l’infraction résulte :',
    options: [
      'D’une violation manifestement délibérée d’une obligation particulière imposée par la loi ou le règlement',
      'D’une simple maladresse',
      'D’un cas de force majeure',
    ],
    answer:
        'D’une violation manifestement délibérée d’une obligation particulière imposée par la loi ou le règlement',
    explanation:
        'Le cours : 222-19 al.2 = aggravation par violation manifestement délibérée d’une obligation particulière.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'ITT > 3 mois — Obligation particulière',
    question:
        'La circonstance aggravante de violation délibérée ne peut pas résulter :',
    options: [
      'D’une circulaire ou d’un règlement intérieur d’entreprise',
      'D’un décret',
      'D’un arrêté',
    ],
    answer: 'D’une circulaire ou d’un règlement intérieur d’entreprise',
    explanation:
        'Le cours précise : la violation délibérée d’une circulaire ou d’un règlement intérieur ne constitue pas l’aggravation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'ITT > 3 mois — Aggravation conducteur (structure)',
    question: 'Les aggravations “conducteur VTM” sont structurées par :',
    options: [
      'L’article 222-19-1 du Code pénal (3 degrés)',
      'L’article 222-20-1 du Code pénal',
      'L’article R. 625-2 du Code pénal',
    ],
    answer: 'L’article 222-19-1 du Code pénal (3 degrés)',
    explanation:
        'Le cours : 222-19-1 CP prévoit trois degrés d’aggravation pour le conducteur.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'ITT > 3 mois — Aggravation conducteur (2e degré)',
    question:
        'Au 2e degré (222-19-1), peut notamment constituer une circonstance :',
    options: [
      'Le délit de fuite',
      'Le port de la ceinture',
      'Le stationnement régulier',
    ],
    answer: 'Le délit de fuite',
    explanation:
        'Le cours énumère, au 2e degré, des délits routiers dont le délit de fuite.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'ITT > 3 mois — Aggravation conducteur (3e degré)',
    question: 'Le 3e degré (222-19-1) correspond :',
    options: [
      'À la réunion de deux ou plusieurs circonstances du 2e degré',
      'À une seule circonstance',
      'À l’absence de toute circonstance',
    ],
    answer: 'À la réunion de deux ou plusieurs circonstances du 2e degré',
    explanation:
        'Le cours : 3e degré = cumul de deux (ou +) circonstances listées au 2e degré.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'ITT > 3 mois — Chien (structure)',
    question:
        'Les aggravations liées à une agression commise par un chien relèvent de :',
    options: [
      'L’article 222-19-2 du Code pénal',
      'L’article 222-20-2 du Code pénal',
      'L’article 221-6-2 du Code pénal',
    ],
    answer: 'L’article 222-19-2 du Code pénal',
    explanation:
        'Le cours : 222-19-2 CP = aggravations “blessures involontaires” liées à l’agression par un chien.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'ITT > 3 mois — Délit de fuite (hors conducteur)',
    question:
        'Selon le cours, l’aggravation “délit de fuite” (hors 222-19-1) est rattachée à :',
    options: [
      'L’article 434-10 du Code pénal',
      'L’article 222-20-1 du Code pénal',
      'L’article 221-6 du Code pénal',
    ],
    answer: 'L’article 434-10 du Code pénal',
    explanation:
        'Le cours mentionne 434-10 CP pour le délit de fuite, hors cas prévus par 222-19-1.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'ITT > 3 mois — Causalité directe',
    question: 'La causalité est dite “directe” lorsque l’auteur :',
    options: [
      'A frappé/heurté la victime ou a initié/contrôlé le mouvement de l’objet causal',
      'S’est seulement abstenu de prévenir un risque',
      'N’a aucun lien avec le dommage',
    ],
    answer:
        'A frappé/heurté la victime ou a initié/contrôlé le mouvement de l’objet causal',
    explanation:
        'Le cours reprend l’idée de causalité immédiate (frapper/heurté ou contrôler le mouvement d’un objet causal).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'ITT > 3 mois — Causalité indirecte',
    question: 'Sont auteurs indirects (121-3 al.4) ceux qui :',
    options: [
      'Ont créé/contribué à créer la situation ayant permis le dommage ou n’ont pas pris les mesures pour l’éviter',
      'Ont uniquement porté secours après l’accident',
      'N’étaient jamais liés à la situation dangereuse',
    ],
    answer:
        'Ont créé/contribué à créer la situation ayant permis le dommage ou n’ont pas pris les mesures pour l’éviter',
    explanation:
        'Le cours cite la définition légale des auteurs indirects : création de la situation ou omission de mesures permettant d’éviter le dommage.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — VIOLATION MANIFESTEMENT DÉLIBÉRÉE (222-20) + COMPLICITÉ
  // =========================================================
  QuizQuestion(
    category: 'Violation délibérée — Source de l’obligation',
    question:
        'L’obligation particulière de prudence ou de sécurité doit être prévue par :',
    options: [
      'Un texte (loi, décret ou arrêté)',
      'Une simple habitude professionnelle',
      'Un avis non contraignant',
    ],
    answer: 'Un texte (loi, décret ou arrêté)',
    explanation:
        'Le cours exige une obligation “particulière” prévue par un texte normatif (loi/décret/arrêté).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation délibérée — Exclusion (jurisprudence)',
    question:
        'Selon le cours, ne constitue pas une obligation particulière au sens de 222-20 :',
    options: [
      'Un arrêté préfectoral déclarant un immeuble insalubre et imposant des travaux',
      'Un arrêté imposant le port d’un équipement obligatoire',
      'Un décret fixant une règle de sécurité',
    ],
    answer:
        'Un arrêté préfectoral déclarant un immeuble insalubre et imposant des travaux',
    explanation:
        'Le cours cite l’exemple jurisprudentiel : l’arrêté préfectoral “immeuble insalubre” ne suffit pas.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation délibérée — Élément moral (précision)',
    question: 'La violation manifestement délibérée implique que l’auteur :',
    options: [
      'Connaît l’obligation et fait le choix délibéré de ne pas la respecter',
      'Ignore l’obligation et agit par erreur',
      'Cherche le dommage',
    ],
    answer:
        'Connaît l’obligation et fait le choix délibéré de ne pas la respecter',
    explanation:
        'Le cours : le dommage n’est pas voulu, mais le risque est assumé, avec connaissance de l’obligation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation délibérée — Complicité',
    question:
        'Contrairement aux infractions non intentionnelles “pures”, la complicité est admise pour 222-20 car :',
    options: [
      'Il s’agit d’une faute délibérée',
      'Il s’agit d’une contravention',
      'L’ITT est toujours nulle',
    ],
    answer: 'Il s’agit d’une faute délibérée',
    explanation:
        'Le cours : la complicité est possible car 222-20 repose sur une violation délibérée (faute délibérée).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation délibérée — Exemple complicité (cours)',
    question:
        'Selon le cours, un exemple de complicité par instigation pourrait être :',
    options: [
      'Un passager ordonnant au chauffeur de franchir un feu rouge',
      'Un témoin appelant les secours',
      'Un usager respectant la signalisation',
    ],
    answer: 'Un passager ordonnant au chauffeur de franchir un feu rouge',
    explanation:
        'Le cours illustre la complicité par instigation : le passager qui ordonne un comportement risqué.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation délibérée — Chien (222-20-2)',
    question: 'Les circonstances aggravantes “chien” pour 222-20 relèvent de :',
    options: [
      'L’article 222-20-2 du Code pénal',
      'L’article 222-19-2 du Code pénal',
      'L’article 221-6-2 du Code pénal',
    ],
    answer: 'L’article 222-20-2 du Code pénal',
    explanation:
        'Le cours : 222-20-2 CP prévoit trois degrés d’aggravation en cas d’agression par un chien.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NIVEAU CONCOURS — VIOLENCES VOLONTAIRES (R.624-1 / R.625-1 / 222-11 / 222-13 / 222-12 / 222-9 / 222-7)
  // =========================================================
  QuizQuestion(
    category: 'Violences volontaires — Contravention (aucune ITT)',
    question:
        'Les violences volontaires n’ayant entraîné aucune ITT relèvent de :',
    options: [
      'L’article R. 624-1 du Code pénal',
      'L’article R. 625-2 du Code pénal',
      'L’article 222-19 du Code pénal',
    ],
    answer: 'L’article R. 624-1 du Code pénal',
    explanation:
        'Le cours : R. 624-1 CP vise les violences contraventionnelles sans ITT (4e classe).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Contravention (ITT ≤ 8 jours)',
    question: 'Les violences volontaires avec ITT ≤ 8 jours relèvent de :',
    options: [
      'L’article R. 625-1 du Code pénal',
      'L’article R. 625-2 du Code pénal',
      'L’article 222-11 du Code pénal',
    ],
    answer: 'L’article R. 625-1 du Code pénal',
    explanation:
        'Le cours : R. 625-1 CP = violences contraventionnelles avec ITT ≤ 8 jours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Délit (ITT > 8 jours)',
    question:
        'Les violences volontaires délictuelles de base (ITT > 8 jours) sont prévues par :',
    options: [
      'L’article 222-11 du Code pénal',
      'L’article 222-13 du Code pénal',
      'L’article 222-19 du Code pénal',
    ],
    answer: 'L’article 222-11 du Code pénal',
    explanation:
        'Le cours : 222-11 CP réprime les violences délictuelles (ITT > 8 jours).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Violences psychologiques',
    question: 'Les violences peuvent être constituées :',
    options: [
      'Même sans atteinte physique, si elles causent un choc émotif/trouble psychologique',
      'Uniquement en cas de coups physiques',
      'Uniquement si une arme est utilisée',
    ],
    answer:
        'Même sans atteinte physique, si elles causent un choc émotif/trouble psychologique',
    explanation:
        'Le cours cite la jurisprudence : acte de nature à impressionner vivement et causer un choc émotif.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Preuve du résultat',
    question: 'La réalité du dommage des violences est notamment établie par :',
    options: [
      'Un certificat médical',
      'Un simple ressenti sans constat',
      'Une rumeur',
    ],
    answer: 'Un certificat médical',
    explanation:
        'Le cours indique que l’atteinte doit être établie, notamment par certificat médical.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences volontaires — 222-13 (logique)',
    question: 'L’article 222-13 du CP concerne principalement :',
    options: [
      'Les violences (ITT ≤ 8 jours ou aucune ITT) en présence de circonstances aggravantes',
      'Les blessures involontaires',
      'L’homicide involontaire',
    ],
    answer:
        'Les violences (ITT ≤ 8 jours ou aucune ITT) en présence de circonstances aggravantes',
    explanation:
        'Le cours : 222-13 = violences “faible ITT” aggravées (plusieurs degrés).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Réunion vs “avec mineur”',
    question:
        'Selon la circulaire citée par le cours, si un majeur agit avec l’aide d’un mineur, il est préférable de retenir pour le majeur :',
    options: [
      'La circonstance “majeur avec aide/assistance d’un mineur” plutôt que la réunion',
      'La récidive',
      'L’amnistie',
    ],
    answer:
        'La circonstance “majeur avec aide/assistance d’un mineur” plutôt que la réunion',
    explanation:
        'Le cours rapporte la recommandation de la circulaire : privilégier cette circonstance pour le majeur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Violences volontaires — Complicité contraventionnelle (exception)',
    question:
        'En matière contraventionnelle, une exception permet de punir l’aide/assistance pour violences via :',
    options: [
      'Les articles R. 625-1 et R. 624-1 du Code pénal',
      'L’article 121-6 uniquement',
      'Aucune exception n’existe',
    ],
    answer: 'Les articles R. 625-1 et R. 624-1 du Code pénal',
    explanation:
        'Le cours précise : aide/assistance punie des mêmes peines en contravention de violences (R. 624-1 / R. 625-1).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Tentative',
    question: 'Selon le cours, la tentative des violences délictuelles est :',
    options: [
      'Non visée par les textes, donc en pratique non retenue',
      'Toujours punissable',
      'Punissable uniquement si ITT ≤ 8 jours',
    ],
    answer: 'Non visée par les textes, donc en pratique non retenue',
    explanation:
        'Le cours : les textes relatifs aux violences délictuelles ne visent pas la tentative.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — HOMICIDE INVOLONTAIRE (221-6 / 221-6-1 / 221-6-2 / 434-10)
  // =========================================================
  QuizQuestion(
    category: 'Homicide involontaire — Définition (faute)',
    question: 'L’homicide involontaire suppose une mort causée notamment par :',
    options: [
      'Maladresse, imprudence, inattention, négligence ou manquement à une obligation',
      'Une intention de tuer',
      'Une préméditation',
    ],
    answer:
        'Maladresse, imprudence, inattention, négligence ou manquement à une obligation',
    explanation:
        'Le cours reprend la liste des cinq comportements fautifs renvoyant à 121-3 CP.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Causalité (principe)',
    question: 'Pour 221-6, la causalité exigée :',
    options: [
      'N’a pas à être directe et immédiate, mais doit être certaine',
      'Doit toujours être immédiate',
      'Peut être seulement hypothétique',
    ],
    answer: 'N’a pas à être directe et immédiate, mais doit être certaine',
    explanation:
        'Le cours : pas besoin d’un lien direct et immédiat, il suffit que le lien soit certain.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Violation délibérée (aggravation)',
    question:
        'L’aggravation de 221-6 al.2 est retenue lorsque la mort résulte :',
    options: [
      'D’une violation manifestement délibérée d’une obligation particulière de prudence ou de sécurité',
      'D’un simple oubli sans texte applicable',
      'D’une contrainte irrésistible',
    ],
    answer:
        'D’une violation manifestement délibérée d’une obligation particulière de prudence ou de sécurité',
    explanation:
        'Le cours : 221-6 al.2 aggrave en cas de violation manifestement délibérée d’une obligation particulière.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Conducteur (structure)',
    question: 'Les trois degrés d’aggravation “conducteur VTM” relèvent de :',
    options: [
      'L’article 221-6-1 du Code pénal',
      'L’article 222-19-1 du Code pénal',
      'L’article 221-6 al.1 uniquement',
    ],
    answer: 'L’article 221-6-1 du Code pénal',
    explanation:
        'Le cours : 221-6-1 CP structure l’aggravation en trois degrés pour le conducteur.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Conducteur (3e degré)',
    question: 'Le 3e degré (221-6-1) est constitué lorsque :',
    options: [
      'Deux ou plus des circonstances du 2e degré sont réunies',
      'Une seule circonstance est retenue',
      'Aucune circonstance n’est retenue',
    ],
    answer: 'Deux ou plus des circonstances du 2e degré sont réunies',
    explanation:
        'Le cours : 3e degré = cumul de deux (ou plus) circonstances mentionnées au 2e degré.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Chien (structure)',
    question:
        'Les aggravations liées à une agression commise par un chien relèvent de :',
    options: [
      'L’article 221-6-2 du Code pénal',
      'L’article 222-19-2 du Code pénal',
      'L’article 222-20-2 du Code pénal',
    ],
    answer: 'L’article 221-6-2 du Code pénal',
    explanation:
        'Le cours : 221-6-2 CP = aggravations d’homicide involontaire en cas d’agression par un chien.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Délit de fuite (hors conducteur)',
    question:
        'Selon le cours, l’aggravation “délit de fuite” (hors 221-6-1) est rattachée à :',
    options: [
      'L’article 434-10 du Code pénal',
      'L’article 221-6 al.2 du Code pénal',
      'L’article 222-20-1 du Code pénal',
    ],
    answer: 'L’article 434-10 du Code pénal',
    explanation:
        'Le cours cite 434-10 CP lorsque l’homicide involontaire est suivi d’un délit de fuite (hors cas 221-6-1).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Complicité',
    question: 'La complicité en matière d’homicide involontaire est :',
    options: [
      'Exclue par la jurisprudence',
      'Toujours punissable',
      'Punissable uniquement par aide et assistance',
    ],
    answer: 'Exclue par la jurisprudence',
    explanation:
        'Le cours précise : la jurisprudence exclut la complicité en matière d’infractions non intentionnelles.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Personnes morales',
    question:
        'La responsabilité pénale des personnes morales pour l’homicide involontaire est prévue par :',
    options: [
      'L’article 221-7 du Code pénal',
      'L’article 221-6-1 du Code pénal',
      'Elle est exclue',
    ],
    answer: 'L’article 221-7 du Code pénal',
    explanation:
        'Le cours : 221-7 CP prévoit la responsabilité pénale des personnes morales.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — R. 625-2 (objet)',
    question: 'L’article R. 625-2 du CP vise :',
    options: [
      'Une atteinte involontaire causant une ITT ≤ 3 mois',
      'Une violence volontaire causant une ITT > 8 jours',
      'Un homicide involontaire',
    ],
    answer: 'Une atteinte involontaire causant une ITT ≤ 3 mois',
    explanation:
        'Le cours : R. 625-2 réprime les atteintes involontaires avec ITT ≤ 3 mois (contravention de 5e classe).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — R. 625-2 (classe)',
    question: 'La qualification de l’article R. 625-2 du CP est :',
    options: [
      'Contravention de 5ème classe',
      'Contravention de 2ème classe',
      'Délit',
    ],
    answer: 'Contravention de 5ème classe',
    explanation: 'Le cours classe R. 625-2 en contravention de 5e classe.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — Source de l’obligation',
    question:
        'Pour un manquement à une obligation de prudence ou de sécurité, le “règlement” s’entend :',
    options: [
      'Des actes administratifs généraux et impersonnels',
      'D’une consigne orale',
      'D’une simple note interne sans portée normative',
    ],
    answer: 'Des actes administratifs généraux et impersonnels',
    explanation:
        'Le cours précise que le “règlement” vise les actes des autorités administratives à caractère général et impersonnel.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Contraventions ITT ≤ 3 mois — Exigence de précision (Cass. crim.)',
    question:
        'En cas de manquement à une obligation textuelle, les magistrats doivent :',
    options: [
      'Préciser la source et la nature exacte de l’obligation violée',
      'Se contenter d’évoquer un devoir général de prudence',
      'Écarter toute référence aux textes',
    ],
    answer: 'Préciser la source et la nature exacte de l’obligation violée',
    explanation:
        'Le cours rappelle l’exigence : identifier précisément l’obligation (Cass. crim., 18 juin 2002).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — Lien de causalité',
    question:
        'Pour retenir une atteinte involontaire contraventionnelle, il faut :',
    options: [
      'Un lien de causalité entre la faute et l’atteinte',
      'Une intention de nuire',
      'Une préméditation',
    ],
    answer: 'Un lien de causalité entre la faute et l’atteinte',
    explanation:
        'Le cours insiste sur la nécessité d’un lien de causalité entre la faute et le dommage, même en matière contraventionnelle.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — Causalité immédiate',
    question:
        'Selon la circulaire citée, la causalité directe (immédiate) correspond notamment à :',
    options: [
      'Heurter/frapper la victime ou contrôler le mouvement de l’objet ayant heurté',
      'Constater l’accident après coup',
      'Ne rien faire mais être présent',
    ],
    answer:
        'Heurter/frapper la victime ou contrôler le mouvement de l’objet ayant heurté',
    explanation:
        'Le cours reprend la définition fonctionnelle : action directe sur la victime ou sur l’objet causal.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — Dommage psychique',
    question: 'Dans les atteintes involontaires, le dommage peut être :',
    options: [
      'Physique ou psychique (ex : choc émotionnel)',
      'Uniquement physique',
      'Uniquement matériel',
    ],
    answer: 'Physique ou psychique (ex : choc émotionnel)',
    explanation:
        'Le cours précise qu’un choc émotionnel peut constituer le résultat d’une atteinte involontaire à l’intégrité de la personne.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Contraventions ITT ≤ 3 mois — Tentative',
    question:
        'La tentative d’atteintes involontaires contraventionnelles est :',
    options: [
      'Non envisageable / non punissable',
      'Toujours punissable',
      'Punissable seulement si ITT = 0',
    ],
    answer: 'Non envisageable / non punissable',
    explanation:
        'Le cours : tentative non retenue (résultat non recherché et pas de texte).',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NIVEAU CONCOURS — ITT > 3 MOIS (222-19) : FAUTE / CAUSALITÉ / AGGRAVATIONS
  // =========================================================
  QuizQuestion(
    category: 'ITT > 3 mois — Faute simple (liste)',
    question: 'La faute simple de 222-19 renvoie à cinq comportements, dont :',
    options: [
      'Maladresse, imprudence, inattention, négligence, manquement',
      'Provocation, préméditation, guet-apens',
      'Recel, extorsion, escroquerie',
    ],
    answer: 'Maladresse, imprudence, inattention, négligence, manquement',
    explanation:
        'Le cours reprend la liste limitative issue de 121-3 et visée par 222-19.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'ITT > 3 mois — Faute caractérisée (condition)',
    question:
        'En causalité indirecte, pour engager une personne physique, il faut notamment :',
    options: [
      'Une faute délibérée ou une faute caractérisée',
      'Une faute quelconque suffit toujours',
      'Aucune faute n’est exigée',
    ],
    answer: 'Une faute délibérée ou une faute caractérisée',
    explanation:
        'Le cours rappelle : en causalité indirecte (personnes physiques), la responsabilité requiert une faute délibérée ou caractérisée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'ITT > 3 mois — Faute caractérisée (définition concours)',
    question: 'La faute caractérisée est :',
    options: [
      'Une imprudence lourde exposant autrui à un danger grave, dont l’auteur ne pouvait ignorer les risques',
      'Une simple distraction sans conséquence',
      'Un acte volontaire de violence',
    ],
    answer:
        'Une imprudence lourde exposant autrui à un danger grave, dont l’auteur ne pouvait ignorer les risques',
    explanation:
        'Le cours définit la faute caractérisée comme une faute lourde, grossière, exposant à un danger d’une particulière gravité.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'ITT > 3 mois — Pluralité de fautes',
    question:
        'Quand plusieurs fautes concourent au dommage, le lien de causalité :',
    options: [
      'Peut être retenu dès lors que la faute a concouru au dommage',
      'Est automatiquement exclu',
      'Exige l’identification d’un auteur unique',
    ],
    answer: 'Peut être retenu dès lors que la faute a concouru au dommage',
    explanation:
        'Le cours : “la faute a concouru au dommage” et la pluralité d’auteurs n’exclut pas la causalité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'ITT > 3 mois — Dommage dans son dernier état',
    question:
        'Selon le cours, la chambre criminelle prend en compte le dommage :',
    options: [
      'Dans son dernier état (aggravations comprises)',
      'Uniquement au moment exact du choc',
      'Uniquement si l’état ne s’aggrave pas',
    ],
    answer: 'Dans son dernier état (aggravations comprises)',
    explanation:
        'Le cours indique que le dommage peut s’aggraver et est apprécié dans son dernier état.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'ITT > 3 mois — Personnes morales (principe)',
    question:
        'Selon le cours, les personnes morales sont pénalement responsables des infractions non intentionnelles :',
    options: [
      'Que le dommage soit direct ou indirect, dès lors qu’une faute d’un organe/représentant a entraîné l’atteinte',
      'Uniquement en causalité directe',
      'Jamais (principe d’irresponsabilité)',
    ],
    answer:
        'Que le dommage soit direct ou indirect, dès lors qu’une faute d’un organe/représentant a entraîné l’atteinte',
    explanation:
        'Le cours rappelle que la responsabilité des personnes morales demeure engagée en toute hypothèse (direct/indirect).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — BLESSURES INVOLONTAIRES CONDUCTEUR (ITT ≤ 3 MOIS : 222-20-1)
  // =========================================================
  QuizQuestion(
    category: 'Conducteur ITT ≤ 3 mois — Base légale',
    question:
        'Les atteintes involontaires (ITT ≤ 3 mois) commises par un conducteur VTM relèvent de :',
    options: [
      'L’article 222-20-1 du Code pénal',
      'L’article 222-19 du Code pénal',
      'L’article R. 625-2 du Code pénal',
    ],
    answer: 'L’article 222-20-1 du Code pénal',
    explanation:
        'Le cours : 222-20-1 CP vise les blessures involontaires par conducteur avec ITT ≤ 3 mois.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Conducteur ITT ≤ 3 mois — Visée préventive',
    question:
        'L’incrimination liée au “groupement violent” a une visée préventive ; pour 222-20-1, la logique principale est plutôt :',
    options: [
      'Réprimer une faute de conduite ayant causé une ITT ≤ 3 mois',
      'Réprimer une intention de tuer',
      'Réprimer une association de malfaiteurs',
    ],
    answer: 'Réprimer une faute de conduite ayant causé une ITT ≤ 3 mois',
    explanation:
        'Le cours distingue : 222-20-1 sanctionne le dommage (ITT) causé par une faute du conducteur.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Conducteur ITT ≤ 3 mois — 1er degré d’aggravation (liste)',
    question:
        'Selon le cours, une circonstance du 1er degré (222-20-1) est notamment :',
    options: [
      'État alcoolique caractérisé ou refus des vérifications',
      'Port de lunettes',
      'Véhicule propre',
    ],
    answer: 'État alcoolique caractérisé ou refus des vérifications',
    explanation:
        'Le cours énumère parmi les circonstances : alcool (ou refus de vérification).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Conducteur ITT ≤ 3 mois — 1er degré (stupéfiants)',
    question: 'Au 1er degré, est aussi visée la situation où :',
    options: [
      'Une analyse révèle l’usage de stupéfiants ou le conducteur refuse les vérifications',
      'Le conducteur est fatigué sans infraction',
      'Le conducteur est simplement stressé',
    ],
    answer:
        'Une analyse révèle l’usage de stupéfiants ou le conducteur refuse les vérifications',
    explanation:
        'Le cours vise l’usage de stupéfiants ou le refus des vérifications prévues par le code de la route.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Conducteur ITT ≤ 3 mois — 1er degré (permis)',
    question: 'Constitue une circonstance (222-20-1) :',
    options: [
      'Absence de permis exigé ou permis annulé/invalidé/suspendu/retenu',
      'Être titulaire du permis',
      'Avoir une assurance à jour',
    ],
    answer: 'Absence de permis exigé ou permis annulé/invalidé/suspendu/retenu',
    explanation:
        'Le cours mentionne explicitement l’absence de permis ou les situations d’annulation/invalidation/suspension/retrait.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Conducteur ITT ≤ 3 mois — 2e degré',
    question: 'Le 2e degré d’aggravation correspond :',
    options: [
      'À la réunion d’au moins deux circonstances listées',
      'À une seule circonstance',
      'À l’absence de circonstances',
    ],
    answer: 'À la réunion d’au moins deux circonstances listées',
    explanation:
        'Le cours : 2e degré = deux (ou plus) des circonstances prévues au 1° à 7°.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Conducteur ITT ≤ 3 mois — Complicité',
    question: 'Pour 222-20-1 (conducteur ITT ≤ 3 mois), la complicité est :',
    options: ['Non', 'Oui', 'Uniquement en contravention'],
    answer: 'Non',
    explanation:
        'Le cours indique : “COMPLICITÉ : NON” pour 222-20-1, infraction non intentionnelle.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — VIOLENCES VOLONTAIRES : ÉLÉMENTS CONSTITUTIFS / AGGRAVATIONS
  // =========================================================
  QuizQuestion(
    category: 'Violences volontaires — Élément matériel',
    question: 'Les violences volontaires supposent :',
    options: [
      'Un acte positif (la simple abstention ne suffit pas)',
      'Une abstention uniquement',
      'Une simple pensée',
    ],
    answer: 'Un acte positif (la simple abstention ne suffit pas)',
    explanation:
        'Le cours : les violences supposent une action positive ; l’abstention relève d’autres qualifications.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Contact indirect',
    question: 'Le contact avec la victime peut être :',
    options: [
      'Indirect (arme, objet, animal excité par l’auteur)',
      'Obligatoirement direct (main/corps)',
      'Exclusivement verbal',
    ],
    answer: 'Indirect (arme, objet, animal excité par l’auteur)',
    explanation:
        'Le cours précise que la violence peut être réalisée par un moyen, même sans contact direct.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Élément moral',
    question: 'L’élément moral des violences volontaires est :',
    options: [
      'La conscience de commettre un acte affectant l’intégrité physique/psychique d’autrui',
      'L’absence totale de volonté',
      'La simple maladresse',
    ],
    answer:
        'La conscience de commettre un acte affectant l’intégrité physique/psychique d’autrui',
    explanation:
        'Le cours : violences = acte intentionnel, avec conscience du préjudice possible.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Mobile',
    question:
        'Selon le cours (jurisprudence), les violences sont constituées :',
    options: [
      'Quel que soit le mobile, dès lors qu’il existe un acte volontaire dirigé contre autrui',
      'Seulement si le mobile est haineux',
      'Seulement si le mobile est financier',
    ],
    answer:
        'Quel que soit le mobile, dès lors qu’il existe un acte volontaire dirigé contre autrui',
    explanation:
        'Le cours rappelle l’idée jurisprudentielle : le mobile n’empêche pas la constitution de l’infraction.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences volontaires — 222-12 vs 222-13',
    question: 'Dans le cours, 222-12 concerne principalement :',
    options: [
      'Les violences avec ITT > 8 jours (aggravées)',
      'Les violences sans ITT',
      'Les blessures involontaires ITT ≤ 3 mois',
    ],
    answer: 'Les violences avec ITT > 8 jours (aggravées)',
    explanation:
        'Le cours : 222-12 organise les aggravations lorsque l’ITT dépasse 8 jours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences volontaires — 222-7 (qualification)',
    question:
        'Les violences ayant entraîné la mort sans intention de la donner relèvent de :',
    options: [
      'L’article 222-7 du Code pénal',
      'L’article 221-6 du Code pénal',
      'L’article 222-11 du Code pénal',
    ],
    answer: 'L’article 222-7 du Code pénal',
    explanation:
        'Le cours indique : 222-7 CP réprime les violences ayant entraîné la mort sans intention de la donner.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences volontaires — 222-9 (qualification)',
    question:
        'Les violences ayant entraîné une mutilation ou une infirmité permanente relèvent de :',
    options: [
      'L’article 222-9 du Code pénal',
      'L’article 222-19 du Code pénal',
      'L’article R. 625-1 du Code pénal',
    ],
    answer: 'L’article 222-9 du Code pénal',
    explanation:
        'Le cours : 222-9 CP vise la mutilation ou l’infirmité permanente.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — HOMICIDE INVOLONTAIRE : FAUTE / CAUSALITÉ / AGGRAVATIONS
  // =========================================================
  QuizQuestion(
    category: 'Homicide involontaire — Base légale',
    question: 'L’homicide involontaire est prévu et réprimé par :',
    options: [
      'L’article 221-6 du Code pénal',
      'L’article 222-7 du Code pénal',
      'L’article 222-14-2 du Code pénal',
    ],
    answer: 'L’article 221-6 du Code pénal',
    explanation:
        'Le cours : 221-6 CP définit et réprime l’homicide involontaire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Faute simple (appréciation)',
    question: 'Les fautes d’imprudence simples sont appréciées par rapport :',
    options: [
      'Au comportement d’un individu normalement prudent/diligent (ou du professionnel diligent)',
      'Au comportement de la victime',
      'À une appréciation purement subjective de l’auteur',
    ],
    answer:
        'Au comportement d’un individu normalement prudent/diligent (ou du professionnel diligent)',
    explanation:
        'Le cours : référence à “l’homme normalement prudent” et, le cas échéant, au professionnel moyen/diligent.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Causalité indirecte (définition)',
    question: 'En causalité indirecte, l’auteur est celui qui :',
    options: [
      'A créé/contribué à créer la situation ayant permis le dommage ou n’a pas pris les mesures pour l’éviter',
      'A porté le coup mortel',
      'A appelé les secours',
    ],
    answer:
        'A créé/contribué à créer la situation ayant permis le dommage ou n’a pas pris les mesures pour l’éviter',
    explanation:
        'Le cours reprend la définition légale de l’auteur indirect (121-3 al.4).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Homicide involontaire — Causalité directe (paramètre déterminant)',
    question: 'Selon le cours, la causalité directe peut inclure :',
    options: [
      'Un comportement paramètre déterminant de la survenance du dommage, même sans être le geste matériel',
      'Uniquement l’auteur matériel du choc',
      'Uniquement l’auteur indirect',
    ],
    answer:
        'Un comportement paramètre déterminant de la survenance du dommage, même sans être le geste matériel',
    explanation:
        'Le cours indique que la chambre criminelle retient une conception large : paramètre déterminant du dommage.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Violation délibérée (preuve)',
    question: 'Pour retenir 221-6 al.2, il faut notamment établir :',
    options: [
      'Une obligation particulière précisément déterminée, prévue par un texte, violée consciemment',
      'Une simple imprudence sans texte',
      'Une intention homicide',
    ],
    answer:
        'Une obligation particulière précisément déterminée, prévue par un texte, violée consciemment',
    explanation:
        'Le cours : obligation prévue par un texte, précisément déterminée, et violation consciente créant un risque mortel réalisé.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Tentative',
    question: 'La tentative d’homicide involontaire est :',
    options: [
      'Non (résultat non souhaité)',
      'Oui (toujours)',
      'Oui seulement en causalité indirecte',
    ],
    answer: 'Non (résultat non souhaité)',
    explanation:
        'Le cours : la tentative n’est pas envisageable car le résultat dommageable n’est pas voulu.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Complicité',
    question:
        'Selon le cours, la complicité en matière d’homicide involontaire est :',
    options: [
      'Exclue (non)',
      'Toujours retenue',
      'Possible uniquement pour les personnes morales',
    ],
    answer: 'Exclue (non)',
    explanation:
        'Le cours indique : “COMPLICITÉ : NON” pour l’homicide involontaire (infraction non intentionnelle).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Aggravation (conducteur)',
    question:
        'L’article 221-6-1 prévoit une aggravation lorsque l’homicide involontaire est commis :',
    options: [
      'Par le conducteur d’un véhicule terrestre à moteur',
      'Par un témoin',
      'Par un mineur de 13 ans',
    ],
    answer: 'Par le conducteur d’un véhicule terrestre à moteur',
    explanation:
        'Le cours : 221-6-1 organise les aggravations spécifiques liées au conducteur VTM.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — 221-6-1 (2e degré)',
    question:
        'Au 2e degré de 221-6-1, l’homicide involontaire est aggravé notamment si :',
    options: [
      'Il s’accompagne d’un délit routier (alcool/stupéfiants/refus/permis/délit de fuite/excès ≥ 50 km/h)',
      'Le conducteur avait un passager',
      'Le véhicule était en leasing',
    ],
    answer:
        'Il s’accompagne d’un délit routier (alcool/stupéfiants/refus/permis/délit de fuite/excès ≥ 50 km/h)',
    explanation:
        'Le cours liste les délits routiers déclenchant le 2e degré d’aggravation (221-6-1).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — 221-6-1 (3e degré)',
    question: 'Le 3e degré d’aggravation (221-6-1) correspond :',
    options: [
      'À la réunion d’au moins deux circonstances du 2e degré',
      'À une seule circonstance',
      'À l’absence de circonstances',
    ],
    answer: 'À la réunion d’au moins deux circonstances du 2e degré',
    explanation:
        'Le cours : 3e degré = deux ou plus des circonstances mentionnées au 2e degré.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — 221-6-2 (chien)',
    question:
        'L’article 221-6-2 vise l’aggravation lorsque l’homicide involontaire résulte :',
    options: [
      'D’une agression commise par un chien',
      'D’un tir à l’arme à feu',
      'D’une bagarre volontaire',
    ],
    answer: 'D’une agression commise par un chien',
    explanation:
        'Le cours : 221-6-2 prévoit des degrés d’aggravation liés à l’agression par un chien.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — 221-6-2 (2e degré)',
    question: 'Au 2e degré de 221-6-2, l’aggravation peut être retenue si :',
    options: [
      'Le propriétaire/détenteur est en ivresse manifeste ou sous emprise stupéfiants',
      'Le chien est tatoué',
      'Le chien est de petite taille',
    ],
    answer:
        'Le propriétaire/détenteur est en ivresse manifeste ou sous emprise stupéfiants',
    explanation:
        'Le cours cite parmi les situations aggravantes : ivresse manifeste ou emprise de stupéfiants du propriétaire/détenteur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Délit de fuite (434-10)',
    question:
        'Le cours indique une aggravation spécifique lorsque l’homicide involontaire est suivi :',
    options: [
      'D’un délit de fuite (article 434-10, hors cas 221-6-1)',
      'D’une déclaration sur les réseaux sociaux',
      'D’une main courante',
    ],
    answer: 'D’un délit de fuite (article 434-10, hors cas 221-6-1)',
    explanation:
        'Le cours mentionne l’article 434-10 pour le délit de fuite (sauf lorsqu’on est déjà dans le cadre 221-6-1).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // VIOLATION MANIFESTEMENT DÉLIBÉRÉE — 222-20 (ITT ≤ 3 MOIS)
  // =========================================================
  QuizQuestion(
    category: 'Violation délibérée (ITT ≤ 3 mois) — Base légale',
    question:
        'Les atteintes involontaires par violation manifestement délibérée (ITT ≤ 3 mois) relèvent de :',
    options: [
      'L’article 222-20 du Code pénal',
      'L’article 222-20-1 du Code pénal',
      'L’article R. 625-3 du Code pénal',
    ],
    answer: 'L’article 222-20 du Code pénal',
    explanation:
        'Le cours : l’infraction délictuelle de violation manifestement délibérée (ITT ≤ 3 mois) est prévue par 222-20.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation délibérée (ITT ≤ 3 mois) — Obligation particulière',
    question:
        'L’obligation particulière de prudence/sécurité doit être prévue par :',
    options: [
      'Un texte (loi, décret ou arrêté)',
      'Un simple usage professionnel',
      'Une rumeur locale',
    ],
    answer: 'Un texte (loi, décret ou arrêté)',
    explanation:
        'Le cours : obligation particulière = prévue par un texte (loi/décret/arrêté) ; le “règlement” = actes administratifs généraux.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation délibérée (ITT ≤ 3 mois) — Connaissance',
    question: 'Pour retenir la violation délibérée, il faut que la personne :',
    options: [
      'Ait connaissance de l’obligation spécifique (formation/fonctions/compétences)',
      'Ignore totalement l’obligation',
      'Soit seulement de bonne foi',
    ],
    answer:
        'Ait connaissance de l’obligation spécifique (formation/fonctions/compétences)',
    explanation:
        'Le cours : la personne doit avoir connaissance de l’obligation, notamment via son rôle/formation/responsabilités.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation délibérée (ITT ≤ 3 mois) — Volonté',
    question: 'La violation manifestement délibérée implique :',
    options: [
      'Un choix délibéré de ne pas respecter l’obligation (le dommage n’est pas voulu)',
      'Un dommage voulu',
      'Une simple inadvertance',
    ],
    answer:
        'Un choix délibéré de ne pas respecter l’obligation (le dommage n’est pas voulu)',
    explanation:
        'Le cours : le risque est assumé, le dommage n’est pas recherché, mais l’obligation est sciemment transgressée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation délibérée (ITT ≤ 3 mois) — Complicité',
    question: 'Pour 222-20, la complicité est :',
    options: [
      'Oui (punissable)',
      'Non (exclue)',
      'Uniquement en contravention',
    ],
    answer: 'Oui (punissable)',
    explanation:
        'Le cours précise que malgré la nature non intentionnelle, la faute délibérée n’exclut pas la complicité (121-6/121-7).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation délibérée (ITT ≤ 3 mois) — Exemple concours',
    question:
        'Le cours donne comme exemple possible de complicité par instigation :',
    options: [
      'Un passager ordonnant à son chauffeur de franchir un feu rouge',
      'Un passager qui dort',
      'Un témoin qui appelle les secours',
    ],
    answer: 'Un passager ordonnant à son chauffeur de franchir un feu rouge',
    explanation:
        'Le cours illustre : une instigation peut constituer complicité car il s’agit d’une faute délibérée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation délibérée (ITT ≤ 3 mois) — Chien (222-20-2)',
    question:
        'L’article 222-20-2 prévoit des degrés d’aggravation lorsque l’atteinte résulte :',
    options: [
      'D’une agression commise par un chien',
      'D’une collision ferroviaire',
      'D’un vol à l’étalage',
    ],
    answer: 'D’une agression commise par un chien',
    explanation:
        'Le cours : 222-20-2 organise l’aggravation des blessures (222-20) en cas d’agression par un chien.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // VIOLENCES VOLONTAIRES — CONTRAVENTIONNELLES / DÉLICTUELLES (R. 624-1, R. 625-1, 222-11, 222-13)
  // =========================================================
  QuizQuestion(
    category: 'Violences volontaires — Contravention (aucune ITT)',
    question: 'Les violences volontaires sans ITT relèvent notamment de :',
    options: [
      'L’article R. 624-1 du Code pénal',
      'L’article 222-11 du Code pénal',
      'L’article 221-6 du Code pénal',
    ],
    answer: 'L’article R. 624-1 du Code pénal',
    explanation:
        'Le cours : R. 624-1 définit/réprime les violences contraventionnelles sans ITT.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Contravention (ITT ≤ 8 jours)',
    question:
        'Les violences volontaires avec ITT ≤ 8 jours relèvent notamment de :',
    options: [
      'L’article R. 625-1 du Code pénal',
      'L’article 222-12 du Code pénal',
      'L’article 222-20 du Code pénal',
    ],
    answer: 'L’article R. 625-1 du Code pénal',
    explanation:
        'Le cours : R. 625-1 vise les violences contraventionnelles avec ITT ≤ 8 jours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Délit (base)',
    question: 'Les violences délictuelles sont définies et réprimées par :',
    options: [
      'L’article 222-11 du Code pénal',
      'L’article R. 624-1 du Code pénal',
      'L’article 221-6 du Code pénal',
    ],
    answer: 'L’article 222-11 du Code pénal',
    explanation:
        'Le cours : 222-11 CP vise les violences délictuelles (ITT > 8 jours ou hypothèses prévues).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Aggravation (ITT ≤ 8 jours)',
    question:
        'Les violences avec ITT ≤ 8 jours ou sans ITT sont aggravées par :',
    options: [
      'L’article 222-13 du Code pénal',
      'L’article 222-12 du Code pénal',
      'L’article 222-9 du Code pénal',
    ],
    answer: 'L’article 222-13 du Code pénal',
    explanation:
        'Le cours : 222-13 prévoit trois degrés d’aggravation pour ITT ≤ 8 jours ou aucune ITT.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences volontaires — 222-13 (degrés)',
    question: 'Selon le cours, 222-13 prévoit :',
    options: ['Trois degrés d’aggravation', 'Un seul degré', 'Cinq degrés'],
    answer: 'Trois degrés d’aggravation',
    explanation:
        'Le cours mentionne explicitement “trois degrés d’aggravation” pour 222-13.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // PARTICIPATION À UN GROUPEMENT VIOLENT — 222-14-2 (niveau concours)
  // =========================================================
  QuizQuestion(
    category: 'Groupement violent — Base légale',
    question:
        'La participation à un groupement violent est définie et réprimée par :',
    options: [
      'L’article 222-14-2 du Code pénal',
      'L’article 222-14-3 du Code pénal',
      'L’article 226-10 du Code pénal',
    ],
    answer: 'L’article 222-14-2 du Code pénal',
    explanation:
        'Le cours : 222-14-2 CP définit et réprime la participation à un groupement violent.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Groupement violent — Condition (préparation)',
    question:
        'L’infraction vise la participation à un groupement en vue de la préparation :',
    options: [
      'Caractérisée par un ou plusieurs faits matériels',
      'Uniquement supposée sans indice',
      'Déjà consommée (violences réalisées)',
    ],
    answer: 'Caractérisée par un ou plusieurs faits matériels',
    explanation:
        'Le cours insiste : préparation “caractérisée” par des faits matériels (barres de fer, cagoules, messages, etc.).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Groupement violent — Résultat nécessaire ?',
    question: 'Pour 222-14-2, la réalisation des violences/dégradations :',
    options: [
      'N’est pas nécessaire',
      'Est indispensable',
      'Transforme l’infraction en crime automatiquement',
    ],
    answer: 'N’est pas nécessaire',
    explanation:
        'Le cours : l’objectif est de démanteler avant commission, donc la réalisation n’est pas exigée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Groupement violent — Participation brève',
    question:
        'Le cours précise que la participation peut être caractérisée même si elle est :',
    options: [
      'Brève (simple présence + intégration au groupement)',
      'Longue (au moins plusieurs jours)',
      'Formalement déclarée',
    ],
    answer: 'Brève (simple présence + intégration au groupement)',
    explanation:
        'Le cours : la simple présence suffit si la personne participe au groupement (intégration), même brièvement.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Groupement violent — Élément moral',
    question:
        'L’élément moral de la participation à un groupement violent suppose que l’auteur :',
    options: [
      'Participe sciemment en ayant connaissance des faits de préparation',
      'Soit simplement présent sans aucune connaissance',
      'Ignore totalement l’objet du groupement',
    ],
    answer:
        'Participe sciemment en ayant connaissance des faits de préparation',
    explanation:
        'Le cours précise que l’auteur doit participer sciemment et avoir connaissance des faits matériels préparatoires.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Groupement violent — Connaissance indirecte',
    question: 'La connaissance des faits de préparation peut résulter :',
    options: [
      'Des faits accomplis par d’autres membres du groupement',
      'Uniquement des faits personnellement accomplis',
      'Uniquement d’aveux',
    ],
    answer: 'Des faits accomplis par d’autres membres du groupement',
    explanation:
        'La jurisprudence admet que l’auteur ait connaissance de faits matériels réalisés par d’autres.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Groupement violent — Qualification',
    question: 'La participation à un groupement violent est classée comme :',
    options: ['Un délit', 'Une contravention', 'Un crime'],
    answer: 'Un délit',
    explanation: 'Le cours qualifie l’infraction de “simple délit”.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Groupement violent — Tentative',
    question: 'La tentative de participation à un groupement violent est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable uniquement en récidive',
    ],
    answer: 'Non punissable',
    explanation:
        'La tentative n’est pas punissable faute de disposition expresse en matière correctionnelle.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Groupement violent — Complicité',
    question:
        'La complicité en matière de participation à un groupement violent est :',
    options: ['Punissable', 'Exclue', 'Limitée aux personnes morales'],
    answer: 'Punissable',
    explanation:
        'Le cours indique expressément : “COMPLICITÉ : OUI” (articles 121-6 et 121-7 CP).',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // RÉCAP NIVEAU CONCOURS — DISTINCTIONS ESSENTIELLES
  // =========================================================
  QuizQuestion(
    category: 'Synthèse concours — Faute simple',
    question: 'La faute simple se distingue principalement par :',
    options: [
      'L’absence d’intention de nuire',
      'La volonté de provoquer le dommage',
      'La préméditation',
    ],
    answer: 'L’absence d’intention de nuire',
    explanation:
        'La faute simple repose sur une imprudence, maladresse, inattention ou négligence.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Synthèse concours — Faute caractérisée',
    question: 'La faute caractérisée suppose notamment :',
    options: [
      'Une exposition d’autrui à un danger d’une particulière gravité',
      'Une simple erreur minime',
      'Une ignorance totale du risque',
    ],
    answer: 'Une exposition d’autrui à un danger d’une particulière gravité',
    explanation:
        'Le cours définit la faute caractérisée comme une imprudence lourde et grossière.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Synthèse concours — Causalité directe',
    question:
        'La causalité directe est retenue lorsque le comportement de l’auteur :',
    options: [
      'Est essentiel et déterminant dans la survenance du dommage',
      'Est simplement accessoire',
      'N’a aucun lien avec le dommage',
    ],
    answer: 'Est essentiel et déterminant dans la survenance du dommage',
    explanation:
        'La chambre criminelle adopte une conception large de la causalité directe.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Synthèse concours — Causalité indirecte',
    question: 'En causalité indirecte, l’auteur est celui qui :',
    options: [
      'A créé ou contribué à créer la situation dangereuse',
      'A porté le coup matériel',
      'Est seulement témoin',
    ],
    answer: 'A créé ou contribué à créer la situation dangereuse',
    explanation: 'Définition issue de l’article 121-3 al.4 du Code pénal.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Synthèse concours — Infractions non intentionnelles',
    question: 'Les infractions non intentionnelles se caractérisent par :',
    options: [
      'Un résultat dommageable non voulu',
      'Une intention criminelle',
      'Une préméditation systématique',
    ],
    answer: 'Un résultat dommageable non voulu',
    explanation:
        'Le résultat n’est pas recherché par l’auteur, ce qui exclut la tentative.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Synthèse concours — Tentative (principe)',
    question:
        'En matière d’infractions non intentionnelles, la tentative est :',
    options: [
      'En principe exclue',
      'Toujours punissable',
      'Punissable uniquement pour les personnes morales',
    ],
    answer: 'En principe exclue',
    explanation:
        'Le résultat n’étant pas voulu, la tentative n’est pas retenue.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Synthèse concours — Complicité (principe)',
    question: 'La complicité est en principe :',
    options: [
      'Exclue pour les infractions non intentionnelles',
      'Toujours retenue',
      'Obligatoire',
    ],
    answer: 'Exclue pour les infractions non intentionnelles',
    explanation:
        'Principe jurisprudentiel, avec exception notable en cas de faute délibérée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Synthèse concours — Exception complicité',
    question:
        'Une exception à l’exclusion de la complicité existe notamment lorsque :',
    options: [
      'L’infraction repose sur une faute délibérée',
      'Il s’agit d’une simple imprudence',
      'Le dommage est léger',
    ],
    answer: 'L’infraction repose sur une faute délibérée',
    explanation:
        'Le cours souligne l’exception en matière de violation manifestement délibérée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Synthèse concours — Personnes morales',
    question:
        'En matière d’infractions non intentionnelles, les personnes morales :',
    options: [
      'Peuvent voir leur responsabilité pénale engagée',
      'Sont toujours irresponsables',
      'Ne sont responsables qu’en cas d’intention',
    ],
    answer: 'Peuvent voir leur responsabilité pénale engagée',
    explanation:
        'Le cours rappelle que les personnes morales restent pénalement responsables même en causalité indirecte.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Synthèse concours — Logique générale',
    question: 'La logique générale des atteintes involontaires est de :',
    options: [
      'Sanctionner un comportement fautif ayant causé un dommage',
      'Réprimer une intention de nuire',
      'Punir une simple présence',
    ],
    answer: 'Sanctionner un comportement fautif ayant causé un dommage',
    explanation:
        'Toute la matière repose sur la faute, le dommage et le lien de causalité.',
    difficulty: 'Facile',
  ),
  // =========================================================
  // NIVEAU CONCOURS — CAS PRATIQUES & PIÈGES FRÉQUENTS
  // =========================================================
  QuizQuestion(
    category: 'Cas pratique concours — ITT ≤ 3 mois',
    question:
        'Un agent municipal oublie de signaler un trou sur la voie publique. Un piéton chute et subit une ITT de 2 mois. La qualification la plus adaptée est :',
    options: [
      'Atteinte involontaire contraventionnelle (R. 625-2 CP)',
      'Violence volontaire',
      'Homicide involontaire',
    ],
    answer: 'Atteinte involontaire contraventionnelle (R. 625-2 CP)',
    explanation:
        'Faute d’imprudence/négligence + ITT ≤ 3 mois = contravention R. 625-2.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique concours — ITT > 3 mois',
    question:
        'Un chef de chantier omet de sécuriser une tranchée. Un ouvrier chute et subit une ITT de 5 mois. La qualification pénale est :',
    options: [
      'Blessures involontaires (222-19 CP)',
      'Contravention R. 625-2',
      'Violences volontaires',
    ],
    answer: 'Blessures involontaires (222-19 CP)',
    explanation:
        'Faute non intentionnelle + ITT > 3 mois = délit de blessures involontaires (222-19).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique concours — Causalité indirecte',
    question:
        'Un maire n’instaure aucune règle de sécurité sur une piste dangereuse. Un accident survient. Le maire est qualifié :',
    options: ['Auteur indirect', 'Auteur direct', 'Complice'],
    answer: 'Auteur indirect',
    explanation:
        'Il a contribué à créer la situation dangereuse sans être l’auteur matériel.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Cas pratique concours — Faute caractérisée',
    question:
        'Confier volontairement les clés d’un véhicule à une personne ivre et sans permis constitue :',
    options: [
      'Une faute caractérisée',
      'Une simple imprudence',
      'Une absence de faute',
    ],
    answer: 'Une faute caractérisée',
    explanation:
        'Jurisprudence constante : exposition consciente à un danger grave.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Cas pratique concours — Violation délibérée',
    question:
        'Un conducteur franchit volontairement un feu rouge connu comme dangereux. Un piéton est blessé (ITT 1 mois). Qualification :',
    options: [
      'Violation manifestement délibérée (222-20 CP)',
      'Contravention simple',
      'Violences volontaires',
    ],
    answer: 'Violation manifestement délibérée (222-20 CP)',
    explanation:
        'Obligation connue + choix délibéré de la violer + ITT ≤ 3 mois.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Cas pratique concours — Complicité exceptionnelle',
    question:
        'Un passager ordonne au conducteur de forcer un barrage, causant des blessures involontaires par violation délibérée. Le passager est :',
    options: ['Complice', 'Non responsable', 'Auteur principal'],
    answer: 'Complice',
    explanation:
        'Exception : la faute délibérée permet la complicité (instigation).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — DISTINCTIONS FINES & QCM SÉLECTIFS
  // =========================================================
  QuizQuestion(
    category: 'QCM concours — ITT',
    question: 'L’ITT s’apprécie :',
    options: [
      'Sur une période continue, sans addition de périodes',
      'En additionnant toutes les périodes',
      'Uniquement le jour des faits',
    ],
    answer: 'Sur une période continue, sans addition de périodes',
    explanation: 'Le cours précise que l’ITT n’est pas cumulative.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'QCM concours — Dommage psychique',
    question: 'Un choc émotionnel sans lésion physique peut constituer :',
    options: [
      'Un dommage pénalement pris en compte',
      'Un dommage uniquement civil',
      'Aucun dommage',
    ],
    answer: 'Un dommage pénalement pris en compte',
    explanation: 'Le dommage peut être psychique (atteinte à l’intégrité).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'QCM concours — Infractions non intentionnelles',
    question: 'Quel élément est toujours exigé ?',
    options: ['Un dommage', 'Une intention', 'Une préméditation'],
    answer: 'Un dommage',
    explanation:
        'Sans dommage, l’infraction non intentionnelle n’est pas constituée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'QCM concours — Violences psychologiques',
    question: 'Les violences psychologiques sont constituées lorsque :',
    options: [
      'Les agissements impressionnent vivement et causent un choc émotif',
      'Il n’y a aucun trouble',
      'Il n’y a pas de contact physique',
    ],
    answer: 'Les agissements impressionnent vivement et causent un choc émotif',
    explanation: 'Cass. crim. + codification à l’article 222-14-3 CP.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'QCM concours — Violences volontaires',
    question: 'Les violences volontaires supposent nécessairement :',
    options: [
      'La conscience d’atteindre l’intégrité d’autrui',
      'Une ITT',
      'Une arme',
    ],
    answer: 'La conscience d’atteindre l’intégrité d’autrui',
    explanation:
        'L’intention porte sur l’acte, pas nécessairement sur le résultat.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NIVEAU CONCOURS — QUESTIONS DE SYNTHÈSE RAPIDE
  // =========================================================
  QuizQuestion(
    category: 'Synthèse — Contravention vs Délit',
    question:
        'La distinction principale entre contravention et délit d’atteintes involontaires repose sur :',
    options: [
      'La durée de l’ITT',
      'La qualité de l’auteur',
      'Le lieu des faits',
    ],
    answer: 'La durée de l’ITT',
    explanation: '≤ 3 mois : contravention / > 3 mois : délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Synthèse — Auteur indirect',
    question: 'Un auteur indirect est celui qui :',
    options: [
      'Crée la situation dangereuse sans être l’auteur matériel',
      'Porte le coup',
      'Intervient après les faits',
    ],
    answer: 'Crée la situation dangereuse sans être l’auteur matériel',
    explanation: 'Définition issue de l’article 121-3 al.4 CP.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Synthèse — Logique préventive',
    question:
        'Certaines infractions (ex : groupement violent) ont une logique principalement :',
    options: ['Préventive', 'Répressive a posteriori uniquement', 'Civile'],
    answer: 'Préventive',
    explanation:
        'Elles permettent d’intervenir avant la commission des violences.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Synthèse — Tentative',
    question:
        'Pourquoi la tentative est-elle exclue en matière non intentionnelle ?',
    options: [
      'Parce que le résultat n’est pas voulu',
      'Parce que la peine est faible',
      'Parce que la victime survit',
    ],
    answer: 'Parce que le résultat n’est pas voulu',
    explanation: 'Principe fondamental rappelé dans tout le cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Synthèse — Concours',
    question: 'Au concours, les questions pièges portent le plus souvent sur :',
    options: [
      'Les distinctions faute simple/faute caractérisée/violation délibérée',
      'Les définitions générales',
      'Les dates',
    ],
    answer:
        'Les distinctions faute simple/faute caractérisée/violation délibérée',
    explanation:
        'Ces distinctions conditionnent la responsabilité et la qualification.',
    difficulty: 'Moyenne',
  ),
  // =========================================================
  // NIVEAU CONCOURS — PIÈGES JURISPRUDENTIELS & FORMULATIONS SUBTILES
  // =========================================================
  QuizQuestion(
    category: 'Jurisprudence concours — Causalité large',
    question:
        'Selon la chambre criminelle, la causalité directe peut être retenue lorsque le comportement de l’auteur :',
    options: [
      'A été un paramètre déterminant du dommage',
      'Est simplement concomitant',
      'Est postérieur au dommage',
    ],
    answer: 'A été un paramètre déterminant du dommage',
    explanation:
        'La Cour adopte une conception large : même sans geste matériel, le comportement peut être déterminant.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Jurisprudence concours — Auteur direct sans geste',
    question:
        'Un supérieur hiérarchique peut être auteur direct d’une infraction non intentionnelle même s’il n’a pas accompli le geste matériel si :',
    options: [
      'Il a manqué à une obligation essentielle et déterminante',
      'Il était absent',
      'Il a donné une consigne écrite',
    ],
    answer: 'Il a manqué à une obligation essentielle et déterminante',
    explanation:
        'Jurisprudence : le manquement déterminant peut suffire à caractériser l’auteur direct.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Jurisprudence concours — Personne morale',
    question:
        'Pour engager la responsabilité pénale d’une personne morale, il faut :',
    options: [
      'Une faute de ses organes ou représentants',
      'Une faute de la victime',
      'Une intention criminelle',
    ],
    answer: 'Une faute de ses organes ou représentants',
    explanation: 'Principe issu des articles 121-2 et suivants du Code pénal.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Jurisprudence concours — ITT et certificat',
    question:
        'La réalité de l’atteinte dans les violences est généralement établie par :',
    options: [
      'Un certificat médical',
      'Un témoignage unique',
      'Une main courante',
    ],
    answer: 'Un certificat médical',
    explanation:
        'Le certificat médical permet d’établir l’ITT et la matérialité du dommage.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — COMPARAISONS CLASSIQUES
  // =========================================================
  QuizQuestion(
    category: 'Comparaison — Violences / Atteintes involontaires',
    question:
        'La différence essentielle entre violences volontaires et atteintes involontaires tient à :',
    options: ['L’intention', 'Le dommage', 'La victime'],
    answer: 'L’intention',
    explanation:
        'Les violences supposent un acte intentionnel, les atteintes involontaires non.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparaison — Faute simple / Faute délibérée',
    question: 'La faute délibérée se distingue de la faute simple par :',
    options: [
      'La conscience et la volonté de violer une obligation',
      'La seule négligence',
      'L’absence de texte',
    ],
    answer: 'La conscience et la volonté de violer une obligation',
    explanation:
        'La faute délibérée implique un choix conscient de transgresser une obligation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Comparaison — Faute caractérisée / Faute délibérée',
    question:
        'La faute caractérisée se distingue de la faute délibérée en ce que :',
    options: [
      'Elle expose autrui à un danger grave sans volonté de violer une obligation précise',
      'Elle suppose toujours un texte violé',
      'Elle implique une intention de nuire',
    ],
    answer:
        'Elle expose autrui à un danger grave sans volonté de violer une obligation précise',
    explanation:
        'La faute caractérisée est lourde et grossière mais pas nécessairement liée à la violation consciente d’un texte.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — QUESTIONS PIÈGES À RÉPONSE UNIQUE
  // =========================================================
  QuizQuestion(
    category: 'Piège concours — Absence de dommage',
    question: 'Sans dommage, une infraction non intentionnelle est :',
    options: ['Inexistante', 'Toujours constituée', 'Une tentative'],
    answer: 'Inexistante',
    explanation: 'Le dommage est un élément constitutif indispensable.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Piège concours — Simple présence',
    question:
        'La simple présence sur les lieux d’un accident suffit à engager la responsabilité pénale pour atteinte involontaire :',
    options: ['Non', 'Oui', 'Uniquement pour les agents publics'],
    answer: 'Non',
    explanation: 'Il faut une faute et un lien de causalité.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Piège concours — Abstention',
    question:
        'Une abstention peut constituer une faute pénale non intentionnelle lorsque :',
    options: [
      'L’auteur n’a pas pris les mesures permettant d’éviter le dommage',
      'Il n’existait aucune obligation',
      'Le dommage est imprévisible',
    ],
    answer: 'L’auteur n’a pas pris les mesures permettant d’éviter le dommage',
    explanation: 'L’abstention fautive est visée par l’article 121-3 al.4.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NIVEAU CONCOURS — MÉMO FINAL (FORMULATIONS EXACTES)
  // =========================================================
  QuizQuestion(
    category: 'Mémo concours — Formule clé',
    question:
        'Quelle formule correspond à la définition de l’auteur indirect ?',
    options: [
      'Celui qui a créé ou contribué à créer la situation ayant permis le dommage',
      'Celui qui a frappé la victime',
      'Celui qui a constaté les faits',
    ],
    answer:
        'Celui qui a créé ou contribué à créer la situation ayant permis le dommage',
    explanation: 'Formulation exacte issue de l’article 121-3 al.4 CP.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mémo concours — Logique pénale',
    question: 'Les infractions non intentionnelles reposent sur le triptyque :',
    options: [
      'Faute – Dommage – Lien de causalité',
      'Intention – Mobile – Résultat',
      'Auteur – Victime – Peine',
    ],
    answer: 'Faute – Dommage – Lien de causalité',
    explanation: 'Structure fondamentale à maîtriser au concours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mémo concours — Objectif',
    question:
        'L’objectif principal de la répression des atteintes involontaires est de :',
    options: [
      'Responsabiliser les comportements à risque',
      'Punir moralement',
      'Réprimer les intentions',
    ],
    answer: 'Responsabiliser les comportements à risque',
    explanation: 'La logique est préventive et responsabilisante.',
    difficulty: 'Facile',
  ),
  // =========================================================
  // NIVEAU CONCOURS — CONFUSIONS FRÉQUENTES AU QCM
  // =========================================================
  QuizQuestion(
    category: 'Confusion concours — Tentative',
    question:
        'La tentative est punissable en matière d’atteintes involontaires à l’intégrité physique :',
    options: ['Jamais', 'Toujours', 'Uniquement en cas de faute caractérisée'],
    answer: 'Jamais',
    explanation:
        'Le résultat dommageable n’étant pas recherché, la tentative n’est pas envisageable.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Confusion concours — Complicité',
    question:
        'En matière d’infractions non intentionnelles, la complicité est en principe :',
    options: ['Exclue', 'Toujours retenue', 'Obligatoire'],
    answer: 'Exclue',
    explanation:
        'La jurisprudence exclut la complicité, sauf cas particuliers de faute délibérée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Confusion concours — Faute et dommage',
    question:
        'Une faute pénale sans dommage permet de retenir une atteinte involontaire :',
    options: ['Non', 'Oui', 'Seulement pour les personnes morales'],
    answer: 'Non',
    explanation: 'Le dommage est un élément constitutif indispensable.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — QUESTIONS À DOUBLE NÉGATION
  // =========================================================
  QuizQuestion(
    category: 'Double négation — Élément moral',
    question:
        'Il n’est pas inexact d’affirmer que l’élément moral est absent en matière d’infractions non intentionnelles :',
    options: ['Oui', 'Non', 'Uniquement en cas de faute simple'],
    answer: 'Oui',
    explanation:
        'L’élément moral n’est pas requis, sauf faute délibérée particulière.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Double négation — Violence',
    question:
        'Il ne peut être exclu que des violences soient constituées sans contact physique :',
    options: ['Oui', 'Non', 'Seulement avec une arme'],
    answer: 'Oui',
    explanation:
        'Les violences psychologiques sont admises par la jurisprudence.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NIVEAU CONCOURS — SCÉNARIOS TYPE QCM
  // =========================================================
  QuizQuestion(
    category: 'Cas pratique — Causalité indirecte',
    question:
        'Un maire n’ayant pas réglementé une activité dangereuse peut être poursuivi sur le fondement de :',
    options: [
      'La causalité indirecte',
      'La causalité directe',
      'La complicité',
    ],
    answer: 'La causalité indirecte',
    explanation:
        'Il a contribué à créer la situation dangereuse sans être l’auteur du geste.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — Conducteur',
    question:
        'Un conducteur en excès de vitesse supérieur à 50 km/h causant une ITT > 3 mois commet :',
    options: [
      'Une atteinte involontaire aggravée',
      'Une contravention',
      'Une infraction intentionnelle',
    ],
    answer: 'Une atteinte involontaire aggravée',
    explanation:
        'L’excès de vitesse ≥ 50 km/h constitue une circonstance aggravante.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NIVEAU CONCOURS — QUESTIONS DE MÉMO JURIDIQUE
  // =========================================================
  QuizQuestion(
    category: 'Mémo concours — Définition exacte',
    question: 'La faute caractérisée est définie comme :',
    options: [
      'Une faute exposant autrui à un danger d’une particulière gravité',
      'Une simple imprudence',
      'Une intention criminelle',
    ],
    answer: 'Une faute exposant autrui à un danger d’une particulière gravité',
    explanation: 'Elle est lourde, grossière et inacceptable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mémo concours — Répression',
    question: 'La qualification des violences dépend principalement :',
    options: ['De l’ITT', 'Du mobile', 'De la plainte'],
    answer: 'De l’ITT',
    explanation:
        'L’ITT conditionne la qualification contraventionnelle, délictuelle ou criminelle.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — QUESTIONS ULTRA PIÈGES
  // =========================================================
  QuizQuestion(
    category: 'Ultra piège — Certitude',
    question: 'Le lien de causalité doit être :',
    options: ['Certain', 'Direct et immédiat', 'Exclusif'],
    answer: 'Certain',
    explanation: 'La causalité n’a pas à être directe ni immédiate.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ultra piège — Personne vivante',
    question: 'Une atteinte involontaire suppose que la victime soit :',
    options: [
      'Vivante au moment des faits',
      'Vivante au jugement',
      'Consciente',
    ],
    answer: 'Vivante au moment des faits',
    explanation: 'La victime doit être une personne humaine vivante.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NIVEAU CONCOURS — FORMULES À SAVOIR PAR CŒUR
  // =========================================================
  QuizQuestion(
    category: 'Formule concours — Cour de cassation',
    question:
        'Selon la Cour de cassation, la causalité directe inclut les comportements qui ont été :',
    options: [
      'Un paramètre déterminant',
      'Un simple contexte',
      'Une conséquence indirecte',
    ],
    answer: 'Un paramètre déterminant',
    explanation: 'Formule jurisprudentielle récurrente.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Formule concours — Responsabilité',
    question:
        'La responsabilité pénale des personnes morales est engagée en cas de :',
    options: ['Faute simple', 'Faute caractérisée uniquement', 'Intention'],
    answer: 'Faute simple',
    explanation:
        'Les personnes morales restent responsables même en causalité indirecte.',
    difficulty: 'Moyenne',
  ),
  // =========================================================
  // NIVEAU CONCOURS — PIÈGES CLASSIQUES DE QUALIFICATION
  // =========================================================
  QuizQuestion(
    category: 'Qualification — ITT',
    question: 'Une ITT de 2 mois causée involontairement relève en principe :',
    options: ['Du délit', 'De la contravention', 'Du crime'],
    answer: 'Du délit',
    explanation:
        'Les atteintes involontaires avec ITT ≤ 3 mois constituent un délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Qualification — ITT',
    question: 'Une atteinte involontaire sans aucune ITT relève en principe :',
    options: ['D’une contravention', 'D’un délit', 'D’un crime'],
    answer: 'D’une contravention',
    explanation: 'Sans ITT, l’infraction est contraventionnelle.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — VIOLATION MANIFESTEMENT DÉLIBÉRÉE
  // =========================================================
  QuizQuestion(
    category: 'Violation délibérée — Définition',
    question: 'La violation manifestement délibérée suppose :',
    options: [
      'La connaissance de l’obligation et le choix de ne pas la respecter',
      'Une simple négligence',
      'Une intention de nuire',
    ],
    answer:
        'La connaissance de l’obligation et le choix de ne pas la respecter',
    explanation:
        'L’auteur connaît l’obligation et décide sciemment de la transgresser.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation délibérée — Texte',
    question:
        'Une obligation issue uniquement d’un règlement intérieur peut fonder une violation délibérée :',
    options: ['Non', 'Oui', 'Seulement pour un professionnel'],
    answer: 'Non',
    explanation:
        'L’obligation doit être prévue par la loi ou le règlement au sens strict.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NIVEAU CONCOURS — CAUSALITÉ (QCM PIÈGES)
  // =========================================================
  QuizQuestion(
    category: 'Causalité — Principe',
    question: 'En matière pénale, le lien de causalité doit être :',
    options: ['Certain', 'Direct et immédiat', 'Exclusif'],
    answer: 'Certain',
    explanation: 'La causalité n’a pas à être directe ni immédiate.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Causalité — Indirecte',
    question: 'Un auteur indirect est celui qui :',
    options: [
      'Crée ou contribue à créer la situation dangereuse',
      'Frappe directement la victime',
      'Est complice',
    ],
    answer: 'Crée ou contribue à créer la situation dangereuse',
    explanation: 'Définition de l’article 121-3 al. 4 du CP.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NIVEAU CONCOURS — CONDUCTEUR DE VÉHICULE
  // =========================================================
  QuizQuestion(
    category: 'Conducteur — Aggravation',
    question: 'Le simple fait d’être conducteur constitue :',
    options: [
      'Une circonstance aggravante légale',
      'Une infraction autonome',
      'Une contravention',
    ],
    answer: 'Une circonstance aggravante légale',
    explanation: 'Le législateur prévoit une aggravation spécifique.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Conducteur — Délit de fuite',
    question: 'Un délit de fuite après blessures involontaires constitue :',
    options: [
      'Une aggravation autonome',
      'Une infraction distincte uniquement',
      'Une contravention',
    ],
    answer: 'Une aggravation autonome',
    explanation: 'L’article 434-10 CP prévoit une aggravation spécifique.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NIVEAU CONCOURS — PERSONNES MORALES
  // =========================================================
  QuizQuestion(
    category: 'Personnes morales — Principe',
    question: 'Les personnes morales sont pénalement responsables :',
    options: [
      'Même en cas de faute simple',
      'Uniquement en cas de faute caractérisée',
      'Jamais pour les infractions involontaires',
    ],
    answer: 'Même en cas de faute simple',
    explanation: 'La responsabilité des personnes morales est plus large.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Personnes morales — Causalité',
    question: 'Pour une personne morale, la causalité indirecte :',
    options: [
      'N’exclut pas la responsabilité pénale',
      'Exclut toute responsabilité',
      'Impose une faute délibérée',
    ],
    answer: 'N’exclut pas la responsabilité pénale',
    explanation: 'Contrairement aux personnes physiques.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — VIOLENCES VOLONTAIRES
  // =========================================================
  QuizQuestion(
    category: 'Violences volontaires — Acte',
    question: 'Les violences volontaires supposent nécessairement :',
    options: ['Un acte positif', 'Une abstention', 'Un résultat grave'],
    answer: 'Un acte positif',
    explanation: 'L’abstention relève d’autres qualifications.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences volontaires — Psychiques',
    question:
        'Les violences psychologiques peuvent constituer une infraction :',
    options: ['Oui', 'Non', 'Seulement si ITT physique'],
    answer: 'Oui',
    explanation: 'La jurisprudence admet le choc émotionnel.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NIVEAU CONCOURS — HOMICIDE INVOLONTAIRE
  // =========================================================
  QuizQuestion(
    category: 'Homicide involontaire — Élément matériel',
    question: 'L’homicide involontaire suppose :',
    options: [
      'La mort de la victime',
      'Une tentative',
      'Une intention de tuer',
    ],
    answer: 'La mort de la victime',
    explanation: 'Le résultat mortel est indispensable.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Homicide involontaire — Tentative',
    question: 'La tentative d’homicide involontaire est :',
    options: ['Impossible', 'Punissable', 'Une contravention'],
    answer: 'Impossible',
    explanation: 'Le résultat n’étant pas voulu, la tentative est exclue.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — QUESTIONS FINALES PIÈGES
  // =========================================================
  QuizQuestion(
    category: 'Piège final — Intention',
    question: 'Une faute délibérée implique :',
    options: [
      'La volonté de violer une obligation',
      'La volonté de causer le dommage',
      'Une intention criminelle',
    ],
    answer: 'La volonté de violer une obligation',
    explanation: 'Le dommage n’est pas recherché.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Piège final — Résultat',
    question: 'Sans résultat dommageable, une infraction non intentionnelle :',
    options: [
      'N’est pas constituée',
      'Est tentée',
      'Devient une contravention',
    ],
    answer: 'N’est pas constituée',
    explanation: 'Le dommage est un élément constitutif.',
    difficulty: 'Facile',
  ),
  // =========================================================
  // NIVEAU CONCOURS — CONFUSIONS FAUTE SIMPLE / CARACTÉRISÉE
  // =========================================================
  QuizQuestion(
    category: 'Faute — Distinction',
    question:
        'En cas de causalité directe, la responsabilité pénale d’une personne physique suppose :',
    options: [
      'Une faute simple',
      'Une faute caractérisée',
      'Une faute délibérée',
    ],
    answer: 'Une faute simple',
    explanation: 'En causalité directe, toute faute suffit.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Faute — Distinction',
    question:
        'En cas de causalité indirecte, la responsabilité pénale d’une personne physique exige :',
    options: [
      'Une faute caractérisée ou délibérée',
      'Une faute simple',
      'Une intention',
    ],
    answer: 'Une faute caractérisée ou délibérée',
    explanation: 'Exigence de gravité renforcée en causalité indirecte.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — OBLIGATION DE PRUDENCE
  // =========================================================
  QuizQuestion(
    category: 'Obligation — Source',
    question: 'Une obligation particulière de prudence peut résulter :',
    options: [
      'D’une loi ou d’un règlement',
      'D’un usage professionnel',
      'D’une simple recommandation',
    ],
    answer: 'D’une loi ou d’un règlement',
    explanation: 'Seuls les textes normatifs sont admis.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Obligation — Preuve',
    question: 'Les juges doivent préciser :',
    options: [
      'La source exacte de l’obligation violée',
      'Le ressenti de la victime',
      'L’intention morale',
    ],
    answer: 'La source exacte de l’obligation violée',
    explanation: 'Exigence jurisprudentielle constante.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NIVEAU CONCOURS — ITT (QUESTIONS PIÈGES)
  // =========================================================
  QuizQuestion(
    category: 'ITT — Calcul',
    question: 'L’ITT prise en compte est celle :',
    options: ['Consécutive', 'Additionnée', 'Estimée'],
    answer: 'Consécutive',
    explanation: 'Les périodes discontinues ne s’additionnent pas.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'ITT — Qualification',
    question: 'Une ITT de 3 mois jour pour jour relève :',
    options: ['Du seuil ≤ 3 mois', 'Du seuil > 3 mois', 'D’une contravention'],
    answer: 'Du seuil ≤ 3 mois',
    explanation: 'Le seuil est inclus.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — PERSONNE D’AUTRUI
  // =========================================================
  QuizQuestion(
    category: 'Victime — Condition',
    question: 'Une atteinte involontaire suppose une victime :',
    options: [
      'Distincte de l’auteur',
      'Ayant porté plainte',
      'Ayant subi un préjudice moral',
    ],
    answer: 'Distincte de l’auteur',
    explanation: 'On ne peut être victime de soi-même.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Victime — Personne vivante',
    question: 'La victime doit être :',
    options: [
      'Vivante au moment des faits',
      'Vivante au jugement',
      'Consciente',
    ],
    answer: 'Vivante au moment des faits',
    explanation: 'Condition constante en droit pénal.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // NIVEAU CONCOURS — VIOLENCES VOLONTAIRES
  // =========================================================
  QuizQuestion(
    category: 'Violences — Intention',
    question: 'L’intention exigée en matière de violences est :',
    options: [
      'La conscience de porter atteinte',
      'La volonté du résultat',
      'La préméditation',
    ],
    answer: 'La conscience de porter atteinte',
    explanation: 'Le dommage précis n’a pas à être voulu.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences — Moyen',
    question: 'Une violence peut être exercée par :',
    options: ['Un objet ou un animal', 'Une abstention', 'Une négligence'],
    answer: 'Un objet ou un animal',
    explanation: 'Le contact peut être indirect.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — HOMICIDE INVOLONTAIRE
  // =========================================================
  QuizQuestion(
    category: 'Homicide — Faute',
    question: 'L’homicide involontaire peut résulter :',
    options: [
      'D’une faute simple',
      'D’une intention',
      'D’une abstention volontaire',
    ],
    answer: 'D’une faute simple',
    explanation: 'En causalité directe, la faute simple suffit.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Homicide — Aggravation',
    question: 'La conduite sous l’empire d’un état alcoolique constitue :',
    options: [
      'Une circonstance aggravante',
      'Une infraction distincte uniquement',
      'Une contravention',
    ],
    answer: 'Une circonstance aggravante',
    explanation: 'Prévue par l’article 221-6-1 du CP.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // NIVEAU CONCOURS — QUESTIONS ULTRA PIÈGES
  // =========================================================
  QuizQuestion(
    category: 'Ultra piège — Prévention',
    question:
        'La création de l’infraction de participation à un groupement violent vise principalement :',
    options: [
      'La prévention',
      'La répression a posteriori',
      'La sanction des intentions',
    ],
    answer: 'La prévention',
    explanation: 'Objectif de démantèlement en amont.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ultra piège — Groupement',
    question: 'La simple présence dans un groupement violent :',
    options: [
      'Peut suffire à caractériser la participation',
      'N’est jamais suffisante',
      'Constitue une complicité',
    ],
    answer: 'Peut suffire à caractériser la participation',
    explanation: 'Il suffit de s’y intégrer sciemment.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Groupement violent — Nature du groupement',
    question: 'Le groupement visé par l’article 222-14-2 peut être :',
    options: [
      'Temporaire ou durable',
      'Uniquement structuré et permanent',
      'Forcément une association déclarée',
    ],
    answer: 'Temporaire ou durable',
    explanation: 'Le texte vise un groupement même formé de façon temporaire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Groupement violent — Objet de l’infraction',
    question: 'Le groupement constitue :',
    options: [
      'Le moyen de préparer des violences ou des dégradations',
      'L’objet même de l’infraction',
      'Une association de malfaiteurs',
    ],
    answer: 'Le moyen de préparer des violences ou des dégradations',
    explanation:
        'Le groupement est le moyen de préparation, non l’objet de l’infraction.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Groupement violent — Distinction juridique',
    question: 'Ce groupement n’est ni une association de malfaiteurs, ni :',
    options: [
      'Une bande organisée ou un attroupement',
      'Une contravention',
      'Un délit de presse',
    ],
    answer: 'Une bande organisée ou un attroupement',
    explanation:
        'Le cours distingue ce groupement de l’association de malfaiteurs, de la bande organisée et de l’attroupement.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Groupement violent — Participation',
    question: 'La participation au groupement est caractérisée :',
    options: [
      'Par la simple présence intégrée au groupe',
      'Uniquement par des actes de violence',
      'Uniquement par un rôle de chef',
    ],
    answer: 'Par la simple présence intégrée au groupe',
    explanation:
        'La simple présence suffit dès lors que la personne s’intègre au groupement.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Groupement violent — Actes préparatoires',
    question: 'Les actes préparatoires doivent être caractérisés par :',
    options: [
      'Un ou plusieurs faits matériels',
      'Une simple intention supposée',
      'Un passé judiciaire',
    ],
    answer: 'Un ou plusieurs faits matériels',
    explanation:
        'L’intention délictueuse doit être établie par des faits matériels précis.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Groupement violent — Exemples d’actes préparatoires',
    question:
        'Lequel constitue un fait matériel caractérisant la préparation ?',
    options: [
      'Le port de barres de fer ou de cagoules',
      'Le simple fait de discuter',
      'La présence dans un lieu public',
    ],
    answer: 'Le port de barres de fer ou de cagoules',
    explanation:
        'Le cours cite notamment le port d’armes improvisées ou de cagoules.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Groupement violent — Finalité',
    question: 'L’infraction vise principalement à :',
    options: [
      'Prévenir la commission de violences ou dégradations',
      'Punir uniquement les violences réalisées',
      'Sanctionner les rassemblements pacifiques',
    ],
    answer: 'Prévenir la commission de violences ou dégradations',
    explanation:
        'Il s’agit d’une infraction à visée préventive, en amont des faits.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Groupement violent — Élément moral',
    question: 'L’auteur doit participer au groupement :',
    options: [
      'Sciemment',
      'Par simple imprudence',
      'Par contrainte automatique',
    ],
    answer: 'Sciemment',
    explanation: 'La participation doit être consciente et volontaire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Groupement violent — Connaissance des faits',
    question: 'L’auteur est responsable s’il :',
    options: [
      'A accompli ou a eu connaissance d’actes préparatoires',
      'Ignore totalement les intentions du groupe',
      'Est présent par hasard',
    ],
    answer: 'A accompli ou a eu connaissance d’actes préparatoires',
    explanation:
        'Il suffit d’avoir accompli ou d’avoir connaissance des faits matériels.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Groupement violent — Tentative',
    question: 'La tentative de participation à un groupement violent est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable uniquement si violences',
    ],
    answer: 'Non punissable',
    explanation: 'La tentative n’est pas punissable faute de texte.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Groupement violent — Peines',
    question: 'La participation à un groupement violent est punie de :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation:
        'Les peines prévues par l’article 222-14-2 CP sont de 1 an et 15 000 €.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // ATTEINTES INVOLONTAIRES — CONDUCTEUR VTAM — ITT ≤ 3 MOIS
  // =========================================================
  QuizQuestion(
    category: 'Atteinte involontaire — VTAM — Fondement',
    question:
        'Les atteintes involontaires par conducteur avec ITT ≤ 3 mois sont prévues par :',
    options: [
      'L’article 222-20-1 du Code pénal',
      'L’article 222-19 du Code pénal',
      'L’article R. 625-2 du Code pénal',
    ],
    answer: 'L’article 222-20-1 du Code pénal',
    explanation:
        'Le cours indique que l’article 222-20-1 CP réprime ces atteintes.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte involontaire — VTAM — Faute',
    question: 'L’infraction repose sur :',
    options: [
      'Une faute d’imprudence',
      'Une intention de nuire',
      'Une préméditation',
    ],
    answer: 'Une faute d’imprudence',
    explanation:
        'Il s’agit d’une infraction non intentionnelle fondée sur une faute.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte involontaire — VTAM — Types de faute',
    question: 'La faute simple peut résulter de :',
    options: [
      'Maladresse, imprudence, inattention ou négligence',
      'Uniquement d’une violation pénale',
      'Uniquement d’une faute lourde',
    ],
    answer: 'Maladresse, imprudence, inattention ou négligence',
    explanation: 'Ces comportements fautifs sont listés à l’article 121-3 CP.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte involontaire — VTAM — Obligation',
    question: 'Le manquement à une obligation de prudence doit être :',
    options: [
      'Prévu par la loi ou le règlement',
      'Simplement moral',
      'Déduit du comportement général',
    ],
    answer: 'Prévu par la loi ou le règlement',
    explanation: 'L’obligation doit être législative ou réglementaire.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte involontaire — VTAM — Lien de causalité',
    question: 'La faute doit :',
    options: [
      'Avoir concouru au dommage',
      'Être la seule cause possible',
      'Être immédiate uniquement',
    ],
    answer: 'Avoir concouru au dommage',
    explanation: 'La faute n’a pas besoin d’être unique ou immédiate.',
    difficulty: 'Moyenne',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizAtteinteInvolontaire extends StatefulWidget {
  static const String routeName =
      '/gpx/crimes_personne/quiz/atteintes_involontaires';
  final String uid;
  final String email;

  const QuizAtteinteInvolontaire({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizAtteinteInvolontaire> createState() =>
      _QuizAtteinteInvolontaireState();
}

class _QuizAtteinteInvolontaireState extends State<QuizAtteinteInvolontaire>
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
        ? questionAtteinteInvolontaire
        : questionAtteinteInvolontaire
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
            'module_name': 'Crimes & délits contre la personne',
            'quiz_name': 'Atteinte involontaire',
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
      await _sb.from('quiz_atteintes_involontaires').insert({
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
      debugPrint('❌ quiz_atteintes_involontaires insert failed: $e');
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
