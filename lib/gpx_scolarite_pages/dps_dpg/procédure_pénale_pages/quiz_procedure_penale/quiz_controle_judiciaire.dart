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
final List<QuizQuestion> questionsControleJudiciaire = [
  // =====================================================
  // NIVEAU 1 — FACILE
  // =====================================================

  // NOTIONS GÉNÉRALES
  QuizQuestion(
    category: "Contrôle judiciaire — Notions générales",
    question:
        "Quel est l’objectif principal du contrôle judiciaire instauré par la loi du 17 juillet 1970 ?",
    options: [
      "Permettre la détention provisoire dans tous les cas",
      "Éviter le recours à la détention provisoire lorsqu’elle n’est pas absolument nécessaire",
      "Remplacer toutes les peines d’emprisonnement",
    ],
    answer:
        "Éviter le recours à la détention provisoire lorsqu’elle n’est pas absolument nécessaire",
    explanation:
        "Le contrôle judiciaire a été créé pour limiter le recours à la détention provisoire et offrir une mesure alternative, plus souple.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Notions générales",
    question: "Le contrôle judiciaire est :",
    options: [
      "Une peine d’emprisonnement",
      "Une mesure restrictive de liberté assortie d’obligations",
      "Une simple mise en garde sans obligation",
    ],
    answer: "Une mesure restrictive de liberté assortie d’obligations",
    explanation:
        "L’article 137 C.P.P. précise que le contrôle judiciaire restreint la liberté par des obligations imposées à la personne mise en examen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Notions générales",
    question:
        "À quelle personne le contrôle judiciaire peut-il être appliqué ?",
    options: [
      "À toute personne suspectée, même sans mise en examen",
      "Uniquement à la personne mise en examen",
      "Uniquement à la personne déjà condamnée",
    ],
    answer: "Uniquement à la personne mise en examen",
    explanation:
        "Le contrôle judiciaire vise la personne mise en examen dans le cadre d’une information judiciaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Notions générales",
    question: "Le contrôle judiciaire est une mesure :",
    options: [
      "Qui s’adapte aux situations les plus diverses",
      "Qui ne peut être prononcée que dans un cas très précis",
      "Réservée aux crimes uniquement",
    ],
    answer: "Qui s’adapte aux situations les plus diverses",
    explanation:
        "Le texte le présente comme une mesure très souple, permettant d’ajuster les obligations selon la situation.",
    difficulty: "Facile",
  ),

  // CONDITIONS GÉNÉRALES
  QuizQuestion(
    category: "Contrôle judiciaire — Conditions de mise en œuvre",
    question:
        "Selon l’article 138 al. 1 C.P.P., le contrôle judiciaire n’est possible que si :",
    options: [
      "L’infraction est punissable d’une peine d’emprisonnement correctionnel",
      "L’infraction est uniquement punissable d’une amende",
      "L’infraction est une simple contravention",
    ],
    answer:
        "L’infraction est punissable d’une peine d’emprisonnement correctionnel",
    explanation:
        "Le texte exclut les simples contraventions : il faut au minimum une peine d’emprisonnement correctionnel encourue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Conditions de mise en œuvre",
    question: "Le contrôle judiciaire peut être prononcé :",
    options: [
      "À l’occasion de la mise en examen ou de la libération d’une détention provisoire",
      "Uniquement après le jugement",
      "Uniquement pendant la garde à vue",
    ],
    answer:
        "À l’occasion de la mise en examen ou de la libération d’une détention provisoire",
    explanation:
        "Il peut intervenir dès la mise en examen ou lors de la remise en liberté d’une personne jusque-là détenue provisoirement.",
    difficulty: "Facile",
  ),

  // AUTORITÉS COMPÉTENTES PLACEMENT
  QuizQuestion(
    category: "Contrôle judiciaire — Conditions de placement",
    question:
        "Parmi les autorités suivantes, laquelle peut ordonner un contrôle judiciaire ?",
    options: ["Le juge d’instruction", "Le greffier", "Le gardien de la paix"],
    answer: "Le juge d’instruction",
    explanation:
        "Le juge d’instruction est expressément mentionné comme pouvant ordonner un contrôle judiciaire (art. 139 C.P.P.).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Conditions de placement",
    question:
        "Quel magistrat peut décider d’un contrôle judiciaire lorsqu’il est saisi pour une demande de détention provisoire ?",
    options: [
      "Le juge des libertés et de la détention (JLD)",
      "Le juge de proximité",
      "Le juge de l’application des peines",
    ],
    answer: "Le juge des libertés et de la détention (JLD)",
    explanation:
        "Lorsque le JLD refuse la détention provisoire, il peut décider un placement sous contrôle judiciaire (art. 145 C.P.P.).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Conditions de placement",
    question:
        "La chambre de l’instruction peut ordonner un contrôle judiciaire :",
    options: [
      "En cas d’appel ou de saisine directe par le procureur de la République",
      "Uniquement en matière contraventionnelle",
      "Jamais, ce n’est pas de sa compétence",
    ],
    answer:
        "En cas d’appel ou de saisine directe par le procureur de la République",
    explanation:
        "Le texte prévoit expressément la possibilité pour la chambre de l’instruction d’ordonner un contrôle judiciaire dans ces hypothèses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Conditions de placement",
    question:
        "Les juridictions de jugement peuvent ordonner un contrôle judiciaire :",
    options: [
      "En saisissant le JLD d’une requête motivée",
      "Uniquement avec l’accord du mis en examen",
      "Uniquement sur demande de la victime",
    ],
    answer: "En saisissant le JLD d’une requête motivée",
    explanation:
        "Elles peuvent ordonner le placement sous contrôle judiciaire jusqu’à la décision de jugement, via une ordonnance motivée.",
    difficulty: "Facile",
  ),

  // OBLIGATIONS PERSONNES PHYSIQUES & MORALES
  QuizQuestion(
    category: "Contrôle judiciaire — Obligations",
    question:
        "Les obligations du contrôle judiciaire applicables aux personnes physiques sont listées :",
    options: [
      "À l’article 138 du C.P.P.",
      "À l’article 63-3 du C.P.P.",
      "À l’article 706-45 du C.P.P.",
    ],
    answer: "À l’article 138 du C.P.P.",
    explanation:
        "L’article 138 énumère les différentes obligations possibles pour la personne physique mise en examen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Obligations",
    question:
        "Les obligations du contrôle judiciaire applicables aux personnes morales sont prévues par :",
    options: [
      "L’article 706-45 du C.P.P.",
      "L’article 138 du C.P.P.",
      "L’article 64 du C.P.P.",
    ],
    answer: "L’article 706-45 du C.P.P.",
    explanation:
        "Cet article prévoit que la personne morale peut se voir imposer une ou plusieurs obligations spécifiques.",
    difficulty: "Facile",
  ),

  // ORGANISATION & SUIVI
  QuizQuestion(
    category: "Contrôle judiciaire — Organisation",
    question:
        "Qui doit veiller à l’application des mesures de contrôle judiciaire ?",
    options: [
      "Le juge d’instruction",
      "Le procureur général",
      "Le maire de la commune",
    ],
    answer: "Le juge d’instruction",
    explanation:
        "C’est au juge d’instruction qu’il revient de veiller à l’exécution des obligations (art. 141 C.P.P.).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Organisation",
    question:
        "Les services de police et de gendarmerie chargés de surveiller la personne sous contrôle judiciaire doivent :",
    options: [
      "Simplement l’inscrire dans un registre",
      "Alerter le juge d’instruction en cas de manquement",
      "Décider eux-mêmes d’une détention provisoire",
    ],
    answer: "Alerter le juge d’instruction en cas de manquement",
    explanation:
        "Ils contrôlent le respect des obligations et avisent rapidement le juge en cas de non-respect.",
    difficulty: "Facile",
  ),

  // MODIFICATION & MAINLEVÉE — PRINCIPES
  QuizQuestion(
    category: "Contrôle judiciaire — Modification",
    question: "La modification du contrôle judiciaire peut consister à :",
    options: [
      "Ajouter des obligations",
      "Supprimer tout ou partie des obligations",
      "Ajouter ou supprimer des obligations",
    ],
    answer: "Ajouter ou supprimer des obligations",
    explanation:
        "Le juge peut adapter les obligations : en ajouter, en retirer, ou en modifier l’étendue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Mainlevée",
    question: "La mainlevée du contrôle judiciaire signifie :",
    options: [
      "Le renforcement des obligations",
      "La fin de l’application du contrôle judiciaire",
      "La transformation en détention provisoire",
    ],
    answer: "La fin de l’application du contrôle judiciaire",
    explanation:
        "La mainlevée met fin aux obligations et à la mesure elle-même.",
    difficulty: "Facile",
  ),

  // FIN NORMALE
  QuizQuestion(
    category: "Contrôle judiciaire — Fin normale",
    question: "En principe, le contrôle judiciaire prend fin :",
    options: [
      "À la clôture de l’information judiciaire",
      "À l’issue de la garde à vue",
      "Automatiquement au bout d’un mois",
    ],
    answer: "À la clôture de l’information judiciaire",
    explanation:
        "Sauf décision de mainlevée anticipée, la mesure dure jusqu’à la fin de l’information.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Fin en matière correctionnelle",
    question:
        "En matière correctionnelle, l’ordonnance de renvoi devant le tribunal correctionnel :",
    options: [
      "Met fin au contrôle judiciaire",
      "Prolonge automatiquement le contrôle judiciaire",
      "Transforme le contrôle judiciaire en détention provisoire",
    ],
    answer: "Met fin au contrôle judiciaire",
    explanation:
        "Le texte précise que l’ordonnance de renvoi met fin, en principe, au contrôle judiciaire.",
    difficulty: "Facile",
  ),

  // TRANSFORMATION EN DÉTENTION
  QuizQuestion(
    category: "Contrôle judiciaire — Transformation",
    question:
        "Si le contrôle judiciaire ne suffit plus à assurer le bon déroulement de l’instruction, il peut être :",
    options: [
      "Transformé en détention provisoire",
      "Transformé en simple rappel à la loi",
      "Automatiquement supprimé",
    ],
    answer: "Transformé en détention provisoire",
    explanation:
        "L’article 137 C.P.P. prévoit la possibilité de recourir à la détention provisoire lorsque le contrôle judiciaire est insuffisant.",
    difficulty: "Facile",
  ),

  // =====================================================
  // NIVEAU 2 — MOYEN
  // =====================================================

  // RÔLE DU JUGE D’INSTRUCTION (MAINLEVÉE & MODIFICATION)
  QuizQuestion(
    category: "Contrôle judiciaire — Mainlevée (rôle du juge d’instruction)",
    question:
        "Selon l’article 140 al. 1 C.P.P., à quel moment le juge d’instruction peut-il ordonner la mainlevée du contrôle judiciaire ?",
    options: [
      "Uniquement à la fin de l’instruction",
      "À tout moment au cours de l’instruction",
      "Uniquement avant la mise en examen",
    ],
    answer: "À tout moment au cours de l’instruction",
    explanation:
        "L’article 140 permet la mainlevée à n’importe quel stade de l’information, dès lors que les conditions ne sont plus réunies.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Mainlevée (rôle du juge d’instruction)",
    question:
        "La mainlevée du contrôle judiciaire par le juge d’instruction peut être :",
    options: [
      "Ordonnée d’office ou sur demande de la personne mise en examen",
      "Uniquement sur demande de la victime",
      "Uniquement sur réquisitions du procureur",
    ],
    answer: "Ordonnée d’office ou sur demande de la personne mise en examen",
    explanation:
        "Le juge peut agir de sa propre initiative ou à la demande de la personne concernée.",
    difficulty: "Moyen",
  ),

  // SAISINE DE LA CHAMBRE DE L’INSTRUCTION
  QuizQuestion(
    category: "Contrôle judiciaire — Mainlevée (chambre de l’instruction)",
    question:
        "En cas de silence du juge d’instruction pendant 5 jours après une demande de mainlevée, la chambre de l’instruction doit être saisie dans un délai de :",
    options: ["5 jours", "20 jours", "1 mois"],
    answer: "20 jours",
    explanation:
        "La chambre de l’instruction doit statuer dans les 20 jours de sa saisine (art. 140 al. 3 C.P.P.).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Mainlevée (chambre de l’instruction)",
    question:
        "Lorsque la chambre de l’instruction est saisie d’une demande de mainlevée du contrôle judiciaire, elle peut :",
    options: [
      "Uniquement confirmer le contrôle judiciaire",
      "Confirmer, modifier ou ordonner la mainlevée du contrôle judiciaire",
      "Uniquement ordonner la détention provisoire",
    ],
    answer:
        "Confirmer, modifier ou ordonner la mainlevée du contrôle judiciaire",
    explanation:
        "La chambre de l’instruction dispose d’un pouvoir d’appréciation complet sur la mesure de contrôle judiciaire.",
    difficulty: "Moyen",
  ),

  // JURIDICTIONS DE JUGEMENT
  QuizQuestion(
    category: "Contrôle judiciaire — Rôle des juridictions de jugement",
    question:
        "Les juridictions de jugement peuvent-elles modifier ou lever un contrôle judiciaire ordonné pendant l’instruction ?",
    options: [
      "Oui, lorsqu’elles sont saisies de l’affaire",
      "Non, seul le juge d’instruction peut le faire",
      "Oui, mais uniquement avec l’accord de la victime",
    ],
    answer: "Oui, lorsqu’elles sont saisies de l’affaire",
    explanation:
        "Une fois saisies, elles disposent des mêmes pouvoirs que le juge d’instruction en matière de maintien, modification ou mainlevée.",
    difficulty: "Moyen",
  ),

  // OBLIGATIONS — PRÉCISIONS
  QuizQuestion(
    category: "Contrôle judiciaire — Obligations (personnes physiques)",
    question:
        "Parmi les propositions suivantes, laquelle correspond à une obligation de contrôle judiciaire prévue par l’article 138 C.P.P. ?",
    options: [
      "Verser une caution ou un cautionnement",
      "Exécuter des travaux d’intérêt général",
      "Signer un contrat de travail avec l’État",
    ],
    answer: "Verser une caution ou un cautionnement",
    explanation:
        "Le cautionnement fait partie des obligations possibles du contrôle judiciaire (article 138).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Obligations (personnes physiques)",
    question:
        "Parmi ces obligations, laquelle peut être imposée dans le cadre du contrôle judiciaire ?",
    options: [
      "Interdiction de rencontrer certaines personnes",
      "Obligation de porter un uniforme",
      "Obligation de dormir au commissariat",
    ],
    answer: "Interdiction de rencontrer certaines personnes",
    explanation:
        "Le juge peut interdire tout contact avec certaines personnes, notamment les co-mis en examen ou la victime.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Obligations (personnes morales)",
    question:
        "Dans le cadre de l’article 706-45 C.P.P., une personne morale placée sous contrôle judiciaire peut être notamment tenue :",
    options: [
      "De fournir un cautionnement",
      "D’exécuter des TIG",
      "De fermer temporairement certains établissements",
    ],
    answer: "De fermer temporairement certains établissements",
    explanation:
        "Les obligations peuvent porter sur l’activité même de la personne morale (fermeture, interdiction d’exercer, etc.).",
    difficulty: "Moyen",
  ),

  // ORGANISATION & SURVEILLANCE (ART. 141-4)
  QuizQuestion(
    category: "Contrôle judiciaire — Surveillance (art. 141-4)",
    question:
        "Selon l’article 141-4 du C.P.P., qui peut retenir une personne sous contrôle judiciaire en cas de soupçon de manquement ?",
    options: [
      "Uniquement le juge d’instruction",
      "Un officier de police judiciaire, sur instruction du juge d’instruction",
      "Un agent de police municipale",
    ],
    answer:
        "Un officier de police judiciaire, sur instruction du juge d’instruction",
    explanation:
        "Les services de police ou de gendarmerie, sur instruction du juge, peuvent procéder à une mesure de retenue spécifique.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Surveillance (art. 141-4)",
    question: "La retenue prévue par l’article 141-4 C.P.P. ne peut excéder :",
    options: ["24 heures", "48 heures", "72 heures"],
    answer: "24 heures",
    explanation:
        "La personne peut être retenue au maximum 24 heures, dans des conditions proches de la garde à vue, avec des garanties spécifiques.",
    difficulty: "Moyen",
  ),

  // DROITS DE LA PERSONNE RETENUE
  QuizQuestion(
    category: "Contrôle judiciaire — Droits de la personne retenue",
    question:
        "Parmi ces droits, lequel est expressément reconnu à la personne retenue en application de l’article 141-4 C.P.P. ?",
    options: [
      "Le droit d’être examinée par un médecin",
      "Le droit d’exiger immédiatement sa remise en liberté",
      "Le droit de refuser toute audition sans conséquence",
    ],
    answer: "Le droit d’être examinée par un médecin",
    explanation:
        "Le texte renvoie notamment aux garanties de l’article 63-3 C.P.P. : droit à un médecin, à un avocat, etc.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Droits de la personne retenue",
    question:
        "La personne retenue au titre de l’article 141-4 C.P.P. bénéficie notamment :",
    options: [
      "Du droit d’être assistée par un avocat",
      "Uniquement du droit de prévenir son employeur",
      "D’aucun droit spécifique",
    ],
    answer: "Du droit d’être assistée par un avocat",
    explanation:
        "Les droits prévus pour la garde à vue (avocat, médecin, interprète, etc.) sont également applicables.",
    difficulty: "Moyen",
  ),

  // FIN / TRANSFORMATION / RÉVOCATION
  QuizQuestion(
    category: "Contrôle judiciaire — Transformation en détention",
    question:
        "Lorsque la personne ne respecte pas ses obligations de contrôle judiciaire, le juge d’instruction peut :",
    options: [
      "Saisir le juge des libertés et de la détention pour un placement en détention provisoire",
      "Simplement adresser un avertissement écrit",
      "Prononcer directement une peine d’emprisonnement définitive",
    ],
    answer:
        "Saisir le juge des libertés et de la détention pour un placement en détention provisoire",
    explanation:
        "Le manquement peut justifier une révocation du contrôle judiciaire et un placement en détention (art. 141-2 C.P.P.).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Fin de la mesure",
    question:
        "En matière criminelle, l’ordonnance de mise en accusation devant la cour d’assises :",
    options: [
      "Ne met pas fin de plein droit au contrôle judiciaire",
      "Met automatiquement fin au contrôle judiciaire",
      "Transforme le contrôle judiciaire en détention provisoire",
    ],
    answer: "Ne met pas fin de plein droit au contrôle judiciaire",
    explanation:
        "Le texte précise que, contrairement à la matière correctionnelle, l’ordonnance de mise en accusation ne met pas fin automatiquement à la mesure.",
    difficulty: "Moyen",
  ),

  // TABLEAU SYNTHÉTIQUE (PAGE FINALE)
  QuizQuestion(
    category: "Contrôle judiciaire — Tableau récapitulatif",
    question:
        "Selon le tableau de synthèse, le juge des libertés et de la détention peut prononcer le contrôle judiciaire :",
    options: [
      "Lorsqu’il est saisi par le juge d’instruction d’une demande de détention provisoire",
      "Uniquement lors de l’audience de jugement",
      "Uniquement en appel d’une décision du tribunal",
    ],
    answer:
        "Lorsqu’il est saisi par le juge d’instruction d’une demande de détention provisoire",
    explanation:
        "Le JLD statue sur la détention provisoire et peut, à la place, prononcer un contrôle judiciaire.",
    difficulty: "Moyen",
  ),

  // =====================================================
  // NIVEAU 3 — DIFFICILE
  // =====================================================

  // CAS PRATIQUES & ARTICULATIONS
  QuizQuestion(
    category: "Contrôle judiciaire — Cas pratique",
    question:
        "Une personne mise en examen pour un délit correctionnel ne respecte plus l’interdiction de contacter la victime. Sur quel fondement juridique le juge d’instruction peut-il demander sa retenue par un officier de police judiciaire ?",
    options: [
      "Article 141-4 du C.P.P.",
      "Article 64 du C.P.P.",
      "Article 137 du C.P.P.",
    ],
    answer: "Article 141-4 du C.P.P.",
    explanation:
        "L’article 141-4 prévoit la retenue d’une personne soumise au contrôle judiciaire lorsqu’il existe des raisons plausibles de soupçonner un manquement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Cas pratique",
    question:
        "Durant la retenue prévue par l’article 141-4, la personne est interrogée. Quel droit doit impérativement lui être notifié, à peine de nullité potentielle ?",
    options: [
      "Le droit de consulter son dossier d’instruction",
      "Le droit d’être assistée par un avocat",
      "Le droit de choisir la juridiction compétente",
    ],
    answer: "Le droit d’être assistée par un avocat",
    explanation:
        "Les droits attachés à la garde à vue s’appliquent, dont l’assistance d’un avocat (articles 63-3-1 et 63-4-3 C.P.P.).",
    difficulty: "Difficile",
  ),

  // ARTICULATION AVEC LA DÉTENTION PROVISOIRE
  QuizQuestion(
    category: "Contrôle judiciaire — Articulation avec la détention provisoire",
    question:
        "Selon l’article 137 C.P.P., dans quel cas le juge peut-il substituer une détention provisoire au contrôle judiciaire ?",
    options: [
      "Lorsque la personne demande la fin du contrôle judiciaire",
      "Lorsque le contrôle judiciaire ne suffit plus à assurer le bon déroulement de l’information ou la sécurité publique",
      "Lorsque la victime le sollicite",
    ],
    answer:
        "Lorsque le contrôle judiciaire ne suffit plus à assurer le bon déroulement de l’information ou la sécurité publique",
    explanation:
        "La détention provisoire est une mesure exceptionnelle, justifiée lorsque le contrôle judiciaire apparaît insuffisant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Articulation avec la détention provisoire",
    question:
        "En cas de révocation du contrôle judiciaire et de placement en détention provisoire, qui décide de cette détention ?",
    options: [
      "Le juge d’instruction seul",
      "Le juge des libertés et de la détention, saisi par le juge d’instruction",
      "Le procureur de la République seul",
    ],
    answer:
        "Le juge des libertés et de la détention, saisi par le juge d’instruction",
    explanation:
        "Le juge d’instruction saisit le JLD, qui statue sur la détention provisoire (sauf cas de mandat d’arrêt en cours d’instruction selon les textes applicables).",
    difficulty: "Difficile",
  ),

  // PERSONNES MORALES — DÉTAILS
  QuizQuestion(
    category: "Contrôle judiciaire — Personnes morales",
    question:
        "L’article 706-45 C.P.P. permet d’imposer à une personne morale des obligations. Laquelle de ces mesures en fait partie ?",
    options: [
      "L’interdiction d’émettre des factures",
      "L’interdiction d’exercer certaines activités professionnelles",
      "L’obligation d’embaucher du personnel judiciaire",
    ],
    answer: "L’interdiction d’exercer certaines activités professionnelles",
    explanation:
        "Le contrôle judiciaire des personnes morales peut porter sur l’activité même, comme l’interdiction provisoire d’exercer.",
    difficulty: "Difficile",
  ),

  // CHAMBRE DE L’INSTRUCTION — DÉTAILS
  QuizQuestion(
    category: "Contrôle judiciaire — Chambre de l’instruction",
    question:
        "Lorsque la chambre de l’instruction statue sur l’appel d’une ordonnance de placement sous contrôle judiciaire, elle peut :",
    options: [
      "Uniquement confirmer le contrôle judiciaire",
      "Confirmer, infirmer ou substituer une autre mesure (dont la détention provisoire)",
      "Uniquement ordonner la mainlevée du contrôle judiciaire",
    ],
    answer:
        "Confirmer, infirmer ou substituer une autre mesure (dont la détention provisoire)",
    explanation:
        "Elle dispose des pouvoirs les plus étendus pour réexaminer la situation du mis en examen.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Chambre de l’instruction",
    question:
        "En cas de carence du juge d’instruction (absence de réponse dans le délai de 5 jours à la demande de mainlevée), la chambre de l’instruction :",
    options: [
      "Est automatiquement dessaisie",
      "Est saisie d’office par le procureur de la République",
      "Peut être saisie par la personne mise en examen ou son avocat",
    ],
    answer: "Peut être saisie par la personne mise en examen ou son avocat",
    explanation:
        "Le mécanisme de carence permet à la personne de saisir la chambre de l’instruction si le juge d’instruction ne statue pas dans les délais.",
    difficulty: "Difficile",
  ),

  // GARANTIES PROCÉDURALES — RÉSULTAT DE LA RETENUE
  QuizQuestion(
    category: "Contrôle judiciaire — Issue de la retenue (art. 141-4)",
    question:
        "À l’issue de la retenue prévue par l’article 141-4 C.P.P., le juge d’instruction peut :",
    options: [
      "Ordre la mise en liberté pure et simple sans suite",
      "Saisir le juge des libertés et de la détention en vue d’une détention provisoire",
      "Prononcer directement une condamnation",
    ],
    answer:
        "Saisir le juge des libertés et de la détention en vue d’une détention provisoire",
    explanation:
        "La retenue est une mesure temporaire qui peut déboucher sur une demande de détention provisoire ou sur la poursuite du contrôle judiciaire.",
    difficulty: "Difficile",
  ),

  // DROITS DURANT LA RETENUE — PRÉCISIONS
  QuizQuestion(
    category: "Contrôle judiciaire — Droits procéduraux",
    question:
        "Pendant la retenue liée au non-respect du contrôle judiciaire, le droit de garder le silence est-il applicable ?",
    options: [
      "Oui, le mis en examen peut garder le silence durant les auditions",
      "Non, il est obligé de répondre",
      "Uniquement s’il en fait la demande écrite",
    ],
    answer: "Oui, le mis en examen peut garder le silence durant les auditions",
    explanation:
        "Comme en garde à vue, il peut choisir de faire des déclarations, de répondre ou de se taire.",
    difficulty: "Difficile",
  ),

  // NOTE / PARTICULARITÉS
  QuizQuestion(
    category: "Contrôle judiciaire — Note explicative",
    question:
        "La note figurant en bas de page précise que la procédure de retenue est également applicable :",
    options: [
      "Lorsque la personne se soustrait au contrôle judiciaire et est renvoyée devant la juridiction de jugement",
      "Uniquement lorsque la personne est encore en garde à vue",
      "Uniquement aux mineurs",
    ],
    answer:
        "Lorsque la personne se soustrait au contrôle judiciaire et est renvoyée devant la juridiction de jugement",
    explanation:
        "La note étend le dispositif de retenue aux hypothèses où la personne ne respecte plus le contrôle judiciaire après renvoi devant la juridiction.",
    difficulty: "Difficile",
  ),

  // SYNTHÈSE : QUI FAIT QUOI ?
  QuizQuestion(
    category: "Contrôle judiciaire — Synthèse des compétences",
    question:
        "Parmi ces propositions, laquelle décrit correctement la répartition des compétences pour le contrôle judiciaire ?",
    options: [
      "Le juge d’instruction ordonne, le JLD ne peut que contrôler la légalité",
      "Le juge d’instruction, le JLD, la chambre de l’instruction et les juridictions de jugement peuvent tour à tour ordonner, modifier ou lever le contrôle judiciaire, selon qu’ils sont saisis de la procédure",
      "Seule la chambre de l’instruction peut lever le contrôle judiciaire",
    ],
    answer:
        "Le juge d’instruction, le JLD, la chambre de l’instruction et les juridictions de jugement peuvent tour à tour ordonner, modifier ou lever le contrôle judiciaire, selon qu’ils sont saisis de la procédure",
    explanation:
        "C’est une mesure qui suit le dossier tout au long de la chaîne judiciaire, avec des compétences réparties entre plusieurs magistrats.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Contrôle judiciaire — Cas avancé",
    question:
        "Une personne mise en examen demande la mainlevée de son contrôle judiciaire. Le juge d’instruction rejette sa demande. Quel recours a-t-elle ?",
    options: [
      "Elle peut former un appel devant la chambre de l’instruction",
      "Elle ne dispose d’aucun recours",
      "Elle doit saisir directement la Cour de cassation",
    ],
    answer: "Elle peut former un appel devant la chambre de l’instruction",
    explanation:
        "La décision refusant la mainlevée peut être contestée devant la chambre de l’instruction, qui réexaminera la nécessité de la mesure.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizControleJudiciairePage extends StatefulWidget {
  static const String routeName =
      '/gpx/procedure_penale/quiz/controle_judiciaire';
  final String uid;
  final String email;

  const QuizControleJudiciairePage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizControleJudiciairePage> createState() =>
      _QuizControleJudiciairePageState();
}

class _QuizControleJudiciairePageState extends State<QuizControleJudiciairePage>
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
        ? questionsControleJudiciaire
        : questionsControleJudiciaire
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
            'module_name': 'Procédure Pénale',
            'quiz_name': 'Contrôle Judiciaire',
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
      await _sb.from('quiz_controle_judiciaire').insert({
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
      debugPrint('❌ quiz_controle_judiciaire insert failed: $e');
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
