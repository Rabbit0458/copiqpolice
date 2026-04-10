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
import 'package:copiqpolice/ui/app_notifier.dart'
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

final List<QuizQuestion> questionAbandonFamille = [
  // =========================================================
  // AJOUT ENOOOOORME — ABANDON DE FAMILLE (227-3)
  // (à coller directement dans ta liste existante, sans "final List..." ni fermeture)
  // =========================================================

  // ---------------------------------------------------------
  // ABANDON DE FAMILLE — FONDEMENT / DÉFINITION
  // ---------------------------------------------------------
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Abandon de famille — Défaut de paiement',
    question: 'L’infraction est constituée si le non-paiement est :',
    options: ['Total ou partiel', 'Uniquement total', 'Uniquement partiel'],
    answer: 'Total ou partiel',
    explanation:
        'Le support indique que le délit est constitué même en cas de paiement partiel.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Abandon de famille — Défaut de paiement',
    question: 'Le débiteur peut être exonéré par des paiements partiels :',
    options: ['Non', 'Oui', 'Oui uniquement si bonne foi'],
    answer: 'Non',
    explanation:
        'Le support précise : paiements partiels ne permettent pas d’exonération.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Abandon de famille — Défaut de paiement',
    question: 'Le débiteur peut être exonéré par des paiements en nature :',
    options: ['Non', 'Oui', 'Oui si accord oral'],
    answer: 'Non',
    explanation:
        'Le support exclut les paiements en nature comme exonératoires.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Abandon de famille — Défaut de paiement',
    question: 'Le débiteur peut être exonéré par compensation :',
    options: ['Non', 'Oui', 'Oui si dette réciproque'],
    answer: 'Non',
    explanation: 'Le support exclut la compensation comme moyen d’exonération.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Abandon de famille — Délai',
    question: 'Le défaut de paiement doit durer :',
    options: ['Plus de deux mois', 'Deux mois exactement', 'Un mois'],
    answer: 'Plus de deux mois',
    explanation:
        'Le support précise : le débiteur doit être resté plus de deux mois sans s’acquitter intégralement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Abandon de famille — Effets postérieurs',
    question:
        'Selon le support, l’infraction subsiste même si la décision de base est ensuite cassée :',
    options: ['Oui', 'Non', 'Oui uniquement si la cassation est partielle'],
    answer: 'Oui',
    explanation:
        'Le support cite Cass. crim., 26 juillet 1977 : la cassation ultérieure n’efface pas rétroactivement le délit.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Abandon de famille — Circonstances aggravantes',
    question: 'Le support indique des circonstances aggravantes pour 227-3 :',
    options: ['Aucune', 'Oui, 227-9', 'Oui, 227-10'],
    answer: 'Aucune',
    explanation: 'Le support précise : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Abandon de famille — Tentative / complicité',
    question: 'Pour 227-3, la tentative est :',
    options: ['Non', 'Oui', 'Oui si paiement partiel'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Cas pratique — Abandon de famille',
    question:
        'Un débiteur refuse d’appliquer l’indexation prévue, en payant l’ancien montant pendant plus de deux mois. L’infraction peut être constituée :',
    options: ['Oui', 'Non', 'Oui seulement si un huissier intervient'],
    answer: 'Oui',
    explanation:
        'Le support cite que le refus de prendre en compte l’indexation peut constituer le délit (Cass. crim., 26 octobre 1987).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Abandon de famille — Sommes dues',
    question: '227-3 vise le non-paiement d’une :',
    options: ['Pension', 'Prime de performance', 'Facture téléphonique'],
    answer: 'Pension',
    explanation:
        'Le texte vise notamment les pensions dues au titre d’obligations familiales.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Abandon de famille — Sommes dues',
    question: '227-3 vise aussi le non-paiement d’une :',
    options: ['Contribution', 'Caution bancaire', 'Dette commerciale'],
    answer: 'Contribution',
    explanation:
        'Le texte vise les contributions dues au titre des obligations familiales.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Abandon de famille — Acte exécutoire',
    question: 'L’obligation pénalement protégée doit présenter un caractère :',
    options: ['Exécutoire', 'Facultatif', 'Moral seulement'],
    answer: 'Exécutoire',
    explanation:
        'Le support exige le caractère exécutoire de la décision ou du titre.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Abandon de famille — Paiement en nature',
    question:
        'Le débiteur peut échapper à l’infraction en payant “en nature” (cadeaux, courses, etc.) :',
    options: ['Non', 'Oui', 'Oui si accord verbal'],
    answer: 'Non',
    explanation:
        'Le support précise que paiements en nature ne permettent pas d’exonération.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Abandon de famille — Effets postérieurs',
    question:
        'Une situation postérieure peut effacer rétroactivement l’existence du délit :',
    options: ['Non', 'Oui', 'Oui si le débiteur régularise'],
    answer: 'Non',
    explanation:
        'Le support indique qu’aucune situation postérieure n’efface rétroactivement l’existence du délit.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Abandon de famille — Effets postérieurs',
    question:
        'Le délit peut subsister même si la décision de base est cassée ultérieurement :',
    options: ['Oui', 'Non', 'Oui uniquement si la cassation est totale'],
    answer: 'Oui',
    explanation: 'Le support cite Cass. crim., 26 juillet 1977.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Non-représentation — Tentative / complicité',
    question: 'Pour 227-5, la tentative est :',
    options: ['Non', 'Oui', 'Oui si l’enfant est à l’étranger'],
    answer: 'Non',
    explanation: 'Le support indique : tentative non prévue.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Transfert domicile — 227-6',
    question: 'Le délai légal de notification (227-6) est :',
    options: ['Un mois', 'Cinq jours', 'Six jours'],
    answer: 'Un mois',
    explanation: 'Le support prévoit un délai d’un mois.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Transfert domicile — 227-6',
    question: 'La simple négligence est punissable pour 227-6 :',
    options: ['Non', 'Oui', 'Oui seulement si déménagement loin'],
    answer: 'Non',
    explanation:
        'Le support précise que la simple négligence n’est pas punissable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Transfert domicile — Tentative / complicité',
    question: 'Pour 227-6, la tentative est :',
    options: ['Non', 'Oui', 'Oui si l’enfant est déplacé'],
    answer: 'Non',
    explanation: 'Le support indique : tentative non prévue.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Soustraction par tiers — 227-8',
    question: 'Le support rappelle que 227-8 exige une soustraction :',
    options: ['Sans fraude ni violence', 'Avec violence', 'Avec fraude'],
    answer: 'Sans fraude ni violence',
    explanation: 'Le texte impose l’absence de fraude et de violence.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Non-représentation — Élément moral',
    question: 'La non-représentation d’enfant mineur est une infraction :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Contraventionnelle'],
    answer: 'Intentionnelle',
    explanation: 'Le support précise que l’infraction est intentionnelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Non-représentation — Tentative / complicité',
    question: 'Pour la non-représentation d’enfant (227-5), la tentative est :',
    options: ['Non', 'Oui', 'Oui uniquement en aggravé'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Défaut notification transfert domicile — Élément moral',
    question:
        'Le défaut de notification de transfert de domicile (227-6) est une infraction :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Contraventionnelle'],
    answer: 'Intentionnelle',
    explanation:
        'Le support précise l’intention : volonté de faire échec au droit de visite/hébergement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Défaut notification transfert domicile — Tentative / complicité',
    question: 'Pour 227-6, la tentative est :',
    options: ['Non', 'Oui', 'Oui uniquement si l’enfant est à l’étranger'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Soustraction par ascendant — Élément moral',
    question:
        'La soustraction d’enfant mineur par ascendant (227-7) est une infraction :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Purement civile'],
    answer: 'Intentionnelle',
    explanation: 'Le support précise que l’infraction est intentionnelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Soustraction par tiers — Élément moral',
    question:
        'La soustraction sans fraude ni violence (227-8) est une infraction :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Purement civile'],
    answer: 'Intentionnelle',
    explanation:
        'Le support précise l’intention : connaissance de son absence de droit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Comparatif — Autorité parentale',
    question:
        'Quel article vise le refus indû de représenter un enfant mineur ?',
    options: ['227-5', '227-6', '227-8'],
    answer: '227-5',
    explanation: '227-5 = non-représentation d’enfant mineur.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — Autorité parentale',
    question:
        'Quel article vise le défaut de notification de transfert de domicile du parent gardien ?',
    options: ['227-6', '227-5', '227-7'],
    answer: '227-6',
    explanation: '227-6 = défaut de notification de transfert de domicile.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — Autorité parentale',
    question:
        'Quel article vise la soustraction d’enfant mineur commise par un ascendant ?',
    options: ['227-7', '227-8', '227-6'],
    answer: '227-7',
    explanation: '227-7 = soustraction par ascendant.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — Autorité parentale',
    question:
        'Quel article vise la soustraction d’enfant mineur sans fraude ni violence par un tiers ?',
    options: ['227-8', '227-7', '227-5'],
    answer: '227-8',
    explanation:
        '227-8 = soustraction par personne autre qu’un ascendant, sans fraude ni violence.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Corruption de mineur — Bande organisée',
    question: 'La corruption de mineur commise en bande organisée :',
    options: ['Est aggravée', 'N’est pas visée', 'Relève uniquement du civil'],
    answer: 'Est aggravée',
    explanation: 'Art. 227-22 al.3 : bande organisée = aggravation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Diffusion message dangereux — Support',
    question: 'Le support du message (art. 227-24) est :',
    options: ['Indifférent', 'Uniquement papier', 'Uniquement numérique'],
    answer: 'Indifférent',
    explanation:
        'Texte : « par quelque moyen que ce soit et quel qu’en soit le support ».',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation mineur crime/délit — Effet',
    question: 'Il est nécessaire que la provocation ait été suivie d’effet :',
    options: ['Oui', 'Non', 'Uniquement si le mineur < 15 ans'],
    answer: 'Non',
    explanation: 'L’infraction est autonome : effet indifférent.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Propositions sexuelles — Auteur',
    question: 'L’auteur des propositions sexuelles (227-22-1) doit être :',
    options: ['Majeur', 'Mineur', 'Indifférent'],
    answer: 'Majeur',
    explanation: 'Le texte vise expressément un majeur.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Auteur',
    question: 'L’auteur doit être :',
    options: ['Majeur', 'Mineur', 'Indifférent'],
    answer: 'Majeur',
    explanation: 'Le texte vise expressément le majeur.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
    category: 'Corruption de mineur — Consentement',
    question: 'Le consentement du mineur en matière de corruption :',
    options: ['Est indifférent', 'Exclut l’infraction', 'Atténue la peine'],
    answer: 'Est indifférent',
    explanation:
        'Le consentement du mineur n’a aucune incidence sur la caractérisation de l’infraction.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
    category: 'Privation de soins — Élément moral',
    question: 'La volonté de nuire est :',
    options: ['Inutile', 'Obligatoire', 'Présumée'],
    answer: 'Inutile',
    explanation: 'La conscience du risque suffit.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Privation de soins — Aggravation',
    question: 'La privation ayant entraîné la mort du mineur constitue :',
    options: ['Un crime', 'Un délit aggravé', 'Une contravention'],
    answer: 'Un crime',
    explanation: 'Prévu à l’article 227-16 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Provocation délinquance — Nature',
    question: 'Une simple apologie générale de la délinquance :',
    options: ['Ne suffit pas', 'Est constitutive', 'Vaut tentative'],
    answer: 'Ne suffit pas',
    explanation: 'La provocation doit être directe et précise.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
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

  QuizQuestion(
    category: 'Provocation délinquance — Effet',
    question: 'Le passage à l’acte du mineur est :',
    options: ['Indifférent', 'Nécessaire', 'Atténuant'],
    answer: 'Indifférent',
    explanation: 'L’infraction est consommée par la provocation.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
    category: 'Alcool — Provocation directe',
    question: 'La provocation doit être :',
    options: ['Directe et précise', 'Générale', 'Symbolique'],
    answer: 'Directe et précise',
    explanation: 'Une simple suggestion ne suffit pas.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
    category: 'Stupéfiants — Élément moral',
    question: 'L’auteur doit agir :',
    options: ['En connaissance de cause', 'Par imprudence', 'Par négligence'],
    answer: 'En connaissance de cause',
    explanation: 'Infraction intentionnelle.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
    category: 'Soustraction parentale — Motif légitime',
    question: 'Le motif légitime est apprécié :',
    options: ['Restrictivement par les juges', 'Largement', 'Automatiquement'],
    answer: 'Restrictivement par les juges',
    explanation: 'La jurisprudence est constante.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
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

  QuizQuestion(
    category: 'Soustraction parentale — Tentative',
    question: 'La tentative de soustraction aux obligations parentales est :',
    options: ['Non punissable', 'Punissable', 'Punissable en cas de récidive'],
    answer: 'Non punissable',
    explanation: 'La tentative n’est pas prévue.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
    category: 'Corruption de mineur — Qualification',
    question: 'La corruption de mineur (227-22) est :',
    options: ['Un délit', 'Un crime', 'Une contravention'],
    answer: 'Un délit',
    explanation: 'Le cours classe la corruption de mineur comme un délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Corruption de mineur — Réseau électronique',
    question:
        'La corruption est aggravée si le mineur a été mis en contact via un réseau de communications électroniques :',
    options: ['Oui', 'Non', 'Uniquement si mineur < 15 ans'],
    answer: 'Oui',
    explanation:
        'Circ. aggravante prévue à 227-22 (messages à destination d’un public non déterminé).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Corruption de mineur — Lieux scolaires',
    question:
        'La corruption est aggravée si commise dans/aux abords d’un établissement scolaire (temps très voisin des entrées/sorties) :',
    options: ['Oui', 'Non', 'Uniquement si bande organisée'],
    answer: 'Oui',
    explanation: 'Circ. aggravante prévue à l’article 227-22 al.1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Corruption de mineur — Intention d’exécuter',
    question:
        'La loi exige que l’auteur ait voulu mettre ses actes à exécution au-delà de l’intimidation/dépravation :',
    options: ['Non', 'Oui', 'Uniquement si mineur < 15 ans'],
    answer: 'Non',
    explanation:
        'Le cours explique que l’intention de corrompre suffit : pas besoin d’un “résultat”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Corruption de mineur — Complicité',
    question: 'La complicité en matière de corruption de mineur est :',
    options: ['Punissable', 'Non punissable', 'Uniquement contraventionnelle'],
    answer: 'Punissable',
    explanation: 'Le cours indique : complicité oui.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Corruption de mineur — Répression aggravée (réseau/lieux)',
    question: 'En cas d’aggravation (réseau/lieux), la peine peut passer à :',
    options: ['7 ans et 100 000 €', '5 ans et 75 000 €', '1 an et 15 000 €'],
    answer: '7 ans et 100 000 €',
    explanation:
        'Le tableau du cours mentionne 7 ans et 100 000 € pour une aggravation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Diffusion message — Déclaration mineur',
    question:
        'L’infraction peut être constituée même si le mineur a simplement déclaré avoir 18 ans :',
    options: ['Oui', 'Non', 'Uniquement si paiement'],
    answer: 'Oui',
    explanation: 'Le cours précise que ce cas n’exclut pas l’infraction.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation pédopornographie — Mineur',
    question: 'La victime des crimes/délits visés (227-28-3) doit être :',
    options: ['Un mineur', 'Un majeur', 'Indifférent'],
    answer: 'Un mineur',
    explanation: 'Le texte vise des faits “à l’encontre d’un mineur”.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation pédopornographie — Aggravations',
    question: 'Le texte 227-28-3 prévoit des circonstances aggravantes :',
    options: ['Non', 'Oui, systématiquement', 'Oui, si mineur < 15 ans'],
    answer: 'Non',
    explanation: 'Le cours mentionne : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation alcool — Directe',
    question: 'La provocation doit être :',
    options: ['Directe', 'Indirecte seulement', 'Toujours par écrit'],
    answer: 'Directe',
    explanation: 'Le cours insiste sur la provocation directe et précise.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation alcool — Tentative',
    question: 'La tentative de 227-19 est :',
    options: ['Non punissable', 'Punissable', 'Toujours punissable'],
    answer: 'Non punissable',
    explanation: 'Le cours indique : tentative non.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation stupéfiants — Nature',
    question: 'La provocation visée doit être :',
    options: ['Directe', 'Indirecte', 'Toujours écrite'],
    answer: 'Directe',
    explanation:
        'Le cours insiste sur la provocation directe avec lien précis.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation stupéfiants — Tentative',
    question:
        'La tentative des infractions de provocation (227-18 / 227-18-1) est :',
    options: ['Non punissable', 'Punissable', 'Toujours punissable'],
    answer: 'Non punissable',
    explanation: 'Le cours indique : tentative non.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Soustraction obligations — Auteur',
    question: 'L’auteur de l’infraction 227-17 est :',
    options: ['Le père ou la mère', 'Un ascendant quelconque', 'Tout adulte'],
    answer: 'Le père ou la mère',
    explanation:
        'Le texte vise père et mère à l’exclusion des autres ascendants.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Soustraction obligations — Nature',
    question:
        'La soustraction peut être constituée même si le parent reste physiquement au domicile :',
    options: ['Oui', 'Non', 'Uniquement si mineur < 15 ans'],
    answer: 'Oui',
    explanation:
        'Le cours évoque un abandon moral possible sans départ du domicile.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Soustraction obligations — Dommage effectif',
    question: 'Le texte exige que le dommage se soit effectivement réalisé :',
    options: ['Non', 'Oui', 'Uniquement si mineur < 15'],
    answer: 'Non',
    explanation: 'Il suffit que ce soit susceptible de se réaliser.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Soustraction obligations — Tentative',
    question: 'La tentative de 227-17 est :',
    options: ['Non punissable', 'Punissable', 'Punissable uniquement si al.2'],
    answer: 'Non punissable',
    explanation: 'Le cours indique : tentative non.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Transversal — Auteur limité',
    question: 'Quel texte limite explicitement l’auteur au “père ou la mère” ?',
    options: ['227-17', '227-15', '227-24'],
    answer: '227-17',
    explanation: 'Le texte 227-17 vise père et mère.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Transversal — Élément moral “conscience du risque”',
    question:
        'Quel texte insiste sur la conscience/prévision d’un mal pour l’enfant sans exiger une volonté de nuire ?',
    options: ['227-15', '227-23', '227-28-3'],
    answer: '227-15',
    explanation: 'Le cours cite Cass. crim. 11 mars 1975 : conscience du mal.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Transversal — Aucun aggravant',
    question:
        'Quel texte indique “Aucune” circonstance aggravante dans le cours ?',
    options: ['227-24', '227-22', '227-21'],
    answer: '227-24',
    explanation:
        'Le cours précise : aucune circonstance aggravante pour 227-24.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Transversal — Réunion sexuelle',
    question:
        'L’organisation de réunions sexuelles avec présence d’un mineur renvoie principalement à :',
    options: ['227-22 al.2', '227-24 al.1', '227-17'],
    answer: '227-22 al.2',
    explanation: 'Cas expressément visé par 227-22 al.2.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Complicité',
    question: 'La complicité de 227-15 est :',
    options: ['Punissable', 'Non punissable', 'Toujours exclue'],
    answer: 'Punissable',
    explanation: 'Le cours indique : complicité oui (121-7).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Privation aliments/soins — Tentative',
    question: 'La tentative de 227-15 est :',
    options: ['Non punissable', 'Punissable', 'Toujours punissable'],
    answer: 'Non punissable',
    explanation: 'Le cours indique : tentative non.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Nature 227-16',
    question:
        'Lorsque la privation entraîne la mort (227-16), l’infraction devient :',
    options: ['Un crime', 'Un délit', 'Une contravention'],
    answer: 'Un crime',
    explanation:
        'Le tableau du cours classe 227-16 comme crime (30 ans de réclusion).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Résultat',
    question:
        'Pour 227-15, il faut prouver que la santé a été atteinte gravement :',
    options: ['Non', 'Oui', 'Uniquement si mineur < 6'],
    answer: 'Non',
    explanation:
        'Le cours précise qu’il suffit que les privations soient susceptibles d’altérer la santé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Privation aliments/soins — Élément moral',
    question: 'L’infraction 227-15 est :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Toujours involontaire'],
    answer: 'Intentionnelle',
    explanation: 'Le cours indique : infraction intentionnelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Convictions religieuses',
    question:
        'Les convictions religieuses peuvent justifier les privations au sens de 227-15 :',
    options: ['Non', 'Oui', 'Uniquement en cas d’accord du mineur'],
    answer: 'Non',
    explanation:
        'Le cours indique que les convictions religieuses ne justifient pas si risque pour la santé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Crime/délit',
    question: '227-15 (simple) est classé comme :',
    options: ['Délit', 'Crime', 'Contravention'],
    answer: 'Délit',
    explanation: 'Le tableau de répression indique : délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Mort',
    question: 'Si la privation entraîne la mort, la qualification est :',
    options: ['227-16', '227-15 al.3', '227-17'],
    answer: '227-16',
    explanation: 'Le cours isole la mort à l’article 227-16.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Privation aliments/soins — Nécessité de résultat',
    question: 'Le résultat dommageable doit être effectif pour 227-15 :',
    options: ['Non', 'Oui', 'Uniquement si mineur < 6'],
    answer: 'Non',
    explanation: 'Il suffit qu’il soit susceptible de se réaliser.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Appréciation',
    question:
        'Qui apprécie au cas par cas l’impact des privations sur la santé du mineur ?',
    options: ['Les juges du fond', 'Le préfet', 'Le maire'],
    answer: 'Les juges du fond',
    explanation:
        'Le cours indique : appréciation au cas par cas par les juges.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Exemple CA Douai',
    question:
        'Dans l’exemple CA Douai 15 février 2006, les enfants ne pouvaient pas cuire faute de :',
    options: ['Gaz', 'Télévision', 'Internet'],
    answer: 'Gaz',
    explanation: 'Le cours mentionne absence de gaz, eau, électricité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — 227-16',
    question: 'L’article 227-16 s’applique quand la privation :',
    options: ['A entraîné la mort', 'A duré plus d’un mois', 'A été filmée'],
    answer: 'A entraîné la mort',
    explanation: 'Le cours : 227-16 = mort.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Élément moral (but)',
    question:
        'Pour 227-15, l’auteur doit nécessairement agir avec un but de nuire :',
    options: ['Non', 'Oui', 'Oui seulement si al.3'],
    answer: 'Non',
    explanation: 'Le cours indique : pas besoin de volonté de nuire.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Structure',
    question: 'La mort de la victime bascule vers :',
    options: ['227-16', '227-15 al.3', '227-17 al.2'],
    answer: '227-16',
    explanation: 'Le cours distingue clairement.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Aggravation al.3 nature',
    question: '227-15 al.3 reste classé :',
    options: ['Délit', 'Crime', 'Contravention'],
    answer: 'Délit',
    explanation: 'Le tableau du cours classe 227-15 al.3 comme délit aggravé.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Privation aliments/soins — Crime 227-16',
    question: '227-16 est classé :',
    options: ['Crime', 'Délit', 'Contravention'],
    answer: 'Crime',
    explanation: 'Le cours le classe crime.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Exemple voisins',
    question:
        'Dans l’exemple du cours, les voisins intervenaient notamment pour :',
    options: ['Donner à manger', 'Payer une amende', 'Éduquer juridiquement'],
    answer: 'Donner à manger',
    explanation:
        'Le cours indique “laissés à la charge des voisins qui leur donnaient à manger”.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — But de sollicitation',
    question: 'L’al.2 vise le maintien de l’enfant pour :',
    options: ['Solliciter la générosité des passants', 'Scolariser', 'Soigner'],
    answer: 'Solliciter la générosité des passants',
    explanation: 'C’est la condition textuelle.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Lien causal',
    question:
        'Pour 227-15, le texte exige que les privations aient effectivement causé une maladie :',
    options: ['Non', 'Oui', 'Oui uniquement si al.3'],
    answer: 'Non',
    explanation: 'Il suffit qu’elles soient susceptibles d’altérer la santé.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Non déclaration naissance',
    question:
        'Le délit de non déclaration d’une naissance à l’officier d’état civil est :',
    options: ['433-18-1', '227-23', '222-39'],
    answer: '433-18-1',
    explanation: 'Référence citée dans le cours à propos de l’aggravation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Responsabilité morale',
    question:
        'Le cours précise que les personnes morales encourent l’amende selon :',
    options: ['131-38 du CP', '227-22 du CP', 'R.623-2 du CP'],
    answer: '131-38 du CP',
    explanation: 'Référence explicite dans le cours.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Carence effective',
    question:
        'Le cours insiste que, même si le dommage n’est pas effectif, la carence doit être :',
    options: ['Effective', 'Fictive', 'Supposée sans preuve'],
    answer: 'Effective',
    explanation: 'Il faut une privation réelle (faits matériels).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Échelle “temps”',
    question: 'Le texte 227-15 fixe un délai minimum de privation (ex : 48h) :',
    options: ['Non', 'Oui', 'Oui pour mineur < 6'],
    answer: 'Non',
    explanation:
        'Le cours ne fixe pas de durée, il vise l’effet sur la santé (risque).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Délit aggravé vs crime',
    question: 'Le seul cas où le cours qualifie “crime” ici est :',
    options: ['227-16 (mort)', '227-15 al.3', '227-15 simple'],
    answer: '227-16 (mort)',
    explanation: 'Les autres restent des délits.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Corruption de mineur — Effet sur la victime',
    question: 'Il faut prouver que le mineur a effectivement été troublé :',
    options: ['Non', 'Oui', 'Oui seulement si mineur < 15'],
    answer: 'Non',
    explanation:
        'Le cours précise : pas nécessaire d’établir un trouble effectif ni un passage à l’acte.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Corruption de mineur — Élément moral',
    question: 'La corruption de mineur est :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Toujours involontaire'],
    answer: 'Intentionnelle',
    explanation:
        'Le cours : conscience de l’obscénité + âge + volonté de corrompre.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Diffusion de message — Condition mineur',
    question:
        'Pour 227-24, il faut qu’un mineur ait effectivement vu le message :',
    options: ['Non', 'Oui', 'Oui seulement si pornographique'],
    answer: 'Non',
    explanation:
        'Le cours : il suffit que le message soit susceptible d’être vu ou perçu par un mineur.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Diffusion de message — Circonstances aggravantes',
    question: '227-24 prévoit des circonstances aggravantes :',
    options: ['Non', 'Oui', 'Oui uniquement si mineur < 15'],
    answer: 'Non',
    explanation: 'Le cours indique : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation pédopornographie — Victime',
    question: 'La provocation vise des crimes/délits à l’encontre :',
    options: ['D’un mineur', 'D’un majeur', 'D’un fonctionnaire uniquement'],
    answer: 'D’un mineur',
    explanation:
        'Le cours : la victime des faits visés doit être un mineur (en l’absence de précision : < 18).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation pédopornographie — Élément moral',
    question: '227-28-3 est une infraction :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Contraventionnelle'],
    answer: 'Intentionnelle',
    explanation:
        'Le cours : volonté de faire commettre une infraction à autrui via offres/promesses.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation pédopornographie — Complicité',
    question: 'La complicité de 227-28-3 est :',
    options: ['Non', 'Oui', 'Oui seulement si bande organisée'],
    answer: 'Non',
    explanation: 'Le cours indique : complicité NON.',
    difficulty: 'Moyenne',
  ),

  // ---------- PROVOCATION DIRECTE D’UN MINEUR À COMMETTRE CRIME/DÉLIT — 227-21 (MOYENNE 35-44) ----------
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation mineur crime/délit — Effet',
    question: 'Il faut que la provocation ait été suivie d’effet :',
    options: ['Non', 'Oui', 'Oui seulement si mineur < 15'],
    answer: 'Non',
    explanation:
        'Le cours : peu importe qu’elle ait été suivie ou non d’effet.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation mineur crime/délit — Âge du provocateur',
    question: 'Le provocateur (227-21) doit être obligatoirement majeur :',
    options: ['Non', 'Oui', 'Oui seulement si mineur < 15'],
    answer: 'Non',
    explanation:
        'Le cours : rien n’est spécifié, provocation possible par majeur ou mineur.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation alcool — Notion',
    question:
        'Les “boissons alcooliques” visées comportent des traces d’alcool supérieures à :',
    options: ['1,2 degré', '0,2 degré', '5 degrés'],
    answer: '1,2 degré',
    explanation:
        'Le cours renvoie à l’article L.3321-1 du code de la santé publique (> 1,2°).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation alcool — Directe',
    question:
        'Une simple suggestion sans lien précis peut être une provocation directe :',
    options: ['Non', 'Oui', 'Oui si mineur < 15'],
    answer: 'Non',
    explanation: 'Le cours : relation précise et lien étroit nécessaires.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Provocation stupéfiants — Directe',
    question: 'La provocation en matière 227-18/227-18-1 doit être :',
    options: ['Directe', 'Indirecte uniquement', 'Purement publicitaire'],
    answer: 'Directe',
    explanation:
        'Le cours insiste : provocation directe avec lien précis et étroit.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Privation aliments/soins — Convictions',
    question:
        'Des convictions religieuses peuvent justifier des privations compromettant la santé :',
    options: ['Non', 'Oui', 'Oui si l’enfant est d’accord'],
    answer: 'Non',
    explanation:
        'Le cours : convictions religieuses / souci d’éducation ne justifient pas si conscience du risque sur la santé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Soustraction obligations — Dommage effectif',
    question: 'Il faut que la compromission soit irréversible et réalisée :',
    options: ['Non', 'Oui', 'Oui si mineur < 15'],
    answer: 'Non',
    explanation:
        'Le cours : pas requis que le dommage se soit réalisé; il suffit qu’il soit susceptible de se réaliser.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Soustraction obligations — Carence effective',
    question: 'Pour 227-17, la carence parentale doit être :',
    options: ['Effective', 'Supposée', 'Présumée par le seul divorce'],
    answer: 'Effective',
    explanation:
        'Le cours : la carence des parents doit être effective (Cass. crim., 11 juillet 1994).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Soustraction obligations — Preuve motif légitime',
    question: 'La preuve du motif légitime est à la charge :',
    options: ['Du prévenu', 'Du ministère public', 'De l’enfant'],
    answer: 'Du prévenu',
    explanation:
        'Le cours : c’est au prévenu d’apporter la preuve d’un motif grave.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Soustraction obligations — Appréciation motif',
    question: 'La légitimité du motif invoqué est appréciée :',
    options: ['Par le juge', 'Par la victime uniquement', 'Par l’école'],
    answer: 'Par le juge',
    explanation: 'Le cours : appréciation au cas par cas par le juge.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Soustraction obligations — Divorce',
    question:
        'L’introduction d’une demande en divorce est un motif légitime justifiant l’abandon :',
    options: ['Non', 'Oui', 'Oui si séparation officielle'],
    answer: 'Non',
    explanation:
        'Le cours : demande en divorce ≠ motif grave (Cass. crim., 30 mai 1967).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Soustraction obligations — Convictions religieuses',
    question:
        'Les convictions religieuses peuvent excuser la soustraction 227-17 :',
    options: ['Non', 'Oui', 'Oui si l’enfant accepte'],
    answer: 'Non',
    explanation:
        'Le cours : convictions religieuses ne sauraient excuser (Cass. crim., 11 juillet 1994).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Soustraction obligations — Élément moral',
    question: '227-17 est une infraction :',
    options: ['Intentionnelle', 'Involontaire', 'Contraventionnelle'],
    answer: 'Intentionnelle',
    explanation:
        'Le cours : conscience de se soustraire et du risque de conséquences dommageables.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Propositions sexuelles en ligne — Auteur',
    question: 'L’auteur des propositions sexuelles (227-22-1) doit être :',
    options: ['Majeur', 'Mineur', 'Indifférent'],
    answer: 'Majeur',
    explanation: 'Le cours : auteur = personne majeure.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Propositions sexuelles en ligne — Acte',
    question: 'Les propositions visées doivent être :',
    options: ['Sexuelles et explicites', 'Ambiguës uniquement', 'Politiques'],
    answer: 'Sexuelles et explicites',
    explanation: 'Le cours : propositions sexuelles explicites.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Propositions sexuelles en ligne — Croyance',
    question:
        'Il suffit que l’auteur ait cru être en présence d’un mineur de quinze ans :',
    options: ['Oui', 'Non', 'Oui seulement si rencontre'],
    answer: 'Oui',
    explanation:
        'Le cours : il suffit qu’il ait cru être en présence d’un mineur < 15.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pédopornographie — Simple nudité',
    question:
        'La simple nudité d’un mineur, sans attitude particulière, entre dans 227-23 :',
    options: ['Non', 'Oui', 'Oui si en public'],
    answer: 'Non',
    explanation: 'Le cours : simple nudité seule n’est pas visée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pédopornographie — Diffusion non publique',
    question: 'La diffusion doit être publique pour être incriminée :',
    options: ['Non', 'Oui', 'Oui sauf si mineur < 15'],
    answer: 'Non',
    explanation:
        'Le cours : diffusion incriminée même sans caractère public (ex : salon privé).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pédopornographie — Élément moral',
    question: 'L’exploitation d’images pédopornographiques (227-23) est :',
    options: ['Intentionnelle', 'Involontaire', 'Contraventionnelle'],
    answer: 'Intentionnelle',
    explanation:
        'Le cours : conscience du caractère contraire aux bonnes mœurs.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pédopornographie — Connaissance minorité',
    question: 'La connaissance de la minorité du sujet représenté est :',
    options: ['Présumée', 'Toujours impossible à prouver', 'Jamais présumée'],
    answer: 'Présumée',
    explanation:
        'Le cours : connaissance par le prévenu de la minorité est présumée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pédopornographie — Aggravation bande organisée',
    question: 'Une aggravation (227-23 al.5) existe en cas de :',
    options: ['Bande organisée', 'Mariage', 'Divorce'],
    answer: 'Bande organisée',
    explanation: 'Le cours : al.5 = bande organisée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Pédopornographie — Complicité',
    question: 'La complicité en matière 227-23 est :',
    options: ['Oui', 'Non', 'Oui uniquement en bande organisée'],
    answer: 'Oui',
    explanation: 'Le cours : complicité OUI (121-7).',
    difficulty: 'Difficile',
  ),

  // ---------- ATTEINTES SEXUELLES MAJEUR SUR MINEUR < 15 — 227-25 / 227-26 (DIFFICILE) ----------
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Atteinte sexuelle < 15 — Auteur',
    question: 'L’auteur visé par 227-25 doit être :',
    options: ['Majeur', 'Mineur', 'Indifférent'],
    answer: 'Majeur',
    explanation: 'Le cours : infraction imputable à un majeur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Défaut de notification — Fondement',
    question:
        'Le défaut de notification de changement de domicile au créancier est prévu par :',
    options: [
      'L’article 227-4-3 du Code pénal',
      'L’article 227-4-2 du Code pénal',
      'L’article 227-22 du Code pénal',
    ],
    answer: 'L’article 227-4-3 du Code pénal',
    explanation:
        'L’élément légal de l’infraction est fixé par l’article 227-4-3 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Fondement',
    question:
        'Le défaut de notification de changement de domicile au créancier est prévu par :',
    options: [
      'L’article 227-4-3 du Code pénal',
      'L’article 227-4-2 du Code pénal',
      'L’article 227-22 du Code pénal',
    ],
    answer: 'L’article 227-4-3 du Code pénal',
    explanation:
        'L’élément légal de l’infraction est fixé par l’article 227-4-3 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Fondement',
    question:
        'L’infraction vise une personne tenue de verser une contribution ou des subsides au titre :',
    options: [
      'D’une ordonnance de protection rendue en application de l’article 515-9 du code civil',
      'D’un jugement de divorce définitif uniquement',
      'D’une simple main courante',
    ],
    answer:
        'D’une ordonnance de protection rendue en application de l’article 515-9 du code civil',
    explanation:
        'Le texte vise la personne tenue de verser une contribution ou des subsides au titre de l’ordonnance de protection (art. 515-9 C. civ.).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Fondement',
    question:
        'Le débiteur doit notifier son changement de domicile au créancier dans un délai de :',
    options: [
      'Un mois à compter du changement',
      'Quinze jours à compter du changement',
      'Deux mois à compter du changement',
    ],
    answer: 'Un mois à compter du changement',
    explanation:
        'Le délai légal est d’un mois à compter du changement de domicile.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question:
        'Concernant la forme de la notification du changement de domicile, le texte :',
    options: [
      'Ne prévoit aucune exigence de forme',
      'Impose une lettre recommandée avec AR',
      'Impose une signification par commissaire de justice',
    ],
    answer: 'Ne prévoit aucune exigence de forme',
    explanation:
        'Aucune exigence n’est formulée quant à la forme de la notification : l’essentiel est d’informer dans le délai.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément moral',
    question:
        'Le défaut de notification de changement de domicile est une infraction :',
    options: [
      'Intentionnelle',
      'Non intentionnelle',
      'Contraventionnelle de police',
    ],
    answer: 'Intentionnelle',
    explanation:
        'L’élément moral repose sur la volonté de ne pas informer le créancier ; la simple négligence n’est pas punissable.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // DÉFAUT DE NOTIFICATION — PRÉCISIONS / MÉCANISME
  // =========================================================
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question:
        'L’infraction a été prévue notamment car le JAF peut se prononcer dans le référé protection sur :',
    options: [
      'La contribution aux charges du ménage',
      'La nationalité',
      'Le permis de conduire',
    ],
    answer: 'La contribution aux charges du ménage',
    explanation:
        'Le cours indique que le JAF peut statuer sur la contribution aux charges du ménage, d’où l’intérêt dissuasif de l’incrimination.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question:
        'Dans ce cadre, la personne visée par 227-4-3 est principalement :',
    options: [
      'Le débiteur d’une contribution ou de subsides',
      'Le créancier uniquement',
      'Le témoin des violences',
    ],
    answer: 'Le débiteur d’une contribution ou de subsides',
    explanation:
        'L’obligation de notifier pèse sur le débiteur tenu de verser la contribution/subsides.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément moral',
    question: 'Pourquoi la simple négligence n’est-elle pas punissable ici ?',
    options: [
      'Car la volonté coupable consiste à priver le titulaire de son droit par le silence',
      'Car l’infraction est toujours une contravention',
      'Car l’infraction n’existe que si le créancier est mineur',
    ],
    answer:
        'Car la volonté coupable consiste à priver le titulaire de son droit par le silence',
    explanation:
        'Le texte insiste sur l’intention : la volonté de priver le créancier de l’exercice de son droit.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Circonstances',
    question:
        'Concernant les circonstances aggravantes du défaut de notification (227-4-3), il y en a :',
    options: [
      'Aucune',
      'Une si récidive légale',
      'Une si le débiteur déménage à l’étranger',
    ],
    answer: 'Aucune',
    explanation:
        'Le cours mentionne : « Aucune » circonstance aggravante prévue.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // DÉFAUT DE NOTIFICATION — RÉPRESSION / PROCÉDURE
  // =========================================================
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question: 'La peine encourue (personne physique) pour 227-4-3 est :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation: 'La répression prévue est : 6 mois + 7 500 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question: 'La classification de l’infraction 227-4-3 est :',
    options: ['Un délit', 'Une contravention', 'Un crime'],
    answer: 'Un délit',
    explanation: 'Le cours précise : classification = délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'La tentative de l’infraction 227-4-3 est :',
    options: [
      'Non punissable (tentative : non)',
      'Punissable (tentative : oui)',
      'Punissable uniquement en cas de violences',
    ],
    answer: 'Non punissable (tentative : non)',
    explanation: 'Le document indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'La complicité pour 227-4-3 est :',
    options: [
      'Applicable (article 121-7 du Code pénal)',
      'Inapplicable',
      'Applicable uniquement si le créancier est un enfant',
    ],
    answer: 'Applicable (article 121-7 du Code pénal)',
    explanation:
        'La complicité est prévue selon l’article 121-7 du Code pénal.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Personnes morales',
    question:
        'Depuis quand la responsabilité des personnes morales est applicable de façon généralisée (référence cours) ?',
    options: [
      'Depuis le 31 décembre 2005',
      'Depuis le 1er janvier 1990',
      'Depuis le 1er juillet 2025',
    ],
    answer: 'Depuis le 31 décembre 2005',
    explanation:
        'Le support mentionne l’application en la matière depuis le 31 décembre 2005 (dans le cadre de la responsabilité des personnes morales).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NON-RESPECT DES OBLIGATIONS / INTERDICTIONS D’UNE ORDONNANCE DE PROTECTION — FONDEMENTS
  // =========================================================
  QuizQuestion(
    category: 'Violation ordonnance de protection — Fondement',
    question:
        'Le non-respect des obligations ou interdictions imposées par une ordonnance de protection est prévu par :',
    options: [
      'L’article 227-4-2 du Code pénal',
      'L’article 227-4-3 du Code pénal',
      'L’article 515-11 du code civil',
    ],
    answer: 'L’article 227-4-2 du Code pénal',
    explanation:
        'L’élément légal est fixé par l’article 227-4-2 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Champ',
    question:
        'L’infraction vise le non-respect d’obligations/interdictions imposées dans :',
    options: [
      'Une ordonnance de protection (art. 515-9 ou 515-13 C. civ.)',
      'Une simple médiation familiale',
      'Une audition libre',
    ],
    answer: 'Une ordonnance de protection (art. 515-9 ou 515-13 C. civ.)',
    explanation:
        'Le texte vise l’ordonnance de protection rendue notamment en application des articles 515-9 ou 515-13 du code civil.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Champ',
    question:
        'Sont aussi visées par 227-4-2 les obligations/interdictions imposées dans :',
    options: [
      'Une ordonnance provisoire de protection immédiate (art. 515-13-1 C. civ.)',
      'Un PV de renseignement judiciaire',
      'Une ordonnance de non-conciliation uniquement',
    ],
    answer:
        'Une ordonnance provisoire de protection immédiate (art. 515-13-1 C. civ.)',
    explanation:
        'Le texte vise aussi l’ordonnance provisoire de protection immédiate rendue sur le fondement de l’article 515-13-1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Champ UE',
    question:
        'Les mêmes peines s’appliquent à la violation d’une mesure de protection civile d’un autre État membre de l’UE reconnue en France via :',
    options: [
      'Le règlement (UE) n° 606/2013 du 12 juin 2013',
      'Le règlement (UE) n° 44/2001',
      'Le traité de Lisbonne',
    ],
    answer: 'Le règlement (UE) n° 606/2013 du 12 juin 2013',
    explanation:
        'Le support mentionne expressément le règlement (UE) 606/2013 relatif à la reconnaissance mutuelle des mesures de protection civiles.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE DE PROTECTION — CONDITIONS (515-9) / DÉLAIS
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Conditions',
    question:
        'Selon l’article 515-9 C. civ., l’ordonnance de protection peut être délivrée lorsque des violences au sein du couple :',
    options: [
      'Mettent en danger la victime ou un ou plusieurs enfants',
      'Sont uniquement anciennes de moins de 24h',
      'Ont déjà donné lieu à une condamnation définitive',
    ],
    answer: 'Mettent en danger la victime ou un ou plusieurs enfants',
    explanation:
        'La condition centrale : danger pour la victime (et/ou les enfants).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Conditions',
    question:
        'L’ordonnance de protection peut être délivrée même lorsqu’il n’y a pas de cohabitation :',
    options: [
      'Oui',
      'Non, la cohabitation est obligatoire',
      'Oui, mais seulement si les personnes sont mariées',
    ],
    answer: 'Oui',
    explanation:
        'Le texte vise les violences au sein du couple y compris sans cohabitation, et même sans cohabitation passée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Délai',
    question:
        'Le JAF délivre l’ordonnance de protection dans un délai maximal de :',
    options: [
      'Six jours à compter de la fixation de la date d’audience',
      'Vingt-quatre heures à compter de la saisine',
      'Un mois à compter de la requête',
    ],
    answer: 'Six jours à compter de la fixation de la date d’audience',
    explanation:
        'Le support indique : délai maximal de six jours (OP classique).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Plainte',
    question:
        'La délivrance d’une ordonnance de protection est-elle conditionnée à une plainte pénale ?',
    options: [
      'Non',
      'Oui',
      'Oui, uniquement en cas de violences psychologiques',
    ],
    answer: 'Non',
    explanation:
        'Le texte précise que l’ordonnance n’est pas conditionnée à l’existence d’une plainte pénale.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ORDONNANCE DE PROTECTION — MESURES POSSIBLES (515-11) : QCM
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Parmi les mesures possibles, le JAF peut interdire à la partie défenderesse :',
    options: [
      'De recevoir/rencontrer certaines personnes et d’entrer en relation avec elles',
      'D’exercer toute activité professionnelle',
      'De conduire un véhicule',
    ],
    answer:
        'De recevoir/rencontrer certaines personnes et d’entrer en relation avec elles',
    explanation: 'C’est la mesure 1° de l’article 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut interdire à la partie défenderesse de se rendre dans certains lieux fréquentés habituellement par la demanderesse :',
    options: [
      'Oui (1° bis)',
      'Non, jamais',
      'Oui, uniquement si un divorce est engagé',
    ],
    answer: 'Oui (1° bis)',
    explanation:
        'La mesure 1° bis prévoit l’interdiction de se rendre dans certains lieux.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question: 'Concernant les armes, le JAF peut notamment :',
    options: [
      'Interdire de détenir/porter une arme',
      'Imposer une peine de prison immédiate',
      'Prononcer une interdiction de vote',
    ],
    answer: 'Interdire de détenir/porter une arme',
    explanation: 'C’est la mesure 2° de l’article 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut ordonner à la partie défenderesse de remettre ses armes :',
    options: [
      'Au service de police ou de gendarmerie le plus proche du domicile',
      'À la mairie',
      'À l’employeur',
    ],
    answer: 'Au service de police ou de gendarmerie le plus proche du domicile',
    explanation:
        'Mesure 2° bis : remise au service de police/gendarmerie le plus proche.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut proposer une prise en charge sanitaire/sociale/psychologique ou un stage de responsabilisation :',
    options: [
      'Oui (2° ter)',
      'Non, c’est uniquement le rôle du procureur',
      'Oui, mais seulement pour la victime',
    ],
    answer: 'Oui (2° ter)',
    explanation:
        'Mesure 2° ter : proposition de prise en charge ou stage ; en cas de refus, information immédiate du procureur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Concernant le logement conjugal, sauf circonstances particulières, la jouissance est attribuée :',
    options: [
      'Au conjoint qui n’est pas l’auteur des violences',
      'Au conjoint qui a le plus de revenus',
      'Au conjoint le plus ancien dans le logement',
    ],
    answer: 'Au conjoint qui n’est pas l’auteur des violences',
    explanation:
        'Le principe : protection de la victime, attribution au non-auteur des violences.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut attribuer la jouissance de l’animal de compagnie détenu au sein du foyer :',
    options: ['Oui (3° bis)', 'Non', 'Oui, uniquement si l’animal est assuré'],
    answer: 'Oui (3° bis)',
    explanation:
        'L’article 515-11 prévoit la mesure 3° bis sur l’animal de compagnie.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Pour des partenaires PACS/concubins, la jouissance du logement commun est attribuée en principe :',
    options: [
      'Au partenaire/concubin qui n’est pas l’auteur des violences',
      'Au propriétaire du bail, quoi qu’il arrive',
      'Au partenaire le plus âgé',
    ],
    answer: 'Au partenaire/concubin qui n’est pas l’auteur des violences',
    explanation:
        'Le même principe protecteur est prévu au 4° pour PACS/concubins.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut se prononcer sur l’autorité parentale et aussi sur :',
    options: [
      'Le droit de visite/hébergement et les contributions (mariage/PACS/enfants)',
      'L’inscription à Pôle emploi',
      'Le retrait de permis',
    ],
    answer:
        'Le droit de visite/hébergement et les contributions (mariage/PACS/enfants)',
    explanation:
        'Mesure 5° : autorité parentale, DVH, et contributions selon la situation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut autoriser la demanderesse à dissimuler son domicile et élire domicile :',
    options: [
      'Chez l’avocat ou auprès du procureur de la République (pour les instances civiles)',
      'Uniquement au commissariat',
      'Uniquement chez un membre de la famille',
    ],
    answer:
        'Chez l’avocat ou auprès du procureur de la République (pour les instances civiles)',
    explanation:
        'Mesure 6° : dissimulation + élection de domicile chez avocat ou auprès du procureur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut aussi autoriser une élection de domicile « pour les besoins de la vie courante » :',
    options: [
      'Chez une personne morale qualifiée (6° bis)',
      'Uniquement chez le notaire',
      'Uniquement à la préfecture',
    ],
    answer: 'Chez une personne morale qualifiée (6° bis)',
    explanation:
        'Mesure 6° bis : élection de domicile vie courante auprès d’une personne morale qualifiée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut prononcer l’admission provisoire à l’aide juridictionnelle :',
    options: [
      'Oui (7°)',
      'Non, jamais',
      'Oui, mais seulement pour la partie défenderesse',
    ],
    answer: 'Oui (7°)',
    explanation: 'Mesure 7° : admission provisoire à l’aide juridictionnelle.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // DISPOSITIF ANTI-RAPPROCHEMENT (515-11-1) — QCM
  // =========================================================
  QuizQuestion(
    category: 'Dispositif anti-rapprochement — 515-11-1',
    question:
        'Si l’interdiction d’entrer en relation (1°) est prononcée, le JAF peut aussi :',
    options: [
      'Fixer une distance minimale et ordonner un dispositif anti-rapprochement',
      'Ordonner une détention provisoire automatique',
      'Prononcer une expulsion locative sans décision',
    ],
    answer:
        'Fixer une distance minimale et ordonner un dispositif anti-rapprochement',
    explanation:
        'L’article 515-11-1 permet l’interdiction de se rapprocher à moins d’une certaine distance + dispositif anti-rapprochement.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE (515-13) — MARIAGE FORCÉ / SORTIE DU TERRITOIRE
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Mariage forcé (515-13)',
    question:
        'L’article 515-13 permet une ordonnance de protection en urgence pour :',
    options: [
      'Une personne majeure menacée de mariage forcé',
      'Toute personne souhaitant changer de nom',
      'Un mineur voulant se marier',
    ],
    answer: 'Une personne majeure menacée de mariage forcé',
    explanation:
        'Le texte vise expressément la personne majeure menacée de mariage forcé.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mariage forcé (515-13)',
    question:
        'Dans ce cadre, le JAF peut ordonner à la demande de la personne :',
    options: [
      'Une interdiction temporaire de sortie du territoire',
      'Une interdiction définitive de quitter la ville',
      'Une saisie automatique du passeport par l’employeur',
    ],
    answer: 'Une interdiction temporaire de sortie du territoire',
    explanation:
        'L’article 515-13 mentionne l’interdiction temporaire de sortie du territoire.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mariage forcé (515-13)',
    question:
        'L’interdiction temporaire de sortie du territoire est inscrite au FPR par :',
    options: ['Le procureur de la République', 'Le maire', 'Le préfet'],
    answer: 'Le procureur de la République',
    explanation:
        'Le support précise l’inscription au FPR par le procureur de la République.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE PROVISOIRE DE PROTECTION IMMÉDIATE (515-13-1) — 24H
  // =========================================================
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question:
        'L’ordonnance provisoire de protection immédiate est délivrée dans un délai de :',
    options: [
      '24 heures à compter de la saisine',
      '6 jours à compter de la fixation d’audience',
      '15 jours à compter de l’enquête',
    ],
    answer: '24 heures à compter de la saisine',
    explanation:
        'Le texte indique : délivrée dans un délai de vingt-quatre heures.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question:
        'Qui peut demander, avec l’accord de la personne en danger, une OPPI en plus de la demande d’OP ?',
    options: ['Le ministère public', 'Le greffe', 'La mairie'],
    answer: 'Le ministère public',
    explanation:
        'L’article 515-13-1 prévoit la demande par le ministère public avec l’accord de la personne en danger.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'Pour délivrer l’OPPI, le JAF statue :',
    options: [
      'Au vu des seuls éléments joints à la requête',
      'Après une enquête de flagrance obligatoire',
      'Uniquement après audition de 3 témoins',
    ],
    answer: 'Au vu des seuls éléments joints à la requête',
    explanation:
        'L’OPPI est délivrée sur la base des éléments joints à la requête (sans débat contradictoire complet).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // VIOLATION ORDONNANCE DE PROTECTION — ÉLÉMENT MATÉRIEL / MORAL
  // =========================================================
  QuizQuestion(
    category: 'Violation ordonnance de protection — Élément matériel',
    question: 'L’élément matériel de 227-4-2 consiste à :',
    options: [
      'Ne pas se conformer aux obligations/interdictions imposées',
      'Ne pas payer une amende forfaitaire',
      'Refuser une audition libre',
    ],
    answer: 'Ne pas se conformer aux obligations/interdictions imposées',
    explanation:
        'La violation est le non-respect des obligations/interdictions fixées par l’ordonnance.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Élément moral',
    question: 'L’infraction 227-4-2 est :',
    options: [
      'Intentionnelle',
      'Non intentionnelle',
      'Une simple faute civile',
    ],
    answer: 'Intentionnelle',
    explanation:
        'Le support précise une infraction intentionnelle : l’auteur agit en connaissance de cause des obligations/interdictions.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Élément moral',
    question: 'Pour caractériser l’élément moral, l’auteur doit notamment :',
    options: [
      'Avoir été informé des termes de l’ordonnance',
      'Avoir changé de travail',
      'Avoir contesté la procédure au civil',
    ],
    answer: 'Avoir été informé des termes de l’ordonnance',
    explanation:
        'La connaissance des obligations/interdictions suppose que l’auteur ait été informé de l’ordonnance.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Finalité',
    question: 'Le texte 227-4-2 vise à rendre l’ordonnance de protection :',
    options: [
      'Pleinement effective et contraignante',
      'Optionnelle',
      'Uniquement symbolique',
    ],
    answer: 'Pleinement effective et contraignante',
    explanation:
        'Le cours insiste sur l’effectivité : sanctionner pénalement la violation pour rendre la mesure réellement protectrice.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // VIOLATION ORDONNANCE DE PROTECTION — RÉPRESSION / PROCÉDURE
  // =========================================================
  QuizQuestion(
    category: 'Violation ordonnance de protection — Répression',
    question: 'La peine encourue (personne physique) pour 227-4-2 est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '10 ans de réclusion et 150 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'La répression prévue par 227-4-2 est de 3 ans et 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Classification',
    question: 'La classification de l’infraction 227-4-2 est :',
    options: ['Un délit', 'Un crime', 'Une contravention'],
    answer: 'Un délit',
    explanation: 'Le cours précise : délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Circonstances',
    question:
        'Concernant les circonstances aggravantes de 227-4-2 (cours), il y en a :',
    options: ['Aucune', 'Deux', 'Uniquement la récidive'],
    answer: 'Aucune',
    explanation: 'Le support indique : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Tentative / complicité',
    question: 'La tentative de 227-4-2 est :',
    options: [
      'Non punissable (tentative : non)',
      'Punissable (tentative : oui)',
      'Toujours punissable en correctionnelle',
    ],
    answer: 'Non punissable (tentative : non)',
    explanation: 'Le document précise : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Tentative / complicité',
    question: 'La complicité pour 227-4-2 est :',
    options: [
      'Oui (article 121-7 du Code pénal)',
      'Non, jamais',
      'Oui, uniquement si l’auteur est mineur',
    ],
    answer: 'Oui (article 121-7 du Code pénal)',
    explanation:
        'La complicité est applicable conformément à l’article 121-7 du Code pénal.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // QUESTIONS MIXTES (COMPARAISONS 227-4-2 / 227-4-3)
  // =========================================================
  QuizQuestion(
    category: 'Comparatif — 227-4-2 vs 227-4-3',
    question:
        'Quelle infraction est la plus lourdement sanctionnée (peine d’emprisonnement) ?',
    options: ['227-4-2 (3 ans)', '227-4-3 (6 mois)', 'Elles sont identiques'],
    answer: '227-4-2 (3 ans)',
    explanation: '227-4-2 prévoit 3 ans, tandis que 227-4-3 prévoit 6 mois.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — 227-4-2 vs 227-4-3',
    question:
        'Quelle infraction concerne spécifiquement le changement de domicile du débiteur ?',
    options: ['227-4-3', '227-4-2', '515-11'],
    answer: '227-4-3',
    explanation:
        '227-4-3 incrimine le défaut de notification du changement de domicile au créancier.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — Élément moral',
    question: 'Point commun entre 227-4-2 et 227-4-3 :',
    options: [
      'Ce sont des infractions intentionnelles',
      'Ce sont des contraventions',
      'Elles exigent une plainte pénale préalable',
    ],
    answer: 'Ce sont des infractions intentionnelles',
    explanation:
        'Les deux supposent une volonté : ne pas se conformer / ne pas informer.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Comparatif — Tentative',
    question: 'Concernant la tentative, 227-4-2 et 227-4-3 :',
    options: [
      'Ne prévoient pas la tentative (tentative : non)',
      'Prévoient toutes deux la tentative',
      'Prévoient la tentative seulement en cas de récidive',
    ],
    answer: 'Ne prévoient pas la tentative (tentative : non)',
    explanation:
        'Le support indique “TENTATIVE : NON” pour les deux infractions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Comparatif — Complicité',
    question: 'Concernant la complicité (121-7 CP), pour 227-4-2 et 227-4-3 :',
    options: [
      'Elle est applicable pour les deux',
      'Elle est exclue pour les deux',
      'Elle n’est applicable que pour 227-4-3',
    ],
    answer: 'Elle est applicable pour les deux',
    explanation:
        'Les deux supports indiquent “COMPLICITÉ : OUI” + référence à l’article 121-7 CP.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // QUESTIONS "PIÈGES" / PRÉCISION DE TEXTE (PLUS DIFFICILES)
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Durée',
    question:
        'Les mesures de l’ordonnance de protection peuvent être prises pour une durée maximale de :',
    options: [
      '12 mois (prolongeable sous conditions)',
      '6 mois non prolongeable',
      '24 mois automatiquement',
    ],
    answer: '12 mois (prolongeable sous conditions)',
    explanation:
        'Le support mentionne une durée maximale de 12 mois, prolongeable sous certaines conditions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Logement',
    question:
        'Sauf circonstances particulières, la jouissance du logement est attribuée :',
    options: [
      'À la personne non auteure des violences',
      'À la personne ayant l’autorité parentale exclusive',
      'Toujours au titulaire du bail',
    ],
    answer: 'À la personne non auteure des violences',
    explanation:
        'Principe protecteur : attribution au non-auteur (sauf ordonnance motivée/circonstances particulières).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Domicile dissimulé',
    question:
        'Si un commissaire de justice doit connaître l’adresse réelle pour exécuter une décision :',
    options: [
      'L’adresse lui est communiquée, mais il ne peut pas la révéler à son mandant',
      'L’adresse ne peut jamais être communiquée à personne',
      'L’adresse est rendue publique au dossier',
    ],
    answer:
        'L’adresse lui est communiquée, mais il ne peut pas la révéler à son mandant',
    explanation:
        'Le support précise la communication nécessaire pour l’exécution, avec interdiction de révélation au mandant.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Information autorités',
    question:
        'Quand les mesures 6°/6° bis sont prononcées, qui peut être informé (avec accord de la personne) pour éviter la communication de l’adresse ?',
    options: [
      'Le maire et le représentant de l’État dans le département',
      'Uniquement le préfet de police de Paris',
      'Uniquement le bâtonnier',
    ],
    answer: 'Le maire et le représentant de l’État dans le département',
    explanation:
        'Le support indique l’information du maire et du représentant de l’État dans le département, sous réserve de l’accord de la personne.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Fin des mesures',
    question: 'Les mesures de l’OPPI prennent fin :',
    options: [
      'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
      'Uniquement au bout de 12 mois',
      'Quand la victime le décide seule',
    ],
    answer:
        'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
    explanation:
        'Le support précise la fin des mesures à compter de la décision sur la demande d’OP ou incident mettant fin à l’instance.',
    difficulty: 'Difficile',
  ),
  // =========================================================
  // PACK ENORME #3 — DÉFAUT DE NOTIFICATION (227-4-3) + VIOLATION OP (227-4-2)
  // + OP / OPPI (515-9 à 515-13-1) + MESURES (515-11 / 515-11-1)
  // =========================================================

  // -----------------------------
  // 227-4-3 — ÉLÉMENT LÉGAL / CHAMP
  // -----------------------------
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question:
        'Le défaut de notification de changement de domicile au créancier est réprimé par :',
    options: [
      'L’article 227-4-3 du Code pénal',
      'L’article 227-4-2 du Code pénal',
      'L’article 515-11 du code civil',
    ],
    answer: 'L’article 227-4-3 du Code pénal',
    explanation: 'L’élément légal est prévu à l’article 227-4-3 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question: 'L’infraction 227-4-3 concerne une personne tenue de verser :',
    options: [
      'Une contribution ou des subsides au titre d’une ordonnance de protection',
      'Une amende forfaitaire délictuelle',
      'Une caution pénale',
    ],
    answer:
        'Une contribution ou des subsides au titre d’une ordonnance de protection',
    explanation:
        'Le texte vise la personne tenue de verser une contribution/subsides au titre de l’ordonnance de protection.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question:
        'Le délai légal pour notifier son changement de domicile au créancier est :',
    options: [
      'Un mois à compter du changement',
      'Quinze jours à compter du changement',
      'Trois mois à compter du changement',
    ],
    answer: 'Un mois à compter du changement',
    explanation: 'Le support fixe un délai d’un mois.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question: 'La notification du changement de domicile au créancier :',
    options: [
      'N’est soumise à aucune exigence de forme',
      'Doit être faite par LRAR',
      'Doit être faite par commissaire de justice',
    ],
    answer: 'N’est soumise à aucune exigence de forme',
    explanation: 'Le texte précise qu’aucune forme n’est exigée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question:
        'L’ordonnance de protection visée pour 227-4-3 est rendue en application de :',
    options: [
      'L’article 515-9 du code civil',
      'L’article 515-4 du code civil',
      'L’article 227-22 du Code pénal',
    ],
    answer: 'L’article 515-9 du code civil',
    explanation:
        'Le support vise expressément l’ordonnance de protection rendue selon 515-9.',
    difficulty: 'Moyenne',
  ),

  // -----------------------------
  // 227-4-3 — ÉLÉMENT MATÉRIEL / LOGIQUE DISUASIVE
  // -----------------------------
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question:
        'L’incrimination 227-4-3 a été prévue notamment car le JAF peut statuer, en référé protection, sur :',
    options: [
      'La contribution aux charges du ménage',
      'La délivrance d’un titre de séjour',
      'La liquidation d’une succession',
    ],
    answer: 'La contribution aux charges du ménage',
    explanation:
        'Le support justifie l’infraction par la nécessité dissuasive liée aux contributions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question: 'L’acte matériel réprimé par 227-4-3 est :',
    options: [
      'Ne pas notifier son changement de domicile au créancier dans le délai légal',
      'Ne pas se présenter à une convocation de police',
      'Ne pas payer une pension dans le mois',
    ],
    answer:
        'Ne pas notifier son changement de domicile au créancier dans le délai légal',
    explanation:
        'Le cœur de l’infraction est l’absence de notification dans le délai d’un mois.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question: 'Le délai d’un mois court :',
    options: [
      'À compter du changement de domicile',
      'À compter de la signification par huissier',
      'À compter de la plainte pénale',
    ],
    answer: 'À compter du changement de domicile',
    explanation: 'Le texte indique : “à compter de ce changement”.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question: 'Le texte précise que la notification doit être faite :',
    options: [
      'Au créancier',
      'Au juge aux affaires familiales uniquement',
      'Au procureur de la République uniquement',
    ],
    answer: 'Au créancier',
    explanation: 'L’obligation est d’informer le créancier.',
    difficulty: 'Facile',
  ),

  // -----------------------------
  // 227-4-3 — ÉLÉMENT MORAL
  // -----------------------------
  QuizQuestion(
    category: 'Défaut de notification — Élément moral',
    question:
        'Le défaut de notification de changement de domicile (227-4-3) est une infraction :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Contraventionnelle'],
    answer: 'Intentionnelle',
    explanation:
        'Le support indique une volonté de ne pas informer le créancier.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément moral',
    question: 'La simple négligence est punissable pour 227-4-3 :',
    options: ['Non', 'Oui', 'Oui si le créancier le demande'],
    answer: 'Non',
    explanation:
        'Le support précise que la simple négligence n’est pas punissable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément moral',
    question: 'La volonté coupable, pour 227-4-3, consiste à :',
    options: [
      'Vouloir, par son silence, priver le créancier de l’exercice d’un droit',
      'Oublier sans s’en rendre compte',
      'Changer d’adresse trop souvent',
    ],
    answer:
        'Vouloir, par son silence, priver le créancier de l’exercice d’un droit',
    explanation:
        'Le support décrit la finalité du silence : priver le titulaire du droit.',
    difficulty: 'Difficile',
  ),

  // -----------------------------
  // 227-4-3 — RÉPRESSION / TENTATIVE / COMPLICITÉ
  // -----------------------------
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question: 'La peine encourue pour 227-4-3 (personne physique) est :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation: 'Le support fixe : 6 mois + 7 500 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question: 'La classification de 227-4-3 est :',
    options: ['Délit', 'Contravention', 'Crime'],
    answer: 'Délit',
    explanation: 'Le tableau répressif indique : délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'Pour 227-4-3, la tentative est :',
    options: ['Non', 'Oui', 'Oui si plusieurs déménagements'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'Pour 227-4-3, la complicité est :',
    options: [
      'Oui (article 121-7 CP)',
      'Non (jamais)',
      'Oui seulement si le complice est un proche',
    ],
    answer: 'Oui (article 121-7 CP)',
    explanation: 'Le support indique : COMPLICITÉ : OUI, article 121-7 CP.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Circonstances aggravantes',
    question: 'Pour 227-4-3, les circonstances aggravantes prévues sont :',
    options: ['Aucune', 'Deux', 'Une en cas d’enfant mineur'],
    answer: 'Aucune',
    explanation: 'Le support mentionne : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // 227-4-2 — NON-RESPECT DES OBLIGATIONS / INTERDICTIONS (OP / OPPI)
  // =========================================================

  // -----------------------------
  // 227-4-2 — ÉLÉMENT LÉGAL / CHAMP
  // -----------------------------
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question:
        'Le non-respect des obligations ou interdictions imposées par une ordonnance de protection est réprimé par :',
    options: [
      'L’article 227-4-2 du Code pénal',
      'L’article 227-4-3 du Code pénal',
      'L’article 515-9 du code civil',
    ],
    answer: 'L’article 227-4-2 du Code pénal',
    explanation: 'L’élément légal est prévu à l’article 227-4-2 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question:
        'Le texte vise une personne faisant l’objet d’une ou plusieurs obligations/interdictions imposées dans :',
    options: [
      'Une ordonnance de protection (515-9 ou 515-13) ou une OPPI (515-13-1)',
      'Un jugement pénal définitif uniquement',
      'Une main courante',
    ],
    answer:
        'Une ordonnance de protection (515-9 ou 515-13) ou une OPPI (515-13-1)',
    explanation: 'Le support vise OP (515-9/515-13) + OPPI (515-13-1).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question:
        'Les mêmes peines s’appliquent aussi à la violation d’une mesure civile ordonnée dans un autre État membre de l’UE si elle est :',
    options: [
      'Reconnue et exécutoire en France',
      'Simplement traduite en français',
      'Uniquement connue de la victime',
    ],
    answer: 'Reconnue et exécutoire en France',
    explanation:
        'Le support exige reconnaissance + force exécutoire en France.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question: 'Le texte UE cité dans le support est :',
    options: [
      'Le règlement (UE) n° 606/2013 du 12 juin 2013',
      'Le règlement (UE) n° 2016/679',
      'Le règlement (CE) n° 44/2001',
    ],
    answer: 'Le règlement (UE) n° 606/2013 du 12 juin 2013',
    explanation: 'Le support cite explicitement le règlement 606/2013.',
    difficulty: 'Difficile',
  ),

  // -----------------------------
  // 227-4-2 — ÉLÉMENT MATÉRIEL
  // -----------------------------
  QuizQuestion(
    category: 'Violation OP — Élément matériel',
    question: 'L’élément matériel de 227-4-2 consiste à :',
    options: [
      'Ne pas se conformer à une ou plusieurs obligations/interdictions imposées',
      'Ne pas notifier un changement de domicile au créancier',
      'Ne pas déposer plainte',
    ],
    answer:
        'Ne pas se conformer à une ou plusieurs obligations/interdictions imposées',
    explanation:
        'Le texte incrimine la violation des obligations/interdictions.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — Élément matériel',
    question: 'La finalité du texte 227-4-2 est de :',
    options: [
      'Donner pleine effectivité à l’ordonnance de protection',
      'Remplacer le juge pénal',
      'Créer une contravention éducative',
    ],
    answer: 'Donner pleine effectivité à l’ordonnance de protection',
    explanation:
        'Le support insiste sur l’effectivité de l’OP en sanctionnant la violation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Élément matériel',
    question: 'L’ordonnance de protection a pour vocation de fournir :',
    options: [
      'Un cadre protecteur aux victimes de violences',
      'Un avantage fiscal aux couples',
      'Un statut administratif de séjour',
    ],
    answer: 'Un cadre protecteur aux victimes de violences',
    explanation: 'Le support présente l’OP comme un cadre protecteur.',
    difficulty: 'Facile',
  ),

  // -----------------------------
  // 227-4-2 — ÉLÉMENT MORAL
  // -----------------------------
  QuizQuestion(
    category: 'Violation OP — Élément moral',
    question: 'L’infraction 227-4-2 est une infraction :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Purement civile'],
    answer: 'Intentionnelle',
    explanation:
        'Le support indique que l’auteur agit en pleine connaissance de cause.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — Élément moral',
    question:
        'Pour que l’élément moral soit caractérisé, l’auteur doit notamment :',
    options: [
      'Avoir été informé des termes de l’ordonnance',
      'Avoir déjà été condamné',
      'Avoir déménagé',
    ],
    answer: 'Avoir été informé des termes de l’ordonnance',
    explanation:
        'Le support précise : l’auteur doit avoir été informé des termes.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Élément moral',
    question:
        'La connaissance par l’auteur des obligations/interdictions implique :',
    options: [
      'Qu’il sache précisément ce qui lui est interdit ou imposé',
      'Qu’il ignore le contenu mais accepte “en général”',
      'Qu’il ait seulement entendu une rumeur',
    ],
    answer: 'Qu’il sache précisément ce qui lui est interdit ou imposé',
    explanation:
        'Infraction intentionnelle : connaissance de cause des obligations/interdictions.',
    difficulty: 'Difficile',
  ),

  // -----------------------------
  // 227-4-2 — RÉPRESSION / TENTATIVE / COMPLICITÉ
  // -----------------------------
  QuizQuestion(
    category: 'Violation OP — Répression',
    question: 'La peine encourue pour 227-4-2 (personne physique) est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le support fixe : 3 ans + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — Répression',
    question: 'La classification de 227-4-2 est :',
    options: ['Délit', 'Contravention', 'Crime'],
    answer: 'Délit',
    explanation: 'Le tableau répressif indique : délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — Tentative / complicité',
    question: 'Pour 227-4-2, la tentative est :',
    options: ['Non', 'Oui', 'Oui si la victime est mineure'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Tentative / complicité',
    question: 'Pour 227-4-2, la complicité est :',
    options: [
      'Oui (article 121-7 CP)',
      'Non',
      'Oui uniquement si le complice est un professionnel',
    ],
    answer: 'Oui (article 121-7 CP)',
    explanation: 'Le support mentionne l’article 121-7 CP.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Circonstances aggravantes',
    question:
        'Pour 227-4-2, le support prévoit des circonstances aggravantes :',
    options: [
      'Aucune',
      'Une circonstance liée au domicile',
      'Deux circonstances liées aux armes',
    ],
    answer: 'Aucune',
    explanation: 'IV – circonstances aggravantes : aucune.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // OP (515-9) — CONDITIONS / PRINCIPES (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'Selon 515-9, l’ordonnance de protection peut être délivrée lorsque les violences :',
    options: [
      'Mettent en danger la victime ou un ou plusieurs enfants',
      'Sont uniquement physiques',
      'Ont déjà fait l’objet d’un jugement pénal',
    ],
    answer: 'Mettent en danger la victime ou un ou plusieurs enfants',
    explanation:
        'Le critère central est le danger pour la victime (et/ou les enfants).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question: '515-9 vise aussi les violences commises par :',
    options: [
      'Un ancien conjoint, ancien partenaire PACS ou ancien concubin',
      'Uniquement un conjoint actuel',
      'Uniquement un parent',
    ],
    answer: 'Un ancien conjoint, ancien partenaire PACS ou ancien concubin',
    explanation: 'Le support inclut les “anciens” liens.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question: 'L’ordonnance de protection peut être délivrée même si :',
    options: [
      'Il n’y a pas de cohabitation',
      'Les parties vivent ensemble obligatoirement',
      'Les parties sont divorcées depuis moins de 6 jours',
    ],
    answer: 'Il n’y a pas de cohabitation',
    explanation: 'Le texte vise les situations sans cohabitation.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'Le juge délivre l’ordonnance de protection si, au vu des éléments, il existe :',
    options: [
      'Des raisons sérieuses de considérer vraisemblables les violences alléguées et le danger',
      'Une preuve absolue et définitive',
      'Une plainte pénale obligatoire',
    ],
    answer:
        'Des raisons sérieuses de considérer vraisemblables les violences alléguées et le danger',
    explanation:
        'Le support utilise la formule “raisons sérieuses” + “vraisemblables”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'La délivrance de l’ordonnance de protection est conditionnée à une plainte pénale :',
    options: ['Non', 'Oui', 'Oui uniquement si absence de cohabitation'],
    answer: 'Non',
    explanation:
        'Le support précise : pas conditionnée à l’existence d’une plainte pénale.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'Le délai maximal de délivrance (OP) indiqué dans le support est :',
    options: [
      'Six jours à compter de la fixation de la date d’audience',
      'Vingt-quatre heures à compter de la saisine',
      'Quinze jours à compter de la plainte',
    ],
    answer: 'Six jours à compter de la fixation de la date d’audience',
    explanation: 'Le support indique un délai maximal de six jours.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // OP — 515-12 : DURÉE MAX (selon support)
  // =========================================================
  QuizQuestion(
    category: 'OP — Durée',
    question:
        'Selon le support, les mesures sont prises pour une durée maximale de :',
    options: [
      '12 mois (prolongeable sous certaines conditions)',
      '6 mois (non prolongeable)',
      '24 mois (automatique)',
    ],
    answer: '12 mois (prolongeable sous certaines conditions)',
    explanation:
        'Le support mentionne : durée maximale de 12 mois (prolongeable sous conditions).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 515-11 — MESURES : QCM “CHOISIS LA BONNE MESURE” (EN SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Interdire de recevoir ou rencontrer certaines personnes et d’entrer en relation avec elles » correspond à :',
    options: ['1°', '1° bis', '2°'],
    answer: '1°',
    explanation: 'Mesure 1° de 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Interdire de se rendre dans certains lieux fréquentés habituellement par la demanderesse » correspond à :',
    options: ['1° bis', '1°', '6°'],
    answer: '1° bis',
    explanation: 'Mesure 1° bis de 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question: '« Interdire de détenir ou porter une arme » correspond à :',
    options: ['2°', '2° bis', '2° ter'],
    answer: '2°',
    explanation: 'Mesure 2° de 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Ordonner la remise des armes au service de police/gendarmerie » correspond à :',
    options: ['2° bis', '2°', '7°'],
    answer: '2° bis',
    explanation: 'Mesure 2° bis de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Proposer une prise en charge sanitaire/sociale/psychologique ou un stage » correspond à :',
    options: ['2° ter', '3°', '5°'],
    answer: '2° ter',
    explanation: 'Mesure 2° ter de 515-11.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Statuer sur la résidence séparée des époux et la jouissance du logement conjugal » correspond à :',
    options: ['3°', '4°', '6°'],
    answer: '3°',
    explanation: 'Mesure 3° de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Attribuer la jouissance de l’animal de compagnie du foyer » correspond à :',
    options: ['3° bis', '4°', '5°'],
    answer: '3° bis',
    explanation: 'Mesure 3° bis de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Se prononcer sur le logement commun des partenaires PACS/concubins » correspond à :',
    options: ['4°', '3°', '6° bis'],
    answer: '4°',
    explanation: 'Mesure 4° de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Modalités d’exercice de l’autorité parentale et droit de visite/hébergement » correspond à :',
    options: ['5°', '6°', '7°'],
    answer: '5°',
    explanation: 'Mesure 5° de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Dissimuler son domicile et élire domicile chez l’avocat ou auprès du procureur » correspond à :',
    options: ['6°', '6° bis', '7°'],
    answer: '6°',
    explanation: 'Mesure 6° de 515-11.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Élire domicile pour la vie courante chez une personne morale qualifiée » correspond à :',
    options: ['6° bis', '6°', '1°'],
    answer: '6° bis',
    explanation: 'Mesure 6° bis de 515-11.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Admission provisoire à l’aide juridictionnelle » correspond à :',
    options: ['7°', '5°', '2°'],
    answer: '7°',
    explanation: 'Mesure 7° de 515-11.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 515-11-1 — DISTANCE + DISPOSITIF ANTI-RAPPROCHEMENT
  // =========================================================
  QuizQuestion(
    category: 'Anti-rapprochement — 515-11-1',
    question:
        'Si l’interdiction prévue au 1° de 515-11 est prononcée, le juge peut :',
    options: [
      'Interdire de se rapprocher à moins d’une certaine distance qu’il fixe',
      'Interdire tout déplacement en France',
      'Obliger à déménager immédiatement',
    ],
    answer:
        'Interdire de se rapprocher à moins d’une certaine distance qu’il fixe',
    explanation: 'Le support prévoit la fixation d’une distance minimale.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Anti-rapprochement — 515-11-1',
    question: 'Le dispositif anti-rapprochement est destiné à :',
    options: [
      'Signaler le non-respect de la distance fixée',
      'Mesurer la vitesse de conduite',
      'Vérifier le paiement des pensions',
    ],
    answer: 'Signaler le non-respect de la distance fixée',
    explanation:
        'Le texte indique qu’il permet de signaler le non-respect de la distance.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 515-13 — MARIAGE FORCÉ / FIN DES MESURES
  // =========================================================
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        'Une ordonnance de protection peut être délivrée en urgence à la personne majeure :',
    options: [
      'Menacée de mariage forcé',
      'Menacée de licenciement',
      'Menacée d’expulsion locative',
    ],
    answer: 'Menacée de mariage forcé',
    explanation:
        'Le support vise la personne majeure menacée de mariage forcé.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        'Dans ce cadre, le juge peut ordonner l’interdiction temporaire de sortie du territoire :',
    options: [
      'À la demande de la personne menacée',
      'Automatiquement dans tous les cas',
      'Uniquement à la demande du maire',
    ],
    answer: 'À la demande de la personne menacée',
    explanation: 'Le support précise : “à sa demande”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question: 'Les mesures prises sur 515-13 prennent fin :',
    options: [
      'À compter de la décision statuant sur la demande d’ordonnance de protection (ou incident mettant fin à l’instance)',
      'Au bout de 12 mois automatiquement',
      'À la fin de l’enquête de police',
    ],
    answer:
        'À compter de la décision statuant sur la demande d’ordonnance de protection (ou incident mettant fin à l’instance)',
    explanation: 'Le support indique cette règle de fin des mesures.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 515-13-1 — OPPI : SAISINE / DÉLAI / CONDITIONS / MESURES
  // =========================================================
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'L’OPPI est demandée par :',
    options: [
      'Le ministère public, avec l’accord de la personne en danger',
      'Le maire, sans accord de la victime',
      'Le commissariat, sans juge',
    ],
    answer: 'Le ministère public, avec l’accord de la personne en danger',
    explanation:
        'Le support précise : ministère public + accord de la personne en danger.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'L’OPPI est délivrée dans un délai de :',
    options: [
      '24 heures à compter de la saisine',
      '6 jours à compter de la fixation de l’audience',
      '48 heures à compter de la plainte',
    ],
    answer: '24 heures à compter de la saisine',
    explanation: 'Le support mentionne : délai de vingt-quatre heures.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'Pour délivrer l’OPPI, le juge se fonde sur :',
    options: [
      'Les seuls éléments joints à la requête',
      'Une expertise psychiatrique obligatoire',
      'Un débat contradictoire obligatoire avec les deux parties présentes',
    ],
    answer: 'Les seuls éléments joints à la requête',
    explanation:
        'Le support indique : “au vu des seuls éléments joints à la requête”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'L’OPPI exige la vraisemblance :',
    options: [
      'Des violences alléguées et du danger grave et immédiat',
      'D’un conflit financier uniquement',
      'D’une infraction routière',
    ],
    answer: 'Des violences alléguées et du danger grave et immédiat',
    explanation: 'Le support vise “danger grave et immédiat”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — Mesures',
    question: 'Dans l’OPPI, le juge peut prononcer à titre provisoire :',
    options: [
      'Les mesures 1° à 2° bis de 515-11',
      'La totalité des mesures 1° à 7° sans limite',
      'Uniquement l’aide juridictionnelle',
    ],
    answer: 'Les mesures 1° à 2° bis de 515-11',
    explanation: 'Le support énumère ces mesures dans l’OPPI.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — Mesures',
    question: 'Dans l’OPPI, le juge peut aussi ordonner :',
    options: [
      'La suspension du droit de visite et d’hébergement (mentionné au 5°)',
      'La déchéance automatique de l’autorité parentale',
      'Une interdiction définitive de sortie du territoire',
    ],
    answer:
        'La suspension du droit de visite et d’hébergement (mentionné au 5°)',
    explanation: 'Le support mentionne explicitement la suspension du DVH.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — Mesures',
    question:
        'Dans l’OPPI, la dissimulation du domicile/résidence est possible selon :',
    options: [
      'Les 6° et 6° bis de 515-11',
      'Une simple demande au commissariat',
      'Une déclaration sur l’honneur sans décision',
    ],
    answer: 'Les 6° et 6° bis de 515-11',
    explanation: 'Le support renvoie aux 6° et 6° bis.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — Fin des mesures',
    question: 'Les mesures de l’OPPI prennent fin :',
    options: [
      'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
      'Après 24 heures automatiquement',
      'Au bout de 6 jours automatiquement',
    ],
    answer:
        'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
    explanation: 'Le support fixe cette règle de fin des mesures.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // QUESTIONS COMPARATIVES (TRÈS UTILES EN QUIZ)
  // =========================================================
  QuizQuestion(
    category: 'Comparatif — 227-4-2 / 227-4-3',
    question:
        'Quelle infraction vise spécifiquement le changement de domicile du débiteur ?',
    options: ['227-4-3', '227-4-2', '515-11-1'],
    answer: '227-4-3',
    explanation:
        '227-4-3 = défaut de notification de changement de domicile au créancier.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — 227-4-2 / 227-4-3',
    question:
        'Quelle infraction vise le non-respect d’obligations/interdictions imposées par une OP/OPPI ?',
    options: ['227-4-2', '227-4-3', '515-12'],
    answer: '227-4-2',
    explanation: '227-4-2 = violation des obligations/interdictions OP/OPPI.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — Peines',
    question:
        'Quelle infraction est la plus lourdement sanctionnée (emprisonnement) ?',
    options: ['227-4-2 (3 ans)', '227-4-3 (6 mois)', 'Elles sont identiques'],
    answer: '227-4-2 (3 ans)',
    explanation: '227-4-2 : 3 ans ; 227-4-3 : 6 mois.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — Élément moral',
    question: 'Point commun entre 227-4-2 et 227-4-3 selon le support :',
    options: [
      'Ce sont des infractions intentionnelles',
      'Ce sont des contraventions',
      'Elles nécessitent une plainte pénale',
    ],
    answer: 'Ce sont des infractions intentionnelles',
    explanation: 'Le support précise l’intention pour les deux infractions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Comparatif — Tentative',
    question:
        'Concernant la tentative, le support indique que pour 227-4-2 et 227-4-3 :',
    options: [
      'La tentative n’est pas prévue (tentative : non)',
      'La tentative est toujours punissable',
      'La tentative dépend d’un délai',
    ],
    answer: 'La tentative n’est pas prévue (tentative : non)',
    explanation: 'Le support indique “TENTATIVE : NON” pour les deux.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // CAS PRATIQUES (QCM) — GROS RENDU MÉMOIRE
  // =========================================================
  QuizQuestion(
    category: 'Cas pratique — 227-4-2',
    question:
        'Une ordonnance de protection interdit à la défenderesse d’entrer en relation avec la demanderesse. Elle envoie un message via un tiers. La qualification la plus adaptée est :',
    options: [
      'Violation des obligations/interdictions de l’ordonnance (227-4-2)',
      'Défaut de notification de changement de domicile (227-4-3)',
      'Aucune infraction car ce n’est pas un contact direct',
    ],
    answer: 'Violation des obligations/interdictions de l’ordonnance (227-4-2)',
    explanation:
        'Le support souligne que l’interdiction peut viser toute forme de relation/contournement.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — 227-4-3',
    question:
        'Un débiteur soumis à une ordonnance de protection déménage, attend volontairement 35 jours et n’informe pas le créancier. La qualification la plus adaptée est :',
    options: [
      'Défaut de notification de changement de domicile au créancier (227-4-3)',
      'Violation des obligations/interdictions de l’ordonnance (227-4-2)',
      'Aucune car aucune forme n’est imposée',
    ],
    answer:
        'Défaut de notification de changement de domicile au créancier (227-4-3)',
    explanation: 'Délai d’un mois dépassé + intention : 227-4-3.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — 515-11-1',
    question:
        'Après une interdiction d’entrer en relation (1°), le juge fixe une distance minimale et ordonne un dispositif anti-rapprochement. Le fondement cité dans le support est :',
    options: [
      '515-11-1 du code civil',
      '227-4-2 du Code pénal',
      '227-4-3 du Code pénal',
    ],
    answer: '515-11-1 du code civil',
    explanation: 'Le support rattache distance + dispositif à 515-11-1.',
    difficulty: 'Difficile',
  ),
  // =========================================================
  // PACK ENORME #4 — 515-11 / 515-11-1 / 515-13 / 515-13-1 + 227-4-2 + 227-4-3
  // (sans fermeture de liste, prêt à coller)
  // =========================================================

  // =========================================================
  // 515-11 — MESURES : QCM “QUE PEUT FAIRE LE JAF ?” (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'Le JAF peut, dans une ordonnance de protection, interdire à la partie défenderesse :',
    options: [
      'D’entrer en relation avec certaines personnes désignées',
      'De travailler dans la fonction publique',
      'De quitter son emploi',
    ],
    answer: 'D’entrer en relation avec certaines personnes désignées',
    explanation:
        'Mesure 1° : interdiction de rencontrer/entrer en relation avec certaines personnes.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'La mesure qui permet d’interdire à la partie défenderesse de se rendre dans certains lieux est :',
    options: ['1° bis', '2°', '7°'],
    answer: '1° bis',
    explanation:
        'Mesure 1° bis : lieux spécialement désignés où la demanderesse se trouve habituellement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'Le juge peut interdire à la partie défenderesse de détenir ou porter une arme au titre :',
    options: [
      'Du 2° de l’article 515-11',
      'Du 6° de l’article 515-11',
      'Du 1° bis de l’article 515-11',
    ],
    answer: 'Du 2° de l’article 515-11',
    explanation: 'Mesure 2° : interdiction de détenir/porter une arme.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'La remise des armes au service de police ou de gendarmerie le plus proche relève :',
    options: [
      'Du 2° bis de l’article 515-11',
      'Du 2° ter de l’article 515-11',
      'Du 5° de l’article 515-11',
    ],
    answer: 'Du 2° bis de l’article 515-11',
    explanation: 'Mesure 2° bis : remise au service de police/gendarmerie.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'Une “prise en charge sanitaire, sociale ou psychologique” ou un “stage de responsabilisation” relève :',
    options: [
      'Du 2° ter de l’article 515-11',
      'Du 3° bis de l’article 515-11',
      'Du 7° de l’article 515-11',
    ],
    answer: 'Du 2° ter de l’article 515-11',
    explanation: 'Mesure 2° ter : proposition de prise en charge/stage.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question: 'En cas de refus de la prise en charge/stage (2° ter), le juge :',
    options: [
      'En avise immédiatement le procureur de la République',
      'Classe automatiquement la procédure',
      'Ne peut rien faire',
    ],
    answer: 'En avise immédiatement le procureur de la République',
    explanation:
        'Le support prévoit l’information immédiate du procureur en cas de refus.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'La mesure qui permet au juge de statuer sur la résidence séparée des époux est :',
    options: ['3°', '4°', '6° bis'],
    answer: '3°',
    explanation: 'Mesure 3° : résidence séparée + logement conjugal.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'Sauf circonstances particulières, la jouissance du logement conjugal est attribuée :',
    options: [
      'Au conjoint qui n’est pas l’auteur des violences',
      'Au conjoint propriétaire du logement',
      'Au conjoint ayant l’autorité parentale',
    ],
    answer: 'Au conjoint qui n’est pas l’auteur des violences',
    explanation: 'Principe de protection de la victime dans le support.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'Le juge peut attribuer à la demanderesse la jouissance de l’animal de compagnie au titre :',
    options: [
      'Du 3° bis de l’article 515-11',
      'Du 6° de l’article 515-11',
      'Du 1° de l’article 515-11',
    ],
    answer: 'Du 3° bis de l’article 515-11',
    explanation: 'Mesure 3° bis : animal de compagnie.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'Pour des partenaires PACS ou concubins, la jouissance du logement commun est en principe attribuée :',
    options: [
      'Au partenaire/concubin qui n’est pas l’auteur des violences',
      'Toujours au titulaire du bail',
      'Toujours au partenaire ayant le plus de revenus',
    ],
    answer: 'Au partenaire/concubin qui n’est pas l’auteur des violences',
    explanation: 'Mesure 4° : même logique protectrice que pour les époux.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'La mesure relative à l’autorité parentale et au droit de visite/hébergement est :',
    options: ['5°', '7°', '2°'],
    answer: '5°',
    explanation: 'Mesure 5° : autorité parentale + DVH + contributions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'La dissimulation du domicile/résidence et l’élection de domicile chez l’avocat ou le procureur relève :',
    options: ['Du 6°', 'Du 6° bis', 'Du 1° bis'],
    answer: 'Du 6°',
    explanation:
        'Mesure 6° : dissimulation + élection de domicile (avocat/parquet).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'L’élection de domicile “pour les besoins de la vie courante” chez une personne morale qualifiée relève :',
    options: ['Du 6° bis', 'Du 7°', 'Du 2° bis'],
    answer: 'Du 6° bis',
    explanation:
        'Mesure 6° bis : vie courante chez une personne morale qualifiée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question: 'L’admission provisoire à l’aide juridictionnelle relève :',
    options: ['Du 7°', 'Du 3° bis', 'Du 1°'],
    answer: 'Du 7°',
    explanation: 'Mesure 7° : admission provisoire à l’aide juridictionnelle.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 515-11-1 — DISTANCE + DISPOSITIF ANTI-RAPPROCHEMENT (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Anti-rapprochement — 515-11-1',
    question:
        'La possibilité d’interdire de se rapprocher à moins d’une certaine distance est prévue par :',
    options: [
      'L’article 515-11-1 du code civil',
      'L’article 227-4-2 du Code pénal',
      'L’article 515-12 du code civil',
    ],
    answer: 'L’article 515-11-1 du code civil',
    explanation: 'Le support rattache distance + dispositif à 515-11-1.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Anti-rapprochement — 515-11-1',
    question:
        'Le juge peut ordonner le port d’un dispositif anti-rapprochement lorsque :',
    options: [
      'L’interdiction prévue au 1° de 515-11 a été prononcée',
      'Une plainte pénale a été déposée',
      'Les parties ont des enfants',
    ],
    answer: 'L’interdiction prévue au 1° de 515-11 a été prononcée',
    explanation:
        'Le support indique : “Lorsque l’interdiction prévue au 1° a été prononcée…”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Anti-rapprochement — 515-11-1',
    question: 'Le dispositif anti-rapprochement sert principalement à :',
    options: [
      'Signaler que la partie défenderesse ne respecte pas la distance fixée',
      'Contrôler les dépenses du ménage',
      'Mesurer le temps de présence au domicile',
    ],
    answer:
        'Signaler que la partie défenderesse ne respecte pas la distance fixée',
    explanation: 'Finalité : signalement du non-respect de la distance.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 515-13 — ORDONNANCE POUR MENACE DE MARIAGE FORCÉ (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        'L’article 515-13 permet une ordonnance de protection en urgence pour :',
    options: [
      'Une personne majeure menacée de mariage forcé',
      'Une personne mineure menacée de fugue',
      'Un couple en procédure de divorce',
    ],
    answer: 'Une personne majeure menacée de mariage forcé',
    explanation:
        'Le support vise explicitement la personne majeure menacée de mariage forcé.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        'Le juge peut ordonner, à la demande de la personne menacée, une :',
    options: [
      'Interdiction temporaire de sortie du territoire',
      'Interdiction définitive de quitter l’UE',
      'Interdiction de travailler',
    ],
    answer: 'Interdiction temporaire de sortie du territoire',
    explanation:
        'Le support mentionne l’interdiction temporaire de sortie du territoire.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        'L’interdiction temporaire de sortie du territoire est inscrite au FPR par :',
    options: ['Le procureur de la République', 'Le préfet', 'Le maire'],
    answer: 'Le procureur de la République',
    explanation: 'Le support indique l’inscription au FPR par le procureur.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 515-13-1 — OPPI : DEMANDE / CONDITIONS / FIN (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'L’OPPI est demandée par le ministère public :',
    options: [
      'Avec l’accord de la personne en danger',
      'Sans accord de la personne en danger',
      'Uniquement sur instruction de la mairie',
    ],
    answer: 'Avec l’accord de la personne en danger',
    explanation: 'Le support exige l’accord de la personne en danger.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'Le juge délivre l’OPPI s’il estime vraisemblables :',
    options: [
      'Les violences alléguées et le danger grave et immédiat',
      'Le conflit conjugal sans danger',
      'Une difficulté financière',
    ],
    answer: 'Les violences alléguées et le danger grave et immédiat',
    explanation: 'Le support insiste sur “danger grave et immédiat”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'Le délai de délivrance de l’OPPI est :',
    options: [
      '24 heures à compter de la saisine',
      '6 jours à compter de la fixation de l’audience',
      '1 mois à compter du dépôt de plainte',
    ],
    answer: '24 heures à compter de la saisine',
    explanation: 'Le support précise : dans les 24 heures.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question:
        'Dans l’OPPI, le juge peut prononcer provisoirement les mesures :',
    options: [
      '1° à 2° bis de 515-11',
      '1° à 7° de 515-11',
      'Uniquement 7° (AJ)',
    ],
    answer: '1° à 2° bis de 515-11',
    explanation: 'Le support limite explicitement aux 1° à 2° bis.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'Le support indique que les mesures de l’OPPI prennent fin :',
    options: [
      'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
      'Au bout de 24 heures automatiquement',
      'Au bout de 12 mois automatiquement',
    ],
    answer:
        'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
    explanation:
        'Le support décrit précisément cette règle de fin des mesures.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 227-4-2 — VIOLATION OP/OPPI : ÉLÉMENTS / PEINES (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question: 'La violation d’une ordonnance de protection consiste à :',
    options: [
      'Ne pas se conformer aux obligations/interdictions imposées',
      'Ne pas notifier un changement d’adresse au créancier',
      'Ne pas se présenter au tribunal',
    ],
    answer: 'Ne pas se conformer aux obligations/interdictions imposées',
    explanation:
        'Élément matériel : non-respect des obligations/interdictions imposées.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question: 'L’élément moral de 227-4-2 repose sur :',
    options: [
      'La volonté de ne pas se conformer (connaissance de cause)',
      'Une simple négligence',
      'Une erreur de bonne foi toujours excusable',
    ],
    answer: 'La volonté de ne pas se conformer (connaissance de cause)',
    explanation: 'Le support précise : infraction intentionnelle.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Répression',
    question:
        'La peine principale (personne physique) prévue par 227-4-2 est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le support fixe 3 ans + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — Tentative / complicité',
    question: 'Pour 227-4-2, la complicité est :',
    options: [
      'Applicable (article 121-7 CP)',
      'Inapplicable',
      'Applicable uniquement en cas de violences physiques',
    ],
    answer: 'Applicable (article 121-7 CP)',
    explanation: 'Le support indique : COMPLICITÉ : OUI (121-7 CP).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Tentative / complicité',
    question: 'Pour 227-4-2, la tentative est :',
    options: ['Non', 'Oui', 'Oui si la distance n’est pas respectée'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 227-4-3 — DÉFAUT DE NOTIFICATION : ÉLÉMENTS / PEINES (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question: 'L’élément moral de 227-4-3 repose sur :',
    options: [
      'La volonté de ne pas informer le créancier du changement de domicile',
      'La simple distraction',
      'Un conflit conjugal ancien',
    ],
    answer:
        'La volonté de ne pas informer le créancier du changement de domicile',
    explanation:
        'Le support précise : infraction intentionnelle, négligence non punissable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question:
        'La peine principale (personne physique) prévue par 227-4-3 est :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation: 'Le support fixe 6 mois + 7 500 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'Pour 227-4-3, la complicité est :',
    options: [
      'Applicable (article 121-7 CP)',
      'Inapplicable',
      'Applicable uniquement si le créancier est un enfant',
    ],
    answer: 'Applicable (article 121-7 CP)',
    explanation: 'Le support indique : COMPLICITÉ : OUI (121-7 CP).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'Pour 227-4-3, la tentative est :',
    options: ['Non', 'Oui', 'Oui si le débiteur a déménagé deux fois'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // CAS PRATIQUES — MIX 515 / 227 (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Cas pratique — Mix',
    question:
        'Une OP interdit à la défenderesse de se rendre dans un lieu désigné (1° bis). Elle y va volontairement. Infraction la plus adaptée :',
    options: [
      'Violation de l’ordonnance de protection (227-4-2)',
      'Défaut de notification de domicile (227-4-3)',
      'Aucune infraction, c’est civil',
    ],
    answer: 'Violation de l’ordonnance de protection (227-4-2)',
    explanation:
        'Le non-respect d’une interdiction imposée par l’OP est sanctionné par 227-4-2.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — Mix',
    question:
        'Une OP prévoit remise des armes (2° bis). La défenderesse refuse et conserve une arme. Infraction la plus adaptée :',
    options: [
      'Violation de l’ordonnance de protection (227-4-2)',
      'Défaut de notification de domicile (227-4-3)',
      'Aucune, car l’ordonnance n’est pas pénale',
    ],
    answer: 'Violation de l’ordonnance de protection (227-4-2)',
    explanation:
        'La violation des obligations imposées (dont remise des armes) relève de 227-4-2.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Cas pratique — Mix',
    question:
        'Un débiteur soumis à une OP déménage et décide de ne pas informer le créancier pour éviter l’exécution des paiements. Infraction la plus adaptée :',
    options: [
      'Défaut de notification de changement de domicile (227-4-3)',
      'Violation de l’ordonnance (227-4-2)',
      'Aucune, car il peut déménager librement',
    ],
    answer: 'Défaut de notification de changement de domicile (227-4-3)',
    explanation:
        'Le cœur de 227-4-3 est l’absence volontaire d’information du créancier dans le délai.',
    difficulty: 'Moyenne',
  ),
  // =========================================================
  // PACK ENORME #5 — (full QCM) 515-9 / 515-11 / 515-11-1 / 515-13 / 515-13-1
  // + 227-4-2 + 227-4-3 (sans fermeture de liste, prêt à coller)
  // =========================================================

  // =========================================================
  // 515-9 — CONDITIONS / CHAMP (SÉRIES D’ANCRAGE MÉMOIRE)
  // =========================================================
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'L’ordonnance de protection peut être délivrée lorsque les violences exercées :',
    options: [
      'Mettent en danger la victime ou un ou plusieurs enfants',
      'Sont uniquement des violences physiques',
      'Ont forcément lieu au domicile conjugal',
    ],
    answer: 'Mettent en danger la victime ou un ou plusieurs enfants',
    explanation:
        'Le support vise le danger pour la victime (et/ou les enfants).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question: 'Le champ de 515-9 inclut les violences exercées :',
    options: [
      'Par un ancien conjoint/ancien partenaire PACS/ancien concubin',
      'Uniquement par un époux actuel',
      'Uniquement par une personne vivant au domicile',
    ],
    answer: 'Par un ancien conjoint/ancien partenaire PACS/ancien concubin',
    explanation: 'Le support cite expressément les “anciens” liens.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question: 'L’ordonnance de protection peut être délivrée même lorsque :',
    options: [
      'Il n’y a pas de cohabitation',
      'Les parties sont mariées uniquement',
      'Une plainte pénale a été déposée',
    ],
    answer: 'Il n’y a pas de cohabitation',
    explanation:
        'Le support mentionne l’absence de cohabitation (même jamais).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'Le juge délivre l’ordonnance s’il existe des raisons sérieuses de considérer vraisemblables :',
    options: [
      'Les violences alléguées et le danger',
      'Une infraction routière',
      'Une dette impayée',
    ],
    answer: 'Les violences alléguées et le danger',
    explanation:
        'Formule du support : raisons sérieuses + vraisemblance + danger.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'La délivrance d’une ordonnance de protection est conditionnée à une plainte pénale :',
    options: ['Non', 'Oui, toujours', 'Oui seulement en cas d’enfants'],
    answer: 'Non',
    explanation:
        'Le support précise que la plainte pénale n’est pas une condition.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'Le délai maximal de délivrance de l’ordonnance de protection indiqué par le support est :',
    options: ['Six jours', 'Vingt-quatre heures', 'Un mois'],
    answer: 'Six jours',
    explanation: 'Le support indique un délai maximal de six jours.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 515-11 — MESURES : QCM “CHOISIS LA MESURE QUI CORRESPOND” (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « interdire à la défenderesse de recevoir ou rencontrer certaines personnes et d’entrer en relation avec elles » ?',
    options: ['1°', '1° bis', '2°'],
    answer: '1°',
    explanation: 'Le support liste cette mesure au 1° de 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « interdire à la défenderesse de se rendre dans certains lieux spécialement désignés » ?',
    options: ['1° bis', '2° bis', '7°'],
    answer: '1° bis',
    explanation: 'Le support liste cette mesure au 1° bis de 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « interdire de détenir ou de porter une arme » ?',
    options: ['2°', '2° bis', '6°'],
    answer: '2°',
    explanation: 'Le support liste cette mesure au 2° de 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « ordonner de remettre les armes au service de police ou de gendarmerie le plus proche » ?',
    options: ['2° bis', '2° ter', '5°'],
    answer: '2° bis',
    explanation: 'Le support liste cette mesure au 2° bis de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « proposer une prise en charge sanitaire, sociale ou psychologique ou un stage de responsabilisation » ?',
    options: ['2° ter', '3°', '3° bis'],
    answer: '2° ter',
    explanation: 'Le support liste cette mesure au 2° ter de 515-11.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « statuer sur la résidence séparée des époux et le logement conjugal » ?',
    options: ['3°', '4°', '6° bis'],
    answer: '3°',
    explanation: 'Le support liste cette mesure au 3° de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « attribuer la jouissance de l’animal de compagnie du foyer » ?',
    options: ['3° bis', '1°', '7°'],
    answer: '3° bis',
    explanation: 'Le support liste cette mesure au 3° bis de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « se prononcer sur le logement commun de partenaires PACS ou concubins » ?',
    options: ['4°', '5°', '6°'],
    answer: '4°',
    explanation: 'Le support liste cette mesure au 4° de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « se prononcer sur l’autorité parentale et le droit de visite/hébergement » ?',
    options: ['5°', '6°', '2°'],
    answer: '5°',
    explanation: 'Le support liste cette mesure au 5° de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « autoriser à dissimuler son domicile et à élire domicile chez l’avocat ou auprès du procureur » ?',
    options: ['6°', '6° bis', '7°'],
    answer: '6°',
    explanation: 'Le support liste cette mesure au 6° de 515-11.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « élire domicile pour les besoins de la vie courante chez une personne morale qualifiée » ?',
    options: ['6° bis', '6°', '1° bis'],
    answer: '6° bis',
    explanation: 'Le support liste cette mesure au 6° bis de 515-11.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « admission provisoire à l’aide juridictionnelle » ?',
    options: ['7°', '2° bis', '3° bis'],
    answer: '7°',
    explanation: 'Le support liste cette mesure au 7° de 515-11.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 515-11 — QUESTIONS “DÉTAILS DE RÉDACTION” (TRÈS BON POUR DÉPISTAGE)
  // =========================================================
  QuizQuestion(
    category: 'Mesures OP — 515-11 (détails)',
    question:
        'Le support précise que la jouissance du logement (époux) est attribuée au non-auteur des violences :',
    options: [
      'Sauf ordonnance spécialement motivée justifiée par des circonstances particulières',
      'Uniquement si la victime est propriétaire',
      'Uniquement si une plainte existe',
    ],
    answer:
        'Sauf ordonnance spécialement motivée justifiée par des circonstances particulières',
    explanation:
        'Le support indique ce principe avec l’exception (ordonnance motivée).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (détails)',
    question:
        'Le support indique que la jouissance du logement peut être attribuée à la victime :',
    options: [
      'Même si elle a bénéficié d’un hébergement d’urgence',
      'Uniquement si elle n’a jamais quitté le logement',
      'Uniquement si elle paie le loyer',
    ],
    answer: 'Même si elle a bénéficié d’un hébergement d’urgence',
    explanation:
        'Le support précise “et ce même s’il a bénéficié d’un hébergement d’urgence”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (détails)',
    question: 'La mesure 1° interdit d’entrer en relation :',
    options: [
      'De quelque façon que ce soit',
      'Uniquement par téléphone',
      'Uniquement par messages écrits',
    ],
    answer: 'De quelque façon que ce soit',
    explanation:
        'Le support contient la formule “de quelque façon que ce soit”.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 515-11-1 — “SI… ALORS…” (EXCELLENTS POUR LA MÉMOIRE)
  // =========================================================
  QuizQuestion(
    category: 'Anti-rapprochement — 515-11-1',
    question: 'Si l’interdiction de contact (1°) est prononcée, le juge peut :',
    options: [
      'Fixer une distance minimale de rapprochement',
      'Fixer une distance uniquement si l’auteur est condamné',
      'Fixer une distance uniquement en cas de récidive',
    ],
    answer: 'Fixer une distance minimale de rapprochement',
    explanation: 'Le support prévoit la distance fixée par le juge.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Anti-rapprochement — 515-11-1',
    question:
        'Le support indique que le port du dispositif anti-rapprochement concerne :',
    options: [
      'Chacune des deux parties',
      'Uniquement la partie défenderesse',
      'Uniquement la partie demanderesse',
    ],
    answer: 'Chacune des deux parties',
    explanation: 'Le support mentionne le port “par chacune des deux parties”.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 515-13 — MENACE DE MARIAGE FORCÉ : MESURES / FIN (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        '515-13 prévoit que le juge est compétent pour prendre les mesures mentionnées notamment aux :',
    options: [
      '1°, 2°, 2° bis, 6° et 7° de 515-11',
      '3°, 3° bis, 4° et 5° de 515-11 uniquement',
      'Toutes les mesures 1° à 7° sans restriction',
    ],
    answer: '1°, 2°, 2° bis, 6° et 7° de 515-11',
    explanation:
        'Le support indique cette compétence spécifique (liste restreinte) pour 515-13.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        'En cas de menace de mariage forcé, le juge peut aussi ordonner :',
    options: [
      'L’interdiction temporaire de sortie du territoire (à la demande)',
      'Une interdiction définitive de sortie du territoire (automatique)',
      'Une confiscation des biens (automatique)',
    ],
    answer: 'L’interdiction temporaire de sortie du territoire (à la demande)',
    explanation: 'Le support mentionne l’ITST temporaire “à sa demande”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question: 'La fin des mesures (515-13) intervient :',
    options: [
      'À compter de la décision statuant sur la demande d’OP ou incident mettant fin à l’instance',
      'Au bout de 6 jours',
      'Au bout de 24 heures',
    ],
    answer:
        'À compter de la décision statuant sur la demande d’OP ou incident mettant fin à l’instance',
    explanation: 'Le support indique cette règle de fin des mesures.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 515-13-1 — OPPI : MESURES PRÉCISES (SÉRIES “LISTE”)
  // =========================================================
  QuizQuestion(
    category: 'OPPI — 515-13-1 (mesures)',
    question: 'Dans l’OPPI, le juge peut prononcer provisoirement :',
    options: [
      'Les mesures 1° à 2° bis de 515-11',
      'Les mesures 3° à 7° uniquement',
      'Uniquement 6° et 6° bis',
    ],
    answer: 'Les mesures 1° à 2° bis de 515-11',
    explanation: 'Le support mentionne explicitement 1° à 2° bis.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1 (mesures)',
    question:
        'Le support précise que dans l’OPPI, le juge peut aussi prononcer :',
    options: [
      'La suspension du droit de visite et d’hébergement (mentionné au 5°)',
      'La déchéance automatique de l’autorité parentale',
      'Une ITST automatique',
    ],
    answer:
        'La suspension du droit de visite et d’hébergement (mentionné au 5°)',
    explanation: 'Le support cite la suspension du DVH.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1 (mesures)',
    question:
        'La dissimulation du domicile/résidence dans l’OPPI se fait selon :',
    options: [
      'Les 6° et 6° bis de 515-11',
      'Le 7° de 515-11 uniquement',
      'Le 3° de 515-11 uniquement',
    ],
    answer: 'Les 6° et 6° bis de 515-11',
    explanation: 'Le support renvoie aux 6° et 6° bis.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 227-4-2 / 227-4-3 — QUESTIONS “CHIFFRES” (PEINES / DÉLAIS) ULTRA RENTABLES
  // =========================================================
  QuizQuestion(
    category: 'Chiffres — 227-4-2',
    question: 'Le quantum d’emprisonnement prévu par 227-4-2 est de :',
    options: ['3 ans', '6 mois', '1 an'],
    answer: '3 ans',
    explanation: 'Le support indique : 3 ans d’emprisonnement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Chiffres — 227-4-2',
    question: 'Le montant de l’amende prévu par 227-4-2 est de :',
    options: ['45 000 €', '7 500 €', '15 000 €'],
    answer: '45 000 €',
    explanation: 'Le support indique : 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Chiffres — 227-4-3',
    question: 'Le quantum d’emprisonnement prévu par 227-4-3 est de :',
    options: ['6 mois', '3 ans', '2 ans'],
    answer: '6 mois',
    explanation: 'Le support indique : 6 mois d’emprisonnement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Chiffres — 227-4-3',
    question: 'Le montant de l’amende prévu par 227-4-3 est de :',
    options: ['7 500 €', '45 000 €', '30 000 €'],
    answer: '7 500 €',
    explanation: 'Le support indique : 7 500 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Chiffres — 227-4-3',
    question: 'Le délai de notification (227-4-3) est de :',
    options: ['1 mois', '6 jours', '24 heures'],
    answer: '1 mois',
    explanation: 'Le support fixe un délai d’un mois.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // CAS PRATIQUES — “BON ARTICLE” (TRÈS EFFICACE POUR EXAMENS)
  // =========================================================
  QuizQuestion(
    category: 'Cas pratique — Bon article',
    question:
        'Une personne visée par une OP ne respecte pas l’interdiction de se rendre dans un lieu désigné (1° bis). Quel article du Code pénal réprime ce non-respect ?',
    options: ['227-4-2', '227-4-3', '515-9'],
    answer: '227-4-2',
    explanation:
        'Le non-respect des obligations/interdictions de l’OP relève de 227-4-2.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — Bon article',
    question:
        'Un débiteur tenu de verser une contribution au titre d’une OP déménage et ne prévient pas le créancier dans le délai. Quel article réprime ce comportement ?',
    options: ['227-4-3', '227-4-2', '515-11-1'],
    answer: '227-4-3',
    explanation:
        'Le défaut de notification de changement de domicile au créancier relève de 227-4-3.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — Bon article',
    question:
        'Le juge fixe une distance minimale et ordonne un dispositif anti-rapprochement. Quel article du code civil est cité dans le support ?',
    options: ['515-11-1', '515-12', '515-4'],
    answer: '515-11-1',
    explanation: 'Distance + dispositif anti-rapprochement : 515-11-1.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question:
        'L’infraction de défaut de notification de changement de domicile au créancier est :',
    options: ['Un délit', 'Une contravention', 'Un crime'],
    answer: 'Un délit',
    explanation: 'Le support classe 227-4-3 comme un délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question:
        'Le délai pour notifier le changement de domicile au créancier est de :',
    options: ['1 mois', '8 jours', '3 mois'],
    answer: '1 mois',
    explanation: 'Le texte prévoit un délai d’un mois à compter du changement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question:
        'Le défaut de notification de changement de domicile au créancier suppose :',
    options: [
      'Une volonté de ne pas informer le créancier',
      'Un simple oubli suffit',
      'Une récidive obligatoire',
    ],
    answer: 'Une volonté de ne pas informer le créancier',
    explanation:
        'C’est une infraction intentionnelle : la simple négligence n’est pas punissable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question:
        'La notification du changement de domicile au créancier doit obligatoirement être faite :',
    options: [
      'Selon une forme libre',
      'Par lettre recommandée avec AR uniquement',
      'Par acte de commissaire de justice uniquement',
    ],
    answer: 'Selon une forme libre',
    explanation: 'Aucune exigence de forme n’est imposée par le texte.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question: 'Le défaut de notification de changement de domicile concerne :',
    options: [
      'Une personne tenue de verser une contribution ou des subsides',
      'Toute personne sous contrôle judiciaire',
      'Toute personne condamnée à une amende',
    ],
    answer: 'Une personne tenue de verser une contribution ou des subsides',
    explanation:
        'Le texte vise le débiteur tenu de verser une contribution/subsides au titre de l’ordonnance de protection.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question:
        'La peine principale encourue (personne physique) pour 227-4-3 est :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation: 'Répression prévue : 6 mois + 7 500 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'Pour 227-4-3, la tentative est :',
    options: ['Non', 'Oui', 'Oui uniquement en cas de récidive'],
    answer: 'Non',
    explanation: 'Le document indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'Pour 227-4-3, la complicité est :',
    options: [
      'Oui (article 121-7 CP)',
      'Non',
      'Oui uniquement si l’auteur est marié',
    ],
    answer: 'Oui (article 121-7 CP)',
    explanation:
        'La complicité est applicable conformément à l’article 121-7 du Code pénal.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Circonstances aggravantes',
    question: 'Pour 227-4-3, les circonstances aggravantes sont :',
    options: [
      'Aucune',
      'Une circonstance liée à la récidive',
      'Deux circonstances liées à la durée',
    ],
    answer: 'Aucune',
    explanation: 'Le support indique : Aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Intention',
    question: 'La volonté coupable (élément moral) de 227-4-3 consiste à :',
    options: [
      'Vouloir, par son silence, priver le créancier de l’exercice de son droit',
      'Oublier involontairement de déclarer une adresse',
      'Changer de domicile plus d’une fois',
    ],
    answer:
        'Vouloir, par son silence, priver le créancier de l’exercice de son droit',
    explanation:
        'Le cours précise que la volonté coupable est de priver le titulaire du droit.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE DE PROTECTION — 515-9 : CONTEXTE / CONDITIONS
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — 515-9',
    question:
        'L’ordonnance de protection peut être délivrée lorsque les violences sont exercées :',
    options: [
      'Au sein du couple ou par un ancien conjoint/partenaire/concubin',
      'Uniquement entre personnes mariées',
      'Uniquement en cas de cohabitation',
    ],
    answer: 'Au sein du couple ou par un ancien conjoint/partenaire/concubin',
    explanation:
        'Le texte vise aussi les anciens conjoints/partenaires/concubins, même sans cohabitation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — 515-9',
    question: 'Selon 515-9, l’ordonnance peut être délivrée même si :',
    options: [
      'Il n’y a jamais eu de cohabitation',
      'Les parties sont toujours cohabitantes',
      'Le couple est uniquement marié',
    ],
    answer: 'Il n’y a jamais eu de cohabitation',
    explanation:
        'Le support précise : y compris lorsqu’il n’y a jamais eu de cohabitation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — 515-9',
    question: 'Pour délivrer l’ordonnance, le juge doit retenir :',
    options: [
      'Des raisons sérieuses de considérer vraisemblables les violences alléguées et le danger',
      'Une preuve scientifique certaine et irréfutable',
      'Une condamnation pénale préalable',
    ],
    answer:
        'Des raisons sérieuses de considérer vraisemblables les violences alléguées et le danger',
    explanation:
        'Le texte parle de “raisons sérieuses” et de violences “vraisemblables” + danger.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — 515-9',
    question:
        'La délivrance de l’ordonnance de protection suppose obligatoirement :',
    options: [
      'Un débat contradictoire devant le juge',
      'Une garde à vue de l’auteur',
      'Une enquête de flagrance',
    ],
    answer: 'Un débat contradictoire devant le juge',
    explanation:
        'Le texte indique que les éléments sont “produits devant lui et contradictoirement débattus”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — 515-9',
    question:
        'L’ordonnance de protection est délivrée dans un délai maximal de :',
    options: ['6 jours', '24 heures', '1 mois'],
    answer: '6 jours',
    explanation:
        'Le support indique : délai maximal de six jours à compter de la fixation de l’audience.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE DE PROTECTION — 515-11 : LISTE DES MESURES (SÉRIES)
  // =========================================================

  // ---- Mesure 1° : interdiction de recevoir/rencontrer/entrer en relation
  QuizQuestion(
    category: 'Mesures OP — 515-11 (1°)',
    question: 'La mesure 1° permet au JAF :',
    options: [
      'D’interdire de recevoir/rencontrer certaines personnes et d’entrer en relation avec elles',
      'D’interdire d’ouvrir un compte bancaire',
      'D’imposer un TIG',
    ],
    answer:
        'D’interdire de recevoir/rencontrer certaines personnes et d’entrer en relation avec elles',
    explanation: 'Mesure 1° de l’article 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (1°)',
    question: 'L’interdiction d’entrer en relation peut viser :',
    options: [
      'Toute façon de communiquer',
      'Uniquement les appels téléphoniques',
      'Uniquement les SMS',
    ],
    answer: 'Toute façon de communiquer',
    explanation: 'Le texte prévoit “de quelque façon que ce soit”.',
    difficulty: 'Moyenne',
  ),

  // ---- Mesure 1° bis : interdiction de se rendre dans certains lieux
  QuizQuestion(
    category: 'Mesures OP — 515-11 (1° bis)',
    question: 'La mesure 1° bis permet au JAF :',
    options: [
      'D’interdire de se rendre dans certains lieux spécialement désignés',
      'D’interdire de voyager en France',
      'D’interdire de travailler',
    ],
    answer:
        'D’interdire de se rendre dans certains lieux spécialement désignés',
    explanation:
        'Mesure 1° bis : lieux où se trouve habituellement la demanderesse.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (1° bis)',
    question:
        'Les lieux visés au 1° bis sont notamment ceux où la demanderesse se trouve :',
    options: [
      'De façon habituelle',
      'Uniquement le week-end',
      'Uniquement la nuit',
    ],
    answer: 'De façon habituelle',
    explanation:
        'Le texte vise “dans lesquels se trouve de façon habituelle la partie demanderesse”.',
    difficulty: 'Moyenne',
  ),

  // ---- Mesures armes : 2°, 2° bis
  QuizQuestion(
    category: 'Mesures OP — 515-11 (2°)',
    question: 'La mesure 2° permet au JAF :',
    options: [
      'D’interdire à la défenderesse de détenir ou porter une arme',
      'D’imposer le port d’un bracelet électronique pénal',
      'D’imposer une amende forfaitaire',
    ],
    answer: 'D’interdire à la défenderesse de détenir ou porter une arme',
    explanation: 'Mesure 2° : interdiction armes.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (2° bis)',
    question: 'La mesure 2° bis prévoit :',
    options: [
      'La remise des armes au service de police ou de gendarmerie le plus proche',
      'La remise des armes au notaire',
      'La remise des armes à l’avocat',
    ],
    answer:
        'La remise des armes au service de police ou de gendarmerie le plus proche',
    explanation: 'Mesure 2° bis : remise au service de police/gendarmerie.',
    difficulty: 'Moyenne',
  ),

  // ---- Mesure 2° ter : prise en charge / stage + info parquet si refus
  QuizQuestion(
    category: 'Mesures OP — 515-11 (2° ter)',
    question: 'La mesure 2° ter permet au JAF de proposer :',
    options: [
      'Une prise en charge sanitaire/sociale/psychologique ou un stage de responsabilisation',
      'Une peine de prison',
      'Une médiation obligatoire',
    ],
    answer:
        'Une prise en charge sanitaire/sociale/psychologique ou un stage de responsabilisation',
    explanation: 'Mesure 2° ter.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (2° ter)',
    question: 'En cas de refus de la partie défenderesse, le juge :',
    options: [
      'En avise immédiatement le procureur de la République',
      'Classe l’affaire automatiquement',
      'Prononce une condamnation pénale immédiate',
    ],
    answer: 'En avise immédiatement le procureur de la République',
    explanation:
        'Le texte prévoit l’information immédiate du procureur en cas de refus.',
    difficulty: 'Difficile',
  ),

  // ---- Mesure 3° : résidence séparée époux / logement conjugal
  QuizQuestion(
    category: 'Mesures OP — 515-11 (3°)',
    question: 'La mesure 3° permet au JAF de statuer sur :',
    options: [
      'La résidence séparée des époux et la jouissance du logement conjugal',
      'La nullité du mariage',
      'L’adoption',
    ],
    answer:
        'La résidence séparée des époux et la jouissance du logement conjugal',
    explanation: 'Mesure 3° : résidence séparée + logement conjugal.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (3°)',
    question: 'En principe, la jouissance du logement conjugal est attribuée :',
    options: [
      'Au conjoint non auteur des violences',
      'Au conjoint qui paie le loyer',
      'Au conjoint propriétaire uniquement',
    ],
    answer: 'Au conjoint non auteur des violences',
    explanation:
        'Principe protecteur : attribution au non-auteur, sauf ordonnance spécialement motivée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (3°)',
    question:
        'Même si la victime a bénéficié d’un hébergement d’urgence, la jouissance du logement conjugal peut :',
    options: [
      'Lui être attribuée quand même',
      'Lui être refusée automatiquement',
      'Être attribuée à l’auteur des violences',
    ],
    answer: 'Lui être attribuée quand même',
    explanation:
        'Le texte précise “et ce même s’il a bénéficié d’un hébergement d’urgence”.',
    difficulty: 'Difficile',
  ),

  // ---- Mesure 3° bis : animal de compagnie
  QuizQuestion(
    category: 'Mesures OP — 515-11 (3° bis)',
    question: 'La mesure 3° bis concerne :',
    options: [
      'La jouissance de l’animal de compagnie détenu au sein du foyer',
      'La pension alimentaire uniquement',
      'Le partage des meubles',
    ],
    answer: 'La jouissance de l’animal de compagnie détenu au sein du foyer',
    explanation: 'Mesure 3° bis.',
    difficulty: 'Moyenne',
  ),

  // ---- Mesure 4° : logement commun PACS/concubins
  QuizQuestion(
    category: 'Mesures OP — 515-11 (4°)',
    question: 'La mesure 4° permet au JAF de statuer sur :',
    options: [
      'Le logement commun des partenaires PACS ou concubins',
      'La dissolution du PACS par décision pénale',
      'La garde alternée automatique',
    ],
    answer: 'Le logement commun des partenaires PACS ou concubins',
    explanation: 'Mesure 4° : logement commun PACS/concubins.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (4°)',
    question:
        'En principe, la jouissance du logement commun (PACS/concubins) est attribuée :',
    options: [
      'Au partenaire/concubin non auteur des violences',
      'Au partenaire/concubin le plus ancien dans le logement',
      'Toujours au titulaire du bail',
    ],
    answer: 'Au partenaire/concubin non auteur des violences',
    explanation: 'Même logique protectrice que pour les époux.',
    difficulty: 'Moyenne',
  ),

  // ---- Mesure 5° : autorité parentale / DVH / contributions
  QuizQuestion(
    category: 'Mesures OP — 515-11 (5°)',
    question: 'La mesure 5° permet au JAF de se prononcer sur :',
    options: [
      'Les modalités d’exercice de l’autorité parentale et, le cas échéant, les contributions',
      'La peine pénale encourue',
      'La saisie des comptes bancaires',
    ],
    answer:
        'Les modalités d’exercice de l’autorité parentale et, le cas échéant, les contributions',
    explanation: 'Mesure 5° : autorité parentale + DVH + contributions.',
    difficulty: 'Moyenne',
  ),

  // ---- Mesure 6° : domicile dissimulé + élection de domicile avocat/parquet
  QuizQuestion(
    category: 'Mesures OP — 515-11 (6°)',
    question: 'La mesure 6° permet à la demanderesse :',
    options: [
      'De dissimuler son domicile/résidence et d’élire domicile chez l’avocat ou auprès du procureur',
      'D’obtenir automatiquement un logement social',
      'D’imposer une interdiction de sortie du territoire à l’auteur',
    ],
    answer:
        'De dissimuler son domicile/résidence et d’élire domicile chez l’avocat ou auprès du procureur',
    explanation: 'Mesure 6°.',
    difficulty: 'Difficile',
  ),

  // ---- Mesure 6° bis : élection domicile vie courante (personne morale qualifiée)
  QuizQuestion(
    category: 'Mesures OP — 515-11 (6° bis)',
    question: 'La mesure 6° bis permet :',
    options: [
      'D’élire domicile pour la vie courante chez une personne morale qualifiée',
      'D’élire domicile uniquement chez un parent',
      'De changer d’état civil',
    ],
    answer:
        'D’élire domicile pour la vie courante chez une personne morale qualifiée',
    explanation: 'Mesure 6° bis.',
    difficulty: 'Difficile',
  ),

  // ---- Mesure 7° : AJ provisoire
  QuizQuestion(
    category: 'Mesures OP — 515-11 (7°)',
    question: 'La mesure 7° concerne :',
    options: [
      'L’admission provisoire à l’aide juridictionnelle',
      'La suspension du permis',
      'La confiscation d’armes',
    ],
    answer: 'L’admission provisoire à l’aide juridictionnelle',
    explanation: 'Mesure 7°.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ORDONNANCE DE PROTECTION — 515-11-1 : DISTANCE + DISPOSITIF ANTI-RAPPROCHEMENT
  // =========================================================
  QuizQuestion(
    category: 'Dispositif anti-rapprochement — 515-11-1',
    question:
        'Quand le 1° (interdiction d’entrer en relation) est prononcé, le JAF peut :',
    options: [
      'Fixer une distance minimale de rapprochement',
      'Fixer une distance minimale uniquement si les parties sont mariées',
      'Fixer une distance minimale uniquement si une plainte existe',
    ],
    answer: 'Fixer une distance minimale de rapprochement',
    explanation:
        '515-11-1 permet l’interdiction de se rapprocher à moins d’une distance fixée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dispositif anti-rapprochement — 515-11-1',
    question: 'Le dispositif anti-rapprochement a pour objectif :',
    options: [
      'De signaler que la partie défenderesse ne respecte pas la distance',
      'De surveiller les réseaux sociaux de la victime',
      'De remplacer une condamnation pénale',
    ],
    answer:
        'De signaler que la partie défenderesse ne respecte pas la distance',
    explanation:
        'Le texte indique qu’il permet de signaler le non-respect de la distance.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 515-13 : MENACE DE MARIAGE FORCÉ + OPPI
  // =========================================================
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question: 'Une ordonnance de protection peut être délivrée en urgence à :',
    options: [
      'Une personne majeure menacée de mariage forcé',
      'Toute personne mineure menacée de mariage',
      'Uniquement une personne déjà mariée',
    ],
    answer: 'Une personne majeure menacée de mariage forcé',
    explanation: 'Le support vise la personne majeure menacée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question: 'Le juge peut ordonner, à la demande de la personne menacée :',
    options: [
      'Une interdiction temporaire de sortie du territoire',
      'Une interdiction définitive de quitter l’UE',
      'Une incarcération automatique de la famille',
    ],
    answer: 'Une interdiction temporaire de sortie du territoire',
    explanation: 'Mesure spécifique mentionnée à 515-13.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        'L’interdiction temporaire de sortie du territoire est inscrite au FPR par :',
    options: [
      'Le procureur de la République',
      'Le juge des enfants',
      'Le maire',
    ],
    answer: 'Le procureur de la République',
    explanation: 'Le support mentionne l’inscription au FPR par le procureur.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 515-13-1 : OPPI — CONDITIONS / MESURES
  // =========================================================
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'L’OPPI est délivrée si le juge estime vraisemblables :',
    options: [
      'Les violences alléguées et le danger grave et immédiat',
      'Une infraction fiscale',
      'Une simple dispute verbale sans danger',
    ],
    answer: 'Les violences alléguées et le danger grave et immédiat',
    explanation: 'Le texte parle de danger “grave et immédiat”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question:
        'Dans l’OPPI, le juge est compétent pour prononcer à titre provisoire :',
    options: [
      'Les mesures 1° à 2° bis de 515-11',
      'Toutes les mesures 1° à 7° automatiquement',
      'Uniquement l’aide juridictionnelle',
    ],
    answer: 'Les mesures 1° à 2° bis de 515-11',
    explanation: 'Le texte vise les mesures 1° à 2° bis.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'Dans l’OPPI, le juge peut aussi prononcer :',
    options: [
      'La suspension du droit de visite et d’hébergement (5°)',
      'La confiscation du véhicule',
      'La déchéance d’autorité parentale automatique',
    ],
    answer: 'La suspension du droit de visite et d’hébergement (5°)',
    explanation: 'Le texte mentionne la suspension du DVH mentionné au 5°.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question:
        'Dans l’OPPI, le juge peut permettre la dissimulation du domicile selon :',
    options: [
      'Les conditions prévues aux 6° et 6° bis de 515-11',
      'Une décision du préfet uniquement',
      'Une déclaration sur l’honneur sans décision',
    ],
    answer: 'Les conditions prévues aux 6° et 6° bis de 515-11',
    explanation: 'Le texte renvoie expressément aux 6° et 6° bis de 515-11.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // VIOLATION OP / OPPI — 227-4-2 : QUALIFICATION / PEINES / ÉLÉMENTS
  // =========================================================
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question: 'La violation d’une ordonnance de protection est réprimée par :',
    options: [
      '227-4-2 du Code pénal',
      '227-4-3 du Code pénal',
      '515-11 du code civil',
    ],
    answer: '227-4-2 du Code pénal',
    explanation: 'Élément légal : 227-4-2 CP.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question: 'La peine principale encourue pour 227-4-2 est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Répression : 3 ans + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question: 'Pour 227-4-2, la tentative est :',
    options: ['Non', 'Oui', 'Oui si l’OP date de moins de 6 jours'],
    answer: 'Non',
    explanation: 'TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question: 'Pour 227-4-2, la complicité est :',
    options: ['Oui (121-7 CP)', 'Non', 'Non si le complice est un proche'],
    answer: 'Oui (121-7 CP)',
    explanation: 'Complicité : OUI, article 121-7 CP.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Élément moral',
    question: 'L’infraction 227-4-2 exige :',
    options: [
      'La volonté de ne pas se conformer aux obligations/interdictions',
      'Une simple inattention',
      'L’absence de notification de changement de domicile',
    ],
    answer: 'La volonté de ne pas se conformer aux obligations/interdictions',
    explanation:
        'Infraction intentionnelle : connaissance + volonté de ne pas respecter.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Élément moral',
    question: 'Pour que 227-4-2 soit caractérisée, l’auteur doit avoir été :',
    options: [
      'Informé des termes de l’ordonnance',
      'Entendu comme témoin',
      'Condamné auparavant',
    ],
    answer: 'Informé des termes de l’ordonnance',
    explanation:
        'Le support précise que l’auteur doit avoir été informé des termes.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Circonstances aggravantes',
    question: 'Le support prévoit des circonstances aggravantes pour 227-4-2 :',
    options: ['Non (aucune)', 'Oui (deux)', 'Oui (une seule)'],
    answer: 'Non (aucune)',
    explanation: 'IV – circonstances aggravantes : aucune.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // RÈGLEMENT UE 606/2013 — APPLICATION EN FRANCE (SÉRIE DIFFICILE)
  // =========================================================
  QuizQuestion(
    category: 'Mesures UE — Règlement 606/2013',
    question:
        'Le texte mentionné prévoit la reconnaissance mutuelle des mesures de protection :',
    options: [
      'En matière civile',
      'En matière commerciale uniquement',
      'En matière fiscale uniquement',
    ],
    answer: 'En matière civile',
    explanation:
        'Le support vise explicitement les mesures de protection “en matière civile”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures UE — Règlement 606/2013',
    question:
        'Les mêmes peines sont applicables à la violation d’une mesure UE si elle est :',
    options: [
      'Reconnue et ayant force exécutoire en France',
      'Simplement évoquée dans un courrier',
      'Seulement traduite en français',
    ],
    answer: 'Reconnue et ayant force exécutoire en France',
    explanation:
        'Le support précise “reconnue et ayant force exécutoire en France”.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // QUESTIONS DE SYNTHÈSE / CAS PRATIQUES (QCM)
  // =========================================================
  QuizQuestion(
    category: 'Cas pratique — 227-4-3',
    question:
        'Un débiteur soumis à une ordonnance de protection déménage et ne prévient pas le créancier pendant 40 jours, volontairement. Quelle qualification est la plus adaptée ?',
    options: [
      'Défaut de notification de changement de domicile au créancier (227-4-3)',
      'Violation des obligations de l’ordonnance (227-4-2)',
      'Aucune infraction car la forme n’est pas imposée',
    ],
    answer:
        'Défaut de notification de changement de domicile au créancier (227-4-3)',
    explanation:
        'Délai d’un mois dépassé + intention de ne pas informer : 227-4-3.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — 227-4-2',
    question:
        'Une personne interdite de contacter la victime (OP) envoie des messages via un ami. Quelle infraction est la plus adaptée ?',
    options: [
      'Non-respect des obligations/interdictions de l’ordonnance (227-4-2)',
      'Défaut de notification de domicile (227-4-3)',
      'Aucune car ce n’est pas un contact direct',
    ],
    answer:
        'Non-respect des obligations/interdictions de l’ordonnance (227-4-2)',
    explanation:
        'L’interdiction porte sur “entrer en relation de quelque façon que ce soit”.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — 515-11-1',
    question:
        'Après une interdiction d’entrer en relation (1°), le juge fixe une distance minimale et impose un dispositif anti-rapprochement. Sur quel fondement ?',
    options: [
      'Article 515-11-1 du code civil',
      'Article 227-4-3 du Code pénal',
      'Article 515-4 du code civil',
    ],
    answer: 'Article 515-11-1 du code civil',
    explanation:
        'Le dispositif anti-rapprochement et la distance relèvent de 515-11-1.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // (GROS BLOC) QUESTIONS “LISTE” SUR 515-11 : REPÉRER LA BONNE MESURE
  // =========================================================
  QuizQuestion(
    category: 'Repérage — 515-11',
    question:
        'Quelle mesure correspond à « interdire de détenir ou porter une arme » ?',
    options: ['2°', '1° bis', '6°'],
    answer: '2°',
    explanation: 'Interdiction armes = 2°.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Repérage — 515-11',
    question:
        'Quelle mesure correspond à « remettre les armes au service de police/gendarmerie » ?',
    options: ['2° bis', '2°', '7°'],
    answer: '2° bis',
    explanation: 'Remise des armes = 2° bis.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Repérage — 515-11',
    question:
        'Quelle mesure correspond à « attribuer la jouissance de l’animal de compagnie » ?',
    options: ['3° bis', '4°', '1°'],
    answer: '3° bis',
    explanation: 'Animal de compagnie = 3° bis.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Repérage — 515-11',
    question:
        'Quelle mesure correspond à « autoriser la dissimulation du domicile et élection chez l’avocat/parquet » ?',
    options: ['6°', '6° bis', '5°'],
    answer: '6°',
    explanation: 'Dissimulation + élection avocat/parquet = 6°.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Repérage — 515-11',
    question:
        'Quelle mesure correspond à « élection de domicile pour la vie courante chez une personne morale qualifiée » ?',
    options: ['6° bis', '6°', '7°'],
    answer: '6° bis',
    explanation: 'Vie courante personne morale qualifiée = 6° bis.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Repérage — 515-11',
    question:
        'Quelle mesure correspond à « admission provisoire à l’aide juridictionnelle » ?',
    options: ['7°', '5°', '1°'],
    answer: '7°',
    explanation: 'Aide juridictionnelle provisoire = 7°.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // (SÉRIES) QUESTIONS “VRAI/FAUX” CONVERTIES EN QCM (OP / OPPI / CP)
  // =========================================================
  QuizQuestion(
    category: 'Vrai/Faux — OP',
    question:
        'L’ordonnance de protection est conditionnée à une plainte pénale.',
    options: ['Vrai', 'Faux', 'Ça dépend de la cohabitation'],
    answer: 'Faux',
    explanation:
        'Le texte précise qu’elle n’est pas conditionnée à l’existence d’une plainte pénale.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Vrai/Faux — OPPI',
    question:
        'L’OPPI est délivrée dans un délai de 24 heures à compter de la saisine.',
    options: ['Vrai', 'Faux', 'Vrai uniquement si les parties sont mariées'],
    answer: 'Vrai',
    explanation: 'Le texte mentionne : délivrée dans les 24 heures.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Vrai/Faux — 227-4-2',
    question:
        'La violation d’une ordonnance de protection est punie de 6 mois d’emprisonnement.',
    options: ['Vrai', 'Faux', 'Vrai si récidive'],
    answer: 'Faux',
    explanation: '227-4-2 prévoit 3 ans d’emprisonnement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Vrai/Faux — 227-4-3',
    question:
        'Le défaut de notification de changement de domicile au créancier est une infraction non intentionnelle.',
    options: ['Vrai', 'Faux', 'Vrai si la forme n’est pas respectée'],
    answer: 'Faux',
    explanation:
        'C’est une infraction intentionnelle : la négligence n’est pas punissable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Fondement',
    question:
        'L’infraction vise une personne tenue de verser une contribution ou des subsides au titre :',
    options: [
      'D’une ordonnance de protection rendue en application de l’article 515-9 du code civil',
      'D’un jugement de divorce définitif uniquement',
      'D’une simple main courante',
    ],
    answer:
        'D’une ordonnance de protection rendue en application de l’article 515-9 du code civil',
    explanation:
        'Le texte vise la personne tenue de verser une contribution ou des subsides au titre de l’ordonnance de protection (art. 515-9 C. civ.).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Fondement',
    question:
        'Le débiteur doit notifier son changement de domicile au créancier dans un délai de :',
    options: [
      'Un mois à compter du changement',
      'Quinze jours à compter du changement',
      'Deux mois à compter du changement',
    ],
    answer: 'Un mois à compter du changement',
    explanation:
        'Le délai légal est d’un mois à compter du changement de domicile.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question:
        'Concernant la forme de la notification du changement de domicile, le texte :',
    options: [
      'Ne prévoit aucune exigence de forme',
      'Impose une lettre recommandée avec AR',
      'Impose une signification par commissaire de justice',
    ],
    answer: 'Ne prévoit aucune exigence de forme',
    explanation:
        'Aucune exigence n’est formulée quant à la forme de la notification : l’essentiel est d’informer dans le délai.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément moral',
    question:
        'Le défaut de notification de changement de domicile est une infraction :',
    options: [
      'Intentionnelle',
      'Non intentionnelle',
      'Contraventionnelle de police',
    ],
    answer: 'Intentionnelle',
    explanation:
        'L’élément moral repose sur la volonté de ne pas informer le créancier ; la simple négligence n’est pas punissable.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // DÉFAUT DE NOTIFICATION — PRÉCISIONS / MÉCANISME
  // =========================================================
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question:
        'L’infraction a été prévue notamment car le JAF peut se prononcer dans le référé protection sur :',
    options: [
      'La contribution aux charges du ménage',
      'La nationalité',
      'Le permis de conduire',
    ],
    answer: 'La contribution aux charges du ménage',
    explanation:
        'Le cours indique que le JAF peut statuer sur la contribution aux charges du ménage, d’où l’intérêt dissuasif de l’incrimination.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question:
        'Dans ce cadre, la personne visée par 227-4-3 est principalement :',
    options: [
      'Le débiteur d’une contribution ou de subsides',
      'Le créancier uniquement',
      'Le témoin des violences',
    ],
    answer: 'Le débiteur d’une contribution ou de subsides',
    explanation:
        'L’obligation de notifier pèse sur le débiteur tenu de verser la contribution/subsides.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément moral',
    question: 'Pourquoi la simple négligence n’est-elle pas punissable ici ?',
    options: [
      'Car la volonté coupable consiste à priver le titulaire de son droit par le silence',
      'Car l’infraction est toujours une contravention',
      'Car l’infraction n’existe que si le créancier est mineur',
    ],
    answer:
        'Car la volonté coupable consiste à priver le titulaire de son droit par le silence',
    explanation:
        'Le texte insiste sur l’intention : la volonté de priver le créancier de l’exercice de son droit.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Circonstances',
    question:
        'Concernant les circonstances aggravantes du défaut de notification (227-4-3), il y en a :',
    options: [
      'Aucune',
      'Une si récidive légale',
      'Une si le débiteur déménage à l’étranger',
    ],
    answer: 'Aucune',
    explanation:
        'Le cours mentionne : « Aucune » circonstance aggravante prévue.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // DÉFAUT DE NOTIFICATION — RÉPRESSION / PROCÉDURE
  // =========================================================
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question: 'La peine encourue (personne physique) pour 227-4-3 est :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation: 'La répression prévue est : 6 mois + 7 500 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question: 'La classification de l’infraction 227-4-3 est :',
    options: ['Un délit', 'Une contravention', 'Un crime'],
    answer: 'Un délit',
    explanation: 'Le cours précise : classification = délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'La tentative de l’infraction 227-4-3 est :',
    options: [
      'Non punissable (tentative : non)',
      'Punissable (tentative : oui)',
      'Punissable uniquement en cas de violences',
    ],
    answer: 'Non punissable (tentative : non)',
    explanation: 'Le document indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'La complicité pour 227-4-3 est :',
    options: [
      'Applicable (article 121-7 du Code pénal)',
      'Inapplicable',
      'Applicable uniquement si le créancier est un enfant',
    ],
    answer: 'Applicable (article 121-7 du Code pénal)',
    explanation:
        'La complicité est prévue selon l’article 121-7 du Code pénal.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Personnes morales',
    question:
        'Depuis quand la responsabilité des personnes morales est applicable de façon généralisée (référence cours) ?',
    options: [
      'Depuis le 31 décembre 2005',
      'Depuis le 1er janvier 1990',
      'Depuis le 1er juillet 2025',
    ],
    answer: 'Depuis le 31 décembre 2005',
    explanation:
        'Le support mentionne l’application en la matière depuis le 31 décembre 2005 (dans le cadre de la responsabilité des personnes morales).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NON-RESPECT DES OBLIGATIONS / INTERDICTIONS D’UNE ORDONNANCE DE PROTECTION — FONDEMENTS
  // =========================================================
  QuizQuestion(
    category: 'Violation ordonnance de protection — Fondement',
    question:
        'Le non-respect des obligations ou interdictions imposées par une ordonnance de protection est prévu par :',
    options: [
      'L’article 227-4-2 du Code pénal',
      'L’article 227-4-3 du Code pénal',
      'L’article 515-11 du code civil',
    ],
    answer: 'L’article 227-4-2 du Code pénal',
    explanation:
        'L’élément légal est fixé par l’article 227-4-2 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Champ',
    question:
        'L’infraction vise le non-respect d’obligations/interdictions imposées dans :',
    options: [
      'Une ordonnance de protection (art. 515-9 ou 515-13 C. civ.)',
      'Une simple médiation familiale',
      'Une audition libre',
    ],
    answer: 'Une ordonnance de protection (art. 515-9 ou 515-13 C. civ.)',
    explanation:
        'Le texte vise l’ordonnance de protection rendue notamment en application des articles 515-9 ou 515-13 du code civil.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Champ',
    question:
        'Sont aussi visées par 227-4-2 les obligations/interdictions imposées dans :',
    options: [
      'Une ordonnance provisoire de protection immédiate (art. 515-13-1 C. civ.)',
      'Un PV de renseignement judiciaire',
      'Une ordonnance de non-conciliation uniquement',
    ],
    answer:
        'Une ordonnance provisoire de protection immédiate (art. 515-13-1 C. civ.)',
    explanation:
        'Le texte vise aussi l’ordonnance provisoire de protection immédiate rendue sur le fondement de l’article 515-13-1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Champ UE',
    question:
        'Les mêmes peines s’appliquent à la violation d’une mesure de protection civile d’un autre État membre de l’UE reconnue en France via :',
    options: [
      'Le règlement (UE) n° 606/2013 du 12 juin 2013',
      'Le règlement (UE) n° 44/2001',
      'Le traité de Lisbonne',
    ],
    answer: 'Le règlement (UE) n° 606/2013 du 12 juin 2013',
    explanation:
        'Le support mentionne expressément le règlement (UE) 606/2013 relatif à la reconnaissance mutuelle des mesures de protection civiles.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE DE PROTECTION — CONDITIONS (515-9) / DÉLAIS
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Conditions',
    question:
        'Selon l’article 515-9 C. civ., l’ordonnance de protection peut être délivrée lorsque des violences au sein du couple :',
    options: [
      'Mettent en danger la victime ou un ou plusieurs enfants',
      'Sont uniquement anciennes de moins de 24h',
      'Ont déjà donné lieu à une condamnation définitive',
    ],
    answer: 'Mettent en danger la victime ou un ou plusieurs enfants',
    explanation:
        'La condition centrale : danger pour la victime (et/ou les enfants).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Conditions',
    question:
        'L’ordonnance de protection peut être délivrée même lorsqu’il n’y a pas de cohabitation :',
    options: [
      'Oui',
      'Non, la cohabitation est obligatoire',
      'Oui, mais seulement si les personnes sont mariées',
    ],
    answer: 'Oui',
    explanation:
        'Le texte vise les violences au sein du couple y compris sans cohabitation, et même sans cohabitation passée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Délai',
    question:
        'Le JAF délivre l’ordonnance de protection dans un délai maximal de :',
    options: [
      'Six jours à compter de la fixation de la date d’audience',
      'Vingt-quatre heures à compter de la saisine',
      'Un mois à compter de la requête',
    ],
    answer: 'Six jours à compter de la fixation de la date d’audience',
    explanation:
        'Le support indique : délai maximal de six jours (OP classique).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Plainte',
    question:
        'La délivrance d’une ordonnance de protection est-elle conditionnée à une plainte pénale ?',
    options: [
      'Non',
      'Oui',
      'Oui, uniquement en cas de violences psychologiques',
    ],
    answer: 'Non',
    explanation:
        'Le texte précise que l’ordonnance n’est pas conditionnée à l’existence d’une plainte pénale.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ORDONNANCE DE PROTECTION — MESURES POSSIBLES (515-11) : QCM
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Parmi les mesures possibles, le JAF peut interdire à la partie défenderesse :',
    options: [
      'De recevoir/rencontrer certaines personnes et d’entrer en relation avec elles',
      'D’exercer toute activité professionnelle',
      'De conduire un véhicule',
    ],
    answer:
        'De recevoir/rencontrer certaines personnes et d’entrer en relation avec elles',
    explanation: 'C’est la mesure 1° de l’article 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut interdire à la partie défenderesse de se rendre dans certains lieux fréquentés habituellement par la demanderesse :',
    options: [
      'Oui (1° bis)',
      'Non, jamais',
      'Oui, uniquement si un divorce est engagé',
    ],
    answer: 'Oui (1° bis)',
    explanation:
        'La mesure 1° bis prévoit l’interdiction de se rendre dans certains lieux.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question: 'Concernant les armes, le JAF peut notamment :',
    options: [
      'Interdire de détenir/porter une arme',
      'Imposer une peine de prison immédiate',
      'Prononcer une interdiction de vote',
    ],
    answer: 'Interdire de détenir/porter une arme',
    explanation: 'C’est la mesure 2° de l’article 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut ordonner à la partie défenderesse de remettre ses armes :',
    options: [
      'Au service de police ou de gendarmerie le plus proche du domicile',
      'À la mairie',
      'À l’employeur',
    ],
    answer: 'Au service de police ou de gendarmerie le plus proche du domicile',
    explanation:
        'Mesure 2° bis : remise au service de police/gendarmerie le plus proche.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut proposer une prise en charge sanitaire/sociale/psychologique ou un stage de responsabilisation :',
    options: [
      'Oui (2° ter)',
      'Non, c’est uniquement le rôle du procureur',
      'Oui, mais seulement pour la victime',
    ],
    answer: 'Oui (2° ter)',
    explanation:
        'Mesure 2° ter : proposition de prise en charge ou stage ; en cas de refus, information immédiate du procureur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Concernant le logement conjugal, sauf circonstances particulières, la jouissance est attribuée :',
    options: [
      'Au conjoint qui n’est pas l’auteur des violences',
      'Au conjoint qui a le plus de revenus',
      'Au conjoint le plus ancien dans le logement',
    ],
    answer: 'Au conjoint qui n’est pas l’auteur des violences',
    explanation:
        'Le principe : protection de la victime, attribution au non-auteur des violences.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut attribuer la jouissance de l’animal de compagnie détenu au sein du foyer :',
    options: ['Oui (3° bis)', 'Non', 'Oui, uniquement si l’animal est assuré'],
    answer: 'Oui (3° bis)',
    explanation:
        'L’article 515-11 prévoit la mesure 3° bis sur l’animal de compagnie.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Pour des partenaires PACS/concubins, la jouissance du logement commun est attribuée en principe :',
    options: [
      'Au partenaire/concubin qui n’est pas l’auteur des violences',
      'Au propriétaire du bail, quoi qu’il arrive',
      'Au partenaire le plus âgé',
    ],
    answer: 'Au partenaire/concubin qui n’est pas l’auteur des violences',
    explanation:
        'Le même principe protecteur est prévu au 4° pour PACS/concubins.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut se prononcer sur l’autorité parentale et aussi sur :',
    options: [
      'Le droit de visite/hébergement et les contributions (mariage/PACS/enfants)',
      'L’inscription à Pôle emploi',
      'Le retrait de permis',
    ],
    answer:
        'Le droit de visite/hébergement et les contributions (mariage/PACS/enfants)',
    explanation:
        'Mesure 5° : autorité parentale, DVH, et contributions selon la situation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut autoriser la demanderesse à dissimuler son domicile et élire domicile :',
    options: [
      'Chez l’avocat ou auprès du procureur de la République (pour les instances civiles)',
      'Uniquement au commissariat',
      'Uniquement chez un membre de la famille',
    ],
    answer:
        'Chez l’avocat ou auprès du procureur de la République (pour les instances civiles)',
    explanation:
        'Mesure 6° : dissimulation + élection de domicile chez avocat ou auprès du procureur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut aussi autoriser une élection de domicile « pour les besoins de la vie courante » :',
    options: [
      'Chez une personne morale qualifiée (6° bis)',
      'Uniquement chez le notaire',
      'Uniquement à la préfecture',
    ],
    answer: 'Chez une personne morale qualifiée (6° bis)',
    explanation:
        'Mesure 6° bis : élection de domicile vie courante auprès d’une personne morale qualifiée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut prononcer l’admission provisoire à l’aide juridictionnelle :',
    options: [
      'Oui (7°)',
      'Non, jamais',
      'Oui, mais seulement pour la partie défenderesse',
    ],
    answer: 'Oui (7°)',
    explanation: 'Mesure 7° : admission provisoire à l’aide juridictionnelle.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // DISPOSITIF ANTI-RAPPROCHEMENT (515-11-1) — QCM
  // =========================================================
  QuizQuestion(
    category: 'Dispositif anti-rapprochement — 515-11-1',
    question:
        'Si l’interdiction d’entrer en relation (1°) est prononcée, le JAF peut aussi :',
    options: [
      'Fixer une distance minimale et ordonner un dispositif anti-rapprochement',
      'Ordonner une détention provisoire automatique',
      'Prononcer une expulsion locative sans décision',
    ],
    answer:
        'Fixer une distance minimale et ordonner un dispositif anti-rapprochement',
    explanation:
        'L’article 515-11-1 permet l’interdiction de se rapprocher à moins d’une certaine distance + dispositif anti-rapprochement.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE (515-13) — MARIAGE FORCÉ / SORTIE DU TERRITOIRE
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Mariage forcé (515-13)',
    question:
        'L’article 515-13 permet une ordonnance de protection en urgence pour :',
    options: [
      'Une personne majeure menacée de mariage forcé',
      'Toute personne souhaitant changer de nom',
      'Un mineur voulant se marier',
    ],
    answer: 'Une personne majeure menacée de mariage forcé',
    explanation:
        'Le texte vise expressément la personne majeure menacée de mariage forcé.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mariage forcé (515-13)',
    question:
        'Dans ce cadre, le JAF peut ordonner à la demande de la personne :',
    options: [
      'Une interdiction temporaire de sortie du territoire',
      'Une interdiction définitive de quitter la ville',
      'Une saisie automatique du passeport par l’employeur',
    ],
    answer: 'Une interdiction temporaire de sortie du territoire',
    explanation:
        'L’article 515-13 mentionne l’interdiction temporaire de sortie du territoire.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mariage forcé (515-13)',
    question:
        'L’interdiction temporaire de sortie du territoire est inscrite au FPR par :',
    options: ['Le procureur de la République', 'Le maire', 'Le préfet'],
    answer: 'Le procureur de la République',
    explanation:
        'Le support précise l’inscription au FPR par le procureur de la République.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE PROVISOIRE DE PROTECTION IMMÉDIATE (515-13-1) — 24H
  // =========================================================
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question:
        'L’ordonnance provisoire de protection immédiate est délivrée dans un délai de :',
    options: [
      '24 heures à compter de la saisine',
      '6 jours à compter de la fixation d’audience',
      '15 jours à compter de l’enquête',
    ],
    answer: '24 heures à compter de la saisine',
    explanation:
        'Le texte indique : délivrée dans un délai de vingt-quatre heures.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question:
        'Qui peut demander, avec l’accord de la personne en danger, une OPPI en plus de la demande d’OP ?',
    options: ['Le ministère public', 'Le greffe', 'La mairie'],
    answer: 'Le ministère public',
    explanation:
        'L’article 515-13-1 prévoit la demande par le ministère public avec l’accord de la personne en danger.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'Pour délivrer l’OPPI, le JAF statue :',
    options: [
      'Au vu des seuls éléments joints à la requête',
      'Après une enquête de flagrance obligatoire',
      'Uniquement après audition de 3 témoins',
    ],
    answer: 'Au vu des seuls éléments joints à la requête',
    explanation:
        'L’OPPI est délivrée sur la base des éléments joints à la requête (sans débat contradictoire complet).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // VIOLATION ORDONNANCE DE PROTECTION — ÉLÉMENT MATÉRIEL / MORAL
  // =========================================================
  QuizQuestion(
    category: 'Violation ordonnance de protection — Élément matériel',
    question: 'L’élément matériel de 227-4-2 consiste à :',
    options: [
      'Ne pas se conformer aux obligations/interdictions imposées',
      'Ne pas payer une amende forfaitaire',
      'Refuser une audition libre',
    ],
    answer: 'Ne pas se conformer aux obligations/interdictions imposées',
    explanation:
        'La violation est le non-respect des obligations/interdictions fixées par l’ordonnance.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Élément moral',
    question: 'L’infraction 227-4-2 est :',
    options: [
      'Intentionnelle',
      'Non intentionnelle',
      'Une simple faute civile',
    ],
    answer: 'Intentionnelle',
    explanation:
        'Le support précise une infraction intentionnelle : l’auteur agit en connaissance de cause des obligations/interdictions.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Élément moral',
    question: 'Pour caractériser l’élément moral, l’auteur doit notamment :',
    options: [
      'Avoir été informé des termes de l’ordonnance',
      'Avoir changé de travail',
      'Avoir contesté la procédure au civil',
    ],
    answer: 'Avoir été informé des termes de l’ordonnance',
    explanation:
        'La connaissance des obligations/interdictions suppose que l’auteur ait été informé de l’ordonnance.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Finalité',
    question: 'Le texte 227-4-2 vise à rendre l’ordonnance de protection :',
    options: [
      'Pleinement effective et contraignante',
      'Optionnelle',
      'Uniquement symbolique',
    ],
    answer: 'Pleinement effective et contraignante',
    explanation:
        'Le cours insiste sur l’effectivité : sanctionner pénalement la violation pour rendre la mesure réellement protectrice.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // VIOLATION ORDONNANCE DE PROTECTION — RÉPRESSION / PROCÉDURE
  // =========================================================
  QuizQuestion(
    category: 'Violation ordonnance de protection — Répression',
    question: 'La peine encourue (personne physique) pour 227-4-2 est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '10 ans de réclusion et 150 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'La répression prévue par 227-4-2 est de 3 ans et 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Classification',
    question: 'La classification de l’infraction 227-4-2 est :',
    options: ['Un délit', 'Un crime', 'Une contravention'],
    answer: 'Un délit',
    explanation: 'Le cours précise : délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Circonstances',
    question:
        'Concernant les circonstances aggravantes de 227-4-2 (cours), il y en a :',
    options: ['Aucune', 'Deux', 'Uniquement la récidive'],
    answer: 'Aucune',
    explanation: 'Le support indique : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Tentative / complicité',
    question: 'La tentative de 227-4-2 est :',
    options: [
      'Non punissable (tentative : non)',
      'Punissable (tentative : oui)',
      'Toujours punissable en correctionnelle',
    ],
    answer: 'Non punissable (tentative : non)',
    explanation: 'Le document précise : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Tentative / complicité',
    question: 'La complicité pour 227-4-2 est :',
    options: [
      'Oui (article 121-7 du Code pénal)',
      'Non, jamais',
      'Oui, uniquement si l’auteur est mineur',
    ],
    answer: 'Oui (article 121-7 du Code pénal)',
    explanation:
        'La complicité est applicable conformément à l’article 121-7 du Code pénal.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // QUESTIONS MIXTES (COMPARAISONS 227-4-2 / 227-4-3)
  // =========================================================
  QuizQuestion(
    category: 'Comparatif — 227-4-2 vs 227-4-3',
    question:
        'Quelle infraction est la plus lourdement sanctionnée (peine d’emprisonnement) ?',
    options: ['227-4-2 (3 ans)', '227-4-3 (6 mois)', 'Elles sont identiques'],
    answer: '227-4-2 (3 ans)',
    explanation: '227-4-2 prévoit 3 ans, tandis que 227-4-3 prévoit 6 mois.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — 227-4-2 vs 227-4-3',
    question:
        'Quelle infraction concerne spécifiquement le changement de domicile du débiteur ?',
    options: ['227-4-3', '227-4-2', '515-11'],
    answer: '227-4-3',
    explanation:
        '227-4-3 incrimine le défaut de notification du changement de domicile au créancier.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — Élément moral',
    question: 'Point commun entre 227-4-2 et 227-4-3 :',
    options: [
      'Ce sont des infractions intentionnelles',
      'Ce sont des contraventions',
      'Elles exigent une plainte pénale préalable',
    ],
    answer: 'Ce sont des infractions intentionnelles',
    explanation:
        'Les deux supposent une volonté : ne pas se conformer / ne pas informer.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Comparatif — Tentative',
    question: 'Concernant la tentative, 227-4-2 et 227-4-3 :',
    options: [
      'Ne prévoient pas la tentative (tentative : non)',
      'Prévoient toutes deux la tentative',
      'Prévoient la tentative seulement en cas de récidive',
    ],
    answer: 'Ne prévoient pas la tentative (tentative : non)',
    explanation:
        'Le support indique “TENTATIVE : NON” pour les deux infractions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Comparatif — Complicité',
    question: 'Concernant la complicité (121-7 CP), pour 227-4-2 et 227-4-3 :',
    options: [
      'Elle est applicable pour les deux',
      'Elle est exclue pour les deux',
      'Elle n’est applicable que pour 227-4-3',
    ],
    answer: 'Elle est applicable pour les deux',
    explanation:
        'Les deux supports indiquent “COMPLICITÉ : OUI” + référence à l’article 121-7 CP.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // QUESTIONS "PIÈGES" / PRÉCISION DE TEXTE (PLUS DIFFICILES)
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Durée',
    question:
        'Les mesures de l’ordonnance de protection peuvent être prises pour une durée maximale de :',
    options: [
      '12 mois (prolongeable sous conditions)',
      '6 mois non prolongeable',
      '24 mois automatiquement',
    ],
    answer: '12 mois (prolongeable sous conditions)',
    explanation:
        'Le support mentionne une durée maximale de 12 mois, prolongeable sous certaines conditions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Logement',
    question:
        'Sauf circonstances particulières, la jouissance du logement est attribuée :',
    options: [
      'À la personne non auteure des violences',
      'À la personne ayant l’autorité parentale exclusive',
      'Toujours au titulaire du bail',
    ],
    answer: 'À la personne non auteure des violences',
    explanation:
        'Principe protecteur : attribution au non-auteur (sauf ordonnance motivée/circonstances particulières).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Domicile dissimulé',
    question:
        'Si un commissaire de justice doit connaître l’adresse réelle pour exécuter une décision :',
    options: [
      'L’adresse lui est communiquée, mais il ne peut pas la révéler à son mandant',
      'L’adresse ne peut jamais être communiquée à personne',
      'L’adresse est rendue publique au dossier',
    ],
    answer:
        'L’adresse lui est communiquée, mais il ne peut pas la révéler à son mandant',
    explanation:
        'Le support précise la communication nécessaire pour l’exécution, avec interdiction de révélation au mandant.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Information autorités',
    question:
        'Quand les mesures 6°/6° bis sont prononcées, qui peut être informé (avec accord de la personne) pour éviter la communication de l’adresse ?',
    options: [
      'Le maire et le représentant de l’État dans le département',
      'Uniquement le préfet de police de Paris',
      'Uniquement le bâtonnier',
    ],
    answer: 'Le maire et le représentant de l’État dans le département',
    explanation:
        'Le support indique l’information du maire et du représentant de l’État dans le département, sous réserve de l’accord de la personne.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Fin des mesures',
    question: 'Les mesures de l’OPPI prennent fin :',
    options: [
      'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
      'Uniquement au bout de 12 mois',
      'Quand la victime le décide seule',
    ],
    answer:
        'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
    explanation:
        'Le support précise la fin des mesures à compter de la décision sur la demande d’OP ou incident mettant fin à l’instance.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Abandon de famille — Circonstances aggravantes',
    question: 'Le support prévoit des circonstances aggravantes pour 227-3 :',
    options: ['Aucune', 'Oui, au-delà de 5 jours', 'Oui, si à l’étranger'],
    answer: 'Aucune',
    explanation: 'Le support mentionne : Aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Abandon de famille — Tentative / complicité',
    question: 'Pour l’abandon de famille (227-3), la tentative est :',
    options: ['Non', 'Oui', 'Oui si paiement partiel'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Cas pratique — Abandon de famille',
    question:
        'Décision notifiée : pension indexée. Le débiteur paye l’ancien montant pendant plus de deux mois et refuse l’indexation. Le délit peut être :',
    options: ['Constitué', 'Non constitué', 'Constitué uniquement si saisie'],
    answer: 'Constitué',
    explanation:
        'Le support mentionne que le refus d’indexation peut constituer le délit (Cass. crim., 26/10/1987).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
class QuizMineursFamille extends StatefulWidget {
  static const String routeName =
      '/gpx/mineurs_famille_pages/quiz/quiz_mineurs_famille';
  final String uid;
  final String email;

  const QuizMineursFamille({super.key, required this.uid, required this.email});

  @override
  State<QuizMineursFamille> createState() => _QuizMineursFamilleState();
}

class _QuizMineursFamilleState extends State<QuizMineursFamille>
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
            'module_name': 'Atteintes aux mineurs & à la famille',
            'quiz_name': 'Atteintes aux mineurs & à la famille',
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
      await _sb.from('quiz_mineurs_famille').insert({
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
      debugPrint('❌ quiz_mineurs_famille insert failed: $e');
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
