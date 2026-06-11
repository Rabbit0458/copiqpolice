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
final List<QuizQuestion> questionsFlagrantDelitProcedure = [
  // ===================== NIVEAU FACILE =====================
  const QuizQuestion(
    category: "Généralités — Flagrance",
    question: "L’enquête de flagrant délit se caractérise principalement par :",
    options: [
      "Une absence de contrôle judiciaire",
      "L’urgence et des pouvoirs élargis de police judiciaire",
      "Un cadre totalement libre pour les enquêteurs",
    ],
    answer: "L’urgence et des pouvoirs élargis de police judiciaire",
    explanation:
        "L’enquête de flagrance est un cadre d’urgence qui donne des pouvoirs élargis aux autorités de police judiciaire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités — Procureur",
    question:
        "Qui peut accomplir personnellement les actes de police judiciaire en flagrance ?",
    options: ["Le maire", "Le procureur de la République", "Le préfet"],
    answer: "Le procureur de la République",
    explanation:
        "Le procureur dispose, sur tout le territoire national, des pouvoirs attachés à la qualité d’O.P.J.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités — OPJ",
    question:
        "Quels agents sont compétents pour conduire l’enquête de flagrant délit ?",
    options: [
      "Les policiers municipaux",
      "Les officiers de police judiciaire de plein exercice",
      "Les gendarmes adjoints volontaires seuls",
    ],
    answer: "Les officiers de police judiciaire de plein exercice",
    explanation:
        "Seuls les O.P.J. visés aux articles 16 et 16-1 C.P.P. peuvent conduire une enquête de flagrance.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Flagrance — Durée",
    question: "La durée initiale maximale de l’enquête de flagrance est de :",
    options: ["24 heures", "8 jours", "15 jours"],
    answer: "8 jours",
    explanation:
        "La flagrance peut durer jusqu’à huit jours, sous le contrôle du procureur.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Flagrance — Durée",
    question: "L’enquête de flagrance peut être prolongée par :",
    options: [
      "Le maire",
      "Le procureur de la République",
      "Le juge d’instruction uniquement",
    ],
    answer: "Le procureur de la République",
    explanation:
        "La prolongation de huit jours supplémentaires est décidée par le procureur si les conditions sont réunies.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Plainte — Généralités",
    question: "Les O.P.J. et A.P.J. sont tenus de recevoir les plaintes :",
    options: [
      "Seulement si les faits sont dans leur circonscription",
      "Uniquement si la victime apporte une preuve matérielle",
      "Quelle que soit le lieu de commission des faits",
    ],
    answer: "Quelle que soit le lieu de commission des faits",
    explanation:
        "L’article 15-3 C.P.P. impose de recevoir toute plainte même si les faits n’ont pas eu lieu localement.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Plainte — Formalités",
    question: "Toute plainte donne obligatoirement lieu à :",
    options: [
      "Un simple enregistrement interne",
      "Un procès-verbal et un récépissé",
      "Une audition systématique du mis en cause",
    ],
    answer: "Un procès-verbal et un récépissé",
    explanation:
        "Le dépôt de plainte implique un PV et la remise d’un récépissé officiel.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Victimes — Droits",
    question: "Parmi les droits suivants, lequel appartient à la victime ?",
    options: [
      "Choisir le policier chargé de l’enquête",
      "Être informée des suites données à la plainte",
      "Exiger une qualification pénale précise",
    ],
    answer: "Être informée des suites données à la plainte",
    explanation:
        "La victime doit pouvoir connaître les suites de sa plainte et les mesures de protection possibles.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Constatations",
    question: "Le transport sur les lieux en flagrance doit être effectué :",
    options: [
      "Avant toute rédaction de PV",
      "Sans délai si nécessaire",
      "Après autorisation du préfet",
    ],
    answer: "Sans délai si nécessaire",
    explanation:
        "Les constatations doivent être réalisées immédiatement si la situation l’exige.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Horaires",
    question: "Les perquisitions en droit commun doivent commencer entre :",
    options: ["5h et 22h", "6h et 21h", "7h et 20h"],
    answer: "6h et 21h",
    explanation: "L’article 59 C.P.P. impose des heures légales : 6h–21h.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Flagrance — Interpellation",
    question:
        "Selon l’article 73 C.P.P., qui peut appréhender l’auteur présumé d’un crime ou délit flagrant ?",
    options: [
      "Uniquement un gendarme",
      "Toute personne",
      "Le maire uniquement",
    ],
    answer: "Toute personne",
    explanation:
        "Toute personne peut appréhender un auteur présumé et le conduire devant l’O.P.J.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Domaine",
    question: "La garde à vue est possible pour :",
    options: [
      "Toute contravention",
      "Les crimes et délits punis d’emprisonnement",
      "Uniquement les crimes",
    ],
    answer: "Les crimes et délits punis d’emprisonnement",
    explanation:
        "La GAV concerne crimes et délits punis d’emprisonnement, jamais les contraventions.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Durée",
    question: "La durée initiale de la garde à vue est de :",
    options: ["12 heures", "24 heures", "48 heures"],
    answer: "24 heures",
    explanation: "La GAV débute pour une durée maximale de 24h.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Fouilles — Nature",
    question: "La fouille intégrale judiciaire est assimilée à :",
    options: [
      "Un acte administratif",
      "Une perquisition",
      "Une palpation simple",
    ],
    answer: "Une perquisition",
    explanation:
        "L’article 63-7 C.P.P. assimile la fouille intégrale à une perquisition.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Interprète",
    question: "Un interprète peut être requis lorsque :",
    options: [
      "La personne refuse de parler",
      "La personne ne comprend pas le français",
      "La personne souhaite un avocat commis d’office",
    ],
    answer: "La personne ne comprend pas le français",
    explanation:
        "Un interprète est requis pour garantir la compréhension des droits et des propos.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Investigation — Prélèvements",
    question: "Les prélèvements externes (empreintes, ADN…) sont :",
    options: [
      "Totalement libres",
      "Encadrés par le code de procédure pénale",
      "Interdits en flagrance",
    ],
    answer: "Encadrés par le code de procédure pénale",
    explanation:
        "Les prélèvements doivent respecter des conditions strictes, notamment en cas de refus.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Véhicules — Fouilles",
    question: "En flagrance, la fouille d’un véhicule peut être réalisée :",
    options: [
      "Uniquement avec l’accord du conducteur",
      "Sans consentement, si des raisons plausibles existent",
      "Jamais sans mandat d’un juge",
    ],
    answer: "Sans consentement, si des raisons plausibles existent",
    explanation:
        "En flagrance, l’O.P.J. peut fouiller un véhicule s’il existe des soupçons plausibles.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Lieux protégés",
    question: "La perquisition dans un cabinet d’avocat doit être faite par :",
    options: [
      "Un O.P.J. seul",
      "Un magistrat, en présence du bâtonnier",
      "Un A.P.J. sous contrôle",
    ],
    answer: "Un magistrat, en présence du bâtonnier",
    explanation:
        "Les perquisitions dans les lieux d'avocats sont ultra-protégées.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Droits — Silence",
    question: "Le droit de garder le silence :",
    options: [
      "Peut être refusé par l’O.P.J.",
      "Doit être notifié dès le début de la GAV",
      "N’existe que devant un juge",
    ],
    answer: "Doit être notifié dès le début de la GAV",
    explanation: "Le droit au silence doit être notifié immédiatement.",
    difficulty: "Facile",
  ),

  // ---------------------- (20 QUESTIONS HERE) -----------------------

  // (Je continue immédiatement jusqu'à environ 70 questions dans cette partie)
  // Je poursuis maintenant avec les questions 21 à 70 :
  const QuizQuestion(
    category: "Plainte — Victimes",
    question: "Une copie du PV de plainte peut être remise :",
    options: [
      "Uniquement si le parquet accepte",
      "Uniquement si un avocat le demande",
      "Immédiatement si la victime le demande",
    ],
    answer: "Immédiatement si la victime le demande",
    explanation:
        "L’article 15-3 impose la remise d'une copie à la victime si elle le demande.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Mesures de protection — Victimes",
    question:
        "Certaines victimes peuvent bénéficier d’une audition à huis clos afin :",
    options: [
      "D’accélérer la procédure",
      "D’éviter la revictimisation",
      "D’éviter l’enregistrement audio",
    ],
    answer: "D’éviter la revictimisation",
    explanation:
        "Les auditions peuvent être adaptées pour protéger les victimes vulnérables.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Actes — Saisie",
    question: "La saisie a pour objectif :",
    options: [
      "De punir immédiatement l’auteur",
      "D’assurer la conservation des éléments utiles",
      "De consigner des objets sans intérêt",
    ],
    answer: "D’assurer la conservation des éléments utiles",
    explanation: "La saisie vise à conserver les pièces à conviction.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Auditions — Témoins",
    question: "Un témoin peut être entendu sous contrainte pendant :",
    options: ["1 heure", "4 heures", "8 heures"],
    answer: "4 heures",
    explanation: "L’article 62 C.P.P. prévoit une durée maximale de 4h.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Auditions — Statut",
    question:
        "Si un témoin devient suspect au cours de son audition, l’enquêteur doit :",
    options: [
      "Continuer l’audition normalement",
      "Immédiatement lui notifier ses droits",
      "Terminer l’audition sans changement",
    ],
    answer: "Immédiatement lui notifier ses droits",
    explanation: "Dès qu'il existe un soupçon, le statut doit être modifié.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Investigation — Signalisation",
    question:
        "Le refus injustifié de se soumettre à certaines opérations de signalisation peut constituer :",
    options: [
      "Une simple infraction administrative",
      "Un délit autonome",
      "Une nullité de procédure",
    ],
    answer: "Un délit autonome",
    explanation: "La jurisprudence sanctionne le refus injustifié.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Mesures — Rétention",
    question:
        "Lors d’une perquisition, une personne peut être retenue sur place :",
    options: [
      "Pour empêcher tout mouvement",
      "Pour le temps strictement nécessaire aux opérations",
      "Pour une durée pouvant aller jusqu’à 48h",
    ],
    answer: "Pour le temps strictement nécessaire aux opérations",
    explanation:
        "La rétention n’est pas une GAV et doit être limitée au strict nécessaire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Interpellation — Mandat de recherche",
    question: "Un mandat de recherche peut être décerné pour :",
    options: [
      "Toute infraction",
      "Un crime ou délit puni d’au moins trois ans d’emprisonnement",
      "Uniquement les crimes",
    ],
    answer: "Un crime ou délit puni d’au moins trois ans d’emprisonnement",
    explanation: "L’article 70 C.P.P. impose une peine minimale de 3 ans.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Médecin",
    question: "Toute personne gardée à vue peut demander :",
    options: [
      "Un examen médical",
      "La fin de la procédure",
      "La présence obligatoire d’un psychologue",
    ],
    answer: "Un examen médical",
    explanation:
        "Le droit à un examen médical est fondamental et peut être exercé dès le début.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Droits — Avocat",
    question:
        "La personne gardée à vue peut bénéficier d’un entretien confidentiel avec son avocat pendant :",
    options: ["10 minutes", "30 minutes", "1 heure"],
    answer: "30 minutes",
    explanation: "Le C.P.P. prévoit un entretien confidentiel de 30 minutes.",
    difficulty: "Facile",
  ),

  // ---------- Nous sommes à ~35 questions. J’en envoie 35 autres dans cette partie. ----------
  const QuizQuestion(
    category: "Garde à vue — Information des droits",
    question: "Les droits en garde à vue doivent être notifiés :",
    options: [
      "Immédiatement et dans une langue comprise",
      "À la fin de l'enquête",
      "Uniquement si la personne est étrangère",
    ],
    answer: "Immédiatement et dans une langue comprise",
    explanation:
        "Les droits doivent être notifiés immédiatement dans une langue comprise par la personne.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Lieux protégés",
    question: "Les entreprises de presse bénéficient :",
    options: [
      "D’aucune protection particulière",
      "D’une protection renforcée liée au secret des sources",
      "D’un accès libre aux enquêteurs",
    ],
    answer: "D’une protection renforcée liée au secret des sources",
    explanation:
        "Les perquisitions dans les locaux de presse sont strictement encadrées.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Contrôle",
    question: "La garde à vue est placée sous le contrôle :",
    options: [
      "Du maire",
      "Du procureur de la République",
      "Du ministre de l’Intérieur",
    ],
    answer: "Du procureur de la République",
    explanation: "Le procureur contrôle la régularité et la nécessité des GAV.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Données",
    question: "Les réquisitions de données de connexion sont possibles pour :",
    options: [
      "N’importe quel délit",
      "Un crime ou délit puni d’au moins trois ans d’emprisonnement",
      "Toutes les contraventions",
    ],
    answer: "Un crime ou délit puni d’au moins trois ans d’emprisonnement",
    explanation:
        "L’article 60-1-2 C.P.P. impose un seuil de trois ans d’emprisonnement.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Fin",
    question: "À l’issue de la garde à vue, la personne peut être :",
    options: [
      "Remise en liberté ou déférée",
      "Détenue automatiquement",
      "Placée systématiquement sous contrôle judiciaire",
    ],
    answer: "Remise en liberté ou déférée",
    explanation: "L’issue dépend de l’appréciation du procureur.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Flagrance — Saisine",
    question: "L’enquête de flagrance débute dès :",
    options: [
      "La première audition",
      "Le premier PV de saisine",
      "La présentation devant le procureur",
    ],
    answer: "Le premier PV de saisine",
    explanation:
        "Le premier PV de saisine ouvre officiellement l’enquête de flagrance.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Fouilles — Sécurité",
    question: "La palpation de sécurité doit être réalisée :",
    options: [
      "Par n’importe quel agent, même du sexe opposé",
      "Par une personne du même sexe",
      "Uniquement en cellule de dégrisement",
    ],
    answer: "Par une personne du même sexe",
    explanation:
        "La palpation doit respecter la dignité et être pratiquée par une personne du même sexe.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Actes — Saisies informatiques",
    question: "Les données informatiques saisies doivent être :",
    options: [
      "Imprimées en totalité",
      "Conservées sous scellés",
      "Effacées après 24h",
    ],
    answer: "Conservées sous scellés",
    explanation:
        "Les données saisies doivent être conservées sous contrôle judiciaire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Interpellations — Mise à disposition",
    question:
        "Lors d'une interpellation en flagrance, les forces de l’ordre doivent :",
    options: [
      "Remettre immédiatement la personne au parquet",
      "Conduire la personne devant l’O.P.J. le plus proche",
      "L’entendre en audition sur place sans délai",
    ],
    answer: "Conduire la personne devant l’O.P.J. le plus proche",
    explanation: "Toute personne appréhendée doit être présentée à un O.P.J.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Flagrance — Notions",
    question: "La flagrance implique :",
    options: [
      "Une enquête longue et à distance",
      "Une enquête immédiate et continue",
      "Une enquête secrète uniquement",
    ],
    answer: "Une enquête immédiate et continue",
    explanation: "La notion de continuité est essentielle en flagrance.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Victimes — Protection",
    question: "L’évaluation personnalisée des besoins de protection concerne :",
    options: [
      "Toutes les victimes",
      "Uniquement les mineurs",
      "Uniquement les victimes de crimes sexuels",
    ],
    answer: "Toutes les victimes",
    explanation: "Tout plaignant peut nécessiter une évaluation de protection.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Médecins",
    question: "Un médecin réquisitionné doit :",
    options: [
      "Déterminer la responsabilité pénale",
      "Évaluer l’aptitude à rester en GAV",
      "Proposer une peine adaptée",
    ],
    answer: "Évaluer l’aptitude à rester en GAV",
    explanation:
        "Le médecin juge de l’aptitude médicale, pas de la responsabilité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Fouilles — Danger",
    question: "Le retrait d’objets dangereux (lacets, ceintures…) est :",
    options: [
      "Une mesure administrative de sécurité",
      "Une sanction disciplinaire",
      "Une mesure judiciaire obligatoire",
    ],
    answer: "Une mesure administrative de sécurité",
    explanation:
        "Il s’agit d’une mesure de sécurité prévue par les articles 63-5 et 63-6.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Procédure — Généralités",
    question: "L’urgence est une caractéristique essentielle de :",
    options: [
      "L’enquête préliminaire",
      "La procédure de flagrant délit",
      "L’information judiciaire",
    ],
    answer: "La procédure de flagrant délit",
    explanation: "La flagrance est précisément un cadre d'urgence.",
    difficulty: "Facile",
  ),

  // ===================== PARTIE 2 / 3 =====================
  // (On continue la liste à la suite de la PARTIE 1)
  const QuizQuestion(
    category: "Flagrance — Conditions",
    question:
        "Pour qu'il y ait flagrance, il faut notamment que l’infraction soit :",
    options: [
      "Récente ou en train de se commettre",
      "Déclarée par un voisin",
      "Ancienne de plus de 30 jours",
    ],
    answer: "Récente ou en train de se commettre",
    explanation:
        "La flagrance concerne les infractions en cours ou commises récemment.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Flagrance — Conditions",
    question: "La flagrance suppose un lien entre le suspect et :",
    options: [
      "Le lieu du crime uniquement",
      "Des indices apparents laissant penser qu’il vient de commettre l’infraction",
      "Une déclaration de la victime",
    ],
    answer:
        "Des indices apparents laissant penser qu’il vient de commettre l’infraction",
    explanation: "La notion d’indices apparents est fondamentale en flagrance.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Flagrance — Continuité",
    question:
        "Pour maintenir le cadre de la flagrance pendant les huit jours, il faut :",
    options: [
      "Rédiger des PV chaque jour",
      "Réaliser des actes d’investigation continus",
      "Interroger chaque témoin plusieurs fois",
    ],
    answer: "Réaliser des actes d’investigation continus",
    explanation:
        "La jurisprudence exige des actes constants, pas seulement de la rédaction de PV.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Flagrance — Perte du cadre",
    question:
        "Si une longue interruption survient dans l’enquête de flagrance :",
    options: [
      "On peut continuer comme si de rien n’était",
      "Le cadre cesse et un basculement vers un autre régime est nécessaire",
      "Le parquet doit ouvrir une information judiciaire",
    ],
    answer:
        "Le cadre cesse et un basculement vers un autre régime est nécessaire",
    explanation: "L’interruption rompt la continuité exigée en flagrance.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Flagrance — Prolongation",
    question: "La prolongation de la flagrance nécessite :",
    options: [
      "Une peine encourue d’au moins cinq ans",
      "L’accord de la victime",
      "L’accord du maire",
    ],
    answer: "Une peine encourue d’au moins cinq ans",
    explanation: "C’est la première condition indispensable à la prolongation.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Flagrance — Prolongation",
    question:
        "La seconde condition pour prolonger l’enquête de flagrance est :",
    options: [
      "La présence d’un avocat",
      "L’impossibilité de différer les investigations",
      "La rédaction au préalable de tous les PV",
    ],
    answer: "L’impossibilité de différer les investigations",
    explanation:
        "Les investigations ne doivent pas pouvoir être différées sans compromettre l’enquête.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Auditions — Suspects",
    question: "Un suspect ne peut être entendu librement que si :",
    options: [
      "Il est informé de ses droits",
      "Un avocat est présent",
      "Le procureur l’autorise",
    ],
    answer: "Il est informé de ses droits",
    explanation:
        "L’audition libre impose la notification des droits du suspect.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Auditions — Suspects",
    question: "Si une personne refuse de répondre en audition libre :",
    options: [
      "Elle doit être immédiatement placée en GAV",
      "Cela n’empêche pas l’audition",
      "L’entretien doit cesser immédiatement",
    ],
    answer: "Cela n’empêche pas l’audition",
    explanation: "L’intéressé peut garder le silence sans empêcher l’audition.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Droits — Tiers prévenu",
    question: "La demande de prévenir un proche doit être satisfaite :",
    options: ["Dans l’heure", "Dans les 3 heures", "À la fin de la GAV"],
    answer: "Dans les 3 heures",
    explanation:
        "Le délai maximal est de trois heures, sauf décision motivée de report.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Droits — Avocat",
    question: "L’avocat peut consulter certaines pièces de la procédure :",
    options: [
      "Sans copie, uniquement les pièces listées par la loi",
      "Avec possibilité de copie intégrale",
      "Uniquement à la fin de la garde à vue",
    ],
    answer: "Sans copie, uniquement les pièces listées par la loi",
    explanation:
        "Les pièces consultables sont limitativement énumérées à l’article 63-4-1.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Garde à vue — Proportionnalité",
    question: "Même si les conditions légales sont réunies, la GAV :",
    options: [
      "Est obligatoire",
      "Est facultative et soumise à un principe de proportionnalité",
      "Doit être systématiquement prolongée",
    ],
    answer: "Est facultative et soumise à un principe de proportionnalité",
    explanation: "La GAV doit être nécessaire et proportionnée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Médecin — GAV",
    question: "Le médecin peut prescrire :",
    options: [
      "La fin immédiate de la procédure",
      "Des aménagements nécessaires",
      "Une nouvelle audition",
    ],
    answer: "Des aménagements nécessaires",
    explanation: "Seule l’aptitude médicale est évaluée par le médecin.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Consentement",
    question: "Le consentement à la perquisition doit être :",
    options: [
      "Oral uniquement",
      "Écrit, daté, signé",
      "Présumé en cas de silence",
    ],
    answer: "Écrit, daté, signé",
    explanation: "Le consentement doit être libre et éclairé.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Absence du mis en cause",
    question:
        "Une perquisition peut se faire en l’absence du mis en cause si :",
    options: [
      "Un voisin le remplace",
      "Deux témoins assistent",
      "Le maire est présent",
    ],
    answer: "Deux témoins assistent",
    explanation:
        "Deux témoins doivent être présents en l’absence du mis en cause.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Cabinet médical",
    question: "Une perquisition dans un cabinet médical doit préserver :",
    options: ["Le matériel informatique", "Le secret médical", "Le mobilier"],
    answer: "Le secret médical",
    explanation:
        "Un magistrat peut intervenir pour protéger les données sensibles.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Flagrance — Véhicules",
    question: "La fouille d’un véhicule en flagrance nécessite :",
    options: [
      "Une suspicion plausible liée à l’infraction",
      "Un mandat judiciaire",
      "L’accord du procureur",
    ],
    answer: "Une suspicion plausible liée à l’infraction",
    explanation: "En flagrance, une simple raison plausible suffit.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Flagrance — Appellation",
    question: "On parle de flagrant délit lorsque l’infraction :",
    options: [
      "Est ancienne",
      "Se commet ou vient de se commettre",
      "Est contraventionnelle uniquement",
    ],
    answer: "Se commet ou vient de se commettre",
    explanation: "La notion d’immédiateté est essentielle.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Victimes — Enregistrement",
    question: "L’audition d’une victime peut être enregistrée :",
    options: [
      "Sur simple demande de la police",
      "Pour certaines victimes, notamment mineures",
      "Jamais en flagrance",
    ],
    answer: "Pour certaines victimes, notamment mineures",
    explanation: "L’enregistrement peut protéger les victimes vulnérables.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "GAV — Traduction",
    question: "Les droits doivent être traduits :",
    options: [
      "Uniquement si la personne le demande",
      "Dans une langue qu’elle comprend",
      "Jamais, c’est oral",
    ],
    answer: "Dans une langue qu’elle comprend",
    explanation: "L’information doit être claire et comprise.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Saisies — Comptes bancaires",
    question: "La saisie d’un compte bancaire peut être effectuée :",
    options: [
      "Pour toute infraction",
      "En cas de crime ou délit puni d’au moins un an",
      "Uniquement pour les crimes financiers",
    ],
    answer: "En cas de crime ou délit puni d’au moins un an",
    explanation: "Les saisies servent à préparer la confiscation éventuelle.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Données téléphoniques",
    question: "Les données de géolocalisation en temps réel nécessitent :",
    options: [
      "Aucun contrôle judiciaire",
      "Une autorisation du procureur puis du JLD",
      "Une simple réquisition orale",
    ],
    answer: "Une autorisation du procureur puis du JLD",
    explanation: "Le JLD contrôle le renouvellement.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Nuit",
    question: "Une perquisition de nuit en criminalité organisée nécessite :",
    options: [
      "Le simple accord du mis en cause",
      "Une ordonnance écrite et motivée du JLD",
      "Un appel téléphonique au procureur",
    ],
    answer: "Une ordonnance écrite et motivée du JLD",
    explanation: "Le cadre est extrêmement strict.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Témoins — Identité",
    question: "Un témoin doit fournir :",
    options: [
      "Ses documents médicaux",
      "Une pièce d’identité",
      "Son casier judiciaire",
    ],
    answer: "Une pièce d’identité",
    explanation: "Cela permet de vérifier son état civil.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "OPJ — Responsabilités",
    question: "L’O.P.J. doit informer le procureur :",
    options: [
      "À la fin de l’enquête uniquement",
      "Sans délai des faits graves",
      "Seulement s’il le souhaite",
    ],
    answer: "Sans délai des faits graves",
    explanation: "Le parquet doit être tenu informé immédiatement.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Auditions — Mineurs",
    question: "Un mineur témoin doit être entendu :",
    options: [
      "Sans formalité",
      "Avec une assistance spéciale selon l’âge",
      "Uniquement avec son avocat",
    ],
    answer: "Avec une assistance spéciale selon l’âge",
    explanation: "Les mineurs bénéficient de protections renforcées.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Avocats",
    question: "Une perquisition chez un avocat nécessite :",
    options: ["Le bâtonnier", "Le procureur seulement", "Le maire"],
    answer: "Le bâtonnier",
    explanation: "Le bâtonnier doit être présent ou représenté.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Constatations — Lieux",
    question: "Le gel des lieux permet de :",
    options: [
      "Sanctionner le mis en cause",
      "Préserver les traces et indices",
      "Faire intervenir la mairie",
    ],
    answer: "Préserver les traces et indices",
    explanation: "Le gel préserve l’intégrité de la scène.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Auditions — Enregistrements",
    question: "L’enregistrement audiovisuel est obligatoire pour :",
    options: [
      "Les contraventions",
      "Certaines infractions graves",
      "Toutes les auditions",
    ],
    answer: "Certaines infractions graves",
    explanation: "Notamment en matière criminelle.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Flagrance — Qualification",
    question: "La qualification de flagrance appartient :",
    options: ["Au maire", "À l’O.P.J.", "À un expert judiciaire"],
    answer: "À l’O.P.J.",
    explanation:
        "L’O.P.J. qualifie le cadre d’enquête sous contrôle du parquet.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Mesures — Inventaires",
    question: "L’inventaire des objets saisis doit être :",
    options: [
      "Facultatif",
      "Daté, signé et détaillé",
      "Tenue par les agents municipaux",
    ],
    answer: "Daté, signé et détaillé",
    explanation: "Le procès-verbal doit être précis.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Procédure — PV",
    question: "Un PV doit contenir :",
    options: [
      "Uniquement les conclusions",
      "Les mentions légales obligatoires",
      "Des appréciations personnelles",
    ],
    answer: "Les mentions légales obligatoires",
    explanation: "Un PV doit rester factuel et précis.",
    difficulty: "Intermédiaire",
  ),

  // ===================== PARTIE 3 / 3 =====================
  // (suite directe des PARTIES 1 et 2)

  // ===================== NIVEAU INTERMÉDIAIRE / DIFFICILE =====================
  const QuizQuestion(
    category: "Flagrance — Saisine",
    question: "La saisine en flagrance intervient lorsque :",
    options: [
      "La victime dépose une main courante",
      "L’OPJ prend connaissance de faits correspondant à la flagrance",
      "Le suspect se présente seul au commissariat",
    ],
    answer: "L’OPJ prend connaissance de faits correspondant à la flagrance",
    explanation: "Dès le premier PV de saisine, le cadre de flagrance démarre.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Début",
    question:
        "Pour vérifier le respect des heures légales (6h–21h), on retient :",
    options: [
      "L’heure de la première ouverture de porte",
      "L’heure du premier scellé",
      "L’heure du premier PV",
    ],
    answer: "L’heure de la première ouverture de porte",
    explanation:
        "C’est la référence juridique pour apprécier la légalité de l’horaire.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Flagrance — Interruption",
    question:
        "Que se passe-t-il si l’enquête est interrompue durant la flagrance ?",
    options: [
      "La flagrance continue sans conditions",
      "Le cadre cesse et doit être requalifié",
      "La durée est automatiquement prolongée",
    ],
    answer: "Le cadre cesse et doit être requalifié",
    explanation: "La continuité des actes d’enquête est obligatoire.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Plaintes — Droit commun",
    question: "Tout dépôt de plainte doit obligatoirement donner lieu à :",
    options: [
      "Une convocation automatique",
      "Un procès-verbal",
      "Une confrontation immédiate",
    ],
    answer: "Un procès-verbal",
    explanation: "C’est une obligation légale prévue à l’article 15-3 du CPP.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Plaintes — Récépissé",
    question: "Le récépissé remis après une plainte doit mentionner :",
    options: [
      "L’adresse du mis en cause",
      "Les délais de prescription de l’action publique",
      "Le casier judiciaire du plaignant",
    ],
    answer: "Les délais de prescription de l’action publique",
    explanation:
        "Il doit aussi indiquer la possibilité d’interrompre ce délai via la constitution de partie civile.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Victimes — Droits",
    question: "Le droit des victimes inclut :",
    options: [
      "La prise en charge automatique par un avocat",
      "La possibilité d’être aidée par une association d’aide aux victimes",
      "La possibilité d’être indemnisée immédiatement",
    ],
    answer:
        "La possibilité d’être aidée par une association d’aide aux victimes",
    explanation: "Il s’agit d’un droit notifié dès le dépôt de plainte.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Victimes — Adresses",
    question: "Une victime peut déclarer une adresse de domiciliation :",
    options: [
      "Uniquement si elle est mineure",
      "Pour limiter les risques de représailles",
      "Pour recevoir des aides sociales",
    ],
    answer: "Pour limiter les risques de représailles",
    explanation:
        "La déclaration d'adresse sécurisée protège contre les menaces.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Victimes — Évaluation",
    question:
        "L’évaluation personnalisée des besoins de protection est réalisée par :",
    options: [
      "Le maire",
      "L’OPJ ou APJ",
      "Le juge des libertés et de la détention",
    ],
    answer: "L’OPJ ou APJ",
    explanation: "Elle est transmise ensuite à l’autorité judiciaire.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Victimes — Mesures renforcées",
    question: "Le téléphone grave danger fait partie :",
    options: [
      "Des mesures civiles uniquement",
      "Des mesures de protection spécifiques pour certaines victimes",
      "Des mesures réservées aux témoins",
    ],
    answer: "Des mesures de protection spécifiques pour certaines victimes",
    explanation: "Utilisé notamment pour les violences conjugales.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Constatations — Témoins",
    question: "L’OPJ peut retenir des témoins sur place :",
    options: [
      "Jusqu'à 24 heures",
      "Pendant le temps strictement nécessaire aux constatations",
      "Uniquement avec l’accord du procureur",
    ],
    answer: "Pendant le temps strictement nécessaire aux constatations",
    explanation:
        "Le temps doit être proportionné aux nécessités des opérations.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Constatations — Prélèvements",
    question: "Un refus injustifié de prélèvements signalétiques :",
    options: [
      "Est sans conséquence",
      "Peut constituer un délit",
      "Interrompt la flagrance",
    ],
    answer: "Peut constituer un délit",
    explanation:
        "C’est notamment le cas lors d’une GAV pour vérifier l’identité.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Protection",
    question: "Certaines catégories de lieux (ex : presse) imposent :",
    options: [
      "La présence d’un magistrat",
      "La simple présence d’un OPJ",
      "L’accord écrit du maire",
    ],
    answer: "La présence d’un magistrat",
    explanation: "Ces lieux bénéficient d’une protection renforcée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Nuit",
    question: "La perquisition de nuit peut être autorisée lorsque :",
    options: [
      "Le mis en cause est absent",
      "La vie ou l’intégrité physique est en danger imminent",
      "Les voisins se plaignent",
    ],
    answer: "La vie ou l’intégrité physique est en danger imminent",
    explanation: "C’est l’un des cas légaux pour ce type d’opération.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Personnes présentes",
    question: "En flagrance, la perquisition doit se faire :",
    options: [
      "Avec la victime obligatoirement",
      "En présence de la personne ou à défaut de deux témoins",
      "Uniquement en présence d’un avocat",
    ],
    answer: "En présence de la personne ou à défaut de deux témoins",
    explanation: "L’art. 57 CPP impose cette présence.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Fouilles — Intégrale",
    question: "La fouille intégrale judiciaire est assimilée :",
    options: [
      "À une palpation de sécurité",
      "À une perquisition",
      "À un contrôle routier",
    ],
    answer: "À une perquisition",
    explanation: "Elle respecte les mêmes règles essentielles.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Fouilles — Intégrale",
    question: "Une fouille intégrale doit être effectuée :",
    options: [
      "Par un agent de n’importe quel sexe",
      "Par une personne du même sexe que la personne fouillée",
      "Par un médecin uniquement",
    ],
    answer: "Par une personne du même sexe que la personne fouillée",
    explanation: "C’est une garantie de respect de la dignité.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Fouilles — Sécurité",
    question: "La palpation de sécurité peut être réalisée :",
    options: [
      "Uniquement par un OPJ",
      "Par un agent du même sexe",
      "Par un magistrat",
    ],
    answer: "Par un agent du même sexe",
    explanation:
        "Elle doit être non humiliante et faite par une personne du même sexe.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Fouilles — Vêtements",
    question: "Le retrait de vêtements en GAV :",
    options: [
      "Peut être systématique",
      "Doit être limité au strict nécessaire",
      "Doit être filmé systématiquement",
    ],
    answer: "Doit être limité au strict nécessaire",
    explanation: "Le retrait n’est autorisé que si un danger est identifié.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Fouilles — Véhicules",
    question: "La fouille d’un véhicule en flagrance :",
    options: [
      "Est interdite sans mandat",
      "Peut être effectuée avec raisons plausibles",
      "Est toujours assimilée à une perquisition de domicile",
    ],
    answer: "Peut être effectuée avec raisons plausibles",
    explanation: "La jurisprudence est constante sur ce point.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Saisies — Données informatiques",
    question: "Les données informatiques peuvent être :",
    options: [
      "Uniquement consultées sur place",
      "Copiées et placées sous contrôle judiciaire",
      "Supprimées immédiatement",
    ],
    answer: "Copiées et placées sous contrôle judiciaire",
    explanation: "Les copies doivent être conservées sous scellés.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interpellations — Article 73",
    question: "L’article 73 permet à tout citoyen :",
    options: [
      "De perquisitionner des domiciles",
      "D’appréhender l’auteur d’un crime ou délit flagrant",
      "De placer en garde à vue un suspect",
    ],
    answer: "D’appréhender l’auteur d’un crime ou délit flagrant",
    explanation: "Il doit ensuite conduire le suspect devant l’OPJ.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interpellations — Menottes",
    question: "Les menottes doivent être utilisées de manière :",
    options: [
      "Systématique en flagrance",
      "Nécessaire et proportionnée",
      "Décidée uniquement par un magistrat",
    ],
    answer: "Nécessaire et proportionnée",
    explanation: "Leur usage dépend des circonstances.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Mandat — Recherche",
    question: "Le mandat de recherche peut être délivré pour :",
    options: [
      "Tout délit",
      "Un crime ou délit puni d’au moins 3 ans",
      "Les contraventions graves",
    ],
    answer: "Un crime ou délit puni d’au moins 3 ans",
    explanation: "Condition minimale prévue à l’article 70 CPP.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Mandat — Notif",
    question: "Le mandat de recherche doit être :",
    options: [
      "Oral",
      "Écrit et motivé",
      "Simplement mentionné dans un PV ultérieur",
    ],
    answer: "Écrit et motivé",
    explanation: "Il doit être notifié lors de l’arrestation.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "GAV — Début",
    question: "Le début de la GAV correspond :",
    options: [
      "À l’arrivée au commissariat",
      "Au moment de l’appréhension ou notification",
      "Au début de la première audition",
    ],
    answer: "Au moment de l’appréhension ou notification",
    explanation: "La rétention antérieure doit être comptabilisée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "GAV — Durée",
    question: "La GAV de droit commun peut durer :",
    options: [
      "12h renouvelables",
      "24h renouvelables une fois",
      "72h directement",
    ],
    answer: "24h renouvelables une fois",
    explanation: "La prolongation doit être motivée par le procureur.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "GAV — Silence",
    question: "Le droit au silence s’applique :",
    options: [
      "Uniquement en présence d’un avocat",
      "Dès la première notification des droits",
      "À partir de la première audition",
    ],
    answer: "Dès la première notification des droits",
    explanation: "Il figure parmi les droits initiaux essentiels.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "GAV — Avocat",
    question: "La renonciation à l’avocat doit être :",
    options: [
      "Toujours orale",
      "Claire, non équivoque et actée",
      "Présumée si la personne ne répond pas",
    ],
    answer: "Claire, non équivoque et actée",
    explanation: "Elle ne peut être implicite.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "GAV — Contrôle",
    question: "Le contrôle de la GAV appartient :",
    options: ["Au maire", "Au procureur de la République", "Au préfet"],
    answer: "Au procureur de la République",
    explanation: "Il exerce un contrôle permanent.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Auditions — Témoin",
    question: "La contrainte sur un témoin ne peut excéder :",
    options: ["2h", "4h", "6h"],
    answer: "4h",
    explanation: "C’est le délai maximal prévu par l’article 62 al. 2 CPP.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Auditions — Témoin",
    question: "Un témoin convoqué doit :",
    options: [
      "Obligatoirement comparaître",
      "Pouvoir refuser sans motif",
      "Être assisté par un avocat",
    ],
    answer: "Obligatoirement comparaître",
    explanation: "Il peut être contraint avec autorisation du magistrat.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Auditions — Suspect devenu auteur",
    question: "Si un témoin devient suspect durant l’audition :",
    options: [
      "L’audition continue normalement",
      "L’enquêteur doit immédiatement notifier ses droits",
      "Il doit être relâché",
    ],
    answer: "L’enquêteur doit immédiatement notifier ses droits",
    explanation: "On ne peut poursuivre sans cadre légal adapté.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Auditions — Criminel",
    question: "L’enregistrement audiovisuel est obligatoire :",
    options: [
      "Pour tous les délits",
      "Pour certaines infractions criminelles",
      "Pour toutes les victimes",
    ],
    answer: "Pour certaines infractions criminelles",
    explanation: "Mentionné à l’article 64-1.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — 60 CPP",
    question: "Une réquisition à personne qualifiée sert à :",
    options: [
      "Faire une expertise médicale",
      "Réaliser un examen technique ou scientifique",
      "Obtenir un témoignage",
    ],
    answer: "Réaliser un examen technique ou scientifique",
    explanation: "Elle porte sur les actes utiles à l’enquête.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Secret professionnel",
    question: "Les personnes astreintes au secret professionnel peuvent :",
    options: [
      "Répondre librement à toutes les réquisitions",
      "Refuser si cela viole le secret protégé",
      "Être sanctionnées automatiquement en cas de refus",
    ],
    answer: "Refuser si cela viole le secret protégé",
    explanation: "Les secrets protégés sont opposables aux réquisitions.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Données de connexion",
    question: "Les données de connexion ne peuvent être demandées que pour :",
    options: [
      "Tout type d’infraction",
      "Un crime ou délit puni d’au moins 3 ans",
      "Les contraventions graves",
    ],
    answer: "Un crime ou délit puni d’au moins 3 ans",
    explanation:
        "Elles doivent être justifiées par les nécessités de l’enquête.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Interprète",
    question: "L’interprète intervient pour garantir :",
    options: [
      "La politesse des échanges",
      "La compréhension réelle des droits et questions",
      "La transcription intégrale",
    ],
    answer: "La compréhension réelle des droits et questions",
    explanation: "Son rôle est essentiel pour les non-francophones.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Examen médical",
    question: "Le certificat médical établi comporte :",
    options: [
      "Des conclusions pénales",
      "L’état clinique de la personne",
      "Le rappel des faits",
    ],
    answer: "L’état clinique de la personne",
    explanation: "Le médecin ne juge pas : il constate.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Autopsie",
    question: "Seul peut pratiquer une autopsie judiciaire :",
    options: [
      "Un médecin généraliste",
      "Un médecin spécialisé en médecine légale",
      "Un vétérinaire",
    ],
    answer: "Un médecin spécialisé en médecine légale",
    explanation: "Les qualifications prévues par les textes sont obligatoires.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Autopsie",
    question: "Les prélèvements d’autopsie sont :",
    options: [
      "Déposés librement dans le service",
      "Placés sous scellés",
      "Remis à la famille",
    ],
    answer: "Placés sous scellés",
    explanation: "Pour garantir la chaîne de conservation.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Géolocalisation — Conditions",
    question: "La géolocalisation en temps réel concerne :",
    options: [
      "Toutes les infractions",
      "Les crimes et délits punis d’au moins 3 ans",
      "Les infractions routières uniquement",
    ],
    answer: "Les crimes et délits punis d’au moins 3 ans",
    explanation: "Le cadre légal est strict.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Géolocalisation — Autorisation",
    question: "L’autorisation initiale en flagrance est donnée par :",
    options: [
      "Le maire",
      "Le procureur de la République",
      "Le juge d’instruction",
    ],
    answer: "Le procureur de la République",
    explanation: "Il peut autoriser pour 8 ou 15 jours selon l’infraction.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Géolocalisation — Renouvellement",
    question: "Le renouvellement de la géolocalisation est décidé par :",
    options: ["L’OPJ", "Le JLD", "La victime"],
    answer: "Le JLD",
    explanation: "Le contrôle judiciaire du JLD est obligatoire.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Manœuvrer",
    question: "La réquisition à manœuvrer peut viser :",
    options: ["Un serrurier", "Un avocat", "Un magistrat"],
    answer: "Un serrurier",
    explanation: "Elle concerne une intervention technique indispensable.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Alcool",
    question: "Les vérifications d’alcoolémie sont obligatoires :",
    options: [
      "En cas d’accident mortel ou grave",
      "À chaque contrôle routier",
      "Uniquement si la personne l’accepte",
    ],
    answer: "En cas d’accident mortel ou grave",
    explanation: "Elles concernent aussi la victime.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Stupéfiants",
    question: "Les prélèvements stupéfiants sont possibles :",
    options: [
      "Même sans raison",
      "En cas de refus de dépistage ou accident grave",
      "Uniquement sur réquisition du maire",
    ],
    answer: "En cas de refus de dépistage ou accident grave",
    explanation: "Prévu par l’article L. 235-2 du code de la route.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Policiers requis",
    question: "Un policier requis agit :",
    options: [
      "Comme citoyen",
      "Comme auxiliaire de justice",
      "Comme magistrat",
    ],
    answer: "Comme auxiliaire de justice",
    explanation: "Il doit respecter strictement les instructions du magistrat.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Saisies — Banques",
    question:
        "La mainlevée de la saisie d’un compte bancaire est décidée par :",
    options: ["L’OPJ", "Le JLD", "La victime"],
    answer: "Le JLD",
    explanation: "Sur requête du procureur dans les 10 jours.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Plainte — Généralités",
    question: "Le dépôt de plainte a pour principal effet :",
    options: [
      "D’ouvrir une procédure administrative",
      "D’officialiser les faits auprès de l’autorité judiciaire",
      "D’entraîner automatiquement un procès",
    ],
    answer: "D’officialiser les faits auprès de l’autorité judiciaire",
    explanation:
        "La plainte permet de porter officiellement les faits à la connaissance de l’autorité judiciaire et des services d’enquête.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Plainte — En ligne",
    question: "La plainte en ligne permet notamment :",
    options: [
      "De déposer plainte pour toutes les infractions",
      "De pré-déposer plainte ou de prendre rendez-vous pour certains faits",
      "De se passer totalement d’un contact avec les forces de l’ordre",
    ],
    answer:
        "De pré-déposer plainte ou de prendre rendez-vous pour certains faits",
    explanation:
        "Le dispositif de plainte dématérialisée vise surtout certaines escroqueries et arnaques en ligne.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Plainte — Visio-plainte",
    question: "La « visio-plainte » a pour but principal :",
    options: [
      "D’éviter toute audition de la victime",
      "De permettre à la victime de déposer plainte à distance",
      "De remplacer la garde à vue",
    ],
    answer: "De permettre à la victime de déposer plainte à distance",
    explanation:
        "La visio-plainte limite les déplacements des victimes tout en garantissant la confidentialité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Victimes — Violences conjugales",
    question: "Pour les violences conjugales, les services de police :",
    options: [
      "Appliquent un traitement identique à toute autre infraction",
      "Bénéficient de circuits dédiés et d’une formation spécifique",
      "Doivent obligatoirement saisir un juge d’instruction",
    ],
    answer: "Bénéficient de circuits dédiés et d’une formation spécifique",
    explanation:
        "La politique publique impose un accueil adapté et des circuits spécifiques pour les violences conjugales.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Victimes — Droits",
    question: "La victime peut se constituer :",
    options: ["Partie civile", "Témoin assisté", "Mis en examen"],
    answer: "Partie civile",
    explanation:
        "La constitution de partie civile lui permet de demander réparation du préjudice et de participer à la procédure.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Victimes — Associations",
    question: "Les associations d’aide aux victimes peuvent :",
    options: [
      "Se substituer au procureur",
      "Accompagner la victime dans ses démarches",
      "Prendre la direction de l’enquête",
    ],
    answer: "Accompagner la victime dans ses démarches",
    explanation:
        "Elles offrent un soutien juridique, psychologique et administratif.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Constatations — Traces",
    question: "Lors des premières constatations, la priorité est :",
    options: [
      "De questionner immédiatement tous les voisins",
      "De préserver les traces et indices",
      "De déplacer les objets gênants",
    ],
    answer: "De préserver les traces et indices",
    explanation:
        "La préservation des traces conditionne la qualité de l’enquête.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Constatations — Scellés",
    question: "Un objet saisi et placé sous scellés doit :",
    options: [
      "Pouvoir être librement manipulé",
      "Être identifié et numéroté dans la procédure",
      "Être directement restitué au propriétaire",
    ],
    answer: "Être identifié et numéroté dans la procédure",
    explanation:
        "La traçabilité des scellés est une garantie essentielle pour la procédure.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Dépendances",
    question: "Les dépendances d’un domicile (cave, garage) :",
    options: [
      "Ne sont jamais considérées comme domicile",
      "Peuvent être assimilées au domicile",
      "Sont toujours des lieux publics",
    ],
    answer: "Peuvent être assimilées au domicile",
    explanation:
        "La notion de domicile est entendue largement par la jurisprudence.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Lieux diplomatiques",
    question: "Les locaux diplomatiques :",
    options: [
      "Peuvent être perquisitionnés comme n’importe quel domicile",
      "Bénéficient d’une protection renforcée liée au droit international",
      "Dépendent uniquement du code de la route",
    ],
    answer:
        "Bénéficient d’une protection renforcée liée au droit international",
    explanation:
        "Ils obéissent à des règles spécifiques et à des immunités diplomatiques.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Mineurs",
    question: "La garde à vue d’un mineur :",
    options: [
      "Obéit aux mêmes règles que pour un majeur",
      "Bénéficie de règles spécifiques adaptées à l’âge et à la vulnérabilité",
      "Est impossible en flagrance",
    ],
    answer:
        "Bénéficie de règles spécifiques adaptées à l’âge et à la vulnérabilité",
    explanation:
        "Les mineurs bénéficient d’un régime renforcé de protection en garde à vue.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Informer des droits",
    question: "L’information des droits en garde à vue doit être :",
    options: [
      "Donée à la fin de la mesure",
      "Immédiate et intelligible pour la personne",
      "Faites uniquement devant le juge",
    ],
    answer: "Immédiate et intelligible pour la personne",
    explanation:
        "La notification des droits est un préalable indispensable au déroulement de la GAV.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Interprète",
    question: "Si la personne gardée à vue ne comprend pas le français :",
    options: [
      "La GAV est impossible",
      "Un interprète doit être requis ou un document traduit utilisé",
      "Les droits ne sont pas notifiés",
    ],
    answer: "Un interprète doit être requis ou un document traduit utilisé",
    explanation:
        "La compréhension effective des droits est une exigence légale.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Médecin",
    question: "Le médecin en garde à vue examine la personne :",
    options: [
      "Pour vérifier son aptitude à rester en GAV",
      "Pour décider de la peine",
      "Pour fixer la durée de la GAV",
    ],
    answer: "Pour vérifier son aptitude à rester en GAV",
    explanation:
        "Il apprécie l’état de santé et peut formuler des recommandations.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Auditions — Avocat",
    question: "Lors d’une audition en GAV, l’avocat :",
    options: [
      "Peut poser des questions en fin d’audition",
      "Dirige l’interrogatoire",
      "Remplace l’OPJ",
    ],
    answer: "Peut poser des questions en fin d’audition",
    explanation:
        "Ses questions sont consignées si elles sont utiles à la manifestation de la vérité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Victimes — Tiers de confiance",
    question: "Lors d’une audition, une victime peut être :",
    options: [
      "Toujours entendue seule",
      "Accompagnée d’un tiers de confiance ou d’un avocat",
      "Tenue à l’écart de toute assistance",
    ],
    answer: "Accompagnée d’un tiers de confiance ou d’un avocat",
    explanation: "Cela vise à limiter la revictimisation et à la rassurer.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Victimes — Lieux adaptés",
    question: "Pour certaines victimes, l’audition peut avoir lieu :",
    options: [
      "Dans tout local disponible",
      "Dans des locaux adaptés, à huis clos et avec un nombre limité d’intervenants",
      "Uniquement dans la rue",
    ],
    answer:
        "Dans des locaux adaptés, à huis clos et avec un nombre limité d’intervenants",
    explanation:
        "Le texte prévoit des mesures pour éviter une nouvelle victimisation.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Interprète",
    question: "L’interprète requis doit :",
    options: [
      "Traduire fidèlement les échanges",
      "Adapter le contenu à sa guise",
      "Modifier les propos pour simplifier",
    ],
    answer: "Traduire fidèlement les échanges",
    explanation: "Il prête serment de traduire fidèlement les déclarations.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Refus de déférer",
    question:
        "Le refus sans motif légitime de répondre à une réquisition régulière :",
    options: [
      "Est sans conséquence",
      "Peut constituer une infraction",
      "Annule toute la procédure",
    ],
    answer: "Peut constituer une infraction",
    explanation: "L’article R. 642-1 du code pénal sanctionne ce refus.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Personne qualifiée",
    question: "Une « personne qualifiée » peut être :",
    options: ["Un expert en identification ADN", "La victime", "Le maire"],
    answer: "Un expert en identification ADN",
    explanation:
        "Il s’agit de toute personne disposant de compétences techniques ou scientifiques utiles à l’enquête.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  const QuizQuestion(
    category: "Flagrance — Cadre juridique",
    question: "Lorsque le caractère de flagrance est perdu, l’OPJ doit :",
    options: [
      "Poursuivre l’enquête comme si de rien n’était",
      "Requalifier le cadre en enquête préliminaire ou autre",
      "Mettre immédiatement fin à toute investigation",
    ],
    answer: "Requalifier le cadre en enquête préliminaire ou autre",
    explanation:
        "La flagrance ne peut être artificiellement prolongée, un autre cadre doit alors être utilisé.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Flagrance — Prolongation",
    question:
        "La prolongation de l’enquête de flagrance est justifiée lorsque :",
    options: [
      "Les actes restants sont mineurs",
      "Les investigations indispensables ne peuvent être différées sans compromettre l’enquête",
      "La victime le demande simplement",
    ],
    answer:
        "Les investigations indispensables ne peuvent être différées sans compromettre l’enquête",
    explanation:
        "C’est la seconde condition cumulative à la peine encourue supérieure ou égale à cinq ans.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Scénario",
    question:
        "De nuit, en matière de trafic de stupéfiants relevant de la criminalité organisée, l’OPJ veut perquisitionner un domicile :",
    options: [
      "Il le peut librement en flagrance",
      "Il doit obtenir une ordonnance écrite et motivée du JLD, sur réquisitions du procureur",
      "Il suffit de l’accord oral du mis en cause",
    ],
    answer:
        "Il doit obtenir une ordonnance écrite et motivée du JLD, sur réquisitions du procureur",
    explanation:
        "Les perquisitions de nuit sont strictement encadrées et soumises à autorisation judiciaire.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Cabinet d’avocat",
    question:
        "Lors d’une perquisition dans un cabinet d’avocat, si le bâtonnier n’est pas présent :",
    options: [
      "L’OPJ poursuit seul",
      "Un représentant du bâtonnier doit être présent",
      "On sollicite un voisin pour le remplacer",
    ],
    answer: "Un représentant du bâtonnier doit être présent",
    explanation:
        "La présence du bâtonnier ou de son représentant est une garantie du respect du secret professionnel.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Fouilles — Investigations corporelles",
    question:
        "Les investigations corporelles internes (recherche de corps étranger) doivent être effectuées :",
    options: [
      "Par un OPJ",
      "Par un médecin désigné à cet effet",
      "Par un infirmier de garde, sans réquisition",
    ],
    answer: "Par un médecin désigné à cet effet",
    explanation: "Elles sont prévues à l’article 63-7 alinéa 2 du CPP.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Mesures de sécurité — GAV",
    question:
        "Les mesures de sécurité (retrait d’objets, palpation de sécurité) :",
    options: [
      "Sont assimilées à des fouilles intégrales",
      "Ont un caractère administratif et non judiciaire",
      "Sont décidées par le juge d’instruction",
    ],
    answer: "Ont un caractère administratif et non judiciaire",
    explanation:
        "Elles visent à prévenir tout danger pour la personne gardée à vue ou pour autrui.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Garde à vue — Prolongation",
    question:
        "La prolongation de la garde à vue de 24 heures supplémentaires est possible si :",
    options: [
      "La personne a des antécédents",
      "La peine encourue est supérieure ou égale à un an et la prolongation reste le seul moyen d’atteindre les objectifs légaux",
      "La victime le demande",
    ],
    answer:
        "La peine encourue est supérieure ou égale à un an et la prolongation reste le seul moyen d’atteindre les objectifs légaux",
    explanation:
        "La prolongation doit être motivée et autorisée par le procureur.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Garde à vue — Nullités",
    question: "Un défaut de notification des droits en GAV peut :",
    options: [
      "Être sans conséquence",
      "Entraîner la nullité des actes subséquents",
      "Être régularisé après le procès",
    ],
    answer: "Entraîner la nullité des actes subséquents",
    explanation:
        "L’atteinte aux droits de la défense peut conduire à la nullité de la procédure.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Auditions — Suspect libre",
    question: "Le suspect libre doit être informé, avant toute audition :",
    options: [
      "Qu’il ne peut quitter les locaux",
      "Qu’il peut quitter les locaux à tout moment et être assisté d’un avocat",
      "Qu’il peut être fouillé intégralement",
    ],
    answer:
        "Qu’il peut quitter les locaux à tout moment et être assisté d’un avocat",
    explanation:
        "La loi du 27 mai 2014 consacre un véritable statut du suspect libre.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Garde à vue — Avocat",
    question:
        "En cas de difficulté à joindre l’avocat choisi par la personne gardée à vue :",
    options: [
      "L’OPJ renonce à toute assistance d’avocat",
      "L’OPJ saisit le bâtonnier pour désigner un avocat de permanence",
      "La GAV devient automatiquement nulle",
    ],
    answer: "L’OPJ saisit le bâtonnier pour désigner un avocat de permanence",
    explanation:
        "L’article 21-3 CPP prévoit la désignation d’office par le bâtonnier.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Auditions — Enregistrement",
    question:
        "En cas d’impossibilité technique d’enregistrement audiovisuel obligatoire :",
    options: [
      "L’audition est interdite",
      "L’audition peut se dérouler mais l’impossibilité doit être dûment constatée",
      "L’OPJ enregistre avec son téléphone personnel",
    ],
    answer:
        "L’audition peut se dérouler mais l’impossibilité doit être dûment constatée",
    explanation:
        "Il est nécessaire de mentionner précisément l’impossibilité dans la procédure.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Données informatiques",
    question:
        "Une réquisition informatique (art. 60-2 et 60-3 CPP) peut viser :",
    options: [
      "Les données conservées dans un système informatique",
      "Uniquement les documents papier",
      "Les procès-verbaux de police",
    ],
    answer: "Les données conservées dans un système informatique",
    explanation:
        "L’objectif est d’obtenir ces données auprès d’organismes publics ou privés.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Données de connexion",
    question: "Les réquisitions de données de connexion doivent respecter :",
    options: [
      "Un principe de proportionnalité et de motivation",
      "Une liberté totale d’accès aux données",
      "Uniquement l’avis de la victime",
    ],
    answer: "Un principe de proportionnalité et de motivation",
    explanation:
        "Les juridictions nationales et européennes rappellent l’importance du respect de la vie privée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Géolocalisation — Intrusion dans un domicile",
    question:
        "L’installation d’une balise de géolocalisation dans un domicile nécessite :",
    options: [
      "L’accord du propriétaire uniquement",
      "Une autorisation écrite et motivée du JLD",
      "Uniquement la décision de l’OPJ",
    ],
    answer: "Une autorisation écrite et motivée du JLD",
    explanation:
        "Toute intrusion dans un lieu d’habitation suppose un contrôle judiciaire renforcé.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Mesures — Recours",
    question:
        "Une personne perquisitionnée peut saisir le JLD pour contester la régularité de l’acte dans un délai :",
    options: ["De 48 heures", "D’un an", "De dix ans"],
    answer: "D’un an",
    explanation:
        "Le texte vise les personnes n’ayant pas fait l’objet de poursuites devant une juridiction.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  const QuizQuestion(
    category: "Flagrance — Jurisprudence",
    question:
        "Selon la jurisprudence, la validité de la flagrance est appréciée en fonction :",
    options: [
      "De la seule date des procès-verbaux",
      "De la réalité et de la continuité des actes d’enquête",
      "De la seule gravité de l’infraction",
    ],
    answer: "De la réalité et de la continuité des actes d’enquête",
    explanation:
        "Le simple enchaînement de PV sans actes réels ne suffit pas à maintenir la flagrance.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Jurisprudence",
    question:
        "Une condamnation fondée exclusivement sur des déclarations obtenues en méconnaissance du droit au silence :",
    options: [
      "Est possible si les faits sont graves",
      "Est exclue et peut entraîner la censure de la décision",
      "Est sans incidence sur la régularité",
    ],
    answer: "Est exclue et peut entraîner la censure de la décision",
    explanation:
        "Le non-respect du droit au silence contrevient aux garanties fondamentales de la procédure pénale.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Avocat (décalage)",
    question: "Le procureur peut décider de différer la présence de l’avocat :",
    options: [
      "Sans motif",
      "En cas de nécessité impérieuse liée au bon déroulement de l’enquête, par décision écrite et motivée",
      "Pour toutes les garde à vue pour plus de commodité",
    ],
    answer:
        "En cas de nécessité impérieuse liée au bon déroulement de l’enquête, par décision écrite et motivée",
    explanation: "Ce report reste exceptionnel et strictement encadré.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Données de connexion (CJUE/CE)",
    question:
        "En pratique, la délivrance de réquisitions portant sur des données de connexion doit intégrer :",
    options: [
      "Uniquement la volonté d’élucider l’infraction",
      "Les exigences posées par les juridictions nationales et européennes sur la conservation et l’accès aux données",
      "Les besoins budgétaires des opérateurs",
    ],
    answer:
        "Les exigences posées par les juridictions nationales et européennes sur la conservation et l’accès aux données",
    explanation:
        "La jurisprudence récente impose de fortes garanties sur l’accès aux données de connexion.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Géolocalisation — Gravité",
    question: "Le recours à la géolocalisation est regardé comme :",
    options: [
      "Une mesure anodine",
      "Une ingérence grave dans la vie privée",
      "Une simple vérification de routine",
    ],
    answer: "Une ingérence grave dans la vie privée",
    explanation:
        "D’où la nécessité d’un strict contrôle judiciaire et d’une motivation liée à la gravité des faits.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Presse",
    question:
        "En matière de presse et de secret des sources, l’OPJ ou le magistrat doivent :",
    options: [
      "Pouvoir accéder librement à toutes les données sans formalisme",
      "Respecter un formalisme écrit, motivé, et ne saisir que les éléments strictement utiles",
      "S’abstenir de toute perquisition",
    ],
    answer:
        "Respecter un formalisme écrit, motivé, et ne saisir que les éléments strictement utiles",
    explanation:
        "La liberté de la presse et le secret des sources imposent des garanties spécifiques.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Défense nationale",
    question:
        "Lorsque des lieux sont couverts par le secret de la défense nationale, les éléments classifiés saisis :",
    options: [
      "Sont librement exploités par les enquêteurs",
      "Sont mis sous scellés et confiés à la Commission du secret de la défense nationale",
      "Sont immédiatement déclassifiés par le procureur",
    ],
    answer:
        "Sont mis sous scellés et confiés à la Commission du secret de la défense nationale",
    explanation:
        "Le régime dérogatoire protège les informations sensibles pour la défense.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Autopsie — Information des proches",
    question:
        "En matière d’autopsie judiciaire, l’information de la famille du défunt :",
    options: [
      "Est systématiquement exclue",
      "Est possible sous réserve des nécessités de l’enquête",
      "Est transférée au maire",
    ],
    answer: "Est possible sous réserve des nécessités de l’enquête",
    explanation:
        "L’enquête prime, mais les proches sont informés dès que cela est compatible avec les investigations.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Saisies — Confiscation",
    question: "La saisie spéciale (ex : comptes bancaires) a pour finalité :",
    options: [
      "De sanctionner administrativement",
      "De garantir l’exécution d’une future confiscation",
      "D’indemniser immédiatement la victime",
    ],
    answer: "De garantir l’exécution d’une future confiscation",
    explanation:
        "Elle anticipe la peine de confiscation qui pourra être prononcée par la juridiction.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Traçabilité",
    question: "Le procès-verbal de fin de garde à vue doit récapituler :",
    options: [
      "Uniquement l’heure de sortie",
      "L’ensemble de la mesure : horaires, auditions, repos, fouilles, motifs",
      "Uniquement les auditions",
    ],
    answer:
        "L’ensemble de la mesure : horaires, auditions, repos, fouilles, motifs",
    explanation:
        "La traçabilité complète permet le contrôle de la régularité de la GAV.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizFlagrantDelitPageGPX extends StatefulWidget {
  static const String grade = 'gpx';
  static const String routeName = '/gpx/generalites/quiz/flagrant_delit';
  final String uid;
  final String email;

  const QuizFlagrantDelitPageGPX({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizFlagrantDelitPageGPX> createState() => _QuizFlagrantDelitPageGPXState();
}

class _QuizFlagrantDelitPageGPXState extends State<QuizFlagrantDelitPageGPX>
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
  static const _introHiddenKey = 'intro_gpx_flagrant_delit';
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
        ? questionsFlagrantDelitProcedure
        : questionsFlagrantDelitProcedure
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
            'quiz_name': 'Le flagrant délit',
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
      await _sb.from('quiz_flagrant_delit').insert({
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
      debugPrint('❌ quiz_flagrant_delit insert failed: $e');
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
      'source_file': 'gpx_quiz_flagrant_delit_page',
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
                            icon: Icons.flash_on_rounded,
                            title: 'Flagrant délit',
                            description: 'Maîtrise le régime du flagrant délit : définition, conditions, pouvoirs renforcés des enquêteurs et actes autorisés en flagrance.',
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
