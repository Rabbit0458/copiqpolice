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
final List<QuizQuestion> questionsNullite = [
  const QuizQuestion(
    category: "Généralités — Nullité",
    question:
        "Quel est l’objectif principal de la nullité des actes de procédure pénale ?",
    options: [
      "Punir les enquêteurs en cas d’erreur",
      "Garantir les droits fondamentaux et la régularité de la procédure",
      "Protéger uniquement les victimes d’infractions",
    ],
    answer: "Garantir les droits fondamentaux et la régularité de la procédure",
    explanation:
        "La nullité vise à contrôler la légalité des actes de procédure pour protéger les libertés individuelles et les droits de la défense tout en assurant une procédure régulière.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Nullité",
    question:
        "Que devient un procès-verbal qui a constaté une détention illégale lorsqu’il est annulé ?",
    options: [
      "Il reste au dossier mais sans valeur probante",
      "Il est retiré de la procédure et ses effets juridiques disparaissent",
      "Il est seulement corrigé par le procureur de la République",
    ],
    answer:
        "Il est retiré de la procédure et ses effets juridiques disparaissent",
    explanation:
        "L’annulation détruit les effets juridiques de l’acte procédural irrégulier ainsi que des actes qui en découlent.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Nullité",
    question:
        "Combien de grandes catégories de nullités distingue-t-on classiquement en procédure pénale française ?",
    options: [
      "Deux : nullités textuelles et nullités substantielles",
      "Trois : nullités civiles, pénales et administratives",
      "Une seule : la nullité d’ordre public",
    ],
    answer: "Deux : nullités textuelles et nullités substantielles",
    explanation:
        "On distingue les nullités textuelles, prévues par un texte, et les nullités substantielles, liées à la violation d’une formalité essentielle.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Nullité",
    question:
        "Selon l’Article 802 du Code de Procédure Pénale, quand la nullité peut-elle être prononcée ?",
    options: [
      "Dès qu’une irrégularité est constatée",
      "Uniquement si l’irrégularité a porté atteinte aux intérêts de la partie concernée",
      "Uniquement sur demande de la personne mise en examen",
    ],
    answer:
        "Uniquement si l’irrégularité a porté atteinte aux intérêts de la partie concernée",
    explanation:
        "L’Article 802 du Code de Procédure Pénale impose que l’irrégularité ait causé un préjudice aux intérêts de la partie pour que la nullité soit prononcée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Généralités — Nullité",
    question: "La nullité d’un acte de procédure pénale entraîne en principe :",
    options: [
      "La remise en cause automatique de la culpabilité",
      "La disparition des effets juridiques de l’acte et des actes qui en découlent",
      "La suspension de la procédure pendant un an",
    ],
    answer:
        "La disparition des effets juridiques de l’acte et des actes qui en découlent",
    explanation:
        "L’annulation efface l’acte vicié de la procédure et empêche qu’il serve de fondement à d’autres actes.",
    difficulty: "Facile",
  ),

  // ==========================================================
  //                  NULLITÉS TEXTUELLES — PRINCIPES
  // ==========================================================
  const QuizQuestion(
    category: "Nullités textuelles — Principe",
    question:
        "Qu’est-ce qui caractérise une nullité textuelle en procédure pénale ?",
    options: [
      "Elle est laissée à l’appréciation souveraine du juge",
      "Elle est expressément prévue par un texte qui mentionne la nullité",
      "Elle s’applique uniquement en matière criminelle",
    ],
    answer:
        "Elle est expressément prévue par un texte qui mentionne la nullité",
    explanation:
        "Les nullités textuelles supposent qu’une disposition indique que la formalité est requise à peine de nullité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Nullités textuelles — Répartition",
    question:
        "Où se trouvent les nullités textuelles dans le Code de Procédure Pénale ?",
    options: [
      "Dans un chapitre unique consacré aux nullités",
      "Elles sont regroupées à la fin du Code de Procédure Pénale",
      "Elles sont mentionnées à la suite de chaque disposition concernée",
    ],
    answer: "Elles sont mentionnées à la suite de chaque disposition concernée",
    explanation:
        "Les nullités textuelles sont dispersées dans le Code de Procédure Pénale et indiquées article par article.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  //          NULLITÉS TEXTUELLES — PERQUISITIONS / SAISIES
  // ==========================================================
  const QuizQuestion(
    category: "Perquisitions — Nullité textuelle",
    question:
        "Quel article prévoit que les formalités des Articles 56, 56-1, 57 et 59 du Code de Procédure Pénale sont prescrites à peine de nullité ?",
    options: [
      "Article 76 du Code de Procédure Pénale",
      "Article 59 du Code de Procédure Pénale",
      "Article 802 du Code de Procédure Pénale",
    ],
    answer: "Article 59 du Code de Procédure Pénale",
    explanation:
        "L’Article 59 alinéa 2 du Code de Procédure Pénale pose la nullité en cas de non-respect des formalités prévues pour certaines perquisitions.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Présence de la personne",
    question:
        "En principe, une perquisition au domicile doit se dérouler en présence :",
    options: [
      "Uniquement de l’officier de police judiciaire",
      "De la personne chez qui elle a lieu ou d’un représentant choisi ou, à défaut, de deux témoins",
      "Uniquement du procureur de la République",
    ],
    answer:
        "De la personne chez qui elle a lieu ou d’un représentant choisi ou, à défaut, de deux témoins",
    explanation:
        "L’Article 59 du Code de Procédure Pénale impose ces garanties à peine de nullité pour protéger les droits de la personne.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Heures légales",
    question:
        "Le non-respect des heures légales d’une perquisition (hors exceptions légales) peut entraîner :",
    options: [
      "Une simple remarque dans le dossier",
      "Une nullité textuelle de la perquisition",
      "Uniquement une sanction disciplinaire de l’enquêteur",
    ],
    answer: "Une nullité textuelle de la perquisition",
    explanation:
        "Les perquisitions doivent respecter les heures légales, sauf exceptions prévues par la loi, sous peine de nullité.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Cabinet d’avocat",
    question:
        "En cabinet d’avocat, quelle condition est requise à peine de nullité pour la perquisition ?",
    options: [
      "La présence d’un huissier de justice",
      "La présence du bâtonnier ou de son délégué et une décision écrite et motivée du juge des libertés et de la détention",
      "La simple autorisation orale du procureur de la République",
    ],
    answer:
        "La présence du bâtonnier ou de son délégué et une décision écrite et motivée du juge des libertés et de la détention",
    explanation:
        "L’Article 56-1 du Code de Procédure Pénale impose ces garanties spécifiques pour les perquisitions en cabinet ou au domicile d’un avocat.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Enquête préliminaire",
    question:
        "En enquête préliminaire, une perquisition sans l’assentiment de la personne est possible à condition :",
    options: [
      "Qu’il s’agisse d’une contravention",
      "Qu’un délit puni d’au moins trois ans d’emprisonnement ou la recherche de biens confisquables le justifie avec autorisation du juge des libertés et de la détention",
      "Qu’un officier de police judiciaire en décide librement",
    ],
    answer:
        "Qu’un délit puni d’au moins trois ans d’emprisonnement ou la recherche de biens confisquables le justifie avec autorisation du juge des libertés et de la détention",
    explanation:
        "L’Article 76 alinéa 4 du Code de Procédure Pénale encadre strictement cette possibilité, à peine de nullité.",
    difficulty: "Difficile",
  ),

  // ==========================================================
  //          NULLITÉS TEXTUELLES — RÉQUISITIONS / PRESSE
  // ==========================================================
  const QuizQuestion(
    category: "Réquisitions — Nullité textuelle",
    question:
        "Selon les Articles 60-1 et 77-1-1 du Code de Procédure Pénale, à peine de nullité, quels éléments ne peuvent pas être versés au dossier ?",
    options: [
      "Les éléments obtenus par réquisition portant atteinte au secret des sources des journalistes",
      "Les réquisitions téléphoniques effectuées de nuit",
      "Les réquisitions adressées à un fournisseur d’accès étranger",
    ],
    answer:
        "Les éléments obtenus par réquisition portant atteinte au secret des sources des journalistes",
    explanation:
        "Les réquisitions contraires à l’Article 2 de la loi du 29 juillet 1881 sur la liberté de la presse entraînent la nullité des éléments obtenus.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  //   NULLITÉS TEXTUELLES — INTERCEPTIONS / CORRESPONDANCES
  // ==========================================================
  const QuizQuestion(
    category: "Interceptions — Information préalable",
    question:
        "En matière d’interception de correspondances, à peine de nullité, le juge d’instruction doit notamment informer :",
    options: [
      "Uniquement le procureur de la République",
      "Le président de l’Assemblée nationale ou du Sénat si la personne est parlementaire, le bâtonnier pour un avocat, et les chefs de cour pour un magistrat",
      "Seulement la personne surveillée",
    ],
    answer:
        "Le président de l’Assemblée nationale ou du Sénat si la personne est parlementaire, le bâtonnier pour un avocat, et les chefs de cour pour un magistrat",
    explanation:
        "L’Article 100-7 du Code de Procédure Pénale impose ces informations préalables pour garantir les immunités et protections des professions visées.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Interceptions — Avocat / secret professionnel",
    question:
        "À peine de nullité, que prévoit l’Article 100-5 du Code de Procédure Pénale pour les correspondances avec un avocat ?",
    options: [
      "Elles peuvent toujours être transcrites si l’infraction est grave",
      "Elles ne peuvent être transcrites lorsqu’elles relèvent de l’exercice des droits de la défense et sont couvertes par le secret professionnel",
      "Elles doivent obligatoirement être transmises au bâtonnier",
    ],
    answer:
        "Elles ne peuvent être transcrites lorsqu’elles relèvent de l’exercice des droits de la défense et sont couvertes par le secret professionnel",
    explanation:
        "L’Article 100-5 protège le secret professionnel de la défense et exclut la transcription de telles correspondances, sauf exceptions prévues par la loi.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Journalistes",
    question:
        "Que prévoit l’Article 100-5 du Code de Procédure Pénale concernant les correspondances avec un journaliste ?",
    options: [
      "Elles sont toujours transcrites pour les besoins de l’enquête",
      "Elles ne peuvent être transcrites si elles permettent d’identifier une source, sous peine de nullité",
      "Elles doivent être transmises au Conseil supérieur de l’audiovisuel",
    ],
    answer:
        "Elles ne peuvent être transcrites si elles permettent d’identifier une source, sous peine de nullité",
    explanation:
        "Le secret des sources des journalistes est protégé par la loi du 29 juillet 1881, ce qui entraîne la nullité en cas de violation.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  //        NULLITÉS TEXTUELLES — INFILTRATION / EXORBITANTS
  // ==========================================================
  const QuizQuestion(
    category: "Infiltration — Nullité textuelle",
    question:
        "À peine de nullité, que ne doit pas faire un agent infiltré lors d’une opération d’infiltration ?",
    options: [
      "Participer à une infraction déjà préparée",
      "Contribuer à la poursuite d’une infraction déjà débutée",
      "Inciter à commettre une infraction",
    ],
    answer: "Inciter à commettre une infraction",
    explanation:
        "L’Article 706-81 du Code de Procédure Pénale interdit que l’agent infiltré provoque lui-même l’infraction. Il ne doit pas être à l’origine de la décision de commettre l’infraction.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Infiltration — Autorisation",
    question:
        "Selon l’Article 706-83 du Code de Procédure Pénale, à peine de nullité, l’autorisation d’infiltration doit être :",
    options: [
      "Orale et notée plus tard dans le dossier",
      "Écrite, spécialement motivée et mentionner les infractions, l’identité de l’officier de police judiciaire coordonnateur et la durée de l’opération",
      "Signée uniquement par le préfet",
    ],
    answer:
        "Écrite, spécialement motivée et mentionner les infractions, l’identité de l’officier de police judiciaire coordonnateur et la durée de l’opération",
    explanation:
        "L’autorisation est strictement encadrée à peine de nullité afin de limiter les risques d’abus dans l’usage de l’infiltration.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Moyens exorbitants — Stupéfiants",
    question:
        "En matière de trafic de stupéfiants, que permet l’Article 706-32 du Code de Procédure Pénale aux officiers de police judiciaire et agents de police judiciaire ?",
    options: [
      "D’effectuer toute saisie sans contrôle judiciaire",
      "D’acquérir des stupéfiants et de fournir des moyens matériels, avec autorisation du magistrat, à peine de nullité",
      "De placer librement des écoutes téléphoniques",
    ],
    answer:
        "D’acquérir des stupéfiants et de fournir des moyens matériels, avec autorisation du magistrat, à peine de nullité",
    explanation:
        "L’Article 706-32 encadre ces actes pour lutter contre le trafic de stupéfiants et le blanchiment, sous le contrôle du procureur de la République ou du juge d’instruction.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Enquête sous pseudonyme",
    question:
        "Selon l’Article 230-46 du Code de Procédure Pénale, dans quel but l’enquête sous pseudonyme est-elle autorisée ?",
    options: [
      "Constater des crimes et délits commis par la voie des communications électroniques",
      "Surveiller les simples contraventions routières",
      "Remplacer les enquêtes classiques en toutes matières",
    ],
    answer:
        "Constater des crimes et délits commis par la voie des communications électroniques",
    explanation:
        "Ce dispositif est réservé aux infractions commises via des moyens de communication électroniques, sous conditions strictes.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Enquête sous pseudonyme — Nullité",
    question:
        "À peine de nullité, que doit faire le magistrat lorsqu’il autorise les actes 3° et 4° de l’Article 230-46 du Code de Procédure Pénale (acquisition, mise à disposition de moyens) ?",
    options: [
      "Informer les médias",
      "Motiver oralement la décision devant le mis en cause",
      "Mentionner ou verser son autorisation au dossier de procédure",
    ],
    answer: "Mentionner ou verser son autorisation au dossier de procédure",
    explanation:
        "L’autorisation peut être donnée par tout moyen mais doit être rattachée au dossier, à peine de nullité, notamment pour le contrôle de proportionnalité.",
    difficulty: "Difficile",
  ),

  // ==========================================================
  //         NULLITÉS TEXTUELLES — VÉRIFICATION D’IDENTITÉ
  // ==========================================================
  const QuizQuestion(
    category: "Vérification d’identité — Nullité",
    question:
        "Quelle durée maximale de rétention est prévue pour une vérification d’identité (hors régimes spécifiques) ?",
    options: [
      "Deux heures",
      "Quatre heures",
      "Huit heures pour tout le territoire",
    ],
    answer: "Quatre heures",
    explanation:
        "L’Article 78-3 du Code de Procédure Pénale fixe ce délai à quatre heures, sauf régimes particuliers comme à Mayotte et en Guyane.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vérification d’identité — Mineurs",
    question:
        "À peine de nullité, que doit-on faire pour un mineur retenu lors d’une vérification d’identité ?",
    options: [
      "Le garder seul pour préserver sa tranquillité",
      "Aviser immédiatement le procureur de la République et faire assister le mineur par son représentant légal",
      "Appeler uniquement les services sociaux",
    ],
    answer:
        "Aviser immédiatement le procureur de la République et faire assister le mineur par son représentant légal",
    explanation:
        "L’Article 78-3 impose des garanties renforcées pour les mineurs, sous peine de nullité.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification d’identité — Procès-verbal",
    question:
        "À peine de nullité, que doit contenir le procès-verbal de vérification d’identité ?",
    options: [
      "Uniquement l’identité de l’agent",
      "L’ensemble des opérations et diligences effectuées",
      "Uniquement la signature du mis en cause",
    ],
    answer: "L’ensemble des opérations et diligences effectuées",
    explanation:
        "Le procès-verbal doit retracer toutes les diligences afin de permettre le contrôle de la régularité de la mesure.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  //                  NULLITÉS SUBSTANTIELLES
  // ==========================================================
  const QuizQuestion(
    category: "Nullités substantielles — Définition",
    question:
        "Selon l’Article 171 du Code de Procédure Pénale, quand y a-t-il nullité substantielle ?",
    options: [
      "Lorsque la loi prévoit expressément la nullité",
      "Lorsque la méconnaissance d’une formalité substantielle a porté atteinte aux intérêts de la partie concernée",
      "Uniquement lorsque le procureur de la République le demande",
    ],
    answer:
        "Lorsque la méconnaissance d’une formalité substantielle a porté atteinte aux intérêts de la partie concernée",
    explanation:
        "L’Article 171 du Code de Procédure Pénale définit la nullité substantielle par référence à une formalité essentielle violée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Nullités substantielles — Garde à vue",
    question:
        "L’absence de notification du droit à être assisté par un avocat en garde à vue constitue :",
    options: [
      "Une simple irrégularité sans conséquence",
      "Une nullité substantielle portant gravement atteinte aux droits de la défense",
      "Une simple faute disciplinaire de l’officier de police judiciaire",
    ],
    answer:
        "Une nullité substantielle portant gravement atteinte aux droits de la défense",
    explanation:
        "Le droit à l’avocat est une garantie fondamentale. Sa violation justifie l’annulation des actes de garde à vue.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Nullités substantielles — Commission rogatoire",
    question:
        "En commission rogatoire, que doit faire l’officier de police judiciaire lorsqu’apparaissent des indices graves et concordants contre une personne entendue comme témoin ?",
    options: [
      "Poursuivre l’audition comme si de rien n’était",
      "Le placer immédiatement en garde à vue ou demander au juge d’instruction de le mettre en examen",
      "Arrêter tous les actes de procédure pour 24 heures",
    ],
    answer:
        "Le placer immédiatement en garde à vue ou demander au juge d’instruction de le mettre en examen",
    explanation:
        "L’Article 105 du Code de Procédure Pénale protège les droits de la défense. Poursuivre une audition comme témoin malgré de tels indices expose à une nullité substantielle.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Nullités substantielles — Bande organisée",
    question:
        "Que rappelle la décision du Conseil constitutionnel du 2 mars 2004 concernant l’usage de la procédure de criminalité organisée ?",
    options: [
      "Qu’elle peut être utilisée librement par les enquêteurs",
      "Qu’elle ne peut être utilisée que s’il existe des raisons plausibles de soupçonner une infraction relevant de la liste de l’Article 706-73 du Code de Procédure Pénale",
      "Qu’elle est obligatoire pour tous les délits",
    ],
    answer:
        "Qu’elle ne peut être utilisée que s’il existe des raisons plausibles de soupçonner une infraction relevant de la liste de l’Article 706-73 du Code de Procédure Pénale",
    explanation:
        "La décision du 2 mars 2004 censurait une validation automatique des procédures de criminalité organisée lorsqu’en réalité la bande organisée n’était pas caractérisée.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Nullités substantielles — Enregistrement des mineurs",
    question:
        "Que se passe-t-il lorsque l’audition d’un mineur placé en garde à vue n’est pas enregistrée et que les modalités prévues ne sont pas respectées ?",
    options: [
      "C’est une irrégularité sans conséquence",
      "C’est une cause de nullité selon la jurisprudence de la Cour de cassation",
      "L’audition est simplement réitérée",
    ],
    answer:
        "C’est une cause de nullité selon la jurisprudence de la Cour de cassation",
    explanation:
        "La Cour de cassation, notamment dans un arrêt du 26 mars 2008, a considéré que le non-respect des modalités d’enregistrement est une cause de nullité.",
    difficulty: "Difficile",
  ),

  // ==========================================================
  //           NULLITÉS D’ORDRE PRIVÉ / D’ORDRE PUBLIC
  // ==========================================================
  const QuizQuestion(
    category: "Nullités — Ordre privé",
    question:
        "Selon l’Article 802 du Code de Procédure Pénale, les nullités fondées sur la violation des formes prescrites à peine de nullité concernent :",
    options: [
      "Les intérêts privés des parties",
      "Uniquement l’intérêt général",
      "Uniquement la victime",
    ],
    answer: "Les intérêts privés des parties",
    explanation:
        "L’Article 802 du Code de Procédure Pénale conditionne la nullité à l’atteinte aux intérêts de la partie concernée pour les nullités d’ordre privé.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Nullités — Ordre public",
    question:
        "Qu’est-ce qui caractérise une nullité d’ordre public par rapport à une nullité d’ordre privé ?",
    options: [
      "Elle est toujours demandée par la défense",
      "Elle vise à protéger des règles fondamentales du système répressif et l’intérêt général",
      "Elle ne peut jamais être relevée d’office par le juge",
    ],
    answer:
        "Elle vise à protéger des règles fondamentales du système répressif et l’intérêt général",
    explanation:
        "Les nullités d’ordre public protègent les principes essentiels, comme l’organisation des juridictions ou l’interdiction de certaines missions techniques.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Nullités — Ordre public (exemples)",
    question:
        "La délivrance d’une mission technique ayant le caractère d’une expertise à un officier de police judiciaire par commission rogatoire est :",
    options: [
      "Régulière si le juge l’ordonne",
      "Prohibée et peut constituer une nullité d’ordre public",
      "Valable uniquement en matière de stupéfiants",
    ],
    answer: "Prohibée et peut constituer une nullité d’ordre public",
    explanation:
        "L’expertise doit être confiée à un expert, non à un officier de police judiciaire, pour respecter la séparation des fonctions.",
    difficulty: "Difficile",
  ),

  // ==========================================================
  //        ACTION EN NULLITÉ — INFORMATION JUDICIAIRE
  // ==========================================================
  const QuizQuestion(
    category: "Action en nullité — Compétence",
    question:
        "En cas d’information judiciaire, quelle juridiction est compétente pour apprécier les nullités d’actes d’instruction ?",
    options: [
      "Le tribunal correctionnel",
      "La chambre de l’instruction",
      "Le juge des libertés et de la détention",
    ],
    answer: "La chambre de l’instruction",
    explanation:
        "L’Article 170 du Code de Procédure Pénale attribue cette compétence à la chambre de l’instruction.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Action en nullité — Juge d’instruction",
    question:
        "Lorsque le juge d’instruction constate qu’un acte est frappé de nullité, que doit-il faire ?",
    options: [
      "Le corriger lui-même dans le dossier",
      "Saisir la chambre de l’instruction après avis du procureur de la République et information des parties",
      "Attendre les réquisitions du procureur général",
    ],
    answer:
        "Saisir la chambre de l’instruction après avis du procureur de la République et information des parties",
    explanation:
        "L’Article 173 alinéa 1 du Code de Procédure Pénale encadre cette saisine par le juge d’instruction.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Action en nullité — Procureur de la République",
    question:
        "Comment le procureur de la République peut-il provoquer l’examen d’une nullité par la chambre de l’instruction ?",
    options: [
      "En adressant une simple note interne au juge d’instruction",
      "En requérant communication de la procédure pour la transmettre à la chambre de l’instruction et en présentant une requête aux fins d’annulation",
      "En saisissant directement la Cour de cassation",
    ],
    answer:
        "En requérant communication de la procédure pour la transmettre à la chambre de l’instruction et en présentant une requête aux fins d’annulation",
    explanation:
        "L’Article 173 alinéa 2 du Code de Procédure Pénale prévoit ce mode de saisine par le ministère public.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Action en nullité — Parties",
    question:
        "À quelles conditions une partie peut-elle saisir la chambre de l’instruction d’une requête en nullité ?",
    options: [
      "Par un simple appel téléphonique au greffe",
      "Par requête motivée, avec copie adressée au juge d’instruction et déclaration au greffe de la chambre",
      "Par un courrier anonyme",
    ],
    answer:
        "Par requête motivée, avec copie adressée au juge d’instruction et déclaration au greffe de la chambre",
    explanation:
        "L’Article 173 alinéa 3 du Code de Procédure Pénale impose ces formalités, à peine d’irrecevabilité de la requête.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Action en nullité — Témoin assisté",
    question: "Le témoin assisté peut-il former une requête en nullité ?",
    options: [
      "Non, seul la personne mise en examen le peut",
      "Oui, dans les mêmes formes que les parties",
      "Uniquement devant la Cour de cassation",
    ],
    answer: "Oui, dans les mêmes formes que les parties",
    explanation:
        "L’Article 173 alinéa 3 du Code de Procédure Pénale étend expressément ce droit au témoin assisté.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  //         ACTION EN NULLITÉ — RÔLE DU PRÉSIDENT / DÉLAIS
  // ==========================================================
  const QuizQuestion(
    category: "Action en nullité — Président chambre",
    question:
        "Dans quel délai le président de la chambre de l’instruction peut-il constater l’irrecevabilité d’une requête en nullité après réception du dossier ?",
    options: ["Dans les 24 heures", "Dans les 8 jours", "Dans les 2 mois"],
    answer: "Dans les 8 jours",
    explanation:
        "L’Article 173 alinéa 5 du Code de Procédure Pénale fixe ce délai pour l’ordonnance du président constatant l’irrecevabilité.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Action en nullité — Irrecevabilité",
    question: "La requête en nullité est irrecevable notamment lorsque :",
    options: [
      "Elle est déposée par la victime",
      "Elle n’a pas fait l’objet d’une déclaration au greffe ou qu’elle porte sur un acte susceptible d’appel",
      "Elle est rédigée par un avocat",
    ],
    answer:
        "Elle n’a pas fait l’objet d’une déclaration au greffe ou qu’elle porte sur un acte susceptible d’appel",
    explanation:
        "Les cas d’irrecevabilité sont listés à l’Article 173 et suivants, dont l’absence de déclaration au greffe ou la contestation d’actes susceptibles d’appel.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Action en nullité — Délais de six mois",
    question:
        "Que prévoit l’Article 173-1 du Code de Procédure Pénale concernant certaines requêtes en nullité ?",
    options: [
      "Qu’elles peuvent être déposées à tout moment de la procédure",
      "Qu’elles sont irrecevables si elles sont présentées plus de six mois après la mise en examen pour des actes accomplis avant l’interrogatoire de première comparution",
      "Qu’elles doivent être déposées uniquement après le renvoi devant la juridiction de jugement",
    ],
    answer:
        "Qu’elles sont irrecevables si elles sont présentées plus de six mois après la mise en examen pour des actes accomplis avant l’interrogatoire de première comparution",
    explanation:
        "L’Article 173-1 du Code de Procédure Pénale limite dans le temps la contestation de certains actes antérieurs.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Action en nullité — Détention provisoire",
    question:
        "Lorsque la détention provisoire se poursuit au-delà de trois mois sans avis de fin d’information, que peut faire la chambre de l’instruction ?",
    options: [
      "Se saisir pour examiner l’ensemble de la procédure, notamment des requêtes en nullité",
      "Libérer automatiquement le mis en examen",
      "Transférer le dossier au tribunal de police",
    ],
    answer:
        "Se saisir pour examiner l’ensemble de la procédure, notamment des requêtes en nullité",
    explanation:
        "L’Article 221-3 du Code de Procédure Pénale permet cette saisine afin d’examiner la régularité de la procédure.",
    difficulty: "Difficile",
  ),

  // ==========================================================
  //         COMPÉTENCE HORS INFORMATION — ART. 385 CPP
  // ==========================================================
  const QuizQuestion(
    category: "Compétence — Tribunal correctionnel",
    question:
        "En matière délictuelle, lorsque les faits ne font pas l’objet d’une information judiciaire, qui est compétent pour constater les nullités de procédure ?",
    options: [
      "Le tribunal correctionnel",
      "La chambre de l’instruction",
      "La Cour de cassation",
    ],
    answer: "Le tribunal correctionnel",
    explanation:
        "L’Article 385 du Code de Procédure Pénale donne compétence au tribunal correctionnel lorsque la saisine se fait par citation directe ou comparution immédiate.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Compétence — Tribunal de police",
    question:
        "En matière contraventionnelle, qui est compétent pour statuer sur les nullités de procédure ?",
    options: [
      "Le tribunal de police, selon l’Article 522 du Code de Procédure Pénale",
      "La chambre de l’instruction",
      "Le conseil municipal",
    ],
    answer:
        "Le tribunal de police, selon l’Article 522 du Code de Procédure Pénale",
    explanation:
        "L’Article 522 du Code de Procédure Pénale confie au tribunal de police la compétence pour apprécier les nullités en matière contraventionnelle.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Compétence — Exception de nullité",
    question:
        "Selon l’Article 385 du Code de Procédure Pénale, à quel moment les exceptions de nullité doivent-elles être soulevées devant le tribunal correctionnel ?",
    options: [
      "À tout moment, y compris après le jugement",
      "Avant toute défense au fond",
      "Uniquement en appel",
    ],
    answer: "Avant toute défense au fond",
    explanation:
        "Les exceptions de nullité doivent être soulevées avant toute défense au fond, à défaut elles sont irrecevables.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  //                  EFFETS DE LA NULLITÉ — PROCÉDURE
  // ==========================================================
  const QuizQuestion(
    category: "Effets de la nullité — Procédure",
    question:
        "Selon l’Article 174 du Code de Procédure Pénale, que peut décider la chambre de l’instruction lorsqu’elle prononce une nullité ?",
    options: [
      "Uniquement l’annulation de l’acte précis contesté",
      "Limiter l’annulation à certains actes ou l’étendre à la procédure ultérieure",
      "Annuler automatiquement toute la procédure pénale",
    ],
    answer:
        "Limiter l’annulation à certains actes ou l’étendre à la procédure ultérieure",
    explanation:
        "L’Article 174 du Code de Procédure Pénale laisse à la chambre de l’instruction le soin d’apprécier l’étendue des effets de la nullité.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Effets de la nullité — Dossier d’information",
    question: "Que devient un acte annulé au regard du dossier d’information ?",
    options: [
      "Il reste au dossier mais avec une mention spéciale",
      "Il est retiré du dossier et classé au greffe de la cour d’appel, sans qu’il soit possible d’y puiser des renseignements contre les parties",
      "Il est détruit matériellement",
    ],
    answer:
        "Il est retiré du dossier et classé au greffe de la cour d’appel, sans qu’il soit possible d’y puiser des renseignements contre les parties",
    explanation:
        "L’Article 174 alinéa 3 du Code de Procédure Pénale prévoit ce régime renforcé pour éviter toute utilisation indirecte de l’acte annulé.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Effets de la nullité — Canceller",
    question:
        "Que signifie le fait qu’un acte soit “cancellé” dans le cadre d’une annulation partielle ?",
    options: [
      "L’acte est entièrement supprimé du dossier",
      "Les passages annulés sont rayés ou bâtonnés pour être rendus illisibles, après copie certifiée conforme au greffe",
      "L’acte est réécrit par le juge d’instruction",
    ],
    answer:
        "Les passages annulés sont rayés ou bâtonnés pour être rendus illisibles, après copie certifiée conforme au greffe",
    explanation:
        "Le cancellage permet de maintenir une trace archivistique sans permettre l’exploitation des mentions annulées.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  //                  EFFETS DE LA NULLITÉ — PARTIES
  // ==========================================================
  const QuizQuestion(
    category: "Effets de la nullité — Purge successive",
    question:
        "Que signifie l’expression “purge successive des nullités” utilisée à propos de la saisine de la chambre de l’instruction ?",
    options: [
      "Les nullités disparaissent automatiquement avec le temps",
      "Chaque saisine permet de traiter les nullités connues à ce stade, sans empêcher les parties ultérieures d’invoquer des nullités qu’elles ne pouvaient pas connaître",
      "La chambre de l’instruction efface définitivement tout moyen de nullité",
    ],
    answer:
        "Chaque saisine permet de traiter les nullités connues à ce stade, sans empêcher les parties ultérieures d’invoquer des nullités qu’elles ne pouvaient pas connaître",
    explanation:
        "Ce mécanisme, décrit notamment par la circulaire du 1er mars 1993, évite la remise en cause infinie de la procédure tout en protégeant les nouveaux intervenants.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Effets de la nullité — Débats devant la chambre",
    question:
        "Après la clôture des débats devant la chambre de l’instruction, que se passe-t-il pour les nullités dont les parties avaient connaissance ?",
    options: [
      "Elles peuvent être soulevées à tout moment devant la Cour de cassation",
      "Elles ne peuvent plus être soulevées par ces parties",
      "Elles doivent être renvoyées devant le tribunal correctionnel",
    ],
    answer: "Elles ne peuvent plus être soulevées par ces parties",
    explanation:
        "Les nullités connues et non soulevées sont réputées abandonnées après la clôture des débats, sauf pour les parties devenues intervenantes après la saisine.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Effets de la nullité — Article 595 CPP",
    question:
        "Que prévoit l’Article 595 du Code de Procédure Pénale pour la recevabilité des moyens de nullité devant la Cour de cassation ?",
    options: [
      "Qu’ils peuvent être soulevés directement devant la Cour sans avoir été invoqués devant la chambre de l’instruction",
      "Qu’ils doivent avoir été préalablement proposés devant la chambre de l’instruction pour être recevables",
      "Qu’ils ne peuvent être soulevés que par le procureur général",
    ],
    answer:
        "Qu’ils doivent avoir été préalablement proposés devant la chambre de l’instruction pour être recevables",
    explanation:
        "Ce mécanisme vise à éviter les manœuvres dilatoires et les saisines répétées des juridictions supérieures.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizNullitePagePA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName = '/pa/procedure_penale/quiz/nullite';
  final String uid;
  final String email;

  const QuizNullitePagePA({super.key, required this.uid, required this.email});

  @override
  State<QuizNullitePagePA> createState() => _QuizNullitePagePAState();
}

class _QuizNullitePagePAState extends State<QuizNullitePagePA>
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
  static const _introHiddenKey = 'intro_pa_nullite';
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
        ? questionsNullite
        : questionsNullite
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
            'quiz_name': 'Nullité',
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

  /// Garde de réentrance des sorties : deux dialogues de confirmation ne peuvent
  /// pas se superposer (croix tapée deux fois, ou croix pendant un geste retour).
  bool _sortieEnCours = false;

  /// Ferme le quiz après confirmation. Chemin unique de la croix et, quand il
  /// existe, du geste retour système — sans quoi celui-ci contournerait la
  /// confirmation.
  Future<void> _fermerQuiz() async {
    if (_sortieEnCours) return;
    _sortieEnCours = true;
    try {
      // Rien n'est engagé avant le choix du niveau : on sort sans demander.
      if (!_hasQuiz) {
        if (mounted) _quitterEcran();
        return;
      }
      final confirme = await _confirmerSortie(
        titre: 'Quitter le quiz ?',
        actionLabel: 'Quitter',
      );
      if (!confirme || !mounted) return;
      await _updateHistoryOnFinish();
      if (!mounted) return;
      _quitterEcran();
    } finally {
      _sortieEnCours = false;
    }
  }

  /// Sortie effective de l'écran.
  ///
  /// **`pop()` et non `maybePop()`.** `maybePop` consulte les `PopScope` de la
  /// route avant de dépiler : sous un `PopScope` qui bloque la sortie pendant un
  /// quiz, il se ferait refuser et rappellerait la confirmation en boucle — gel
  /// de l'interface. `pop()` dépile directement, ce qui est exactement ce qu'on
  /// veut une fois la décision confirmée.
  void _quitterEcran() {
    final nav = Navigator.of(context);
    if (nav.canPop()) nav.pop();
  }

  /// Dialogue commun à « Mettre fin » et à la fermeture.
  Future<bool> _confirmerSortie({
    required String titre,
    required String actionLabel,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // On reprend la mise en scène de la carte de résultat — flou d'arrière-plan,
    // fondu, léger agrandissement — au lieu de l'`AlertDialog` par défaut.
    final reponse = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirmation',
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (ctx, __, ___) => Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: const SizedBox.expand(),
            ),
          ),
          Center(
            child: _ConfirmCard(
              isDark: isDark,
              titre: titre,
              message: 'Tes réponses déjà validées sont enregistrées, et ton '
                  'score sera calculé sur cette base.',
              actionLabel: actionLabel,
              onConfirmer: () => Navigator.of(ctx).pop(true),
              onAnnuler: () => Navigator.of(ctx).pop(false),
            ),
          ),
        ],
      ),
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
        child: ScaleTransition(
          scale: Tween(begin: .96, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOutBack))
              .animate(anim),
          child: child,
        ),
      ),
    );
    return reponse ?? false;
  }

  Future<void> _endQuizNow() async {
    if (!_hasQuiz) return;

    final confirme = await _confirmerSortie(
      titre: 'Mettre fin au quiz ?',
      actionLabel: 'Mettre fin',
    );
    if (!confirme || !mounted) return;

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
      await _sb.from('quiz_nullite').insert({
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
      debugPrint('❌ quiz_nullite insert failed: $e');
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
    HapticFeedback.selectionClick();
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
      'source_file': 'pa_quiz_nullite_page',
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
        final bg = isDark ? const Color(0xFF000B36) : _Brand.bgLight;
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
            child: Stack(
              children: [
                Positioned.fill(child: _QuizBackdrop(isDark: isDark)),
                Scaffold(
              backgroundColor: Colors.transparent,
              extendBody: true,
              extendBodyBehindAppBar: _showSplash,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.close_rounded, color: textCol),
                  onPressed: _fermerQuiz,
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
                  builder: (context, _) {

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Masquée à la source plutôt que recouverte : on ne
                        // construit pas une interface pour la dissimuler.
                          if (!_showSplash)
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

                                  // La réserve ajoutait jusqu'à 240 px de vide sous la carte pour
// loger la croix flottante. Le feedback vivant désormais dans le
// bandeau, seule la barre de boutons est à compenser.
final double bottomInsetForThisPage = bottomBarReserved;

                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      8,
                                      20,
                                      0,
                                    ),
                                    child: KeyedSubtree(
                                      key: ValueKey('page_$i'),
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
                                        estActive: i == _index,
                                        pulse: _pulseCtrl,
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

                        // L'overlay de feedback a été retiré : il se superposait au bandeau
                          // d'explication dès que l'énoncé était long. L'animation vit
                          // maintenant dans `_OutcomeIcon`, bornée par le bandeau.

                        if (_showIntro)
                          _IntroSplash(
                            isDark: isDark,
                            hideForever: _hideIntroForever,
                            onChangedHideForever: _saveIntroPreference,
                            onStart: () async { await _doStartQuiz(); },
                            icon: Icons.cancel_rounded,
                            title: 'Nullités',
                            description: 'Comprends le régime des nullités de procédure : nullités textuelles et substantielles, conditions, effets et moyens de les invoquer.',
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
              ],
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
                  // Ferme la carte de résultat, puis l'écran. `pop()` et non
                  // `maybePop()` : sous un `PopScope`, `maybePop` relancerait
                  // la confirmation de sortie en boucle.
                  Navigator.of(context).pop();
                  _quitterEcran();
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
          'Question ${index + 1} / $totalSafe',
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
          backgroundColor: _opa(_Brand.bad, .10),
          foregroundColor: isEnabled ? _Brand.bad : _opa(_Brand.bad, .35),
          side: BorderSide(
            color: _opa(isEnabled ? _Brand.bad : _opa(_Brand.bad, .35), .55),
            width: 1.4,
          ),
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

class _QuestionCard extends StatefulWidget {
  final QuizQuestion question;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;
  final bool locked;
  final bool showOutcome;
  final bool isCorrect;

  /// Marge basse à ajouter dans le scroll pour éviter toute coupe
  /// `true` quand cette page est celle que l'utilisateur regarde.
  ///
  /// Indispensable : `PageView.builder` construit aussi les pages voisines
  /// à l'avance. Sans ce garde-fou, la cascade de la question suivante se
  /// jouerait hors écran et serait déjà terminée à l'arrivée.
  final bool estActive;

  /// Contrôleur du feedback, relancé à chaque validation par `_validate`.
  final AnimationController pulse;

  final double bottomSafeInset;

  const _QuestionCard({
    required this.question,
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.locked,
    required this.showOutcome,
    required this.isCorrect,
    required this.estActive,
    required this.pulse,
    this.bottomSafeInset = 0,
  });

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard>
    with SingleTickerProviderStateMixin {
  // ─── Cascade d'apparition ────────────────────────────────────────────────
  //
  // Un seul `AnimationController` pilote la séquence ; chaque élément lit une
  // fenêtre différente de sa progression via un `Interval`. L'alternative — un
  // contrôleur et un `Timer` par élément — multiplierait les tickers par le
  // nombre d'options, sur chaque page vivante du `PageView`.
  static const int _msElement = 420;
  static const int _msDecalage = 130;

  int get _nbElements => 1 + (_afficheSousTitre ? 1 : 0) + widget.options.length;

  /// Le sous-titre compte comme un élément de la séquence quand il est affiché.
  bool get _afficheSousTitre => (widget.question.sub?.trim().isNotEmpty ?? false);

  int get _msTotal => _msDecalage * (_nbElements - 1) + _msElement;

  late final AnimationController _cascade = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _msTotal),
  );

  /// Contrôleur de la colonne, pour amener le bandeau de correction dans le champ
  /// de vision : sur un énoncé long, l'explication naissait sous le pli.
  final ScrollController _colonne = ScrollController();

  /// Ancre posée sur le bandeau, cible du défilement.
  final GlobalKey _ancreBandeau = GlobalKey();

  bool get _mouvementReduit => WidgetsBinding
      .instance
      .platformDispatcher
      .accessibilityFeatures
      .disableAnimations;

  @override
  void initState() {
    super.initState();
    // Accessibilité : on saute à l'état final, jamais à un état invisible.
    if (_mouvementReduit) {
      _cascade.value = 1;
    } else if (widget.estActive) {
      _cascade.forward();
    }
  }

  @override
  void didUpdateWidget(_QuestionCard old) {
    super.didUpdateWidget(old);

    final duree = Duration(milliseconds: _msTotal);
    if (_cascade.duration != duree) _cascade.duration = duree;

    if (_mouvementReduit) {
      _cascade.value = 1;
      return;
    }

    // La page vient de devenir celle qu'on regarde : la cascade démarre en même
    // temps que le glissement du `PageView`, `_index` étant mis à jour avant
    // l'appel à `nextPage`.
    if (!old.estActive && widget.estActive) {
      _cascade
        ..reset()
        ..forward();
    }

    if (!old.showOutcome && widget.showOutcome && widget.estActive) {
      _revelerBandeau();
    }
  }

  @override
  void dispose() {
    _cascade.dispose();
    _colonne.dispose();
    super.dispose();
  }

  void _revelerBandeau() {
    // Après la frame qui insère le bandeau : avant, sa position n'existe pas.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _ancreBandeau.currentContext;
      if (ctx == null || !_colonne.hasClients) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        // 0.9 plutôt que 1.0 : le bandeau se cale vers le bas de la zone visible
        // en gardant les options au-dessus dans le champ.
        alignment: 0.9,
      );
    });
  }

  /// Fenêtre d'animation du n-ième élément de la séquence.
  Animation<double> _fenetre(int rang) {
    final total = _msTotal;
    final debut = (_msDecalage * rang) / total;
    final fin = (_msDecalage * rang + _msElement) / total;
    return CurvedAnimation(
      parent: _cascade,
      curve: Interval(
        debut.clamp(0.0, 1.0),
        fin.clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  /// Énoncé nettoyé de l'énumération des options.
  ///
  /// Beaucoup de questions répètent les réponses dans leur libellé, puis les
  /// mêmes options s'affichent juste en dessous : le titre double de hauteur et
  /// la question perd sa force. La coupe est conservatrice — il faut un `:` suivi
  /// de texte, **toutes** les options retrouvées après lui, une partie conservée
  /// d'au moins 15 caractères, et aucune option de moins de 4 caractères, qui se
  /// retrouverait par hasard dans n'importe quelle phrase.
  String get _enonceAffiche {
    final brut = widget.question.question.trim();
    final coupe = brut.lastIndexOf(':');
    if (coupe <= 0 || coupe >= brut.length - 1) return brut;

    final avant = brut.substring(0, coupe).trim();
    final apres = brut.substring(coupe + 1).toLowerCase();
    if (avant.length < 15) return brut;

    for (final o in widget.options) {
      final option = o.trim();
      if (option.length < 4) return brut;
      if (!apres.contains(option.toLowerCase())) return brut;
    }
    return avant.endsWith('?') ? avant : '$avant ?';
  }

  /// Taille du titre, réduite par palier quand l'énoncé s'allonge : à 28 px fixes
  /// et avec un réglage de texte système élevé, les options passaient sous le pli.
  double _tailleTitre(String enonce) {
    if (enonce.length > 150) return 21;
    if (enonce.length > 110) return 23;
    if (enonce.length > 75) return 25;
    return 28;
  }

  @override
  Widget build(BuildContext context) {
    // Rang dans la cascade : le titre ouvre, le sous-titre suit s'il
    // existe, puis les options dans l'ordre d'affichage.
    var rangCascade = 0;
    final enonce = _enonceAffiche;
    final textCol = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : _Brand.textDark;

    return SingleChildScrollView(
      controller: _colonne,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: 8,
        // marge bas normale + réserve (animation + bouton)
        bottom: 12 + widget.bottomSafeInset,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ElementCascade(
            animation: _fenetre(rangCascade++),
            child: Text(
            enonce,
            style: _Brand.h1(context).copyWith(
              color: textCol,
              fontSize: _tailleTitre(enonce),
            ),
          ),
          ),
          if (widget.question.sub != null) ...[
            const SizedBox(height: 6),
            _ElementCascade(
              animation: _fenetre(rangCascade++),
              child: Text(
              widget.question.sub!,
              style: TextStyle(
                color: textCol.withAlpha(180),
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
            ),
          ],
          const SizedBox(height: 16),

          // Options
          ...widget.options.map((o) {
            final isSel = widget.selected == o;
            final correctShown = widget.showOutcome && o == widget.question.answer;
            final wrongShown = widget.showOutcome && isSel && o != widget.question.answer;

            return _ElementCascade(
              animation: _fenetre(rangCascade++),
              child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OptionTile(
                label: o,
                selected: isSel,
                locked: widget.locked,
                correct: correctShown,
                wrong: wrongShown,
                onTap: () => widget.onSelect(o),
              ),
            ),
            );
          }),

          // Explication
          AnimatedSwitcher(
            key: _ancreBandeau,
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            layoutBuilder: (currentChild, previousChildren) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (currentChild != null) currentChild,
                ...previousChildren,
              ],
            ),
            child: widget.showOutcome
                ? _OutcomeCard(
                    key: ValueKey<bool>(widget.isCorrect),
                    good: widget.isCorrect,
                    explanation: widget.question.explanation,
                    pulse: widget.pulse,
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

  /// Animation du feedback, partagée avec la page : elle doit partir au
  /// moment exact de la validation, pas à la construction du bandeau.
  final AnimationController pulse;
  const _OutcomeCard({
    super.key,
    required this.good,
    required this.explanation,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    final color = good ? _Brand.good : _Brand.bad;
    final icon = good ? Icons.check_circle_rounded : Icons.cancel_rounded;

    // Dimensionnement adaptatif, sur deux axes : la largeur d'écran — 28 px
    // fixes paraissaient gros sur un petit téléphone et perdus sur une tablette
    // — et le réglage de taille de texte du système, l'icône devant grandir avec
    // l'explication qu'elle accompagne.
    final largeur = MediaQuery.sizeOf(context).width;
    final scaler = MediaQuery.textScalerOf(context);
    final double tailleIcone = scaler
        .scale((largeur / 13.5).clamp(24.0, 34.0))
        .clamp(24.0, 52.0);

    // Zone carrée un peu plus large que l'icône : les étincelles s'y déploient
    // sans empiéter sur le texte, puisqu'elles sont bornées ici et non posées en
    // overlay au-dessus de la page.
    final zone = tailleIcone * 1.7;

    // Alignement optique : l'icône est centrée dans `zone`, son centre est donc
    // à `zone / 2`. La première ligne du texte s'y cale, moins sa demi-hauteur.
    const double tailleTexte = 14.0;
    const double hauteurLigne = 1.32;
    final double demiLigne = scaler.scale(tailleTexte) * hauteurLigne / 2;
    final double decalageTexte = (zone / 2 - demiLigne).clamp(0.0, 24.0);

    // Une seule boîte peinte : bord et fond partagent la même `BoxDecoration`,
    // et la marge est passée à l'extérieur du widget bordé.
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _opa(color, .10),
          // 22 comme les options : le bandeau est collé sous la dernière, à
          // largeur identique — une rupture de rayon se verrait.
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _opa(color, .55), width: 1.2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: zone,
              height: zone,
              child: _OutcomeIcon(
                controller: pulse,
                icon: icon,
                color: color,
                tailleIcone: tailleIcone,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: decalageTexte),
                child: Text(
                  explanation,
                  softWrap: true,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : _Brand.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: tailleTexte,
                    height: hauteurLigne,
                    decoration: TextDecoration.none,
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

// `_FeedbackStrip` et `_FeedbackSparkles` supprimés : l'animation de résultat
// vit désormais dans `_OutcomeIcon`, à l'intérieur du bandeau d'explication.
// `_Star` est conservé, il sert aux étincelles.


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
    with SingleTickerProviderStateMixin {
  // ─── Cascade d'ouverture ─────────────────────────────────────────────────
  //
  // Même mécanique et même widget (`_ElementCascade`) que l'arrivée d'une
  // question : un seul contrôleur, chaque élément lisant une fenêtre différente
  // de sa progression via un `Interval`. Les deux écrans partagent donc le même
  // geste — fondu plus montée de 10 px.
  //
  // Rangs explicites plutôt qu'un compteur incrémenté pendant le build : le
  // `LayoutBuilder` des cartes peut être rappelé à chaque relayout, et un
  // compteur mutable y dériverait à chaque passe.
  static const int _msElement = 380;
  static const int _msDecalage = 90;
  static const int _rangTitre = 0;
  static const int _rangSousTitre = 1;
  static const int _rangFacile = 2;
  static const int _rangMoyen = 3;
  static const int _rangDifficile = 4;
  static const int _rangCommencer = 5;
  static const int _rangMelanger = 6;
  static const int _nbElements = 7;

  late final AnimationController _entree = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: _msDecalage * (_nbElements - 1) + _msElement,
    ),
  );

  @override
  void initState() {
    super.initState();
    final reduit = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    // On saute à l'état final, jamais à un écran vide.
    if (reduit) {
      _entree.value = 1;
    } else {
      _entree.forward();
    }
  }

  @override
  void dispose() {
    _entree.dispose();
    super.dispose();
  }

  Animation<double> _fenetre(int rang) {
    const total = _msDecalage * (_nbElements - 1) + _msElement;
    final debut = (_msDecalage * rang) / total;
    final fin = (_msDecalage * rang + _msElement) / total;
    return CurvedAnimation(
      parent: _entree,
      curve: Interval(
        debut.clamp(0.0, 1.0),
        fin.clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
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
            // Aucun fond propre : le splash laisse voir le `_QuizBackdrop` de la
            // page. Il empilait auparavant son dégradé et ses halos par-dessus
            // celui du quiz — deux systèmes d'animation superposés, et une
            // rupture de teinte au démarrage. Un voile suffit à détacher le
            // contenu du fond.
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: isDark ? .28 : .04),
                ),
              ),
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
                        _ElementCascade(
                          animation: _fenetre(_rangTitre),
                          child: Text(
                          'Sélectionne le niveau de difficulté',
                          textAlign: TextAlign.center,
                          style: _Brand.h1(
                            context,
                          ).copyWith(color: textMain, fontSize: 24),
                        ),
                        ),
                        const SizedBox(height: 8),
                        _ElementCascade(
                          animation: _fenetre(_rangSousTitre),
                          child: Text(
                          'Nouvelles questions à chaque partie.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: sub,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                            decoration: TextDecoration.none,
                          ),
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
                              _ElementCascade(
                                animation: _fenetre(_rangFacile),
                                child: _LevelCard(
                                label: 'Facile',
                                icon: Icons.eco_rounded,
                                tint: const Color(0xFF22C55E),
                                active: widget.selected == 'Facile',
                                onTap: () => widget.onSelect('Facile'),
                                isDark: isDark,
                              ),
                              ),
                              _LevelCard(
                                label: 'Moyenne',
                                icon: Icons.military_tech_rounded,
                                tint: const Color(0xFFF59E0B),
                                active: widget.selected == 'Moyenne',
                                onTap: () => widget.onSelect('Moyenne'),
                                isDark: isDark,
                              ),
                              _ElementCascade(
                                animation: _fenetre(_rangDifficile),
                                child: _LevelCard(
                                label: 'Difficile',
                                icon: Icons.emoji_events_rounded,
                                tint: const Color(0xFFEF4444),
                                active: widget.selected == 'Difficile',
                                onTap: () => widget.onSelect('Difficile'),
                                isDark: isDark,
                              ),
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
                                  const SizedBox(height: spacing),
                                  children[1],
                                  const SizedBox(height: spacing),
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
                            child: Text(
                              widget.selected == null
                                  ? 'Choisis un niveau'
                                  : 'Commencer',
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Bouton Aléatoire (mix 3 niveaux)
                        _ElementCascade(
                          animation: _fenetre(_rangMelanger),
                          child: SizedBox(
                          height: 56,
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: widget.onStartRandom,
                            icon: const Icon(Icons.shuffle_rounded, size: 20),
                            label: const Text('Mélanger les 3 niveaux'),
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
                                borderRadius: BorderRadius.circular(28),
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

// `_AnimatedBackground` supprimé : dégradé propre au splash, remplacé par le
// `_QuizBackdrop` de la page. Un seul fond pour tout l'écran.


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
  /// Icône du niveau. Remplace un emoji, dont le dessin dépend de la police
  /// système et dont la couleur n'est pas contrôlable.
  final IconData icon;
  final Color tint;
  final bool active;
  final bool isDark;
  final VoidCallback onTap;

  const _LevelCard({
    required this.label,
    required this.icon,
    required this.tint,
    required this.active,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final track = _Brand.radioTrack(context);

    // Carte fixe. Le `AnimatedBuilder` + `Transform.translate` qui la
    // faisait osciller de ±2 px a été retiré : sur trois cartes à
    // comparer, ce balancement désalignait les bords en permanence.
    return AnimatedScale(
            duration: const Duration(milliseconds: 180),
            scale: active ? 1.02 : 1.0,
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
                  color: _opa(tint, isDark
                      ? (active ? .22 : .13)
                      : (active ? .18 : .10)),
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
                        color: _opa(tint, isDark ? .22 : .18),
                        border: Border.all(
                          color: active ? tint : _opa(tint, .45),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 24,
                          color: isDark ? tint : _assombrir(tint, .22),
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


/// Assombrit une teinte pour qu'elle reste lisible sur fond clair.
///
/// Les teintes de niveau sont vives (#22C55E, #F59E0B, #EF4444) : parfaites sur
/// fond sombre, trop claires en thème clair. On les rabat vers le noir plutôt
/// que d'entretenir une seconde palette en parallèle.
Color _assombrir(Color c, [double facteur = .45]) =>
    Color.lerp(c, Colors.black, facteur)!;


/// Fond du quiz, dans les deux thèmes.
///
/// Remplace un aplat (noir pur ou gris #2C2C2E) par la matière du module Cas
/// pratiques : dégradé navy, halo de lumière derrière la question, masses
/// colorées dérivantes, vignette. Le thème clair a la même construction en
/// lumineux — ce n'est pas un fond au rabais.
///
/// Trois précautions, ce fond vivant sous un `PageView` :
///  * `RepaintBoundary` isole la couche du reste de l'écran ;
///  * un seul contrôleur de 26 s pour les trois halos ;
///  * aucun flou, coûteux sur mobile d'entrée de gamme — les halos sont des
///    `RadialGradient`, déjà diffus.
class _QuizBackdrop extends StatefulWidget {
  const _QuizBackdrop({required this.isDark});
  final bool isDark;
  @override
  State<_QuizBackdrop> createState() => _QuizBackdropState();
}

class _QuizBackdropState extends State<_QuizBackdrop>
    with SingleTickerProviderStateMixin {
  static const Color _navyTop = Color(0xFF000B36);
  static const Color _navyMid = Color(0xFF000A33);
  static const Color _navyBot = Color(0xFF00082D);

  static const Color _clairTop = Color(0xFFF8FAFF);
  static const Color _clairMid = Color(0xFFEFF3FD);
  static const Color _clairBot = Color(0xFFE6ECFB);

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 26),
  );

  @override
  void initState() {
    super.initState();
    final reduit = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    if (!reduit) _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sombre = widget.isDark;
    final degrade = sombre
        ? const [_navyTop, _navyMid, _navyBot]
        : const [_clairTop, _clairMid, _clairBot];
    // Un halo blanc serait invisible sur un fond clair : la lumière vient alors
    // du bleu brand, en très faible densité.
    final halo = sombre ? Colors.white : _Brand.accent;
    final haloFort = sombre ? 0.10 : 0.07;
    final haloFaible = sombre ? 0.035 : 0.025;
    // Du noir salirait le thème clair : on referme au bleu dilué.
    final vignette = sombre
        ? Colors.black.withValues(alpha: 0.42)
        : _Brand.accent.withValues(alpha: 0.10);

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: degrade,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.72),
                radius: 1.15,
                colors: [
                  halo.withValues(alpha: haloFort),
                  halo.withValues(alpha: haloFaible),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
          _Halo(
            color: _Brand.accent,
            size: 300,
            dx: -130,
            dy: -180,
            ctrl: _ctrl,
            strength: sombre ? 0.16 : 0.09,
          ),
          _Halo(
            color: const Color(0xFF1A55E6),
            size: 260,
            dx: 140,
            dy: 200,
            ctrl: _ctrl,
            strength: sombre ? 0.14 : 0.08,
          ),
          _Halo(
            color: _Brand.good,
            size: 200,
            dx: 30,
            dy: 420,
            ctrl: _ctrl,
            strength: sombre ? 0.08 : 0.05,
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.15),
                  radius: 1.10,
                  colors: [Colors.transparent, vignette],
                  stops: const [0.55, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// Un élément d'une cascade d'apparition : fondu et montée de 10 px.
///
/// `FadeTransition` gère l'opacité sans rien reconstruire, et l'enfant est passé
/// à `AnimatedBuilder` via `child:` — seul le `Transform` est rebâti à chaque
/// frame, jamais le contenu.
///
/// Le décalage est en pixels et non en fraction de hauteur (ce que ferait un
/// `SlideTransition`) : un titre et une option n'ont pas la même hauteur, et une
/// fraction commune donnerait des amplitudes différentes.
class _ElementCascade extends StatelessWidget {
  const _ElementCascade({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  static const double _monteeDepart = 10.0;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (_, enfant) => Transform.translate(
          offset: Offset(0, _monteeDepart * (1 - animation.value)),
          child: enfant,
        ),
      ),
    );
  }
}


/// Icône de résultat animée : rebond à l'apparition, puis étincelles qui
/// s'écartent et s'effacent.
///
/// Remplace une croix flottante de 240 px posée en overlay au-dessus de la page,
/// qui chevauchait l'explication dès que l'énoncé était long. Bornée par le
/// `SizedBox` du bandeau, elle ne peut plus rien recouvrir.
class _OutcomeIcon extends StatelessWidget {
  const _OutcomeIcon({
    required this.controller,
    required this.icon,
    required this.color,
    required this.tailleIcone,
  });

  final AnimationController controller;
  final IconData icon;
  final Color color;
  final double tailleIcone;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final t = controller.value.clamp(0.0, 1.0);

          const n = 6;
          final rayonMax = tailleIcone * 0.72;
          final etincelles = <Widget>[];

          // Une fois l'animation finie, on ne peint plus que l'icône : aucune
          // couche inutile ne subsiste dans l'arbre de rendu.
          if (t < 0.999) {
            for (var i = 0; i < n; i++) {
              final angle = (i / n) * 2 * math.pi;
              final r = rayonMax * t;
              etincelles.add(
                Transform.translate(
                  offset: Offset(r * math.cos(angle), r * math.sin(angle)),
                  child: Transform.scale(
                    scale: 0.3 + t * 0.7,
                    child: Opacity(
                      opacity: (1 - t).clamp(0.0, 1.0),
                      child: _Star(color: color, size: tailleIcone * 0.22),
                    ),
                  ),
                ),
              );
            }
          }

          // `Curves.elasticOut` serait trop remuant à côté d'un texte qu'on veut
          // lire : un simple dépassement suffit.
          final echelle = 0.7 + Curves.easeOutBack.transform(t) * 0.3;

          return Stack(
            alignment: Alignment.center,
            children: [
              ...etincelles,
              Transform.scale(
                scale: echelle,
                child: Icon(icon, color: color, size: tailleIcone),
              ),
            ],
          );
        },
      ),
    );
  }
}


/// Carte de confirmation avant une sortie de quiz.
///
/// Sert la croix comme le bouton « Mettre fin » : même mise en page, seuls le
/// titre et le libellé de l'action changent. Remplace un `AlertDialog` Material,
/// qui détonnait avec le reste de l'écran.
///
/// Hiérarchie assumée — l'action sûre est en bas, pleine et dans l'accent de
/// l'app : la plus atteignable au pouce et la plus visible. L'action destructive
/// est au-dessus, en contour rouge : identifiable, jamais tentante.
class _ConfirmCard extends StatelessWidget {
  const _ConfirmCard({
    required this.isDark,
    required this.titre,
    required this.message,
    required this.actionLabel,
    required this.onConfirmer,
    required this.onAnnuler,
  });

  final bool isDark;
  final String titre;
  final String message;
  final String actionLabel;
  final VoidCallback onConfirmer;
  final VoidCallback onAnnuler;

  @override
  Widget build(BuildContext context) {
    final fond = isDark ? const Color(0xFF11131A) : Colors.white;
    final texte = isDark ? Colors.white : _Brand.textDark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
            decoration: BoxDecoration(
              color: fond,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark ? _opa(Colors.white, .10) : _opa(Colors.black, .06),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? .45 : .12),
                  blurRadius: 34,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pastille d'avertissement : donne un point d'entrée au regard et
                // annonce la nature de l'action avant même la lecture.
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _opa(_Brand.bad, .12),
                    border: Border.all(color: _opa(_Brand.bad, .30)),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: _Brand.bad,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  titre,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: texte,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    height: 1.2,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: _opa(texte, .70),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.45,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: onConfirmer,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _opa(_Brand.bad, .10),
                      foregroundColor: _Brand.bad,
                      side: BorderSide(color: _opa(_Brand.bad, .55), width: 1.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    child: Text(actionLabel),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: onAnnuler,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: _Brand.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    child: const Text('Continuer le quiz'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
