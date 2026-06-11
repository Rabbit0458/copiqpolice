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

final List<QuizQuestion> questionMiseEnPerilMineurs = [
  // =========================================================
  // CORRUPTION DE MINEUR — FONDEMENTS
  // =========================================================
  const QuizQuestion(
    category: 'Corruption de mineur — Fondement',
    question: 'L’infraction de corruption de mineur est prévue par :',
    options: [
      'L’article 227-22 du Code pénal',
      'L’article 227-24 du Code pénal',
      'L’article 225-5 du Code pénal',
    ],
    answer: 'L’article 227-22 du Code pénal',
    explanation:
        'La corruption de mineur est définie et réprimée par l’article 227-22 du Code pénal.',
    difficulty: 'Facile',
  ),
  // =====================
  // CORRUPTION DE MINEUR — 227-22
  // =====================
  const QuizQuestion(
    category: 'Corruption de mineur — Fondement',
    question: 'La corruption de mineur est prévue et réprimée par :',
    options: [
      'L’article 227-22 al.1 et 2 du Code pénal',
      'L’article 227-23 du Code pénal',
      'L’article 227-15 du Code pénal',
    ],
    answer: 'L’article 227-22 al.1 et 2 du Code pénal',
    explanation:
        'Le cours précise que la corruption de mineur est prévue par l’article 227-22 al.1 et 2 du Code pénal.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Auteur',
    question:
        'Concernant l’auteur de la corruption de mineur (art. 227-22), il peut être :',
    options: [
      'Majeur ou mineur',
      'Uniquement majeur',
      'Uniquement un ascendant',
    ],
    answer: 'Majeur ou mineur',
    explanation:
        'L’alinéa 1 ne fixe pas de condition d’âge : l’auteur peut être majeur ou mineur.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Victime',
    question: 'La victime de la corruption de mineur doit être :',
    options: [
      'Un mineur de 18 ans',
      'Un mineur de 15 ans',
      'Un majeur vulnérable',
    ],
    answer: 'Un mineur de 18 ans',
    explanation:
        'La victime est un mineur de 18 ans (sans condition de moralité, consentement indifférent).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Consentement',
    question: 'Le consentement du mineur, en matière de corruption de mineur :',
    options: [
      'Est indifférent',
      'Supprime l’infraction',
      'Transforme l’infraction en contravention',
    ],
    answer: 'Est indifférent',
    explanation: 'Il importe peu que le mineur soit consentant.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Acte',
    question: 'La corruption de mineur vise notamment :',
    options: [
      'Tout acte visant à éveiller ou exciter la dépravation sexuelle chez un mineur',
      'Toute insulte adressée à un mineur',
      'Toute contrainte physique sur un mineur',
    ],
    answer:
        'Tout acte visant à éveiller ou exciter la dépravation sexuelle chez un mineur',
    explanation:
        'Le cours définit l’acte de corruption par l’objectif de dépravation sexuelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Propos obscènes',
    question: 'De simples propos obscènes ou de simples conseils sont :',
    options: [
      'Insuffisants, sauf s’ils sont persistants et précis',
      'Toujours suffisants',
      'Toujours dépénalisés',
    ],
    answer: 'Insuffisants, sauf s’ils sont persistants et précis',
    explanation:
        'Le cours précise que les simples propos/conseils ne suffisent pas : il faut persistance et précision.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Résultat',
    question:
        'Pour caractériser la corruption de mineur, il faut prouver que le mineur :',
    options: [
      'A effectivement été troublé',
      'S’est livré à un acte sexuel ensuite',
      'N’a pas besoin d’avoir été effectivement troublé',
    ],
    answer: 'N’a pas besoin d’avoir été effectivement troublé',
    explanation:
        'Il n’est pas nécessaire d’établir un trouble effectif ni un passage à l’acte du mineur.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Illustration (alinéa 2)',
    question: 'L’alinéa 2 de l’article 227-22 vise notamment :',
    options: [
      'Le fait, par un majeur, d’organiser des réunions sexuelles avec présence/participation d’un mineur',
      'Le fait de menacer un mineur',
      'Le fait de priver un mineur d’aliments',
    ],
    answer:
        'Le fait, par un majeur, d’organiser des réunions sexuelles avec présence/participation d’un mineur',
    explanation:
        'Cas expressément prévu : réunions comportant exhibitions ou relations sexuelles.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Réunion',
    question:
        'Assister en connaissance de cause à une réunion comportant exhibitions ou relations sexuelles avec présence d’un mineur :',
    options: [
      'Peut constituer une corruption de mineur',
      'N’est jamais punissable',
      'Relève seulement d’une contravention',
    ],
    answer: 'Peut constituer une corruption de mineur',
    explanation:
        'L’alinéa 2 réprime aussi l’assistance en connaissance de cause.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Élément moral',
    question: 'L’élément moral exige notamment :',
    options: [
      'La conscience du caractère obscène de l’acte et de l’âge de la victime',
      'Une intention de blesser',
      'Une intention de voler',
    ],
    answer:
        'La conscience du caractère obscène de l’acte et de l’âge de la victime',
    explanation: 'Le cours insiste sur la conscience obscénité + âge.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — But',
    question:
        'Si l’auteur agit uniquement pour assouvir ses pulsions personnelles sans chercher à dépraver le mineur :',
    options: [
      'La corruption de mineur peut ne pas être constituée',
      'La corruption est automatiquement constituée',
      'Le fait devient une contravention',
    ],
    answer: 'La corruption de mineur peut ne pas être constituée',
    explanation:
        'Le cours précise que l’intention de corrompre est nécessaire.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Circonstance aggravante (réseaux)',
    question:
        'La corruption de mineur est aggravée si le mineur a été mis en contact via :',
    options: [
      'Un réseau de communications électroniques (messages à public non déterminé)',
      'Un courrier postal',
      'Un appel unique non réitéré',
    ],
    answer:
        'Un réseau de communications électroniques (messages à public non déterminé)',
    explanation: 'Circ. aggravante prévue à l’article 227-22 al.1.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Circonstance aggravante (lieux)',
    question: 'La corruption de mineur est aggravée si commise :',
    options: [
      'Dans un établissement d’enseignement/éducation ou locaux administration (ou abords proches)',
      'Dans un lieu privé quelconque sans autre précision',
      'Uniquement sur la voie publique',
    ],
    answer:
        'Dans un établissement d’enseignement/éducation ou locaux administration (ou abords proches)',
    explanation: 'Circ. aggravante prévue à l’article 227-22 al.1.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Aggravation âge',
    question: 'Lorsque le mineur est âgé de moins de 15 ans :',
    options: [
      'La corruption de mineur est aggravée (art. 227-22 al.3)',
      'L’infraction disparaît',
      'C’est une contravention',
    ],
    answer: 'La corruption de mineur est aggravée (art. 227-22 al.3)',
    explanation: 'L’âge < 15 ans constitue une circonstance aggravante.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Bande organisée',
    question: 'La corruption de mineur commise en bande organisée :',
    options: ['Est aggravée', 'N’est pas visée', 'Relève uniquement du civil'],
    answer: 'Est aggravée',
    explanation: 'Art. 227-22 al.3 : bande organisée = aggravation.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Tentative',
    question: 'La tentative de corruption de mineur est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable uniquement si résultat',
    ],
    answer: 'Punissable',
    explanation: 'La tentative est expressément prévue par l’alinéa 1.',
    difficulty: 'Facile',
  ),

  // =====================
  // DIFFUSION MESSAGE VIOLENT / TERRORISME / PORNO / DANGEREUX — 227-24
  // =====================
  const QuizQuestion(
    category: 'Diffusion message dangereux — Fondement',
    question:
        'La diffusion d’un message violent/terroriste/pornographique/dangereux susceptible d’être vu par un mineur est prévue par :',
    options: [
      'L’article 227-24 al.1 du Code pénal',
      'L’article 227-23 du Code pénal',
      'L’article 227-15 du Code pénal',
    ],
    answer: 'L’article 227-24 al.1 du Code pénal',
    explanation: 'Le cours vise l’article 227-24 al.1 CP.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion message dangereux — Notion',
    question: 'Le terme « message » doit être compris :',
    options: [
      'Au sens le plus large possible (supports variés)',
      'Uniquement comme une lettre',
      'Uniquement comme une vidéo',
    ],
    answer: 'Au sens le plus large possible (supports variés)',
    explanation: 'Le cours précise une acception très large du message.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion message dangereux — Support',
    question: 'Le support du message (art. 227-24) est :',
    options: ['Indifférent', 'Uniquement papier', 'Uniquement numérique'],
    answer: 'Indifférent',
    explanation:
        'Texte : « par quelque moyen que ce soit et quel qu’en soit le support ».',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion message dangereux — Mineur atteint ?',
    question:
        'Pour caractériser l’infraction, il faut que le mineur ait effectivement vu le message :',
    options: [
      'Oui',
      'Non, il suffit qu’il soit susceptible d’être vu ou perçu',
      'Uniquement si le mineur est < 15 ans',
    ],
    answer: 'Non, il suffit qu’il soit susceptible d’être vu ou perçu',
    explanation: 'Le texte vise la susceptibilité, pas l’atteinte effective.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion message dangereux — Négligence',
    question: 'L’infraction peut être constituée en cas :',
    options: [
      'De manque de précautions permettant l’accès à des mineurs',
      'Uniquement d’intention de nuire',
      'Uniquement de violence',
    ],
    answer: 'De manque de précautions permettant l’accès à des mineurs',
    explanation:
        'Le cours mentionne l’imprudence/négligence permettant l’accès.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Diffusion message dangereux — Tentative',
    question: 'La tentative de l’infraction de l’article 227-24 est :',
    options: ['Non punissable', 'Punissable', 'Toujours punissable'],
    answer: 'Non punissable',
    explanation: 'Le cours indique : tentative non.',
    difficulty: 'Facile',
  ),

  // =====================
  // PRIVATION D’ALIMENTS OU DE SOINS — 227-15 / 227-16
  // =====================
  const QuizQuestion(
    category: 'Privation soins — Fondement',
    question:
        'La privation d’aliments ou de soins à mineur de 15 ans est prévue par :',
    options: [
      'L’article 227-15 du Code pénal',
      'L’article 227-17 du Code pénal',
      'L’article 227-23 du Code pénal',
    ],
    answer: 'L’article 227-15 du Code pénal',
    explanation: 'Le cours vise expressément l’article 227-15 CP.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation soins — Victime',
    question: 'La victime doit être :',
    options: [
      'Un mineur de moins de 15 ans',
      'Un mineur de moins de 18 ans',
      'Un majeur vulnérable',
    ],
    answer: 'Un mineur de moins de 15 ans',
    explanation: 'Interprétation stricte : < 15 ans.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation soins — Auteur',
    question: 'Peut être auteur de l’infraction (art. 227-15) :',
    options: [
      'Ascendants / titulaire autorité parentale / personne ayant autorité sur le mineur',
      'Uniquement le père',
      'Uniquement le tuteur judiciaire',
    ],
    answer:
        'Ascendants / titulaire autorité parentale / personne ayant autorité sur le mineur',
    explanation:
        'Le texte vise plusieurs catégories : ascendants, autorité parentale, autorité de fait.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation soins — Notion',
    question: 'La privation de soins concerne notamment :',
    options: [
      'Hygiène, soins médicaux, prise en charge quotidienne',
      'Uniquement l’absence d’école',
      'Uniquement la privation de téléphone',
    ],
    answer: 'Hygiène, soins médicaux, prise en charge quotidienne',
    explanation: 'Le cours décrit la privation de soins au quotidien.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation soins — Condition de santé',
    question: 'Pour être punissable, la privation doit :',
    options: [
      'Compromettre la santé (au point de)',
      'Compromettre uniquement la scolarité',
      'Avoir entraîné une ITT',
    ],
    answer: 'Compromettre la santé (au point de)',
    explanation: 'Condition centrale : compromission de la santé.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation soins — Résultat',
    question: 'L’article 227-15 exige :',
    options: [
      'Un dommage effectif obligatoire',
      'Que les privations soient susceptibles d’altérer la santé',
      'Une mutilation',
    ],
    answer: 'Que les privations soient susceptibles d’altérer la santé',
    explanation:
        'Pas besoin d’atteinte grave effective : susceptibilité suffit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation soins — Présomption (moins de 6 ans)',
    question:
        'Maintenir un enfant de moins de 6 ans sur la voie publique pour solliciter la générosité :',
    options: [
      'Constitue notamment une privation de soins au sens du texte',
      'N’est jamais visé',
      'Relève uniquement d’une contravention de tapage',
    ],
    answer: 'Constitue notamment une privation de soins au sens du texte',
    explanation: 'Présomption prévue à l’article 227-15 al.2.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation soins — Mendicité',
    question: 'Le simple fait de mendier avec un enfant en bas âge est :',
    options: [
      'Toujours constitutif',
      'Pas en soi constitutif automatiquement',
      'Toujours dépénalisé',
    ],
    answer: 'Pas en soi constitutif automatiquement',
    explanation: 'Le cours cite : pas en soi constitutif.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation soins — Élément moral',
    question: 'L’élément moral implique :',
    options: [
      'La conscience que les privations risquent de causer un mal à l’enfant',
      'La volonté de nuire obligatoire',
      'Le mobile religieux justificatif',
    ],
    answer:
        'La conscience que les privations risquent de causer un mal à l’enfant',
    explanation: 'Cass. crim., 11 mars 1975 : conscience/prévision du mal.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation soins — Aggravation mort',
    question: 'Si la privation entraîne la mort du mineur :',
    options: [
      'Art. 227-16 : crime',
      'Art. 227-15 : contravention',
      'Aucune aggravation',
    ],
    answer: 'Art. 227-16 : crime',
    explanation: 'Le cours mentionne l’article 227-16 en cas de mort.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation soins — Tentative',
    question: 'La tentative de privation d’aliments ou de soins (227-15) est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable uniquement si mineur < 6 ans',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours indique : tentative non.',
    difficulty: 'Facile',
  ),

  // =====================
  // PROVOCATION DIRECTE D’UN MINEUR À COMMETTRE CRIME/DÉLIT — 227-21
  // =====================
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Fondement',
    question:
        'La provocation directe d’un mineur à commettre un crime ou un délit est prévue par :',
    options: [
      'L’article 227-21 al.1 du Code pénal',
      'L’article 227-19 du Code pénal',
      'L’article 227-24 du Code pénal',
    ],
    answer: 'L’article 227-21 al.1 du Code pénal',
    explanation: 'Le cours vise expressément l’article 227-21 al.1 CP.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Directe',
    question: 'La provocation doit être :',
    options: [
      'Directe, avec relation précise et lien étroit avec l’infraction',
      'Une simple apologie',
      'Une simple publicité',
    ],
    answer: 'Directe, avec relation précise et lien étroit avec l’infraction',
    explanation: 'Le cours insiste sur la relation précise et incontestable.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Contravention',
    question: 'La provocation visée par l’article 227-21 concerne :',
    options: [
      'Crimes ou délits uniquement',
      'Contraventions aussi',
      'Uniquement crimes',
    ],
    answer: 'Crimes ou délits uniquement',
    explanation: 'La provocation à une contravention n’est pas visée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Effet',
    question: 'Il est nécessaire que la provocation ait été suivie d’effet :',
    options: ['Oui', 'Non', 'Uniquement si le mineur < 15 ans'],
    answer: 'Non',
    explanation: 'L’infraction est autonome : effet indifférent.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Habitude',
    question: 'La provocation à un acte unique peut suffire :',
    options: [
      'Oui, la condition d’habitude n’est plus requise',
      'Non, il faut une habitude',
      'Non, il faut une récidive légale',
    ],
    answer: 'Oui, la condition d’habitude n’est plus requise',
    explanation: 'Le cours précise qu’un acte unique suffit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Aggravations',
    question: 'L’article 227-21 al.2 prévoit notamment l’aggravation si :',
    options: [
      'La provocation est adressée à un mineur de 15 ans',
      'Le mineur est majeur',
      'La provocation est indirecte',
    ],
    answer: 'La provocation est adressée à un mineur de 15 ans',
    explanation: 'Circ. aggravante : mineur de 15 ans.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Élément moral',
    question: 'L’élément moral exige :',
    options: [
      'La conscience d’inciter un mineur à commettre crimes/délits',
      'Une intention de résultat',
      'Un mobile lucratif obligatoire',
    ],
    answer: 'La conscience d’inciter un mineur à commettre crimes/délits',
    explanation: 'Infraction intentionnelle.',
    difficulty: 'Difficile',
  ),

  // =====================
  // PROPOSITIONS SEXUELLES À MINEUR < 15 ANS PAR INTERNET — 227-22-1
  // =====================
  const QuizQuestion(
    category: 'Propositions sexuelles — Fondement',
    question:
        'Les propositions sexuelles à un mineur de 15 ans via communication électronique sont prévues par :',
    options: [
      'L’article 227-22-1 du Code pénal',
      'L’article 227-25 du Code pénal',
      'L’article 227-23 du Code pénal',
    ],
    answer: 'L’article 227-22-1 du Code pénal',
    explanation: 'Le cours vise l’article 227-22-1 CP.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles — Auteur',
    question: 'L’auteur des propositions sexuelles (227-22-1) doit être :',
    options: ['Majeur', 'Mineur', 'Indifférent'],
    answer: 'Majeur',
    explanation: 'Le texte vise expressément un majeur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles — Victime',
    question: 'La victime peut être :',
    options: [
      'Un mineur de 15 ans ou une personne se présentant comme telle',
      'Uniquement un mineur de 18 ans',
      'Uniquement un majeur',
    ],
    answer: 'Un mineur de 15 ans ou une personne se présentant comme telle',
    explanation:
        'Il suffit que l’auteur ait cru échanger avec un mineur de 15 ans.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles — Objet',
    question: 'Les propositions doivent être :',
    options: [
      'Sexuelles et explicites',
      'Vagues et implicites',
      'Uniquement des insultes',
    ],
    answer: 'Sexuelles et explicites',
    explanation: 'Le cours insiste sur des propositions explicites.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles — Aggravation',
    question: 'L’infraction est aggravée lorsque :',
    options: [
      'Les propositions ont été suivies d’une rencontre',
      'Le message est supprimé',
      'La victime ne répond pas',
    ],
    answer: 'Les propositions ont été suivies d’une rencontre',
    explanation: 'Art. 227-22-1 al.2 : rencontre = aggravation.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles — Tentative',
    question:
        'La tentative des propositions sexuelles à mineur (227-22-1) est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable uniquement en bande organisée',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours indique : tentative non.',
    difficulty: 'Facile',
  ),

  // =====================
  // ATTEINTES SEXUELLES — MAJEUR SUR MINEUR < 15 ANS — 227-25 / 227-26
  // =====================
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Fondement',
    question:
        'L’atteinte sexuelle par un majeur sur mineur de 15 ans (hors viol/agression sexuelle) est prévue par :',
    options: [
      'L’article 227-25 du Code pénal',
      'L’article 227-27 du Code pénal',
      'L’article 222-23 du Code pénal',
    ],
    answer: 'L’article 227-25 du Code pénal',
    explanation: 'Le cours vise l’article 227-25 CP.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Définition',
    question: 'L’atteinte sexuelle suppose :',
    options: [
      'Un contact physique sans violence, contrainte, menace ni surprise',
      'Une pénétration sexuelle',
      'Une violence obligatoire',
    ],
    answer: 'Un contact physique sans violence, contrainte, menace ni surprise',
    explanation: 'Sinon : viol/agression sexuelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Auteur',
    question: 'L’auteur doit être :',
    options: ['Majeur', 'Mineur', 'Indifférent'],
    answer: 'Majeur',
    explanation: 'Le texte vise expressément le majeur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Connaissance de l’âge',
    question: 'L’erreur sur l’âge de la victime :',
    options: [
      'N’atténue pas la responsabilité pénale',
      'Supprime toujours l’infraction',
      'Transforme en contravention',
    ],
    answer: 'N’atténue pas la responsabilité pénale',
    explanation:
        'Principe : erreur non exonératoire, sauf hypothèses très particulières admises par la jurisprudence.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Aggravation',
    question:
        'L’atteinte sexuelle (227-25) est aggravée (227-26) notamment si :',
    options: [
      'L’auteur a une autorité de droit ou de fait sur la victime',
      'La victime est majeure',
      'L’acte est commis sans contact',
    ],
    answer: 'L’auteur a une autorité de droit ou de fait sur la victime',
    explanation:
        'Art. 227-26 : autorité, abus de fonctions, pluralité, réseau, ivresse/stupéfiants.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Tentative',
    question: 'La tentative des atteintes sexuelles sur mineur est :',
    options: ['Punissable', 'Non punissable', 'Punissable seulement si ITT'],
    answer: 'Punissable',
    explanation: 'Prévue par l’article 227-27-2.',
    difficulty: 'Moyenne',
  ),

  // =====================
  // ATTEINTES SEXUELLES — MAJEUR SUR MINEUR > 15 — 227-27
  // =====================
  const QuizQuestion(
    category: 'Atteinte sexuelle > 15 — Fondement',
    question:
        'Les atteintes sexuelles sur mineur de plus de 15 ans (hors viol/agression sexuelle) sont prévues par :',
    options: [
      'L’article 227-27 du Code pénal',
      'L’article 227-25 du Code pénal',
      'L’article 227-22 du Code pénal',
    ],
    answer: 'L’article 227-27 du Code pénal',
    explanation: 'Le cours vise l’article 227-27 CP.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle > 15 — Condition',
    question: 'Pour relever de l’article 227-27, il faut notamment :',
    options: [
      'Autorité de droit/de fait ou abus d’autorité fonctionnelle',
      'Une menace obligatoire',
      'Une pénétration obligatoire',
    ],
    answer: 'Autorité de droit/de fait ou abus d’autorité fonctionnelle',
    explanation: 'Le texte vise ces deux hypothèses.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle > 15 — Victime',
    question: 'La victime doit être :',
    options: [
      'Âgée de plus de 15 ans et de moins de 18 ans, même émancipée',
      'Âgée de moins de 15 ans',
      'Majeure',
    ],
    answer: 'Âgée de plus de 15 ans et de moins de 18 ans, même émancipée',
    explanation: 'Critère d’âge au jour des faits.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle > 15 — Tentative',
    question: 'La tentative des atteintes sexuelles sur mineur (227-27) est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable uniquement si bande organisée',
    ],
    answer: 'Punissable',
    explanation: 'Prévue par l’article 227-27-2.',
    difficulty: 'Moyenne',
  ),

  // =====================
  // PÉDOPORNOGRAPHIE — 227-23 (fabrication / diffusion / consultation / détention)
  // =====================
  const QuizQuestion(
    category: 'Pédopornographie — Fondement',
    question:
        'L’exploitation de l’image pornographique d’un mineur est prévue par :',
    options: [
      'L’article 227-23 du Code pénal',
      'L’article 227-24 du Code pénal',
      'L’article 227-22-1 du Code pénal',
    ],
    answer: 'L’article 227-23 du Code pénal',
    explanation: 'Le cours détaille les alinéas 1, 2, 4, etc.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Notion image/représentation',
    question: 'Le texte vise :',
    options: [
      'Images réelles et représentations fictives',
      'Uniquement des photos réelles',
      'Uniquement des vidéos',
    ],
    answer: 'Images réelles et représentations fictives',
    explanation:
        'Le terme représentation couvre dessins, montages, morphing, etc.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Pornographique',
    question: 'La simple nudité d’un mineur, sans attitude sexuelle :',
    options: [
      'N’entre pas nécessairement dans le champ',
      'Est toujours pédopornographique',
      'Est une contravention',
    ],
    answer: 'N’entre pas nécessairement dans le champ',
    explanation: 'Il faut un caractère pornographique (activité sexuelle).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Fabrication (al.1)',
    question: 'L’alinéa 1 réprime notamment :',
    options: [
      'Fixer/enregistrer/transmettre en vue de diffusion',
      'Consulter habituellement un site',
      'Diffuser une menace',
    ],
    answer: 'Fixer/enregistrer/transmettre en vue de diffusion',
    explanation:
        'Fabrication en vue de diffusion (sauf mineur < 15 ans : diffusion pas exigée).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Mineur < 15 ans',
    question: 'Si l’image concerne un mineur de moins de 15 ans :',
    options: [
      'La fabrication est punie même sans intention de diffusion',
      'La fabrication n’est jamais punie',
      'Seule la diffusion est punie',
    ],
    answer: 'La fabrication est punie même sans intention de diffusion',
    explanation: 'Exception expressément prévue.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Diffusion (al.2)',
    question: 'L’alinéa 2 réprime notamment :',
    options: [
      'Offrir/rendre disponible/diffuser/importer/exporter',
      'Uniquement fabriquer',
      'Uniquement consulter',
    ],
    answer: 'Offrir/rendre disponible/diffuser/importer/exporter',
    explanation: 'Diffusion au sens large.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Rendre disponible',
    question: 'Rendre disponible correspond notamment au fait :',
    options: [
      'De laisser des fichiers accessibles sur Internet sans les envoyer directement',
      'D’effacer les fichiers',
      'De signaler un site',
    ],
    answer:
        'De laisser des fichiers accessibles sur Internet sans les envoyer directement',
    explanation: 'Le cours donne précisément cet exemple.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Consultation/détention (al.4)',
    question: 'L’alinéa 4 réprime notamment :',
    options: [
      'Consulter habituellement ou contre paiement + acquérir/détenir',
      'Uniquement vendre',
      'Uniquement fabriquer',
    ],
    answer: 'Consulter habituellement ou contre paiement + acquérir/détenir',
    explanation:
        'Texte : consultation habituelle ou payante + acquisition/détention.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Paiement',
    question: 'La consultation est punie même si occasionnelle lorsqu’elle :',
    options: [
      'A donné lieu à un paiement',
      'A lieu une seule fois',
      'Est faite en privé',
    ],
    answer: 'A donné lieu à un paiement',
    explanation: 'La consultation occasionnelle devient punissable si payante.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Aggravations',
    question: 'Le réseau de communications électroniques peut constituer :',
    options: [
      'Une circonstance aggravante (227-23 al.3)',
      'Une excuse',
      'Une contravention',
    ],
    answer: 'Une circonstance aggravante (227-23 al.3)',
    explanation: 'Aggravation prévue par le texte.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Bande organisée',
    question: 'La bande organisée constitue :',
    options: [
      'Une aggravation (227-23 al.5)',
      'Un élément constitutif obligatoire',
      'Un fait non visé',
    ],
    answer: 'Une aggravation (227-23 al.5)',
    explanation: 'Aggravation prévue au texte.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Tentative',
    question: 'La tentative des infractions prévues par l’article 227-23 est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable uniquement si diffusion',
    ],
    answer: 'Punissable',
    explanation: 'Prévue à l’alinéa 6.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Piège concours — Corruption vs atteinte sexuelle',
    question:
        'Un majeur réalise un acte à connotation sexuelle devant un mineur pour l’exciter/dépraver : on vise prioritairement :',
    options: [
      'La corruption de mineur (227-22)',
      'La soustraction parentale (227-17)',
      'La diffusion de message (227-24)',
    ],
    answer: 'La corruption de mineur (227-22)',
    explanation: 'But = dépravation sexuelle du mineur : corruption.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Piège concours — 227-24',
    question:
        'Pour 227-24, l’accès d’un mineur via une simple case “j’ai +18 ans” :',
    options: [
      'N’empêche pas la constitution de l’infraction',
      'Supprime toujours l’infraction',
      'Transforme en contravention',
    ],
    answer: 'N’empêche pas la constitution de l’infraction',
    explanation:
        'Le cours précise que l’infraction peut être constituée même dans ce cas.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Piège concours — 227-15',
    question: 'Privation de soins à mineur : il faut établir :',
    options: [
      'Compromission de la santé (au point de)',
      'ITT > 8 jours obligatoire',
      'Mutilation obligatoire',
    ],
    answer: 'Compromission de la santé (au point de)',
    explanation: 'C’est l’exigence textuelle centrale.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Piège concours — 227-21',
    question:
        'Une incitation générale “devenez délinquants” sans infraction déterminée :',
    options: [
      'Ne suffit pas à caractériser 227-21',
      'Caractérise automatiquement 227-21',
      'Relève forcément de 227-15',
    ],
    answer: 'Ne suffit pas à caractériser 227-21',
    explanation: 'Il faut viser une ou plusieurs infractions déterminées.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Corruption de mineur — Consentement',
    question: 'Le consentement du mineur en matière de corruption :',
    options: ['Est indifférent', 'Exclut l’infraction', 'Atténue la peine'],
    answer: 'Est indifférent',
    explanation:
        'Le consentement du mineur n’a aucune incidence sur la caractérisation de l’infraction.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Corruption de mineur — Acte matériel',
    question: 'Les simples propos obscènes isolés sont :',
    options: [
      'Insuffisants pour caractériser l’infraction',
      'Toujours constitutifs',
      'Punissables uniquement si répétés',
    ],
    answer: 'Insuffisants pour caractériser l’infraction',
    explanation:
        'Il faut des actes précis et persistants visant la dépravation du mineur.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Corruption de mineur — Internet',
    question:
        'Le fait de mettre un mineur en contact via un réseau de communication électronique constitue :',
    options: [
      'Une circonstance aggravante',
      'Une infraction autonome',
      'Un fait non répréhensible',
    ],
    answer: 'Une circonstance aggravante',
    explanation: 'Prévu à l’article 227-22 alinéa 1 du Code pénal.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Corruption de mineur — Tentative',
    question: 'La tentative de corruption de mineur est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable uniquement si la victime a moins de 15 ans',
    ],
    answer: 'Punissable',
    explanation:
        'La tentative est expressément prévue par l’article 227-22 du Code pénal.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Corruption de mineur — Élément moral',
    question:
        'Si l’auteur agit uniquement pour assouvir ses pulsions sans volonté de corrompre :',
    options: [
      'L’infraction n’est pas constituée',
      'L’infraction est automatiquement constituée',
      'Il y a présomption de culpabilité',
    ],
    answer: 'L’infraction n’est pas constituée',
    explanation: 'L’intention de corrompre est indispensable.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Messages dangereux — Support',
    question: 'Le support du message dangereux :',
    options: [
      'Est indifférent',
      'Doit être numérique',
      'Doit être audiovisuel',
    ],
    answer: 'Est indifférent',
    explanation: 'Tous les supports sont visés par l’article 227-24.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Messages dangereux — Public',
    question: 'L’infraction est constituée même si :',
    options: [
      'Aucun mineur n’a effectivement vu le message',
      'Le message n’a été diffusé qu’une fois',
      'Le message est gratuit',
    ],
    answer: 'Aucun mineur n’a effectivement vu le message',
    explanation: 'La simple susceptibilité d’accès suffit.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Messages dangereux — Jeux dangereux',
    question:
        'Les jeux incitant à une mise en danger physique (ex : jeu du foulard) :',
    options: [
      'Entrent dans le champ de l’article 227-24',
      'Relèvent uniquement du droit civil',
      'Ne sont pas incriminés',
    ],
    answer: 'Entrent dans le champ de l’article 227-24',
    explanation: 'Ils sont expressément visés par le texte.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Messages dangereux — Élément moral',
    question: 'L’élément moral est caractérisé par :',
    options: [
      'La conscience du risque de diffusion aux mineurs',
      'La volonté de nuire',
      'L’intention terroriste',
    ],
    answer: 'La conscience du risque de diffusion aux mineurs',
    explanation: 'La négligence suffit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation de soins — Âge de la victime',
    question: 'La victime doit être :',
    options: [
      'Un mineur de moins de 15 ans',
      'Un mineur de moins de 18 ans',
      'Un enfant non émancipé',
    ],
    answer: 'Un mineur de moins de 15 ans',
    explanation: 'Condition stricte d’âge prévue par l’article 227-15.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Privation de soins — Mendicité',
    question:
        'Maintenir un enfant de moins de 6 ans sur la voie publique pour mendier :',
    options: [
      'Constitue une présomption de privation de soins',
      'Est toujours licite',
      'N’est jamais réprimé',
    ],
    answer: 'Constitue une présomption de privation de soins',
    explanation: 'Prévu expressément par le texte.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Privation de soins — Résultat',
    question: 'Le dommage à la santé du mineur :',
    options: [
      'N’a pas besoin d’être effectif',
      'Doit être irréversible',
      'Doit entraîner une ITT',
    ],
    answer: 'N’a pas besoin d’être effectif',
    explanation: 'Il suffit d’un risque de compromission.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Privation de soins — Élément moral',
    question: 'La volonté de nuire est :',
    options: ['Inutile', 'Obligatoire', 'Présumée'],
    answer: 'Inutile',
    explanation: 'La conscience du risque suffit.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Privation de soins — Aggravation',
    question: 'La privation ayant entraîné la mort du mineur constitue :',
    options: ['Un crime', 'Un délit aggravé', 'Une contravention'],
    answer: 'Un crime',
    explanation: 'Prévu à l’article 227-16 du Code pénal.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Provocation délinquance — Nature',
    question: 'Une simple apologie générale de la délinquance :',
    options: ['Ne suffit pas', 'Est constitutive', 'Vaut tentative'],
    answer: 'Ne suffit pas',
    explanation: 'La provocation doit être directe et précise.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Provocation délinquance — Infraction visée',
    question: 'La provocation doit porter sur :',
    options: [
      'Un crime ou un délit',
      'Une contravention',
      'Un comportement immoral',
    ],
    answer: 'Un crime ou un délit',
    explanation: 'Les contraventions sont exclues.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Provocation délinquance — Effet',
    question: 'Le passage à l’acte du mineur est :',
    options: ['Indifférent', 'Nécessaire', 'Atténuant'],
    answer: 'Indifférent',
    explanation: 'L’infraction est consommée par la provocation.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Provocation délinquance — Aggravation',
    question: 'La provocation adressée à un mineur de 15 ans :',
    options: [
      'Aggrave l’infraction',
      'Est neutre',
      'Supprime la responsabilité',
    ],
    answer: 'Aggrave l’infraction',
    explanation: 'Prévu par l’article 227-21 al.2.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Provocation délinquance — Élément moral',
    question: 'L’auteur doit avoir conscience :',
    options: [
      'D’inciter un mineur à commettre une infraction',
      'De troubler l’ordre public',
      'De choquer la morale',
    ],
    answer: 'D’inciter un mineur à commettre une infraction',
    explanation: 'Infraction intentionnelle.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Définition',
    question: 'La provocation à la pédopornographie consiste à :',
    options: [
      'Inciter autrui à commettre une infraction sexuelle sur mineur',
      'Diffuser directement des images pornographiques',
      'Consulter des images pédopornographiques',
    ],
    answer: 'Inciter autrui à commettre une infraction sexuelle sur mineur',
    explanation: 'L’infraction réside dans la provocation elle-même.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Provocation pédopornographie — Réalisation',
    question: 'L’infraction est constituée même si :',
    options: [
      'Le crime ou le délit n’est ni commis ni tenté',
      'La victime est majeure',
      'L’auteur agit sans intention',
    ],
    answer: 'Le crime ou le délit n’est ni commis ni tenté',
    explanation: 'Condition expressément prévue par l’article 227-28-3.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Provocation pédopornographie — Élément moral',
    question: 'L’élément moral exige :',
    options: [
      'La volonté de faire commettre une infraction',
      'La connaissance du résultat',
      'Une récidive préalable',
    ],
    answer: 'La volonté de faire commettre une infraction',
    explanation: 'Infraction intentionnelle.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Provocation pédopornographie — Tentative',
    question: 'La tentative de provocation à la pédopornographie est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable uniquement en bande organisée',
    ],
    answer: 'Non punissable',
    explanation: 'La tentative n’est pas prévue par le texte.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Alcool — Définition',
    question: 'La provocation à la consommation d’alcool concerne :',
    options: [
      'Une consommation excessive ou habituelle',
      'Toute consommation d’alcool',
      'La vente d’alcool',
    ],
    answer: 'Une consommation excessive ou habituelle',
    explanation: 'Les consommations occasionnelles sont exclues.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Alcool — Provocation directe',
    question: 'La provocation doit être :',
    options: ['Directe et précise', 'Générale', 'Symbolique'],
    answer: 'Directe et précise',
    explanation: 'Une simple suggestion ne suffit pas.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Alcool — Mineur de 15 ans',
    question:
        'La provocation adressée à un mineur de moins de 15 ans constitue :',
    options: [
      'Une circonstance aggravante',
      'Une infraction distincte',
      'Un fait non punissable',
    ],
    answer: 'Une circonstance aggravante',
    explanation: 'Prévue à l’article 227-19 al.3.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Alcool — Élément moral',
    question: 'L’auteur doit avoir conscience :',
    options: [
      'D’inciter un mineur à consommer',
      'Du taux d’alcool précis',
      'Du résultat sur la santé',
    ],
    answer: 'D’inciter un mineur à consommer',
    explanation: 'Infraction intentionnelle.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Stupéfiants — Usage',
    question: 'La provocation à l’usage de stupéfiants suppose :',
    options: [
      'Un acte direct d’incitation',
      'Une simple apologie',
      'Une diffusion publique',
    ],
    answer: 'Un acte direct d’incitation',
    explanation: 'Condition essentielle du texte.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Stupéfiants — Trafic',
    question: 'La provocation à devenir guetteur relève :',
    options: [
      'De la provocation à la complicité',
      'D’une contravention',
      'D’un fait non répréhensible',
    ],
    answer: 'De la provocation à la complicité',
    explanation: 'Explicitement visé par l’article 227-18-1.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Stupéfiants — Élément moral',
    question: 'L’auteur doit agir :',
    options: ['En connaissance de cause', 'Par imprudence', 'Par négligence'],
    answer: 'En connaissance de cause',
    explanation: 'Infraction intentionnelle.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Stupéfiants — Tentative',
    question: 'La tentative de provocation aux stupéfiants est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable uniquement si mineur < 15 ans',
    ],
    answer: 'Non punissable',
    explanation: 'La tentative n’est pas prévue.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction parentale — Auteur',
    question: 'L’infraction peut être commise par :',
    options: [
      'Le père ou la mère',
      'Tout ascendant',
      'Toute personne ayant autorité',
    ],
    answer: 'Le père ou la mère',
    explanation: 'Seul le lien de filiation est requis.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Soustraction parentale — Abandon',
    question: 'L’abandon moral peut exister :',
    options: [
      'Même en restant au domicile',
      'Uniquement en cas de départ',
      'Uniquement en cas de divorce',
    ],
    answer: 'Même en restant au domicile',
    explanation: 'La carence peut être comportementale.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Soustraction parentale — Motif légitime',
    question: 'Le motif légitime est apprécié :',
    options: ['Restrictivement par les juges', 'Largement', 'Automatiquement'],
    answer: 'Restrictivement par les juges',
    explanation: 'La jurisprudence est constante.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Soustraction parentale — Élément moral',
    question: 'L’élément moral repose sur :',
    options: [
      'La conscience du danger pour l’enfant',
      'La volonté de nuire',
      'L’intention de quitter le foyer',
    ],
    answer: 'La conscience du danger pour l’enfant',
    explanation: 'Cass. crim., 21 octobre 1998.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Soustraction parentale — Tentative',
    question: 'La tentative de soustraction aux obligations parentales est :',
    options: ['Non punissable', 'Punissable', 'Punissable en cas de récidive'],
    answer: 'Non punissable',
    explanation: 'La tentative n’est pas prévue.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Auteur',
    question: 'Concernant l’auteur de la corruption de mineur :',
    options: [
      'Il peut être mineur ou majeur',
      'Il doit obligatoirement être majeur',
      'Il doit être un ascendant',
    ],
    answer: 'Il peut être mineur ou majeur',
    explanation:
        'L’article 227-22 al.1 ne pose aucune condition d’âge concernant l’auteur.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Corruption de mineur — Victime',
    question: 'La victime de la corruption de mineur doit être :',
    options: [
      'Un mineur de moins de 18 ans',
      'Un mineur de moins de 15 ans',
      'Un mineur non consentant',
    ],
    answer: 'Un mineur de moins de 18 ans',
    explanation:
        'La victime doit être mineure, quel que soit son âge et même si elle est consentante.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Corruption de mineur — Élément matériel',
    question: 'Constitue un acte de corruption de mineur :',
    options: [
      'Un acte visant à éveiller la dépravation sexuelle du mineur',
      'Un simple propos obscène isolé',
      'Un conseil général sans précision',
    ],
    answer: 'Un acte visant à éveiller la dépravation sexuelle du mineur',
    explanation:
        'La corruption suppose un comportement dépravant, les simples propos isolés sont insuffisants.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Corruption de mineur — Réunions sexuelles',
    question:
        'Le fait pour un majeur d’organiser des réunions sexuelles auxquelles un mineur assiste constitue :',
    options: [
      'Une corruption de mineur',
      'Une atteinte sexuelle',
      'Une infraction impossible',
    ],
    answer: 'Une corruption de mineur',
    explanation:
        'L’article 227-22 al.2 vise expressément ce mode de commission.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Corruption de mineur — Élément moral',
    question: 'L’élément moral de la corruption de mineur suppose :',
    options: [
      'La volonté de corrompre le mineur',
      'La simple imprudence',
      'L’intention exclusive d’assouvir ses pulsions',
    ],
    answer: 'La volonté de corrompre le mineur',
    explanation:
        'L’infraction est intentionnelle et suppose la volonté d’inciter le mineur à la dépravation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Messages dangereux — Fondement',
    question:
        'La diffusion de messages violents ou pornographiques susceptibles d’être vus par un mineur est prévue par :',
    options: [
      'L’article 227-24 du Code pénal',
      'L’article 227-23 du Code pénal',
      'L’article 222-16 du Code pénal',
    ],
    answer: 'L’article 227-24 du Code pénal',
    explanation:
        'Cette infraction est prévue par l’article 227-24 du Code pénal.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Messages dangereux — Élément matériel',
    question: 'L’infraction est constituée lorsque le message est :',
    options: [
      'Susceptible d’être vu ou perçu par un mineur',
      'Effectivement vu par un mineur',
      'Diffusé uniquement sur Internet',
    ],
    answer: 'Susceptible d’être vu ou perçu par un mineur',
    explanation:
        'Il n’est pas nécessaire qu’un mineur ait effectivement vu le message.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Messages dangereux — Négligence',
    question: 'L’infraction peut être constituée en cas de :',
    options: [
      'Négligence permettant l’accès à des mineurs',
      'Intention exclusive de viser des mineurs',
      'Plainte obligatoire',
    ],
    answer: 'Négligence permettant l’accès à des mineurs',
    explanation:
        'La négligence ou l’imprudence suffit à caractériser l’élément moral.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation de soins — Fondement',
    question:
        'La privation d’aliments ou de soins à mineur de quinze ans est prévue par :',
    options: [
      'L’article 227-15 du Code pénal',
      'L’article 227-17 du Code pénal',
      'L’article 222-14 du Code pénal',
    ],
    answer: 'L’article 227-15 du Code pénal',
    explanation:
        'Cette infraction est définie par l’article 227-15 du Code pénal.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Privation de soins — Auteur',
    question: 'Peut être auteur de la privation d’aliments ou de soins :',
    options: [
      'Toute personne ayant autorité sur le mineur',
      'Uniquement les parents biologiques',
      'Uniquement un ascendant',
    ],
    answer: 'Toute personne ayant autorité sur le mineur',
    explanation:
        'Le texte vise ascendants, détenteurs de l’autorité parentale et autorités de fait.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Privation de soins — Résultat',
    question: 'Pour être constituée, la privation doit :',
    options: [
      'Être susceptible de compromettre la santé du mineur',
      'Avoir causé une atteinte grave',
      'Avoir entraîné une hospitalisation',
    ],
    answer: 'Être susceptible de compromettre la santé du mineur',
    explanation:
        'Le résultat n’a pas besoin d’être effectif, le risque suffit.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Privation de soins — Élément moral',
    question: 'L’élément moral de l’infraction suppose :',
    options: [
      'La conscience du risque pour l’enfant',
      'La volonté de nuire',
      'Une intention homicide',
    ],
    answer: 'La conscience du risque pour l’enfant',
    explanation:
        'Il n’est pas nécessaire de vouloir nuire, la conscience du danger suffit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation délinquance — Fondement',
    question:
        'La provocation directe d’un mineur à commettre un crime ou un délit est prévue par :',
    options: [
      'L’article 227-21 du Code pénal',
      'L’article 227-28-3 du Code pénal',
      'L’article 121-7 du Code pénal',
    ],
    answer: 'L’article 227-21 du Code pénal',
    explanation:
        'Cette infraction est prévue par l’article 227-21 du Code pénal.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Provocation délinquance — Nature',
    question: 'La provocation doit être :',
    options: ['Directe et précise', 'Générale et abstraite', 'Indirecte'],
    answer: 'Directe et précise',
    explanation: 'Une simple suggestion ou apologie ne suffit pas.',
    difficulty: 'Moyenne',
  ),
  // =====================
  // CORRUPTION DE MINEUR — 227-22 (suite + variations)
  // =====================
  const QuizQuestion(
    category: 'Corruption de mineur — Qualification',
    question: 'La corruption de mineur (227-22) est :',
    options: ['Un délit', 'Un crime', 'Une contravention'],
    answer: 'Un délit',
    explanation: 'Le cours classe la corruption de mineur comme un délit.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Mineur < 15 ans',
    question:
        'Dans la corruption de mineur, l’âge de moins de 15 ans de la victime constitue :',
    options: [
      'Une circonstance aggravante',
      'Une cause d’irresponsabilité',
      'Une excuse absolutoire',
    ],
    answer: 'Une circonstance aggravante',
    explanation:
        'Le cours indique que la minorité de 15 ans aggrave l’infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Objet',
    question: 'L’acte de corruption est défini principalement :',
    options: [
      'Par son but (favoriser la corruption)',
      'Par une liste exhaustive d’actes matériels',
      'Par une ITT obligatoire',
    ],
    answer: 'Par son but (favoriser la corruption)',
    explanation:
        'Le texte mentionne “favoriser la corruption” : l’acte est défini par son objectif.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Obscénité',
    question: 'Si le caractère obscène de l’acte matériel fait défaut :',
    options: [
      'L’infraction n’est pas caractérisée',
      'L’infraction est toujours caractérisée',
      'On bascule automatiquement sur 227-24',
    ],
    answer: 'L’infraction n’est pas caractérisée',
    explanation:
        'Le cours précise que sans caractère obscène, la corruption n’est pas retenue.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Réunion sexuelle',
    question:
        'Organiser une réunion comportant des exhibitions/relations sexuelles à laquelle un mineur assiste :',
    options: [
      'Peut constituer un cas express de corruption',
      'Constitue uniquement une contravention',
      'Relève de 227-17',
    ],
    answer: 'Peut constituer un cas express de corruption',
    explanation:
        'Le cours cite l’article 227-22 al.2 : organisation de réunions.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Assistance',
    question:
        'Assister en connaissance de cause à une réunion sexuelle avec présence d’un mineur :',
    options: [
      'Est visé par 227-22 al.2',
      'N’est jamais puni',
      'Relève exclusivement de la complicité',
    ],
    answer: 'Est visé par 227-22 al.2',
    explanation:
        'L’alinéa 2 incrimine aussi l’assistance en connaissance de cause.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Réseau électronique',
    question:
        'La corruption est aggravée si le mineur a été mis en contact via un réseau de communications électroniques :',
    options: ['Oui', 'Non', 'Uniquement si mineur < 15 ans'],
    answer: 'Oui',
    explanation:
        'Circ. aggravante prévue à 227-22 (messages à destination d’un public non déterminé).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Lieux scolaires',
    question:
        'La corruption est aggravée si commise dans/aux abords d’un établissement scolaire (temps très voisin des entrées/sorties) :',
    options: ['Oui', 'Non', 'Uniquement si bande organisée'],
    answer: 'Oui',
    explanation: 'Circ. aggravante prévue à l’article 227-22 al.1.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Bande organisée',
    question: 'La bande organisée en matière de corruption de mineur :',
    options: [
      'Aggrave (art. 227-22 al.3)',
      'Réduit la peine',
      'N’est pas prévue',
    ],
    answer: 'Aggrave (art. 227-22 al.3)',
    explanation: 'Le cours mentionne l’aggravation si bande organisée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Intention d’exécuter',
    question:
        'La loi exige que l’auteur ait voulu mettre ses actes à exécution au-delà de l’intimidation/dépravation :',
    options: ['Non', 'Oui', 'Uniquement si mineur < 15 ans'],
    answer: 'Non',
    explanation:
        'Le cours explique que l’intention de corrompre suffit : pas besoin d’un “résultat”.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Tentative',
    question: 'La tentative de corruption de mineur est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable uniquement si contact physique',
    ],
    answer: 'Punissable',
    explanation: 'Le cours indique que la tentative est expressément prévue.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Complicité',
    question: 'La complicité en matière de corruption de mineur est :',
    options: ['Punissable', 'Non punissable', 'Uniquement contraventionnelle'],
    answer: 'Punissable',
    explanation: 'Le cours indique : complicité oui.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Peine simple',
    question:
        'La peine principale “simple” (cas de base) de la corruption de mineur est notamment :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation:
        'Le tableau de répression indique 5 ans et 75 000 € en simple.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Répression aggravée (réseau/lieux)',
    question: 'En cas d’aggravation (réseau/lieux), la peine peut passer à :',
    options: ['7 ans et 100 000 €', '5 ans et 75 000 €', '1 an et 15 000 €'],
    answer: '7 ans et 100 000 €',
    explanation:
        'Le tableau du cours mentionne 7 ans et 100 000 € pour une aggravation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Répression aggravée (mineur < 15)',
    question:
        'Lorsque la victime a moins de 15 ans, la peine peut être portée à :',
    options: ['10 ans et 150 000 €', '7 ans et 100 000 €', '5 ans et 75 000 €'],
    answer: '10 ans et 150 000 €',
    explanation:
        'Le tableau du cours prévoit une aggravation à 10 ans et 150 000 €.',
    difficulty: 'Difficile',
  ),

  // =====================
  // DIFFUSION MESSAGE VIOLENT/TERRORISME/PORNO/DANGEREUX — 227-24 (suite)
  // =====================
  const QuizQuestion(
    category: 'Diffusion message — Caractères',
    question: 'Le message visé par 227-24 peut être :',
    options: [
      'Violent, incitant au terrorisme, pornographique, ou dangereux pour les mineurs',
      'Uniquement violent',
      'Uniquement diffamatoire',
    ],
    answer:
        'Violent, incitant au terrorisme, pornographique, ou dangereux pour les mineurs',
    explanation: 'Le texte vise plusieurs natures de messages.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion message — Jeux dangereux',
    question: 'Le texte vise notamment les messages incitant des mineurs à :',
    options: [
      'Des jeux les mettant physiquement en danger',
      'Des jeux vidéo uniquement',
      'Des sports encadrés',
    ],
    answer: 'Des jeux les mettant physiquement en danger',
    explanation: 'Le cours cite l’exemple du “jeu du foulard”.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion message — Actes matériels',
    question: 'Les actes matériels visés par 227-24 incluent notamment :',
    options: [
      'Fabriquer, transporter, diffuser, faire commerce',
      'Uniquement écrire',
      'Uniquement héberger un mineur',
    ],
    answer: 'Fabriquer, transporter, diffuser, faire commerce',
    explanation: 'Le texte liste fabrication/transport/diffusion/commerce.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion message — Public',
    question:
        'Pour 227-24, il faut prouver que le message a été vu par un mineur :',
    options: [
      'Non, seulement susceptible d’être vu/perçu',
      'Oui, obligatoirement',
      'Oui, mais seulement si mineur < 15 ans',
    ],
    answer: 'Non, seulement susceptible d’être vu/perçu',
    explanation: 'Le critère est la susceptibilité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion message — Négligence',
    question: 'La diffusion peut être retenue si l’accès des mineurs résulte :',
    options: [
      'D’un manque de précautions suffisantes',
      'Uniquement d’un acte de violence',
      'Uniquement d’une menace',
    ],
    answer: 'D’un manque de précautions suffisantes',
    explanation: 'Le cours évoque l’imprudence ou la négligence.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Diffusion message — Mention “réservé adultes”',
    question:
        'Un message pornographique sans mention “réservé aux adultes” accessible à un mineur peut :',
    options: [
      'Constituer 227-24',
      'Ne jamais être poursuivi',
      'Relever uniquement du civil',
    ],
    answer: 'Constituer 227-24',
    explanation:
        'Le cours donne l’exemple des messages réservés aux majeurs accessibles aux mineurs.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Diffusion message — Déclaration mineur',
    question:
        'L’infraction peut être constituée même si le mineur a simplement déclaré avoir 18 ans :',
    options: ['Oui', 'Non', 'Uniquement si paiement'],
    answer: 'Oui',
    explanation: 'Le cours précise que ce cas n’exclut pas l’infraction.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Diffusion message — Élément moral',
    question: 'L’élément moral (227-24) est caractérisé :',
    options: [
      'Si diffusion délibérée à des mineurs ou manque de précautions',
      'Uniquement si mineur effectivement traumatisé',
      'Uniquement si l’auteur avoue',
    ],
    answer: 'Si diffusion délibérée à des mineurs ou manque de précautions',
    explanation: 'Volonté ou insuffisance de précautions.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Diffusion message — Circonstances aggravantes',
    question:
        'Le texte (227-24) prévoit des circonstances aggravantes spécifiques :',
    options: [
      'Non',
      'Oui, bande organisée obligatoire',
      'Oui, mineur < 15 seulement',
    ],
    answer: 'Non',
    explanation: 'Le cours indique : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion message — Répression',
    question: 'La peine principale prévue à 227-24 al.1 est :',
    options: [
      '3 ans d’emprisonnement et 75 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Le tableau du cours prévoit 3 ans et 75 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Diffusion message — Tentative',
    question: 'La tentative de l’infraction 227-24 est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable seulement si récidive',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours indique : tentative non.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion message — Complicité',
    question: 'La complicité de 227-24 est :',
    options: ['Punissable', 'Non punissable', 'Uniquement civile'],
    answer: 'Punissable',
    explanation: 'Le cours indique : complicité oui (121-7).',
    difficulty: 'Facile',
  ),

  // =====================
  // PROVOCATION À LA PÉDOPORNOGRAPHIE — 227-28-3 (suite)
  // =====================
  const QuizQuestion(
    category: 'Provocation pédopornographie — Fondement',
    question: 'La provocation à la pédopornographie est prévue par :',
    options: [
      'L’article 227-28-3 du Code pénal',
      'L’article 227-23 du Code pénal',
      'L’article 227-21 du Code pénal',
    ],
    answer: 'L’article 227-28-3 du Code pénal',
    explanation: 'Le cours vise expressément 227-28-3.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Acte',
    question: 'La provocation (227-28-3) consiste notamment à :',
    options: [
      'Faire des offres/promesses/proposer des dons/avantages',
      'Tenir des propos vagues',
      'Se taire',
    ],
    answer: 'Faire des offres/promesses/proposer des dons/avantages',
    explanation: 'Le texte décrit les moyens de provocation.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Infractions visées',
    question: 'La provocation vise notamment des infractions dont :',
    options: [
      'La corruption de mineur (227-22) et la pédopornographie (227-23)',
      'Uniquement le vol',
      'Uniquement les contraventions',
    ],
    answer: 'La corruption de mineur (227-22) et la pédopornographie (227-23)',
    explanation:
        'Le cours liste : proxénétisme, corruption, 227-23, atteintes sexuelles, etc.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Mineur',
    question: 'La victime des crimes/délits visés (227-28-3) doit être :',
    options: ['Un mineur', 'Un majeur', 'Indifférent'],
    answer: 'Un mineur',
    explanation: 'Le texte vise des faits “à l’encontre d’un mineur”.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Réalisation',
    question:
        'Pour 227-28-3, le crime ou le délit provoqué doit avoir été commis ou tenté :',
    options: [
      'Non, l’infraction réside dans la provocation',
      'Oui, obligatoirement',
      'Oui, seulement si paiement',
    ],
    answer: 'Non, l’infraction réside dans la provocation',
    explanation:
        'Le texte précise que le crime/délit ne doit être ni commis ni tenté.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Élément moral',
    question: 'L’élément moral repose sur :',
    options: [
      'La volonté de faire commettre une infraction à un tiers',
      'Une erreur sur l’âge',
      'Un mobile de vengeance obligatoire',
    ],
    answer: 'La volonté de faire commettre une infraction à un tiers',
    explanation: 'Infraction intentionnelle (offres/promesses…).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Aggravations',
    question: 'Le texte 227-28-3 prévoit des circonstances aggravantes :',
    options: ['Non', 'Oui, systématiquement', 'Oui, si mineur < 15 ans'],
    answer: 'Non',
    explanation: 'Le cours mentionne : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Répression délit',
    question: 'Si la provocation porte sur un délit, la peine est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans et 30 000 €',
      '5 ans et 75 000 €',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le tableau du cours indique 3 ans et 45 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Répression crime',
    question: 'Si la provocation porte sur un crime, la peine est :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans et 75 000 €',
      '10 ans et 150 000 €',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Le tableau du cours indique 7 ans et 100 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Tentative',
    question: 'La tentative de 227-28-3 est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable seulement si bande organisée',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours indique : tentative non.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Complicité',
    question: 'La complicité de 227-28-3 est :',
    options: ['Non', 'Oui', 'Uniquement civile'],
    answer: 'Non',
    explanation: 'Le cours précise : complicité non.',
    difficulty: 'Facile',
  ),

  // =====================
  // PROVOCATION MINEUR À L’ALCOOL — 227-19 (suite)
  // =====================
  const QuizQuestion(
    category: 'Provocation alcool — Fondement',
    question:
        'La provocation directe d’un mineur à la consommation excessive ou habituelle d’alcool est prévue par :',
    options: [
      'L’article 227-19 du Code pénal',
      'L’article 227-21 du Code pénal',
      'L’article 227-18 du Code pénal',
    ],
    answer: 'L’article 227-19 du Code pénal',
    explanation: 'Le cours vise l’article 227-19 CP.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Notion',
    question: 'Les “boissons alcooliques” visées sont celles comportant :',
    options: [
      'Des traces d’alcool supérieures à 1,2°',
      'Plus de 0,2°',
      'Exactement 10°',
    ],
    answer: 'Des traces d’alcool supérieures à 1,2°',
    explanation: 'Le cours renvoie au seuil du code de la santé publique.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Excessive',
    question:
        'La provocation directe à la consommation excessive d’alcool consiste notamment à :',
    options: [
      'Faire boire jusqu’à l’ivresse un mineur',
      'Faire boire un verre d’eau',
      'Interdire l’alcool',
    ],
    answer: 'Faire boire jusqu’à l’ivresse un mineur',
    explanation:
        'Le cours décrit cette hypothèse (présence/participation active).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Habituelle',
    question: 'La consommation habituelle d’alcool traduit :',
    options: [
      'Un caractère répété / intervention de l’entourage',
      'Un acte unique',
      'Une contravention',
    ],
    answer: 'Un caractère répété / intervention de l’entourage',
    explanation: 'Le cours explique l’objectif de prévention de la dépendance.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Directe',
    question: 'La provocation doit être :',
    options: ['Directe', 'Indirecte seulement', 'Toujours par écrit'],
    answer: 'Directe',
    explanation: 'Le cours insiste sur la provocation directe et précise.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Mineur',
    question: 'La provocation doit s’adresser :',
    options: [
      'À un mineur (tout âge)',
      'Uniquement à un mineur < 6 ans',
      'À un majeur',
    ],
    answer: 'À un mineur (tout âge)',
    explanation: 'Le texte vise tout mineur, avec aggravation si < 15 ans.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Élément moral',
    question: 'L’élément moral consiste en :',
    options: [
      'La conscience d’inciter un mineur à consommer habituellement/excessivement',
      'Une erreur sur l’âge',
      'Une ITT',
    ],
    answer:
        'La conscience d’inciter un mineur à consommer habituellement/excessivement',
    explanation: 'Infraction intentionnelle.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Aggravations',
    question: 'L’article 227-19 al.3 aggrave notamment lorsque :',
    options: [
      'La provocation vise un mineur de 15 ans',
      'Le mineur est majeur',
      'L’auteur est mineur',
    ],
    answer: 'La provocation vise un mineur de 15 ans',
    explanation:
        'Circ. aggravante : mineur de 15 ans + lieux scolaires/administration.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Tentative',
    question: 'La tentative de 227-19 est :',
    options: ['Non punissable', 'Punissable', 'Toujours punissable'],
    answer: 'Non punissable',
    explanation: 'Le cours indique : tentative non.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Complicité',
    question: 'La complicité de 227-19 est :',
    options: ['Punissable', 'Non punissable', 'Uniquement civile'],
    answer: 'Punissable',
    explanation: 'Le cours indique : complicité oui.',
    difficulty: 'Facile',
  ),

  // =====================
  // PROVOCATION MINEUR AUX STUPÉFIANTS — 227-18 / 227-18-1 (suite)
  // =====================
  const QuizQuestion(
    category: 'Provocation stupéfiants — Fondement usage',
    question:
        'La provocation d’un mineur à faire un usage illicite de stupéfiants est prévue par :',
    options: [
      'L’article 227-18 al.1 du Code pénal',
      'L’article 227-18-1 al.1 du Code pénal',
      'L’article L.3421-4 du CSP uniquement',
    ],
    answer: 'L’article 227-18 al.1 du Code pénal',
    explanation: 'Le cours distingue usage (227-18) et trafic (227-18-1).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation stupéfiants — Fondement trafic',
    question:
        'La provocation d’un mineur à transporter/détenir/offrir/céder des stupéfiants est prévue par :',
    options: [
      'L’article 227-18-1 al.1 du Code pénal',
      'L’article 227-18 al.1 du Code pénal',
      'L’article 227-19 du Code pénal',
    ],
    answer: 'L’article 227-18-1 al.1 du Code pénal',
    explanation:
        'Le trafic (transport/détention/offre/cession) est visé par 227-18-1.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation stupéfiants — Nature',
    question: 'La provocation visée doit être :',
    options: ['Directe', 'Indirecte', 'Toujours écrite'],
    answer: 'Directe',
    explanation:
        'Le cours insiste sur la provocation directe avec lien précis.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation stupéfiants — Apologie',
    question:
        'L’apologie/propagande/publicité favorable à l’usage de stupéfiants est plutôt réprimée par :',
    options: [
      'L’article L.3421-4 du CSP',
      'L’article 227-18 du CP',
      'L’article 227-17 du CP',
    ],
    answer: 'L’article L.3421-4 du CSP',
    explanation:
        'Le cours précise la différence avec 227-18 (directe) et L.3421-4 (apologie).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation stupéfiants — Mineur',
    question: 'L’acte doit être adressé :',
    options: [
      'À un mineur (tout âge)',
      'À un majeur',
      'Uniquement à un mineur < 6 ans',
    ],
    answer: 'À un mineur (tout âge)',
    explanation: 'Tout mineur, aggravation si mineur de 15 ans.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Provocation stupéfiants — Complicité trafic',
    question: 'La provocation à devenir “guetteur” est :',
    options: [
      'Visée (provocation à se rendre complice)',
      'Hors du champ',
      'Une contravention',
    ],
    answer: 'Visée (provocation à se rendre complice)',
    explanation:
        'Le cours indique que la provocation à la complicité de trafic est visée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation stupéfiants — Offrir stupéfiants',
    question:
        'Offrir des stupéfiants à un mineur pour sa consommation personnelle est spécialement prévu par :',
    options: [
      'L’article 222-39 al.2 du Code pénal',
      'L’article 227-18 al.1 du Code pénal',
      'L’article 227-19 du Code pénal',
    ],
    answer: 'L’article 222-39 al.2 du Code pénal',
    explanation:
        'Le cours précise que ce cas est spécialement prévu et aggravé à 222-39 al.2.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation stupéfiants — Aggravations',
    question:
        'Les aggravations (227-18 al.2 et 227-18-1 al.2) incluent notamment :',
    options: [
      'Mineur de 15 ans + lieux scolaires/administration',
      'Paiement',
      'Publicité',
    ],
    answer: 'Mineur de 15 ans + lieux scolaires/administration',
    explanation: 'Le cours liste ces deux aggravations.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation stupéfiants — Tentative',
    question:
        'La tentative des infractions de provocation (227-18 / 227-18-1) est :',
    options: ['Non punissable', 'Punissable', 'Toujours punissable'],
    answer: 'Non punissable',
    explanation: 'Le cours indique : tentative non.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Provocation stupéfiants — Complicité',
    question:
        'La complicité des infractions de provocation (227-18 / 227-18-1) est :',
    options: ['Punissable', 'Non punissable', 'Uniquement civile'],
    answer: 'Punissable',
    explanation: 'Le cours indique : complicité oui.',
    difficulty: 'Facile',
  ),

  // =====================
  // SOUSTRACTION D’UN PARENT À SES OBLIGATIONS — 227-17 (suite)
  // =====================
  const QuizQuestion(
    category: 'Soustraction obligations — Fondement',
    question:
        'La soustraction d’un parent à ses obligations légales est prévue par :',
    options: [
      'L’article 227-17 du Code pénal',
      'L’article 227-15 du Code pénal',
      'L’article 227-24 du Code pénal',
    ],
    answer: 'L’article 227-17 du Code pénal',
    explanation: 'Le cours vise l’article 227-17 CP.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Victime',
    question: 'La victime doit être :',
    options: [
      'Un mineur (moins de 18 ans)',
      'Un mineur de moins de 15 ans uniquement',
      'Un majeur',
    ],
    answer: 'Un mineur (moins de 18 ans)',
    explanation: 'Le texte vise l’enfant mineur sans condition d’âge.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Auteur',
    question: 'L’auteur de l’infraction 227-17 est :',
    options: ['Le père ou la mère', 'Un ascendant quelconque', 'Tout adulte'],
    answer: 'Le père ou la mère',
    explanation:
        'Le texte vise père et mère à l’exclusion des autres ascendants.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Autorité parentale',
    question:
        'L’infraction 227-17 exige que l’auteur ait l’autorité parentale ou la garde :',
    options: [
      'Non, le lien de filiation suffit',
      'Oui, obligatoirement',
      'Oui, uniquement si divorce',
    ],
    answer: 'Non, le lien de filiation suffit',
    explanation:
        'Le cours précise que le texte ne conditionne pas à l’autorité parentale/garde.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Nature',
    question:
        'La soustraction peut être constituée même si le parent reste physiquement au domicile :',
    options: ['Oui', 'Non', 'Uniquement si mineur < 15 ans'],
    answer: 'Oui',
    explanation:
        'Le cours évoque un abandon moral possible sans départ du domicile.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Obligation',
    question: 'Les obligations légales recouvrent notamment :',
    options: [
      'Sécurité, santé, moralité, éducation (art. 371-1 C. civil)',
      'Uniquement alimentation',
      'Uniquement vaccination',
    ],
    answer: 'Sécurité, santé, moralité, éducation (art. 371-1 C. civil)',
    explanation: 'Le cours renvoie à l’article 371-1 du code civil.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Compromission',
    question:
        'Pour être punissable, la soustraction doit être susceptible de :',
    options: [
      'Compromettre santé/sécurité/moralité/éducation',
      'Créer une ITT > 8 jours',
      'Créer une mutilation',
    ],
    answer: 'Compromettre santé/sécurité/moralité/éducation',
    explanation: 'Le texte exige une compromission au moins potentielle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Dommage effectif',
    question: 'Le texte exige que le dommage se soit effectivement réalisé :',
    options: ['Non', 'Oui', 'Uniquement si mineur < 15'],
    answer: 'Non',
    explanation: 'Il suffit que ce soit susceptible de se réaliser.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Motif légitime',
    question:
        'Les faits ne sont punissables que si le parent s’est soustrait :',
    options: [
      'Sans motif légitime',
      'Avec motif légitime',
      'Avec motif religieux',
    ],
    answer: 'Sans motif légitime',
    explanation: 'Le texte vise “sans motif légitime”.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Preuve motif',
    question: 'La preuve du motif légitime :',
    options: [
      'Doit être apportée par le prévenu',
      'Doit être apportée par la victime',
      'Est automatique',
    ],
    answer: 'Doit être apportée par le prévenu',
    explanation: 'Le cours indique que c’est au prévenu d’apporter la preuve.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Élément moral',
    question: 'L’élément moral repose sur :',
    options: [
      'La conscience de se soustraire et du risque de conséquences dommageables',
      'L’intention de tuer',
      'L’intention de voler',
    ],
    answer:
        'La conscience de se soustraire et du risque de conséquences dommageables',
    explanation: 'Infraction intentionnelle selon le cours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Aggravation (crime/délits du mineur)',
    question:
        'L’article 227-17 al.2 aggrave lorsque la soustraction a conduit à :',
    options: [
      'La commission par le mineur d’au moins un crime ou plusieurs délits (condamnations définitives)',
      'Une simple contravention',
      'Une absence de scolarité uniquement',
    ],
    answer:
        'La commission par le mineur d’au moins un crime ou plusieurs délits (condamnations définitives)',
    explanation: 'Aggravation prévue à l’alinéa 2.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Tentative',
    question: 'La tentative de 227-17 est :',
    options: ['Non punissable', 'Punissable', 'Punissable uniquement si al.2'],
    answer: 'Non punissable',
    explanation: 'Le cours indique : tentative non.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Complicité',
    question: 'La complicité de 227-17 est :',
    options: ['Punissable', 'Non punissable', 'Uniquement civile'],
    answer: 'Punissable',
    explanation: 'Le cours indique : complicité oui.',
    difficulty: 'Facile',
  ),

  // =====================
  // MÉGA MIX — QUESTIONS TRANSVERSALES / QCM “PIÈGE”
  // =====================
  const QuizQuestion(
    category: 'Transversal — Âge victime',
    question:
        'Quel texte vise explicitement une victime “mineur de moins de 15 ans” ?',
    options: [
      '227-15 (privation d’aliments/soins)',
      '227-17 (soustraction obligations)',
      '227-24 (diffusion message)',
    ],
    answer: '227-15 (privation d’aliments/soins)',
    explanation: '227-15 vise strictement la victime mineure de 15 ans.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Transversal — Directe vs apologie',
    question: 'Quel texte exige explicitement une provocation “directe” ?',
    options: [
      '227-21 (provocation crime/délit)',
      '227-24 (diffusion message)',
      '227-15 (privation soins)',
    ],
    answer: '227-21 (provocation crime/délit)',
    explanation: '227-21 vise une provocation directe avec lien précis.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Transversal — Tentative punissable',
    question:
        'Parmi ces infractions, laquelle a une tentative punissable selon le cours ?',
    options: [
      'Corruption de mineur (227-22)',
      'Soustraction obligations (227-17)',
      'Diffusion message (227-24)',
    ],
    answer: 'Corruption de mineur (227-22)',
    explanation: 'Le cours indique tentative : oui pour 227-22.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Transversal — Complicité non',
    question:
        'Parmi ces infractions, laquelle a “complicité : non” selon le cours ?',
    options: [
      'Provocation à la pédopornographie (227-28-3)',
      'Corruption de mineur (227-22)',
      'Diffusion message (227-24)',
    ],
    answer: 'Provocation à la pédopornographie (227-28-3)',
    explanation: 'Le cours indique : complicité non pour 227-28-3.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Transversal — Susceptible d’être vu/perçu',
    question:
        'La formule “susceptible d’être vu ou perçu par un mineur” correspond à :',
    options: [
      '227-24 (diffusion message)',
      '227-15 (privation soins)',
      '227-21 (provocation crime/délit)',
    ],
    answer: '227-24 (diffusion message)',
    explanation: 'C’est le critère central de 227-24.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Transversal — Auteur limité',
    question: 'Quel texte limite explicitement l’auteur au “père ou la mère” ?',
    options: ['227-17', '227-15', '227-24'],
    answer: '227-17',
    explanation: 'Le texte 227-17 vise père et mère.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Transversal — Élément moral “conscience du risque”',
    question:
        'Quel texte insiste sur la conscience/prévision d’un mal pour l’enfant sans exiger une volonté de nuire ?',
    options: ['227-15', '227-23', '227-28-3'],
    answer: '227-15',
    explanation: 'Le cours cite Cass. crim. 11 mars 1975 : conscience du mal.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Transversal — Aucun aggravant',
    question:
        'Quel texte indique “Aucune” circonstance aggravante dans le cours ?',
    options: ['227-24', '227-22', '227-21'],
    answer: '227-24',
    explanation:
        'Le cours précise : aucune circonstance aggravante pour 227-24.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Transversal — Réunion sexuelle',
    question:
        'L’organisation de réunions sexuelles avec présence d’un mineur renvoie principalement à :',
    options: ['227-22 al.2', '227-24 al.1', '227-17'],
    answer: '227-22 al.2',
    explanation: 'Cas expressément visé par 227-22 al.2.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Transversal — “Sans motif légitime”',
    question: 'La formule “sans motif légitime” est une condition propre à :',
    options: ['227-17', '227-24', '227-28-3'],
    answer: '227-17',
    explanation: '227-17 exige l’absence de motif légitime.',
    difficulty: 'Facile',
  ),
  // =====================
  // PRIVATION D’ALIMENTS OU DE SOINS — 227-15 / 227-16 (100 Q supplémentaires)
  // =====================

  // ---------- FACILE (1-34) ----------
  const QuizQuestion(
    category: 'Privation aliments/soins — Fondement',
    question:
        'La privation d’aliments ou de soins à un mineur de quinze ans est prévue par :',
    options: [
      'L’article 227-15 du Code pénal',
      'L’article 227-17 du Code pénal',
      'L’article 227-24 du Code pénal',
    ],
    answer: 'L’article 227-15 du Code pénal',
    explanation:
        'Le cours indique que l’article 227-15 CP définit et réprime cette infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Victime',
    question: 'Pour 227-15, la victime doit être :',
    options: [
      'Un mineur de moins de quinze ans',
      'Un mineur de moins de dix-huit ans',
      'Un majeur vulnérable',
    ],
    answer: 'Un mineur de moins de quinze ans',
    explanation: 'Le texte vise un mineur de quinze ans (donc < 15).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Condition',
    question: 'L’infraction exige que la privation compromette :',
    options: [
      'La santé du mineur',
      'La propriété du mineur',
      'La tranquillité publique',
    ],
    answer: 'La santé du mineur',
    explanation:
        'Le cours précise : privation au point de compromettre la santé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Auteur',
    question: 'L’article 227-15 vise comme auteurs possibles notamment :',
    options: [
      'Les ascendants',
      'Uniquement les enseignants',
      'Uniquement les médecins',
    ],
    answer: 'Les ascendants',
    explanation: 'Le cours vise ascendants (père, mère, grands-parents, etc.).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Autorité parentale',
    question: 'L’article 227-15 vise aussi :',
    options: [
      'Les personnes exerçant l’autorité parentale',
      'Uniquement les voisins',
      'Uniquement les policiers',
    ],
    answer: 'Les personnes exerçant l’autorité parentale',
    explanation: 'Le cours cite expressément l’autorité parentale.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Autorité de fait',
    question: 'L’article 227-15 vise également :',
    options: [
      'Les personnes exerçant une autorité de fait',
      'Uniquement les ascendants',
      'Uniquement les tuteurs judiciaires',
    ],
    answer: 'Les personnes exerçant une autorité de fait',
    explanation:
        'Le cours évoque nouveaux conjoints, personnes à qui le mineur est confié, etc.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Privation aliments',
    question: 'La privation d’aliments correspond notamment au fait :',
    options: [
      'De ne pas fournir une nourriture en quantité/qualité suffisante',
      'De ne pas scolariser l’enfant',
      'De l’insulter',
    ],
    answer: 'De ne pas fournir une nourriture en quantité/qualité suffisante',
    explanation: 'Le cours définit la privation d’aliments ainsi.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Privation soins',
    question: 'La privation de soins peut être constituée par :',
    options: [
      'Le défaut d’hygiène ou de soins médicaux nécessaires',
      'Le fait de crier dans la rue',
      'Le fait de refuser un prêt',
    ],
    answer: 'Le défaut d’hygiène ou de soins médicaux nécessaires',
    explanation: 'Le cours mentionne hygiène et soins médicaux.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Présomption',
    question: 'Le cours mentionne une présomption de défaut de soins lorsque :',
    options: [
      'Un enfant de moins de six ans est maintenu sur la voie publique pour mendier',
      'Un enfant refuse de manger',
      'Un enfant manque l’école',
    ],
    answer:
        'Un enfant de moins de six ans est maintenu sur la voie publique pour mendier',
    explanation: 'Le 2e alinéa vise ce cas “notamment”.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Âge < 6 ans',
    question:
        'La situation “enfant de moins de six ans sur la voie publique pour solliciter la générosité” concerne :',
    options: [
      'Une privation de soins (227-15 al.2)',
      'Une diffusion de message (227-24)',
      'Une soustraction (227-17)',
    ],
    answer: 'Une privation de soins (227-15 al.2)',
    explanation:
        'Le cours l’identifie comme “privation de soins” au sens de 227-15.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Complicité',
    question: 'La complicité de 227-15 est :',
    options: ['Punissable', 'Non punissable', 'Toujours exclue'],
    answer: 'Punissable',
    explanation: 'Le cours indique : complicité oui (121-7).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Tentative',
    question: 'La tentative de 227-15 est :',
    options: ['Non punissable', 'Punissable', 'Toujours punissable'],
    answer: 'Non punissable',
    explanation: 'Le cours indique : tentative non.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Personnes morales',
    question: 'Les personnes morales peuvent être responsables de 227-15 via :',
    options: [
      'L’article 227-17-2 du Code pénal',
      'L’article 227-27-2 du Code pénal',
      'L’article 121-2 uniquement sans texte',
    ],
    answer: 'L’article 227-17-2 du Code pénal',
    explanation:
        'Le cours précise la responsabilité des personnes morales à 227-17-2.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Répression simple',
    question: 'La peine principale (simple) de 227-15 est :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '2 ans et 30 000 €',
      '3 ans et 45 000 €',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Le tableau du cours indique 7 ans / 100 000 €.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Aggravation al.3',
    question: 'L’article 227-15 al.3 prévoit une aggravation lorsque :',
    options: [
      'L’auteur a aussi commis sur le même mineur le délit 433-18-1 (non déclaration naissance)',
      'Le mineur a plus de 15 ans',
      'Le parent a divorcé',
    ],
    answer:
        'L’auteur a aussi commis sur le même mineur le délit 433-18-1 (non déclaration naissance)',
    explanation: 'Le cours mentionne expressément 227-15 al.3.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Peine aggravée al.3',
    question: 'En cas d’aggravation (227-15 al.3), la peine devient :',
    options: [
      '10 ans d’emprisonnement et 300 000 € d’amende',
      '7 ans et 100 000 €',
      '5 ans et 75 000 €',
    ],
    answer: '10 ans d’emprisonnement et 300 000 € d’amende',
    explanation: 'Le tableau du cours indique 10 ans / 300 000 €.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Mort',
    question: 'Lorsque la privation d’aliments/soins entraîne la mort :',
    options: [
      'C’est l’article 227-16 du CP',
      'C’est l’article 227-24 du CP',
      'C’est une contravention',
    ],
    answer: 'C’est l’article 227-16 du CP',
    explanation: 'Le cours indique : aggravation “mort” à 227-16.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Nature 227-16',
    question:
        'Lorsque la privation entraîne la mort (227-16), l’infraction devient :',
    options: ['Un crime', 'Un délit', 'Une contravention'],
    answer: 'Un crime',
    explanation:
        'Le tableau du cours classe 227-16 comme crime (30 ans de réclusion).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Peine 227-16',
    question: 'La peine principale prévue à 227-16 est :',
    options: [
      '30 ans de réclusion',
      '20 ans de réclusion',
      '10 ans d’emprisonnement',
    ],
    answer: '30 ans de réclusion',
    explanation: 'Le tableau du cours indique 30 ans de réclusion.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Mineur > 15',
    question: 'Si la victime a plus de 15 ans, 227-15 :',
    options: [
      'Ne s’applique pas (interprétation stricte)',
      'S’applique quand même',
      'S’applique uniquement si l’auteur est ascendant',
    ],
    answer: 'Ne s’applique pas (interprétation stricte)',
    explanation:
        'Le cours précise que 227-15 ne s’applique pas à un mineur > 15.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Exemple du cours',
    question:
        'L’exemple “enfants laissés sans gaz/eau/électricité” est utilisé pour illustrer :',
    options: [
      'La privation de soins/aliments (227-15)',
      'La diffusion de message (227-24)',
      'La corruption de mineur (227-22)',
    ],
    answer: 'La privation de soins/aliments (227-15)',
    explanation:
        'Le cours cite un arrêt (CA Douai, 15 février 2006) comme exemple.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Mendicité',
    question: 'Le simple fait de mendier avec un enfant en bas âge est :',
    options: [
      'Pas en soi constitutif du délit (selon le cours)',
      'Toujours constitutif',
      'Toujours une contravention',
    ],
    answer: 'Pas en soi constitutif du délit (selon le cours)',
    explanation: 'Le cours cite Cass. crim., 12 octobre 2005.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Résultat',
    question:
        'Pour 227-15, il faut prouver que la santé a été atteinte gravement :',
    options: ['Non', 'Oui', 'Uniquement si mineur < 6'],
    answer: 'Non',
    explanation:
        'Le cours précise qu’il suffit que les privations soient susceptibles d’altérer la santé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Élément moral',
    question: 'L’infraction 227-15 est :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Toujours involontaire'],
    answer: 'Intentionnelle',
    explanation: 'Le cours indique : infraction intentionnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Intention de nuire',
    question: 'Pour 227-15, la volonté de nuire est :',
    options: [
      'Non nécessaire',
      'Obligatoire',
      'Toujours présumée irréfragable',
    ],
    answer: 'Non nécessaire',
    explanation:
        'Le cours : ni volonté de nuire ni de causer dommage nécessaires.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Convictions religieuses',
    question:
        'Les convictions religieuses peuvent justifier les privations au sens de 227-15 :',
    options: ['Non', 'Oui', 'Uniquement en cas d’accord du mineur'],
    answer: 'Non',
    explanation:
        'Le cours indique que les convictions religieuses ne justifient pas si risque pour la santé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — “Compromettre la santé”',
    question: '“Compromettre la santé” signifie notamment :',
    options: [
      'Privations susceptibles d’altérer la santé',
      'Obligation d’un certificat d’ITT',
      'Uniquement un décès',
    ],
    answer: 'Privations susceptibles d’altérer la santé',
    explanation: 'Le cours précise que le dommage effectif n’est pas requis.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Lieu',
    question: 'La présomption de défaut de soins mentionne aussi :',
    options: [
      'Espace affecté au transport collectif de voyageurs',
      'Uniquement l’école',
      'Uniquement le domicile',
    ],
    answer: 'Espace affecté au transport collectif de voyageurs',
    explanation:
        'Le cours cite “voie publique ou espace affecté au transport collectif”.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Auteur tuteur',
    question: 'Un tuteur peut entrer dans 227-15 comme :',
    options: [
      'Personne exerçant l’autorité parentale',
      'Personne totalement exclue',
      'Victime',
    ],
    answer: 'Personne exerçant l’autorité parentale',
    explanation: 'Le cours indique qu’un tuteur peut être inclus.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Qualité auteur',
    question: 'L’auteur peut être :',
    options: [
      'Ascendant / autorité parentale / autorité de fait',
      'Uniquement policier',
      'Uniquement voisin',
    ],
    answer: 'Ascendant / autorité parentale / autorité de fait',
    explanation: 'Le cours liste ces trois catégories.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Objet',
    question: 'La privation de soins vise notamment :',
    options: [
      'Hygiène et soins médicaux',
      'Uniquement sport',
      'Uniquement argent de poche',
    ],
    answer: 'Hygiène et soins médicaux',
    explanation: 'Le cours le précise.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Répression',
    question: 'La répression de 227-15 concerne des personnes :',
    options: [
      'Physiques et morales',
      'Uniquement morales',
      'Uniquement physiques',
    ],
    answer: 'Physiques et morales',
    explanation:
        'Le cours prévoit responsabilité des personnes morales via 227-17-2.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Crime/délit',
    question: '227-15 (simple) est classé comme :',
    options: ['Délit', 'Crime', 'Contravention'],
    answer: 'Délit',
    explanation: 'Le tableau de répression indique : délit.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Objectif',
    question: 'Le critère central de 227-15 est :',
    options: [
      'La privation au point de compromettre la santé',
      'Le fait de diffuser un message',
      'Le fait de provoquer un crime',
    ],
    answer: 'La privation au point de compromettre la santé',
    explanation: 'Condition textuelle du 227-15.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Mort',
    question: 'Si la privation entraîne la mort, la qualification est :',
    options: ['227-16', '227-15 al.3', '227-17'],
    answer: '227-16',
    explanation: 'Le cours isole la mort à l’article 227-16.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Nécessité de résultat',
    question: 'Le résultat dommageable doit être effectif pour 227-15 :',
    options: ['Non', 'Oui', 'Uniquement si mineur < 6'],
    answer: 'Non',
    explanation: 'Il suffit qu’il soit susceptible de se réaliser.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Interprétation stricte',
    question:
        'Pourquoi 227-15 ne s’applique pas à un mineur de plus de 15 ans ?',
    options: [
      'Principe d’interprétation stricte de la loi pénale',
      'Parce que c’est une contravention',
      'Parce que l’auteur est toujours mineur',
    ],
    answer: 'Principe d’interprétation stricte de la loi pénale',
    explanation: 'Le cours invoque l’interprétation stricte.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Objet 2',
    question:
        'Le maintien d’un enfant < 6 ans dans un transport collectif pour mendier est cité comme :',
    options: ['Privation de soins', 'Corruption', 'Diffusion de message'],
    answer: 'Privation de soins',
    explanation:
        'Le texte le mentionne explicitement comme privation de soins.',
    difficulty: 'Facile',
  ),

  // ---------- MOYENNE (35-68) ----------
  const QuizQuestion(
    category: 'Privation aliments/soins — Domaine',
    question:
        '227-15 ne vise pas un mineur de plus de quinze ans. Dans ce cas, le cours indique qu’on peut viser :',
    options: [
      'D’autres qualifications (ex : séquestration 224-1 ou 227-17 selon cas)',
      'Uniquement 227-24',
      'Uniquement 227-28-3',
    ],
    answer:
        'D’autres qualifications (ex : séquestration 224-1 ou 227-17 selon cas)',
    explanation:
        'Le cours évoque d’autres qualifications possibles hors champ de 227-15.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Condition “santé”',
    question: 'La compromission de la santé implique :',
    options: [
      'Que les privations soient susceptibles d’altérer la santé',
      'Une ITT obligatoire',
      'Un décès obligatoire',
    ],
    answer: 'Que les privations soient susceptibles d’altérer la santé',
    explanation: 'Le cours précise que le résultat effectif n’est pas exigé.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Appréciation',
    question:
        'Qui apprécie au cas par cas l’impact des privations sur la santé du mineur ?',
    options: ['Les juges du fond', 'Le préfet', 'Le maire'],
    answer: 'Les juges du fond',
    explanation:
        'Le cours indique : appréciation au cas par cas par les juges.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Cas relaxe',
    question:
        'Le cours indique qu’une relaxe est possible si, malgré la situation “mendicité”, l’enfant est :',
    options: [
      'En bonne santé au vu des pièces',
      'Forcément malade',
      'Sans certificat médical',
    ],
    answer: 'En bonne santé au vu des pièces',
    explanation:
        'Exemple du cours : enfant en bonne santé -> pas de compromission retenue.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Élément moral',
    question: 'Selon le cours (Cass. crim., 11 mars 1975), il faut :',
    options: [
      'La conscience / prévision qu’il en résulterait un mal pour l’enfant',
      'Une intention de tuer',
      'Une intention de voler',
    ],
    answer:
        'La conscience / prévision qu’il en résulterait un mal pour l’enfant',
    explanation: 'Le cours cite cette formule pour l’élément moral.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Al.2 “notamment”',
    question: 'La mention “notamment” (al.2) signifie :',
    options: [
      'C’est un exemple de privation de soins parmi d’autres',
      'C’est la seule hypothèse possible',
      'C’est une excuse légale',
    ],
    answer: 'C’est un exemple de privation de soins parmi d’autres',
    explanation: '“Notamment” indique une illustration non exhaustive.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Mendicité seule',
    question:
        'Pourquoi le “simple fait de mendier avec un enfant” n’est pas toujours suffisant ?',
    options: [
      'Il faut que la santé soit compromise/susceptible de l’être',
      'Il faut une bande organisée',
      'Il faut un réseau électronique',
    ],
    answer: 'Il faut que la santé soit compromise/susceptible de l’être',
    explanation:
        'Le cours insiste sur l’exigence de compromission de la santé.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Auteur “autorité de fait”',
    question:
        'Un concubin du parent qui exerce une autorité sur le mineur peut être :',
    options: [
      'Auteur au titre d’une autorité de fait',
      'Toujours exclu du texte',
      'Seulement complice',
    ],
    answer: 'Auteur au titre d’une autorité de fait',
    explanation: 'Le cours cite “nouveaux époux ou concubins”.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Exemple CA Douai',
    question:
        'Dans l’exemple CA Douai 15 février 2006, les enfants ne pouvaient pas cuire faute de :',
    options: ['Gaz', 'Télévision', 'Internet'],
    answer: 'Gaz',
    explanation: 'Le cours mentionne absence de gaz, eau, électricité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — “au point de”',
    question: 'L’expression “au point de compromettre” implique :',
    options: [
      'Un seuil : simple manquement léger insuffisant',
      'Une contravention automatique',
      'Une dispense de preuve',
    ],
    answer: 'Un seuil : simple manquement léger insuffisant',
    explanation:
        'Le cours indique la nécessité d’une compromission (au moins potentielle).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Personnes morales',
    question: 'Les personnes morales encourent notamment :',
    options: [
      'Amende + peines de 131-39 (dissolution, interdiction, etc.)',
      'Uniquement un avertissement',
      'Uniquement une contravention',
    ],
    answer: 'Amende + peines de 131-39 (dissolution, interdiction, etc.)',
    explanation: 'Le cours renvoie à 131-38 et 131-39.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — 227-15 al.3',
    question: 'L’aggravation de 227-15 al.3 est liée à :',
    options: [
      'La non déclaration de naissance (433-18-1) sur le même mineur',
      'Un message violent',
      'Une provocation stupéfiants',
    ],
    answer: 'La non déclaration de naissance (433-18-1) sur le même mineur',
    explanation: 'Le cours le précise.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — 227-16',
    question: 'L’article 227-16 s’applique quand la privation :',
    options: ['A entraîné la mort', 'A duré plus d’un mois', 'A été filmée'],
    answer: 'A entraîné la mort',
    explanation: 'Le cours : 227-16 = mort.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Seuil gravité',
    question: 'Le cours précise que 227-15 n’exige pas :',
    options: [
      'Une atteinte grave effective',
      'Une susceptibilité de dommage',
      'Une qualité d’auteur',
    ],
    answer: 'Une atteinte grave effective',
    explanation: 'Il suffit que ce soit susceptible d’altérer la santé.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Exemple transport collectif',
    question:
        'Le maintien d’un enfant < 6 ans dans un espace de transport collectif est incriminé lorsqu’il est fait :',
    options: [
      'Dans le but de solliciter la générosité des passants',
      'Pour aller à l’école',
      'Pour rendre visite à la famille',
    ],
    answer: 'Dans le but de solliciter la générosité des passants',
    explanation: 'Condition explicitement citée au 2e alinéa.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Interprétation stricte',
    question: 'La mention “mineur de quinze ans” impose que la victime ait :',
    options: [
      'Moins de quinze ans',
      'Moins de dix-huit ans',
      'Moins de treize ans',
    ],
    answer: 'Moins de quinze ans',
    explanation: 'Le cours rappelle la lecture stricte : < 15.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Élément moral (but)',
    question:
        'Pour 227-15, l’auteur doit nécessairement agir avec un but de nuire :',
    options: ['Non', 'Oui', 'Oui seulement si al.3'],
    answer: 'Non',
    explanation: 'Le cours indique : pas besoin de volonté de nuire.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Preuve',
    question: 'Les juges peuvent retenir l’infraction si les privations sont :',
    options: [
      'Susceptibles d’altérer la santé du mineur',
      'Seulement si un décès survient',
      'Seulement si l’enfant avoue',
    ],
    answer: 'Susceptibles d’altérer la santé du mineur',
    explanation: 'Condition rappelée par le cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Nature',
    question: '227-15 réprime principalement :',
    options: [
      'Un manquement grave à l’assistance matérielle (aliments/soins)',
      'La diffusion de pornographie',
      'La provocation à un crime',
    ],
    answer: 'Un manquement grave à l’assistance matérielle (aliments/soins)',
    explanation: 'Objet du texte.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — “sans commentaire particulier”',
    question: 'Le cours indique que la privation d’aliments :',
    options: [
      'Ne nécessite pas de commentaire particulier (définition simple)',
      'Est toujours impossible à prouver',
      'Ne peut jamais être retenue',
    ],
    answer: 'Ne nécessite pas de commentaire particulier (définition simple)',
    explanation: 'Formule reprise dans le cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Soins au quotidien',
    question: 'La privation de soins inclut le fait :',
    options: [
      'De ne pas s’occuper matériellement de l’enfant au quotidien',
      'De ne pas donner d’argent de poche',
      'De ne pas acheter un téléphone',
    ],
    answer: 'De ne pas s’occuper matériellement de l’enfant au quotidien',
    explanation: 'Le cours détaille cette notion.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Compromission',
    question: 'Le texte exige :',
    options: [
      'Une compromission potentielle de la santé',
      'Une compromission potentielle de la propriété',
      'Une compromission potentielle des élections',
    ],
    answer: 'Une compromission potentielle de la santé',
    explanation: 'Formule du texte.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Al.2 et preuve',
    question:
        'Même avec l’al.2 (“< 6 ans sur voie publique”), la défense peut soutenir l’absence d’infraction si :',
    options: [
      'La santé n’est pas compromise (enfant en bonne santé selon pièces)',
      'Il y a un réseau électronique',
      'Il y a une vidéo',
    ],
    answer:
        'La santé n’est pas compromise (enfant en bonne santé selon pièces)',
    explanation: 'Exemple du cours : pas de compromission retenue.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Structure',
    question: 'La mort de la victime bascule vers :',
    options: ['227-16', '227-15 al.3', '227-17 al.2'],
    answer: '227-16',
    explanation: 'Le cours distingue clairement.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Peines morales',
    question: 'Les personnes morales encourent des peines comme :',
    options: [
      'Dissolution, interdiction d’activité, surveillance judiciaire',
      'Emprisonnement',
      'Travaux d’intérêt général obligatoires',
    ],
    answer: 'Dissolution, interdiction d’activité, surveillance judiciaire',
    explanation: 'Référence à 131-39 dans le cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Complicité (modes)',
    question: 'La complicité suppose un fait constitutif comme :',
    options: [
      'Aide/assistance, provocation, instructions',
      'Uniquement présence',
      'Uniquement opinion',
    ],
    answer: 'Aide/assistance, provocation, instructions',
    explanation: 'Rappel droit commun 121-7 indiqué dans le cours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Aggravation al.3 nature',
    question: '227-15 al.3 reste classé :',
    options: ['Délit', 'Crime', 'Contravention'],
    answer: 'Délit',
    explanation: 'Le tableau du cours classe 227-15 al.3 comme délit aggravé.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Crime 227-16',
    question: '227-16 est classé :',
    options: ['Crime', 'Délit', 'Contravention'],
    answer: 'Crime',
    explanation: 'Le cours le classe crime.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Philosophie',
    question: 'La loi vise à protéger particulièrement :',
    options: [
      'Les mineurs de moins de quinze ans',
      'Tous les majeurs',
      'Les entreprises',
    ],
    answer: 'Les mineurs de moins de quinze ans',
    explanation: 'Condition d’âge du texte.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Exemple voisins',
    question:
        'Dans l’exemple du cours, les voisins intervenaient notamment pour :',
    options: ['Donner à manger', 'Payer une amende', 'Éduquer juridiquement'],
    answer: 'Donner à manger',
    explanation:
        'Le cours indique “laissés à la charge des voisins qui leur donnaient à manger”.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Sens “compromettre”',
    question: '“Compromettre la santé” signifie que :',
    options: [
      'La santé est mise en danger par les privations',
      'La santé est forcément détruite',
      'La santé doit être certifiée par un expert uniquement',
    ],
    answer: 'La santé est mise en danger par les privations',
    explanation: 'Le cours insiste sur la susceptibilité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Mineur > 15 (rappel)',
    question: 'Si la victime est mineure mais a 16 ans, 227-15 :',
    options: [
      'Ne peut pas être appliqué (strict)',
      'S’applique automatiquement',
      'S’applique uniquement si l’auteur est mère',
    ],
    answer: 'Ne peut pas être appliqué (strict)',
    explanation: 'Le cours le dit explicitement.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — But de sollicitation',
    question: 'L’al.2 vise le maintien de l’enfant pour :',
    options: ['Solliciter la générosité des passants', 'Scolariser', 'Soigner'],
    answer: 'Solliciter la générosité des passants',
    explanation: 'C’est la condition textuelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Preuve santé',
    question:
        'Pour exclure l’infraction, la défense peut tenter de démontrer :',
    options: [
      'Absence de compromission de la santé',
      'Existence d’un SMS',
      'Existence d’un paiement',
    ],
    answer: 'Absence de compromission de la santé',
    explanation: 'Le cours illustre cette idée via l’exemple.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Cible',
    question: 'La loi pénale vise surtout à sanctionner :',
    options: [
      'La défaillance grave de prise en charge matérielle',
      'Le manque de politesse',
      'La simple pauvreté',
    ],
    answer: 'La défaillance grave de prise en charge matérielle',
    explanation:
        'La privation doit compromettre la santé : ce n’est pas la pauvreté en soi.',
    difficulty: 'Moyenne',
  ),

  // ---------- DIFFICILE (69-100) ----------
  const QuizQuestion(
    category: 'Privation aliments/soins — Éléments constitutifs',
    question: 'Quel enchaînement correspond le mieux à 227-15 ?',
    options: [
      'Victime < 15 + auteur visé + privation aliments/soins + compromission santé + conscience du risque',
      'Victime majeure + menace + ITT > 8 jours',
      'Message violent + réseau électronique + diffusion',
    ],
    answer:
        'Victime < 15 + auteur visé + privation aliments/soins + compromission santé + conscience du risque',
    explanation: 'Le cours détaille éléments matériel et moral ainsi.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Élément moral exact',
    question: 'Le cours indique que l’élément moral exige :',
    options: [
      'Conscience/connaissance/prévision du mal possible, sans volonté de nuire',
      'Volonté de nuire obligatoire',
      'Intention de tuer obligatoire',
    ],
    answer:
        'Conscience/connaissance/prévision du mal possible, sans volonté de nuire',
    explanation:
        'Formule citée (Cass. crim., 11 mars 1975) et commentaire du cours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Al.2 et interprétation',
    question:
        'Le 2e alinéa (“< 6 ans sur voie publique”) doit être compris comme :',
    options: [
      'Une modalité typique de privation de soins, mais la santé doit rester un enjeu central',
      'Une infraction autonome sans condition',
      'Un simple conseil',
    ],
    answer:
        'Une modalité typique de privation de soins, mais la santé doit rester un enjeu central',
    explanation:
        'Le cours montre qu’on discute encore la compromission via l’exemple.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Lien causal',
    question:
        'Pour 227-15, le texte exige que les privations aient effectivement causé une maladie :',
    options: ['Non', 'Oui', 'Oui uniquement si al.3'],
    answer: 'Non',
    explanation: 'Il suffit qu’elles soient susceptibles d’altérer la santé.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Double incrimination',
    question:
        'Le fait de priver un mineur > 15 ans d’aliments/soins peut éventuellement relever :',
    options: [
      'D’autres qualifications (ex : 227-17 ou 224-1 selon hypothèse)',
      'Toujours de 227-15',
      'Jamais d’aucun texte',
    ],
    answer: 'D’autres qualifications (ex : 227-17 ou 224-1 selon hypothèse)',
    explanation: 'Le cours suggère des qualifications alternatives.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Auteur “ascendant”',
    question: 'Sont visés par “ascendants” au sens du cours :',
    options: [
      'Père, mère, grands-parents, arrière-grands-parents',
      'Uniquement père et mère',
      'Uniquement oncle et tante',
    ],
    answer: 'Père, mère, grands-parents, arrière-grands-parents',
    explanation: 'Le cours le précise.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Autorité parentale (délégation)',
    question:
        'Le cours évoque la délégation de l’autorité parentale prévue aux articles :',
    options: [
      '376 à 377-3 du code civil',
      '121-6 à 121-7 du code pénal',
      '222-22 à 222-33-1 du code pénal',
    ],
    answer: '376 à 377-3 du code civil',
    explanation: 'Référence indiquée dans le cours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Autorité de fait (exemples)',
    question:
        'Lequel est un exemple d’autorité de fait mentionné dans le cours ?',
    options: [
      'Responsables et employés des services d’aide à l’enfance',
      'Client d’un magasin',
      'Passant inconnu',
    ],
    answer: 'Responsables et employés des services d’aide à l’enfance',
    explanation:
        'Le cours les cite comme personnes pouvant exercer une autorité de fait.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Cass. 12 oct. 2005',
    question:
        'Le cours indique qu’en 12 octobre 2005, le simple fait de mendier avec un enfant :',
    options: [
      'N’est pas en soi constitutif du délit',
      'Constitue toujours le délit',
      'Relève de 227-24',
    ],
    answer: 'N’est pas en soi constitutif du délit',
    explanation: 'Rappel de l’arrêt cité par le cours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — TGI Paris 13 janv. 2004',
    question:
        'Le cours cite un arrêt confirmant l’exigence “compromettre la santé” :',
    options: [
      'TGI Paris, 13 janvier 2004',
      'Cass. crim., 11 mai 2006',
      'CA Paris, 30 juin 2006',
    ],
    answer: 'TGI Paris, 13 janvier 2004',
    explanation: 'Référence explicitement mentionnée dans le cours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Répartition peines',
    question: 'Quel triptyque correspond correctement aux niveaux de gravité ?',
    options: [
      '227-15 (délit) → 227-15 al.3 (délit aggravé) → 227-16 (crime)',
      '227-16 (contravention) → 227-15 (crime) → 227-15 al.3 (délit)',
      '227-15 (crime) → 227-16 (délit) → 227-17 (contravention)',
    ],
    answer: '227-15 (délit) → 227-15 al.3 (délit aggravé) → 227-16 (crime)',
    explanation: 'C’est la structure indiquée par le tableau du cours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Lien 433-18-1',
    question:
        'L’aggravation 227-15 al.3 suppose que la personne s’est rendue coupable :',
    options: [
      'Sur le même mineur, du délit 433-18-1',
      'Sur n’importe quel mineur, du délit 227-24',
      'Sur un majeur, du délit 227-17',
    ],
    answer: 'Sur le même mineur, du délit 433-18-1',
    explanation: 'Condition textuelle rappelée par le cours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Santé “en bonne santé”',
    question:
        'Selon le cours, même avec maintien sur voie publique, les juges peuvent relaxer si :',
    options: [
      'L’enfant est en bonne santé selon pièces',
      'Le parent est au chômage',
      'La ville est petite',
    ],
    answer: 'L’enfant est en bonne santé selon pièces',
    explanation: 'Exemple commenté dans le cours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Négligence vs intention',
    question: '227-15 est intentionnel, mais n’exige pas :',
    options: [
      'La volonté de nuire',
      'La conscience du risque',
      'La qualité d’auteur',
    ],
    answer: 'La volonté de nuire',
    explanation: 'Le cours : conscience du risque oui, volonté de nuire non.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Support “transport collectif”',
    question:
        'Le texte mentionne l’“espace affecté au transport collectif” pour viser :',
    options: [
      'Une modalité de privation de soins (al.2)',
      'Une modalité de diffusion de message',
      'Une modalité de provocation stupéfiants',
    ],
    answer: 'Une modalité de privation de soins (al.2)',
    explanation: 'C’est un élément de l’al.2.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Distinction 227-17',
    question: 'Différence principale entre 227-15 et 227-17 (cours) :',
    options: [
      '227-15 : aliments/soins + < 15 ans ; 227-17 : soustraction obligations + mineur < 18',
      '227-15 : message violent ; 227-17 : pornographie',
      '227-15 : provocation ; 227-17 : terrorisme',
    ],
    answer:
        '227-15 : aliments/soins + < 15 ans ; 227-17 : soustraction obligations + mineur < 18',
    explanation: 'Distinction d’âge et d’objet indiquée dans les textes.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Droit commun complicité',
    question: 'Le fondement de la complicité renvoyé par le cours est :',
    options: [
      'L’article 121-7 du Code pénal',
      'L’article 371-1 du code civil',
      'L’article R.623-1 du Code pénal',
    ],
    answer: 'L’article 121-7 du Code pénal',
    explanation:
        'Le cours renvoie explicitement au droit commun de la complicité.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Non déclaration naissance',
    question:
        'Le délit de non déclaration d’une naissance à l’officier d’état civil est :',
    options: ['433-18-1', '227-23', '222-39'],
    answer: '433-18-1',
    explanation: 'Référence citée dans le cours à propos de l’aggravation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Nature “privation de soins”',
    question:
        'Le cours précise que la privation de soins consiste notamment à :',
    options: [
      'Ne pas fournir les soins que la prise en charge réclame (hygiène/soins médicaux)',
      'Ne pas acheter de jouets',
      'Ne pas donner de cours particuliers',
    ],
    answer:
        'Ne pas fournir les soins que la prise en charge réclame (hygiène/soins médicaux)',
    explanation: 'Définition du cours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Champ strict',
    question: 'Pourquoi 227-15 est d’application stricte ?',
    options: [
      'Parce que la loi pénale est d’interprétation stricte et vise < 15 ans',
      'Parce que c’est une règle de procédure',
      'Parce que c’est un texte civil',
    ],
    answer:
        'Parce que la loi pénale est d’interprétation stricte et vise < 15 ans',
    explanation: 'Le cours insiste sur l’interprétation stricte.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Échelle peines',
    question: 'Quelle progression de peine est correcte ?',
    options: [
      '7 ans/100k → 10 ans/300k → 30 ans réclusion',
      '2 ans/30k → 3 ans/45k → 5 ans/75k',
      '5 ans/75k → 7 ans/100k → 10 ans/150k',
    ],
    answer: '7 ans/100k → 10 ans/300k → 30 ans réclusion',
    explanation: 'Correspond aux tableaux 227-15, 227-15 al.3, 227-16.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Qualification “crime”',
    question: 'La bascule en “crime” intervient uniquement si :',
    options: [
      'La privation a entraîné la mort (227-16)',
      'La privation a duré 10 jours',
      'La privation est filmée',
    ],
    answer: 'La privation a entraîné la mort (227-16)',
    explanation: 'Selon le tableau de répression.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Lien voisinage',
    question:
        'Dans l’exemple, le fait que les voisins nourrissent les enfants montre surtout :',
    options: [
      'La carence de prise en charge par l’auteur',
      'La complicité des voisins',
      'L’absence totale d’infraction',
    ],
    answer: 'La carence de prise en charge par l’auteur',
    explanation: 'L’exemple sert à caractériser la privation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Responsabilité morale',
    question:
        'Le cours précise que les personnes morales encourent l’amende selon :',
    options: ['131-38 du CP', '227-22 du CP', 'R.623-2 du CP'],
    answer: '131-38 du CP',
    explanation: 'Référence explicite dans le cours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Peines complémentaires morales',
    question:
        'Les peines complémentaires des personnes morales sont mentionnées aux :',
    options: [
      '2° à 5° et 7° à 9° de 131-39 du CP',
      '1° à 3° de 222-12 du CP',
      'alinéas 1 à 2 de 227-24',
    ],
    answer: '2° à 5° et 7° à 9° de 131-39 du CP',
    explanation: 'Le cours le détaille.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Logique “prévention”',
    question:
        'Le texte sanctionne même si le dommage ne s’est pas produit pour :',
    options: [
      'Intervenir avant l’atteinte effective à la santé',
      'Punir la pauvreté',
      'Créer une contravention',
    ],
    answer: 'Intervenir avant l’atteinte effective à la santé',
    explanation:
        'Le cours : dommage effectif non requis, susceptibilité suffit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Carence effective',
    question:
        'Le cours insiste que, même si le dommage n’est pas effectif, la carence doit être :',
    options: ['Effective', 'Fictive', 'Supposée sans preuve'],
    answer: 'Effective',
    explanation: 'Il faut une privation réelle (faits matériels).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — “but” al.2',
    question: 'Dans l’al.2, le but exigé est :',
    options: [
      'Solliciter la générosité des passants',
      'Se protéger',
      'Travailler',
    ],
    answer: 'Solliciter la générosité des passants',
    explanation: 'C’est dans la lettre du texte.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Exclusion “mineur >15”',
    question: 'La conséquence directe de l’exclusion “mineur > 15” est :',
    options: [
      'Ne pas utiliser 227-15, chercher une autre qualification',
      'Classer sans suite automatiquement',
      'Transformer en contravention',
    ],
    answer: 'Ne pas utiliser 227-15, chercher une autre qualification',
    explanation: 'Le cours évoque des qualifications alternatives.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category:
        'Privation aliments/soins — Distinction “privation” vs “soustraction”',
    question:
        '227-15 vise une privation matérielle, tandis que 227-17 vise surtout :',
    options: [
      'Une défaillance parentale globale (obligations légales)',
      'Une diffusion de message',
      'Une consultation de site',
    ],
    answer: 'Une défaillance parentale globale (obligations légales)',
    explanation: 'Selon les définitions du cours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Réalisation',
    question: 'La privation d’aliments/soins est une infraction :',
    options: [
      'De commission par omission qualifiée (privation) avec exigence “santé compromise”',
      'De presse',
      'De terrorisme',
    ],
    answer:
        'De commission par omission qualifiée (privation) avec exigence “santé compromise”',
    explanation: 'Le texte incrimine la privation (défaut de fournir).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Placement sous surveillance',
    question:
        'Parmi les peines possibles pour une personne morale, le cours cite :',
    options: [
      'Placement sous surveillance judiciaire',
      'Peine de prison',
      'Interdiction de séjour pour un individu',
    ],
    answer: 'Placement sous surveillance judiciaire',
    explanation: 'Le cours mentionne cette peine dans l’énumération.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — “nourriture qualité”',
    question:
        'La privation d’aliments inclut la qualité insuffisante, ce qui implique :',
    options: [
      'Pas seulement la quantité, mais aussi l’adéquation',
      'Uniquement la quantité',
      'Uniquement l’eau',
    ],
    answer: 'Pas seulement la quantité, mais aussi l’adéquation',
    explanation: 'Le cours parle de quantité ou qualité suffisante.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — “soins médicaux”',
    question:
        'Le refus de soins médicaux nécessaires, avec conscience du risque, peut :',
    options: [
      'Caractériser la privation de soins si santé compromise/susceptible',
      'Être toujours sans conséquence pénale',
      'Devenir automatiquement 227-24',
    ],
    answer:
        'Caractériser la privation de soins si santé compromise/susceptible',
    explanation: 'Définition de la privation de soins + condition de santé.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Échelle “temps”',
    question: 'Le texte 227-15 fixe un délai minimum de privation (ex : 48h) :',
    options: ['Non', 'Oui', 'Oui pour mineur < 6'],
    answer: 'Non',
    explanation:
        'Le cours ne fixe pas de durée, il vise l’effet sur la santé (risque).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Cumul',
    question: 'Si la privation mène à la mort, on retient en principe :',
    options: [
      '227-16 (crime) pour le résultat mortel',
      'Uniquement 227-15 simple',
      'Uniquement 227-24',
    ],
    answer: '227-16 (crime) pour le résultat mortel',
    explanation: 'Le cours distingue le cas mortel.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Sens “autorité sur un mineur”',
    question: '“Ayant une autorité sur un mineur” inclut notamment :',
    options: [
      'Personnes à qui le mineur a été confié par ses parents',
      'Toute personne croisée dans la rue',
      'Uniquement les magistrats',
    ],
    answer: 'Personnes à qui le mineur a été confié par ses parents',
    explanation: 'Exemple mentionné dans le cours.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Interprétation stricte (piège)',
    question:
        'Un mineur de 15 ans pile (le jour de ses 15 ans) est dans le champ de 227-15 :',
    options: [
      'Non (le texte vise “mineur de quinze ans” donc < 15 selon le cours)',
      'Oui',
      'Oui uniquement si al.3',
    ],
    answer:
        'Non (le texte vise “mineur de quinze ans” donc < 15 selon le cours)',
    explanation: 'Le cours explique : “donc âgé de moins de quinze ans”.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Articulation',
    question: 'Le cœur de l’élément matériel est :',
    options: [
      'Privation + compromission de la santé',
      'Simple présence sur la voie publique',
      'Un message violent',
    ],
    answer: 'Privation + compromission de la santé',
    explanation: 'Le cours insiste sur ce couple.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Délit aggravé vs crime',
    question: 'Le seul cas où le cours qualifie “crime” ici est :',
    options: ['227-16 (mort)', '227-15 al.3', '227-15 simple'],
    answer: '227-16 (mort)',
    explanation: 'Les autres restent des délits.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Exclusion “simple mendicité”',
    question:
        'Le cours précise que la mendicité avec un enfant ne suffit pas “en soi” car :',
    options: [
      'Il faut que la privation compromette/susceptible de compromettre la santé',
      'Il faut un écrit',
      'Il faut une réitération',
    ],
    answer:
        'Il faut que la privation compromette/susceptible de compromettre la santé',
    explanation: 'Condition essentielle du texte.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Conclusion',
    question: 'Quel couple “tentative/complicité” est correct pour 227-15 ?',
    options: [
      'Tentative : non ; Complicité : oui',
      'Tentative : oui ; Complicité : non',
      'Tentative : oui ; Complicité : oui',
    ],
    answer: 'Tentative : non ; Complicité : oui',
    explanation:
        'Le cours indique explicitement : tentative non, complicité oui.',
    difficulty: 'Difficile',
  ),
  // =====================
  // BANQUE SUPPLÉMENTAIRE — 60 QUESTIONS (3 niveaux) — MISE EN PÉRIL DES MINEURS
  // (à coller directement sous les précédentes QuizQuestion)
  // =====================

  // ---------- CORRUPTION DE MINEUR — 227-22 (FACILE 1-12) ----------
  const QuizQuestion(
    category: 'Corruption de mineur — Fondement',
    question: 'La corruption de mineur est prévue et réprimée par :',
    options: [
      'L’article 227-22 alinéa 1 et 2 du Code pénal',
      'L’article 227-24 alinéa 1 du Code pénal',
      'L’article 227-23 alinéa 4 du Code pénal',
    ],
    answer: 'L’article 227-22 alinéa 1 et 2 du Code pénal',
    explanation:
        'Le cours indique que 227-22 al.1 et 2 CP prévoit et réprime la corruption de mineur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Définition',
    question: 'Constitue notamment une corruption de mineur :',
    options: [
      'Favoriser ou tenter de favoriser la corruption d’un mineur',
      'Refuser une carte d’identité',
      'Diffuser un message violent à un adulte',
    ],
    answer: 'Favoriser ou tenter de favoriser la corruption d’un mineur',
    explanation:
        'Le cours vise le fait de favoriser ou tenter de favoriser la corruption d’un mineur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Auteur',
    question: 'Pour l’alinéa 1 de 227-22, l’auteur peut être :',
    options: [
      'Un mineur ou un majeur',
      'Uniquement un majeur',
      'Uniquement un mineur',
    ],
    answer: 'Un mineur ou un majeur',
    explanation:
        'Le cours précise que l’alinéa 1 ne fixe pas de condition d’âge : auteur mineur ou majeur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Victime',
    question: 'La victime de corruption de mineur doit être :',
    options: [
      'Un mineur de 18 ans',
      'Un mineur de 15 ans uniquement',
      'Un majeur vulnérable',
    ],
    answer: 'Un mineur de 18 ans',
    explanation:
        'Le cours indique : victime mineure de 18 ans, quel que soit le sexe/la moralité.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Consentement',
    question: 'Le consentement du mineur (corruption de mineur) :',
    options: [
      'Est indifférent',
      'Exclut toujours l’infraction',
      'Transforme l’infraction en contravention',
    ],
    answer: 'Est indifférent',
    explanation: 'Le cours précise : il importe peu qu’il soit consentant.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Acte',
    question: 'Un acte de corruption vise notamment à :',
    options: [
      'Éveiller ou exciter la dépravation sexuelle chez un mineur',
      'Empêcher toute scolarisation',
      'Organiser une grève',
    ],
    answer: 'Éveiller ou exciter la dépravation sexuelle chez un mineur',
    explanation:
        'Définition donnée : éveiller/exciter la dépravation sexuelle ou aider à satisfaire des pulsions.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Propos',
    question: 'Les simples propos obscènes, seuls :',
    options: [
      'Sont insuffisants s’ils ne sont pas persistants et précis',
      'Suffisent toujours',
      'Ne sont jamais pris en compte',
    ],
    answer: 'Sont insuffisants s’ils ne sont pas persistants et précis',
    explanation:
        'Le cours indique qu’il faut des conseils persistants et précis.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Effet sur la victime',
    question: 'Il faut prouver que le mineur a effectivement été troublé :',
    options: ['Non', 'Oui', 'Oui seulement si mineur < 15'],
    answer: 'Non',
    explanation:
        'Le cours précise : pas nécessaire d’établir un trouble effectif ni un passage à l’acte.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Réunions (al.2)',
    question: 'L’article 227-22 al.2 vise notamment un majeur qui :',
    options: [
      'Organise des réunions sexuelles auxquelles un mineur assiste ou participe',
      'Diffuse un message violent',
      'Fait des propositions sexuelles en ligne',
    ],
    answer:
        'Organise des réunions sexuelles auxquelles un mineur assiste ou participe',
    explanation:
        'Le cours mentionne l’organisation de réunions avec exhibitions/relations sexuelles.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Élément moral',
    question: 'La corruption de mineur est :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Toujours involontaire'],
    answer: 'Intentionnelle',
    explanation:
        'Le cours : conscience de l’obscénité + âge + volonté de corrompre.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Tentative',
    question: 'La tentative de corruption de mineur (227-22) est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable seulement si bande organisée',
    ],
    answer: 'Punissable',
    explanation: 'Le cours indique : tentative OUI, prévue à l’alinéa 1.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Corruption de mineur — Complicité',
    question: 'La complicité en matière de corruption de mineur est :',
    options: [
      'Applicable',
      'Jamais applicable',
      'Applicable uniquement aux mineurs',
    ],
    answer: 'Applicable',
    explanation: 'Le cours : complicité OUI (121-7 CP).',
    difficulty: 'Facile',
  ),

  // ---------- DIFFUSION MESSAGE — 227-24 (FACILE 13-22) ----------
  const QuizQuestion(
    category: 'Diffusion de message — Fondement',
    question:
        'La diffusion d’un message violent/porno/dangereux susceptible d’être vu par un mineur est prévue par :',
    options: [
      'L’article 227-24 alinéa 1 du Code pénal',
      'L’article 227-22 alinéa 1 du Code pénal',
      'L’article 227-23 alinéa 2 du Code pénal',
    ],
    answer: 'L’article 227-24 alinéa 1 du Code pénal',
    explanation:
        'Le cours : 227-24 al.1 CP prévoit et réprime cette diffusion.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion de message — Message',
    question: 'Le terme « message » doit être entendu :',
    options: [
      'Au sens le plus large possible',
      'Uniquement comme un SMS',
      'Uniquement comme un article de presse',
    ],
    answer: 'Au sens le plus large possible',
    explanation:
        'Le cours : message au sens large (lettre, œuvre, peinture, etc.).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion de message — Support',
    question: 'Le support (papier, vidéo, en ligne…) est :',
    options: [
      'Indifférent',
      'Obligatoirement numérique',
      'Obligatoirement papier',
    ],
    answer: 'Indifférent',
    explanation:
        'Le cours : diffusion par quelque moyen que ce soit, quel qu’en soit le support.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion de message — Condition mineur',
    question:
        'Pour 227-24, il faut qu’un mineur ait effectivement vu le message :',
    options: ['Non', 'Oui', 'Oui seulement si pornographique'],
    answer: 'Non',
    explanation:
        'Le cours : il suffit que le message soit susceptible d’être vu ou perçu par un mineur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion de message — Actes matériels',
    question: 'Les actes matériels visés par 227-24 comprennent notamment :',
    options: [
      'Fabriquer, transporter, diffuser ou faire commerce',
      'Uniquement consulter',
      'Uniquement détenir',
    ],
    answer: 'Fabriquer, transporter, diffuser ou faire commerce',
    explanation:
        'Le cours énumère ces actes (fabrication, transport, diffusion, commerce).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion de message — Jeux dangereux',
    question:
        'Sont visés les messages incitant des mineurs à des jeux les mettant :',
    options: [
      'Physiquement en danger',
      'Financièrement riches',
      'Administrativement en règle',
    ],
    answer: 'Physiquement en danger',
    explanation: 'Le cours cite l’exemple du “jeu du foulard”.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion de message — Élément moral',
    question: 'L’élément moral de 227-24 est réalisé :',
    options: [
      'En cas de diffusion délibérée ou par manque de précautions suffisantes',
      'Uniquement si la victime porte plainte',
      'Uniquement si le message est vendu',
    ],
    answer:
        'En cas de diffusion délibérée ou par manque de précautions suffisantes',
    explanation:
        'Le cours : intention + négligence/imprudence permettant l’accès des mineurs.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion de message — Circonstances aggravantes',
    question: '227-24 prévoit des circonstances aggravantes :',
    options: ['Non', 'Oui', 'Oui uniquement si mineur < 15'],
    answer: 'Non',
    explanation: 'Le cours indique : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion de message — Tentative',
    question: 'La tentative de 227-24 est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable seulement si bande organisée',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours : tentative NON.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion de message — Peine',
    question: 'La peine principale prévue par 227-24 al.1 est :',
    options: [
      '3 ans d’emprisonnement et 75 000 € d’amende',
      '5 ans et 100 000 €',
      '2 ans et 30 000 €',
    ],
    answer: '3 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Le tableau du cours mentionne 3 ans / 75 000 €.',
    difficulty: 'Facile',
  ),

  // ---------- PROVOCATION À LA PÉDOPORNOGRAPHIE — 227-28-3 (MOYENNE 23-34) ----------
  const QuizQuestion(
    category: 'Provocation pédopornographie — Fondement',
    question: 'La provocation à la pédopornographie est prévue par :',
    options: [
      'L’article 227-28-3 du Code pénal',
      'L’article 227-23 alinéa 4 du Code pénal',
      'L’article 227-19 du Code pénal',
    ],
    answer: 'L’article 227-28-3 du Code pénal',
    explanation:
        'Le cours : 227-28-3 CP prévoit et réprime la provocation à la pédopornographie.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Acte',
    question: 'La provocation (227-28-3) consiste notamment à :',
    options: [
      'Faire des offres/promesses ou proposer des dons/avantages',
      'Se contenter d’avoir une opinion',
      'Refuser un contrôle',
    ],
    answer: 'Faire des offres/promesses ou proposer des dons/avantages',
    explanation:
        'Le cours reprend les termes : offres, promesses, dons, présents, avantages.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Victime',
    question: 'La provocation vise des crimes/délits à l’encontre :',
    options: ['D’un mineur', 'D’un majeur', 'D’un fonctionnaire uniquement'],
    answer: 'D’un mineur',
    explanation:
        'Le cours : la victime des faits visés doit être un mineur (en l’absence de précision : < 18).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Condition',
    question:
        'Pour 227-28-3, l’infraction provoquée doit avoir été commise ou tentée :',
    options: [
      'Non (elle ne doit ni avoir été commise ni tentée)',
      'Oui, c’est obligatoire',
      'Oui seulement si bande organisée',
    ],
    answer: 'Non (elle ne doit ni avoir été commise ni tentée)',
    explanation:
        'Le cours : l’infraction réside dans la provocation, crime/délit non commis ni tenté.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Objet',
    question: 'Le texte 227-28-3 vise des infractions listées, dont :',
    options: [
      'La corruption de mineur (227-22) et l’exploitation pornographique (227-23)',
      'Uniquement les stupéfiants',
      'Uniquement l’alcool',
    ],
    answer:
        'La corruption de mineur (227-22) et l’exploitation pornographique (227-23)',
    explanation:
        'Le cours liste proxénétisme, corruption, 227-23, atteintes sexuelles 227-25 à 227-28.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Élément moral',
    question: '227-28-3 est une infraction :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Contraventionnelle'],
    answer: 'Intentionnelle',
    explanation:
        'Le cours : volonté de faire commettre une infraction à autrui via offres/promesses.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Répression (délit)',
    question: 'Si la provocation porte sur un délit, la peine est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans et 30 000 €',
      '5 ans et 75 000 €',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le cours : 3 ans / 45 000 € si provocation portant sur un délit.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Répression (crime)',
    question: 'Si la provocation porte sur un crime, la peine est :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '10 ans et 150 000 €',
      '5 ans et 75 000 €',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation:
        'Le cours : 7 ans / 100 000 € si provocation portant sur un crime.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Tentative',
    question: 'La tentative de 227-28-3 est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable seulement si mineur < 15',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours : tentative NON.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation pédopornographie — Complicité',
    question: 'La complicité de 227-28-3 est :',
    options: ['Non', 'Oui', 'Oui seulement si bande organisée'],
    answer: 'Non',
    explanation: 'Le cours indique : complicité NON.',
    difficulty: 'Moyenne',
  ),

  // ---------- PROVOCATION DIRECTE D’UN MINEUR À COMMETTRE CRIME/DÉLIT — 227-21 (MOYENNE 35-44) ----------
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Fondement',
    question:
        'La provocation directe d’un mineur à commettre un crime ou un délit est prévue par :',
    options: [
      'L’article 227-21 alinéa 1 du Code pénal',
      'L’article 227-28-3 du Code pénal',
      'L’article 227-15 du Code pénal',
    ],
    answer: 'L’article 227-21 alinéa 1 du Code pénal',
    explanation:
        'Le cours : 227-21 al.1 CP réprime la provocation d’un mineur à commettre crime/délit.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Directe',
    question:
        'La provocation doit être qualifiée de “directe”, ce qui implique :',
    options: [
      'Un lien précis et étroit avec des faits déterminés',
      'Une simple publicité générale',
      'Une simple apologie sans incitation',
    ],
    answer: 'Un lien précis et étroit avec des faits déterminés',
    explanation:
        'Le cours : relation précise et incontestable + lien étroit, pas une incitation générale.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Effet',
    question: 'Il faut que la provocation ait été suivie d’effet :',
    options: ['Non', 'Oui', 'Oui seulement si mineur < 15'],
    answer: 'Non',
    explanation:
        'Le cours : peu importe qu’elle ait été suivie ou non d’effet.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Objet',
    question: 'L’objet de la provocation visée par 227-21 doit être :',
    options: [
      'Un crime ou un délit (pas une contravention)',
      'Une contravention uniquement',
      'Un simple manquement civil',
    ],
    answer: 'Un crime ou un délit (pas une contravention)',
    explanation:
        'Le cours : n’est pas visée la provocation à des faits contraventionnels.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Âge du provocateur',
    question: 'Le provocateur (227-21) doit être obligatoirement majeur :',
    options: ['Non', 'Oui', 'Oui seulement si mineur < 15'],
    answer: 'Non',
    explanation:
        'Le cours : rien n’est spécifié, provocation possible par majeur ou mineur.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Victime',
    question: 'La provocation doit s’adresser :',
    options: [
      'À un mineur quel que soit son âge',
      'À un majeur',
      'À un témoin uniquement',
    ],
    answer: 'À un mineur quel que soit son âge',
    explanation: 'Le cours : adressée à un mineur (note : < 15 = aggravation).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Peine simple',
    question: 'La peine simple (227-21 al.1) est :',
    options: [
      '5 ans d’emprisonnement et 150 000 € d’amende',
      '3 ans et 45 000 €',
      '2 ans et 30 000 €',
    ],
    answer: '5 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Le cours : 5 ans / 150 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Aggravations',
    question: 'Sont des circonstances aggravantes (227-21 al.2) :',
    options: [
      'Provocation adressée à un mineur de 15 ans, ou habitualité, ou établissements scolaires',
      'Réseau électronique obligatoire',
      'Paiement obligatoire',
    ],
    answer:
        'Provocation adressée à un mineur de 15 ans, ou habitualité, ou établissements scolaires',
    explanation: 'Le cours liste ces aggravations.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Peine aggravée',
    question: 'La peine aggravée (227-21 al.2) est :',
    options: [
      '7 ans d’emprisonnement et 150 000 € d’amende',
      '5 ans et 150 000 €',
      '10 ans et 300 000 €',
    ],
    answer: '7 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Le cours : 7 ans / 150 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation mineur crime/délit — Tentative',
    question: 'La tentative de 227-21 est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable seulement si bande organisée',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours : tentative NON.',
    difficulty: 'Moyenne',
  ),

  // ---------- ALCOOL — 227-19 (DIFFICILE 45-52) ----------
  const QuizQuestion(
    category: 'Provocation alcool — Fondement',
    question:
        'La provocation directe d’un mineur à la consommation de boissons alcooliques est prévue par :',
    options: [
      'L’article 227-19 du Code pénal',
      'L’article 227-21 du Code pénal',
      'L’article 227-18 du Code pénal',
    ],
    answer: 'L’article 227-19 du Code pénal',
    explanation:
        'Le cours : 227-19 CP prévoit et réprime la provocation directe à l’alcool.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Notion',
    question:
        'Les “boissons alcooliques” visées comportent des traces d’alcool supérieures à :',
    options: ['1,2 degré', '0,2 degré', '5 degrés'],
    answer: '1,2 degré',
    explanation:
        'Le cours renvoie à l’article L.3321-1 du code de la santé publique (> 1,2°).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Formes',
    question: 'La consommation visée par 227-19 doit être :',
    options: [
      'Habituelle ou excessive',
      'Uniquement occasionnelle',
      'Uniquement festive',
    ],
    answer: 'Habituelle ou excessive',
    explanation: 'Le cours précise : habituelle ou excessive.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Directe',
    question:
        'Une simple suggestion sans lien précis peut être une provocation directe :',
    options: ['Non', 'Oui', 'Oui si mineur < 15'],
    answer: 'Non',
    explanation: 'Le cours : relation précise et lien étroit nécessaires.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Peines',
    question:
        'La provocation directe à la consommation excessive (227-19 al.1) est punie de :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '2 ans et 45 000 €',
      '3 ans et 75 000 €',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation:
        'Le cours distingue al.1 (1 an/15 000 €) et al.2 (2 ans/45 000 €).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Habitude',
    question: 'La consommation habituelle (227-19 al.2) est punie de :',
    options: [
      '2 ans d’emprisonnement et 45 000 € d’amende',
      '1 an et 15 000 €',
      '5 ans et 100 000 €',
    ],
    answer: '2 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le tableau du cours : al.2 = 2 ans / 45 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Aggravation',
    question: 'En cas d’aggravation (227-19 al.3), il est prévu :',
    options: [
      'Doublement du maximum des peines encourues',
      'Une amende fixe de 1 500 €',
      'Une peine automatique de 10 ans',
    ],
    answer: 'Doublement du maximum des peines encourues',
    explanation: 'Le cours mentionne : doublement du maximum.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation alcool — Tentative/Complicité',
    question: 'Pour 227-19 :',
    options: [
      'Tentative : non ; Complicité : oui',
      'Tentative : oui ; Complicité : non',
      'Tentative : oui ; Complicité : oui',
    ],
    answer: 'Tentative : non ; Complicité : oui',
    explanation: 'Le cours : tentative NON ; complicité OUI (121-7).',
    difficulty: 'Difficile',
  ),

  // ---------- STUPÉFIANTS — 227-18 / 227-18-1 (DIFFICILE 53-60) ----------
  const QuizQuestion(
    category: 'Provocation stupéfiants — Fondement usage',
    question:
        'La provocation d’un mineur à l’usage illicite de stupéfiants est prévue par :',
    options: [
      'L’article 227-18 alinéa 1 du Code pénal',
      'L’article 227-18-1 alinéa 1 du Code pénal',
      'L’article 227-19 du Code pénal',
    ],
    answer: 'L’article 227-18 alinéa 1 du Code pénal',
    explanation: 'Le cours : 227-18 al.1 réprime la provocation à l’usage.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation stupéfiants — Fondement trafic',
    question:
        'La provocation d’un mineur au transport/détention/offre/cession de stupéfiants est prévue par :',
    options: [
      'L’article 227-18-1 alinéa 1 du Code pénal',
      'L’article 227-18 alinéa 1 du Code pénal',
      'L’article 227-21 du Code pénal',
    ],
    answer: 'L’article 227-18-1 alinéa 1 du Code pénal',
    explanation:
        'Le cours : 227-18-1 al.1 réprime la provocation au trafic visé.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation stupéfiants — Directe',
    question: 'La provocation en matière 227-18/227-18-1 doit être :',
    options: ['Directe', 'Indirecte uniquement', 'Purement publicitaire'],
    answer: 'Directe',
    explanation:
        'Le cours insiste : provocation directe avec lien précis et étroit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation stupéfiants — Aggravations',
    question:
        'Sont des circonstances aggravantes (227-18 al.2 / 227-18-1 al.2) :',
    options: [
      'Mineur de quinze ans ou établissements d’enseignement/abords',
      'Paiement obligatoire',
      'Diffusion par voie de presse uniquement',
    ],
    answer: 'Mineur de quinze ans ou établissements d’enseignement/abords',
    explanation: 'Le cours liste ces aggravations.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation stupéfiants — Peine simple usage',
    question: 'La peine simple (227-18 al.1) est :',
    options: [
      '5 ans d’emprisonnement et 100 000 € d’amende',
      '7 ans et 150 000 €',
      '2 ans et 30 000 €',
    ],
    answer: '5 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Le tableau du cours : 5 ans / 100 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation stupéfiants — Peine simple trafic',
    question: 'La peine simple (227-18-1 al.1) est :',
    options: [
      '7 ans d’emprisonnement et 150 000 € d’amende',
      '5 ans et 100 000 €',
      '3 ans et 45 000 €',
    ],
    answer: '7 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Le tableau du cours : 7 ans / 150 000 €.',
    difficulty: 'Difficile',
  ),
  // =====================
  // BANQUE SUPPLÉMENTAIRE — 100 QUESTIONS (3 niveaux) — SUITE DIRECTE
  // Thèmes : 227-15, 227-17, 227-22-1, 227-23, 227-25/26, 227-27, + rappels 227-24
  // =====================

  // =========================================================
  // PRIVATION D’ALIMENTS OU DE SOINS À MINEUR < 15 — 227-15/227-16
  // FACILE (1-20)
  // =========================================================
  const QuizQuestion(
    category: 'Privation aliments/soins — Fondement',
    question:
        'La privation d’aliments ou de soins à un mineur de quinze ans est prévue par :',
    options: [
      'L’article 227-15 du Code pénal',
      'L’article 227-17 du Code pénal',
      'L’article 227-22 du Code pénal',
    ],
    answer: 'L’article 227-15 du Code pénal',
    explanation:
        'Le cours : 227-15 CP définit et réprime la privation d’aliments ou de soins à mineur < 15 ans.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Victime',
    question: 'Pour 227-15, la victime doit être :',
    options: [
      'Âgée de moins de 15 ans',
      'Mineure de moins de 18 ans',
      'Majeure vulnérable',
    ],
    answer: 'Âgée de moins de 15 ans',
    explanation:
        'Le cours : la privation ne constitue une infraction que si la victime est un mineur de quinze ans (donc < 15).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Auteur',
    question: 'L’article 227-15 vise notamment comme auteurs :',
    options: [
      'Ascendants, titulaires de l’autorité parentale, ou personnes ayant autorité sur le mineur',
      'Uniquement les enseignants',
      'Uniquement les voisins',
    ],
    answer:
        'Ascendants, titulaires de l’autorité parentale, ou personnes ayant autorité sur le mineur',
    explanation:
        'Le cours : ascendants / autorité parentale / autorité de fait (nouveau conjoint, responsables, etc.).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Ascendants',
    question: 'Dans 227-15, “ascendants” regroupe notamment :',
    options: [
      'Père, mère, grands-parents, arrière-grands-parents',
      'Uniquement le père',
      'Uniquement le tuteur',
    ],
    answer: 'Père, mère, grands-parents, arrière-grands-parents',
    explanation: 'Le cours précise les ascendants concernés.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Privation d’aliments',
    question: 'La privation d’aliments correspond à :',
    options: [
      'Ne pas fournir une nourriture en quantité ou qualité suffisante',
      'Ne pas scolariser l’enfant',
      'Ne pas déclarer une naissance',
    ],
    answer: 'Ne pas fournir une nourriture en quantité ou qualité suffisante',
    explanation:
        'Le cours : privation d’aliments = défaut de nourriture en quantité/qualité suffisante.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Privation de soins',
    question: 'La privation de soins inclut notamment :',
    options: [
      'Ne pas assurer hygiène et soins médicaux nécessaires',
      'Refuser un cadeau',
      'Refuser un entretien scolaire',
    ],
    answer: 'Ne pas assurer hygiène et soins médicaux nécessaires',
    explanation:
        'Le cours : soins au quotidien (hygiène, soins médicaux, prise en charge).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Condition de résultat',
    question: 'Pour 227-15, les privations doivent être :',
    options: [
      'Au point de compromettre la santé du mineur',
      'Au point de compromettre uniquement ses notes scolaires',
      'Toujours mortelles',
    ],
    answer: 'Au point de compromettre la santé du mineur',
    explanation:
        'Le texte exige une compromission (au moins potentielle) de la santé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Dommage effectif',
    question: 'Il faut prouver que la santé a été effectivement altérée :',
    options: [
      'Non, il suffit que ce soit susceptible d’altérer la santé',
      'Oui, obligatoirement',
      'Oui uniquement si mineur < 6 ans',
    ],
    answer: 'Non, il suffit que ce soit susceptible d’altérer la santé',
    explanation:
        'Le cours : pas nécessaire que le dommage se réalise, suffit que les privations soient susceptibles d’altérer la santé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Présomption (mineur < 6 ans)',
    question:
        'Constitue notamment une privation de soins (227-15 al.2) le fait de :',
    options: [
      'Maintenir un enfant de moins de 6 ans sur la voie publique pour solliciter la générosité',
      'Lui acheter un jouet',
      'Le laisser aller à l’école seul',
    ],
    answer:
        'Maintenir un enfant de moins de 6 ans sur la voie publique pour solliciter la générosité',
    explanation:
        'Le cours : présomption de défaut de soins en cas de maintien < 6 ans sur voie publique/transport collectif pour mendicité.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Mendicité',
    question: 'Le simple fait de mendier avec un enfant en bas âge :',
    options: [
      'N’est pas en soi constitutif du délit',
      'Est toujours constitutif',
      'Est une contravention uniquement',
    ],
    answer: 'N’est pas en soi constitutif du délit',
    explanation:
        'Le cours : “Par contre, le simple fait de mendier avec un enfant en bas âge n’est pas en soi constitutif” (Cass. crim., 12 oct. 2005).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Élément moral',
    question: 'L’élément moral de 227-15 exige :',
    options: [
      'La conscience que les privations risquent de causer un mal à l’enfant',
      'La volonté de tuer',
      'L’accord du mineur',
    ],
    answer:
        'La conscience que les privations risquent de causer un mal à l’enfant',
    explanation:
        'Le cours : conscience/connaissance/prévision du mal (Cass. crim., 11 mars 1975).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Volonté de nuire',
    question: 'Pour 227-15, la volonté de nuire est :',
    options: [
      'Non requise',
      'Toujours requise',
      'Requise seulement si mineur < 6 ans',
    ],
    answer: 'Non requise',
    explanation:
        'Le cours : ni volonté de nuire ni volonté de causer un dommage ne sont nécessaires.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Convictions',
    question:
        'Des convictions religieuses peuvent justifier des privations compromettant la santé :',
    options: ['Non', 'Oui', 'Oui si l’enfant est d’accord'],
    answer: 'Non',
    explanation:
        'Le cours : convictions religieuses / souci d’éducation ne justifient pas si conscience du risque sur la santé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Aggravation (227-15 al.3)',
    question:
        'Une circonstance aggravante (227-15 al.3) existe notamment si l’auteur a commis sur le même mineur :',
    options: [
      'Le délit de non-déclaration de naissance (433-18-1 CP)',
      'Le vol simple',
      'Une contravention de tapage',
    ],
    answer: 'Le délit de non-déclaration de naissance (433-18-1 CP)',
    explanation:
        'Le cours : 227-15 al.3 vise le cas où l’auteur s’est rendu coupable du délit 433-18-1 sur le même mineur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Mort',
    question:
        'Lorsque la privation d’aliments ou de soins entraîne la mort, le texte visé est :',
    options: [
      'L’article 227-16 du Code pénal',
      'L’article 227-15 al.1',
      'L’article 227-17',
    ],
    answer: 'L’article 227-16 du Code pénal',
    explanation:
        'Le cours : 227-16 CP = aggravation lorsque la privation a entraîné la mort.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Peine simple',
    question: 'La peine principale (227-15) est :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '3 ans et 45 000 €',
      '2 ans et 30 000 €',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Le tableau du cours : 7 ans / 100 000 €.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Peine aggravée (227-15 al.3)',
    question: 'La peine principale (227-15 al.3) est :',
    options: [
      '10 ans d’emprisonnement et 300 000 € d’amende',
      '7 ans et 100 000 €',
      '5 ans et 75 000 €',
    ],
    answer: '10 ans d’emprisonnement et 300 000 € d’amende',
    explanation: 'Le cours : 10 ans / 300 000 €.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Crime (mort)',
    question: 'En cas de mort (227-16), la peine est :',
    options: [
      '30 ans de réclusion',
      '10 ans d’emprisonnement',
      '5 ans d’emprisonnement',
    ],
    answer: '30 ans de réclusion',
    explanation: 'Le cours : 227-16 = crime, 30 ans de réclusion.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Privation aliments/soins — Tentative/Complicité',
    question: 'Pour 227-15 :',
    options: [
      'Tentative : non ; Complicité : oui',
      'Tentative : oui ; Complicité : non',
      'Tentative : oui ; Complicité : oui',
    ],
    answer: 'Tentative : non ; Complicité : oui',
    explanation: 'Le cours : tentative NON, complicité OUI (121-7).',
    difficulty: 'Facile',
  ),

  // =========================================================
  // SOUSTRACTION D’UN PARENT À SES OBLIGATIONS — 227-17
  // MOYENNE (21-45)
  // =========================================================
  const QuizQuestion(
    category: 'Soustraction obligations — Fondement',
    question:
        'La soustraction d’un parent à ses obligations légales est prévue par :',
    options: [
      'L’article 227-17 du Code pénal',
      'L’article 227-15 du Code pénal',
      'L’article 227-24 du Code pénal',
    ],
    answer: 'L’article 227-17 du Code pénal',
    explanation:
        'Le cours : 227-17 CP définit et réprime la soustraction d’un parent à ses obligations légales.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Auteur',
    question: 'L’auteur visé par 227-17 est :',
    options: [
      'Le père ou la mère',
      'Tout ascendant',
      'Tout adulte vivant au domicile',
    ],
    answer: 'Le père ou la mère',
    explanation:
        'Le cours : seuls père et mère (lien de filiation), exclusion des autres ascendants.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Victime',
    question: 'La victime de 227-17 doit être :',
    options: [
      'Un mineur sans condition d’âge',
      'Un mineur de moins de 15 ans uniquement',
      'Un majeur protégé',
    ],
    answer: 'Un mineur sans condition d’âge',
    explanation: 'Le cours : mineur sans condition d’âge (= < 18).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Motif légitime',
    question:
        'Les faits ne sont punissables que si le parent s’est soustrait :',
    options: [
      'Sans motif légitime',
      'Même avec un motif légitime',
      'Uniquement après une condamnation civile',
    ],
    answer: 'Sans motif légitime',
    explanation: 'Le texte exige l’absence de motif légitime.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Autorité parentale',
    question:
        'L’article du code civil cité au sujet de l’autorité parentale est :',
    options: [
      'L’article 371-1 du Code civil',
      'L’article 121-7 du Code pénal',
      'L’article 222-23 du Code pénal',
    ],
    answer: 'L’article 371-1 du Code civil',
    explanation:
        'Le cours rappelle 371-1 C. civ. (sécurité, santé, moralité, éducation, développement, sans violences).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Quitter le domicile',
    question: 'Pour 227-17, il faut que le parent quitte le domicile :',
    options: [
      'Non, l’abandon peut être moral même en étant présent',
      'Oui, toujours',
      'Oui uniquement si l’enfant a moins de 15 ans',
    ],
    answer: 'Non, l’abandon peut être moral même en étant présent',
    explanation:
        'Le cours : pas nécessaire de quitter le domicile; c’est un abandon moral possible même présent.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Contenu',
    question: 'Sont cités comme exemples d’abandon moral/matériel :',
    options: [
      'Mauvais traitements, inconduite notoire, défaut de soins, manque de direction',
      'Absence de passeport',
      'Absence de permis de conduire',
    ],
    answer:
        'Mauvais traitements, inconduite notoire, défaut de soins, manque de direction',
    explanation: 'Le cours liste ces exemples.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Condition de compromission',
    question:
        'L’infraction est constituée si la soustraction est susceptible de compromettre :',
    options: [
      'Santé, sécurité, moralité ou éducation',
      'Uniquement l’éducation',
      'Uniquement la moralité',
    ],
    answer: 'Santé, sécurité, moralité ou éducation',
    explanation: 'Le texte vise ces quatre intérêts.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Dommage effectif',
    question: 'Il faut que la compromission soit irréversible et réalisée :',
    options: ['Non', 'Oui', 'Oui si mineur < 15'],
    answer: 'Non',
    explanation:
        'Le cours : pas requis que le dommage se soit réalisé; il suffit qu’il soit susceptible de se réaliser.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Carence effective',
    question: 'Pour 227-17, la carence parentale doit être :',
    options: ['Effective', 'Supposée', 'Présumée par le seul divorce'],
    answer: 'Effective',
    explanation:
        'Le cours : la carence des parents doit être effective (Cass. crim., 11 juillet 1994).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Preuve motif légitime',
    question: 'La preuve du motif légitime est à la charge :',
    options: ['Du prévenu', 'Du ministère public', 'De l’enfant'],
    answer: 'Du prévenu',
    explanation:
        'Le cours : c’est au prévenu d’apporter la preuve d’un motif grave.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Appréciation motif',
    question: 'La légitimité du motif invoqué est appréciée :',
    options: ['Par le juge', 'Par la victime uniquement', 'Par l’école'],
    answer: 'Par le juge',
    explanation: 'Le cours : appréciation au cas par cas par le juge.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Divorce',
    question:
        'L’introduction d’une demande en divorce est un motif légitime justifiant l’abandon :',
    options: ['Non', 'Oui', 'Oui si séparation officielle'],
    answer: 'Non',
    explanation:
        'Le cours : demande en divorce ≠ motif grave (Cass. crim., 30 mai 1967).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Incarcération',
    question: 'L’incarcération du parent peut constituer un motif légitime :',
    options: [
      'Oui, dans certaines conditions',
      'Non, jamais',
      'Oui automatiquement',
    ],
    answer: 'Oui, dans certaines conditions',
    explanation:
        'Le cours : incarcération reconnue comme motif légitime dans un cas (Cass. crim., 26 mars 1957).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Convictions religieuses',
    question:
        'Les convictions religieuses peuvent excuser la soustraction 227-17 :',
    options: ['Non', 'Oui', 'Oui si l’enfant accepte'],
    answer: 'Non',
    explanation:
        'Le cours : convictions religieuses ne sauraient excuser (Cass. crim., 11 juillet 1994).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Élément moral',
    question: '227-17 est une infraction :',
    options: ['Intentionnelle', 'Involontaire', 'Contraventionnelle'],
    answer: 'Intentionnelle',
    explanation:
        'Le cours : conscience de se soustraire et du risque de conséquences dommageables.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Aggravation al.2',
    question:
        'Une aggravation (227-17 al.2) existe si la soustraction a conduit à :',
    options: [
      'La commission par le mineur d’au moins un crime ou de plusieurs délits avec condamnation définitive',
      'Une absence de bulletin scolaire',
      'Un simple retard',
    ],
    answer:
        'La commission par le mineur d’au moins un crime ou de plusieurs délits avec condamnation définitive',
    explanation:
        'Le cours : aggravation si lien direct + condamnation définitive du mineur.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Peine simple',
    question: 'La peine simple (227-17) est :',
    options: [
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '5 ans et 75 000 €',
      '3 ans et 45 000 €',
    ],
    answer: '2 ans d’emprisonnement et 30 000 € d’amende',
    explanation: 'Tableau : 2 ans / 30 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Peine aggravée',
    question: 'La peine aggravée (227-17 al.2) est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans et 30 000 €',
      '7 ans et 100 000 €',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Tableau : 3 ans / 45 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Soustraction obligations — Tentative/Complicité',
    question: 'Pour 227-17 :',
    options: [
      'Tentative : non ; Complicité : oui',
      'Tentative : oui ; Complicité : non',
      'Tentative : oui ; Complicité : oui',
    ],
    answer: 'Tentative : non ; Complicité : oui',
    explanation: 'Le cours : tentative NON, complicité OUI (121-7).',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // PROPOSITIONS SEXUELLES À MINEUR < 15 PAR MOYEN ÉLECTRONIQUE — 227-22-1
  // MOYENNE (46-60)
  // =========================================================
  const QuizQuestion(
    category: 'Propositions sexuelles en ligne — Fondement',
    question:
        'Les propositions sexuelles à un mineur de quinze ans par moyen électronique sont prévues par :',
    options: [
      'L’article 227-22-1 du Code pénal',
      'L’article 227-25 du Code pénal',
      'L’article 227-23 du Code pénal',
    ],
    answer: 'L’article 227-22-1 du Code pénal',
    explanation:
        'Le cours : 227-22-1 CP réprime les propositions sexuelles via communication électronique.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles en ligne — Auteur',
    question: 'L’auteur des propositions sexuelles (227-22-1) doit être :',
    options: ['Majeur', 'Mineur', 'Indifférent'],
    answer: 'Majeur',
    explanation: 'Le cours : auteur = personne majeure.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles en ligne — Acte',
    question: 'Les propositions visées doivent être :',
    options: ['Sexuelles et explicites', 'Ambiguës uniquement', 'Politiques'],
    answer: 'Sexuelles et explicites',
    explanation: 'Le cours : propositions sexuelles explicites.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles en ligne — Moyen',
    question: 'Le moyen exigé par 227-22-1 est :',
    options: [
      'Un moyen de communication électronique',
      'Une lettre manuscrite uniquement',
      'Une conversation en présentiel uniquement',
    ],
    answer: 'Un moyen de communication électronique',
    explanation:
        'Le texte vise l’usage d’un moyen de communication électronique.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles en ligne — Victime',
    question: 'La victime doit être :',
    options: [
      'Un mineur de 15 ans ou une personne se présentant comme telle',
      'Un mineur de plus de 15 ans uniquement',
      'Un majeur',
    ],
    answer: 'Un mineur de 15 ans ou une personne se présentant comme telle',
    explanation:
        'Le cours : adressées à mineur < 15 ou personne se présentant comme telle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles en ligne — Croyance',
    question:
        'Il suffit que l’auteur ait cru être en présence d’un mineur de quinze ans :',
    options: ['Oui', 'Non', 'Oui seulement si rencontre'],
    answer: 'Oui',
    explanation:
        'Le cours : il suffit qu’il ait cru être en présence d’un mineur < 15.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles en ligne — Nature',
    question: '227-22-1 réprime principalement :',
    options: [
      'Un acte préparatoire ou une tentative d’atteinte sexuelle',
      'Un homicide',
      'Un vol',
    ],
    answer: 'Un acte préparatoire ou une tentative d’atteinte sexuelle',
    explanation:
        'Le cours : incriminer des comportements pouvant conduire à une atteinte sexuelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles en ligne — Élément moral',
    question: 'L’élément moral (227-22-1) repose sur :',
    options: [
      'La volonté de faire des propositions sexuelles à une personne supposée mineure < 15 via électronique',
      'La volonté de se marier',
      'La négligence uniquement',
    ],
    answer:
        'La volonté de faire des propositions sexuelles à une personne supposée mineure < 15 via électronique',
    explanation:
        'Le cours : infraction intentionnelle, volonté d’effectuer ces propositions.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles en ligne — Aggravation',
    question: 'La circonstance aggravante (227-22-1 al.2) est :',
    options: [
      'Lorsque les propositions ont été suivies d’une rencontre',
      'Lorsque l’auteur est mineur',
      'Lorsque le message est violent',
    ],
    answer: 'Lorsque les propositions ont été suivies d’une rencontre',
    explanation: 'Le cours : aggravation si rencontre.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles en ligne — Peine simple',
    question: 'La peine simple (227-22-1 al.1) est :',
    options: [
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '3 ans et 75 000 €',
      '5 ans et 100 000 €',
    ],
    answer: '2 ans d’emprisonnement et 30 000 € d’amende',
    explanation: 'Tableau : 2 ans / 30 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles en ligne — Peine aggravée',
    question: 'La peine aggravée (227-22-1 al.2) est :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '2 ans et 30 000 €',
      '7 ans et 150 000 €',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Tableau : 5 ans / 75 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles en ligne — Tentative',
    question: 'La tentative (227-22-1) est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable seulement si bande organisée',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours : tentative NON.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Propositions sexuelles en ligne — Complicité',
    question: 'La complicité (227-22-1) est :',
    options: ['Oui', 'Non', 'Oui uniquement si rencontre'],
    answer: 'Oui',
    explanation: 'Le cours : complicité OUI (121-7).',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // EXPLOITATION IMAGE PORNOGRAPHIQUE D’UN MINEUR — 227-23
  // DIFFICILE (61-100)
  // =========================================================
  const QuizQuestion(
    category: 'Pédopornographie — Fondement fixation',
    question:
        'Le fait de fixer/enregistrer/transmettre l’image pornographique d’un mineur en vue de diffusion est prévu par :',
    options: [
      'L’article 227-23 alinéa 1 du Code pénal',
      'L’article 227-23 alinéa 4 du Code pénal',
      'L’article 227-24 alinéa 1 du Code pénal',
    ],
    answer: 'L’article 227-23 alinéa 1 du Code pénal',
    explanation:
        'Le cours : 227-23 al.1 réprime la fixation/enregistrement/transmission en vue de diffusion.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Mineur < 15 et diffusion',
    question:
        'Si l’image concerne un mineur de quinze ans, la fixation/enregistrement est punie :',
    options: [
      'Même sans intention de diffusion',
      'Uniquement si diffusion prouvée',
      'Uniquement si paiement prouvé',
    ],
    answer: 'Même sans intention de diffusion',
    explanation:
        'Le cours : pour mineur < 15, punissable même sans vue de diffusion.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Fondement diffusion',
    question:
        'Offrir/rendre disponible/diffuser/importer/exporter une image pornographique de mineur est prévu par :',
    options: [
      'L’article 227-23 alinéa 2 du Code pénal',
      'L’article 227-23 alinéa 1 du Code pénal',
      'L’article 227-22 du Code pénal',
    ],
    answer: 'L’article 227-23 alinéa 2 du Code pénal',
    explanation:
        'Le cours : 227-23 al.2 réprime l’offre, mise à dispo, diffusion, import/export.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Fondement consultation/détention',
    question:
        'Consulter habituellement ou en contrepartie d’un paiement un site pédopornographique / détenir ou acquérir est prévu par :',
    options: [
      'L’article 227-23 alinéa 4 du Code pénal',
      'L’article 227-23 alinéa 2 du Code pénal',
      'L’article 227-24 alinéa 1 du Code pénal',
    ],
    answer: 'L’article 227-23 alinéa 4 du Code pénal',
    explanation:
        'Le cours : 227-23 al.4 incrimine consultation habituelle ou payante + acquisition/détention.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Image vs représentation',
    question: 'Le terme “représentation” a été ajouté notamment pour viser :',
    options: [
      'Les contenus fictifs/virtuels (dessins, morphing, etc.)',
      'Uniquement les photos réelles',
      'Uniquement les textes',
    ],
    answer: 'Les contenus fictifs/virtuels (dessins, morphing, etc.)',
    explanation:
        'Le cours : image réelle et représentation fictive/virtuelle (dessins, photomontage, morphing…).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Support',
    question: 'L’image/représentation peut se trouver :',
    options: [
      'Sur tout support (film, photo, affiche, clip, etc.)',
      'Uniquement sur papier',
      'Uniquement sur serveur en ligne',
    ],
    answer: 'Sur tout support (film, photo, affiche, clip, etc.)',
    explanation: 'Le cours : support indifférent, exemples multiples.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Caractère pornographique',
    question: 'Le caractère pornographique vise :',
    options: [
      'Des comportements en relation avec l’activité sexuelle',
      'Toute nudité simple',
      'Toute photo d’enfant',
    ],
    answer: 'Des comportements en relation avec l’activité sexuelle',
    explanation:
        'Le cours : simple nudité hors attitude particulière n’entre pas dans l’incrimination.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Simple nudité',
    question:
        'La simple nudité d’un mineur, sans attitude particulière, entre dans 227-23 :',
    options: ['Non', 'Oui', 'Oui si en public'],
    answer: 'Non',
    explanation: 'Le cours : simple nudité seule n’est pas visée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Œuvre artistique',
    question:
        'Pour des œuvres artistiques (tableaux, gravures), la qualification pornographique relève :',
    options: [
      'De l’appréciation du juge au cas par cas',
      'D’une interdiction automatique',
      'D’une exonération automatique',
    ],
    answer: 'De l’appréciation du juge au cas par cas',
    explanation: 'Le cours : appréciation au cas par cas (art/pornographie).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Diffusion',
    question:
        'La diffusion au sens de 227-23 al.2 doit en principe impliquer :',
    options: [
      'Plusieurs destinataires',
      'Un destinataire unique seulement',
      'Aucun destinataire',
    ],
    answer: 'Plusieurs destinataires',
    explanation:
        'Le cours : diffusion suppose plusieurs destinataires (contrairement à une correspondance personnelle).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Correspondance',
    question:
        'Une lettre adressée à une seule personne (correspondance personnelle) est, en principe :',
    options: [
      'Difficilement qualifiable de diffusion',
      'Toujours qualifiable de diffusion',
      'Toujours une contravention',
    ],
    answer: 'Difficilement qualifiable de diffusion',
    explanation:
        'Le cours : a contrario, une lettre à une seule personne ne peut être qualifiée de diffusion.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Diffusion non publique',
    question: 'La diffusion doit être publique pour être incriminée :',
    options: ['Non', 'Oui', 'Oui sauf si mineur < 15'],
    answer: 'Non',
    explanation:
        'Le cours : diffusion incriminée même sans caractère public (ex : salon privé).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Offre',
    question: 'L’offre (227-23 al.2) s’entend :',
    options: [
      'Mise à disposition consciente, même à titre gratuit',
      'Vente exclusivement',
      'Publication dans un journal uniquement',
    ],
    answer: 'Mise à disposition consciente, même à titre gratuit',
    explanation:
        'Le cours : offre = mise à disposition d’autrui même gratuite, sans exiger pluralité de destinataires.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Rendre disponible',
    question: 'Rendre disponible correspond notamment au fait de :',
    options: [
      'Laisser des fichiers accessibles par Internet sans les envoyer soi-même',
      'Envoyer un SMS unique',
      'Écrire un journal intime',
    ],
    answer:
        'Laisser des fichiers accessibles par Internet sans les envoyer soi-même',
    explanation:
        'Le cours : laisser des fichiers accessibles sans diffuser directement.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Import/export',
    question:
        'L’importation/exportation de documents pédopornographiques est incriminée :',
    options: [
      'Même s’ils ne font que transiter sur le territoire national',
      'Uniquement si fabrication en France',
      'Uniquement si mineur français',
    ],
    answer: 'Même s’ils ne font que transiter sur le territoire national',
    explanation: 'Le cours : incrimination spécifique, y compris transit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Consultation habituelle',
    question:
        'La consultation d’un site pédopornographique est incriminée si elle est :',
    options: [
      'Habituelle ou en contrepartie d’un paiement',
      'Uniquement en journée',
      'Uniquement sur ordinateur fixe',
    ],
    answer: 'Habituelle ou en contrepartie d’un paiement',
    explanation: 'Le cours : consultation habituelle ou payante.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Consultation payante',
    question: 'La consultation même occasionnelle est sanctionnée dès lors :',
    options: [
      'Qu’elle a donné lieu à un paiement',
      'Qu’elle dure plus de 10 minutes',
      'Qu’elle a lieu sur un réseau social',
    ],
    answer: 'Qu’elle a donné lieu à un paiement',
    explanation:
        'Le cours : consultation occasionnelle sanctionnée si paiement.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Acquisition/détention',
    question: 'La détention/acquisition est caractérisée notamment par :',
    options: [
      'La présence de fichiers au domicile ou sur le matériel si l’agent n’en ignore pas l’existence',
      'La seule rumeur',
      'La simple navigation sans image',
    ],
    answer:
        'La présence de fichiers au domicile ou sur le matériel si l’agent n’en ignore pas l’existence',
    explanation:
        'Le cours : présence sur matériel suffit si impossibilité d’établir qu’il ignorait l’existence.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Repentir',
    question: 'Détruire ultérieurement les fichiers (repentir) :',
    options: [
      'N’efface pas l’infraction si la détention antérieure est prouvée',
      'Supprime l’infraction automatiquement',
      'Transforme en contravention',
    ],
    answer: 'N’efface pas l’infraction si la détention antérieure est prouvée',
    explanation:
        'Le cours : délit prouvé même si fichiers détruits; repentir sans influence.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Apparence de mineur',
    question:
        'L’infraction peut être constituée si la personne a l’aspect physique d’un mineur :',
    options: [
      'Oui, sauf preuve qu’elle avait 18 ans lors de la fixation/enregistrement',
      'Non, jamais',
      'Uniquement si elle est française',
    ],
    answer:
        'Oui, sauf preuve qu’elle avait 18 ans lors de la fixation/enregistrement',
    explanation:
        'Le cours : aspect de mineur suffit sauf établissement de majorité au moment de la fixation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Élément moral',
    question: 'L’exploitation d’images pédopornographiques (227-23) est :',
    options: ['Intentionnelle', 'Involontaire', 'Contraventionnelle'],
    answer: 'Intentionnelle',
    explanation:
        'Le cours : conscience du caractère contraire aux bonnes mœurs.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Mobile',
    question: 'Le mobile (sadisme, prétendue vocation artistique, etc.) :',
    options: [
      'Est indifférent',
      'Est indispensable',
      'Efface l’infraction si artistique',
    ],
    answer: 'Est indifférent',
    explanation: 'Le cours : mobile importe peu.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Connaissance minorité',
    question: 'La connaissance de la minorité du sujet représenté est :',
    options: ['Présumée', 'Toujours impossible à prouver', 'Jamais présumée'],
    answer: 'Présumée',
    explanation:
        'Le cours : connaissance par le prévenu de la minorité est présumée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Aggravation réseau',
    question: 'Une aggravation (227-23 al.3) existe lorsque :',
    options: [
      'Un réseau de communications électroniques est utilisé pour diffusion à un public non déterminé',
      'Le support est papier',
      'La victime est majeure',
    ],
    answer:
        'Un réseau de communications électroniques est utilisé pour diffusion à un public non déterminé',
    explanation:
        'Le cours : al.3 = usage d’un réseau électronique pour diffusion à public non déterminé.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Aggravation bande organisée',
    question: 'Une aggravation (227-23 al.5) existe en cas de :',
    options: ['Bande organisée', 'Mariage', 'Divorce'],
    answer: 'Bande organisée',
    explanation: 'Le cours : al.5 = bande organisée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Peine fabrication simple',
    question:
        'La fabrication/fixation en vue de diffusion (227-23 al.1) est punie de :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans et 45 000 €',
      '7 ans et 150 000 €',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Tableau : 5 ans / 75 000 € (fabrication simple).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Peine diffusion simple',
    question: 'La diffusion simple (227-23 al.2) est punie de :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '2 ans et 30 000 €',
      '10 ans et 500 000 €',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Tableau : 5 ans / 75 000 € (diffusion simple).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Peine consultation/détention',
    question:
        'La consultation habituelle ou la détention (227-23 al.4) est punie de :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans et 75 000 €',
      '3 ans et 45 000 €',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Tableau : 7 ans / 100 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Peine aggravée réseau',
    question: 'La diffusion aggravée (227-23 al.3) est punie de :',
    options: [
      '10 ans d’emprisonnement et 500 000 € d’amende',
      '7 ans et 150 000 €',
      '5 ans et 75 000 €',
    ],
    answer: '10 ans d’emprisonnement et 500 000 € d’amende',
    explanation: 'Tableau : 10 ans / 500 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Tentative',
    question: 'La tentative des infractions prévues par 227-23 est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable seulement si mineur < 15',
    ],
    answer: 'Punissable',
    explanation:
        'Le cours : 227-23 al.6 prévoit la tentative punissable pour toutes les infractions de 227-23.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Pédopornographie — Complicité',
    question: 'La complicité en matière 227-23 est :',
    options: ['Oui', 'Non', 'Oui uniquement en bande organisée'],
    answer: 'Oui',
    explanation: 'Le cours : complicité OUI (121-7).',
    difficulty: 'Difficile',
  ),

  // ---------- ATTEINTES SEXUELLES MAJEUR SUR MINEUR < 15 — 227-25 / 227-26 (DIFFICILE) ----------
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Fondement',
    question:
        'Les atteintes sexuelles commises par un majeur sur un mineur de quinze ans sont prévues par :',
    options: [
      'L’article 227-25 du Code pénal',
      'L’article 227-27 du Code pénal',
      'L’article 227-22-1 du Code pénal',
    ],
    answer: 'L’article 227-25 du Code pénal',
    explanation:
        'Le cours : 227-25 CP réprime l’atteinte sexuelle par majeur sur mineur < 15 (hors viol/agression sexuelle).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Définition',
    question: 'L’atteinte sexuelle suppose :',
    options: [
      'Un contact physique en rapport avec l’activité sexuelle',
      'Uniquement des paroles',
      'Uniquement un regard insistant',
    ],
    answer: 'Un contact physique en rapport avec l’activité sexuelle',
    explanation: 'Le cours : contact physique entre agresseur et victime.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Absence de violence',
    question: 'L’atteinte sexuelle 227-25 correspond à un contact :',
    options: [
      'Sans violence, contrainte, menace ni surprise',
      'Avec violence obligatoire',
      'Avec arme obligatoire',
    ],
    answer: 'Sans violence, contrainte, menace ni surprise',
    explanation: 'Le cours : sinon, bascule vers viol/agression sexuelle.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Auteur',
    question: 'L’auteur visé par 227-25 doit être :',
    options: ['Majeur', 'Mineur', 'Indifférent'],
    answer: 'Majeur',
    explanation: 'Le cours : infraction imputable à un majeur.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Âge victime',
    question: 'Pour 227-25, la victime doit être :',
    options: [
      'Âgée de moins de 15 ans au moment des faits',
      'Âgée de moins de 18 ans',
      'Majeure',
    ],
    answer: 'Âgée de moins de 15 ans au moment des faits',
    explanation: 'Le cours : on retient l’âge au moment des faits.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Calcul âge',
    question: 'Le cours précise que l’âge se calcule :',
    options: [
      'D’heure à heure',
      'Par année scolaire',
      'Au 1er janvier uniquement',
    ],
    answer: 'D’heure à heure',
    explanation:
        'Le cours : Cass. crim., 03 septembre 1985 (calcul d’heure à heure).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Erreur âge',
    question: 'L’erreur sur l’âge de la victime :',
    options: [
      'N’atténue pas la responsabilité pénale (principe)',
      'Efface automatiquement l’infraction',
      'Transforme en contravention',
    ],
    answer: 'N’atténue pas la responsabilité pénale (principe)',
    explanation:
        'Le cours : erreur sur l’âge n’atténue pas, avec nuances jurisprudentielles très limitées.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Aggravations',
    question:
        'Les circonstances aggravantes de l’atteinte sexuelle < 15 sont prévues par :',
    options: [
      'L’article 227-26 du Code pénal',
      'L’article 227-27 du Code pénal',
      'L’article 227-23 al.3 du Code pénal',
    ],
    answer: 'L’article 227-26 du Code pénal',
    explanation: 'Le cours : 227-26 CP prévoit les aggravations.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Peine simple',
    question: 'La peine simple (227-25) est :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans et 75 000 €',
      '2 ans et 30 000 €',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Tableau : 7 ans / 100 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Peine aggravée',
    question: 'La peine aggravée (227-26) est :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans et 100 000 €',
      '5 ans et 45 000 €',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Tableau : 10 ans / 150 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Tentative',
    question: 'La tentative des délits d’atteintes sexuelles sur mineur est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable seulement si bande organisée',
    ],
    answer: 'Punissable',
    explanation: 'Le cours : tentative OUI (article 227-27-2).',
    difficulty: 'Difficile',
  ),

  // ---------- ATTEINTES SEXUELLES MAJEUR SUR MINEUR > 15 — 227-27 (DIFFICILE) ----------
  const QuizQuestion(
    category: 'Atteinte sexuelle > 15 — Fondement',
    question:
        'Les atteintes sexuelles sur un mineur de plus de 15 ans (hors viol/agression sexuelle) sont prévues par :',
    options: [
      'L’article 227-27 du Code pénal',
      'L’article 227-25 du Code pénal',
      'L’article 227-22 du Code pénal',
    ],
    answer: 'L’article 227-27 du Code pénal',
    explanation:
        'Le cours : 227-27 CP réprime les atteintes sexuelles sur mineur > 15, sous conditions d’autorité.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle > 15 — Conditions',
    question:
        'Pour 227-27, l’infraction est constituée notamment lorsque l’acte est commis par un majeur :',
    options: [
      'Ayant autorité de droit/de fait sur la victime ou abusant de l’autorité de ses fonctions',
      'Sans aucun lien avec la victime',
      'Uniquement en présence de témoins',
    ],
    answer:
        'Ayant autorité de droit/de fait sur la victime ou abusant de l’autorité de ses fonctions',
    explanation:
        'Le cours : 1° autorité de droit/de fait ; 2° abus de l’autorité conférée par les fonctions.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle > 15 — Âge victime',
    question: 'Pour 227-27, la victime doit être :',
    options: [
      'Âgée de plus de 15 ans et de moins de 18 ans (même émancipée)',
      'Âgée de moins de 15 ans',
      'Majeure',
    ],
    answer: 'Âgée de plus de 15 ans et de moins de 18 ans (même émancipée)',
    explanation: 'Le cours : mineur > 15 et < 18, même émancipé.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle > 15 — Peine',
    question: 'La peine principale (227-27) est :',
    options: [
      '5 ans d’emprisonnement et 45 000 € d’amende',
      '7 ans et 100 000 €',
      '2 ans et 30 000 €',
    ],
    answer: '5 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Tableau : 5 ans / 45 000 €.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteinte sexuelle > 15 — Tentative/Complicité',
    question: 'Pour 227-27 :',
    options: [
      'Tentative : oui ; Complicité : oui',
      'Tentative : non ; Complicité : non',
      'Tentative : non ; Complicité : oui',
    ],
    answer: 'Tentative : oui ; Complicité : oui',
    explanation:
        'Le cours : tentative OUI (227-27-2) ; complicité OUI (121-7).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Provocation délinquance — Résultat',
    question: 'La provocation est punissable :',
    options: [
      'Même si elle n’a pas été suivie d’effet',
      'Seulement si le mineur passe à l’acte',
      'Uniquement en cas de récidive',
    ],
    answer: 'Même si elle n’a pas été suivie d’effet',
    explanation: 'L’infraction est consommée par la provocation elle-même.',
    difficulty: 'Facile',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizMisePerilMineurPA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril/quiz_mise_en_peril';
  final String uid;
  final String email;

  const QuizMisePerilMineurPA({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizMisePerilMineurPA> createState() => _QuizMisePerilMineurPAState();
}

class _QuizMisePerilMineurPAState extends State<QuizMisePerilMineurPA>
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
  static const _introHiddenKey = 'intro_pa_mise_peril_mineurs';
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
        ? questionMiseEnPerilMineurs
        : questionMiseEnPerilMineurs
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
            'quiz_name': 'Mise en péril des mineurs',
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
      await _sb.from('quiz_mise_peril_mineurs').insert({
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
      debugPrint('❌ quiz_mise_peril_mineurs insert failed: $e');
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
      'source_file': 'pa_quiz_mise_peril_mineurs',
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
                            icon: Icons.child_friendly_rounded,
                            title: 'Mise en péril des mineurs',
                            description: 'Maîtrise les infractions mettant en péril les mineurs : abandon moral, délaissement, incitation à la débauche et protection de l’enfance.',
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
