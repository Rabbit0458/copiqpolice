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
final List<QuizQuestion> questionsEnquetePrelim = [
  // ===================== NIVEAU FACILE =====================
  const QuizQuestion(
    category: "Généralités — Saisie comptes bancaires",
    question:
        "Dans le cadre de l’enquête préliminaire, la saisie des comptes bancaires sert principalement à :",
    options: [
      "Payer immédiatement les victimes",
      "Préserver rapidement des sommes d’argent avant l’issue de la procédure",
      "Clore automatiquement le dossier pénal",
    ],
    answer:
        "Préserver rapidement des sommes d’argent avant l’issue de la procédure",
    explanation:
        "La saisie des comptes bancaires permet de préserver des sommes d’argent, y compris numériques, pour éviter leur disparition avant la fin de la procédure.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Généralités — Nature",
    question: "L’enquête préliminaire est :",
    options: [
      "Une enquête simplement tolérée par la loi",
      "Une enquête légalisée par le Code de procédure pénale",
      "Une enquête secrète non prévue par les textes",
    ],
    answer: "Une enquête légalisée par le Code de procédure pénale",
    explanation:
        "Elle est prévue aux articles 75 à 78 du C.P.P., ce qui en fait une enquête légale et encadrée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Objectif — Procureur",
    question: "L’objectif principal de l’enquête préliminaire est :",
    options: [
      "Arrêter immédiatement l’auteur de l’infraction",
      "Réunir les premiers renseignements pour éclairer le procureur sur l’opportunité des poursuites",
      "Obliger le mis en cause à avouer",
    ],
    answer:
        "Réunir les premiers renseignements pour éclairer le procureur sur l’opportunité des poursuites",
    explanation:
        "Le texte indique que l’enquête préliminaire vise à recueillir les premiers renseignements afin que le procureur décide d’éventuelles poursuites.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Acteurs — Police judiciaire",
    question: "Qui diligente l’enquête préliminaire ?",
    options: ["La police judiciaire", "Le maire", "Le juge civil"],
    answer: "La police judiciaire",
    explanation:
        "Elle est menée par les officiers et agents de police judiciaire, soit à la demande du parquet, soit d’initiative.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Initiative — Déclenchement",
    question: "Une enquête préliminaire peut être ouverte :",
    options: [
      "Uniquement sur décision du procureur",
      "Par la police judiciaire d’initiative ou sur demande du procureur",
      "Uniquement par un juge d’instruction",
    ],
    answer: "Par la police judiciaire d’initiative ou sur demande du procureur",
    explanation:
        "L’enquête peut être ouverte d’initiative par la police judiciaire ou sur instruction du parquet.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Libertés — Risques",
    question:
        "Pourquoi l’enquête préliminaire doit-elle être strictement encadrée ?",
    options: [
      "Parce qu’elle n’a aucune utilité sans cadre légal",
      "Parce qu’elle peut porter atteinte aux libertés individuelles",
      "Parce qu’elle se déroule uniquement au domicile des suspects",
    ],
    answer: "Parce qu’elle peut porter atteinte aux libertés individuelles",
    explanation:
        "Le texte précise que malgré l’absence habituelle de coercition, elle comporte des risques pour les libertés et nécessite un encadrement strict.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — Champ",
    question:
        "Quelles infractions peuvent faire l’objet d’une enquête préliminaire ?",
    options: [
      "Les seuls délits",
      "Les crimes, les délits et les contraventions",
      "Uniquement les crimes",
    ],
    answer: "Les crimes, les délits et les contraventions",
    explanation:
        "Le texte affirme que toutes les infractions, quelle que soit leur nature, peuvent être traitées en enquête préliminaire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — Flagrance",
    question:
        "Peut-on traiter une infraction flagrante en enquête préliminaire ?",
    options: [
      "Oui, c’est possible selon l’appréciation de l’autorité judiciaire",
      "Non, jamais",
      "Uniquement les contraventions",
    ],
    answer: "Oui, c’est possible selon l’appréciation de l’autorité judiciaire",
    explanation:
        "Le texte précise qu’il est possible de traiter des crimes ou délits flagrants en enquête préliminaire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Limitations — Information judiciaire",
    question:
        "Quand la police judiciaire doit-elle cesser d’agir en enquête préliminaire ?",
    options: [
      "Lorsque le maire le demande",
      "Lorsque qu’une information judiciaire est ouverte et connue d’elle",
      "Lorsque la victime refuse de coopérer",
    ],
    answer:
        "Lorsque qu’une information judiciaire est ouverte et connue d’elle",
    explanation:
        "Dès que l’O.P.J. ou l’A.P.J. sait qu’une information est ouverte, il ne peut plus agir qu'en exécution des délégations du magistrat instructeur.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Personnes — Principe",
    question:
        "Selon le texte, qui peut être impliqué dans une enquête préliminaire ?",
    options: [
      "Uniquement les citoyens français",
      "Toute personne résidant sur le territoire français",
      "Uniquement les personnes fichées",
    ],
    answer: "Toute personne résidant sur le territoire français",
    explanation:
        "Le texte pose ce principe général, sous réserve de statuts protecteurs et immunités.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU FACILE =====================
  const QuizQuestion(
    category: "Généralités — Fondement",
    question:
        "Quels articles du Code de procédure pénale encadrent l’enquête préliminaire ?",
    options: ["Articles 60 à 63", "Articles 75 à 78", "Articles 90 à 95"],
    answer: "Articles 75 à 78",
    explanation:
        "Le texte précise que l’enquête préliminaire est prévue aux articles 75 à 78 du C.P.P.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Nature — Caractère",
    question: "L’enquête préliminaire est décrite comme une enquête :",
    options: [
      "Non prévue par la loi",
      "Légalisée par le C.P.P.",
      "Strictement réservée aux crimes",
    ],
    answer: "Légalisée par le C.P.P.",
    explanation: "Le texte insiste sur son caractère légalement organisé.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Objectif — Renseignement",
    question: "L’enquête préliminaire permet d’obtenir :",
    options: [
      "Des condamnations immédiates",
      "Les premiers renseignements sur une infraction",
      "Uniquement la localisation des suspects",
    ],
    answer: "Les premiers renseignements sur une infraction",
    explanation: "Elle sert à éclairer le procureur sur la suite à donner.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Finalité — Procureur",
    question:
        "La décision que le procureur prend à l’issue de l’enquête préliminaire concerne :",
    options: [
      "La constitution d’un dossier civil",
      "L’opportunité des poursuites",
      "La nomination d’un avocat obligatoire",
    ],
    answer: "L’opportunité des poursuites",
    explanation:
        "L’enquête préliminaire détermine si le parquet poursuit ou non.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Acteurs — PJ",
    question: "Qui met en œuvre l’enquête préliminaire ?",
    options: ["La police judiciaire", "Les pompiers", "Le préfet"],
    answer: "La police judiciaire",
    explanation: "Elle est menée par les O.P.J. et A.P.J.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Initiative — Parquet",
    question: "L’enquête préliminaire peut être diligentée :",
    options: [
      "Uniquement par un juge d’instruction",
      "À la demande du procureur ou d’initiative par la police",
      "Uniquement en cas de crime",
    ],
    answer: "À la demande du procureur ou d’initiative par la police",
    explanation: "Le texte décrit ces deux modes de déclenchement.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Libertés — Besoin d’encadrement",
    question:
        "Pourquoi l’enquête préliminaire nécessite-t-elle un encadrement strict ?",
    options: [
      "Parce qu’elle est totalement secrète",
      "Parce qu’elle comporte des risques pour les libertés individuelles",
      "Parce qu’elle est rarement utilisée",
    ],
    answer:
        "Parce qu’elle comporte des risques pour les libertés individuelles",
    explanation:
        "Même sans coercition, des atteintes aux libertés sont possibles.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — Portée",
    question: "L’enquête préliminaire peut porter sur :",
    options: [
      "Uniquement les délits financiers",
      "Crimes, délits et contraventions",
      "Exclusivement les infractions routières",
    ],
    answer: "Crimes, délits et contraventions",
    explanation: "Le texte est clair : elle couvre toute nature d'infraction.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Flagrance — Alternative",
    question:
        "Pourquoi un délit flagrant peut-il être traité en enquête préliminaire ?",
    options: [
      "Parce que c’est obligatoire",
      "Parce que c’est laissé à l’appréciation de l’autorité judiciaire",
      "Parce que la flagrance n’existe plus",
    ],
    answer: "Parce que c’est laissé à l’appréciation de l’autorité judiciaire",
    explanation:
        "Le choix du cadre procédural appartient à l’autorité judiciaire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Information judiciaire — Connaissance",
    question:
        "Les actes d’enquête préliminaire deviennent irréguliers lorsque :",
    options: [
      "Un avocat est présent",
      "Les enquêteurs apprennent qu’une information judiciaire a été ouverte",
      "La victime retire sa plainte",
    ],
    answer:
        "Les enquêteurs apprennent qu’une information judiciaire a été ouverte",
    explanation: "Avant cette connaissance, les actes restent réguliers.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  const QuizQuestion(
    category: "Validité — Rétroactivité",
    question:
        "Le passage à l’information judiciaire invalide-t-il rétroactivement les actes d’enquête préliminaire ?",
    options: [
      "Oui, dans tous les cas",
      "Non, seulement si l’enquêteur en avait connaissance",
      "Oui, mais uniquement pour les crimes",
    ],
    answer: "Non, seulement si l’enquêteur en avait connaissance",
    explanation:
        "Les actes restent valables tant que l’O.P.J. n’avait pas connaissance de l’ouverture de l’information.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Personnes — Résidence",
    question:
        "Selon le texte, qui peut être concerné par une enquête préliminaire ?",
    options: [
      "Toute personne résidant sur le territoire français",
      "Uniquement les personnes de nationalité française",
      "Uniquement les personnes ayant un casier judiciaire",
    ],
    answer: "Toute personne résidant sur le territoire français",
    explanation:
        "La compétence s’applique à toute personne résidant en France.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Immunités — Diplomates",
    question:
        "Quelle caractéristique limite les mesures d’enquête envers les agents diplomatiques ?",
    options: [
      "Leur domicile est privé",
      "Ils bénéficient d’immunités internationales",
      "Ils sont protégés par le secret professionnel",
    ],
    answer: "Ils bénéficient d’immunités internationales",
    explanation:
        "Le texte indique qu’ils jouissent d’un statut protégé par le droit international.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Statut — Président",
    question: "Le Président de la République est :",
    options: [
      "Responsable pénalement des actes accomplis dans ses fonctions",
      "Irresponsable pour les actes liés à ses fonctions et inviolable durant son mandat",
      "Justiciable comme un simple citoyen pour tout acte",
    ],
    answer:
        "Irresponsable pour les actes liés à ses fonctions et inviolable durant son mandat",
    explanation: "Le texte rappelle ce régime constitutionnel.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Personnes — Règles spéciales",
    question: "Les agents consulaires bénéficient :",
    options: [
      "D’une immunité absolue",
      "D’un privilège d’exemption d’arrestation sauf crime flagrant",
      "D’un droit d’immunité uniquement dans leur consulat",
    ],
    answer: "D’un privilège d’exemption d’arrestation sauf crime flagrant",
    explanation:
        "Le texte mentionne ce privilège accordé par les conventions bilatérales.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Parlementaires — Suspension",
    question:
        "En enquête préliminaire, les poursuites contre un parlementaire peuvent être :",
    options: [
      "Interdites",
      "Suspendues par l’assemblée durant la session",
      "Conduites uniquement la nuit",
    ],
    answer: "Suspendues par l’assemblée durant la session",
    explanation: "Le texte rappelle ce pouvoir des assemblées.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Parlementaires — Mesures coercitives",
    question:
        "Avant d’appliquer une garde à vue à un parlementaire, il faut obtenir :",
    options: [
      "L’accord du procureur général",
      "L’autorisation du bureau de son assemblée",
      "L’accord du Président de la République",
    ],
    answer: "L’autorisation du bureau de son assemblée",
    explanation: "C’est une condition légale incontournable.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Lieux — Domicile",
    question:
        "L’introduction dans un domicile en enquête préliminaire est en principe subordonnée à :",
    options: [
      "Un mandat écrit du procureur",
      "L’accord préalable du maître des lieux",
      "Une décision collégiale du parquet",
    ],
    answer: "L’accord préalable du maître des lieux",
    explanation: "Principe rappelé dans le texte.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Lieux — Consentement",
    question:
        "L’assentiment pour une perquisition en enquête préliminaire doit être :",
    options: ["Uniquement oral", "Exprès et écrit", "Silencieux mais présumé"],
    answer: "Exprès et écrit",
    explanation: "Cet assentiment doit être clair et matérialisé par écrit.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Contrôle — C.J.penal",
    question:
        "Le recours au J.L.D. pour une perquisition en enquête préliminaire intervient :",
    options: [
      "Uniquement pour les contraventions",
      "Pour les crimes et délits punis d’au moins 3 ans d’emprisonnement",
      "Pour tous les vols simples",
    ],
    answer: "Pour les crimes et délits punis d’au moins 3 ans d’emprisonnement",
    explanation: "Référence à l’article 76 alinéa 4 du C.P.P.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  const QuizQuestion(
    category: "Information judiciaire — Effet",
    question:
        "Quel principe fait que la police judiciaire cesse d’agir librement en enquête préliminaire après l’ouverture d’une information judiciaire ?",
    options: [
      "Le principe de dessaisissement automatique",
      "Le principe selon lequel elle n'agit plus qu’en exécution des délégations du magistrat instructeur",
      "Le principe du contradictoire immédiat",
    ],
    answer:
        "Le principe selon lequel elle n'agit plus qu’en exécution des délégations du magistrat instructeur",
    explanation: "Ce principe découle de l’article 14 alinéa 2 du C.P.P.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Immunités — Diplomatie",
    question:
        "Les immunités des agents diplomatiques en enquête préliminaire ont pour origine :",
    options: [
      "Les traditions européennes",
      "Le droit international",
      "Le C.P.P. uniquement",
    ],
    answer: "Le droit international",
    explanation:
        "Le texte précise que leur statut est protégé par le droit international.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Parlementaires — Fondement",
    question:
        "Le régime dérogatoire applicable aux parlementaires en enquête préliminaire vise à protéger :",
    options: [
      "La campagne électorale",
      "La séparation des pouvoirs et la représentation nationale",
      "Le secret défense",
    ],
    answer: "La séparation des pouvoirs et la représentation nationale",
    explanation: "Le texte précise cette justification du régime dérogatoire.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Lieux — Gravité",
    question:
        "Pourquoi une perquisition sans assentiment peut-elle être autorisée en enquête préliminaire ?",
    options: [
      "Pour lutter contre les infractions les plus graves",
      "Pour éviter de perdre du temps avec l’occupant",
      "Parce qu’elle est plus simple qu’une perquisition classique",
    ],
    answer: "Pour lutter contre les infractions les plus graves",
    explanation:
        "Les infractions visées incluent celles punies d’au moins 3 ans ou celles relevant du 706-73 C.P.P.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "JLD — Rôle",
    question:
        "Le rôle du J.L.D. dans les perquisitions sans assentiment consiste à :",
    options: [
      "Remplacer le procureur",
      "Autoriser ou non une atteinte grave à la vie privée",
      "Procéder lui-même à la perquisition",
    ],
    answer: "Autoriser ou non une atteinte grave à la vie privée",
    explanation:
        "Il constitue une garantie essentielle lors des perquisitions sans consentement.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Lieux — Vie privée",
    question:
        "Quelle raison justifie la protection renforcée du domicile en enquête préliminaire ?",
    options: [
      "Il s’agit d’un lieu public",
      "Il constitue un espace privilégié de la vie privée",
      "Il est toujours inconnu des enquêteurs",
    ],
    answer: "Il constitue un espace privilégié de la vie privée",
    explanation: "Le texte rappelle cette justification.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Perquisition — Formalisme",
    question:
        "Pourquoi l’assentiment écrit doit-il être annexé à la procédure ?",
    options: [
      "Pour prouver le respect des conditions légales",
      "Pour être envoyé au juge d’instruction",
      "Pour remplacer un procès-verbal",
    ],
    answer: "Pour prouver le respect des conditions légales",
    explanation: "Cela sécurise juridiquement la perquisition.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Infractions graves — 706-73",
    question:
        "Les perquisitions sans assentiment en enquête préliminaire peuvent viser les infractions listées dans :",
    options: [
      "L’article 78-2 du C.P.P.",
      "L’article 706-73 du C.P.P.",
      "Le Code civil",
    ],
    answer: "L’article 706-73 du C.P.P.",
    explanation: "Le texte cite explicitement cet article.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Procédure — Garanties",
    question:
        "L'intervention du J.L.D. dans les perquisitions sans consentement représente :",
    options: [
      "Une simple formalité administrative",
      "Une garantie importante pour les libertés individuelles",
      "Une validation automatique",
    ],
    answer: "Une garantie importante pour les libertés individuelles",
    explanation: "Le texte insiste sur cette protection essentielle.",
    difficulty: "Difficile",
  ),

  // ===================== BLOC 3 — NIVEAU FACILE =====================
  const QuizQuestion(
    category: "Généralités — Qualification",
    question:
        "Comment l’enquête préliminaire est-elle classiquement caractérisée ?",
    options: [
      "Par un usage systématique de la coercition",
      "Par l’absence de coercition",
      "Par l’absence totale de cadre légal",
    ],
    answer: "Par l’absence de coercition",
    explanation:
        "Le texte indique que l’enquête préliminaire est classiquement caractérisée par l’absence de coercition.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Fréquence",
    question: "Dans la pratique, l’enquête préliminaire est :",
    options: [
      "Très rarement utilisée",
      "Très fréquemment mise en œuvre",
      "Uniquement utilisée pour les affaires politiques",
    ],
    answer: "Très fréquemment mise en œuvre",
    explanation:
        "Le texte souligne qu’elle est très fréquemment mobilisée dans la pratique.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Objectif — Rôle du procureur",
    question: "L’enquête préliminaire a pour but d’aider le procureur à :",
    options: [
      "Fixer le montant des dommages et intérêts civils",
      "Prendre une décision sur l’opportunité des poursuites",
      "Nommer un juge d’instruction",
    ],
    answer: "Prendre une décision sur l’opportunité des poursuites",
    explanation:
        "Elle sert à éclairer sa décision sur le déclenchement ou non des poursuites.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Acteurs — Types d’enquêteurs",
    question:
        "Quels membres de la police judiciaire peuvent diligenter une enquête préliminaire ?",
    options: [
      "Uniquement les agents de police judiciaire (A.P.J.)",
      "Uniquement les officiers de police judiciaire (O.P.J.)",
      "Les officiers et les agents de police judiciaire",
    ],
    answer: "Les officiers et les agents de police judiciaire",
    explanation: "Le texte mentionne explicitement les O.P.J. et les A.P.J.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infractions — Choix du cadre",
    question:
        "Le choix entre enquête de flagrance et enquête préliminaire pour un crime flagrant relève :",
    options: [
      "Du libre choix de la victime",
      "De l’appréciation de l’autorité judiciaire",
      "D’un barème automatique fixé par le C.P.P.",
    ],
    answer: "De l’appréciation de l’autorité judiciaire",
    explanation:
        "Le texte précise que le choix du cadre procédural appartient à l’autorité judiciaire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Libertés — Risque",
    question:
        "Que rappelle le texte à propos des libertés individuelles en enquête préliminaire ?",
    options: [
      "Qu’elles ne sont jamais menacées",
      "Qu’elles peuvent être mises en cause si les règles ne sont pas respectées",
      "Qu’elles sont suspendues pendant toute l’enquête",
    ],
    answer:
        "Qu’elles peuvent être mises en cause si les règles ne sont pas respectées",
    explanation:
        "Le texte insiste sur le risque pour les libertés en cas de non-respect des règles procédurales.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Personnes — Champ personnel",
    question:
        "Le principe posé en matière de personnes concernées par l’enquête préliminaire est :",
    options: [
      "Une compétence personnelle limitée aux fonctionnaires",
      "Une compétence personnelle large",
      "Une compétence limitée aux étrangers",
    ],
    answer: "Une compétence personnelle large",
    explanation:
        "Le texte parle d’un principe de compétence personnelle large, concernant toute personne résidant en France.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Personnes — Exceptions",
    question:
        "Les exceptions au principe de compétence personnelle large sont principalement liées :",
    options: [
      "Au niveau de revenu des personnes",
      "À certains statuts protecteurs ou immunités",
      "Au lieu où l’infraction a été commise",
    ],
    answer: "À certains statuts protecteurs ou immunités",
    explanation:
        "Le texte mentionne que les exceptions tiennent à des statuts protecteurs ou immunités.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Lieux — Notion de lieu privé",
    question:
        "En enquête préliminaire, l’introduction dans un lieu privé, notamment un domicile, suppose :",
    options: [
      "Une réquisition écrite de la mairie",
      "L’accord de la personne qui en a la jouissance",
      "Un mandat de dépôt préalable",
    ],
    answer: "L’accord de la personne qui en a la jouissance",
    explanation:
        "Le texte indique que l’introduction dans un lieu privé est en principe subordonnée à cet accord.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Objet",
    question:
        "Les perquisitions en enquête préliminaire visent notamment à découvrir :",
    options: [
      "Uniquement des armes",
      "Des documents, objets ou indices utiles à l’enquête",
      "Uniquement des stupéfiants",
    ],
    answer: "Des documents, objets ou indices utiles à l’enquête",
    explanation:
        "Le texte précise que les perquisitions visent des documents, objets ou indices susceptibles d’intéresser l’enquête.",
    difficulty: "Facile",
  ),

  // ===================== BLOC 3 — NIVEAU INTERMÉDIAIRE =====================
  const QuizQuestion(
    category: "Infractions — Confiscation",
    question:
        "Les perquisitions peuvent viser des biens dont la confiscation est prévue par :",
    options: [
      "L’article 131-21 du Code pénal",
      "L’article 78-2 du C.P.P.",
      "L’article 16 du C.P.P.",
    ],
    answer: "L’article 131-21 du Code pénal",
    explanation:
        "Le texte mentionne explicitement les biens dont la confiscation est prévue à l’article 131-21 du code pénal.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Consentement",
    question:
        "En principe, pour perquisitionner un lieu privé en enquête préliminaire, il faut :",
    options: [
      "L’assentiment exprès et écrit de la personne concernée",
      "Un simple appel téléphonique du procureur",
      "La signature d’un juge d’instruction",
    ],
    answer: "L’assentiment exprès et écrit de la personne concernée",
    explanation:
        "Le texte impose cet assentiment exprès et écrit pour la perquisition en enquête préliminaire.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Forme de l’assentiment",
    question:
        "Selon le texte, l’assentiment écrit exigé pour une perquisition en enquête préliminaire doit être :",
    options: [
      "Vague, mais daté",
      "Clair, non équivoque et signé",
      "Toujours rédigé par l’avocat",
    ],
    answer: "Clair, non équivoque et signé",
    explanation:
        "Il doit être explicite, non ambigu et signé par la personne chez qui la perquisition a lieu.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Pièce de procédure",
    question:
        "Que devient l’écrit matérialisant l’assentiment à la perquisition ?",
    options: [
      "Il est conservé par la personne perquisitionnée",
      "Il est annexé à la procédure",
      "Il est détruit après l’opération",
    ],
    answer: "Il est annexé à la procédure",
    explanation:
        "Le texte précise que ce document est annexé à la procédure pour prouver la régularité de la mesure.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Régime dérogatoire — Crimes et délits graves",
    question:
        "Pour quels faits le J.L.D. peut-il autoriser une perquisition sans l’assentiment de l’occupant en enquête préliminaire ?",
    options: [
      "Pour toutes les contraventions routières",
      "Pour les crimes et délits punis d’au moins 3 ans d’emprisonnement",
      "Uniquement pour les délits de presse",
    ],
    answer: "Pour les crimes et délits punis d’au moins 3 ans d’emprisonnement",
    explanation:
        "Cette possibilité est prévue par l’article 76 alinéa 4 du C.P.P.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Régime dérogatoire — Criminalité organisée",
    question:
        "Les perquisitions sans assentiment en enquête préliminaire peuvent aussi viser certaines infractions prévues par :",
    options: [
      "L’article 706-73 du C.P.P.",
      "L’article 78-3 du C.P.P.",
      "L’article 63-1 du C.P.P.",
    ],
    answer: "L’article 706-73 du C.P.P.",
    explanation:
        "Le texte renvoie aux infractions visées par l’article 706-73 et à l’article 706-90 du C.P.P.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Personnes — Catégories protégées",
    question:
        "Parmi les catégories ci-dessous, laquelle fait l’objet de règles particulières en enquête préliminaire ?",
    options: [
      "Les commerçants",
      "Les parlementaires",
      "Les fonctionnaires territoriaux",
    ],
    answer: "Les parlementaires",
    explanation:
        "Les parlementaires font l’objet d’un régime particulier, notamment pour les mesures privatives ou restrictives de liberté.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Personnes — Mesures restrictives",
    question:
        "Les mesures privatives ou restrictives de liberté envisagées contre un parlementaire en enquête préliminaire :",
    options: [
      "Sont interdites",
      "Nécessitent une autorisation du bureau de l’assemblée concernée",
      "Sont laissées à l’initiative exclusive de l’O.P.J.",
    ],
    answer: "Nécessitent une autorisation du bureau de l’assemblée concernée",
    explanation:
        "Le texte rappelle cette exigence pour la garde à vue, le contrôle judiciaire, etc.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Enquête préliminaire — Mise en œuvre",
    question: "Le texte précise que l’enquête préliminaire est :",
    options: [
      "Rarement utilisée, car trop formalisée",
      "Très fréquemment mise en œuvre dans la pratique",
      "Obligatoirement remplacée par la flagrance en cas de délit",
    ],
    answer: "Très fréquemment mise en œuvre dans la pratique",
    explanation: "Cette phrase figure explicitement dans l’introduction.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Libertés — Encadrement procédural",
    question:
        "L’existence de risques pour les libertés individuelles en enquête préliminaire justifie :",
    options: [
      "Un encadrement procédural strict",
      "Une absence totale de formalités",
      "Une suppression de l’enquête préliminaire",
    ],
    answer: "Un encadrement procédural strict",
    explanation:
        "Le texte affirme que ces risques justifient un encadrement strict de la procédure.",
    difficulty: "Intermédiaire",
  ),

  // ===================== BLOC 3 — NIVEAU DIFFICILE =====================
  const QuizQuestion(
    category: "Articulation — Enquête préliminaire / Information judiciaire",
    question:
        "Pourquoi les actes accomplis en enquête préliminaire avant la connaissance de l’ouverture d’une information judiciaire demeurent-ils valables ?",
    options: [
      "Parce qu’ils sont automatiquement repris par le juge d’instruction",
      "Parce qu’ils ont été accomplis alors que la police judiciaire ignorait encore l’ouverture de l’information",
      "Parce que la loi considère toute enquête préliminaire comme supérieure à l’information",
    ],
    answer:
        "Parce qu’ils ont été accomplis alors que la police judiciaire ignorait encore l’ouverture de l’information",
    explanation:
        "Le texte précise que le basculement vers l’information ne prive pas rétroactivement de validité les actes régulièrement accomplis avant que les enquêteurs n’en aient connaissance.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Théorie — Caractère non rétroactif",
    question:
        "Quelle notion juridique illustre le fait que l’ouverture d’une information judiciaire n’annule pas les actes déjà accomplis en enquête préliminaire ?",
    options: [
      "La rétroactivité de la loi pénale plus douce",
      "La non-rétroactivité de l’irrégularité procédurale",
      "La responsabilité objective de la police judiciaire",
    ],
    answer: "La non-rétroactivité de l’irrégularité procédurale",
    explanation:
        "Les actes régulièrement accomplis avant l’ouverture connue de l’information conservent leur validité.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Immunités — Portée pratique",
    question:
        "En pratique, que provoque l’immunité dont bénéficient les agents diplomatiques en enquête préliminaire ?",
    options: [
      "Une impossibilité absolue de tout contact avec eux",
      "Un obstacle, sauf exceptions, aux mesures d’enquête et de contrainte ordinaires",
      "Un simple allongement des délais de procédure",
    ],
    answer:
        "Un obstacle, sauf exceptions, aux mesures d’enquête et de contrainte ordinaires",
    explanation:
        "Le texte précise que leurs immunités font obstacle aux mesures d’enquête et de contrainte ordinaires.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Enquête préliminaire — Risque et contrôle",
    question:
        "Comment concilier l’absence de coercition « classique » de l’enquête préliminaire avec le risque pour les libertés individuelles ?",
    options: [
      "En admettant que les libertés ne sont pas concernées",
      "En organisant un encadrement procédural strict malgré ce caractère non coercitif",
      "En supprimant toute intervention de la police judiciaire",
    ],
    answer:
        "En organisant un encadrement procédural strict malgré ce caractère non coercitif",
    explanation:
        "Le texte rappelle que ce caractère n’exclut pas la nécessité d’un encadrement strict.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Régime mixte",
    question:
        "Pourquoi le régime des perquisitions en enquête préliminaire est-il présenté comme particulièrement protecteur ?",
    options: [
      "Parce qu’il nécessite toujours une décision de la Cour de cassation",
      "Parce qu’il repose sur l’assentiment en principe, mais permet une dérogation sous contrôle du J.L.D. pour les infractions graves",
      "Parce qu’il est laissé totalement à l’appréciation de l’O.P.J.",
    ],
    answer:
        "Parce qu’il repose sur l’assentiment en principe, mais permet une dérogation sous contrôle du J.L.D. pour les infractions graves",
    explanation:
        "Le texte combine un principe de consentement avec un régime dérogatoire contrôlé par un juge.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Parlementaires — Conciliation des intérêts",
    question:
        "Que cherche à concilier le régime particulier applicable aux parlementaires en enquête préliminaire ?",
    options: [
      "La protection de la vie privée et le droit du travail",
      "La séparation des pouvoirs, la protection de la représentation nationale et la nécessité de poursuites pénales",
      "La liberté de la presse et la sécurité routière",
    ],
    answer:
        "La séparation des pouvoirs, la protection de la représentation nationale et la nécessité de poursuites pénales",
    explanation:
        "Le texte explique que ce régime vise précisément cette conciliation.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Lieux — Atteinte aux droits fondamentaux",
    question:
        "Pourquoi la perquisition sans assentiment dans un domicile est-elle soumise à l’intervention du J.L.D. ?",
    options: [
      "Parce qu’il faut toujours l’autorisation d’un juge pour entrer dans un domicile",
      "Parce qu’il s’agit d’une atteinte grave au domicile et à la vie privée qui doit être autorisée et contrôlée par un juge",
      "Parce que le procureur ne peut jamais intervenir en matière de perquisitions",
    ],
    answer:
        "Parce qu’il s’agit d’une atteinte grave au domicile et à la vie privée qui doit être autorisée et contrôlée par un juge",
    explanation:
        "Le texte insiste sur le rôle du J.L.D. comme garantie importante des libertés.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Domaine — Actualisation des règles",
    question:
        "Quel enseignement tire-t-on de la mention « Version au 01/07/2025 — SDCP — Tous droits réservés UoPl » figurant en fin de texte ?",
    options: [
      "Que les règles présentées sont temporaires et non applicables",
      "Que les règles exposées sont à jour à cette date et issues d’une documentation officielle",
      "Que les règles ne sont qu’un simple commentaire doctrinal sans valeur",
    ],
    answer:
        "Que les règles exposées sont à jour à cette date et issues d’une documentation officielle",
    explanation:
        "Cette mention précise la date de mise à jour et le caractère officiel du support.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Enquête préliminaire — Domaine matériel et personnel",
    question:
        "Que révèle la combinaison des sections « infractions », « personnes » et « lieux » du chapitre 1 sur le domaine d’application de l’enquête préliminaire ?",
    options: [
      "Qu’il est strictement limité aux délits financiers commis par des nationaux dans des lieux publics",
      "Qu’il couvre tous types d’infractions, une large catégorie de personnes et divers lieux, sous réserve d’exceptions et de garanties spécifiques",
      "Qu’il ne s’applique qu’en matière de criminalité organisée",
    ],
    answer:
        "Qu’il couvre tous types d’infractions, une large catégorie de personnes et divers lieux, sous réserve d’exceptions et de garanties spécifiques",
    explanation:
        "Le chapitre 1 structure le domaine matériel (infractions), personnel (personnes) et territorial (lieux) de l’enquête préliminaire.",
    difficulty: "Difficile",
  ),

  // ===================== CONSTATATIONS, RÉQUISITIONS & PRÉLÈVEMENTS — BLOC 1 =====================
  // ===================== NIVEAU FACILE =====================
  const QuizQuestion(
    category: "Saisine — Ouverture de l’enquête",
    question: "Quel acte ouvre concrètement l’enquête préliminaire ?",
    options: [
      "Le rapport de fin d’enquête",
      "Le procès-verbal de saisine",
      "Le procès-verbal de fin de garde à vue",
    ],
    answer: "Le procès-verbal de saisine",
    explanation:
        "Le texte précise que le procès-verbal de saisine ouvre concrètement l’enquête préliminaire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Saisine — Origine",
    question: "Le procès-verbal de saisine peut être ouvert notamment :",
    options: [
      "Uniquement sur plainte écrite",
      "À l’initiative de l’O.P.J. ou de l’A.P.J. sous son contrôle, ou sur instructions du procureur",
      "Uniquement sur dénonciation anonyme",
    ],
    answer:
        "À l’initiative de l’O.P.J. ou de l’A.P.J. sous son contrôle, ou sur instructions du procureur",
    explanation:
        "Le texte mentionne l’initiative de l’O.P.J./A.P.J., les instructions du procureur (art. 75 C.P.P.) et la plainte ou dénonciation (art. 17 C.P.P.).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Saisine — Rôle de l’OPJ",
    question: "À compter du premier procès-verbal de saisine, l’O.P.J. :",
    options: [
      "Cesse d’enquêter",
      "Dirige les premières investigations et rend compte au procureur",
      "Est dessaisi au profit du juge d’instruction",
    ],
    answer: "Dirige les premières investigations et rend compte au procureur",
    explanation:
        "Le texte précise que l’O.P.J. dirige les premières investigations et rend compte au procureur des suites données.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Transport sur les lieux — Possibilité",
    question:
        "En enquête préliminaire, les enquêteurs peuvent-ils se transporter sur les lieux ?",
    options: [
      "Non, jamais",
      "Oui, pour effectuer les premières constatations utiles",
      "Uniquement en cas de crime flagrant",
    ],
    answer: "Oui, pour effectuer les premières constatations utiles",
    explanation:
        "Le texte indique qu’ils conservent la faculté de se rendre sur place pour effectuer les premières constatations.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Transport sur les lieux — Lieux privés",
    question:
        "En enquête préliminaire, l’introduction dans des lieux privés lors du transport sur les lieux suppose :",
    options: [
      "Un mandat de perquisition",
      "L’autorisation expresse de l’occupant habituel ou de son représentant",
      "La présence obligatoire du maire",
    ],
    answer:
        "L’autorisation expresse de l’occupant habituel ou de son représentant",
    explanation:
        "Le texte précise que l’introduction dans des lieux privés nécessite une autorisation expresse de l’occupant.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Transport sur les lieux — Autorisation",
    question:
        "Comment doit être consignée l’autorisation donnée pour entrer dans un lieu privé lors du transport sur les lieux ?",
    options: [
      "Elle n’a pas à être mentionnée",
      "Elle doit être consignée dans la procédure",
      "Elle doit être notariée",
    ],
    answer: "Elle doit être consignée dans la procédure",
    explanation:
        "Le texte indique que cette autorisation, bien que verbale, doit être consignée dans la procédure.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Transport vs perquisition",
    question:
        "Quelle différence est rappelée entre l’autorisation d’entrer dans un lieu privé et l’assentiment en matière de perquisition ?",
    options: [
      "Il s’agit exactement de la même exigence",
      "L’autorisation est verbale pour le transport, l’assentiment doit être exprès et écrit pour la perquisition",
      "Les deux doivent être notariés",
    ],
    answer:
        "L’autorisation est verbale pour le transport, l’assentiment doit être exprès et écrit pour la perquisition",
    explanation:
        "Le texte insiste sur la distinction entre l’autorisation verbale pour l’introduction sur les lieux et l’assentiment écrit pour la perquisition ou la saisie.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Constatations — Définition",
    question: "Les constatations désignent principalement :",
    options: [
      "Les auditions de témoins uniquement",
      "Les opérations d’examen des lieux, objets, documents ou personnes",
      "Uniquement les prises de photographies",
    ],
    answer: "Les opérations d’examen des lieux, objets, documents ou personnes",
    explanation:
        "Le texte précise que les constatations regroupent l’ensemble des opérations d’examen destinées à conserver traces et indices.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Constatations — Finalité",
    question: "La finalité des constatations en enquête préliminaire est :",
    options: [
      "De clore l’enquête",
      "De conserver les traces et indices utiles à la manifestation de la vérité",
      "De sanctionner immédiatement le mis en cause",
    ],
    answer:
        "De conserver les traces et indices utiles à la manifestation de la vérité",
    explanation: "C’est l’objectif clairement indiqué dans le texte.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Principe",
    question: "Les réquisitions permettent à l’O.P.J. ou au procureur :",
    options: [
      "De sanctionner directement les personnes requises",
      "De solliciter l’intervention de personnes ou organismes extérieurs",
      "De perquisitionner sans formalité",
    ],
    answer:
        "De solliciter l’intervention de personnes ou organismes extérieurs",
    explanation:
        "Le texte mentionne médecins, experts, opérateurs, banques, administrations, etc.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  const QuizQuestion(
    category: "Base légale — Constatations & réquisitions",
    question:
        "Les constatations et réquisitions en enquête préliminaire sont notamment encadrées par :",
    options: [
      "Les articles 75 à 78 du C.P.P. uniquement",
      "Les articles 77-1 à 77-1-4, 60, 60-1, 60-2, 60-3 et 230-28 et suivants, 230-32 à 230-44 du C.P.P.",
      "Le seul article 17 du C.P.P.",
    ],
    answer:
        "Les articles 77-1 à 77-1-4, 60, 60-1, 60-2, 60-3 et 230-28 et suivants, 230-32 à 230-44 du C.P.P.",
    explanation:
        "Le texte recense ces dispositions comme encadrant constatations et réquisitions.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions judiciaires — Art. 77-1",
    question:
        "Selon l’article 77-1 C.P.P., pour procéder à des constatations ou examens techniques ou scientifiques, l’O.P.J. :",
    options: [
      "Agit toujours sans contrôle du procureur",
      "Peut, sur autorisation du procureur, avoir recours à toutes personnes qualifiées",
      "Doit obligatoirement saisir un juge d’instruction",
    ],
    answer:
        "Peut, sur autorisation du procureur, avoir recours à toutes personnes qualifiées",
    explanation:
        "Le texte cite l’article 77-1 et la possibilité de recourir à des personnes qualifiées.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Personne qualifiée — Statut",
    question:
        "La personne qualifiée requise sur le fondement de l’article 77-1 C.P.P. :",
    options: [
      "Intervient sans aucune formalité",
      "Intervient sous serment et dépose un rapport détaillé",
      "N’a pas à signer les scellés",
    ],
    answer: "Intervient sous serment et dépose un rapport détaillé",
    explanation:
        "Les quatre derniers alinéas de l’article 60 C.P.P. lui imposent serment, rapport et signature sur scellés le cas échéant.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Objectif des réquisitions — Petites infractions",
    question:
        "Quel objectif le législateur poursuit-il en encadrant les réquisitions d’examens ou d’expertises pour les petites infractions ?",
    options: [
      "Limiter les possibilités d’enquête",
      "Rappeler que seules les opérations réellement nécessaires à la manifestation de la vérité doivent être ordonnées",
      "Remplacer toutes les expertises par de simples constatations",
    ],
    answer:
        "Rappeler que seules les opérations réellement nécessaires à la manifestation de la vérité doivent être ordonnées",
    explanation:
        "Le texte indique que le dispositif vise à encadrer ces réquisitions pour éviter les abus.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Personnes qualifiées — Article 39-3",
    question: "En application de l’article 39-3 C.P.P., le procureur peut :",
    options: [
      "Donner des instructions générales autorisant les O.P.J. et, sous leur contrôle, les A.P.J. à requérir des personnes qualifiées",
      "Se dessaisir de toutes enquêtes",
      "Interdire à la police de recourir à des techniciens",
    ],
    answer:
        "Donner des instructions générales autorisant les O.P.J. et, sous leur contrôle, les A.P.J. à requérir des personnes qualifiées",
    explanation:
        "Le texte mentionne cette possibilité via des instructions générales.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Exemples de personnes qualifiées",
    question:
        "Parmi les personnes suivantes, lesquelles peuvent être requises comme personnes qualifiées ?",
    options: [
      "Médecins, psychologues, techniciens, services de police technique et scientifique",
      "Uniquement des magistrats",
      "Uniquement des agents de mairie",
    ],
    answer:
        "Médecins, psychologues, techniciens, services de police technique et scientifique",
    explanation:
        "Le texte cite expressément ces exemples de personnes qualifiées.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Jurisprudence — Limite des missions 77-1",
    question:
        "Selon la jurisprudence rappelée, une mission confiée à une « personne qualifiée » sur le fondement de l’article 77-1 C.P.P. :",
    options: [
      "Ne doit pas dégénérer en véritable expertise judiciaire cachée",
      "Peut toujours remplacer une expertise contradictoire",
      "Peut être totalement secrète pour la défense",
    ],
    answer: "Ne doit pas dégénérer en véritable expertise judiciaire cachée",
    explanation:
        "Le texte insiste sur le fait que, si l’analyse devient trop approfondie, il faut recourir à une expertise contradictoire.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions d’ordre général — Art. 77-1-1",
    question:
        "Les réquisitions d’ordre général prévues par l’article 77-1-1 C.P.P. permettent :",
    options: [
      "De perquisitionner tous les domiciles sans consentement",
      "D’obtenir des informations ou documents auprès de toute personne, service ou organisme public ou privé",
      "Uniquement de saisir des véhicules",
    ],
    answer:
        "D’obtenir des informations ou documents auprès de toute personne, service ou organisme public ou privé",
    explanation:
        "Le texte mentionne la remise d’enregistrements, images, listes, contrats, données administratives, etc.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions d’ordre général — Secret pro",
    question:
        "Face à une réquisition d’ordre général, le secret professionnel :",
    options: [
      "Ne peut jamais être opposé",
      "Peut être opposé lorsqu’il est directement et légalement protégé",
      "Est toujours facultatif",
    ],
    answer: "Peut être opposé lorsqu’il est directement et légalement protégé",
    explanation:
        "Le texte cite les avocats, médecins, journalistes (protection des sources) comme exemples.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Refus de déférer",
    question:
        "Le refus injustifié de répondre à une réquisition régulièrement formulée est susceptible de constituer :",
    options: [
      "Une simple faute civile",
      "Une infraction prévue par l’article R. 642-1 du code pénal",
      "Un motif automatique de relaxe",
    ],
    answer: "Une infraction prévue par l’article R. 642-1 du code pénal",
    explanation:
        "Le texte renvoie expressément à cette infraction en cas de refus injustifié.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE (suite) =====================
  const QuizQuestion(
    category: "Données de connexion — Conditions",
    question:
        "Les réquisitions portant sur les données de connexion ne sont possibles que si l’enquête concerne :",
    options: [
      "Tout type d’infraction, même contraventionnelle",
      "Un crime ou un délit puni d’au moins trois ans d’emprisonnement, ou certains cas particuliers",
      "Uniquement les infractions routières",
    ],
    answer:
        "Un crime ou un délit puni d’au moins trois ans d’emprisonnement, ou certains cas particuliers",
    explanation:
        "Le texte conditionne ces réquisitions à la gravité de l’infraction ou à des hypothèses spécifiques.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Données de connexion — Nature",
    question: "Les données de connexion visées peuvent notamment comprendre :",
    options: [
      "Des données techniques d’identification et de trafic, comme adresse IP ou données de localisation",
      "Uniquement le contenu intégral des conversations",
      "Uniquement le nom de famille de l’abonné",
    ],
    answer:
        "Des données techniques d’identification et de trafic, comme adresse IP ou données de localisation",
    explanation:
        "Le texte cite les données techniques, de trafic et de localisation.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Données de connexion — Détenteurs",
    question: "Les données de connexion sont détenues principalement par :",
    options: [
      "Les notaires",
      "Les fournisseurs d’accès, hébergeurs et opérateurs de communications",
      "Les tribunaux de police",
    ],
    answer:
        "Les fournisseurs d’accès, hébergeurs et opérateurs de communications",
    explanation:
        "C’est indiqué clairement dans le texte (FAI, hébergeurs, opérateurs).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Données de connexion — Vie privée",
    question:
        "Pourquoi la Cour de cassation insiste-t-elle sur un contrôle renforcé du recours aux données de connexion ?",
    options: [
      "Parce qu’il s’agit d’opérations coûteuses",
      "En raison de l’atteinte portée à la vie privée",
      "Pour limiter les charges de travail des opérateurs",
    ],
    answer: "En raison de l’atteinte portée à la vie privée",
    explanation:
        "Le texte souligne l’importance de la protection de la vie privée dans ce domaine.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Données de connexion — Proportionnalité",
    question:
        "En cas de contestation d’une réquisition de données de connexion, le juge doit vérifier :",
    options: [
      "Uniquement l’identité de l’O.P.J.",
      "La gravité des faits, la complexité de l’enquête, l’existence d’indices sérieux et l’absence d’atteinte disproportionnée aux droits fondamentaux",
      "Uniquement le coût de l’opération",
    ],
    answer:
        "La gravité des faits, la complexité de l’enquête, l’existence d’indices sérieux et l’absence d’atteinte disproportionnée aux droits fondamentaux",
    explanation: "Le texte évoque précisément ce contrôle de proportionnalité.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions informatiques/téléphoniques — Contenu",
    question:
        "Les réquisitions informatiques ou téléphoniques peuvent porter sur :",
    options: [
      "Des informations conservées dans des systèmes informatiques (historique de connexions, contenus de comptes, vidéosurveillance, etc.)",
      "Uniquement les relevés bancaires papier",
      "Uniquement les conversations enregistrées par les notaires",
    ],
    answer:
        "Des informations conservées dans des systèmes informatiques (historique de connexions, contenus de comptes, vidéosurveillance, etc.)",
    explanation: "Le texte mentionne explicitement ces types de données.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions informatiques — Limites",
    question:
        "Les limitations de l’article 60-1-2 C.P.P. en matière de réquisitions informatiques concernent notamment :",
    options: [
      "Les données de connexion et les données sensibles relatives à la vie privée",
      "Uniquement la durée de conservation des fichiers audio",
      "Uniquement les expertises médicolégales",
    ],
    answer:
        "Les données de connexion et les données sensibles relatives à la vie privée",
    explanation:
        "Le texte précise que ces limitations s’appliquent à ces catégories de données.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Police technique et scientifique",
    question: "Les services de police technique et scientifique peuvent être :",
    options: [
      "Requis directement, sans réquisition distincte pour chaque agent intervenant",
      "Requis uniquement par un juge d’instruction",
      "Jamais requis en enquête préliminaire",
    ],
    answer:
        "Requis directement, sans réquisition distincte pour chaque agent intervenant",
    explanation:
        "Le texte mentionne ce dispositif pour simplifier leur intervention.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Autopsie — Conditions",
    question:
        "Selon l’article 230-28 C.P.P., une autopsie en enquête préliminaire peut être ordonnée lorsque :",
    options: [
      "Le décès est ancien et non suspect",
      "Les circonstances du décès apparaissent suspectes ou la cause doit être précisée",
      "La famille le demande systématiquement",
    ],
    answer:
        "Les circonstances du décès apparaissent suspectes ou la cause doit être précisée",
    explanation: "Le texte décrit ces conditions pour ordonner une autopsie.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Autopsie — Médecin légiste",
    question:
        "Qui peut pratiquer une autopsie judiciaire dans le cadre de l’enquête préliminaire ?",
    options: [
      "Tout médecin inscrit à l’Ordre",
      "Uniquement un médecin qualifié en médecine légale, titulaire des titres requis",
      "Un agent de police spécialement formé",
    ],
    answer:
        "Uniquement un médecin qualifié en médecine légale, titulaire des titres requis",
    explanation: "Le texte impose cette condition de qualification.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  const QuizQuestion(
    category: "Géolocalisation — Conditions d’infraction",
    question:
        "La géolocalisation en temps réel en enquête préliminaire ne peut être utilisée que pour :",
    options: [
      "Les contraventions de stationnement",
      "Les crimes et délits punis d’au moins trois ans d’emprisonnement lorsque les nécessités de l’enquête l’exigent",
      "Uniquement les infractions routières",
    ],
    answer:
        "Les crimes et délits punis d’au moins trois ans d’emprisonnement lorsque les nécessités de l’enquête l’exigent",
    explanation: "Le texte fixe ce seuil et ce critère de nécessité.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Géolocalisation — Autorité compétente",
    question:
        "En enquête préliminaire, la décision initiale de mise en œuvre de la géolocalisation appartient :",
    options: [
      "Au juge d’instruction",
      "Au juge des libertés et de la détention",
      "Au procureur de la République",
    ],
    answer: "Au procureur de la République",
    explanation:
        "Le texte précise que l’autorisation initiale appartient au procureur pour une durée limitée.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Géolocalisation — Durées",
    question:
        "En matière de géolocalisation en enquête préliminaire, les durées de l’autorisation initiale par le procureur sont :",
    options: [
      "Toujours un an ferme",
      "8 jours pour le droit commun, 15 jours pour certaines infractions graves",
      "24 heures maximum",
    ],
    answer:
        "8 jours pour le droit commun, 15 jours pour certaines infractions graves",
    explanation:
        "Ces durées sont mentionnées dans le tableau de synthèse de la mesure.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Géolocalisation — Rôle du JLD",
    question:
        "En enquête préliminaire, le Juge des libertés et de la détention intervient en matière de géolocalisation pour :",
    options: [
      "Autoriser les renouvellements au-delà de l’autorisation initiale du procureur",
      "Pratiquer lui-même les filatures",
      "Remplacer le procureur dans toutes ses décisions",
    ],
    answer:
        "Autoriser les renouvellements au-delà de l’autorisation initiale du procureur",
    explanation:
        "Le texte mentionne que les renouvellements se font sous le contrôle du J.L.D.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Géolocalisation — Intrusion dans domicile",
    question:
        "L’introduction dans un domicile pour installer ou retirer un dispositif de géolocalisation nécessite :",
    options: [
      "Le simple accord oral de l’occupant",
      "Une ordonnance écrite et motivée du Juge des libertés et de la détention",
      "Uniquement l’accord du procureur",
    ],
    answer:
        "Une ordonnance écrite et motivée du Juge des libertés et de la détention",
    explanation:
        "Le texte est très clair sur ce point de protection des lieux privés.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Géolocalisation — Durée maximale",
    question:
        "Selon le tableau de synthèse, la durée maximale de géolocalisation sous contrôle du J.L.D. est :",
    options: [
      "Un an pour le droit commun, deux ans pour certaines infractions de criminalité organisée",
      "Toujours trois jours",
      "Toujours illimitée",
    ],
    answer:
        "Un an pour le droit commun, deux ans pour certaines infractions de criminalité organisée",
    explanation:
        "Le texte précise ces plafonds pour la géolocalisation prolongée.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Géolocalisation — Activation à distance",
    question:
        "L’activation à distance d’un appareil électronique pour la géolocalisation est :",
    options: [
      "Possible pour toute infraction, sans contrôle",
      "Réservée aux infractions les plus graves, sur autorisation écrite et motivée du J.L.D.",
      "Interdite en toute hypothèse",
    ],
    answer:
        "Réservée aux infractions les plus graves, sur autorisation écrite et motivée du J.L.D.",
    explanation:
        "Le tableau indique cette restriction stricte pour l’activation à distance.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Prélèvements & signalétique — Base légale",
    question:
        "Les prélèvements externes et relevés signalétiques sont prévus en enquête préliminaire par :",
    options: [
      "L’article 76-2-1 du C.P.P.",
      "L’article 17 du C.P.P.",
      "L’article 230-32 du C.P.P.",
    ],
    answer: "L’article 76-2-1 du C.P.P.",
    explanation: "Le texte mentionne cette base légale pour ces opérations.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Prélèvements — Finalité",
    question:
        "La finalité principale des prélèvements externes et relevés signalétiques est :",
    options: [
      "La constitution d’un dossier fiscal",
      "La réalisation d’examens techniques et scientifiques de comparaison",
      "La diffusion publique de l’identité des mis en cause",
    ],
    answer:
        "La réalisation d’examens techniques et scientifiques de comparaison",
    explanation:
        "Le texte précise que ces opérations servent aux examens de comparaison (empreintes, ADN, etc.).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Prélèvements — Refus de se soumettre",
    question:
        "Le refus injustifié de se soumettre à certaines opérations de signalisation ou de prélèvement, lorsqu’elles constituent le seul moyen d’identification ou de vérification de l’implication, est :",
    options: [
      "Sans conséquence juridique",
      "Pénalement sanctionné",
      "Uniquement sanctionné disciplinairement",
    ],
    answer: "Pénalement sanctionné",
    explanation: "Le texte précise que ce refus est pénalement réprimé.",
    difficulty: "Difficile",
  ),

  // ===================== FOUILLES EN ENQUÊTE PRÉLIMINAIRE — BLOC 1 =====================
  // ===================== NIVEAU FACILE =====================
  const QuizQuestion(
    category: "Généralités — Définition",
    question:
        "Les fouilles, en enquête préliminaire, ont pour finalité principale :",
    options: [
      "D’assurer la sécurité routière",
      "De rechercher des objets ou indices intéressant l’enquête dans le cadre de l’établissement de la preuve",
      "De vérifier l’identité des témoins",
    ],
    answer:
        "De rechercher des objets ou indices intéressant l’enquête dans le cadre de l’établissement de la preuve",
    explanation:
        "Le texte précise que les fouilles sont destinées exclusivement à la recherche d’objets ou d’indices intéressant l’enquête, dans le cadre de l’établissement de la preuve.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Catégories",
    question:
        "Quelles sont les deux grandes catégories de fouilles distinguées en enquête préliminaire ?",
    options: [
      "La fouille domiciliaire et la fouille informatique",
      "La fouille intégrale de la personne gardée à vue et la fouille de véhicule",
      "La fouille administrative et la fouille judiciaire",
    ],
    answer:
        "La fouille intégrale de la personne gardée à vue et la fouille de véhicule",
    explanation:
        "Les intro-bullets de la page distinguent explicitement ces deux grandes catégories.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Intrusion",
    question:
        "Par rapport aux palpations de sécurité, les fouilles se caractérisent par :",
    options: [
      "Une moindre intrusion dans la sphère privée",
      "Une intrusion plus importante dans la sphère privée",
      "Une absence totale d’atteinte à la vie privée",
    ],
    answer: "Une intrusion plus importante dans la sphère privée",
    explanation:
        "Le texte précise que les fouilles se distinguent des palpations et contrôles visuels par une intrusion plus importante dans la sphère privée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Fouille intégrale — Personne concernée",
    question:
        "Selon l’article 63-7 du C.P.P., la fouille intégrale ne peut être pratiquée que :",
    options: [
      "Sur toute personne contrôlée sur la voie publique",
      "Sur une personne gardée à vue",
      "Sur tout témoin",
    ],
    answer: "Sur une personne gardée à vue",
    explanation:
        "Le texte indique qu’elle ne peut être pratiquée que sur une personne gardée à vue et pour les nécessités de l’enquête.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Fouille intégrale — Décision",
    question: "Qui décide de la mise en œuvre d’une fouille intégrale ?",
    options: [
      "Un agent de police municipale",
      "Un officier de police judiciaire (O.P.J.)",
      "Le greffier du tribunal",
    ],
    answer: "Un officier de police judiciaire (O.P.J.)",
    explanation:
        "La page précise que la fouille intégrale est décidée par un O.P.J.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Fouille intégrale — Voies moins intrusives",
    question: "Avant de recourir à une fouille intégrale, il faut :",
    options: [
      "Toujours la pratiquer en priorité",
      "S’assurer qu’aucun autre moyen de détection moins intrusif ne peut être mis en œuvre",
      "Obtenir l’autorisation du juge d’instruction",
    ],
    answer:
        "S’assurer qu’aucun autre moyen de détection moins intrusif ne peut être mis en œuvre",
    explanation:
        "Le texte indique qu’il ne peut y être recouru que si une palpation ou un moyen électronique ne peut être utilisé.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Fouille intégrale — Assimilation",
    question: "En enquête préliminaire, la fouille intégrale est assimilée à :",
    options: [
      "Une simple vérification d’identité",
      "Une perquisition",
      "Un contrôle routier",
    ],
    answer: "Une perquisition",
    explanation:
        "La page précise que la fouille intégrale est assimilée à une perquisition.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Fouille intégrale — Heures légales",
    question:
        "Les heures légales applicables aux perquisitions s’appliquent-elles à la fouille intégrale de la personne ?",
    options: [
      "Oui, strictement",
      "Non, elle peut être réalisée de jour comme de nuit",
      "Uniquement en matière criminelle",
    ],
    answer: "Non, elle peut être réalisée de jour comme de nuit",
    explanation:
        "Le texte indique que le respect des heures légales des perquisitions ne s’applique pas aux fouilles de personnes.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Fouille intégrale — Sexe de l’agent",
    question: "La fouille intégrale doit être effectuée :",
    options: [
      "Par n’importe quel agent, quel que soit son sexe",
      "Par une personne du même sexe que l’individu fouillé",
      "Uniquement par un médecin",
    ],
    answer: "Par une personne du même sexe que l’individu fouillé",
    explanation:
        "Le texte impose que la fouille intégrale soit accompli par une personne du même sexe.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Fouille véhicule — Domicile",
    question:
        "Un véhicule, en principe, constitue-t-il un domicile au sens du droit des perquisitions ?",
    options: [
      "Oui, toujours",
      "Non, sauf s’il est spécialement aménagé et effectivement utilisé comme résidence",
      "Oui uniquement pour les véhicules de fonction",
    ],
    answer:
        "Non, sauf s’il est spécialement aménagé et effectivement utilisé comme résidence",
    explanation:
        "La jurisprudence rappelée dans le texte précise qu’un véhicule n’est pas un domicile, sauf aménagement effectif à usage d’habitation.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  const QuizQuestion(
    category: "Généralités — Encadrement",
    question:
        "Pourquoi les fouilles en enquête préliminaire sont-elles strictement encadrées ?",
    options: [
      "Pour limiter le travail des enquêteurs",
      "Pour concilier efficacité des investigations et protection des libertés individuelles",
      "Pour éviter tout recours à la preuve matérielle",
    ],
    answer:
        "Pour concilier efficacité des investigations et protection des libertés individuelles",
    explanation:
        "L’introduction précise ce double objectif : efficacité de l’enquête et protection des libertés.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Fouille intégrale — Base légale",
    question:
        "Quel article de loi encadre directement la fouille intégrale de la personne gardée à vue ?",
    options: [
      "Article 63-7 du Code de procédure pénale",
      "Article 76 du Code de procédure pénale",
      "Article 60 du Code de procédure pénale",
    ],
    answer: "Article 63-7 du Code de procédure pénale",
    explanation:
        "Le texte cite explicitement l’article 63-7 C.P.P. comme base de la fouille intégrale.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Fouille intégrale — Conditions cumulatives",
    question:
        "Parmi les conditions suivantes, lesquelles sont requises pour recourir à une fouille intégrale ?",
    options: [
      "La personne est gardée à vue, la fouille est décidée par un O.P.J. et aucun autre moyen moins intrusif n’est possible",
      "La personne est simplement contrôlée sur la voie publique",
      "La personne est uniquement témoin des faits",
    ],
    answer:
        "La personne est gardée à vue, la fouille est décidée par un O.P.J. et aucun autre moyen moins intrusif n’est possible",
    explanation: "La page pose précisément ces conditions de recours.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Fouille intégrale — Assentiment",
    question:
        "En enquête préliminaire, puisque la fouille intégrale est assimilée à une perquisition, elle suppose :",
    options: [
      "Un simple accord oral non consigné",
      "L’assentiment de la personne dans les formes et conditions prévues pour les perquisitions",
      "Une décision du juge d’instruction",
    ],
    answer:
        "L’assentiment de la personne dans les formes et conditions prévues pour les perquisitions",
    explanation:
        "Le texte précise que, assimilée à une perquisition, elle est soumise à l’assentiment dans les mêmes formes que les perquisitions.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Fouille intégrale — Lieu de réalisation",
    question:
        "Dans quelles conditions matérielles doit être réalisée une fouille intégrale ?",
    options: [
      "En cellule collective, en présence d’autres personnes",
      "Dans un espace fermé, à l’abri des regards",
      "Toujours devant un officier de l’état civil",
    ],
    answer: "Dans un espace fermé, à l’abri des regards",
    explanation:
        "Le texte impose un espace fermé, à l’abri des regards, pour respecter la dignité de la personne.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Dignité — Limitation de la mesure",
    question: "Le caractère intrusif de la fouille intégrale implique que :",
    options: [
      "L’on puisse l’utiliser largement pour plus d’efficacité",
      "L’acte soit limité à ce qui est strictement nécessaire à la recherche de la preuve",
      "La personne soit systématiquement filmée",
    ],
    answer:
        "L’acte soit limité à ce qui est strictement nécessaire à la recherche de la preuve",
    explanation:
        "Le NotaBox insiste sur la nécessité de limiter la mesure au strict nécessaire pour respecter la dignité.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Fouille de véhicule — Nature juridique",
    question:
        "Comment est qualifiée juridiquement la fouille de véhicule selon la jurisprudence rappelée ?",
    options: [
      "Comme une simple inspection administrative",
      "Comme une opération toujours indépendante des règles de perquisition",
      "Comme une opération assimilable à une perquisition en raison de l’atteinte à la vie privée",
    ],
    answer:
        "Comme une opération assimilable à une perquisition en raison de l’atteinte à la vie privée",
    explanation:
        "La jurisprudence citée considère la fouille de véhicule comme assimilable à une perquisition.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Fouille de véhicule — Heures légales",
    question:
        "Les fouilles de véhicule sont-elles soumises au respect des heures légales applicables aux perquisitions domiciliaires ?",
    options: [
      "Oui, toujours",
      "Non, elles ne sont pas soumises au respect des heures légales",
      "Uniquement pour les véhicules de fonction",
    ],
    answer: "Non, elles ne sont pas soumises au respect des heures légales",
    explanation:
        "La page indique que la fouille de véhicule n’est pas soumise aux heures légales.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Fouille de véhicule — Présence de la personne",
    question:
        "En enquête préliminaire, la fouille de véhicule doit être réalisée :",
    options: [
      "En l’absence systématique du conducteur",
      "En présence de la personne trouvée en possession du véhicule",
      "Uniquement en présence du maire",
    ],
    answer: "En présence de la personne trouvée en possession du véhicule",
    explanation:
        "Le texte précise que, compte tenu du caractère non coercitif, la fouille est réalisée en présence de cette personne.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Fouille de véhicule — Assentiment",
    question:
        "Quelle autorisation est requise pour fouiller un véhicule en enquête préliminaire ?",
    options: [
      "Une autorisation orale quelconque",
      "L’autorisation de la personne trouvée en possession du véhicule, sous forme d’un assentiment exprès et écrit",
      "Aucune autorisation n’est nécessaire",
    ],
    answer:
        "L’autorisation de la personne trouvée en possession du véhicule, sous forme d’un assentiment exprès et écrit",
    explanation:
        "Le texte indique qu’elle suppose l’autorisation dans les formes prévues pour les perquisitions (assentiment exprès et écrit).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Fouille de véhicule — Référence légale",
    question:
        "Selon la jurisprudence citée (Cass. crim., 16 janv. 2024, n° 22-87.593), sauf texte spécial, la fouille du véhicule ne peut être effectuée qu’avec l’assentiment recueilli selon :",
    options: [
      "L’article 63-7 du C.P.P.",
      "L’article 76 du C.P.P.",
      "L’article 60 du C.P.P.",
    ],
    answer: "L’article 76 du C.P.P.",
    explanation:
        "La décision de la Cour de cassation mentionnée renvoie expressément aux conditions de l’article 76 C.P.P.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  const QuizQuestion(
    category: "Fouille intégrale — Qualification procédurale",
    question:
        "Pourquoi, en enquête préliminaire, la fouille intégrale d’une personne gardée à vue est-elle assimilée à une perquisition au sens du C.P.P. ?",
    options: [
      "Parce qu’elle se déroule toujours au domicile du mis en cause",
      "Parce qu’elle constitue une intrusion importante dans la sphère privée justifiée par la recherche de la preuve et nécessitant l’assentiment de la personne",
      "Parce qu’elle ne nécessite aucun contrôle judiciaire",
    ],
    answer:
        "Parce qu’elle constitue une intrusion importante dans la sphère privée justifiée par la recherche de la preuve et nécessitant l’assentiment de la personne",
    explanation:
        "Le texte souligne à la fois son caractère intrusif et son assimilation aux perquisitions quant au formalisme.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Fouille intégrale — Articulation avec garde à vue",
    question:
        "Quelle articulation entre la garde à vue et la fouille intégrale ressort de l’article 63-7 C.P.P. et du texte étudié ?",
    options: [
      "La fouille intégrale peut se faire avant toute mesure de garde à vue",
      "La fouille intégrale ne peut être pratiquée que sur une personne déjà placée en garde à vue et pour les nécessités de l’enquête",
      "La fouille intégrale est indépendante de toute mesure de garde à vue",
    ],
    answer:
        "La fouille intégrale ne peut être pratiquée que sur une personne déjà placée en garde à vue et pour les nécessités de l’enquête",
    explanation:
        "Le texte relie expressément cette fouille au statut de gardé à vue et aux nécessités de l’enquête.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Fouille intégrale — Heures légales vs perquisitions",
    question:
        "Que révèle la possibilité de pratiquer une fouille intégrale de jour comme de nuit sur la logique du régime des fouilles par rapport aux perquisitions domiciliaires ?",
    options: [
      "Que les fouilles sont moins intrusives que les perquisitions",
      "Qu’elles obéissent à une logique propre liée à la personne, distincte du respect des heures légales fixées pour les lieux",
      "Qu’elles ne sont pas encadrées légalement",
    ],
    answer:
        "Qu’elles obéissent à une logique propre liée à la personne, distincte du respect des heures légales fixées pour les lieux",
    explanation:
        "La règle spécifique sur les heures montre que le législateur distingue l’atteinte au domicile de l’atteinte au corps.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Fouille de véhicule — Vie privée",
    question:
        "Pourquoi la jurisprudence assimile-t-elle la fouille d’un véhicule à une perquisition, alors même que le véhicule n’est pas un domicile au sens strict ?",
    options: [
      "Parce qu’un véhicule est toujours immobilisé au domicile",
      "En raison de l’intrusion qu’elle représente dans l’intimité de la vie privée de son occupant",
      "Parce que tout véhicule est présumé être un domicile",
    ],
    answer:
        "En raison de l’intrusion qu’elle représente dans l’intimité de la vie privée de son occupant",
    explanation:
        "La décision citée indique que c’est l’atteinte à la vie privée qui justifie l’assimilation.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Fouille de véhicule — Assentiment et formalisme",
    question:
        "D’un point de vue pratique, quel formalisme l’assentiment à la fouille d’un véhicule doit-il respecter ?",
    options: [
      "Aucun formalisme particulier n’est exigé",
      "Il doit être clair, libre, éclairé, consigné par écrit et signé par la personne",
      "Il peut être implicite et non consigné",
    ],
    answer:
        "Il doit être clair, libre, éclairé, consigné par écrit et signé par la personne",
    explanation:
        "Le NotaBox final précise que l’assentiment doit être recueilli de manière claire, libre et éclairée, consigné par écrit et signé.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Fouilles — Proportionnalité",
    question:
        "Comment le principe de proportionnalité se manifeste-t-il dans le régime des fouilles en enquête préliminaire ?",
    options: [
      "Par la possibilité systématique de fouiller toute personne sans motif",
      "Par l’exigence que la fouille soit justifiée par les nécessités de l’enquête et limitée à ce qui est strictement nécessaire à la recherche de la preuve",
      "Par l’absence totale de contrôle sur les décisions de l’O.P.J.",
    ],
    answer:
        "Par l’exigence que la fouille soit justifiée par les nécessités de l’enquête et limitée à ce qui est strictement nécessaire à la recherche de la preuve",
    explanation:
        "Le texte rappelle que les fouilles doivent être justifiées par l’enquête et limitées au strict nécessaire.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Fouilles — Distinction avec palpations",
    question:
        "Sur le plan théorique, quelle distinction majeure le texte opère entre la fouille et la simple palpation de sécurité ?",
    options: [
      "La palpation ne peut jamais être utilisée en enquête préliminaire",
      "La fouille implique une intrusion plus profonde, orientée vers la recherche de la preuve, alors que la palpation vise la sécurité immédiate",
      "La palpation est plus intrusive que la fouille",
    ],
    answer:
        "La fouille implique une intrusion plus profonde, orientée vers la recherche de la preuve, alors que la palpation vise la sécurité immédiate",
    explanation:
        "La page souligne que la fouille est plus intrusive et liée à l’établissement de la preuve, contrairement à la simple sécurité.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Fouilles — Domaine personnel vs matériel",
    question:
        "En synthèse, que révèle la distinction entre fouille intégrale et fouille de véhicule sur les domaines d’atteinte en enquête préliminaire ?",
    options: [
      "Qu’il n’existe aucune différence entre atteinte aux personnes et atteinte aux biens",
      "Qu’il existe un régime spécifique pour l’atteinte au corps (dignité, sexe, lieu de fouille) et un régime proche de la perquisition pour l’atteinte aux biens (véhicule)",
      "Que les véhicules sont juridiquement assimilés à des personnes",
    ],
    answer:
        "Qu’il existe un régime spécifique pour l’atteinte au corps (dignité, sexe, lieu de fouille) et un régime proche de la perquisition pour l’atteinte aux biens (véhicule)",
    explanation:
        "La structure du texte distingue clairement ces deux domaines d’atteinte, chacun avec ses garanties propres.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Fouilles — Logique d’ensemble",
    question:
        "En quoi le régime des fouilles (intégrale et véhicule) illustre-t-il la logique générale de l’enquête préliminaire ?",
    options: [
      "Il montre l’absence totale de formalités dans ce cadre",
      "Il illustre un équilibre entre la recherche de la preuve et la protection de la dignité et de la vie privée, via l’assentiment et des conditions strictes",
      "Il remplace toutes les règles sur les perquisitions",
    ],
    answer:
        "Il illustre un équilibre entre la recherche de la preuve et la protection de la dignité et de la vie privée, via l’assentiment et des conditions strictes",
    explanation:
        "La page rappelle constamment la nécessité de concilier efficacité de l’enquête et libertés individuelles.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Fouille de véhicule — Jurisprudence Cass. crim. 2024",
    question:
        "Selon l’arrêt Cass. crim., 16 janv. 2024, n° 22-87.593, à défaut de texte spécial autorisant la fouille de véhicule :",
    options: [
      "Les enquêteurs peuvent fouiller tout véhicule sans formalité",
      "La fouille ne peut être effectuée qu’avec l’assentiment du propriétaire ou du conducteur, recueilli selon les conditions de l’article 76 C.P.P.",
      "La fouille doit être ordonnée par le juge d’instruction dans tous les cas",
    ],
    answer:
        "La fouille ne peut être effectuée qu’avec l’assentiment du propriétaire ou du conducteur, recueilli selon les conditions de l’article 76 C.P.P.",
    explanation:
        "La jurisprudence citée dans le texte énonce précisément cette exigence d’assentiment conforme à l’article 76 du C.P.P.",
    difficulty: "Difficile",
  ),

  // ===================== GARDE À VUE EN ENQUÊTE PRÉLIMINAIRE =====================
  // ===================== NIVEAU FACILE =====================
  const QuizQuestion(
    category: "Base légale — Enquête préliminaire",
    question:
        "Quel article du Code de procédure pénale précise que les règles de la garde à vue s’appliquent à l’enquête préliminaire ?",
    options: [
      "Article 75 du Code de procédure pénale",
      "Article 77 du Code de procédure pénale",
      "Article 63 du Code de procédure pénale",
    ],
    answer: "Article 77 du Code de procédure pénale",
    explanation:
        "Le texte indique que l’article 77 C.P.P. se rapporte à la garde à vue en enquête préliminaire et renvoie aux articles 62-2 à 64-1 C.P.P.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Base légale — Articles applicables",
    question:
        "Les règles générales de la garde à vue applicables à l’enquête préliminaire sont prévues aux :",
    options: [
      "Articles 62-2 à 64-1 du Code de procédure pénale",
      "Articles 14 à 19 du Code de procédure pénale",
      "Articles 706-88 à 706-94 du Code de procédure pénale",
    ],
    answer: "Articles 62-2 à 64-1 du Code de procédure pénale",
    explanation:
        "L’introduction précise que l’article 77 C.P.P. renvoie aux articles 62-2 à 64-1 C.P.P. pour la garde à vue en enquête préliminaire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions — Raison plausible",
    question: "Une personne peut être placée en garde à vue lorsqu’il existe :",
    options: [
      "Un simple doute sur sa présence dans la commune",
      "Une ou plusieurs raisons plausibles de soupçonner qu’elle a commis ou tenté de commettre un crime ou un délit puni d’emprisonnement",
      "Une rumeur non vérifiée à son sujet",
    ],
    answer:
        "Une ou plusieurs raisons plausibles de soupçonner qu’elle a commis ou tenté de commettre un crime ou un délit puni d’emprisonnement",
    explanation:
        "Le texte rappelle que la garde à vue suppose des raisons plausibles de soupçonner un crime ou un délit puni d’emprisonnement.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Objectifs — Article 62-2",
    question: "Les objectifs légaux de la garde à vue sont définis par :",
    options: [
      "L’article 62-2 du Code de procédure pénale",
      "L’article 63-1 du Code de procédure pénale",
      "L’article 78-4 du Code de procédure pénale",
    ],
    answer: "L’article 62-2 du Code de procédure pénale",
    explanation:
        "Le texte précise que les objectifs (préservation des preuves, prévention des pressions, etc.) sont définis par l’article 62-2 C.P.P.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Nature — Caractère coercitif",
    question: "En enquête préliminaire, la garde à vue :",
    options: [
      "N’est pas coercitive",
      "Conserve la même nature coercitive qu’en enquête de flagrance",
      "Est purement facultative et symbolique",
    ],
    answer: "Conserve la même nature coercitive qu’en enquête de flagrance",
    explanation:
        "Le NotaBox précise qu’en enquête préliminaire, la garde à vue garde la même nature coercitive qu’en flagrance.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions — Nécessité",
    question: "La garde à vue ne peut être décidée que si :",
    options: [
      "Elle est plus pratique pour les enquêteurs",
      "Elle constitue le seul moyen d’atteindre l’un des objectifs légaux de l’article 62-2 C.P.P.",
      "La personne refuse de répondre aux questions",
    ],
    answer:
        "Elle constitue le seul moyen d’atteindre l’un des objectifs légaux de l’article 62-2 C.P.P.",
    explanation:
        "Le texte insiste sur le fait que la mesure doit être le seul moyen d’atteindre un des objectifs légaux de la garde à vue.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Hypothèses — Présentation volontaire",
    question:
        "Une première hypothèse de mise en garde à vue en enquête préliminaire est celle de :",
    options: [
      "La présentation volontaire de la personne au service de police ou de gendarmerie",
      "La dénonciation anonyme sur internet",
      "La simple rédaction d’un courrier au parquet",
    ],
    answer:
        "La présentation volontaire de la personne au service de police ou de gendarmerie",
    explanation:
        "Le point B.1 expose le cas de la présentation volontaire, spontanée ou sur convocation.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Départ du délai — Présentation volontaire",
    question:
        "En cas de placement en garde à vue après une présentation volontaire, le point de départ du délai de 24 heures est :",
    options: [
      "L’heure du placement formel en garde à vue",
      "L’heure du début de l’audition",
      "L’heure de la décision du procureur",
    ],
    answer: "L’heure du début de l’audition",
    explanation:
        "Le texte indique que dans ce cas, le délai maximal de 24 heures commence à courir à compter du début de l’audition.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Titre de contrainte — Définition",
    question:
        "Le titre de contrainte qui permet de conduire une personne devant le service d’enquête est :",
    options: [
      "Un ordre de comparution délivré par le procureur de la République",
      "Une simple convocation téléphonique",
      "Un mandat d’arrêt international",
    ],
    answer: "Un ordre de comparution délivré par le procureur de la République",
    explanation:
        "Le texte précise que la personne peut être conduite en vertu d’un titre de contrainte, ordre de comparution du procureur.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Durée — Garde à vue initiale",
    question:
        "En enquête préliminaire, la durée initiale maximale de la garde à vue est de :",
    options: ["12 heures", "24 heures", "48 heures"],
    answer: "24 heures",
    explanation:
        "La partie C rappelle que la durée initiale est de 24 heures, comme en flagrance.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  const QuizQuestion(
    category: "Conditions — Rappel synthétique",
    question:
        "Selon la section A, le placement en garde à vue en enquête préliminaire suppose :",
    options: [
      "Des indices très légers mais aucune nécessité de la mesure",
      "Des raisons plausibles de soupçonner une infraction punie d’emprisonnement et la nécessité de la mesure pour un objectif légal",
      "Une simple dénonciation anonyme",
    ],
    answer:
        "Des raisons plausibles de soupçonner une infraction punie d’emprisonnement et la nécessité de la mesure pour un objectif légal",
    explanation:
        "Le texte résume ces deux conditions : soupçons plausibles et nécessité pour un objectif de l’article 62-2 C.P.P.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Proportionnalité — Garde à vue",
    question: "Le texte rappelle que la garde à vue doit toujours demeurer :",
    options: [
      "Strictement nécessaire et proportionnée à l’objectif recherché",
      "La mesure la plus longue possible",
      "Une mesure automatique en cas de suspicion",
    ],
    answer: "Strictement nécessaire et proportionnée à l’objectif recherché",
    explanation:
        "Le NotaBox indique que la garde à vue doit rester strictement nécessaire et proportionnée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Titre de contrainte — Apparition des soupçons",
    question:
        "Lorsqu’une personne est conduite par titre de contrainte sans raison plausible initiale de soupçon, à quel moment la garde à vue devient-elle possible ?",
    options: [
      "Dès la délivrance du titre de contrainte",
      "Uniquement sur décision ultérieure du juge d’instruction",
      "Lorsque, au cours de l’audition, apparaissent des raisons plausibles de soupçonner une infraction punie d’emprisonnement",
    ],
    answer:
        "Lorsque, au cours de l’audition, apparaissent des raisons plausibles de soupçonner une infraction punie d’emprisonnement",
    explanation:
        "Le texte précise que la garde à vue devient possible lorsque de telles raisons apparaissent au cours de l’audition.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Titre de contrainte — Point de départ du délai",
    question:
        "En cas de placement en garde à vue après un titre de contrainte sans soupçons initiaux, le point de départ du délai est fixé :",
    options: [
      "À l’instant de la notification de la garde à vue",
      "À l’heure du début de la contrainte",
      "Au moment de la fin de l’audition",
    ],
    answer: "À l’heure du début de la contrainte",
    explanation:
        "Le texte indique que le point de départ de la garde à vue est le début de la contrainte.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Titre de contrainte — Personne déjà soupçonnée",
    question:
        "Lorsque des raisons plausibles de soupçonner existent déjà au moment du titre de contrainte, la personne est placée en garde à vue :",
    options: [
      "Uniquement si elle l’accepte",
      "Dès son arrivée au service si l’O.P.J. souhaite la maintenir à sa disposition et qu’un objectif légal est retenu",
      "Seulement après 24 heures de retenue",
    ],
    answer:
        "Dès son arrivée au service si l’O.P.J. souhaite la maintenir à sa disposition et qu’un objectif légal est retenu",
    explanation:
        "Le texte décrit que la garde à vue commence dès son arrivée dans ce cas.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification d’identité — Imputation du temps",
    question:
        "À l’issue d’une rétention pour vérification d’identité, si une garde à vue est décidée, la durée de la rétention :",
    options: [
      "S’ajoute intégralement à celle de la garde à vue",
      "Est sans incidence sur le calcul du délai",
      "S’impute sur la durée totale de la garde à vue",
    ],
    answer: "S’impute sur la durée totale de la garde à vue",
    explanation:
        "Le texte, en renvoyant à l’article 78-4 C.P.P., précise que la durée de la rétention est imputée sur la garde à vue.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Base légale — Vérification d’identité",
    question:
        "Quelle disposition prévoit l’imputation de la durée de la rétention pour vérification d’identité sur celle de la garde à vue ?",
    options: [
      "Article 78-4 du Code de procédure pénale",
      "Article 62-2 du Code de procédure pénale",
      "Article 63-9 du Code de procédure pénale",
    ],
    answer: "Article 78-4 du Code de procédure pénale",
    explanation:
        "Le texte cite expressément l’article 78-4 C.P.P. pour cette imputation.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Indices lors d’une perquisition — Garde à vue",
    question:
        "Lors d’une perquisition, si des raisons plausibles de soupçonner apparaissent à l’égard d’une personne présente sur les lieux :",
    options: [
      "Elle ne peut jamais être placée en garde à vue",
      "Elle peut être placée en garde à vue si les conditions de l’article 62-2 C.P.P. sont réunies",
      "Il faut attendre l’ouverture d’une information judiciaire",
    ],
    answer:
        "Elle peut être placée en garde à vue si les conditions de l’article 62-2 C.P.P. sont réunies",
    explanation:
        "La section B.3 l’indique clairement, y compris en enquête préliminaire.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Témoin retenu — Article 76 al. 3",
    question:
        "Pour un témoin retenu sur le fondement de l’article 76, alinéa 3 C.P.P., si une garde à vue devient nécessaire, le temps de rétention lors de la perquisition :",
    options: [
      "N’est jamais pris en compte",
      "Est déduit de la durée de la garde à vue",
      "Doit être recommencé à zéro",
    ],
    answer: "Est déduit de la durée de la garde à vue",
    explanation:
        "Le texte précise que le temps de rétention est déduit de la durée de la garde à vue.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Durée — Prolongation",
    question:
        "En enquête préliminaire, la garde à vue peut être prolongée une fois pour :",
    options: [
      "12 heures supplémentaires",
      "24 heures supplémentaires",
      "72 heures supplémentaires",
    ],
    answer: "24 heures supplémentaires",
    explanation:
        "La partie C précise que la durée initiale de 24 heures est renouvelable une fois pour 24 heures sur décision du procureur.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Prolongation — Moment",
    question: "La décision de prolongation de la garde à vue doit intervenir :",
    options: [
      "Après l’expiration du premier délai de 24 heures",
      "À tout moment, sans contrainte",
      "Avant l’expiration du premier délai de 24 heures",
    ],
    answer: "Avant l’expiration du premier délai de 24 heures",
    explanation:
        "Le texte rappelle que la prolongation doit intervenir avant la fin du premier délai.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Prolongation — Motivation",
    question: "La décision de prolongation de la garde à vue :",
    options: [
      "Doit être spécialement motivée par écrit",
      "N’a pas à être spécialement motivée",
      "Doit être validée par le J.L.D.",
    ],
    answer: "N’a pas à être spécialement motivée",
    explanation:
        "La page précise expressément que la décision de prolongation n’a pas à être spécialement motivée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Prolongation — Présentation au magistrat",
    question:
        "Avant de décider la prolongation, il appartient aux magistrats :",
    options: [
      "De présenter systématiquement la personne en présentiel",
      "D’apprécier, selon les circonstances, s’il est opportun de présenter la personne, éventuellement par visioconférence",
      "De déléguer cette décision à l’O.P.J.",
    ],
    answer:
        "D’apprécier, selon les circonstances, s’il est opportun de présenter la personne, éventuellement par visioconférence",
    explanation:
        "Le texte mentionne cette appréciation, avec la possibilité de visioconférence (art. 706-71 C.P.P.).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Extension de compétence — Prolongation",
    question:
        "En cas d’extension de compétence, qui peut ordonner la prolongation de la garde à vue ?",
    options: [
      "Uniquement le procureur directeur d’enquête",
      "Le procureur de la République du lieu d’exécution de la mesure, en application de l’article 63-9 C.P.P.",
      "Le juge d’instruction du ressort voisin",
    ],
    answer:
        "Le procureur de la République du lieu d’exécution de la mesure, en application de l’article 63-9 C.P.P.",
    explanation:
        "Le texte cite l’article 63-9 C.P.P. et la compétence du procureur du lieu d’exécution.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  const QuizQuestion(
    category: "Extension de compétence — Rôle du procureur directeur d’enquête",
    question:
        "Avant de décider la prolongation en cas d’extension de compétence, l’O.P.J. doit :",
    options: [
      "Uniquement informer le gardé à vue",
      "Prévenir le maire de la commune",
      "Référer préalablement au procureur de la République directeur d’enquête pour justifier la nécessité de prolonger",
    ],
    answer:
        "Référer préalablement au procureur de la République directeur d’enquête pour justifier la nécessité de prolonger",
    explanation:
        "Le texte précise cette obligation de référer au procureur directeur d’enquête avant prolongation par le procureur du lieu d’exécution.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Sort de la garde à vue — Fin de mesure",
    question:
        "À l’issue de la garde à vue en enquête préliminaire, lorsque des éléments suffisants existent à l’encontre de la personne :",
    options: [
      "Elle est nécessairement incarcérée",
      "Elle est soit remise en liberté (éventuellement avec convocation), soit déférée devant le procureur",
      "La procédure est automatiquement classée sans suite",
    ],
    answer:
        "Elle est soit remise en liberté (éventuellement avec convocation), soit déférée devant le procureur",
    explanation:
        "La partie C décrit ces deux issues possibles : remise en liberté ou déferrement.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Droits — Information initiale",
    question:
        "Le droit d’être immédiatement informé de la nature de l’infraction reprochée et de ses droits en garde à vue est prévu par :",
    options: [
      "L’article 63-1 du Code de procédure pénale",
      "L’article 62-2 du Code de procédure pénale",
      "L’article 78-4 du Code de procédure pénale",
    ],
    answer: "L’article 63-1 du Code de procédure pénale",
    explanation:
        "La section D rappelle ce droit fondamental en renvoyant à l’article 63-1 C.P.P.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Droits — Prévenir un proche et l’employeur",
    question:
        "Le droit pour la personne gardée à vue de faire prévenir un proche, son employeur ou les autorités consulaires est prévu par :",
    options: [
      "L’article 63-2 du Code de procédure pénale",
      "L’article 63-3 du Code de procédure pénale",
      "L’article 64 du Code de procédure pénale",
    ],
    answer: "L’article 63-2 du Code de procédure pénale",
    explanation:
        "Le texte détaille ces droits en renvoyant à l’article 63-2 C.P.P.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Droits — Examen médical",
    question:
        "Le droit à un examen médical pour la personne gardée à vue est prévu par :",
    options: [
      "L’article 63-3 du Code de procédure pénale",
      "L’article 64-1 du Code de procédure pénale",
      "L’article 77 du Code de procédure pénale",
    ],
    answer: "L’article 63-3 du Code de procédure pénale",
    explanation:
        "La liste des droits renvoie à l’article 63-3 C.P.P. pour l’examen médical.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Droits — Assistance d’un avocat",
    question:
        "Le droit à l’assistance d’un avocat pour la personne gardée à vue est prévu par :",
    options: [
      "L’article 63-3-1 du Code de procédure pénale",
      "L’article 63-1 du Code de procédure pénale",
      "L’article 78-4 du Code de procédure pénale",
    ],
    answer: "L’article 63-3-1 du Code de procédure pénale",
    explanation:
        "Le texte renvoie à l’article 63-3-1 C.P.P. pour ce droit fondamental.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Formalisme — PV et enregistrement",
    question:
        "Le procès-verbal de garde à vue et l’enregistrement audiovisuel des auditions en matière criminelle sont prévus respectivement par :",
    options: [
      "Les articles 64 et 64-1 du Code de procédure pénale",
      "Les articles 62-2 et 62-3 du Code de procédure pénale",
      "Les articles 706-88 et 706-89 du Code de procédure pénale",
    ],
    answer: "Les articles 64 et 64-1 du Code de procédure pénale",
    explanation:
        "La section D évoque ces formalités en renvoyant à 64 (PV) et 64-1 (enregistrement audiovisuel).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Régimes dérogatoires — Criminalité organisée",
    question:
        "Les régimes dérogatoires de garde à vue en matière de criminalité organisée sont prévus par :",
    options: [
      "Les articles 706-88 et suivants du Code de procédure pénale",
      "L’article 77 du Code de procédure pénale",
      "L’article 63-9 du Code de procédure pénale",
    ],
    answer: "Les articles 706-88 et suivants du Code de procédure pénale",
    explanation:
        "Le NotaBox final précise que ces régimes dérogatoires sont étudiés ailleurs et renvoie aux articles 706-88 et suivants.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Mineurs — Applicabilité",
    question:
        "Les dispositions spécifiques applicables aux mineurs en matière de garde à vue, de retenue et de défèrement :",
    options: [
      "Ne s’appliquent pas en enquête préliminaire",
      "S’appliquent en enquête préliminaire dans les mêmes conditions qu’en cas de flagrant délit",
      "Sont réservées aux informations judiciaires",
    ],
    answer:
        "S’appliquent en enquête préliminaire dans les mêmes conditions qu’en cas de flagrant délit",
    explanation:
        "Le texte précise que ces dispositions s’appliquent de la même manière en préliminaire et en flagrance.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Théorie — Nature de la garde à vue en préliminaire",
    question:
        "Sur le plan théorique, que montre l’application des articles 62-2 à 64-1 à l’enquête préliminaire via l’article 77 C.P.P. ?",
    options: [
      "Que la garde à vue en préliminaire obéit à un régime entièrement distinct de celui de la flagrance",
      "Que la garde à vue en préliminaire est alignée sur le régime général de la garde à vue, avec la même nature coercitive et les mêmes garanties",
      "Qu’elle n’offre pas les droits classiques au gardé à vue",
    ],
    answer:
        "Que la garde à vue en préliminaire est alignée sur le régime général de la garde à vue, avec la même nature coercitive et les mêmes garanties",
    explanation:
        "Le texte insiste sur la transposition complète des règles générales de garde à vue à l’enquête préliminaire via l’article 77 C.P.P.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Proportionnalité — Analyse globale",
    question:
        "En synthèse, quelle exigence majeure ressort de l’ensemble des règles relatives à la garde à vue en enquête préliminaire ?",
    options: [
      "Utiliser la garde à vue dès qu’une personne est entendue",
      "Veiller à ce que la mesure soit toujours strictement nécessaire, proportionnée, et assortie de garanties effectives (droits, durée, contrôle du parquet)",
      "Limiter les droits de la défense pour faciliter l’enquête",
    ],
    answer:
        "Veiller à ce que la mesure soit toujours strictement nécessaire, proportionnée, et assortie de garanties effectives (droits, durée, contrôle du parquet)",
    explanation:
        "Les sections A à D rappellent constamment nécessité, proportionnalité, contrôle du parquet et droits renforcés du gardé à vue.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Prélèvements — Dignité & vulnérabilité",
    question:
        "Les prélèvements externes et relevés signalétiques doivent être réalisés :",
    options: [
      "En public pour plus de transparence",
      "Dans le respect de la dignité, de préférence dans des locaux adaptés, avec garanties renforcées pour les mineurs et personnes vulnérables",
      "Uniquement au commissariat central",
    ],
    answer:
        "Dans le respect de la dignité, de préférence dans des locaux adaptés, avec garanties renforcées pour les mineurs et personnes vulnérables",
    explanation:
        "Le texte mentionne la dignité, les locaux adaptés, l’abri du public et des garanties supplémentaires pour mineurs et personnes vulnérables.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Théorie — Domaine d’application",
    question:
        "En synthèse, le « domaine d’application » de l’enquête préliminaire renvoie principalement :",
    options: [
      "Aux seules règles de compétence territoriale du parquet",
      "À l’ensemble des infractions, personnes et lieux pouvant être concernés, sous réserve des régimes dérogatoires",
      "Aux seules infractions de terrorisme",
    ],
    answer:
        "À l’ensemble des infractions, personnes et lieux pouvant être concernés, sous réserve des régimes dérogatoires",
    explanation:
        "C’est l’objet même de ce chapitre 1 : définir dans quels cas, à l’égard de qui et où l’enquête préliminaire peut être mise en œuvre.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Doctrine — Document officiel",
    question: "L’exemple documentaire en fin de texte souligne que :",
    options: [
      "Les règles sont susceptibles d'être obsolètes",
      "Les règles présentées sont à jour au 01/07/2025",
      "Le document n’est pas officiel",
    ],
    answer: "Les règles présentées sont à jour au 01/07/2025",
    explanation: "La mention « Version au 01/07/2025 — SDCP » le confirme.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Lieux — Principe",
    question:
        "L’introduction dans un domicile en enquête préliminaire suppose :",
    options: [
      "L’accord verbal préalable du maître des lieux",
      "Un mandat de perquisition obligatoire",
      "La présence de deux témoins indépendants",
    ],
    answer: "L’accord verbal préalable du maître des lieux",
    explanation:
        "Le texte impose cet accord verbal mentionné au procès-verbal.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Nature de la saisie",
    question: "La saisie des comptes bancaires s’inscrit dans la logique de :",
    options: [
      "La réparation civile uniquement",
      "La confiscation de certains biens ou droits mobiliers incorporels",
      "La simple consultation des comptes bancaires",
    ],
    answer: "La confiscation de certains biens ou droits mobiliers incorporels",
    explanation:
        "Le texte précise que la saisie intervient dans le cadre de la procédure de confiscation de certains biens ou droits mobiliers incorporels.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions — Infraction",
    question:
        "La saisie des sommes inscrites sur un compte bancaire peut intervenir notamment lorsque :",
    options: [
      "L’infraction n’est punie que d’une amende",
      "L’infraction est un crime ou un délit puni d’une peine d’emprisonnement supérieure à un an",
      "L’infraction n’est pas prévue par la loi",
    ],
    answer:
        "L’infraction est un crime ou un délit puni d’une peine d’emprisonnement supérieure à un an",
    explanation:
        "Le texte prévoit la saisie lorsque la peine de confiscation est prévue ou lorsque l’infraction est un crime ou un délit puni d’une peine d’emprisonnement supérieure à un an.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Compte visé — Types de comptes",
    question:
        "Quels types de comptes peuvent être visés par la saisie dans ce cadre ?",
    options: [
      "Uniquement les comptes d’épargne",
      "Les comptes de dépôt, comptes de paiement et comptes d’actifs numériques",
      "Uniquement les comptes détenus à l’étranger",
    ],
    answer:
        "Les comptes de dépôt, comptes de paiement et comptes d’actifs numériques",
    explanation:
        "Le texte mentionne explicitement les sommes versées sur un compte de dépôt, un compte de paiement ou un compte d’actifs numériques.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorité compétente — Procureur",
    question:
        "Qui autorise la saisie des comptes bancaires dans le cadre de l’enquête préliminaire ?",
    options: [
      "Le maire de la commune",
      "Le juge de l’application des peines",
      "Le procureur de la République",
    ],
    answer: "Le procureur de la République",
    explanation:
        "L’autorisation de procéder à la saisie est délivrée par tout moyen par le procureur de la République.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorité compétente — Délivrance",
    question:
        "Sous quelle forme le procureur de la République peut-il délivrer son autorisation de saisie ?",
    options: [
      "Uniquement par courrier recommandé",
      "Par tout moyen",
      "Uniquement par ordonnance écrite et signée",
    ],
    answer: "Par tout moyen",
    explanation:
        "Le texte précise que l’autorisation de procéder à la saisie est délivrée « par tout moyen » par le procureur de la République, afin de garantir la réactivité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Contrôle — Juge des libertés et de la détention",
    question:
        "Quel magistrat est chargé du contrôle juridictionnel de la saisie des comptes bancaires ?",
    options: [
      "Le juge des libertés et de la détention (J.L.D.)",
      "Le juge de cassation",
      "Le juge des enfants",
    ],
    answer: "Le juge des libertés et de la détention (J.L.D.)",
    explanation:
        "Le contrôle juridictionnel de la saisie est assuré par le juge des libertés et de la détention, saisi par le procureur de la République.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Contrôle — Délai",
    question:
        "Dans quel délai le Juge des libertés et de la détention doit-il se prononcer sur le maintien ou la mainlevée de la saisie ?",
    options: [
      "Dans un délai de 24 heures",
      "Dans un délai de 10 jours à compter de la réalisation de la saisie",
      "Dans un délai de 2 mois",
    ],
    answer:
        "Dans un délai de 10 jours à compter de la réalisation de la saisie",
    explanation:
        "Le texte indique que le J.L.D. doit se prononcer, par ordonnance motivée, dans un délai de dix jours à compter de la réalisation de la saisie.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  const QuizQuestion(
    category: "Cadre juridique — Références légales",
    question:
        "La définition des comptes pouvant être saisis (dont les comptes d’actifs numériques) renvoie à :",
    options: [
      "L’article L. 54-10-1 du Code monétaire et financier",
      "L’article 78-2 du Code de procédure pénale",
      "L’article L. 2212-2 du Code général des collectivités territoriales",
    ],
    answer: "L’article L. 54-10-1 du Code monétaire et financier",
    explanation:
        "Le texte mentionne l’article L. 54-10-1 du Code monétaire et financier pour définir les comptes de dépôt, de paiement et d’actifs numériques concernés.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Cadre juridique — Procédure pénale",
    question:
        "La saisie des sommes inscrites sur un compte bancaire dans ce cadre est notamment prévue par :",
    options: [
      "L’article 706-154 du Code de procédure pénale",
      "L’article 21 du Code de procédure pénale",
      "L’article 63-1 du Code de procédure pénale",
    ],
    answer: "L’article 706-154 du Code de procédure pénale",
    explanation:
        "Le texte renvoie expressément à l’article 706-154 du Code de procédure pénale pour la saisie des sommes inscrites sur un compte.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Conditions — Peine de confiscation",
    question:
        "Parmi les conditions, la saisie des comptes bancaires est possible lorsque :",
    options: [
      "La peine de confiscation est prévue par les textes applicables",
      "La peine encourue est uniquement une sanction disciplinaire",
      "Il n’existe aucune peine prévue par les textes",
    ],
    answer: "La peine de confiscation est prévue par les textes applicables",
    explanation:
        "Le texte précise que la saisie intervient dans le cadre de la procédure de confiscation lorsque la peine de confiscation est prévue par les textes applicables.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Nature de la mesure — Conservatoire",
    question:
        "Quelle est la nature juridique principale de la saisie des comptes bancaires décrite dans le texte ?",
    options: [
      "Une mesure conservatoire",
      "Une peine définitive",
      "Une simple mesure administrative",
    ],
    answer: "Une mesure conservatoire",
    explanation:
        "Le texte précise que la saisie a un caractère conservatoire : elle ne préjuge pas de la décision finale de confiscation.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Objectif — Préservation des fonds",
    question:
        "Quelle finalité principale poursuit le caractère conservatoire de la saisie ?",
    options: [
      "Garantir la présence des fonds pour une éventuelle exécution de la peine de confiscation",
      "Obliger le mis en cause à reconnaître les faits",
      "Mettre fin automatiquement à l’enquête",
    ],
    answer:
        "Garantir la présence des fonds pour une éventuelle exécution de la peine de confiscation",
    explanation:
        "La saisie garantit que les sommes resteront disponibles pour l’exécution ultérieure d’une éventuelle peine de confiscation.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Autorisation — Réactivité",
    question:
        "La possibilité pour le procureur de délivrer l’autorisation de saisie « par tout moyen » permet principalement :",
    options: [
      "De contourner tout contrôle du juge",
      "D’obtenir une réactivité maximale et de limiter les risques de transfert des fonds",
      "De rendre la saisie définitive sans recours",
    ],
    answer:
        "D’obtenir une réactivité maximale et de limiter les risques de transfert des fonds",
    explanation:
        "Le texte insiste sur la rapidité de la validation par le parquet pour limiter le risque de transfert ou de dissimulation des fonds.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Contrôle — Ordonnance",
    question:
        "Sous quelle forme le Juge des libertés et de la détention se prononce-t-il sur la saisie ?",
    options: [
      "Par une simple note manuscrite",
      "Par ordonnance motivée",
      "Par un avis oral non consigné",
    ],
    answer: "Par ordonnance motivée",
    explanation:
        "Le texte impose que le J.L.D. se prononce par ordonnance motivée sur le maintien ou la mainlevée de la saisie.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Contrôle — Moment",
    question:
        "Le Juge des libertés et de la détention doit se prononcer sur la saisie des comptes bancaires :",
    options: [
      "Même si la juridiction de jugement est déjà saisie",
      "Uniquement avant la saisine de la juridiction de jugement",
      "Uniquement après un éventuel appel",
    ],
    answer: "Même si la juridiction de jugement est déjà saisie",
    explanation:
        "Le texte précise que le J.L.D. doit se prononcer sur la saisie, même si la juridiction de jugement est déjà saisie.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Droits fondamentaux — Défense et propriété",
    question:
        "Le contrôle du J.L.D. en matière de saisie des comptes bancaires vise notamment à garantir :",
    options: [
      "Le secret des correspondances privées uniquement",
      "Les droits de la défense et le droit de propriété",
      "Uniquement la rapidité de l’enquête",
    ],
    answer: "Les droits de la défense et le droit de propriété",
    explanation:
        "Le texte rappelle que ce contrôle garantit le respect des droits de la défense et du droit de propriété.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  const QuizQuestion(
    category: "Portée — Actifs numériques",
    question:
        "En matière de saisie des comptes bancaires dans l’enquête préliminaire, les « actifs numériques » visés par le texte :",
    options: [
      "Incluent les jetons et crypto-actifs mentionnés au Code monétaire et financier",
      "Excluent systématiquement les crypto-actifs",
      "Ne concernent que les espèces physiques",
    ],
    answer:
        "Incluent les jetons et crypto-actifs mentionnés au Code monétaire et financier",
    explanation:
        "Le texte vise les comptes d’actifs numériques (jetons, crypto-actifs) mentionnés à l’article L. 54-10-1 du Code monétaire et financier.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Articulation — Enquête préliminaire / confiscation",
    question:
        "Pourquoi la saisie des comptes bancaires en enquête préliminaire s’inscrit-elle dans la logique de la confiscation ?",
    options: [
      "Parce qu’elle constitue déjà, en elle-même, la peine de confiscation",
      "Parce qu’elle prépare et sécurise l’exécution éventuelle ultérieure de la peine de confiscation",
      "Parce qu’elle se substitue au jugement sur le fond",
    ],
    answer:
        "Parce qu’elle prépare et sécurise l’exécution éventuelle ultérieure de la peine de confiscation",
    explanation:
        "La saisie, mesure conservatoire, vise à préserver les sommes pour permettre, le cas échéant, la mise en œuvre ultérieure de la peine de confiscation.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Hiérarchie des acteurs — Procureur / JLD",
    question:
        "Quelle affirmation décrit le mieux l’articulation entre le procureur de la République et le J.L.D. dans la saisie des comptes bancaires ?",
    options: [
      "Le procureur autorise la saisie et le J.L.D. exerce un contrôle juridictionnel sur son maintien ou sa mainlevée",
      "Le J.L.D. autorise la saisie et le procureur la contrôle",
      "Ni le procureur ni le J.L.D. n’interviennent dans la saisie",
    ],
    answer:
        "Le procureur autorise la saisie et le J.L.D. exerce un contrôle juridictionnel sur son maintien ou sa mainlevée",
    explanation:
        "Le procureur donne l’autorisation par tout moyen, puis le J.L.D., saisi par le procureur, contrôle la mesure et statue par ordonnance motivée.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Efficacité — Investigations financières",
    question:
        "Le texte souligne que le contrôle par le J.L.D. doit concilier :",
    options: [
      "Uniquement la rapidité de l’exécution des peines",
      "L’efficacité des investigations financières et le respect des droits fondamentaux",
      "La confidentialité totale à l’égard du mis en cause, sans information",
    ],
    answer:
        "L’efficacité des investigations financières et le respect des droits fondamentaux",
    explanation:
        "Le contrôle par le J.L.D. garantit les droits de la défense et le droit de propriété tout en préservant l’efficacité des investigations financières.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Portée temporelle — Effets de la saisie",
    question:
        "En pratique, le caractère conservatoire de la saisie des comptes bancaires signifie que :",
    options: [
      "La saisie emporte automatiquement confiscation définitive des sommes",
      "La saisie bloque les fonds pour les maintenir disponibles, sans préjuger de la décision finale de confiscation",
      "Les fonds sont immédiatement transférés au Trésor public",
    ],
    answer:
        "La saisie bloque les fonds pour les maintenir disponibles, sans préjuger de la décision finale de confiscation",
    explanation:
        "Le texte précise que la saisie est conservatoire : elle n’anticipe pas la décision de confiscation mais garantit la disponibilité future des fonds.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizEnquetePreliminairePageGPX extends StatefulWidget {
  static const String grade = 'gpx';
  static const String routeName = '/gpx/generalites/quiz/enquete_preliminaire';
  final String uid;
  final String email;

  const QuizEnquetePreliminairePageGPX({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizEnquetePreliminairePageGPX> createState() => _QuizEnquetePreliminairePageGPXState();
}

class _QuizEnquetePreliminairePageGPXState extends State<QuizEnquetePreliminairePageGPX>
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
  static const _introHiddenKey = 'intro_gpx_enquete_preliminaire';
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
        ? questionsEnquetePrelim
        : questionsEnquetePrelim
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
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Cadres Juridiques',
            'quiz_name': 'L`enquête préliminaire',
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
      await _sb.from('quiz_enquete_preliminaire').insert({
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
      debugPrint('❌ quiz_enquete_preliminaire insert failed: $e');
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
      await _updateHistoryOnFinish();
      if (!mounted) return;
      _openResultDialog(_score, _qs.length);
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
      'source_file': 'gpx_quiz_enquete_preliminaire_page',
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
                            icon: Icons.manage_search_rounded,
                            title: 'Enquête préliminaire',
                            description: 'Maîtrise le cadre de l’enquête préliminaire : pouvoirs des enquêteurs, droits des personnes et actes autorisés.',
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
      builder: (_, c) {
        final s = c.maxWidth * 0.56;
        final size = s.clamp(140.0, 240.0);
        return SizedBox(
          height: size,
          child: Center(
            // >>> Choisis UNE des 3 lignes ci-dessous <<<
            // child: _FeedbackConfettiBurst(controller: controller, good: good, size: size),
            // child: _FeedbackStrokeDraw(controller: controller, good: good, size: size),
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
        // t normalisé 0..1 (au cas où)
        final t =
            ((controller.value - controller.lowerBound) /
                    (controller.upperBound - controller.lowerBound))
                .clamp(0.0, 1.0);
        final icon = good ? Icons.check_rounded : Icons.close_rounded;
        final iconSize = size * .30;

        const n = 8;
        final maxR = size * .58;
        final kids = <Widget>[];

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

        return Stack(
          alignment: Alignment.center,
          children: [
            ...kids,
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
