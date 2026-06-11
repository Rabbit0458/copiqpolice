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

final List<QuizQuestion> questionAbandonFamille = [
  // =========================================================
  // AJOUT ENOOOOORME — ABANDON DE FAMILLE (227-3)
  // (à coller directement dans ta liste existante, sans "final List..." ni fermeture)
  // =========================================================

  // ---------------------------------------------------------
  // ABANDON DE FAMILLE — FONDEMENT / DÉFINITION
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Fondement',
    question: 'Le délit d’abandon de famille est prévu et réprimé par :',
    options: [
      'L’article 227-3 du Code pénal',
      'L’article 227-5 du Code pénal',
      'L’article 227-6 du Code pénal',
    ],
    answer: 'L’article 227-3 du Code pénal',
    explanation:
        'L’élément légal du délit d’abandon de famille est fixé par l’article 227-3 du Code pénal.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Définition',
    question: 'L’abandon de famille consiste notamment à :',
    options: [
      'Ne pas exécuter un acte imposant de verser une somme d’argent, en demeurant plus de deux mois sans s’acquitter intégralement',
      'Refuser de représenter un enfant mineur',
      'Soustraire un enfant sans fraude ni violence',
    ],
    answer:
        'Ne pas exécuter un acte imposant de verser une somme d’argent, en demeurant plus de deux mois sans s’acquitter intégralement',
    explanation:
        'Le texte vise l’inexécution d’une obligation de paiement pendant plus de deux mois.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Définition',
    question:
        'Le délit d’abandon de famille peut viser des sommes dues au profit :',
    options: [
      'D’un enfant mineur, d’un descendant, d’un ascendant ou du conjoint',
      'Uniquement d’un enfant mineur',
      'Uniquement du conjoint',
    ],
    answer:
        'D’un enfant mineur, d’un descendant, d’un ascendant ou du conjoint',
    explanation:
        'Le support mentionne ces bénéficiaires (enfant mineur, descendant, ascendant, conjoint).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Définition',
    question: 'L’obligation visée par 227-3 porte sur :',
    options: [
      'Une pension, une contribution, des subsides ou des prestations de toute nature dues au titre d’obligations familiales',
      'Uniquement une amende pénale',
      'Uniquement une dette commerciale',
    ],
    answer:
        'Une pension, une contribution, des subsides ou des prestations de toute nature dues au titre d’obligations familiales',
    explanation:
        'Le champ vise toutes les obligations familiales prévues par le code civil.',
    difficulty: 'Moyenne',
  ),

  // ---------------------------------------------------------
  // ABANDON DE FAMILLE — OBLIGATIONS FAMILIALES (EXEMPLES)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Obligations familiales',
    question:
        'Parmi les obligations familiales entrant dans le champ de 227-3, on trouve :',
    options: [
      'Les contributions des époux aux charges du mariage',
      'Le paiement d’une contravention',
      'Un prêt bancaire',
    ],
    answer: 'Les contributions des époux aux charges du mariage',
    explanation:
        'Le support cite les contributions aux charges du mariage parmi les obligations familiales.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Obligations familiales',
    question:
        'Parmi les obligations familiales entrant dans le champ de 227-3, on trouve aussi :',
    options: [
      'Les pensions alimentaires ou prestations compensatoires après divorce',
      'Les impôts locaux',
      'Une facture d’électricité',
    ],
    answer:
        'Les pensions alimentaires ou prestations compensatoires après divorce',
    explanation:
        'Le support cite les pensions alimentaires et prestations compensatoires après divorce.',
    difficulty: 'Moyenne',
  ),

  // ---------------------------------------------------------
  // ABANDON DE FAMILLE — ACTE EXÉCUTOIRE : PRINCIPE
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Acte exécutoire',
    question: 'L’abandon de famille suppose l’inexécution :',
    options: [
      'D’une décision judiciaire ou d’un titre ayant un caractère exécutoire',
      'D’un simple accord oral',
      'D’une promesse informelle',
    ],
    answer:
        'D’une décision judiciaire ou d’un titre ayant un caractère exécutoire',
    explanation:
        'L’obligation pénalement protégée doit être fondée sur une décision ou un titre exécutoire.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Acte exécutoire',
    question: 'Le support rappelle que l’acte fondant l’obligation peut être :',
    options: [
      'Une décision juridictionnelle',
      'Uniquement un acte notarié',
      'Uniquement une convention non homologuée',
    ],
    answer: 'Une décision juridictionnelle',
    explanation:
        'Le support mentionne une décision juridictionnelle parmi les actes possibles.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Acte exécutoire',
    question:
        'Le support indique que l’acte fondant l’obligation peut aussi être :',
    options: [
      'Une convention judiciairement homologuée',
      'Un message sur réseau social',
      'Un accord verbal entre amis',
    ],
    answer: 'Une convention judiciairement homologuée',
    explanation:
        'La convention homologuée est citée parmi les titres possibles.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Acte exécutoire',
    question:
        'Le support indique que l’acte fondant l’obligation peut aussi être :',
    options: [
      'Une convention prévue à l’article 229-1 du code civil',
      'Un mail sans signature',
      'Une promesse orale',
    ],
    answer: 'Une convention prévue à l’article 229-1 du code civil',
    explanation: 'Le support cite la convention 229-1 du code civil.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Acte exécutoire',
    question:
        'Le support indique que l’acte fondant l’obligation peut aussi être :',
    options: [
      'Un acte notarié',
      'Une attestation sur l’honneur seule',
      'Une simple facture',
    ],
    answer: 'Un acte notarié',
    explanation: 'Le support cite l’acte notarié parmi les titres.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Acte exécutoire',
    question: 'Le support mentionne aussi comme titre possible :',
    options: [
      'Une convention à laquelle l’organisme débiteur des prestations familiales a donné force exécutoire',
      'Un courrier non daté',
      'Un accord téléphonique',
    ],
    answer:
        'Une convention à laquelle l’organisme débiteur des prestations familiales a donné force exécutoire',
    explanation:
        'Le support cite cette hypothèse de force exécutoire donnée par l’organisme.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Acte exécutoire',
    question: 'Le support évoque aussi comme fondement possible :',
    options: [
      'Une transaction ou un acte constatant un accord issu d’une médiation/conciliation/procédure participative',
      'Une publication sur un forum',
      'Un échange de SMS',
    ],
    answer:
        'Une transaction ou un acte constatant un accord issu d’une médiation/conciliation/procédure participative',
    explanation:
        'Le support mentionne transaction / accord issu d’une médiation / conciliation / procédure participative.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // ABANDON DE FAMILLE — CONNAISSANCE / NOTIFICATION DE LA DÉCISION
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Notification',
    question:
        'Pour que l’inexécution soit pénalement sanctionnée, le support rappelle que la décision doit :',
    options: [
      'Avoir été notifiée légalement, ou exécutée volontairement, ou que le débiteur en ait eu légalement connaissance',
      'Être simplement prononcée oralement',
      'Être connue uniquement de l’avocat',
    ],
    answer:
        'Avoir été notifiée légalement, ou exécutée volontairement, ou que le débiteur en ait eu légalement connaissance',
    explanation:
        'Le support expose ces modalités de connaissance/notoriété de l’acte.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Période d’obligation',
    question: 'L’obligation de payer se poursuit :',
    options: [
      'Pendant toute la période prévue par l’acte exécutoire tant qu’une décision ultérieure ne la supprime pas',
      'Jusqu’au premier impayé',
      'Jusqu’à une simple contestation',
    ],
    answer:
        'Pendant toute la période prévue par l’acte exécutoire tant qu’une décision ultérieure ne la supprime pas',
    explanation:
        'Le support précise que l’obligation dure tant qu’une décision ultérieure ne la supprime pas.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // ABANDON DE FAMILLE — DÉFAUT DE PAIEMENT : INTÉGRALITÉ / PARTIEL / NATURE
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Défaut de paiement',
    question: 'Le débiteur doit s’acquitter :',
    options: [
      'Intégralement de l’obligation',
      'Seulement d’une partie',
      'Uniquement en nature',
    ],
    answer: 'Intégralement de l’obligation',
    explanation: 'Le support insiste sur l’intégralité du paiement.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Défaut de paiement',
    question: 'L’infraction est constituée si le non-paiement est :',
    options: ['Total ou partiel', 'Uniquement total', 'Uniquement partiel'],
    answer: 'Total ou partiel',
    explanation:
        'Le support indique que le délit est constitué même en cas de paiement partiel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Défaut de paiement',
    question: 'Le débiteur peut être exonéré par des paiements partiels :',
    options: ['Non', 'Oui', 'Oui uniquement si bonne foi'],
    answer: 'Non',
    explanation:
        'Le support précise : paiements partiels ne permettent pas d’exonération.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Défaut de paiement',
    question: 'Le débiteur peut être exonéré par des paiements en nature :',
    options: ['Non', 'Oui', 'Oui si accord oral'],
    answer: 'Non',
    explanation:
        'Le support exclut les paiements en nature comme exonératoires.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Défaut de paiement',
    question: 'Le débiteur peut être exonéré par compensation :',
    options: ['Non', 'Oui', 'Oui si dette réciproque'],
    answer: 'Non',
    explanation: 'Le support exclut la compensation comme moyen d’exonération.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Indexation',
    question:
        'Le délit peut être constitué lorsque le débiteur refuse de prendre en compte une indexation (réévaluation) :',
    options: ['Oui', 'Non', 'Oui seulement si juge le précise'],
    answer: 'Oui',
    explanation:
        'Le support cite Cass. crim., 26 octobre 1987 sur le refus d’indexation.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // ABANDON DE FAMILLE — DÉLAI DE DEUX MOIS : RÈGLES
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Délai',
    question: 'Le défaut de paiement doit durer :',
    options: ['Plus de deux mois', 'Deux mois exactement', 'Un mois'],
    answer: 'Plus de deux mois',
    explanation:
        'Le support précise : le débiteur doit être resté plus de deux mois sans s’acquitter intégralement.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Délai',
    question:
        'Selon la jurisprudence citée (CA Paris, 16 mars 1994), le délit suppose :',
    options: [
      'Que le délai de plus de deux mois soit dépassé (et non deux mois seulement)',
      'Deux mois pile suffisent',
      'Un mois suffit',
    ],
    answer:
        'Que le délai de plus de deux mois soit dépassé (et non deux mois seulement)',
    explanation:
        'Le support cite CA Paris, 16 mars 1994 : “plus de deux mois”.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Point de départ',
    question: 'Le point de départ du délai peut être :',
    options: [
      'La date de la signification de la décision ordonnant le versement',
      'La date de naissance de l’enfant',
      'La date de séparation seulement',
    ],
    answer: 'La date de la signification de la décision ordonnant le versement',
    explanation:
        'Le support fixe comme point de départ la signification de la décision.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Point de départ',
    question:
        'En cas d’interruption des paiements, le point de départ peut être :',
    options: [
      'Le jour du dernier versement intégral',
      'Le jour du dernier versement partiel',
      'Le jour du premier impayé uniquement',
    ],
    answer: 'Le jour du dernier versement intégral',
    explanation:
        'Le support indique : point de départ = dernier versement intégral.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Constitution du délit',
    question: 'Le délit est constitué :',
    options: [
      'Dès que les deux mois sont expirés',
      'Seulement après une relance',
      'Seulement après une mise en demeure',
    ],
    answer: 'Dès que les deux mois sont expirés',
    explanation:
        'Le support précise que l’infraction est constituée dès expiration du délai.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Effet du paiement tardif',
    question:
        'Un paiement intervenant tardivement efface rétroactivement le délit :',
    options: ['Non', 'Oui', 'Oui si le débiteur est de bonne foi'],
    answer: 'Non',
    explanation:
        'Le support indique que le paiement tardif n’efface pas rétroactivement l’existence du délit.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // ABANDON DE FAMILLE — SITUATIONS POSTÉRIEURES (CASSATION / RÉFORMATION)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Effets postérieurs',
    question:
        'Selon le support, l’infraction subsiste même si la décision de base est ensuite cassée :',
    options: ['Oui', 'Non', 'Oui uniquement si la cassation est partielle'],
    answer: 'Oui',
    explanation:
        'Le support cite Cass. crim., 26 juillet 1977 : la cassation ultérieure n’efface pas rétroactivement le délit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Effets postérieurs',
    question:
        'Selon le support, l’infraction subsiste même si la décision de base fait l’objet d’une réformation partielle :',
    options: ['Oui', 'Non', 'Oui uniquement si aggravation'],
    answer: 'Oui',
    explanation: 'Le support cite Cass. crim., 21 mai 1980.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // ABANDON DE FAMILLE — ÉLÉMENT MORAL (VOLONTÉ) + PRÉCARITÉ
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Élément moral',
    question: 'L’élément moral de 227-3 repose sur :',
    options: [
      'La volonté de ne pas exécuter l’acte imposant le versement d’une somme d’argent',
      'La simple négligence',
      'Un oubli excusable',
    ],
    answer:
        'La volonté de ne pas exécuter l’acte imposant le versement d’une somme d’argent',
    explanation:
        'Le délit sanctionne l’inexécution volontaire de l’acte fixant le montant.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Élément moral',
    question:
        'Le délit d’abandon de famille suppose notamment que l’auteur ait :',
    options: [
      'Reçu notification de la décision',
      'Simplement entendu parler de la décision',
      'Été informé par un proche',
    ],
    answer: 'Reçu notification de la décision',
    explanation:
        'Le support précise que l’inexécution volontaire suppose la notification de la décision.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Preuve',
    question:
        'Selon le support, la charge de la preuve (notamment sur le caractère volontaire) appartient :',
    options: [
      'À la partie poursuivante',
      'Au débiteur uniquement',
      'À l’enfant mineur',
    ],
    answer: 'À la partie poursuivante',
    explanation:
        'Le support indique que la charge de la preuve appartient à la partie poursuivante.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Exclusion',
    question: 'Le délit n’est pas constitué si le non-paiement est dû à :',
    options: [
      'Une situation de précarité persistante ne résultant pas de la volonté du débiteur',
      'Une simple envie de ne pas payer',
      'Un conflit avec l’autre parent',
    ],
    answer:
        'Une situation de précarité persistante ne résultant pas de la volonté du débiteur',
    explanation:
        'Le support cite CA Aix-en-Provence, 01 juillet 1994 sur la précarité persistante involontaire.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // ABANDON DE FAMILLE — INTERMÉDIATION FINANCIÈRE
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Intermédiation',
    question:
        'Lorsque l’intermédiation financière des pensions alimentaires est mise en œuvre, l’infraction est constituée si le parent débiteur :',
    options: [
      'Demeure plus de deux mois sans s’acquitter intégralement des sommes dues entre les mains de l’organisme assurant l’intermédiation',
      'Oublie un paiement d’une journée',
      'Paye en nature à l’autre parent',
    ],
    answer:
        'Demeure plus de deux mois sans s’acquitter intégralement des sommes dues entre les mains de l’organisme assurant l’intermédiation',
    explanation: 'Le texte assimile ce comportement à l’abandon de famille.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // ABANDON DE FAMILLE — CIRCONSTANCES AGGRAVANTES / RÉPRESSION
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Circonstances aggravantes',
    question: 'Le support indique des circonstances aggravantes pour 227-3 :',
    options: ['Aucune', 'Oui, 227-9', 'Oui, 227-10'],
    answer: 'Aucune',
    explanation: 'Le support précise : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Répression',
    question:
        'Les peines encourues (personne physique) pour l’abandon de famille (227-3) sont :',
    options: [
      '2 ans d’emprisonnement et 15 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le support fixe : 2 ans + 15 000 €.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Tentative / complicité',
    question: 'Pour 227-3, la tentative est :',
    options: ['Non', 'Oui', 'Oui si paiement partiel'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Tentative / complicité',
    question: 'Pour 227-3, la complicité est :',
    options: [
      'Oui (article 121-7 du Code pénal)',
      'Non',
      'Oui uniquement si le complice est ascendant',
    ],
    answer: 'Oui (article 121-7 du Code pénal)',
    explanation:
        'Le support indique : COMPLICITÉ : OUI, selon l’article 121-7 CP.',
    difficulty: 'Moyenne',
  ),

  // ---------------------------------------------------------
  // ABANDON DE FAMILLE — PERSONNES MORALES (RAPPEL)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Personnes morales',
    question:
        'Le support mentionne que la responsabilité des personnes morales est prévue par :',
    options: [
      'L’article 227-4-1 du Code pénal',
      'L’article 227-3 du Code pénal uniquement',
      'L’article 388 du code civil',
    ],
    answer: 'L’article 227-4-1 du Code pénal',
    explanation:
        'Le support cite 227-4-1 pour la responsabilité des personnes morales.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Personnes morales',
    question:
        'En cas de responsabilité d’une personne morale, l’amende est encourue suivant :',
    options: [
      'Les modalités de l’article 131-38 du Code pénal',
      'Les modalités de l’article 227-9 du Code pénal',
      'Les modalités de l’article 388 du code civil',
    ],
    answer: 'Les modalités de l’article 131-38 du Code pénal',
    explanation:
        'Le support renvoie aux modalités d’amende de l’article 131-38 CP.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Personnes morales',
    question:
        'Le support mentionne aussi des peines complémentaires applicables aux personnes morales via :',
    options: [
      'Les articles 131-39, 2° à 9° du Code pénal',
      'L’article 227-11 du Code pénal',
      'L’article 373-2-2 du code civil',
    ],
    answer: 'Les articles 131-39, 2° à 9° du Code pénal',
    explanation:
        'Le support cite 131-39, 2° à 9° (interdiction d’exercer, etc.).',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // CAS PRATIQUES (QCM) — ABANDON DE FAMILLE
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Cas pratique — Abandon de famille',
    question:
        'Un parent débiteur cesse de payer la pension fixée par décision exécutoire et notifiée. Il ne verse plus rien pendant 2 mois exactement. L’infraction 227-3 est constituée :',
    options: [
      'Non, il faut plus de deux mois',
      'Oui, deux mois suffisent',
      'Oui uniquement si l’enfant est mineur',
    ],
    answer: 'Non, il faut plus de deux mois',
    explanation:
        'Le texte exige plus de deux mois ; la jurisprudence citée précise que deux mois seulement ne suffisent pas.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Cas pratique — Abandon de famille',
    question:
        'Un débiteur effectue des paiements partiels pendant 3 mois au lieu du montant intégral. L’infraction 227-3 peut être constituée :',
    options: [
      'Oui, car l’obligation doit être acquittée intégralement',
      'Non, car il a payé une partie',
      'Non, car les paiements partiels exonèrent',
    ],
    answer: 'Oui, car l’obligation doit être acquittée intégralement',
    explanation:
        'Le support précise que le délit est constitué même en cas de paiement partiel et que le paiement doit être intégral.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Cas pratique — Abandon de famille',
    question:
        'Un débiteur refuse d’appliquer l’indexation prévue, en payant l’ancien montant pendant plus de deux mois. L’infraction peut être constituée :',
    options: ['Oui', 'Non', 'Oui seulement si un huissier intervient'],
    answer: 'Oui',
    explanation:
        'Le support cite que le refus de prendre en compte l’indexation peut constituer le délit (Cass. crim., 26 octobre 1987).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Cas pratique — Abandon de famille',
    question:
        'Le débiteur ne paye pas pendant plus de deux mois mais démontre une précarité persistante non volontaire. Le délit est :',
    options: [
      'Non constitué (caractère involontaire du défaut de paiement)',
      'Toujours constitué',
      'Constitué uniquement si plainte',
    ],
    answer: 'Non constitué (caractère involontaire du défaut de paiement)',
    explanation:
        'Le support indique que la précarité persistante non volontaire exclut le délit (ex. CA Aix-en-Provence, 01/07/1994).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Cas pratique — Abandon de famille',
    question:
        'Après l’expiration du délai de plus de deux mois, le débiteur régularise intégralement. Cela efface rétroactivement l’infraction :',
    options: ['Non', 'Oui', 'Oui si c’est la première fois'],
    answer: 'Non',
    explanation:
        'Le support précise que le paiement tardif n’efface pas rétroactivement l’existence du délit.',
    difficulty: 'Moyenne',
  ),
  // =========================================================
  // AJOUT ENOOOOORME #2 — ABANDON DE FAMILLE (227-3)
  // (à coller directement dans ta liste existante)
  // =========================================================

  // ---------------------------------------------------------
  // 227-3 — CIBLES / BÉNÉFICIAIRES (QUI PEUT ÊTRE PROTÉGÉ ?)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Bénéficiaires',
    question:
        'L’abandon de famille (227-3) peut concerner des sommes dues au profit :',
    options: [
      'D’un enfant mineur',
      'Uniquement d’un enfant majeur',
      'Uniquement d’un voisin',
    ],
    answer: 'D’un enfant mineur',
    explanation:
        'Le texte vise notamment l’enfant mineur parmi les bénéficiaires possibles.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Bénéficiaires',
    question: 'Le texte de 227-3 vise également des sommes dues au profit :',
    options: [
      'D’un descendant',
      'Uniquement d’un colocataire',
      'Uniquement d’un employeur',
    ],
    answer: 'D’un descendant',
    explanation:
        'Le champ d’incrimination vise les obligations au profit d’un descendant.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Bénéficiaires',
    question: 'Le texte de 227-3 vise également des sommes dues au profit :',
    options: [
      'D’un ascendant',
      'Uniquement d’un ami',
      'Uniquement d’un organisme privé',
    ],
    answer: 'D’un ascendant',
    explanation:
        'Le champ d’incrimination vise aussi les obligations au profit d’un ascendant.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Bénéficiaires',
    question: 'Le texte de 227-3 vise également des sommes dues au profit :',
    options: [
      'Du conjoint',
      'Uniquement de l’ex-concubin',
      'Uniquement du frère',
    ],
    answer: 'Du conjoint',
    explanation: 'Le texte mentionne le conjoint parmi les bénéficiaires.',
    difficulty: 'Moyenne',
  ),

  // ---------------------------------------------------------
  // 227-3 — NATURE DES SOMMES (QUOI EXACTEMENT ?)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Sommes dues',
    question: '227-3 vise le non-paiement d’une :',
    options: ['Pension', 'Prime de performance', 'Facture téléphonique'],
    answer: 'Pension',
    explanation:
        'Le texte vise notamment les pensions dues au titre d’obligations familiales.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Sommes dues',
    question: '227-3 vise aussi le non-paiement d’une :',
    options: ['Contribution', 'Caution bancaire', 'Dette commerciale'],
    answer: 'Contribution',
    explanation:
        'Le texte vise les contributions dues au titre des obligations familiales.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Sommes dues',
    question: '227-3 vise aussi le non-paiement de :',
    options: [
      'Subsides',
      'Dommages-intérêts délictuels',
      'Impôt sur le revenu',
    ],
    answer: 'Subsides',
    explanation: 'Le texte vise les subsides.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Sommes dues',
    question: '227-3 vise aussi le non-paiement de :',
    options: [
      'Prestations de toute nature dues en raison d’obligations familiales',
      'Prestations uniquement en espèces',
      'Prestations uniquement après un décès',
    ],
    answer:
        'Prestations de toute nature dues en raison d’obligations familiales',
    explanation:
        'Le texte vise les prestations de toute nature dues au titre des obligations familiales.',
    difficulty: 'Moyenne',
  ),

  // ---------------------------------------------------------
  // 227-3 — ACTE EXÉCUTOIRE : LISTE DES TITRES (ENTRAÎNEMENT)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Titres possibles',
    question:
        'Parmi les fondements possibles de l’obligation (selon le support) on trouve :',
    options: [
      'Une décision juridictionnelle',
      'Un simple accord oral',
      'Une attestation non signée',
    ],
    answer: 'Une décision juridictionnelle',
    explanation:
        'Le support cite la décision juridictionnelle parmi les actes possibles.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Titres possibles',
    question:
        'Parmi les fondements possibles de l’obligation (selon le support) on trouve :',
    options: [
      'Une convention judiciairement homologuée',
      'Un SMS',
      'Une promesse verbale',
    ],
    answer: 'Une convention judiciairement homologuée',
    explanation: 'Le support cite la convention homologuée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Titres possibles',
    question:
        'Parmi les fondements possibles de l’obligation (selon le support) on trouve :',
    options: [
      'Une convention prévue à l’article 229-1 du code civil',
      'Un échange WhatsApp',
      'Un simple brouillon',
    ],
    answer: 'Une convention prévue à l’article 229-1 du code civil',
    explanation: 'Le support mentionne la convention 229-1 du code civil.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Titres possibles',
    question:
        'Parmi les fondements possibles de l’obligation (selon le support) on trouve :',
    options: [
      'Un acte notarié',
      'Une déclaration d’intention',
      'Un courrier non daté',
    ],
    answer: 'Un acte notarié',
    explanation: 'Le support mentionne l’acte notarié.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Titres possibles',
    question:
        'Parmi les fondements possibles de l’obligation (selon le support) on trouve :',
    options: [
      'Une convention à laquelle l’organisme débiteur des prestations familiales a donné force exécutoire',
      'Une convention non signée',
      'Un simple mail',
    ],
    answer:
        'Une convention à laquelle l’organisme débiteur des prestations familiales a donné force exécutoire',
    explanation:
        'Le support cite ce type de convention ayant reçu force exécutoire.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Titres possibles',
    question: 'Le support mentionne aussi comme fondement :',
    options: [
      'Une transaction',
      'Une discussion téléphonique',
      'Un message vocal',
    ],
    answer: 'Une transaction',
    explanation: 'Le support cite la transaction parmi les actes possibles.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Titres possibles',
    question: 'Le support mentionne aussi comme fondement :',
    options: [
      'Un acte constatant un accord issu d’une médiation',
      'Une simple décision de l’école',
      'Une note manuscrite',
    ],
    answer: 'Un acte constatant un accord issu d’une médiation',
    explanation: 'Le support mentionne un accord issu d’une médiation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Titres possibles',
    question: 'Le support mentionne aussi comme fondement :',
    options: [
      'Un acte constatant un accord issu d’une conciliation',
      'Un devis',
      'Un courriel',
    ],
    answer: 'Un acte constatant un accord issu d’une conciliation',
    explanation: 'Le support mentionne un accord issu d’une conciliation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Titres possibles',
    question: 'Le support mentionne aussi comme fondement :',
    options: [
      'Un acte constatant un accord issu d’une procédure participative',
      'Un simple post Facebook',
      'Une promesse familiale',
    ],
    answer: 'Un acte constatant un accord issu d’une procédure participative',
    explanation:
        'Le support mentionne l’accord issu d’une procédure participative.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // 227-3 — EXÉCUTOIRE / CONNAISSANCE : CONDITIONS
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Acte exécutoire',
    question: 'L’obligation pénalement protégée doit présenter un caractère :',
    options: ['Exécutoire', 'Facultatif', 'Moral seulement'],
    answer: 'Exécutoire',
    explanation:
        'Le support exige le caractère exécutoire de la décision ou du titre.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Connaissance',
    question:
        'Le support indique que l’acte peut fonder des poursuites s’il a été :',
    options: [
      'Notifié légalement au débiteur',
      'Uniquement affiché au tribunal',
      'Seulement envoyé à l’avocat adverse',
    ],
    answer: 'Notifié légalement au débiteur',
    explanation:
        'Le support insiste sur la notification légale au débiteur (ou autres formes de connaissance).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Connaissance',
    question:
        'Le support indique aussi que l’acte peut fonder des poursuites si :',
    options: [
      'Le débiteur en a eu légalement connaissance',
      'Le débiteur l’ignore totalement',
      'Le débiteur n’a jamais été informé',
    ],
    answer: 'Le débiteur en a eu légalement connaissance',
    explanation: 'Le support évoque la “connaissance légale” du débiteur.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Connaissance',
    question:
        'Le support précise aussi qu’à défaut, l’acte peut fonder des poursuites s’il a été :',
    options: ['Volontairement exécuté', 'Uniquement contesté', 'Ignoré'],
    answer: 'Volontairement exécuté',
    explanation:
        'Le support mentionne l’hypothèse d’une exécution volontaire comme élément de rattachement.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // 227-3 — DÉFAUT DE PAIEMENT : TOTAL / PARTIEL / REFUS INDEXATION
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Paiement intégral',
    question:
        'Le délit peut être constitué même si le débiteur a payé “un peu” :',
    options: [
      'Oui, car le paiement doit être intégral',
      'Non, car tout paiement suffit',
      'Non, si le paiement est en espèces',
    ],
    answer: 'Oui, car le paiement doit être intégral',
    explanation:
        'Le support précise que le délit est constitué en cas de paiement partiel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Indexation',
    question:
        'Le refus de prendre en compte une indexation (réévaluation) peut :',
    options: [
      'Constituer le délit d’abandon de famille',
      'Écarter systématiquement l’infraction',
      'Transformer l’infraction en contravention',
    ],
    answer: 'Constituer le délit d’abandon de famille',
    explanation:
        'Le support cite Cass. crim., 26 octobre 1987 sur le refus d’indexation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Paiement en nature',
    question:
        'Le débiteur peut échapper à l’infraction en payant “en nature” (cadeaux, courses, etc.) :',
    options: ['Non', 'Oui', 'Oui si accord verbal'],
    answer: 'Non',
    explanation:
        'Le support précise que paiements en nature ne permettent pas d’exonération.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Compensation',
    question:
        'Le débiteur peut échapper à l’infraction en compensant avec une dette de l’autre parent :',
    options: ['Non', 'Oui', 'Oui si le juge l’autorise oralement'],
    answer: 'Non',
    explanation: 'Le support exclut la compensation comme cause d’exonération.',
    difficulty: 'Moyenne',
  ),

  // ---------------------------------------------------------
  // 227-3 — DÉLAI : + DE 2 MOIS (PIÈGES CLASSIQUES)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Délai',
    question: 'Le texte exige que le débiteur demeure plus de deux mois :',
    options: [
      'Sans s’acquitter intégralement',
      'Sans payer la moitié seulement',
      'Sans répondre aux messages',
    ],
    answer: 'Sans s’acquitter intégralement',
    explanation:
        'Le support précise “plus de deux mois sans s’acquitter intégralement”.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Délai',
    question:
        'Si le débiteur ne paie pas pendant exactement deux mois, l’infraction est :',
    options: [
      'Non constituée (il faut plus de deux mois)',
      'Constituée',
      'Constituée uniquement si plainte',
    ],
    answer: 'Non constituée (il faut plus de deux mois)',
    explanation:
        'Le support cite CA Paris, 16 mars 1994 : il faut dépasser les deux mois.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Délai',
    question: 'Le point de départ du délai est fixé notamment à :',
    options: [
      'La date de la signification de la décision ordonnant le versement',
      'La date du divorce',
      'La date de l’audience',
    ],
    answer: 'La date de la signification de la décision ordonnant le versement',
    explanation: 'Le support indique la signification comme point de départ.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Délai',
    question: 'En cas d’interruption des paiements, le point de départ est :',
    options: [
      'Le jour du dernier versement intégral',
      'Le jour du dernier versement partiel',
      'Le jour de la dernière relance',
    ],
    answer: 'Le jour du dernier versement intégral',
    explanation: 'Le support précise : dernier versement intégral.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // 227-3 — “RÉTROACTIVITÉ” : AUCUNE SITUATION POSTÉRIEURE N’EFFACE
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Effets postérieurs',
    question:
        'Une situation postérieure peut effacer rétroactivement l’existence du délit :',
    options: ['Non', 'Oui', 'Oui si le débiteur régularise'],
    answer: 'Non',
    explanation:
        'Le support indique qu’aucune situation postérieure n’efface rétroactivement l’existence du délit.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Effets postérieurs',
    question:
        'Le délit peut subsister même si la décision de base est cassée ultérieurement :',
    options: ['Oui', 'Non', 'Oui uniquement si la cassation est totale'],
    answer: 'Oui',
    explanation: 'Le support cite Cass. crim., 26 juillet 1977.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Effets postérieurs',
    question:
        'Le délit peut subsister même si la décision est réformée partiellement ensuite :',
    options: [
      'Oui',
      'Non',
      'Oui uniquement si la réformation augmente la pension',
    ],
    answer: 'Oui',
    explanation: 'Le support cite Cass. crim., 21 mai 1980.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Effets postérieurs',
    question:
        'Le paiement tardif après expiration du délai de plus de deux mois :',
    options: [
      'N’efface pas rétroactivement l’infraction',
      'Efface toujours l’infraction',
      'Efface seulement en première infraction',
    ],
    answer: 'N’efface pas rétroactivement l’infraction',
    explanation: 'Le support cite Cass. crim., 23 mars 1981 (paiement tardif).',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // 227-3 — ÉLÉMENT MORAL : VOLONTÉ + PRÉCARITÉ
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Intention',
    question: 'L’abandon de famille sanctionne :',
    options: [
      'L’inexécution volontaire de l’acte fixant la pension/obligation',
      'Un simple oubli ponctuel',
      'Une erreur de calcul toujours excusable',
    ],
    answer: 'L’inexécution volontaire de l’acte fixant la pension/obligation',
    explanation:
        'Le support vise l’inexécution volontaire (à condition de notification).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Intention',
    question:
        'Le délit n’est pas constitué si le non-paiement résulte d’une précarité persistante :',
    options: [
      'Ne résultant pas de la volonté du débiteur',
      'Résultant d’un choix de confort',
      'Résultant d’un désaccord parental',
    ],
    answer: 'Ne résultant pas de la volonté du débiteur',
    explanation: 'Le support cite CA Aix-en-Provence, 01 juillet 1994.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Preuve',
    question:
        'La preuve (notamment de la notification et du caractère volontaire) relève :',
    options: [
      'De la partie poursuivante',
      'Du débiteur uniquement',
      'Du juge exclusivement',
    ],
    answer: 'De la partie poursuivante',
    explanation:
        'Le support indique que la charge de la preuve appartient à la partie poursuivante.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // 227-3 — INTERMÉDIATION FINANCIÈRE (CAF / ORGANISME)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Intermédiation',
    question:
        'Avec intermédiation financière, le débiteur commet l’infraction s’il ne paye pas intégralement pendant plus de deux mois :',
    options: [
      'Entre les mains de l’organisme assurant l’intermédiation',
      'Uniquement directement à l’autre parent',
      'Uniquement en espèces',
    ],
    answer: 'Entre les mains de l’organisme assurant l’intermédiation',
    explanation:
        'Le texte prévoit la même infraction via l’organisme assurant l’intermédiation.',
    difficulty: 'Difficile',
  ),

  // ---------------------------------------------------------
  // 227-3 — RÉPRESSION / PROCÉDURE
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Abandon de famille — Répression',
    question: 'Les peines principales prévues par 227-3 sont :',
    options: [
      '2 ans d’emprisonnement et 15 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le support indique : 2 ans + 15 000 €.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Circonstances aggravantes',
    question: 'Le support prévoit des circonstances aggravantes pour 227-3 :',
    options: ['Aucune', 'Oui, au-delà de 5 jours', 'Oui, si à l’étranger'],
    answer: 'Aucune',
    explanation: 'Le support mentionne : Aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Tentative / complicité',
    question: 'Pour l’abandon de famille (227-3), la tentative est :',
    options: ['Non', 'Oui', 'Oui si paiement partiel'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abandon de famille — Tentative / complicité',
    question: 'Pour l’abandon de famille (227-3), la complicité est :',
    options: [
      'Oui (article 121-7 du Code pénal)',
      'Non',
      'Oui uniquement si la pension est due à un mineur',
    ],
    answer: 'Oui (article 121-7 du Code pénal)',
    explanation: 'Le support indique : COMPLICITÉ : OUI (121-7 CP).',
    difficulty: 'Moyenne',
  ),

  // ---------------------------------------------------------
  // CAS PRATIQUES (NIVEAUX MIXÉS)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: 'Cas pratique — Abandon de famille',
    question:
        'Décision exécutoire notifiée : pension 300 €/mois. Le débiteur paye 150 € pendant 4 mois. L’infraction 227-3 peut être constituée :',
    options: [
      'Oui, car le paiement doit être intégral et l’impayé peut être partiel',
      'Non, car il a payé quelque chose',
      'Non, car il n’y a pas d’impayé total',
    ],
    answer:
        'Oui, car le paiement doit être intégral et l’impayé peut être partiel',
    explanation:
        'Le support précise que le délit est constitué en cas de non-paiement total ou partiel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Cas pratique — Abandon de famille',
    question:
        'Décision notifiée : pension indexée. Le débiteur paye l’ancien montant pendant plus de deux mois et refuse l’indexation. Le délit peut être :',
    options: ['Constitué', 'Non constitué', 'Constitué uniquement si saisie'],
    answer: 'Constitué',
    explanation:
        'Le support mentionne que le refus d’indexation peut constituer le délit (Cass. crim., 26/10/1987).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Cas pratique — Abandon de famille',
    question:
        'Le débiteur ne paye pas pendant plus de deux mois, puis régularise après 3 mois. L’infraction :',
    options: [
      'Reste constituée, le paiement tardif n’efface pas rétroactivement',
      'Est effacée automatiquement',
      'N’existe plus si la victime retire plainte',
    ],
    answer: 'Reste constituée, le paiement tardif n’efface pas rétroactivement',
    explanation:
        'Le support précise que le paiement tardif n’efface pas rétroactivement l’existence du délit.',
    difficulty: 'Difficile',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizAbandonFamillePA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/abandon_famille/quiz_abandon_famille';
  final String uid;
  final String email;

  const QuizAbandonFamillePA({super.key, required this.uid, required this.email});

  @override
  State<QuizAbandonFamillePA> createState() => _QuizAbandonFamillePAState();
}

class _QuizAbandonFamillePAState extends State<QuizAbandonFamillePA>
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
  static const _introHiddenKey = 'intro_pa_abandon_famille';
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
        ? questionAbandonFamille
        : questionAbandonFamille
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
            'quiz_name': 'Abandon de famille',
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
      await _sb.from('quiz_abandon_famille').insert({
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
      debugPrint('❌ quiz_abandon_famille insert failed: $e');
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
      'source_file': 'pa_quiz_abandon_famille',
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
                            icon: Icons.family_restroom_rounded,
                            title: 'Abandon de famille',
                            description: 'Teste tes connaissances sur l’abandon de famille, les obligations alimentaires et la protection des membres vulnérables du foyer.',
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
